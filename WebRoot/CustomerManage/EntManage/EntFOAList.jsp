<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: ndeng 2004-11-30
		Tester:
		Describe: 企业应收应付帐款信息
		Input Param:
			CustomerID：当前客户编号
		Output Param:
			CustomerID：当前客户编号
			SerialNo:流水号
			EditRight:--权限代码（01：查看权；02：维护权）
		HistoryLog:
	 */
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "企业应收应付帐款信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得页面参数	
	
	//获得组件参数	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sCustomerID == null) sCustomerID = "";			

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头				
	String sHeaders[][] = { 
                            {"CustomerID","客户编号"},
                            {"SerialNo","流水号"},
                            {"UpToDate","账务截至日期"},
                            {"FOAType","帐款类型"},
                            {"AccountYears","帐龄"}, 
                            {"FOACurrency","币种"}, 
                            {"FOASum","金额"},   
                            {"OrgName","登记机构"},
                            {"UserName","登记人"}
			              };   		   		
	
	sSql = 	"  select CustomerID,SerialNo,UpToDate,getItemName('FundsType',FOAType) as FOAType," +
			"  getItemName('FundsAge',AccountYears) as AccountYears,getItemName('Currency',FOACURRENCY) as FOACURRENCY,FOASUM," +
			"  InputOrgId,getOrgName(InputOrgId) as OrgName,InputUserId,getUserName(InputUserId) as UserName " +
			"  from ENT_FOA" +
			"  where CustomerID ='"+sCustomerID+"'";
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "ENT_FOA";
	doTemp.setKey("CustomerID,SerialNo",true);	 //为后面的删除
	//设置不可见项
	doTemp.setVisible("CustomerID,SerialNo,InputOrgId,InputUserId",false);	    
	//通常用于外部存储函数得到的字段
	doTemp.setUpdateable("UserName,OrgName",false);   
	//设置显示文本框的长度
	//doTemp.setCheckFormat("UpToDate","3");
	doTemp.setHTMLStyle("UserName"," style={width:80px} ");
    doTemp.setHTMLStyle("OrgName","style={width:200px}"); 	
	//设置小数显示状态,
	doTemp.setAlign("FOASum","3");
	doTemp.setAlign("FOAType,AccountYears,FOACurrency","2");
	doTemp.setType("FOASum","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("FOASum","2");
	
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
		{"true","","Button","新增","新增应收应付账款信息","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看应收应付账款信息详情","viewAndEdit()",sResourcesPath},
		{"true","","Button","删除","删除应收应付账款信息","deleteRecord()",sResourcesPath},
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
		OpenPage("/CustomerManage/EntManage/EntFOAInfo.jsp?EditRight=02","_self","");
	}
	

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
	  	sUserID=getItemValue(0,getRow(),"InputUserId");
		sCustomerID = getItemValue(0,getRow(),"CustomerID");		
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
        sUserID=getItemValue(0,getRow(),"InputUserId");//--用户代码
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
        	OpenPage("/CustomerManage/EntManage/EntFOAInfo.jsp?SerialNo="+sSerialNo+"&EditRight="+sEditRight, "_self","");
        }
    }
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>

	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>

