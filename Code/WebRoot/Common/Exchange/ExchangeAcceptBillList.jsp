<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: fxie 2005-04-25
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
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sPerPutOutNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PerPutOutNo"));
	String sPutOutSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("PutOutSerialNo"));
	String sExchangeState = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ExchangeState"));
	
	if (sObjectType==null) sObjectType="";
	if (sPerPutOutNo==null) sPerPutOutNo="";
	if (sPutOutSerialNo==null) sPutOutSerialNo="";
	if (sExchangeState==null) sExchangeState="";
	
	String sObjectNo = "";
	String sSqlNo = "select ContractSerialNo from business_putout where serialno=(Select RelativePutoutNo from business_putout where serialno='"+sPutOutSerialNo+"')";
    sObjectNo = Sqlca.getString(sSqlNo);   
    if (sObjectNo==null) sObjectNo="";
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%


	String sHeaders[][] = {	{"InterSerialNo","�������"},
							{"GatheringName","�տ��˻���"},
							{"AccountNo","�տ����˺�"},
							{"AboutBankID","�տ����к�"},
							{"AboutBankName","�տ�������"},
							{"BillSum","���(Ԫ)"},
							{"UserName","�Ǽ���"},
	                        {"OrgName","�Ǽǻ���"}
	                       }; 


	String sSql = " select ObjectNo,ObjectType,SerialNo,InterSerialNo,"+
				  " GatheringName,AccountNo,AboutBankID,AboutBankName,BillSum,"+
				  " getUserName(InputUserID) as UserName,getOrgName(InputOrgID) as OrgName "+
				  " from BILL_INFO where RelativePutoutNo = '"+sPutOutSerialNo+"'";


	//��SQL������ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "BILL_INFO";
	doTemp.setKey("SerialNo,ObjectNo,ObjectType",true);	 //Ϊ�����ɾ��
	//���ò��ɼ���
	doTemp.setVisible("SerialNo,ObjectNo,ObjectType",false);
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
		{"false","","Button","����","����Ʊ����Ϣ","newRecord()",sResourcesPath},
		{"true","","Button","����","�鿴Ʊ������","viewAndEdit()",sResourcesPath},
		{"false","","Button","ɾ��","ɾ��Ʊ����Ϣ","deleteRecord()",sResourcesPath},
		};
		
	if (sExchangeState.equals("1")){
		sButtons[0][0] = "true";
		sButtons[1][0] = "true";
		sButtons[2][0] = "true";
	}
	%>
<%/*~END~*/%>




<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	
	/*~[Describe=������¼;InputParam=��;OutPutParam=��;]~*/
	function newRecord()
	{
		OpenPage("/Common/Exchange/ExchangeAcceptBillInfo.jsp?ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&PerPutOutNo=<%=sPerPutOutNo%>&PutOutSerialNo=<%=sPutOutSerialNo%>&ExchangeState=<%=sExchangeState%>","_self","");
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
	
	function viewAndEdit()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		sObjectType = getItemValue(0,getRow(),"ObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
		}
		else 
		{
			OpenPage("/Common/Exchange/ExchangeAcceptBillInfo.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType+"&PutOutSerialNo=<%=sPutOutSerialNo%>&PerPutOutNo=<%=sPerPutOutNo%>&ExchangeState=<%=sExchangeState%>", "_self","");
				
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
