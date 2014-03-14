<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: ������Ϣ���ٲ�ѯ
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ�������Ϣ���ٲ�ѯ
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ���ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql
	String sComponentName = "";//--�������
	String PG_CONTENT_TITLE = "";//--��ͷ
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;�����ʲ���ѯ&nbsp;&nbsp;";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"CustomerName","�ͻ�����"},
							{"PutoutOrgName","�Ŵ�����"},
							{"ContractSum","��ͬ���"},
							{"ContractBalance","��ͬ���"},	
							{"BusinessType","ҵ��Ʒ��"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"VouchType","������ʽ"},
							{"VouchTypeName","������ʽ"},
							{"BeginDate","��ͬ��ʼ��"},
							{"EndDate","��ͬ������"},
							{"IsoverLawTerm","�Ƿ񳬹�����ʱЧ"},
							{"HarvestSumCash","�����ջض�ֽ�"},
							{"HarvestSumAsset","�����ջض��ծ�ʲ���"},
							{"LossSum","�����γ���ʧ��"},
							{"IsoverLawTermName","�Ƿ񳬹�����ʱЧ"},
							{"ManageUserName","������"}
							}; 
	sSql =	" select CustomerName,PutoutOrgName,ContractSum,ContractBalance-Bad_Asset.HarvestSum as ContractBalance,"+
			" BusinessType,getItemName('BadAssetBusinessType',BusinessType) as BusinessTypeName,"+
			" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
			" BeginDate,EndDate,IsoverLawTerm,getItemName('YesNo',IsoverLawTerm) as IsoverLawTermName,"+
			" case when Harvest_Record.HarvestType = '01' then Harvest_Record.HarvestSum else 0 end as HarvestSumCash,"+
			" case when Harvest_Record.HarvestType <> '01' then Harvest_Record.HarvestSum else 0 end as HarvestSumAsset,"+
			" ContractBalance-Bad_Asset.HarvestSum as LossSum,ManageUserName"+
			" from Bad_Asset ,Harvest_Record  where Bad_Asset.SerialNo=Harvest_Record.ObjectNo";
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ö��뷽ʽ
	doTemp.setAlign("ContractSum,ContractBalance,HarvestSumCash,HarvestSumAsset,LossSum","3");
	doTemp.setType("ContractSum,ContractBalance,HarvestSumCash,HarvestSumAsset,LossSum","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("ContractSum,ContractBalance,HarvestSumCash,HarvestSumAsset,LossSum","2");
	doTemp.setVisible("BusinessType,VouchType,IsoverLawTerm",false);
	//���ɲ�ѯ��
	
	doTemp.setDDDWCode("IsoverLawTerm","YesNo");
	doTemp.setDDDWCode("BusinessType","BadAssetBusinessType");
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from code_library where codeno='VouchType' and length(itemno)=3");	
	
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","PutoutOrgName","");
	doTemp.setFilter(Sqlca,"3","IsoverLawTerm","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"4","BusinessType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"5","VouchType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"6","ManageUserName","");
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
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
	String sButtons[][] = {
		//{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		//{"true","","Button","�鿴�������","�鿴�������","viewOpinions()",sResourcesPath},
		//{"true","","Button","�鿴���鱨��","�鿴���鱨��","viewReport()",sResourcesPath}
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
		//���ҵ����ˮ��
		sSerialNo =getItemValue(0,getRow(),"SerialNo");	
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			openObject("CreditApply",sSerialNo,"002");
		}
	}	
    
    /*~[Describe=�鿴�������;InputParam=��;OutPutParam=��;]~*/
	function viewOpinions()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
	    popComp("ViewFlowOpinions","/Common/WorkFlow/ViewFlowOpinions.jsp","ObjectType=CreditApply&ObjectNo="+sObjectNo,"dialogWidth=50;dialogHeight=40;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	}
	/*~[Describe=�鿴���鱨��;InputParam=��;OutPutParam=��;]~*/
	function viewReport()
	{
		sObjectType = "CreditApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		
		var sDocID = PopPage("/FormatDoc/ReportTypeSelect.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
		if (typeof(sDocID)=="undefined" || sDocID.length==0)
		{
			alert("���鱨�滹δ��д��������д���鱨���ٲ鿴��");
			return;
		}
		
		sReturn = PopPage("/FormatDoc/GetReportFile.jsp?ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&DocID="+sDocID,"","");
		if (sReturn == "false")
		{
			alert("���鱨�滹δ���ɣ��������ɵ��鱨���ٲ鿴��");
			return;  
		}
		
		var CurOpenStyle = "width=720,height=540,top=20,left=20,toolbar=no,scrollbars=yes,resizable=yes,status=yes,menubar=no,";		
		OpenPage("/FormatDoc/PreviewFile.jsp?DocID="+sDocID+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"_blank02",CurOpenStyle); 
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
