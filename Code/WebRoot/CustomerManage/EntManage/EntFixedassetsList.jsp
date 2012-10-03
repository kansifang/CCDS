<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
<%
/*
*	Author: XWu 2004-11-29
*	Tester:
*	Describe: 客户固定资产信息列表;
*	Input Param:
*		CustomerID：客户编号
*	Output Param:     
*        CustomerID：--当前客户编号
*		 SerialNo:	--具体信息流水号
*		 EditRight:--权限代码（01：查看权；02：维护权）
*	HistoryLog:
*/
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "固定资产信息列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	
	//获得页面参数

	//获得组件参数
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {	
							{"SerialNo","流水号"},
							{"CustomerID","客户编号"},
							{"UpToDate","账务截至日期"},
							{"FixedAssetsType","固定资产类型"},
							{"Currency","币种"},
							{"FormerValue","入帐价值"},
							{"EvalValue","资产净值"},
							{"Remark","备注"},
							{"Location","处所位置"},
							{"FixedAssetsName","固定资产名称"},
							{"CertificateNo","权利证书号"},
							{"EvalDate","评估日期"},
							{"EvalOrg","评估机构"},
							{"UseMethod","使用方式"},
							{"FixedAssetsStatus","资产状态"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"},
							{"InputDate","登记日期"},
							{"UpdateDate","更新日期"}
						  };
						  
	String sSql = 	" Select SerialNo, " +
					" CustomerID, " +
					" UpToDate, " +
					" getItemName('AssetsType',FixedAssetsType) as FixedAssetsType, " +
					" getItemName('Currency',Currency) as Currency, " +
					" FormerValue, " +
					" EvalValue, " +
					" Remark, " +
					" Location, " +
					" FixedAssetsName, " +
					" CertificateNo, " +
					" EvalDate, " +
					" EvalOrg, " +
					" UseMethod, " +
					" FixedAssetsStatus, " +
					" InputUserID, " +
					" InputOrgID, " +
					" getUserName(InputUserID) as InputUserName, "+
					" getOrgName(InputOrgID) as InputOrgName, "+
					" InputDate, " +
					" UpdateDate " +
					" from ENT_FIXEDASSETS " +
					" Where CustomerID = '"+sCustomerID+"'";	  

	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);

	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("SerialNo,CustomerID,Remark,Location,FixedAssetsName,CertificateNo,InputUserID,InputOrgID",false);
	doTemp.setVisible("EvalDate,EvalOrg,UseMethod,FixedAssetsStatus,InputDate,UpdateDate",false);
	doTemp.UpdateTable = "ENT_FIXEDASSETS";

	doTemp.setType("FormerValue,EvalValue","Number");
	//设置数字型，对应设置模版"值类型 2为小数，5为整型"
	doTemp.setCheckFormat("FormerValue,EvalValue","2");

	//doTemp.setAlign("UpToDate,InputDate,UpdateDate","2");
	doTemp.setCheckFormat("UpdateDate,InputDate","3");
    doTemp.setHTMLStyle("InputOrgName","style={width:200px}"); 			
	doTemp.setAlign("FixedAssetsType,Currency","2");
	doTemp.setHTMLStyle("UpToDate,FixedAssetsType,Currency,InputUserID,InputOrgID"," style={width:80px} ");

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
		{"true","","Button","新增","新增固定资产信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看固定资产详细信息","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除固定资产信息","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/EntFixedassetsInfo.jsp?EditRight=02","_self","");
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
		sUserID=getItemValue(0,getRow(),"InputUserID");//--用户代码
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
			OpenPage("/CustomerManage/EntManage/EntFixedassetsInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight,"_self","");
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
