<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.14      
		Tester:	
		Content:  ���ݲɼ���������ҵ��
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ҵ��"; // ��������ڱ��� <title> PG_TITLE </title>
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
									{"AccountMonth","����·�"},
									{"AccountMonth1","����·�"},
									{"Serialno","���к�"},
									{"AAdjustValue","����ϵ��"},
									{"MAdjustValue","����ϵ��"},
									{"MLossRate1","�����������ʧ��"},	
									{"MLossRate2","��ע�������ʧ��"},
									{"MLossRate3","�μ��������ʧ��"},
									{"MLossRate4","�����������ʧ��"},
									{"MLossRate5","��ʧ�������ʧ��"},
									{"ALossRate1","�����������ʧ��"},
									{"ALossRate2","��ע�������ʧ��"},
									{"ALossRate3","�μ��������ʧ��"},
									{"ALossRate4","�����������ʧ��"},
									{"ALossRate5","��ʧ�������ʧ��"},
									{"OverDueDaysAdjust1","������������ϵ��"},
									{"OverDueDaysAdjust2","����1-30��������ϵ��"},
									{"OverDueDaysAdjust3","����31-90��������ϵ��"},
									{"OverDueDaysAdjust4","����91-180��������ϵ��"},
									{"OverDueDaysAdjust5","����181-360��������ϵ��"},
									{"OverDueDaysAdjust6","����360������������ϵ��"},
									{"BaseDate","��׼����"},
									{"LastAccountMonth","���ڻ���·�"},
									{"Grade","����"}
			        	  	}; 
    sSql = " select AccountMonth,AccountMonth as AccountMonth1,Serialno,AAdjustValue,MAdjustValue,MLossRate1, MLossRate2,MLossRate3,MLossRate4,MLossRate5, "+
    	   " ALossRate1,ALossRate2,ALossRate3,ALossRate4,ALossRate5,OverDueDaysAdjust1,OverDueDaysAdjust2,OverDueDaysAdjust3, " +
    	   " OverDueDaysAdjust4,OverDueDaysAdjust5,OverDueDaysAdjust6,BaseDate,LastAccountMonth,Grade " +
	       " from Reserve_IndPara " +
	       " where 1=1 ";
    
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_IndPara";
    doTemp.setKey("AccountMonth",true);
    doTemp.setVisible("AccountMonth,MAdjustValue,MLossRate1,Serialno,MLossRate2,MLossRate3,MLossRate4,MLossRate5,ALossRate1,ALossRate2,ALossRate3,ALossRate4,ALossRate5,OverDueDaysAdjust1,OverDueDaysAdjust2,OverDueDaysAdjust3,OverDueDaysAdjust4,OverDueDaysAdjust5,OverDueDaysAdjust6,Grade",false);
    //doTemp.setCheckFormat("AccountMonth","6");
    //doTemp.setDDDWSql("AccountMonth","select distinct AccountMonth,AccountMonth from Reserve_IndPara desc");
    doTemp.setColumnAttribute("AccountMonth","IsFilter","1");
    doTemp.setType("AAdjustValue","Number");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	//if(!doTemp.haveReceivedFilterCriteria()){
	//	doTemp.WhereClause += " and AccountMonth In (Select max(AccountMonth) from Reserve_IndPara )";
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
			{"true","","Button","�鿴����","�鿴����","my_View()",sResourcesPath}
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
		var sReturn = PopComp("DataBaseIndInfo","/BusinessManage/ReserveDataPrepare/DataBaseIndInfo.jsp","","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
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
		var sReturn = PopComp("DataBaseIndInfo","/BusinessManage/ReserveDataPrepare/DataBaseIndInfo.jsp","AccountMonth="+sAccountMonth,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0)
        {
        	return;
        }
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