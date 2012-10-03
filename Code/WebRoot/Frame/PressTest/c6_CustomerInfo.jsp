<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang  2004.12.2
		Tester:
		Content: 客户概况
		Input Param:
			                sCustomerID:客户号
			                sCustomerInfoTemplet:客户概况显示模板
		Output param:
		History Log: 
		    jytian 2004.12.23  保存时加入"是否有项目"和"是否从事房地产开发"的提示
		    cwzhan 2005-1-19    当客户所在国家(地区)不是中国时，不要求输入省份、直辖市、自治区
	 */
	%>
<%/*~END~*/%> 




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户概况"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	//模板类型
	String sCustomerInfoTemplet="";
	
	//获得组件参数

	//获得页面参数	
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)request.getParameter("CustomerID"));

	String sSql;
	ASResultSet rs = null;
	
	//取得视图模板类型
	sCustomerInfoTemplet = "";
	sSql="select ItemAttribute  from CODE_LIBRARY where CodeNo ='CustomerType' and ItemNo in (select CustomerType from CUSTOMER_INFO where CustomerID ='"+sCustomerID+"' )";
    rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{ 
	   	sCustomerInfoTemplet=DataConvert.toString(rs.getString("ItemAttribute"));
	}
	rs.getStatement().close(); 
	
	if(sCustomerInfoTemplet.equals(""))
		throw new Exception("客户信息不存在或客户类型未设置！"); 
	

