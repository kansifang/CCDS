<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  --fbkang 2005.7.25
		Tester:
		Content: --权限申请页面
		Input Param:
            CustomerID：客户号
            UserID：用户代码
            OrgID：机构代码
            Check：检查标志
		Output param:
			               
		History Log: 
		
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户权限申请情况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量

	//获得组件参数：客户编号、用户ID、机构ID、检查标志
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sUserID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("UserID"));
	String sOrgID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OrgID"));
    String sCheck = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Check"));
    //将空值转化为空字符串
    if(sCustomerID == null) sCustomerID = "";
    if(sUserID == null) sUserID = "";
    if(sOrgID == null) sOrgID = "";
    if(sCheck == null) sCheck = "";
    
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	String sHeaders[][] = {										
								{"CertID","证件号码"},
								{"CustomerName","客户名称"},
                                {"ApplyAttribute","是否申请客户主办权"},   
                                {"ApplyAttribute1","是否申请信息查看权"},
                                {"ApplyAttribute2","是否申请信息维护权"},
                                {"ApplyAttribute3","是否申请业务申办权"},
								{"ApplyReason","申请理由"}
						  };

	String sSql =	" select CI.CustomerID as CustomerID,CB.UserID as UserID,CB.OrgID as OrgID, "+
					" CI.CertID as CertID,CI.CustomerName as CustomerName, "+
					" CB.ApplyAttribute as ApplyAttribute,CB.ApplyAttribute1 as ApplyAttribute1, "+
					" CB.ApplyAttribute2 as ApplyAttribute2,CB.ApplyAttribute3 as ApplyAttribute3, "+
					" CB.ApplyAttribute4 as ApplyAttribute4,CB.BelongAttribute as BelongAttribute, "+
					" CB.BelongAttribute1 as BelongAttribute1,CB.BelongAttribute2 as BelongAttribute2, "+
					" CB.BelongAttribute3 as BelongAttribute3,CB.BelongAttribute4 as BelongAttribute4,"+
					" CB.ApplyStatus as ApplyStatus,CB.ApplyReason as ApplyReason"+
					" from CUSTOMER_INFO CI,CUSTOMER_BELONG CB " +
					" where CI.CustomerID=CB.CustomerID and CB.CustomerID='"+sCustomerID+"' and UserID='"+sUserID+"' and OrgID='"+sOrgID+"'";

	//由sSql生成窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头,更新表名,键值,必输项,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "CUSTOMER_BELONG";
	doTemp.setKey("CustomerID,OrgID,UserID",true);
	doTemp.setLimit("ApplyReason",200);
	//设置必输项
	doTemp.setRequired("ApplyAttribute,ApplyAttribute1,ApplyAttribute2,ApplyAttribute3,ApplyAttribute4,ApplyReason",true);   //应补登需要修改
	//设置不可见项
	doTemp.setVisible("CustomerID,UserID,OrgID,BelongAttribute,ApplyStatus,BelongAttribute1,BelongAttribute2,BelongAttribute3,BelongAttribute4,ApplyAttribute4",false);
	//设置不可更新项
	doTemp.setUpdateable("CertID,CustomerName",false);
	doTemp.setReadOnly("ApplyAttribute2",true);
    //触发事件
    doTemp.setHTMLStyle("ApplyAttribute"," onchange=parent.checkApplyAttribute() ");
    
	//设置字段格式	
	doTemp.setEditStyle("ApplyReason","3");
	doTemp.setHTMLStyle("ApplyReason"," style={height:150px;width:400px};overflow:scroll ");
	doTemp.setHTMLStyle("CustomerName"," style={width:300px} ");
	doTemp.setLimit("ApplyReason",200);
    doTemp.setReadOnly("CertID,CustomerName",true);
    if(sCheck.equals("Y"))
    {
       doTemp.setReadOnly("ApplyReason",true); 
       doTemp.setRequired("",false);
    }
	//设置下拉框来源
	doTemp.setDDDWCode("ApplyAttribute,ApplyAttribute1,ApplyAttribute2,ApplyAttribute3,ApplyAttribute4","YesNo");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";//freeform

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
			{"true","","Button","保存","保存所有修改","saveRecord()",sResourcesPath},
			{"true","","Button","提交","提交申请","Apply()",sResourcesPath},
			{"true","","Button","批准","批准申请","Authorize()",sResourcesPath},
			{"true","","Button","否决","否决申请","Overrule()",sResourcesPath}
		};
	if(sCheck.equals("Y"))
	{
	   sButtons[1][0]="false";
	}
	else
	{
	   sButtons[2][0]="false"; 
	   sButtons[3][0]="false";
	}
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
	function saveRecord(sPostEvents)
	{
		if(!checkOtherRoles())
		    return;
		as_save("myiframe0",sPostEvents);
	}
    /*~[Describe=提交;InputParam=无;OutPutParam=无;]~*/
    function Apply()
    {
        if(!checkOtherRoles())
		    return;
        var sApplyReason =  getItemValue(0,getRow(),"ApplyReason");
        if(sApplyReason=="")
        {
            alert("信息不全，提交失败！(申请理由没填)");
            return;
        }
        var sApplyAttribute =  getItemValue(0,getRow(),"ApplyAttribute");//--获得是否申请客户主办权标志
        var sApplyAttribute1 = getItemValue(0,getRow(),"ApplyAttribute1");//--获得是否申请信息查看权标志
        var sApplyAttribute2 = getItemValue(0,getRow(),"ApplyAttribute2");//--获得是否申请信息维护权标志
        var sApplyAttribute3 = getItemValue(0,getRow(),"ApplyAttribute3");//--获得是否申请业务申办权标志
        sCustomerID=getItemValue(0,getRow(),"CustomerID");
        
        if(sApplyAttribute == "1" || sApplyAttribute1=="1" || sApplyAttribute2 == "1" || sApplyAttribute3 == "1")
        {    
            setItemValue(0,0,"ApplyStatus","1"); 
            sReturnString = PopPage("/CustomerManage/GetMessageAction.jsp?CustomerID="+sCustomerID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
           	alert(sReturnString);
           	saveRecord(self.close());
        }
        else
        {
            alert("至少要提交一个权限的申请！");
        }
    }
    
    function Authorize()
    {
        if(!checkOtherRoles())
		    return;
        if(confirm("确定通过该申请吗？"))
        {
            var sApplyAttribute =  getItemValue(0,getRow(),"ApplyAttribute");//--获得是否申请客户主办权标志
            var sApplyAttribute1 = getItemValue(0,getRow(),"ApplyAttribute1");//--获得是否申请信息查看权标志
            var sApplyAttribute2 = getItemValue(0,getRow(),"ApplyAttribute2");//--获得是否申请信息维护权标志
            var sApplyAttribute3 = getItemValue(0,getRow(),"ApplyAttribute3");//--获得是否申请业务申办权标志
            var sApplyAttribute4 = getItemValue(0,getRow(),"ApplyAttribute4");//--获得待定的权限标志
            
            sReturn = PopPage("/CustomerManage/AuthorizeRoleAction.jsp?CustomerID=<%=sCustomerID%>&UserID=<%=sUserID%>&ApplyAttribute="+sApplyAttribute+"&ApplyAttribute1="+sApplyAttribute1+"&ApplyAttribute2="+sApplyAttribute2+"&ApplyAttribute3="+sApplyAttribute3+"&ApplyAttribute4="+sApplyAttribute4,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
            sReturn = sReturn.split("@");
            sHave = sReturn[0];
            sOrgName = sReturn[1];
            sUserName = sReturn[2];
            sBelongUserID = sReturn[3];
            if(sHave == "_TRUE_")
            {
                if(confirm(sOrgName+" "+sUserName+" "+"已经拥有该客户的主办权！是否继续批准？如果主办权转移，原有主办权人则自动丧失一切客户权利，如有需求则需重新申请！"))
                {
                    PopPage("/CustomerManage/ChangeRoleAction.jsp?CustomerID=<%=sCustomerID%>&UserID=<%=sUserID%>&BelongUserID="+sBelongUserID,"","resizable=yes;dialogWidth=0;dialogHeight=0;dialogLeft=0;dialogTop=0;center:yes;status:no;statusbar:yes");
                    alert("批准该客户权限成功！");
                    setItemValue(0,0,"ApplyStatus","2");
		            setItemValue(0,0,"ApplyAttribute","");
		            setItemValue(0,0,"ApplyAttribute1","");
		            setItemValue(0,0,"ApplyAttribute2","");
		            setItemValue(0,0,"ApplyAttribute3","");
		            setItemValue(0,0,"ApplyAttribute4","");
		            setItemValue(0,0,"ApplyReason","");
		            saveRecord(self.close());   
                }
            }else
            {
                alert("批准该客户权限成功！");
                setItemValue(0,0,"ApplyStatus","2");
	            setItemValue(0,0,"ApplyAttribute","");
	            setItemValue(0,0,"ApplyAttribute1","");
	            setItemValue(0,0,"ApplyAttribute2","");
	            setItemValue(0,0,"ApplyAttribute3","");
	            setItemValue(0,0,"ApplyAttribute4","");
	            setItemValue(0,0,"ApplyReason","");
	            saveRecord(self.close());   
            }
            self.close();        
        }
    }
    
    function Overrule()
    {
        if(confirm("确定否决该申请吗？"))
        {
            setItemValue(0,0,"ApplyStatus","2");
            setItemValue(0,0,"ApplyAttribute","");
            setItemValue(0,0,"ApplyAttribute1","");
            setItemValue(0,0,"ApplyAttribute2","");
            setItemValue(0,0,"ApplyAttribute3","");
            setItemValue(0,0,"ApplyAttribute4","");
            setItemValue(0,0,"ApplyReason","");
            alert("已否决该客户权限申请！");
            saveRecord(self.close());  
        }
    }
    
    function checkApplyAttribute()
    {
        var sApplyAttribute = getItemValue(0,getRow(),"ApplyAttribute");//--获得是否申请客户主办权标志
        if(sApplyAttribute == "1")
        {
            setItemValue(0,0,"ApplyAttribute1","1");
            setItemValue(0,0,"ApplyAttribute2","1");
            setItemValue(0,0,"ApplyAttribute3","1");
            setItemValue(0,0,"ApplyAttribute4","1");
        }
        else
        {
        	setItemValue(0,0,"ApplyAttribute2","2");
        }
    }
    function checkOtherRoles()
    {
        var sApplyAttribute = getItemValue(0,getRow(),"ApplyAttribute");//--获得是否申请客户主办权标志
        var sApplyAttribute1 = getItemValue(0,getRow(),"ApplyAttribute1");//--获得是否申请信息查看权标志
        var sApplyAttribute2 = getItemValue(0,getRow(),"ApplyAttribute2");//--获得是否申请信息维护权标志
        var sApplyAttribute3 = getItemValue(0,getRow(),"ApplyAttribute3");//--获得是否申请业务申办权标志
        var sApplyAttribute4 = getItemValue(0,getRow(),"ApplyAttribute4");//--未定
        
        if(sApplyAttribute == "1")
        {
            if(sApplyAttribute == "2" || sApplyAttribute2 == "2" || sApplyAttribute3 == "2" || sApplyAttribute4 == "2")
            {
                alert("你已经选择了主办权，主办权包含了各项权利，其他项不能选否");
                return false;
            }
            
        }
        
        if(sApplyAttribute2 == "1" && sApplyAttribute1 == "2")
        {            
            alert("你已经选择了信息维护权，信息维护权包含了信息查看权，信息查看权不能选否");
            return false;    
        }
        
        return true;
    }
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>
	<script language=javascript>

    function initRow()
    {
        var sBelongAttribute =  getItemValue(0,getRow(),"BelongAttribute");//--获得是否客户主办权标志
        var sBelongAttribute1 = getItemValue(0,getRow(),"BelongAttribute1");//--获得是否信用等级评定权标志
        var sBelongAttribute2 = getItemValue(0,getRow(),"BelongAttribute2");//--获得是否信息查看权标志
        var sBelongAttribute3 = getItemValue(0,getRow(),"BelongAttribute3");//--获得是否信息维护权标志
        var sBelongAttribute4 = getItemValue(0,getRow(),"BelongAttribute4");//--获得是否业务申办权标志
        
        var sApplyStatus = getItemValue(0,getRow(),"ApplyStatus");//--获得是否提交申请标志

		if(sApplyStatus != "1")
		{
	        if(sBelongAttribute == "1")
	        	setItemValue(0,0,"ApplyAttribute","1");
			else 
			 	setItemValue(0,0,"ApplyAttribute","2");
			
		    if(sBelongAttribute1 == "1")
	        	setItemValue(0,0,"ApplyAttribute1","1");
			else 
			 	setItemValue(0,0,"ApplyAttribute1","2");
			
			if(sBelongAttribute2 == "1")
	        	setItemValue(0,0,"ApplyAttribute2","1");
	    	else 
			 	setItemValue(0,0,"ApplyAttribute2","2");
		
	        if(sBelongAttribute3 == "1")
	        	setItemValue(0,0,"ApplyAttribute3","1");
	        else 
			 	setItemValue(0,0,"ApplyAttribute3","2");
		
	        if(sBelongAttribute4 == "1")
	        	setItemValue(0,0,"ApplyAttribute4","1");
	        else 
			 	setItemValue(0,0,"ApplyAttribute4","2"); 
		}	    
        
    }
    
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>

<script language=javascript>	
    //不提示页面已修改
	function isModified(objname)
	{
		return false;
	}
</script>
<%/*~END~*/%>


<%@	include file="/IncludeEnd.jsp"%>
