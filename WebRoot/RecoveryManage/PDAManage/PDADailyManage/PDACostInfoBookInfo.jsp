<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   FSGong  2004.12.12
		Content: ��ծ�ʲ�������ط���̨������
		Input Param:
		        ObjectType:��������
		        ObjectNo:��ծ�ʲ���ˮ��
		        SerialNo:���ü�¼��ˮ��										
		Output param:
		
		History Log: zywei 2005/09/07 �ؼ����
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ�������ط���̨������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������

	//���ҳ�����
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	//����ֵת��Ϊ���ַ���
	if(sSerialNo == null ) sSerialNo = "";//������¼
	if(sObjectNo == null ) sObjectNo = "";
	if(sObjectType == null ) sObjectType = "";
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info03;Describe=�������ݶ���;]~*/%>
	<%
	//ͨ����ʾģ�����ASDataObject����doTemp
	String sTempletNo ="PDACostInfo";
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style = "2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sObjectType+','+sObjectNo+','+sSerialNo);
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
			{"true","","Button","����","���������޸�","goBack()",sResourcesPath},
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
	function saveRecord()
	{
		if(bIsInsert)
		{
			beforeInsert();
			bIsInsert = false;
		}

		beforeUpdate();
		as_save("myiframe0");		
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
			bIsInsert = true;		

			setItemValue(0,0,"ObjectNo","<%=sObjectNo%>");
			setItemValue(0,0,"ObjectType","<%=sObjectType%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgID","<%=CurOrg.OrgID%>");		
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");		
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
		}
		
		var sColName = "AssetName@AssetType"+"~";
		var sTableName = "ASSET_INFO"+"~";
		var sWhereClause = "String@ObjectNo@"+"<%=sObjectNo%>"+"@String@ObjectType@AssetInfo"+"~";
		
		sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
		if(typeof(sReturn) != "undefined" && sReturn != "") 
		{			
			sReturn = sReturn.split('~');
			var my_array1 = new Array();
			for(i = 0;i < sReturn.length;i++)
			{
				my_array1[i] = sReturn[i];
			}
			
			for(j = 0;j < my_array1.length;j++)
			{
				sReturnInfo = my_array1[j].split('@');	
				var my_array2 = new Array();
				for(m = 0;m < sReturnInfo.length;m++)
				{
					my_array2[m] = sReturnInfo[m];
				}
				
				for(n = 0;n < my_array2.length;n++)
				{									
					//�����ʲ�����
					if(my_array2[n] == "assetname")
						setItemValue(0,getRow(),"AssetName",sReturnInfo[n+1]);					
					//�����ʲ�����
					if(sReturnInfo[n] == "assettype")
						setItemValue(0,getRow(),"AssetType",sReturnInfo[n+1]);					
				}
			}			
		}			
    }
	
	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDACostInfoBookList.jsp","right","");
	}

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "COST_INFO";//����
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