package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * 贷款展期798005
 * 注意展期成功后把本笔合同置终结
 * @author zrli
 * @二○○九年十二月三日
 *
 */
public class MFTrade798005 implements MFTradeInterface {
	public String runMFTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "798005";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		MFMessageBuilder mb = new MFMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="",RelativeAccountNo="",Maturity="";
		ASResultSet rs,rs1=null;
		double dBalance = 0.0,dContractSum=0.0,dPutOutTotalSum=0.0;
		String sIsPigeonholeFlag = "",sContractSerialNo = "";
		try {
			sSql = "select RelativeAccountNo,Maturity,ContractSum,ContractSerialNo from BUSINESS_PUTOUT Where SerialNo = '"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				RelativeAccountNo = rs.getString("RelativeAccountNo");
				Maturity = rs.getString("Maturity");
				dContractSum=rs.getDouble("ContractSum");
				sContractSerialNo = rs.getString("ContractSerialNo");
			}
			rs.close();
			
			// 从配置文件中读取数据,组成报文头
			sm.write(mb.setValue("WholeLength"));
			sm.write(mb.setValue("MessageType"));
			sm.write(mb.setValue("TradeCode",sTradeID));
			sm.write(mb.setValue("TradeDate",sTradeDate));
			sm.write(mb.setValue("SysDate",sTradeDate));
			sm.write(mb.setValue("TradeTime",StringFunction.getNow().replace(":", ".")));
			sm.write(mb.setValue("OrgID"));//取默认业务机构号
			sm.write(mb.setValue("TerminiterID"));
			sm.write(mb.setValue("UserID"));//取默认信贷员编号
			sm.write(mb.setValue("TradeFlag"));
			sm.write(mb.setValue("TradeSerialNo"));
			sm.write(mb.setValue("Flag1"));
			sm.write(mb.setValue("Flag2"));
			sm.write(mb.setValue("Flag3"));
			sm.write(mb.setValue("Flag4"));
			sm.write(mb.setValue("ConfirmUserID"));
			//以上为报文头部分，以下为报文体部分
			sm.write(mb.setValue("BPSerialNo",sObjectNo));//sObjectNo
			sm.write(mb.setValue("BDSerialNo",RelativeAccountNo));//sObjectNo
			sm.write(mb.setValue("ExtendMaturity",Maturity.replace("/", "-")));//sObjectNo
			//////////////取对应合同是否放完//////////////////////
			sSql="  select SUM(BusinessSum) as PutOutTotalSum from BUSINESS_PUTOUT where ContractSerialNo='"+sContractSerialNo+"'";
			rs1=Sqlca.getResultSet(sSql);
			if(rs1.next()){
				dPutOutTotalSum=rs1.getDouble("PutOutTotalSum");
			}
			rs1.close();
			if(dPutOutTotalSum>=dContractSum)
			{
				sIsPigeonholeFlag="True";
			}					
			//报文体部分填充完毕
			sm.flush();
			mb.logger.debug("sOldTemp=" + mb.sOldTemp);
			mb.logger.debug("sNewTemp=" + mb.sNewTemp);
			mb.logger.debug("iLeng=" + mb.iLeng);
			mb.logger.info("["+sTradeID+"]发送成功！");
			// 读取返回包长
			byte[] pckbuf = new byte[4];
			sm.read(pckbuf);
			String s = new String(pckbuf, mb.CONV_CODESET);
			mb.logger.debug("Rcv_Head=" + s);
			int pcklen = Integer.parseInt(s);
			// 读取返回包
			byte[] revbuf = new byte[pcklen];
			sm.readFully(revbuf);
			mb.logger.info("["+sTradeID+"]返回数据=" + new String(revbuf, mb.CONV_CODESET));
			// 初始化xml对象
			mb.initRcv(revbuf, pcklen);
			mb.logger.debug("["+sTradeID+"]交易标志TradeType（1成功，3失败）=" + mb.getValue("TradeType"));	
			if(mb.getValue("TradeType").equals("3")){
				String sOutMsgID=mb.getValue("OutMsgID").substring(2,9);
				String sOutMsg="";
				rs1=Sqlca.getASResultSet("select MsgBdy from MF_ErrCode where CodeNo='" + sOutMsgID+ "'");
				if(rs1.next())
					sOutMsg = rs1.getString(1);
				sReturn=sOutMsgID+"@"+sOutMsg;
				rs1.close();
				mb.logger.debug("["+sTradeID+"]错误代码OutMsgID=" + mb.getValue("OutMsgID") + " 错误信息="+sOutMsg);
			}else if(mb.getValue("TradeType").equals("1")){
				sReturn="0000000@";
				Sqlca.executeSQL("Update BUSINESS_PUTOUT set SendFlag='1' where SerialNo='"+sObjectNo+"'");
				//如果为非循环合同就直接合同归档。
				if("True".equals(sIsPigeonholeFlag))
				{
					Sqlca.executeSQL("Update BUSINESS_CONTRACT set PigeonholeDate='"+StringFunction.getToday()+"' where SerialNo='"+sContractSerialNo+"' and (CycleFlag is null or CycleFlag = '' or CycleFlag ='2')");
				}
			}else
				sReturn="9999999@["+sTradeID+"]交易失败，可能是网络通讯原因！";
			// 短连接时要 关闭连接，长连接时不关闭
			sm.teardownConnection();
		} catch (Exception e) {
			sReturn="9999999@["+sTradeID+"]交易失败，可能是网络通讯原因！请联系系统管理员！";
			e.printStackTrace();
			sm.teardownConnection();
		}
			
		return sReturn;
	}
}
