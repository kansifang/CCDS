<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Info00;Describe=注释区;]~*/%>
	<% 
	/*
		Author: 
		Tester:
		Describe: 显示客户相关的现金流预测
		Input Param:
	        CustomerID ： 当前客户编号
			BaseYear   : 基准年份:距离现在最近的一年  
			YearCount  : 预测年数:default=1
			ReportScope: 报表口径
		Output Param:
			
		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-22 fbkang    新的版本的改写
	 */
%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "客户现金流测算详情"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%
    //定义变量
    ASResultSet rs = null;
	String sCustomerName = "",sReportScopeName="";
    //获得页面参数
	String sCustomerID  = DataConvert.toRealString(CurPage.getParameter("CustomerID"));
	String sBaseYear    = DataConvert.toRealString(CurPage.getParameter("BaseYear"));
	sBaseYear = sBaseYear.substring(0,4);//做个字符串转换，在double型转化为Integer时会报错
	String sYearCount   = DataConvert.toRealString(CurPage.getParameter("YearCount"));
	String sReportScope = DataConvert.toRealString(CurPage.getParameter("ReportScope"));
    //获得组件参数
%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=获得变量值;]~*/%>
<%
	rs = Sqlca.getResultSet("select EnterpriseName from ent_info where CustomerID = '" + sCustomerID + "' ");
	if(rs.next())
		sCustomerName = rs.getString(1);
	rs.getStatement().close();
	rs = Sqlca.getResultSet("select getItemName('ReportScope','"+sReportScope+"') from role_info ");
	if(rs.next())
		sReportScopeName = rs.getString(1);
	rs.getStatement().close();


	String sYear1,sYear2,sYear3,sYear4,sYear5,sMonth1,sMonth2,sMonth3,sMonth4,sMonth5;

	sYear1 = sBaseYear;														//前一年
	sMonth1 = sYear1 + "/12";
	sYear2 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 1);		//前二年
	sMonth2 = sYear2 + "/12";
	sYear3 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 2);		//前三年
	sMonth3 = sYear3 + "/12";
	sYear4 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 3);		//前四年
	sMonth4 = sYear4 + "/12";
	sYear5 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 4);		//前五年
	sMonth5 = sYear5 + "/12";

	String sSql = "",sMessage = "";
	//5
	sSql = 	"select count(*) from customer_fsrecord " +
			" where CustomerID = '" + sCustomerID + "' and reportdate ='" + sMonth5 + "' and ReportScope = '" + sReportScope + "' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth5+"无"+sReportScopeName+"报表";
	rs.getStatement().close();
	//4
	sSql = 	"select count(*) from customer_fsrecord " +
			" where CustomerID = '" + sCustomerID + "' and reportdate ='" + sMonth4 + "' and ReportScope = '" + sReportScope + "' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth4+"无"+sReportScopeName+"报表";
	rs.getStatement().close();
	//3
	sSql = 	"select count(*) from customer_fsrecord " +
			" where CustomerID = '" + sCustomerID + "' and reportdate ='" + sMonth3 + "' and ReportScope = '" + sReportScope + "' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth3+"无"+sReportScopeName+"报表";
	rs.getStatement().close();
	//2
	sSql = 	"select count(*) from customer_fsrecord " +
			" where CustomerID = '" + sCustomerID + "' and reportdate ='" + sMonth2 + "' and ReportScope = '" + sReportScope + "' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth2+"无"+sReportScopeName+"报表";
	rs.getStatement().close();
	//1
	sSql = 	"select count(*) from customer_fsrecord " +
			" where CustomerID = '" + sCustomerID + "' and reportdate ='" + sMonth1 + "' and ReportScope = '" + sReportScope + "' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth1+"无"+sReportScopeName+"报表";
	rs.getStatement().close();
