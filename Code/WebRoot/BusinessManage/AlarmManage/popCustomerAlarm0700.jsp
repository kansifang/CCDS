<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          Ԥ������-�ͻ���0500����������������ҵ����
 *           
 * Input Param:
 *      altsce:			��Session��ץȡԤ������
 *      sModelNo:		��requst�л�ȡ��ǰ�����ģ�ͱ��
 *      
 * Output param:
 *      ReturnValue:    Ԥ����鴦��ͨ������'$'�ָǰ��λ���ִ���ʽ��ţ�����ʾ�ַ���
 * History Log:  
 *		zywei 2007/10/10 �����չ����ʽ��Ϊ��λһ��
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.math.BigDecimal" %>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//�������
	String sResult="";
	String sTip="У��ͨ����";
	StringBuffer sbTips = new StringBuffer("");
	String sDealMethod="99";	
	String sSql="";
	ASResultSet rs=null;
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
			
			//���з�Χ��	
			sSql = 	" select count(*) from CUSTOMER_OACTIVITY "+
					" where CustomerID = '"+sCustomerID+"' "+					
					" and UptoDate <= '"+StringFunction.getToday()+"' ";	
			String sCount = Sqlca.getString(sSql);
			if( sCount == null || Integer.parseInt(sCount,10) == 0 )
			{								
			}else
			{
				sbTips.append("������δ���������ҵ�������"+sCount+";\n\r");
				sSql = 	" select sum(BusinessSum*getERate(Currency,'01','')) as BusinessSum, "+
						" sum(Balance*getERate(Currency,'01','')) as BalanceSum ,getBusinessName(BUSINESSTYPE) as BusinessType "+
						" from CUSTOMER_OACTIVITY "+
						" where CustomerID = '"+sCustomerID+"' "+
						" and UptoDate <= '"+StringFunction.getToday()+"' group by BusinessType ";
				rs = Sqlca.getResultSet(sSql);
				while(rs.next())
				{
					String sBusinessSum = rs.getString("BusinessSum");
					String sBalanceSum = rs.getString("BalanceSum");
					String sBusinessType = rs.getString("BusinessType");
					if(sBusinessSum == null) sBusinessSum = "0.00";
					if(sBalanceSum == null) sBalanceSum = "0.00";
					sbTips.append("������δ����ġ�"+sBusinessType+"�������ܽ�������ң���"+DataConvert.toMoney(sBusinessSum)+",��������ң���"+DataConvert.toMoney(sBalanceSum)+";\n\r");
				}
				rs.getStatement().close();
			}
						
			//���ò���
			//altsce.setArgValue("VouchType",sVouchType);
						
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
