<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: lfang 2008.04.21 ���Ӻ�ͬ��ӡ�б�
		Tester:
		Describe:
		Input Param:
			ObjectType
			ObjectNo
		Output Param:
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ӻ�ͬ��ӡ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "",sSql1="",sPhaseType="";

	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sFlag == null) sFlag = "";

	String sECOrgID = "";
	sECOrgID = Sqlca.getString(" select VitualID from ORG_INFO where OrgID = '"+CurOrg.OrgID+"' ");
	if(sECOrgID == null) sECOrgID = "";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"EDocNo","���Ӻ�ͬ���"},
							{"EDocNoName","���Ӻ�ͬ����"},
							};

	sSql =  //ҵ������ͬ
			" select ObjectNo,EContractType as EDocNo,getItemName('ElectronicContractType',EContractType) as EDocNoName, "+
			" ObjectType as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" union "+
			//�׷��������ڻ��������ͬ������
			" select ObjectNo,'A101' as EDocNo,getItemName('ElectronicContractType','A101') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType in ('A001','A050') "+
			" union "+
			//���ֻ�Ʊ�嵥����Ʊ���ֺ�ͬ��
			" select ObjectNo,'A102' as EDocNo,getItemName('ElectronicContractType','A102') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType = 'A002' "+
			" union "+
			//���гжһ�Ʊ�嵥����Ʊ�жҺ�ͬ������
			" select ObjectNo,'A103' as EDocNo,getItemName('ElectronicContractType','A103') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType = 'A004' "+
			" union "+
			//�׷�չ�ڽ�����ڻ�������չ�ں�ͬ������
			" select ObjectNo,'A104' as EDocNo,getItemName('ElectronicContractType','A104') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType = 'A012' "+
			" union "+
			//��Ѻ���ز����飨¥��ҵ�Ѻ����ͬ������
			" select ObjectNo,'C101' as EDocNo,getItemName('ElectronicContractType','C101') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType in ('C002','C051') "+
			" union "+
			//�׷��������ڻ����ί�д����ͬ������
			" select ObjectNo,'F025' as EDocNo,getItemName('ElectronicContractType','F025') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType = 'F006' "+
			" union "+
			//ί�д���Э�飨��ί�д����ͬһ��չʾ��
			" select ObjectNo,'F007' as EDocNo,getItemName('ElectronicContractType','F007') as EDocNoName, "+
			" ObjectType as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType = 'F006' "+
			" union "+
			//�ֵ���Ѻ���Э��
			" select SerialNo,EContractType as EDocNo,getItemName('ElectronicContractType',EContractType) as EDocNoName, "+
			" 'ECIndependent1' as ObjectType,SerialNo as ObjectNo "+
			" from ECONTRACT_INDEPENDENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType = 'A014' "+
			" union "+
			//��ó������Э��
			" select SerialNo,EContractType as EDocNo,getItemName('ElectronicContractType',EContractType) as EDocNoName, "+
			" 'ECIndependent2' as ObjectType,SerialNo as ObjectNo "+
			" from ECONTRACT_INDEPENDENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType = 'A015' "+
			" union "+
			//������ͬ
			" select SerialNo,EContractType as EDocNo,getItemName('ElectronicContractType',EContractType) as EDocNoName, "+
			" 'GuarantyContract' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType in ('E001','E002','E003','E004','E005','E006','E007','E008') "+
			" and ECTempSaveFlag = '2' "+
			" union "+
