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
	String sCustomerType =""; //�ͻ����� 1Ϊ��˾�ͻ� 2Ϊͬҵ�ͻ� 3Ϊ���˿ͻ� 4Ϊ���ù�ͬ��
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
							{"SerialNo","��ͬ��ˮ��"},
							{"CustomerID","�ͻ����"},
							{"CustomerName","�ͻ�����"},
							{"BusinessType","ҵ��Ʒ��"},										
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"OccurType","��������"},										
							{"OccurTypeName","��������"},
							{"BusinessSum","���"},
							{"Balance","���"},										
							{"Currency","����"},
							{"RateFloat","���ʸ�������"},
							{"BusinessRate","ִ��������(��)"},
							{"InterEstBalance1","����ǷϢ"},
							{"InterEstBalance2","����ǷϢ"},
							{"NormalBalance","�������"},
							{"OverdueBalance","�������"},
							{"DullBalance","�������"},
							{"BadBalance","�������"},
							{"PutOutDate","��ͬ��ʼ��"},
							{"Maturity","��ͬ������"},
							{"FinishDate","�ս�����"},
							{"ClassifyResult","��ǰ���շ����������棩"},
							{"ClassifyResultName","��ǰ���շ����������棩"},
							{"BaseClassifyResult","��ǰ���շ�������ʵ�ʣ�"},
							{"BaseClassifyResultName","��ǰ���շ�������ʵ�ʣ�"},
							{"VouchType","��Ҫ������ʽ"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"ManageOrgName","�ܻ�����"},
							{"ManageUserName","�ܻ���"},
							{"FinancePlatformFlag","�Ƿ�����ƽ̨"}
							}; 
	if(sCustomerType.equalsIgnoreCase("1")){
		sSql =	" select BC.SerialNo,BC.CustomerID,BC.CustomerName,BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
				" BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
				" getItemName('Currency',BC.BusinessCurrency) as Currency,BC.BusinessSum,BC.Balance,BC.RateFloat, "+
				" BC.BusinessRate,BC.InterEstBalance1,BC.InterEstBalance2,NormalBalance,OverdueBalance,DullBalance,BadBalance,"+
				" BC.PutOutDate,BC.Maturity,BC.FinishDate,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
				" BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
				" BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResultName,"+
				" getOrgName(BC.ManageOrgID) as ManageOrgName,getUserName(BC.ManageUserID) as ManageUserName, " +
				" GETCustomerFPFlag(BC.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_CONTRACT BC ,BUSINESS_TYPE BT"+
		       	" where BT.TypeNo = BC.BusinessType and BT.Attribute1 = '1' and BC.BusinessType not in ('3060','3015')  "+
				" and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if(sCustomerType.equalsIgnoreCase("2")){
		sSql =	" select BC.SerialNo,BC.CustomerID,BC.CustomerName,BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
				" BC.OccurType,getItemName('',BC.OccurType) as OccurTypeName,"+
				" getItemName('Currency',BC.BusinessCurrency) as Currency,BC.BusinessSum,BC.Balance,BC.RateFloat, "+
				" BC.BusinessRate,BC.InterEstBalance1,BC.InterEstBalance2,NormalBalance,OverdueBalance,DullBalance,BadBalance, "+
				" BC.PutOutDate,BC.Maturity,BC.FinishDate,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
				" BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
				" BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResultName,"+
				" getOrgName(BC.ManageOrgID) as ManageOrgName,getUserName(BC.ManageUserID) as ManageUserName, " +
				" GETCustomerFPFlag(BC.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_CONTRACT BC "+
		       	" where BC.BusinessType = '3015' "+
				" and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	else if(sCustomerType.equalsIgnoreCase("3")){
		sSql =	" select BC.SerialNo,BC.CustomerID,BC.CustomerName,BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
				" BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
				" getItemName('Currency',BC.BusinessCurrency) as Currency,BC.BusinessSum,BC.Balance,BC.RateFloat, "+
				" BC.BusinessRate,BC.InterEstBalance1,BC.InterEstBalance2,NormalBalance,OverdueBalance,DullBalance,BadBalance, "+
				" BC.PutOutDate,BC.Maturity,BC.FinishDate,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
				" BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
				" BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResultName,"+
				" getOrgName(BC.ManageOrgID) as ManageOrgName,getUserName(BC.ManageUserID) as ManageUserName, " +
				" GETCustomerFPFlag(BC.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_CONTRACT BC ,BUSINESS_TYPE BT"+
		       	" where BT.TypeNo = BC.BusinessType and BT.Attribute1 = '2' "+
				" and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";		
	}
	else if(sCustomerType.equalsIgnoreCase("4")){
		sSql =	" select BC.SerialNo,BC.CustomerID,BC.CustomerName,BC.BusinessType,getBusinessName(BC.BusinessType) as BusinessTypeName, "+
				" BC.OccurType,getItemName('OccurType',BC.OccurType) as OccurTypeName,"+
				" getItemName('Currency',BC.BusinessCurrency) as Currency,BC.BusinessSum,BC.Balance,BC.RateFloat, "+
				" BC.BusinessRate,BC.InterEstBalance1,BC.InterEstBalance2,NormalBalance,OverdueBalance,DullBalance,BadBalance,"+
				" BC.PutOutDate,BC.Maturity,BC.FinishDate,BC.VouchType,getItemName('VouchType',BC.VouchType) as VouchTypeName, "+
				" BC.ClassifyResult,getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResultName,"+
				" BC.BaseClassifyResult,getItemName('ClassifyResult',BC.BaseClassifyResult) as BaseClassifyResult,"+
				" getOrgName(BC.ManageOrgID) as ManageOrgName,getUserName(BC.ManageUserID) as ManageUserName, " +
				" GETCustomerFPFlag(BC.CustomerID) as FinancePlatformFlag "+
		       	" from BUSINESS_CONTRACT BC ,BUSINESS_TYPE BT"+
		       	" where BT.TypeNo = BC.BusinessType and BT.Attribute1 = '1' and BC.BusinessType = '3060'  "+
				" and BC.ManageOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	}
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	doTemp.setKey("CustomerID",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName,ManageOrgName","style={width:250px} ");  
	doTemp.setHTMLStyle("BusinessRate","style={width:60px} "); 	
	doTemp.setHTMLStyle("InterEstBalance1,InterEstBalance2","style={width:80px} "); 		
	
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum,BusinessRate,Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance","3");	
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum,RateFloat","2");	
	doTemp.setCheckFormat("PutOutDate,Maturity,FinishDate","3");
	doTemp.setType("BusinessSum,BusinessRate,Balance,TermMonth,InterEstBalance1,InterEstBalance2,NormalBalance,OverdueBalance,DullBalance,BadBalance","Number");
	doTemp.setVisible("VouchType,BusinessType,ClassifyResult,BaseClassifyResult,OccurType,InterEstBalance1,InterEstBalance2,NormalBalance,OverdueBalance,DullBalance,BadBalance,FinancePlatformFlag",false);
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'VouchType' and Length(ItemNo)>3");
	doTemp.setDDDWSql("OccurType","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'OccurType' ");
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWCode("FinancePlatformFlag","YesNo");
		doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)>2");	
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%1%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	}else if("3".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWSql("ClassifyResult,BaseClassifyResult","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'ClassifyResult' and length(ItemNo)=2");	
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo not like '3%' and Attribute1 like '%2%' and (DisplayTemplet is not null or DisplayTemplet<>'') and IsInUse = '1' ");
	}else if("2".equalsIgnoreCase(sCustomerType)){
		doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where TypeNo='3015' ");
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
	doTemp.setFilter(Sqlca,"10","OccurType","");
	doTemp.setFilter(Sqlca,"11","ClassifyResult","");	
	doTemp.setFilter(Sqlca,"12","BaseClassifyResult","");
	if("1".equalsIgnoreCase(sCustomerType)){
		doTemp.setFilter(Sqlca,"13","FinancePlatformFlag","Operators=EqualsString;");	
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
		{"true","","Button","�ͻ�������ˮ��Ϣ","�ͻ�������ˮ��Ϣ","viewBusinessSerialInfo()",sResourcesPath},
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
	/*~[Describe=�鿴�ͻ�������ˮ��Ϣ;InputParam=��;OutPutParam=SerialNo;]~*/
	function viewBusinessSerialInfo()
	{
		//��ÿͻ����
		sCustomerID=getItemValue(0,getRow(),"CustomerID");	
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			popComp("BusinessSerialInfoList","/InfoManage/QuickSearch/BusinessSerialInfoList.jsp","ComponentName=��˾�ͻ�������ˮ��Ϣ�б�&CustomerID="+sCustomerID,"","");
		}

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
