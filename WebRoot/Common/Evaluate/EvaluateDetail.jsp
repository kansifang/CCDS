<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.biz.evaluate.*,com.amarsoft.app.lending.bizlets.*" %>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:    
		Tester:	
		Content: �ͻ��б�
		Input Param:
			              --Action      :  ��������
			              --ObjectType  :  ��������
			              --ObjectNo    :  ������
			              --SerialNo    :  ������ˮ��            
		Output param:
			               
		History Log: 
			DATE	CHANGER		CONTENT
			2005.7.22 fbkang    ҳ�������
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<% 
    //�������
	int    i = 0 ;//--������
	String sMessage = "";//--������ʾ��Ϣ
	String sObjectName="";//--��������
	String sSubModelNo="";//--��ģ�ͺ���
	String sModelName="";//--ģ������
	String sModelType="";//--ģ������
	String sItemName="";//--�������
	String sItemValue="";//--���ֵ
	String sItemNo="";//����
	String sValueCode="";//--ֵ���
	String sValueMethod="";//--ֵ����
	String sValueType="";//--ֵ����
	String sCoefficient = "";//Ȩ��(�ַ�)
	String sSql="";//--���sql
	ASResultSet rs = null;//--��Ž��
	String sEvaDate="";//--��������
	String sEvaResult="";//--�������
	float dEvaScore=0;//--������֮
	String sEvaluateScore="�÷֣�",sEvaluateResult="�����",CurYear="";
	String sFinanceScore="����ָ��: ",sNotFinanceScore="�ǲ���ָ��: ";
	String sBelongAttribute = "";//--����Ȩ
	String sBelongAttribute1 = "";//--�鿴Ȩ
	String sBelongAttribute2 = "";//--ά��Ȩ
	boolean isEditable=true;//�Ƿ���Ա��桢����
	
  //���ҳ�����
	String sAction     = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo")); 
	String sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sCustomerID   = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sEditable =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Editable"));
	if("false".equals(sEditable))isEditable=false;
	//����ֵת��Ϊ���ַ���
	if(sAction == null) sAction = "";
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sCustomerID == null) sCustomerID = "";
	System.out.println("sAction:"+sAction+"@sObjectType:"+sObjectType+"@sObjectNo:"+sObjectNo+"&CustomerID:"+sCustomerID+"*ObjectNo:"+sObjectNo);
	Evaluate eEvaluate    = new Evaluate(sObjectType,sObjectNo,sSerialNo,Sqlca);
	//added by bllou 2012-10-01 ����������Ȩ�ض�̬�����ȴ�����	
	EvaluateExtraAction eea=new EvaluateExtraAction(eEvaluate);
