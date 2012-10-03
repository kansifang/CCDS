package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * ����ҵ�񣬴������6001����
 * @author zrli
 * @date 2010-03-01
 *
 */
public class GDTrade6023 implements GDTradeInterface {
	public String runGDTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "6023";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		GDMessageBuilder mb = new GDMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="",sContractSerialNo="",sOrgID="",sUserID="";
		String sIsPigeonholeFlag = "";
		ASResultSet rs,rs1=null;
		String  EvalNetValue1 = "",GuarantySum1 = "",EvalNetValue2 = "",GuarantySum2="";
		String sBuinessType = "";
		double dContractSum = 0.0,dPutOutTotalSum=0.0;
		
		
		sSql="select BP.ContractSerialNo as ContractSerialNo,BP.ContractSum as ContractSum,GetMFUserID(BP.InputUserID) as InputUserID,GetMFOrgID(BP.InputOrgID) as InputOrgID," +
				"BP.InputDate,BC.ThirdParty1,BC.Describe1,BC.ConstructContractNo,BP.COMMERCIALNO,BP.ACCUMULATIONNO, "+
				"BP.BusinessType as BusinessType "+
				" from BUSINESS_PUTOUT BP,IND_INFO II,BUSINESS_CONTRACT BC " +
				" where BP.SerialNo='"+sObjectNo+"' and BP.CustomerID=II.CustomerID and BP.ContractSerialNo=BC.SerialNo";
		try{
			rs=Sqlca.getResultSet(sSql);
			if(rs.next()){
				////////////////������//////////////////
				sOrgID = rs.getString("InputOrgID");
				sUserID = rs.getString("InputUserID");
				sContractSerialNo = rs.getString("ContractSerialNo");
				sBuinessType = rs.getString("BusinessType");
				//////////////ȡ��������Ѻ�����Ϣ//////////////////////
				sSql="  select  sum(case when guarantytype like '010%' then EvalNetValue else 0 end) as EvalNetValue1 , "+
					"sum(case when guarantytype like '010%' then AboutSum2 else 0 end) as GuarantySum1, "+
					"sum(case when guarantytype like '020%' then EvalNetValue else 0 end) as EvalNetValue2, "+
					"sum(case when guarantytype like '020%' then AboutSum2 else 0 end) as GuarantySum2 from GUARANTY_INFO "+ 
					"where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType = 'BusinessContract' and ObjectNo = '"+sContractSerialNo+"' ) ";
				rs1=Sqlca.getResultSet(sSql);
				if(rs1.next()){
					EvalNetValue1=rs1.getString("EvalNetValue1");
					GuarantySum1=rs1.getString("GuarantySum1");
					EvalNetValue2=rs1.getString("EvalNetValue2");
					GuarantySum2=rs1.getString("GuarantySum2");
					
				}
				rs1.close();
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
					sm.write(mb.setValue("TradeTime",StringFunction.getNow()));
					sm.write(mb.setValue("OrgID","9090"));//ȡĬ��ҵ�������
					sm.write(mb.setValue("TerminiterID"));
					sm.write(mb.setValue("UserID",sUserID));//ȡĬ���Ŵ�Ա���
					sm.write(mb.setValue("TradeFlag"));
					sm.write(mb.setValue("TradeSerialNo",sObjectNo));//������ˮ��
					sm.write(mb.setValue("Flag1"));
					sm.write(mb.setValue("Flag2"));
					sm.write(mb.setValue("Flag3"));
					sm.write(mb.setValue("Flag4"));
					sm.write(mb.setValue("ConfirmUserID",sUserID));
					//����Ϊ����ͷ���֣�����Ϊ�����岿��
					sm.write(mb.setValue("BPSerialNo",sObjectNo));//�Ŵ�ϵͳ������ˮ��
					sm.write(mb.setValue("BCSerialNo",sContractSerialNo));//�Ŵ�ϵͳ��ͬ��ˮ��
					sm.write(mb.setValue("CommercialNo",rs.getString("COMMERCIALNO")));//�̴���
					sm.write(mb.setValue("AccumulationNo",rs.getString("ACCUMULATIONNO")));//ί����
					sm.write(mb.setValue("GuarantySum1",GuarantySum1));//��Ѻ������ծȨ������
					sm.write(mb.setValue("GuarantySum2",GuarantySum2));//��Ѻ������ծȨ������
					sm.write(mb.setValue("EvaluateSum1",EvalNetValue1));//��Ѻ������ֵ������
					sm.write(mb.setValue("EvaluateSum2",EvalNetValue2));//��Ѻ������ֵ������
					sm.write(mb.setValue("BailAccountNo","0"));//��֤���˺�
					sm.write(mb.setValue("BailRatio","0"));//��ͽɴ汣֤�����
					sm.write(mb.setValue("PutOutUserID",sUserID));//�Ŵ�Ա
					sm.write(mb.setValue("PutOutOrgID",sOrgID));//����֧��
					
					
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
						if("2110020".equals(sBuinessType))
						{
							sReturn="0000000@"+"�����Ϊ["+rs.getString("ACCUMULATIONNO")+"],��ݺ�Ϊ["+mb.getValue("AccumulationDuebillNo")+"]";
						}else{
							sReturn="0000000@"+"�����Ϊ["+rs.getString("COMMERCIALNO")+"],��ݺ�Ϊ["+mb.getValue("CommercialDuebillNo")+"]";
						}
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
