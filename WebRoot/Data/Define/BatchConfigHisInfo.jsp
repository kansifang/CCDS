<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: zywei 2005-11-27
			Tester:
			Describe: ҵ����������Ӧ�������ĵ�����Ϣ�б�;
			Input Param:
			ObjectType���������ͣ�CreditApply��
			ObjectNo: �����ţ�������ˮ�ţ�
			Output Param:
			
			HistoryLog:
						
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
	String sModelNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ModelNo")));
	String sItemNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ItemNo")));
	String sValueCode = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ValueCode")));
	//CreditLevelToTotalScore ��������   ScoreToItemValue ��Ŀ����
	String sCodeNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CodeNo")));
	String sCItemNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CItemNo")));
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders0[][] = {
					{"ItemNo","��ˮ��"},
					{"ItemDescribe","a"},
					{"Attribute1","b"},
					{"Attribute2","c"},
					{"Attribute3","d"},
					{"Attribute4","Median"},
					{"Attribute5","StDev"},
					{"Attribute6","LowerLimit"},
					{"Attribute7","UpperLimit"},
					{"IsInUse","�Ƿ���Ч"},
					{"UpdateUserName","������"},
					{"UpdateTime","����ʱ��"}
				};
	String sSql0 =  " select  CodeNo,ItemNo,ItemName,SortNo,"+
				" ItemDescribe,"+
				" Attribute1,"+
				" Attribute2,"+
				" Attribute3,"+
				" Attribute4,"+
				" Attribute5,"+
				" Attribute6,"+
				" Attribute7,"+
				" IsInUse,"+
				" InputUser,"+
				" getUserName(UpdateUser) as UpdateUserName,"+
				" InputTime,"+
				" UpdateUser,"+
				" getUserName(UpdateUser) as UpdateUserName,"+
				" UpdateTime"+
				" from Code_Library "+
				" where  CodeNo = '"+sCodeNo+"'"+
				" and ItemName='"+sModelNo+"'"+
				" and SortNo='"+sItemNo+"'";
	String sHeaders1[][] = {
					{"ItemNo","��ˮ��"},
					{"ItemDescribe","��ֵ"},
					{"Attribute1","���޲�������������"},
					{"Attribute2","���ޱ߽�ֵ��������"},
					{"Attribute3","���޲�������������"},
					{"Attribute4","���ޱ߽�ֵ��������"},		
					{"Attribute5","ȡֵ�����ԣ�"},
					{"IsInUse","��Ч"},
					{"InputUserName","�Ǽ���"},
					{"InputTime","�Ǽ�ʱ��"},		
					{"UpdateUserName","������"},
					{"UpdateTime","����ʱ��"}
				};
	String sHeaders2[][] = {
					{"ItemNo","��ˮ��"},
					{"ItemDescribe","����"},
					{"Attribute1","���޲�����"},
					{"Attribute2","���ޱ߽�ֵ"},
					{"Attribute3","���޲�����"},
					{"Attribute4","���ޱ߽�ֵ"},		
					{"IsInUse","��Ч"},
					{"InputUserName","�Ǽ���"},
					{"InputTime","�Ǽ�ʱ��"},		
					{"UpdateUserName","������"},
					{"UpdateTime","����ʱ��"}
		  				};
	sSql =  " select  CodeNo,ItemNo,ItemName,SortNo,"+
		" ItemDescribe,"+
		" Attribute1,"+
		" Attribute2,"+
		" Attribute3,"+
		" Attribute4,"+
		" Attribute5,"+
		" IsInUse,"+
		" InputUser,"+
		" getUserName(InputUser) as InputUserName,"+
		" InputTime,"+
		" UpdateUser,"+
		" getUserName(UpdateUser) as UpdateUserName,"+
		" UpdateTime"+
	" from Code_Library "+
	" where  CodeNo = '"+sCodeNo+"'"+
	" and ItemNo='"+sCItemNo+"'"+
	" and ItemName='"+sModelNo+"'";
	//��sSql�������ݴ������
	ASDataObject doTemp = null;
	//���ñ�ͷ,���±���,��ֵ,�ɼ����ɼ�,�Ƿ���Ը���
	if("311".equals(sModelNo)&&sItemNo.endsWith("TJMX")){//����ҵ��С��ͳ��ģ�͹�ʽ
	doTemp = new ASDataObject(sSql0);
	doTemp.setHeader(sHeaders0);
	}else{
		if("ScoreToItemValue".equals(sCodeNo)){
	sSql+=" and SortNo='"+sItemNo+"' order by Double(ItemDescribe) asc ";
	doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders1);
	if(!"".equals(sValueCode)){
		doTemp.setVisible("Attribute1,Attribute2,Attribute3,Attribute4",false);
		doTemp.setDDDWCode("Attribute5",sValueCode);
		doTemp.setRequired("Attribute5",true);
		doTemp.setHTMLStyle("Attribute5"," style={width:1000px} ");
		if("������Ȩ��������".equals(sValueCode)){
			doTemp.setDDDWCode("ItemDescribe","��׼�ն�����ߵ÷ֱ�");
		}
	}else{
		doTemp.setVisible("Attribute5",false);
	}
		}else if("CreditLevelToTotalScore".equals(sCodeNo)){
	sSql+=" order by ItemDescribe asc ";
	doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders2);
	doTemp.setVisible("Attribute5",false);
	doTemp.setDDDWSql("ItemDescribe","select ItemNo,ItemName from Code_Library where CodeNo='CreditLevel'");
		}
		doTemp.setDDDWSql("Attribute1","select ItemNo,ItemName from Code_Library where CodeNo='ArithmeticOpe' and ItemNo in('030','040','050') and IsInUse='1'");
		doTemp.setDDDWSql("Attribute3","select ItemNo,ItemName from Code_Library where CodeNo='ArithmeticOpe' and ItemNo in('010','020','050') and IsInUse='1'");
	}
	doTemp.UpdateTable = "Code_Library";
	doTemp.setKey("CodeNo,ItemNo",true);
	//���ø�ʽ
	doTemp.setAlign("Attribute2,Attribute4,","1");
	doTemp.setVisible("CodeNo,ItemName,SortNo,InputUser,UpdateUser",false);
	//doTemp.setHTMLStyle("Attribute1,Attribute2,Attribute3,Attribute4"," style={width:auto} ");
	doTemp.setDDDWCode("IsInUse","YesNo");
	doTemp.setRequired("IsInUse",true);
	//doTemp.setCheckFormat("InputTime,UpdateTime","3");
	doTemp.setUpdateable("InputUserName,UpdateUserName",false);
	doTemp.setReadOnly("ItemNo,InputUserName,UpdateUserName,InputTime,UpdateTime",true);
	//�����ֶ���ʾ���	
	
	//����datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //����DW��� 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //�����Ƿ�ֻ�� 1:ֻ�� 0:��д
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
			{"true","","Button","����","������һ����¼","newRecord()",sResourcesPath},
			{"true","","Button","����","����","saveRecord()",sResourcesPath},
			{"true","","Button","����","�����б�ҳ��","goBack()",sResourcesPath}
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
	function saveRecord()
	{
		var patrn=/^(-?\d+)(\.\d{0,16})?$/;
		var sItemDescribe=getItemValue(0,0,"ItemDescribe");
		if(sItemDescribe.length>0&&"<%=sCodeNo%>"=="ScoreToItemValue"){
			if (patrn.exec(sItemDescribe)==null){
				alert("��ֵ����Ϊ���16λС�������֣�");
				setItemValue(0,getRow(),"ItemDescribe","");
				return false;
			}
		}
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
		if(!bIsInsert){
			backupHis();
		}
		as_save("myiframe0","");
	}
	 /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecordAndAdd()
	{
        as_save("myiframe0","newRecord()");
	}
	function newRecord()
	{
		OpenPage("/Common/Configurator/EvaluateManage/EvaluateScoreConfigInfo.jsp?CodeNo=<%=sCodeNo%>","_self","");
		//OpenComp("EvaluateScoreConfigInfo","/Common/Configurator/EvaluateManage/EvaluateScoreConfigInfo.jsp","CodeNo=<%=sCodeNo%>","_self","");
	}
	 /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
   	function goBack(){
		OpenPage("/Common/Configurator/EvaluateManage/EvaluateScoreConfigList.jsp","_self","");
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
   /*~[Describe=��ʼ��ѡ����;InputParam=��;OutPutParam=��;]~*/
   function initRow(){
		if (getRowCount(0)==0) //���û���ҵ���Ӧ��¼��������һ�����������ֶ�Ĭ��ֵ
		{
			as_add("myiframe0");//������¼
			setItemValue(0,0,"CodeNo","<%=sCodeNo%>");
	        var sItemNo=PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName=Code_Library&ColumnName=ItemNo","","");
	        setItemValue(0,0,"ItemNo",sItemNo);
	        setItemValue(0,0,"ItemName","<%=sModelNo%>");
	        setItemValue(0,0,"SortNo","<%=sItemNo%>");
	        setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
	        setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
	        setItemValue(0,0,"InputTime","<%=StringFunction.getToday()+"-"+StringFunction.getNow()%>");
	        setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
	        setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
	        setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()+"-"+StringFunction.getNow()%>");
		    bIsInsert = true;
		}else{
			 setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		     setItemValue(0,0,"UpdateTime","<%=StringFunction.getToday()+"-"+StringFunction.getNow()%>");
		}
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