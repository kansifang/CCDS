<%@page buffer="64kb" errorPage="/ErrorPage.jsp"%>
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
<%!//����REG_DBCONN_DEF��������������ݿⶨ������ȡ���ݿ�����
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
        }else{
            try{
                dsApp = ConnectionManager.getDataSource(sAppDataSourceName);
                Sqlca = ConnectionManager.getTransaction(dsApp);
            }catch(Exception ex){
                throw new Exception("�������ݿ�ʧ�ܣ����Ӳ�����<br>sAppDataSourceName:"+sAppDataSourceName);
            }
        }
    }else{
        Sqlca = ConnectionManager.getTransaction(iAppDBChange,sAppDBURL,sAppDriverClass,sAppUserID,sAppPassword);
    }
    return Sqlca;
}

//ע��ҳ��
void registerPage(Transaction SqlcaRepository,ASComponent CurComp,String sOpenerFunctionName,String sServletURL,ASUser CurUser) throws Exception {
    String sPageID = SqlcaRepository.getString("select PageID from REG_PAGE_DEF where PageID='"+sServletURL+"'");
	if(sPageID == null){
	    System.out.println("����ע��ҳ�棺"+sServletURL);
		String sNow = StringFunction.getToday() + " " + StringFunction.getNow(); 
	    SqlcaRepository.executeSQL("insert into REG_PAGE_DEF(PageID,PageName,PageURL,InputTime,InputUser,InputOrg,UpdateUser,UpdateTime) values('"+sServletURL+"','"+sServletURL+"','"+sServletURL+"','"+sNow+"','"+CurUser.UserID+"','"+CurUser.OrgID+"','"+CurUser.UserID+"','"+sNow+"')");
	    SqlcaRepository.conn.commit();
	
	    if(CurComp!=null){
	    	String sCompID = SqlcaRepository.getString("select CompID from REG_COMP_PAGE where CompID='"+CurComp.ID+"' and PageID='"+sServletURL+"'");
	        if(sCompID==null){
	            System.out.println("���ڽ�ҳ��ע�ᵽ�����"+CurComp.ID+"----"+sServletURL);
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

//�����û�ƫ��
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
}%>
<%
	java.util.Date dBeginTime = new java.util.Date();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss:SSS");
    String sBeginTimeTemp = sdf.format(dBeginTime);
	String sServletURL = request.getServletPath();
	String sCurJspName=request.getContextPath()+sServletURL;

	/*
	Enumeration enumAttrs = session.getAttributeNames();
	if(!enumAttrs.hasMoreElements()) throw new Exception("------Timeout------");
	*/
	if(session.isNew()) throw new Exception("------Timeout------");

	ASConfigure CurConfig = ASConfigure.getASConfigure();
    if(CurConfig ==null) throw new Exception("��ȡ�����ļ���������amarsoft.xml");

    String sDebugMode = CurConfig.getConfigure("DebugMode");
    String sRunTimeDebugMode = CurConfig.getConfigure("RunTimeDebugMode");
    String sCurRunMode=CurConfig.getConfigure("RunMode");

    ASRuntimeContext CurARC = (ASRuntimeContext)session.getAttribute("CurARC");
    ASUser CurUser = (ASUser)CurARC.getAttribute("CurUser");
    ASOrg CurOrg = (ASOrg)CurARC.getAttribute("CurOrg");

    String sWebRootPath = (String)CurARC.getAttribute("WebRootPath");
    String sResourcesPath = (String)CurARC.getAttribute("ResourcesPath");
    String sCompClientID="";
    String sPageClientID = null;

    //--------------------------------------BEGIN--add by xdhou in 2007/11/18 for �ظ�click
	String sCurQueryString = request.getQueryString();
	if (sCurQueryString == null) 
		sCurQueryString = "";
	else{
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
<!--  --><!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
		<html>
		<head>
		<title>��Ϣ</title>
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
		<center>�����ť�������Ӻ���ϵͳ��Ӧ�Ƚ����������ĵȴ��������ظ������</center>
		<br><br>
		<center>�밴<a href="javascript:OpenComp('Main','/Main.jsp','','_top','');">���ﷵ��</a>����ҳ�档</center>
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
	    //--------------------------------------END--add by xdhou in 2007/11/18 for �ظ�click
	    
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
	        
	        if(session==null){
	%>
            <script>
                alert("��ǰ�û����ӳ�ʱ�������µ�¼��");
                if(top.opener){
                    top.opener.open("<%=CurConfig.getConfigure("WebRootPath")%>","_top");
                    top.close();
                }else{
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
        	    throw new Exception("�������ݿ�ʧ�ܣ����Ӳ�����<br>DataSource:"+sDataSource);
        	}

            //--------------------------------------BEGIN--add by byhu
            //��session��ȡ�����ʵ����
            CurCompSession = (ASComponentSession)CurARC.getAttribute("CurCompSession");
            //���������ͻ��˱��
            sCompClientID = request.getParameter("CompClientID");
            if(sCompClientID==null) sCompClientID="";
            CurPref = (ASPreference)CurARC.getAttribute("CurPref");


            //�����ʵ�������ҵ��ÿͻ��˱�ŵ����ʵ��
            if(sCompClientID!=null && !sCompClientID.equals(""))
            {
                CurComp = CurCompSession.lookUp(sCompClientID);
               //��һ�������ǣ��������ҳ��A��رգ��ص�listҳ�����ˢ�£���������list����������ڴ���ע������
               	//�ٴ�Aҳ�棬�������������л��棬���������������������ʱAҳ���ٴ򿪷����ҳ�潫�Ҳ���list�������ʱ�ᱨ��
               //���Իص�ԭlist����ˢ��
                if(CurComp==null){
                    throw new Exception("�������ҳ���ѹ��ڻ��Ҳ�����Ӧ������벻Ҫͨ����ǰ�����������ˡ���ˢ�¡������ʱ�ϵͳ�Ĺ��ܡ��벻Ҫͬʱ�Զ�����ڽ��в�����"+sCompClientID+"<br><a href=\"javascript:window.open('"+sWebRootPath+"/Redirector.jsp?ComponentURL=/Main.jsp&ComponentID=Main','_top');\">����˴�������ҳ�档</a>");
                }
            }else{
                CurComp = null;
                throw new Exception("�Ƿ��ķ��ʷ�ʽ����ҳ�治���������ķ��ʷ�ʽ��</a>");
            }

            //byhu ��ʱ����ҳ��ʵ��
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

            //Ϊ�˴ӵײ�֧��SQL��־������Ҫ��Sqlca�д�ŵ�ǰ����ľ�� byhu 2006.08.02
            //Sqlca.setComponent(CurComp);
            if(sCurRunMode.equals("Development")){
                //����ĸ���������
                String sOpenerFunctionName = DataConvert.toRealString(iPostChange,(String)request.getParameter("OpenerFunctionName"));
                //ҳ��URL
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
<meta http-equiv=Content-Type content="text/html; charset=GBK">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
<link rel="shortcut icon" href="<%=sWebRootPath%>/favicon.ico">
<link rel="stylesheet" href="<%=sResourcesPath%>/Style.css">
<link rel="stylesheet" type="text/css" href="<%=sWebRootPath%>/Frame/page/resources/css/button.css">
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
<!-- <script language=vbscript src="<%=sResourcesPath%>/js/xls.vbs"> </script> -->
<script type=text/javascript>
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
    top.status="��ǰ������<%=CurOrg.OrgID%>-<%=CurOrg.OrgName%>  ��ǰ�û��ǣ�<%=CurUser.UserID%>-<%=CurUser.UserName%> ";
</script>
<%
        }
%>