%>
<%/*END*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=���ݲ�ͬ�Ĳ�����ȷ������ģ�Ͳ�����Ӧ�ı��桢ɾ��������Ĵ���;]~*/%>
<%	
	if(eEvaluate.ModelNo.equals("RiskEvaluate")){
		sEvaluateScore="���նȣ�";
		sEvaluateResult="";
	}
	
	if(eEvaluate.ModelNo.equals("CreditLine")){
		sEvaluateScore="��������ۺ������޶�ο�ֵ��";
		sEvaluateResult="��Ԫ";
	}
	//�ж��Ƿ���Ա������:�Ѿ�����ͨ�������õȼ�������¼
	rs = Sqlca.getASResultSet(" select 1 from EVALUATE_RECORD Where SerialNo='" + sSerialNo +"' and FinishDate is not null and Finishdate!=''");
	if (rs.next()) {
		isEditable=false;
	}
	rs.getStatement().close();
	
	//�ж��û�Ȩ��
	sSql =  " select BelongAttribute,BelongAttribute1,BelongAttribute2 " +
			" from CUSTOMER_BELONG " +
			" where CustomerID='"+sCustomerID+"' and UserID='"+CurUser.UserID+"' and OrgID='"+CurUser.OrgID+"'";
	rs = Sqlca.getASResultSet(sSql);
	while (rs.next()) {
		sBelongAttribute = rs.getString(1);
		sBelongAttribute1 = rs.getString(2);
		sBelongAttribute2 = rs.getString(3);
	}
	rs.getStatement().close();
	
	//�õ�ģ������,����
	rs = Sqlca.getASResultSet("select ModelName,ModelType from EVALUATE_CATALOG where ModelNo='"+eEvaluate.ModelNo+"'");
	if (rs.next()){	
		sModelName = rs.getString(1);
		sModelType = rs.getString(2);
	}
	rs.getStatement().close();
	String sModelTypeName = Sqlca.getString("select ItemName from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo='"+sModelType+"'");
	String sModelTypeAttributes = Sqlca.getString("select RelativeCode from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo='"+sModelType+"'");

	if(sModelTypeAttributes==null) throw new Exception("ģ������ ["+sModelType+"] �����Լ� û�ж��壬��鿴CODE_LIBRARY:EvaluateModelType��RelativeCode����");
	String sDisplayFinalResult = StringFunction.getProfileString(sModelTypeAttributes,"DisplayFinalResult");
	String sDisplayItemScore = StringFunction.getProfileString(sModelTypeAttributes,"DisplayItemScore");
	String sButtonSaveFace = StringFunction.getProfileString(sModelTypeAttributes,"ButtonSaveFace");
	String sButtonCalcFace = StringFunction.getProfileString(sModelTypeAttributes,"ButtonCalcFace");
	String sButtonDelFace = StringFunction.getProfileString(sModelTypeAttributes,"ButtonDelFace");
	String sButtonCloseFace = StringFunction.getProfileString(sModelTypeAttributes,"ButtonCloseFace");
	String sItemValueDisplayWidth = StringFunction.getProfileString(sModelTypeAttributes,"ItemValueDisplayWidth");
	if(sItemValueDisplayWidth==null || sItemValueDisplayWidth.equals("")) sItemValueDisplayWidth="100";		
	
	if (sObjectType.equals("Customer")|| sObjectType.equals("MaxCreditLine")||sObjectType.equals("CustomerLimit") || sObjectType.equals("NewEvaluate")) //�ͻ� change by hldu 
		sObjectName = Sqlca.getString("select CustomerName from CUSTOMER_INFO where CustomerID='"+sObjectNo+"'");
	else //ҵ������
		sObjectName = Sqlca.getString("select CustomerName||'*'||getBusinessName(BusinessType) from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'");
	if(sAction.equals("update") || sAction.equals("evaluate")){
		if (eEvaluate.Data.first()){
			do {
				i ++;
				sItemName  = "R" + String.valueOf(i);
				sItemValue = DataConvert.toRealString(iPostChange,request.getParameter(sItemName));
				sItemNo = eEvaluate.Data.getString("ItemNo");		     		
				if (sItemValue!=null && sItemValue.trim().length()!=0){
					Sqlca.executeSQL("update EVALUATE_DATA set ItemValue='"+sItemValue+"' where ObjectType='" + sObjectType + "' and ObjectNo='" + sObjectNo + "' and SerialNo='"+ sSerialNo + "' and ItemNo='"+sItemNo+"'");
				}
			}while(eEvaluate.Data.next());	
		}
		eEvaluate.getRecord();
		eEvaluate.getData(); 
		sMessage =  "���ݱ�����ɣ�";  		 
		
	if(sAction.equals("evaluate")) {
		
		eEvaluate.evaluate();
		//added by bllou ����Ȩ��
		eea.updateCoefficient();
		//end bllou
		eEvaluate.evaluate();

		eEvaluate.getRecord();
		eEvaluate.getData();  
		//�õ�ϵͳ���������ϵͳ��������,���������������
		rs = Sqlca.getASResultSet("select EvaluateDate,EvaluateScore,EvaluateResult from EVALUATE_RECORD where ObjectType='" + sObjectType + "' and ObjectNo='" + sObjectNo + "' and SerialNo='"+ sSerialNo + "'");
		if (rs.next()){	
			sEvaDate = rs.getString(1);
			dEvaScore = rs.getFloat(2);
			sEvaResult = rs.getString(3);
		}
		rs.getStatement().close();
		//added by bllou 2012-09-19 ���ݵ���������������
		sEvaResult =eea.adjustResult(sEvaResult);
		//end bllou
		sSql = " Update EVALUATE_RECORD Set EvaluateDate='"+StringFunction.getToday()+"',CognDate='"+ sEvaDate +"',CognScore=" + dEvaScore +",CognResult='" +sEvaResult+ "',"+
		       " CognOrgID='"+CurOrg.OrgID+"',CognUserID='"+CurUser.UserID+"'" +
		       " where ObjectType='" + sObjectType + "' and ObjectNo='" + sObjectNo + "' and SerialNo='"+ sSerialNo + "'";
		Sqlca.executeSQL(sSql);
		
		rs = Sqlca.getASResultSet("  select AccountMonth,CognResult from EVALUATE_RECORD Where ObjectNo='"+sObjectNo+"'and ObjectType = 'Customer' order by AccountMonth desc,SerialNo desc fetch first 1 rows only"); //change by hldu
		String sEvaDate1="",sEvaResult1="";
		if (rs.next()){	
			sEvaDate1 = rs.getString(1);
			sEvaResult1 = rs.getString(2);
		}
		rs.getStatement().close();

		sSubModelNo=eEvaluate.ModelNo.substring(0,1);
		if(sSubModelNo.equals("0")){
			String sSql1 = "Update ENT_INFO  Set EvaluateDate='"+sEvaDate1+"',CreditLevel='"+sEvaResult1+ "' where  CustomerID= '"+sObjectNo+"'";
			
			Sqlca.executeSQL(sSql1);
		}
		else if(eEvaluate.ModelNo.equals("RiskEvaluate")){
			String  sSql1 = "Update BUSINESS_APPLY  Set RiskRate = "+dEvaScore+" where  SerialNo= '"+sObjectNo+"'";
			Sqlca.executeSQL(sSql1);
		}
		sMessage =  "������ɣ�" ;
	}
	}
	//ȡ����ָ�� 
	//added by bllou 2012-10-18 ��ͬҵģ�� ������ģ�ʹ��� ����ָ��Ȩ��0.8���ǲ���ָ��Ȩ��0.2
	sSql =  " select sum(nvl(EvaluateScore,0))*"+(eEvaluate.ModelNo.startsWith("21")?"1":"0.8")+" from EVALUATE_DATA where SerialNo='"+sSerialNo+"' and ItemNo like '1%'  ";
	rs = Sqlca.getASResultSet(sSql);
	while (rs.next()) {
		sFinanceScore = sFinanceScore+DataConvert.toString(rs.getDouble(1));
	}
	rs.getStatement().close();
	//ȡ�ǲ���ָ��
	sSql =  " select sum(nvl(EvaluateScore,0))*"+(eEvaluate.ModelNo.startsWith("21")?"1":"0.2")+" from EVALUATE_DATA where SerialNo='"+sSerialNo+"' and ItemNo like '2%' ";
	rs = Sqlca.getASResultSet(sSql);
	while (rs.next()) {
		sNotFinanceScore = sNotFinanceScore+DataConvert.toString(rs.getDouble(1));
	}
	rs.getStatement().close();
