package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * ����Ѻ����⽻��777100����
 * @author xhyong 2012/07/26
 *
 */
public class MFTrade777100 implements MFTradeInterface {
	public String runMFTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "777100";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		MFMessageBuilder mb = new MFMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="";
		ASResultSet rs,rs1 = null;
		String sLoanOrgID = "",sGuarantyID = "",sBCSerialNO = "",
			sOwnerName = "",sShareCustomerName = "",sGCSerialNo = "",
			sGuarantyType = "",sGuarantyList = "",sGuarantyTypeName = "",
			sFidate = "",sAmount = "",sUnit = "",sModel = "",sVouchType = "",
			sConfirmValue = "",sGuarantyCurrency = "",sEvalNetValue = "",
			sAboutSum2 = "",sRPName = "",sGuarantyRightID = "",sRPOfer	 = "";
		try{
			//���Ϊ����׶�
			
			sSql="select '' as LoanOrgID,GI.GuarantyID,GR.ObjectNo as BCSerialNo,"+
				" GI.OwnerName,GI.ShareCustomerName,GR.ContractNo as GCSerialNo,"+
				" GI.GuarantyType,'' as GuarantyList,getItemName('GuarantyList',GI.GuarantyType) as GuarantyTypeName,"+
				" '' as Fidate,'' as Amount,'' as Unit,"+
				" '' as Model,(case when GI.GuarantyType like '010%' then '01' else '02' end) as VouchType," +
				" GI.ConfirmValue,GI.GuarantyCurrency,GI.EvalNetValue,GI.AboutSum2,"+
				" '' as RPName,GI.GuarantyRightID,'' as RPOfer "+
			" from GUARANTY_RELATIVE GR,GUARANTY_INFO GI "+
			" where GR.GuarantyID=GI.GuarantyID "+
				"and GR.ObjectType='BusinessContract' "+
				" and GI.GuarantyStatus<>'02' "+
				"and GI.GuarantyID='"+sObjectNo+"' ";
			rs=Sqlca.getResultSet(sSql);
			if(rs.next()){
				sLoanOrgID = rs.getString("LoanOrgID");
				sGuarantyID = rs.getString("GuarantyID");
				sBCSerialNO = rs.getString("BCSerialNO");
				sOwnerName = rs.getString("OwnerName");
				sShareCustomerName = rs.getString("ShareCustomerName");
				sGCSerialNo = rs.getString("GCSerialNo");
				sGuarantyType = rs.getString("GuarantyType");
				sGuarantyList = rs.getString("GuarantyList");
				sGuarantyTypeName = rs.getString("GuarantyTypeName");
				sFidate = rs.getString("Fidate");
				sAmount = rs.getString("Amount");
				sUnit = rs.getString("Unit");
				sModel = rs.getString("Model");
				sVouchType = rs.getString("VouchType");
				sConfirmValue = rs.getString("ConfirmValue");
				sGuarantyCurrency = rs.getString("GuarantyCurrency");
				sEvalNetValue = rs.getString("EvalNetValue");
				sAboutSum2 = rs.getString("AboutSum2");
				sRPName = rs.getString("RPName");
				sGuarantyRightID = rs.getString("GuarantyRightID");
				sRPOfer	 = rs.getString("RPOfer");
			}
			rs.close();
			
		}catch(Exception ex){
			mb.logger.error("��ѯ["+sSql+"]����");
			sReturn="9999996@����ʧ�ܣ���ѯ["+sSql+"]����";
			return sReturn;
		}

		try{
				
				//-----------------��ϱ���----------------------
				try {
					// �������ļ��ж�ȡ����,��ɱ���ͷ
					sm.write(mb.setValue("WholeLength"));
					sm.write(mb.setValue("MessageType"));
					sm.write(mb.setValue("TradeCode"));
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
					sm.write(mb.setValue("LoanOrgID",sLoanOrgID)); //������
					sm.write(mb.setValue("GuarantyID",sGuarantyID)); //����Ʒ���
					sm.write(mb.setValue("BCSerialNo",sBCSerialNO)); //�Ŵ���ͬ��
					sm.write(mb.setValue("OwnerName",sOwnerName)); //����Ʒ������
					sm.write(mb.setValue("ShareCustomerName",sShareCustomerName)); //����Ʒ������
					sm.write(mb.setValue("GCSerialNo",sGCSerialNo)); //������ͬ���
					sm.write(mb.setValue("GuarantyType",sGuarantyType)); //����Ʒ����
					sm.write(mb.setValue("GuarantyList",sGuarantyList)); //����Ʒ������
					sm.write(mb.setValue("GuarantyTypeName",sGuarantyTypeName)); //����Ʒ����
					sm.write(mb.setValue("FIdate",sFidate)); //����Ʒ������
					sm.write(mb.setValue("Amount",sAmount)); //����
					sm.write(mb.setValue("Unit",sUnit)); //��λ
					sm.write(mb.setValue("Model",sModel)); //����ͺ�
					sm.write(mb.setValue("VouchType",sVouchType)); //������ʽ
					sm.write(mb.setValue("ConfirmValue",sConfirmValue)); //��ǰ����
					sm.write(mb.setValue("GuarantyCurrency",sGuarantyCurrency)); //����
					sm.write(mb.setValue("EvalNetValue",sEvalNetValue)); //������ֵ
					sm.write(mb.setValue("AboutSum2",sAboutSum2)); //��Ѻ�Ǽǽ��
					sm.write(mb.setValue("RPName",sRPName)); //Ȩ��֤������
					sm.write(mb.setValue("GuarantyRightID",sGuarantyRightID)); //Ȩ��֤�����
					sm.write(mb.setValue("RPOfer",sRPOfer)); //Ȩ��֤���ṩ��
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
					}else
						sReturn="9999999@["+sTradeID+"]����ʧ�ܣ�����������ͨѶԭ��";
					// ������ʱҪ �ر����ӣ�������ʱ���ر�
					sm.teardownConnection();
				} catch (Exception e) {
					sReturn="9999999@["+sTradeID+"]����ʧ�ܣ�����������ͨѶԭ������ϵϵͳ����Ա��";
					e.printStackTrace();
					sm.teardownConnection();
				}
		}catch(Exception ex){
			ex.printStackTrace();
			mb.logger.error(sSql+"["+sTradeID+"]ִ�г���!");
		}
		return sReturn;
	}
}
