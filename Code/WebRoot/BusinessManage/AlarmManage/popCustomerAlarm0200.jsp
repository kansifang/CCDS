<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          Ԥ������-�ͻ���0200��Ԥ���ͻ����
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
	String sCount="";
	StringBuffer sbTips = new StringBuffer("");
	boolean bResult=true;
	
	//��ò���
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
			
			//���ÿͻ��Ƿ��������Ч��Ԥ����Ϣ
			String sSql = " select count(RS1.SerialNo) from RISK_SIGNAL RS1  "+
						  " where RS1.SerialNo not in (select distinct RS2.RelativeSerialNo "+
						  " from RISK_SIGNAL RS2 "+
						  " where RS2.SignalType='02' "+
						  " and RS2.SignalStatus='30') "+
						  " and RS1.ObjectType = 'Customer' "+
						  " and RS1.ObjectNo = '"+sCustomerID+"' "+
						  " and SignalType = '01' "+
						  " and RS1.SignalStatus='30' ";
			sCount = Sqlca.getString(sSql);
			if( sCount != null && Integer.parseInt(sCount,10) > 0  )
			{
				sbTips.append( "������Ч��Ԥ���źţ�"+"\r\n" );
			}

			//���ò���
			//altsce.setArgValue("ApplyNo",sObjectNo);

			//�����ʩ����Ҫ�޸�����������ֻ��Ҫ��ʾ�Ϳ���
			if( !sDealMethod.equals("99") )
				sDealMethod = "81";
			
			//��¼��־
			//���ݷ��ؽ�����жϳɹ���񣬲�����DealMethod�ж��Ƿ���
			if( sbTips.length() > 0 )
			{
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
