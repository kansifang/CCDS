<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: --fbkang 2005-7-26
		Tester:
		Describe: --相关认证信息列表;
		Input Param:
			CustomerID：--当前客户编号
		Output Param:
			CustomerID：--当前客户编号
			SerialNo:  --当前流水号码
			EditRight:--权限代码（01：查看权；02：维护权）
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "相关认证信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
     String sSql="";//--存放sql语句
	//获得页面参数
	
	//获得组件参数，客户代码
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {	
							{"SerialNo","流水号"},
							{"CertName","认证和证书名称"},
							{"CertResult","认证结果"},
							{"CertOrg","认证机构"},
							{"AuthDate","认证日期"},
							{"ValidDate","有效日期"},
							{"OrgName","登记机构"},
							{"UserName","登记人"}
						  };

	      sSql =	" select CustomerID,SerialNo,CertName,CertResult,CertOrg,AuthDate,ValidDate," +
					" InputOrgID,getOrgName(InputOrgID) as OrgName,InputUserID,getUserName(InputUserID) as UserName " +
					" from ENT_AUTH " +
					" where CustomerID='"+sCustomerID+"' "+
					" and CertType='01' ";


	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置修改表名
	doTemp.UpdateTable = "ENT_AUTH";
    //设置主键
	doTemp.setKey("CustomerID,SerialNo",true);
	doTemp.setCheckFormat("AuthDate,ValidDate","3");
	//设置不可见
	doTemp.setVisible("CustomerID,SerialNo,CertResult,InputOrgID,InputUserID",false);
	//设置不可修改的列
	doTemp.setUpdateable("UserName,OrgName",false);
	//设置列宽度
	doTemp.setHTMLStyle("OrgName,CertOrg","style={width:200px}");	
	doTemp.setHTMLStyle("UserName"," style={width:80px} ");
	

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读


	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","新增","新增认证情况","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看认证情况","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除认证情况","deleteRecord()",sResourcesPath},
		};
	%>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	//---------------------定义按钮事件------------------------------------
	/*~[Describe=新增记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/AuthInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
	    sUserID=getItemValue(0,getRow(),"InputUserID");//--用户代码  
		sCustomerID = getItemValue(0,getRow(),"CustomerID");//--客户代码
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else if(sUserID=='<%=CurUser.UserID%>')
		{
    		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
    		{
    			as_del('myiframe0');
    			as_save('myiframe0');  //如果单个删除，则要调用此语句
    		}
		}else alert(getHtmlMessage('3'));
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
	    sUserID=getItemValue(0,getRow(),"InputUserID");//--用户代码
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01';
	    sSerialNo   = getItemValue(0,getRow(),"SerialNo");//--流水号
		sCustomerID   = getItemValue(0,getRow(),"CustomerID");//--客户代码
		
		if (typeof(sCustomerID)=="undefined" || sCustomerID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenPage("/CustomerManage/EntManage/AuthInfo.jsp?CustomerID="+sCustomerID+"&SerialNo="+sSerialNo+"&EditRight="+sEditRight, "_self","");
		}
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
