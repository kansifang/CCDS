<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: fbkang 2005-7-26
		Tester:
		Describe: --����Ӫ��ҵ����б�;
		Input Param:
			CustomerID��--��ǰ�ͻ����
		Output Param:
			CustomerID��--��ǰ�ͻ����
			SerialNo:   --��ǰ��ˮ��
			EditRight:--Ȩ�޴��루01���鿴Ȩ��02��ά��Ȩ��
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����Ӫ��ҵ����б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
    String sSql="";//--���sql���
    
	//���ҳ�����
	
	//�������������ͻ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {	
							{"SerialNo","��ˮ��"},
							{"CertName","�漰��ҵ����"},
							{"CertID","������ҵ��Ӫ���֤����"},
							{"OrgName","�Ǽǻ���"},
							{"UserName","�Ǽ���"}
						  };

	      sSql =	" select CustomerID,SerialNo,CertID,CertName," +
					" InputOrgID,getOrgName(InputOrgID) as OrgName,InputUserID,getUserName(InputUserID) as UserName " +
					" from ENT_AUTH " +
					" where CustomerID='"+sCustomerID+"' "+
					" and CertType='02' ";


	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//�����޸ı���
	doTemp.UpdateTable = "ENT_AUTH";
    //����������
	doTemp.setKey("CustomerID,SerialNo",true);
	//���ò��ɼ���
	doTemp.setVisible("CustomerID,SerialNo,InputOrgID,InputUserID",false);
	//���ò����޸���
	doTemp.setUpdateable("UserName,OrgName",false);
	//�����п�
	doTemp.setHTMLStyle("UserName"," style={width:80px} ");
	doTemp.setHTMLStyle("CertID"," style={width:150px} ");
	doTemp.setHTMLStyle("OrgName","style={width:200px}");
	

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
		{"true","","Button","����","��������Ӫ���","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴����Ӫ���","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ������Ӫ���","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>

	//---------------------���尴ť�¼�--------------------------//
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/EspecialAuthInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
	    sUserID=getItemValue(0,getRow(),"InputUserID");//--�û�����
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--�ͻ�����
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
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
	 	sUserID=getItemValue(0,getRow(),"InputUserID");//--�û�����
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01';
	 	sSerialNo   = getItemValue(0,getRow(),"SerialNo");//--��ǰ��ˮ����
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");//--�ͻ�����
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenPage("/CustomerManage/EntManage/EspecialAuthInfo.jsp?CustomerID="+sCustomerID+"&SerialNo="+sSerialNo+"&EditRight="+sEditRight, "_self","");
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
