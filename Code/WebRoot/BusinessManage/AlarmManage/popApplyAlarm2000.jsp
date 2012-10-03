<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: xhyong 2011/09/30
 * Tester:
 *
 * Content: 
 *          Ԥ������-���룭2000-������Ƿ����Ԥ���ź�
 *           
 * Input Param:
 *      altsce:			��Session��ץȡԤ������
 *      sModelNo:		��requst�л�ȡ��ǰ�����ģ�ͱ��
 *      
 * Output param:
 *      ReturnValue:    Ԥ����鴦��ͨ������'$'�ָǰ��λ���ִ���ʽ��ţ�����ʾ�ַ���
 * History Log:  mjliu 2011-2-16 �رշ��ն�̽�⣬���䵥����Ϊһ������
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.math.BigDecimal" %>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%
	//�������
	String sResult="";
	String sTip="У��ͨ����";
	String sDealMethod="99";
	String sSql = "";//��ѯ���
	StringBuffer sbTips = new StringBuffer("");	
	String sAuditDate = "";
	String sEvalDate = "";
	String sEffectStartDate ="";
	String sEffectFinishDate = "";
	String sAuditOrgType = "";
	String sExistFlag = "";
	Date AuditDate=null;
	Date EvalDate=null;
	Date EffectStartDate=null;
	Date EffectFinishDate=null;
	int iCount=0;
	int iCount1=0;
	SimpleDateFormat dd;
	ASResultSet rs = null;
	//��ò���
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//������ʾ	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
		{
			sResult = "10$ģ�ͱ��δָ����";
		}else{
			//��ò���
			String sCustomerID = altsce.getArgValue("CustomerID");	//�ͻ����
			if (sCustomerID == null) sCustomerID = "";
			
			//��ѯ�Ƿ���ڸ�Ԥ���ź�
			sSql = "select 1  " +
					" from Risk_Signal RS"+
					" where ObjectNo = '"+sCustomerID+"' "+
					" and SignalType='01' "+//����
					" and not exists(select 1 from Risk_Signal where RelativeSerialNo=RS.SerialNo ) ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sExistFlag="01";//ֻ���ڽ����ͨ����Ԥ��
			}
			rs.getStatement().close();
			
			//��������ڷ�����ź������Ƿ��н�����ź�
			sSql = "select 1  " +
				" from Risk_Signal "+
				" where ObjectNo = '"+sCustomerID+"' "+
				" and SignalType='02' "+//���
				" and SignalStatus<>'30' ";//����׼
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()&&!"01".equals(sExistFlag))
			{
				sExistFlag="01";//ֻ���ڽ����ͨ����Ԥ��
			}
			rs.getStatement().close();
			
			if("01".equals(sExistFlag))
			{
				sbTips.append("�ÿͻ�����Ԥ���ź�;\n\r");
			}
			//���ò���
			//altsce.setArgValue("CustomerID",sCustomerID);			
		}							
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
