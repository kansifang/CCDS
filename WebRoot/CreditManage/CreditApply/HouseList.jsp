<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: xhyong 2011/06/10
		Tester:
		Describe: ������Ϣ�б�
		Input Param:
			ObjectType: �׶α��
			ObjectNo:
			SerialNo��ҵ����ˮ��
		Output Param:
			SerialNo��ҵ����ˮ��
			DeleteRelative
		HistoryLog:
	 */
	%>
<%/*~END~*/%>





<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "������Ϣ�б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������:������
	String sRelativeTable="CONTRACT_RELATIVE";
	//���ҳ�����

	//����������
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));

	if(sObjectType.equals("CreditApply")){ 
		sRelativeTable = "Apply_RELATIVE";
	}else{
		sRelativeTable = "CONTRACT_RELATIVE";
	}
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%


	String sHeaders[][] = {	{"HouseContractNo","������ͬЭ����"},
							{"ItemName","������Ŀ����"},
							{"BuildArea","�������"},
							{"HousePrice","�����ۼ�"},
							{"SelfPrice","�Գ��ʽ��"},
							{"EvaluateValue","�����۸�"},
							{"BudgetValue","���޷�Ԥ���ֵ"},
							{"UserName","�Ǽ���"},
	                        {"OrgName","�Ǽǻ���"}
	                       }; 


	String sSql = " select SerialNo,HouseContractNo,"+
				  " ItemName,BuildArea,HousePrice,SelfPrice,EvaluateValue,BudgetValue,"+
				  " getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName "+
				  " from House_INFO HI "+
				  " where exists (Select AR.ObjectNo from "+sRelativeTable+" AR where "+
				" AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='HouseInfo' "+
				" and AR.ObjectNo = HI.SerialNo) ";

	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "House_INFO";
	doTemp.setKey("SerialNo",true);	 
	//���ò��ɼ���
	doTemp.setVisible("SerialNo",false);
	//���ò��ɼ���
	doTemp.setVisible("InputOrgID,InputUserID",false);
	doTemp.setUpdateable("UserName,OrgName",false);
	//doTemp.setHTMLStyle("InterSerialNo,AboutBankID,UserName"," style={width:80px} ");
	doTemp.setType("HousePrice,SelfPrice,EvaluateValue,BudgetValue","number");
	doTemp.setAlign("HousePrice,SelfPrice,EvaluateValue,BudgetValue","3");

	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
	//����setEvent	
	dwTemp.setEvent("AfterDelete","!BusinessManage.DeleteRelative("+sObjectNo+",HouseInfo,#SerialNo,APPLY_RELATIVE)");

	
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
		{"false","","Button","����","����Ʊ����Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴Ʊ������","viewAndEdit()",sResourcesPath},
		{"false","","Button","ɾ��","ɾ��Ʊ����Ϣ","deleteRecord()",sResourcesPath},
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
		OpenPage("/CreditManage/CreditApply/HouseInfo.jsp","_self","");
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
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}else 
		{
			OpenPage("/CreditManage/CreditApply/HouseInfo.jsp?SerialNo="+sSerialNo, "_self","");	
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
