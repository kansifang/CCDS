package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * �������798002����
 * @author zrli
 * @��������ʮ��������
 *
 */
public class MFTrade798002 implements MFTradeInterface {
	public String runMFTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "798002";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		MFMessageBuilder mb = new MFMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="",sCustomerID="",sVouchType="",sContractSerialNo="",sIsPigeonholeFlag = "";
		String sAllowanceFlag = "0";    // ��Ϣ��־  0-��(�̶�),1-������Ϣ,2-���������Ϣ,3-������Ϣ  
		String sDeductType = "101";     // �ۿʽ  101-�ж��ٿ۶���, 102-ȫ��      
		String sRateFloatFlag = "0";    // ������������ 0-��ֵ,1��ֵ
		String sBusinessRateType = "Y"; // �������� Y-������,M-������,D-������
		String sTradeFlag = sObjectType;        // ���ױ�ʶ 0-����,1-�ſ�
		double BusinessSum=0.00;
		ASResultSet rs,rs1=null;
		double dContractSum = 0.0,dPutOutTotalSum=0.0;
		
		/*
		sSql="select CustomerID,"+
		" (select mainframeexgid from org_info where orgid=OperateOrgID) as OperateOrgID,getMFUserID(OperateUserID,'') as OperateUserID "+
		" from "+sTable+" where SerialNo='"+sObjectNo+"'";
		try{
			rs1=Sqlca.getResultSet(sSql);
			if(rs1.next()){
				sOperateOrgID=rs1.getString("OperateOrgID");
				sOperateUserID=rs1.getString("OperateUserID");
				sCustomerID=rs1.getString("CustomerID");
				if(sOperateOrgID == null) sOperateOrgID="";
				if(sOperateUserID == null) sOperateUserID="";
				if(sCustomerID == null) sCustomerID="";
			}
			rs1.close();
		}catch(Exception ex){
			mb.logger.error("��ѯ["+sSql+"]����");
			sReturn="9999996@����ʧ�ܣ���ѯ["+sSql+"]����";
			return sReturn;
		}
		*/
		sSql="select SerialNo,getMFCode('Currency',BusinessCurrency,'01') as BusinessCurrency,VouchType,PutOutDate,Maturity,BusinessSum," +
				"TermMonth,BusinessRate,ICCyc,CorpusPayMethod,CreditKind,getMFCode('CertType',CertType,'Z') as CertType,CertID,ContractSerialNo, "+
				"OverdueRateFloat,TARateFloat,ContractSum,ConsultNo,SubjectNo,CapitalSource,CapitalSourceNo,DeductNo,PutOutOrgID,LoanOrgID,ABS(RateFloat) as RateFloat,AdjustRateType "+
			" from BUSINESS_PUTOUT where SerialNo='"+sObjectNo+"'";
		System.out.println("sSql===>>>"+sSql);
		try{
			rs=Sqlca.getResultSet(sSql);
			if(rs.next()){
				//������ʽ����
				sVouchType = rs.getString("VouchType");
				if(sVouchType == null) sVouchType = "";
				if(sVouchType.startsWith("005"))
					sVouchType="04";
				else if(sVouchType.startsWith("010"))
					sVouchType="03";
				else if(sVouchType.startsWith("020"))
					sVouchType="01";
				else if(sVouchType.startsWith("040"))
					sVouchType="02";
				else
					sVouchType="99";
				sContractSerialNo = rs.getString("ContractSerialNo");
				BusinessSum = rs.getDouble("BusinessSum");
				//////////////ȡ��Ӧ��ͬ�Ƿ����//////////////////////
				dContractSum=rs.getDouble("ContractSum");
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
				//-----------------��ϱ���----------------------
				try {
					// �������ļ��ж�ȡ����,��ɱ���ͷ
					sm.write(mb.setValue("WholeLength"));
					sm.write(mb.setValue("MessageType"));
					sm.write(mb.setValue("TradeCode",sTradeID));
					sm.write(mb.setValue("TradeDate",sTradeDate));
					sm.write(mb.setValue("SysDate",sTradeDate));
					sm.write(mb.setValue("TradeTime",StringFunction.getNow().replace(":", ".")));
					sm.write(mb.setValue("OrgID"));//ȡĬ��ҵ�������
					sm.write(mb.setValue("TerminiterID"));
					sm.write(mb.setValue("UserID"));//ȡĬ���Ŵ�Ա���
					sm.write(mb.setValue("TradeFlag"));
					sm.write(mb.setValue("TradeSerialNo"));
					sm.write(mb.setValue("Flag1"));
					sm.write(mb.setValue("Flag2"));
					sm.write(mb.setValue("Flag3"));
					sm.write(mb.setValue("Flag4"));
					sm.write(mb.setValue("ConfirmUserID"));
					//����Ϊ����ͷ���֣�����Ϊ�����岿��
					sm.write(mb.setValue("BusinessCurrency",rs.getString("BusinessCurrency")));
					sm.write(mb.setValue("BusinessSum",rs.getString("BusinessSum")));
					sm.write(mb.setValue("VouchType",sVouchType));
					sm.write(mb.setValue("BeginDate",rs.getString("PutOutDate").replace("/", "-")));
					sm.write(mb.setValue("EndDate",rs.getString("Maturity").replace("/", "-")));
					sm.write(mb.setValue("TermMonth",rs.getString("TermMonth")));
					sm.write(mb.setValue("BusinessRate",rs.getString("BusinessRate")));
					sm.write(mb.setValue("ICCyc",rs.getString("ICCyc")));
					sm.write(mb.setValue("CorpusPayMethod",rs.getString("CorpusPayMethod")));
					sm.write(mb.setValue("Purpose",rs.getString("CreditKind")));
					sm.write(mb.setValue("CertType",rs.getString("CertType")));
					sm.write(mb.setValue("CertID",rs.getString("CertID")));
					sm.write(mb.setValue("BPSerialNo",sObjectNo));
					sm.write(mb.setValue("BCSerialNo",sContractSerialNo));
					sm.write(mb.setValue("OverdueRateFloat",rs.getString("OverdueRateFloat")));
					sm.write(mb.setValue("TARateFloat",rs.getString("TARateFloat")));
					sm.write(mb.setValue("ConsultNo",rs.getString("ConsultNo")));					
					sm.write(mb.setValue("SubjectNo",rs.getString("SubjectNo")));
					sm.write(mb.setValue("CapitalSource",rs.getString("CapitalSource")));
					sm.write(mb.setValue("CapitalSourceNo",rs.getString("CapitalSourceNo")));
					sm.write(mb.setValue("DeductNo",rs.getString("DeductNo")));
					sm.write(mb.setValue("PutOutOrgID",rs.getString("PutOutOrgID")));
					sm.write(mb.setValue("LoanOrgID",rs.getString("LoanOrgID")));
					sm.write(mb.setValue("RateFloat",rs.getString("RateFloat")));
					sm.write(mb.setValue("AdjustRateType",rs.getString("AdjustRateType")));
					sm.write(mb.setValue("AllowanceFlag",sAllowanceFlag));
					sm.write(mb.setValue("DeductType",sDeductType));
					sm.write(mb.setValue("RateFloatFlag",sRateFloatFlag));
					sm.write(mb.setValue("BusinessRateType",sBusinessRateType));
					sm.write(mb.setValue("TradeFlag",sTradeFlag));
										
					//�����岿��������
					sm.flush();
					mb.logger.debug("sOldTemp=" + mb.sOldTemp);
					mb.logger.debug("sNewTemp=" + mb.sNewTemp);
					mb.logger.debug("���ͱ����ܳ�iLeng=" + mb.iLeng+",ע�����ͷ�б��ĳ���ӦΪ������4��");
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
						String sOutMsgID=mb.getValue("OutMsgID").substring(2,9);
						String sOutMsg="";
						rs1=Sqlca.getASResultSet("select MsgBdy from MF_ErrCode where CodeNo='" + sOutMsgID+ "'");
						if(rs1.next())
							sOutMsg = rs1.getString(1);
						sReturn=sOutMsgID+"@"+sOutMsg+"|"+mb.getValue("OutMsg");
						rs1.close();
						mb.logger.debug("["+sTradeID+"]�������OutMsgID=" + mb.getValue("OutMsgID") + " ������Ϣ="+sOutMsg+"|"+mb.getValue("OutMsg"));
					}else if(mb.getValue("TradeType").equals("1")){
						mb.logger.debug("["+sTradeID+"]���׳ɹ�");
						sReturn="0000000@";
						Sqlca.executeSQL("Update BUSINESS_PUTOUT set SendFlag='1' where SerialNo='"+sObjectNo+"'");
						//���Ϊ��ѭ����ͬ��ֱ�Ӻ�ͬ�鵵��
						if("True".equals(sIsPigeonholeFlag))
						{
							Sqlca.executeSQL("Update BUSINESS_CONTRACT set PigeonholeDate='"+StringFunction.getToday()+"' where SerialNo='"+sContractSerialNo+"' and (CycleFlag is null or CycleFlag = '' or CycleFlag ='2')");
						}
					}else
						sReturn="9999999@["+sTradeID+"]����ʧ�ܣ�����������ͨѶԭ��";
					// ������ʱҪ �ر����ӣ�������ʱ���ر�
					sm.teardownConnection();
				} catch (Exception e) {
					sReturn="9999999@["+sTradeID+"]����ʧ�ܣ�����������ͨѶԭ������ϵϵͳ����Ա��";
					e.printStackTrace();
					sm.teardownConnection();
				}
			}
			rs.close();
		}catch(Exception ex){
			ex.printStackTrace();
			mb.logger.error(sSql+"["+sTradeID+"]ִ�г���!");
		}
		return sReturn;
	}
}
