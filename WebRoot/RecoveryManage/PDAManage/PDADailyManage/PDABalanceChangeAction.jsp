<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   FSGong 2004-12-16
 * Tester:
 *
 * Content:  ���ڵ�ծ�ʲ����ı䶯������������ʲ������
 * Input Param:
 *		SerialNo���ʲ���ˮ�� 
 * 		Interval_Value���䶯���Ĳ���Ϊ���ܺ����޸ĵ����������ı䶯��ֵ���ܲ��Ǳ䶯��
 *		ChangeType���䶯����
 * Output param		
 *		���䶯���ͣ�����ͳ��ۣ�BalanceChangeType
 *		�ʲ������ʲ����y=�ʲ����е�����a-�䶯���б䶯���b.
 *		���ʽ�����b>0;otherwise b<0.
 *
 * History Log:  
 *	      
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%
	String sSerialNo = DataConvert.toRealString(iPostChange,request.getParameter("SerialNo")); //�ʲ���ˮ��
	String sInterval_Value = DataConvert.toRealString(iPostChange,request.getParameter("Interval_Value")); //��Ҫ�䶯��ֵ:�з���!
	String sChangeType = DataConvert.toRealString(iPostChange,request.getParameter("ChangeType")); //�䶯����
	String sSql = "";

	Double vInterval_Value = new Double(sInterval_Value);	 
	String  sAssetBalance = "0";
	String  sOutNowBalance = "0";
	String  sFlag = "0";
	double vValue = 0.0;
	ASResultSet rs = null;

	sSql = " select AssetBalance,OutNowBalance,Flag from ASSET_INFO where SerialNo = '"+sSerialNo+"' and AssetAttribute = '01' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
	   	sAssetBalance = DataConvert.toString(rs.getString("AssetBalance"));	   	
		if((sAssetBalance == null) || (sAssetBalance.equals(""))) sAssetBalance = "0"; 
	   	sOutNowBalance = DataConvert.toString(rs.getString("OutNowBalance"));	   	
		if ((sOutNowBalance == null) || (sOutNowBalance.equals(""))) sOutNowBalance = "0"; 
	   	sFlag = DataConvert.toString(rs.getString("Flag"));	   	
		if ((sFlag == null) || (sFlag.equals(""))) sFlag = "010";  //������������ܳ���
	}
	rs.getStatement().close(); 

	Double vAssetBalance = new Double(sAssetBalance); 
	Double vOutNowBalance = new Double(sOutNowBalance); 
	
	if (sChangeType.equals("020")) //����
	{
		if (sFlag.equals("010") )//����
		{
			vValue = vAssetBalance.doubleValue() + vInterval_Value.doubleValue();  //�������.
		}else
		{
			vValue = vOutNowBalance.doubleValue() + vInterval_Value.doubleValue();  //�������.
		}
	}else  //����
	{
		if (sFlag.equals("010")) //����
		{
			vValue = vAssetBalance.doubleValue() - vInterval_Value.doubleValue();  //�������.
		}else
		{
			vValue = vOutNowBalance.doubleValue() - vInterval_Value.doubleValue();  //�������.
		}
	};

	if (sFlag.equals("010") )//����
	{
	    sSql = " UPDATE ASSET_INFO  SET AssetBalance = "+vValue+" WHERE  SerialNo = '"+sSerialNo+"' and AssetAttribute = '01' ";
	}else
	{
	    sSql = " UPDATE ASSET_INFO  SET OutNowBalance = "+vValue+" WHERE  SerialNo = '"+sSerialNo+"' and AssetAttribute = '01' ";
	}	
    Sqlca.executeSQL(sSql);
%>


<script language=javascript>
    self.returnValue = "<%=vValue%>";
    self.close();    
</script>


<%@ include file="/IncludeEnd.jsp"%>
