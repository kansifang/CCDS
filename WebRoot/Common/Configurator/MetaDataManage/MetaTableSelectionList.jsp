<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui  2003.8.18
		Tester:
		Content: ��ҵծȯ������Ϣ_List
		Input Param:
			                CustomerID���ͻ����
			                CustomerRight:Ȩ�޴���----01�鿴Ȩ��02ά��Ȩ��03����ά��Ȩ
		Output param:
		                CustomerID����ǰ�ͻ�����Ŀͻ���
		              	Issuedate:��������
		              	BondType:ծȯ����
		                CustomerRight:Ȩ�޴���
		                EditRight:�༭Ȩ�޴���----01�鿴Ȩ��02�༭Ȩ
		History Log: 
		                 2003.08.20 CYHui
		                 2003.08.28 CYHui
		                 2003.09.08 CYHui 
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
	String sSql;
	
	//���ҳ�����	
	//sCustomerID =  DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
   	String sHeaders[][] = {
				{"DatabaseID","���ݿ�ID"},
				{"TableID","��ID"},
				{"TableName","����"},
				{"IsInUse","��Ч"},
				{"TableType","���ݿ�����ID"},
			       };  

	sSql = " Select  "+
				"DatabaseID,"+
				"TableID,"+
				"TableName,"+
				"getItemName('IsInUse',IsInUse) as IsInUse,"+
				"TableType "+
				"From META_TABLE where 1=1";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="META_TABLE";
	doTemp.setKey("DatabaseID",true);
	doTemp.setHeader(sHeaders);

	doTemp.setHTMLStyle("DatabaseID"," style={width:160px} ");
	doTemp.setHTMLStyle("TableID"," style={width:160px} ");
	doTemp.setHTMLStyle("TableName"," style={width:160px} ");
	doTemp.setHTMLStyle("IsInUse"," style={width:60px} ");
	doTemp.setHTMLStyle("TableType"," style={width:160px} ");
	
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);

	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
		{"true","","Button","ȷ��","����ѡ�еļ�¼","returnSelection()",sResourcesPath},
		{"true","","Button","ȡ��","ȡ��","cancel()",sResourcesPath}
		};
	%> 
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=����ѡ����Ϣ;InputParam=��;OutPutParam=��;]~*/
	function returnSelection()
	{
		sDatabaseID=getItemValue(0,getRow(),"DatabaseID");
		sTableID=getItemValue(0,getRow(),"TableID");
		if (typeof(sTableID)=="undefined" || sTableID.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		parent.returnValue = sDatabaseID+"@"+sTableID;
		parent.close();
	}
	/*~[Describe=ȡ��;InputParam=��;OutPutParam=��;]~*/
	function cancel()
	{
		self.returnValue = "_CANCEL_";
		self.close();
	}
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	
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