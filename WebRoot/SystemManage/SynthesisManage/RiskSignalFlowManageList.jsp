<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   xhyong 2012/02/17
		Tester:
		Content: Ԥ�������б���Ϣ
		Input Param:
					
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ�������б���Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
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
							{"CustomerName","�ͻ�����"},
							{"SignalTypeName","Ԥ������"},
							{"SignalLevelName","Ԥ������"},
							{"SignalStatusName","Ԥ��״̬"},		
							{"CustomerOpenBalance","���ڽ��"},
							{"PhaseNo","��ǰ�׶κ�"},
							{"PhaseName","��ǰ�׶�"},
							{"OperateUserName","������"},
							{"OperateOrgName","�������"},
							{"ApproveUserID","����������"},
							{"ApproveOrgID","�������"},
							{"ApproveDate","��������"}
							}; 
	
	sSql =	" select FO.ObjectType as ObjectType,FO.ObjectNo as ObjectNo,"+
			"getCustomerName(RS.ObjectNo) as CustomerName,"+
			"getItemName('SignalType',RS.SignalType) as SignalTypeName,"+
			"getItemName('SignalLevel',RS.SignalLevel) as SignalLevelName,"+
	        "getItemName('SignalStatus',RS.SignalStatus) as SignalStatusName,"+
	        "RS.CustomerOpenBalance as CustomerOpenBalance,"+
			"FO.UserName as OperateUserName,"+
			"FO.OrgName as OperateOrgName,FO.PhaseType as PhaseType,"+
			"FO.ApplyType as ApplyType,FO.FlowNo as FlowNo,FO.FlowName as FlowName,"+
			"FO.PhaseNo as PhaseNo,FO.PhaseName as PhaseName "+
			"from FLOW_OBJECT FO,RISK_SIGNAL RS "+
			"where FO.ObjectType =  'RiskSignalApply'  and  FO.ObjectNo = RS.SerialNo "+
			" and RS.InputOrgID in (select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	
	sSql += "order by FO.ObjectNo desc";
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    //doTemp.setKeyFilter("ObjectNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	//���ö��뷽ʽ
	doTemp.setAlign("CustomerOpenBalance","3");	
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("CustomerOpenBalance","2");	
	doTemp.setType("CustomerOpenBalance","Number");
	doTemp.setVisible("ObjectType,PhaseType,ApplyType,FlowNo,FlowName",false);
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
		{"true","","Button","��ʼ��Ԥ��","��ʼ��Ԥ����������","initApply()",sResourcesPath},
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
			if(confirm("��ȷ��Ҫ��["+sCustomerName+"]�ĵ�ǰ�׶���Ϊ["+sPhaseName+"]������["+sObjectNo+"]��ʼ���������˽׶���")){
				sRetValue = PopPage("/SystemManage/SynthesisManage/InitRiskSignalAction.jsp?SerialNo="+sObjectNo+"&rand=" + randomNumber(),"","dialogWidth=24;dialogHeight=20;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if(sRetValue=='00'){
					alert("��ʼ���ɹ���");
					reloadSelf();
				}else if(sRetValue=='99')
				{
					alert("��ʼ��ʧ�ܣ�");
				}else
				{
					alert(sRetValue);
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
