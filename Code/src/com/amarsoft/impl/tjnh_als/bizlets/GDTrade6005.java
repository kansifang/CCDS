package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * 合同变更(6005)
 * @author zrli
 * @date 2010-03-25
 *
 */
public class GDTrade6005 implements GDTradeInterface {
	public String runGDTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "6005";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		GDMessageBuilder mb = new GDMessageBuilder(S_URL, R_URL);
		String sSql="",sSql1="",sReturn="",RelativeNo="",Maturity1="",Maturity2="",SerialNo="",BankAccount1="",BankAccount2="",Paycyc1="",Paycyc2="";
		String FineRate2="",FineRate1="",DisCountInfo1="",DisCountInfo2="",RateFloat1="",RateFloat2="",MFOrgID="",BDSerialNo="",ReduceTermMonth="";
		String sAccountNoType = "";             //变更后还款账号类型    
		double ReturnBalance = 0.0,Balance=0.0;
		int IsReduceTermMonth = 0 ;
		ASResultSet rs,rs1=null;
	
		try{	
			sSql = " select SerialNo,RelativeNo,CustomerID,CustomerName,Paycyc1," +
					"getItemName('PayCyc',Paycyc1) as Paycyc1Name,Paycyc2,Maturity1,Maturity2,Balance1,ReduceTermMonth," +
					"ReturnBalance,BankAccount1,BankAccount2,RateFloat1,RateFloat2," +
					"FineRate1,FineRate2,OccurType,getItemName('OccurType',OccurType) as OccurTypeName,Purpose1," +
					"Purpose2,GuarantyInfo1,GuarantyInfo2,GuarantyOwner1,GuarantyOwner2," +
					"GuarantyAllOwner1,GuarantyAllOwner2,Warrantor1,Warrantor2,DisCountInfo1," +
					"DisCountInfo2,Remark,InputDate,InputUser,getUserName(InputUser) as InputUserName," +
					"InputOrg,getOrgName(InputOrg) as InputOrgName,UpdateDate,AccountNoType " +
					"from CONTRACT_MODIFY where SerialNo='"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				RelativeNo = rs.getString("RelativeNo");
				Maturity1 = rs.getString("Maturity1");
				Maturity2 = rs.getString("Maturity2");
				ReturnBalance = rs.getDouble("ReturnBalance");
				BankAccount1 = rs.getString("BankAccount1");
				BankAccount2 = rs.getString("BankAccount2");
				Paycyc1 = rs.getString("Paycyc1");
				Paycyc2 = rs.getString("Paycyc2");
				FineRate1 = rs.getString("FineRate1");
				FineRate2 = rs.getString("FineRate2");
				DisCountInfo1 = rs.getString("DisCountInfo1");
				DisCountInfo2 = rs.getString("DisCountInfo2");
				RateFloat1 = rs.getString("RateFloat1");
				RateFloat2 = rs.getString("RateFloat2");
				Balance = rs.getDouble("Balance1");
				ReduceTermMonth = rs.getString("ReduceTermMonth");
				sAccountNoType = rs.getString("AccountNoType");
				if(SerialNo == null) SerialNo ="";
				if(Maturity1 == null) Maturity1 ="";
				if(Maturity2 == null) Maturity2 ="";
				if(BankAccount1 == null) BankAccount1 ="";
				if(BankAccount2 == null) BankAccount2 ="";
				if(Paycyc1 == null) Paycyc1 ="";
				if(Paycyc2 == null) Paycyc2 ="";
				if(FineRate1 == null) FineRate1 ="";
				if(FineRate2 == null) FineRate2 ="";
				if(DisCountInfo1 == null) DisCountInfo1 ="";
				if(DisCountInfo2 == null) DisCountInfo2 ="";
				if(RateFloat1 == null) RateFloat1 ="";
				if(RateFloat2 == null) RateFloat2 ="";
				if(ReduceTermMonth == null) ReduceTermMonth ="";
				if(sAccountNoType == null) sAccountNoType ="";
			}
			/////////////取贷款账号//////////////
			sSql1 = "select SerialNo,MFOrgID from BUSINESS_DUEBILL where RelativeSerialNo2 = '"+RelativeNo+"' order by serialno desc";
			rs1 = Sqlca.getASResultSet(sSql1);
			if(rs1.next()){
				BDSerialNo = rs1.getString("SerialNo");
				MFOrgID = rs1.getString("MFOrgID");
				if(BDSerialNo == null) BDSerialNo ="";
				if(MFOrgID == null) MFOrgID ="";
			}
			rs1.close();
			//测试使用
			//RelativeNo = RelativeNo.length()>0?RelativeNo:"9031001001000719";
			//Maturity1 = "2010/12/08";
			//Maturity2 = "2009/12/08";
			//MFOrgID = MFOrgID.length()>0?MFOrgID:"901010900";
			/////////////取期限///////////////
			//if(Maturity2.length()>0&&Maturity1.length()>0){
			//	IsReduceTermMonth = (Integer.parseInt(Maturity1.substring(0, 3))*12+Integer.parseInt(Maturity1.substring(5, 6)))
			//					   -(Integer.parseInt(Maturity2.substring(0, 3))*12+Integer.parseInt(Maturity2.substring(5, 6)));
			//}
			//System.out.println(Paycyc2.length()>0&&!Paycyc2.equals(Paycyc1)?"1":"2"+"@@@@@@@@@@@@@");
			//System.out.println(Paycyc2.length()+"@"+Paycyc2+"@"+Paycyc1);
			//System.out.println(ReduceTermMonth);
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
				sm.write(mb.setValue("BDSerialNo",BDSerialNo));//贷款号
				sm.write(mb.setValue("IsPayBackSum",ReturnBalance>0?"1":"2"));//是否存在提前还款
				sm.write(mb.setValue("PayBackSum",String.valueOf(ReturnBalance)));//提前还款金额
				sm.write(mb.setValue("IsChangeAccountNo",BankAccount2.length()>0&&!BankAccount2.equals(BankAccount1)?"1":"2"));//是否存在还款账号变更
				sm.write(mb.setValue("ChangedAccountNo",BankAccount2));//变更后还款账号
				sm.write(mb.setValue("IsReduceTermMonth",ReduceTermMonth.length()>0?"1":"2"));//是否存在缩期
				sm.write(mb.setValue("ReducedMaturity",Maturity2.replace('/', '-')));//变更后到期日
				sm.write(mb.setValue("ReducedTermMonth",ReduceTermMonth));//变更期限
				sm.write(mb.setValue("IsChangePayBackMethod",Paycyc2.length()>0&&!Paycyc2.equals(Paycyc1)?"1":"2"));//是否存在还款方式变更
				sm.write(mb.setValue("ChangedPayBackMethod",Paycyc2));//变更后的还款方式
				sm.write(mb.setValue("IsChangeFineRate",FineRate2.length()>0&&!FineRate2.equals(FineRate1)?"1":"2"));//是否存在罚息利率变更
				sm.write(mb.setValue("ChangedFineRate",FineRate2));//变更后罚息利率
				sm.write(mb.setValue("IsChangeInterest",DisCountInfo2.length()>0&&!DisCountInfo2.equals(DisCountInfo1)?"1":"2"));//是否存在贴息比率变更
				sm.write(mb.setValue("ChangedInterest",DisCountInfo2));//变更贴息比率
				sm.write(mb.setValue("IsChangeFloatRate",RateFloat2.length()>0&&!RateFloat2.equals(RateFloat1)?"1":"2"));//是否存在利率浮动比率变更
				sm.write(mb.setValue("ChangedFloatRate",RateFloat2));//变更后利率浮动比率
				sm.write(mb.setValue("BaseRate",""));//基准利率
				sm.write(mb.setValue("FundSource","0"));//资金来源
				sm.write(mb.setValue("PayBackType",ReturnBalance>0?(Balance>ReturnBalance?"0":"1"):""));//还款类型（部分还是一次性提前还款）
				sm.write(mb.setValue("ManageOrgID",MFOrgID));//贷款支行
				sm.write(mb.setValue("AccountNoType",sAccountNoType));//变更后还款账号类型      
				
				
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
					sReturn=sOutMsgID+"@"+sOutMsg;
					rs1.close();
					mb.logger.debug("["+sTradeID+"]错误代码OutMsgID=" + mb.getValue("OutMsgID") + " 错误信息="+sOutMsg);
				}else if(mb.getValue("TradeType").equals("1")){
					mb.logger.debug("["+sTradeID+"]交易成功");
					sReturn="0000000@";
					//Sqlca.executeSQL("Update BUSINESS_PUTOUT set SendFlag='1' where SerialNo='"+sObjectNo+"'");
					
				}else
					sReturn="9999999@["+sTradeID+"]交易失败，可能是网络通讯原因！";
				// 短连接时要 关闭连接，长连接时不关闭
				sm.teardownConnection();
			} catch (Exception e) {
				rs.close();
				sReturn="9999999@["+sTradeID+"]交易失败，可能是网络通讯原因！请联系系统管理员！";
				e.printStackTrace();
				sm.teardownConnection();
			}
			rs.close();
		}catch(Exception ex){
			ex.printStackTrace();
			mb.logger.error(sSql+"["+sTradeID+"]执行出错!");
		}
		return sReturn;
	}
}
