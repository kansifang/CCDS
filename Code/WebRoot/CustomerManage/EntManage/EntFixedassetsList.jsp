<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
<%
/*
*	Author: XWu 2004-11-29
*	Tester:
*	Describe: �ͻ��̶��ʲ���Ϣ�б�;
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
	String PG_TITLE = "�̶��ʲ���Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
	//�������
	
	//���ҳ�����

	//����������
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = {	
							{"SerialNo","��ˮ��"},
							{"CustomerID","�ͻ����"},
							{"UpToDate","�����������"},
							{"FixedAssetsType","�̶��ʲ�����"},
							{"Currency","����"},
							{"FormerValue","���ʼ�ֵ"},
							{"EvalValue","�ʲ���ֵ"},
							{"Remark","��ע"},
							{"Location","����λ��"},
							{"FixedAssetsName","�̶��ʲ�����"},
							{"CertificateNo","Ȩ��֤���"},
							{"EvalDate","��������"},
							{"EvalOrg","��������"},
							{"UseMethod","ʹ�÷�ʽ"},
							{"FixedAssetsStatus","�ʲ�״̬"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputDate","�Ǽ�����"},
							{"UpdateDate","��������"}
						  };
						  
	String sSql = 	" Select SerialNo, " +
					" CustomerID, " +
					" UpToDate, " +
					" getItemName('AssetsType',FixedAssetsType) as FixedAssetsType, " +
					" getItemName('Currency',Currency) as Currency, " +
					" FormerValue, " +
					" EvalValue, " +
					" Remark, " +
					" Location, " +
					" FixedAssetsName, " +
					" CertificateNo, " +
					" EvalDate, " +
					" EvalOrg, " +
					" UseMethod, " +
					" FixedAssetsStatus, " +
					" InputUserID, " +
					" InputOrgID, " +
					" getUserName(InputUserID) as InputUserName, "+
					" getOrgName(InputOrgID) as InputOrgName, "+
					" InputDate, " +
					" UpdateDate " +
					" from ENT_FIXEDASSETS " +
					" Where CustomerID = '"+sCustomerID+"'";	  

	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("SerialNo,CustomerID,Remark,Location,FixedAssetsName,CertificateNo,InputUserID,InputOrgID",false);
	doTemp.setVisible("EvalDate,EvalOrg,UseMethod,FixedAssetsStatus,InputDate,UpdateDate",false);
	doTemp.UpdateTable = "ENT_FIXEDASSETS";

	doTemp.setType("FormerValue,EvalValue","Number");
	//���������ͣ���Ӧ����ģ��"ֵ���� 2ΪС����5Ϊ����"
	doTemp.setCheckFormat("FormerValue,EvalValue","2");

	//doTemp.setAlign("UpToDate,InputDate,UpdateDate","2");
	doTemp.setCheckFormat("UpdateDate,InputDate","3");
    doTemp.setHTMLStyle("InputOrgName","style={width:200px}"); 			
	doTemp.setAlign("FixedAssetsType,Currency","2");
	doTemp.setHTMLStyle("UpToDate,FixedAssetsType,Currency,InputUserID,InputOrgID"," style={width:80px} ");

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
		{"true","","Button","����","�����̶��ʲ���Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴�̶��ʲ���ϸ��Ϣ","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ���̶��ʲ���Ϣ","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/EntFixedassetsInfo.jsp?EditRight=02","_self","");
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
		sUserID=getItemValue(0,getRow(),"InputUserID");//--�û�����
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
			OpenPage("/CustomerManage/EntManage/EntFixedassetsInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight,"_self","");
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
