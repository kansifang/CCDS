<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
						
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "��������������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������
	String sSql = "";//Sql���
	ASResultSet rs = null;//�����
	//�������������������͡������š�����Ȩ��
	String sCodeNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo")));
	String sItemNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ItemNo")));
	String sType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.compParentComponent.getParameter("type")));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = {
					{"ItemNo","��ˮ��"},
					{"ItemName","�����кų�ʼ��"},
					{"Attribute1","Ҫ��Excel����"},
					{"Attribute3","�Ƿ�ʶ���ǩ"},
					{"ItemDescribe","DB�ֶ�"},
					{"Attribute6","Ҫ�����ڱ�"},
					{"ItemAttribute","Ҫ��ע��"},
					{"Attribute2","Ҫ������"},
					{"Attribute4","Ҫ�س���"},
					{"Attribute5","Ҫ�ؾ���"},
					{"Attribute7","����Ҫ�ط�ʽ"},
					{"SortNo","���"},
					{"IsInUse","��Ч"},
					{"InputUserName","�Ǽ���"},
					{"InputTime","�Ǽ�ʱ��"},
					{"UpdateUserName","������"},
					{"UpdateTime","����ʱ��"}
				};
	sSql =  " select  CodeNo,ItemNo,ItemName,SortNo,"+
				" Attribute1,Attribute3,ItemDescribe,"+
				" Attribute6,ItemAttribute,"+
				"Attribute2,Attribute4,Attribute5,"+
				" Attribute7,IsInUse,"+
				" InputUser,getUserName(InputUser) as InputUserName,InputTime,"+
				" UpdateUser,getUserName(UpdateUser) as UpdateUserName, UpdateTime"+
				" from Code_Library "+
				" where  CodeNo = '"+sCodeNo+"'"+
				" and ItemNo='"+sItemNo+"' order by SortNo asc";
	//��sSql�������ݴ������
	ASDataObject doTemp = null;
	//���ñ�ͷ,���±���,��ֵ,�ɼ����ɼ�,�Ƿ���Ը���
	doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	doTemp.setDDDWSql("Attribute2","select ItemNo,ItemName from Code_Library where CodeNo='DataType' and ItemNo in('Number','String') and IsInUse='1'");
	doTemp.setDDDWCode("Attribute3", "YesNo");
	doTemp.UpdateTable = "Code_Library";
	doTemp.setKey("CodeNo,ItemNo",true);
	//���ø�ʽ
	doTemp.setAlign("Attribute2,Attribute4,","1");
	doTemp.setRequired("Attribute2", true);
	doTemp.setVisible("CodeNo,ItemName,InputUser,UpdateUser",false);
	if("01".equals(sType)){
		doTemp.setVisible("ItemAttribute", false);
		doTemp.setUnit("ItemDescribe","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectColumn();\"> ");
	}else{
		doTemp.setVisible("Attribute1,Attribute3", false);
		doTemp.setHTMLStyle("ItemDescribe"," style={width:200px} ");
		doTemp.setUnit("Attribute6", "<font style={color:red}>������,�ָ�</font>");
	}
	doTemp.setDDDWCode("IsInUse","YesNo");
	doTemp.setDDDWCode("Attribute7", "AlterType");
	doTemp.setDDDWCode("ItemName","YesNo");
	doTemp.setUpdateable("InputUserName,UpdateUserName",false);
	doTemp.setReadOnly("ItemNo,InputUserName,UpdateUserName,InputTime,UpdateTime",true);
	//�����ֶ���ʾ���	
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
	//dwTemp.setEvent("AfterInsert","!BusinessManage.InsertRelative(#SerialNo,#RelativeObjectType,#RelativeAgreement,APPLY_RELATIVE) + !WorkFlowEngine.InitializeFlow("+sObjectType+",#SerialNo,"+sApplyType+","+sFlowNo+","+sPhaseNo+","+CurUser.UserID+","+CurOrg.OrgID+")");
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=���尴ť;]~*/
%>
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
			{"true","","Button","���沢����","������һ����¼","saveRecord('newRecord()')",sResourcesPath},
			{"true","","Button","����","����","saveRecord('doReturn()')",sResourcesPath},
			{"false","","Button","����","�����б�ҳ��","doReturn()",sResourcesPath}
		};
	%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~���ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=����ҳ��;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
		var bIsInsert=false;
		function saveRecord(sPostEvents){
			if (!ValidityCheck()) return;
			if(bIsInsert){
				beforeInsert();
			}else{
				//backupHis();
			}
			beforeUpdate();
			//�ֶ�����ƴ�ӣ����������ں�׺�Ա����ظ���
			var ColumnType = getItemValue(0,getRow(),"Attribute2");
			var date=new Date();
			var autoColumnName=ColumnType+date.getFullYear()+""+(date.getMonth()+1)+""+date.getDate()+""+date.getHours()+""+date.getMinutes()+""+date.getSeconds();;
			var AlterType = getItemValue(0,getRow(),"Attribute7");
			var ColumnTable = getItemValue(0,getRow(),"Attribute6").toUpperCase();
			var ColumnName=getItemValue(0,getRow(),"ItemDescribe");//���ֶ�
			if(ColumnName.length==0){
				ColumnName=autoColumnName;
				setItemValue(0,0,"ItemDescribe",ColumnName);
			}
			var ColumnLong = getItemValue(0,getRow(),"Attribute4");
			var ColumnPrecision = getItemValue(0,getRow(),"Attribute5");
			alterColumn(AlterType,ColumnTable,ColumnName,ColumnType,ColumnLong,ColumnPrecision);
			//ʹ�ñ��ֶε�ҳ��Ҫͬ�������ֶζ��ձ�,ע���ñ���ֶ���Ϊ������������Ϊ�ֶ�ά��ҳ�����ά���������ֶΣ���������Ǹ����Զ�ƴ�ӵ��ֶΣ�Ҳ�����ظ��ˣ�������Ҫ�ǿ��ǵ������ֹ�д���ֶ�����
			if("<%=sType%>"=="01"){
				//�ֶ�ά�����ձ�ά����û�в��룬�������
				var ItemNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName=Code_Library&ColumnName=ItemNo&Prefix=","","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
				var ColumnType = getItemValue(0,getRow(),"Attribute2");
				var ColumnLong = getItemValue(0,getRow(),"Attribute4");
				var ColumnPrecision = getItemValue(0,getRow(),"Attribute5");
				var ColumnTable = getItemValue(0,getRow(),"Attribute6").toUpperCase();
				var sReturn=RunMethod("PublicMethod","GetColValue","Count(1) as Count,Code_Library,String@CodeNo@b20140323000001@String@Attribute6@"+ColumnTable+"@String@ItemDescribe@"+ColumnName+",Code_Library");
				if(sReturn.split('@')[1]==0){
					RunMethod("PublicMethod","InsertColValue","String@CodeNo@b20140323000001"+
							"@String@ItemNo@"+ItemNo+
							"@String@ItemDescribe@"+ColumnName+
							"@String@Attribute2@"+ColumnType+
							"@String@Attribute4@"+ColumnLong+
							"@String@Attribute5@"+ColumnPrecision+
							"@String@Attribute6@"+ColumnTable+
							"@String@Attribute7@AddColumn"+
							"@String@IsInUse@1,Code_Library");
				}else{
					//���¸��ֶε���������
					RunMethod("PublicMethod","UpdateColValue","String@CodeNo@b20140323000001"+
							"@String@ItemNo@"+ItemNo+
							"@String@ItemDescribe@"+ColumnName+
							"@String@Attribute2@"+ColumnType+
							"@String@Attribute4@"+ColumnLong+
							"@String@Attribute5@"+ColumnPrecision+
							"@String@Attribute6@"+ColumnTable+
							"@String@Attribute7@AlterLong"+
							"@String@IsInUse@1,Code_Library,String@CodeNo@b20140323000001@String@Attribute6@"+ColumnTable+"@String@ItemDescribe@"+ColumnName);
				}
			}
			var sortNo=getItemValue(0,getRow(),"SortNo").toUpperCase();
			if(sortNo.length==1){
				sortNo='00'+sortNo;
			}else if(sortNo.length==2){
				sortNo='0'+sortNo;
			}
			setItemValue(0,0,"SortNo",sortNo);
			as_save("myiframe0",sPostEvents+"");
		}
		function alterColumn(AlterType,ColumnTable,ColumnName,ColumnType,ColumnLong,ColumnPrecision){
			//ִ�����ݿ�DDL�ĵķ��������Ӧ����procedure
			var arrColumnTable=ColumnTable.split(",");
			for(var i=0;i<arrColumnTable.length;i++){
				RunMethod("PublicMethod","AlterColumnInDB",AlterType+","+arrColumnTable[i]+","+ColumnName+","+ColumnType+","+ColumnLong+","+ColumnPrecision);
			}
			return ColumnName;
		}
		function newRecord()
		{
			OpenPage("/Data/Define/BatchConfigInfo.jsp?CodeNo=<%=sCodeNo%>","_self","");
		}
	    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	    function doReturn(sIsRefresh){
			sObjectNo = getItemValue(0,getRow(),"CodeNo");
			parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
			parent.closeAndReturn();
		}
	    /*~[Describe=�޸�ǰ����һ�ݱ���;InputParam=��;OutPutParam=��;]~*/
	   	function backupHis(){
	   		var CodeNo = getItemValue(0,getRow(),"CodeNo");
	   		var ItemNo = getItemValue(0,getRow(),"ItemNo");
	   		RunMethod("SystemManage","InsertScoreConfigInfo",CodeNo+","+ItemNo);
		}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
