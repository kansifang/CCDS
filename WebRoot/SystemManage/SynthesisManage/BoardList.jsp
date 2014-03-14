<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/
%>
	<%
		/*
			Author: ndeng 2005-04-17
			Tester:
			Describe: 通知列表
			Input Param:
		
			Output Param:
		
		
			HistoryLog:
		 */
	%>
<%
	/*~END~*/
%>



<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/
%>
	<%
		String PG_TITLE = "通知列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>



<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量

	//获得页面参数
	
	//获得组件参数
	//String sBelongOrg = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	//out.println(sBelongOrg);
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/
%>
<%
	String sHeaders[][] = { 
					{"BoardNo","公告编号"},
					{"BoardName","公告名称"},
					{"BoardTitle","公告标题"},
					{"BoardDesc","公告描述"},
					{"IsPublish","是否发布"},
					{"IsNew","是否新"},
					{"IsEject","是否弹出"},
					{"FileName","公告文件名"},
					{"ContentType","内容类型"},
					{"ContentLength","内容长度"},
					{"UploadTime","上传时间"},
					{"DocContent","文档内容"}				
				}; 

	String sSql = " select BoardNo,BoardName,BoardTitle,BoardDesc, "+
		  " getItemName('YesNo',IsPublish) as IsPublish, "+
		    	  " getItemName('YesNo',IsNew) as IsNew, "+
		    	  " getItemName('YesNo',IsEject) as IsEject "+
		    	  " from BOARD_LIST ";

	//设置DataObject				
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    //设置更新的数据库表名
	doTemp.UpdateTable = "BOARD_LIST"; 
    //设置关键字段	
	doTemp.setKey("BoardNo",true);
	doTemp.setAlign("IsNew,IsEject,IsPublish","2");
	doTemp.setHTMLStyle("IsNew,IsEject,IsPublish"," style={width:60px} ");
	doTemp.setVisible("BoardNo",false);
	doTemp.setHTMLStyle("BoardTitle"," style={width:300px}");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读


	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/
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
						{"true","","Button","新增","新增公告","my_add()",sResourcesPath},
						{"true","","Button","详情","查看详情","my_detail()",sResourcesPath},
						{"true","","Button","删除","删除公告","my_del()",sResourcesPath}						
					  };
	%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/
%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>

	function my_del()
	{
		sBoardNo = getItemValue(0,getRow(),"BoardNo");	
		if (typeof(sBoardNo)=="undefined" || sBoardNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			as_del('myiframe0');
			as_save('myiframe0');  //如果单个删除，则要调用此语句
		}		
	}
	

	function initRow()
	{
		if (getRowCount(0)==0)
		{
		 	as_add("myiframe0");
		}		
	}
	
	/*这个函数一定要  */
	function mySelectRow()
	{		
	}
	
	function my_add()
	{
		OpenPage("/SystemManage/SynthesisManage/BoardInfo.jsp","_self","");	
	}
	
	function my_detail()
	{
		sBoardNo = getItemValue(0,getRow(),"BoardNo");			
		if (typeof(sBoardNo)=="undefined" || sBoardNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		OpenPage("/SystemManage/SynthesisManage/BoardInfo.jsp?BoardNo="+sBoardNo,"_self","");	
	}
	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/
%>
	<script language=javascript>


	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/
%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%
	/*~END~*/
%>

<%@	include file="/IncludeEnd.jsp"%>
