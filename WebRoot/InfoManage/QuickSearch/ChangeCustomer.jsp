<%@ page contentType="text/html; charset=GBK" %>
<%@ include file="/IncludeBegin.jsp" %>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
<%
	/*
         Author: 2010-05-11	wwhe
         Tester:
         Describe: 客户重点链接
         Input Param:
         Output param:
         History Log:

      */
%>
<%
	/*~END~*/
%>

<%
	String sCustomerID = DataConvert.toRealString(iPostChange, (String) CurComp.getParameter("CustomerID"));
    if (sCustomerID == null) sCustomerID = "";
%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/
%>
<%
	String PG_TITLE = "客户重点链接"; // 浏览器窗口标题 <title> PG_TITLE </title>
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/
%>
<%
	//定义变量：SQL语句
    String sSql = "";
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/
%>
<%
	//通过显示模版产生ASDataObject对象doTemp
    String[][] sHeaders = {
		            {"CustomerID", "客户编号"},
		            {"EnterpriseName", "客户名称"},
		            {"RealtyFlag", "客户重点链接类型"},
		            {"IndustryType1", "特殊客户类型"},
		            {"ProjectFlag", "名单制类型"},
		            {"IndustryType", "国标行业分类"},
		            {"IndustryTypeName", "国标行业分类"},
		            {"IndustryType2", "本行行业类型"},
		            {"Flag3", "行内客户类型"},
		            {"EconomyType","经营类型"}
    };
    sSql = 	" select CustomerID,EnterpriseName,RealtyFlag,IndustryType1,ProjectFlag, "+
    		" IndustryType,getItemName('IndustryType',IndustryType) as IndustryTypeName,IndustryType2,Flag3,EconomyType "+
            " from ENT_INFO "+
            " where CustomerID= '" + sCustomerID + "' ";

    //通过SQL产生ASDataObject对象doTemp
    ASDataObject doTemp = new ASDataObject(sSql);
    //设置标题
    doTemp.setHeader(sHeaders);
    doTemp.UpdateTable = "ENT_INFO";
    doTemp.setKey("CustomerID", true);
    doTemp.setUpdateable("IndustryTypeName", false);
    //设置数据类型
    doTemp.setDDDWCode("RealtyFlag","RealtyFlag");
    doTemp.setDDDWCode("IndustryType1","IndustryType1");
    doTemp.setDDDWCode("ProjectFlag","ProjectFlag");
    doTemp.setDDDWCode("IndustryType2","BankIndustryType");
    doTemp.setDDDWCode("Flag3","CustomerType2");
    doTemp.setDDDWCode("EconomyType","EconomyType");
    doTemp.appendHTMLStyle("IndustryTypeName"," onClick=\"javascript:parent.getIndustryType()\" ");
    doTemp.setVisible("IndustryType",false);
    doTemp.setReadOnly("IndustryTypeName,CustomerID,EnterpriseName",true);
    
    if(!CurUser.hasRole("000")){
    	doTemp.setVisible("IndustryType1,ProjectFlag,IndustryTypeName,IndustryType2,Flag3",false);
    }

    ASDataWindow dwTemp = new ASDataWindow(CurPage, doTemp, Sqlca);
    dwTemp.Style = "2";      //设置DW风格 1:Grid 2:Freeform
    dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写

    //生成HTMLDataWindow
    Vector vTemp = dwTemp.genHTMLDataWindow("");
    for (int i = 0; i < vTemp.size(); i++) out.print((String) vTemp.get(i));
    session.setAttribute(dwTemp.Name, dwTemp);
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
            {"true", "", "Button", "保存", "保存使用额度信息", "saveRecord()", sResourcesPath}
    };
%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=Info05;Describe=主体页面;]~*/
%>
<%@ include file="/Resources/CodeParts/Info05.jsp" %>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info06;Describe=定义按钮事件;]~*/
%>
<script language=javascript>
    /*~[Describe=取消新增授信方案;InputParam=无;OutPutParam=取消标志;]~*/
    function doCancel() {
        top.returnValue = "_CANCEL_";
        top.close();
    }
</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/
%>

<script language=javascript>

    /*~[Describe=保存数入的金额;InputParam=无;OutPutParam=无;]~*/
    function saveRecord(sPostEvents)
    {
    	as_save("myiframe0", sPostEvents);
    	close();
    }

	/*~[Describe=弹出国标行业类型选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function getIndustryType()
	{
		var sIndustryType = getItemValue(0,getRow(),"IndustryType");
		//由于行业分类代码有几百项，分两步显示行业代码
		sIndustryTypeInfo = PopComp("IndustryVFrame","/Common/ToolsA/IndustryVFrame.jsp","IndustryType="+sIndustryType,"dialogWidth=45;dialogHeight=25;center:yes;status:no;statusbar:no","");
		//sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];//-- 行业类型代码
			sIndustryTypeName = sIndustryTypeInfo[1];//--行业类型名称
			setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
			setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);				
		}
	}

    /*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
    function initRow()
    {
    	
    }

</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/
%>
<script language=javascript>
    AsOne.AsInit();
    init();
    my_load(2, 0, 'myiframe0');
    initRow();
    //页面装载时，对DW当前记录进行初始化
</script>
<%
	/*~END~*/
%>

<%@ include file="/IncludeEnd.jsp" %>