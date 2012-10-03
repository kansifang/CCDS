<%@page buffer="64kb" errorPage="/ErrorPage.jsp"%>
<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.*"%>
<%@page import="com.amarsoft.are.ARE"%>
<%@page import="com.amarsoft.are.sql.*"%>
<%@page import="com.amarsoft.are.util.*"%>
<%@page import="com.amarsoft.context.*"%>
<%@page import="com.amarsoft.amarscript.*"%>
<%@page import="com.amarsoft.alert.*"%>
<%@page import="com.amarsoft.web.*"%>
<%@page import="com.amarsoft.web.dw.*"%>
<%@page import="com.amarsoft.web.ui.*"%>
<%@page import="com.amarsoft.app.util.*"%>
<%@page import="com.amarsoft.web.config.ASConfigure"%>
<%!
//根据REG_DBCONN_DEF的组件定义中数据库定义来获取数据库连接
Transaction getSqlca(Transaction SqlcaRepository, String sAppID, String sDataSource) throws Exception {
	Transaction Sqlca;
    ASResultSet rsInclude = null;
    javax.sql.DataSource dsApp = null;

    String sAppConnType=null;
    String sAppProviderURL = null;
    String sAppDataSourceName=null;
    String sAppDBURL=null;
    String sAppDriverClass=null;
    String sAppUserID=null;
    String sAppPassword=null;
    int iAppDBChange=0;

    String sIBSql = "select * from REG_DBCONN_DEF where DBConnectionID = (select DBConnectionID from REG_APP_DEF where AppID='"+sAppID+"') ";
    rsInclude = SqlcaRepository.getASResultSet(sIBSql);
    if (rsInclude.next()){
        iAppDBChange = rsInclude.getInt("DBChange");
        sAppConnType = rsInclude.getString("ConnType");
        sAppProviderURL = rsInclude.getString("ProviderURL");
        sAppDataSourceName = rsInclude.getString("DataSourceName");
        sAppDBURL = rsInclude.getString("DBURL");
        sAppDriverClass = rsInclude.getString("DriverClass");
        sAppUserID = rsInclude.getString("UserID");
        sAppPassword = rsInclude.getString("Password");
    }
    rsInclude.getStatement().close();

    if(sAppConnType!=null && sAppConnType.equals("DataSource"))
    {
        if(sAppDataSourceName.equals(sDataSource) && sAppProviderURL.equals(sDataSource))
        {
            Sqlca = SqlcaRepository;
        }else
        {
            try{
                dsApp = ConnectionManager.getDataSource(sAppDataSourceName);
                Sqlca = ConnectionManager.getTransaction(dsApp);
            }catch(Exception ex){
                throw new Exception("连接数据库失败！连接参数：<br>sAppDataSourceName:"+sAppDataSourceName);
            }
        }
    }else{
        Sqlca = ConnectionManager.getTransaction(iAppDBChange,sAppDBURL,sAppDriverClass,sAppUserID,sAppPassword);
    }
    return Sqlca;
}

//注册页面
void registerPage(Transaction SqlcaRepository,ASComponent CurComp,String sOpenerFunctionName,String sServletURL,ASUser CurUser) throws Exception {
    String sPageID = SqlcaRepository.getString("select PageID from REG_PAGE_DEF where PageID='"+sServletURL+"'");
	if(sPageID == null){
	    System.out.println("正在注册页面："+sServletURL);
		String sNow = StringFunction.getToday() + " " + StringFunction.getNow(); 
	    SqlcaRepository.executeSQL("insert into REG_PAGE_DEF(PageID,PageName,PageURL,InputTime,InputUser,InputOrg,UpdateUser,UpdateTime) values('"+sServletURL+"','"+sServletURL+"','"+sServletURL+"','"+sNow+"','"+CurUser.UserID+"','"+CurUser.OrgID+"','"+CurUser.UserID+"','"+sNow+"')");
	    SqlcaRepository.conn.commit();
	
	    if(CurComp!=null){
	    	String sCompID = SqlcaRepository.getString("select CompID from REG_COMP_PAGE where CompID='"+CurComp.ID+"' and PageID='"+sServletURL+"'");
	        if(sCompID==null){
	            System.out.println("正在将页面注册到组件："+CurComp.ID+"----"+sServletURL);
	            System.out.println("insert into REG_COMP_PAGE(CompID,PageID) values('"+CurComp.ID+"','"+sServletURL+"')");
	            if(CurComp!=null)  SqlcaRepository.executeSQL("insert into REG_COMP_PAGE(CompID,PageID) values('"+CurComp.ID+"','"+sServletURL+"')");
	            SqlcaRepository.conn.commit();
	        }
	    }else{
	        SqlcaRepository.executeSQL("insert into REG_COMP_PAGE(CompID,PageID) values('Main','"+sServletURL+"')");
	        SqlcaRepository.conn.commit();
	    }
	}
	if(CurComp!=null && sOpenerFunctionName!=null && !sOpenerFunctionName.equals("")){
	    String sFSql="update REG_FUNCTION_DEF set TargetPage = '"+sServletURL+"' where FunctionID='"+CurComp.ID+"-"+sOpenerFunctionName+"'";
	    SqlcaRepository.executeSQL(sFSql);
	    SqlcaRepository.conn.commit();
	}
}

