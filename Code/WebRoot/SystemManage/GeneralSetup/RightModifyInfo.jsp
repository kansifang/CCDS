<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29 
		Tester:
		Describe: 客户管理权维护（系统没有记录操作日志，如银行有此需求，请保存时进行添加）
		Input Param:
			CustomerID：当前客户编号
			SerialNo:	流水号
		Output Param:
			CustomerID：当前客户编号

		HistoryLog:
			     ndeng 2004-11-30
	 */
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户管理权维护信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	
	//获得页面参数
	
	//获得组件参数	
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	//将空值转化为空字符串
	if(sCustomerID == null) sCustomerID = "";
	if(sOrgID == null) sOrgID = "";	
	if(sUserID == null) sUserID = "";
		
%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = {     
	                            {"CustomerID","组织机构代码"},
	                            {"CustomerName","客户名称"},
	                            {"OrgName","机构名称"},
	                            {"UserName","客户经理"},
	                            {"BelongAttribute","客户主办权"},                               
                                {"BelongAttribute1","信息查看权"},
                                {"BelongAttribute2","信息维护权"},
                                {"BelongAttribute3","业务申办权"},
	                            {"InputOrgName","登记机构"},
	                            {"InputUserName","登记人"},
	                            {"InputDate","登记日期"},
	                            {"UpdateDate","更新日期"},
	                            {"Remark","备注"}
							};    	  		   		
	
	
	String sSql = " select CustomerID,getCustomerName(CustomerID) as CustomerName,"+
				  " OrgID,getOrgName(OrgID) as OrgName," +
	              " UserID,getUserName(UserID) as UserName,"+
	              " BelongAttribute,"+
                  " BelongAttribute1,"+
                  " BelongAttribute2,"+
                  " BelongAttribute3,"+
                  " BelongAttribute4,"+
	              " Remark," +
				  " InputOrgID,getOrgName(InputOrgID) as InputOrgName,InputUserID,getUserName(InputUserID) as InputUserName,InputDate,UpdateDate " +
	              " from CUSTOMER_BELONG " +
	              " where CustomerID = '"+sCustomerID+"' " +
	              " and OrgID = '"+sOrgID+"' " +
	              " and UserID = '"+sUserID+"' " ;
    //用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	
	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_BELONG";
	doTemp.setKey("CustomerID,OrgID,UserID",true);	 //为后面的删除
	doTemp.setRequired("CustomerName,OrgName,UserName,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4",true);
	
	//设置不可见项
	doTemp.setVisible("CustomerID,BelongAttribute4,InputOrgID,InputUserID,OrgID,UserID",false);
	
	//通常用于外部存储函数得到的字段
	doTemp.setUpdateable("CustomerName,UserName,OrgName,InputOrgName,InputUserName",false);
	doTemp.setHTMLStyle("UserName,OrgName,InputUserName,InputDate,UpdateDate"," style={width:80px} ");
	doTemp.setHTMLStyle("Remark"," style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("OrgName,BelongAttribute,BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4"," style={width:300px} ");
	doTemp.setReadOnly("OrgName,UserName,CustomerName,InputOrgName,InputUserName,InputDate,UpdateDate,BelongAttribute2",true);
	doTemp.setHTMLStyle("InputOrgName"," style={width:250px} ");
	doTemp.setDDDWCode("BelongAttribute","HaveNot");
	doTemp.setDDDWCode("BelongAttribute1","HaveNot");
	doTemp.setDDDWCode("BelongAttribute2","HaveNot");
	doTemp.setDDDWCode("BelongAttribute3","HaveNot");	
	doTemp.appendHTMLStyle("BelongAttribute","onchange=parent.checkApplyAttribute()");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));

	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info04;Describe=定义按钮;]~*/%>
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
		{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath}		
		};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/Info05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/%>
	<script language=javascript>
	var bIsInsert = false; //标记DW是否处于“新增状态”

	//---------------------定义按钮事件------------------------------------

	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord()
	{		
		var sCustomerID = getItemValue(0,getRow(),"CustomerID");//--获得客户编号
		var sUserID = getItemValue(0,getRow(),"UserID");//--获得用户编号
		var sBelongAttribute =  getItemValue(0,getRow(),"BelongAttribute");//--获得客户主办权标志
        var sBelongAttribute1 = getItemValue(0,getRow(),"BelongAttribute1");//--获得信息查看权标志
        var sBelongAttribute2 = getItemValue(0,getRow(),"BelongAttribute2");//--获得信息维护权标志
        var sBelongAttribute3 = getItemValue(0,getRow(),"BelongAttribute3");//--获得业务申办权标志
        var sBelongAttribute4 = getItemValue(0,getRow(),"BelongAttribute4");//--获得待定的权限标志
        sReturn = PopPage("/CustomerManage/AuthorizeRoleAction.jsp?CustomerID="+sCustomerID+"&UserID="+sUserID+"&ApplyAttribute="+sBelongAttribute+"&ApplyAttribute1="+sBelongAttribute1+"&ApplyAttribute2="+sBelongAttribute2+"&ApplyAttribute3="+sBelongAttribute3+"&ApplyAttribute4="+sBelongAttribute4,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
        sReturn = sReturn.split("@");
        sHave = sReturn[0];
        sOrgName = sReturn[1];
        sUserName = sReturn[2];
        sBelongUserID = sReturn[3];
        if(sHave == "_TRUE_")
        {
            if(confirm(sOrgName+" "+sUserName+" "+"已经拥有该客户的主办权！是否继续？如果主办权转移，原有主办权人则自动丧失一切客户权利，如有需求则需重新申请！"))
            {
                PopPage("/CustomerManage/ChangeRoleAction.jsp?CustomerID=<%=sCustomerID%>&UserID=<%=sUserID%>&BelongUserID="+sBelongUserID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
                alert(getBusinessMessage('224'));//客户权限保存成功！
            }            
        }
        else
        {
            alert(getBusinessMessage('224'));//客户权限保存成功！
        }
        bCheckBeforeUnload=false;
	}
		
	function checkApplyAttribute()
    {
        var sBelongAttribute = getItemValue(0,getRow(),"BelongAttribute");//--获得是否申请客户主办权标志
        if(sBelongAttribute == "1")
        {
            setItemValue(0,0,"BelongAttribute1","1");
            setItemValue(0,0,"BelongAttribute2","1");
            setItemValue(0,0,"BelongAttribute3","1");
            setItemValue(0,0,"BelongAttribute4","1");
        }
        else
        {
        	setItemValue(0,0,"BelongAttribute2","2");
        }
    }	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
		
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');	
</script>	
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>