package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * 提前还款取消(6029)
 * @author xhyong
 * @date 2011-07-28
 *
 */
public class GDTrade6029 implements GDTradeInterface {
	public String runGDTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "6029";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		GDMessageBuilder mb = new GDMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="",sOutMsgID="";
		String sOrgID="";
		String sUserID="";
		String sCommercialNo = "";
		String sAccumulationNo = "";
		ASResultSet rs,rs1=null;

		try{	
			
			sSql = " select commercialno,businesstype,accumulationno from business_contract where serialno = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sCommercialNo = rs.getString("commercialno");//商贷贷款号
				if(sCommercialNo==null)sCommercialNo="";
				sAccumulationNo = rs.getString("accumulationno");//委贷贷款号
				if(sAccumulationNo==null)sAccumulationNo="";
			}
			rs.close();
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
				sm.write(mb.setValue("CommercialNo",sCommercialNo));//商贷号
				sm.write(mb.setValue("AccumulationNo",sAccumulationNo));//委贷号
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
				}else if(mb.getValue("TradeType").equals("1")){
					mb.logger.debug("["+sTradeID+"]交易成功");
					sReturn="0000000@";
				}else
					sReturn="9999999@["+sTradeID+"]交易失败，可能是网络通讯原因！";
				// 短连接时要 关闭连接，长连接时不关闭
				sm.teardownConnection();
			} catch (Exception e) {
				sReturn="9999999@["+sTradeID+"]交易失败，可能是网络通讯原因！请联系系统管理员！";
				e.printStackTrace();
				sm.teardownConnection();
			}
		}catch(Exception ex){
			ex.printStackTrace();
			mb.logger.error(sSql+"["+sTradeID+"]执行出错!");
		}
		return sReturn;
	}
}
