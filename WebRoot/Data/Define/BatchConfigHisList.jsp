<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: zywei 2005-11-27
			Tester:
			Describe: ҵ����������Ӧ�������ĵ�����Ϣ�б�;
			Input Param:
			ObjectType���������ͣ�CreditApply��
			ObjectNo: �����ţ�������ˮ�ţ�
			Output Param:
			
			HistoryLog:
						
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "��������������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "";//Sql���
	ASResultSet rs = null;//�����
	String sCodeNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CodeNo")));
	String sCItemNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo")));
	String sCItemNoSql="";
	if(!"XX".equals(sCItemNo)){
		sCItemNoSql=" and locate('"+sCItemNo+"',ItemNo)>0";
	}
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = {
	{"ItemNo","��ˮ��"},
	{"ItemName","ģ������"},
	{"ItemDescribe","����Ҫ��"},
	{"Attribute1","Excel����Ҫ��"},
	{"IsInUse","��Ч"},
	{"UpdateUserName","������"},
	{"UpdateTime","����ʱ��"}
		};
	sSql =  " select  CodeNo,ItemNo,ItemName,SortNo,"+
	" getItemName('SModelColumns',ItemDescribe) as ItemDescribe,"+
	" Attribute1,"+
	" getItemName('YesNo',IsInUse) as IsInUse,"+
	" getUserName(UpdateUser) as UpdateUserName,"+
	" UpdateTime"+
	" from Code_Library "+
	" where  CodeNo = '"+sCodeNo+"'"+
	sCItemNoSql+
	" order by ItemDescribe,ItemNo asc";
	
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable= "Code_Library";
	doTemp.setKey("CodeNo,ItemNo",true);
	//���ø�ʽ
	doTemp.setVisible("CodeNo,ItemName,SortNo",false);
	//doTemp.setHTMLStyle("Attribute1,Attribute2,Attribute3,Attribute4"," style={width:auto} ");
	//�����ֶ���ʾ���	
	doTemp.appendHTMLStyle("Status"," style={width:90px} onDBLClick=parent.selectOrUnselect() ");
	doTemp.setColumnAttribute("OwnerName,GCSerialNo,GuarantyRightID,ImpawnID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	if(sCItemNo.length()==0){
		doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	}
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);
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
		{(sCItemNo.length()==0?"true":"false"),"","Button","����","����","newRecord()",sResourcesPath},
		{(sCItemNo.length()==0?"true":"false"),"","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
		{(sCItemNo.length()==0?"true":"false"),"","Button","����","�鿴","viewAndEdit()",sResourcesPath},
		{(sCItemNo.length()==0?"true":"false"),"","Button","�鿴��ǰ�޸���ʷ","�鿴�޸���ʷ","viewModifiedHis('Some')",sResourcesPath},
		{(sCItemNo.length()==0?"true":"false"),"","Button","�鿴�����޸���ʷ","�鿴�޸���ʷ","viewModifiedHis('All')",sResourcesPath},
		{(sCItemNo.length()==0?"false":"true"),"","Button","����","����","goBack()",sResourcesPath}
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

	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/Common/Configurator/EvaluateManage/EvaluateScoreConfigInfo.jsp?CodeNo=<%=sCodeNo%>","_self","");
		//popComp("EvaluateScoreConfigInfo.jsp","/Common/Configurator/EvaluateManage/EvaluateScoreConfigInfo.jsp","ModelNo=<sModelNo&ItemNo=sItemNo&CodeNo=sCodeNo","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		var sItemNo = getItemValue(0,getRow(),"ItemNo");//--ѺƷ����������ˮ��
		if(typeof(sItemNo)=="undefined" || sItemNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			backupHis();
			as_del('myiframe0');
   		    as_save('myiframe0');  //�������ɾ��,��Ҫ���ô����
   		   // reloadSelf();
		}
	}

	/*~[Describe=�鿴���޸�ѺƷ����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
		if(typeof(sItemNo)=="undefined" || sItemNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//popComp("EvaluateScoreConfigInfo.jsp","/Common/Configurator/EvaluateManage/EvaluateScoreConfigInfo.jsp","ModelNo="+sItemNo,"");
		OpenPage("/Common/Configurator/EvaluateManage/EvaluateScoreConfigInfo.jsp?CodeNo=<%=sCodeNo%>&CItemNo="+sItemNo,"_self","");
		//reloadSelf();
	}
   	function goBack(){
		OpenPage("/Common/Configurator/EvaluateManage/EvaluateScoreConfigList.jsp","_self","");
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
		function viewModifiedHis(flag)
		{
			var sItemNo='XX';
			if(flag=='Some'){
				sItemNo = getItemValue(0,getRow(),"ItemNo");
				if(typeof(sItemNo)=="undefined" || sItemNo.length==0) 
				{
					alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
					return;
				}
			}
			//OpenComp("EvaluateScoreConfigList","/Common/Configurator/EvaluateManage/EvaluateScoreConfigList.jsp","ModelNo="+sModelNo+"&ItemNo="+sItemNo+"&ValueCode="+sValueCode+"&ValueMethod="+sValueMethod+"&CodeNo=ScoreToItemValue","DetailFrame","");
		  	OpenPage("/Common/Configurator/EvaluateManage/EvaluateScoreConfigList.jsp?CItemNo="+sItemNo,"DetailFrame","");
		}
	    /*~[Describe=�޸�ǰ����һ�ݱ���;InputParam=��;OutPutParam=��;]~*/
	   	function backupHis(){
	   		var CodeNo = getItemValue(0,getRow(),"CodeNo");
	   		var ItemNo = getItemValue(0,getRow(),"ItemNo");
	   		RunMethod("SystemManage","InsertScoreConfigInfo",CodeNo+","+ItemNo);
		}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	
	//initRow();
	//var bCheckBeforeUnload=false;
</script>
<%
	/*~END~*/
%>
<%@	include file="/IncludeEnd.jsp"%>