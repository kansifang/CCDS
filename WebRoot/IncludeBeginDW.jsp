<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.*"%>
<%@page import="java.util.*"%>
<%@page import="com.lmt.frameapp.ARE"%>
<%@page import="com.lmt.frameapp.sql.*"%>
<%@page import="com.lmt.baseapp.util.*"%>
<%@page import="com.lmt.baseapp.user.*"%>
<%@page import="com.lmt.frameapp.script.*"%>
<%@page import="com.lmt.frameapp.web.*"%>
<%@page import="com.lmt.frameapp.web.render.*"%>
<%@page import="com.lmt.frameapp.web.ui.*"%>
<%@page import="com.lmt.frameapp.config.ASConfigure"%>
<%!//根据REG_DBCONN_DEF的组件定义中数据库定义来获取数据库连接
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
}%>
<%
    java.util.Date dBeginTime = new java.util.Date();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss:SSS");
	String sCurJspName=request.getContextPath()+request.getServletPath();

	Enumeration enumAttrs = session.getAttributeNames();
    if(!enumAttrs.hasMoreElements()) throw new Exception("------Timeout------");

	ASConfigure CurConfig = ASConfigure.getASConfigure();
    if(CurConfig ==null) throw new Exception("读取配置文件错误！请检查amarsoft.xml");

    String sDebugMode = CurConfig.getConfigure("DebugMode");
    String sRunTimeDebugMode = CurConfig.getConfigure("RunTimeDebugMode");
    String sCurRunMode=CurConfig.getConfigure("RunMode");

    ASRuntimeContext CurARC = (ASRuntimeContext)session.getAttribute("CurARC");

    String sWebRootPath = (String)CurARC.getAttribute("WebRootPath");
    String sResourcesPath = (String)CurARC.getAttribute("ResourcesPath");

    Transaction SqlcaRepository = null;
    Transaction Sqlca = null;
    ASUser CurUser = null;
    ASOrg  CurOrg = null;
    String sSessionID = null;

    try
    {
        int iPostChange = Integer.valueOf(CurConfig.getConfigure("PostChange")).intValue();

        ASComponentSession CurCompSession;
        ASComponent CurComp = null;
        String sCompClientID="";
        ASPage CurPage = null;
        String sPageClientID = null;
        String sToDestroyPageClientID = null;
        ASPreference CurPref = null;
        String sServletURL = request.getServletPath();
        if(session!=null)
        {
            String sDataSource = CurConfig.getConfigure("DataSource");
        	try{
        		javax.sql.DataSource ds = ConnectionManager.getDataSource(sDataSource);
        		SqlcaRepository = ConnectionManager.getTransaction(ds);
        	}catch(Exception ex) {
        		ex.printStackTrace();
        	    throw new Exception("连接数据库失败！连接参数：<br>DataSource:"+sDataSource);
        	}

            CurUser = (ASUser)CurARC.getAttribute("CurUser");
            CurOrg = (ASOrg)CurARC.getAttribute("CurOrg");
			//SessionID是存在缓存中的dw：ASDataWindow
            sSessionID = DataConvert.toRealString(5,(String)request.getParameter("SessionID"));
            if( sSessionID == null || sSessionID.equals("") )
                sSessionID = DataConvert.toRealString(5,(String)request.getParameter("dw"));
            if( sSessionID == null || sSessionID.equals("") )
                throw new Exception("------没有获得DW名称------");

            //组件客户端编号
            sCompClientID = StringFunction.getSeparate(sSessionID,"|",2);
            sPageClientID = StringFunction.getSeparate(sSessionID,"|",3);

            //从session中取出组件实例集
            CurCompSession = (ASComponentSession)CurARC.getAttribute("CurCompSession");

            //从组件实例集中找到该客户端编号的组件实例
            if(sCompClientID!=null && !sCompClientID.equals(""))
            {
                CurComp = CurCompSession.lookUp(sCompClientID);
              	//有一个问题是，如果打开新页面A后关闭，回到list页面而不刷新，list这个组件会从内存中注销掉，所以再打开A页面，A页面再打开非组件页面将找不到list组件，这时会报错
              	//加个rand=amarRand()能借据浏览器缓存问题，这对于不需要缓存的情况很有用（打开组件关掉组件，组件在服务器端会destroy,这时再打开组件有缓存的话不会请求服务器，这个组件再进一步打开页面将
				//报组件过期或找不到错误）
				//完美解决报这个错误问题
                if(CurComp==null){
                    throw new Exception("DW错误：您请求的页面已过期或找不到相应组件："+sCompClientID);
                }
            }else{
                CurComp = null;
            }

            if(CurComp == null)
            {
                Sqlca = SqlcaRepository;

            }else if(CurComp.appID == null || CurComp.appID.equals(""))
            {
                Sqlca = SqlcaRepository;
            }else
            {
                Sqlca = getSqlca(SqlcaRepository,CurComp.appID,CurConfig.getConfigure("DataSource"));
            }

            //为了从底层支持SQL日志，把需要在Sqlca中存放当前组件的句柄 byhu 2006.08.02
            //Sqlca.setComponent(CurComp);

            if(CurComp!=null){
                if(sPageClientID!=null && !sPageClientID.equals(""))
                {
                    CurPage = CurComp.lookUpPage(sPageClientID);
                }else{
                    throw new Exception("DW错误：无法找到ASPage实例："+sPageClientID);
                }

            }
            Sqlca.conn.commit();
            SqlcaRepository.conn.commit();
            
            //add in 2008/04/10,2008/02/14 for report sort etc
			ASDataWindow dwTemp0 = null;
			if(CurPage!=null)
				dwTemp0 = (ASDataWindow) CurPage.getAttribute(sSessionID);
			else
				dwTemp0 = (ASDataWindow) session.getAttribute(sSessionID);	
			//如果DW的数据源是报表的数据源 
			String sDataSource0 = CurConfig.getConfigure("DataSource");
			String sDataSourceReport0 = CurConfig.getConfigure("DataSource_Report");
			if(dwTemp0.getDataSourceName().equals(sDataSourceReport0))
			{
				//如果报表的数据源和主系统的数据源一致，则不再重新获取数据库连接
				if (!sDataSource0.equals(sDataSourceReport0)) {
					if(Sqlca != SqlcaRepository)
					{
					    Sqlca.conn.commit();
					    Sqlca.disConnect();
					    Sqlca = null;
					}
					
					try{
						javax.sql.DataSource ds_report = ConnectionManager.getDataSource(sDataSourceReport0);
					    Sqlca = ConnectionManager.getTransaction(ds_report);
					}catch(Exception ex){
						ex.printStackTrace();
					    throw new Exception("连接数据库失败！连接参数：<br>DataSource_Report:"+sDataSourceReport0);
					}
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
</script>
<script type=text/javascript src="<%=sResourcesPath%>/js/jquery-1.3.2.min.js"></script>
<script type=text/javascript src="<%=sResourcesPath%>/js/as_dz.js"> </script>
<script type=text/javascript src="<%=sResourcesPath%>/js/as_dz_middle.js"> </script>
<script type=text/javascript src="<%=sResourcesPath%>/js/grid.js"> </script>
<script type=text/javascript src="<%=sResourcesPath%>/js/fform.js"> </script>
<script type=text/javascript src="<%=sResourcesPath%>/js/init.js"> </script>
<script type=text/javascript src="<%=sResourcesPath%>/js/as_control.js"></script>
<script type=text/javascript src="<%=sResourcesPath%>/js/as_webcalendar.js"></script>
<script type=text/javascript src="<%=sResourcesPath%>/js/mainmenu.js"> </script>
<script type=text/javascript src="<%=sResourcesPath%>/js/treemenu.js"> </script>
<script type=text/javascript src="<%=sResourcesPath%>/js/tabaform.js"> </script>
<script type=text/javascript src="<%=sResourcesPath%>/js/String.js"> </script>
<script type=text/javascript src="<%=sResourcesPath%>/js/checkdatavalidity.js"> </script>
<script type=text/javascript src="<%=sResourcesPath%>/js/common.js"> </script>
<script type=text/javascript src="<%=sResourcesPath%>/js/message.js"> </script>
<script type=text/javascript src="<%=sResourcesPath%>/HtmlEdit/editor.js"> </script>
<script type=text/javascript src="<%=sResourcesPath%>/js/xls.js"> </script>
<script language=javascript>
var AsOne = {
		SetDefault:function(sURL){
			document.write("<iframe name=myform999 src='"+sURL+"' frameborder=0 width=1 height=1 style='display:none'> </iframe>");
			},
		AsInit:function() {} 
	};
AsOne.SetDefault("");
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