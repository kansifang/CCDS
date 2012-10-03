<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:byhu 20050727
		Tester:
		Content: 授信额度设置与调整列表页面
		Input Param:
			
		Output param:
		History Log: 
			zywei 2007/10/10 增加过滤到期授信额度的条件
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "未命名模块123"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//定义变量
	String sSql = "";
	
	//获得组件参数	
	
	//获得页面参数	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%		
	//显示标题				
	String[][] sHeaders = {		
					{"BCSerialNo","合同流水号"},
					{"CLTypeName","额度类型"},
					{"CustomerID","客户编号"},
					{"CustomerName","客户名称"},
					{"LineSum1","额度金额"},
					{"Currency","币种"},
					{"LineEffDate","生效日"},
					{"BeginDate","起始日"},
					{"EndDate","到期日"}
					};
	String sDBName = Sqlca.conn.getMetaData().getDatabaseProductName().toUpperCase();
	if(sDBName.startsWith("INFORMIX"))
	{
		sSql =  " select LineID,CLTypeID,CLTypeName,BCSerialNo,CustomerID,CustomerName,"+
				" LineSum1,getItemName('Currency',Currency) as Currency,LineEffDate, "+
				" BeginDate,EndDate "+
				" from CL_INFO "+
				" Where LineEffDate <= '"+StringFunction.getToday()+"' "+
				" and BeginDate <= '"+StringFunction.getToday()+"' "+
				" and EndDate >= '"+StringFunction.getToday()+"' "+
				" and BCSerialNo is not null "+//表示已签订授信协议
				" and BCSerialNo <> '' "+
				" and (ParentLineID is null "+
				" or ParentLineID = '') "+
				" and (FreezeFlag = '1' "+//冻结标志FreezeFlag(1:正常;2:冻结;3:解冻;4:终止)
				" or FreezeFlag = '3') ";	
	}else if(sDBName.startsWith("ORACLE"))
	{
		sSql =  " select LineID,CLTypeID,CLTypeName,BCSerialNo,CustomerID,CustomerName,"+
				" LineSum1,getItemName('Currency',Currency) as Currency,LineEffDate, "+
				" BeginDate,EndDate "+
				" from CL_INFO "+
				" Where LineEffDate <= '"+StringFunction.getToday()+"' "+
				" and BeginDate <= '"+StringFunction.getToday()+"' "+
				" and EndDate >= '"+StringFunction.getToday()+"' "+
				" and BCSerialNo is not null "+//表示已签订授信协议
				" and BCSerialNo <> ' ' "+
				" and (ParentLineID is null "+
				" or ParentLineID = ' ') "+
				" and (FreezeFlag = '1' "+//冻结标志FreezeFlag(1:正常;2:冻结;3:解冻;4:终止)
				" or FreezeFlag = '3') ";	
	
	}else if(sDBName.startsWith("DB2"))
	{
		sSql =  " select LineID,CLTypeID,CLTypeName,BCSerialNo,CustomerID,CustomerName,"+
				" LineSum1,getItemName('Currency',Currency) as Currency,LineEffDate, "+
				" BeginDate,EndDate "+
				" from CL_INFO "+
				" Where LineEffDate <= '"+StringFunction.getToday()+"' "+
				" and BeginDate <= '"+StringFunction.getToday()+"' "+
				" and EndDate >= '"+StringFunction.getToday()+"' "+
				" and BCSerialNo is not null "+//表示已签订授信协议
				" and BCSerialNo <> '' "+
				" and (ParentLineID is null "+
				" or ParentLineID = '') "+
				" and (FreezeFlag = '1' "+//冻结标志FreezeFlag(1:正常;2:冻结;3:解冻;4:终止)
				" or FreezeFlag = '3') ";	
	}
	//机构权限控制
	sSql +=" and InputOrg in(select OrgID from ORG_INFO where SortNo like '"+CurOrg.SortNo+"%') ";
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.UpdateTable="CL_INFO";
	doTemp.setKey("LineID",true);	
	doTemp.setHeader(sHeaders);
	doTemp.setAlign("Currency","2");
	doTemp.setVisible("LineID,CLTypeID,CustomerID,LineEffDate",false);
	
	doTemp.setType("LineSum1","Number");
	doTemp.setHTMLStyle("CustomerName"," style={width:200px} ");
	doTemp.setHTMLStyle("Currency"," style={width:80px} ");
	
	//设置Filter			
	doTemp.setColumnAttribute("CustomerName","IsFilter","1");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause += " and 1=1 ";
	
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("%");
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
		//{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
		{"true","","Button","详情","查看/修改详情","openWithObjectViewer()",sResourcesPath},
		{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
		{"true","","Button","授信额度项下业务","相关授信额度项下业务","lineSubList()",sResourcesPath}
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
		sReturn=popComp("CreditLineCreationDialog","/CreditManage/CreditLine/CreditLineCreationInfo.jsp","","dialogwidth:550px;dialogheight:650px");
		reloadSelf();
	}
	
	/*~[Describe=授信额度项下业务;InputParam=无;OutPutParam=无;]~*/
	function lineSubList()
	{		
		sBCSerialNo = getItemValue(0,getRow(),"BCSerialNo");
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		popComp("lineSubList","/CreditManage/CreditLine/lineSubList.jsp","CreditAggreement="+sBCSerialNo,"","");
	}
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		sLineID = getItemValue(0,getRow(),"LineID");
		sBCSerialNo = getItemValue(0,getRow(),"BCSerialNo");		
		if (typeof(sLineID)=="undefined" || sLineID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			sReturn = PopPage("/CreditManage/CreditLine/CheckCLDelAction.jsp?ObjectNo="+sBCSerialNo,"","");
	        if (typeof(sReturn)=="undefined" || sReturn.length==0)
	       	{
	            RunMethod("CreditLine","DeleteLineRelative",sLineID);
	            alert(getHtmlMessage('7'));//信息删除成功！ add by cdeng 2009-02-25
	            reloadSelf();
	        }else if(sReturn == 'Reinforce')
	        {
	            alert(getBusinessMessage('425'));//该合同为补登合同，不能删除！
	            return;
	        }else if(sReturn == 'Finish')
	        {
	            alert(getBusinessMessage('426'));//该合同已经被终结了，不能删除！
	            return;
	        }else if(sReturn == 'Pigeonhole')
	        {
	            alert(getBusinessMessage('427'));//该合同已经完成放贷了，不能删除！
	            return;
	        }else if(sReturn == 'Use')
	        {
	            alert(getBusinessMessage('430'));//该授信额度已被占用，不能删除！
	            return;
	        }
		}
	}

	
	/*~[Describe=使用ObjectViewer打开;InputParam=无;OutPutParam=无;]~*/
	function openWithObjectViewer()
	{
		sLineID=getItemValue(0,getRow(),"LineID");
		if (typeof(sLineID)=="undefined" || sLineID.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		openObject("CreditLine",sLineID,"001");
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
