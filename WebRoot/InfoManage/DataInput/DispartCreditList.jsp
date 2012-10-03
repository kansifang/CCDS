<%@	page contentType="text/html; charset=GBK"%>
<%@	include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2011/06/14
		Tester:
		Describe: �ִηſ��ͬ����
		Input Param:
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ִηſ��ͬ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	
	//�������
	String sSql1="";
	String sCondition ="";

	//���ҳ�����
	
	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	if (sReinforceFlag==null) sReinforceFlag="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","��ͬ��ˮ��"},
							{"CustomerName","�ͻ�����"},							
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"CreditAggreement","���Э����"},						
							{"OccurTypeName","��������"},													
							{"Currency","����"},
							{"BusinessSum","��ͬ���"},
							{"Balance","���"},
							{"NormalBalance","�������"},
							{"OverdueBalance","�������"},
							{"DullBalance","�������"},
							{"BadBalance","�������"},						
							{"BusinessRate","����(��)"},
							{"InterestBalance1","����ǷϢ���"},
							{"InterestBalance2","����ǷϢ���"},
							{"PutOutDate","��ʼ����"},
							{"Maturity","��������"},
							{"VouchTypeName","������ʽ"},							
							{"ClassifyResult","���շ���"},
							{"UserName","�ͻ�����"},
							{"OperateOrgName","�������"},
							{"VouchType","��Ҫ������ʽ"}
						  };
   
 		String sSql = " select SerialNo,CustomerID,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance,"+
					" nvl(InterestBalance1,0) as InterestBalance1,nvl(InterestBalance2,0) as InterestBalance2,"+
					" BusinessRate,PutOutDate,Maturity,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
					" getOrgName(ManageOrgID) as OrgName,"+
					" getUserName(ManageUserID) as UserName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where SerialNo like 'FC%' and ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') "+
					" and (FinishDate = '' or FinishDate is null)";

	//����֧�пͻ��������пͻ��������пͻ�������û�ֻ�ܲ鿴�Լ��ܻ��ĺ�ͬ
	if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080"))
	{
	    sSql += " and ManageUserID = '"+CurUser.UserID+"'";
	}
	sSql += " order by CustomerName";
	//out.println(sSql);
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);

	doTemp.setVisible("OverdueBalance,CustomerID,OccurTypeName,BusinessRate",false);	
	
	//���ò��ɼ���
	doTemp.setVisible("BusinessType,OccurType,BusinessCurrency,VouchType,OperateOrgID,OrgName",false);	
	
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
	doTemp.setAlign("BadBalance,DullBalance,NormalBalance,BusinessSum,Balance,OverdueBalance,BusinessRate","3");
	doTemp.setType("BadBalance,DullBalance,NormalBalance,InterestBalance1,InterestBalance2,BusinessSum,Balance,OverdueBalance,BusinessRate","Number");
	doTemp.setCheckFormat("BadBalance,DullBalance,NormalBalance,BusinessSum,Balance,OverdueBalance","2");
	doTemp.setCheckFormat("BusinessRate","16");
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setDDDWSql("VouchType","select ItemNo,ItemName from code_library where codeno = 'VouchType' and ItemNo in ('005','010','020','040')");
	doTemp.setAlign("BusinessTypeName,OccurTypeName,Currency","2");
	//doTemp.setColumnAttribute("CustomerName,BusinessTypeName,SerialNo,Maturity,VouchType","IsFilter","1");
	
	doTemp.setFilter(Sqlca,"1","CustomerName","");
	doTemp.setFilter(Sqlca,"2","BusinessTypeName","");	
	doTemp.setFilter(Sqlca,"3","SerialNo","");
	doTemp.setFilter(Sqlca,"4","BusinessSum","");
	doTemp.setFilter(Sqlca,"5","Maturity","");
	doTemp.setFilter(Sqlca,"6","VouchType","Operators=BeginsWith");	
	doTemp.parseFilterData(request,iPostChange);
	
	//doTemp.generateFilters(Sqlca);
	//doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(10); 	//��������ҳ

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
		{"true","","Button","������ͬ","������ͬ","NewContract()",sResourcesPath},	
		{"true","","Button","�鿴��ͬ����","�鿴��ͬ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ����ͬ","ɾ����ͬ","Delete()",sResourcesPath},
		{"true","","Button","��ͬ���½�ݹ���","��ͬ���½�ݹ���","addRelativeBD()",sResourcesPath},
		{"true","","Button","ɾ����ͬ���½��","ɾ����ͬ���½��","deleteRelativeBD()",sResourcesPath},
	};

	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		openObject("ReinforceContract",sObjectNo,"001");
		reloadSelf();	
	}
	
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������ͬ;InputParam=��;OutPutParam=��;]~*/
	function NewContract()
	{
		sCompID	 = "ReinforceCreation2";
		sCompURL = "/InfoManage/DataInput/ReinforceCreationInfo2.jsp";
		sReturn = popComp(sCompID,sCompURL,"","dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(!(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") )
		{
			sReturn = sReturn.split("@");
			var sObjectNo = sReturn[0];
			openObject("ReinforceContract",sObjectNo,"002");					
		}
		else
		{
			return;
		}
		reloadSelf();
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function Delete()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}   
		//�Ƿ���ڽ��
	    var sColName = "count(serialno)";
		var sTableName = "Business_Duebill";
		var sWhereClause = "String@RelativeSerialNo2@"+sSerialNo;
			
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturnValue = sReturn.split('@');
			if(sReturnValue[1]>0) 
			{
				alert("�ñʺ�ͬ���ڽ����Ϣ������ɾ����");
				return;
				
			}else
			{
				if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
				{
					as_del('myiframe0');
		            as_save('myiframe0');  //�������ɾ������Ҫ���ô����
					//reloadSelf();
				}
			}
		}
	}
	
	
	/*~[Describe=���ӹ�����ͬ(���);InputParam=��;OutPutParam=��;]~*/
	function addRelativeBD()
	{
		//��ͬ��ˮ�š��ͻ���š���ͬ���
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sArtificialNo   = getItemValue(0,getRow(),"ArtificialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{	
			 var sReturn = popComp("UniteContractSelectList1","/InfoManage/DataInput/UniteContractSelectList1.jsp","ContractNo="+sSerialNo+"&CustomerID="+sCustomerID+"&Flag=AddContract","dialogWidth=50;dialogHeight=40;","resizable=yes;scrollbars=yes;status:no;maximize:yes;help:no;");
			 if(sReturn=="true")
			 {
				reloadSelf();
			 }
		}
	}
	
	/*~[Describe=ɾ��������ͬ(���);InputParam=��;OutPutParam=��;]~*/
	function deleteRelativeBD()
	{
		//��ͬ��ˮ�š��ͻ���š���ͬ���
		var sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		var sCustomerID   = getItemValue(0,getRow(),"CustomerID");
		var sArtificialNo   = getItemValue(0,getRow(),"ArtificialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{	
			 var sReturn = popComp("UniteContractSelectList1","/InfoManage/DataInput/UniteContractSelectList1.jsp","ContractNo="+sSerialNo+"&CustomerID="+sCustomerID+"&Flag=DeleteContract","dialogWidth=50;dialogHeight=40;","resizable=yes;scrollbars=yes;status:no;maximize:yes;help:no;");
			 if(sReturn=="true")
			 {
				reloadSelf();
			 }
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