%>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = sCustomerInfoTemplet;
	
  
	ASDataObject doTemp = new ASDataObject(sTempletNo,Sqlca);
	
	
	//设置行业类型一选择方式
	doTemp.appendHTMLStyle("IndustryType"," style={cursor:hand;background=\"#EEEEff\"} ondblclick=\"javascript:parent.getIndustryType()\" ");
	//设置国内地区选择方式
	doTemp.appendHTMLStyle("RegionName"," style=cursor:hand; onClick=\"javascript:parent.getRegionCode()\" ");	
	//判断邮政编码
	doTemp.appendHTMLStyle("OfficeZIP"," onchange=parent.checkOfficeZIP() ");

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sCustomerID);
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
	function saveRecord(sPostEvents)
	{
	    //@author:  cwzhan 
        //@date:    2005-1-19
        //@GoTo:    保存前判断该客户所在国家(地区)为中国时是否有输入“省份、直辖市、自治区”信息
        //~end add 2005-1-19
        //判断营业执照合法性
		/*
        var sLicenseNo = getItemValue(0,getRow(),"LicenseNo");
		if(sLicenseNo !=' ' && sLicenseNo != '')
		{
			//营业执照代码应该是13位！
			if (sLicenseNo.length != 13)
			{
				alert(getBusinessMessage('155'));
				return;
			}
		}
			
		//判断身份证合法性,个人身份证号码应该是15或18位！
		var sFictitiousPersonID = getItemValue(0,getRow(),"FictitiousPersonID");
		if(sFictitiousPersonID !='')
		{
			if (sFictitiousPersonID.length != 15 && sFictitiousPersonID.length != 18)
			{
				alert(getBusinessMessage('156'));
				return;
			}
		}
		*/

		if(vI_all("myiframe0"))
		{
			beforeUpdate();
			setItemValue(0,getRow(),'TempSaveFlag',"");
			as_save("myiframe0",sPostEvents);
		}
	}
		
	function saveRecordTemp()
	{
		//0：表示第一个dw
		setNoCheckRequired(0);  //先设置所有必输项都不检查
		setItemValue(0,getRow(),'TempSaveFlag',"是");
		as_save("myiframe0");   //再暂存
		setNeedCheckRequired(0);//最后再将必输项设置回来		
	}

	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		sDay = PopPage("/Common/ToolsB/GetDay.jsp","","");
		setItemValue(0,0,"UpdateOrgID","<%=CurOrg.OrgID%>");
		setItemValue(0,0,"UpdateOrgName","<%=CurOrg.OrgName%>");
		setItemValue(0,0,"UpdateUserID","<%=CurUser.UserID%>");
		setItemValue(0,0,"UpdateUserName","<%=CurUser.UserName%>");
		setItemValue(0,0,"UpdateDate",sDay);
	}

        /*~[Describe=弹出代码内容选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCode(sCodeNo,sIDColumn,sNameColum)
	{
		
		setObjectInfo("Code","CodeNo="+sCodeNo+"@"+sIDColumn+"@0@"+sNameColum+"@1",0,0);
		/*
		* setObjectInfo()函数说明：---------------------------
		* 功能： 弹出指定对象对应的查询选择对话框，并将返回的对象设置到指定DW的域
		* 返回值： 形如“ObjectID@ObjectName”的返回串，可能有多段，例如“UserID@UserName@OrgID@OrgName”
		* sObjectType： 对象类型
		* sValueString格式： 传入参数 @ ID列名 @ ID在返回串中的位置 @ Name列名 @ Name在返回串中的位置
		* iArgDW:  第几个DW，默认为0
		* iArgRow:  第几行，默认为0
		* 详情请参阅 common.js -----------------------------
		*/
		var sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");
		if(sCountryTypeValue!="142")
		{
			setItemValue(0,getRow(),"RegionCode","");
			setItemValue(0,getRow(),"RegionCodeName","");
		}
		
	}
	function selectVillage(sIDColumn,sNameColum)
	{
		setObjectInfo("Village","VillageType='0'@"+sIDColumn+"@0@"+sNameColum+"@1",0,0);
	
	}
	
	//选择国内地区（个人籍贯）
	function getRegionCode(flag)
	{
		//判断国家有没有选中国
		var sCountryTypeValue = getItemValue(0,getRow(),"CountryCode");
		//alert(sCountryTypeValue);
		var sRegionInfo;
		if (flag=="ent")
		{
		//判断国家是否已经选了
		if (typeof(sCountryTypeValue) != "undefined" && sCountryTypeValue != "" )

		{
			if(sCountryTypeValue=="142")
			{
			
			sRegionInfo = PopPage("/Common/ToolsA/RegionSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
        		//两次调用RegionSelect.jsp，主要目的是分次显示城市代码，缩短页面显示时间
			if(sRegionInfo!="NO" && sRegionInfo != "" && typeof(sRegionInfo) != "undefined")
			{
	        		sRegionInfo1=sRegionInfo.split("@");
	        		sRegionCode = sRegionInfo1[0];
	        		sRegionName = sRegionInfo1[1];
	        		if(sRegionCode !='71' && sRegionCode !='81' && sRegionCode !='82')
	        			sRegionInfo = PopPage("/Common/ToolsA/RegionSelect.jsp?RegionCode="+sRegionCode+"&RegionName="+sRegionName+"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
	    		}
			if(sRegionInfo == "NO")
			{
				
					setItemValue(0,getRow(),"RegionCode","");
					setItemValue(0,getRow(),"RegionCodeName","");
			
			}
			else if(typeof(sRegionInfo) != "undefined" && sRegionInfo != "")
			{
				sRegionInfo = sRegionInfo.split('@');
				sRegionValue = sRegionInfo[0];
				sRegionName = sRegionInfo[1];
			
					setItemValue(0,getRow(),"RegionCode",sRegionValue);
					setItemValue(0,getRow(),"RegionCodeName",sRegionName);
			
			}
			}
			else
			{
				alert(getBusinessMessage('122'));//所选国家不是中国，无需选择地区
			}
		}
		else
		{
			alert(getBusinessMessage('123'));//尚未选择国家，无法选择地区
		}
		
		
		}
		else 	//区分企业客户的行政区域和个人的籍贯
		{

			sRegionInfo = PopPage("/Common/ToolsA/RegionSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
        		//两次调用RegionSelect.jsp，主要目的是分次显示城市代码，缩短页面显示时间
			if(sRegionInfo!="NO" && sRegionInfo != "" && typeof(sRegionInfo) != "undefined")
			{
	        		sRegionInfo1=sRegionInfo.split("@");
	        		sRegionCode = sRegionInfo1[0];
	        		sRegionName = sRegionInfo1[1];
	        		if(sRegionCode !='71' && sRegionCode !='81' && sRegionCode !='82')
	        			sRegionInfo = PopPage("/Common/ToolsA/RegionSelect.jsp?RegionCode="+sRegionCode+"&RegionName="+sRegionName+"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
	    		}
			if(sRegionInfo == "NO")
			{
				
					setItemValue(0,getRow(),"NativePlace","");
					setItemValue(0,getRow(),"NativePlaceName","");
				
			}
			else if(typeof(sRegionInfo) != "undefined" && sRegionInfo != "")
			{
				sRegionInfo = sRegionInfo.split('@');
				sRegionValue = sRegionInfo[0];
				sRegionName = sRegionInfo[1];
				
				
				setItemValue(0,getRow(),"NativePlace",sRegionValue);
				setItemValue(0,getRow(),"NativePlaceName",sRegionName);
				
			}
		}
	}	
	
    	//选择国标行业类型
	function getIndustryType()
	{

		//由于行业分类代码有几百项，分两步显示行业代码
		sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
		
		if(sIndustryTypeInfo == "NO")
		{
			setItemValue(0,getRow(),"IndustryType","");
			setItemValue(0,getRow(),"IndustryTypeName","");
		}
		else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
		{
			sIndustryTypeInfo = sIndustryTypeInfo.split('@');
			sIndustryTypeValue = sIndustryTypeInfo[0];
			sIndustryTypeName = sIndustryTypeInfo[1];

			sIndustryTypeInfo = PopPage("/Common/ToolsA/IndustryTypeSelect.jsp?IndustryTypeValue="+sIndustryTypeValue+"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");
			if(sIndustryTypeInfo == "NO")
			{
				setItemValue(0,getRow(),"IndustryType","");
				setItemValue(0,getRow(),"IndustryTypeName","");
			}
			else if(typeof(sIndustryTypeInfo) != "undefined" && sIndustryTypeInfo != "")
			{
				sIndustryTypeInfo = sIndustryTypeInfo.split('@');
				sIndustryTypeValue = sIndustryTypeInfo[0];
				sIndustryTypeName = sIndustryTypeInfo[1];
				setItemValue(0,getRow(),"IndustryType",sIndustryTypeValue);
				setItemValue(0,getRow(),"IndustryTypeName",sIndustryTypeName);
				
			}

		}

	}
	//效验邮政编码中是否包含字符，并将字符去掉 Add by ndeng 2005.01.27
	function checkOfficeZIP()
	{
		var sOfficeZIP = getItemValue(0,getRow(),"OfficeZIP");
		var siOfficeZIP = "";	//包含的数字
		var bhavechar = false;	//输入字段是否包含字符
		for(var i=0;i<=sOfficeZIP.length-1;i++)
		{
			s_tmp = sOfficeZIP.substring(i,i+1);
			if (s_tmp<="9" && s_tmp>="0")
			{
				siOfficeZIP=siOfficeZIP+s_tmp;		//保留数字		
			}
			else
			{
				bhavechar=true; 			//有不是数字的字符
			}
		}		
		if(bhavechar)
		{
			alert("邮政编码应为数字！");
			setItemValue(0,getRow(),"OfficeZIP",siOfficeZIP); //将输入的数字保留在输入框
		}
	}
	function View()
	{	
		var sCustomerID="<%=sCustomerID%>";
		openObject("Customer",sCustomerID,"001");	
	}
	
	/*~[保存时加入"是否有项目"和"是否从事房地产开发"的提示;]~*/		
	function alertInput()
	{	
		var sProjectFlag = getItemValue(0,getRow(),"ProjectFlag");
		var sRealtyFlag = getItemValue(0,getRow(),"RealtyFlag");
		if (sProjectFlag=='010')
		{
			alert(getBusinessMessage('187')); //该客户目前有项目，请稍后在“参与项目情况”中录入相应的项目信息！
		}
		if (sRealtyFlag=='010')
		{
			alert(getBusinessMessage('188'));  //该客户从事房地产开发，请稍后在“房地产资质情况”中录入相应的房地产资质信息！
		}	
	}
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		var sCountryCode = getItemValue(0,getRow(),"CountryCode");
		var sInputUserID = getItemValue(0,getRow(),"InputUserID");
		var sCreditBelong = getItemValue(0,getRow(),"CreditBelong");
		if (sCountryCode=="") //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			setItemValue(0,getRow(),"CountryCode","142");
			setItemValue(0,getRow(),"CountryCodeName","中华人民共和国");
		}
		if (sInputUserID=="") 
		{
			setItemValue(0,getRow(),"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,getRow(),"InputUserName","<%=CurUser.UserName%>");
		}
		if("<%=sCustomerInfoTemplet%>" == "EnterpriseInfo03" && sCreditBelong == "")
		{
		    setItemValue(0,getRow(),"CreditBelong","011");
			
			setItemValue(0,getRow(),"CreditBelongName","企业化管理的事业单位信用等级评估表");
		}
    }
	
    //利用String.replace函数，将字符串左右两边的空格替换成空字符串
    function Trim (sTmp)
    {
    return sTmp.replace(/^(\s+)/,"").replace(/(\s+)$/,"");
    }

	</script>
<%/*~END~*/%>




<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
	initRow(); //页面装载时，对DW当前记录进行初始化
</script>	
<%/*~END~*/%>



<%@ include file="IncludeEnd.jsp"%>
