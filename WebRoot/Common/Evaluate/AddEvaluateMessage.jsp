<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  2005.7.22 fbkang    �µİ汾�ĸ�д
		Tester:	
		Content: �ͻ��б�
		Input Param:
			              ObjectType:  ��������
			              ObjectNo  :  ������
			              ModelType :  ����ģ������ 010--���õȼ�����   030--���ն�����  080--�����޶� 018--���ô�������  ������'EvaluateModelType'����˵��     
		Output param:
			               
		History Log: 
			DATE	CHANGER		CONTENT
			
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = ""; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	String sModelTypeAttributes="",sDefaultModelNo="";
	String sAccountMonthSelectSQL = "",sAccountMonthInputType = "",sDefaultModelNoSQL="",sAccountMonthExplanation="";

	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));	
	String sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sModelType  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ModelType"));
	if(sModelType==null) sModelType = "";
%>
<%/*END*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sSql = "select RelativeCode from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo='"+sModelType+"'";
	ASResultSet rs   = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sModelTypeAttributes = rs.getString("RelativeCode");
	}
	else{
		throw new Exception("ģ������ ["+sModelType+"] û�ж��塣���ϵͳ����Ա��ϵ��");
	}
	rs.getStatement().close();

	/* �ȼ���������˵��
	sModelTypeAttributes	ģ����صĲ������崮
	sAccountMonthSelectSQL  
	sAccountMonthExplanation ���ڻ���·ݵĲ���˵��
	sDefaultModelNoSQL		ȡ�ö�Ӧ���͵Ĳ�ѯ���
	*/
	sAccountMonthInputType = StringFunction.getProfileString(sModelTypeAttributes,"AccountMonthInputType");
	sAccountMonthSelectSQL = StringFunction.getProfileString(sModelTypeAttributes,"AccountMonthSelectSQL");	
	sAccountMonthExplanation = StringFunction.getProfileString(sModelTypeAttributes,"AccountMonthExplanation");
	sDefaultModelNoSQL = StringFunction.getProfileString(sModelTypeAttributes,"DefaultModelNoSQL");

	//����Ӧ�Ĳ���ת��Ϊ��ǰʵ������
	sAccountMonthSelectSQL = StringFunction.replace(sAccountMonthSelectSQL,"#ObjectType",sObjectType);
	sAccountMonthSelectSQL = StringFunction.replace(sAccountMonthSelectSQL,"#ObjectNo",sObjectNo);
	sAccountMonthSelectSQL = StringFunction.replace(sAccountMonthSelectSQL,"#ModelType",sModelType);
	sDefaultModelNoSQL = StringFunction.replace(sDefaultModelNoSQL,"#ObjectType",sObjectType);
	sDefaultModelNoSQL = StringFunction.replace(sDefaultModelNoSQL,"#ObjectNo",sObjectNo);
	sDefaultModelNoSQL = StringFunction.replace(sDefaultModelNoSQL,"#ModelType",sModelType);

	//ȡ�ö�Ӧ������ģ��
	if(sDefaultModelNoSQL!=null && !sDefaultModelNoSQL.equals("")){
		sDefaultModelNo = Sqlca.getString(sDefaultModelNoSQL);
	}
	String sModelTypeName = Sqlca.getString("select ItemName from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo='"+sModelType+"'");

	//ȡ�ÿͻ�����
	String sObjectName = Sqlca.getString("select CustomerName from CUSTOMER_INFO where CustomerID='"+sObjectNo+"' ");
	
	//ȡ�ÿͻ�����
	String sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID='"+sObjectNo+"' ");
	
	//ȡ��ǰ�����û�¼�빫˾�ͻ���Ϣʱ�Ƿ���Ȩʹ��С��ҵ����ģ��
	String sIsUseSmallTemplet = "";
	if(sCustomerType.substring(0,2).equals("01"))
	{
	    sIsUseSmallTemplet = Sqlca.getString("select IsUseSmallTemplet from ORG_INFO where OrgID = '"+CurOrg.OrgID+"' ");
		if (sIsUseSmallTemplet == null) sIsUseSmallTemplet = "";
	}
	//add by hldu 
	//ȥ�Ƿ�ͣ�ò������õȼ�����
	String sIsInuse = Sqlca.getString(" select IsInuse  from code_library where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' ");
	if(sIsInuse == null) sIsInuse = "";
	//add end
	
%> 
<%/*END*/%>

<html>
<head><title><%=sModelTypeName%> - ����</title></head>
<body bgcolor="#DCDCDC" leftmargin="0" topmargin="0">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
			<td width="10%">&nbsp;</td>
			<td width="100%" align="left" valign="top"> 
			<form name="evaluate">
				<table width="100%" align="left" border="0" cellspacing="0" cellpadding="5">
				<tr> 
					<td>&nbsp;</td>
				</tr>
