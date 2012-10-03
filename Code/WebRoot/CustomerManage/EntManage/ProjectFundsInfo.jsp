<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: cwliu 2004-11-29
		Tester:
		Describe:  项目资金来源
		Input Param:
			ProjectNo：当前项目编号
		Output Param:
			ProjectNo：当前项目编号
			

		HistoryLog: 
					2005.7.28   hxli 修改投资占比初始化，界面改写
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "项目资金来源"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	ASResultSet rs ;
	String sPlanTotalCast = "";
	String sProjectCapitalScale = "";
	//获得组件参数
	String sProjectNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ProjectNo"));
	//获得页面参数	
	String sSerialNo    = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sFundSource  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("FundSource"));
	if(sFundSource == null ) sFundSource = "";
	if(sSerialNo == null ) sSerialNo = "";

	
	if(sFundSource.equals("01"))
	{
		sSql = "select PlanTotalCast,CapitalScale from PROJECT_INFO "+
			   " where ProjectNo= '"+sProjectNo+"'";
		rs = Sqlca.getResultSet(sSql);
		if(rs.next())
		{
			sPlanTotalCast = rs.getString("PlanTotalCast");
			sProjectCapitalScale = rs.getString("CapitalScale");
		}
		rs.getStatement().close();

	}
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sTempletNo = "ProjectFundsInfo";	
	String sTempletFilter = "  ColAttribute like '%"+sFundSource+"%' ";
	ASDataObject doTemp = new ASDataObject(sTempletNo,sTempletFilter,Sqlca);
	
	//“项目本资金” 中“借款金额” 要素应改名为“投资金额”、“其他自筹资金”中“借款金额”改名为“筹资金额”
	System.out.println("sFundSource:"+sFundSource);
	if("02".equals(sFundSource))//项目本资金
	{
		doTemp.setHeader("INVESTSUM","出资金额");
		doTemp.setHeader("INVESTRATIO","出资占比");
		doTemp.setHeader("TOTALSUM","资本金总额");
		doTemp.setDDDWSql("ATTENDPROJECTWAY","select ItemNo,ItemName from code_Library where CodeNo ='ContributiveType' and ItemNo in ('010','020') ");
	}
	if("01".equals(sFundSource))//其他自筹资金
	{
		doTemp.setHeader("TOTALSUM","筹资总额");
		doTemp.setHeader("INVESTSUM","筹资金额");
		doTemp.setDDDWSql("ATTENDPROJECTWAY","select ItemNo,ItemName from code_Library where CodeNo ='ContributiveType' and ItemNo in ('030','040') ");
	}
	if("03".equals(sFundSource))//项目本资金
	{
		doTemp.setHeader("INVESTSUM","融资金额");
		doTemp.setHeader("INVESTRATIO","融资占比");
		doTemp.setHeader("TOTALSUM","融资总金额");
		doTemp.setHeader("INVESTORNAME","金融机构名称");
	}
	
	//设置投资占比(%)范围
	//doTemp.appendHTMLStyle("INVESTRATIO"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"投资占比(%)的范围为[0,100]\" ");
	//设置到位比例(%)范围
	doTemp.appendHTMLStyle("ACTUALRADIO"," myvalid=\"parseFloat(myobj.value,10)>=0 && parseFloat(myobj.value,10)<=100 \" mymsg=\"到位比例(%)的范围为[0,100]\" ");
	//设置投资金额(元)范围
	doTemp.appendHTMLStyle("INVESTSUM"," myvalid=\"parseFloat(myobj.value,10)>=0 \" mymsg=\"出资金额(元)必须大于等于0！\" ");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca); 
	dwTemp.Style="2";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "0"; //设置是否只读 1:只读 0:可写
	
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow(sProjectNo+","+sSerialNo);
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
		{"true","","Button","返回","返回列表页面","goBack()",sResourcesPath},
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
		//录入数据有效性检查
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}

		beforeUpdate();
		as_save("myiframe0",sPostEvents);	
	}
	
	
	/*~[Describe=弹出客户选择窗口，并置将返回的值设置到指定的域;InputParam=无;OutPutParam=无;]~*/
	function selectCustomer()
	{
		setObjectValue("SelectInvest","","@INVESTORCODE@0@INVESTORNAME@1",0,0,"");
	}
	
	/*~[Describe=返回列表页面;InputParam=无;OutPutParam=无;]~*/
	function goBack()
	{
		OpenPage("/CustomerManage/EntManage/ProjectFundsList.jsp?","_self","");
	}
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=Info07;Describe=自定义函数;]~*/%>

	<script language=javascript>

	/*~[Describe=新增一条记录;InputParam=无;OutPutParam=无;]~*/
	function newRecord()
	{
		OpenPage("/CustomerManage/EntManage/ProjectFundsInfo.jsp","_self","");
	}

	/*~[Describe=执行插入操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeInsert()
	{
		initSerialNo();
		setItemValue(0,0,"PROJECTNO","<%=sProjectNo%>");
		setItemValue(0,0,"FUNDSOURCE","<%=sFundSource%>");
		bIsInsert = false;
	}
	/*~[Describe=执行更新操作前执行的代码;InputParam=无;OutPutParam=无;]~*/
	function beforeUpdate()
	{
		setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
	}
	
	/*~[Describe=有效性检查;InputParam=无;OutPutParam=通过true,否则false;]~*/
	function ValidityCheck()
	{	
		var sFundSource = "<%=sFundSource%>";
		sInvestRatio = getItemValue(0,getRow(),"INVESTRATIO");
		if(sInvestRatio>100 || sInvestRatio<0){
			if(sFundSource=="01"){
				alert("筹资占比(%)的范围为[0,100]");	
			}else if(sFundSource=="02"){
				alert("出资占比(%)的范围为[0,100]");
			}else if(sFundSource=="03"){
				alert("融资占比(%)的范围为[0,100]");
			}	
			return false;
		}
		return true;
	}

	//选择地区
	function getRegionCode()
	{
		sParaString = "CodeNo"+",AreaCode";			
		setObjectValue("SelectCode",sParaString,"@LOCATIONOFINVESTOR@0@LOCATIONOFINVESTORNAME@1",0,0,"");
	}	
	
	/*~[Describe=页面装载时，对DW进行初始化;InputParam=无;OutPutParam=无;]~*/
	function initRow()
	{
		if (getRowCount(0)==0) //如果没有找到对应记录，则新增一条，并设置字段默认值
		{
			as_add("myiframe0");//新增记录
			setItemValue(0,0,"FUNDSOURCE","<%=sFundSource%>");
			setItemValue(0,0,"InputUserID","<%=CurUser.UserID%>");
			setItemValue(0,0,"InputOrgID","<%=CurUser.OrgID%>");
			setItemValue(0,0,"InputUserName","<%=CurUser.UserName%>");
			setItemValue(0,0,"InputOrgName","<%=CurOrg.OrgName%>");
			setItemValue(0,0,"InputDate","<%=StringFunction.getToday()%>");
			setItemValue(0,0,"UpdateDate","<%=StringFunction.getToday()%>");
			if("<%=sFundSource%>"=="010")
			{	//hxli 投资占比为空，置空白
				if("<%=sPlanTotalCast%>" != "null" )
				{
					setItemValue(0,0,"INVESTSUM","<%=sPlanTotalCast%>");
					//setItemValue(0,0,"INVESTRATIO","<%=sProjectCapitalScale%>");
				}
				
				if("<%=sProjectCapitalScale%>" != "null")
				{
					//setItemValue(0,0,"INVESTSUM","<%=sPlanTotalCast%>");
					setItemValue(0,0,"INVESTRATIO","<%=sProjectCapitalScale%>");
				}
			}
			bIsInsert = true;
		}
    }
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "PROJECT_FUNDS";//表名
		var sColumnName = "SERIALNO";//字段名
		var sPrefix = "";//前缀

		//使用GetSerialNo.jsp来抢占一个流水号
		var sSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		//将流水号置入对应字段
		setItemValue(0,getRow(),sColumnName,sSerialNo);
	}
	
	function getInvestRatio(){
		var sInvestSum = getItemValue(0,getRow(),"INVESTSUM");
		var sTotalSum = getItemValue(0,getRow(),"TOTALSUM");
		sInvestRatio = parseFloat(sInvestSum/sTotalSum)*100
		sInvestRatio = Math.round(parseFloat(sInvestRatio)*100)/100
		setItemValue(0,getRow(),"INVESTRATIO" ,sInvestRatio);	
		
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

<%@ include file="/IncludeEnd.jsp"%>
