<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>  
	<%
	/*
		Author:   --jjwang  2008.10.14      
		Tester:	
		Content:  数据采集——个人业务
		Input Param:
		Output param:
		History Log:  
	*/
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "个人业务"; // 浏览器窗口标题 <title> PG_TITLE </title>
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
	
			        	  	
	String sHeaders[][] = { 
									{"AccountMonth","会计月份"},
									{"AccountMonth1","会计月份"},
									{"Serialno","序列号"},
									{"AAdjustValue","调整系数"},
									{"MAdjustValue","调整系数"},
									{"MLossRate1","正常类贷款损失率"},	
									{"MLossRate2","关注类贷款损失率"},
									{"MLossRate3","次级类贷款损失率"},
									{"MLossRate4","可疑类贷款损失率"},
									{"MLossRate5","损失类贷款损失率"},
									{"ALossRate1","正常类贷款损失率"},
									{"ALossRate2","关注类贷款损失率"},
									{"ALossRate3","次级类贷款损失率"},
									{"ALossRate4","可疑类贷款损失率"},
									{"ALossRate5","损失类贷款损失率"},
									{"OverDueDaysAdjust1","正常天数调整系数"},
									{"OverDueDaysAdjust2","逾期1-30天数调整系数"},
									{"OverDueDaysAdjust3","逾期31-90天数调整系数"},
									{"OverDueDaysAdjust4","逾期91-180天数调整系数"},
									{"OverDueDaysAdjust5","逾期181-360天数调整系数"},
									{"OverDueDaysAdjust6","逾期360天以上数调整系数"},
									{"BaseDate","基准日期"},
									{"LastAccountMonth","上期会计月份"},
									{"Grade","级次"}
			        	  	}; 
    sSql = " select AccountMonth,AccountMonth as AccountMonth1,Serialno,AAdjustValue,MAdjustValue,MLossRate1, MLossRate2,MLossRate3,MLossRate4,MLossRate5, "+
    	   " ALossRate1,ALossRate2,ALossRate3,ALossRate4,ALossRate5,OverDueDaysAdjust1,OverDueDaysAdjust2,OverDueDaysAdjust3, " +
    	   " OverDueDaysAdjust4,OverDueDaysAdjust5,OverDueDaysAdjust6,BaseDate,LastAccountMonth,Grade " +
	       " from Reserve_IndPara " +
	       " where 1=1 ";
    
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
    doTemp.UpdateTable="Reserve_IndPara";
    doTemp.setKey("AccountMonth",true);
    doTemp.setVisible("AccountMonth,MAdjustValue,MLossRate1,Serialno,MLossRate2,MLossRate3,MLossRate4,MLossRate5,ALossRate1,ALossRate2,ALossRate3,ALossRate4,ALossRate5,OverDueDaysAdjust1,OverDueDaysAdjust2,OverDueDaysAdjust3,OverDueDaysAdjust4,OverDueDaysAdjust5,OverDueDaysAdjust6,Grade",false);
    //doTemp.setCheckFormat("AccountMonth","6");
    //doTemp.setDDDWSql("AccountMonth","select distinct AccountMonth,AccountMonth from Reserve_IndPara desc");
    doTemp.setColumnAttribute("AccountMonth","IsFilter","1");
    doTemp.setType("AAdjustValue","Number");
	doTemp.generateFilters(Sqlca);
	doTemp.parseFilterData(request,iPostChange);
	doTemp.multiSelectionEnabled = false;
	//if(!doTemp.haveReceivedFilterCriteria()){
	//	doTemp.WhereClause += " and AccountMonth In (Select max(AccountMonth) from Reserve_IndPara )";
	//}
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
			{"true","","Button","新增","新增记录","newRecord()",sResourcesPath},
			{"true","","Button","查看详情","查看/修改详情","viewAndEdit()",sResourcesPath},
			{"true","","Button","删除","删除记录","deleteRecord()",sResourcesPath}	,
			{"true","","Button","查看附件","查看附件","my_View()",sResourcesPath}
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
		var sReturn = PopComp("DataBaseIndInfo","/BusinessManage/ReserveDataPrepare/DataBaseIndInfo.jsp","","resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
		reloadSelf();
	}
	/*~[Describe=查看及修改详情;InputParam=无;OutPutParam=无;]~*/
	function viewAndEdit()
	{
		var sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		if (typeof(sAccountMonth) == "undefined" || sAccountMonth.length == 0)
		{
			alert(getHtmlMessage('1'));
			return;
		}
		var sReturn = PopComp("DataBaseIndInfo","/BusinessManage/ReserveDataPrepare/DataBaseIndInfo.jsp","AccountMonth="+sAccountMonth,"resizable=yes;dialogWidth=210;dialogHeight=100;center:yes;status:no;statusbar:no");
        if (typeof(sReturn) == "undefined" || sReturn.length == 0)
        {
        	return;
        }
        reloadSelf();
		
	}
	function deleteRecord(sPostEvents)
	{
		sAccountMonth = getItemValue(0,getRow(),"AccountMonth");
		if (typeof(sAccountMonth)=="undefined" || sAccountMonth.length==0)
		{
			alert(getHtmlMessage('1')); //请选择一条信息！
			return;
		}
		if(confirm(getHtmlMessage('2'))) //您真的想删除该信息吗？
		{
			as_del("myiframe0");
			as_save("myiframe0",sPostEvents);  //如果单个删除，则要调用此语句
		}
	}
	/*~[Describe=导出;InputParam=无;OutPutParam=无;]~*/
	function exportAll()
	{
		amarExport("myiframe0");
	}	
	function my_View(){
		sSerialNo =  getItemValue(0,getRow(),"Serialno");
		if(typeof(sSerialNo) == "undefined" || sSerialNo==""){
			 alert("请选择一条查看信息");
		   return;
		}
        PopComp("CSAttachmentList","/BusinessManage/ReserveManage/CSAttachmentList.jsp","ObjectNo="+sSerialNo+"&rand="+randomNumber(),"_blank");
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