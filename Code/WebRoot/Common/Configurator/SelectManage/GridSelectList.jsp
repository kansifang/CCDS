<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei 2005-11-27
		Tester:
		Content: �б��ѯѡ��
		Input Param:
                  
		Output param:
		                
		History Log: 
		  zywei 2007/10/11 ����Attribute4Ϊ�Ƿ���ݼ���������ѯ�����������������ѯ�������Ӧ�ӳ�
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������	
	
	//���ҳ�����	
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	String[][] sHeaders={
				{"SelName","��ѯ����"},
				{"SelDescribe","��ѯ˵��"},
				{"SelType","��ѯ����"},
				{"SelTableName","��ѯ����"},
				{"SelPrimaryKey","����"},
				{"SelBrowseMode","չ�ַ�ʽ"},
				{"SelArgs","����"},
				{"SelHideField","������"},				
				{"SelCode","��ѯʵ�ִ���"},
				{"SelFieldName","�б���ʾ����"},
				{"SelFieldDisp","�б���ʾ���"},
				{"SelReturnValue","������"},
				{"SelFilterField","������"},
				{"MutilOrSingle","ѡ��ģʽ"},
				{"Attribute1","��ʾ�ֶζ��뷽ʽ"},
				{"Attribute2","��ʾ�ֶ�����"},
				{"Attribute3","��ʾ�ֶμ��ģʽ"},	
				{"Attribute4","�Ƿ���ݼ���������ѯ"},
				{"IsInUse","�Ƿ���Ч"}			
			};

	sSql =  " select SelName,SelDescribe,SelType,SelTableName,SelPrimaryKey,SelBrowseMode, "+
			" SelArgs,SelHideField,SelCode,SelFieldName,SelFieldDisp,SelReturnValue, "+
			" SelFilterField,MutilOrSingle,Attribute1,Attribute2,Attribute3, "+
			" getItemName('YesNo',Attribute4) as Attribute4, "+
			" getItemName('IsInUse',IsInUse) as IsInUse "+
			" from SELECT_CATALOG "+
			" where SelBrowseMode = 'Grid' "+
			" order by UpdateTime desc ";

	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.UpdateTable="SELECT_CATALOG";
	doTemp.setKey("SelName",true);
	doTemp.setHeader(sHeaders);

	//��ѯ
 	doTemp.setColumnAttribute("SelName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);

	//��������¼�
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
%>

<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ��
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	var sCurCodeNo=""; //��¼��ǰ��ѡ���еĴ����

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/Common/Configurator/SelectManage/GridSelectInfo.jsp","_self","");      
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
        sSelName = getItemValue(0,getRow(),"SelName");
        if(typeof(sSelName) == "undefined" || sSelName.length == 0) 
        {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
        
        OpenPage("/Common/Configurator/SelectManage/GridSelectInfo.jsp?SelName="+sSelName,"_self","");           
	}
    
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSelName = getItemValue(0,getRow(),"SelName");
        if(typeof(sSelName) == "undefined" || sSelName.length == 0) 
        {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return ;
		}
		
		if(confirm(getHtmlMessage('45'))) 
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	function mySelectRow()
	{
        
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
    
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
