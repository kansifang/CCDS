<%
/*  This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: lpzhang 2009-8-19 
 * Tester:
 *
 * Content: 
 *         ���ų�Ա����ҵ���������ύʱ���м�飬�Ƿ�����������������������ڵ��� �����ʱ������15��
 *           
 * Input Param:
 *      altsce:			��Session��ץȡԤ������
 *      sModelNo:		��requst�л�ȡ��ǰ������ģ�ͱ��
 *      
 * Output param:
 *      ReturnValue:    Ԥ����鴦��ͨ������'$'�ָǰ��λ���ִ�����ʽ��ţ�����ʾ�ַ���
 * History Log:
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.math.BigDecimal" %>
<%@ page  import="com.amarsoft.script.AmarInterpreter,com.amarsoft.script.Anything"  buffer="64kb"  %>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//�������
	String sResult="";
	String sTip="У��ͨ����";
	String sDealMethod="99";
	StringBuffer sbTips = new StringBuffer("");			
	ASResultSet rs = null;
	String sOperateOrgID ="",sCustomerID="";
	//��ò���
	String sModelNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//������ʾ	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
			sResult = "10$ģ�ͱ��δָ����";
		else{
			String sSerialNo = altsce.getArgValue("SerialNo");	//������
		    sCustomerID = altsce.getArgValue("CustomerID");	//�ͻ����
			String JTCustomerID ="";
			String sSql = " select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"' "+
				   " and RelationShip ='0401' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				JTCustomerID = rs.getString("CustomerID");
				if(JTCustomerID == null) JTCustomerID ="";
			}
			rs.getStatement().close();
			if(!JTCustomerID.equals(""))
			{
				AmarInterpreter interpreter = new AmarInterpreter();
				Anything aReturn =  interpreter.explain(Sqlca,"!��������.�Ƿ��ʱ���("+sSerialNo+",CreditApply,4)");
				String sReturn = aReturn.stringValue();
				if(sReturn.equals("TRUE"))
				{
					sbTips.append("�ñʴ���������+�����������������ʱ�����ռ��15%��"+"\r\n");
				}
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