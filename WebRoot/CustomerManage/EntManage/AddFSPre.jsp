<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jbye 2004-12-16 20:40
		Tester:
		Describe: �������񱨱�׼����Ϣ ��ҳ��������ڱ�����Ϣ����������
		Input Param:
			--CustomerID����ǰ�ͻ����
			--ModelClass: ģʽ����
		Output Param:
			--CustomerID����ǰ�ͻ����
		HistoryLog:		
			DATE	CHANGER		CONTENT
			2005-8-10	fbkang	ҳ�����	
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����˵��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
    String sCustomerID="";//--�ͻ�����
    String sModelClass = "";//--ģʽ����
    String sSql = "";//--���sql���
    String sPassRight = "true";//--�����ͱ���
	//�������������ͻ����롢ģʽ����
	sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID")); 
	sModelClass = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelClass")); 
	//���ҳ�����	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sHeaders[][] = {
							{"CustomerID","�ͻ���"},
							{"RecordNo","��¼��"},
							{"ReportDate","�����������"},
							{"ReportScope","����ھ�"},
							{"ReportPeriod","��������"},
							{"ReportCurrency","�������"},
							{"ReportUnit","����λ"},
							{"ReportStatus","����״̬"},
							{"ReportFlag","�������־"},
							{"ReportOpinion","����ע��"},
							{"AuditFlag","������"},
							{"AuditOffice","��Ƶ�λ"},
							{"AuditDate","���ʱ��"},
							{"AuditOpinion","������"},
							{"InputDate","�Ǽ�����"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"},
							{"UpdateDate","�޸�����"},
							{"Remark","��ע"}
						  };
	
	sSql = 	" select CustomerID,RecordNo,ReportDate,ReportScope,ReportPeriod,ReportCurrency,"+
			" ReportUnit,ReportStatus,ReportFlag,ReportOpinion,AuditFlag,AuditOffice,AuditDate,AuditOpinion,"+
			" getUserName(UserID) as UserName,"+
			" getOrgName(OrgID) as OrgName,"+
			" InputDate,OrgID,UserID,UpdateDate,Remark "+
			" from CUSTOMER_FSRECORD "+
			" where 1=2 ";
	ASDataObject doTemp = new ASDataObject(sSql);
	
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_FSRECORD";
	doTemp.setKey("RecordNo",true);	
	doTemp.setUpdateable("UserName,OrgName",false);
	doTemp.setVisible("ReportFlag,CustomerID,RecordNo,OrgID,UserID,Remark,ReportStatus",false);
	
	//����Ĭ��Ϊ����ң���λĬ��ΪԪ��modi by xuzhang 2005-1-20
	doTemp.setDefaultValue("ReportCurrency","01");
	doTemp.setDefaultValue("ReportUnit","01");
    //���������б��
	doTemp.setDDDWCode("ReportPeriod","ReportPeriod");
	doTemp.setDDDWCode("ReportCurrency","Currency");
	doTemp.setDDDWCode("ReportStatus","ReportStatus");
	doTemp.setDDDWCode("ReportScope","ReportScope");
	doTemp.setDDDWCode("ReportUnit","ReportUnit");
	doTemp.setDDDWCode("AuditFlag","AuditInstance");
	doTemp.setDDDWCode("AuditOpinion","AuditOpinion");
	//ѡ������
	doTemp.setUnit("ReportDate","<input class=\"InputDate\" value=\"...\" type=button onClick=parent.getMonth(\"ReportDate\")>");
	doTemp.setUnit("AuditOffice","<input type=button value=.. onclick=parent.selectEvalOrgName()>");
	//datawindow��ʽ���Ͷ���
	//doTemp.setEditStyle("AuditOpinion","3");
	doTemp.appendHTMLStyle("ReportDate"," style={width=55px} ");
	doTemp.appendHTMLStyle("AuditOffice"," style={width=300px} ");	 
	//doTemp.appendHTMLStyle("AuditOpinion","  style={height:100px;width:400px;overflow:scroll} ");
    doTemp.setLimit("ReportOpinion,AuditOpinion",200);
	//���޸��ֶ�
	doTemp.setRequired("AuditFlag,ReportDate,ReportScope,ReportPeriod,ReportUnit,ReportCurrency",true);
	//�ֶ�ֻ��
	doTemp.setHTMLStyle("OrgName","style={width:250px}");  
	doTemp.setReadOnly("ReportDate,UserName,OrgName,InputDate,UpdateDate,ReportUnit,ReportCurrency",true);
	//�������ڵĸ�ʽ
	doTemp.setCheckFormat("AuditDate","3");
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//�������в��񱨱�ĳ�ʼ������
	dwTemp.setEvent("AfterInsert","!BusinessManage.InitFinanceReport(CustomerFS,#CustomerID,#ReportDate,#ReportScope,ModelClass^'"+sModelClass+"',,AddNew,"+CurOrg.OrgID+","+CurUser.UserID+")");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=���尴ť;]~*/%>
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
		       {"true","","Button","ȷ��","ȷ��","doCreation()",sResourcesPath}
		      };
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info04;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------//
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		sReportDate = getItemValue(0,0,"ReportDate");
		sReportScope = getItemValue(0,0,"ReportScope");
		//�����Ҫ���Խ��б���ǰ��Ȩ���ж�
		sPassRight = PopPage("/CustomerManage/EntManage/FinanceCanPass.jsp?ReportDate="+sReportDate+"&ReportScope="+sReportScope,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		if(sPassRight=="pass")
		{
			//ʹ��GetSerialNo.jsp����ռһ����ˮ��
			var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName=CUSTOMER_FSRECORD&ColumnName=RecordNo&Prefix=CFS","","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
			//����ˮ�������Ӧ�ֶ�
			setItemValue(0,0,"RecordNo",sSerialNo);
			as_save("myiframe0",sPostEvents);
		}else
		{
			alert(sReportDate +" �Ѵ�����ͬ����ھ��Ĳ��񱨱�������ѡ�񱨱�ھ���");
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=����һ����¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation()
	{
		saveRecord("goBack()");
	}
	
	function goBack()
	{
		sRecordNo = getItemValue(0,0,"RecordNo");//��ˮ��
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//�ͻ����
		sReportDate = getItemValue(0,getRow(),"ReportDate");//��������
		sReportScope = getItemValue(0,getRow(),"ReportScope");//����ھ�
		sUserID = getItemValue(0,getRow(),"UserID");
		self.returnValue= sRecordNo+"@"+sCustomerID+"@"+sReportDate+"@"+sReportScope+"@"+sUserID;
		self.close();
	}
	
	/*~[Describe=����ѡ��;InputParam=��;OutPutParam=��;]~*/
	function getMonth(sObject)
	{
		sReturnMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=18;dialogHeight=12;center:yes;status:no;statusbar:no");
		if(typeof(sReturnMonth) != "undefined")
		{
			setItemValue(0,0,sObject,sReturnMonth);
		}
	}
	
	/*~[Describe=ѡ����Ƶ�λ;InputParam=��;OutPutParam=��;]~*/
	function selectEvalOrgName()
	{
		//����ֻ���ɷ��ز����������������������ʲ�������˾
		var AuditOrgType = "010";
		sParaString = "AuditOrgType"+","+AuditOrgType;
		setObjectValue("selectNewEvalOrgName",sParaString,"@AuditOffice@0",0,0,"");
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{			
		//У�鱨���ֹ�����Ƿ���ڵ�ǰ����
		sReportDate = getItemValue(0,0,"ReportDate");//�����ֹ����
		sToday = "<%=StringFunction.getToday()%>";//��ǰ����
		sToday = sToday.substring(0,7);//��ǰ���ڵ�����			
		if(typeof(sReportDate) != "undefined" && sReportDate != "" )
		{
			if(sReportDate >= sToday)
			{		    
				alert(getBusinessMessage('163'));//�����ֹ���ڱ������ڵ�ǰ���ڣ�
				return false;		    
			}
		}
		//��������Ϊ�����ʱ,��Ƶ�λ,������ں�������������д
		sAuditFlag = getItemValue(0,0,"AuditFlag");//������
		sAuditOffice = getItemValue(0,0,"AuditOffice");//��Ƶ�λ
		sAuditOpinion = getItemValue(0,0,"AuditOpinion");//������
		sAuditDate = getItemValue(0,0,"AuditDate");//�������	
		if(typeof(sAuditFlag) != "undefined" && sAuditFlag != "")
		{
			if(sAuditFlag == '2' && (typeof(sAuditOffice) == "undefined" || sAuditOffice == "" ||sAuditDate=="" || typeof(sAuditDate) == "undefined" ||typeof(sAuditOpinion) == "undefined" || sAuditOpinion == ""))
			{
				alert("��������Ϊ�����ʱ,��Ƶ�λ,������ں�������������д!");
				return false;
			}
			if(sAuditFlag == '2'&& typeof(sAuditDate) != "undefined" && sAuditDate != "")
			{
				//��ƻ�����Ч�Լ��
				sCustomerName = getItemValue(0,getRow(),"AuditOffice");
				sAuditDate = getItemValue(0,getRow(),"AuditDate");
				sReturn=RunMethod("CustomerManage","selectNewEvalOrgDate",sCustomerName);
				sReturn1=sReturn.split("@");
     			sEffectStartDate=sReturn1[0];
     			sEffectFinishDate=sReturn1[1];
				if(sAuditDate<sEffectStartDate || sAuditDate>sEffectFinishDate)
				{
					alert("������ڲ�������������Ч����!");
					return true;
				}		
				return true;
			}
		}
		return true;
	}
	

	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"ReportStatus","01");
			setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"OrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		}
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
