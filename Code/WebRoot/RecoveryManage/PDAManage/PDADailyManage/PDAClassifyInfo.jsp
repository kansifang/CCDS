<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   hxli 2005-8-3
		Tester:
		Content: ��ծ�ʲ��弶��������
		Input Param:
			        ObjectNo:		������--���ǵ�ծ�ʲ���ˮ��
			        ObjectType:		��������--ASSET_INFO
									������Ϊ�����������
					SerialNo:		�弶����š�
									������Ϊҳ���������
		Output param:
		
		History Log: zywei 2005/09/07 �ؼ����
	 */
	%>
<%/*~END~*/%>

 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ծ�ʲ��弶������Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	String sSql = "";
	
	//����������
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));  //�ʲ���ˮ��
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));//asset_info
	if(sObjectNo == null ) sObjectNo = "";
	if(sObjectType == null ) sObjectType = "";
	
	//���ҳ�����
	String sSerialNo	=DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));			//�䶯��¼��ˮ��
	if(sSerialNo == null ) sSerialNo = "";//��ʾ����
	
%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/%>
<%	
	//�����ͷ�ļ�
	String sHeaders[][] = { 							
							{"SerialNo","�弶������ˮ��"},
							{"ObjectType","��������"},
							{"ObjectNo","�ʲ���ˮ��"},							
							{"AssetName","�ʲ�����"},
							{"FinallyResult","������"},
							{"ClassifyDate","��������"},	
							{"Remark","��ע"},	
							{"InputUserName","�Ǽ���"}, 
							{"InputOrgName","�Ǽǻ���"},
							{"UpdateDate","��������"}
						};
						 
	//���弶������л�ȡ�����¼	
	sSql =  " select CR.SerialNo,CR.ObjectType,CR.ObjectNo,AI.AssetName,"+
			" CR.FinallyResult,CR.ClassifyDate,CR.Remark,CR.ClassifyOrgID,"+
			" getOrgName(CR.ClassifyOrgID) as InputOrgName," + 
			" CR.ClassifyUserID,getUserName(CR.ClassifyUserID) as InputUserName,CR.UpdateDate " + 
			" from CLASSIFY_RECORD CR,ASSET_INFO AI" +
			" where  CR.ObjectNo='"+sObjectNo+"' and CR.ObjectType='"+sObjectType+"' "+
			" and CR.ObjectNo=AI.SerialNo and CR.SerialNo='"+sSerialNo+"'"+
			" order by ClassifyDate desc";
			//��Ӧ��ObjectType��ĳ���ʲ��ı䶯��¼��
			
	//����sSql�������ݶ���
	ASDataObject doTemp = new ASDataObject(sSql);

	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CLASSIFY_RECORD";
	
	//���ùؼ���
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);	 
	doTemp.setUpdateable("AssetNo,AssetName,InputOrgName,InputUserName",false);
	//���ò��ɼ���
	doTemp.setVisible("ObjectType,ObjectNo,ClassifyUserID,ClassifyOrgID,SerialNo",false);
	//���ø�ʽ
	doTemp.setDDDWCode("FinallyResult","ClassifyResult");
	doTemp.setCheckFormat("ClassifyDate","3");
	doTemp.setEditStyle("Remark","3");
	doTemp.setLimit("Remark",200);
	doTemp.setHTMLStyle("InputOrgName"," style={width:250px} ");
	
	
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
			{"true","","Button","����","���ص��ϼ�ҳ��","goBack()",sResourcesPath}
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

	/*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
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

	/*~[Describe=���ص��ϼ�ҳ��;InputParam=��;OutPutParam=��;]~*/
	function goBack()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAClassifyList.jsp","right");
	}

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
			setItemValue(0,0,"ClassifyUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"ClassifyOrgID","<%=CurOrg.OrgID%>");		
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");	
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"ClassifyDate","<%=StringFunction.getToday()%>");
		}
		
		var sColName = "AssetName"+"~";
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
				}
			}			
		}		
    }	

	/*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo() 
	{
		var sTableName = "CLASSIFY_RECORD";//����
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

