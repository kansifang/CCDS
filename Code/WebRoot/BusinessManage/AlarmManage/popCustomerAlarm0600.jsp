<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          Ԥ������-�ͻ���0200���������ͻ����
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
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String sResult;
	String sTip="У��ͨ����";
	String sDealMethod="99";
	StringBuffer sbTips = new StringBuffer("");
	String sShowScript=null;
	Any anyResult;
	String sToday = StringFunction.getToday();
	boolean bResult=true;
	boolean bContinue = true;
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
			String sCustomerName = altsce.getArgValue("CustomerName");
			String sCertType = altsce.getArgValue("CertType");
			String sCertID = altsce.getArgValue("CertID");
			
			String sCount = null;
			String[][] ssMatrix = null;
			String sMsg = null;
			int j=0;
			
			//���ÿͻ��Ƿ���ں�������
			sCount = Sqlca.getString("select count(SerialNo) from CUSTOMER_SPECIAL "+
									"where (CustomerID = '"+sCustomerID+"' or CustomerID = '"+sCustomerName+"' "+
									"or (CertType = '"+sCertType+"' and CertID = '"+sCertID+"')) and SectionType = '40' "+
									"and InListStatus='1' and (EndDate >='"+sToday+"' or EndDate is null)" );
			if( sCount != null && Integer.parseInt(sCount,10) > 0  )
			{
				sbTips.append( "���ں������ͻ���"+"\r\n" );
			}
			

			//���ò���
			//altsce.setArgValue("ApplyNo",sObjectNo);

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
