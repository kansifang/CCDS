package com.amarsoft.app.lending.bizlets;
/*
Author: --��ҵ� 2005-08-03
Tester:
Describe: --�����鱨���Ƿ�����
Input Param:
		sObjectType����������
		sObjectNo��������
Output Param:

HistoryLog:
*/
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.MD5;
import com.amarsoft.biz.bizlet.Bizlet;


public class CheckCreditApplyReport extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{
		//�Զ���ô���Ĳ���ֵ
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		if(sObjectType==null)sObjectType="";
		if(sObjectNo==null)sObjectNo="";

		double dBailRatio = 0;
		String sBusinessType ="";
		String sDocID = "";
		String sSql = " select DocID from FORMATDOC_DATA where ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"' ";
		ASResultSet rs = Sqlca.getResultSet(sSql);
		if(rs.next()) sDocID = rs.getString(1);
		rs.getStatement().close();
		
		sSql = " select BusinessType,BailRatio from BUSINESS_APPLY where SerialNo = '"+sObjectNo+"' ";
		rs = Sqlca.getResultSet(sSql);
		if(rs.next())
		{
			sBusinessType = rs.getString(1);
			dBailRatio = rs.getDouble(2);
		}
		rs.getStatement().close();
		if((sDocID == null) || sDocID.equals(""))
		{
			if(dBailRatio == 100) sDocID = "1";
			else if(sBusinessType.equals("1020010") || sBusinessType.equals("1020030")) sDocID = "2";
			else if(sBusinessType.equals("5010")) sDocID = "3";
			else sDocID = "4";
		}

		if (sDocID.length()==1)
		{
			return "alert('���鱨�滹δ����,�޵��鱨����ϸ��Ϣ��')";
		}
		String sFlag = "";
		
		MD5 m = new MD5();
	    String sSerialNoNew = m.getMD5ofStr(sDocID+sObjectNo+sObjectType);
	    String sFileName = "C:/Jboss4/server/default/./deploy/ALS6.war/FormatDoc/WorkDoc/"+sSerialNoNew+".html";
	    java.io.File file = new java.io.File(sFileName);

	    if(file.exists())
		{
			sFlag = "true";
		}
		else
		{
			sFlag = "false";
		}
	    if (sFlag == "false") return "alert('���鱨�滹δ����,�޵��鱨����ϸ��Ϣ��')";
	    return "OpenPage('/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&FrameName=TabContentFrame','TabContentFrame','')";
	 }
}
