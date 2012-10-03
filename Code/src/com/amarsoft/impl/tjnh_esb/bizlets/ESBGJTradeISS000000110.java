package com.amarsoft.impl.tjnh_esb.bizlets;


import spc.webos.data.CompositeNode;
import spc.webos.data.ICompositeNode;
import spc.webos.data.IMessage;
import spc.webos.data.Status;
import spc.webos.endpoint.ESB;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * ISS000000110����ȡ��
 * @author hldu
 * ���� credAcctSeq-�Ŵ�������ˮ��
 * ���� flag-��־ 0-���ɹ�,1-�ɹ�
 */
public class ESBGJTradeISS000000110 implements ESBGJTradeInterface {
	public String runESBGJTrade(String sObjectNo,String sObjectType,String sTradeType,Transaction Sqlca,String sTradeDate){
	
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		if(sTradeType.equals("")) sTradeType = "ISS000000110";
		//�������
		String sReturn = "";         //����ķ��ز���
		String sSql = "";			 //sql ���
		String sBPSerialNo = "";	 //�Ŵ�������ˮ��
		String sFlag = "";			 //�ɹ�ʧ�ܱ�־0-���ɹ�,1-�ɹ�
		String sMessage="";			 //���ر�����Ϣ
		ASResultSet rs = null;		 //sql�α�
		String sContractSerialNo = ""; //��ͬ��ˮ��
		
		/******************************��ȡ��������***********************************/
		sSql = " select BP.SerialNo as BPSerialNo,BP.ContractSerialNo " +
				" from BUSINESS_PUTOUT BP" +
				" where BP.SerialNo='"+sObjectNo+"' ";
		try{
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next())
		{ 
			sBPSerialNo = rs.getString("BPSerialNo");
			sContractSerialNo = rs.getString("ContractSerialNo");
		}
		rs.getStatement().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		/*****************************����������**************************************/
		ESB esb = ESB.getInstance();
		spc.webos.data.Message reqmsg = esb.newMessage(); // ����һ���ձ���
		// ��������������������
		reqmsg.setMsgCd(sTradeType); 	// ���ô˴�����ķ����ı��(����)
		reqmsg.setRcvAppCd("ISS");		//	���ô˴�����Ľ���ϵͳ��ţ����裩
		reqmsg.setCallType ("SYN");		//	 ���÷�ʽSYN ��ʾͬ������
		//��������
		reqmsg.setInRequest("credAcctSeq",sBPSerialNo);   //�Ŵ�������ˮ��
		//��ӡ������
		System.out.println("req msg:������"   + reqmsg.toXml(true));
		
		/******************************��ȡ��������*******************************/
		IMessage repmsg;
		try {
			repmsg = esb.execute(reqmsg);
			ICompositeNode body = repmsg.getBody();	// ��ȡ������
			Status status = repmsg.getStatus();	
			sMessage=status.getDesc();
			ICompositeNode response = repmsg.getResponse();
			System.out.println("rep msg:Ӧ����"   + repmsg.toXml(true));
			sFlag =response.get("flag").toString();
			if(sFlag.equals("1"))
			{
				//���Ϊ��ѭ����ͬ��ȡ����ͬ�鵵��
				Sqlca.executeSQL("Update BUSINESS_CONTRACT set PigeonholeDate=null where SerialNo='"+sContractSerialNo+"' and (CycleFlag <>'1' or CycleFlag is null) and PigeonholeDate is not null");
				//�÷��ͱ�ʾΪ9
				Sqlca.executeSQL(sSql=" Update BUSINESS_PUTOUT set SendFlag='9' where SerialNo='"+sObjectNo+"'" );
				sReturn="0000000";
			}
			else
			{
				sReturn="["+sMessage+"]@["+sTradeType+"]����ʧ�ܣ��ÿͻ��ڹ���ϵͳ��û���ҵ���Ӧ��ҵ��";
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

		ESB.getInstance().destory();

		return sReturn;
	}
}
