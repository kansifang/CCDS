<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: ���շ�����Ϣ���ٲ�ѯ
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ����շ�����Ϣ���ٲ�ѯ
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���շ�����Ϣ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	String sComponentName = "";//--�������
	String PG_CONTENT_TITLE = "";
	String sCustomerType =""; //�ͻ����� 1Ϊ��˾�ͻ� 2Ϊͬҵ�ͻ� 3Ϊ���˿ͻ�
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	sCustomerType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerType"));
	if(sCustomerType == null) sCustomerType="";
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	
	//�����ͷ�ļ�����ͬ��
	String sHeaders[][] = {
									{"CustomerID","�ͻ����"},
									{"CustomerName","�ͻ�����"},
									{"ObjectNo","��ͬ��ˮ��"},
									{"BusinessTypeName","ҵ��Ʒ��"},
									{"BusinessType","ҵ������"},
									{"AccountMonth","�����������"},
									{"BusinessSum","���"},
									{"Balance","���"},
									{"PutOutDate","��ʼ��"},
									{"Maturity","������"},
									{"Currency","����"},
									{"InterEstBalance1","����ǷϢ"},
									{"InterEstBalance2","����ǷϢ"},
									{"VouchType","��Ҫ������ʽ"},
									{"VouchTypeName","��Ҫ������ʽ"},
									{"Result2Name","�ͻ�������ֽ�������棩"},
									{"ClassifyLevel2","�ͻ�������ֽ����ʵ�ʣ�"},
									{"ClassifyResult","��ǰ���շ����������棩"},
									{"ClassifyResultName","��ǰ���շ����������棩"},
									{"BaseClassifyResult","��ǰ���շ�������ʵ�ʣ�"},
									{"BaseClassifyResultName","��ǰ���շ�������ʵ�ʣ�"},
									{"FinallyResult","���ڷ��շ����������棩"},
									{"FinallyResultName","���ڷ��շ����������棩"},
									{"FinallyBaseResult","���ڷ��շ�������ʵ�ʣ�"},
									{"FinallyBaseResultName","���ڷ��շ�������ʵ�ʣ�"},
									{"OperateOrgID","�������"},
									{"OperateOrgName","�������"},
									{"OperateUserID","������"},
									{"OperateUserName","������"},
									{"FinancePlatformFlag","�Ƿ�����ƽ̨"}
							}; 
	if("1".equalsIgnoreCase(sCustomerType)){						
		sSql = " select CR.ObjectType,Cr.ObjectNo,CR.SerialNo,BC.CustomerID,BC.CustomerName, " +
					" BC.BusinessType,CR.AccountMonth,getBusinessName(BC.BusinessType) as BusinessTypeName, " +
					" getItemName('Currency',BusinessCurrency) as Currency,BC.BusinessSum, BC.Balance, " +
					" BC.InterEstBalance1,BC.InterEstBalance2, "+
					" BC.PutOutDate,BC.Maturity,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
					" getItemName('ClassifyResult',CR.ClassifyLevel) as Result2Name , "+
					" getItemName('ClassifyResult',CR.ClassifyLevel2) as ClassifyLevel2 , "+
					" BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName , "+
					" BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResultName , "+
					" CR.FinallyResult,getItemName('ClassifyResult',CR.FinallyResult) as FinallyResultName , "+
					" CR.FinallyBaseResult,getItemName('ClassifyResult',CR.FinallyBaseResult) as FinallyBaseResultName , "+
					" OperateOrgID,getOrgName(BC.OperateOrgID) as OperateOrgName, "+
					" OperateUserID,getUserName(BC.OperateUserID) as OperateUserName, "+
					" GETCustomerFPFlag(BC.CustomerID) as FinancePlatformFlag "+
		       		" from CLASSIFY_RECORD CR,BUSINESS_CONTRACT BC ,ENT_INFO EI" +
					" where CR.ObjectNo = BC.SerialNo "+
					" and BC.CustomerID = EI.CustomerID  and OrgNature like '01%' and OrgNature <>'07' "+
					" and CR.ObjectType = 'BusinessContract' "+
					" and ManageOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if("3".equalsIgnoreCase(sCustomerType)){
		sSql = " select CR.ObjectType,Cr.ObjectNo,CR.SerialNo,BC.CustomerID,BC.CustomerName, " +
					" BC.BusinessType,CR.AccountMonth,getBusinessName(BC.BusinessType) as BusinessTypeName, " +
					" getItemName('Currency',BusinessCurrency) as Currency,BC.BusinessSum, BC.Balance, " +
					" BC.InterEstBalance1,BC.InterEstBalance2, "+
					" BC.PutOutDate,BC.Maturity,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
					" getItemName('ClassifyResult',CR.ClassifyLevel) as Result2Name, "+
					" getItemName('ClassifyResult',CR.ClassifyLevel2) as ClassifyLevel2 , "+
					" BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName , "+
					" BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResultName , "+
					" CR.FinallyResult,getItemName('ClassifyResult',CR.FinallyResult) as FinallyResultName , "+
					" CR.FinallyBaseResult,getItemName('ClassifyResult',CR.FinallyBaseResult) as FinallyBaseResultName , "+
					" OperateOrgID,getOrgName(BC.OperateOrgID) as OperateOrgName, "+
					" OperateUserID,getUserName(BC.OperateUserID) as OperateUserName, "+
					" GETCustomerFPFlag(BC.CustomerID) as FinancePlatformFlag "+
		       		" from CLASSIFY_RECORD CR,BUSINESS_CONTRACT BC ,IND_INFO II" +
					" where CR.ObjectNo = BC.SerialNo "+
					" and BC.CustomerID = II.CustomerID "+ 
					" and CR.ObjectType = 'BusinessContract' "+
					" and ManageOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	/*
	//�����ͷ�ļ�����ݣ�
	String sHeaders[][] = {
									{"CustomerID","�ͻ����"},
									{"CustomerName","�ͻ�����"},
									{"ObjectNo","�����ˮ��"},
									{"BusinessTypeName","ҵ��Ʒ��"},
									{"BusinessType","ҵ������"},
									{"BusinessSum","���"},
									{"Balance","���"},
									{"PutOutDate","��Ϣ��"},
									{"Maturity","������"},
									{"Currency","����"},
									{"FinallyResult","�϶����"},
									{"FinallyResultName","�϶����"},
									{"OperateOrgName","�������"},
									{"OperateUserName","������"}
							}; 
							
	sSql =		" select CR.ObjectType,Cr.ObjectNo,CR.SerialNo,BD.CustomerID,BD.CustomerName, " +
				" BD.BusinessType,getBusinessName(BD.BusinessType) as BusinessTypeName, " +
				" getItemName('Currency',BD.BusinessCurrency) as Currency,BD.BusinessSum, BC.Balance" +
				" BD.PutOutDate,BD.Maturity,CR.FinallyResult,getItemName('ClassifyResult',CR.FinallyResult) as FinallyResultName " +
				" getOrgName(BD.OperateOrgID) as OperateOrgName, "+
				" getUserName(BD.OperateUserID) as OperateUserName,"+
	       		" from CLASSIFY_RECORD CR,BUSINESS_DUEBIll BD ,ENT_INFO EI" +
				" where CR.ObjectNo = BD.SerialNo "+
				" and BD.CustomerID = EI.CustomerID  and OrgNature like '01%' and OrgNature <>'0107' "+
				" and CR.ObjectType = 'BusinessDueBill' "+
				" and BD.OperateOrgID in  (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	*/
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("CR.SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CLASSIFY_RECORD";
	
	//���ùؼ���
	doTemp.setKey("ObjectType,ObjectNo,SerialNo",true);

	//���ò��ɼ���
	doTemp.setVisible("FinallyResult,FinallyBaseResult,ClassifyResultName,BaseClassifyResultName,ClassifyResult,BaseClassifyResult,ObjectType,SerialNo,CustomerID,BusinessType,VouchType,OperateOrgID,OperateUserID,FinancePlatformFlag",false);
	doTemp.setCheckFormat("PutOutDate,Maturity,FinishDate","3");
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("Currency","style={width:60px} ");
	doTemp.setHTMLStyle("InterEstBalance1,InterEstBalance2","style={width:80px} ");	  
	doTemp.setHTMLStyle("CustomerName,OperateOrgName","style={width:250px} "); 		
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum","3");
	doTemp.setType("BusinessSum,Balance","Number");

	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum","2");
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWCode("FinancePlatformFlag","YesNo");
		doTemp.setDDDWSql("FinallyResult,FinallyBaseResult,ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)>2");	
	}else if("3".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWSql("FinallyResult,FinallyBaseResult,ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)=2");	
	}
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%1%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	}else if("3".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%2%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	}
	
	doTemp.setDDDWSql("OperateOrgID","select OrgID,OrgName from ORG_INFO");
	//doTemp.setDDDWSql("OperateUserID","select UserID,UserName from USER_INFO");
	
	//���ɲ�ѯ��
	doTemp.generateFilters(Sqlca);
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","BusinessType","");
	doTemp.setFilter(Sqlca,"3","ObjectNo","");
	doTemp.setFilter(Sqlca,"4","BusinessSum","");
	doTemp.setFilter(Sqlca,"5","AccountMonth","");
	doTemp.setFilter(Sqlca,"6","FinallyResult","");
	doTemp.setFilter(Sqlca,"7","FinallyBaseResult","");
	doTemp.setFilter(Sqlca,"8","Balance","");
	doTemp.setFilter(Sqlca,"9","OperateOrgID","");
	doTemp.setFilter(Sqlca,"10","OperateUserID","");
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setFilter(Sqlca,"10","FinancePlatformFlag","Operators=EqualsString;");	
	}
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
		sObjectNo =getItemValue(0,getRow(),"ObjectNo");
		sObjectType =getItemValue(0,getRow(),"ObjectType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			OpenComp("ClassifyQueryInfo","/InfoManage/QuickSearch/ClassifyQueryInfo.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo, "_bank",OpenStyle);
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
