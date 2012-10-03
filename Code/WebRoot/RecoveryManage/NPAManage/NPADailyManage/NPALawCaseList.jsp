<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   XWu 2004.12.12
		Tester:
		Content: ��ͬ���߰�����Ϣ�б�
		Input Param:
			   ObjectNo����ͬ��� �����ʲ�����    
			   ObjectType����������     
			   CustomerID���ͻ�ID �Ŵ��ͻ���Ϣ����    
		Output param:
				 
		History Log: 
		                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ���߰�����Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sWhereCondition = "";
	String sInCondition = "";	
	String sSql = "";
	ASResultSet rs = null;
	//����������	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID")); //��������
	if(sCustomerID == null) sCustomerID = "";

	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType")); //��������
	if(sObjectType == null) sObjectType = "BusinessContract";
	
	if(sCustomerID.equals(""))
	{
		String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
		sWhereCondition	= " SerialNo in (Select SerialNo From LAWCASE_RELATIVE Where ObjectNo = '"+sObjectNo+"' And ObjectType = 'BusinessContract') order by InputDate desc ";
	}else
	{
		sSql = "select SerialNo from BUSINESS_CONTRACT where CustomerID='"+sCustomerID+"'";
		rs = Sqlca.getResultSet(sSql);
		while(rs.next()){
			if(sInCondition != null && !sInCondition.equals(""))
				sInCondition = sInCondition+",";
			sInCondition = sInCondition+ "'"+rs.getString(1)+"'";
		}
		rs.getStatement().close();

		if(sInCondition == null) sInCondition = "";
		if(sInCondition.indexOf("'")<0) sInCondition = "'"+sInCondition+"'";

		sWhereCondition	= 	" SerialNo in (Select Distinct SerialNo From LAWCASE_RELATIVE Where ObjectNo in ("+sInCondition+")" + 
							" And ObjectType = 'BusinessContract') order by InputDate desc ";  	
	}

	//�����ͷ�ļ�
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
							{"AimSum","�����ܱ��"},				
							{"ManageUserName","����������"},
							{"ManageOrgName","�����������"},
							{"InputDate","�Ǽ�����"}				
						}; 

	 sSql = " select  SerialNo,LawCaseName,"+
			" LawCaseType,getItemName('LawCaseType',LawCaseType) as LawCaseTypeName, "+		  
			" LawsuitStatus,getItemName('LawsuitStatus',LawsuitStatus) as LawsuitStatusName, "+
			" CaseBrief,getItemName('CaseBrief',CaseBrief) as CaseBriefName,CourtStatus," +
			" CaseStatus,getItemName('CaseStatus',CaseStatus) as CaseStatusName," +
			" CognizanceResult,getItemName('CognizanceResult',CognizanceResult) as CognizanceResultName," +
			" Currency,getItemName('Currency',Currency) as CurrencyName," +
			" AimSum,"+
			" ManageUserID,getUserName(ManageUserID) as ManageUserName, " +
			" ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName," +
			" InputDate"+
			" From LAWCASE_INFO " +
			" Where ((PigeonholeDate='') or (PigeonholeDate is null) ) and " + sWhereCondition ;
			//���������ų��˹鵵�İ�����   added by FSGong 2005-03-18
	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	
	//����Sql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ù��ø�ʽ
	doTemp.setVisible("SerialNo,LawsuitStatus,LawCaseType,CaseBrief,Currency,LawCaseOrg,ManageUserID,ManageOrgID,PigeonholeDate,LawCaseTypeNo",false);	
	doTemp.setVisible("CaseStatus,CognizanceResult",false);	

	doTemp.setCheckFormat("AimSum","2");	
	//���ö��뷽ʽ	
	doTemp.setAlign("AimSum","3");	
	doTemp.setAlign("LawCaseTypeName,LawsuitStatusName,CaseBriefName,CurrencyName","2");
	doTemp.setCheckFormat("InputDate","3");
    doTemp.setHTMLStyle("ManageOrgName","style={width:200px}");		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.setPageSize(20);  //��������ҳ

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
	
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
					{"true","","Button","����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
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
		//��ð�����ˮ�š���������
		var sSerialNo=getItemValue(0,getRow(),"SerialNo");	
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
		}
		else
		{		
			sObjectType = "LawCase";
			sObjectNo = sSerialNo;
			sViewID = "002";
			openObject(sObjectType,sObjectNo,sViewID);		}
		
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
