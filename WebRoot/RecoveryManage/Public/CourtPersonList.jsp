<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: ndeng 2004-12-24
		Tester:
		Describe: ���������Ա�б�;
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			CustomerID����ǰ�ͻ����
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���������Ա�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	//����������
	
	//���ҳ�����
	String sBelongNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("BelongNo"));
	//Flag=Y��ʾ�����������Ϣ�б�����
	String sFlag = DataConvert.toRealString(iPostChange,CurPage.getParameter("Flag"));
	//����ֵת��Ϊ���ַ���
	if(sBelongNo == null) sBelongNo = "";
	if(sFlag == null) sFlag = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = { 							
							{"AgentName","���������Ա����"},
							{"BelongAgency","���������������"},
							{"DepartTypeName","���������������"},
							{"Duty","ְ��"},
							{"RelationTel","��ϵ�绰"},
							{"UserName","�Ǽ���"},
							{"OrgName","�Ǽǻ���"},
							{"InputDate","�Ǽ�����"}
						}; 

	if(sBelongNo.equals(""))
	{
		sSql = 	" select SerialNo,AgentName,BelongAgency,getItemName('DepartType',DepartType) as DepartTypeName, "+
				" Duty,RelationTel,InputUserID,getUserName(InputUserID) as UserName,InputOrgID, "+
				" getOrgName(InputOrgID) as OrgName,InputDate"+
				" from AGENT_INFO "+
				" where AgentType = '01' "+
				//" and InputOrgID = '"+CurOrg.OrgID+"' "+
				" order by InputDate desc ";
	 }else
	 {		
		 sSql = " select SerialNo,AgentName,BelongAgency,Duty,RelationTel,InputUserID,getUserName(InputUserID) as UserName," +
			   	" InputOrgID,getOrgName(InputOrgID) as OrgName,InputDate"+
		       	" from AGENT_INFO " +
		       	" where BelongNo = '"+sBelongNo+"' "+
		       	//" and InputOrgID='"+CurOrg.OrgID+"' "+
		       	" order by InputDate desc";
	 }      
	
	//��sSql�������ݴ������
	//out.println(sSql);
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "AGENT_INFO";	
	doTemp.setKey("SerialNo",true);	 //���ùؼ���
	
	//���ù��ø�ʽ
	doTemp.setVisible("SerialNo,InputUserID,InputOrgID,InputDate",false);	
	
	doTemp.setHTMLStyle("UserName,InputDate"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:120px} ");
	doTemp.setHTMLStyle("AgentName,BelongAgency"," style={width:120px} ");
	doTemp.setHTMLStyle("Duty"," style={width:60px} ");
	doTemp.setHTMLStyle("RelationTel"," style={width:100px} ");

	//���ɲ�ѯ��
	doTemp.setColumnAttribute("AgentName,BelongAgency","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20); 	//��������ҳ

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

	String sButtons[][] = {
			{"true","","Button","����","����������","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴������","viewAndEdit()",sResourcesPath},
			{"true","","Button","��������","�鿴��������","my_lawcase()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ��������","deleteRecord()",sResourcesPath}
		};
		
	if(sFlag.equals("Y")) //�ӻ�����Ϣ�б����
	{
		sButtons[0][0]="false";
		sButtons[1][0]="false";
		sButtons[2][0]="false";
		sButtons[4][0]="false";
		
	}else
	{
		sButtons[3][0]="false";
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
		OpenPage("/RecoveryManage/Public/CourtPersonInfo.jsp","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/Public/CourtPersonInfo.jsp?SerialNo="+sSerialNo, "_self","");
		}
	}
	
	/*~[Describe=�����б�;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{     	
		OpenPage("/RecoveryManage/Public/CourtList.jsp?rand="+randomNumber(),"_self","");
	}
	
	/*~[Describe=�Ѵ�������Ϣ;InputParam=��;OutPutParam=��;]~*/
	function my_lawcase()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/RecoveryManage/Public/SupplyLawCase.jsp?QuaryName=PersonNo&QuaryValue="+sSerialNo+"&Back=4&rand="+randomNumber(),"_self","");           	
		}		
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
