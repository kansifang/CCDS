<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   CYHui  2003.8.18
			Tester:
			Content: 企业债券发行信息_List
			Input Param:
		                CustomerID：客户编号
		                CustomerRight:权限代码----01查看权，02维护权，03超级维护权
			Output param:
			                CustomerID：当前客户对象的客户号
			              	Issuedate:发行日期
			              	BondType:债券类型
			                CustomerRight:权限代码
			                EditRight:编辑权限代码----01查看权，02编辑权
			History Log: 
			                 2003.08.20 CYHui
			                 2003.08.28 CYHui
			                 2003.09.08 CYHui 
		 */
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "查询定义维护页面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量
	String sSql;
	
	//获得组件参数

	//获得页面参数	
	//获得页面参数	
	String sDocNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("docNo")));
	String sAttachmentNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("attachmentNo")));
	//String sColumn = DataConvert.toString(DataConvert.toRealString(5,(String)CurPage.getParameter("R0F4")));用下面代替
	String sColumn = DataConvert.toString(DataConvert.decode(request.getParameter("R0F4"),"UTF-8"));
	String sMethod = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("method")));
%>
<%
	/*~END~*/
%>

<%
	String sDescribeCount = "";
	String sUpdate0 = "";
	if(sMethod.equals("2")){ //2:update docContect
		//html中如产生换行，会原封不懂存入数据库，读取时，setItemValue(0,0,"Column",sColumn)时 会造成
		//setItemValue(0,0,"Column","zzz
		//		yyy"),很显然，js和java的一个字符串换行而不加连接符是有问题，故在这处理掉
		sColumn=sColumn.replaceAll("[\r\n]", "");
		byte abyte0[] = sColumn.getBytes("GBK");
		sUpdate0 = "update Doc_Attachment set DocContent=?,ContentLength=?,UpdateTime='"+StringFunction.getToday()+"' "+
					" where DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'";
		PreparedStatement pre0 = Sqlca.conn.prepareStatement(sUpdate0);
		pre0.clearParameters();
		pre0.setBinaryStream(1, new ByteArrayInputStream(abyte0,0,abyte0.length), abyte0.length);
		pre0.setInt(2, abyte0.length);
		pre0.executeUpdate();
		pre0.close();	   				
	}//else if(sMethod.equals("1")){//1:display 
	StringBuffer sb=new StringBuffer("");
	ASResultSet rs1 = Sqlca.getResultSet("select ContentLength from Doc_Attachment"+
							" where DocNo='"+sDocNo+"' and AttachmentNo='"+sAttachmentNo+"'");
	if(rs1.next()){		
		int iContentLength=rs1.getInt("ContentLength");
		if (iContentLength>0){
			byte bb[] = new byte[iContentLength];
			int iByte = 0;		
			java.io.InputStream inStream = null;
			ASResultSet rs2 = Sqlca.getResultSet2("select DocContent from Doc_Attachment"+
					" where DocNo='"+sDocNo+"' and/**/ AttachmentNo='"+sAttachmentNo+"'");//注意是getResultSet2
			if(rs2.next()){
				inStream = rs2.getBinaryStream("DocContent");
				while(true){
					iByte = inStream.read(bb);
					if(iByte<=0)
						break;
					sb.append(new String(bb,"GBK"));
				}
			}
			rs2.getStatement().close();
		}
	}
	rs1.getStatement().close();	
	sColumn=sb.toString().replaceAll("\"", "'");
	//}
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
	<%
		String sTempletNo = "QDefinition";
		String sTempletFilter = "1=1";
		
		ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
		//查询
	 	//doTemp.setColumnAttribute(sKeyColumn,"IsFilter","1");
		//doTemp.generateFilters(Sqlca);
		//doTemp.parseFilterData(request,iPostChange);
		//CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
		
		//if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
		ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
		dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
		dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
		dwTemp.setPageSize(10);
		
		//生成HTMLDataWindow
		Vector vTemp = dwTemp.genHTMLDataWindow(sDocNo+","+sAttachmentNo);
		for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/
