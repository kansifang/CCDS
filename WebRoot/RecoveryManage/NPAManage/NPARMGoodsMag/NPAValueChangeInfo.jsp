<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: FMWu 2004-12-9
		Tester:
		Describe: ����Ѻ����Ϣ���;
		Input Param:
			SerialNo: �����ˮ��
			GuarantyID:����Ѻ����ˮ��
			ChangeType: ������ͣ�010����ֵ�����020�����������030������Ȩ֤�����				
		Output Param:
			

		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "����Ѻ����Ϣ���"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sTempletFilter = "";
	String sTempletNo = "";
	
	//����������
	String sGuarantyID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("GuarantyID"));
	String sChangeType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ChangeType"));
	//����ֵת��Ϊ���ַ���
	if (sGuarantyID==null) sGuarantyID = "";
	if (sChangeType==null) sChangeType = "";
	
	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	if (sSerialNo==null) sSerialNo = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//��ʾģ��	
	sTempletNo = "PawnChangeInfo";
	//����ChangeType�Ĳ�ͬ���õ���ͬ�Ĺ�������
    sTempletFilter = " (ColAttribute like '%"+sChangeType+"%' ) ";

	//ͨ����ʾģ�����ASDataObject����doTemp
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);	
	//���ù��ø�ʽ
	doTemp.setVisible("SerialNo",false);	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
	//����setEvent
	dwTemp.setEvent("AfterInsert","!BusinessManage.UpdateGuarantyChangeInfo(#GuarantyID,#SerialNo,"+sChangeType+")");
	dwTemp.setEvent("AfterUpdate","!BusinessManage.UpdateGuarantyChangeInfo(#GuarantyID,#SerialNo,"+sChangeType+")");
	
	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sSerialNo);
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
		if(bIsInsert){		
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);		
	}
	
	/*~[Describe=�����б�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/NPAManage/NPARMGoodsMag/NPAValueChangeList.jsp","_self","");
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
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"GuarantyID","<%=sGuarantyID%>");
			setItemValue(0,0,"ChangeType","<%=sChangeType%>");			
		<%
			ASResultSet rs=Sqlca.getASResultSet("select * from GUARANTY_INFO where GuarantyID='"+sGuarantyID+"'");
			if(rs.next())
			{ 
		%>
				setItemValue(0,0,"OldEvalOrgID","<%=DataConvert.toString(rs.getString("EvalOrgID"))%>");
				setItemValue(0,0,"OldEvalOrgName","<%=DataConvert.toString(rs.getString("EvalOrgName"))%>");
				setItemValue(0,0,"OldEvalNetValue","<%=DataConvert.toString(rs.getString("EvalNetValue"))%>");
				setItemValue(0,0,"OldConfirmValue","<%=DataConvert.toString(rs.getString("ConfirmValue"))%>");
				setItemValue(0,0,"OldOwnerID","<%=DataConvert.toString(rs.getString("OwnerID"))%>");
				setItemValue(0,0,"OldOwnerName","<%=DataConvert.toString(rs.getString("OwnerName"))%>");
<%
			}
			rs.getStatement().close(); 
%>
			bIsInsert = true;
		}
		
    }

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "GUARANTY_CHANGE";//����
		var sColumnName = "SerialNo";//�ֶ���
		var sPrefix = "";//ǰ׺

		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
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

