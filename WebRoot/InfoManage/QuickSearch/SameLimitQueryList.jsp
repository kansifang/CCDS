<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zwhu 2009-08-30
		Tester:
		Describe: ��ˮ̨���б�;
		Input Param:

		Output Param:
			
		HistoryLog:

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
							{"LineID","��ȱ��"},							
							{"ApproveSerialNo","���������"},
							{"BusinessType","ҵ��Ʒ��"},
							{"BusinessTypeName","ҵ��Ʒ��"},
							{"Currency","����"},
							{"LineSum1","���"},
							{"FreezeFlag","״̬"},										
							{"FreezeFlagName","״̬"},										
							{"LineEffDate","ʹ������"},
							{"PutOutDeadLine","��ֹ����"},										
							{"InputUser","������"},
							{"InputOrg","�������"}
							}; 
	sSql =	" select CI.LineID,CI.ApproveSerialNo,CI.BusinessType,getBusinessName(CI.BusinessType) as BusinessTypeName , "+ 
			" getItemName('Currency',CI.Currency) as Currency,CI.LineSum1,"+
			" FreezeFlag,getItemName('FreezeFlag',CI.FreezeFlag) as FreezeFlagName ,CI.LineEffDate,CI.PutOutDeadLine, "+
			" getUserName(CI.InputUser) as InputUser ,getOrgName(CI.InputOrg) as InputOrg "+
			" from CL_INFO CI,ENT_INFO EI "+
			" WHERE CI.CustomerID = EI.CustomerID and EI.OrgNature like '07%' "+
			" and CI.InputOrg in (select OrgID from ORG_INFO where SortNo like '" +CurOrg.SortNo+"%') ";	
	
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("LineID");
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);	
	//���ùؼ���
	doTemp.setKey("LineID",true);	
	//���ö��뷽ʽ
	doTemp.setAlign("LineSum1","3");	
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("LineSum1","2");	
	doTemp.setCheckFormat("LineEffDate,PutOutDeadLine","3");
	doTemp.setType("LineSum1","Number");
	doTemp.setVisible("LineID,BusinessType,FreezeFlag",false);
	doTemp.setDDDWSql("FreezeFlag","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'FreezeFlag'");
	doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE ");
	doTemp.setHTMLStyle("InputOrg","style={width:250px} ");  	
	//���ɲ�ѯ��
	doTemp.setFilter(Sqlca,"1","ApproveSerialNo","");
	doTemp.setFilter(Sqlca,"2","BusinessType","");	
	doTemp.setFilter(Sqlca,"3","LineEffDate","");
	doTemp.setFilter(Sqlca,"4","PutOutDeadLine","");
	doTemp.setFilter(Sqlca,"5","InputUser","");
	doTemp.setFilter(Sqlca,"6","InputOrg","");
	doTemp.setFilter(Sqlca,"7","FreezeFlag","");
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
		{"true","","Button","����EXCEL","����EXCEL","exportAll()",sResourcesPath},
	};
	
	if(CurUser.hasRole("095")||CurUser.hasRole("0A2")||CurUser.hasRole("0B5")||CurUser.hasRole("0C2")||
	 CurUser.hasRole("0D2")||CurUser.hasRole("0E9")||CurUser.hasRole("0F4")||CurUser.hasRole("0H5")||
	 CurUser.hasRole("0I4")||CurUser.hasRole("0J1")||CurUser.hasRole("282")||CurUser.hasRole("295")||
	 CurUser.hasRole("2A4")||CurUser.hasRole("2B9")||CurUser.hasRole("2C2")||CurUser.hasRole("2D4")||
	 CurUser.hasRole("2E4")||CurUser.hasRole("2G5")||CurUser.hasRole("2H5")||CurUser.hasRole("2I2")||
	 CurUser.hasRole("421")||CurUser.hasRole("495"))
	{
		sButtons[1][0] = "false";
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
		sLineID =getItemValue(0,getRow(),"LineID");	
		if (typeof(sLineID)=="undefined" || sLineID.length==0)
		{
			alert(getHtmlMessage(1));  //��ѡ��һ����¼��
			return;
		}else
		{
			popComp("SameLimitQueryInfo","/InfoManage/QuickSearch/SameLimitQueryInfo.jsp","ComponentName=ͬҵ�ͻ������ϸ��Ϣ&LineID="+sLineID,"","");		
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
