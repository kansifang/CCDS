<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.lmt.app.crawler.*" %>

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
	String sType = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type")));
%>
<%
	/*~END~*/
%>

<%
		String crawlPath="D:\\crawl";
		int depth = 5;
		int threads = 10;
		if("1".equals(sType)){
			BreadthCrawler crawler = new IfengCrawler();
			session.setAttribute("crawler",crawler);
			sSql="select RelativeCode,ItemDescribe,ItemAttribute,Attribute1 " +
					" from Code_Library" +
					" where CodeNo='"+sCodeNo+"'"+
					" and ItemNo='"+sItemNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				String sSeeds=rs.getString(1);
				String sPRegexs=rs.getString(2);
				String sNRegexs=rs.getString(3);
				depth=Integer.valueOf(rs.getString(4));
				//crawler.setPageSavePath(pageSavePath);
				crawler.setCrawlPath(crawlPath);
		        crawler.setResumable(false);
		        crawler.setThreads(threads);
		        crawler.addSeeds(sSeeds, "\\s+");
		        crawler.addPRegexs(sPRegexs, "\\s+");
		        crawler.addNRegexs(sNRegexs, "\\s+");
		        crawler.start(depth);
			}
			rs.getStatement().close();
		}else if("2".equals(sType)){
			BreadthCrawler crawler=(BreadthCrawler)session.getAttribute("crawler");
			crawler.stop();
		}
%>
<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	String sHeaders[][] = {
					{"ItemNo","��ˮ��"},
					{"ItemName","ģ������"},
					{"RelativeCode","����"},
					{"ItemDescribe","��������"},
					{"ItemAttribute","��ֹ����"},
					{"Attribute1","URL���"},
					{"SortNo","���"},
					{"IsInUse","��Ч"},
					{"InputUserName","�Ǽ���"},
					{"InputTime","�Ǽ�ʱ��"},
					{"UpdateUserName","������"},
					{"UpdateTime","����ʱ��"}
				};
	sSql =  " select  CodeNo,ItemNo,ItemName,SortNo,"+
				" RelativeCode,ItemDescribe,"+
				" ItemAttribute,Attribute1,IsInUse,"+
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
	doTemp.setVisible("CodeNo,ItemName,InputUser,UpdateUser,Attribute8",false);
	//doTemp.setUnit("ItemDescribe","<input type=button class=inputDate   value=\"...\" name=button1 onClick=\"javascript:parent.selectColumn();\"> ");
	doTemp.setHTMLStyle("RelativeCode,ItemDescribe,ItemAttribute"," style={width:400px;height:100px} ");
	doTemp.setDDDWCode("IsInUse","YesNo");
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
			{"true","","Button","����","����","saveRecord()",sResourcesPath},//'doReturn()'
			{"true","","Button","��ʼ","��ʼ��ȡ","start()",sResourcesPath},
			{"true","","Button","ֹͣ","ֹͣ��ȡ","stop()",sResourcesPath},
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
			var sortNo=getItemValue(0,getRow(),"SortNo").toUpperCase();
			if(sortNo.length==1){
				sortNo='00'+sortNo;
			}else if(sortNo.length==2){
				sortNo='0'+sortNo;
			}
			setItemValue(0,0,"SortNo",sortNo);
			as_save("myiframe0",sPostEvents+"");
		}
		function addColumn(){
			var AlterType = getItemValue(0,getRow(),"Attribute7");
			var ColumnType = getItemValue(0,getRow(),"Attribute2");
			var ColumnLong = getItemValue(0,getRow(),"Attribute4");
			var ColumnPrecision = getItemValue(0,getRow(),"Attribute5");
			var ColumnTable = getItemValue(0,getRow(),"Attribute6");
			if(ColumnType=="String"){
				ColumnName=ColumnType+ColumnLong;
			}else{
				ColumnName=ColumnType+ColumnLong+ColumnPrecision;
			}
			var date=new Date();
			var prefix=date.getFullYear()+""+(date.getMonth()+1)+""+date.getDate()+""+date.getHours()+""+date.getMinutes()+""+date.getSeconds();
			ColumnName=ColumnName+prefix;//���ֶ����ּ��Ϻ�׺�Ա����ظ�
			setItemValue(0,0,"Attribute8",ColumnName);
			setItemValue(0,0,"Attribute6",ColumnTable.toUpperCase());
			RunMethod("PublicMethod","AlterColumnInDB",AlterType+","+ColumnTable+","+ColumnName+","+ColumnType+","+ColumnLong+","+ColumnPrecision);
			return ColumnName;
		}
		function newRecord()
		{
			OpenPage("/BusinessManage/BatchConfigInfo.jsp?CodeNo=<%=sCodeNo%>","_self","");
		}
	    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
	    function doReturn(sIsRefresh){
			sObjectNo = getItemValue(0,getRow(),"CodeNo");
			parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
			parent.closeAndReturn();
		}
	    /*~[Describe=�޸�ǰ����һ�ݱ���;InputParam=��;OutPutParam=��;]~*/
	   	function start(){
	   		OpenPage("/Data/Report/CrawlerSetInfo.jsp?CodeNo=<%=sCodeNo%>&ItemNo=<%=sItemNo%>&Type=1","_self","");
		}
	   	/*~[Describe=�޸�ǰ����һ�ݱ���;InputParam=��;OutPutParam=��;]~*/
	   	function stop(){
	   		OpenPage("/Data/Report/CrawlerSetInfo.jsp?CodeNo=<%=sCodeNo%>&ItemNo=<%=sItemNo%>&Type=2","_self","");
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
		setObjectValue("SelectColumn",sParaString,"@ItemDescribe@2@Attribute2@3@Attribute4@4@Attribute5@5",0,0,"");			
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
			setItemValue(0,0,"Attribute6","Batch_Import");
			setItemValue(0,0,"Attribute7","AddColumn");
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
		alert(sItemNo);
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