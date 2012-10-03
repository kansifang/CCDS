<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FSGong  2005.01.26
		Tester:
		Content: ���ϰ������ٲ�ѯ
		Input Param:
		Output param:
				 
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���ϰ������ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql;
	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"SerialNo","�ڲ�����"},
							{"LawCaseName","��������"},
							{"LawCaseType","��������"},				
							{"LawCaseTypeName","��������"},
							{"LowCaseManageType","������������"},
							{"LowCaseManageTypeName","������������"},				
							{"LawCaseOrg","�Է�����������"},				
							{"LawsuitStatus","�������ϵ�λ"},
							{"LawsuitStatusName","�������ϵ�λ"},
							{"CaseBriefName","����"},
							{"CourtStatus","��ǰ����Ժ"},
							{"CaseStatus","��ǰ���Ͻ���"},
							{"CaseStatusName","��ǰ���Ͻ���"},
							{"CasePhaseName","��ǰ�׶�"},					
							{"CognizanceResultName","������"},
							{"CurrencyName","���ϱ���"},
							{"AimSum","�����ܱ��"},				
							{"ManageUserName","����������"},
							{"ManageOrgName","�����������"},
							{"InputDate","�Ǽ�����"}				
			            }; 
	
	
	sSql = 		"  select  SerialNo,LawCaseName,"+
				"  LawCaseType,getItemName('LawCaseType',LawCaseType) as LawCaseTypeName, "+
				"  LowCaseManageType,getItemName('LowCaseManageType',LowCaseManageType) as LowCaseManageTypeName,"+		  
				"  LawCaseOrg,"+
				"  LawsuitStatus,getItemName('LawsuitStatus',LawsuitStatus) as LawsuitStatusName, "+
				"  CaseBrief,getItemName('CaseBrief',CaseBrief) as CaseBriefName,CourtStatus," +
				"  CaseStatus,getItemName('CaseStatus',CaseStatus) as CaseStatusName," +
				"  CasePhase,getItemName('CasePhase',CasePhase) as CasePhaseName," +
				"  CognizanceResult,getItemName('CognizanceResult',CognizanceResult) as CognizanceResultName," +
				
				"  Currency,getItemName('Currency',Currency) as CurrencyName," +
				"  AimSum,"+
				"  ManageUserID,getUserName(ManageUserID) as ManageUserName, " +
				"  ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName," +
				"  InputDate"+
				"  from LAWCASE_INFO where 1=1" ;
	  
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKeyFilter("SerialNo");
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LAWCASE_INFO";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ù��ø�ʽ
	doTemp.setVisible("LawsuitStatus,LawCaseType,LowCaseManageType,CaseBrief,Currency,CasePhase,CaseStatus,ManageUserID,ManageOrgID,PigeonholeDate,LawCaseTypeNo",false);	
	doTemp.setVisible("SerialNo,CaseStatus,CognizanceResult,CaseStatus,LawsuitStatus,LawCaseType",false);	

	doTemp.setCheckFormat("AimSum","2");
	
	//���ö��뷽ʽ	
	doTemp.setAlign("AimSum","3");	
	
	//����ѡ���п�
	doTemp.setHTMLStyle("LawCaseName,LawCaseName"," style={width:120px} ");
	doTemp.setHTMLStyle("LawCaseTypeName"," style={width:100px} ");
	doTemp.setHTMLStyle("LowCaseManageTypeName"," style={width:100px} ");
	doTemp.setHTMLStyle("LawsuitStatusName"," style={width:100px} ");
	doTemp.setHTMLStyle("CaseBriefName"," style={width:80px} ");
	doTemp.setHTMLStyle("CaseStatusName"," style={width:80px} ");
	doTemp.setHTMLStyle("CognizanceResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CurrencyName"," style={width:80px} ");
	doTemp.setHTMLStyle("AimSum"," style={width:100px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("InputDate"," style={width:80px} ");
	
	//���ɲ�ѯ��
	doTemp.setDDDWCode("LawCaseType","LawCaseType");
	doTemp.setDDDWCode("LawsuitStatus","LawsuitStatus");
	doTemp.setDDDWCode("CaseStatus","CaseStatus");
	doTemp.setDDDWCode("LowCaseManageType","LowCaseManageType");
	
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","LawCaseName","");
	doTemp.setFilter(Sqlca,"2","LawCaseType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"3","LawsuitStatus","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"4","CaseStatus","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"5","LawCaseOrg","");
	doTemp.setFilter(Sqlca,"6","ManageOrgName","");
	doTemp.setFilter(Sqlca,"7","ManageUserName","");
	doTemp.setFilter(Sqlca,"8","LowCaseManageType","");

	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));	
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
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
	
		//���Ϊ��ǰ���������б���ʾ���°�ť
		String sButtons[][] = {					
					{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
					{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath}	
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
		var sCasePhase =getItemValue(0,getRow(),"CasePhase");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}
		else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;		
			sViewID = "002";			
			openObject(sObjectType,sObjectNo,sViewID);
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