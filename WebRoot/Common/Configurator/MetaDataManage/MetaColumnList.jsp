<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:   CYHui  2003.8.18
			Tester:
			Content: �ֶ�_List
			Input Param:
		 
			Output param:
			           
			History Log: 
			      
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "δ����ģ��123"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql;
	
	//���ҳ�����	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = {
		{"DatabaseID","����ID"},	
		{"TableID","��ID"},
		{"ColID","�ֶ���"},
		{"ColName","�ֶ�������"},
		{"IsInUse","��Ч"},
		{"SortNo","�����"},
		{"ColType","�ֶ�����"},
		{"DomainID","������"},
		{"DefaultValue","ȱʡֵ"},
		{"CheckFormat","����ʽ"},
		{"ValidationType","У������"},
		{"ValidationCode","У�����"},
		{"ColLimit","��������"},
		{"ColKey","�Ƿ�ؼ���"},
		{"IsForeignKey","�Ƿ����"},
		{"DataPrecision","��Чλ��"},
		{"DataScale","С�����λ��"},
		{"Attribute1","����1"},
		{"Attribute2","����2"},
		{"Attribute3","����3"},
		{"Attribute4","����4"},
		{"Attribute5","����5"},
	       };  

	sSql = " Select  "+
		"DatabaseID,"+
		"TableID,"+
		"ColID,"+
		"ColName,"+
		"IsInUse,"+
		"SortNo,"+
		"ColType,"+
		"DomainID,"+
		"DefaultValue,"+
		"CheckFormat,"+
		"ValidationType,"+
		"ValidationCode,"+
		"ColLimit,"+
		"ColKey,"+
		"IsForeignKey,"+
		"DataPrecision,"+
		"DataScale,"+
		"Attribute1,"+
		"Attribute2,"+
		"Attribute3,"+
		"Attribute4,"+
		"Attribute5 "+
		"From META_COLUMN where 1=1";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="META_COLUMN";
	doTemp.setKey("DatabaseID,TableID,ColID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("DatabaseID"," style={width:160px} ");
	doTemp.setHTMLStyle("TableID"," style={width:160px} ");
	doTemp.setHTMLStyle("ColID"," style={width:160px} ");
	doTemp.setHTMLStyle("ColName"," style={width:160px} ");
	doTemp.setHTMLStyle("IsInUse"," style={width:160px} ");
	doTemp.setHTMLStyle("SortNo"," style={width:160px} ");
	doTemp.setHTMLStyle("ColType"," style={width:160px} ");
	doTemp.setHTMLStyle("DomainID"," style={width:160px} ");
	doTemp.setHTMLStyle("DefaultValue"," style={width:160px} ");
	doTemp.setHTMLStyle("CheckFormat"," style={width:160px} ");
	doTemp.setHTMLStyle("ValidationType"," style={width:160px} ");
	doTemp.setHTMLStyle("ValidationCode"," style={width:160px} ");
	doTemp.setHTMLStyle("ColLimit"," style={width:160px} ");
	doTemp.setHTMLStyle("ColKey"," style={width:160px} ");
	doTemp.setHTMLStyle("IsForeignKey"," style={width:160px} ");
	doTemp.setHTMLStyle("DataPrecision"," style={width:160px} ");
	doTemp.setHTMLStyle("DataScale"," style={width:160px} ");
	doTemp.setHTMLStyle("Attribute1"," style={width:160px} ");
	doTemp.setHTMLStyle("Attribute2"," style={width:160px} ");
	doTemp.setHTMLStyle("Attribute3"," style={width:160px} ");
	doTemp.setHTMLStyle("Attribute4"," style={width:160px} ");
	doTemp.setHTMLStyle("Attribute5"," style={width:160px} ");

	//����С����ʾ״̬,
	doTemp.setAlign("DataPrecision,DataScale","3");
	doTemp.setType("DataPrecision,DataScale","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("DataPrecision,DataScale","2");

	//���ò��ɼ���
	doTemp.setVisible("DefaultValue,CheckFormat,ValidationType,ValidationCode,ColLimit,ColKey,IsForeignKey,DataPrecision,DataScale,Attribute1,Attribute2,Attribute3,Attribute4,Attribute5",false);	    
	

	//��ѯ
 	doTemp.setColumnAttribute("DatabaseID,TableID,ColID,DataPrecision","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" And 1=2";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(200);

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
%>
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
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath}
			};
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		popComp("MetaColumnInfo","/Common/Configurator/MetaDataManage/MetaColumnInfo.jsp","","");
		reloadSelf();
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sColID = getItemValue(0,getRow(),"ColID");
		
		if (typeof(sColID)=="undefined" || sColID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sDatabaseID=getItemValue(0,getRow(),"DatabaseID");
		sTableID=getItemValue(0,getRow(),"TableID");
		sColumnID=getItemValue(0,getRow(),"ColID");
		if (typeof(sColumnID)=="undefined" || sColumnID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("MetaColumnInfo","/Common/Configurator/MetaDataManage/MetaColumnInfo.jsp","DatabaseID="+sDatabaseID+"&TableID="+sTableID+"&ColumnID="+sColumnID,"");
	}

	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>

	
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');

</script>	
<%
		/*~END~*/
	%>

<%@ include file="/IncludeEnd.jsp"%>
