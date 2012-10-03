<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   CYHui 2005-1-25
		Tester:
		Content: ��ͬ��Ϣ���ٲ�ѯ
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ���ͬ��Ϣ���ٲ�ѯ
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ��Ϣ���ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
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
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"SerialNo","�����ˮ��"},
							{"RelativeSerialNo2","��ͬ��ˮ��"},
							{"CustomerID","�ͻ����"},
							{"CustomerName","�ͻ�����"},
							{"BusinessType","ҵ��Ʒ��"},										
							{"BusinessTypeName","ҵ��Ʒ��"},										
							{"BusinessSum","���"},
							{"Balance","���"},										
							{"Currency","����"},
							{"RateFloat","���ʸ�������"},
							{"ActualBusinessRate","ִ��������(��)"},
							{"InterEstBalance1","����ǷϢ"},
							{"InterEstBalance2","����ǷϢ"},
							{"NormalBalance","�������"},
							{"OverdueBalance","�������"},
							{"DullBalance","�������"},
							{"BadBalance","�������"},
							{"PutOutDate","�����ʼ��"},
							{"Maturity","��ݵ�����"},
							{"VouchType","��Ҫ������ʽ"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"ManageOrgName","�ܻ�����"},
							{"ManageUserName","�ܻ���"},
							{"MfOrgName","���˻���"},
							{"FinancePlatformFlag","�Ƿ�����ƽ̨"}
							}; 
	if("1".equalsIgnoreCase(sCustomerType)){
		sSql =	" select BD.SerialNo,BD.RelativeSerialNo2,BD.CustomerID,BD.CustomerName,BD.BusinessType, "+
				" getBusinessName(BD.BusinessType) as BusinessTypeName, "+
				" getItemName('Currency',BD.BusinessCurrency) as Currency,BD.BusinessSum,BD.Balance,BC.RateFloat, BD.ActualBusinessRate, "+
				" BD.InterEstBalance1,BD.InterEstBalance2,BD.NormalBalance,BD.OverdueBalance,BD.DullBalance,BD.BadBalance, "+
				" BD.PutOutDate,BD.Maturity,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
				" getOrgName(BC.ManageOrgID) as ManageOrgName,getUserName(BC.ManageUserID) as ManageUserName, " +
				" getOrgName(BD.MfOrgID) as MfOrgName,"+
				" GETCustomerFPFlag(BD.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_DUEBILL BD,BUSINESS_CONTRACT BC ,BUSINESS_TYPE BT"+
		       	" where BT.TypeNo = BD.BusinessType and BT.Attribute1 = '1' "+
				" and BD.RelativeSerialNo2 = BC.SerialNo and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if("3".equalsIgnoreCase(sCustomerType)){
				sSql =	" select BD.SerialNo,BD.RelativeSerialNo2,BD.CustomerID,BD.CustomerName,BD.BusinessType, "+
				" getBusinessName(BD.BusinessType) as BusinessTypeName, "+
				" getItemName('Currency',BD.BusinessCurrency) as Currency,BD.BusinessSum,BD.Balance,BC.RateFloat, BD.ActualBusinessRate, "+
				" BD.InterEstBalance1,BD.InterEstBalance2,BD.NormalBalance,BD.OverdueBalance,BD.DullBalance,BD.BadBalance, "+
				" BD.PutOutDate,BD.Maturity,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
				" getOrgName(BC.ManageOrgID) as ManageOrgName,getUserName(BC.ManageUserID) as ManageUserName, " +
				" getOrgName(BD.MfOrgID) as MfOrgName,"+
				" GETCustomerFPFlag(BD.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_DUEBILL BD,BUSINESS_CONTRACT BC ,BUSINESS_TYPE BT"+
		       	" where BT.TypeNo = BD.BusinessType and BT.Attribute1 = '2' "+
				" and BD.RelativeSerialNo2 = BC.SerialNo and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("BD.SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	doTemp.setKey("CustomerID",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("ActualBusinessRate","style={width:60px} "); 		
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum,ActualBusinessRate,Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance","3");	
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum,NormalBalance,OverdueBalance,DullBalance,BadBalance,RateFloat","2");	
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	doTemp.setType("BusinessSum,ActualBusinessRate,Balance,TermMonth,InterEstBalance1,InterEstBalance2,NormalBalance,OverdueBalance,DullBalance,BadBalance","Number");
	doTemp.setVisible("VouchType,BusinessType,BusinessSum,FinancePlatformFlag",false);
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'VouchType' and Length(ItemNo)>3");
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWCode("FinancePlatformFlag","YesNo");
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where Attribute1 = '1' and typeno not like '3%' ");
	}else if("3".equalsIgnoreCase(sCustomerType)) {
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where Attribute1 = '2' and typeno not like '3%'");
	}
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");	
	doTemp.setFilter(Sqlca,"3","BusinessType","");
	doTemp.setFilter(Sqlca,"4","BusinessSum","");
	doTemp.setFilter(Sqlca,"5","Balance","");
	doTemp.setFilter(Sqlca,"6","ManageOrgName","");
	doTemp.setFilter(Sqlca,"7","PutOutDate","");
	doTemp.setFilter(Sqlca,"8","Maturity","");	
	doTemp.setFilter(Sqlca,"9","VouchType","");	
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
		sSerialNo =getItemValue(0,getRow(),"RelativeSerialNo2");	
		
	    sObjectType = "AfterLoan";
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sCompID = "CreditTab";
    		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
    		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sSerialNo;
    		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	/*~[Describe=ʹ��OpenComp������;InputParam=��;OutPutParam=��;]~*/
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"RelativeSerialNo2");
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
