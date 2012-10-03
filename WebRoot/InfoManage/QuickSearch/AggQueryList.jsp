<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   --CYHui 2005-1-25
		Tester:
		Content: --�������Ͽ��ٲ�ѯ
		Input Param:
					--���в�����Ϊ�����������
					--ComponentName	������ƣ��������ſͻ����ٲ�ѯ
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ſ��ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	String sComponentName = "";//--�������
	String PG_CONTENT_TITLE = "";//--����
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	PG_CONTENT_TITLE="&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"CustomerID","�ͻ����"},
							{"EnterpriseName","��������"},
							{"EnglishName","���ż��"},
							{"GroupType","��������"},
							{"GroupTypeName","��������"},
							{"RegionCodeName","�����ܲ����ڵ�"},
							{"RelativeType","�ܻ��ͻ�������ϵ�绰"},
							{"OrgName","�ܻ�����"},
							{"UserName","�ܻ��ͻ�����"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputUserName","�Ǽ���"},
							{"InputDate","�Ǽ�����"},
							{"UpdateUserName","������Ա"},
							{"UpdateOrgName","���»���"},
							{"UpdateDate","��������"}
						  }; 
	
	sSql =	" select EI.CustomerID as CustomerID,EI.EnterpriseName,EnglishName, "+
			" EI.GroupType,getItemName('GroupOwnType',GroupType) as GroupTypeName, "+
			" getItemName('AreaCode',EI.RegionCode) as RegionCodeName, "+
			" RelativeType,getOrgName(CB.OrgID) as OrgName, "+
			" getUserName(CB.UserID) as UserName, "+
			" getOrgName(EI.InputOrgID) as InputOrgName, "+
			" getUserName(EI.InputUserID) as InputUserName, "+
			" EI.InputDate as InputDate, "+
			" getUserName(EI.UpdateUserID) as UpdateUserName, "+
			" getOrgName(EI.UpdateOrgID) as UpdateOrgName, "+
			" EI.UpdateDate as UpdateDate "+
			" from ENT_INFO EI,CUSTOMER_BELONG CB "+
			" where EI.CustomerID = CB.CustomerID "+
			" and CB.BelongAttribute = '1' "+
			" and  EI.OrgNature like '02%' "+
			" and CB.OrgID in (select OrgId "+
			" from ORG_INFO "+
			" where SortNo like '"+CurOrg.SortNo+"%')";
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("EI.CustomerID");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ENT_INFO";	
	//���ùؼ���
	doTemp.setKey("CustomerID",true);
	//������ʾ�ı���ĳ��ȼ��¼�����
    doTemp.setHTMLStyle("EnterpriseName,RegisterAdd,OfficeAdd","style={width:200px}");
    doTemp.setHTMLStyle("EmployeeNumber","style={width:30px}");    
    doTemp.setHTMLStyle("MostBusiness","style={width:250px}");   
    doTemp.setHTMLStyle("InputOrgName,UpdateOrgName,IndustryTypeName,IndustryDetailName","style={width:200px}"); 
       
    doTemp.setCheckFormat("Licensedate,LicenseMaturity,UpdateDate,InputDate","3");	
	//��������������
	doTemp.setDDDWCode("OrgNature","CustomerType");
	doTemp.setDDDWSql("GroupType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'GroupOwnType'");
	doTemp.setVisible("GroupType",false);
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("CustomerID,EnterpriseName,EnglishName,GroupType","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(16);  //��������ҳ

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
		{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
	};
	
	if(CurUser.hasRole("095")||CurUser.hasRole("0A2")||CurUser.hasRole("0B5")||CurUser.hasRole("0C2")||
	 CurUser.hasRole("0D2")||CurUser.hasRole("0E9")||CurUser.hasRole("0F4")||CurUser.hasRole("0H5")||
	 CurUser.hasRole("0I4")||CurUser.hasRole("0J1")||CurUser.hasRole("282")||CurUser.hasRole("295")||
	 CurUser.hasRole("2A4")||CurUser.hasRole("2B9")||CurUser.hasRole("2C2")||CurUser.hasRole("2D4")||
	 CurUser.hasRole("2E4")||CurUser.hasRole("2G5")||CurUser.hasRole("2H5")||CurUser.hasRole("2I2")||
	 CurUser.hasRole("421")||CurUser.hasRole("495"))
	{
		sButtons[1][0] = "false";
	}
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//��õ�ծ�ʲ���ˮ�š���ծ�ʲ�����
		sCustomerID=getItemValue(0,getRow(),"CustomerID");			
	
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			openObject("Customer",sCustomerID,"002");
		}
	}	
	
 	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
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