<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hxli 2005-8-1
		Tester:
		Describe: 提款记录列表
		
		Input Param:
		SerialNo:流水号
		ObjectType:对象类型
		ObjectNo：对象编号
		
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
	String PG_TITLE = "提款记录列表"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得组件参数
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectNo"));
	String sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	//out.println("tteee"+sSerialNo);
%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info03;Describe=定义数据对象;]~*/%>
	<%
	//通过显示模版产生ASDataObject对象doTemp
	String sHeaders[][] = { {"AccountNo","入账账号"},
							{"CustomerName","入账客户名称"},
							{"CurrencyName","币种"}, 
							{"ItemDate","交易日期"},
							{"ItemSum","交易金额"},
							{"Balance","帐户余额"}
						  };
	String sSql = " select SerialNo,ItemNo,ObjectType,objectno,AccountNo,CustomerName,"+
				  " getItemName('Currency',Currency) as CurrencyName,"+
	              " ItemDate,ItemSum,Balance from INSPECT_DETAIL "+
	              " where ItemType='01' and SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' "+
	              " and  ObjectType='"+sObjectType+"'";
    //sql生成doTemp对象
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新的表
	doTemp.UpdateTable = "INSPECT_DETAIL";
	//设置关键字
	doTemp.setKey("SerialNo,ItemNo,ObjectType,objectno",true);
	//设置不可见项
	doTemp.setVisible("SerialNo,ItemNo,ObjectType,objectno",false);
	
	doTemp.setCheckFormat("ItemSum,Balance","2");//设置输入格式，带逗号的钱数
	doTemp.setAlign("ItemSum,Balance","3");
	doTemp.setVisible("Balance",false);
		
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置DW风格 1:Grid 2:Freeform
	dwTemp.ReadOnly = "1"; //设置为只读
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
		{"true","","Button","新增","新增提款记录","newRecord()",sResourcesPath},
		{"true","","Button","删除","删除提款记录","deleteRecord()",sResourcesPath},
		};
	//检查该报告是否已完成	
	sSql = " select Finishdate from INSPECT_INFO where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"'"+
		   " and  ObjectType='"+sObjectType+"'";
	ASResultSet rs = Sqlca.getResultSet(sSql);

	if(rs.next())
	{
		String s =(String)rs.getString("Finishdate");
		if(s != null)
		{
			sButtons[0][0] = "false";
			sButtons[1][0] = "false";
		}
	}
	rs.getStatement().close();
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
		OpenPage("/CreditManage/CreditCheck/PutoutRecordInfo.jsp?SerialNo=<%=sSerialNo%>&ObjectNo=<%=sObjectNo%>&ObjectType=<%=sObjectType%>&rand="+randomNumber(),"_self","");
	}

	function deleteRecord()
	{
		var sSerialNo = getItemValue(0,getRow(),"SerialNo");
		if (typeof(sSerialNo)=="undefined" || sSerialNo.length==0)
		{
		
			alert("请选择一条记录！");
			
		}
		else
		{		
			if (confirm("您确定要删除该记录吗？"))
			{
				as_del('myiframe0');
				as_save('myiframe0');
			}			
		}
	}
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

