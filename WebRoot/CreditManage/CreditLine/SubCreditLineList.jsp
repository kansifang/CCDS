<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:zywei 2006/03/31
		Tester:
		Content: ���Ŷ�ȷ����б�ҳ��
		Input Param:
			ParentLineID����ȱ��
		Output param:
		
		History Log: 

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
	String sSql = "";
	
	//����������	
	
	//���ҳ�����	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	if(sObjectType == null) sObjectType = "";
	String sParentLineID =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ParentLineID"));
	if(sParentLineID == null) sParentLineID = "";
	//�������
	ASResultSet rs= null;
	String sBusinessType = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%		
	//��ʾ����				
	String[][] sHeaders = {		
						{"CustomerID","�ͻ����"},
						{"CustomerName","�ͻ�����"},
						{"BusinessTypeName","ҵ��Ʒ��"},
						{"MemberName","��Ա����"},
						{"AssessLevel","���ù�ͬ������������"},
						{"RotativeName","�Ƿ�ѭ��"},
						{"BailRatio","��ͱ�֤�����"},
						{"TermMonth","����(��)"},
						{"LineSum1","��߶�Ƚ��"},
						{"LineSum2","�����޶�"},
						{"Currency","����"}
					};
	
		sSql =  " select LineID,CustomerID,CustomerName,BusinessType, "+
				" getBusinessName(BusinessType) as BusinessTypeName, TermMonth,"+
				" Rotative,getItemName('YesNo',Rotative) as RotativeName, "+
				" BailRatio,LineSum1,LineSum2,getItemName('Currency',Currency) as Currency "+
				" from CL_INFO "+
				" Where ParentLineID = '"+sParentLineID+"' ";	
	//�����ͬҵ�ͻ�ȡ����sql	
	String 	sSql1 = "select BusinessType from CL_INFO where LineID = '"+sParentLineID+"' ";
	rs= Sqlca.getASResultSet(sSql1);
	if(rs.next())
	{
		sBusinessType = rs.getString("BusinessType");
		if(sBusinessType == null) sBusinessType="";
	}
	rs.getStatement().close();
	if(sBusinessType.equals("3015"))
	{
		sSql =  " select LineID,CustomerID,CustomerName,BusinessType, "+
				" getItemName('BusinessTypeTY',BusinessType) as BusinessTypeName, TermMonth,"+
				" Rotative,getItemName('YesNo',Rotative) as RotativeName, "+
				" BailRatio,LineSum1,LineSum2,getItemName('Currency',Currency) as Currency "+
				" from CL_INFO "+
				" Where ParentLineID = '"+sParentLineID+"' ";	
	}else if(sBusinessType.equals("3050") || sBusinessType.equals("3060")) //����С�飬���ù�ͬ��
	 {
		 sSql = " select LineID,CustomerID,CustomerName, "+
				" MemberName, getItemName('AssessLevel',GETCGALevel(CustomerID,MemberID)) as AssessLevel, LineSum1,LineSum2,getItemName('Currency',Currency) as Currency ,TermMonth,Rotative "+
				" from CL_INFO "+
				" Where ParentLineID = '"+sParentLineID+"' ";	
	 }
		
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "CL_INFO";
	doTemp.setKey("LineID,",true);		
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("LineID,BusinessType,Rotative,LineSum2,BailRatio",false);
	if(sBusinessType.equals("3050"))
	{
		doTemp.setHeader("CustomerName","����С������");
		doTemp.setHeader("MemberName","��Ա����");
		doTemp.setVisible("MemberName",true);
		doTemp.setVisible("BusinessTypeName",false);
	}
	if(sBusinessType.equals("3060"))
	{
		doTemp.setHeader("CustomerName","���ù�ͬ������");
		doTemp.setHeader("MemberName","��Ա����");
		doTemp.setVisible("MemberName",true);
		doTemp.setVisible("BusinessTypeName",false);
	}
	//���ø�ʽ
	doTemp.setType("LineSum1,LineSum2,BailRatio","Number");
	doTemp.setUnit("BailRatio","(%)");
	doTemp.setAlign("BusinessTypeName","2");		
	//����Filter			
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(10);
	//��������¼�
	dwTemp.setEvent("AfterDelete","!CreditLine.DeleteCLLimitationRelative(#LineID)");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//��֯���кϼ��ò��� add by zrli 
	String[][] sListSumHeaders = {{"BusinessSum","���"},
								  {"Currency","����"}
								 };
	String sListSumSql = "Select getItemName('Currency',Currency) as Currency,Sum(LineSum1) as BusinessSum from CL_INFO "+doTemp.WhereClause +" group by  Currency";
	CurComp.setAttribute("ListSumHeaders",sListSumHeaders);
	CurComp.setAttribute("ListSumSql",sListSumSql);
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
		{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
		{"false","","Button","��������","����/�鿴/�޸���������","LimitationView()",sResourcesPath},
		{"true","","Button","����","������","listSum()",sResourcesPath}
		};
		if(sObjectType.equals("BusinessContract")){
			sButtons[0][0]= "false";
			sButtons[2][0]= "false";
		}
	%> 
	
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CreditManage/CreditLine/SubCreditLineInfo.jsp?ParentLineID=<%=sParentLineID%>&BusinessType=<%=sBusinessType%>","_self","");
	}
	
	/*~[Describe=����/�鿴/�޸���������;InputParam=��;OutPutParam=��;]~*/
	function LimitationView()
	{
		sSubLineID = getItemValue(0,getRow(),"LineID");
		if (typeof(sSubLineID)=="undefined" || sSubLineID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		popComp("CreidtLineLimitationView","/CreditManage/CreditLine/CreidtLineLimitationView.jsp","SubLineID="+sSubLineID,"","");
	}
	
	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sLineID = getItemValue(0,getRow(),"LineID");
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
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSubLineID = getItemValue(0,getRow(),"LineID");
		var sCLBusinessType = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSubLineID) == "undefined" || sSubLineID.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		OpenPage("/CreditManage/CreditLine/SubCreditLineInfo.jsp?ParentLineID=<%=sParentLineID%>&BusinessType=<%=sBusinessType%>&SubLineID="+sSubLineID+"&CLBusinessType="+sCLBusinessType,"_self","");
	}

	/*~[Describe=������;InputParam=��;OutPutParam=��;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	
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
