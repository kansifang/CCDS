<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zrli
		Tester:
		Describe: ��ʾ�������б�
		Input Param:
			InspectType��  �������� 
				010     ������;��鱨��
	            010010  δ���
	            010020  �����
	            020     �����鱨��
	            020010  δ���
	            020020  �����
		Output Param:
			SerialNo:��ˮ��
			ObjectType:��������
			ObjectNo��������
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//����������
	String sInspectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("InspectType"));
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	ASDataObject doTemp = null;
  	//�״μ�鱨���б�
  	if(sInspectType.equals("010010"))
  	{
	  	String sHeaders1[][] = {
								{"SerialNo","��ͬ��ˮ��"},
								{"CustomerName","�ͻ�����"},
								{"BusinessTypeName","ҵ��Ʒ��"},								
								{"Currency","����"},
								{"BusinessSum","��ͬ���"},
								{"Balance","��ͬ���"},
								};

	  	String sSql1 =  " select SerialNo,getBusinessName(BusinessType) as BusinessTypeName,CustomerID,"+
					  	"CustomerName,nvl(BusinessSum,0) as BusinessSum,nvl(Balance,0) as Balance,BusinessType  "+
					  	"from BUSINESS_CONTRACT  "+
					  	"where not exists (select ObjectNo from Inspect_Info Where ObjectType='BusinessContract'  "+
					  	"and InspectType like '010%' and ObjectNo=BUSINESS_CONTRACT.SerialNo) "+
					  	"and (OccurType != '020' or OccurType is null) "+
					  	"and ActualPutOutSum > 0 and ManageUserID = '"+CurUser.UserID+"' and (FinishDate is null or FinishDate = '')  ";
		//��SQL������ɴ������
		doTemp = new ASDataObject(sSql1);
		//���ÿɸ��µı�
		doTemp.UpdateTable = "BUSINESS_CONTRACT";
		//���ùؼ���
		doTemp.setKey("SerialNo",true);
		doTemp.setHeader(sHeaders1);
		//���ò��ɼ���
		doTemp.setVisible("BusinessType,CustomerID",false);
		doTemp.setAlign("BusinessSum,Balance","3");
		doTemp.setType("BusinessSum,Balance","Number");
		doTemp.setCheckFormat("BusinessSum,Balance","2");
		
		doTemp.setColumnAttribute("SerialNo,CustomerName,BusinessSum","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
	  	//����html��ʽ
	  	doTemp.setHTMLStyle("SerialNo,CustomerName,BusinessTypeName"," style={width:120px} ");
 	}
  	//�����鱨���б�
  	else if(sInspectType.equals("020010") || sInspectType.equals("020020"))
  	{
    	String sHeaders2[][] = {
								{"CustomerName","�ͻ�����"},
								{"CertTypeName","֤������"},
								{"CertID","֤�����"},
								{"LoanCardNo","�����"}
							  };

	  	String sSql2 =  " select CustomerID,CustomerName,CertID,getItemName('CertType',CertType) as CertTypeName,LoanCardNo "+
					  	" from CUSTOMER_INFO CI   where CustomerID in (select customerID from CHECK_Frequency where "+
					  	"(FinishFrequencyDate is not null and FinishFrequencyDate<>'') and ((CheckTime is null or CheckTime ='') "+
					  	"or( NextCheckTime is not null and NextCheckTime <>'' and  NextCheckTime<='"+StringFunction.getToday()+"'  ))"+
					  	" and CheckFrequency <>'0' ) and (CustomerType like '01%' or CustomerType like '03%') "+
					  	" and CustomerID in(Select CustomerID from Customer_Belong where BelongAttribute='1' and UserID='"+CurUser.UserID+"')";

		//��SQL������ɴ������
		doTemp = new ASDataObject(sSql2);
		//���ÿɸ��µı�
		doTemp.UpdateTable = "CUSTOMER_INFO";
		//���ùؼ���
		doTemp.setKey("CustomerID",true);
		doTemp.setHeader(sHeaders2);
		//���ò��ɼ���
		doTemp.setVisible("CustomerID",false);
		
		//����html��ʽ
		doTemp.setHTMLStyle("CustomerName"," style={width:250px} ");
		
		doTemp.setColumnAttribute("CustomerName,CertID","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

  	}
  	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
  	dwTemp.Style="1";      //����ΪGrid���
  	dwTemp.ReadOnly = "1"; //����Ϊֻ��
  
  
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
		{"true","","Button","�ͻ�������Ϣ","�鿴�ͻ�������Ϣ","viewCustomer()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
 
    /*~[Describe=�鿴�ͻ�����;InputParam=��;OutPutParam=��;]~*/
	function viewCustomer()
	{
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");
        if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			openObject("Customer",sCustomerID,"001");
		}
    		
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