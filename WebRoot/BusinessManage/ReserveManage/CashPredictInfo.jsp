<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:jjwang  2008.10.12
		Tester:
		Content:  Ԥ���ֽ���
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ���ֽ�����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�������

	//����������

	//���ҳ�����
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth==null) sAccountMonth="";
	String sBusinessRate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("BusinessRate"));
	if(sBusinessRate==null) sBusinessRate="";
	String sLoanAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));
	if(sLoanAccount==null) sLoanAccount="";
	String sReturnDate = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ReturnDate"));
	if(sReturnDate==null) sReturnDate="";
	String sGrade = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Grade"));
	if(sGrade==null) sGrade="";
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if(sSerialNo==null) sSerialNo="";

%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo = "CashPredictInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable = "Reserve_PredictData";
   	doTemp.setVisible("ObjectNo,GradeName",false);
   	doTemp.setHTMLStyle("Reason,GuarantyReason,EnsureReason","style={width:260;height:150}overflow:scroll");
   	doTemp.appendHTMLStyle("PredictInterest"," onBlur=\"javascript:parent.calDueSum()\" ");
	doTemp.appendHTMLStyle("PredictCapital"," onBlur=\"javascript:parent.calDueSum()\" ");
	doTemp.appendHTMLStyle("GuarantyValue"," onBlur=\"javascript:parent.calDueSum()\" ");
	doTemp.appendHTMLStyle("EnsureValue"," onBlur=\"javascript:parent.calDueSum()\" ");
	//��û������ݲ����ǶԹ����ǶԸ�
	String sSqljjw = "select businessflag from reserve_record where LoanAccount = '" + sLoanAccount + "'";
	ASResultSet stempjjw = Sqlca.getASResultSet(sSqljjw);
	String tablejjw = "";
	if(stempjjw.next()){
		String sbusinessflag = stempjjw.getString("businessflag")==null ? "" : stempjjw.getString("businessflag");
		if(sbusinessflag.equals("1"))
		{
			tablejjw = "Reserve_Para";
		}
		else if(sbusinessflag.equals("2"))
		{
			tablejjw = "Reserve_IndPara";
		}
	}
	stempjjw.getStatement().close();
	//��û������ݲ���
	String stemp = "select basedate from " + tablejjw + " where AccountMonth = '" + sAccountMonth + "'";
    ASResultSet rsTemp = Sqlca.getASResultSet(stemp);
    String sBaseDate = "";
    if(rsTemp.next()){
       sBaseDate = rsTemp.getString("basedate")== null ? "" : rsTemp.getString("basedate");
    }
    rsTemp.getStatement().close();
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccountMonth+","+","+sReturnDate+","+sLoanAccount+","+sGrade);
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
		{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
		{"true","","Button","����","����","goBack()",sResourcesPath},
		{"false","","Button","�ϴ�����","�ϴ�����","Upload()",sResourcesPath},
		{"false","","Button","�ͻ�����","�ͻ�����","CustomerAndView()",sResourcesPath}
	};
	if(CurUser.hasRole("603"))
	{
		sButtons[3][0] = "true";
	}
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	function selectAccountMonth()
	{
		
		var sReturnDate = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=21;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sReturnDate)!="undefined" && sReturnDate!="")
		{	
			alert(sReturnDate);
			setItemValue(0,0,"ReturnDate",sReturnDate);
		}
		else
			setItemValue(0,0,"ReturnDate","");
	}
	
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
			var sReturnDate=getItemValue(0,getRow(),"ReturnDate");
			var iCount = RunMethod("�»��׼��","getReturnDate","<%=sLoanAccount%>"+","+"<%=sAccountMonth%>"+","+sReturnDate+","+"<%=sGrade%>");
			if(iCount==1)
			{
				alert("���Ѿ�Ԥ���˸�Ԥ�ƻ������ڣ�������Ԥ�⣡");
				bIsInsert=true;
				return;
			}
		}
		else{
			beforeUpdate();
		}
		var sDiscountValue = getItemValue(0,getRow(),"DiscountValue");
		if(sDiscountValue=="" )
		{
			var sVar = calDiscountValue();
		    if(sVar == 1){
		    	return 1;
		    }
		}
		
		as_save("myiframe0",sPostEvents);
	}
	
	function goBack()
	{
		self.close();
	}
	function Upload(){
		sLoanAccount = getItemValue(0,getRow(),"LoanAccount"); 
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth"); 
		PopComp("AddDocumentPreMessage","/BusinessManage/ReserveManage/AddDocumentPreMessage.jsp","ObjectType=ReserveImport&ObjectNo= <%=sSerialNo%>" + "&rand="+randomNumber(),"_blank","width=500,height=150,top=200,left=170;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 	
	}
	
	function CustomerAndView()
	{
		
		var sLoanAccount = getItemValue(0,getRow(),"LoanAccount");
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sCustomerID = RunMethod("�»��׼��","CustomerAndView",sLoanAccount+","+sAccountMonth);
		if (sCustomerID=="1")
		{
			alert("�ͻ����Ϊ�գ������ڿͻ�����");
			return;
		}
		var sReturn = PopPage("/CustomerManage/CheckRolesAction.jsp?CustomerID="+sCustomerID,"","resizable=yes;dialogWidth=25;dialogHeight=10;center:yes;status:no;statusbar:no");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0)
        {
        	return;
        }

        var sReturnValue = sReturn.split("@");
        sReturnValue1 = sReturnValue[0];
        sReturnValue2 = sReturnValue[1];
        sReturnValue3 = sReturnValue[2];
		openObject("Customer",sCustomerID,"001");
		reloadSelf();
	}
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		
	}
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"AccountMonth","<%=sAccountMonth%>");
			setItemValue(0,0,"LoanAccount","<%=sLoanAccount%>");
			setItemValue(0,0,"Grade","<%=sGrade%>");
			setItemValue(0,0,"Discount","<%=sBusinessRate%>");
		}	
    }
    
    function calDueSum()
    {
	    if(allowCalDueSum() == false){
	       return;
	    }
		dPredictInterest = getItemValue(0,getRow(),"PredictINTEREST");			
		dPredictCapital = getItemValue(0,getRow(),"PredictCapital");			
		dGuarantyValue = getItemValue(0,getRow(),"GuarantyValue");			
		dEnsureValue = getItemValue(0,getRow(),"EnsureValue");
		dDueSum = dPredictInterest + dPredictCapital + 	dGuarantyValue + dEnsureValue;
	    setItemValue(0,getRow(),"DueSum",dDueSum);	
	    calDiscountValue();

	}
	function allowCalDueSum()
	{
		dPredictInterest = getItemValue(0,getRow(),"PredictINTEREST");
      	if (typeof(dPredictInterest) == "undefined" || dPredictInterest.length == 0)
		{
			return false;
		}			
		dPredictCapital = getItemValue(0,getRow(),"PredictCapital");			
      	if (typeof(dPredictCapital) == "undefined" || dPredictCapital.length == 0)
		{
			return false;
		}
		dGuarantyValue = getItemValue(0,getRow(),"GuarantyValue");			
      	if (typeof(dGuarantyValue) == "undefined" || dGuarantyValue.length == 0)
		{
			return false;
		}
		dEnsureValue = getItemValue(0,getRow(),"EnsureValue");	
      	if (typeof(dEnsureValue) == "undefined" || dEnsureValue.length == 0)
		{
			return false;
		}
		return true;	   
	}
	function calDiscountValue(){
	   sReturnDate = getItemValue(0,getRow(),"ReturnDate");	
	   sBaseDate = "<%=sBaseDate%>";
	   if(typeof(sBaseDate)=="undefined" || sBaseDate.length ==0)
	   {
	   		alert("����ҵ��Ļ������ݲ����ڣ���¼�뱾�·ݵĻ������ݣ�");
	   		return 1;
	   }
	   dDueSum = getItemValue(0,getRow(),"DueSum");	
	   dDiscount = getItemValue(0,getRow(),"Discount");	
	   var   n1   =   new   Date(sReturnDate).getTime();   
  	   var   n2   =   new   Date(sBaseDate).getTime();
  	   dYear = (n1-n2)/(24*60*60*1000*360);
	   tmp = Math.pow((1+dDiscount/100.0), dYear);
	   dDiscountValue = dDueSum/tmp;
	   dDiscountValue = Math.round(dDiscountValue * 100)/100.0;
	   if(isNaN(dDiscountValue))
	   {
	   		setItemValue(0,getRow(),"DiscountValue","");	
	   }else
	   {	   		
	    	setItemValue(0,getRow(),"DiscountValue",dDiscountValue);
	   }
	   return 0;
	}
   
	</script>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
