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
	String sType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("type")));//"BatchColumnConfig";)
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
					{"ItemName","�����к�Ϊ׼"},
					{"Attribute1","Excel����Ҫ��"},
					{"Attribute3","�Ƿ�����ǩ"},
					{"ItemDescribe","������Ӧ��Ҫ��"},
					{"Attribute7","����Ҫ�ط�ʽ"},
					{"Attribute6","Ҫ�����ڱ�"},
					{"ItemAttribute","Ҫ��ע��"},
					{"Attribute8","Ҫ������"},
					{"Attribute2","Ҫ������"},
					{"Attribute4","Ҫ�س���"},
					{"Attribute5","Ҫ�ؾ���"},
					{"SortNo","���"},
					{"IsInUse","��Ч"},
					{"UpdateUserName","������"},
					{"UpdateTime","����ʱ��"}
				};
	sSql =  " select  CodeNo,ItemNo,getItemName('YesNo',ItemName) as ItemName,SortNo,"+
			" Attribute1,getItemName('YesNo',Attribute3) as Attribute3,getItemName('SModelColumns',ItemDescribe) as ItemDescribe,"+
			" getItemName('AlterType',Attribute7) as Attribute7,Attribute6,ItemAttribute,Attribute8,getItemName('DataType',Attribute2) as Attribute2,Attribute4,Attribute5,"+
			" getItemName('YesNo',IsInUse) as IsInUse,"+
			" getUserName(UpdateUser) as UpdateUserName,"+
			" UpdateTime"+
			" from Code_Library "+
			" where  CodeNo = '"+sCodeNo+"'"+
			" and IsInUse='1'"+
			" order by SortNo asc";
	
	//��sSql�������ݴ������
	ASDataObject doTemp = null;
	//���ñ�ͷ,���±���,��ֵ,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//doTemp.setRequired("Attribute5",true);
	doTemp.setHTMLStyle("ItemDescribe"," style={width:150px} ");
	doTemp.UpdateTable= "Code_Library";
	doTemp.setKey("CodeNo,ItemNo",true);
	//���ø�ʽ
	doTemp.setVisible("CodeNo,ItemName",false);
	if("01".equals(sType)){
		doTemp.setVisible("Attribute7,Attribute6,ItemAttribute,Attribute8,Attribute4,Attribute5,Attribute7", false);
	}else{
		doTemp.setVisible("Attribute1,Attribute3,ItemDescribe", false);
	}
	//doTemp.setHTMLStyle("Attribute1,Attribute2,Attribute3,Attribute4"," style={width:auto} ");
	//�����ֶ���ʾ���	
	//doTemp.appendHTMLStyle("Status"," style={width:90px} onDBLClick=parent.selectOrUnselect() ");
	doTemp.setColumnAttribute("Attribute1,Attribute6,Attribute8,ItemDescribe,Attribute2,SortNo","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	doTemp.appendHTMLStyle("","style=cursor:hand ondblclick=\"javascript:parent.viewAndEdit()\"");
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(25);
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
				{"01".equals(sType)?"true":"false","","Button","����","������������","importConfig()",sResourcesPath},
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
		//OpenPage("/Data/Define/BatchConfigInfo.jsp?CodeNo=<%=sCodeNo%>","_self","");
		popComp("BatchConfigInfo.jsp","/Data/Define/BatchConfigInfo.jsp","CodeNo=<%=sCodeNo%>","dialogWidth=35;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
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
			//backupHis();
			as_del('myiframe0');
   		    as_save('myiframe0');  //�������ɾ��,��Ҫ���ô����
   		   reloadSelf();
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
		popComp("BatchConfigInfo","/Data/Define/BatchConfigInfo.jsp","CodeNo="+sCodeNo+"&ItemNo="+sItemNo,"dialogWidth=40;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		reloadSelf();
	}
	/*~[Describe=�����������������Խ�ʡ����;InputParam=��;OutPutParam=��;]~*/
	function importConfig()
	{
		var CodeNo="<%=sCodeNo%>";
		var sParaString = "";
		var sReturn=setObjectValue("SelectColumnConfig",sParaString,"",0,0,"");
		if(typeof(sReturn)!=="undefined"){
			var sSourceCodeNo = sReturn.split('@')[0];
			sReturn=RunMethod("PublicMethod","ExecuteSql","[select~~select count(1) as count from Code_Library where CodeNo='"+sSourceCodeNo+"']");
			if(sReturn==0){
				alert("����������������Ϣ��");
				return;;
			}
			//������һ�� Remark��1
			RunMethod("PublicMethod","ExecuteSql","[update~~update Code_Library set Remark=nvl(Remark,0)#1 where CodeNo='"+sSourceCodeNo+"' and IsInUse='1']");
			var sSql="[insert~~insert into "+
				"Code_Library(CodeNo,ItemNo,SortNo,"+
				"Attribute1,"+//Ҫ��Excel����
				"Attribute3,"+//�Ƿ�ʶ���ǩ
				"ItemDescribe,"+//Ҫ�ض�Ӧ���ֶ�
				"Attribute6,"+//Ҫ�����ڱ�
				"ItemAttribute,"+
				"Attribute8,"+//Ҫ������
				"Attribute2,"+//Ҫ������
				"Attribute4,"+//Ҫ�س���
				"+Attribute5,"+//Ҫ�ؾ���
				"+Attribute7,"+//����Ҫ�ط�ʽ
				"IsInUse)"+
				"(select '"+CodeNo+"','c'||Remark||ItemNo,SortNo,"+
				"Attribute1,"+
				"Attribute3,"+
				"ItemDescribe,"+
				"Attribute6,"+
				"ItemAttribute,"+
				"Attribute8,"+
				"Attribute2,"+
				"Attribute4,"+
				"+Attribute5,"+
				"+Attribute7,"+
				"IsInUse from Code_Library CL where CodeNo='"+sSourceCodeNo+"' and IsInUse='1'"+
				" and not exists(select 1 from Code_Library CL2 where CL2.CodeNo='"+CodeNo+"' and CL2.ItemDescribe=CL.ItemDescribe and IsInUse='1'))]";
			RunMethod("PublicMethod","ExecuteSql",sSql);
		}
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
		  	PopPage("/Data/Define/BatchConfigHisList.jsp?CodeNo="+sCodeNo+"&ItemNo="+sItemNo,"DetailFrame","dialogWidth=50;dialogHeight=30;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
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
	bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
	//hideFilterArea();
	//initRow();
	//var bCheckBeforeUnload=false;
</script>
<%
	/*~END~*/
%>
<%@	include file="/IncludeEnd.jsp"%>