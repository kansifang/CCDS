<%
/* Copyright 2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   FSGong 2004-12-16
 * Tester:
 *
 * Content:  ����������ֵõ�������ҵı���(����)��
 * Input Param:
 *	AssetSerialNo	��������� 
 * Output param	���ñ��ֶ�����ҵı���.
 *
 *
 * History Log:  
 *	      
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	String sReclaimCurrency	= DataConvert.toRealString(iPostChange,request.getParameter("ReclaimCurrency")); //�������
	//��ȡReclaimCurrency���ֶ�����ҵĻ���
	String	sSql = "";
	String	sUnit = "";
	String	sPrice = "";
	double	ddUnit = 0;
	double  ddPrice = 0;
	double	dOldCurrencyRatio = 1;  //ReclaimCurrency���ֶ���Ԫ����
	double	dRMBCurrencyRatio = 1;  //����Ҷ���Ԫ����
	double	dCurrencyRatio = 1;  //ReclaimCurrency���ֶ�����ҵĻ���
	ASResultSet rs = null;

	//ReclaimCurrency���ֶ���Ԫ����(???/$)
	sSql = " select Unit,Price,EfficientDate  from ERATE_INFO where  Currency = '"+sReclaimCurrency+"' order by EfficientDate desc ";
	//��������ȡ��һ����¼,��Ϊ�������.
	rs = Sqlca.getASResultSet(sSql);
	if (rs.next())
	{ 
		sUnit = rs.getString(1);	
		sPrice = rs.getString(2);	
		if (sUnit == null || sUnit == "") sUnit = "1";
		if (sPrice == null || sPrice == "") sPrice = "1";

		Double dUnit = new Double(sUnit);	
		Double dPrice = new Double(sPrice);	
		ddUnit = dUnit.doubleValue();
		ddPrice = dPrice.doubleValue();
		if (ddUnit < 0.0001) ddUnit = 1;
		if (ddPrice < 0.0001) ddPrice = 1;
		dOldCurrencyRatio = ddUnit/ddPrice;
	}else
		dOldCurrencyRatio = 1;
	rs.getStatement().close(); 

	//����Ҷ���Ԫ����(RMB/$)
	sSql = " select Unit,Price,EfficientDate  from ERATE_INFO where  Currency = '01' order by EfficientDate desc ";
	//��������ȡ��һ����¼,��Ϊ�������.
	rs = Sqlca.getASResultSet(sSql);
	if (rs.next())
	{ 
		sUnit = rs.getString(1);	
		sPrice = rs.getString(2);	
		if (sUnit == null || sUnit == "") sUnit = "1";
		if (sPrice==null || sPrice=="") sPrice = "1";

		Double dUnit = new Double(sUnit);	
		Double dPrice = new Double(sPrice);	
		ddUnit = dUnit.doubleValue();
		ddPrice = dPrice.doubleValue();
		if (ddUnit < 0.0001) ddUnit = 1;
		if (ddPrice < 0.0001) ddPrice = 1;
		dRMBCurrencyRatio = ddUnit/ddPrice;
	}else
		dRMBCurrencyRatio = 1;
	rs.getStatement().close(); 

	//ReclaimCurrency���ֶ�����ҵĻ���(??/RMB)
	dCurrencyRatio = dOldCurrencyRatio/dRMBCurrencyRatio;
%>			

<script language=javascript>
	var sCurrencyRatio="<%=dCurrencyRatio%>";
	var sReturn=sCurrencyRatio+"@"+sCurrencyRatio;
	self.returnValue=sReturn;
	self.close();    
</script>


<%@ include file="/IncludeEnd.jsp"%>
