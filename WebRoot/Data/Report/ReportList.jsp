<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 贷后检查列表
		Input Param:
			InspectType：  报告类型 
				010     贷款用途检查报告
	            010010  未完成
	            010020  已完成
	            020     贷后检查报告
	            020010  未完成
	            020020  已完成
		Output Param:
			SerialNo:流水号
			ObjectType:对象类型
			ObjectNo：对象编号
			
		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "贷后检查列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
		//顾名思义，就是获取树菜单中的ItemNo，唯一一条记录配置了此报告的相关配置 
		//其本身含义为：前两位表示01通用、02小企业、03个体户等，接着三位表示010用途检查报告、020客户检查报告，最后三位表示报告010未完成、020已完成
		String sCurItemID =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CurItemID"))); 
	    String sType =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Type"))); 
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%
		ASDataObject doTemp = null;
		String sHeaders1[][] = {
									{"SerialNo","流水号"},
									{"OneKey","报告日期"},
									{"ReportConfigNo","维度配置号"},
									{"EDocNo","报告模板"},
									{"Remark","备注"},
									{"BusinessSum","合同金额"},
									{"PutOutDate","合同生效日期"},
									{"InputUser","检查人"},
									{"InputOrg","所属机构"}
								};
		String sSql1 =  " select "+
							//" case when II.InspectType like '%010' then '2' else '1' end as IsDataHandle,"+
							" SerialNo,ReportConfigNo,"+
							" OneKey,Type,EDocNo,Remark,"+
							" getUserName(InputUserID) as InputUser,"+
							" getOrgName(InputOrgId) as InputOrg"+
							" from Batch_Report "+
							" where Type='"+sType+"' "+
			                " order by ReportConfigNo asc,OneKey desc";
		//由SQL语句生成窗体对象。
		doTemp = new ASDataObject(sSql1);
		doTemp.setHeader(sHeaders1);
		//设置可更新的表
		doTemp.UpdateTable = "Batch_Report";
		//设置关键字
		doTemp.setKey("SerialNo",true);
		//设置不可见项
		doTemp.setVisible("Type,BusinessType,ObjectType,CustomerID,InspectType,InputUserID,InputOrgID",false);
		//设置不可更新项
		doTemp.setUpdateable("BusinessType,BusinessSum,CustomerName",false);
		doTemp.setUpdateable("CustomerName,InputUserName,InputOrgName",false);
		doTemp.setAlign("BusinessSum,Balance","3");
		doTemp.setType("BusinessSum,Balance","Number");
		doTemp.setCheckFormat("BusinessSum,Balance","2");
		doTemp.setDDDWSql("ReportConfigNo", "select DocNo,DocTitle from Doc_Library where DocNo like 'QDT%'");
		//设置html格式
	  	doTemp.setHTMLStyle("InspectType"," style={width:100px} ");
	  	doTemp.setHTMLStyle("ObjectNo,CustomerName,BusinessTypeName"," style={width:120px} ");
		doTemp.setHTMLStyle("UpdateDate,InputUserName"," style={width:80px} ");
		doTemp.setHTMLStyle("ObjectNo,CustomerName"," style={width:250px} ");
		doTemp.setCheckFormat("ReportDate","3");
		//配置查询项
		doTemp.setColumnAttribute("BCSerialNo,CustomerName,BusinessSum","IsFilter","1");
		doTemp.setColumnAttribute("ObjectNo,CustomerName,ReportDate","IsFilter","1");
		doTemp.generateFilters(Sqlca);
		doTemp.parseFilterData(request,iPostChange);
		CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));//不知何用，暂时保留，以后再探！
	
	  	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	  	dwTemp.Style="1";      //设置为Grid风格
	  	dwTemp.ReadOnly = "1"; //设置为只读
	  
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
			{"true","","Button","新增","新增报告","newRecord()",sResourcesPath},
			{"true","","Button","删除","删除该报告","deleteRecord()",sResourcesPath},
			{"true","","Button","加工数据","数据做最后处理","DataHandle()",sResourcesPath},
			{"true","","Button","展示数据","以各种图形进行展示","displayReport()",sResourcesPath},
			{"true","","Button","生成报告","生成各种word形式的格式化报告","printContract()",sResourcesPath},
			{"true","","Button","详情","生成各种word形式的格式化报告","viewAndEdit()",sResourcesPath},
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
	function newRecord(){
		var sReturn = PopPage("/Data/Report/CreationInfo.jsp?","","dialogWidth:350px;dialogHeight:350px;resizable:yes;scrollbars:no");
		if(typeof(sReturn)=='undefined'||sReturn==""||sReturn=="_CANCEL_"){
			return;
		}
		sReturn = sReturn.split("@");
		var sSerialNo=sReturn[0];
		sCompID = "ReportTab";
		sCompURL = "/Data/Report/ReportTab.jsp";
		sParamString = "SerialNo="+sSerialNo;
		OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}

	/*~[Describe=删除记录;InputParam=无;OutPutParam=无;]~*/
	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) 
		{
			alert(getHtmlMessage('1'));//请选择一条信息！
		}
		else if(confirm(getHtmlMessage('2')))//您真的想删除该信息吗？
		{
			var sCol="Inspect_Detail";
			sCol=sCol+",String@SerialNo@"+sSerialNo+"@String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType;
			var sRV=RunMethod("PublicMethod","DeleteColValue",sCol);
			if(sRV==="TRUE"){
				as_del('myiframe0');
				as_save('myiframe0');  //如果单个删除，则要调用此语句
			}else{
				alert("删除失败！");
			}
		}	
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function displayReport()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sReportConfigNo = getItemValue(0,getRow(),"ReportConfigNo");
		var sOneKey = getItemValue(0,getRow(),"OneKey");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else{
			sCompID = "ReportTab";
			sCompURL = "/Data/Report/ReportTab.jsp";
			sParamString = "SerialNo="+sSerialNo+"&ReportConfigNo="+sReportConfigNo+"&OneKey="+sOneKey;
			OpenComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		}
	}
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
			
		sCompID = "ReportInfo";
		sCompURL = "/Data/Report/ReportInfo.jsp";
		sParamString = "SerialNo="+sSerialNo;
		popComp(sCompID,sCompURL,sParamString,"_blank",OpenStyle);
		reloadSelf();
	}
  /*~[Describe=完成;InputParam=无;OutPutParam=无;]~*/
	function DataHandle()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sReportConfigNo = getItemValue(0,getRow(),"ReportConfigNo");
		var sOneKey = getItemValue(0,getRow(),"OneKey");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		ShowMessage("正在进行文档上传后的后续操作,请耐心等待.......",true,false);
   		sReturn=PopPage("/Data/Import/Handler.jsp?HandleType=BeforeDisplay&ConfigNo="+sReportConfigNo+"&OneKeys="+sOneKey,"","dialogWidth=650px;dialogHeight=250px;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
   		if(sReturn=="true"){
   			alert("处理成功！");
   		}else{
   			alert("处理失败！");
   		}
   		try{hideMessage();}catch(e) {};
   		reloadSelf(); 
	}
	function generateReport(){
	    var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		var sObjectNo = getItemValue(0,getRow(),"ObjectNo");
		var sObjectType=getItemValue(0,getRow(),"ObjectType");
		if(typeof(sSerialNo)=="undefined" || sSerialNo.length==0) {
			alert(getHtmlMessage('1'));//请选择一条信息！
		}else if(confirm(getBusinessMessage('654'))){//你确定要撤回该报告吗？
			sReturn=PopPage("/CreditManage/CreditCheck/ReEditInspectAction.jsp?SerialNo="+sSerialNo+"&ObjectNo="+sObjectNo+"&ObjectType="+sObjectType,"","");
			var sCol="[Number@InspectType@substr(InspectType,1,5)||'010'@String@FinishDate@None@String@UpdateDate@<%=StringFunction.getToday()%>]";
			sCol=sCol+",Work_Report";
			sCol=sCol+",String@SerialNo@"+sSerialNo+"@String@ObjectNo@"+sObjectNo+"@String@ObjectType@"+sObjectType;
			var sRV=RunMethod("PublicMethod","UpdateColValue",sCol);
			if(sRV==="TRUE"){
				alert("撤回成功！");
				reloadSelf();
			}else{
				alert("撤回不成功！");
			}
		}
	}
	/*~[Describe=打印电子合同;InputParam=无;OutPutParam=无;]~*/
	function printContract(){
		var sObjectType = getItemValue(0,getRow(),"ReportConfigNo");
		var sObjectNo = getItemValue(0,getRow(),"SerialNo");
		var sEDocNo = getItemValue(0,getRow(),"EDocNo");
		if (typeof(sObjectNo)=="undefined" || sObjectNo.length==0){
			alert(getHtmlMessage('1'));//请选择一条信息！
			return;
		}
		sReturn = PopPage("/Data/Report/EDOC/EDocCreateCheckAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
		if (typeof(sReturn)=="undefined") {
	        alert("打印电子合同失败！！");
		    return;
		}
		else if (sReturn=="nodef") {
			alert("对应的产品未定义电子合同模版,不能生成电子合同！");
			return;
		}
		else if (sReturn=="nodoc") {
			sReturn = PopPage("/Data/Report/EDOC/EDocCreateActionAll.jsp?ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&EDocNo="+sEDocNo,"","");
		    if (typeof(sReturn)=="undefined") {
		        alert("生成电子合同失败！");
			    return;
			}
		}
		popComp("EDocView","/Data/Report/EDOC/EDocView.jsp","SerialNo="+sReturn);
	}
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>


	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List07;Describe=页面装载时，进行初始化;]~*/%>
<script	language=javascript>
	AsOne.AsInit();
	init();
	my_load(2,0,'myiframe0');
</script>
<%/*~END~*/%>

<%@	include file="/IncludeEnd.jsp"%>