<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<% 
	/*
		Author: jbye  2004-12-16 20:15
		Tester:
		Describe: ��ʾ�ͻ���صĲ��񱨱�
		Input Param:
			CustomerID�� ��ǰ�ͻ����
		Output Param:
			CustomerID�� ��ǰ�ͻ����
		HistoryLog:
			DATE	CHANGER		CONTENT
			2005-7-24	fbkang	ҳ�����
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ����񱨱���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
     String sCustomerID = "";//--�ͻ�����
     String sSql = "";//--���sql���
	//���ҳ�����

	//�������������ͻ�����
	sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
							{"CustomerID","�ͻ���"},
							{"RecordNo","��¼��"},
							{"ReportDate","�����������"},
							{"ReportScopeName","����ھ�"},
							{"ReportPeriodName","��������"},
							{"ReportCurrencyName","�������"},
							{"ReportUnitName","����λ"},
							{"ReportStatus","����״̬"},
							{"ReportFlag","�������־"},
							{"ReportOpinion","����ע��"},
							{"AuditFlag","��Ʊ�־"},
							{"AuditOffice","��Ƶ�λ"},
							{"AuditOpinion","������"},							
							{"InputDate","�Ǽ�����"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"},
							{"UpdateDate","�޸�����"},
							{"Remark","��ע"}
						  };
	
	sSql =  " select distinct CF.CustomerID,CF.RecordNo,CF.ReportDate," +
			" CF.ReportScope,CF.ReportPeriod,CF.ReportCurrency,CF.ReportUnit,"+
			" getItemName('ReportScope',CF.ReportScope) as ReportScopeName,"+
			" getItemName('ReportPeriod',CF.ReportPeriod) as ReportPeriodName,"+
			" getItemName('Currency',CF.ReportCurrency) as ReportCurrencyName,"+
			" getItemName('ReportUnit',CF.ReportUnit) as ReportUnitName,"+
			" getUserName(CF.UserID) as UserName,"+
			" getOrgName(CF.OrgID) as OrgName,"+
			" CF.ReportStatus,CF.ReportFlag,CF.ReportOpinion,CF.AuditFlag,CF.AuditOffice,CF.AuditOpinion,"+
			" CF.InputDate,CF.OrgID,CF.UserID,CF.UpdateDate,CF.Remark "+
			" from CUSTOMER_FSRECORD CF "+
			" where CF.CustomerID='"+sCustomerID+"' "+
			" order by CF.ReportDate DESC ";
			
	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_FSRECORD";
	doTemp.setKey("RecordNo",true);	
	
	//���ò��ɼ���	
	doTemp.setVisible("ReportScope,ReportPeriod,ReportCurrency,ReportUnit",false);
	doTemp.setVisible("CustomerID,RecordNo,OrgID,UserID,Remark",false);
		
	//�����Ϣ��ʱ���أ���Ҫʱ�ڽ��м��
	doTemp.setCheckFormat("UpdateDate,InputDate","3");
	doTemp.setVisible("AuditFlag,AuditOffice,AuditOpinion",false);
	doTemp.setVisible("ReportStatus,ReportOpinion,ReportFlag",false);
	doTemp.appendHTMLStyle("ReportScopeName,ReportPeriodName,ReportCurrencyName,ReportUnitName,UserName"," style={width=55px} ");
	doTemp.appendHTMLStyle("InputDate,UpdateDate"," style={width=70px} ");
	doTemp.setAlign("ReportScopeName,ReportPeriodName,ReportCurrencyName,ReportUnitName","2");
    doTemp.setHTMLStyle("OrgName","style={width:250px}"); 	
	//���ɹ�����
	doTemp.setColumnAttribute("ReportDate","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	dwTemp.setPageSize(20);
	//ɾ����ز��񱨱���Ϣ
	dwTemp.setEvent("AfterDelete","!BusinessManage.InitFinanceReport(CustomerFS,#CustomerID,#ReportDate,#ReportScope,,,Delete,,)");
	
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
		{"true","","Button","��������","�����ͻ�һ�ڲ��񱨱�","AddNewFS()",sResourcesPath},
		{"true","","Button","����˵��","�޸Ŀͻ�һ�ڲ��񱨱������Ϣ","FSDescribe()",sResourcesPath},
		{"true","","Button","��������","�鿴���ڱ������ϸ��Ϣ","FSDetail()",sResourcesPath},
		{"true","","Button","�޸ı�������","�޸ı�������","ModifyReportDate()",sResourcesPath},
		{"true","","Button","ɾ������","ɾ�����ڲ��񱨱�","DeleteFS()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	var ObjectType = "CustomerFS";
	//����һ�ڲ��񱨱�
	function AddNewFS()
	{
		var stmp = CheckRole();
		if("true" == stmp)
		{
    		//�жϸÿͻ���Ϣ�в��񱨱�������Ƿ�ѡ��
    		sModelClass = PopPage("/CustomerManage/EntManage/FindFSType.jsp?CustomerID=<%=sCustomerID%>&rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
    		if(sModelClass == "false")
    		{
    			alert(getBusinessMessage('162'));//�ͻ��ſ���Ϣ���벻��������������ͻ��ſ���Ϣ��
    		}else
    		{
    			//�� /CustomerManage/EntManage/AddFSPre.jsp ҳ�������������
    			sReturn = PopComp("CustomerFS","/CustomerManage/EntManage/AddFSPre.jsp","CustomerID=<%=sCustomerID%>~ModelClass="+sModelClass,"dialogWidth=40;dialogHeight=50;resizable:yes;scrollbars:no;");
    			if(typeof(sReturn) != "undefined" && sReturn != "")
    			{
    				reloadSelf();	
    				FSDetail1(sReturn);
    			}
    		}
		}else
	    {
	        alert(getHtmlMessage('16'));//�Բ�����û����Ϣά����Ȩ�ޣ�
	        return;
	    }
	}
	
	//�޸ı��������Ϣ
	function FSDescribe()
	{
	    var stmp = CheckRole();
	    var srole = "";
		if("true" == stmp)
		    srole="has";
		else
		    srole="no";
		var sEditable="true";
		sUserID = getItemValue(0,getRow(),"UserID");
		sRecordNo = getItemValue(0,getRow(),"RecordNo");
		if (typeof(sRecordNo) != "undefined" && sRecordNo != "" )
		{
			if(CheckFSinEvaluateRecord())
				sEditable="false";
			if(sUserID!="<%=CurUser.UserID%>")
				sEditable="false";
			OpenComp("FinanceStatementInfo","/CustomerManage/EntManage/FinanceStatementInfo.jsp","Role="+srole+"&RecordNo="+sRecordNo+"&Editable="+sEditable,"_self",OpenStyle);
		}else
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
	}
	
	//������ϸ��Ϣ
	function FSDetail()
	{
	    var stmp = CheckRole();
	    var srole = "";
		if("true" == stmp)
		{
		    srole="has";
		}
		else
		{
		    srole="no";
		}
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sRecordNo = getItemValue(0,getRow(),"RecordNo");
		sReportScope = getItemValue(0,getRow(),"ReportScope");
		sUserID = getItemValue(0,getRow(),"UserID");
		if (typeof(sCustomerID) != "undefined" && sCustomerID != "" )
		{
			var sEditable="true";
			if(CheckFSinEvaluateRecord())
				sEditable="false";
			if(sUserID!="<%=CurUser.UserID%>")
				sEditable="false";
			OpenComp("FinanceReportTab","/Common/FinanceReport/FinanceReportTab.jsp","Role="+srole+"&RecordNo="+sRecordNo+"&ObjectType="+ObjectType+"&CustomerID="+sCustomerID+"&ReportDate="+sReportDate+"&ReportScope="+sReportScope+"&Editable="+sEditable,"_blank",OpenStyle);
		    reloadSelf();
		}else
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
	}
	
	//������ϸ��Ϣ
	function FSDetail1(sReturn)
	{
	    var stmp = CheckRole();
	    var srole = "";
		if("true" == stmp)
		{
		    srole="has";
		}
		else
		{
		    srole="no";
		}
		sReturn = sReturn.split("@");
		sRecordNo = sReturn[0];
		sCustomerID = sReturn[1];
		sReportDate = sReturn[2];
		sReportScope = sReturn[3];
		sUserID = sReturn[4];
		
		if (typeof(sRecordNo) != "undefined" && sRecordNo != "" )
		{
			var sEditable="true";
			OpenComp("FinanceReportTab","/Common/FinanceReport/FinanceReportTab.jsp","Role="+srole+"&RecordNo="+sRecordNo+"&ObjectType="+ObjectType+"&CustomerID="+sCustomerID+"&ReportDate="+sReportDate+"&ReportScope="+sReportScope+"&Editable="+sEditable,"_blank",OpenStyle);
		    reloadSelf();
		}else
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
	}
	
	//�޸ı�������
	function ModifyReportDate()
	{
		var stmp = CheckRole();
		if("true" != stmp)
		{
		    alert(getHtmlMessage('16'));//�Բ�����û����Ϣά����Ȩ�ޣ�
		    return;
		}
		if(CheckFSinEvaluateRecord()){
			alert("�Բ��𣬱��ڲ��񱨱����������õȼ�����!");
			return;
		}
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sReportScope = getItemValue(0,getRow(),"ReportScope");
		if(typeof(sReportDate)!="undefined"&& sReportDate != "" )
		{
			//ȡ�ö�Ӧ�ı����·�
			sReturnMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
			if(typeof(sReturnMonth) != "undefined" && sReturnMonth != "")
			{
				sToday = "<%=StringFunction.getToday()%>";//��ǰ����
				sToday = sToday.substring(0,7);//��ǰ���ڵ�����
				if(sReturnMonth >= sToday)
				{		    
					alert(getBusinessMessage('163'));//�����ֹ���ڱ������ڵ�ǰ���ڣ�
					return;		    
				}
				
				if(confirm("��ȷ��Ҫ�� "+sReportDate+"���񱨱� ����Ϊ"+sReturnMonth+"��"))
				{
					//�����Ҫ���Խ��б���ǰ��Ȩ���ж�
					sPassRight = PopPage("/CustomerManage/EntManage/FinanceCanPass.jsp?ReportDate="+sReturnMonth+"&ReportScope="+sReportScope,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
					if(sPassRight == "pass")
					{
						//������صĲ��񱨱�
						sReturn = RunMethod("BusinessManage","InitFinanceReport","CustomerFS,<%=sCustomerID%>,"+sReportDate+","+sReportScope+",,"+sReturnMonth+",ModifyReportDate,<%=CurOrg.OrgID%>,<%=CurUser.UserID%>");
						if(sReturn == "ok")
						{
							alert("���ڲ��񱨱��Ѿ�����Ϊ"+sReturnMonth);	
							reloadSelf();	
						}
					}else
					{
						alert(sReturnMonth +" �Ĳ��񱨱��Ѵ��ڣ�");
					}
				}
			}
		}else
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
	}
	
	//ɾ��һ�ڲ��񱨱�
	function DeleteFS() 
	{
	    var stmp = CheckRole();
		if("true" != stmp)
		{
		    alert(getHtmlMessage('16'));//�Բ�����û����Ϣά����Ȩ�ޣ�
		    return;
		}
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sUserID = getItemValue(0,getRow(),"UserID");
		sReportScope = getItemValue(0,getRow(),"ReportScope");
		if (typeof(sReportDate) != "undefined" && sReportDate != "" )
		{
			if(sUserID=='<%=CurUser.UserID%>')
			{
    			if(CheckFSinEvaluateRecord()){
					alert("�Բ��𣬱��ڲ��񱨱����������õȼ�����!");
					return;
				}
    			if(confirm(getHtmlMessage('2')))
    		    {			
	    			as_del('myiframe0');
	      			as_save('myiframe0');  //�������ɾ������Ҫ���ô����			
    			}
			}else alert(getHtmlMessage('3'));
		}else
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}	
	}
	
	//�ж�ʱ������Ϣά��Ȩ��
	function CheckRole()
	{
	    var sCustomerID="<%=sCustomerID%>";
		var sReturn = PopPage("/CustomerManage/CheckRolesAction.jsp?CustomerID="+sCustomerID,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
  
        if (typeof(sReturn)=="undefined" || sReturn.length==0){
        	return n;
        }
        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];        //�ͻ�����Ȩ
        sReturnValue2 = sReturnValue[1];        //��Ϣ�鿴Ȩ
        sReturnValue3 = sReturnValue[2];        //��Ϣά��Ȩ
        sReturnValue4 = sReturnValue[3];        //ҵ�����Ȩ

        if(sReturnValue3 =="Y2")
            return "true";
        else
            return "n";
	}
	//�����񱨱��Ƿ����������õȼ�����
	function CheckFSinEvaluateRecord(){
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sReturn=RunMethod("CustomerManage","CheckFSinEvaluateRecord",sCustomerID+","+sReportDate);
		if(sReturn>0)return true;
		return false;
		
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
