<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: �������֤��Ϣ
		Input Param:
			ObjectType: �׶α��
			ObjectNo:
			SerialNo��ҵ����ˮ��
		Output Param:
			SerialNo��ҵ����ˮ��
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������֤��Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";
	if(CurUser.hasRole("0E3") || CurUser.hasRole("480") || CurUser.hasRole("280"))
		CurComp.setAttribute("RightType","All");//��ǰҳ���Լ���ҳ��Ϊ���޸� add by zwhu
    String sBusinessType = "" ;
    if(sObjectType.equals("CreditApply"))
    {
    	sBusinessType = Sqlca.getString("select BusinessType from Business_Apply where SerialNo = '"+sObjectNo+"'");
    }else if (sObjectType.equals("BusinessContract") || sObjectType.equals("AfterLoan") || sObjectType.equals("ReinforceContract"))
    {
    	sBusinessType = Sqlca.getString("select BusinessType from Business_Contract where SerialNo = '"+sObjectNo+"'");
    }
	if(sBusinessType == null) sBusinessType = "";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%


	String sHeaders[][] = {	{"SerialNo","��ˮ��"},
							{"LCNo","����֤���"},
							{"LCTypeName","����֤����"},
							{"IssueBank","��֤��"},
	                        {"IssueState","��֤����"},
							{"IssueDate","��������"},
							{"Purpose","��;"},
							{"Applicant","����������"},
	                        {"ApplicantAddress","�����˵�ַ"},
							{"Beneficiary","����������"},
							{"BeneficiaryAddress","�����˵�ַ"},
	                        {"LCCurrencyName","����֤����"},
							{"LCSum","����֤���(Ԫ)"},
	                        {"ImportCargo","��������"},
							{"Exporter","����������"},
							{"VouchType","������ʽ"},
							{"LoadingDate","����֤װ��"},
	                        {"ValidDate","����֤Ч��"},
							{"DocumentDate","����֤������"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"}
	                       }; 


	String sSql =  " select "+
			" ObjectType,ObjectNo,SerialNo,LCNo,Exporter,ImportCargo,ValidDate,LoadingDate,"+
			" getItemName('Currency',LCCurrency) as LCCurrencyName,LCSum,"+
			" InputUserID,getUserName(InputUserID) as UserName,InputOrgID,"+
			" getOrgName(InputOrgID) as OrgName"+
			" from LC_INFO "+
	     	" where ObjectType='"+sObjectType+"' and ObjectNo='"+sObjectNo+"' ";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "LC_INFO";
	doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	 //Ϊ�����ɾ��
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
	//���ò��ɼ���
	
	if("2050030".equals(sBusinessType)){
		doTemp.setVisible("LCNo,InputOrgID,InputUserID,LCCurrencyName,LCSum",false);
		doTemp.setCheckFormat("ValidDate,LoadingDate","3");
	}
	else{
		doTemp.setVisible("InputOrgID,InputUserID,Exporter,ImportCargo,ValidDate,LoadingDate",false);
	}	
	doTemp.setUpdateable("UserName,OrgName,LCCurrencyName",false);
	doTemp.setHTMLStyle("UserName"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:200px} ");
	doTemp.setUpdateable("",false);
	doTemp.setAlign("LCSum","3");
	doTemp.setCheckFormat("LCSum","2");

	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

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
		{"true","","Button","����","��������֤��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴����֤����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ������֤��Ϣ","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		sBusinessType = "<%=sBusinessType%>";
		OpenPage("/CreditManage/CreditApply/RelativeLCInfo.jsp?BusinessType="+sBusinessType,"_self","");
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
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sBusinessType = "<%=sBusinessType%>";		
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else {
			OpenPage("/CreditManage/CreditApply/RelativeLCInfo.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType, "_self","");
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
