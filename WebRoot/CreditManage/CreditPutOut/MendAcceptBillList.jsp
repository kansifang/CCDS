<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
		Describe: �ж�Ʊ����Ϣ
		Input Param:
			ObjectType: �׶α��
			ObjectNo:
			SerialNo��ҵ����ˮ��
		Output Param:
			SerialNo��ҵ����ˮ��
		
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ж�Ʊ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����

	//����������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%


	String sHeaders[][] = {	{"ObjectType","��������"},
							{"ObjectNo","������ͬ��"},
							{"ReDueBillNo","������ݺ�"},
							{"SerialNo","��ˮ��"},
							{"BillNo","�жһ�Ʊ���"},
							{"BillSum","��Ʊ���(Ԫ)"},
							{"Acceptor","������ȫ��"},
							{"Writer","��Ʊ��ȫ��"},
							{"AccountNo","��Ʊ���˺�"},
							{"Beneficiary","�տ���ȫ��"},
							{"Maturity","Ʊ�ݵ�����"},
							{"InterSerialNo","�ж�Э����"},
							{"BillSum","���(Ԫ)"},
							{"UserName","�Ǽ���"},
	                        {"OrgName","�Ǽǻ���"}
	                       }; 


	String sSql = " select ObjectType,ObjectNo,ReDueBillNo,SerialNo,BillNo,"+
				  " BillSum,Acceptor,Writer,AccountNo,Beneficiary,Maturity,InterSerialNo,"+
				  " getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName "+
				  " from BILL_INFO ";
		sSql+=" where ObjectNo = '"+sObjectNo+"' ";


	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BILL_INFO";
	doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	 //Ϊ�����ɾ��
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectType",false);
	//���ò��ɼ���
	doTemp.setVisible("InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName",false);
	doTemp.setHTMLStyle("InterSerialNo,AboutBankID,UserName"," style={width:80px} ");
	doTemp.setType("BillSum","number");
	doTemp.setAlign("BillSum","3");

	//����datawindow
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
		{"true","","Button","����","����Ʊ����Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴Ʊ������","viewAndEdit()",sResourcesPath},
		{"true","","Button","ɾ��","ɾ��Ʊ����Ϣ","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/CreditManage/CreditPutOut/MendAcceptBillInfo.jsp?","_self","");
	}


	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
		{
			as_del('myiframe0');
			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
		}
	}
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else 
		{
				OpenPage("/CreditManage/CreditPutOut/MendAcceptBillInfo.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&SerialNo="+sSerialNo, "_self","");
				
		}
	}

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		as_save("myiframe0",sPostEvents);
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