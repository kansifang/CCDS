<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: XWu 2004-11-29
*	Tester:
*	Describe: �ͻ����й�Ʊ��Ϣ�б�;
*	Input Param:
*		CustomerID���ͻ����
*	Output Param:     
*        CustomerID��--��ǰ�ͻ����
*		 SerialNo:	--������Ϣ��ˮ��
*		 EditRight:--Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "���й�Ʊ��Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sEditRight;

	//���ҳ�����

	//����������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {	
							{"SerialNo","��Ϣ��ˮ��"},				
							{"CertificateType","�ɶ�����֤����"},
							{"UpToDate","�����������"},  
							{"CertificateNo","��Ʊ����"},
							{"StockName","��Ʊ����"},
							{"StockType","��Ʊ����"},
							{"StockAmount","��Ʊ����"},
							{"StockCurrency","��Ʊ����"},
							{"MarketValue","��Ʊ��ֵ"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputUserName","�Ǽ���"},
							{"InputDate","�Ǽ�����"},
							{"UpdateDate","��������"},
							{"Remark","��ע"}
						};

	String sSql = " Select SerialNo, " +
				" CertificateType, " +
				" UpToDate, " +
				" CertificateNo, " +
				" StockName, " +
				" getItemName('StockType',StockType) as StockType, " +
				" StockAmount, " +
				" getItemName('Currency',StockCurrency) as StockCurrency, " +
				" MarketValue, " +				
				" InputOrgID,getOrgName(InputOrgID) as InputOrgName, " +
				" InputUserID,getUserName(InputUserID) as InputUserName, " +
				" InputDate, " +
				" UpdateDate, " +
				" Remark " +
				" from CUSTOMER_STOCK " +
				" Where CustomerID = '"+sCustomerID+"'";	  

	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("SerialNo,CertificateType,InputUserID,InputOrgID,Remark,UpdateDate",false);
	doTemp.UpdateTable = "CUSTOMER_STOCK";

	doTemp.setType("MarketValue,StockAmount","Number");
	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("MarketValue","2");
	doTemp.setCheckFormat("StockAmount","5");
	
	doTemp.setAlign("CertificateType,CertificateNo,StockName,StockType,UpToDate,InputDate,UpdateDate,StockType,StockCurrency","2");
	doTemp.setHTMLStyle("CertificateNo,CertificateType,StockCurrency,StockType,StockName"," style={width:80px} ");
	doTemp.setHTMLStyle("StockName"," style={width:300px} ");
	doTemp.setHTMLStyle("UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate"," style={width:80px} ");
	doTemp.setCheckFormat("UpdateDate,InputDate","3");
    doTemp.setHTMLStyle("InputOrgName","style={width:200px}"); 	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));


	String sCriteriaAreaHTML = ""; //��ѯ����ҳ�����
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
		{"true","","Button","����","�����ͻ����й�Ʊ��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴�ͻ����й�Ʊ��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���ͻ����й�Ʊ��Ϣ","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>

<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
<script language=javascript>

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{		
		OpenPage("/CustomerManage/EntManage/EntHoldStockInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
	  	sUserID=getItemValue(0,getRow(),"InputUserID");  
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(sUserID=='<%=CurUser.UserID%>')
		{
    		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
    		{	
    			as_del('myiframe0');
    			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
    		}
		}else alert(getHtmlMessage('3'));
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
	 	sUserID=getItemValue(0,getRow(),"InputUserID");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01';
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/CustomerManage/EntManage/EntHoldStockInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight,"_self","");
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

<%@include file="/IncludeEnd.jsp"%>
