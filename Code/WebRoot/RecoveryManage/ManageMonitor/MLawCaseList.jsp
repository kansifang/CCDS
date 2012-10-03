<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2009/09/28
		Tester:
		Content: ���ϰ�������б�
		Input Param:
		Output param:
				 
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ϰ�������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";		
	
	
	//����������	����ͼ�ڵ��	
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	if(sDealType == null) sDealType="";	
			
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
				{"SerialNo","�ڲ�����"},
				{"LawCaseOrg","�Ʋ�������"},
				{"LowApplySubjectName","�Ʋ���������"},
				{"Claim","�Ʋ�������"},
				{"ApplyDate","�Ʋ�����ʱ��"},				
				{"BankruptSum","�Ʋ��Ʋ����"},				
				{"IsGuaranty","�Ƿ�֣��ʣ�Ѻ"},
				{"DeclareDate","ծȨ�걨ʱ��"},
				{"LegalCost","ծȨ�걨��"}
			}; 
	
	sSql = 	" select  LI.SerialNo as SerialNo,"+
			" LI.LawCaseOrg as LawCaseOrg,"+
			" getItemName('ApplySubject',LI.LowApplySubject) as LowApplySubjectName,"+
			" LI.Claim as Claim,"+
			" LI.ApplyDate as ApplyDate,LI.BankruptSum as BankruptSum ,"+
			" getItemName('YesNo',LI.IsGuaranty) as IsGuaranty, "+
			" LI.DeclareDate as DeclareDate,LI.LegalCost as LegalCost " +
			" from LAWCASE_INFO LI"+		
			" where  ApplyStatus='020' and days(replace(DeclareDate,'/','-'))<days(current date) ";
		
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LAWCASE_INFO";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ù��ø�ʽ
	//doTemp.setVisible("LawsuitStatus,LawCaseType,CaseBrief,Currency,ManageUserID,ManageOrgID,PigeonholeDate,LawCaseTypeNo",false);	
	//doTemp.setVisible("SerialNo,CaseStatus,CognizanceResult,CasePhase",false);	
	//���ý���ʽ
	doTemp.setCheckFormat("BankruptSum,LegalCost","2");	
	//���ö��뷽ʽ	
	doTemp.setAlign("BankruptSum,LegalCost","3");	
	
	//����ѡ���п�
	//doTemp.setHTMLStyle("Counter"," style={width:60px} ");
	
	//���ɲ�ѯ��
	doTemp.setColumnAttribute("LawCaseOrg","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ
 
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
	
		//���Ϊ��ǰ���������б���ʾ���°�ť
		String sButtons[][] = {
					{"true","","Button","��������","�鿴/�޸İ�������","viewAndEdit()",sResourcesPath},
				};
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
		//��ð�����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;			
			sViewID = "001"
			
			openObject(sObjectType,sObjectNo,sViewID);	
			reloadSelf();		
		}
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
