<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong  2012/02/21
		Tester:
		Describe: ��ӡԤ��������б�
		Input Param:	
			
		Output Param:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ӡԤ��������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//--���sql
	String sComponentName = "";//--�������
	String PG_CONTENT_TITLE = "��ӡԤ��������б�";//--��ͷ
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
							{"SerialNo","Ԥ���ź���ˮ��"},
							{"CustomerName","�ͻ�����"},
							{"SignalType","Ԥ������"},
							{"SignalLevel","Ԥ������"},	
							{"SignalStatus","Ԥ��״̬"},
							{"CustomerOpenBalance","���ڽ��"},									
							{"OperateUserName","�Ǽ���"},
							{"OperateOrgName","�Ǽǻ���"},
							}; 
						
		sSql =	" select RS.SerialNo as SerialNo,"+
				" GetCustomerName(RS.ObjectNo) as CustomerName,"+
				" getItemName('SignalType',RS.SignalType) as SignalType,"+
				" getItemName('SignalLevel',RS.SignalLevel) as SignalLevel,"+
				" getItemName('SignalStatus',RS.SignalStatus) as SignalStatus,"+
				" RS.CustomerOpenBalance as CustomerOpenBalance,"+
				" getUserName(RS.InputUserID) as OperateUserName,"+
				" getOrgName(RS.InputOrgID) as OperateOrgName "+
			" from FLOW_OBJECT FO,RISK_SIGNAL RS "+
			" where  FO.ObjectType =  'RiskSignalApply' "+
				" and  FO.ObjectNo = RS.SerialNo and FO.PhaseType='1040' "+
				" and FO.ApplyType='RiskSignalApply' and RS.SignalType='01' "+
				" and RS.InputOrgID in (select OrgID from ORG_Info where SortNo like '"+CurOrg.SortNo+"%') ";
		if(CurUser.hasRole("089")) sSql +="and exists(select 1 from flow_task ft1,flow_task ft2 where ft1.SerialNo=ft2.RelativeSerialNo and ft1.ObjectNo=RS.Serialno and  ft1.ApplyType='RiskSignalApply' and ft2.phaseNo='1000' and ft1.orgid='9900' )";
		if(CurUser.hasRole("08A")) sSql +="and RS.InputUserID in (select userid from user_role where roleid='080')";
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("SerialNo");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "RISK_SIGNAL";	
	//���ùؼ���
	doTemp.setKey("SerialNo",true);
	//������ʾ�ı���ĳ��ȼ��¼�����
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	doTemp.setHTMLStyle("OperateOrgName","style={width:250px} "); 	
	//���ö��뷽ʽ
	doTemp.setAlign("CustomerOpenBalance","3");
	doTemp.setType("CustomerOpenBalance","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("CustomerOpenBalance","2");
	

	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");
	doTemp.setFilter(Sqlca,"3","OperateUserName","");
	doTemp.setFilter(Sqlca,"4","OperateOrgName","");
	
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
		{"true","","Button","Ԥ������","�鿴Ԥ������","viewAndEdit()",sResourcesPath},
		{"true","","Button","�鿴Ԥ������������","�鿴Ԥ������������","checkManulReport()",sResourcesPath}
	};
	
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------


	/*~[Describe=�鿴Ԥ������������;InputParam=��;OutPutParam=��;]~*/
	function checkManulReport()
	{
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectType = "RiskSignal";
		if (typeof(sObjectNo) == "undefined" || sObjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
	    var sSerialNo = RunMethod("BusinessManage","GetInspectNo",sObjectNo+",RiskSignal");
	    
	    if (typeof(sSerialNo)!="undefined" && sSerialNo.length!=0 && sSerialNo != "Null")
		{
			sCompID = "PurposeInspectTab";
		    sCompURL = "/CreditManage/CreditCheck/PurposeInspectTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&viewOnly=true";
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
			
			return;
		}else{
			alert("δ��дԤ������������!");
		}
	}
    
    /*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}
		//���������������ˮ�ţ��������������
		
		sCompID = "CreditTab";
		sCompURL = "/CreditManage/CreditApply/ObjectTab.jsp";
		sParamString = "ObjectType=RiskSignalApply&ObjectNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
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