%>

<%/*END*/%>


<html>
<head>
<title><%=sModelTypeName%></title>
</head>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List04;Describe=�Զ��庯��;]~*/%>
<script language=javascript> 
	function evaluate(){
		var i;
		for(i = 0;i<=document.forms(0).elements.length-1;i++){
	   		
			if(document.forms(0).elements(i).type.substr(0,4)=="text"){
				if(document.forms(0).elements(i).value==""){
					alert(getBusinessMessage('198'));//�������Ҫ���
					document.forms(0).elements(i).focus();
					return;
				}
			}
		}
	   		
		for(i = 0;i<=document.forms(0).elements.length-1;i++){
			if(document.forms(0).elements(i).type.substr(0,6)=="select"){
				if(document.forms(0).elements(i).value=="0"){
					alert(getBusinessMessage('199'));//��ѡ���Ҫ���
					document.forms(0).elements(i).focus();
					return;
				}
			}
		}
		if(!ValidityCheck()) return;
		document.report.action="EvaluateDetail.jsp?Action=evaluate&CompClientID=<%=sCompClientID%>";
		document.report.submit(); 
	}
   
	function updateData(){
		document.report.action="EvaluateDetail.jsp?Action=update&CompClientID=<%=sCompClientID%>";
		document.report.submit();
		reloadSelf();
	}
   
	function ValidityCheck(){
		//���м��������ų��ڣ��������������ţ�>�������ų��ڣ��������������ţ�
		//�������ų��ڣ��������������ţ�=��һ�ֵ�����Ӧ���ų���+�ڶ��ֵ�����Ӧ���ų���+�����ֵ�����Ӧ���ų���+�����ֵ�����Ӧ���ų��ڡ�
		//С��ҵ��ó�����õȼ�������
		if("<%=eEvaluate.ModelNo%>"=="303")
		{
			var R9Value=0;//���м��������ų��ڣ��������������ţ�
			var R16Value=0;//�������ų��ڣ��������������ţ�
			var R22Value=0;//��һ�ֵ�����Ӧ���ų���
			var R24Value=0;//�ڶ��ֵ�����Ӧ���ų���
			var R26Value=0;//�����ֵ�����Ӧ���ų���
			var R28Value=0;//�����ֵ�����Ӧ���ų���
			for(i = 0;i<=document.forms(0).elements.length-1;i++){
				if(document.forms(0).elements(i).name=="R9"){
					R9Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R16"){
					R16Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R22"){
					R22Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R24"){
					R24Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R26"){
					R26Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R28"){
					R28Value=document.forms(0).elements(i).value;
				}
			}
			if(parseFloat(R9Value)<parseFloat(R16Value)){
				alert("���м��������ų��ڣ��������������ţ���ӦС���������ų��ڣ��������������ţ�");
				return false;
			}
			if(parseFloat(R16Value)!=(parseFloat(R22Value)+parseFloat(R24Value)+parseFloat(R26Value)+parseFloat(R28Value))){
				alert("�������ų��ڣ��������������ţ�Ӧ���ڸ�������Ӧ���ų���֮��");
				return false;
			}
		}else if("<%=eEvaluate.ModelNo%>"=="304")//С��ҵ����ҵ�����õȼ�������
		{
			var R9Value=0;//���м��������ų��ڣ��������������ţ�
			var R16Value=0;//�������ų��ڣ��������������ţ�
			var R24Value=0;//��һ�ֵ�����Ӧ���ų���
			var R26Value=0;//�ڶ��ֵ�����Ӧ���ų���
			var R28Value=0;//�����ֵ�����Ӧ���ų���
			var R30Value=0;//�����ֵ�����Ӧ���ų���
			for(i = 0;i<=document.forms(0).elements.length-1;i++){
				if(document.forms(0).elements(i).name=="R9"){
					R9Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R16"){
					R16Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R24"){
					R24Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R26"){
					R26Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R28"){
					R28Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R30"){
					R30Value=document.forms(0).elements(i).value;
				}
			}
			if(parseFloat(R9Value)<parseFloat(R16Value)){
				alert("���м��������ų��ڣ��������������ţ���ӦС���������ų��ڣ��������������ţ�");
				return false;
			}
			if(parseFloat(R16Value)!=(parseFloat(R24Value)+parseFloat(R26Value)+parseFloat(R28Value)+parseFloat(R30Value))){
				alert("�������ų��ڣ��������������ţ�Ӧ���ڸ�������Ӧ���ų���֮��");
				return false;
			}
		}else if("<%=eEvaluate.ModelNo%>"=="305")//С��ҵ������ҵ�����õȼ�������
		{
			var R9Value=0;//���м��������ų��ڣ��������������ţ�
			var R16Value=0;//�������ų��ڣ��������������ţ�
			var R22Value=0;//��һ�ֵ�����Ӧ���ų���
			var R24Value=0;//�ڶ��ֵ�����Ӧ���ų���
			var R26Value=0;//�����ֵ�����Ӧ���ų���
			var R28Value=0;//�����ֵ�����Ӧ���ų���
			for(i = 0;i<=document.forms(0).elements.length-1;i++){
				if(document.forms(0).elements(i).name=="R9"){
					R9Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R16"){
					R16Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R22"){
					R22Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R24"){
					R24Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R26"){
					R26Value=document.forms(0).elements(i).value;
				}
				if(document.forms(0).elements(i).name=="R28"){
					R28Value=document.forms(0).elements(i).value;
				}
			}
			if(parseFloat(R9Value)<parseFloat(R16Value)){
				alert("���м��������ų��ڣ��������������ţ���ӦС���������ų��ڣ��������������ţ�");
				return false;
			}
			if(parseFloat(R16Value)!=(parseFloat(R22Value)+parseFloat(R24Value)+parseFloat(R26Value)+parseFloat(R28Value))){
				alert("�������ų��ڣ��������������ţ�Ӧ���ڸ�������Ӧ���ų���֮��");
				return false;
			}
		}
		return true;
	}
	
	function goBack(){
		self.close();
	} 
	
	function initRow()
	{
		sBelongAttribute = "<%=sBelongAttribute%>";
		sBelongAttribute1 = "<%=sBelongAttribute1%>";
		sBelongAttribute2 = "<%=sBelongAttribute2%>";
		
		if(sBelongAttribute == "2" && sBelongAttribute1 == "1" && sBelongAttribute2 == "2"&&<%=isEditable%>)
		{
			document.getElementById("updateData").style.display = "none";
			document.getElementById("evaluate").style.display = "none";
		}
	}
	
		/*~[Describe=��ӡ;InputParam=��;OutPutParam=��;]~*/
	function my_print()
	{
		sSerialNo ="<%=sSerialNo%>";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��  	
		}else
		{
			PopPage("/Common/Evaluate/EvaluatePrint.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&SerialNo="+sSerialNo+"&rand="+randomNumber(),"_blank","");
 		}
	}
	
