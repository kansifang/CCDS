<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.08      
		Tester:	
		Content: �»��׼�򡪡���˾ҵ��
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��˾ҵ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//��� sql���
	String sCondition = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Condition"));
	if(sCondition==null) sCondition="";
	String sAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	if(sAction==null) sAction="";
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sType==null) sType="";
	String sCondition1 = "";
	String sRightCondi = "";
	String sEqualRightCondi = "";//����Ȩ�������Ĳ�������
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//��ȡ�����ͻ���Ϣ������	
	String sHeaders[][]={
							{"AccountMonth","����·�"},
	                        {"LoanAccount","��ݺ�"},
	                        {"DuebillNo","��ݱ��"},
	                        {"CustomerOrgCode","�ͻ���֯��������"},
	                        {"CustomerOrgCodeName","�ͻ���֯��������"},
	                        {"CustomerID","�ͻ����"},
	                        {"CustomerName","�ͻ�����"},
	                        {"IndustryType","��ҵ����"},
	                        {"Scope","��ҵ��ģ"},
	                        {"PutoutDate","������"},
	                        {"Maturity","������"},
	                        {"RMBBalance","���"},
	                        {"MFiveClassify","�弶����"},
	                        {"MFiveClassifyName","�弶����"},
	                        {"AFiveClassify","����弶����"},
	                        {"AFiveClassifyName","����弶����"},
	                        {"AuditStatFlag","�Ƿ����"},
	                        {"AuditStatFlagName","�Ƿ����"},
	                        {"ManageStatFlag","����ģʽ"},
	                        {"ManageStatFlagName","����ģʽ"},                       
	                        {"Manageuserid","�ܻ���"},
	                        {"ManageuserName","�ܻ���"}
                        };
    sSql = " select AccountMonth,LoanAccount,DuebillNo,CustomerID,CustomerName,PutoutDate,"+
    	   " CustomerOrgCode,getOrgName(CustomerOrgCode) as CustomerOrgCodeName,IndustryType,Scope,"+
    	   " Maturity,RMBBalance,MFiveClassify,getItemName('MFiveClassify',MFiveClassify) as MFiveClassifyName,"+
    	   " AFiveClassify,getItemName('MFiveClassify',AFiveClassify) as AFiveClassifyName,"+
    	   " AuditStatFlag,getItemName('AuditStatFlag',AuditStatFlag) as AuditStatFlagName,ManageStatFlag,getItemName('ManageStatFlag',ManageStatFlag) as ManageStatFlagName,"+
    	   " Manageuserid,getUserName(Manageuserid) as ManageuserName " +
    	   " from Reserve_Total  " +
    	   " where BusinessFlag = '1'";
    
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Total";
    doTemp.setKey("AccountMonth,LoanAccount",true);
    doTemp.setColumnAttribute("AccountMonth,CustomerName,LoanAccount","IsFilter","1");
	//doTemp.setCheckFormat("AccountMonth","6");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//������datawindows����ʾ������
	dwTemp.setPageSize(20); //add by hxd in 2005/02/20 for �ӿ��ٶ�
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "1"; 
		
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
			{"true","","Button","��ֵ׼������","��ֵ׼������","update_Reserve()",sResourcesPath},
			{"true","","Button","ҵ������","ҵ������","viewAndEdit()",sResourcesPath}
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	
	function update_Reserve(){
		if(confirm("ȷ��Ҫ���м�ֵ׼�����ݸ�����")){
			sAccountMonth  = getItemValue(0,getRow(),"AccountMonth");
			sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
			alert(sAccountMonth);
			if (typeof(sAccountMonth)=="undefined" || sAccountMonth.length==0){
				alert("��ѡ��Ҫ���µĻ���·�");//��ѡ��
				return;
			}
			sGrade = PopComp("GradeSelect","/BusinessManage/ReserveManage/GradeSelect.jsp","rand="+randomNumber()," ","dialogWidth=35;dialogHeight=18;center:yes;status:no;statusbar:no");
			if (typeof(sGrade)=="undefined" || sGrade.length==0){
				alert("��ѡ��Ԥ���ֽ�������");//��ѡ��
				return;
			}
			sReturn = PopComp("PrepareAction","/BusinessManage/ReserveManage/PrepareAction.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount+"&UpdateFlag=2&Grade="+sGrade+"&rand="+randomNumber()," ","dialogWidth=20;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;close:no");			
			if(sReturn == "00"){
				alert("���ݸ��³ɹ���");
			}
			else{
				alert("���ݸ���ʧ�ܣ�");
			}
			reloadSelf();
		}		
	}
	
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSubjectNo = getItemValue(0,getRow(),"SubjectNo");
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		if (typeof(sSubjectNo) == "undefined" || sSubjectNo.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		
		var sReturn = PopComp("ReserveDataInfo","/BusinessManage/ReserveDataPrepare/ReserveDataInfo.jsp","AccountMonth="+sAccountMonth+"&AssetNo="+sAssetNo,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
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