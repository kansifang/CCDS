<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jytian 2004-12-02
		Tester:
		Describe: �����ʲ����
		Input Param:
			CustomerID����ǰ�ͻ����
		Output Param:
			CustomerID����ǰ�ͻ����
			SerialNo:	��ˮ��
			EditRight:Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ����"; // ��������ڱ��� <title> PG_TITLE </title>
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
	String sHeaders[][] = 	{
								{"UpToDate","ͳ�ƽ�ֹ����"},		
								{"ASSETTYPE","�ʲ�����"},
								{"ASSETNAME","�ʲ�����"},
								{"AUTHORG","��֤����"},
								{"EVALUATEVALUE","������ֵ(Ԫ)"},
								{"OrgName","�Ǽǻ���"},
								{"UserName","�Ǽ���"},
								{"INPUTDATE","�Ǽ�����"},
								{"UPDATEDATE","��������"},
					      	};

	String sSql =	" select CustomerID,SerialNo,UpToDate,getItemName('ImmaterialAssetType',ASSETTYPE) as ASSETTYPE, "+
					" ASSETNAME,AUTHORG,EVALUATEVALUE,InputOrgID,getOrgName(InputOrgID) as OrgName,InputUserID, "+
					" getUserName(InputUserID) as UserName,INPUTDATE,UPDATEDATE" +
					" from CUSTOMER_IMASSET " +
					" where CustomerID='"+sCustomerID+"' ";


	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ��µı�
	doTemp.UpdateTable = "CUSTOMER_IMASSET";
	//���ùؼ���
	doTemp.setKey("CustomerID,SerialNo",true);
	doTemp.setVisible("CustomerID,SerialNo,InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName",false);
	doTemp.setAlign("ASSETNAME,AUTHORG","1");
	doTemp.setAlign("UpToDate,ASSETTYPE,OrgName,UserName,INPUTDATE,UPDATEDATE","2");
	doTemp.setCheckFormat("UpToDate,INPUTDATE,UPDATEDATE","3");
	doTemp.setHTMLStyle("OrgName" ,"style={width:200px} ");	
	doTemp.setHTMLStyle("UserName,UpToDate,INPUTDATE,UPDATEDATE"," style={width:80px} ");
	doTemp.setHTMLStyle("OrgName"," style={width:200px} ");	
	//����С����ʾ״̬,
	doTemp.setAlign("EVALUATEVALUE","3");
	doTemp.setType("EVALUATEVALUE","Number");
	//С��Ϊ2������Ϊ5
	doTemp.setCheckFormat("EVALUATEVALUE","2");

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
		{"true","","Button","����","���������ʲ����","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴�����ʲ����","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ�������ʲ����","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/IndManage/ImmaterialAssetInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sUserID=getItemValue(0,getRow(),"InputUserID");//--�û�����
		sCustomerID = getItemValue(0,getRow(),"CustomerID");
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else if(sUserID=='<%=CurUser.UserID%>')
		{
    		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
    		}	
    	}else
        	alert(getHtmlMessage('3'));	
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sUserID=getItemValue(0,getRow(),"InputUserID");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01';
		sSerialNo   = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else
		{
			OpenPage("/CustomerManage/IndManage/ImmaterialAssetInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight, "_self","");
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