<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          Ԥ������-�ͻ���0500�������˱�������ҵ����
 *           
 * Input Param:
 *      altsce:			��Session��ץȡԤ������
 *      sModelNo:		��requst�л�ȡ��ǰ�����ģ�ͱ��
 *      
 * Output param:
 *      ReturnValue:    Ԥ����鴦��ͨ������'$'�ָǰ��λ���ִ���ʽ��ţ�����ʾ�ַ���
 * History Log: 
 *		zywei 2007/10/10 �����չ����ʽ��Ϊ��λһ��
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.math.BigDecimal" %>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//�������
	String sResult="";
	String sTip="У��ͨ����";
	StringBuffer sbTips = new StringBuffer("");
	String sDealMethod="99";	
	String sSql="";
	ASResultSet rs=null;
	//��ò���	�Լ�����Ҫ��ȡ
	String sModelNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//������ʾ	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
			sResult = "10$ģ�ͱ��δָ����";
		else{
			//��ò���
			String sCustomerID = altsce.getArgValue("CustomerID");	
			
			//ȫ�з�Χ��	
			sSql = 	" select count(*) from BUSINESS_CONTRACT "+
					" where CustomerID = '"+sCustomerID+"' "+
					" and BusinessType not like '3%' "+
					" and (FinishDate is null "+
					" or FinishDate = '') ";	
			String sCount = Sqlca.getString(sSql);
			if( sCount == null || Integer.parseInt(sCount,10) == 0 )
			{								
			}else
			{
				sbTips.append("��ȫ�з�Χ��δ���������ҵ�������"+sCount+";\n\r");
				sSql = 	" select sum(BusinessSum*getERate(BusinessCurrency,'01',ERateDate)) as BusinessSum, "+
						" sum(Balance*getERate(BusinessCurrency,'01',ERateDate)) as BalanceSum "+
						" from BUSINESS_CONTRACT "+
						" where CustomerID = '"+sCustomerID+"' "+
						" and BusinessType not like '3%' "+
						" and (FinishDate is null "+
						" or FinishDate = '') ";
				rs = Sqlca.getResultSet(sSql);
				if(rs.next())
				{
					String sBusinessSum = rs.getString("BusinessSum");
					String sBalanceSum = rs.getString("BalanceSum");
					if(sBusinessSum == null) sBusinessSum = "0.00";
					if(sBalanceSum == null) sBalanceSum = "0.00";
					sbTips.append("��ȫ�з�Χ��δ���������ҵ�񷢷��ܽ�������ң���"+DataConvert.toMoney(sBusinessSum)+";\n\r");
					sbTips.append("��ȫ�з�Χ��δ���������ҵ������������ң���"+DataConvert.toMoney(sBalanceSum)+";\n\r");
				}
				rs.getStatement().close();
			}
						
			//���ò���
			//altsce.setArgValue("VouchType",sVouchType);
						
			if( sbTips.length() > 0 )
				sTip = SpecialTools.real2Amarsoft(sbTips.toString());

			//��¼��־
			//���ݷ��ؽ�����жϳɹ���񣬲�����DealMethod�ж��Ƿ���
			if( sbTips.length() > 0 ){
				sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
				sTip = SpecialTools.real2Amarsoft(sbTips.toString());
			}
			
			altsce.writeAlarmLog(sModelNo,sTip,sDealMethod,Sqlca);
			
			//���÷���ֵ
			sResult = sDealMethod+"$"+sTip;
		}
	}catch(Exception ea){
		ea.printStackTrace();
		sResult="10$"+ea.getMessage();
	}
%>
<html>
<head>
</head>
<body onkeydown=mykd1 >
	<iframe name="myprint10" width=0% height=0% style="display:none" frameborder=1></iframe>
</body>
</html>

<script language=javascript >
	self.returnValue = "<%=sResult%>";
	self.close();
</script>

<%@ include file="/IncludeEnd.jsp"%>
