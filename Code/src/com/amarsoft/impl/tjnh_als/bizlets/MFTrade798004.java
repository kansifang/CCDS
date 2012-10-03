package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * 实时余额查询798004
 * @author zrli
 * @二○○九年十二月三日
 *
 */
public class MFTrade798004 implements MFTradeInterface {
	public String runMFTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "798004";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		MFMessageBuilder mb = new MFMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="";
		ASResultSet rs,rs1=null;
		double dBalance = 0.0;
		double dNormalBalance = 0.0;
		double dOverdueBalance = 0.0;
		double dDullBalance = 0.0;
		double dBadBalance = 0.0;
		double dInterestBalance1 = 0.0;
		double dInterestBalance2 = 0.0;
		
		try {
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
			sm.write(mb.setValue("BCSerialNo",sObjectNo));//sObjectNo
								
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
				sReturn=sOutMsgID+"@"+sOutMsg+"|"+mb.getValue("OutMsg");
				rs1.close();
				mb.logger.debug("["+sTradeID+"]错误代码OutMsgID=" + mb.getValue("OutMsgID") + " 错误信息="+sOutMsg+"|"+mb.getValue("OutMsg"));
			}else if(mb.getValue("TradeType").equals("1")){
				dBalance = Double.parseDouble(mb.getValue("Balance"))/100.00;
				dNormalBalance = Double.parseDouble(mb.getValue("NormalBalance"))/100.00;
				dOverdueBalance = Double.parseDouble(mb.getValue("OverdueBalance"))/100.00;
				dDullBalance = Double.parseDouble(mb.getValue("DullBalance"))/100.00;
				dBadBalance = Double.parseDouble(mb.getValue("BadBalance"))/100.00;
				dInterestBalance1 = Double.parseDouble(mb.getValue("InterestBalance1"))/100.00;
				dInterestBalance2 = Double.parseDouble(mb.getValue("InterestBalance2"))/100.00;
				mb.logger.debug("["+sTradeID+"]交易成功,余额="+dBalance);
				sReturn="0000000@余额="+DataConvert.toMoney(dBalance)+";表内欠息="+dInterestBalance1+";表外欠息="+dInterestBalance2;
				Sqlca.executeSQL("Update BUSINESS_CONTRACT "+
						"set Balance="+dBalance+","+
						" NormalBalance="+dNormalBalance+","+
						" OverdueBalance="+dOverdueBalance+","+
						" DullBalance="+dDullBalance+","+
						" BadBalance="+dBadBalance+","+
						" InterestBalance1="+dInterestBalance1+","+
						" InterestBalance2="+dInterestBalance2+
						" where SerialNo='"+sObjectNo+"'");
				if(dBalance == 0|| dNormalBalance ==0|| dOverdueBalance ==0||dDullBalance==0||dBadBalance==0||dInterestBalance1==0||dInterestBalance2==0){
					String sUpdateBalance = "Update BUSINESS_DUEBILL set ";
					if(dBalance == 0){
						sUpdateBalance+=" Balance=0,";
					}
					if(dNormalBalance == 0){
						sUpdateBalance+=" NormalBalance=0,";
					}
					if(dOverdueBalance == 0){
						sUpdateBalance+=" OverdueBalance=0,";
					}
					if(dDullBalance == 0){
						sUpdateBalance+=" DullBalance=0,";
					}
					if(dBadBalance == 0){
						sUpdateBalance+=" BadBalance=0,";
					}
					if(dInterestBalance1 == 0){
						sUpdateBalance+=" InterestBalance1=0,";
					}
					if(dInterestBalance2 == 0){
						sUpdateBalance+=" InterestBalance2=0,";
					}
					sUpdateBalance+=" LcStatus = LcStatus where RelativeSerialNo2='"+sObjectNo+"'";
					Sqlca.executeSQL(sUpdateBalance);
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
