<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.12      
		Tester:	
		Content: �»��׼�򡪡���ƽ��ȷ��
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ƽ��ȷ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql = "";//��� sql���
	String sAction = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Action"));
	if(sAction==null) sAction="";
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sType==null) sType="";
	String sGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grade"));
	if(sGrade==null) sGrade="";
	String sCondition1 = "";
	String sRightCondi = "";
	String sEqualRightCondi = "";//����Ȩ�������Ĳ�������
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//��ȡ�����ͻ���Ϣ������	
	String sHeaders[][] = {
				 {"SerialNo","���"},
	             {"AccountMonth","����·�"},
				 {"LoanAccount","��ݺ�"},
//				 {"ObjectNo","��ݺ�"},
				 {"CustomerName","�ͻ�����"},
				 {"Balance","�������"},
				 {"PutoutDate","������"},
				 {"MaturityDate","������"},
				 {"AuditRate","ʵ������(��)"},
//				 {"VouchType","��Ҫ������ʽ"},
//				 {"VouchTypeName","��Ҫ������ʽ"},
				 {"MClassifyResultName","�弶����"},
				 {"MClassifyResult","�弶����"},
//				 {"AClassifyResultName","����弶����"},
//				 {"AClassifyResult","����弶����"},
				 {"Result1","�ܻ�Ա������"},
				 {"Result2","֧���϶����"},
				 {"Result3","�����϶����"},
				 {"Result4","�����϶����"},
//				 {"AResult","����϶����"}
				 {"ManageOrgID","��������"}
			};
    sSql = " select  RR.SerialNo,RR.AccountMonth,RR.LoanAccount,RR.ObjectNo,RR.CustomerName,RR.Balance,RR.PutoutDate,RR.MaturityDate,RR.AuditRate, " +
    	   " getItemName('MFiveClassify',RR.MClassifyResult) as MClassifyResultName,RR.Result1,RR.Result2,RR.Result3,RR.Result4,RR.ManageOrgID " +
	       " from Reserve_Record RR ,Reserve_Total RT " +
	       " where RR.LoanAccount = RT.LoanAccount and RR.AccountMonth = RT. AccountMonth and RR.BusinessFlag = '1'  and RT.AuditStatFlag = '1'";
     if(sAction.equals("Finished") && sType.equals("Audit")){
		 	sRightCondi = " and (RR.MFinishdate is null and RR.UserID4 is not null)";
	 }
	sSql = sSql + sRightCondi;         

    sSql = sSql + " order by ObjectNo desc";
	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Record";
    doTemp.setKey("SerialNo,AccountMonth,ObjectNo",true);
    doTemp.setVisible("ObjectNo,SerialNo,ObjectNo,ManageOrgID",false);
 //   doTemp.setColumnAttribute("AccountMonth,CustomerName,ObjectNo","IsFilter","1");
	//doTemp.setCheckFormat("AccountMonth","6");
	doTemp.generateFilters(Sqlca);
 	doTemp.setFilter(Sqlca,"1","AccountMonth","Operators=EqualsString");
 	doTemp.setFilter(Sqlca,"2","CUstomerName","Operators=BeginsWith");
 	doTemp.setFilter(Sqlca,"3","LoanAccount","Operators=BeginsWith");
 	doTemp.setFilter(Sqlca,"4","ManageOrgID","Operators=EqualsString;HtmlTemplate=PopSelect");
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
			{"true","","Button","�����ʧʶ��","�����ʧʶ��","lossManage()",sResourcesPath},
			{"true","","Button","���Ԥ���ֽ���","���Ԥ���ֽ���","my_Input()",sResourcesPath},
			{"false","","Button","���ʳ���","���ʳ���","my_SingleCancel()",sResourcesPath},
			{"false","","Button","��������","��������","my_Cancel()",sResourcesPath}
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	
	//---------------------���尴ť�¼�------------------------------------
	function lossManage()
	{
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount"); 
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sCustomerName = getItemValue(0,getRow(),"CustomerName");
		if(typeof(sAccountMonth)=="undefined" || sAccountMonth.length==0)
		{
			alert("��ѡ��һ����Ϣ");
			return;
		}
		PopComp("ReserveLossView","/BusinessManage/ReserveManage/ReserveLossView.jsp","AccountMonth="+sAccountMonth+"&ObjectNo="+sObjectNo+"&CustomerName="+sCustomerName,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
	}
	
	function my_Input()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount"); 
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sMClassifyResult = getItemValue(0,getRow(),"MClassifyResult");
		sAClassifyResult = getItemValue(0,getRow(),"AClassifyResult");
		if(typeof(sLoanAccount) == "undefined" || sLoanAccount==""){
			 alert("��ѡ��һ����Ϣ");
		     return;
		}
 		PopComp("CashPredictView","/BusinessManage/ReserveManage/CashPredictView.jsp","AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount+"&SerialNo="+sSerialNo+"&Grade=<%=sGrade%>","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
 		reloadSelf();
	}
	
	//���ʳ���ҵ��
	function my_SingleCancel()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert("��ѡ��һ�������Ϣ��");
		}else
	    {
		
			if(confirm("ȷ������ѡ��¼��������һ����"))//ȷ����Ϣ���������
			{
				
				sReturn=PopComp("singleCanclePredictAction","/BusinessManage/ReserveManage/singleCanclePredictAction.jsp","SerialNo="+sSerialNo+"&rand="+randomNumber(),"dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if (sReturn=="00")
				{
					alert("�����ɹ�");
				}else
				{
					alert("����ʧ��");
				}
				reloadSelf();
			}
		}
	}
	
	//ȫ������
	function my_Cancel()
	{
		var sReturn="";
		iCount=getRowCount(0);
		var sReturn="";
		if (iCount>0)
		{
			if (confirm("ȷ�������м�¼������"))//ȷ����Ϣ���������
			{
				var sCondition="<%=sCondition1%>";
			 	sReturn=PopComp("CancelCashPredictAction","/BusinessManage/ReserveManage/CancelCashPredictAction.jsp","Type=<%=sType%>&rand="+randomNumber(),"dialogWidth=42;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
				if (sReturn=="00")
				{
					alert("�����ɹ�");
				}else
				{
					alert("����ʧ��");
				}
				reloadSelf();
			}
		}else 
		{
 			alert("û����Ҫ�����ļ�¼");
 		}
	}
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	
	
	function filterAction(sObjectID,sFilterID,sObjectID2){
		oMyObj = document.all(sObjectID);
		oMyObj2 = document.all(sObjectID2);
		if(sFilterID=="1"){
		
		}else if(sFilterID=="4"){
			//����ģ̬����ѡ��򣬲�������ֵ����sReturn
			sReturn = selectObjectInfo("Code","CodeNo=OrgInfo^��ѡ��ܻ�����^","");
			if(typeof(sReturn)=="undefined" || sReturn=="_CANCEL_"){
				return;
			}else if(sReturn=="_CLEAR_"){
				oMyObj.value="";
				oMyObj2.value="";
			}else{
				sReturns = sReturn.split("@");
				oMyObj.value=sReturns[0];
				oMyObj2.value=sReturns[1];
			}
		}
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