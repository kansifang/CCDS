<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2011/05/13
		Tester:
		Content: ������Ϣ�б�
		Input Param:
					
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql���
	String sComponentName = "";//--�������
	String sType="";
	String PG_CONTENT_TITLE = "";
	//����������	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//���ҳ�����	
	sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));	//���ҳ�����	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"ObjectNo","������ˮ��"},
							{"CustomerID","�ͻ����"},
							{"CustomerName","�ͻ�����"},										
							{"BusinessTypeName","ҵ��Ʒ��"},		
							{"OccurTypeName","��������"},								
							{"BusinessSum","��Ԫ��"},								
							{"CurrencyName","����"},
							{"PhaseNo","��ǰ�׶κ�"},
							{"PhaseName","��ǰ�׶�"},
							{"OperateUserName","������"},
							{"OperateOrgName","�������"},
							{"ApproveUserID","����������"},
							{"ApproveOrgID","�������"},
							{"ApproveDate","��������"}
							}; 
	
	sSql =	" select FLOW_OBJECT.ObjectType as ObjectType,FLOW_OBJECT.ObjectNo as ObjectNo,"+
			"BUSINESS_APPLY.CustomerID as CustomerID,BUSINESS_APPLY.CustomerName as CustomerName,"+
			"BUSINESS_APPLY.BusinessType as BusinessType,getBusinessName(BusinessType) as BusinessTypeName,"+
			"BUSINESS_APPLY.OccurType as OccurType,getItemName('OccurType',OccurType) as OccurTypeName,"+
			"getItemName('Currency',BusinessCurrency) as CurrencyName,"+
			"BUSINESS_APPLY.BusinessSum as BusinessSum,"+
			"BUSINESS_APPLY.CreditAggreement as CreditAggreement,FLOW_OBJECT.UserName as OperateUserName,"+
			"FLOW_OBJECT.OrgName as OperateOrgName,FLOW_OBJECT.PhaseType as PhaseType,"+
			"FLOW_OBJECT.ApplyType as ApplyType,FLOW_OBJECT.FlowNo as FlowNo,FLOW_OBJECT.FlowName as FlowName,"+
			"FLOW_OBJECT.PhaseNo as PhaseNo,FLOW_OBJECT.PhaseName as PhaseName, "+
			"getUserName(BUSINESS_APPLY.ApproveUserID) as ApproveUserID,getOrgName(BUSINESS_APPLY.ApproveOrgID) as ApproveOrgID,BUSINESS_APPLY.ApproveDate as ApproveDate "+
			"from FLOW_OBJECT ,BUSINESS_APPLY "+
			"where FLOW_OBJECT.ObjectType =  'CreditApproveApply'  and  FLOW_OBJECT.ObjectNo = BUSINESS_APPLY.SerialNo "+
			"and BUSINESS_APPLY.PigeonholeDate is null "+
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
	doTemp.setHTMLStyle("BusinessRate","style={width:60px} "); 		
	//���ö��뷽ʽ
	doTemp.setAlign("BusinessSum,BusinessRate,","3");	
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("BusinessSum","2");	
	doTemp.setType("BusinessSum,BusinessRate,Balance,TermMonth","Number");
	doTemp.setVisible("ObjectType,BusinessType,OccurType,CreditAggreement,PhaseType,ApplyType,FlowNo,FlowName",false);
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","ObjectNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");	
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
		{"true","","Button","��ʼ������","��ʼ��������������","initApply()",sResourcesPath},
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------

	/*~[Describe=��ʼ������;InputParam=��;OutPutParam=SerialNo;]~*/
	function initApply()
	{
		//���ҵ����ˮ��
		sObjectNo =getItemValue(0,getRow(),"ObjectNo");	
		sPhaseName =getItemValue(0,getRow(),"PhaseName");
		sCustomerName =getItemValue(0,getRow(),"CustomerName");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			sReturn = RunMethod("WorkFlowEngine","CheckBAP",sObjectNo);
			if(sReturn>0){
				alert("��ҵ���ѵǼǺ�ͬ�����ܽ��г�ʼ��������");
				return;
			}
			if(confirm("��ȷ��Ҫ��["+sCustomerName+"]�ĵ�ǰ�׶���Ϊ["+sPhaseName+"]������["+sObjectNo+"]��ʼ���������˽׶���")){
				sRetValue = PopPage("/SystemManage/SynthesisManage/InitCreditApproveAction.jsp?SerialNo="+sObjectNo+"&rand=" + randomNumber(),"","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if(sRetValue=='00'){
					alert("��ʼ���ɹ���");
					reloadSelf();
				}else{
					alert("��ʼ��ʧ�ܣ�");
				}
			}
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
