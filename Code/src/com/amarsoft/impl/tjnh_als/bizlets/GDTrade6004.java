package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * 提前还款试算(6004)
 * @author zrli
 * @date 2010-03-25
 *
 */
public class GDTrade6004 implements GDTradeInterface {
	public String runGDTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "6004";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		GDMessageBuilder mb = new GDMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="",RelativeNo="",Maturity1="",Maturity2="",ReturnBalance="",SerialNo="",Balance="";
		int IsReduceTermMonth = 0 ;
		ASResultSet rs,rs1=null;
	
		try{	
			sSql = " select BD.SerialNo,BD.Balance,CC.RelativeNo,CC.CustomerID,CC.Maturity1,CC.Maturity2,CC.ReturnBalance " +
					"from CONTRACT_MODIFY CC,BUSINESS_DUEBILL BD " +
					"where CC.SerialNo='"+sObjectNo+"' and CC.RelativeNo = BD.RelativeSerialNo2 order by serialno desc ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				SerialNo = rs.getString("SerialNo");
				Maturity1 = rs.getString("Maturity1");
				Maturity2 = rs.getString("Maturity2");
				Balance = rs.getString("Balance");
				ReturnBalance = rs.getString("ReturnBalance");
				if(SerialNo == null) SerialNo ="";
				if(Maturity1 == null) Maturity1 ="";
				if(Maturity2 == null) Maturity2 ="";
				if(ReturnBalance == null) ReturnBalance ="";
			}
			rs.close();
			//判断缩期情况
			//SerialNo = "9031001001000719";
			//ReturnBalance = "1090";
			//Maturity1 = "2009/12/08";
			//Maturity2 = "2008/12/08";
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
				sm.write(mb.setValue("BDSerialNo",SerialNo));//贷款号
				sm.write(mb.setValue("IsReduceTermMonth",Maturity1.equals(Maturity2)?"2":"1"));//是否存在缩期
				sm.write(mb.setValue("PayBackSum",ReturnBalance));//提前还款金额
				sm.write(mb.setValue("FundSource"));//资金来源
				sm.write(mb.setValue("ReturnType",ReturnBalance.equals(Balance)?"1":"0"));//还款类型
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
					String sOutMsgID=mb.getValue("OutMsgID");
					String sOutMsg="";
					rs1=Sqlca.getASResultSet("select MsgBdy from GD_ErrCode where CodeNo='" + sOutMsgID+ "'");
					if(rs1.next())
						sOutMsg = rs1.getString(1);
					sReturn=sOutMsgID+"@"+sOutMsg+"|"+mb.getValue("OutMsg");
					rs1.close();
					mb.logger.debug("["+sTradeID+"]错误代码OutMsgID=" + mb.getValue("OutMsgID") + " 错误信息="+sOutMsg);
				}else if(mb.getValue("TradeType").equals("1")){
					mb.logger.debug("["+sTradeID+"]交易成功");
					sReturn="0000000@应还本金["+Double.parseDouble(mb.getValue("PayBackCapitalSum"))/10000+"],应还利息["+Double.parseDouble(mb.getValue("PayBackInterest"))/10000+"]";
					//Sqlca.executeSQL("Update BUSINESS_PUTOUT set SendFlag='1' where SerialNo='"+sObjectNo+"'");
					
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
