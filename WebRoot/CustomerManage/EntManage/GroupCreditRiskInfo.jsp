<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: hldu
		Tester:
		Describe: �������ŷ����޶�; 
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�������ŷ����޶�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
    String sSql = "";
    String sRelativeID = "";
    String sEditRight = "";
	//�������������ͻ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sCustomerID    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
	String sCustomerName = Sqlca.getString("select getCustomerName('"+sCustomerID+"') from (values 1) as a");
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders[][] = { 
		                     {"OBJECTTYPE","GroupCreditRisk"},
                             {"SERIALNO","��ˮ��"},
	                         {"OBJECTNO","�ͻ����"},
	                         {"CustomerName","�ͻ�����"},
	                         {"CreditAuthSum","���Ŷ���޶�"},
	                         {"Currency","����"},     
	                         {"BeganDate","��ʼ��"},
	                         {"EndDate","������"},
	                         {"InputOrgId","�Ǽǻ���"},
	                         {"InputOrgID","�Ǽǻ���"},
	                         {"InputUserId","�Ǽ���"},
	                         {"InputUserID","�Ǽ���"},
	                         {"InputDate","�Ǽ�����"},						
	                         {"UpdateDate","��������"}
			              };

	sSql =	" select OBJECTTYPE,SERIALNO,OBJECTNO,getCustomerName(OBJECTNO) as CustomerName, " +
		    " COGNSCORE as CreditAuthSum,MODELNO as Currency,FINISHDATE as BeganDate, " +
		    " FINISHDATE2 as EndDate,ORGID as InputOrgID,USERID as InputUserID,FINISHDATE3 as InputDate, " +
		    " FINISHDATE4 as UpdateDate from EVALUATE_RECORD where OBJECTNO = '"+sCustomerID+"' and OBJECTTYPE = 'GroupCreditRisk' and SERIALNO = '"+sSerialNo+"' ";

	//��sSql���ɴ������
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ,���±���,��ֵ,������,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp.setHeader(sHeaders);
	doTemp.setDefaultValue("OBJECTTYPE,SERIALNO","GroupCreditRisk");
	doTemp.UpdateTable = "EVALUATE_RECORD";
	doTemp.setKey("OBJECTNO,SERIALNO,SERIALNO",true);
	doTemp.setVisible("OBJECTTYPE,SERIALNO",false);
	doTemp.setUpdateable("CustomerName",false);
	doTemp.setCheckFormat("BeganDate,EndDate","3");
	//doTemp.setUnit("CreditAuthSum","Ԫ");
	doTemp.setType("CreditAuthSum","Number");
	doTemp.setRequired("CreditAuthSum,Currency,BeganDate,EndDate",true);
	doTemp.setHTMLStyle("CustomerName"," style={width:80px} ");
	doTemp.setHTMLStyle("InputUserId,InputUserId","style={width:300px}");
	doTemp.setHTMLStyle("CustomerName,Describe,OrgName"," style={width:200px}");
	doTemp.setHTMLStyle("InputOrgID,InputUserID,UpdateDate,InputDate,"," style={width:100px}");	
	doTemp.setReadOnly("OBJECTNO,CustomerName,InputOrgID,InputUserID,InputDate,UpdateDate",true);
	doTemp.setHTMLStyle("OrgName","style={width:400px}");

	//����������
	doTemp.setDDDWSql("Currency","select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'Currency' ");
	//����Ĭ��ֵ
	
	doTemp.setUnit("Describe"," <input type=button class=inputdate value=.. onclick=parent.selectEntCustomer()><font color=red>(�����ѡ)</font>");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform
	if(sEditRight.equals("01"))
	{
		dwTemp.ReadOnly="1";
		doTemp.appendHTMLStyle(""," style={color:#848284} ");
	}
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
	<%
	//����Ϊ:
		//0.�Ƿ���ʾ
		//1.ע��Ŀ�������(Ϊ�����Զ�ȡ��ǰ���)
		//2.����(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
		//3.��ť����
		//4.˵������
		//5.�¼�
		//6.��ԴͼƬ·��
	String sButtons[][] = {
			{"true","","Button","����","���������޸�","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��

	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		//¼��������Ч�Լ��		
		
		
		if(bIsInsert){
			//����ǰ���м��,���ͨ�����������,���������ʾ			
		    // if (!RelativeCheck()) return;
			beforeInsert();
			//��������,���Ϊ��������,�����ҳ��ˢ��һ��,��ֹ�������޸�
			beforeUpdate();
			as_save("myiframe0","pageReload()");
			return;
		}

		beforeUpdate();		
		as_save("myiframe0",sPostEvents);
	}

	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/GroupCreditRiskList.jsp?","_self","");
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>
	<script language=javascript>
	/*~[Describe=��������ҳ��ˢ�¶���;InputParam=��;OutPutParam=��;]~*/
	function pageReload()
	{
		sSerialNo = getItemValue(0,getRow(),"SERIALNO");//--���»����ˮ��
		OpenPage("/CustomerManage/EntManage/GroupCreditRiskInfo.jsp?SerialNo="+sSerialNo+"", "_self","");
	}
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
	    initSerialNo() ;    
	}

	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}

	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			bIsInsert = true;
			setItemValue(0,0,"OBJECTNO","<%=sCustomerID%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			setItemValue(0,0,"InputUserId","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserName%>");
		
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			
		}
	}
	
	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{	
	   return true;	
	}
	
    /*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "EVALUATE_RECORD";//����
		var sColumnName = "SERIALNO";//�ֶ���
		var sPrefix = "ER";//ǰ׺
       
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>