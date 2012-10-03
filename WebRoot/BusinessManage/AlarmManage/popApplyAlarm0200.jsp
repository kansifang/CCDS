<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          Ԥ������-���룭0200������������Ҫ������ʽ���ͷ��յ������Ƿ�ͷ���ҵ��
 *           
 * Input Param:
 *      altsce:			��Session��ץȡԤ������
 *      sModelNo:		��requst�л�ȡ��ǰ�����ģ�ͱ��
 *      
 * Output param:
 *      ReturnValue:    Ԥ����鴦��ͨ������'$'�ָǰ��λ���ִ���ʽ��ţ�����ʾ�ַ���
 * History Log:  lpzhang 2009-8-19 ����������ʽ���
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
	StringBuffer sbTips = new StringBuffer("");		
	//��ò���
	String sModelNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//������ʾ	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
			sResult = "10$ģ�ͱ��δָ����";
		else{
			//��ò���u
			String sApplySerialNo = altsce.getArgValue("ApplySerialNo");
			String sBusinessType = altsce.getArgValue("BusinessType");
			String sVouchType = altsce.getArgValue("VouchType");
			System.out.println("sApplySerialNo:"+sApplySerialNo+"sVouchType:"+sVouchType);
			if(sVouchType.length()>=3) {
				//����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤,�������뱣֤������Ϣ
				if(sVouchType.substring(0,3).equals("010") && !sVouchType.equals("0105080"))
				{
					//��鵣����ͬ��Ϣ���Ƿ���ڱ�֤����
					sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
							" from APPLY_RELATIVE where SerialNo='"+sApplySerialNo+"' and ObjectType = 'GuarantyContract') "+
							" and GuarantyType like '010%' having count(SerialNo) > 0 ";
					sCount = Sqlca.getString(sSql);
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("������Ϣ����Ҫ������ʽΪ��֤����û�������뱣֤�йصĵ�����Ϣ��\n\r");						
					}					
				}
				
				//����ҵ�������Ϣ�е���Ҫ������ʽΪ��Ѻ,���������Ѻ������Ϣ�����һ���Ҫ����Ӧ�ĵ�Ѻ����Ϣ
				if(sVouchType.substring(0,3).equals("020"))	{
					//��鵣����ͬ��Ϣ���Ƿ���ڵ�Ѻ����
					sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
							" from APPLY_RELATIVE where SerialNo='"+sApplySerialNo+"' and ObjectType = 'GuarantyContract') "+
							" and GuarantyType like '050%' ";
					
					sCount = Sqlca.getString(sSql);
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("������Ϣ����Ҫ������ʽΪ��Ѻ����û���������Ѻ�йصĵ�����Ϣ��\n\r");						
					}else 
					{							
						sSql = 	" select GuarantyID,GuarantyRate,EvalMethod,GuarantyType from GUARANTY_INFO where GuarantyID in (Select GuarantyID "+
								" from GUARANTY_RELATIVE where ObjectType = 'CreditApply' and ObjectNo = '"+sApplySerialNo+"') "+
								" and GuarantyType like '010%' ";
						ASResultSet rs  = Sqlca.getASResultSet(sSql);
						int iCount = 0;
						while(rs.next()){
							double dGuarantyRate = rs.getDouble("GuarantyRate");
							String sEvalMethod = rs.getString("EvalMethod");
							if(sEvalMethod == null) sEvalMethod = "";
							String sGuarantyType = rs.getString("GuarantyType");
							if(sGuarantyType == null) sGuarantyType = "";
							if("01".equals(sEvalMethod) && "1050020".equals(sBusinessType) && "010020".equals(sGuarantyType) ){
								if(dGuarantyRate > 50 )
									sbTips.append("ҵ��Ϊ���ش��������Ѻ���صĵ�Ѻ�ʲ��ܴ���50%��\n\r");
									iCount++;	
									break;	
							}
							else{
								if(dGuarantyRate>70){
									sbTips.append("��Ѻ����Ϣ�еĵ�Ѻ�ʲ����д���70%�ĵ�Ѻ�\n\r");
									iCount++;	
									break;
								}
							}
							iCount++;
						}
						rs.close();
						if(iCount < 1 )
						{
							sbTips.append("������Ϣ����Ҫ������ʽΪ��Ѻ��������ĵ�Ѻ������Ϣû�е�Ѻ����Ϣ��\n\r");						
						}
												
					}												
				}
				
				//����ҵ�������Ϣ�е���Ҫ������ʽΪ��Ѻ,����������Ѻ������Ϣ�����һ���Ҫ����Ӧ��������Ϣ
				if(sVouchType.substring(0,3).equals("040"))	{
					//��鵣����ͬ��Ϣ���Ƿ������Ѻ����
					sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
							" from APPLY_RELATIVE where SerialNo='"+sApplySerialNo+"' and ObjectType = 'GuarantyContract') "+
							" and GuarantyType like '060%' ";
					sCount = Sqlca.getString(sSql);
					if( sCount == null || Integer.parseInt(sCount) <= 0 )
					{
						sbTips.append("������Ϣ����Ҫ������ʽΪ��Ѻ����û����������Ѻ�йصĵ�����Ϣ��\n\r");						
					}else 
					{
						sSql = 	" select count(GuarantyID) from GUARANTY_INFO where GuarantyID in (Select GuarantyID "+
								" from GUARANTY_RELATIVE where ObjectType = 'CreditApply' and ObjectNo = '"+sApplySerialNo+"') "+
								" and GuarantyType like '020%' ";
						sCount = Sqlca.getString(sSql);
						if( sCount == null || Integer.parseInt(sCount) <= 0 )
						{
							sbTips.append("������Ϣ����Ҫ������ʽΪ��Ѻ�����������Ѻ������Ϣû��������Ϣ��\n\r");						
						}							
					}						
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
