<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:jjwang  2008.10.07
		Tester:
		Content: 数据采集  对个数据维护
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "对个数据维护"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量

	//获得组件参数

	//获得页面参数
	String sAccountMonth =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth==null) sAccountMonth="";
	String sLoanAccount =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));
	if(sLoanAccount==null) sLoanAccount="";
	String sIsManageUser = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("IsManageUser"));
	if(sIsManageUser == null) sIsManageUser = "";
	String sMFiveClassify = "" ,sAFiveClassify = "",sManageStatFlag="";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ReserveDataIndInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable = "Reserve_Total";
	doTemp.setVisible("SubjectNo,DuebillNo,CustomerOrgCode,OverDueDays",false);
	//doTemp.setUnit("AccountMonth","<input type=\"button\" class=\"inputDate\" value=\"...\" onclick=\"parent.selectAccountMonth()\">");
    //doTemp.setUnit("CountryCodeName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectCountryCode()>");
	//doTemp.setUnit("RegionName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.getRegionCode(\"ent\")>(当选择国家为中国时请选择具体省市)");
	doTemp.setHTMLStyle("AccountMonth","style={width:80}");
	doTemp.setHTMLStyle("VouchTypeName","style={width:360}");
	doTemp.setUnit("VouchTypeName", "<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectVouchType()>");
	doTemp.appendHTMLStyle("ManageStatFlag"," onchange=\"javascript:parent.selAuditStatFlag()\" ");
	if(!CurUser.hasRole("608"))
	{
		doTemp.setVisible("MFiveClassify,AFiveClassify,AuditStatFlag,ManageStatFlag",false);
	}
 	if("true".equals(sIsManageUser))
    {
    	doTemp.setReadOnly("BusinessSum,MFiveClassify,AuditStatFlag",false);
    }
	/*
	String sSql = "select MFiveClassify,AFiveClassify from reserve_total where LoanAccount = '"+sLoanAccount+"'";
    ASResultSet rs = null;
    rs = Sqlca.getASResultSet(sSql);
    if(rs.next()){
			sMFiveClassify = rs.getString("MFiveClassify");
			sAFiveClassify = rs.getString("AFiveClassify");
		}
	rs.getStatement().close();
	if(sMFiveClassify.equals("01") || sMFiveClassify.equals("02"))
	{
		doTemp.setHeader("MBadLastPrdDiscount","管理层口正常贷款径上期预测现金流本期贴现值");
		doTemp.setHeader("MBadPrdDiscount","管理层口径正常贷款本期预测现金流贴现值");
		doTemp.setHeader("MBadReserveSum","管理层口径正常贷款本期计提减值准备");
		doTemp.setHeader("MBadMinusSum","管理层口径正常贷款本期转回减值准备");
		doTemp.setHeader("MBadRetSum","管理层口径正常贷款本期折现回拨减值准备");
		doTemp.setHeader("MBadReserveBalance","管理层口径正常贷款本期减值准备余额");
	}
	if(sAFiveClassify.equals("01") || sAFiveClassify.equals("02"))
	{
		doTemp.setHeader("ABadLastprdDiscount","审计口径正常贷款上期预测现金流本期贴现值");
		doTemp.setHeader("ABadPrdDiscount","审计口径正常贷款本期预测现金流贴现值");
		doTemp.setHeader("ABadReserveSum","审计口径正常贷款本期计提减值准备");
		doTemp.setHeader("ABadMinusSum","审计口径正常贷款本期转回减值准备");
		doTemp.setHeader("ABadRetSum","审计口径正常贷款本期折现回拨减值准备");
		doTemp.setHeader("ABadReserveBalance","审计口径正常贷款本期减值准备余额");
	}
	*/
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccountMonth+","+sLoanAccount);
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//session.setAttribute(dwTemp.Name,dwTemp);
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
		{"true","","Button","返回","返回","goBack()",sResourcesPath}
		};
	if("true".equals(sIsManageUser))
    {
    	sButtons[0][0] = "true";
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
	function selectCountryCode()
	{		
		sParaString = "CodeNo"+","+"CountryCode";			
		sCountryCodeInfo = setObjectValue("SelectCode",sParaString,"@CountryCode@0@CountryCodeName@1",0,0,"");
		if (typeof(sCountryCodeInfo) != "undefined" && sCountryCodeInfo != "" )
		{
			sCountryCodeInfo = sCountryCodeInfo.split('@');
			CountryCode = sCountryCodeInfo[0];//-- 所在国家(地区)代码
			setItemValue(0,getRow(),"CountryCode",CountryCode);			
		}
	}
	
	function getRegionCode(flag)
	{
		//判断国家有没有选中国
		var sCustomerType="01";
		var sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");
		var sRegionInfo;
		if (flag == "ent")
		{
			if(sCustomerType.substring(0,2) == "01")//公司客户要求先选所在国家或地区，再选择具体省市
			{
				//判断国家是否已经选了
				if (typeof(sCountryTypeValue) != "undefined" && sCountryTypeValue != "" )
				{
					if(sCountryTypeValue == "142")
					{
						sParaString = "CodeNo"+",AreaCode";			
						setObjectValue("SelectCode",sParaString,"@Region@0@RegionName@1",0,0,"");
					}else
					{
						alert(getBusinessMessage('122'));//所选国家不是中国，无需选择地区
						return;
					}
				}else
				{
					alert(getBusinessMessage('123'));//尚未选择国家，无法选择地区
					return;
				}
			}else
			{
				sParaString = "CodeNo"+",AreaCode";			
				setObjectValue("SelectCode",sParaString,"@Region@0@RegionName@1",0,0,"");
			}
		}else 	//区分企业客户的行政区域和个人的籍贯
		{
			sParaString = "CodeNo"+",AreaCode";			
			setObjectValue("SelectCode",sParaString,"@Region@0@RegionName@1",0,0,"");
		}
	}	
	
	function selectAccountMonth()
	{
		var sAccountMonth = PopPage("/Common/ToolsA/SelectMonth.jsp?rand="+randomNumber(),"","dialogWidth=21;dialogHeight=15;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sAccountMonth)!="undefined" && sAccountMonth!="")
		{	
			setItemValue(0,0,"AccountMonth",sAccountMonth);
		}
		else
			setItemValue(0,0,"AccountMonth","");
	}
	
	function selectVouchType() 
	{
    	sParaString = "CodeNo" + "," + "VouchType";
    	setObjectValue("SelectCode", sParaString, "@VouchType@0@VouchTypeName@1", 0, 0, "");
	}
	
	//检测计提模式是否可以更改
	function selAuditStatFlag()
	{
		sMFiveClassify = getItemValue(0,getRow(),"MFiveClassify");
		sAFiveClassify = getItemValue(0,getRow(),"AFiveClassify");
		if(sMFiveClassify > 02 || sAFiveClassify > 02)
		{
			alert("五级分类为不良,不可以将计提模式设为组合计提");
			setItemValue(0,0,"ManageStatFlag","2");
			return;
		}
	}
	/*~[Describe=保存;InputParam=后续事件;OutPutParam=无;]~*/
	function saveRecord(sPostEvents)
	{
		if(bIsInsert){
			beforeInsert();
		}
		else{
			beforeUpdate();
		}
		sMFiveClassify = getItemValue(0,getRow(),"MFiveClassify");
		sAFiveClassify = getItemValue(0,getRow(),"AFiveClassify");
		sManageStatFlag = getItemValue(0,getRow(),"ManageStatFlag");
		if(sMFiveClassify =="03" || sMFiveClassify =="04" || sMFiveClassify =="05" || sAFiveClassify == "03" || sAFiveClassify == "04" || sAFiveClassify == "05")
		{
			if(sManageStatFlag == "1")
			{
				alert("五级分类为不良,不可以将计提模式设为组合计提");
				setItemValue(0,0,"ManageStatFlag","2");
				return;
			}
		}
		as_save("myiframe0",sPostEvents);
	}

	function goBack()
	{
		self.close();
	}
	
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>
	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		
	}
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			bIsInsert = true;
		}
    }
    
	</script>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>
	AsOne.AsInit();
	init();
	var bFreeFormMultiCol = true;
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>
<%/*~END~*/%>

<%@ include file="/IncludeEnd.jsp"%>
