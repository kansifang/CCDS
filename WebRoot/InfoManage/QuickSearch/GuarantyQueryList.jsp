<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: ������ͬ���ٲ�ѯ
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ�������ͬ���ٲ�ѯ
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������ͬ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql
	String sComponentName = "";//--�������
	String PG_CONTENT_TITLE = "";
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"CustomerID","�ͻ����"},
							{"CustomerName","�����ͻ�����"},
							{"ContractType","��������"},
							{"ContractTypeName","��������"},
							{"VouchType","������ʽ"},
							{"VouchTypeName","������ʽ"},
							{"GuarantorName","����������"},
							{"GuarantyCurrencyName","��������"},
							{"GuarantyValue","�����ܽ��"},
							{"SerialNo","������ͬ��ˮ��"},
							{"BusinessName","ҵ��Ʒ��"},
							{"TermMonth","����"},
							{"PutOutDate","��ͬ������"},
							{"Maturity","��ͬ������"},
							{"ClassifyResult","���շ���(�弶)����"},
							{"BaseClassifyResult","���շ���(�弶)ʵ��"},
							{"ManageOrgName","�ܻ�����"},
							}; 
	
	sSql =	" select GC.SerialNo,GC.ContractNo,CR.ObjectNo as ObjectNo,GC.CustomerID,getCustomerName(GC.CustomerID) as CustomerName, " +
			" GC.ContractType,getItemName('ContractType1',GC.ContractType) as ContractTypeName, "+
			" BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
			" GC.GuarantorName ,"+
			" getItemName('Currency',GC.GuarantyCurrency) as GuarantyCurrencyName,GC.GuarantyValue, " +
			" getBusinessName(BC.BusinessType) as BusinessName,"+
			" BC.TermMonth,BC.PutOutDate,BC.Maturity,"+
			" getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResult,"+
			" getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResult,"+
			" getOrgName(BC.ManageOrgID) as ManageOrgName  "+
	       	" from GUARANTY_CONTRACT GC,BUSINESS_CONTRACT BC,CONTRACT_RELATIVE CR" +
			" where CR.SerialNo = BC.SerialNo and CR.ObjectNo = GC.SerialNo and GC.ContractStatus ='020' "+
			" and GC.InputOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
		
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("GC.SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";	
	//���ùؼ���
	doTemp.setKey("SerialNo",true);
	//���ò��ɼ���
	doTemp.setVisible("VouchType,ObjectNo,ContractNo,BusinessType,ContractType",false);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName,GuarantorName","style={width:250px} ");  		
	//���ö��뷽ʽ
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setType("GuarantyValue","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("GuarantyValue","2");	
	//����������
//	doTemp.setDDDWSql("ContractType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ContractType1' ");
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'VouchType' and length(ItemNo)>3 and IsInUse = '1' order by sortno ");
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","CustomerName","");
//	doTemp.setFilter(Sqlca,"2","ContractType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"2","GuarantorName","");
	doTemp.setFilter(Sqlca,"3","GuarantyValue","");
	doTemp.setFilter(Sqlca,"4","SerialNo","");
	doTemp.setFilter(Sqlca,"5","VouchType","Operators=EqualsString;");
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
		{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","ҵ���ͬ����","ҵ���ͬ����","viewTab()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
	};
	
	if(CurUser.hasRole("095")||CurUser.hasRole("0A2")||CurUser.hasRole("0B5")||CurUser.hasRole("0C2")||
	 CurUser.hasRole("0D2")||CurUser.hasRole("0E9")||CurUser.hasRole("0F4")||CurUser.hasRole("0H5")||
	 CurUser.hasRole("0I4")||CurUser.hasRole("0J1")||CurUser.hasRole("282")||CurUser.hasRole("295")||
	 CurUser.hasRole("2A4")||CurUser.hasRole("2B9")||CurUser.hasRole("2C2")||CurUser.hasRole("2D4")||
	 CurUser.hasRole("2E4")||CurUser.hasRole("2G5")||CurUser.hasRole("2H5")||CurUser.hasRole("2I2")||
	 CurUser.hasRole("421")||CurUser.hasRole("495"))
	{
		sButtons[2][0] = "false";
	}
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
			openObject("GuarantyContract",sSerialNo,"002");
		}
	}	
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sObjectNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
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
