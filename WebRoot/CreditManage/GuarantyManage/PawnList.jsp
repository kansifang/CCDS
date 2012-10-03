<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2005-11-27
		Tester:
		Describe: ��Ѻ����Ϣ�б�;
		Input Param:
			GuarantyStatus: ��Ѻ��״̬
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��Ѻ����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sTempletNo = "";

	//���ҳ���������Ѻ��״̬
	String sGuarantyStatus = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("GuarantyStatus"));
	if(sGuarantyStatus == null) sGuarantyStatus = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	sTempletNo = "PawnList";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	doTemp.WhereClause += " and GuarantyType like '010%' and GuarantyStatus = '"+sGuarantyStatus+"' " + 
	          			  " and InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%')";
	//+" and exists (select 1 from Guaranty_Relative where ObjectType='BusinessContract' and GuarantyID=Guaranty_Info.GuarantyID)";
	//�ͻ�����ֻ�ܲ鿴�Լ�����ĵ�Ѻ��
	if(CurUser.hasRole("2D3")||CurUser.hasRole("480")||CurUser.hasRole("0E8")||CurUser.hasRole("080")||CurUser.hasRole("2A5")||CurUser.hasRole("280")||CurUser.hasRole("2J4"))
	{
		doTemp.WhereClause += " and InputUserID='"+CurUser.UserID+"'";
	}
	//���ӹ�����	
	doTemp.setColumnAttribute("GuarantyID,GuarantyType","IsFilter","1");
	doTemp.setHTMLStyle("InputOrgName"," style={width:250px} ");
	doTemp.setFilter(Sqlca,"1","GuarantyID","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"2","GuarantyType","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	CurComp.setAttribute("RightType","READONLY");
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);
	
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);//����datawindow��Sql���

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
		{(sGuarantyStatus.equals("01")?"true":"false"),"","Button","����","������Ѻ����Ϣ","newRecord()",sResourcesPath},
		{(sGuarantyStatus.equals("01")?"true":"false"),"","Button","ɾ��","ɾ����Ѻ����Ϣ","deleteRecord()",sResourcesPath},
		{"true","","Button","����","�鿴��Ѻ����Ϣ����","viewAndEdit()",sResourcesPath},
		{(sGuarantyStatus.equals("01")?"true":"false"),"","Button","��ӡ���ƾ֤","��ӡ��Ѻ�����ƾ֤","printLoadGuaranty()",sResourcesPath},
		{(sGuarantyStatus.equals("01")?"true":"false"),"","Button","���","��Ѻ�����","loadGuaranty()",sResourcesPath},
		{(sGuarantyStatus.equals("02")?"false":"false"),"","Button","��ֵ���","��Ѻ���ֵ���","valueChange()",sResourcesPath},
		{(sGuarantyStatus.equals("02")?"false":"false"),"","Button","��Ϣ���","��Ѻ��������Ϣ���","otherChange()",sResourcesPath},
