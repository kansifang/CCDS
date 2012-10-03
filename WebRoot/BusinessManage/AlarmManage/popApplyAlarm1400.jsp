<%
/*  This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: lpzhang 2009-8-21 
 * Tester:
 *
 * Content: 
 *         �Ƿ�Ϊ���⴦��ͻ�
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
	ASResultSet rs = null;
	String sOperateOrgID ="",sCustomerID="";
	double iNum =0.0;
	//��ò���
	String sModelNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//������ʾ	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
			sResult = "10$ģ�ͱ��δָ����";
		else{
		    sCustomerID = altsce.getArgValue("CustomerID");	//�ͻ����
		    
			String sSql = "select count(*) from CUSTOMER_SPECIAL  where SectionType ='70' and CustomerID='"+sCustomerID+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
				iNum = rs.getInt(1);
			
			rs.getStatement().close();
			if(iNum > 0)
			{
				sbTips.append("������ͻ�!"+"\r\n");
			}else
			{
				sbTips.append("��������ͻ�!"+"\r\n");
			}
			
		}
		if( sbTips.length() > 0 )
		{
			sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
			sTip = SpecialTools.real2Amarsoft(sbTips.toString());	
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
