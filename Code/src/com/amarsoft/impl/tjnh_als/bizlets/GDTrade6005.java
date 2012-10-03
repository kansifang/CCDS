package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * ��ͬ���(6005)
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
		String sAccountNoType = "";             //����󻹿��˺�����    
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
			/////////////ȡ�����˺�//////////////
			sSql1 = "select SerialNo,MFOrgID from BUSINESS_DUEBILL where RelativeSerialNo2 = '"+RelativeNo+"' order by serialno desc";
			rs1 = Sqlca.getASResultSet(sSql1);
			if(rs1.next()){
				BDSerialNo = rs1.getString("SerialNo");
				MFOrgID = rs1.getString("MFOrgID");
				if(BDSerialNo == null) BDSerialNo ="";
				if(MFOrgID == null) MFOrgID ="";
			}
			rs1.close();
			//����ʹ��
			//RelativeNo = RelativeNo.length()>0?RelativeNo:"9031001001000719";
			//Maturity1 = "2010/12/08";
			//Maturity2 = "2009/12/08";
			//MFOrgID = MFOrgID.length()>0?MFOrgID:"901010900";
			/////////////ȡ����///////////////
			//if(Maturity2.length()>0&&Maturity1.length()>0){
			//	IsReduceTermMonth = (Integer.parseInt(Maturity1.substring(0, 3))*12+Integer.parseInt(Maturity1.substring(5, 6)))
			//					   -(Integer.parseInt(Maturity2.substring(0, 3))*12+Integer.parseInt(Maturity2.substring(5, 6)));
			//}
			//System.out.println(Paycyc2.length()>0&&!Paycyc2.equals(Paycyc1)?"1":"2"+"@@@@@@@@@@@@@");
			//System.out.println(Paycyc2.length()+"@"+Paycyc2+"@"+Paycyc1);
			//System.out.println(ReduceTermMonth);
			//-----------------��ϱ���----------------------
			try {
				// �������ļ��ж�ȡ����,��ɱ���ͷ
				sm.write(mb.setValue("WholeLength"));
				sm.write(mb.setValue("MessageType"));
				sm.write(mb.setValue("TradeCode",sTradeID));
				sm.write(mb.setValue("TradeDate",sTradeDate));
				sm.write(mb.setValue("SysDate",sTradeDate));
				sm.write(mb.setValue("TradeTime",StringFunction.getNow()));
				sm.write(mb.setValue("OrgID","909020000"));//ȡĬ��ҵ�������
				sm.write(mb.setValue("TerminiterID"));
				sm.write(mb.setValue("UserID","908908"));//ȡĬ���Ŵ�Ա���
				sm.write(mb.setValue("TradeFlag"));
				sm.write(mb.setValue("TradeSerialNo",sObjectNo));//������ˮ��
				sm.write(mb.setValue("Flag1"));
				sm.write(mb.setValue("Flag2"));
				sm.write(mb.setValue("Flag3"));
				sm.write(mb.setValue("Flag4"));
				sm.write(mb.setValue("ConfirmUserID","908908"));
				//����Ϊ����ͷ���֣�����Ϊ�����岿��
				sm.write(mb.setValue("BDSerialNo",BDSerialNo));//�����
				sm.write(mb.setValue("IsPayBackSum",ReturnBalance>0?"1":"2"));//�Ƿ������ǰ����
				sm.write(mb.setValue("PayBackSum",String.valueOf(ReturnBalance)));//��ǰ������
				sm.write(mb.setValue("IsChangeAccountNo",BankAccount2.length()>0&&!BankAccount2.equals(BankAccount1)?"1":"2"));//�Ƿ���ڻ����˺ű��
				sm.write(mb.setValue("ChangedAccountNo",BankAccount2));//����󻹿��˺�
				sm.write(mb.setValue("IsReduceTermMonth",ReduceTermMonth.length()>0?"1":"2"));//�Ƿ��������
				sm.write(mb.setValue("ReducedMaturity",Maturity2.replace('/', '-')));//���������
				sm.write(mb.setValue("ReducedTermMonth",ReduceTermMonth));//�������
				sm.write(mb.setValue("IsChangePayBackMethod",Paycyc2.length()>0&&!Paycyc2.equals(Paycyc1)?"1":"2"));//�Ƿ���ڻ��ʽ���
				sm.write(mb.setValue("ChangedPayBackMethod",Paycyc2));//�����Ļ��ʽ
				sm.write(mb.setValue("IsChangeFineRate",FineRate2.length()>0&&!FineRate2.equals(FineRate1)?"1":"2"));//�Ƿ���ڷ�Ϣ���ʱ��
				sm.write(mb.setValue("ChangedFineRate",FineRate2));//�����Ϣ����
				sm.write(mb.setValue("IsChangeInterest",DisCountInfo2.length()>0&&!DisCountInfo2.equals(DisCountInfo1)?"1":"2"));//�Ƿ������Ϣ���ʱ��
				sm.write(mb.setValue("ChangedInterest",DisCountInfo2));//�����Ϣ����
				sm.write(mb.setValue("IsChangeFloatRate",RateFloat2.length()>0&&!RateFloat2.equals(RateFloat1)?"1":"2"));//�Ƿ�������ʸ������ʱ��
				sm.write(mb.setValue("ChangedFloatRate",RateFloat2));//��������ʸ�������
				sm.write(mb.setValue("BaseRate",""));//��׼����
				sm.write(mb.setValue("FundSource","0"));//�ʽ���Դ
				sm.write(mb.setValue("PayBackType",ReturnBalance>0?(Balance>ReturnBalance?"0":"1"):""));//�������ͣ����ֻ���һ������ǰ���
				sm.write(mb.setValue("ManageOrgID",MFOrgID));//����֧��
				sm.write(mb.setValue("AccountNoType",sAccountNoType));//����󻹿��˺�����      
				
				
				//�����岿��������
				sm.flush();
				mb.logger.debug("sOldTemp=" + mb.sOldTemp);
				mb.logger.debug("sNewTemp=" + mb.sNewTemp);
				mb.logger.debug("iLeng=" + mb.iLeng);
				mb.logger.info("["+sTradeID+"]���ͳɹ���");
				// ��ȡ���ذ���
				byte[] pckbuf = new byte[4];
				sm.read(pckbuf);
				String s = new String(pckbuf, mb.CONV_CODESET);
				mb.logger.debug("Rcv_Head=" + s);
				int pcklen = Integer.parseInt(s);
				// ��ȡ���ذ�
				byte[] revbuf = new byte[pcklen];
				sm.readFully(revbuf);
				mb.logger.info("["+sTradeID+"]��������=" + new String(revbuf, mb.CONV_CODESET));
				// ��ʼ��xml����
				mb.initRcv(revbuf, pcklen);
				mb.logger.debug("["+sTradeID+"]���ױ�־TradeType��1�ɹ���3ʧ�ܣ�=" + mb.getValue("TradeType"));	
				if(mb.getValue("TradeType").equals("3")){
					String sOutMsgID=mb.getValue("OutMsgID");
					String sOutMsg="";
					rs1=Sqlca.getASResultSet("select MsgBdy from GD_ErrCode where CodeNo='" + sOutMsgID+ "'");
					if(rs1.next())
						sOutMsg = rs1.getString(1);
					sReturn=sOutMsgID+"@"+sOutMsg;
					rs1.close();
					mb.logger.debug("["+sTradeID+"]�������OutMsgID=" + mb.getValue("OutMsgID") + " ������Ϣ="+sOutMsg);
				}else if(mb.getValue("TradeType").equals("1")){
					mb.logger.debug("["+sTradeID+"]���׳ɹ�");
					sReturn="0000000@";
					//Sqlca.executeSQL("Update BUSINESS_PUTOUT set SendFlag='1' where SerialNo='"+sObjectNo+"'");
					
				}else
					sReturn="9999999@["+sTradeID+"]����ʧ�ܣ�����������ͨѶԭ��";
				// ������ʱҪ �ر����ӣ�������ʱ���ر�
				sm.teardownConnection();
			} catch (Exception e) {
				rs.close();
				sReturn="9999999@["+sTradeID+"]����ʧ�ܣ�����������ͨѶԭ������ϵϵͳ����Ա��";
				e.printStackTrace();
				sm.teardownConnection();
			}
			rs.close();
		}catch(Exception ex){
			ex.printStackTrace();
			mb.logger.error(sSql+"["+sTradeID+"]ִ�г���!");
		}
		return sReturn;
	}
}
