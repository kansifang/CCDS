<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author:	ljma  2011-02-24
			Tester:
			Content: ��������б�
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
		String PG_TITLE = "��ҵ��ģ��׼"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sHeaders[][] = { 
	{"Scope","��ҵ��ģ"},
	{"ScopeName","��ҵ��ģ"},
	{"IndustryType","������ҵ"},
	{"IndustryTypeName","������ҵ"},
	{"EmployeeNumberMin","��ҵ�������ޣ�����"},
	{"EmployeeNumberMax","��ҵ��������"},
	{"SaleSumMin","���۶����ޣ���������Ԫ��"},
	{"SaleSumMax","���۶����ޣ���Ԫ��"},
	{"AssetSumMin","�ʲ��ܶ����ޣ���������Ԫ��"},
	{"AssetSumMax","�ʲ��ܶ����ޣ���Ԫ��"},
	{"InputUserName","�Ǽ���Ա"},
	{"InputOrgName","�Ǽǻ���"},
	{"InputDate","�Ǽ�����"},
	{"UpdateUserName","������Ա"},
	{"UpdateOrgName","���»���"},
	{"UpdateDate","��������"}
	
		};
	String sSql = " select IndustryType,getItemName('IndustryType',IndustryType) as IndustryTypeName, "+
		  "Scope,getItemName('Scope',Scope) as ScopeName,"+
		  " EmployeeNumberMin,EmployeeNumberMax, "+ 
		  " SaleSumMin,SaleSumMax, "+
		  " AssetSumMin,AssetSumMax, "+
		  " getUserName(InputUserID) as InputUserName, "+
		  " getOrgName(InputOrgID) as InputOrgName,"+
		  "	InputDate, "+
		  " getUserName(UpdateUserID) as UpdateUserName, "+
		  " getOrgName(UpdateOrgID) as UpdateOrgName,"+
		  " UpdateDate "+
		  " from ENT_SCOPE_STANDARD where 1=1 ";
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	//����DataObject				
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	//doTemp.setColumnAttribute("ExampleName","IsFilter","1");


	doTemp.UpdateTable="ENT_SCOPE_STANDARD";
	doTemp.setKey("SERIALNO",true);

	//���ò��ɼ�
	doTemp.setVisible("SerialNo,Scope,IndustryType",false);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("IndustryTypeName","style={width:200px} ");  
	
	//doTemp.setDDDWSql("BusinessType"," select TypeNo,TypeName from Business_Type where IsInUse = '1' order by SortNo ");
	//doTemp.setDDDWSql("OrgID"," select OrgID,OrgName from org_info where orglevel = '6' and status = '1' or OrgID in ('3200','3400') order by orglevel ");
	doTemp.setDDDWCode("Scope","Scope");
	doTemp.setDDDWCode("IndustryType","IndustryType");
	//���ɲ�ѯ����
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","Scope","");
	//doTemp.setFilter(Sqlca,"2","IndustryType","style={editables}");
	doTemp.setFilter(Sqlca,"2","IndustryType","HtmlTemplate=PopSelect");
	doTemp.parseFilterData(request,iPostChange);
	//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=1";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(15);

	//��������¼�
	//dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//out.println(doTemp.SourceSql); //������仰����datawindow
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
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
			{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath}	,
			{"true","","PlainText","(�������͵ķǿ���������д��-1��)","(�������͵ķǿ���������д��-1��)","style={color:red}",sResourcesPath}		
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
		OpenPage("/SystemManage/SynthesisManage/EntScoptStandardInfo.jsp","_self","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		
		if(confirm("�������ɾ������Ϣ��")) 
		{		
			//������־��¼
			RunMethod("BusinessManage","CreditLimitLog",sSerialNo+",DELETE(ɾ��),<%=CurUser.UserID%>");
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
		}
		reloadSelf();
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		var sScope = getItemValue(0,getRow(),"Scope");
		if (typeof(sIndustryType)=="undefined" || sIndustryType.length==0)
		{
			alert("��ѡ��һ����¼��");
			return;
		}
		OpenPage("/SystemManage/SynthesisManage/EntScoptStandardInfo.jsp?IndustryType="+sIndustryType+"&Scope="+sScope,"_self","");
	}
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	/*~[Describe=��ѯ����;InputParam=��;OutPutParam=SerialNo;]~*/
	function filterAction(sObjectID,sFilterID,sObjectID2)
	{
		oMyObj = document.all(sObjectID);
		oMyObj2 = document.all(sObjectID2);
		if(sFilterID=="2"){
			getIndustryType(oMyObj,oMyObj2);
		}
	}
	/*~[Describe=����������ҵ����ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function getIndustryType(id,name)
	{
		//������ҵ��������м������������ʾ��ҵ����
		var sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelectNew.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(typeof(sIndustryTypeInfo)=="undefined" || sIndustryTypeInfo.length==0){
			return;
		}
		if(sIndustryTypeInfo.search("OK") >0){
			if(sIndustryTypeInfo == "NO")
			{
				id.value="";
				name.value="";
			}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
			{
				sIndustryTypeInfo = sIndustryTypeInfo.split('@');
				sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
				sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
				id.value=sIndustryTypeValue;
				name.value=sIndustryTypeName;
			}
		}else{
			if(sIndustryTypeInfo == "NO")
			{
				id.value="";
				name.value="";
			}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
			{
				sIndustryTypeInfo = sIndustryTypeInfo.split('@');
				sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
				sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
	
				sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelectNew.jsp?IndustryTypeValue="+sIndustryTypeValue+"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
				if(sIndustryTypeInfo == "NO")
				{
					id.value="";
					name.value="";
				}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
				{
					sIndustryTypeInfo = sIndustryTypeInfo.split('@');
					sIndustryTypeValue = sIndustryTypeInfo[0];//-- ��ҵ���ʹ���
					sIndustryTypeName = sIndustryTypeInfo[1];//--��ҵ��������
					id.value=sIndustryTypeValue;
					name.value=sIndustryTypeName;
				}
			}
		}
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
