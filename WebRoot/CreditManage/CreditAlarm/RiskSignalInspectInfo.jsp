<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   zywei 2006/03/27
		Tester:
		Content: Ԥ���źż�鱨����Ϣ_info
		Input Param:
			  ObjectType:��������
			  ObjectNo��������   
		Output param:
		       
		History Log: 
		       
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ԥ���źż�鱨����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	//����������

	//���ҳ�����	
	String sObjectType =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sEditRight =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("EditRight"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sEditRight == null) sEditRight = "02";
	//	��ȡԤ���źż�鱨����ˮ��
	String sSerialNo = Sqlca.getString("select SerialNo from INSPECT_INFO where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"'");
	if(sSerialNo == null) sSerialNo = "";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%		
	String[][] sHeaders = {
							{"Opinion1","ҵ��"},
							{"Opinion2","��״/����"},
							{"Opinion3","�����ж����"},
							{"Opinion4","������"},							
							{"Remark","��ע"},
							{"InspectOrgName","������"},
							{"InspectUserName","�����"},
							{"InspectDate","���ʱ��"},
							{"UpdateDate","����ʱ��"}
						};
		
	sSql =  " select SerialNo,ObjectType,ObjectNo,InspectType,UptoDate, "+
			" Opinion1,Opinion2,Opinion3,Opinion4,Remark,InspectOrgID, "+
			" getOrgName(InspectOrgID) as InspectOrgName,InspectUserID, "+
			" getUserName(InspectUserID) as InspectUserName,InspectDate, "+
			" InputOrgID,InputUserID,InputDate,FinishDate "+
			" from INSPECT_INFO "+
			" where ObjectType = '"+sObjectType+"' "+
			" and ObjectNo = '"+sObjectNo+"' ";
			
	//ͨ��SQL������ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable="INSPECT_INFO";
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);

	//����ֻ������
	doTemp.setReadOnly("Opinion1,Opinion2,Opinion3,Opinion4,Remark,InspectOrgName,InspectUserName,InspectDate",true);
	//if(sSerialNo.equals(""))doTemp.setReadOnly("Opinion1,Opinion2,Opinion3,Opinion4,Remark",false);
	if(sEditRight.equals("01"))doTemp.setReadOnly("Opinion1,Opinion2,Opinion3,Opinion4,Remark",false);
	//���ñ�������
	doTemp.setRequired("Opinion1,Opinion2",true);
	//���ò��ɼ�����
	doTemp.setVisible("SerialNo,ObjectType,ObjectNo,InspectType,UptoDate,InspectOrgID",false);
	doTemp.setVisible("InspectUserID,InputOrgID,InputUserID,InputDate,FinishDate",false);
	//���ò��ɸ���
	doTemp.setUpdateable("InspectOrgName,InspectUserName",false);
	//���ø�ʽ
	doTemp.setHTMLStyle("InspectOrgName","style={width:250px}");	
	doTemp.setHTMLStyle("InspectUserName,InspectDate,UpdateDate"," style={width:80px;} ");
	doTemp.setHTMLStyle("Opinion1,Opinion2,Opinion3,Opinion4,Remark"," style={height:100px;width:400px;overflow:scroll} ");
 	doTemp.setLimit("Opinion1,Opinion2,Opinion3,Opinion4,Remark",100);
 	doTemp.setEditStyle("Opinion1,Opinion2,Opinion3,Opinion4,Remark","3");
 	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
		
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	
	//��ȡ����ֹ����
	String sUpToDate = Sqlca.getString("select NextCheckDate from RISKSIGNAL_OPINION where SerialNo = '"+sObjectNo+"'");
	if(sUpToDate == null) sUpToDate = "";
	
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
			{(sEditRight.equals("01")?"true":"false"),"","Button","����","����Ԥ����鱨�����Ϣ","saveRecord()",sResourcesPath},		
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
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);
		
	}
			
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		if("<%=CurComp.ID%>"=="RiskSignalReport")
		{
			self.close();
		}
		else if("<%=CurComp.ID%>"=="RiskSignalCheckList")
		{
			OpenPage("/CreditManage/CreditAlarm/RiskSignalCheckList.jsp","_self","");
		}
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	
	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();//��ʼ����ˮ���ֶ�				
		bIsInsert = false;
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
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"InspectType","05");  //01���״μ�飻02�����ڼ�飻03�������ڼ�飻04��ר���飻05��Ԥ���źż��
			setItemValue(0,0,"UptoDate","<%=sUpToDate%>");			
			setItemValue(0,0,"InspectUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InspectUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InspectOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InspectOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");			
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InspectDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"FinishDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;			
		}		
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "INSPECT_INFO";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "AL";//ǰ׺

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
