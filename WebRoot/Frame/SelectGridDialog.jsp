<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 20050826
		Tester:
		Content: ѡ��Ի���ҳ��
		Input Param:
		Output param:
		History Log: 
			zywei 2007/10/11 �������������ѯ�������Ӧ�ӳ�
			xhgao 2009/04/09 ����KeyFilter�ӿ��ѯ�ٶȣ�����˫��ȷ��
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ѡ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
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
	//�����������ʾ�ֶζ��뷽ʽ����ʾ�ֶ����͡���ʾ�ֶμ��ģʽ���Ƿ���ݼ���������ѯ������5
	String sAttribute1 = "",sAttribute2 = "",sAttribute3 = "",sAttribute4 = "",sAttribute5 = "";
	//������������鳤��
	int l = 0;
	//��������������ֶεĸ���
	int iReturnFiledNum = 0;
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
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
	iReturnFiledNum = sReturnValue.length;
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
	
	//ʵ����DataObject	
	ASDataObject doTemp = new ASDataObject(sSelCode);
	doTemp.UpdateTable = sSelTableName;
	doTemp.setKey(sSelPrimaryKey,true);
	doTemp.setHeader(sHeaders);	
	
	//���������ֶ�	
	if(!sSelHideField.equals("")) doTemp.setVisible(sSelHideField,false);	
	
	//���ö����ʽ
	StringTokenizer stAlign = new StringTokenizer(sAttribute1,"@");
	while (stAlign.hasMoreTokens()) 
	{
		String sAlignName  = stAlign.nextToken().trim();
		String sAlignValue  = stAlign.nextToken().trim();		
		doTemp.setAlign(sAlignName,sAlignValue);  	
	}
	
	//��������
	StringTokenizer stType = new StringTokenizer(sAttribute2,"@");
	while (stType.hasMoreTokens()) 
	{
		String sTypeName  = stType.nextToken().trim();
		String sTypeValue  = stType.nextToken().trim();		
		doTemp.setType(sTypeName,sTypeValue);  	
	}
	
	//���ü��ģʽ
	StringTokenizer stCheck = new StringTokenizer(sAttribute3,"@");
	while (stCheck.hasMoreTokens()) 
	{
		String sCheckName  = stCheck.nextToken().trim();
		String sCheckValue  = stCheck.nextToken().trim();		
		doTemp.setCheckFormat(sCheckName,sCheckValue);  	
	}	
	
	//KeyFilter�ӿ��ѯ�ٶ�
	StringTokenizer stFilter = new StringTokenizer(sAttribute4,"@");
	String sFilter="";
	while (stFilter.hasMoreTokens()) 
	{
		String sFilterValue  = stFilter.nextToken().trim();	
		sFilter=sFilter+"||"+sFilterValue;
	}
	if(sFilter.length()>2)
	{
		doTemp.setKeyFilter(sFilter.substring(2,sFilter.length()));
	}
	
	//������ʾ��ʽ
	StringTokenizer stDisp = new StringTokenizer(sSelFieldDisp,"@");
	while (stDisp.hasMoreTokens()) 
	{
		String sDispName  = stDisp.nextToken().trim();
		String sDispValue  = stDisp.nextToken().trim();		
		doTemp.setHTMLStyle(sDispName,sDispValue);  
	}		
	
	//���ü�����
	if(!sSelFilterField.equals(""))
	{		
		doTemp.setColumnAttribute(sSelFilterField,"IsFilter","1");		
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	}
	
	doTemp.appendHTMLStyle(""," style=\"cursor:hand\" ondblclick=javascript:parent.parent.returnSelection() ");

	//�����Ҫ���ݼ���������ѯ�������Ĭ�ϲ�ѯΪ��
	if(sAttribute4.equals("1") && !doTemp.haveReceivedFilterCriteria())
		doTemp.WhereClause += " and 1=2 ";
	
	if(!sMutilOrSingle.equals("Single"))
		doTemp.multiSelectionEnabled=true;			
	//ʵ����DataWindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(15);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
	//out.println(doTemp.SourceSql); //������仰����datawindow
%>

<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�ύ;InputParam=��;OutPutParam=��;]~*/	
	function doSearch()
	{
		document.forms("form1").submit();
	}
	
	/*~[Describe=��ѡ���е���Ϣƴ���ַ���������;InputParam=��;OutPutParam=��;]~*/	
	function mySelectRow()
	{   
		if (getRow()<0) return;
		
		var sReturnValue = "";
		try{
			<%
			for(int j = 0 ; j < sReturnValue.length ; j ++)
			{			
			%>		
			sReturnValue += getItemValue(0,getRow(),"<%=sReturnValue[j]%>") + "@";
			<%					
			}
			%>
		}catch(e){
			return;
		}
		parent.sObjectInfo = sReturnValue; 
	}
	
	/*~[Describe=��ѡ���е���Ϣƴ���ַ���������;InputParam=��;OutPutParam=��;]~*/	
	function returnValue()
	{   
		var sReturnValue = "";
		var sMutilOrSingle = "<%=sMutilOrSingle%>";		
		if(sMutilOrSingle == "Multi")		//��ѡ
			sReturnValue = myMultiSelectRow();
		else
			sReturnValue = mySingleSelectRow();
		
		sReturnSplit = sReturnValue.split("@");//by jgao����Ϊ�ڷ���ʱ��ֻҪ�жϵ�һ����undefined���Ϳ���˵����û��ѡ���κ�����
		if(sReturnSplit[0]=="undefined")       //���������undefied�ġ�
		{
			parent.sObjectInfo="";
		}else{
			parent.sObjectInfo = sReturnValue;
		}		
	}
	
	/*~[Describe=��ѡ���е���Ϣƴ���ַ���������;InputParam=��;OutPutParam=��;]~*/	
	function mySingleSelectRow()
	{   
		try{			
			var sReturnValue = "";			
			<%
			for(int j = 0 ; j < iReturnFiledNum ; j ++)
			{			
			%>				
				sReturnValue += getItemValue(0,getRow(),"<%=sReturnValue[j]%>") + "@";
			<%					
			}
			%>				
		}catch(e){
			return;
		}				
		return (sReturnValue); 
	}
	
	/*~[Describe=��ѡ���е���Ϣƴ���ַ���������;InputParam=��;OutPutParam=��;]~*/	
	function myMultiSelectRow()
	{   
		try{
			var b = getRowCount(0);
			var sReturnValue = "";				
			for(var iMSR = 0 ; iMSR < b ; iMSR++)
			{
				var a = getItemValue(0,iMSR,"MultiSelectionFlag");				
				if(a == "��")
				{			
					<%
					for(int j = 0 ; j < iReturnFiledNum ; j ++)
					{		
					%>			
						sReturnValue += getItemValue(0,getRow(),"<%=sReturnValue[j]%>") + "@";
					<%
					}
					%>
				}				
			}
		}catch(e){
			return;
		}				
		return (sReturnValue); 
	}
			
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');		
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>