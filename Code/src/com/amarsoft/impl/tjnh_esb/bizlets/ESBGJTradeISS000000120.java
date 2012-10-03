package com.amarsoft.impl.tjnh_esb.bizlets;


import java.util.ArrayList;
import java.util.List;

import spc.webos.data.ICompositeNode;
import spc.webos.data.IMessage;
import spc.webos.data.Status;
import spc.webos.endpoint.ESB;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.ibm.mq.MQException;

/**
 * ISS000000120��ȡҵ��ο���
 * @author hldu 2012-04-17
 * ���� custNo-���Ŀͻ���,bussClass-ҵ��Ʒ��
 * ���� bussConsNo-ҵ��ο���,custNo-���Ŀͻ���,currType-����,bussClass-ҵ��Ʒ��,amt-������,note-��ע
 */
public class ESBGJTradeISS000000120 implements ESBGJTradeInterface {
	public String runESBGJTrade(String sObjectNo,String sObjectType,String sTradeType,Transaction Sqlca,String sTradeDate){
	
		//��ȡ�������������ڣ����ױ���
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		if(sTradeType.equals("")) sTradeType = "ISS000000120";
		
		//�������
		String sReturn = "";       					//����ķ��ز���
		String sSql = "";          					//sql ���
		String sMFCustomerID ="";  					//���Ŀͻ���
		String sBusinessType = "";					//����ҵ��Ʒ��
		String sConsultNo = "";						//����ҵ��ο���
		String sCurrency = "";						//����ҵ�����
		String sRemark = "" ;						//����ҵ��Ʊ��
		Double dBusinessSum = 0.0 ;					//����ҵ����
		ASResultSet rs = null;                      //sql�α�
		String sCustName = "";                      //�ͻ���������
		
		/******************************��ȡ��������***********************************/
		sSql =  " select CI.MFCustomerID,BP.BusinessType,BP.CustomerID " +
				" from CUSTOMER_INFO CI,BUSINESS_PUTOUT BP" +
				" where BP.SerialNo='"+sObjectNo+"' and CI.CustomerID=BP.CustomerID ";
		try{
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sMFCustomerID = rs.getString("MFCustomerID");
				sBusinessType = rs.getString("BusinessType");
			}
			rs.getStatement().close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		/*****************************����������**************************************/
		// ����һ���ձ���
		ESB esb = ESB.getInstance();
		spc.webos.data.Message reqmsg = esb.newMessage(); 
		
		// ��������������������
		// ��������� ���ũ����SOAƽ̨�ӿ�XML���Ĺ淶-V1.0.doc
		// ������ͷ:
		reqmsg.setMsgCd(sTradeType); 							//���ô˴�����ķ����ı��(����)
		reqmsg.setRcvAppCd("ISS");								//���ô˴�����Ľ���ϵͳ��ţ����裩
		reqmsg.setCallType ("SYN");								//���÷�ʽSYN ��ʾͬ������
		
		//��������		
		reqmsg.setInRequest("custNo", sMFCustomerID);   		//���Ŀͻ���
		reqmsg.setInRequest("bussClass", sBusinessType);     	//ҵ��Ʒ��             

		// ��ӡ�������͵ı�������
		System.out.println("req msg:������ " 	+ reqmsg.toXml(true));
		/******************************��ȡ��������*******************************/
		IMessage repmsg;
		try {
			repmsg = esb.execute(reqmsg);								//���Ͳ���ȡ���ر���
			ICompositeNode body = repmsg.getBody();						// ��ȡ������
			Status status = repmsg.getStatus();							// ��ȡ����״̬��Ϣ

			//��ӡӦ����
			System.out.println("rep msg:Ӧ���� " 	+ repmsg.toXml(true));
			//���سɹ�ʱ�������صĹ���ҵ����Ϣ��������CONSULT_INFO��
			List ls =  new ArrayList();
		//	ls = (List) repmsg.findArrayInResponse ("result",null).plainListValue(); 
			ls = (List) repmsg.findArrayInResponse ("result",null);
			ICompositeNode node;
			if("000000".equals(status.getRetCd())&&ls.size()>0)
			{
				//ɾ���ñʳ��������Ӧ�Ĳ�ѯ�����Ĺ���ҵ�� 
				Sqlca.executeSQL(" delete from CONSULT_INFO where SerialNo='"+sObjectNo+"'");
				//��ȡѭ���������еı�����Ϣ
				//��ȡresponse��ǩ��result��ǩԪ�أ�listValue תΪList����
				
				for(int i=0;i<ls.size();i++)
				{					
					node = (ICompositeNode)ls.get(i);
					sConsultNo = node.get("bussConsNo").toString();
					sMFCustomerID = node.get("custNo").toString();
					sCurrency = node.get("currType").toString();
					sBusinessType = node.get("bussClass").toString();
					dBusinessSum = Double.parseDouble(node.get("amt").toString());
					sRemark = node.get("note").toString();
					sCustName = node.get("custName").toString();
		            
					//����ȡ�Ĺ���ҵ����Ϣ��������
					Sqlca.executeSQL("insert into CONSULT_INFO(SerialNo,CONSULTNO,MFCUSTOMERID,CURRENCY,BUSINESSTYPE,BUSINESSSUM,REMARK,CUSTNAME) "+
							"values('"+sObjectNo+"','"+sConsultNo+"','"+sMFCustomerID+"','"+sCurrency+"','"+sBusinessType+"',"+dBusinessSum+",'"+sRemark+"','"+sCustName+"') ");
				}
				sReturn="0000000";
			}else{
				sReturn="9999999@["+sTradeType+"]����ʧ�ܣ��ÿͻ��ڹ���ϵͳ��û���ҵ���Ӧ��ҵ��";
			}	
			//ESB���ٴ˴�����API
			ESB.getInstance().destory();	
		}catch (MQException mqe) {
			sReturn="9999999@["+sTradeType+"]����ʧ�ܣ������ǽ��չ��ᱨ��ʱ���ӹ��������ʧ�ܣ�����ϵϵͳ����Ա��";
		}catch (Exception e) {
			// TODO Auto-generated catch block
			sReturn="9999999@["+sTradeType+"]����ʧ�ܣ���������װ���ͱ���ʱ���ӹ��������ʧ�ܣ�����ϵϵͳ����Ա��";
			//e.printStackTrace();
		}
		return sReturn;
	}
}
