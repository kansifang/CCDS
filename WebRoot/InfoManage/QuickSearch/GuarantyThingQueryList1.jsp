<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-26
		Tester:
		Content: ��������Ϣ���ٲ�ѯ
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ���������Ϣ���ٲ�ѯ
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��������Ϣ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	String sComponentName = "";//--����������
	String PG_CONTENT_TITLE = "";
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
		String sHeaders[][] =	{ 							
									{"OwnerName","Ȩ��������"},
									{"GuarantyID","��Ѻ����"},
									{"GuarantyName","��Ѻ������"},
									{"GuarantyType","��Ѻ������"},
									{"GuarantyTypeName","��Ѻ������"},
									{"GuarantyRightID","Ȩ֤��"},//new
									{"OwnerType","Ȩ��������"},
									{"EvalCurrencyName","��Ѻ�����"},
									{"EvalNetValue","��Ѻ����"},
									{"ConfirmValue","���Ϣ�ܶ�"},
									{"GuarantyRate","��Ѻ��"}
								}; 
		
		sSql =	" select GI.GuarantyID,GI.GuarantyName,GI.GuarantyType,getItemName('GuarantyList',GI.GuarantyType) as GuarantyTypeName,GI.OwnerName, " +
				" GI.GuarantyRightID,getItemName('SecurityType',GI.OwnerType) as OwnerType," +
				" GI.EvalCurrency,getItemName('Currency',GI.EvalCurrency) as EvalCurrencyName,GI.EvalNetValue,"+
				" GI.ConfirmValue,GI.GuarantyRate ,GR.ObjectNo" +
		       	" from GUARANTY_INFO GI,GUARANTY_RELATIVE GR " +
				" where GI.GuarantyID = GR.GuarantyID and GR.ObjectType='BusinessContract' "+
				" and GuarantyType like '020%' and InputOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("GI.GuarantyID");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_INFO";	
	//���ùؼ���
	doTemp.setKey("GuarantyID",true);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("OwnerName","style={width:250px} ");  
	//���ò��ɼ���
	doTemp.setVisible("EvalCurrency,GuarantyType,GuarantyCurrency,ObjectNo",false);		
	//���ö��뷽ʽ
	doTemp.setAlign("EvalNetValue,ConfirmValue","3");
	doTemp.setType("EvalNetValue,ConfirmValue","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("EvalNetValue,ConfirmValue","2");	
	//����������
	doTemp.setDDDWSql("GuarantyType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'GuarantyList' and ItemNo  like '020%' and length(ItemNo) > 3");

	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","GuarantyName","");
	doTemp.setFilter(Sqlca,"2","GuarantyType","Operators=EqualsString;");
	doTemp.setFilter(Sqlca,"3","EvalNetValue","");
	doTemp.setFilter(Sqlca,"4","GuarantyID","");
	doTemp.setFilter(Sqlca,"5","GuarantyRightID","");
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
		//��õ�������ˮ��
		sGuarantyID    =getItemValue(0,getRow(),"GuarantyID");	
		sGuarantyType=getItemValue(0,getRow(),"GuarantyType");
		if (typeof(sGuarantyID)=="undefined" || sGuarantyID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
		    popComp("GuarantyThingQueryInfo","/InfoManage/QuickSearch/GuarantyThingQueryInfo.jsp","GuarantyType="+sGuarantyType+"&GuarantyID="+sGuarantyID,"","");
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
