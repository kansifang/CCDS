<%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: zxu  2005-06-28
 * Tester:
 *
 * Content: 
 *          Ԥ������-���룭1900�����񱨱����������Ƿ�����Ч��
 *           
 * Input Param:
 *      altsce:			��Session��ץȡԤ������
 *      sModelNo:		��requst�л�ȡ��ǰ�����ģ�ͱ��
 *      
 * Output param:
 *      ReturnValue:    Ԥ����鴦��ͨ������'$'�ָǰ��λ���ִ���ʽ��ţ�����ʾ�ַ���
 * History Log:  mjliu 2011-2-16 �رշ��ն�̽�⣬���䵥����Ϊһ������
 */
%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ page import="java.math.BigDecimal" %>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%
	//�������
	String sResult="";
	String sTip="У��ͨ����";
	String sDealMethod="99";
	String sSql = "";//��ѯ���
	StringBuffer sbTips = new StringBuffer("");	
	String sAuditDate = "";
	String sEvalDate = "";
	String sEffectStartDate ="";
	String sEffectFinishDate = "";
	String sAuditOrgType = "";
	Date AuditDate=null;
	Date EvalDate=null;
	Date EffectStartDate=null;
	Date EffectFinishDate=null;
	int iCount=0;
	int iCount1=0;
	SimpleDateFormat dd;
	ASResultSet rs = null;
	//��ò���
	String sModelNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AlarmModelNo")); 
	if( sModelNo == null ) sModelNo = "";

	//������ʾ	
	try{
		ASAlarmScenario altsce = (ASAlarmScenario)session.getAttribute("CurAlarmSce");

		if( sModelNo.trim().length() == 0 )
		{
			sResult = "10$ģ�ͱ��δָ����";
		}else{
			//��ò���
			String sCustomerID = altsce.getArgValue("CustomerID");	//�ͻ����
			String sApplySerialNo = altsce.getArgValue("ApplySerialNo");//������ˮ��
			if (sCustomerID == null) sCustomerID = "";
			if (sApplySerialNo == null) sApplySerialNo = "";
			
			//���񱨱�����������Ч����֤
			sSql = "select CF.AuditDate as AuditDate,CS.EffectStartDate AS EffectStartDate,CS.EffectFinishDate AS EffectFinishDate,CF.AuditOffice,CF.ReportDate AS ReportDate from CUSTOMER_SPECIAL CS, CUSTOMER_FSRECORD CF where CS.CustomerName=CF.AuditOffice  and AuditFlag='2' and CS.SectionType='60' and CF.CustomerID = '"+sCustomerID+"' ";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next() && iCount<1)
			{
				sAuditDate = rs.getString("AuditDate");
				sEffectStartDate = rs.getString("EffectStartDate");
				sEffectFinishDate = rs.getString("EffectFinishDate");	
				dd=new SimpleDateFormat("yyyy/MM/dd");
				if(sAuditDate==null)
				{
					sbTips.append("���񱨱�ѡ�����Ѳ�����Ч��֮�ڵ��н����;���߲��񱨱�˵��δ��д����;\n\r");
					iCount++;
				}else if(sEffectStartDate!=null && sEffectFinishDate!=null)
				{	
					AuditDate=dd.parse(sAuditDate);
					EffectStartDate=dd.parse(sEffectStartDate);
					EffectFinishDate=dd.parse(sEffectFinishDate);
					if(AuditDate.after(EffectFinishDate)||AuditDate.before(EffectStartDate))
					{
						sbTips.append("���񱨱�ѡ�����Ѳ�����Ч��֮�ڵ��н����;���߲��񱨱�˵��δ��д����;\n\r");
						iCount++;
					}
				}	
			}
			rs.getStatement().close();
			
			//����Ѻ����������Ч����֤
			sSql = "select GI.EvalDate as EvalDate,CS.EffectStartDate AS EffectStartDate,"+
					" CS.EffectFinishDate AS EffectFinishDate  "+
					" from GUARANTY_RELATIVE GR,GUARANTY_INFO GI,CUSTOMER_SPECIAL CS  "+
					" where GR.GuarantyID=GI.GuarantyID  and GR.ObjectType='CreditApply' "+
					" and GI.EvalOrgName=CS.CustomerName and GR.ObjectNo='"+sApplySerialNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next() && iCount1<1)
			{
				sEvalDate = rs.getString("EvalDate");
				sEffectStartDate = rs.getString("EffectStartDate");
				sEffectFinishDate = rs.getString("EffectFinishDate");	
				dd=new SimpleDateFormat("yyyy/MM/dd");
				if(sEffectStartDate!=null && sEffectFinishDate!=null && sEvalDate!=null)
				{	
					EvalDate=dd.parse(sEvalDate);
					EffectStartDate=dd.parse(sEffectStartDate);
					EffectFinishDate=dd.parse(sEffectFinishDate);
					if(EvalDate.after(EffectFinishDate)||EvalDate.before(EffectStartDate))
					{
						sbTips.append("����Ѻ��ѡ�����Ѳ�����Ч��֮�ڵ��н����;\n\r");
						iCount1++;
					}
				}	
			}
			rs.getStatement().close();
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
