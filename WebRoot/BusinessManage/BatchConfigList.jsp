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
	//�������������������͡������š�����Ȩ��
	String sCodeNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo")));//"BatchColumnConfig";)
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
					{"Attribute2","Ҫ������"},
					{"IsInUse","��Ч"},
					{"UpdateUserName","������"},
					{"UpdateTime","����ʱ��"}
				};
	sSql =  " select  CodeNo,ItemNo,ItemName,SortNo,"+
		" getItemName('SModelColumns',ItemDescribe) as ItemDescribe,"+
		" Attribute1,"+
		" getItemName('DataType',Attribute2) as Attribute2,"+
		" getItemName('YesNo',IsInUse) as IsInUse,"+
		" getUserName(UpdateUser) as UpdateUserName,"+
		" UpdateTime"+
		" from Code_Library "+
		" where  CodeNo = '"+sCodeNo+"'"+
		" and IsInUse='1'"+
		" order by ItemNo asc";
	
	//��sSql�������ݴ������
	ASDataObject doTemp = null;
	//���ñ�ͷ,���±���,��ֵ,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setVisible("Attribute3,Attribute4",false);
	doTemp.setRequired("Attribute5",true);
	doTemp.setHTMLStyle("Attribute5"," style={width:1000px} ");
	doTemp.UpdateTable= "Code_Library";
	doTemp.setKey("CodeNo,ItemNo",true);
	//���ø�ʽ
	doTemp.setVisible("CodeNo,ItemName,SortNo",false);
	//doTemp.setHTMLStyle("Attribute1,Attribute2,Attribute3,Attribute4"," style={width:auto} ");
	//�����ֶ���ʾ���	
	//doTemp.appendHTMLStyle("Status"," style={width:90px} onDBLClick=parent.selectOrUnselect() ");
	//doTemp.setColumnAttribute("OwnerName,GCSerialNo,GuarantyRightID,ImpawnID","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
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
		{"true","","Button","����","����","newRecord()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},
		{"true","","Button","����","�鿴","viewAndEdit()",sResourcesPath},
		{"true","","Button","�鿴��ǰ�޸���ʷ","�鿴�޸���ʷ","viewModifiedHis('Some')",sResourcesPath},
		{"true","","Button","�鿴�����޸���ʷ","�鿴�޸���ʷ","viewModifiedHis('All')",sResourcesPath}
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
		//OpenPage("/BusinessManage/BatchConfigInfo.jsp?CodeNo=<%=sCodeNo%>","_self","");
		popComp("BatchConfigInfo.jsp","/BusinessManage/BatchConfigInfo.jsp","CodeNo=<%=sCodeNo%>","dialogWidth=35;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		reloadSelf();
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
		var sCodeNo = getItemValue(0,getRow(),"CodeNo");
		var sItemNo = getItemValue(0,getRow(),"ItemNo");
		if(typeof(sItemNo)=="undefined" || sItemNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("BatchConfigInfo","/BusinessManage/BatchConfigInfo.jsp","CodeNo="+sCodeNo+"&ItemNo="+sItemNo,"dialogWidth=40;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		reloadSelf();
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
			sCodeNo = getItemValue(0,getRow(),"CodeNo");
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
		  	PopPage("/BusinessManage/BatchConfigHisList.jsp?CodeNo="+sCodeNo+"&ItemNo="+sItemNo,"DetailFrame","dialogWidth=50;dialogHeight=30;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
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