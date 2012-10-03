<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: cchang 2004-12-06
		Tester:
		Describe: �ͻ����������ڻ���ҵ��;
		Input Param:
				DealType��
				    03����ɷŴ��ĺ�ͬ
					04����ɷŴ��ĺ�ͬ
		Output Param:
			
		HistoryLog:
			zywei 2007/10/10 �޸�ȡ����ͬ����ʾ��
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ͬ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql1="";
	
	//����������
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("DealType"));

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"CustomerName","�ͻ�����"},
							{"SerialNo","��ͬ��ˮ��"},
							{"OccurTypeName","��������"},
							{"Currency","����"},
							{"BusinessSum","��ͬ���"},
							{"RelativeSum","�ѳ��˽��"},
							{"Balance","���"},
							{"VouchTypeName","��Ҫ������ʽ"},
							{"PutOutDate","��ʼ����"},
							{"Maturity","��������"},
							{"ManageOrgName","�������"},
						  };
	String 	sSql = "";
    String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	if(sDBName.startsWith("INFORMIX"))
	{
		sSql =   " select SerialNo,CustomerID,CustomerName,"+
						" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
						" ArtificialNo,"+
						" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
						" BusinessSum,"+
						" Balance,"+
						" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
						" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
						" PutOutDate,Maturity,"+
						" ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName,FinishDate "+
						" from BUSINESS_CONTRACT "+
						" where ManageUserID = '"+CurUser.UserID+"' "+
						" and BusinessType not like '30%'"+
			 			" and (DeleteFlag = ''  or  DeleteFlag is null) ";
	}
	else if(sDBName.startsWith("ORACLE"))
	{		 					 			
		sSql =   " select SerialNo,CustomerID,CustomerName,"+
						" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
						" ArtificialNo,"+
						" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
						" BusinessSum,"+
						" Balance,"+
						" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
						" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
						" PutOutDate,Maturity,"+
						" ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName,FinishDate "+
						" from BUSINESS_CONTRACT "+
						" where ManageUserID = '"+CurUser.UserID+"' "+
						" and BusinessType not like '30%'"+
			 			" and (DeleteFlag = ''  or  DeleteFlag is null) ";	 			
	}else if(sDBName.startsWith("DB2"))
	{
		sSql =   " select SerialNo,CustomerID,CustomerName,"+
						" BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
						" ArtificialNo,"+
						" BusinessCurrency,getItemName('Currency',BusinessCurrency) as Currency,"+
						" BusinessSum,"+
						" Balance,"+
						" OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
						" VouchType,getItemName('VouchType',VouchType) as VouchTypeName,"+
						" PutOutDate,Maturity,"+
						" ManageOrgID,getOrgName(ManageOrgID) as ManageOrgName,FinishDate "+
						" from BUSINESS_CONTRACT "+
						" where ManageUserID = '"+CurUser.UserID+"' "+
						" and BusinessType not like '30%'"+
			 			" and (DeleteFlag = ''  or  DeleteFlag is null) ";
	}
	if(sDealType.equals("03100"))
	{
		if(sDBName.startsWith("INFORMIX"))
		{
		    sSql1 =" and (PigeonholeDate ='' or PigeonholeDate is null) ";
		}
		else if(sDBName.startsWith("ORACLE")) 
		{
			sSql1 =" and (PigeonholeDate =' ' or PigeonholeDate is null) ";
		}else if(sDBName.startsWith("DB2"))
		{
		    sSql1 =" and (PigeonholeDate ='' or PigeonholeDate is null) ";
		}
	}
	else if(sDealType.equals("03200"))
	{
		
		if(sDBName.startsWith("INFORMIX"))
		{
		    sSql1 =" and (PigeonholeDate !='' and PigeonholeDate is not null) ";
		}
		else if(sDBName.startsWith("ORACLE")) 
		{
			sSql1 =" and (PigeonholeDate !=' ' and PigeonholeDate is not null) ";
		}else if(sDBName.startsWith("DB2"))
		{
		    sSql1 =" and (PigeonholeDate !='' and PigeonholeDate is not null) ";
		}
	}
	sSql = sSql + sSql1 + " order by SerialNo desc ";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable="BUSINESS_CONTRACT";
	doTemp.setKeyFilter("SerialNo");
	
	doTemp.setHeader(sHeaders);
	//���ò��ɼ���
	doTemp.setVisible("ArtificialNo,CustomerID,BusinessType,OccurType,BusinessCurrency,VouchType,ManageOrgID,FinishDate",false);
	if (sDealType.equals("030")) {
		doTemp.setVisible("RelativeSum",false);
	}

	doTemp.setUpdateable("",false);
	doTemp.setAlign("BusinessSum,RelativeSum,Balance","3");
	doTemp.setAlign("Currency,OccurTypeName","2");
	doTemp.setType("BusinessSum,RelativeSum,Balance","Number");
	
	doTemp.setCheckFormat("BusinessSum,RelativeSum,Balance","2");
	//����html��ʽ
	doTemp.setHTMLStyle("Currency,PutOutDate,Maturity,ClassifyResultName"," style={width:80px} ");
	doTemp.setHTMLStyle("ArtificialNo"," style={width:120px} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
    
    doTemp.setFilter(Sqlca,"1","SerialNo","");
    doTemp.setFilter(Sqlca,"2","CustomerName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
	doTemp.setFilter(Sqlca,"3","BusinessSum","");
	doTemp.setFilter(Sqlca,"4","BusinessTypeName","Operators=BeginsWith,EndWith,Contains,EqualsString;");
    
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(10); 	//��������ҳ

	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteBusiness(BusinessContract,#SerialNo,DeleteBusiness)"); 
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//��֯���кϼ��ò��� add by zrli 
	String[][] sListSumHeaders = {	{"BusinessCurrency","����"},
									{"BusinessSum","��ͬ���"},
									{"Balance","���"},
								 };
	String sListSumSql = "Select BusinessCurrency,Sum(BusinessSum) as BusinessSum,Sum(Balance) as Balance "
						+ " From BUSINESS_CONTRACT "
						+ doTemp.WhereClause
						+ " Group By BusinessCurrency";
	CurComp.setAttribute("ListSumHeaders",sListSumHeaders);
	CurComp.setAttribute("ListSumSql",sListSumSql);
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
		{"true","","Button","������ͬ","������ͬ","newRecord()",sResourcesPath},
		{"true","","Button","��ͬ����","��ͬ����","viewTab()",sResourcesPath},
		{"true","","Button","ȡ����ͬ","ȡ����ͬ","cancelContract()",sResourcesPath},
		{"true","","Button","��ͬ�鵵","��ͬ�鵵","archive()",sResourcesPath},
		{"true","","Button","�����ص�����","�����ص��ͬ����","addUserDefine()",sResourcesPath},
		{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
		{"true","","Button","����","������","listSum()",sResourcesPath},
		{"false","","Button","���������������","���������������","newAFRecord()",sResourcesPath}
	};

	if(sDealType.equals("04")||sDealType.equals("03200"))
	{
		sButtons[0][0] ="false";
		sButtons[2][0] ="false";
		sButtons[3][0] ="false";
	}
	
	if(sDealType.equals("03100"))
	{
		sButtons[7][0] ="true";
	}
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
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
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

	/*~[Describe=�����ص��ͬ����;InputParam=��;OutPutParam=��;]~*/
	function addUserDefine()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getBusinessMessage('420'))) //Ҫ�������ͬ��Ϣ�����ص��ͬ��������
		{
			PopPage("/Common/ToolsB/AddUserDefineAction.jsp?ObjectType=BusinessContract&ObjectNo="+sSerialNo,"","");
		}
	}

	/*~[Describe=��ɷŴ�;InputParam=��;OutPutParam=��;]~*/
	function archive(){
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sBalance = getItemValue(0,getRow(),"Balance");
		sFinishDate = getItemValue(0,getRow(),"FinishDate");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(!(sBalance>0 || (sFinishDate.length>0 && typeof(sObjectNo)!="undefined"))){
			alert("������¼���ܹ鵵");
			return;
		}
		if(confirm("�鵵��ĺ�ͬ�������ٷŴ�����ȷ��Ҫ���˺�ͬ�鵵��")) //������뽫�ñʺ�ͬ��Ϊ��ɷŴ���
		{
			sReturn = PopPage("/Common/WorkFlow/AddPigeonholeAction.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"","");
			if(typeof(sReturn)!="undefined" && sReturn!="failed")
				reloadSelf();
			alert(getBusinessMessage('422'));//�ñʺ�ͬ�Ѿ���Ϊ��ɷŴ���
		}
	}

	/*~[Describe=ȡ����ͬ;InputParam=��;OutPutParam=��;]~*/
	function cancelContract()
	{
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		sBusinessType = getItemValue(0,getRow(),"BusinessType");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('70')))//�������ȡ������Ϣ��
		{
		    sReturn = PopPage("/CreditManage/CreditPutOut/CheckContractDelAction.jsp?ObjectNo="+sObjectNo,"","");
	        if (typeof(sReturn)=="undefined" || sReturn.length==0)
	       	{
	       		if(sBusinessType="2110020")
	       		{
	       			sReturn = RunMethod("BusinessManage","DeleteBusiness",sObjectNo+",CreditApply,DeleteTask");
	       		}
	            as_del('myiframe0');
	            as_save('myiframe0');  //�������ɾ������Ҫ���ô����
	        }else if(sReturn == 'Reinforce')
	        {
	            alert(getBusinessMessage('425'));//�ú�ͬΪ���Ǻ�ͬ������ɾ����
	            return;
	        }else if(sReturn == 'Finish')
	        {
	            alert(getBusinessMessage('426'));//�ú�ͬ�Ѿ����ս��ˣ�����ɾ����
	            return;
	        }else if(sReturn == 'Pigeonhole')
	        {
	            alert(getBusinessMessage('427'));//�ú�ͬ�Ѿ���ɷŴ��ˣ�����ɾ����
	            return;
	        }else if(sReturn == 'PutOut')
	        {
	            alert(getBusinessMessage('428'));//�ú�ͬ�Ѿ������ˣ�����ɾ����
	            return;
	        }else if(sReturn == 'Other')
	        {
	            alert(getBusinessMessage('429'));//�ú�ͬ�ܻ���Ϊ������Ա������ɾ����
	            return;
	        }else if(sReturn == 'Use')
	        {
	            alert(getBusinessMessage('430'));//�����Ŷ���ѱ�ռ�ã�����ɾ����
	            return;
	        }
		}
	}
	
	/*~[Describe=������ͬ;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		sParaString = "ObjectType"+","+"CreditApply"+","+"UserID"+","+"<%=CurUser.UserID%>";
		sReturn = setObjectValue("SelectApplyForContract",sParaString,"",0,0,"");		
		if(typeof(sReturn) == "undefined" || sReturn == "" || sReturn == "_NONE_" || sReturn == "_CLEAR_" || sReturn == "_CANCEL_") return;

		var sReturn = sReturn.split("@");
		sObjectNo = sReturn[0];
		sReturn=RunMethod("BusinessManage","InitializeContract","CreditApply,"+sObjectNo+","+"<%=CurUser.UserID%>"+","+"<%=CurOrg.OrgID%>");
	    if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
		alert("��������׼���������ɺ�ͬ�ɹ�����ͬ��ˮ��["+sReturn+"]��\n\r�������д��ͬ��ֹʱ���Ҫ����Ϣ��");
		sObjectType = "BusinessContract";
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sReturn;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}
	 /*~[Describe=������;InputParam=��;OutPutParam=��;]~*/
	function listSum()
	{
		popComp("ListSum","/Common/ToolsA/ListSum.jsp","Column1=222","dialogWidth=40;dialogHeight=20;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
	
	} 
	
	
	/*~[Describe=���������������;InputParam=��;OutPutParam=��;]~*/
	function newAFRecord()
	{
		//����������Ϣ
		sCompID = "AssembleCreationInfo";
		sCompURL = "/CreditManage/CreditPutOut/AssembleCreationInfo.jsp";
		sReturn = popComp(sCompID,sCompURL,"","dialogWidth=35;dialogHeight=15;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if(typeof(sReturn)=="undefined" || sReturn=="" || sReturn=="_CANCEL_") return;
		sReturn = sReturn.split("@");
		sObjectNo=sReturn[0];////������ˮ��
		sAccumulationNo = sReturn[1]; //ί�������
		//ȡ�ñ������Ӧ�����̽׶κ�
		sTradeType = "6020";
		sReturn = RunMethod("BusinessManage","SendGD",sObjectNo+","+"CreditApply"+","+sTradeType);
		sReturn=sReturn.split("@");
		if(sReturn[0] != "0000000")
		{
			alert("����ϵͳ��ʾ��"+sReturn[1]+",������["+sReturn[0]+"]");//���ʧ���״������
			sReturn = RunMethod("BusinessManage","DeleteBusiness",sObjectNo+",CreditApply,DeleteTask");
			return;
		}else{
			alert("���͸����ɹ���"+sReturn[1]);
			sReturn = RunMethod("BusinessManage","UpdateTrade6020",sObjectNo+", ,"+sAccumulationNo);
			if(typeof(sReturn)!="undefined" && sReturn.length!=0)
			{
				alert(sReturn);
			}
			reloadSelf();
		}
		//���ɺ�ͬ��Ϣ
		sReturn=RunMethod("BusinessManage","InitializeContract","CreditApply,"+sObjectNo+","+"<%=CurUser.UserID%>"+","+"<%=CurOrg.OrgID%>");
	    if(typeof(sReturn)=="undefined" || sReturn.length==0) return;
		sObjectType = "BusinessContract";
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType="+sObjectType+"&ObjectNo="+sReturn;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
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