<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:zywei 20050826
			Tester:
			Content: ѡ�����ͶԻ���ҳ��
			Input Param:
		SelName����ѯ����
		ParaString�������ַ���
			Output param:
			History Log: 

		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/
%>
<%
	//��ȡ��������ѯ���ƺͲ���
	String sSelName  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SelName"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParaString"));
	
	//����ֵת��Ϊ���ַ���
	if(sSelName == null) sSelName = "";
	if(sParaString == null) sParaString = "";
		
	//�����������ѯ�����
	ASResultSet rs = null;
	//���������SQL���
	String sSql = "";
	//�����������ѯ���͡�չ�ַ�ʽ��������������
	String sSelType = "",sSelBrowseMode = "",sSelArgs = "",sSelHideField = "";
	//������������롢�ֶ���ʾ�������ơ�����������
	String sSelCode = "",sSelFieldName = "",sSelTableName = "",sSelPrimaryKey = "";
	//����������ֶ���ʾ��񡢷���ֵ�������ֶΡ�ѡ��ʽ
	String sSelFieldDisp = "",sSelReturnValue = "",sSelFilterField = "",sMutilOrSingle = "";
	//�������������1������2������3������4������5
	String sAttribute1 = "",sAttribute2 = "",sAttribute3 = "",sAttribute4 = "",sAttribute5 = "";
	//������������鳤��
	int l = 0;
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "ѡ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=����ҵ���߼�;]~*/
%>
<%
	sSql =  " select SelType,SelTableName,SelPrimaryKey,SelBrowseMode,SelArgs,SelHideField,SelCode, "+
	" SelFieldName,SelFieldDisp,SelReturnValue,SelFilterField,MutilOrSingle,Attribute1, "+
	" Attribute2,Attribute3,Attribute4,Attribute5 "+
	" from SELECT_CATALOG "+
	" where SelName = '"+sSelName+"' "+
	" and IsInUse = '1' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next()){
		sSelType = rs.getString("SelType");
		sSelTableName = rs.getString("SelTableName");
		sSelPrimaryKey = rs.getString("SelPrimaryKey");
		sSelBrowseMode = rs.getString("SelBrowseMode");
		sSelArgs = rs.getString("SelArgs");
		sSelHideField = rs.getString("SelHideField");
		sSelCode = rs.getString("SelCode");
		sSelFieldName = rs.getString("SelFieldName");
		sSelFieldDisp = rs.getString("SelFieldDisp");
		sSelReturnValue = rs.getString("SelReturnValue");
		sSelFilterField = rs.getString("SelFilterField");
		sMutilOrSingle = rs.getString("MutilOrSingle");
		sAttribute1 = rs.getString("Attribute1");
		sAttribute2 = rs.getString("Attribute2");
		sAttribute3 = rs.getString("Attribute3");
		sAttribute4 = rs.getString("Attribute4");
		sAttribute5 = rs.getString("Attribute5");
	}
	rs.getStatement().close();

	//����ֵת��Ϊ���ַ���
	if(sSelType == null) sSelType = "";
	if(sSelTableName == null) sSelTableName = "";
	if(sSelPrimaryKey == null) sSelPrimaryKey = "";
	if(sSelBrowseMode == null) sSelBrowseMode = "";
	if(sSelArgs == null) sSelArgs = "";
	else sSelArgs = sSelArgs.trim();
	if(sSelHideField == null) sSelHideField = "";
	else sSelHideField = sSelHideField.trim();
	if(sSelCode == null) sSelCode = "";
	else sSelCode = sSelCode.trim();	
	if(sSelFieldName == null) sSelFieldName = "";
	else sSelFieldName = sSelFieldName.trim();
	if(sSelFieldDisp == null) sSelFieldDisp = "";
	else sSelFieldDisp = sSelFieldDisp.trim();
	if(sSelReturnValue == null) sSelReturnValue = "";
	else sSelReturnValue = sSelReturnValue.trim();
	if(sSelFilterField == null) sSelFilterField = "";
	else sSelFilterField = sSelFilterField.trim();
	if(sMutilOrSingle == null) sMutilOrSingle = "";
	if(sAttribute1 == null) sAttribute1 = "";
	if(sAttribute2 == null) sAttribute2 = "";
	if(sAttribute3 == null) sAttribute3 = "";
	if(sAttribute4 == null) sAttribute4 = "";
	if(sAttribute5 == null) sAttribute5 = "";
	
	//��ȡ����ֵ
	StringTokenizer st = new StringTokenizer(sSelReturnValue,"@");
	String [] sReturnValue = new String[st.countTokens()];  
	while (st.hasMoreTokens()) 
	{
		sReturnValue[l] = st.nextToken();                
		l ++;
	}
	//������ʾ����
	String sHeaders = sSelFieldName;
	
	//��Sql�еı��������Ӧ��ֵ�滻	
	StringTokenizer stArgs = new StringTokenizer(sParaString,",");
	while (stArgs.hasMoreTokens()) 
	{
		try{
	String sArgName  = stArgs.nextToken().trim();
	String sArgValue  = stArgs.nextToken().trim();		
	sSelCode = StringFunction.replace(sSelCode,"#"+sArgName,sArgValue );		
		}catch(NoSuchElementException ex){
	throw new Exception("���������ʽ����");
		}
	}
