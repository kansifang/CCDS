<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: XWu 2004-11-29
*	Tester:
*	Describe: 客户无形资产信息列表;
*	Input Param:
*		CustomerID：客户编号
*	Output Param:     
*       CustomerID：--当前客户编号
*		SerialNo:	--具体信息流水号
*		EditRight:--权限代码（01：查看权；02：维护权） 
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "无形资产列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql ="";

	//获得页面参数

	//获得组件参数
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = { 
							{"CustomerID","个人编号"},
							{"SerialNo","流水号"},
							{"AssetTypeName","资产类型"},
							{"AuthNo","证书编号"},
							{"AssetDescribe","资产简述"},
							{"AuthOrg","认证机构"},
							{"AuthDate","认证日期"},
							{"AccountValue","入帐价值(元)"},
							{"UpToDate","统计截止日期"},
							{"OrgName","登记单位"},
							{"UserName","登记人"},
							{"InputDate","登记日期"},
							{"UpdateDate","更新日期"},
							{"AssetName","资产名称"}
						  };

		sSql =	" select CustomerID,SerialNo,AssetType,getItemName('ImmaterialAssetType',AssetType) as AssetTypeName,"+
				" AssetName,AuthNo,AssetDescribe,AuthOrg,AuthDate,AccountValue,UpToDate,"+
				" InputOrgID,getOrgName(InputOrgID) as OrgName," +
				" InputUserID,getUserName(InputUserID) as UserName," +
				" InputDate,UpdateDate"+
				" from CUSTOMER_IMASSET"+
				" where CustomerID='"+sCustomerID+"'"+
				" order by CustomerID";


	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.setUpdateable("AssetTypeName,OrgName,UserName",false);
	
	doTemp.setAlign("AccountValue","3");
	doTemp.setAlign("AuthDate,UpToDate,InputDate,UpdateDate,AssetTypeName","2");
	
	doTemp.setHTMLStyle("AuthDate,UpToDate,InputDate,UpdateDate"," style={width:70px} ");
	doTemp.setHTMLStyle("AssetName,AuthOrg"," style={width:150px} ");
	doTemp.setCheckFormat("UpdateDate,InputDate","3");
    doTemp.setHTMLStyle("OrgName","style={width:200px}"); 	
	doTemp.UpdateTable="CUSTOMER_IMASSET";
	
	doTemp.setKey("CustomerID,SerialNo",true);
	doTemp.setVisible("InputUserID",false);
	doTemp.setUpdateable("UserName",false);		
	doTemp.setCheckFormat("UpToDate,InputDate,UpdateDate","3");	
	doTemp.setCheckFormat("AccountValue","2");
	doTemp.setType("AccountValue","Number");
	
	doTemp.setVisible("CustomerID,SerialNo,InputUserID,InputOrgID,AssetType,AuthDate,AuthNo,AssetDescribe,UpToDate",false);

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
		{"true","","Button","新增","新增客户无形资产信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看客户无形资产详细信息","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除客户无形资产信息","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/EntImassetsInfo.jsp?EditRight=02","_self","");
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
	  	sUserID=getItemValue(0,getRow(),"InputUserID");  
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
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
    	sUserID=getItemValue(0,getRow(),"InputUserID");
		if(sUserID=='<%=CurUser.UserID%>')
			sEditRight='02';
		else
			sEditRight='01';	
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}else
		{
			OpenPage("/CustomerManage/EntManage/EntImassetsInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight,"_self","");
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

<%@include file="/IncludeEnd.jsp"%>
