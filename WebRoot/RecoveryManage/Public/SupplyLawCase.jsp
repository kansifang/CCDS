<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: slliu 2004-12-02
		Tester:
		Describe: �Ѵ�������Ϣ�б�;
		Input Param:
			QuaryName������
			QuaryValue��ֵ
			Back����������
		Output Param:
						
		HistoryLog:ndeng 2004-12-26
				   zywei 2005/09/07 �ؼ����
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�Ѵ�������Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������

	//���ҳ�����	    
    String sQuaryName = DataConvert.toRealString(iPostChange,request.getParameter("QuaryName"));
    String sQuaryValue = DataConvert.toRealString(iPostChange,request.getParameter("QuaryValue"));
    String sBack = DataConvert.toRealString(iPostChange,request.getParameter("Back"));
	//����ֵת��Ϊ���ַ���
	if(sQuaryName == null) sQuaryName = "";
	if(sQuaryValue == null) sQuaryValue = "";
	if(sBack == null) sBack = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = { 							
							{"SerialNo","�ڲ�����"},
							{"LawCaseName","��������"},
							{"LawCaseTypeName","��������"},				
							{"LawsuitStatusName","���е����ϵ�λ"},
							{"CaseBriefName","����"},				
							{"CaseStatusName","��ǰ���Ͻ���"},
							{"CourtStatus","��ǰ����Ժ"},
							{"CognizanceResultName","������"},
							{"CurrencyName","���ϱ���"},
							{"AimSum","�����ܱ��(Ԫ)"},				
							{"ManageUserName","����������"},
							{"ManageOrgName","�����������"},
							{"InputDate","�Ǽ�����"}				
						}; 	
	
	if(sQuaryName.equals("OrgNo"))
	{
		
		sSql = 	" select distinct LI.SerialNo,LI.LawCaseName,LI.LawCaseType, "+
				" getItemName('LawCaseType',LI.LawCaseType) as LawCaseTypeName, "+		  
				" getItemName('LawsuitStatus',LI.LawsuitStatus) as LawsuitStatusName, "+
				" LI.CaseBrief,getItemName('CaseBrief',LI.CaseBrief) as CaseBriefName," +
				" LI.CourtStatus,LI.LawsuitStatus,LI.CognizanceResult,LI.Currency, "+
				" LI.CaseStatus,getItemName('CaseStatus',LI.CaseStatus) as CaseStatusName," +
				" getItemName('CognizanceResult',LI.CognizanceResult) as CognizanceResultName," +
				" getItemName('Currency',LI.Currency) as CurrencyName,LI.AimSum,LI.ManageUserID, " +
				" getUserName(LI.ManageUserID) as ManageUserName,LI.ManageOrgID, " +
				" getOrgName(LI.ManageOrgID) as ManageOrgName,LI.InputDate"+
		        " from LAWCASE_INFO LI,LAWCASE_PERSONS LP " +
		        " where LI.SerialNo=LP.ObjectNo "+
		        " and LP.OrgNo = '"+sQuaryValue+"' ";
	}
	
	if(sQuaryName.equals("PersonNo"))
	{
		
		sSql = 	" select distinct LI.SerialNo,LI.LawCaseName,LI.LawCaseType, "+
				" getItemName('LawCaseType',LI.LawCaseType) as LawCaseTypeName, "+		  
				" getItemName('LawsuitStatus',LI.LawsuitStatus) as LawsuitStatusName, "+
				" LI.CaseBrief,getItemName('CaseBrief',LI.CaseBrief) as CaseBriefName, "+
				" LI.CaseStatus,getItemName('CaseStatus',LI.CaseStatus) as CaseStatusName, "+
				" getItemName('CognizanceResult',LI.CognizanceResult) as CognizanceResultName, "+
				" LI.Currency,getItemName('Currency',LI.Currency) as CurrencyName, "+
				" LI.LawsuitStatus,LI.AimSum,LI.CognizanceResult,LI.ManageUserID, "+
				" getUserName(LI.ManageUserID) as ManageUserName,LI.ManageOrgID, " +
				" getOrgName(LI.ManageOrgID) as ManageOrgName,LI.InputDate"+
		        " from LAWCASE_INFO LI,LAWCASE_PERSONS LP " +
		        " where  LI.SerialNo=LP.ObjectNo "+
		        " and LP.PersonNo ='"+sQuaryValue+"' ";
	}
			 
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LAWCASE_INFO";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ù��ø�ʽ
	doTemp.setVisible("SerialNo,LawsuitStatus,LawCaseType,CaseBrief,Currency,ManageUserID,ManageOrgID,PigeonholeDate,LawCaseTypeNo",false);	
	doTemp.setVisible("CaseStatus,CognizanceResult",false);	
	//���ý���ʽ
	doTemp.setCheckFormat("AimSum","2");	
	doTemp.setAlign("AimSum","3");	
	
	//����ѡ���п�
	doTemp.setHTMLStyle("LawCaseName"," style={width:120px} ");
	doTemp.setHTMLStyle("LawCaseTypeName"," style={width:100px} ");	
	doTemp.setHTMLStyle("LawsuitStatusName"," style={width:100px} ");
	doTemp.setHTMLStyle("CaseBriefName"," style={width:80px} ");
	doTemp.setHTMLStyle("CaseStatusName"," style={width:80px} ");
	doTemp.setHTMLStyle("CognizanceResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CurrencyName"," style={width:80px} ");
	doTemp.setHTMLStyle("AimSum"," style={width:100px} ");
	doTemp.setHTMLStyle("ManageUserName"," style={width:80px} ");
	doTemp.setHTMLStyle("ManageOrgName"," style={width:250px} ");
	doTemp.setHTMLStyle("InputDate"," style={width:80px} ");	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);	
	dwTemp.Style = "1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ
	
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
				{"true","","Button","����","����","viewAndEdit()",sResourcesPath},
				{"true","","Button","����","����","goBack()",sResourcesPath}
			};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		//��ð�����ˮ��
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");			
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;
			sViewID = "002"
			openObject(sObjectType,sObjectNo,sViewID);
		}
	}

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{		
		sBack = "<%=sBack%>";
		if(sBack == "1")
			OpenPage("/RecoveryManage/Public/AgencyList.jsp?rand="+randomNumber(),"_self","");
		if(sBack == "2")
			OpenPage("/RecoveryManage/Public/AgentList.jsp?rand="+randomNumber(),"_self","");
		if(sBack == "3")
			OpenPage("/RecoveryManage/Public/CourtList.jsp?rand="+randomNumber(),"_self","");
		if(sBack == "4")
			OpenPage("/RecoveryManage/Public/CourtPersonList.jsp?rand="+randomNumber(),"_self","");
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
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
