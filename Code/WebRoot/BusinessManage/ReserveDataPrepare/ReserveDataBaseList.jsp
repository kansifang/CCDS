<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.12      
		Tester:	
		Content: �»��׼�򡪡���˾ҵ��_��ֵ׼��Ԥ��
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ֵ׼��Ԥ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>

<%
	//�������
	String sSql = "";//��� sql���

	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sType == null) sType = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//��ȡ�����ͻ���Ϣ������	
	String sHeaders[][] = {
				 {"SerialNo","���"},
	             {"AccountMonth","����·�"},
				 {"LoanAccount","��ݺ�"},
				 {"ObjectNo","��ݺ�"},
				 {"Statorgid","�����������"},
				 {"StatOrgName","�����������"},
				 {"CustomerName","�ͻ�����"},
				 {"BusinessSum","������"},
				 {"Balance","�������"},
				 {"PutoutDate","������"},
				 {"MaturityDate","������"},
				 {"AuditRate","ʵ�����ʣ��룩"},
				 {"VouchType","��Ҫ������ʽ"},
				 {"VouchTypeName","��Ҫ������ʽ"},
				 {"MClassifyResultName","�弶����"},
				 {"MClassifyResult","�弶����"},
				 {"AClassifyResultName","����弶����"},
				 {"AClassifyResult","����弶����"},
				 {"Result1","�ܻ�Ա������"},
				 {"Result2","֧��Ԥ����"},
				 {"Result3","����Ԥ����"},
				 {"Result4","�����϶����"},
				 {"MResult","���������϶����"},
				 {"AResult","����϶����"}
			};
	String sSql1 = "";
	String sSql2 = "";
	if("Ent".equals(sType))
	{
		 sSql1 = "select  SerialNo, LoanAccount, AccountMonth, getorgname(Statorgid) as StatOrgName, ObjectNo, CustomerName,BusinessSum, Balance," + 
	       		" getItemName('MFiveClassify', MClassifyResult) as MClassifyResultName,MClassifyResult, "+
	       		" getItemName('MFiveClassify', AClassifyResult) as AClassifyResultName,AClassifyResult, "+
	       		" PutoutDate,MaturityDate,getItemName('VouchType', RR.VouchType) as VouchTypeName, "+
	       		" Result1, Result2, Result3, Result4, MResult, AResult " +
	       		" from Reserve_Record RR where RR.BusinessFlag = '1' ";
    	 sSql2 = " union select 'unInput' as SerialNo, RT.LoanAccount as LoanAccount, RT.AccountMonth as AccountMonth, getorgname(RT.Statorgid) as StatOrgName, RT.DuebillNo as ObjectNo, RT.CustomerName as CustomerName, RT.BusinessSum as BusinessSum , RT.Balance as Balance, " + 
                        " getItemName('MFiveClassify', RT.MFiveClassify) as MClassifyResultName, RT.MFiveClassify as MClassifyResult, " +
                        " getItemName('MFiveClassify', RT.AFiveClassify) as AClassifyResultName, RT.AFiveClassify as AClassifyResult, " +
	                    " RT.PutoutDate as PutoutDate,RT.Maturity as MaturityDate,getItemName('VouchType', RT.VouchType) as VouchTypeName , " + 
	                    " '' as Result1, '' as Result2, '' as Result3, '' as Result4, '' as MResult, '' as AResult from Reserve_Total RT " + 
	                    " where not exists (select * from Reserve_Record RR where RR.LoanAccount = RT.LoanAccount and RR.AccountMonth = RT.AccountMonth) "+
	                    " and RT.ManageStatFlag = '2' " + //2-��ʼ���
	                    " and RT.BusinessFlag = '1' " ;
	}else if("Ind".equals(sType))
	{
		 sSql1 = "select  SerialNo, LoanAccount, AccountMonth, getorgname(Statorgid) as StatOrgName, ObjectNo, CustomerName,BusinessSum, Balance," + 
	       		" getItemName('MFiveClassify', MClassifyResult) as MClassifyResultName,MClassifyResult, "+
	       		" getItemName('MFiveClassify', AClassifyResult) as AClassifyResultName,AClassifyResult, "+
	       		" PutoutDate,MaturityDate,getItemName('VouchType', RR.VouchType) as VouchTypeName, "+
	       		" Result1, Result2, Result3, Result4, MResult, AResult " +
	       		" from Reserve_Record RR where RR.BusinessFlag = '2' ";
    	 sSql2 = " union select 'unInput' as SerialNo, RT.LoanAccount as LoanAccount, RT.AccountMonth as AccountMonth, getorgname(RT.Statorgid) as StatOrgName, RT.DuebillNo as ObjectNo, RT.CustomerName as CustomerName, RT.BusinessSum as BusinessSum , RT.Balance as Balance, " + 
                        " getItemName('MFiveClassify', RT.MFiveClassify) as MClassifyResultName, RT.MFiveClassify as MClassifyResult, " +
                        " getItemName('MFiveClassify', RT.AFiveClassify) as AClassifyResultName, RT.AFiveClassify as AClassifyResult, " +
	                    " RT.PutoutDate as PutoutDate,RT.Maturity as MaturityDate,getItemName('VouchType', RT.VouchType) as VouchTypeName , " + 
	                    " '' as Result1, '' as Result2, '' as Result3, '' as Result4, '' as MResult, '' as AResult from Reserve_Total RT " + 
	                    " where not exists (select * from Reserve_Record RR where RR.LoanAccount = RT.LoanAccount and RR.AccountMonth = RT.AccountMonth) "+
	                    " and RT.ManageStatFlag = '2' " + //2-��ʼ���
	                    " and RT.BusinessFlag = '2' " ;
	}
	sSql = sSql1 + sSql2;
	ASDataObject doTemp = new ASDataObject(sSql);
	String sTemp = doTemp.WhereClause;
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Record,Reserve_Total";
    doTemp.setKey("SerialNo,AccountMonth,LoanAccount",true);
    doTemp.setColumnAttribute("AccountMonth,CustomerName,LoanAccount","IsFilter","1");
    //doTemp.setCheckFormat("AccountMonth","6");
    doTemp.setHTMLStyle("LoanAccount","style={width:150px}");
    //add by jjwang 2009.01.07  ����С��λ�������ݸ�ʽ����λһ����
	doTemp.setCheckFormat("BusinessSum,Balance,Result1,Result2,Result3,Result4,AResult","2");
	//end by jjwang 2009.01.07
    doTemp.setHTMLStyle("Result1,Result2,Result3,Result4,AResult","style={width:100px}");
    doTemp.setHTMLStyle("AccountMonth,PutoutDate,MaturityDate,MClassifyResultName,AClassifyResultName","style={width:80px}");
	doTemp.setVisible("SerialNo,ObjectNo,MClassifyResult,AClassifyResult,PutoutDate,MaturityDate,VouchTypeName,StatOrgName,MResult",false);
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
    
	//����datawindows
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);	
	if(doTemp.haveReceivedFilterCriteria()){
	        sSql1 += doTemp.WhereClause.substring(sTemp.length());
	        sSql2 += doTemp.WhereClause.substring(sTemp.length());
	        String sSql3= sSql1 +sSql2;
	        doTemp = null;
	        dwTemp = null;
	        doTemp = new ASDataObject(sSql3);
	     	doTemp.setHeader(sHeaders);
			doTemp.UpdateTable="Reserve_Record,Reserve_Total";
			doTemp.setKey("SerialNo,AccountMonth,LoanAccount",true);
			doTemp.setColumnAttribute("AccountMonth,CustomerName,LoanAccount","IsFilter","1");
			doTemp.setCheckFormat("AccountMonth","6");
			doTemp.setHTMLStyle("LoanAccount","style={width:150px}");
			//add by jjwang 2009.01.07  ����С��λ�������ݸ�ʽ����λһ����
			doTemp.setCheckFormat("BusinessSum,Balance,Result1,Result2,Result3,Result4,AResult","2");
			//end by jjwang 2009.01.07
			doTemp.setHTMLStyle("Result1,Result2,Result3,Result4,AResult","style={width:100px}");
			doTemp.setHTMLStyle("AccountMonth,PutoutDate,MaturityDate,MClassifyResultName,AClassifyResultName","style={width:80px}");
			doTemp.setVisible("SerialNo,ObjectNo,MClassifyResult,AClassifyResult,PutoutDate,MaturityDate,VouchTypeName,StatOrgName,MResult",false);
			doTemp.generateFilters(Sqlca);
			doTemp.parseFilterData(request,iPostChange);
			doTemp.multiSelectionEnabled = false;
			CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
			dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	}

	//������datawindows����ʾ������
	dwTemp.setPageSize(20); 
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "1";  
	//out.println(doTemp.SourceSql);
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("LoanAccount");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	//out.println(doTemp.SourceSql); //����datawindow��Sql���÷���
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
		//6.��ԴͼƬ·��{"true","","Button","�ܻ�Ȩת��","�ܻ�Ȩת��","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{"true","","Button","ҵ������","ҵ������","viewAndEdit()",sResourcesPath},
			{"true","","Button","����Excel","����Excel","exportAll()",sResourcesPath}
	};

	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("ReserveDataEntInfo","/BusinessManage/ReserveDataPrepare/ReserveDataEntInfo.jsp","LoanAccount="+sLoanAccount+"&AccountMonth="+sAccountMonth,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
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