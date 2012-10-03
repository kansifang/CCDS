<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zwhu 2010/03/29
		Tester:
		Content: �������ҵ���б�
		Input Param:
		Output param:
		History Log:   

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ҵ���б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������	
	String sCustomerID = DataConvert.toRealString(iPostChange,CurComp.getParameter("CustomerID"));
	String sObjectNo = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,CurComp.getParameter("ObjectType"));
	String sCreditLineID = DataConvert.toRealString(iPostChange,CurComp.getParameter("ParentLineID"));
	if(sObjectType == null) sObjectType= "";
	if(sCreditLineID == null) sCreditLineID= "";
	if(sCustomerID == null) sCustomerID= "";
	if(sObjectNo == null) sObjectNo = "";	
	//���ҳ�����	
	CurComp.setAttribute("IsCreditLine","true");
	String sRightType = (String)CurPage.getAttribute("RightType");
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	

	String[][] sHeaders = {	
							{"SerialNo","������ˮ��"},
							{"CustomerName","�ͻ�����"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"Currency","ҵ�����"},
							{"BusinessSum","��ͬ���"},
							{"TermMonth","���ޣ��£�"},
							{"InputUserName","������"},
							{"InputOrgName","�������"},
					};
	sSql = "select SerialNo,CustomerID,CustomerName,BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
		 " BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
		 " BusinessSum,InputUserID,getUserName(InputUserID) as InputUserName, "+
		 " InputOrgID,getOrgName(InputOrgID) as InputOrgName "+
		 " from BUSINESS_APPLY where BAAgreement ='"+sObjectNo+"'";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="BUSINESS_APPLY";
	doTemp.setKey("SerialNo",true);
	doTemp.setHeader(sHeaders);
	doTemp.setType("BusinessSum","Number");
	doTemp.setCheckFormat("Currency","3");
	doTemp.setVisible("InputUserID,InputOrgID,BusinessCurrency,BusinessType,CustomerID",false);
	doTemp.setFilter(Sqlca,"1","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"2","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//out.println(doTemp.SourceSql); //������仰����datawindow
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
		{"true","","Button","����","����","newApply()",sResourcesPath},	
		{"true","","Button","����","����","viewTab()",sResourcesPath},	
		{"true","","Button","ɾ��","ɾ��","deleteRecord()",sResourcesPath},		
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
	<script language=javascript>
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newApply()
	{
		//��jsp�еı���ֵת����js�еı���ֵ
		sObjectNo = "<%=sObjectNo%>";	
		sObjectType = "<%=sObjectType%>";		
		sCustomerID = "<%=sCustomerID%>";
		sCompID = "CreditLineApplyCreation";
		sCompURL = "/CreditManage/CreditLine/CreditLineApplyCreation.jsp";			
		sReturn = popComp(sCompID,sCompURL,"ParentLineID=<%=sCreditLineID%>&ObjectNo="+sObjectNo+"&CustomerID="+sCustomerID+"&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		sReturn = sReturn.split("@");
		sObjectNo=sReturn[0];

        //���������������ˮ�ţ��������������
        if((<%=CurUser.hasRole("280")%> || <%=CurUser.hasRole("480")%> || <%=CurUser.hasRole("080")%> )&& "<%=sRightType%>" == "All"){
   	        openObject(sObjectType,sObjectNo,"000");
        }else {
        	openObject(sObjectType,sObjectNo,"002");
        } 
		
		reloadSelf();		
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sLineID = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sLineID)=="undefined" || sLineID.length==0)
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
	
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		//����������͡�������ˮ��
		sObjectType = "<%=sObjectType%>";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
        if((<%=CurUser.hasRole("280")%> || <%=CurUser.hasRole("480")%> || <%=CurUser.hasRole("080")%> )&& "<%=sRightType%>" == "All"){
   	        openObject(sObjectType,sObjectNo,"000");
        }else {
        	openObject(sObjectType,sObjectNo,"002");
        } 
		reloadSelf();
	}	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	setDialogTitle("���Ŷ������ҵ���б�");
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
