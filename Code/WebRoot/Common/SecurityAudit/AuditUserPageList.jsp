<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: FSGong  2005-01-26
*
*	Tester:
*	Describe: �ܻ��Ĳ����ʲ����ٲ�ѯ
*	Input Param:
*	Output Param:     
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҳ�����ʱ����־"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%/*~END~*/%>         
                      
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"UserID","�û���"},
							{"UserName","�û�����"},
							{"JspName","����ҳ��"},
							{"BeginTime","���ʿ�ʼʱ��"},
							{"EndTime","���ʽ���ʱ��"},
							{"TimeConsuming","����(��)"},
						}; 

 	String sSql = "select SessionID,UserID,getUserName(UserID) as UserName,JspName, BeginTime, " +
 				  "EndTime,TimeConsuming from USER_RUNTIME where 1=1 and BeginTime like ('" +
 				  StringFunction.getToday().substring(0,4)+StringFunction.getToday().substring(5,7)+
 				  StringFunction.getToday().substring(8,10)+"%')";

	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);	
	doTemp.setHeader(sHeaders);	
    doTemp.setKey("SessionID",true);
	doTemp.setVisible("SessionID,RuntimeID",false);	
	
	doTemp.UpdateTable = "USER_RUNTIME";
	doTemp.setHTMLStyle("UserName"," style={width:90px} ");
	doTemp.setHTMLStyle("UserID"," style={width:60px} ");
	doTemp.setHTMLStyle("TimeConsuming"," style={width:30px} ");
	doTemp.setHTMLStyle("JspName"," style={width:300px} ");
	//���ö��뷽ʽ
	doTemp.setAlign("TimeConsuming","3");
	doTemp.setAlign("UserName,BeginTime,EndTime","2");
	doTemp.setAlign("JspName","1");
	doTemp.setCheckFormat("TimeConsuming","2");
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("UserID,UserName,BeginTime,EndTime","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and BeginTime like '"+StringFunction.getToday()+" "+StringFunction.getNow().substring(0,5)+"%'";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	dwTemp.setPageSize(40); 	//��������ҳ
	//out.println(doTemp.SourceSql);
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
				

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
		{"true","","PlainText","���ڱ�ҳ��������������ͨ����ѯ������ѯ","���ڱ�ҳ��������������ͨ����ѯ������ѯ","style={color:red}",sResourcesPath}		
		};
%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	
</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	showFilterArea();
</script>
<%/*~END~*/%>

<%@include file="/IncludeEnd.jsp"%>
