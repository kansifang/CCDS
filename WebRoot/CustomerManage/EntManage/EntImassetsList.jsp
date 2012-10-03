<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: XWu 2004-11-29
*	Tester:
*	Describe: �ͻ������ʲ���Ϣ�б�;
*	Input Param:
*		CustomerID���ͻ����
*	Output Param:     
*       CustomerID��--��ǰ�ͻ����
*		SerialNo:	--������Ϣ��ˮ��
*		EditRight:--Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ�� 
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�����ʲ��б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	String sSql ="";

	//���ҳ�����

	//����������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = { 
							{"CustomerID","���˱��"},
							{"SerialNo","��ˮ��"},
							{"AssetTypeName","�ʲ�����"},
							{"AuthNo","֤����"},
							{"AssetDescribe","�ʲ�����"},
							{"AuthOrg","��֤����"},
							{"AuthDate","��֤����"},
							{"AccountValue","���ʼ�ֵ(Ԫ)"},
							{"UpToDate","ͳ�ƽ�ֹ����"},
							{"OrgName","�Ǽǵ�λ"},
							{"UserName","�Ǽ���"},
							{"InputDate","�Ǽ�����"},
							{"UpdateDate","��������"},
							{"AssetName","�ʲ�����"}
						  };

		sSql =	" select CustomerID,SerialNo,AssetType,getItemName('ImmaterialAssetType',AssetType) as AssetTypeName,"+
				" AssetName,AuthNo,AssetDescribe,AuthOrg,AuthDate,AccountValue,UpToDate,"+
				" InputOrgID,getOrgName(InputOrgID) as OrgName," +
				" InputUserID,getUserName(InputUserID) as UserName," +
				" InputDate,UpdateDate"+
				" from CUSTOMER_IMASSET"+
				" where CustomerID='"+sCustomerID+"'"+
				" order by CustomerID";


	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.setUpdateable("AssetTypeName,OrgName,UserName",false);
	
	doTemp.setAlign("AccountValue","3");
	doTemp.setAlign("AuthDate,UpToDate,InputDate,UpdateDate,AssetTypeName","2");
	
	doTemp.setHTMLStyle("AuthDate,UpToDate,InputDate,UpdateDate"," style={width:70px} ");
	doTemp.setHTMLStyle("AssetName,AuthOrg"," style={width:150px} ");
	doTemp.setCheckFormat("UpdateDate,InputDate","3");
    doTemp.setHTMLStyle("OrgName","style={width:200px}"); 	
	doTemp.UpdateTable="CUSTOMER_IMASSET";
	
	doTemp.setKey("CustomerID,SerialNo",true);
	doTemp.setVisible("InputUserID",false);
	doTemp.setUpdateable("UserName",false);		
	doTemp.setCheckFormat("UpToDate,InputDate,UpdateDate","3");	
	doTemp.setCheckFormat("AccountValue","2");
	doTemp.setType("AccountValue","Number");
	
	doTemp.setVisible("CustomerID,SerialNo,InputUserID,InputOrgID,AssetType,AuthDate,AuthNo,AssetDescribe,UpToDate",false);

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
		{"true","","Button","����","�����ͻ������ʲ���Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴�ͻ������ʲ���ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���ͻ������ʲ���Ϣ","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/EntImassetsInfo.jsp?EditRight=02","_self","");
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
			OpenPage("/CustomerManage/EntManage/EntImassetsInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight,"_self","");
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
