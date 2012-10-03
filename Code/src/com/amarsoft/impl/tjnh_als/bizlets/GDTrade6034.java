package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * 公积金变更出账取消(6034)
 * @author wangdw
 * @date 2012-09-10
 *
 */
public class GDTrade6034 implements GDTradeInterface {
	public String runGDTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "6034";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		GDMessageBuilder mb = new GDMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="",sOutMsgID="";
		String sOrgID="";
		String sContractSerialNo="",sUserID="";
		ASResultSet rs,rs1=null;
		
		sSql="select BP.SerialNo,BP.ContractSerialNo,BP.COMMERCIALNO,BP.ACCUMULATIONNO," +
				"GetMFUserID(BP.InputUserID) as InputUserID,GetMFOrgID(BP.InputOrgID) as InputOrgID ,BP.ChangType" +
		" from BUSINESS_PUTOUT BP,BUSINESS_CONTRACT BC " +
		" where BP.SerialNo='"+sObjectNo+"' and BP.ContractSerialNo=BC.SerialNo";
		try{	
			rs=Sqlca.getResultSet(sSql);
			if(rs.next()){
				////////////////机构号//////////////////
				sOrgID = rs.getString("InputOrgID");
				sUserID = rs.getString("InputUserID");
				sContractSerialNo = rs.getString("ContractSerialNo");
			//-----------------组合报文----------------------
			try {
				// 从配置文件中读取数据,组成报文头
				sm.write(mb.setValue("WholeLength"));
				sm.write(mb.setValue("MessageType"));
				sm.write(mb.setValue("TradeCode",sTradeID));
				sm.write(mb.setValue("TradeDate",sTradeDate));
				sm.write(mb.setValue("SysDate",sTradeDate));
				sm.write(mb.setValue("TradeTime",StringFunction.getNow()));
				sm.write(mb.setValue("OrgID","909020000"));//取默认业务机构号
				sm.write(mb.setValue("TerminiterID"));
				sm.write(mb.setValue("UserID","908908"));//取默认信贷员编号
				sm.write(mb.setValue("TradeFlag"));
				sm.write(mb.setValue("TradeSerialNo",sObjectNo));//交易流水号
				sm.write(mb.setValue("Flag1"));
				sm.write(mb.setValue("Flag2"));
				sm.write(mb.setValue("Flag3"));
				sm.write(mb.setValue("Flag4"));
				sm.write(mb.setValue("ConfirmUserID","908908"));
				//以上为报文头部分，以下为报文体部分
				sm.write(mb.setValue("BPSerialNo",sObjectNo));//信贷系统出账流水号
				sm.write(mb.setValue("BCSerialNo",sContractSerialNo));//信贷系统合同流水号
				sm.write(mb.setValue("CommercialNo",rs.getString("COMMERCIALNO")));//商贷号
				sm.write(mb.setValue("AccumulationNo",rs.getString("ACCUMULATIONNO")));//委贷号
				sm.write(mb.setValue("ChangType",rs.getString("ChangType")));		   //变更类型
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
					sOutMsgID=mb.getValue("OutMsgID");
					String sOutMsg="";
					rs1=Sqlca.getASResultSet("select MsgBdy from GD_ErrCode where CodeNo='" + sOutMsgID+ "'");
					if(rs1.next())
						sOutMsg = rs1.getString(1);
					sReturn=sOutMsgID+"@"+sOutMsg;
					rs1.close();
					mb.logger.debug("["+sTradeID+"]错误代码OutMsgID=" + mb.getValue("OutMsgID") + " 错误信息="+sOutMsg);

					//如果个贷返回错误信息为“个贷已取消”那么也认为取消成功
					if(sOutMsgID.equals("5024")||sOutMsgID.equals("5023")){
						Sqlca.executeSQL("update  business_contract set pigeonholedate =null where serialno='"+sContractSerialNo+"' ");
						//置发送标示为空
						Sqlca.executeSQL("update  business_putout set SendFlag ='9' where serialno='"+sObjectNo+"' ");
						sReturn="0000000@";
					}
				}else if(mb.getValue("TradeType").equals("1")){
					mb.logger.debug("["+sTradeID+"]交易成功");
					sReturn="0000000@";
					//成功后更新合同归档日期
					Sqlca.executeSQL("update  business_contract set pigeonholedate =null where serialno='"+sContractSerialNo+"' ");
					//置发送标示为空
					Sqlca.executeSQL("update  business_putout set SendFlag ='9' where serialno='"+sObjectNo+"' ");
					
				}else
					sReturn="9999999@["+sTradeID+"]交易失败，可能是网络通讯原因！";
				// 短连接时要 关闭连接，长连接时不关闭
				sm.teardownConnection();
			} catch (Exception e) {
				sReturn="9999999@["+sTradeID+"]交易失败，可能是网络通讯原因！请联系系统管理员！";
				e.printStackTrace();
				sm.teardownConnection();
			}
			}
			rs.close();
		}catch(Exception ex){
			ex.printStackTrace();
			mb.logger.error(sSql+"["+sTradeID+"]执行出错!");
		}
		return sReturn;
	}
}
