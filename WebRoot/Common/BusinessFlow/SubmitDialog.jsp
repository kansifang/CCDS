<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.lmt.baseapp.flow.*" %>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
<%
	/*
		Author: byhu 2004-12-06 
		Tester:
		Describe: �ύѡ���
		Input Param:
	SerialNo��������ˮ��
		Output Param:
		HistoryLog: zywei 2005/08/01			
	 */
%>
<%
	/*~END~*/
%> 


<%
 	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
 %>
<%
	//��ȡ������������ˮ��
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));//���ϸ�ҳ��õ������������ˮ��
	//������������̱�š��׶α�š�������
	String sFlowNo = "",sPhaseNo = "",sObjectNo = "";
	//��������������������б��׶ε����͡�������ʾ���׶ε�����
	String sPhaseAction = "",sActionList[],sSelectStyle = "",sActionDescribe = "",sPhaseAttribute = "",sPhaseOpinion1[]; 
	String sSql="";
	ASResultSet rsTemp = null;
%>
<%
	/*~END~*/
%>	


<%
		/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=����ҵ���߼�����;]~*/
	%>
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

	sPhaseOpinion1 = ftBusiness.getChoiceList();
	if (sPhaseOpinion1 == null){
		sPhaseOpinion1 = new String[1];
		sPhaseOpinion1[0] = "";
	}

	//��ȡ����ѡ���б�
	sActionList = ftBusiness.getActionList("");
	if (sActionList == null){
		sActionList = new String[1];
		sActionList[0] = "";
	}
	

	String sActionValue[];
	String sTempString1 = "";
	int iCount=sActionList.length;
	sActionValue = new String[iCount];

	for(int i=0;i<iCount;i++){
		sSql = "select LoginID||'  '||UserName from USER_INFO where UserID = '"+sActionList[i]+"' ";
		rsTemp = Sqlca.getASResultSet(sSql);
		if(rsTemp.next()){
			sActionValue[i] = rsTemp.getString(1);
		}
		rsTemp.getStatement().close();
	}
	if(sActionValue[0] == null)
		sActionValue = sActionList;
%>
<%
	/*~END~*/
%>	
<%
		/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=����ѡ���ύ����������;]~*/
	%>
	<html>
	<head>
		<title>�ύ����ѡ���б�</title>
	</head>
	<body class="ShowModalPage" leftmargin="0" topmargin="0" onload="" >
	<form name="Phase" method="post" target="_top">
	<%
		if (!sPhaseOpinion1[0].equals("")){//��ǰҳ����Ϊ��չʾPhaseOpinion1���ݣ���֪Ϊɶ���if else
	%>
		 <table width="100%" align="center">
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
		        </td>
		        </tr>
		        <tr height=1> 
		          <td colspan="5" valign="top" ><hr></td>
		        </tr>	
		        <tr>
		        <td>				
					<table align="center">							
						<tr>
							 <!--<td valign="top" width=1><img src="<%=sResourcesPath%>/TN_031.gif" width="123" height="80"></td>-->
							 <td colspan=5>
								<select size=8  name="PhaseOpinion1"  class="select1">
								<option value='' style='color:white'>------------------------</option>
								<%=HTMLControls.generateDropDownSelect(sPhaseOpinion1,sPhaseOpinion1,"")%>
								</select>
							 </td>
						</tr>							
					</table>
				</td>
			</tr>
		</table>
		<p>		
		<div style="visibility:hidden;">
			<table align="right">
				<tr>
					<td colspan=4>
						<select size=8 <%=sSelectStyle%>  name="PhaseAction"  class="select1">
						<option value='' style='color:white'>------------------------</option>
						<%=HTMLControls.generateDropDownSelect(sActionList,sActionValue,"")%>
						</select>
					</td>
				</tr>
			</table>
		</div>
<%
	}else{
%>
			<table align="center">
				<tr>
					<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��  ��","�ύ","javascript:commitAction()",sResourcesPath)%>
					</td>
					<td>
					<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��  ��","����","javascript:doCancel()",sResourcesPath)%>
					</td>			
				</tr>
		        <tr height=1> 
		          <td colspan="5" valign="top" ><hr></td>
		        </tr>
		        <br>	
				<tr>
					 <td valign="top" width=1><img src="<%=sResourcesPath%>/TN_031.gif" width="123" height="80"></td>
					 <td colspan=4>
						<select size=8 <%=sSelectStyle%> <%=sSelectStyle%> name="PhaseAction"  class="select1">
						<option value='' style='color:white'>------------------------</option>
						<%=HTMLControls.generateDropDownSelect(sActionList,sActionValue,"")%>
						</select>
					</td>
				</tr>
				<tr>
					<td colspan=4>
					</td>
				</tr>
			</table>
		<p>		
		<div style="visibility:hidden;">
			<table align="right">
					<tr>
						<td colspan=4>
							<select size=8 <%=sSelectStyle%>  name="PhaseOpinion1"  class="select1">
							<option value='' style='color:white'>------------------------</option>
							<%=HTMLControls.generateDropDownSelect(sPhaseOpinion1,sPhaseOpinion1,"")%>
							</select>
						</td>
					</tr>
			</table>
		</div>
<%
	}
