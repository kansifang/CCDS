<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          Ԥ������-�ͻ���0400�����õȼ�����
 *           
 * Input Param:
 *      altsce:			��Session��ץȡԤ������
 *      sModelNo:		��requst�л�ȡ��ǰ�����ģ�ͱ��
 *      
 * Output param:
 *      ReturnValue:    Ԥ����鴦��ͨ������'$'�ָǰ��λ���ִ���ʽ��ţ�����ʾ�ַ���
 * History Log:  
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.math.BigDecimal" %>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//�������
	String sResult="";
	String sTip="У��ͨ����";
	String sDealMethod="99";
	StringBuffer sbTips = new StringBuffer("");
	
	//��ò���
	String sModelNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//������ʾ	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
			sResult = "10$ģ�ͱ��δָ����";
		else
		{
			//��ò���
			String sCustomerID = altsce.getArgValue("CustomerID");
			String sSql = " select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
			String sCustomerType = Sqlca.getString(sSql);
			if (sCustomerType == null) sCustomerType = "";	
			
			String sCount = "";//��¼��	
			// ������Ϊ��˾�ͻ�����ͻ�����Ϊ��������ҵ���Ƿ�����ҵ����ҵ��λ����
			if( sCustomerType.equals("0101") || sCustomerType.equals("0102") || sCustomerType.equals("0104") )
			{
				String sTodayMonth = StringFunction.getToday();
				String sBgMonth = String.valueOf(Integer.parseInt(sTodayMonth.substring(0,4),10)-1).concat(sTodayMonth.substring(4,7));
				
				sCount = Sqlca.getString("select count(SerialNo) from EVALUATE_RECORD where ObjectType='Customer' And ObjectNo='"+sCustomerID+"' And AccountMonth >= '"+sBgMonth+"'");
				if( sCount == null || Integer.parseInt(sCount) <= 0 )
				{
					sbTips.append("�ÿͻ�ȱ��һ���ڵ�����������"+"\r\n");
				}
			}
		}
				
		//���ò���
		//altsce.setArgValue("ApplyNo",sObjectNo);
		
		if( sbTips.length() > 0 )
		{
			sTip = SpecialTools.real2Amarsoft(sbTips.toString());		
			sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
		}
		//��¼��־
		//���ݷ��ؽ�����жϳɹ���񣬲�����DealMethod�ж��Ƿ���
		altsce.writeAlarmLog(sModelNo,sTip,sDealMethod,Sqlca);
		
		//���÷���ֵ
		sResult = sDealMethod+"$"+sTip;
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