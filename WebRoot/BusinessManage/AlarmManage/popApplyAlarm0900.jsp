<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          Ԥ������-���룭0900����֤�˱�������ҵ����
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
	String sDealMethod="99";	
	String sCount="";
	String sSql="";
	String sGuarantorID="";	
	String sGuarantorName="";	
	StringBuffer sbTips = new StringBuffer("");		
	ASResultSet rs=null;
	ASResultSet rs1=null;
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
		            	//ȫ�з�Χ��	
						sSql = 	" select count(*) from BUSINESS_CONTRACT "+
								" where CustomerID = '"+sGuarantorID+"' "+
								" and BusinessType not like '3%' "+
								" and (FinishDate is null "+
								" or FinishDate = '') ";	
						sCount = Sqlca.getString(sSql);
						if( sCount != null && Integer.parseInt(sCount,10) > 0 )
						{	
							sbTips.append("��֤��["+sGuarantorName+"]��ȫ�з�Χ��δ���������ҵ�������"+sCount+";\n\r");
							sSql = 	" select sum(BusinessSum*getERate(BusinessCurrency,'01',ERateDate)) as BusinessSum, "+
									" sum(Balance*getERate(BusinessCurrency,'01',ERateDate)) as BalanceSum "+
									" from BUSINESS_CONTRACT "+
									" where CustomerID = '"+sGuarantorID+"' "+
									" and BusinessType not like '3%' "+
									" and (FinishDate is null "+
									" or FinishDate = '') ";
							rs1 = Sqlca.getResultSet(sSql);
							if(rs1.next())
							{
								String sBusinessSum = rs1.getString("BusinessSum");
								String sBalanceSum = rs1.getString("BalanceSum");
								if(sBusinessSum == null) sBusinessSum = "0.00";
								if(sBalanceSum == null) sBalanceSum = "0.00";
								sbTips.append("��֤��["+sGuarantorName+"]��ȫ�з�Χ��δ���������ҵ�񷢷��ܽ�������ң���"+DataConvert.toMoney(sBusinessSum)+";\n\r");
								sbTips.append("��֤��["+sGuarantorName+"]��ȫ�з�Χ��δ���������ҵ������������ң���"+DataConvert.toMoney(sBalanceSum)+";\n\r");
							}
							rs1.getStatement().close();
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
