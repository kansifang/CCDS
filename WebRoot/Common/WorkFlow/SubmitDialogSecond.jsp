<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.workflow.*" %>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
<%
	/*
		Author: byhu 2004-12-06 
		Tester:
		Describe: �ύѡ���
		Input Param:
			SerialNo��������ˮ��
			PhaseOpinion1�����
		Output Param:
		HistoryLog: zywei 2005/08/01	
					cdeng 2009-02-17
					lpzhang 2009-8-14 for TJ
	 */
%>
<%/*~END~*/%> 


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<% 
	//��ȡ������������ˮ�š����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//String sPhaseOpinion1 = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PhaseOpinion1"));
	
	//������������̱�š��׶α�š�������
	String sFlowNo = "",sPhaseNo = "",sObjectNo = "";
	//��������������������б��׶ε����͡�������ʾ���׶ε�����
	String sPhaseAction = "",sActionList[],sSelectStyle = "",sActionDescribe = "",sPhaseAttribute = ""; 
	String sSql="";
	ASResultSet rsTemp = null;
%>
<%/*~END~*/%>	


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=����ҵ���߼�����;]~*/%>
<%
	//���������̱�FLOW_TASK�в�ѯ�����̱�š��׶α��
	sSql = "select FlowNo,PhaseNo from FLOW_TASK where SerialNo = '"+sSerialNo+"' ";
	rsTemp = Sqlca.getASResultSet(sSql);
	if (rsTemp.next())
	{
		sFlowNo  = DataConvert.toString(rsTemp.getString("FlowNo"));
		sPhaseNo  = DataConvert.toString(rsTemp.getString("PhaseNo"));
		
		//����ֵת���ɿ��ַ���
		if(sFlowNo == null) sFlowNo = "";
		if(sPhaseNo == null) sPhaseNo = "";				
	}
	rsTemp.getStatement().close();
	
	System.out.println("sFlowNO:"+sFlowNo+"%sPhaseNo:"+sPhaseNo);
	
	//������ģ�ͱ�FLOW_MODEL�в�ѯ���׶����ԡ��׶�����
	sSql = "select PhaseAttribute,ActionDescribe from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo = '"+sPhaseNo+"' ";
	rsTemp = Sqlca.getASResultSet(sSql);
	if (rsTemp.next())
	{
		sPhaseAttribute  = DataConvert.toString(rsTemp.getString("PhaseAttribute"));
		sActionDescribe = DataConvert.toString(rsTemp.getString("ActionDescribe"));
		//����ֵת���ɿ��ַ���
		if(sPhaseAttribute == null) sPhaseAttribute = "";
		if(sActionDescribe == null) sActionDescribe = "";
		sSelectStyle = StringFunction.getProfileString(sPhaseAttribute,"ActionStyle");
		//����ֵת���ɿ��ַ���
		if(sSelectStyle == null) sSelectStyle = "";
	}
	rsTemp.getStatement().close();
	    
	//��ʼ���������		 
	FlowTask ftBusiness = new FlowTask(sSerialNo,Sqlca);
	//��ȡ����ѡ���б�
	sActionList = ftBusiness.getActionList("");
	if (sActionList == null) 
	{ 
		sActionList = new String[1];
		sActionList[0] = "";
	}	
	
	String sActionValue[];
	String sTempString1 = "";
	int iCount=sActionList.length;
	sActionValue = new String[iCount];

	for(int i=0;i<iCount;i++)
	{
		
		sSql = "select LoginID||'  '||UserName from USER_INFO where UserID = '"+sActionList[i]+"' ";
		rsTemp = Sqlca.getASResultSet(sSql);
		if(rsTemp.next())
		{
			sActionValue[i] = rsTemp.getString(1);
		}
		rsTemp.getStatement().close();
	}
	if(sActionValue[0] == null)
	{
		sActionValue = sActionList;
	}
