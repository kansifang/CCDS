package com.amarsoft.app.lending.bizlets;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;

public class CheckSaveFlag extends Bizlet
{
	public Object  run(Transaction Sqlca) throws Exception
	{		 
		//��ȡ�������������ͺͶ�����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		
		//��õ�ǰ����
		String sToday = StringFunction.getToday();
		//���ȥ��ͬ��
		
		//�����������ʾ��Ϣ��SQL��䡢��Ʒ���͡��ͻ�����
		String sMessage = "",sSql = "";
		//�����������Ҫ������ʽ���ͻ����롢�����������������
		String sMainTable = "",sRelativeTable = "",sContractSerialNo="",sBCPutOutDate ="",sCycleFlag="";
		double dBusinessSum =0.0,dBPBusinessSum=0.0,dBalance=0.0,dTotalPBSum=0.0;
		//����������ݴ��־,�Ƿ�ͷ���
		String sTempSaveFlag = "";
		//����������������͡��������͡������˴���
		//�����������ѯ�����
		ASResultSet rs = null;			
		
		//���ݶ������ͻ�ȡ�������
		sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) { 
			sMainTable = rs.getString("ObjectTable");
			sRelativeTable = rs.getString("RelativeTable");
			//����ֵת���ɿ��ַ���
			if (sMainTable == null) sMainTable = "";
			if (sRelativeTable == null) sRelativeTable = "";
		}
		rs.getStatement().close();
		
		if (!sMainTable.equals("")) {
			//--------------�������������������Ƿ�ȫ������---------------
			//����Ӧ�Ķ���������л�ȡ����Ʒ���͡�Ʊ����������������
			sSql = 	" select ContractSerialNo,TempSaveFlag,BusinessSum from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			while (rs.next()) { 			
				sTempSaveFlag = rs.getString("TempSaveFlag");	
				sContractSerialNo = rs.getString("ContractSerialNo");
				dBPBusinessSum = rs.getDouble("BusinessSum");
				
				//����ֵת���ɿ��ַ���
				if (sTempSaveFlag == null) sTempSaveFlag = "";	
				if (sContractSerialNo == null) sContractSerialNo = "";	
				if (sTempSaveFlag.equals("1")) {			
					sMessage = "��Ϣ����Ϊ�ݴ�״̬��������д����Ϣ���鲢������水ť��";
												
				}			
			}
			rs.getStatement().close();
		} 
		
		 //--------------�ڶ��������÷ſ�������Ƿ�������ͨ��90����---------------	
		sSql = 	" select BusinessSum,Balance,PutOutDate,CycleFlag "+
				" from Business_Contract where SerialNo = '"+sContractSerialNo+"'";
		rs = Sqlca.getASResultSet(sSql);
		while (rs.next()) { 
			dBusinessSum = rs.getDouble("BusinessSum");	
			dBalance = rs.getDouble("Balance");	
			sBCPutOutDate = rs.getString("PutOutDate");
			sCycleFlag = rs.getString("CycleFlag");
			if(sBCPutOutDate == null) sBCPutOutDate = "";
			if(sCycleFlag == null) sCycleFlag = "";
		}
		rs.getStatement().close();
		
		String FirstPutOutDate = Sqlca.getString(" select PutOutDate from Business_PutOut where ContractSerialNo = '"+sContractSerialNo+"'" +
												 " order by PutOutDate desc fetch first 1 rows only");
		
		Calendar cd = new GregorianCalendar(Integer.parseInt(FirstPutOutDate.substring(0,4)),Integer.parseInt(FirstPutOutDate.substring(5,7)),Integer.parseInt(FirstPutOutDate.substring(8, 10)));
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
		cd.add(Calendar.DATE,-91); //����90��
		String Temp = sdf.format(cd.getTime());
		
		if(Temp.compareTo(FirstPutOutDate)>0)
		{
			sMessage = "90����δ������ҵ������Ŵ����ñ��������ϣ����ܽ��зŴ����룡"+"@";
		}
		
		return sMessage;
	}
		

}