/*
			//��Ѻ���ֵȷ����
			" select SerialNo,EContractType as EDocNo,getItemName('ElectronicContractType',EContractType) as EDocNoName, "+
			" 'ECGuaranty' as ObjectType,SerialNo as ObjectNo "+
			" from ECONTRACT_GUARANTY "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" union "+
*/
			//��Ѻ���ֵȷ���飨��׼��¥��ҵ�Ѻ����ͬ������
			" select ObjectNo,'C102' as EDocNo,getItemName('ElectronicContractType','C102') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType in ('C002','C051') "+
			" and IsItem14 = '10' "+
			" union "+
			//��Ѻ���ֵȷ���飨���ڱ�����¥��ҵ�Ѻ����ͬ������
			" select ObjectNo,'C103' as EDocNo,getItemName('ElectronicContractType','C103') as EDocNoName, "+
			" 'BCAttachment' as ObjectType,ObjectNo as ObjectNo "+
			" from ECONTRACT_SUPPLEMENT "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" and EContractType in ('C002','C051') "+
			" and IsItem14 = '20' "+
			" union "+
			//��Ѻ���ֵȷ���飨��׼���Ѻ��ͬ������
			" select SerialNo,'E010' as EDocNo,getItemName('ElectronicContractType','E010') as EDocNoName, "+
			" 'GCAttachment' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType = 'E005' "+
			" and ECTempSaveFlag = '2' "+
			" and FinanceItem7 = '10' "+
			" union "+
			//��Ѻ���ֵȷ���飨���ڱ������Ѻ��ͬ������
			" select SerialNo,'E011' as EDocNo,getItemName('ElectronicContractType','E011') as EDocNoName, "+
			" 'GCAttachment' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType = 'E005' "+
			" and ECTempSaveFlag = '2' "+
			" and FinanceItem7 = '20' "+
			" union "+
			//��Ѻ���嵥����Ѻ��ͬ������
			" select SerialNo,'E012' as EDocNo,getItemName('ElectronicContractType','E012') as EDocNoName, "+
			" 'GCAttachment' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType = 'E005' "+
			" and ECTempSaveFlag = '2' "+
			" and (FinanceItem6 = '2' or FinanceItem6 is null) "+
			" union "+
			//��Ѻ���嵥����Ѻ��ͬ�Ϻ��渽����
			" select SerialNo,'E016' as EDocNo,getItemName('ElectronicContractType','E016') as EDocNoName, "+
			" 'GCAttachment' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType = 'E005' "+
			" and ECTempSaveFlag = '2' "+
			" and FinanceItem6 = '1' "+
			" union "+
			//���е�Ѻ�Ʋ��嵥��������Ѻ��ͬ������
			" select SerialNo,'E013' as EDocNo,getItemName('ElectronicContractType','E013') as EDocNoName, "+
			" 'GCAttachment' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType = 'E006' "+
			" and ECTempSaveFlag = '2' "+
			" union "+
			//�����嵥����Ѻ��ͬ������
			" select SerialNo,'E014' as EDocNo,getItemName('ElectronicContractType','E014') as EDocNoName, "+
			" 'GCAttachment' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType = 'E007' "+
			" and ECTempSaveFlag = '2' "+
			" union "+
			//��ѺӦ���˿��嵥��Ӧ���˿���Ѻ��ͬ��
			" select SerialNo,'E015' as EDocNo,getItemName('ElectronicContractType','E015') as EDocNoName, "+
			" 'GCAttachment' as ObjectType,SerialNo as ObjectNo "+
			" from GUARANTY_CONTRACT "+
			" where SerialNo in (Select ObjectNo from CONTRACT_RELATIVE "+
			" where SerialNo = '"+sObjectNo+"' and ObjectType='GuarantyContract') "+
			" and GuarantyType in ('010010','050','060') "+
			" and ContractType = '010' "+
			" and (ContractStatus = '010' or ContractStatus = '020') "+
			" and EContractType = 'E008' "+
			" and ECTempSaveFlag = '2' "+
			" union "+
			//����������ͬ
			" select SerialNo,LGType as EDocNo,getItemName('ElectronicContractType',LGType) as EDocNoName, "+
			" 'ECLG1' as ObjectType,SerialNo as ObjectNo "+
			" from ECONTRACT_LG1 "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' "+
			" union "+
			//������ͬ
			" select SerialNo,EContractType as EDocNo,getItemName('ElectronicContractType',EContractType) as EDocNoName, "+
			" 'ElectronicContract' as ObjectType,SerialNo as ObjectNo "+
			" from ECONTRACT_INDEPENDENT "+
			" where SerialNo = '"+sObjectNo+"' "+
			" order by EDocNo ";
			;

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable="BUSINESS_CONTRACT";

	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo",false);
	//����html��ʽ
	doTemp.setHTMLStyle("EDocNoName"," style={width:300px} ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
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
		{"true","","Button","��ӡ���Ӻ�ͬ","��ӡ���Ӻ�ͬ","printContract()",sResourcesPath},
		{"true","","Button","�������ɺ�ͬ","���Ӻ�ͬ��������","genContract()",sResourcesPath},
		{(sFlag.equals("")&&sECOrgID.equals("")?"true":"false"),"","Button","��ӡ����ǩ��","��ӡ����ǩ��","printStamper1()",sResourcesPath},
		{(sFlag.equals("")&&sECOrgID.equals("1")?"true":"false"),"","Button","���͵���ǩ��","���͵���ǩ��","printStamper()",sResourcesPath},
	};

	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=��ӡ���Ӻ�ͬ;InputParam=��;OutPutParam=��;]~*/
	function printContract()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sEDocNo = getItemValue(0,getRow(),"EDocNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		sReturn = PopPage("/Common/EDOC/EDocCreateCheckAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
		if (typeof(sReturn)=="undefined") {
	        alert("��ӡ���Ӻ�ͬʧ�ܣ���");
		    return;
		}
		else if (sReturn=="nodef") {
			alert("��Ӧ�Ĳ�Ʒδ������Ӻ�ͬģ��,�������ɵ��Ӻ�ͬ��");
			return;
		}
		else if (sReturn=="nodoc") {
			if(confirm("���Ӻ�ͬδ���ɣ�ȷ��Ҫ���ɵ��Ӵ�ӡ��ͬ��"))
			{
				sReturn = PopPage("/Common/EDOC/EDocCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
			    if (typeof(sReturn)=="undefined") {
			        alert("���ɵ��Ӻ�ͬʧ�ܣ�");
				    return;
				}
			}
			else
			    return;
		}
		popComp("EDocView","/Common/EDOC/EDocView.jsp","SerialNo="+sReturn);
	}

	/*~[Describe=���Ӻ�ͬ��������;InputParam=��;OutPutParam=��;]~*/
	function genContract()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sEDocNo = getItemValue(0,getRow(),"EDocNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		sReturn = PopPage("/Common/EDOC/EDocCreateCheckAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
	    if (typeof(sReturn)=="undefined") {
	        alert("��ӡ���Ӻ�ͬʧ�ܣ���");
		    return;
		}
		else if (sReturn=="nodef") {
			alert("��Ӧ�Ĳ�Ʒδ������Ӻ�ͬģ��,�������ɵ��Ӻ�ͬ��");
			return;
		}
		else if (sReturn=="nodoc") {
			if(confirm("���Ӻ�ͬδ���ɣ�ȷ��Ҫ���ɵ��Ӵ�ӡ��ͬ��"))
			{
				sReturn = PopPage("/Common/EDOC/EDocCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
			    if (typeof(sReturn)=="undefined") {
			        alert("���ɵ��Ӻ�ͬʧ�ܣ�");
				    return;
				}
			}
			else
			    return;
		}
		else if (sReturn != "nodoc") {
			if(confirm("���Ӻ�ͬ�Ѿ����ڣ�ȷ��Ҫ�������ɵ��Ӵ�ӡ��ͬ��"))
			{
				sReturn = PopPage("/Common/EDOC/EDocCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
			    if (typeof(sReturn)=="undefined") {
			        alert("���ɵ��Ӻ�ͬʧ�ܣ�");
				    return;
				}
			}
			else
			    return;
		}
		popComp("EDocView","/Common/EDOC/EDocView.jsp","SerialNo="+sReturn);
	}

	/*~[Describe=���͵���ǩ��;InputParam=��;OutPutParam=��;]~*/
	function printStamper()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sEDocNo = getItemValue(0,getRow(),"EDocNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sReturn = PopPage("/Common/EDOC/Stamper/StamperCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
	    if (typeof(sReturn)=="undefined") {
	        alert("���ɵ���ǩ��ҳʧ�ܣ�");
		    return;
		}
		else if (sReturn=="nodef") {
			alert("��Ӧ�Ĳ�Ʒδ�������ǩ��ҳģ��,�������ɵ���ǩ��ҳ��");
			return;
		}
		else if (sReturn=="nodoc") {
			alert("���Ӻ�ͬδ�����ҵ���ǩ��ҳΪ��ͬ�����������ɵ��Ӻ�ͬ��");
			return;
		}
		popComp("StatmperInfo","/Common/EDOC/Stamper/StamperInfo.jsp","SerialNo="+sReturn);
	}

	/*~[Describe=��ӡ����ǩ��;InputParam=��;OutPutParam=��;]~*/
	function printStamper1()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sEDocNo = getItemValue(0,getRow(),"EDocNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}

		sReturn = PopPage("/Common/EDOC/Stamper/StamperCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
	    alert(sReturn);
		if (typeof(sReturn)=="undefined") {
	        alert("���ɵ���ǩ��ҳʧ�ܣ�");
		    return;
		}
		else if (sReturn=="nodef") {
			alert("��Ӧ�Ĳ�Ʒδ�������ǩ��ҳģ��,�������ɵ���ǩ��ҳ��");
			return;
		}
		else if (sReturn=="nodoc") {
			alert("���Ӻ�ͬδ�����ҵ���ǩ��ҳΪ��ͬ�����������ɵ��Ӻ�ͬ��");
			return;
		}
		popComp("StamperView","/Common/EDOC/Stamper/StamperView.jsp","SerialNo="+sReturn);
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