package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * ��������ѯ����ҵ��ϵͳ�ͻ���Ϣ798001����
 * @author zrli
 *
 */
public class MFTrade798001 implements MFTradeInterface {
	public String runMFTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "798001";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		MFMessageBuilder mb = new MFMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="",sCustomerID="",sTable="",sCustomerName="";
		ASResultSet rs,rs1=null;
		try{
			//���Ϊ����׶�
			if(sObjectType.equals("Customer")){
				sTable="CUSTOMER_INFO";
				sCustomerID = sObjectNo;
			}else if(sObjectType.equals("CreditApply")){
				sTable="BUSINESS_APPLY";
				sSql="select CustomerID From Business_Apply where SerialNo='"+sObjectNo+"'";
				rs1=Sqlca.getResultSet(sSql);
				if(rs1.next()){
					sCustomerID=rs1.getString("CustomerID");
					if(sCustomerID == null) sCustomerID="";
				}
				rs1.close();
			}else if(sObjectType.equals("PutOutApply")){
				sTable="BUSINESS_PUTOUT";
				sSql="select CustomerID From BUSINESS_PUTOUT where SerialNo='"+sObjectNo+"'";
				rs1=Sqlca.getResultSet(sSql);
				if(rs1.next()){
					sCustomerID=rs1.getString("CustomerID");
					if(sCustomerID == null) sCustomerID="";
				}
				rs1.close();
			}else{
				sReturn="9999997@����ʧ�ܣ�ObjectType=["+sObjectType+"]��֧�֣�";
				return sReturn;
			}
		}catch(Exception ex){
			mb.logger.error("��ѯ["+sSql+"]����");
			sReturn="9999996@����ʧ�ܣ���ѯ["+sSql+"]����";
			return sReturn;
		}

		sSql="select getMFCode('CertType',CertType,'') as CertType,CertID,CustomerName,"+
			" case when CustomerType='03' then '1' else '2' end as CustomerType "+
			" from CUSTOMER_INFO where CustomerID='"+sCustomerID+"'";
		try{
			rs=Sqlca.getResultSet(sSql);
			if(rs.next()){
				sCustomerName = rs.getString("CustomerName");
				
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
					sm.write(mb.setValue("Channel"));
					sm.write(mb.setValue("CustomerID",sCustomerID));
					sm.write(mb.setValue("CertType",rs.getString("CertType")));
					sm.write(mb.setValue("CertID",rs.getString("CertID")));
					sm.write(mb.setValue("CustomerName",sCustomerName));
					sm.write(mb.setValue("CustomerType",rs.getString("CustomerType")));
					
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
						//����ͻ����ƿ��Ա���һ�¾���ʾ�ɹ�
						if(sCustomerName.equals(mb.getValue("MFCustomerName"))){
							sReturn="0000000@"+mb.getValue("MFCustomerID")+mb.getValue("MFCustomerName");
							Sqlca.executeSQL("Update Customer_Info set MFCustomerID='"+mb.getValue("MFCustomerID")+"' where CustomerID='"+sCustomerID+"'");
						}else{
							sReturn="0000001@["+mb.getValue("MFCustomerID")+mb.getValue("MFCustomerName")+"]�Ŵ�ϵͳ�����ϵͳ�ͻ����Ʋ�һ�£�";
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
