<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          Ԥ������-�ͻ���0100���ͻ���Ϣ�����Լ��
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
	//�������
	String sResult="";
	String sTip="У��ͨ����";
	String sDealMethod="99";
	StringBuffer sbTips = new StringBuffer("");		
	boolean bContinue = true;
	
	//��ò���=
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//������ʾ	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
			sResult = "10$ģ�ͱ��δָ����";
		else{
			//��ò���
			String sCustomerID = altsce.getArgValue("CustomerID");
			if(sCustomerID==null)sCustomerID="";
			String sCustomerType = Sqlca.getString("select CustomerType from Customer_Info where CustomerID='"+sCustomerID+"'");
			if(sCustomerType==null)sCustomerType="";
						
			//�������
			String sMaxAccMonth = "";
			String sCount = "";
			String sTempSaveFlag = "";
			String sCurToday = StringFunction.getToday();
			// �����˿ͻ��ſ�����¼�루�����ֶ������룩
			if( sCustomerType.substring(0,2).equals("03") )
			{
				//������Ϊ���˿ͻ�������ݴ��־�Ƿ�Ϊ��
				sTempSaveFlag = Sqlca.getString("select TempSaveFlag from IND_INFO where CustomerID='"+sCustomerID+"'");
				if(sTempSaveFlag == null) sTempSaveFlag = "";
				if( sTempSaveFlag.equals("1") )
					sbTips.append("�ÿͻ��Ŀͻ��ſ���Ϣ¼�벻������"+"\r\n");
				bContinue = false;
			}else if( sCustomerType.substring(0,2).equals("01") )
			{	
				//������Ϊ���˿ͻ�������ݴ��־�Ƿ�Ϊ��
				sTempSaveFlag = Sqlca.getString("select TempSaveFlag from ENT_INFO where CustomerID='"+sCustomerID+"'");
				if(sTempSaveFlag == null) sTempSaveFlag = "";
				if( sTempSaveFlag.equals("1") )
					sbTips.append("�ÿͻ��Ŀͻ��ſ���Ϣ¼�벻������"+"\r\n");			
			}
			
			if( bContinue )
			{
				sCount = null;
				if( sCustomerType.substring(0,2).equals("01") )
				{
					//�����˿ͻ�����Ϊ����˾�ͻ��ġ����߹���Ϣ�б����з��˴�����Ϣ
					sCount = Sqlca.getString("select count(CustomerID) from CUSTOMER_RELATIVE where Relationship='0100' and CustomerID='"+sCustomerID+"'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{	
						sbTips.append("�ÿͻ��ĸ߹���Ϣ��ȱ�ٷ��˴�����Ϣ��"+"\r\n");
					}	
					//��飺��ʾ��˾�ͻ���Ϣ�ͻ��߹���Ϣ�б���¼��ʵ�ʿ�����
					sCount = Sqlca.getString("select count(CustomerID) from CUSTOMER_RELATIVE where RelationShip = '0109' and CustomerID = '"+sCustomerID+"'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{	
						sbTips.append("�ÿͻ��ĸ߹���Ϣ��ȱ��ʵ�ʿ�������Ϣ��"+"\r\n");
					}
				}					
			}
		}
			
		//���ò���
		//altsce.setArgValue("ApplyNo",sObjectNo);
		
		//��¼��־
		//���ݷ��ؽ�����жϳɹ���񣬲�����DealMethod�ж��Ƿ���
		if( sbTips.length() > 0 ){
			sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
			sTip = SpecialTools.real2Amarsoft(sbTips.toString());
		}
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
