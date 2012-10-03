<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  hlzhang 2011-10-28
		Tester:
		Content: 修改业务合同的审批利率
		Input Param:
					下列参数作为组件参数输入
					ComponentName	组件名称：合同信息快速查询
			          
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "修改业务合同的利率"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//--存放sql语句
	String sComponentName = "";//--组件名称
	String sType="";
	String PG_CONTENT_TITLE = "";
	//获得组件参数	
	sComponentName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ComponentName"));	//获得页面参数	
	sType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"));	//获得页面参数	
	PG_CONTENT_TITLE = "&nbsp;&nbsp;"+sComponentName+"&nbsp;&nbsp;";

%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//定义表头文件
	String sHeaders[][] = { 							
							{"SerialNo","合同流水号"},
							{"CustomerID","客户编号"},
							{"CustomerName","客户名称"},	
							{"BusinessType","业务品种"},	
							{"BusinessTypeName","业务品种"},		
							{"BusinessSum","金额（元）"},								
							{"ManageUserName","登记人"},
							{"ManageOrgName","登记机构"},
							}; 
	
	sSql =	" select SerialNo,CustomerID,CustomerName,BusinessType,getBusinessName(BusinessType) as BusinessTypeName,BusinessSum, "+
			" getUserName(InputUserID) as ManageUserName,getOrgName(InputOrgID) as ManageOrgName "+
			" from BUSINESS_CONTRACT "+
			//" where exists (select 'X' from DATA_MODIFY DM,FLOW_OBJECT FO where DM.SerialNo=FO.ObjectNo and FO.ObjectType='DataModApply' and FO.PhaseNo='1000' and DM.RelativeNo=BUSINESS_CONTRACT.SerialNo) "+
			" where 1=1 ";
	
	//利用sSql生成数据对象
	ASDataObject doTemp = new ASDataObject(sSql);
    doTemp.setKeyFilter("SerialNo");
	//设置表头
	doTemp.setHeader(sHeaders);	
	//设置可更新目标表
	doTemp.UpdateTable = "Business_Contract";
	
	//设置关键字
	doTemp.setKey("SerialNo",true);	
	//设置显示文本框的长度及事件属性
	doTemp.setHTMLStyle("CustomerName","style={width:250px} ");  
	//设置对齐方式
	doTemp.setAlign("BusinessSum,BusinessRate,","3");	
	//小数为2，整数为5
	doTemp.setCheckFormat("BusinessSum","2");	
	doTemp.setType("BusinessSum,BusinessRate,Balance,TermMonth","Number");
	doTemp.setDDDWSql("BusinessType","select TypeNo,TypeName from BUSINESS_TYPE where IsinUse='1' and ContractDetailNo is not null  order by SortNo");
	doTemp.setVisible("BusinessType",false);
	//生成查询框
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","CustomerName","");	
	doTemp.setFilter(Sqlca,"3","BusinessType","");	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));

	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置是否只读 1:只读 0:可写
	dwTemp.setPageSize(16);  //服务器分页

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
		{(CurUser.hasRole("0ZZ")?"true":"false"),"","Button","合同详情","合同详情","viewTab()",sResourcesPath},
		{(CurUser.hasRole("0ZZ")?"true":"false"),"","Button","查看合同历史记录","历史合同修改记录信息","HistoryContract()",sResourcesPath},
		{(CurUser.hasRole("0ZZ")?"true":"false"),"","Button","删除此合同","删除合同信息","deleteContract()",sResourcesPath}
	};
	%> 
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	//---------------------定义按钮事件------------------------------------

	/*~[Describe=使用OpenComp打开详情;InputParam=无;OutPutParam=无;]~*/
	function viewTab()
	{
		sObjectType = "BusinessContract";
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		OpenComp("ContractManageInfo","/SystemManage/SynthesisManage/ContractManageInfo.jsp","ObjectType="+sObjectType+"&ObjectNo="+sObjectNo,"_blank");
	}
	
	
	/*~[Describe=使用OpenComp历史合同修改记录信息;InputParam=无;OutPutParam=无;]~*/
	function HistoryContract()
	{
		sObjectType = "BusinessContract";
		sBCSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{							
			if(confirm("请点击“确定”按钮并选择一条合同信息或者点击“取消”按钮手工输入电子合同流水号！")){
				return;
			}else{
				sReturn = PopPage("/SystemManage/SynthesisManage/SelectBusinessContract.jsp?","","dialogWidth=20;dialogHeight=7;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
				if(sReturn != "_CANCEL_"){
					sBCSerialNo = sReturn;
				}else{
					return;
				}
			}	
		}
		OpenComp("HistoryContractList","/SystemManage/SynthesisManage/HistoryContractList.jsp","ObjectType="+sObjectType+"&ObjectNo="+sBCSerialNo,"_blank");	
	}
	
	
	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteContract()
	{
		//获得合同类型、合同流水号
		sObjectNo = getItemValue(0,getRow(),"SerialNo");		
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		
		if(confirm(getHtmlMessage('70')))//您真的想取消该信息吗？
		{
			
			//获得借据编号
        	var sColName = "SerialNo";
			var sTableName = "BUSINESS_DUEBILL";
			var sWhereClause = "String@RelativeSerialNo2@"+sObjectNo;
			sReturn=RunMethod("PublicMethod","GetColValue",sColName + "," + sTableName + "," + sWhereClause);
			if(typeof(sReturn) != "undefined" && sReturn != "") 
			{
				alert("对不起，该合同关联的借据信息["+sReturn+"]尚未重新指定合同，不能删除此合同！");
				return;
			}
			
			if(confirm("您确定已经将与该合同关联的借据信息重新指定合同了吗？"))
			{
				//业务详情时将当前合同记录插入到BC_B备份表中
				sBCBSerialNo = initSerialNo();
				sReturn = RunMethod("BusinessManage","AddBusinessContractBak",sBCBSerialNo+","+sObjectNo+","+"<%=CurOrg.OrgID%>"+","+"<%=CurUser.UserID%>"+",BusinessContract");
				if(sReturn == 1){
					as_del("myiframe0");
					as_save("myiframe0");  //如果单个删除，则要调用此语句
				}else{
					alert("删除数据失败！");
					return;
				}
			}
		}
	}
	
	
	/*~[Describe=初始化流水号字段;InputParam=无;OutPutParam=无;]~*/
	function initSerialNo() 
	{
		var sTableName = "BUSINESS_CONTRACT_BAK";//表名
		var sColumnName = "BCSerialNo";//字段名
		var sPrefix = "BCB";//前缀
       
		//使用GetSerialNo.jsp来抢占一个流水号
		var sBCBSerialNo = PopPage("/Common/ToolsB/GetSerialNo.jsp?TableName="+sTableName+"&ColumnName="+sColumnName+"&Prefix="+sPrefix,"","resizable=yes;dialogWidth=0;dialogHeight=0;center:no;status:no;statusbar:no");
		
		//将流水号返回
		return sBCBSerialNo;
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List08;Describe=页面装载时，进行初始化;]~*/%>
<script language=javascript>	
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>	
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
