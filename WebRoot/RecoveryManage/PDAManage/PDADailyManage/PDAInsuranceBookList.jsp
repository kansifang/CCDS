<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   FSGong 2004.12.12
		Tester:
		Content: 抵债资产保险台帐AppDisposingList.jsp
		Input Param:
				下列参数作为组件参数输入				
				ObjectType			对象类型：ASSET_INFO
				ObjectNo			    对象编号：资产流水号	
		Output param:

		History Log: 	zywei 2005/09/07 重检代码	                  
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "抵债资产保险台帐列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	
	//获得组件参数	
	String sObjectType	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo	=DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	//将空值转化为空字符串
	if(sObjectNo == null) sObjectNo = "";
	if(sObjectType == null) sObjectType = "";

	//获取页面参数	

%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"ObjectType","对象类型"},
							{"ObjectNo","对象编号"},
							{"SerialNo","保险记录流水号"},							
							{"AssetName","资产名称"},
							{"InsuranceNo","保险单号"},
							{"Insurer","保险人名称"},
							{"InsuranceName","投保人名称"},
							{"beneficiary","受益人名称"},
							{"InsuranceSum","保险金额"},
							{"InsuranceCost","投保费用"},
							{"UptoDate","保险到期日"}
						}; 
	
	//从抵债资产处置信息表ASSET_DISPOSITON中选出处置信息记录
	sSql = 	" select INSURANCE_INFO.ObjectType as ObjectType ,"+
			" INSURANCE_INFO.ObjectNo as ObjectNo,"+
			" INSURANCE_INFO.SerialNo as SerialNo,"+			
			" ASSET_INFO.AssetName as AssetName,"+
			" INSURANCE_INFO.InsuranceNo as InsuranceNo,"+
			" INSURANCE_INFO.Insurer as Insurer,"+
			" INSURANCE_INFO.InsuranceName as InsuranceName,"+
			" INSURANCE_INFO.beneficiary as beneficiary,"+
			" INSURANCE_INFO.InsuranceSum  as InsuranceSum,"+
			" INSURANCE_INFO.InsuranceCost  as InsuranceCost,"+
			" INSURANCE_INFO.UptoDate as UptoDate"+
			" from INSURANCE_INFO,ASSET_INFO" +
			" where INSURANCE_INFO.ObjectType = '"+sObjectType+"' "+
			" and INSURANCE_INFO.ObjectNo = '"+sObjectNo+"' "+
			" and ASSET_INFO.SerialNo = INSURANCE_INFO.ObjectNo"+
			" order by INSURANCE_INFO.InsuranceNo desc";
	
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);

	//设置表头
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "INSURANCE_INFO";
	
	//设置关键字
	doTemp.setKey("SerialNo,ObjectType,ObjectNo",true);	 

	//设置不可见项
	doTemp.setVisible("ObjectType,ObjectNo,SerialNo",false);

	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("ObjectNo,UptoDate","style={width:80px} ");  
	doTemp.setHTMLStyle("InsuranceSum,InsuranceCost,AssetNo","style={width:80px} ");  
	doTemp.setHTMLStyle("Insurer,InsuranceName,beneficiary,AssetName"," style={width:100px} ");
	
	//设置对齐方式
	doTemp.setAlign("InsuranceSum,InsuranceCost","3");
	doTemp.setType("InsuranceSum,InsuranceCost","Number");
	//小数为2，整数为5
	doTemp.setCheckFormat("InsuranceSum,InsuranceCost","2");
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

	//定义后续事件
	
	//生成HTMLDataWindow
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
				{"true","","Button","新增","新增","newRecord()",sResourcesPath},
				{"true","","Button","详情","详情","viewAndEdit()",sResourcesPath},
				{"true","","Button","删除","删除","deleteRecord()",sResourcesPath}
			};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>



<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	
	/*~[Describe=新增记录;InputParam=无;OutPutParam=SerialNo;]~*/
	function newRecord()
	{
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAInsuranceBookInfo.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");				
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		if(confirm(getHtmlMessage(2))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
		}
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=SerialNo;]~*/
	function viewAndEdit()
	{
		//获得资产处置流水号
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo) == "undefined" || sSerialNo.length == 0)
		{
			alert(getHtmlMessage(1));  //请选择一条记录！
			return;
		}
		
		OpenPage("/RecoveryManage/PDAManage/PDADailyManage/PDAInsuranceBookInfo.jsp?SerialNo="+sSerialNo+"&ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>","right");
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
