<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: zywei 2006-8-18
		Tester:
		Describe: ����Ѻ�����/������Ϣ����;
		Input Param:
			SerialNo����ˮ��				
			GuarantyID������Ѻ����
			GuarantyStatus������Ѻ��״̬
		Output Param:

		HistoryLog:

	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����Ѻ�����/���������Ϣ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������	
	String sSql = "";//Sql���
	ASResultSet rs = null;//�����
	String sGuarantyName = "";//����Ѻ������
	String sGuarantyType = "";//����Ѻ������
	
	//����������������Ѻ���š�����Ѻ��״̬
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyID"));
	String sGuarantyStatus  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyStatus"));
	String sSerialNo  = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	//����ֵת��Ϊ���ַ���
	if(sGuarantyID == null) sGuarantyID = "";
	if(sGuarantyStatus == null) sGuarantyStatus = "";
	if(sSerialNo == null) sSerialNo = "";

			
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%		        
	//���ݵ���Ѻ����ȡ�õ���Ѻ�����ƺ͵���Ѻ������
	sSql = 	" select GuarantyName,GuarantyType from GUARANTY_INFO "+
		 	" where GuarantyID = '"+sGuarantyID+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next()){
		sGuarantyName = rs.getString("GuarantyName");
		sGuarantyType = rs.getString("GuarantyType");
		//����ֵת��Ϊ���ַ���
		if(sGuarantyName == null) sGuarantyName = "";
		if(sGuarantyType == null) sGuarantyType = "";
	}
	rs.getStatement().close();
	
	
	//��ʾ����	
	String[][] sHeaders = {
							{"GuarantyID","����Ѻ����"},							
							{"GuarantyName","����Ѻ������"},
							{"GuarantyType","����Ѻ������"},
							{"GuarantyStatus","����Ѻ��״̬"},	
							{"LostDate","��������"},
							{"Reason","����ԭ��"},							
							{"PlanReturnDate","Ԥ�ƻؿ�����"},
							{"FactReturnDate","ʵ�ʻؿ�����"},
							{"InputOrgName","�Ǽǻ���"},
							{"InputUserName","�Ǽ���"},
							{"InputDate","�Ǽ�����"},
							{"UpdateDate","��������"}
						  };
	
	sSql = 	" select SerialNo,GuarantyID,GuarantyName,GuarantyType, "+		
			" GuarantyStatus,LostDate,Reason,PlanReturnDate,FactReturnDate, "+
			" InputOrg,getOrgName(InputOrg) as InputOrgName,InputUser, "+	
			" getUserName(InputUser) as InputUserName,InputDate,UpdateDate "+		
			" from GUARANTY_AUDIT "+
			" where SerialNo = '"+sSerialNo+"' ";
			
	//ͨ��Sql����ASDataObject����doTemp	
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_AUDIT";
	doTemp.setKey("SerialNo",true);
	
	//����������
	doTemp.setDDDWCode("GuarantyType","GuarantyList");
	doTemp.setDDDWCode("GuarantyStatus","GuarantyStatus");
	//���ò��ɸ���
	doTemp.setUpdateable("InputOrgName,InputUserName",false);	
	//���ø�ʽ
	doTemp.setEditStyle("Reason","3");	
	doTemp.setHTMLStyle("InputOrgName","style={width:250px}");	
	doTemp.setHTMLStyle("GuarantyName","  style={width:200px}  ");
	doTemp.setHTMLStyle("GuarantyStatus","  style={width:50px}  ");
	doTemp.setHTMLStyle("Reason","  style={height:150px;width:400px}  ");
	doTemp.setLimit("Reason",200);
	doTemp.setCheckFormat("LostDate,PlanReturnDate,FactReturnDate","3");
	//�����ֶβ��ɼ�����
	doTemp.setVisible("SerialNo,InputOrg,InputUser",false);
	
	if(sGuarantyStatus.equals("03")) //��ʱ����
	{
		//���ñ�����
		doTemp.setRequired("LostDate,Reason,PlanReturnDate",true);
		//����ֻ��
		doTemp.setReadOnly("GuarantyID,GuarantyNamem,GuarantyType,GuarantyStatus,InputOrgName,InputUserName,InputDate,UpdateDate",true);
		//�����ֶβ��ɼ�����
		doTemp.setVisible("FactReturnDate",false);
	}else if(sGuarantyStatus.equals("01")) //�ٻؿ�
	{
		//���ñ�����
		doTemp.setRequired("FactReturnDate",true);
		//����ֻ��
		doTemp.setReadOnly("GuarantyID,GuarantyNamem,GuarantyType,GuarantyStatus,LostDate,Reason,PlanReturnDate,InputOrgName,InputUserName,InputDate,UpdateDate",true);
		//���õ���״̬Ϊ�����
		sGuarantyStatus="02";

	}
			
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	if(sGuarantyStatus.equals("00")) //���鿴��Ϣ
		dwTemp.ReadOnly = "1"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	else
		dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//��������¼�
	dwTemp.setEvent("AfterInsert","!BusinessManage.UpdateGuarantyStatus(#GuarantyID,"+sGuarantyStatus+")");
	dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateGuarantyStatus(#GuarantyID,"+sGuarantyStatus+")");
			
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sGuarantyID);
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
		{(!sGuarantyStatus.equals("00")?"true":"false"),"","Button","��ʱ����","���������޸�","saveRecord('self.close();')",sResourcesPath},
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
		if (!checkDate()) return;
			if(confirm("ȷ��Ҫ������Ʒ��ʱ������"))
			{
				if(bIsInsert){		
					beforeInsert();
				}
	
				beforeUpdate();
				as_save("myiframe0",sPostEvents);
				
			}	
			alert("��Ѻ����ʱ����ɹ���");
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		if(<%=sGuarantyStatus%> != "00")
		{
			self.close();
		}else{
			OpenPage("/CreditManage/GuarantyManage/GuarantyAuditList.jsp","_self","");
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
		if (getRowCount(0) == 0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"GuarantyID","<%=sGuarantyID%>");
			setItemValue(0,0,"GuarantyName","<%=sGuarantyName%>");
			setItemValue(0,0,"GuarantyType","<%=sGuarantyType%>");			
			setItemValue(0,0,"GuarantyStatus","<%=sGuarantyStatus%>");
			setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrg","<%=CurOrg.OrgID%>");			
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			
			bIsInsert = true;			
		}
		
    }
    //��������Ӧ��С�ڵ���Ԥ�ƻؿ����� 
    function checkDate(){
    	var sLostDate= getItemValue(0,getRow(),"LostDate"); 
    	var sPlanReturnDate = getItemValue(0,getRow(),"PlanReturnDate");
    	if(sLostDate.length!=0 && typeof(sLostDate)!="undefined"){
			if(sPlanReturnDate!= 0 &&��typeof(sPlanReturnDate)!="undefined"){
				if(sLostDate > sPlanReturnDate){
					alert("���������Ӧ��С�ڵ���Ԥ�ƻؿ�����");
					return false;
				}
			}
		}else{
			alert("����������Ԥ�ƻؿ����ڲ���Ϊ�գ�");
			return false;
		}
		return true;
    }
	        
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "GUARANTY_AUDIT";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),"SerialNo",sSerialNo);				
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