<script language=javascript>
	function beforeInsert()
	{
		initSerialNo();
		bIsInsert = false;
	}
	/*~[Describe=ִ�и��²���ǰִ�еĴ���;InputParam=��;OutPutParam=��;]~*/
	function beforeUpdate()
	{
		 setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
	     setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()+"-"+StringFunction.getNow()%>");
	}

	/*~[Describe=��Ч�Լ��;InputParam=��;OutPutParam=ͨ��true,����false;]~*/
	function ValidityCheck()
	{
		var patrn=/^(-?\d+)(\.\d{0,16})?$/;
		/*
		var sAttribute2=getItemValue(0,0,"Attribute2");
		if(sAttribute2.length>0){
			if(patrn.exec(sAttribute2)==null){
				alert("���ޱ߽�ֵ����Ϊ���16λС�������֣�");
				setItemValue(0,getRow(),"Attribute2","");
				return false;
			}
		}
		var sAttribute4=getItemValue(0,0,"Attribute4");
		if(sAttribute4.length>0){
			if(patrn.exec(sAttribute4)==null){
				alert("���ޱ߽�ֵ����Ϊ���16λС�������֣�");
				setItemValue(0,getRow(),"Attribute4","");
				return false;
			}
		}
		*/
		//У����������Ƿ���ڵ�ǰ����
		sDocDate = getItemValue(0,0,"DocDate");//��������
		sToday = "<%=StringFunction.getToday()%>";//��ǰ����
		if(typeof(sDocDate) != "undefined" && sDocDate != "")
		{
			if(sDocDate > sToday)
			{
				alert(getBusinessMessage('161'));//�������ڱ������ڵ�ǰ���ڣ�
				return false;
			}
		}
		return true;
	}
	function selectColumn()
	{		
		sParaString = "CodeNo,b20140323000001,CurrCodeNo,<%=sCodeNo%>";
		setObjectValue("SelectColumn",sParaString,"@Attribute6@2@ItemDescribe@3@Attribute2@4@Attribute4@5@Attribute5@6",0,0,"");			
	}
   /*~[Describe=��ʼ��ѡ����;InputParam=��;OutPutParam=��;]~*/
   function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"CodeNo","<%=sCodeNo%>");
			setItemValue(0,0,"Attribute3","2");
			setItemValue(0,0,"Attribute2","String");
			setItemValue(0,0,"Attribute5","0");
			setItemValue(0,0,"Attribute6","Batch_Import,Batch_Import_Interim");
			//setItemValue(0,0,"Attribute7","AddColumn");
	        setItemValue(0,0,"IsInUse","1");
	        setItemValue(0,0,"SortNo","000");
	        setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
	        setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
	        setItemValue(0,0,"InputTime","<%=StringFunction.getToday()+"-"+StringFunction.getNow()%>");
	        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
	        setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
	        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()+"-"+StringFunction.getNow()%>");
		    bIsInsert = true;
		}
   }
   /*~[Describe=��ʼ����ˮ���ֶ�;InputParam=��;OutPutParam=��;]~*/
	function initSerialNo()
	{
		var sTableName = "Code_Library";//����
		var sColumnName = "ItemNo";//�ֶ���
		var sPrefix = "";//ǰ׺
		//ʹ��GetSerialNo.jsp����ռһ����ˮ��
		var sItemNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//����ˮ�������Ӧ�ֶ�
		setItemValue(0,getRow(),sColumnName,sItemNo);
	}
	function randomNumber()
	{
		today = new Date();
		num = Math.abs(Math.sin(today.getTime()));
		return num;  
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	var bFreeFormMultiCol=true;
	init();
	my_load(2,0,'myiframe0');
	initRow();
	//var bCheckBeforeUnload=false;
</script>
<%
	/*~END~*/
%>
<%@	include file="/IncludeEnd.jsp"%>