<%
				if(sAccountMonthInputType.equals("select")&&!"113".equals(sDefaultModelNo)){//bllou �½���ҵ�����������ڱ���Ļ����ϣ����ԣ����ڿ�������ѡ�� 2012-10-11){
					if(sAccountMonthSelectSQL==null || sAccountMonthSelectSQL.equals(""))
						throw new Exception("����������("+sModelType+")����·����뷽ʽΪ select ������û�ж��� AccountMonthSelectSQL"+"   sModelTypeAttributes:"+sModelTypeAttributes);
%> 
				<tr> 
					<td nowrap> �·ݣ� 
						<select name="AccountMonth" class="right">
							<%=HTMLControls.generateDropDownSelect(Sqlca,sAccountMonthSelectSQL,1,1,"")%> 
						</select>
						(<%=sAccountMonthExplanation%>)
					</td>
				</tr>
<% 
				}
				else{
%> 
				<tr> 
					<td nowrap> �·ݣ� 
						<SELECT id="AccountMonth" name="AccountMonth" class=loginInput>
<%
						int iMonth = 0;
						String sVisibleString = StringFunction.getToday().substring(0,7);
						for(iMonth=0;iMonth<24;iMonth++){
							out.println("<OPTION value='"+sVisibleString+"'>"+sVisibleString+"</OPTION>");
							sVisibleString = StringFunction.getRelativeAccountMonth(sVisibleString,"Month",-1);
						}
%>
						</SELECT>
					</td>
				</tr>
<%
				}
%>
			<tr> 
				<td>&nbsp;</td>
			</tr>
			<tr> 
				<td nowrap> ģ�ͣ� 
					<select name="ModelNo" class="right">
<% 
						if (sModelType.equals("010")||sModelType.equals("012")||sModelType.equals("015")||sModelType.equals("915")||sModelType.equals("910"))	// change by hldu
						{
							// "С��ҵ����ģ��"���ƹ����Ż�
							if(sIsUseSmallTemplet.equals("1"))
							{
								out.print(HTMLControls.generateDropDownSelect(Sqlca,"select ModelNo,ModelName from EVALUATE_CATALOG where ModelType='"+sModelType+"' and ModelNo = '"+sDefaultModelNo+"'  order by ModelNo ",1,2,sDefaultModelNo));
							}else{
								out.print(HTMLControls.generateDropDownSelect(Sqlca,"select ModelNo,ModelName from EVALUATE_CATALOG where ModelType='"+sModelType+"' and ModelNo = '"+sDefaultModelNo+"' and ModelNo not like '30%'  order by ModelNo ",1,2,sDefaultModelNo));// change by hldu
							}
						}
						else if(sModelType.equals("080")&&sCustomerType.equals("0107"))//ͬҵ�����޶�
						{
							out.print(HTMLControls.generateDropDownSelect(Sqlca,"select ModelNo,ModelName from EVALUATE_CATALOG where ModelType='"+sModelType+"'  and ModelNo='CreditLineFinance' order by ModelNo ",1,2,sDefaultModelNo));
						}
						else if(sModelType.equals("080"))//�����ͻ������޶�
						{
							out.print(HTMLControls.generateDropDownSelect(Sqlca,"select ModelNo,ModelName from EVALUATE_CATALOG where ModelType='"+sModelType+"'  and ModelNo='CreditLine' order by ModelNo ",1,2,sDefaultModelNo));
						}
						//add by hldu 
						else if((sModelType.equals("017") && !sIsInuse.equals("2")) || (sModelType.equals("917") && sIsInuse.equals("2")))
						{
							out.print(HTMLControls.generateDropDownSelect(Sqlca,"select ModelNo,ModelName from EVALUATE_CATALOG where ModelType='"+sModelType+"' and ModelNo = '"+sDefaultModelNo+"'  order by ModelNo ",1,2,sDefaultModelNo));
						}
						//add end
						else
						{
							out.print(HTMLControls.generateDropDownSelect(Sqlca,"select ModelNo,ModelName from EVALUATE_CATALOG where ModelType='"+sModelType+"' order by ModelNo ",1,2,sDefaultModelNo));
						}
%>
					</select>
				</td>
			</tr>
			<tr> <td>&nbsp;</td>  </tr>
			<tr> 
				<td> 
					<table width="70%" border="0">
						<tr> 
							<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>  
							<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȷ��","ȷ������������","javascript:setNext()",sResourcesPath)%></td>
			    		<td><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","ȡ��","ȡ��������","javascript:self.close();",sResourcesPath)%></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		</form>
    </td>
  </tr>
</table>
</body>
</html>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
<script type="text/javascript">
	function setNext() {
		sAccountMonth = document.forms("evaluate").AccountMonth.value;
		sModelNo = document.forms("evaluate").ModelNo.value;
		if(sAccountMonth==""){
			alert(getBusinessMessage('191'));//����ѡ���Ʊ����·ݣ�
			return;
		}
		if(!isDateForAccountMonth(sAccountMonth+"/01")){
			alert(getBusinessMessage('192'));//��������ȷ�Ļ�Ʊ����·ݸ�ʽ��YYYY/MM����
			return;
		}
		if(sModelNo==""){
			alert(getBusinessMessage('193'));//����ѡ��һ��ģ�ͣ�
			return;
		} 
		self.returnValue="<%=sObjectType%>@<%=sObjectNo%>@<%=sModelType%>@"+sModelNo+"@"+sAccountMonth;
		self.close();
	} 
	function isDateForAccountMonth(sItemName) {
		var sItems = sItemName.split("/");
		if (sItems.length!=3) return false;
		if (isNaN(sItems[0])) return false;
		if (isNaN(sItems[1])) return false;
		if (isNaN(sItems[2])) return false;
		if (parseInt(sItems[0],10)<1900 || parseInt(sItems[0],10)>2050) return false;
		if (parseInt(sItems[1],10)<1 || parseInt(sItems[1],10)>12) return false;
		if (parseInt(sItems[2],10)<1 || parseInt(sItems[2],10)>31) return false;
		return true;
	}
</script>
<%/*END*/%>

<%@ include file="/IncludeEnd.jsp"%>