</script>
<%/*~END~*/%>


<body bgcolor="#DCDCDC" leftmargin="0" topmargin="0" onBeforeUnload="reloadOpener();">

<div id="Layer1" style="position:absolute; left:24px; top:9px; width:26px; height:20px; z-index:1"></div>
<table border="0" width="95%" align="center">
	<tr> 
	<td colspan=5>
		<table>
		<%if(sButtonSaveFace!=null && !sButtonSaveFace.equals("NONE")){
		if(isEditable){%>
		<td id="updateData">
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button",sButtonSaveFace,sButtonSaveFace,"javascript:updateData()",sResourcesPath)%>
    	</td>
		<td id="evaluate"> 
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button",sButtonCalcFace,sButtonCalcFace,"javascript:evaluate()",sResourcesPath)%>
		</td>
		
		<td id="goBack"> 
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button",sButtonCloseFace,sButtonCloseFace,"javascript:goBack()",sResourcesPath)%>
		</td>
		
		<% if(!eEvaluate.ModelNo.equals("CreditLine")){ %>
		 <td id="goBack"> 
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��ӡ","��ӡ","javascript:my_print()",sResourcesPath)%>
		</td> 
			<%
				}
			} %>
		<%}%>
		</table>
	</td>
	</tr>
	<tr> 
		<td colspan="5"> 
			<hr>
		</td>
	</tr>
	<tr> 
		<td nowrap align="center" colspan="5"><FONT SIZE="4"><B><%=sObjectName +"&nbsp;"+ eEvaluate.AccountMonth %></B><%=sModelName%></FONT></td>
	</tr>
