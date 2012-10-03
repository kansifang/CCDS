<%
/*  This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: lpzhang 2010-4-7 
 * Tester:
 *
 * Content: 
 *      ���ڽ����Ϊ���ز�������ҵ�ģ���������ӦΪ���������ϣ����൱�ȼ���������������ʵ��ڶ����������ֽ�����ʾ
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
<%@ page  import="com.amarsoft.script.AmarInterpreter,com.amarsoft.script.Anything"  buffer="64kb"  %>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//�������
	String sResult="",sSerialNo="";
	String sTip="У��ͨ����";
	String sDealMethod="99";
	StringBuffer sbTips = new StringBuffer("");			
	ASResultSet rs = null;ASResultSet rs1 = null;
	String sCustomerID="",sRelativeID = "",sAccountMonth="";
	String sSql="",sSql1="",sLevelInfo="";
	double dBusinessSum =0.0 ,dTotalSum =0.0,dRiskSum = 0.0;
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
		   
		   sLevelInfo = Sqlca.getString("SELECT  LevelInfo FROM ENT_REALTYAUTH  WHERE CustomerID = '"+sCustomerID+"' order by UptoDate desc fetch first 1 rows only ");
		   if(sLevelInfo == null) sLevelInfo ="";
		   
		   if(sLevelInfo.equals(""))
		   {
			   sDealMethod = "81";
			   sbTips.append("�ÿͻ�û��¼�뷿�ز��������!"+"\r\n");
		   }else{
			   if(sLevelInfo.compareTo("030")>0)
			   {
				   sDealMethod = "81";
				   sbTips.append("�ÿͻ����ز����ʵ��ڶ���!"+"\r\n");
			   }
		   }
		   
		   
		}  
		if( sbTips.length() > 0 )
		{
			//sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
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
