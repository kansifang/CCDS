<%@ page contentType="text/html; charset=GBK"%><%@ include file="/IncludeBeginMDAJAX.jsp"%><%/*
 * Content: ��ȡ��ˮ��
 * Input Param:
 *			����:	TableName
 *			����:	ColumnName
 			��ʽ��	SerialNoFormate
 * Output param:
 *		  ��ˮ��:	SerialNo
 *
 */
	//��ȡ�����������͸�ʽ
	String	sTableName		 = DataConvert.toRealString(iPostChange,(String)request.getParameter("TableName"));
	String	sColumnName 	 = DataConvert.toRealString(iPostChange,(String)request.getParameter("ColumnName"));
	String	sSerialNoFormate = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNoFormate"));
	String  sPrefix			 = DataConvert.toRealString(iPostChange,(String)request.getParameter("Prefix"));

	if (sSerialNoFormate == null) sSerialNoFormate="";
	if (sPrefix == null) sPrefix = "";

	String	sSerialNo = ""; //��ˮ��

	if(sSerialNoFormate.equals(""))
	{
		if (sPrefix.equals(""))	sSerialNo = DBFunction.getSerialNo(sTableName,sColumnName,Sqlca);
		else sSerialNo = DBFunction.getSerialNo(sTableName,sColumnName,sPrefix,Sqlca);

	}else
	{
		sSerialNo = DBFunction.getSerialNo(sTableName,sColumnName,sSerialNoFormate,Sqlca);
	}
	out.print(sSerialNo);%><%@ include file="/IncludeEndAJAX.jsp"%>