%>
	 <input name="SelectedCount" readonly type="text" style="font-size: 9pt;background-color:#DEDFCE;border-style=none" >
	</form>
	</body>
	</html>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>		
		//�ύ����
		function commitAction(){
			var thisPhaseAction  = "";
			var thisPhaseOpinion1 = "";
			iLength  = document.forms("Phase").PhaseAction.length;
			for(var i = 0;i <= iLength - 1;i++)
			{
				if (document.forms("Phase").PhaseAction.item(i).selected)
				{
					if(document.forms("Phase").PhaseAction.item(i).value != "")
					{
			    			thisPhaseAction += "," + document.forms("Phase").PhaseAction.item(i).value;
			    	}
			    }
			}
			
			iLength =  document.forms("Phase").PhaseOpinion1.length;
			//��������Щ������Ͳ�Ҫ�ύ��������һ��ѡ���ύ����Ի���
			for(var i = 0;i <= iLength - 1;i++)
			{
				if (document.forms("Phase").PhaseOpinion1.item(i).selected)
				{
					if(document.forms("Phase").PhaseOpinion1.item(i).value != "")
					{
			    		thisPhaseOpinion1 += "," + document.forms("Phase").PhaseOpinion1.item(i).value;	
			    		if (document.forms("Phase").PhaseOpinion1.item(i).value.search("�ύ")>=0)
			    		{
			    			self.returnValue = document.forms("Phase").PhaseOpinion1.item(i).value;
			    			self.close();	
			    			return;			    		
			    		}		    		
			    		if (document.forms("Phase").PhaseOpinion1.item(i).value.search("ͬ��")>=0)
			    		{
			    			self.returnValue = document.forms("Phase").PhaseOpinion1.item(i).value;
			    			self.close();	
			    			return;			    		
			    		}
			    		if (document.forms("Phase").PhaseOpinion1.item(i).value.search("����")>=0)
			    		{
			    			self.returnValue = document.forms("Phase").PhaseOpinion1.item(i).value;
			    			self.close();	
			    			return;			    		
			    		}
			    		if (document.forms("Phase").PhaseOpinion1.item(i).value.search("����")>=0)
			    		{
			    			self.returnValue = document.forms("Phase").PhaseOpinion1.item(i).value;
			    			self.close();	
			    			return;			    		
			    		}
			    		if (document.forms("Phase").PhaseOpinion1.item(i).value.search("������ȫ")>=0)
			    		{
			    			self.returnValue = document.forms("Phase").PhaseOpinion1.item(i).value;
			    			self.close();	
			    			return;			    		
			    		}
		    		}
		    	}
			}
			thisPhaseAction = thisPhaseAction.substring(1);			
			thisPhaseOpinion1 = thisPhaseOpinion1.substring(1);	
						
			if(thisPhaseAction.length == 0 && thisPhaseOpinion1.length == 0)
			{				
				alert("���Ƚ����ύ����ѡ�� ��");
			}else if(thisPhaseAction.length > 0 && thisPhaseOpinion1.length > 0)
			{
				alert("����ͬʱѡ�������ύ������");
				document.forms("Phase").PhaseAction.item(0).selected = true;
				document.forms("Phase").PhaseOpinion1.item(0).selected = true;
			}else if (thisPhaseAction == '<%=CurUser.UserID%>')
			{
				alert("�ύ������Ϊ��ǰ�û���");
				return;
			}else
			{						
				var sPhaseInfo = PopPage("/Common/BusinessFlow/GetNextFlowPhaseAction.jsp?SerialNo=<%=sSerialNo%>&PhaseAction="+thisPhaseAction+"&PhaseOpinion1="+thisPhaseOpinion1+"&rand="+randomNumber(),"_blank","");
				if (confirm(sPhaseInfo+"\r\n ȷ���ύ��"))
				{
					sReturnValue = PopPage("/Common/BusinessFlow/SubmitAction.jsp?SerialNo=<%=sSerialNo%>&PhaseOpinion1="+thisPhaseOpinion1+"&PhaseAction="+thisPhaseAction,"","");
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
<%
	/*~END~*/
%>
<%@ include file="/IncludeEnd.jsp"%>