<%
	if(sDisplayFinalResult!=null && sDisplayFinalResult.equalsIgnoreCase("Y")){
%>
	<tr> 
    	<td  nowrap align="center" colspan="5">
    		<FONT SIZE="4"><%=sEvaluateScore%><B><%=DataConvert.toMoney(eEvaluate.EvaluateScore)%></B></FONT> 
<%
				if(!eEvaluate.ModelNo.equals("RiskEvaluate") && !eEvaluate.ModelNo.equals("080")) {
					out.println("<FONT SIZE=\"4\">"+sEvaluateResult+"<B>"+DataConvert.toString(eEvaluate.EvaluateResult)+"</B></FONT>");
				}
				if (eEvaluate.ModelNo.equals("080")){
					out.println("<FONT SIZE=\"4\">"+sEvaluateResult+"</FONT>");
				}
				if(eEvaluate.ModelNo.substring(0,1).equals("2"))//ͬҵ���õȼ�����
				{
					out.println("<FONT SIZE=\"4\">"+"&nbsp;"+sFinanceScore+"&nbsp;"+sNotFinanceScore+"</FONT>");
				}
				//added by bllou ��ʾ�������������
				if(eea.isHasEvaluateAdjust()){
					out.println("<FONT SIZE=\"4\">��������ǰ�����<B>"+eea.getBeforeAdjustResult()+"</B></FONT>");
				}
%>
    	</td>
    </tr>
	<%
	}
	%>
	<tr> 
	</tr>
	<tr> 
		<td colspan="5">
	<form name="report" method="post">
		<table width="100%" border=1 cellspacing=0 cellpadding=3 bordercolordark=#EEEEEE bordercolorlight=#999999 align="left">
			<tr> 
				<td nowrap  align="center" background="<%=sResourcesPath%>/Support/back.gif">���</td>
				<td nowrap  align="center" background="<%=sResourcesPath%>/Support/back.gif">��Ŀ����</td>
				<td nowrap  align="center" background="<%=sResourcesPath%>/Support/back.gif" width="<%=sItemValueDisplayWidth%>">��Ŀֵ</td>
				<%
				if(sDisplayItemScore!=null && sDisplayItemScore.equalsIgnoreCase("Y"))
				{
					if(eEvaluate.ModelNo.equals("CreditLine"))
					{
				%>
				<td nowrap  align="center" background="<%=sResourcesPath%>/Support/back.gif">ϵ������ֵ</td>
				<%	
					}else{
				%>
				<td nowrap  align="center" background="<%=sResourcesPath%>/Support/back.gif">�÷�</td>
				<%
					}
				}
				%>
			</tr>
	<%
	i = 0;
	String myS="",myItemName="",sDisplayNo="",sTitle="";
	if(eEvaluate.Data.first())
	{
		do
		{
		i ++;
     	sItemName = "R" + String.valueOf(i);          
     	myItemName=DataConvert.toString(eEvaluate.Data.getString("ItemName"));
		sDisplayNo=DataConvert.toString(eEvaluate.Data.getString("DisplayNo"));
	%> 
          <tr bgcolor="#e9e9e9" height="35"> 
            <td nowrap ><%=sDisplayNo%></td>
			<% if (sDisplayNo.trim().length() == 1)
              out.print("<td nowrap style='width:350;'><B>"+myItemName+"</B></td>");
	       else 
                out.print("<td nowrap style='width:350;'>"+myItemName+"</td>");%>
            <%
	 	sValueCode   = eEvaluate.Data.getString("ValueCode"); 
	 	sValueMethod = eEvaluate.Data.getString("ValueMethod"); 
	 	sValueType   = eEvaluate.Data.getString("ValueType"); 
	 	sCoefficient   = eEvaluate.Data.getString("Coefficient");
	 	
	 	if (sValueCode != null && sValueCode.trim().length() > 0) //����д�������ʾ�����б�
	 	{
	 		sSql = "select ItemNo,ItemDescribe,ItemName from CODE_LIBRARY where CodeNo = '" + sValueCode + "' order by ItemNo";
	 	%> 
            <td nowrap align="left" > 
              <select name=<%=sItemName%> align="left" style="width:500;" onmousedown="FixWidth(this)">
                <option value='0'> </option>
                <%=HTMLControls.generateDropDownSelect(Sqlca,sSql,1,3,DataConvert.toString(eEvaluate.Data.getString("ItemValue")))%> 
              </select>
            </td>
            <%
	 	}else if ((sValueMethod != null && sValueMethod.trim().length() > 0) || sValueType==null || sValueType.trim().length() == 0) //�����ȡֵ�������ܽ����޸�
	 	{
	 		//ȡ��ʾ���
	 		sDisplayNo=DataConvert.toString(eEvaluate.Data.getString("DisplayNo"));
	 		myS=DataConvert.toString(eEvaluate.Data.getString("ItemValue"));
	 		
	 		if(myS!=null && !myS.equalsIgnoreCase("null") && !myS.equals(""))
	 		{
				
				if(sValueType !=null && sValueType.equals("Number"))	
	 			{	
	 				myS=DataConvert.toMoney(String.valueOf(eEvaluate.Data.getDouble("ItemValue")));
	 				if(myS.equals("")) myS="0.00";
	 			}else	myS=eEvaluate.Data.getString("ItemValue");
	 		
	 		}
	 		else{ myS="";}
	 		
	 		if (sDisplayNo.length()==1)
	 			myS="";
	 	%> 
            <td nowrap  height='22' align="left" name="<%=sItemName%>"><%=myS%>&nbsp;</td>
            <%
	 	}else //������Խ����޸�
	 	{
	 	%> 
            <td nowrap  align="left" >                                                                                                                 
              <input class="no_border_number" type=text name="<%=sItemName%>" value='<%=DataConvert.toString(eEvaluate.Data.getString("ItemValue"))%>' onkeyup="value=value.replace(/[^\d\.\-]/g,'')" onbeforepaste="clipboardData.setData('text',clipboardData.getData('text').replace(/[^\d\.\-]/g,''))">
            </td>
            <%
	 	}	
            
//sDisplayItemScore="N";
		//bllou 20121012 ��Ӹ������������ж��Ƿ���ʾ
		String sEvaluateMethod=eEvaluate.Data.getString("EvaluateMethod");
		if(sDisplayItemScore!=null && sDisplayItemScore.equalsIgnoreCase("Y")){
			if (sCoefficient != null&&sCoefficient.length()>0&&sEvaluateMethod!=null&&sEvaluateMethod.length()>0)
			{
				
				//ȡ��ʾ���
				sDisplayNo=DataConvert.toString(eEvaluate.Data.getString("DisplayNo"));
			%> 
				<td nowrap  align="right"><%=DataConvert.toMoney(eEvaluate.Data.getDouble("EvaluateScore"))%></td>
			<%	
			}else 
			{//added by bllou 201209-19 �ͻ���������
				if(eea.isHasEvaluateAdjust()){
					if("PJTZ".equals(DataConvert.toString(eEvaluate.Data.getString("ItemNo")))){
						out.println("<td nowrap align='right'>������������</td>");
					}else if(DataConvert.toString(eEvaluate.Data.getString("ItemNo")).startsWith("PJTZ")){
						String sT=DataConvert.toString(eEvaluate.Data.getString("ItemValue"));
						if("D".equals(sT)){
							sT="�µ���"+sT+"��";
						}else if(!"Z".equals(sT)){
							sT="�µ�"+sT+"��";
						}else{
							sT="";
						}
						out.println("<td nowrap align='right'>"+sT+"</td>");
					}
				}//end bllou	
				else{
			%> 
				<td nowrap align="right"></td>
		<%	
				}
			}
		}
		%> </tr>
		<%
	}while(eEvaluate.Data.next());
 }
 
