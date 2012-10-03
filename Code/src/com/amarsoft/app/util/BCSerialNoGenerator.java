package com.amarsoft.app.util;
/**
 * ���ũ�Ϻ�ͬ��������
 * ����ͬ��Ź���16λ��[��������] + [�ͻ����] + [��ͬ���] + [����·�]+[��ˮ��]
 *                     5          1           2           4        4
 *
 * Author��lpzhang 2009-8-26
 */


import java.text.DecimalFormat;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;


public class BCSerialNoGenerator {
	
	//���ݿ������������
	private static ASResultSet rs=null;
	private static String sSqlforSerialNo=null;
	
	//�����������
	//���ݿ�����浱�������ˮ��
	private static String sMaxSerialNoFromTable="";
	//������������ˮ��
	private static String sMaxSerialNo="";
	//�ͻ����
	private static String sCustomerBCType="";
	//���Ļ�����
	private static String sMainFrameOrgID="";
	//���Ļ�����ǰ��λ
	private static String sMainOrgIDStr="";
	//��ͬ�������
	private static String sBCType="";
	//��ǰ����
	private static String sCurrentMonth="";
	//��������
	private static String sMonthFromTable="";
	//��������ˮ
	private static String sNewGCSerialNo="";
	
	private static final  String sTableName="OBJECT_MAXSN_BC";

	public static String getBCSerialNo(String sBusinessType,String sCustomerType,String sOrgID,Transaction Sqlca) throws Exception
	{
		sBCType = Sqlca.getString("select Attribute14 from Business_Type where TypeNo = '"+sBusinessType+"'");
		if (sBCType == null||sBCType.equals("")) 
			throw new Exception("��ȡҵ��Ʒ�ֵĺ�ͬ���ʹ�������ϵϵͳ����Ա��");
		
		sMainFrameOrgID = Sqlca.getString("select MainFrameOrgID from Org_Info where OrgID = '"+sOrgID+"'");
		if (sMainFrameOrgID == null||sMainFrameOrgID.equals("")) 
			throw new Exception("��ȡ�����ĺ��Ļ����Ŵ�������ϵϵͳ����Ա��");
		if(sMainFrameOrgID.length()>=5){
			sMainOrgIDStr = sMainFrameOrgID.substring(0,5);
		}else{
			sMainOrgIDStr = sMainFrameOrgID;
			for(int i=sMainFrameOrgID.length();i<5;i++){
				sMainOrgIDStr = "0"+ sMainOrgIDStr;
			}
		}
		if(sCustomerType.startsWith("03"))// ����
		{
			sCustomerBCType="3";
		}else if(sCustomerType.equals("0107")){//ͬҵ
			sCustomerBCType="2";
		}else{
			sCustomerBCType="1";
		}
		
		boolean bOld = Sqlca.conn.getAutoCommit(); 
		try {
			if(bOld)
				Sqlca.conn.setAutoCommit(false);
			
			//�õ���ǰ����
			String TempDate = StringFunction.getToday();
			sCurrentMonth = TempDate.substring(2,4)+TempDate.substring(5,7);
			DecimalFormat decimalformat = new DecimalFormat("0000");
			
			String sSerialIndex = "" , sUpdateSql = "",sInsertSql="",sBeginSerialNo = "";
			
			sSqlforSerialNo = " select MaxSerialNo from "+sTableName+" where MainFrameOrgID = '"+sMainOrgIDStr+"'" +
							  " and CustomerType = '"+sCustomerBCType+"' and BCType = '"+sBCType+"'  with ur";
			rs = Sqlca.getASResultSet(sSqlforSerialNo);
			if(rs.next())
			{
				sMaxSerialNoFromTable = rs.getString("MaxSerialNo");
				if(sMaxSerialNoFromTable == null) sMaxSerialNoFromTable ="";
				
				sMonthFromTable = sMaxSerialNoFromTable.substring(8,12);//���������ˮ��ȡ���·�
				if(sCurrentMonth.equals(sMonthFromTable))
				{
					sSerialIndex = decimalformat.format(Integer.parseInt(sMaxSerialNoFromTable.substring(sMaxSerialNoFromTable.length()-4,sMaxSerialNoFromTable.length())) + 1);
					sMaxSerialNo = sMaxSerialNoFromTable.substring(0,12)+sSerialIndex;
					
					sUpdateSql = " update "+sTableName+"  set MaxSerialNo ='"+sMaxSerialNo + "'" +
								 " where MainFrameOrgID = '"+sMainOrgIDStr+"'" +
								 " and CustomerType = '"+sCustomerBCType+"' and BCType = '"+sBCType+"'  with ur";
					Sqlca.executeSQL(sUpdateSql);
				}else//���·�
				{
					//��ͬ��ǰ12λ�̶���
					sBeginSerialNo = sMainOrgIDStr+sCustomerBCType+sBCType+sCurrentMonth;
					
					sMaxSerialNo = sBeginSerialNo+"0001";
					
					sUpdateSql = " update "+sTableName+"  set  MaxSerialNo ='"+sMaxSerialNo+"'" +
								 " where MainFrameOrgID = '"+sMainOrgIDStr+"'" +
								 " and CustomerType = '"+sCustomerBCType+"' and BCType = '"+sBCType+"' with ur";
					Sqlca.executeSQL(sUpdateSql);
				}
				
			}else{
				
				//��ͬ��ǰ12λ�̶���
				sBeginSerialNo = sMainOrgIDStr+sCustomerBCType+sBCType+sCurrentMonth;
				
				sMaxSerialNo = sBeginSerialNo+"0001";
				
				sInsertSql = " insert into "+sTableName+"(MainFrameOrgID,CustomerType,BCType,MaxSerialNo)" +
							 " values('"+sMainOrgIDStr+"', '"+sCustomerBCType+"', '"+sBCType+"', '"+sMaxSerialNo+"') with ur";
				Sqlca.executeSQL(sInsertSql);
				
			}
			rs.getStatement().close();
			
			Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(bOld);
			
		}catch(Exception e)
		{
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(bOld);
			throw new Exception("������ʧ�ܣ�"+e.getMessage());
		}		
		
		System.out.println("getBCSerialNo(����ȡ���º�ͬ��)..." + sMaxSerialNo);

		return sMaxSerialNo;
	}
	

}