%>

<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=����ҵ���߼�;]~*/
%>
<html>
<head> 
<title><%=PG_TITLE%></title>
<script language=javascript src="<%=sResourcesPath%>/expand.js"></script>

<script language=javascript>
	function TreeViewOnClick()
	{		
		var sType = getCurTVItem().type;
		var sName = getCurTVItem().name;
		var sValue = getCurTVItem().value;
		if(sValue == "root")
		{
			buff.ReturnString.value = "root";
		}else
		{
			if(sType == "page" && "<%=sAttribute2%>" == '2')
			{
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.sObjectInfo = buff.ReturnString.value;
			}else if("<%=sAttribute2%>" == '1')
			{	
				buff.ReturnString.value = sValue + "@" + sName;				
				parent.sObjectInfo = buff.ReturnString.value;
			}else
			{
				alert("ҳ�ڵ���Ϣ����ѡ��������ѡ��");
			}
		}
	}
	
	function startMenu() 
	{
	<%HTMLTreeView tviTemp = new HTMLTreeView(SqlcaRepository,CurComp,sServletURL,"ѡ����Ϣ�б�","right");
		tviTemp.TriggerClickEvent=true;		
		
		//����������������Ϊ��
		//ID�ֶ�(����),Name�ֶ�(����),Value�ֶ�,Script�ֶ�,Picture�ֶ�,From�Ӿ�(����),OrderBy�Ӿ�,Sqlca
		tviTemp.initWithSql(sSelHideField,sSelFieldDisp,sSelFieldName,"","",sSelCode,sSelFilterField,Sqlca);		
		
		tviTemp.ImageDirectory = sResourcesPath; //������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		out.println(tviTemp.generateHTMLTreeView());%>
		expandNode('root');	
		<%int j = sAttribute1.split("@").length;
		String sExportNode[] = new String[20];
		sExportNode = sAttribute1.split("@");
		for(int i=0;i<j;i++)
		{%>
			try{
				expandNode('<%=sExportNode[i]%>');		
			}catch(e)
			{
	
			}
		<%}%>
	}
	
	
</script>
<style>

.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}

</style>
</head>

<body class="pagebackground">
	<center>
		<form  name="buff">
		<input type="hidden" name="ReturnString" value="">
			<table width="90%" border='1' height="98%" cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
				<tr> 
        				<td id="myleft"  align=center width=100%><iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe></td>
				</tr>
			</table>
		</form>
	</center>
</body>
<script>
	startMenu();	
</script>
</html>
<%
	/*~END~*/
%>


<%@ include file="/IncludeEnd.jsp"%>