%> 
        </table>
      </form>
    </td>
  </tr>
	<tr> 
		<td colspan="5"> 
			<hr>
		</td>
	<%
		if(sDisplayFinalResult!=null && sDisplayFinalResult.equalsIgnoreCase("Y")){
	%>
		<tr> 
    	<td  nowrap align="center" colspan="5">
    		<FONT SIZE="4"><%=sEvaluateScore%><B><%=DataConvert.toMoney(eEvaluate.EvaluateScore)%></B></FONT> 
			<%
				if(!eEvaluate.ModelNo.equals("RiskEvaluate") && !eEvaluate.ModelNo.equals("080")) {
					out.println("<FONT SIZE=\"4\">"+sEvaluateResult+"<B>"+DataConvert.toString(eEvaluate.EvaluateResult)+"</B></FONT>");
				}
				if (eEvaluate.ModelNo.equals("080")){
					out.println("<FONT SIZE=\"4\">"+sEvaluateResult+"</FONT>");
				}
				if(eEvaluate.ModelNo.substring(0,1).equals("2"))//ͬҵ���õȼ�����
				{
					out.println("<FONT SIZE=\"4\">"+"&nbsp;"+sFinanceScore+"&nbsp;"+sNotFinanceScore+"</FONT>");
				}
				//added by bllou ��ʾ�������������
				if(eea.isHasEvaluateAdjust()){
					out.println("<FONT SIZE=\"4\">��������ǰ�����<B>"+eea.getBeforeAdjustResult()+"</B></FONT>");
				}
			%>
    	</td>
    </tr>
	<%
	}
	%>
	<tr> 
	<td colspan=5>
		<table>
		<%if(sButtonSaveFace!=null && !sButtonSaveFace.equals("NONE")){
		if(isEditable){%>
		<td> 
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button",sButtonSaveFace,sButtonSaveFace,"javascript:updateData()",sResourcesPath)%>
    	</td>
		<td> 
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button",sButtonCalcFace,sButtonCalcFace,"javascript:evaluate()",sResourcesPath)%>
		</td>
		
		<td> 
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button",sButtonCloseFace,sButtonCloseFace,"javascript:goBack()",sResourcesPath)%>
		</td>
		<% if(!eEvaluate.ModelNo.equals("CreditLine")){ %>
		 <td id="goBack"> 
			<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","��ӡ","��ӡ","javascript:my_print()",sResourcesPath)%>
		</td> 
			<%
				}
			} %>
		<%}%>
		</table>
	</td>
	</tr>
