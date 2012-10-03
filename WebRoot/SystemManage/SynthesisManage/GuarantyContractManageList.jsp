<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hlzhang 2012-07-17
		Tester:
		Describe: 担保合同修改列表
		Input Param:
				ObjectType：对象类型（BusinessContract）
				ObjectNo: 对象编号（合同流水号）
		Output Param:
				
		HistoryLog:
							
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "担保合同修改列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";
	//获得组件参数：对象类型、对象编号
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";	
	
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
	String sHeaders[][] = {
							{"SerialNo","担保合同编号"},
							{"GuarantyTypeName","担保方式"},							
							{"GuarantorName","担保人名称"},
							{"GuarantyValue","担保金额"},				            
							{"GuarantyCurrency","币种"},
							{"InputUserName","登记人"},
							{"InputOrgName","登记机构"}
						  };

	sSql =  " select GC.SerialNo,GC.CustomerID,GC.GuarantyType, "+
			" getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName, "+
			" GC.GuarantorID,GC.GuarantorName,GC.GuarantyValue, "+
			" getItemName('Currency',GC.GuarantyCurrency) as GuarantyCurrency, "+
			" GC.InputUserID,getUserName(GC.InputUserID) as InputUserName, "+
			" GC.InputOrgID,getOrgName(GC.InputOrgID) as InputOrgName,Channel "+
			" from GUARANTY_CONTRACT GC "+
			//" where exists (select 'X' from DATA_MODIFY DM,FLOW_OBJECT FO,CONTRACT_RELATIVE CR where CR.SerialNo=DM.RelativeNo and CR.ObjectNo=GC.SerialNo and CR.ObjectType='GuarantyContract' and  DM.SerialNo=FO.ObjectNo and FO.ObjectType='DataModApply' and FO.PhaseNo='1000') "+
			" where 1=1 ";
	
	//用sSql生成数据窗体对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头,更新表名,键值,可见不可见,是否可以更新
	doTemp.setHeader(sHeaders);
	doTemp.UpdateTable = "GUARANTY_CONTRACT";
	doTemp.setKey("SerialNo",true);
	doTemp.setVisible("CustomerID,GuarantorID,GuarantyType,InputUserID,InputOrgID,Channel",false);
	doTemp.setUpdateable("",false);doTemp.setVisible("CustomerID,GuarantorID,GuarantyType,InputUserID,InputOrgID",false);
	doTemp.setUpdateable("GuarantyTypeName,GuarantyCurrency,InputUserName,InputOrgName",false);
	//设置格式
	doTemp.setAlign("GuarantyValue","3");
	doTemp.setCheckFormat("GuarantyValue","2");
	doTemp.setHTMLStyle("GuarantyTypeName"," style={width:60px} ");
	doTemp.setHTMLStyle("GuarantorName"," style={width:180px} ");
	
	//生成查询框
	doTemp.setFilter(Sqlca,"1","SerialNo","");
	doTemp.setFilter(Sqlca,"2","GuarantorName","");	
	doTemp.parseFilterData(request,iPostChange);
	if(!doTemp.haveReceivedFilterCriteria()) doTemp.WhereClause+=" and 1=2";
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//生成datawindow
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	dwTemp.setPageSize(16);  //服务器分页
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.print(doTemp.SourceSql);
	
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
		sGuarantyType = getItemValue(0,getRow(),"GuarantyType");
		sObjectNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0)
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		OpenComp("GuarantyContractManageInfo","/SystemManage/SynthesisManage/GuarantyContractManageInfo.jsp","GuarantyType="+sGuarantyType+"&SerialNo="+sObjectNo,"_blank");
	}
	
	
	/*~[Describe=使用OpenComp历史合同修改记录信息;InputParam=无;OutPutParam=无;]~*/
	function HistoryContract()
	{
		GuarantyType = getItemValue(0,getRow(),"GuarantyType");
		sBCSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sBCSerialNo)=="undefined" || sBCSerialNo.length==0)
		{							
			if(confirm("请点击“确定”按钮并选择一条合同信息或者点击“取消”按钮手工输入担保合同流水号！")){
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
		OpenComp("HistoryGuarantyContractList","/SystemManage/SynthesisManage/HistoryGuarantyContractList.jsp","ObjectType="+GuarantyType+"&ObjectNo="+sBCSerialNo,"_blank");	
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
						
			if(confirm("您确定删除本笔担保合同吗？"))
			{
				//业务详情时将当前合同记录插入到BC_B备份表中
				sBCBSerialNo = initSerialNo();
				sReturn = RunMethod("BusinessManage","AddBusinessContractBak",sBCBSerialNo+","+sObjectNo+","+"<%=CurOrg.OrgID%>"+","+"<%=CurUser.UserID%>"+",GuarantyContract");
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
		var sTableName = "GUARANTY_CONTRACT_BAK";//表名
		var sColumnName = "GCBSerialNo";//字段名
		var sPrefix = "GCB";//前缀
       
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