package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;

public class AddCLInfoLog extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//�Զ���ô���Ĳ���ֵ	   
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sAction = (String)this.getAttribute("Action");
		String sUserID = (String)this.getAttribute("UserID");
		String sOrgID = (String)this.getAttribute("OrgID");
		
		//��õ�ǰʱ��
	    String sNow = StringFunction.getToday()+" "+StringFunction.getNow();
	    
	    String sSql = "",sLogID = "",sFieldValue = "",sLineID = "";
	    int iColumnCount = 0,iFieldType = 0;
	    ASResultSet rs = null;
	    
	    //-----------------------��һ������¼CL_INFO��Ĳ�����־--------------------------
	    //���ݶ������͵Ĳ�ͬ����¼������־
	    if(sObjectType.equals("CreditApply"))//��ѯ��������Ϣ��Ӧ�ķ�����ϸ��Ϣ
			sSql =  " select * from CL_INFO where ApplySerialNo = '"+sObjectNo+"' ";

	    if(sObjectType.equals("ApproveApply"))//��ѯ���������������Ϣ��Ӧ�ķ�����ϸ��Ϣ 	
			sSql =  " select * from CL_INFO where ApproveSerialNo = '"+sObjectNo+"' ";

	    if(sObjectType.equals("BusinessContract"))//��ѯ��ҵ���ͬ��Ϣ��Ӧ�ķ�����ϸ��Ϣ
			sSql =  " select * from CL_INFO where BCSerialNo = '"+sObjectNo+"' ";

		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		if(rs.next())
		{				
			//��÷�����ϸ��Ϣ��ˮ��
			sLogID = DBFunction.getSerialNo("CL_INFO_LOG","LogID",Sqlca);
			//���뷽����ϸ��Ϣ
			sSql = " insert into CL_INFO_LOG values('"+sLogID+"'";
			for(int i=1;i<= iColumnCount;i++)
			{					
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}					
			}
			sSql= sSql + ",'"+sUserID+"','"+sOrgID+"','"+sNow+"','"+sAction+"','"+sObjectType+"')";
			Sqlca.executeSQL(sSql);	   
			
			//������Ŷ�ȱ��
			sLineID = rs.getString("LineID");
		}  
		rs.getStatement().close();
		
		//-----------------------�ڶ�������¼CL_LIMITATION��Ĳ�����־--------------------------
		sSql = " select * from CL_LIMITATION where LineID = '"+sLineID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		
		while(rs.next())
		{
			//��÷�����������ˮ��
			sLogID = DBFunction.getSerialNo("CL_LIMITATION_LOG","LogID",Sqlca);
			//���뷽����ϸ��Ϣ
			sSql = " insert into CL_LIMITATION_LOG values('"+sLogID+"'";
			for(int i=1;i<= iColumnCount;i++)
			{					
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}				
			}
			sSql= sSql + ",'"+sUserID+"','"+sOrgID+"','"+sNow+"','"+sAction+"','"+sObjectType+"')";
			
			Sqlca.executeSQL(sSql);	 
		}
		rs.getStatement().close();
		
		//-----------------------����������¼CL_LIMITATION_SET��Ĳ�����־--------------------------
		sSql = " select * from CL_LIMITATION_SET where LineID = '"+sLineID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		iColumnCount = rs.getColumnCount();
		while(rs.next())
		{
			//��÷�����������ˮ��
			sLogID = DBFunction.getSerialNo("CL_LIMITATION_SET_LOG","LogID",Sqlca);
			//���뷽����ϸ��Ϣ
			sSql = " insert into CL_LIMITATION_SET_LOG values('"+sLogID+"'";
			for(int i=1;i<= iColumnCount;i++)
			{					
				sFieldValue = rs.getString(i);
				iFieldType = rs.getColumnType(i);
				if (isNumeric(iFieldType))					
				{
					if (sFieldValue == null) sFieldValue = "0";
					sSql=sSql +","+sFieldValue;
				}else {
					if (sFieldValue == null) sFieldValue = "";
					sSql=sSql +",'"+sFieldValue +"'";
				}					
			}
			sSql= sSql + ",'"+sUserID+"','"+sOrgID+"','"+sNow+"','"+sAction+"','"+sObjectType+"')";
			Sqlca.executeSQL(sSql);	 
		}
		rs.getStatement().close();
	    	
		return "1";
	}
    
	//�ж��ֶ������Ƿ�Ϊ��������,����integer����lpzhang
	private static boolean isNumeric(int iType) 
	{
		if (iType==java.sql.Types.BIGINT || iType==java.sql.Types.SMALLINT || iType==java.sql.Types.DECIMAL || iType==java.sql.Types.NUMERIC || iType==java.sql.Types.DOUBLE || iType==java.sql.Types.FLOAT ||iType==java.sql.Types.REAL ||iType==java.sql.Types.INTEGER)
			return true;
		return false;
	}
}