//设置用户偏好
void setCurPref(ASPreference CurPref, ASComponent CurComp) throws Exception{
	CurPref.setUserPreference("LastVisitComp",CurComp.ID);
	CurPref.setUserPreference("LastVisitCompURL",CurComp.CompURL);
	if( CurComp.Name != null && CurComp.Name.length() > 0 )
	    CurPref.setUserPreference("LastVisitCompName",CurComp.Name);
	else
	    CurPref.setUserPreference("LastVisitCompName",CurComp.ID);
	CurPref.setUserPreference("LastVisitApp",CurComp.appID);
	StringBuffer sbCompPara = new StringBuffer("");
	Vector vParaList = CurComp.parameterList;
	ASParameter tmpPara;
	for( int ii = 0; ii < vParaList.size(); ii++ ){
	    tmpPara = (ASParameter)vParaList.elementAt(ii);
	    if( !tmpPara.paraName.equals("rand1") ){
	        sbCompPara.append(tmpPara.paraName);
	        sbCompPara.append("=");
	        sbCompPara.append(tmpPara.paraValue);
	        sbCompPara.append("&");
	    }
	}
	int length = sbCompPara.length();
	if( length > 0 ) {
	    length--;
	    CurPref.setUserPreference("LastVisitCompPara",sbCompPara.substring(0,length));
	}else{
	    CurPref.setUserPreference("LastVisitCompPara","");
	}
}
%>
<%
    java.util.Date dBeginTime = new java.util.Date();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss:SSS");
    String sBeginTimeTemp = sdf.format(dBeginTime);
	String sServletURL = request.getServletPath();
	String sCurJspName=request.getContextPath()+sServletURL;

	Enumeration enumAttrs = session.getAttributeNames();
    if(!enumAttrs.hasMoreElements()) throw new Exception("------Timeout------");

	ASConfigure CurConfig = ASConfigure.getASConfigure();
    if(CurConfig ==null) throw new Exception("读取配置文件错误！请检查amarsoft.xml");

    String sDebugMode = CurConfig.getConfigure("DebugMode");
    String sRunTimeDebugMode = CurConfig.getConfigure("RunTimeDebugMode");
    String sCurRunMode=CurConfig.getConfigure("RunMode");

    ASRuntimeContext CurARC = (ASRuntimeContext)session.getAttribute("CurARC");
    ASUser CurUser = (ASUser)CurARC.getAttribute("CurUser");
    ASOrg CurOrg = (ASOrg)CurARC.getAttribute("CurOrg");

    String sCABDesc = (String)CurARC.getAttribute("CABDesc");;
    String sWebRootPath = (String)CurARC.getAttribute("WebRootPath");
    String sResourcesPath = (String)CurARC.getAttribute("ResourcesPath");
    String sCompClientID="";
    String sPageClientID = null;

    //--------------------------------------BEGIN--add by xdhou in 2007/11/18 for 重复click
	String sCurQueryString = request.getQueryString();
	if (sCurQueryString == null) 
		sCurQueryString = "";
	else
	{
		String[] sMQuery = sCurQueryString.split("&");
		sCurQueryString = "";
		for(int i1=0;i1<sMQuery.length;i1++)
		if(sMQuery[i1].length()>5 && !sMQuery[i1].substring(0,5).equals("rand="))
		sCurQueryString += sMQuery[i1]+"&";
	}

    if (session.getAttribute("LastRunJspName")!=null && 
		session.getAttribute("LastRunJspName").equals(sCurJspName) &&
		session.getAttribute("LastRunQueryString").equals(sCurQueryString) &&
		session.getAttribute("LastRunEndTime").equals("") )
	{
    	ARE.getLog().warn("[BBB]"+sBeginTimeTemp+" : "+CurUser.UserID+"  :  "+sCurJspName+" reclick(wait)...request.getQueryString...ana..."+sCurQueryString);

	    sResourcesPath = (String)CurARC.getAttribute("ResourcesPath");
	    sWebRootPath = (String)CurARC.getAttribute("WebRootPath");
	    sCompClientID = request.getParameter("CompClientID");
	    if(sCompClientID==null) sCompClientID="";
	    sPageClientID = request.getParameter("PageClientID");
	    if(sPageClientID==null) sPageClientID="";
	%>
		<html>
		<head>
		<title>信息</title>
		<META http-equiv=Content-Type content="text/html; charset=GBK">
		<script language=javascript>
		    var sWebRootPath = "<%=sWebRootPath%>";
		    var sResourcesPath = "<%=sResourcesPath%>";
		    var sCompClientID = "<%=sCompClientID%>";
		    var sPageClientID = "<%=sPageClientID%>";
		</script>
		<script language=javascript src="<%=sResourcesPath%>/common.js"> </script>
		</head>
		<body bgcolor="#DCDCDC" style="font-size:9pt">
		<br><br><br>
		<br><br><br>
		<center>点击按钮或者链接后，若系统反应比较慢，请耐心等待，请勿重复点击。</center>
		<br><br>
		<center>请按<a href="javascript:OpenComp('Main','/Main.jsp','','_top','');">这里返回</a>到主页面。</center>
		</body>
		</html>
	<%
        ARE.getLog().warn("[BBB]"+sBeginTimeTemp+" : "+CurUser.UserID+"  :  "+sCurJspName+"  :  no_exec");
		return;
	}
	else
	{
		session.setAttribute("LastRunEndTime","");
		session.setAttribute("LastRunJspName",sCurJspName);
		session.setAttribute("LastRunQueryString",sCurQueryString);
		session.setAttribute("LastRunBeginTime",sBeginTimeTemp);
	}
    //--------------------------------------END--add by xdhou in 2007/11/18 for 重复click
    
    Transaction SqlcaRepository = null;
    Transaction Sqlca = null;

    try
    {
        int iPostChange = Integer.valueOf(CurConfig.getConfigure("PostChange")).intValue();

        ASComponentSession CurCompSession;
        ASComponent CurComp = null;
        ASPage CurPage = null;
        String sToDestroyPageClientID = null;
        ASPreference CurPref = null;
        
        if(session==null)
        {
%>
            <script>
                alert("当前用户连接超时，请重新登录！");
                if(top.opener)
                {
                    top.opener.open("<%=CurConfig.getConfigure("WebRootPath")%>","_top");
                    top.close();
                }
                else
                {
                    open("<%=CurConfig.getConfigure("WebRootPath")%>","_top");
                }

            </script>
        <%
            return;
        }
        else
        {
    		String sDataSource = CurConfig.getConfigure("DataSource");
        	try{
        		SqlcaRepository = ConnectionManager.getTransaction(sDataSource);
        	}catch(Exception ex) {
        		ex.printStackTrace();
        	    throw new Exception("连接数据库失败！连接参数：<br>DataSource:"+sDataSource);
        	}

            //--------------------------------------BEGIN--add by byhu
            //从session中取出组件实例集
            CurCompSession = (ASComponentSession)CurARC.getAttribute("CurCompSession");
            //传入的组件客户端编号
            sCompClientID = request.getParameter("CompClientID");
            if(sCompClientID==null) sCompClientID="";
            CurPref = (ASPreference)CurARC.getAttribute("CurPref");


            //从组件实例集中找到该客户端编号的组件实例
            if(sCompClientID!=null && !sCompClientID.equals(""))
            {
                CurComp = CurCompSession.lookUp(sCompClientID);
                if(CurComp==null){
                    throw new Exception("您请求的页面已过期。请不要通过“前进”、“后退”或“刷新”来访问本系统的功能。请不要同时对多个窗口进行操作。<br><a href=\"javascript:window.open('"+sWebRootPath+"/Redirector.jsp?ComponentURL=/Main.jsp&ComponentID=Main','_top');\">点击此处返回主页面。</a>");
                }
            }else{
                CurComp = null;
                throw new Exception("非法的访问方式：本页面不允许非组件的访问方式！</a>");
            }

            //byhu 及时销毁页面实例
            sToDestroyPageClientID = request.getParameter("ToDestroyPageClientID");
            if(CurComp!=null && sToDestroyPageClientID!=null && !sToDestroyPageClientID.equals("")){
                CurComp.lookUpAndDestroyPage(sToDestroyPageClientID);
                System.out.print("Destroying page:"+sToDestroyPageClientID);
            }

            if(CurComp == null || CurComp.appID == null || CurComp.appID.equals(""))
            {
                Sqlca = SqlcaRepository;
            } else {
                Sqlca = getSqlca(SqlcaRepository,CurComp.appID,CurConfig.getConfigure("DataSource"));
            }

            //为了从底层支持SQL日志，把需要在Sqlca中存放当前组件的句柄 byhu 2006.08.02
            //Sqlca.setComponent(CurComp);
            if(sCurRunMode.equals("Development"))
            {
                //传入的父方法名称
                String sOpenerFunctionName = DataConvert.toRealString(iPostChange,(String)request.getParameter("OpenerFunctionName"));
                //页面URL
                registerPage(SqlcaRepository,CurComp,sOpenerFunctionName,sServletURL,CurUser);
            }

            sPageClientID = request.getParameter("PageClientID");
            if(CurComp!=null){
                if(sPageClientID!=null && !sPageClientID.equals(""))
                {
                    CurPage = CurComp.lookUpPage(sPageClientID);
                }else{
                    CurPage = new ASPage(CurComp);
                }
                CurPage.setRequestAttribute((HttpServletRequest)request);
                sPageClientID = CurPage.ClientID;
            }
            Sqlca.conn.commit();
            SqlcaRepository.conn.commit();

            if( CurComp != null && CurComp.CompType != null && CurComp.CompType.equalsIgnoreCase("MainWindow")) {
				setCurPref(CurPref,CurComp);
                try{
                    CurPref.commitPreference(Sqlca);
                }catch(Exception em){
                    System.out.println("Warning...: "+em.getMessage());
                }
            }
%>
<META http-equiv=Content-Type content="text/html; charset=GBK">
<link rel="stylesheet" href="<%=sResourcesPath%>/Style.css">
<script language=javascript>
    var sWebRootPath = "<%=sWebRootPath%>";
    var sResourcesPath = "<%=sResourcesPath%>";
    var sCompClientID = "<%=sCompClientID%>";
    var sPageClientID = "<%=sPageClientID%>";
    var sCurJspName = "<%=sCurJspName%>";  //新增
</script>
<script language=javascript src="<%=sResourcesPath%>/expand.js"> </script>
<script language=javascript src="<%=sResourcesPath%>/htmlcontrol.js"> </script>
<script language=javascript src="<%=sResourcesPath%>/String.js"> </script>
<script language=javascript src="<%=sResourcesPath%>/Support/as_dz.js"> </script>
<script language=javascript src="<%=sResourcesPath%>/Support/checkdatavalidity.js"> </script>
<script language=javascript src="<%=sResourcesPath%>/HtmlEdit/editor1.js"> </script>
<script language=javascript src="<%=sResourcesPath%>/common.js"> </script>
<script language=javascript src="<%=sResourcesPath%>/message.js"> </script>
<script language=javascript src="<%=sResourcesPath%>/menu.js"> </script>
<script language=vbscript src="<%=sResourcesPath%>/xls.vbs"> </script>
<script language=javascript>
    <%
    if(CurComp!=null){
    %>
        try{
            top.LastRetrievedCompID = "<%=CurComp.ID%>";
        }catch(e){
        }
    <%
    }
    %>
    var _editor_url = "<%=sResourcesPath%>/HtmlEdit/";
    top.status="当前机构：<%=CurOrg.OrgID%>-<%=CurOrg.OrgName%>  当前用户是：<%=CurUser.UserID%>-<%=CurUser.UserName%> ";
</script>
<%
        }
%>