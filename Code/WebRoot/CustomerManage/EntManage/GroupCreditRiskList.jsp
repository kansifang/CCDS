<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hldu 2012-06-15
		Tester:
		Describe: �������ŷ����޶�;     
		HistoryLog:			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ŷ����޶�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
     String sSql = "";//--���sql���
	//���ҳ�����

	//�������������ͻ�����
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = { 
		                    {"CustomerID","�ͻ����"},
		                    {"CustomerName","�ͻ�����"},
		                    {"CreditAuthSum","���Ŷ���޶�"},
		                    {"Currency","����"}, 
		                    //{"CurrencyName","����"}, 
		                    {"BeganDate","��ʼ��"},
		                    {"EndDate","������"},
		                    {"InputOrgID","�Ǽǻ���"},
		                    {"InputUserID","�Ǽ���"},
		                    {"InputDate","�Ǽ�����"},						
		                    {"UpdateDate","��������"}
						  };

	 sSql =	" select SERIALNO,OBJECTNO as CustomerID,getCustomerName(OBJECTNO) as CustomerName, " +
	        " COGNSCORE as CreditAuthSum,getItemName('Currency',MODELNO) as Currency,FINISHDATE as BeganDate, " +
	        " FINISHDATE2 as EndDate,ORGID as InputOrgID,USERID as InputUserID,FINISHDATE3 as InputDate, " +
	        " FINISHDATE4 as UpdateDate from EVALUATE_RECORD where OBJECTNO = '"+sCustomerID+"' and OBJECTTYPE = 'GroupCreditRisk' ";
    

	//��sSql�������ݴ������
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	//�����޸ĵı�
	doTemp.UpdateTable = "EVALUATE_RECORD";
    //��������ֵ
	doTemp.setKey("CustomerID,RelativeID,RelationShip",true);
	//���ò��ɼ�
	doTemp.setVisible("CustomerID,RelativeID,RelationShip,SERIALNO",false);
	//���ò����޸���
	doTemp.setUpdateable("UserName,OrgName,RelationName",false);
    //����������
	doTemp.setType("InvestmentProp,OughtSum,InvestmentSum","Number");
	//�����еĿ��,
	doTemp.setHTMLStyle("CurrencyTypeName,InvestDate,InvestmentProp"," style={width:80px} ");
    doTemp.setHTMLStyle("OrgName"," style={width:200px} ");  
    doTemp.setHTMLStyle("CustomerName"," style={width:200px} "); 
    doTemp.setHTMLStyle("UserName"," style={width:100px} "); 
    doTemp.setHTMLStyle("EffStatus"," style={width:30px} "); 
	doTemp.setAlign("RelationShipName,CurrencyTypeName,UserName","2");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��

	//����setEvent
	dwTemp.setEvent("AfterDelete","!CustomerManage.DeleteRelation(#CustomerID,#RelativeID,#RelationShip)");

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
			{"true","","Button","����","�����ʱ�����","newRecord()",sResourcesPath},
			{"true","","Button","����","�鿴�ʱ���������","viewAndEdit()",sResourcesPath},
			{"true","","Button","ɾ��","ɾ���ʱ�����","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/GroupCreditRiskInfo.jsp?","_self","");
	}

	/*~[Describe=ɾ����¼;InputParam=��;OutPutParam=��;]~*/
	function deleteRecord()
	{
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--�ͻ�����
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else 
		{
    		if(confirm(getHtmlMessage('2')))//�������ɾ������Ϣ��
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //�������ɾ������Ҫ���ô����
    		}
		}
	}

	/*~[Describe=�鿴���޸�����;InputParam=��;OutPutParam=��;]~*/
	function viewAndEdit()
	{      
	    sSerialNo = getItemValue(0,getRow(),"SERIALNO");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//��ѡ��һ����Ϣ��
			return;
		}else
		{
			OpenPage("/CustomerManage/EntManage/GroupCreditRiskInfo.jsp?SerialNo="+sSerialNo, "_self","");
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
