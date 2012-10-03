package com.amarsoft.app.lending.bizlets;
/*
Author: --王业罡 2005-08-03
Tester:
Describe: --检查调查报告是否生成
Input Param:
		sObjectType：对象类型
		sObjectNo：对象编号
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
		//自动获得传入的参数值
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
			return "alert('调查报告还未生成,无调查报告详细信息！')";
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
	    if (sFlag == "false") return "alert('调查报告还未生成,无调查报告详细信息！')";
	    return "OpenPage('/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&FrameName=TabContentFrame','TabContentFrame','')";
	 }
}
