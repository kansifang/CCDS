<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jbye 2004-12-16 20:40
		Tester:
		Describe: �޸ı�����Ϣ
		Input Param:
			--sRecordNo:	������ˮ��
			
		Output Param:

		HistoryLog:
			
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
	String sRecordNo = "";//--������ˮ��
	boolean isEditable=true;
	String sSql = "";//--���sql���
	//����������,������ˮ��
	sRecordNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RecordNo"));
	String sEditable =DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Editable"));
	if("false".equals(sEditable))isEditable=false;
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sHeaders[][] = {
							{"CustomerID","�ͻ���"},
							{"RecordNo","��¼��"},
							{"ReportDate","��������"},
							{"ReportScope","����ھ�"},
							{"ReportPeriod","��������"},
							{"ReportCurrency","�������"},
							{"ReportUnit","����λ"},
							{"ReportStatus","����״̬"},
							{"ReportFlag","�������־"},
							{"ReportOpinion","����ע��"},
							{"AuditFlag","������"},
							{"AuditOffice","��Ƶ�λ"},
							{"AuditDate","�������"},
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
			" where RecordNo='"+sRecordNo+"'";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_FSRECORD";
	doTemp.setKey("RecordNo",true);	
	doTemp.setUpdateable("UserName,OrgName",false);
	
	doTemp.setRequired("ReportScope,AuditFlag,ReportPeriod,ReportUnit,ReportCurrency",true);
	doTemp.setVisible("CustomerID,RecordNo,OrgID,UserID,Remark,ReportStatus,ReportFlag",false);
	//�����б�
	doTemp.setDDDWCode("ReportPeriod","ReportPeriod");
	doTemp.setDDDWCode("ReportCurrency","Currency");
	doTemp.setDDDWCode("ReportStatus","ReportStatus");
	doTemp.setDDDWCode("ReportScope","ReportScope");
	doTemp.setDDDWCode("ReportUnit","ReportUnit");
	doTemp.setDDDWCode("AuditFlag","AuditInstance");
	doTemp.setDDDWCode("AuditOpinion","AuditOpinion");
	
	doTemp.setUnit("AuditOffice","<input type=button value=.. onclick=parent.selectEvalOrgName()>");
	doTemp.setEditStyle("ReportOpinion","3");
	doTemp.setHTMLStyle("OrgName"," style={width:250px} ");
	doTemp.setReadOnly("ReportDate,UserName,OrgName,InputDate,UpdateDate,ReportUnit,ReportCurrency",true);
	doTemp.appendHTMLStyle("ReportDate"," style={width=55px} ");
	doTemp.appendHTMLStyle("AuditOffice"," style={width=300px} ");
	doTemp.appendHTMLStyle("ReportOpinion","  style={height:100px;width:400px;overflow:scroll} ");
	doTemp.appendHTMLStyle("ReportScope"," onChange=\"javascript:parent.updateReportScope()\" ");
    doTemp.setLimit("ReportOpinion",200);
    
   	//�������ڵĸ�ʽ
	doTemp.setCheckFormat("AuditDate","3");
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
		{isEditable?"true":"false","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�-----------------------//
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord()
	{
		//��ǰ�·ݲ��񱨱��Ѵ���
		if(checkFSMonth()){
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		alert(sReportDate +" �Ѵ�����ͬ����ھ��Ĳ��񱨱�������ѡ�񱨱�ھ���");
		return;
		}
		setItemValue(0,0,"UserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"OrgID","<%=CurUser.OrgID%>");
		setItemValue(0,0,"UserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"OrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
		if (!ValidityCheck())
		{
			return;
		}else{
			updateReportScope();
		}
		as_save("myiframe0");
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function goBack()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		OpenComp("CustomerFSList","/CustomerManage/EntManage/CustomerFSList.jsp","CustomerID="+sCustomerID,"_self",OpenStyle);
	}
	
	/*~[Describe=��ȡ�·�;InputParam=�����¼�;OutPutParam=��;]~*/
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
	
	/*~[Describe=��ⱨ���·��Ƿ��Ѵ���;InputParam=�����¼�;OutPutParam=��;]~*/
	function checkFSMonth(){
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sRecordNo = getItemValue(0,getRow(),"RecordNo");
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sReturn=RunMethod("CustomerManage","CheckFSRecord",sCustomerID+","+sRecordNo+","+sReportDate);
		if(sReturn>0)return true;
		return false;
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe= ����REPORT_RECORD��ReportScope;InputParam=�����¼�;OutPutParam=��;]~*/
	function updateReportScope(){
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		sReportDate = getItemValue(0,getRow(),"ReportDate");
		sReportScope = getItemValue(0,getRow(),"ReportScope");
		sReturnValue=RunMethod("PublicMethod","UpdateColValue","String@ReportScope@"+sReportScope+",REPORT_RECORD,String@ObjectType@CustomerFS@String@ObjectNo@"+sCustomerID+"@String@ReportDate@"+sReportDate);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
