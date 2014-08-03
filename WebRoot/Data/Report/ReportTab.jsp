<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   cchang 2004-12-16 20:35
		Tester:
		Content: 显示授信业务信息
		Input Param:
            ObjectNo:代号
            InspectType:报告类型
                010	贷款用途报告
				020	贷款检查报告
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "显示授信业务信息"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//获得组件参数	
	String sSerialNo   = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")));
	%>
<%/*~END~*/%>     


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main03;Describe=定义标签;]~*/%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%
		String sSql = "";
		String sItemName = "";
		String sPurposeInspectItems = "";
		String sTitle="";
	  	String sAddStringArray[] = null;
	  	String sTabStrip[][] = new String[30][3];
		int initTab = 1;//设定默认的 tab ，数值代表第几个tab
		String sConfigNo="",sOneKey="";		
		ASResultSet rs=Sqlca.getASResultSet("select ReportConfigNo,OneKey from Batch_Report where SerialNo='"+sSerialNo+"'");
		if(rs.next()){
			sConfigNo=DataConvert.toString(rs.getString(1));
			sOneKey=DataConvert.toString(rs.getString(2));
		}
		rs.getStatement().close();
		//获取
		sSql = "select AttachmentNo,FileName,Attribute1,Attribute2 from Doc_Attachment where DocNo ='"+sConfigNo+"' order by FileName asc";
		rs = Sqlca.getResultSet(sSql);
		int tabs=0;
		int tabsEveryRow=6;//每行显示6个
		while(rs.next()){
			sAddStringArray = new String[] {"",rs.getString(2),"doTabAction('"+
					rs.getString(3).replaceAll("#AttachmentNo",rs.getString(1))
						.replaceAll("#Type", rs.getString(4))
						.replaceAll("#OneKey", sOneKey)
						+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			tabs++;
		}
		rs.getStatement().close();
		int rows=tabs%tabsEveryRow==0?tabs/tabsEveryRow:tabs/tabsEveryRow+1;
		//设定标题
		sTitle = "贷款用途报告";
		//根据定义组生成 tab
		//out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.all('tabtd')"));
		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","tabtd",tabsEveryRow));
		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "TabContentFrame";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=正在打开页面，请稍候";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=yes";
	%>
</script>
<%/*~END~*/%>


<%/*~BEGIN~不可编辑区[Editable=false;CodeAreaID=Main04;Describe=主体页面]~*/%>
<html>
<head>
<title><%=sTitle%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main05;Describe=树图事件;]~*/%>
	<script language=javascript>
  	function doTabAction(ssOpenUrl)
  	{	
  	  	var sOpenUrl=ssOpenUrl;
  	    sOpenUrl=sOpenUrl.replace(/~/g,"\""); 
  		//sOpenUrl=sOpenUrl.replace(/#TargetJSP/g,"<%="sCurrentItemNo".substring(0,"sCurrentItemNo".length()-3)%>");  
  		//sOpenUrl=sOpenUrl.replace("#AttachmentNo","<%=sConfigNo%>");
  		//sOpenUrl=sOpenUrl.replace("#SerialNo","<%=sSerialNo%>");
		eval(sOpenUrl);
		return true;
  	}
  	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区[Editable=true;CodeAreaID=Main06;Describe=在页面装载时执行,初始化;]~*/%>
	<script language=javascript>
	//根据多少组tab自动添加tr td标签
	function addRow(tdidfortab){//每点击一下添加按钮就生成一个上传条 
  		var obj = document.getElementById("tabtid");
  		//table 插入一行tr
  		var r = obj.insertRow(); 
  		//插入一个td
  	    var c =r.insertCell();
  		c.style.backgroundColor="#D8D8AF";
  		c.align="right";
  		c.id=tdidfortab;
  		c.setAttribute("class","tabtd");
  		c =r.insertCell();
  		c.innerHTML+="";
  		c.setAttribute("valign","top");
  		c.setAttribute("class","tabbar");
  	}
	//初始化所有分组tab
  	for(var i=0;i<parseInt("<%=rows%>");i++){
  		addRow("tabtd"+i);
  		hc_drawTabToTable("tab_DeskTopInfo"+i,tabs[i],1,document.all('tabtd'+i));
  	}
	//设定默认页面
	<%=sTabStrip[initTab-1][2]%>;
	</script>	
<%/*~END~*/%>
	
<%@ include file="/IncludeEnd.jsp"%>