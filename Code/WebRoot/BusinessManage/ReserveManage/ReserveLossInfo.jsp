<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:jjwang  2008.10.12
		Tester:
		Content: ��˾ҵ��  ��ʧʶ��
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ʧʶ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������

	//����������

	//���ҳ�����
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth==null) sAccountMonth="";
	String sLoanAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));
	if(sLoanAccount==null) sLoanAccount="";
	String sCustomerName = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerName"));
	if(sCustomerName==null) sCustomerName="";
	String sMClassifyResult = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MClassifyResult"));
	if(sMClassifyResult==null) sMClassifyResult="";
	String sBalance = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Balance"));
	if(sBalance==null) sBalance="";
	String sPutoutDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("PutoutDate"));
	if(sPutoutDate==null) sPutoutDate="";
	String sMaturityDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("MaturityDate"));
	if(sMaturityDate==null) sMaturityDate="";

%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "ReserveLossInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable = "Reserve_Loss";
	//doTemp.setUnit("BeginDate"," <input type=button class=inputDate value=... onclick=parent.selectAccountMonth() > ");
    //doTemp.setUnit("ConfirmDate"," <input type=button class=inputDate value=... onclick=parent.selectAccountMonth() > ");
  	doTemp.setType("Balance","Number");
    doTemp.setHTMLStyle("Describes","style={width:200px;height:100px}overflow:scroll");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sLoanAccount);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//session.setAttribute(dwTemp.Name,dwTemp);
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","����","goBack()",sResourcesPath}
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	
	/*~[Describe=��ʧʶ���ڼ䣨��);InputParam=��;OutPutParam=��;]~*/
	function getTermDay()
	{
	    sBeginDate = getItemValue(0,getRow(),"BeginDate");
	    sConfirmDate = getItemValue(0,getRow(),"ConfirmDate");
	    BeginDate1 = sBeginDate.split("/")
	    BeginDate2 = new Date(BeginDate1[1]+'-'+BeginDate1[2]+'-'+BeginDate1[0]);
	    ConfirmDate1 = sConfirmDate.split("/")
	    ConfirmDate2 = new Date(ConfirmDate1[1]+'-'+ConfirmDate1[2]+'-'+ConfirmDate1[0]);	 
	    iTermDay = parseInt(Math.abs(ConfirmDate2 - BeginDate2)/1000/60/60/24) ;
		setItemValue(0,0,"TermDay",iTermDay);	
	}
	
	function selectAccountMonth()
	{
		
		var sAccountMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=21;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sAccountMonth)!="undefined" && sAccountMonth!="")
		{	
			setItemValue(0,0,"AccountMonth",sAccountMonth);
		}
		else
			setItemValue(0,0,"AccountMonth","");
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}
		else{
			beforeUpdate();
		}
		as_save("myiframe0",sPostEvents);
	}
	
	function goBack()
	{
		self.close();
	}
	/*~[Describe=���沢����һ����¼;InputParam=��;OutPutParam=��;]~*/
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
		
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		
	}
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"Inputuserid","<%=CurUser.UserID%>");
			setItemValue(0,0,"OperateOrgid","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputuserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OperateOrgName","<%=CurOrg.OrgName%>");			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
	
			setItemValue(0,0,"AccountMonth","<%=sAccountMonth%>");
			setItemValue(0,0,"LoanAccount","<%=sLoanAccount%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"MClassifyResult","<%=sMClassifyResult%>");
			setItemValue(0,0,"Balance","<%=sBalance%>");
			setItemValue(0,0,"PutoutDate","<%=sPutoutDate%>");
			setItemValue(0,0,"MaturityDate","<%=sMaturityDate%>");	
		}	
    }
   
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
