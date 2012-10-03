package com.amarsoft.impl.tjnh_esb.bizlets;


import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.PropertyConfigurator;

import spc.webos.data.CompositeNode;
import spc.webos.data.ICompositeNode;
import spc.webos.data.IMessage;
import spc.webos.data.Status;
import spc.webos.endpoint.ESB;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;
import com.amarsoft.impl.tjnh_als.bizlets.MFMessageBuilder;


/**
 * ISS000000100���˽���
 * @author hldu
 * ���� credAcctSeq-�Ŵ�������ˮ��,credCotSeq-�Ŵ���ͬ��ˮ��,amt-���˽��,currType- ���˱���,bussClass-ҵ��Ʒ�֣�bussConsNo-ҵ��ο���
 *	   credNo-����֤���,custNo-���Ŀͻ���,credDate-����֤Ч��,credPerdType-����֤��������,credPerd-����֤Զ������,nvcNo-��Ʊ��
 * ���� flag-��־ 0-���ɹ�,1-�ɹ�
 */
public class ESBGJTradeISS000000100 implements ESBGJTradeInterface {
	public String runESBGJTrade(String sObjectNo,String sObjectType,String sTradeType,Transaction Sqlca,String sTradeDate){

		//��ȡ�������������ڣ����ױ���
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		if(sTradeType.equals("")) sTradeType = "ISS000000100";
		
		//�������
		String sReturn = "" ;						//����ķ���ֵ
		String sSql = "" ;							//sql���
		String sBPSerialNo = "" ;					//�Ŵ�������ˮ��
		String sBCSerialNo = "" ;					//�Ŵ���ͬ��ˮ��
		String sCurrency = "" ;						//���˱���
		String sBusinessType = "" ;					//ҵ��Ʒ��
		String sConsultNo = "";						//ҵ��ο���
		String sOldLCNo = "" ;						//����֤���
		String sMFCustomerID = "" ;					//���Ŀͻ���
		String sBusinessSubType = "" ;				//����֤��������
		String sInvoiceNo = "" ;					//��Ʊ��
		String sFlag="";							//�ɹ�ʧ�ܱ�־0-���ɹ�,1-�ɹ�
		String sOldLCValidDate = "";				//����֤Ч��
		Double dBusinessSum = 0.0;					//���˽��
		Double dContractSum = 0.0;					//���˺�ͬ���
		int iGracePeriod =0;						//����֤Զ������
		ASResultSet rs = null;						//sql�α�
		ASResultSet rs1 = null;						//sql�α�
		String sMessage = "" ;						//����������Ϣ
		String sContractSerialNo = "";				//�Ŵ���ͬ��ˮ��
		Double dPutOutTotalSum =0.0;				//�����ܽ��
		String sIsPigeonholeFlag ="";
		
		/******************************��ȡ��������***********************************/
		sSql = " select BP.SerialNo as BPSerialNo,BC.SerialNo as BCSerialNo,BP.BusinessSum,"+
		        " getBankNo('Currency',BP.BusinessCurrency) as BusinessCurrency,BP.BusinessType,BP.ConsultNo,BC.LCNo,"+
		        " CI.MFCustomerID,BC.OldLCValidDate,BP.ContractSerialNo,"+
				" BC.BusinessSubType,BC.GracePeriod,BC.InvoiceNo,BP.ContractSum"+
				" from BUSINESS_CONTRACT BC,BUSINESS_PUTOUT BP,CUSTOMER_INFO CI" +
				" where BP.SerialNo='"+sObjectNo+"' and BP.CustomerID=CI.CustomerID and BP.ContractSerialNo=BC.SerialNo" ;
		try{
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next())
		{ 
			sBPSerialNo = rs.getString("BPSerialNo");
			sBCSerialNo = rs.getString("BCSerialNo");
			dBusinessSum = rs.getDouble("BusinessSum");
			sCurrency = rs.getString("BusinessCurrency");
			sBusinessType = rs.getString("BusinessType");
			sConsultNo = rs.getString("ConsultNo");
			sOldLCNo = rs.getString("LCNo");
			sMFCustomerID = rs.getString("MFCustomerID");
			sOldLCValidDate = rs.getString("OldLCValidDate");
			sBusinessSubType = rs.getString("BusinessSubType");
			iGracePeriod = rs.getInt("GracePeriod");
			sInvoiceNo = rs.getString("InvoiceNo");
			sContractSerialNo = rs.getString("ContractSerialNo");
			dContractSum=rs.getDouble("ContractSum");
		}
		
		if(sBPSerialNo==null) sBPSerialNo="  ";
		if(sBCSerialNo==null) sBCSerialNo="  ";
		if(sCurrency==null) sCurrency="  ";
		if(sBusinessType==null) sBusinessType="  ";
		if(sConsultNo==null) sConsultNo="  ";
		if(sOldLCNo==null) sOldLCNo="  ";
		if(sMFCustomerID==null) sMFCustomerID="  ";
		if(sBusinessSubType==null) sBusinessSubType="  ";
		if(!sBusinessSubType.equals("01")) sBusinessSubType="02";
		if(sInvoiceNo==null) sInvoiceNo="  ";
		if(sOldLCValidDate==null) sOldLCValidDate="  ";
		if(sContractSerialNo==null) sContractSerialNo="  ";
		
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
		
		rs.getStatement().close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		/*****************************����������**************************************/
		ESB esb = ESB.getInstance();
		spc.webos.data.Message reqmsg = esb.newMessage(); // ����һ���ձ���
		// ��������������������
		reqmsg.setMsgCd(sTradeType);    // ���ô˴�����ķ����ı��(����)
		reqmsg.setRcvAppCd("ISS");		//	���ô˴�����Ľ���ϵͳ��ţ����裩
		reqmsg.setCallType("SYN");		//	 ���÷�ʽSYN ��ʾͬ������
		//��������
		reqmsg.setInRequest("credAcctSeq", sBPSerialNo);        //�Ŵ�������ˮ��
		reqmsg.setInRequest("credCotSeq", sBCSerialNo);         //�Ŵ���ͬ��ˮ��
		reqmsg.setInRequest("amt", dBusinessSum);               //���˽��      
		reqmsg.setInRequest("currType", sCurrency);             //���˱���      
		reqmsg.setInRequest("bussClass", sBusinessType);        //ҵ��Ʒ��      
		reqmsg.setInRequest("bussConsNo", sConsultNo);          //ҵ��ο���    
		reqmsg.setInRequest("credNo", sOldLCNo);                //����֤���    
		reqmsg.setInRequest("custNo", sMFCustomerID);           //���Ŀͻ���    
		reqmsg.setInRequest("credDate", sOldLCValidDate.replace('/', '-'));       //����֤Ч��   
		reqmsg.setInRequest("credPerdType", sBusinessSubType);  //����֤��������
		reqmsg.setInRequest("credPerd", iGracePeriod);          //����֤Զ������
		reqmsg.setInRequest("nvcNo", sInvoiceNo);               //��Ʊ��        
		
		System.out.println("req msg:������ " 	+ reqmsg.toXml(true));
		
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
				Sqlca.executeSQL(" Update BUSINESS_PUTOUT set SendFlag='1' where SerialNo='"+sObjectNo+"'" );
				//���Ϊ��ѭ����ͬ��ֱ�Ӻ�ͬ�鵵��
				if("True".equals(sIsPigeonholeFlag))
				{
					Sqlca.executeSQL("Update BUSINESS_CONTRACT set PigeonholeDate='"+StringFunction.getToday()+"' where SerialNo='"+sContractSerialNo+"' and (CycleFlag is null or CycleFlag = '' or CycleFlag ='2')");
				}
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
