<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.08      
		Tester:	
		Content:  数据采集——对非信贷数据维护
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "非信贷数据维护"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
	//定义变量
	String sSql = "";//存放 sql语句
%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>
<%	
	//获取关联客户信息表数据	
	String sHeaders[][]={
							{"AccountMonth","会计月份"},
							{"AssetNo","资产编号"},
	                        {"SubjectNo","对应会计科目号"},
	                        {"SubjectName","对应会计科目名称"},
	                        {"AssetType","资产形式"},
	                        {"AssetTypeName","资产形式"},
	                        {"DebtorName","债务人名称"},
	                        {"Balance","本期余额"},
	                        {"AuditStatFlag","是否审计"},
	                        {"AuditStatFlagName","是否审计"},
	                        {"Manageuserid","资产管户人"},
	                        {"ManageuserName","资产管户人"},
	                        {"InputUserID","录入人"},
	                        {"InputDate","录入时间"}
                        };
    sSql = " select AccountMonth,AssetNo,SubjectNo,getItemName('SubjectNo',SubjectNo) as SubjectName,AssetType,getItemName('AssetType',AssetType) as AssetTypeName,DebtorName,Balance,"+
    	   " AuditStatFlag,getItemName('AuditStatFlag',AuditStatFlag) as AuditStatFlagName,"+
    	   " getUserName(Manageuserid) as ManageuserName,InputUserID,InputDate " +
    	   " from Reserve_Nocredit "+
    	   " where 1=1";
    
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_Nocredit";
    doTemp.setKey("AssetNo,AccountMonth",true);
    doTemp.setColumnAttribute("AccountMonth,AssetNo,SubjectNo","IsFilter","1");
    doTemp.setVisible("SubjectNo,AssetType,InputUserID,InputDate,AuditStatFlag,AuditStatFlagName,ManageuserName",false);
	//doTemp.setCheckFormat("AccountMonth","6");
	doTemp.setDDDWSql("SubjectNo","select ItemNo,ItemName from code_library where codeno = 'SubjectNo'");
	doTemp.setDDDWSql("AuditStatFlag","select ItemNo,ItemName from code_library where codeno = 'AuditStatFlag'");
	doTemp.setHTMLStyle("AccountMonth,AuditStatFlagName","style={width:80}");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	CurPage.setAttribute("FilterHTML",doTemp.getFilterHtml(Sqlca));
	
	//产生datawindows
	ASDataWindow dwTemp = new ASDataWindow(CurPage ,doTemp,Sqlca);
	//设置在datawindows中显示的行数
	dwTemp.setPageSize(20); 
	//设置DW风格 1:Grid 2:Freeform
	dwTemp.Style="1";      
	//设置是否只读 1:只读 0:可写
	dwTemp.ReadOnly = "1"; 
		
	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("AccountMonth");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	//out.println(doTemp.SourceSql); //调试datawindow的Sql常用方法
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
		//6.资源图片路径{"true","","Button","管户权转移","管户权转移","ManageUserIdChange()",sResourcesPath}
	String sButtons[][] = {
			{"true","","Button","新增","新增一条记录","newRecord()",sResourcesPath},
			{"true","","Button","查看详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除所选中的记录","deleteRecord()",sResourcesPath},
			{"true","","Button","查看附件","查看附件","viewFile()",sResourcesPath},
			{"true","","Button","导出","导出Excel文件","exportAll()",sResourcesPath},
			{"false","","Button","导入","导入信息","CustomerAndView()",sResourcesPath}
		};	
	%> 
<%/*~END~*/%>

<%/*~BEGIN~不可编辑区~[Editable=false;CodeAreaID=List05;Describe=主体页面;]~*/%>
	<%@include file="/Resources/CodeParts/List05.jsp"%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>
	<script language=javascript>
	
	//---------------------定义按钮事件------------------------------------
	function newRecord()
	{
		var sReturn = PopComp("ReserveDataInfo","/BusinessManage/ReserveDataPrepare/ReserveDataInfo.jsp","","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}

	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sSubjectNo = getItemValue(0,getRow(),"SubjectNo");
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		var sAssetNo = getItemValue(0,getRow(),"AssetNo");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("ReserveDataInfo","/BusinessManage/ReserveDataPrepare/ReserveDataInfo.jsp","AccountMonth="+sAccountMonth+"&AssetNo="+sAssetNo,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	function deleteRecord()
	{
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		sLoanAccount = getItemValue(0,getRow(),"AssetNo");
		var para = "AccountMonth="+sAccountMonth+"&LoanAccount="+sLoanAccount;
		if (typeof(sAccountMonth)=="undefined" || sAccountMonth.length==0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0");  //如果单个删除，则要调用此语句
			RunMethod("新会计准则","DeleteNullCredit",sLoanAccount + "," + sAccountMonth );
		}
	}
	
	function viewFile(){
		sAssetNo = getItemValue(0,getRow(),"AssetNo"); 
		if(typeof(sAssetNo) == "undefined" || sAssetNo==""){
			 alert("请选择一条查看信息");
		   return;
		}
        PopComp("AttachmentList1","/BusinessManage/ReserveManage/AttachmentList.jsp","ObjectNo="+sAssetNo+"&rand="+randomNumber(),"_blank");
   }
	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	

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