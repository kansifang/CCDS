<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: XWu 2004-11-29
*	Tester:
*	Describe: �ͻ�����ծȯ��Ϣ�б�;
*	Input Param:
*		CustomerID��--��ǰ�ͻ����
*		SerialNo:	--������Ϣ��ˮ��
*		EditRight:--Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
*	Output Param:     
*        
*	HistoryLog:
*/
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����ծȯ��Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//���ҳ�����
	
	//����������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {	
							{"SerialNo","��Ϣ��ˮ��"},
							{"UpToDate","�����������"},
							{"BondType","ծȯ����"},
							{"BondName","ծȯ����"},
							{"BondCurrency","����"},
							{"BondAmount","ծȯ����"},
							{"BondSum","�����ܼ۸�"},
							{"BeginDate","ծȯ��ʼ����"},
							{"EndDate","ծȯ��������"},
							{"SaleDate","����(�Ҹ�)����"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputUserName","�Ǽ���"},
							{"InputDate","�Ǽ�����"},
							{"UpdateDate","��������"},
							{"Remark","��ע"}
						   };
	
	String sSql = 	" Select SerialNo, " +
					" UpToDate, " +				
					" getItemName('BondType',BondType) as BondType, " +
					" BondName, " +
					" getItemName('Currency',BondCurrency) as BondCurrency, " +
					" BondAmount, " +
					" BondSum, " +
					" BeginDate, " +
					" EndDate, " +
					" SaleDate, " +
					" InputOrgID,getOrgName(InputOrgID) as InputOrgName, " +
					" InputUserID,getUserName(InputUserID) as InputUserName, " +
					" InputDate, " +
					" UpdateDate, " +
					" Remark " +
					" from CUSTOMER_BOND " +
					" Where CustomerID = '"+sCustomerID+"'";	  

	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//���ùؼ���
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("SerialNo,Remark,UpdateDate,BondAmount,SaleDate,InputOrgID,InputUserID",false);
	doTemp.UpdateTable = "CUSTOMER_BOND";

	doTemp.setType("BondSum,BondAmount","Number");
	//����
	doTemp.setAlign("DondName,BondSum,BondAmount","3");
	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("BondSum","2");
	doTemp.setCheckFormat("BondAmount","5");
	//����
	doTemp.setAlign("BondType,BondName,BondCurrency,InputUserName,UpToDate,InputDate,UpdateDate,BondType,BondCurrency","2");
	doTemp.setHTMLStyle("BondCurrency,BondType,BondAmount"," style={width:80px} ");
	doTemp.setHTMLStyle("BondName"," style={width:300px} ");
	doTemp.setHTMLStyle("UpToDate,InputOrgID,InputUserID,InputDate,UpdateDate"," style={width:80px} ");
	doTemp.setCheckFormat("UpdateDate,InputDate,BeginDate,EndDate,SaleDate","3");
    doTemp.setHTMLStyle("InputOrgName","style={width:200px}"); 	
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
		{"true","","Button","����","�����ͻ�����ծȯ��Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴�ͻ�����ծȯ��ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���ͻ�����ծȯ��Ϣ","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/EntHoldBondInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
	  	sUserID=getItemValue(0,getRow(),"InputUserID");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
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
			return;
		}else
		{
			OpenPage("/CustomerManage/EntManage/EntHoldBondInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight,"_self","");
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
