<%@	page contentType="text/html; charset=GBK"%>
<%@	include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: ����ճ�����;
		Input Param:
					sDealType��010��Ч�Ķ��ҵ��
						020ʵЧ�Ķ��ҵ��
		Output Param:
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "ҵ���ճ�����"; // ��������ڱ��� <title> PG_TITLE </title>
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
	//String sBusinessType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("BusinessType"));
	String sReinforceFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReinforceFlag"));
	//out.println(sDealType+"@@@"+sReinforceFlag+"###"+sBusinessType);
	if (sReinforceFlag==null) sReinforceFlag="";
	//out.println(sBusinessType);
	
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
							{"BailAccount","��֤���˺�"},
							{"BailSum","��֤��(Ԫ)"},
							{"ClearSum","���ڽ��(Ԫ)"},
							{"FineBalance1","���ڷ�Ϣ���"},
							{"FineBalance2","��Ϣ���"},							
							{"BusinessRate","����(��)"},
							{"InterestBalance1","����ǷϢ���"},
							{"InterestBalance2","����ǷϢ���"},
							{"PdgRatio","����(��)"},
							{"PutOutDate","��ʼ����"},
							{"Maturity","��������"},
							{"VouchTypeName","������ʽ"},							
							{"ClassifyResult","���շ���"},
							{"UserName","�ͻ�����"},
							{"OperateOrgName","�������"},
							{"VouchType","��Ҫ������ʽ"}
						  };
   
 		String sSql = " select SerialNo,CustomerName, "+
					" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+					
					" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
					" CreditAggreement,"+
					" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
					" BusinessSum,nvl(Balance,0) as Balance,NormalBalance,OverdueBalance,DullBalance,BadBalance,BailAccount,nvl(BailSum,0) as BailSum,"+
					" case when (Balance-nvl(BailSum,0))<0 then 0 else (Balance-nvl(BailSum,0)) end as ClearSum,"+
					" nvl(InterestBalance1,0) as InterestBalance1,nvl(InterestBalance2,0) as InterestBalance2,"+
					" FineBalance1,FineBalance2,BusinessRate,PdgRatio,PutOutDate,Maturity,"+
					" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
					" getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,"+
					" getOrgName(ManageOrgID) as OrgName,"+
					" getUserName(ManageUserID) as UserName,"+
					" OperateOrgID,getOrgName(OperateOrgID) as OperateOrgName"+
					" from BUSINESS_CONTRACT"+
					" where SerialNo like 'BC%' and ManageOrgID  in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') "+
					" and (BusinessType like '2050%' or BusinessType like '1020%' or BusinessType like '2030%' or BusinessType like '2040%' "+
					" or BusinessType = '2010' or BusinessType like '1080%' or BusinessType like '2110%' or BusinessType like '2070%' or BusinessType in('1110010'))"+
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

	doTemp.setVisible("OverdueBalance,OccurTypeName,BusinessRate",false);	
	
	//���ò��ɼ���
	doTemp.setVisible("BusinessType,BailAccount,BailSum,ClearSum,OccurType,PdgRatio,BusinessCurrency,VouchType,OperateOrgID,OrgName",false);	
	
	doTemp.UpdateTable = "BUSINESS_CONTRACT";
	doTemp.setAlign("BadBalance,DullBalance,NormalBalance,BusinessSum,Balance,BailSum,OverdueBalance,FineBalance1,FineBalance2,BusinessRate,ClearSum,PdgRatio","3");
	doTemp.setType("BadBalance,DullBalance,NormalBalance,InterestBalance1,InterestBalance2,BusinessSum,Balance,BailSum,OverdueBalance,FineBalance1,FineBalance2,BusinessRate,ClearSum,PdgRatio","Number");
	doTemp.setCheckFormat("BadBalance,DullBalance,NormalBalance,BusinessSum,Balance,BailSum,OverdueBalance,FineBalance1,FineBalance2,PdgRatio,ClearSum","2");
	doTemp.setCheckFormat("BusinessRate","16");
	doTemp.setCheckFormat("PutOutDate,Maturity","3");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName,PdgRatio"," style={width:80px} ");
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
		{"true","","Button","��ͬ����","��ͬ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","�������ҵ�񲹵�","�������ҵ�񲹵�","ChanageApplyType()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��","Delete()",sResourcesPath},
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
	
	function ChanageApplyType()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)	
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}  
		var sCLType =PopPage("/InfoManage/DataInput/AddCreditLineDialog.jsp?","","top=20;dialogWidth=18;dialogHeight=10;resizable=yes;status:no;maximize:yes;help:no;");
		var sParaString = "BusinessType"+","+sCLType+","+"ManageUserID"+","+"<%=CurUser.UserID%>";
		var sCLSerialNo = setObjectValue("SelectCL",sParaString,"",0,0,"");
		var sCLSerialNo = sCLSerialNo.split("@");
		var sCreditAggreement=sCLSerialNo[0];
		sReturn = PopPage("/InfoManage/DataInput/UpdateInputContractAction1.jsp?SerialNo="+sSerialNo+"&BusinessType="+sBusinessType+"&ApplyType=DependentApply&CreditAggreement="+sCreditAggreement,"","");
		reloadSelf();
	}
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������ͬ;InputParam=��;OutPutParam=��;]~*/
	function NewContract()
	{
		sCompID	 = "ReinforceCreation1";
		sCompURL = "/InfoManage/DataInput/ReinforceCreationInfo1.jsp";
		sReturn = popComp(sCompID,sCompURL,"","dialogWidth=50;dialogHeight=25;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		
		if(!(sReturn=="" || sReturn=="_CANCEL_" || typeof(sReturn)=="undefined") )
		{
			sReturn = sReturn.split("@");
			var sObjectNo = sReturn[0];
			openObject("ReinforceContract",sObjectNo,"001");					
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
