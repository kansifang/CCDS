<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.08      
		Tester:	
		Content: �»��׼�򡪡�Ԥ���ֽ���
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ���ֽ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,����)�����Զ���Ӧwindow_open
	//��ý׶����͡�ҳ���־����ͬ���ͺ���ɱ�־
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth == null) sAccountMonth = "";
	String sLoanAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));
	if(sLoanAccount == null) sLoanAccount = "";
	String sGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grade"));
	if(sGrade == null) sGrade = "";
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo == null) sSerialNo = "";
	String sMFiveClassify = "", sAFiveClassify="", sAuditRate="", sObjectNo = "";
	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {
				 {"AccountMonth","����·�"},
	             {"ReturnDate","Ԥ���ջ�����"},
	             {"LoanAccount","��ݺ�"},
	             {"Grade","Ԥ�⼶��"},
	             {"PredictCapital","Ԥ���ֽ���-����Ԫ��"},
				 {"PredictInterest","Ԥ���ֽ���-��Ϣ��Ԫ��"},
				 {"Reason","�ֽ���Ԥ������"},
				 {"GuarantyValue","Ԥ���õ�ѺƷ��ֵ��Ԫ��"},
				 {"GuarantyReason","��ѺƷ��������"},
				 {"EnsureValue","Ԥ�ƿ��ջصı�֤��Ԫ��"},
				 {"EnsureReason","��֤�������"},
				 {"DueSum","�ϼƽ�Ԫ��"},
				 {"Discount","������"},
				 {"DiscountValue","����ֵ��Ԫ��"}
	      };
	
	String sSql =  " select AccountMonth, ReturnDate, LoanAccount,Grade, PredictCapital , PredictInterest, Reason, "+
			   " GuarantyValue,GuarantyReason,EnsureValue, EnsureReason, DueSum, Discount, DiscountValue "+
     		   " from reserve_predictdata "+
     		   " where LoanAccount='"+sLoanAccount+"'" +
     		   " and Grade ='" + sGrade + "'";
     
 	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "reserve_predictdata";
	
	//�������ݱ���������
	doTemp.setKey("LoanAccount,AccountMonth",true);
	doTemp.setVisible("LoanAccount,AccountMonth",false);
    //��html��ʽ
	doTemp.setHTMLStyle("Reason,GuarantyReason,EnsureReason"," style={width:150px}");
       
	//����ASDataWindow����
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);

	//����ΪGrid���
	dwTemp.Style="1";
	
	//����Ϊֻ��
	dwTemp.ReadOnly = "1";
	//����HTMLDataWindow
	
	Vector vTemp = dwTemp.genHTMLDataWindow("LoanAccount");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//session.setAttribute(dwTemp.Name,dwTemp);
	
	
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
			{"true","","Button","����","������¼","my_Add()",sResourcesPath},
			{"true","","Button","�鿴����","�鿴/�޸�����","my_ViewEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ����¼","my_Del()",sResourcesPath},
			{"true","","Button","Ԥ�����","Ԥ�����","my_Confirm()",sResourcesPath},
			{"true","","Button","�鿴����","�鿴����","my_View()",sResourcesPath}
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>
<script language=javascript>
	
  	//˫��ĳ������ֱ�����ӵ�ҵ����Ϣ����ҳ��
	function my_Add()
	{
		PopComp("CashPreInfo","/BusinessManage/ReserveNullCredit/CashPreInfo.jsp","LoanAccount=<%=sLoanAccount%>"+"&SerialNo=<%=sSerialNo%>"+"&Grade=<%=sGrade%>","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}

	
	//�鿴��ͬ��Ϣ����
    function my_ViewEdit()
	{
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sReturnDate = getItemValue(0,getRow(),"ReturnDate");
		sGrade = getItemValue(0,getRow(),"Grade");
		alert(sLoanAccount+"-----"+sAccountMonth+"-----"+sReturnDate+"-----"+sGrade);
       	if (typeof(sLoanAccount) == "undefined" || sLoanAccount.length == 0)
		{
			alert(getHtmlMessage(1));
			return;
		}
		PopComp("CashPreInfo","/BusinessManage/ReserveNullCredit/CashPreInfo.jsp","AccountMonth="+sAccountMonth+"&sGrade = " + sGrade + "&ReturnDate = " +sReturnDate+"&LoanAccount="+sLoanAccount+"&SerialNo=<%=sSerialNo%>","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	
	//����Ԥ���ֽ������б�ҳ��
	function my_Confirm(){
		sGrade = "<%=sGrade%>";
	    sSerialNo = "<%=sSerialNo%>";
	    sReturn = PopComp("CheckAttAction","/BusinessManage/ReserveNullCredit/CheckAttAction.jsp","ObjectNo="+sSerialNo,"dialogWidth=20;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;close:no");
 		if(sReturn == "01"){
	           	alert("û�и����������ϴ�������");
	          	return;
	    }
	    iCount=getRowCount(0);
	    if(iCount == 0){
	       alert("����Ԥ���ֽ���");
	       return;
	    }
		sLoanAccount= "<%=sLoanAccount%>";
		
		sAccountMonth = "<%=sAccountMonth%>";
	    sReturn = PopComp("UpdateCashPreAction","/BusinessManage/ReserveNullCredit/UpdateCashPreAction.jsp","LoanAccount="+sLoanAccount+"&AccountMonth="+sAccountMonth+"&Grade="+sGrade+"&rand="+randomNumber()," ","dialogWidth=20;dialogHeight=10;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no;close:no");
	    reloadSelf();
        if(sReturn == "00"){
           alert("Ԥ��ɹ�");
        }
        if(sReturn != "00"){
           alert("Ԥ��ʧ��");
        }
        //opener.opener.location.reload();
 	}
 	
 	//ɾ����¼
 	function my_Del(){
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sReturnDate = getItemValue(0,getRow(),"ReturnDate");
       	if (typeof(sReturnDate) == "undefined" || sReturnDate.length == 0)
		{
			alert(getHtmlMessage(1));
			return;
		}
        as_del('myiframe0');
		as_save('myiframe0');  //�������ɾ������Ҫ���ô����
 	}
	function my_View(){
		sSerialNo = "<%=sSerialNo%>"; 
		if(typeof(sSerialNo) == "undefined" || sSerialNo==""){
			 alert("��ѡ��һ���鿴��Ϣ");
		   return;
		}
        PopComp("AttachmentList1","/BusinessManage/ReserveManage/AttachmentList.jsp","ObjectNo="+sSerialNo+"&rand="+randomNumber(),"_blank");
   }
</script>

<script language=javascript>
    //bShowGridSum = true;
	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
</script>

<%@ include file="/IncludeEnd.jsp"%>
