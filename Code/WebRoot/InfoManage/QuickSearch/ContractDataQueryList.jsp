<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  bqliu 2011-5-9
		Tester:
		Content: ����̨�˿��ٲ�ѯ
		Input Param:
					���в�����Ϊ�����������
					ComponentName	������ƣ�
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����̨�˿��ٲ�ѯ"; // ��������ڱ��� <title> PG_TITLE </title>
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
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";
	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = {
							{"ObjectNo","������ˮ��"},
							{"CustomerName","�ͻ�����"},							
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"OccurTypeName","��������"},													
							{"CurrencyName","����"},
							{"BusinessSum","������"},
							{"BusinessSum2","������׼���"},
							{"PhaseName","����״̬"},
							{"BailRatio","��֤�����%"},
							{"VouchType","��Ҫ������ʽ"},
							{"FlowName","��������"},
							{"OperateUserName","������"},
							{"OperateOrgName","�������"},
							{"ApproveUserID","����������"},
							{"ApproveOrgID","�������"},
							{"ApproveDate","����ʱ��"}
						  };
    /*
	sSql =	" select FLOW_OBJECT.ObjectType as ObjectType,FLOW_OBJECT.ObjectNo as ObjectNo,"+
			"BUSINESS_APPLY.CustomerID as CustomerID,BUSINESS_APPLY.CustomerName as CustomerName,"+
			"BUSINESS_APPLY.BusinessType as BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
			"BUSINESS_APPLY.OccurType as OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
			"getItemName('Currency',BusinessCurrency) as CurrencyName,"+
			"BUSINESS_APPLY.BusinessSum as BusinessSum,GetBusinessSum2(FLOW_OBJECT.ObjectNo) as BusinessSum2,"+
			"FLOW_OBJECT.PhaseName as PhaseName,BUSINESS_APPLY.BailRatio as BailRatio,"+
			"getItemName('VouchType',BUSINESS_APPLY.VouchType) as VouchType,FLOW_OBJECT.FlowName as FlowName,"+
			"FLOW_OBJECT.UserName as OperateUserName,FLOW_OBJECT.OrgName as OperateOrgName,"+
			"getUserName(BUSINESS_APPLY.ApproveUserID) as ApproveUserID,getOrgName(BUSINESS_APPLY.ApproveOrgID) as ApproveOrgID,BUSINESS_APPLY.ApproveDate as ApproveDate "+
			"from FLOW_OBJECT ,BUSINESS_APPLY "+
			"where FLOW_OBJECT.ObjectType =  'CreditApply'  and  FLOW_OBJECT.ObjectNo = BUSINESS_APPLY.SerialNo "+
			"and FLOW_OBJECT.ApplyType in ('IndependentApply','CreditLineApply','DependentApply','LowRiskApply') "+
			"and BUSINESS_APPLY.PigeonholeDate is null "+
			" and BUSINESS_APPLY.InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
    */
	sSql =	" select BUSINESS_CONTRACT.SerialNo as SerialNo,FLOW_OBJECT.ObjectType as ObjectType,FLOW_OBJECT.ObjectNo as ObjectNo,"+
			"BUSINESS_CONTRACT.CustomerID as CustomerID,BUSINESS_CONTRACT.CustomerName as CustomerName,"+
			"getBusinessName(BUSINESS_CONTRACT.BusinessType) as BusinessTypeName,"+
			"getItemName('OccurType',BUSINESS_CONTRACT.OccurType) as OccurTypeName,"+
			"getItemName('Currency',BUSINESS_CONTRACT.BusinessCurrency) as CurrencyName,"+
			"BUSINESS_APPLY.BusinessSum as BusinessSum,BUSINESS_CONTRACT.BusinessSum as BusinessSum2, "+
			"FLOW_OBJECT.PhaseName as PhaseName,BUSINESS_CONTRACT.BailRatio as BailRatio,"+
			"getItemName('VouchType',BUSINESS_CONTRACT.VouchType) as VouchType,FLOW_OBJECT.FlowName as FlowName,"+
			"getUserName(BUSINESS_CONTRACT.OPERATEUSERID) as OperateUserName,getOrgName(BUSINESS_CONTRACT.OPERATEORGID) as OperateOrgName,"+
			"getUserName(BUSINESS_APPLY.ApproveUserID) as ApproveUserID,getOrgName(BUSINESS_APPLY.ApproveOrgID) as ApproveOrgID,BUSINESS_APPLY.ApproveDate as ApproveDate "+
			"from FLOW_OBJECT ,BUSINESS_CONTRACT,BUSINESS_APPLY "+
			"where FLOW_OBJECT.ObjectType =  'CreditApply'  and FLOW_OBJECT.ObjectNo=BUSINESS_APPLY.SerialNo and  BUSINESS_APPLY.SerialNo= BUSINESS_CONTRACT.RELATIVESERIALNO "+
			"and FLOW_OBJECT.ApplyType in ('IndependentApply','CreditLineApply','DependentApply','LowRiskApply') "+
			"and BUSINESS_CONTRACT.BusinessType not like '3%' "+
			" and BUSINESS_APPLY.InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
			
	//�����ֱ��֧�й���Ա
	if(CurUser.hasRole("0M2"))
	{
		sSql += " AND BUSINESS_APPLY.InputOrgID in(select OrgID from ORG_INFO where OrgLevel='3' and OrgFlag='030') ";
	}
	//����ҵ������ϵͳ����Ա
	if(CurUser.hasRole("0J2"))
	{
		sSql += " AND exists(select 1 from user_role where UserID=BUSINESS_APPLY.InputUserID and roleid in('080'))  ";
	}
	sSql += "order by FLOW_OBJECT.ObjectNo desc";
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("ObjectNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	doTemp.setKey("CustomerID",true);	
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum","3");	
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum,BusinessSum2,BailRatio","2");
	doTemp.setCheckFormat("ApproveDate","3");
	doTemp.setType("BusinessSum,BusinessSum2,Balance","Number");
	doTemp.setVisible("SerialNo,CustomerID,ObjectType,BusinessType,OccurType",false);
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","ObjectNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");	
	doTemp.setFilter(Sqlca,"3","PhaseName","");	
	doTemp.setFilter(Sqlca,"4","ApproveDate","");
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
		{"true","","Button","��ϸ��Ϣ","��ϸ��Ϣ","viewAndEdit2()",sResourcesPath},
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
		sSerialNo =getItemValue(0,getRow(),"ObjectNo");	
	
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			openObject("CreditApply",sSerialNo,"002");
		}
	}	
    
    function viewAndEdit2()
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