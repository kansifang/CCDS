<%
/*  This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: lpzhang 2009-8-19 
 * Tester:
 *
 * Content: 
 *         �Խ����ͼ���,(������������������������ŷ����������ݼ������ŷ����޶�
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
	double dReturn =0.0 ,dTotalSum =0.0,dRiskSum = 0.0,dEvaluateScore=0.0;
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
		    
		    AmarInterpreter interpreter = new AmarInterpreter();
		    
			String JTCustomerID ="",sGroupOwnType="";
			String sSql = " select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"' "+
				          " and RelationShip ='0401' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				JTCustomerID = rs.getString("CustomerID");
				if(JTCustomerID == null) JTCustomerID ="";
			}
			rs.getStatement().close();
			//��������
			sGroupOwnType = Sqlca.getString("select GroupType  from ENT_INFO where CustomerID ='"+JTCustomerID+"'");
			if(sGroupOwnType==null) sGroupOwnType="";
			
			if(!JTCustomerID.equals("") && sGroupOwnType.equals("010"))//���ڽ����ͼ���
			{
				//�������ŷ����޶�
				sSql = " select EvaluateScore,AccountMonth from EVALUATE_RECORD where "+
					   " ObjectType ='CustomerLimit' and ObjectNo ='"+sCustomerID+"' order by SerialNo desc " +
					   " fetch first 1 rows only";
				
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{
					//���һ�ڷ��������޶�
					dEvaluateScore = rs.getDouble("EvaluateScore");
					sAccountMonth = rs.getString("AccountMonth");//����·�
				
					//���ų�Ա
					sSql ="select RelativeID from Customer_Relative where CustomerID = "+
						 "(select CustomerID from Customer_Relative where RelativeID = '"+sCustomerID+"' and RelationShip ='0401') and  RelationShip ='0401'";
					rs1 = Sqlca.getASResultSet(sSql);
					while(rs1.next())
					{
						sRelativeID = rs1.getString("RelativeID");
						Anything aReturn =  interpreter.explain(Sqlca,"!CustomerManage.ComputeRiskGross("+sRelativeID+")");
						dReturn = aReturn.doubleValue();
						dTotalSum += dReturn;//�������ŷ�������
					}
					rs1.getStatement().close();
				
					//�������ŷ�������
					Anything aReturn1 =  interpreter.explain(Sqlca,"!�������ܼ��.���������������("+sSerialNo+")");
					dRiskSum = aReturn1.doubleValue();
					//������������������������ŷ�������
					dTotalSum =dTotalSum+dRiskSum;
					
					if(dTotalSum>dEvaluateScore)
					{
						sDealMethod = "10";
						sbTips.append("�����������ŷ����޶���������ŷ����޶����·�Ϊ��"+sAccountMonth+"��"+"\r\n");
					}else
					{
						sDealMethod = "99";
						sbTips.append("У��ͨ�������������ŷ����޶����·�Ϊ��"+sAccountMonth+"��"+"\r\n");
					}
					
				}else
				{
					sDealMethod = "10";
					sbTips.append("û�жԸü������ŷ����޶���в��㣡"+"\r\n");
				}
				rs.getStatement().close();
				
			}	
			
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
