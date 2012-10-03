<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei  2006.03.14
		Tester:
		Content: ��ʾ��������ҵ��_List
		Input Param:			
			Days��������7�죻15�죻30�죩			   
		Output param:
		                
		History Log: 
		                 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������ҵ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	int iDays = 0;
	String sBeginDate = "",sEndDate="";
	String sSql = "";
		
	//����������		
	String sDays = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Days"));	
	//����ֵת��Ϊ���ַ���	
	if(sDays == null) sDays = "";	
	//���ҳ�����	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
 	//���ַ���������ת��Ϊ����
 	if(!sDays.equals("")) iDays = Integer.parseInt(sDays);
	sBeginDate=StringFunction.getToday();
	sEndDate = StringFunction.getRelativeDate(StringFunction.getToday(),iDays);
	
	//�б��ͷ
	String sHeaders[][] = { 							
							{"SerialNo","�������"},
							{"LawCaseName","��������"},				
							{"LawCaseTypeName","��������"},
							{"LawsuitStatusName","�������ϵ�λ"},
							{"LawCaseOrg","�Ʋ�������"},
							{"ApplyDate","�����Ʋ���"}, 
							{"DeclareDate","ծȨ�걨����"},
						}; 
			              
	
	sSql = 	" select SerialNo,LawCaseName,getItemName('LawCaseType',LawCaseType) as LawCaseTypeName, "+
			" getItemName('LawsuitStatus',LawsuitStatus) as LawsuitStatusName, LawCaseOrg,DeclareDate,PigeonholeDate "+
			" from LAWCASE_INFO "+
			" where DeclareDate >= '"+sBeginDate+"' and DeclareDate <='"+sEndDate+"'";
        				
	//ͨ��SQL��������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable = "LAWCASE_INFO";
	doTemp.setKey("SerialNo",true);
	//�����б��ͷ
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,PigeonholeDate",false);

	//���ù�����
	doTemp.setColumnAttribute("SerialNo,LawCaseName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.setPageSize(10);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

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
			{"true","","Button","��������","�鿴��������","viewCaseDetail()",sResourcesPath}
		};
		
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------	
	
	/*~[Describe=��������;InputParam=��;OutPutParam=��;]~*/
	function viewCaseDetail()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sPigeonholeDate = getItemValue(0,getRow(),"PigeonholeDate");
		
		if(typeof(sObjectNo)=="undefined" || sObjectNo=="")
		{
			alert(getHtmlMessage('1'));
			return;
		}	
		sObjectType = "LawCase";
		sViewID = "";		
		if(typeof(sPigeonholeDate)=="undefined" || sPigeonholeDate=="")
		{
			sViewID = "001";
		}	
		else
			sViewID = "002";					
		openObject(sObjectType,sObjectNo,sViewID);	
		reloadSelf();	
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
