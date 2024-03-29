<%@page import="java.lang.reflect.Array"%>
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
	String sSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")));
	String sConfigNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportConfigNo")));
	String sOneKey   =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OneKey")));	
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
		//标签组所在的记录 parentAttachmentNo=attachmentNo
		sSql = "select AttachmentNo,ParentFileName from Doc_Attachment where DocNo ='"+sConfigNo+"' and nvl(AttachmentNo,'A')=nvl(ParentAttachmentNo,'B') order by ParentFileName asc";
		ASResultSet rs = Sqlca.getResultSet(sSql);
		int tabs=0;
		int tabsEveryRow=6;//每行显示6个
		while(rs.next()){
			String sPatentAttachmentNo=rs.getString(1);
			String sTabName=rs.getString(2);
			sSql = "select replace(Attribute1,'#AttachmentNo',AttachmentNo) "+//AttachmentNo决定了页面的SQL
					" from Doc_Attachment where DocNo ='"+sConfigNo+"'"+
					" and nvl(ParentAttachmentNo,'')='"+sPatentAttachmentNo+"' order by FileName asc";
			String[]sAURLS=Sqlca.getStringArray(sSql);
			String sURLS=StringFunction.toArrayString(sAURLS,"@");
			sAddStringArray = new String[]{"",sTabName,
					"doTabAction('"+
						sURLS.replaceAll("#OneKey", sOneKey)//这个和当前报告密切相关
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
		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=100% height=100%";
		String sTabHeadStyle = "";
		String sTabHeadText = "报告标题";
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
  	  	ssOpenUrl=ssOpenUrl.replace(/~/g,"\"");
  	  	var sOpenUrl=ssOpenUrl.split("@");
  		eval(sOpenUrl[0]);
  		//有附属页面就另外打开
  		var OpenStyle="width="+(sScreenWidth*0.6)+"px,height="+sScreenHeight*0.8+"px,top=0,right=0,toolbar=no,scrollbars=yes,resizable=yes,status=no,menubar=no";
  		if(sOpenUrl.length>1){
  			for(var i=1;i<sOpenUrl.length;i++){
				var xxx=sOpenUrl[i].replace("<%=sIframeName%>",""+i).replace("#style",OpenStyle);
  				eval(xxx);
  			}
  		}
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
  		c.align="left";
  		c.id=tdidfortab;
  		//c.colspan="2";
  		c.width="100%";
  		//c.setAttribute("class","tabtd");
  		//c.setAttribute("colspan","3");
  		/*标签行插一个单元格让整个铺满
  		c =r.insertCell();
  		c.innerHTML+="ccc";
  		c.setAttribute("valign","top");
  		c.setAttribute("class","tabbar");
  		*/
  	}
	//初始化所有分组tab,每一行tabs一个 <table></table>
  	for(var i=0;i<parseInt("<%=rows%>");i++){
  		addRow("tabtd"+i);
  		hc_drawTabToTable("tab_DeskTopInfo"+i,tabs[i],1,document.all('tabtd'+i));
  	}
	//设定默认页面
	<%=sTabStrip[initTab-1][2]%>;
	</script>	
<%/*~END~*/%>
	
<%@ include file="/IncludeEnd.jsp"%>