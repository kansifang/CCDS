<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          Ԥ������-���룭0500����֤�˿ͻ���Ϣ�����Լ��
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
	String sSql="";
	String sGuarantorID="";
	String sGuarantorName="";
	String sCustomerType="";
	StringBuffer sbTips = new StringBuffer("");	
	boolean bContinue = true;
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
		            	//���ݲ�ѯ�ó��ı�֤�˿ͻ����룬��ѯ���ǵĿͻ��ſ��Ƿ�¼������
		            	if (sCustomerType.substring(0,2).equals("01")) //��˾�ͻ�
							sSql =  " select Count(CustomerID) from ENT_INFO "+
									" where CustomerID = '"+sGuarantorID+"' "+
									" and TempSaveFlag = '1' ";
		            	if (sCustomerType.substring(0,2).equals("03")) //��ظ���
		            		sSql =  " select Count(CustomerID) from IND_INFO "+
		            				" where CustomerID = '"+sGuarantorID+"' "+
		            				" and TempSaveFlag = '1' ";
		            	
						sCount = Sqlca.getString(sSql);
						if( sCount == null || Integer.parseInt(sCount) <= 0 )
						{												
						}else
						{
						 	sbTips.append("��֤��["+sGuarantorName+"]�Ŀͻ��ſ���Ϣ¼�벻������\n\r");
						 	bContinue = false;
						}
						
						if( bContinue )
						{
							sCount = null;
							//�����˿ͻ�����Ϊ����˾�ͻ��ġ����߹���Ϣ�б����з��˴�����Ϣ
							if( sCustomerType.substring(0,2).equals("01") )
							{
								sCount = Sqlca.getString("select count(CustomerID) from CUSTOMER_RELATIVE where Relationship='0100' and CustomerID='"+sGuarantorID+"'");
								if( sCount == null || Integer.parseInt(sCount) <= 0 )
									sbTips.append("��֤��["+sGuarantorName+"]�ĸ߹���Ϣ��ȱ�ٷ��˴�����Ϣ��"+"\r\n");
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