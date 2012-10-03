<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          Ԥ������-���룭0100��ҵ��������Ϣ�����Լ��
 *           
 * Input Param:
 *      altsce:			��Session��ץȡԤ������
 *      sModelNo:		��requst�л�ȡ��ǰ�����ģ�ͱ��
 *      
 * Output param:
 *      ReturnValue:    Ԥ����鴦��ͨ������'$'�ָǰ��λ���ִ���ʽ��ţ�����ʾ�ַ���
 * History Log:  lpzhang 2009-8-19 �رշ��ն�̽�⣬���䵥����Ϊһ������
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
	String sCount="",sHasIERight="",sNum="";
	StringBuffer sbTips = new StringBuffer("");	
	boolean bContinue = true;
	double dBusinessSum = 0.0;
	int iBillNum = 0;
	//��ò���
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//������ʾ	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
			sResult = "10$ģ�ͱ��δָ����";
		else{
			//��ò���
			String sApplySerialNo = altsce.getArgValue("ApplySerialNo");
			String sCustomerID = altsce.getArgValue("CustomerID");				
			String sBusinessType = altsce.getArgValue("BusinessType");
			String sOccurType = altsce.getArgValue("OccurType");			
			String sTempSaveFlag = altsce.getArgValue("TempSaveFlag");			
			String sBusinessSum = altsce.getArgValue("BusinessSum");
			String sObjectType = altsce.getArgValue("ObjectType");
			String sApplyType = altsce.getArgValue("ApplyType");
			if(sBusinessSum != null && !sBusinessSum.equals(""))
				dBusinessSum = Double.parseDouble(sBusinessSum);
			String sBillNum = altsce.getArgValue("BillNum");
			if(sBillNum != null && !sBillNum.equals(""))
				iBillNum = Integer.parseInt(sBillNum);
				
			System.out.println("sCustomerID="+sCustomerID);
			System.out.println("sOccurType="+sOccurType);
			//�������			
			//1���ݴ��־Ϊ�������Ƿ�¼�������ļ���־
			if( sTempSaveFlag != null && sTempSaveFlag.equals("1"))
			{
				sbTips.append("���������Ϣ������δ¼��������\n\r");
				bContinue = false;
			}
			
			if( bContinue )
			{
				//��������Ϊչ�ڣ���������չ��ҵ��
				if(sOccurType.equals("015"))
				{
					sCount = Sqlca.getString("select count(SerialNo) from Apply_RELATIVE where SerialNo='"+sApplySerialNo +"' and ObjectType='BusinessDueBill'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("��������Ϊչ�ڣ���������ص�չ��ҵ����Ϣ��\n\r");						
					}
				}
				//��������Ϊ���»��ɣ������������»��ɵ�ҵ��
				if(sOccurType.equals("020"))
				{
					sCount = Sqlca.getString("select count(SerialNo) from Apply_RELATIVE where SerialNo='"+sApplySerialNo +"' and ObjectType='BusinessDueBill'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("��������Ϊ���»��ɣ���������صĽ��»���ҵ����Ϣ��\n\r");						
					}
				}
				System.out.println("3333333");
				//��������Ϊ���ɽ��£������������ɽ��µ�ҵ��
				if(sOccurType.equals("060"))
				{
					sCount = Sqlca.getString("select count(SerialNo) from Apply_RELATIVE where SerialNo='"+sApplySerialNo +"' and ObjectType='BusinessDueBill'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("��������Ϊ���ɽ��£���������صĻ��ɽ���ҵ����Ϣ��\n\r");						
					}
				}
				//��������Ϊ����(����)��������������(����)��ҵ��
				if(sOccurType.equals("065"))
				{
					sCount = Sqlca.getString("select count(SerialNo) from Apply_RELATIVE where SerialNo='"+sApplySerialNo +"' and ObjectType='BusinessDueBill'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("��������Ϊ����(����)����������ص�����(����)ҵ����Ϣ��\n\r");						
					}
				}
				//��������Ϊ�ʲ����飬���������ʲ����鷽��
				if(sOccurType.equals("030"))
				{
					sCount = Sqlca.getString("select count(SerialNo) from Apply_RELATIVE where SerialNo='"+sApplySerialNo +"' and ObjectType='CapitalReform'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("��������Ϊ�ʲ����飬��������ص��ʲ����鷽����Ϣ��\n\r");						
					}
				}
				System.out.println("sBusinessType="+sBusinessType);
				//ҵ��Ʒ��Ϊ��Ŀ������������Ӧ����Ŀ��Ϣ
				if("1030010,1030015,1030020,1030030,1050010,1050020".indexOf(sBusinessType) >-1)
				{					
					sCount = Sqlca.getString("select count(PR.ProjectNo) from PROJECT_RELATIVE PR,BUSINESS_APPLY BA where PR.ObjectNo=BA.SerialNo and PR.ObjectType='CreditApply' and PR.ObjectNo='"+sApplySerialNo +"'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("ҵ��Ʒ��Ϊ��Ŀ������������Ӧ����Ŀ��Ϣ��\n\r");
					}
				}
				//--------------�Ƿ��н����ھ�ӪȨ---------------
		        if (sBusinessType.substring(0, 4).equals("1080"))
		        {
		        	sHasIERight = Sqlca.getString("select HasIERight from ENT_INFO where CustomerID = '"+sCustomerID+"' ");
		        	if(sHasIERight==null) sHasIERight="";
		        	if(sHasIERight.equals("2"))
		        		sbTips.append("ҵ��Ʒ��Ϊ�������ʣ������н����ھ�ӪȨ��\n\r");
		                
		        } 
		        System.out.println("555555555555");
		        
				//���նȼ��
				//remarked by lpzhang 2009-8-19 ���ն���Ϊ����̽����
				/*String sSql = " select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"' ";
				String sCustomerType = Sqlca.getString(sSql);
				if (sCustomerType == null) sCustomerType = "";	
						
				if (sCustomerType.substring(0,2).equals("01")) //��˾�ͻ�
				{
					sCount = Sqlca.getString("select Count(SerialNo) from EVALUATE_RECORD where ObjectType='CreditApply' and ObjectNo='"+sApplySerialNo +"' and EvaluateScore >=0 ");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("�����뻹δ���з��նȲ�����\n\r");
					}
				}
				*/
							
				if (sBusinessType.equals("1080020"))	{
					sCount = Sqlca.getString("select count(SerialNo) from LC_INFO where ObjectType = 'CreditApply' and ObjectNo = '"+sApplySerialNo+"'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("ҵ��Ʒ��Ϊ����֤���´������ҵ��û���������֤��Ϣ��\n\r");
					}					
				}
				
				if(sBusinessType.length()>=4) {
					//�����Ʒ����Ϊ����ҵ��
					if(sBusinessType.substring(0,4).equals("1020"))	{
						sCount = Sqlca.getString("select count(SerialNo) from BILL_INFO  where ObjectType = 'CreditApply' and ObjectNo = '"+sApplySerialNo+"' having sum(BillSum) = "+dBusinessSum+" ");
						if( sCount == null || Integer.parseInt(sCount) <= 0 )
						{
							sbTips.append("ҵ��Ʒ��Ϊ����ҵ��ҵ�����Ʊ�ݽ���ܺͲ�����\n\r");
						}
										
						sCount = Sqlca.getString("select count(SerialNo) from BILL_INFO  where ObjectType = 'CreditApply' and ObjectNo = '"+sApplySerialNo+"' having count(SerialNo) = "+iBillNum+" ");
						if( sCount == null || Integer.parseInt(sCount) <= 0 )
						{
							sbTips.append("ҵ��Ʒ��Ϊ����ҵ��ҵ���������Ʊ�������������Ʊ������������\n\r");
						}									
					}
				}
				
				//��������֤��������������֤Ѻ�������֡���������Ѻ�������֡�������ҵ��Ʊ���ʡ���������֤Ѻ��,����������֤��Ϣ
				if (sBusinessType.equals("1080020") || sBusinessType.equals("1080080") || sBusinessType.equals("1080090") || sBusinessType.equals("1080030") ||sBusinessType.equals("1080035") )	{
					sNum = 	Sqlca.getString(" select count(SerialNo) from LC_INFO where ObjectType = 'CreditApply'  and ObjectNo = '"+sApplySerialNo+"' ");
					if( sNum == null || Integer.parseInt(sNum) <= 0 )
						sbTips.append("��������Ѻ�������֡�������ҵ��Ʊ���ʻ�����֤���ҵ��û���������֤��Ϣ��\n\r");
				}

				if ( sBusinessType.equals("1080010")) {
					sCount = Sqlca.getString("select count(SerialNo) from CONTRACT_INFO where ObjectType = 'CreditApply' and ObjectNo = '"+sApplySerialNo+"'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("���ں�ͬ�������ҵ��û�����ó�׺�ͬ��Ϣ��\n\r");
					}					
				}

				if (sBusinessType.equals("1090020") ||  sBusinessType.equals("1090030")) {
					sCount = Sqlca.getString("select count(SerialNo) from INVOICE_INFO where ObjectType = 'CreditApply' and ObjectNo = '"+sApplySerialNo+"'");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("ҵ��Ʒ��Ϊ���ڱ���ҵ�����ڱ���ҵ��û����ֵ˰��Ʊ��Ϣ��\n\r");
					}					
				}
				//������²������鱨�� add by zrli
				if (!"DependentApply".equals(sApplyType)){
					sCount = Sqlca.getString("select count(SerialNo) from FORMATDOC_DATA where ObjectType='CreditApply' and ObjectNo='"+sApplySerialNo +"' ");
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("�����뻹δ��д���鱨����Ϣ��\n\r");
					}
				}
										
			}
			
			//���ò���
			//altsce.setArgValue("CustomerID",sCustomerID);			
									
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
