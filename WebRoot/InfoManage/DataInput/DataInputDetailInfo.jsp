<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author: bliu 2004-12-22
		Tester:
		Describe: Ͷ�ʣ���ҵծȨͶ��
		Input Param:
			CustomerID����ǰ�ͻ����
			SerialNo:	��ˮ��
		Output Param:
			CustomerID����ǰ�ͻ����

		HistoryLog:slliua 2005-1-6
			
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "Ͷ�ʣ���ҵծȨͶ��"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	
	//����������

	
	//���ҳ�����	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	if(sSerialNo == null ) sSerialNo = "";
	
	//����������
	String sFlag = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Flag"));
	if(sFlag==null) sFlag="";
	
	//����������(8010��ҵͶ�ʡ�8020��ȨͶ�ʡ�8030���)
	String sCurItemDescribe3 = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CurItemDescribe3"));
	if(sCurItemDescribe3==null) sCurItemDescribe3="";
	
%>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo="";
	
	//��ҵծȨͶ��
	if(sCurItemDescribe3.equals("8010"))
	{
		sTempletNo = "InputInvestBondInfo";
	}
	
	//��ȨͶ��
	if(sCurItemDescribe3.equals("8020"))
	{
		sTempletNo = "InputInvestStockInfo";
	}
	
	//���
	if(sCurItemDescribe3.equals("8030"))
	{
		sTempletNo = "InputLendInfo";
	}
	
	
	
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	//���ñ��ʷ�Χ
	doTemp.appendHTMLStyle("BaseRate"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"ծȯ���ʵķ�ΧΪ[0,100]\" ");
	
	if(sFlag.equals("Y"))
	{
		doTemp.setUpdateable("ManageOrgID",false);
	}else
	{
		doTemp.setUpdateable("RecoveryOrgID",false);
	}
	
	//����ֻ��
	doTemp.setReadOnly("SerialNo,CustomerID,BusinessSubType,BeginDate,EndDate,BusinessCurrency,FirstDrawingDate",true);
	
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	
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
		self.close();
	}
	
	</script>
<%/*~END~*/%>




<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=Info07;Describe=�Զ��庯��;]~*/%>

	<script language=javascript>
	/*~[Describe=�����ͻ�ѡ�񴰿ڣ����ý����ص�ֵ���õ�ָ������;InputParam=��;OutPutParam=��;]~*/
	function selectCustomer()
	{
		setObjectInfo("ImportCustomer","0@CustomerID@3@CustomerName@1",0,0);
	}
	
	/*~[Describe=ѡ��ȫ�������;InputParam=��;OutPutParam=��;]~*/
	function getRecoveryOrgID()
	{
		var sReturn= selectObjectInfo("Org","OrgID=<%=CurOrg.OrgID%>");
		if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_'))
		{
			sReturn=sReturn.split("@");
			sRecoveryOrgID=sReturn[0];
			sRecoveryOrgName=sReturn[1];
	
			setItemValue(0,0,"RecoveryOrgID",sReturn[0]);	
			setItemValue(0,0,"RecoveryOrgName",sReturn[1]);
		}else if (sReturn=='_CLEAR_')
		{
			setItemValue(0,0,"RecoveryOrgID","");
			setItemValue(0,0,"RecoveryOrgName","");
		}else 
		{
			return;
		}
	}
	
	/*~[Describe=ѡ�񾭰��˺;������;InputParam=��;OutPutParam=��;]~*/
	function getOperateUserID()
	{
		var sReturn= selectObjectInfo("User","OrgID=<%=CurOrg.OrgID%>");
		if (!(sReturn=='_CANCEL_' || typeof(sReturn)=="undefined" || sReturn.length==0 || sReturn=='_CLEAR_'))
		{
			sReturn=sReturn.split("@");
			sOperateUserID=sReturn[0];
			sOperateUserName=sReturn[1];
			sOperateOrgID=sReturn[2];
			sOperateOrgName=sReturn[3];
	
			setItemValue(0,0,"OperateUserID",sReturn[0]);
			setItemValue(0,0,"OperateUserName",sReturn[1]);
			setItemValue(0,0,"OperateOrgID",sReturn[2]);	
			setItemValue(0,0,"OperateOrgName",sReturn[3]);
		}else if (sReturn=='_CLEAR_')
		{
			setItemValue(0,0,"OperateUserID","");
			setItemValue(0,0,"OperateUserName","");
			setItemValue(0,0,"OperateOrgID","");	
			setItemValue(0,0,"OperateOrgName","");
		}else 
		{
			return;
		}
	}	

	/*~[Describe=ִ�в������ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeInsert()
	{
		initSerialNo();
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
			
			var sCurItemDescribe3 = "<%=sCurItemDescribe3%>";
			
			//��ҵծȨͶ��
			if(sCurItemDescribe3=="8010")
			{
				setItemValue(0,0,"BusinessType","8010");
			}
			
			//��ȨͶ��
			if(sCurItemDescribe3=="8020")
			{
				setItemValue(0,0,"BusinessType","8020");
			}
			
			//���
			if(sCurItemDescribe3=="8030")
			{
				setItemValue(0,0,"BusinessType","88010");
			}
			
			
			var sFlag = "<%=sFlag%>";
			if(sFlag=="Y")
			{
				setItemValue(0,0,"ShiftType","020");
			}
			
			setItemValue(0,0,"RecoveryOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"RecoveryOrgName","<%=CurOrg.OrgName%>");
			
			setItemValue(0,0,"ManageOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"ManageOrgName","<%=CurOrg.OrgName%>");
			
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			bIsInsert = true;
		}
    }
	
	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_CONTRACT";//����
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
