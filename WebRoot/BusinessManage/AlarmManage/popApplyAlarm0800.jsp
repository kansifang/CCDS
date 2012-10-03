<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          Ԥ������-���룭0800����֤�������������
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
	String sCount="";
	String sSql="";
	String sGuarantorID="";	
	String sGuarantorName="";
	String sCustomerType="";
	StringBuffer sbTips = new StringBuffer("");		
	ASResultSet rs=null;
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
			String sApplySerialNo = altsce.getArgValue("ApplySerialNo");
			String sVouchType = altsce.getArgValue("VouchType");
			
			if(sVouchType.length()>=3) 
			{
				//����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤,���ѯ����֤�˿ͻ�����
				if(sVouchType.substring(0,3).equals("010"))
				{
					sSql = 	" select GuarantorID,GuarantorName from GUARANTY_CONTRACT "+
							" where SerialNo in (select ObjectNo from APPLY_RELATIVE "+
							" where SerialNo = '"+sApplySerialNo+"' "+
							" and ObjectType = 'GuarantyContract') "+
							" and GuarantyType like '010%' ";
					rs = Sqlca.getASResultSet(sSql);
		        	while(rs.next())
		        	{
		            	sGuarantorID = rs.getString("GuarantorID");
		            	sGuarantorName = rs.getString("GuarantorName");
		            	sCustomerType=Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sGuarantorID+"'");
		            	if(sCustomerType == null) sCustomerType = "";
		            	//��֤��Ϊ��˾�ͻ�����ͻ�����Ϊ��������ҵ���Ƿ�����ҵ����ҵ��λ����
						if( sCustomerType.equals("0101") || sCustomerType.equals("0102") || sCustomerType.equals("0104") )
						{
							String sTodayMonth = StringFunction.getToday();
							String sBgMonth = String.valueOf(Integer.parseInt(sTodayMonth.substring(0,4),10)-1).concat(sTodayMonth.substring(4,7));
							
							sCount = Sqlca.getString("select count(SerialNo) from EVALUATE_RECORD where ObjectType='Customer' And ObjectNo='"+sGuarantorID+"' And AccountMonth >= '"+sBgMonth+"'");
							if( sCount == null || Integer.parseInt(sCount) <= 0 )
							{
								sbTips.append("��֤��["+sGuarantorName+"]ȱ��һ���ڵ�����������"+"\r\n");
							}
						}					
					}
					rs.getStatement().close();					
				}
			}			
			
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
