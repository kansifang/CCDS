<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: --�ͻ����񱨱����
		Input Param:
			  CustomerID��--��ǰ�ͻ����
		Output Param:
			  CustomerID��--��ǰ�ͻ����
			
		HistoryLog:
		--fbkang 2005.7.21,ҳ��������޸�
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����
	
	//�������������ͻ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
								{"CustomerID","�ͻ���"},
								{"RecordNo","��¼��"},
								{"ReportDate","�����������"},
								{"ReportScopeName","����ھ�"},
								{"ReportPeriodName","��������"},
								{"ReportCurrencyName","�������"},
								{"ReportUnitName","����λ"},
								{"InputDate","�Ǽ�����"},
								{"OrgName","�Ǽǻ���"},
								{"UserName","�Ǽ���"},
								{"UpdateDate","�޸�����"}
						  };

	String 	sSql = " select CustomerID,RecordNo,ReportDate,ReportScope,ReportPeriod,ReportCurrency,ReportUnit,"+
					" getItemName('ReportScope',ReportScope) as ReportScopeName,"+
					" getItemName('ReportPeriod',ReportPeriod) as ReportPeriodName,"+
					" getItemName('Currency',ReportCurrency) as ReportCurrencyName,"+
					" getItemName('ReportUnit',ReportUnit) as ReportUnitName,"+
					" getUserName(UserID) as UserName,"+
					" getOrgName(OrgID) as OrgName,"+
					" InputDate,OrgID,UserID,UpdateDate "+
					" from CUSTOMER_FSRECORD "+
					" where CustomerID='"+sCustomerID+"' order by ReportDate DESC";


	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//�����޸ı���
	doTemp.UpdateTable = "CUSTOMER_FSRECORD";
	doTemp.setKey("RecordNo",true);	
	//���ò��ɼ���
	doTemp.setVisible("ReportScope,ReportPeriod,ReportCurrency,ReportUnit",false);
	doTemp.setVisible("CustomerID,RecordNo,OrgID,UserID,UpdateDate,Remark",false);
	//���ý�����
	doTemp.appendHTMLStyle("ReportScopeName,ReportPeriodName,ReportCurrencyName,ReportUnitName"," style={width=55px} ");
	doTemp.appendHTMLStyle("ReportDate,UserName,InputDate"," style={width=70px} ");
	doTemp.setCheckFormat("InputDate,UpdateDate","3");
    doTemp.setHTMLStyle("OrgName","style={width:200px}"); 	
	doTemp.setAlign("ReportScopeName,ReportPeriodName,ReportCurrencyName,ReportUnitName","2");
	//���ɹ�����
	doTemp.setColumnAttribute("ReportDate","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

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

	String sButtons[][] = 
	  {
			{"true","","Button","�Ű����","�Ű����","dupondInfo()",sResourcesPath},
			{"true","","Button","�ṹ����","�ṹ����","structureInfo()",sResourcesPath},
			{"true","","Button","ָ�����","ָ�����","itemInfo()",sResourcesPath},
			{"true","","Button","���Ʒ���","���Ʒ���","trendInfo()",sResourcesPath}
	  };
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�Ű����;InputParam=�ͻ�����;OutPutParam=��;]~*/
	function dupondInfo()
	{   
		//����ֵ�����������
		sMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=16;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;scrollbar:yes ");
		if(typeof(sMonth)=="undefined" || sMonth=='')
		return;
		PopPage("/CustomerManage/FinanceAnalyse/DBAnalyse.jsp?CustomerID=<%=sCustomerID%>&AccountMonth="+sMonth,"width=480,height=400,left=180,top=150,status=yes,center=yes ");
	}
	
	/*~[Describe=�ṹ����;InputParam=�ͻ�����;OutPutParam=��;]~*/
	function structureInfo()
	{   
	    //����ֵ���������������������¡�����Χ
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm.jsp?CustomerID=<%=sCustomerID%>","","width=160,height=20,left=20,top=20,status=yes,center=yes ");
		if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_")
		return;
		PopPage("/CustomerManage/FinanceAnalyse/StructureMain.jsp?CustomerID=<%=sCustomerID%>&Term=" + sReturnValue + "","width=480,height=400,left=180,top=150,status=yes,center=yes ");
	
	}

	/*~[Describe=ָ�����;InputParam=�ͻ�����;OutPutParam=��;]~*/
	function itemInfo()
	{  
	    //����ֵ���������������������¡�����Χ
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm.jsp?CustomerID=<%=sCustomerID%>","","width=200,height=20,left=20,top=20,status=yes,center=yes ");
		if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_")
		 return;
		PopPage("/CustomerManage/FinanceAnalyse/ItemMain.jsp?CustomerID=<%=sCustomerID%>&Term="+sReturnValue+"","_blank","");
	}

	/*~[Describe=���Ʒ���;InputParam=�ͻ�����;OutPutParam=��;]~*/
	function trendInfo()
	{
	    //����ֵ���������������������¡�����Χ
		sReturnValue = PopPage("/CustomerManage/FinanceAnalyse/AnalyseTerm_Trend.jsp?CustomerID=<%=sCustomerID%>","","width=200,height=20,left=20,top=20,status=yes,center=yes ");
		
		if(typeof(sReturnValue)=="undefined" || sReturnValue=="_none_")
			return;
		PopPage("/CustomerManage/FinanceAnalyse/TrendMain.jsp?CustomerID=<%=sCustomerID%>&Term=" + sReturnValue + "","_blank","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