</table>
<%
	if(!(sAction.equals("new") || sAction.equals("display"))){
%>
		<script language=javascript> 
			alert('<%=sMessage%>');
		</script>
<%	 
	}
	eEvaluate.close();
%> 
</body>
</html>
<script language="JavaScript">
	function reloadOpener(){
		try{
			top.opener.location.reload();
		}
		catch(e){
		}
	}
</script>
<script language="JavaScript">
	//added by bllou 2012-9-19 	��������˵�ѡ��̫��������
	function FixWidth(selectObj)
	{
	    var newSelectObj = document.createElement("select");
	    newSelectObj = selectObj.cloneNode(true);
	    newSelectObj.selectedIndex = selectObj.selectedIndex;
	    newSelectObj.onmouseover = null;
	    newSelectObj.onmousedown = null;
	    var e = selectObj;
	    var absTop = e.offsetTop;
	    var absLeft = e.offsetLeft;
	    // alert(e.offsetHeight);
	    var MaxTextLength=0;
	    for(var i=0;i<selectObj.length;i++){
		    if(MaxTextLength<selectObj[i].text.length){
		    	MaxTextLength= selectObj[i].text.length;
		    }
	    }
	    if(MaxTextLength*7-300>0){
	    	absLeft=absLeft-(MaxTextLength*7-300);
	    }
	    
	    while(e = e.offsetParent)
	    {
	        absTop += e.offsetTop;
	        absLeft += e.offsetLeft;
	    }
	    with (newSelectObj.style)
	    {
	        position = "absolute";
	        top = absTop + "px";
	        left = absLeft + "px";
	        width = "auto";
	    }
	    
	    var rollback = function(){ RollbackWidth(selectObj, newSelectObj); };
	    if(window.addEventListener)
	    {
	        newSelectObj.addEventListener("blur", rollback, false);
	        newSelectObj.addEventListener("change", rollback, false);
	    }
	    else
	    {
	        newSelectObj.attachEvent("onblur", rollback);
	        newSelectObj.attachEvent("onchange", rollback);
	    }
	    
	    selectObj.style.visibility = "hidden";
	    document.body.appendChild(newSelectObj);
	    newSelectObj.focus();
	}

	function RollbackWidth(selectObj, newSelectObj)
	{
	    selectObj.selectedIndex = newSelectObj.selectedIndex;
	    selectObj.style.visibility = "visible";
	    document.body.removeChild(newSelectObj);
	}
</script>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language="JavaScript">
	AsOne.AsInit();
	//AsMaxWindow();
	initRow();
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>