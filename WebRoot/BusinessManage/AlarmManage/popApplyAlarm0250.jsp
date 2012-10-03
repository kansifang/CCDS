<%
/*  This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: lpzhang 2009-8-19 
 * Tester:
 *
 * Content: 
 *         ������֮���ն�������Ϣ
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
	StringBuffer sbTips = new StringBuffer("");			
	ASResultSet rs = null;
	double dRiskEvaluate = 0.0;
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
			String sSerialNo = altsce.getArgValue("SerialNo");	//������
			//��ѯ���ն�
			String sSql = " select RiskEvaluate from Risk_Evaluate where ObjectNo = '"+sSerialNo+"' and ObjectType ='CreditApply' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				dRiskEvaluate = rs.getDouble("RiskEvaluate");
				sbTips.append("�ñ�ҵ����з��ն�Ϊ��"+dRiskEvaluate+"\r\n");
				sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
				sTip = SpecialTools.real2Amarsoft(sbTips.toString());	
				if( sbTips.length() > 0 )
				{
					sDealMethod = "81";
					sTip = SpecialTools.real2Amarsoft(sbTips.toString());	
				}
				
			}else
			{
				sbTips.append("û�жԸñ�ҵ����з��ն�������"+"\r\n");
				if( sbTips.length() > 0 )
				{
					sDealMethod = altsce.getModelAttribute(sModelNo,"DealMethod");
					sTip = SpecialTools.real2Amarsoft(sbTips.toString());	
				}
			}
			rs.getStatement().close();
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
