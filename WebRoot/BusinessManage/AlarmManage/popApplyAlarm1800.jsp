<%
/*  This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: lpzhang 2010-4-7 
 * Tester:
 *
 * Content: 
 *        �����ڻ������ʽ����ϡ������������š�ռ����Ͷ�ʶ�ı������ܳ���50%
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
	String sSql="",sSql1="";
	double dBusinessSum =0.0 ,dTotalSum =0.0,dPlanTotalCast = 0.0;
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
			String sApplySerialNo = altsce.getArgValue("ApplySerialNo");
		  
		   dBusinessSum = Sqlca.getDouble("select nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum from Business_Apply where SerialNo ='"+sApplySerialNo+"'").doubleValue();
		    
		  //���ڻ������ʽ���ܶ�
		   sSql =  " SELECT I.ProjectNo as ProjectNo, nvl(I.PlanTotalCast,0)*10000 as PlanTotalCast FROM PROJECT_RELATIVE R, PROJECT_INFO I WHERE R.objecttype = 'CreditApply' AND R.ObjectNo = '"+sApplySerialNo+"' "+
   				   "AND I.ProjectNo = R.ProjectNo ORDER BY R.ProjectNo  fetch first 1 rows only ";
		   rs = Sqlca.getASResultSet(sSql);
		   if(rs.next())
		   {
			   sRelativeID = rs.getString("ProjectNo");
			   dPlanTotalCast = rs.getDouble("PlanTotalCast");
			   if(sRelativeID == null) sRelativeID="";
			   sSql = " select sum(nvl(nvl(InverstBalance,0)*getERate(Currency,'01',''),0)) as InvestTotalSum from PROJECT_FUNDS "+
				      " where ProjectNo = '"+sRelativeID+"' "+
				      " and FundSource = '03' ";
			   rs1 = Sqlca.getASResultSet(sSql);
			   if(rs1.next())
			   {
			   		dTotalSum = rs1.getDouble(1);
		       }
		       rs1.getStatement().close();
		       
		       if(dBusinessSum+dTotalSum > dPlanTotalCast*0.5)
		       {
		    	   sDealMethod = "10";
				   sbTips.append("�����ڻ������������ϡ������������š�ռ����Ͷ�ʶ�ı������ܳ���50%!"+"\r\n");
		       }
			   
		   }
		   rs.getStatement().close();
			
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