%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=����ѡ���ύ����������;]~*/%>
	<html>
	<head> 
		<link rel="stylesheet" href="<%=sResourcesPath%>/style.css">
		<title>�ύ����ѡ���б�</title>
	</head>
	<body class="ShowModalPage" leftmargin="0" topmargin="0" onload="" >

	<form name="Phase" method="post" target="_top">
 		<table width="100%"> 
		  	<tr width="100%" > 
		  		<td width="100%"  valign="top" >
	 		       <table >
					<tr>
						<td>
						<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��  ��","�ύ","javascript:commitAction()",sResourcesPath)%>
						</td>
						<td>
						<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��  ��","����","javascript:doCancel()",sResourcesPath)%>
						</td>			
					</tr>
		           </table>
		           <tr height=1> 
			          <td colspan="5" valign="top" ><hr></td>
			       </tr>	 		       
	               <table align="center">						
							<tr>
								<td valign="top" width=1><img src="<%=sResourcesPath%>/TN_031.gif" width="123" height="80"></td>
					  		    <td colspan=4>
									<select size=8 <%=sSelectStyle%> <%=sSelectStyle%> name="PhaseAction"  class="select1">
			                  		<!-- 	<option value='' style='color:white'>------------------------</option>remarked by lpzhang ��ֹ���ѡ�� -->
			                  			<%=HTMLControls.generateDropDownSelect(sActionList,sActionValue,"")%> 
									</select>
								</td>
							</tr> 
	                	 	<tr>
	                	 	    <td colspan=4></td>
	                	 	</tr> 
					</table>
				</td>
			</tr>
		</table> 
	 <p>	       
	 <input name="SelectedCount" readonly type="text" style="font-size: 9pt;background-color:#DEDFCE;border-style=none" > 
	</form>	
	<!-- δͨ����ȼ����ʾ 
	<form name="Phase1"  target="_top">
 		<table width="100%" align="center" border="2" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF"> 
		  	<tr width="100%" > 
		  		<td width="100%"  valign="top" >
	 		       <table width="100%" border="1" cellspacing="0" cellpadding="3"  bordercolordark="#FFFFFF">
					<tr>
						<font color='blue'>�Բ�����û��Ȩ��������ҵ��</font>
					</tr>
		           </table>
		           
				</td>
			</tr>
		</table>       
	</form>	
	-->
	</body>
	</html>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

		var thisPhaseAction  = "";
		var thisPhaseOpinion1  = "";
		//�ύ����
		function commitAction()
		{
			var sReturnValue = "";
			var thisPhaseAction = "";
			var FlowNo = "<%=sFlowNo%>";		
			var PhaseNo = "<%=sPhaseNo%>";	
			var n = 0 ;//add by lpzhang  2009-8-18 �ַ���Ա�ַ���������		
			iLength  = document.forms("Phase").PhaseAction.length;
			
			for(i = 0;i <= iLength - 1;i++)
			{	
				if (document.forms("Phase").PhaseAction.item(i).selected)
				{
					var thisPhaseAction1 = thisPhaseAction.length;
					var tempPhaseAction=document.forms("Phase").PhaseAction.item(i);// add by cdeng 2009-02-17
					var index=tempPhaseAction.value.indexOf(" ",0);	
					if(index>=0)//�½׶��н�ɫ��ֻȡ�û�ID
						thisPhaseAction += "," + tempPhaseAction.value.substring(0,index);
					else//�½׶��޽�ɫ
						thisPhaseAction += "," + tempPhaseAction.value;
					if(thisPhaseAction.length>1 && thisPhaseAction.length != thisPhaseAction1) n++;
				}
			}	
			thisPhaseAction = thisPhaseAction.substring(1);
			if(thisPhaseAction.length == 0) alert("���Ƚ����ύ����ѡ�� !");
			else if (thisPhaseAction == '<%=CurUser.UserID%>')
			{
				alert("�ύ������Ϊ��ǰ�û���");
			}//֧������С��ַ�Ա�����д�������顢���д�ǰ����ַ�ҵ����Ա����  
			
			else if(n<3 && ((FlowNo.indexOf("EntCreditFlowTJ01") == 0 && PhaseNo.indexOf("0030") == 0) || 
			                //(FlowNo.indexOf("EntCreditFlowTJ01") == 0 && PhaseNo.indexOf("0150") == 0) ||
			                //(FlowNo.indexOf("EntCreditFlowTJ01") == 0 && PhaseNo.indexOf("0280") == 0) ||
			                (FlowNo.indexOf("IndCreditFlowTJ01") == 0 && PhaseNo.indexOf("0030") == 0) ||
			                //(FlowNo.indexOf("IndCreditFlowTJ01") == 0 && PhaseNo.indexOf("0150") == 0) ||
			                //(FlowNo.indexOf("IndCreditFlowTJ01") == 0 && PhaseNo.indexOf("0280") == 0) ||
			                (FlowNo.indexOf("CreditFlow03") == 0 && PhaseNo.indexOf("0250") == 0) 
			                )
			      )
		     {
			      alert("�ַ���Ա���ܵ���3�ˣ�");
			      return;
			 }	
			 		
			else {
				/*
				if( (FlowNo.indexOf("EntCreditFlowTJ01") == 0 && PhaseNo.indexOf("0150") == 0) ||
				(FlowNo.indexOf("IndCreditFlowTJ01") == 0 && PhaseNo.indexOf("0150") == 0) ){
					dReturn = PopPage("/Common/WorkFlow/CheckBusinessSubmit.jsp?PhaseAction="+thisPhaseAction+"&RoleID=218&rand="+randomNumber(),"_blank","");
					if(dReturn < 1){
						alert("û��ѡ���ύ���������������������ίԱ����������ѡ��");
						return;
					}	
				}
				else if( (FlowNo.indexOf("EntCreditFlowTJ01") == 0 && PhaseNo.indexOf("0280") == 0) || 	                 
		                 (FlowNo.indexOf("IndCreditFlowTJ01") == 0 && PhaseNo.indexOf("0280") == 0) ||
				         (FlowNo.indexOf("CreditFlow03") == 0 && PhaseNo.indexOf("0250") == 0)){
					dReturn = PopPage("/Common/WorkFlow/CheckBusinessSubmit.jsp?PhaseAction="+thisPhaseAction+"&RoleID=016&rand="+randomNumber(),"_blank","");
					if(dReturn < 1){
						alert("û��ѡ���ύ���������������ίԱ������ίԱ����������ѡ��");
						return;
					}
				}
				*/
				var sPhaseInfo = PopPage("/Common/WorkFlow/GetNextFlowPhaseAction.jsp?SerialNo=<%=sSerialNo%>&PhaseAction="+thisPhaseAction+"&PhaseOpinion1="+thisPhaseOpinion1+"&rand="+randomNumber(),"_blank","");
				if (confirm(sPhaseInfo+"\r\n ȷ���ύ��"))
				{
					sReturnValue = PopPage("/Common/WorkFlow/SubmitAction.jsp?SerialNo=<%=sSerialNo%>&PhaseOpinion1="+thisPhaseOpinion1+"&PhaseAction="+thisPhaseAction+"&rand="+randomNumber(),"","");
					self.returnValue = sReturnValue;   				
					self.close();
				}	
			}
		}
		
		//ȡ���ύ
		function doCancel()
		{
			if (confirm("��Ҫ�����ô��ύ��ȷ����")) 
			{
				self.returnValue = "_CANCEL_";
				self.close();
			}	
		}	
   
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>	