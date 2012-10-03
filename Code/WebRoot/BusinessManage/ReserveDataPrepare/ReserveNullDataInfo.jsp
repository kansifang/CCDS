<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<%
	/*
		Author:jjwang  2008.10.07
		Tester:
		Content: 数据采集  非信贷数据维护显示界面
		Input Param:
		Output param:
		History Log:
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "非信贷数据维护显示界面"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量

	//获得组件参数

	//获得页面参数
	String sAccountMonth =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth==null) sAccountMonth="";
	String sAssetNo =  DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AssetNo"));
	if(sAssetNo==null) sAssetNo="";
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ReserveNullDataInfo";
	String sTempletFilter = "1=1";

	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	doTemp.UpdateTable = "ReserveNull_Total";
	
	//doTemp.setUnit("AccountMonth","<input type=\"button\" class=\"inputDate\" value=\"...\" onclick=\"parent.selectAccountMonth()\">");
	doTemp.setUnit("CountryCodeName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectCountryCode()>");
	doTemp.setUnit("RegionName","<input class=\"inputdate\" value=\"...\" type=button onClick=parent.getRegionCode(\"ent\")>(当选择国家为中国时请选择具体省市)");
	doTemp.setVisible("DuebillNo,CustomerID",false);
    doTemp.setAlign("Interest,RetSum,OmitSum","3");
    doTemp.appendHTMLStyle("Balance"," onBlur=\"javascript:parent.setRMBBalance()\" ");
	doTemp.appendHTMLStyle("ExchangeRate"," onBlur=\"javascript:parent.setRMBBalance()\" ");
    doTemp.setUnit("VouchTypeName", "<input class=\"inputdate\" value=\"...\" type=button onClick=parent.selectVouchType()>");
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sAccountMonth+","+sAssetNo);
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
	function getIndustryType()
	{
   		 //由于行业分类代码有几百项，分两步显示行业代码
    	sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand=" + randomNumber(), "", "dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");

    	if (sIndustryTypeInfo == "NO")
    	{
       	 	setItemValue(0, getRow(), "Direction", "");
        	setItemValue(0, getRow(), "DirectionName", "");
    	}
    	else if (typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
    	{
        	sIndustryTypeInfo = sIndustryTypeInfo.split('@');
        	sIndustryTypeValue = sIndustryTypeInfo[0];
        	sIndustryTypeName = sIndustryTypeInfo[1];

        	sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryTypeValue=" + sIndustryTypeValue, "", "dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
        	if (sIndustryTypeInfo == "NO")
        	{
            	setItemValue(0, getRow(), "Direction", "");
            	setItemValue(0, getRow(), "DirectionName", "");
        	} else if (typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
        	{
            	sIndustryTypeInfo = sIndustryTypeInfo.split('@');
            	sIndustryTypeValue = sIndustryTypeInfo[0];
            	sIndustryTypeName = sIndustryTypeInfo[1];
            	setItemValue(0, getRow(), "Direction", sIndustryTypeValue);
            	setItemValue(0, getRow(), "DirectionName", sIndustryTypeName);
        	}
    	}
	}
	function selectVouchType() 
	{
    	sParaString = "CodeNo" + "," + "VouchType";
    	setObjectValue("SelectCode", sParaString, "@VouchType@0@VouchTypeName@1", 0, 0, "");
	}
	
	function setRMBBalance()
	{
		if(getActureVale()==false)
		{
			return;
		}
		else
		{
			var dBalance=getItemValue(0,getRow(),"Balance");
			var dExchangeRate=getItemValue(0,getRow(),"ExchangeRate");
			setItemValue(0,0,"RMBBalance",dBalance*dExchangeRate);
		}
	}
	function getActureVale()
	{
		var sBalance=getItemValue(0,getRow(),"Balance");
		if(typeof(sBalance)=="undefined" || sBalance.length==0)
		{
			return false;
		}
		var sExchangeRate=getItemValue(0,getRow(),"ExchangeRate");
		if(typeof(sExchangeRate)=="undefined" || sExchangeRate.length==0)
		{
			return false;
		}
		return true;
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
			setItemValue(0,0,"LoanAccount","<%=sAssetNo%>");
			setItemValue(0,0,"AccountMonth","<%=sAccountMonth%>");
			setItemValue(0,0,"BusinessFlag","3");
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
