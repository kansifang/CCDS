<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hlzhang 2012-07-17
		Tester:
		Describe: ����������ʷ��¼�б�
		Input Param:
				ObjectType���������ͣ���
				ObjectNo: �����ţ���ͬ��ˮ�ţ�
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����������ʷ��¼�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";
	//�������������������͡�������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"BPBSerialNo","���������޸���ˮ��"},
							{"SerialNo","������ˮ��"},
							{"ContractSerialNo","��ͬ��ˮ��"},							
							{"CustomerName","�ͻ�����"},
							{"BusinessType","ҵ��Ʒ��"},	
							{"BusinessTypeName","ҵ��Ʒ��"},				            
							{"BusinessCurrency","����"},
							{"Businesssum","���"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"},
							{"ModifyUserName","�޸���"},
							{"ModifyOrgName","�޸Ļ���"}
						  };
				
	sSql =  " select BPBSerialNo,SerialNo,ContractSerialNo, "+
			" CustomerID,CustomerName,"+
			" BusinessType, "+
			" getBusinessName(BusinessType) as BusinessTypeName, "+
			" Businesssum,"+
			" getItemName('Currency',BusinessCurrency) as BusinessCurrency, "+
			" InputUserID,getUserName(InputUserID) as InputUserName, "+
			" InputOrgID,getOrgName(InputOrgID) as InputOrgName, "+
			" ModifyUserID,getUserName(ModifyUserID) as ModifyUserName, "+
			" ModifyOrgID,getOrgName(ModifyOrgID) as ModifyOrgName "+
			" from BUSINESS_PUTOUT_BAK  "+
			" where SerialNo = '"+sObjectNo+"' "+
			" Order by BPBSerialNo Desc ";
	
	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ,���±���,��ֵ,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BUSINESS_PUTOUT_BAK";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("CustomerID,InputUserID,InputOrgID,ModifyUserID,ModifyOrgID",false);
	//���ø�ʽ
	doTemp.setAlign("Businesssum","3");
	//doTemp.setHTMLStyle("BP.CustomerName"," style={width:180px} ");
	doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where IsinUse='1' and ContractDetailNo is not null  order by SortNo");
	doTemp.setVisible("BusinessType",false);
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");	
	doTemp.setFilter(Sqlca,"3","BusinessType","");	
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	
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
			{(CurUser.hasRole("0ZZ")?"true":"false"),"","Button","��������","��������","viewTab()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = "PutOutApply";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sBPBSerialNo = getItemValue(0,getRow(),"BPBSerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//OpenComp("HistoryGuarantyContractInfo","/SystemManage/SynthesisManage/HistoryGuarantyContractInfo.jsp","GuarantyType="+sGuarantyType+"&SerialNo="+sObjectNo,"_blank");
		OpenPage("/SystemManage/SynthesisManage/HistoryPutOutInfo.jsp?BPBSerialNo="+sBPBSerialNo+"&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo, "_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>