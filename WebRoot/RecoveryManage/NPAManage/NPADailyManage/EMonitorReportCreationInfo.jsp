<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zwhu  2009.09.21
		Tester:
		Content: �����ص��ر���
		Input Param:
			ObjectNo��������
			DealType:��ͼ�ڵ��
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ص��ر���������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%
	//�Զ������
	String sCustomerName = "";
	String sCustomerID = "";
	String sBadType = "";//��������
	String sReportType = "";//��������
	//����������	���������͡��������͡��׶����͡����̱�š��׶α��
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sDealType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("DealType"));
	
	//����ֵת���ɿ��ַ���
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";	
	if(sDealType == null) sDealType = "";	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ȡ��������
	if(sDealType.length()>=12){
		//����,�ɾ��û�,����Ʊ���û�,�Ѻ�������
		if(sDealType.substring(0,9).equals("020030010"))
		{  
		    sBadType="010";
		}else if(sDealType.substring(0,9).equals("020030020"))
		{
			sBadType="020";
		}else if(sDealType.substring(0,9).equals("020030030"))
		{
			sBadType="030";
		}else if(sDealType.substring(0,9).equals("020030040"))
		{
			sBadType="040";
		}
		//һ����,�ص���
		if(sDealType.substring(9,12).equals("010"))
		{
			sReportType="010";
		}else if(sDealType.substring(9,12).equals("020")){
			sReportType="020";
		}
	}
	
	String sSql = "select CustomerID,CustomerName from BUSINESS_CONTRACT where SerialNo = '"+sObjectNo+"'";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		sCustomerName = rs.getString("CustomerName");
		sCustomerID = rs.getString("CustomerID");
	}
	rs.getStatement().close();
	//ͨ��sql����ASDataObject����doTemp
	String sHeaders[][] = {
							{"CustomerName","�ͻ�����"},
							{"ObjectNo","��ͬ��ˮ��"},
							{"ReportDate","��������"},
							{"InputUserName","�Ǽ���"},
							{"InputOrgName","�Ǽǻ���"}
						  };

	sSql =   " select SerialNo,ObjectNo,ReportDate,ReportType,BadType,"+
					" CustomerID,CustomerName,"+
					" InputUserID,getUserName(InputUserID) as InputUserName,"+
					" InputOrgID,getOrgName(InputOrgID) as InputOrgName,InputDate"+
					" from MONITOR_REPORT where SerialNo = '"+sSerialNo+"'";
	
	//����ģ�����������ݶ���	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	//��������,�ɸ��±�
	doTemp.setKey("SerialNo",true);
	doTemp.UpdateTable = "MONITOR_REPORT";
	doTemp.setUpdateable("InputUserName,InputOrgName",false);
	//���ñ��䱳��ɫ
	doTemp.setHTMLStyle("CustomerName","style={background=\"#EEEEff\"} ");
	doTemp.setHTMLStyle("ObjectNo","style={background=\"#EEEEff\"} ");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setVisible("SerialNo,CustomerID,ReportType,BadType,InputUserID,InputOrgID,InputDate",false);
	//����ֻ��
	doTemp.setReadOnly("CustomerName,ReportDate,InputUserName,InputOrgName,InputDate",true);
	doTemp.setHTMLStyle("InputOrgName"," style={width:250px} ");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//���ñ���ʱ�����������ݱ�Ķ���
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
		
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info04;Describe=���尴ť;]~*/%>
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
			{"true","","Button","ȷ��","ȷ������","doCreation()",sResourcesPath},
			{"true","","Button","ȡ��","ȡ������","doCancel()",sResourcesPath}	
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=Info05;Describe=����ҳ��;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info06;Describe=���尴ť�¼�;]~*/%>
	<script language=javascript>

	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{		
		initSerialNo();
		as_save("myiframe0",sPostEvents);		
	}
		   
    /*~[Describe=ȡ���������ŷ���;InputParam=��;OutPutParam=ȡ����־;]~*/
	function doCancel()
	{		
		top.returnValue = "_CANCEL_";
		top.close();
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>

	/*~[Describe=����һ�����������¼;InputParam=��;OutPutParam=��;]~*/
	function doCreation()
	{
		saveRecord("doReturn()");
	}
	
	/*~[Describe=ȷ��������������;InputParam=��;OutPutParam=������ˮ��;]~*/
	function doReturn(){
		sObjectNo = getItemValue(0,0,"SerialNo");
		top.returnValue = sObjectNo;
		top.close();
	}
	
	/*~[Describe=ҳ��װ��ʱ����DW���г�ʼ��;InputParam=��;OutPutParam=��;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//����һ���ռ�¼
			//��ͬ���
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");			
			//�ͻ�����
			setItemValue(0,0,"CustomerID","<%=sCustomerID%>");
			setItemValue(0,0,"CustomerName","<%=sCustomerName%>");
			//��������
			setItemValue(0,0,"ReportDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ReportType","<%=sReportType%>");//��������
			setItemValue(0,0,"BadType","<%=sBadType%>");//��������
			//�Ǽǻ���
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			//�Ǽ���
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			//�Ǽ�����			
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "MONITOR_REPORT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺
								
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info08;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //ҳ��װ��ʱ����DW��ǰ��¼���г�ʼ��
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>