%>
	<%
		//依次为：
			//0.是否显示
			//1.注册目标组件号(为空则自动取当前组件)
			//2.类型(Button/ButtonWithNoAction/HyperLinkText/TreeviewItem/PlainText/Blank)
			//3.按钮文字
			//4.说明文字
			//5.事件
			//6.资源图片路径
		String sButtons[][] = {
			{"true","","Button","保存","保存所有修改面","saveRecord()",sResourcesPath},
			{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
			{"true","","Button","查询","维护数据库","handleDatabase()",sResourcesPath}
			};
	%> 
<%
 	/*~END~*/
 %>




<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/
%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0","reloadSelf()");
		
		updateHtmlData();
		//goBack();
	}
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		parent.sObjectInfo="OK";
		parent.closeAndReturn();
	}
	</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>

<script language=javascript>
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();//初始化流水号字段
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"InputUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"InputOrg","<%=CurUser.OrgID%>");
		setItemValue(0,0,"InputTime",sNow);
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		sNow = PopPage("/Common/ToolsB/GetNow.jsp","","");
		setItemValue(0,0,"UpdateUser","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateTime",sNow);
	}

	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow(){
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"DocNo","<%=sDocNo%>");
			setItemValue(0,0,"QStyle","02");
			setItemValue(0,0,"Attribute2","01");
			setItemValue(0,0,"Attribute1","OpenComp(~QResultChart~,~/Data/Define/QResultChart.jsp~,~AttachmentNo=#AttachmentNo&Type=#Type&OneKey=#OneKey~,~TabContentFrame~,~~)");
			bIsInsert = true;
		}
		setItemValue(0,0,"Column","<%=sColumn%>");
		//由于保存后会请求两次本页面，一次是更新Blob，一次刷新，保存时AttachmentNo有新值，到更新Blob时，其被清空，所以在此
		//重新设上，到刷新时就有值了
		var sAttachmentNo=getItemValue(0,0,"AttachmentNo");
		setItemValue(0,0,"AttachmentNo",sAttachmentNo);
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "Doc_Attachment";//表名
		var sColumnName = "AttachmentNo";//字段名
		var sPrefix = "QDN";//前缀
		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	</script>
	<script type="text/javascript">
	<!--
	//according to value of QStyle,display different element
	function displayContent(element){
		var selectValue="";
		if(typeof(element) =="string"){
			selectValue=document.frames("myiframe0").document.all["R0F"+getColIndex(0,element)].value;
		}else if(typeof(element) =="object"){
			selectValue=element.value;
		}
		if(selectValue=="01"){
			setStyle("Column","none");
			setStyle("TableName,KeyColumn","block");
		}else if(selectValue=="02"){
			setStyle("Column","block");
			setStyle("TableName,KeyColumn","none");
		}
	}
	function setStyle(colnames,isDisplay){ 
		var myiframeWindow=document.getElementsByName("myiframe0")[0].contentWindow;
		var colNs=colnames.split(",");
		for(var i=0;i<colNs.length;i++){
			myiframeWindow.document.getElementsByName("R0F"+getColIndex(0,colNs[i]))[0].parentNode.parentNode.style.display=isDisplay;
		}
	}
	//更新完整查询语句到FormatDoc_Data.htmlData
	function updateHtmlData()
	{
		var sDocNo="<%=sDocNo%>";
		var sAttachmentNo=getItemValue(0,0,"AttachmentNo");
		var sStyle=getItemValue(0,0,"QStyle");
		var objectArray =document.frames("myiframe0").document.getElementsByName("R0F4");
		//对表单内容进行编码，在服务端用DataConvert.toRealString(5,s)或DataConvert.decode(s,"GBK")进行解码
		//objectArray[0].value=asConvU2G(objectArray[0].value); 用下面代替
		objectArray[0].value=encodeURIComponent(objectArray[0].value,'UTF-8');
		var form1=document.frames("myiframe0").document.forms("form1");
		if(sStyle=="02"){
			form1.action=sWebRootPath+"/Data/Define/QDefinitionInfo.jsp?CompClientID=<%=sCompClientID%>&docNo="+sDocNo+"&attachmentNo="+sAttachmentNo+"&method=2";
		}else if(sStyle=="01"){
			form1.action=sWebRootPath+"/Data/Define/QDefinitionInfo.jsp?CompClientID=<%=sCompClientID%>&docNo="+sDocNo+"&attachmentNo="+sAttachmentNo+"&method=1";
		}
		form1.method='post';
		form1.target = "_parent";
		form1.submit();
	}
	//利用查询语句生成查询页面
	function handleDatabase()
	{
		//self.close();
		//OpenComp("QDefinitionInfo","/Data/Define/QDefinitionInfo.jsp","docNo=<%=sDocNo%>&attachmentNo=<%=sDocNo%>&method=1&CompClientID=<%=sCompClientID%>","_self");

		var iframe0 =document.frames("myiframe0");
		//对表单内容进行编码，在服务端用DataConvert.toRealString(5,s)或DataConvert.decode(s,"GBK")进行解码
		for(var i=0;i<DZ[0][1].length;i++){
			var objectArray=iframe0.document.getElementsByName("R0F"+i);
			if(objectArray.length>0&&i!=3){
				iframe0.document.getElementsByName("R0F"+i)[0].value=asConvU2G(objectArray[0].value);
			}
		}
		var form1=iframe0.document.forms("form1");
		form1.action=sWebRootPath+"/Data/Define/QResultList.jsp?CompClientID=<%=sCompClientID%>";
		form1.method='post';
		form1.target = "_blank";
		form1.submit();
		//reloadSelf();
	}
	//-->
	</script>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>	
	bCheckBeforeUnload=false;
	bNotCheckModified=true;
	AsOne.AsInit();
	init();//初始化js中各种数据，为展示准备材料
	my_load(2,0,'myiframe0');//展示吧
	initRow(); //页面装载时，对DW当前记录进行初始化
	displayContent("QStyle");
