<%
/*  This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: lpzhang 2009-8-19 
 * Tester:
 *
 * Content: 
 *        �������+���ʨQ���ŷ����޶�
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
			String sApplySerialNo = altsce.getArgValue("ApplySerialNo");
		   // AmarInterpreter interpreter = new AmarInterpreter();
		   dBusinessSum = Sqlca.getDouble("select nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum from Business_Apply where SerialNo ='"+sApplySerialNo+"'").doubleValue();
		    
		  //ȫ�з�Χ��ҵ�����
			sSql = 	" select sum(nvl(nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate),0)) as Balance from BUSINESS_CONTRACT "+
					" where CustomerID = '"+sCustomerID+"' "+
					" and BusinessType not like '3%' "+
					" and (FinishDate is null "+
					" or FinishDate = '') ";	
		  
		    rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    {
			    dTotalSum = rs.getDouble(1);
		    }
		    rs.getStatement().close();
			
			
			//�����޶�
			sSql1 = " select CognScore from EVALUATE_RECORD R,EVALUATE_CATALOG C "+
			       " where ObjectType = 'CustomerLimit' and ObjectNo = '"+sCustomerID+"'  and R.ModelNo = C.ModelNo  and C.ModelType='080' "+
			       " order by AccountMonth DESC  fetch first 1 rows only";
		    rs = Sqlca.getASResultSet(sSql1);
		    if(rs.next())
	        {
	     	   dRiskSum = rs.getDouble(1)*10000;
	     	   if(dRiskSum < dTotalSum+dBusinessSum)
				 {
					sDealMethod = "10";
					sbTips.append("�������+���ʽ������ŷ����޶�!"+"\r\n");
				 }else
				 {
					sDealMethod = "99";
					sbTips.append("У��ͨ����");
				 }
	        }else
	        {
	        	sDealMethod = "10";
				sbTips.append("δ�Ըÿͻ��������ŷ����޶����!"+"\r\n");
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