%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List04;Describe=定义数据对象;]~*/%>
<%
	String sHeaders1[][] =
	{
		{"ParameterCode","参数指标号"},
		{"ParameterName","参数名称"},
		{"Value1","前一年"},
		{"Value2","前二年"},
		{"Value3","前三年"},
		{"Value4","前二年"},
		{"Value5","前三年"},
		{"Valuea","平均值"},
		{"Value0","假定值"},
		{"name1","参数名称"}
	};

	sHeaders1[2][1]=sMonth1;
	sHeaders1[3][1]=sMonth2;
	sHeaders1[4][1]=sMonth3;
	sHeaders1[5][1]=sMonth4;
	sHeaders1[6][1]=sMonth5;

	sSql = 	"select CustomerID,BaseYear,ReportScope,ParameterNo,"+
			" ParameterCode,ParameterName,Value5,Value4,Value3,Value2,Value1,Valuea,Value0,ParameterName as name1 "+
			"  from CashFlow_Parameter " +
			" where CustomerID = '" + sCustomerID + "' " +
			"   and BaseYear = " + sBaseYear +
			//"   and ParameterNo >= 0 " +
			"   and ParameterNo >= 1 " +
			" order by ParameterNo";

	//通过sql产生数据窗体对象
	ASDataObject doPara = new ASDataObject(sSql);
	//设置表头
	doPara.setHeader(sHeaders1);
	doPara.UpdateTable = "CashFlow_Parameter";
	doPara.setKey("CustomerID,BaseYear,ReportScope,ParameterNo",true);
	//doPara.setRequired("Value0",true); //通过js自己判断输入是否完全
	doPara.setReadOnly("ParameterCode,ParameterName,Value5,Value4,Value3,Value2,Value1,Valuea,name1",true);
	doPara.setVisible("CustomerID,BaseYear,ReportScope,ParameterNo,ParameterCode,name1",false);

	//设置html格式
	/*
	doPara.setHTMLStyle("ParameterCode"," style={width:80px} ");
	doPara.setHTMLStyle("ParameterName,name1"," style={width:380px} ");
	doPara.setHTMLStyle("Value5,Value4,Value3,Value2,Value1,Valuea"," style={width:80px} ");
	doPara.setHTMLStyle("Value0"," style={width:80px;background-color:#88FFFF;color:black} ");
	*/
	doPara.setHTMLStyle("ParameterCode"," style={width:60px} ");
	doPara.setHTMLStyle("ParameterName,name1"," style={width:280px} ");
	doPara.setHTMLStyle("Value5,Value4,Value3,Value2,Value1,Valuea"," style={width:60px} ");
	doPara.setHTMLStyle("Value0"," style={width:80px;background-color:#88FFFF;color:black} ");

	doPara.setAlign("Value5,Value4,Value3,Value2,Value1,Valuea,Value0","3");
	doPara.setType("BaseYear,ParameterNo,Value5,Value4,Value3,Value2,Value1,Valuea,Value0","Number");
	//doPara.setCheckFormat("Value5,Value4,Value3,Value2,Value1,Valuea,Value0","2");


	//生成ASDataWindow对象
	ASDataWindow dwPara = new ASDataWindow(CurPage,doPara,Sqlca);
	dwPara.Style="1";      //设置为Grid风格
	dwPara.ReadOnly = "0"; //设置为只读
	Vector vPara = dwPara.genHTMLDataWindow("");
	for(int i=0;i<vPara.size();i++) out.print((String)vPara.get(i));
	session.setAttribute(dwPara.Name,dwPara);

	String sHeaders2[][] =
	{
		{"ItemNo","指标编号"},
		{"ItemName","指标"},
		{"ItemValue","未来1年指标值"}
	};

	sSql = 	"select ItemNo,ItemName,ItemValue "+
		"  from CashFlow_Data " +
                " where CustomerID = '" + sCustomerID + "' "+
		"   and BaseYear = " + sBaseYear +
		"   and FCN = " + sYearCount +
		" order by ItemNo";

	//通过sql产生数据窗体对象
	ASDataObject doData = new ASDataObject(sSql);
	//设置表头
	doData.setHeader(sHeaders2);

	//设置html格式

	doData.setHTMLStyle("ItemNo"," style={width:80px} ");
	doData.setHTMLStyle("ItemName"," style={width:200px} ");
	doData.setAlign("ItemValue","3");
	doData.setType("ItemValue","Number");
	doData.setAlign("ItemNo","2");
	doData.setType("ItemNo","Integer");//by jgao 整型显示

	//生成ASDataWindow对象
	ASDataWindow dwData = new ASDataWindow(CurPage,doData,Sqlca);
	dwData.Style="1";      //设置为Grid风格
	dwData.ReadOnly = "1"; //设置为只读
	Vector vData = dwData.genHTMLDataWindow("");
	for(int i=0;i<vData.size();i++) out.print((String)vData.get(i));
%>
<script language=javascript>
	AsOne.AsInit();
</script>
<%/*~END~*/%>

<html>
<head>
<title>现金流量预测</title>
</head><body bgcolor="#DEDFCE" leftmargin="0" topmargin="0" onload="" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr height=1 valign=top bgcolor='#DEDFCE'>
    <td>
    	<table>
	    	<tr>
       		<td>
              <%=HTMLControls.generateButton("现金流预测","进行现金流预测","javascript:my_compute()",sResourcesPath)%>
    		</td>
       		<td>
              <%=HTMLControls.generateButton("转出至电子表格","转出至电子表格","javascript:my_export()",sResourcesPath)%>
    		</td>
       		<td>
              <%=HTMLControls.generateButton("返回","返回现金流预测列表","javascript:my_close()",sResourcesPath)%>
    		</td>
    		</tr>
    	</table>
    </td>
