<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.08      
		Tester:	
		Content:  ���ݲɼ������Է��Ŵ�����ά��
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���Ŵ�����ά��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//��� sql���
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//��ȡ�����ͻ���Ϣ������	
	String sHeaders[][]={
							{"AccountMonth","����·�"},
							{"AssetNo","�ʲ����"},
	                        {"SubjectNo","��Ӧ��ƿ�Ŀ��"},
	                        {"SubjectName","��Ӧ��ƿ�Ŀ����"},
	                        {"AssetType","�ʲ���ʽ"},
	                        {"AssetTypeName","�ʲ���ʽ"},
	                        {"DebtorName","ծ��������"},
	                        {"Balance","�������"},
	                        {"AuditStatFlag","�Ƿ����"},
	                        {"AuditStatFlagName","�Ƿ����"},
	                        {"Manageuserid","�ʲ��ܻ���"},
	                        {"ManageuserName","�ʲ��ܻ���"},
	                        {"InputUserID","¼����"},
	                        {"InputDate","¼��ʱ��"}
                        };
    sSql = " select AccountMonth,AssetNo,SubjectNo,getItemName('SubjectNo',SubjectNo) as SubjectName,AssetType,getItemName('AssetType',AssetType) as AssetTypeName,DebtorName,Balance,"+
    	   " AuditStatFlag,getItemName('AuditStatFlag',AuditStatFlag) as AuditStatFlagName,"+
    	   " getUserName(Manageuserid) as ManageuserName,InputUserID,InputDate " +
    	   " from Reserve_Nocredit "+
    	   " where 1=1";
    
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Nocredit";
    doTemp.setKey("AssetNo,AccountMonth",true);
    doTemp.setColumnAttribute("AccountMonth,AssetNo,SubjectNo","IsFilter","1");
    doTemp.setVisible("SubjectNo,AssetType,InputUserID,InputDate,AuditStatFlag,AuditStatFlagName,ManageuserName",false);
	//doTemp.setCheckFormat("AccountMonth","6");
	doTemp.setDDDWSql("SubjectNo","select ItemNo,ItemName from code_library where codeno = 'SubjectNo'");
	doTemp.setDDDWSql("AuditStatFlag","select ItemNo,ItemName from code_library where codeno = 'AuditStatFlag'");
	doTemp.setHTMLStyle("AccountMonth,AuditStatFlagName","style={width:80}");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//����datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//������datawindows����ʾ������
	dwTemp.setPageSize(20); 
	//����DW��� 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	dwTemp.ReadOnly = "1"; 
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("AccountMonth");
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
			{"true","","Button","����","����һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","�鿴����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����ѡ�еļ�¼","deleteRecord()",sResourcesPath},
			{"true","","Button","�鿴����","�鿴����","viewFile()",sResourcesPath},
			{"true","","Button","����","����Excel�ļ�","exportAll()",sResourcesPath},
			{"false","","Button","����","������Ϣ","CustomerAndView()",sResourcesPath}
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	function newRecord()
	{
		var sReturn = PopComp("ReserveDataInfo","/BusinessManage/ReserveDataPrepare/ReserveDataInfo.jsp","","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sSubjectNo = getItemValue(0,getRow(),"SubjectNo");
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sAssetNo = getItemValue(0,getRow(),"AssetNo");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("ReserveDataInfo","/BusinessManage/ReserveDataPrepare/ReserveDataInfo.jsp","AccountMonth="+sAccountMonth+"&AssetNo="+sAssetNo,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function deleteRecord()
	{
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sLoanAccount = getItemValue(0,getRow(),"AssetNo");
		var para = "AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount;
		if (typeof(sAccountMonth)=="undefined" || sAccountMonth.length==0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0");  //�������ɾ������Ҫ���ô����
			RunMethod("�»��׼��","DeleteNullCredit",sLoanAccount + "," + sAccountMonth );
		}
	}
	
	function viewFile(){
		sAssetNo = getItemValue(0,getRow(),"AssetNo"); 
		if(typeof(sAssetNo) == "undefined" || sAssetNo==""){
			 alert("��ѡ��һ���鿴��Ϣ");
		   return;
		}
        PopComp("AttachmentList1","/BusinessManage/ReserveManage/AttachmentList.jsp","ObjectNo="+sAssetNo+"&rand="+randomNumber(),"_blank");
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