</script>
	
<%
/*~END~*/
%>
<script language=javascript>
	//在展示页面增加编辑框
	var mywindow=window.frames['myiframe0'];
	mywindow._editor_url=_editor_url;
	//动态挂js代码
	function IncludeJS(windowobj,sId, fileUrl,isGetSrcCode,func){ 
		var oHead = windowobj.document.getElementsByTagName('HEAD').item(0); 
		var oBody = windowobj.document.getElementsByTagName("BODY").item(0); 
		if(!(oHead && oHead.length>0)){ 
			oHead = oBody; 
		} 
		var scriptTag=windowobj.document.getElementById(sId);
		if (!scriptTag){ 
			var oScript = windowobj.document.createElement( "script" ); 
			oScript.language = "javascript"; 
			oScript.type = "text/javascript"; //script.setAttribute("type",'text/javascript');两种方式皆可
			oScript.id = sId; 
			oScript.defer = true; 
			if(!isGetSrcCode){//把js挂到src下，让浏览器异步加载
				/*用传统的 js appendChild方法添加 script的src ,这个是异步的，加进去，执行里面的方法不能保证，需要做一些状态判断*/
				oScript.setAttribute("src",fileUrl);//文件的地址:_editor_url+"editor.js"
				oHead.appendChild(oScript); 
				oScript.onload = oScript.onreadystatechange = function(){ 
					if ((!this.readyState) || this.readyState == "complete" || this.readyState == "loaded" ){ 
						windowobj.eval(func); // editor_generate()方法 在 引入的js文件中 ,加载完后在此执行
						oScript.onload = oScript.onreadystatechange = null;
					}else{ 
					    console.info("can not load the oScript2.js file"); 
					} 
				};
			}else{
				//用XMLHTTP取得要脚本的内容，再创建 Script 对象。
				//另外注意编码的保持一致,因为服务器与XML使用UTF8编码传送数据。
				oScript.text = RunJspAjax(fileUrl);//用ajax，会用utf-8编码，所以服务端要用utf-8编码，以后所有程序要使用utf-8统一编码
				oHead.appendChild(oScript); 
				windowobj.eval(func); 
			}
		} 
	}
	//以下两者皆可
	IncludeJS(mywindow,"sid",_editor_url+"editor.js",false,"editor_generate('R0F4')");
	//下面这个似乎影响性能，原因未明
	//IncludeJS(mywindow,"sid","/Resources/1/HtmlEdit/editor.js",true,"editor_generate('R0F4')");
</script>
<%@ include file="/IncludeEnd.jsp"%>