</tr>
<tr height=1 valign=top >
	<td style="font-size:9.0pt">&nbsp客户名称：<%=sCustomerName%> </td>
</tr>
<tr height=1 valign=top >
	<td style="font-size:9.0pt">&nbsp报表口径：<%=sReportScopeName%> &nbsp;&nbsp;单位：人民币万元 &nbsp;&nbsp;<font color=red>注意：<%=sMessage%></font></td>
</tr>
<tr height=1 valign=top >
	<td style="font-size:9.0pt;">&nbsp提示：所得税率的假定值主要参考核定的所得税率，有息债务总额的假定值以最近一年的为参考依据</td>
</tr>

<tr height=1 valign=top align=center>
	<td style="font-size:12.0pt;font-weight:600;">&nbsp现金流量预测参数选择</td>
</tr>
<tr>
    <td>
	<iframe name="myiframe0" width=100% height=100% frameborder=0></iframe>
    </td>
</tr>
<tr height=1 valign=top align=center>
	<td style="font-size:12.0pt;font-weight:600;">&nbsp现金流量预测表</td>
</tr>
<tr>
    <td>
	<iframe name="myiframe1" width=100% height=100% frameborder=0></iframe>
    </td>
</tr>
</table>

</body>
</html>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List05;Describe=自定义函数;]~*/%>
<script language="JavaScript">
   //---------------------定义按钮事件------------------------------------
   /*~[Describe=导出到电子表格;InputParam=后续事件;OutPutParam=无;]~*/
	function my_export()
	{
		var mystr = my_load_save(2,0,"myiframe1");
		spreadsheetTransfer(mystr);
	}
    /*~[Describe=计算;InputParam=后续事件;OutPutParam=无;]~*/
	function my_compute()
	{
		for(ii=0;ii<getRowCount(0);ii++)
		{
			if(getItemValue(0,ii,"Value0")+"A"=="A")
			{
				alert("请输入第"+(parseInt(ii,10)+1)+"行：“"+getItemValue(0,ii,"ParameterName")+"”的假定值！");
				return;
			}
		}
		as_save('myiframe0','my_compute2()');
	}
	/*~[Describe=打开窗口;InputParam=无;OutPutParam=无;]~*/
	function my_compute2()
	{
		OpenPage("/CustomerManage/FinanceAnalyse/CashFlowCompute.jsp?CustomerID=<%=sCustomerID%>&YearCount=<%=sYearCount%>&ReportScope=<%=sReportScope%>&BaseYear=<%=sBaseYear%>","_self");
	}
    /*~[Describe=关闭窗口;InputParam=无;OutPutParam=无;]~*/
	function my_close()
	{
		OpenPage("/CustomerManage/FinanceAnalyse/CashFlowList.jsp?","_self","");
	}

	function mySelectRow()
	{
		//demo code
		//if(myiframe0.event.srcElement.tagName=="BODY") return;
		//setColor();
		//if(myiframe1.event.srcElement.tagName!="") return;
	}

</script>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=对页面的一些操作;]~*/%>

<script language=javascript>
	bSavePrompt = false;
	bHighlight = false;
	init();

	//不要排序
	needReComputeIndex[0]=0;
	needReComputeIndex[1]=0;   
	
	my_load(2,0,'myiframe0',1);  //1 for change
	my_load(2,0,'myiframe1');
	AsMaxWindow();
	for(ii=0;ii<getRowCount(0);ii++)
		getASObject(0,ii,"Value0").style.cssText = getASObject(0,ii,"Value0").style.cssText + ";width:80px;background-color:#88FFFF;color:black";
	//setItemFocus(0,0,'Value0');

	//重新func,为了可输入负数
	function reg_Num(str)
	{
		var Letters = "-1234567890.,";
		var j = 0;
		if(str=="" || str==null) return true;
		for (i=0;i<str.length;i++)
		{
			var CheckChar = str.charAt(i);
			if (Letters.indexOf(CheckChar) == -1){return false;}
			if (CheckChar == "."){j = j + 1;}
		}
		if (j > 1){return false;}

		return true;
	}

	document.frames("myiframe1").document.body.onmousedown = Function("return false;");
	document.frames("myiframe1").document.body.onKeyUp = Function("return false;");
	
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