//		{(sGuarantyStatus.equals("02")?"true":"false"),"","Button","��ʱ����","��Ѻ����ʱ����","unloadGuaranty1()",sResourcesPath},
		{(sGuarantyStatus.equals("02")?"true":"false"),"","Button","����","��Ѻ�����","unloadGuaranty2()",sResourcesPath},
		{(sGuarantyStatus.equals("03")?"true":"false"),"","Button","�ٻؿ�","��Ѻ���ٻؿ�","reloadGuaranty()",sResourcesPath},
		{(!sGuarantyStatus.equals("01")?"false":"false"),"","Button","�������ʷ��¼","�鿴�������ʷ��¼","viewGuarantyAudit()",sResourcesPath},
		{(!sGuarantyStatus.equals("01")?"true":"false"),"","Button","������ͬ��Ϣ","�鿴������ͬ��Ϣ","viewGuarantyContract()",sResourcesPath},
		{(!sGuarantyStatus.equals("01")?"true":"false"),"","Button","ҵ���ͬ��Ϣ","�鿴ҵ���ͬ��Ϣ","viewBusinessContract()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath}
	};
		
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		//��ȡ��Ѻ������
		sReturn = setObjectValue("SelectPawnType","","",0,0,"");
		//�ж��Ƿ񷵻���Ч��Ϣ
		if(sReturn == "" || sReturn == "_CANCEL_" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || typeof(sReturn) == "undefined") return;
		sReturn = sReturn.split('@');
		sPawnType = sReturn[0];	
		OpenPage("/CreditManage/GuarantyManage/PawnInfo.jsp?GuarantyStatus=<%=sGuarantyStatus%>&PawnType="+sPawnType,"_self");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");		
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{			
			sReturn=RunMethod("BusinessManage","CheckGuarantyRelative",sGuarantyID);
			if(sReturn > 0) 
			{
				alert(getBusinessMessage('850'));//�õ�Ѻ����ǩ������ͬ������ɾ����
				return;
			}else
			{
				as_del('myiframe0');
				as_save("myiframe0");  //�������ɾ������Ҫ���ô����	
			}		
		}		
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		sPawnType = getItemValue(0,getRow(),"GuarantyType");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			OpenPage("/CreditManage/GuarantyManage/PawnInfo.jsp?GuarantyStatus=<%=sGuarantyStatus%>&GuarantyID="+sGuarantyID+"&PawnType="+sPawnType,"_self");
		}
	}
	
	/*~[Describe=��Ѻ�����;InputParam=��;OutPutParam=��;]~*/
	function loadGuaranty()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm(getBusinessMessage('851'))) //������뽫�õ�Ѻ�������
		{
			sReturn=RunMethod("BusinessManage","InsertGuarantyAudit",sGuarantyID+",02,"+"<%=CurUser.UserID%>");
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				alert(getBusinessMessage('852'));//��Ѻ�����ɹ���
				reloadSelf();
			}else
			{
				alert(getBusinessMessage('853'));//��Ѻ�����ʧ�ܣ������²�����
				return;
			}
		}
	}
	
	/*~[Describe=��ӡ��Ѻ�����ƾ֤;InputParam=��;OutPutParam=��;]~*/
	function printLoadGuaranty()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			PopComp("LoadPawnSheet","/CreditManage/GuarantyManage/LoadPawnSheet.jsp","GuarantyID="+sGuarantyID,"dialogWidth:800px;dialogHeight:600px;resizable:yes;scrollbars:no");
		}
	}	
	
	/*~[Describe=��Ѻ���ֵ���;InputParam=��;OutPutParam=��;]~*/
	function valueChange()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			popComp("ChangePawnList","/CreditManage/GuarantyManage/ChangePawnList.jsp","ChangeType=010&GuarantyID="+sGuarantyID);
			reloadSelf();
		}
	}

	/*~[Describe=��Ѻ��������Ϣ���;InputParam=��;OutPutParam=��;]~*/
	function otherChange()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			popComp("ChangePawnList","/CreditManage/GuarantyManage/ChangePawnList.jsp","ChangeType=020&GuarantyID="+sGuarantyID);
			reloadSelf();
		}
	}
	
	/*~[Describe=��Ѻ����ʱ����;InputParam=��;OutPutParam=��;]~*/
	function unloadGuaranty1()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			popComp("AddGuarantyAudit","/CreditManage/GuarantyManage/GuarantyAuditInfo.jsp","GuarantyID="+sGuarantyID+"&GuarantyStatus=03");
			
			reloadSelf();
		}
	}
		
	/*~[Describe=��Ѻ�����;InputParam=��;OutPutParam=��;]~*/
	function unloadGuaranty2()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm("�Ƿ�ȷ�����⣿"))
		{			
			dReturn=RunMethod("BusinessManage","CheckGuarantyContract",sGuarantyID);
			if(dReturn != 0){
				alert("��ͬ��Ϊ0�����ܳ��⣡");
			}	
			else {
				sReturn=RunMethod("BusinessManage","InsertGuarantyAudit",sGuarantyID+",04,"+"<%=CurUser.UserID%>");
				if(typeof(sReturn) != "undefined" && sReturn != "") 
				{
					alert(getBusinessMessage('854'));//��Ѻ�����ɹ���
					reloadSelf();
				}else
				{
					alert(getBusinessMessage('855'));//��Ѻ�����ʧ�ܣ������²�����
					return;
				}		
			}	
		}
	}
	
	/*~[Describe=��Ѻ���ٻؿ�;InputParam=��;OutPutParam=��;]~*/
	function reloadGuaranty()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(confirm("ȷ�����õ�Ѻ���ٻؿ�����ѡ��ʵ�ʻؿ�����")) 
		{
			sReturn = PopPage("/FixStat/SelectDate.jsp","_blank","resizable=yes;dialogWidth=20;dialogHeight=16;center:yes;status:no;statusbar:no");
			if(typeof(sReturn) != "undefined" && sReturn != "_CANCEL_" && sReturn != "_NONE_" )
			{
				sSerialNo = RunMethod("BusinessManage","GetGuarantyAuditSerialNo",sGuarantyID);
				RunMethod("BusinessManage","UpdateGuarantyStatusWithDate",sSerialNo+","+sReturn);
				sReturn = RunMethod("BusinessManage","UpdateGuarantyStatus",sGuarantyID+",02");
				if(typeof(sReturn) != "undefined" && sReturn != "")
				{
					alert("�õ�Ѻ���ѳɹ��ؿ�!");
				}
			}
			reloadSelf();
		}
	}
	
	/*~[Describe=�鿴���/������־��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function viewGuarantyAudit()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			popComp("logGuarantyAudit","/CreditManage/GuarantyManage/GuarantyAuditList.jsp","GuarantyID="+sGuarantyID+"&GuarantyStatus=00");
		}
	}
	
	/*~[Describe=�鿴������ͬ��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function viewGuarantyContract()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			popComp("GuarantyContractList","/CreditManage/GuarantyManage/GuarantyContractList.jsp","GuarantyID="+sGuarantyID);
		}
	}
	
	/*~[Describe=�鿴ҵ���ͬ��Ϣ;InputParam=��;OutPutParam=��;]~*/
	function viewBusinessContract()
	{
		sGuarantyID = getItemValue(0,getRow(),"GuarantyID");
		if(typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			popComp("BusinessContractList","/CreditManage/GuarantyManage/BusinessContractList.jsp","GuarantyID="+sGuarantyID);
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
	
	</script>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	var bHighlightFirst = true;//�Զ�ѡ�е�һ����¼
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>