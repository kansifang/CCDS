<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.08      
		Tester:	
		Content:  ���ݲɼ��������������趨������˾ҵ��
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
	
			        	  	
	String sHeaders[][] = { 
									{"AccountMonth1","����·�"},
									{"AccountMonth","����·�"},
									{"Serialno","���к�"},
									{"ALossTerm","��ʧʶ���ڼ�"},
									{"AAdjustValue","����ϵ��"},	
									{"ALossRate1","�����������ʧ��"},	
									{"ALossRate2","��ע�������ʧ��"},	
									{"BaseDate","��׼����"},	
									{"LastAccountMonth","���ڻ���·�"},	
									{"RetCancelSum","�����ջ��Ѻ�������"}
			        	  	}; 
    sSql = "select AccountMonth,AccountMonth as AccountMonth1,Serialno,ALossTerm,AAdjustValue,ALossRate1, ALossRate2, BaseDate,"+
	    			" LastAccountMonth,RetCancelSum from Reserve_Para where 1=1 ";
    
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Para";
    doTemp.setKey("AccountMonth",true);
    doTemp.setVisible("AccountMonth,ALossTerm,RetCancelSum,Serialno",false);
    //doTemp.setCheckFormat("AccountMonth","6");
    //doTemp.setDDDWSql("AccountMonth","select distinct AccountMonth,AccountMonth from Reserve_Para desc");
    doTemp.setColumnAttribute("AccountMonth","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
		
	//if(!doTemp.haveReceivedFilterCriteria()){
	//	doTemp.WhereClause += " and AccountMonth In (Select max(AccountMonth) from Reserve_Para )";
	//}
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
			{"true","","Button","����","������¼","newRecord()",sResourcesPath},
			{"true","","Button","�鿴����","�鿴/�޸�����","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����¼","deleteRecord()",sResourcesPath}	,	
//			{"true","","Button","�鿴����","�鿴����","my_View()",sResourcesPath}
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
		var sReturn = PopComp("DataBaseInfo","/BusinessManage/ReserveDataPrepare/DataBaseInfo.jsp","","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		
		var sReturn = PopComp("DataBaseInfo","/BusinessManage/ReserveDataPrepare/DataBaseInfo.jsp","AccountMonth="+sAccountMonth,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function deleteRecord(sPostEvents)
	{
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		if (typeof(sAccountMonth)=="undefined" || sAccountMonth.length==0)
		{
			alert(getHtmlMessage('1')); //��ѡ��һ����Ϣ��
			return;
		}
		if(confirm(getHtmlMessage('2'))) //�������ɾ������Ϣ��
		{
			as_del("myiframe0");
			as_save("myiframe0",sPostEvents);  //�������ɾ������Ҫ���ô����
		}
	}
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	
	
	function my_View(){
		sSerialNo =  getItemValue(0,getRow(),"Serialno");
		if(typeof(sSerialNo) == "undefined" || sSerialNo==""){
			 alert("��ѡ��һ���鿴��Ϣ");
		   return;
		}
        PopComp("CSAttachmentList","/BusinessManage/ReserveManage/CSAttachmentList.jsp","ObjectNo="+sSerialNo+"&rand="+randomNumber(),"_blank");
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