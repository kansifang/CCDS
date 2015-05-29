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
        }else
        {
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
}%>
<%
    java.util.Date dBeginTime = new java.util.Date();
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss:SSS");
	String sCurJspName=request.getContextPath()+request.getServletPath();

	Enumeration enumAttrs = session.getAttributeNames();
    if(!enumAttrs.hasMoreElements()) throw new Exception("------Timeout------");

	ASConfigure CurConfig = ASConfigure.getASConfigure();
    if(CurConfig ==null) throw new Exception("��ȡ�����ļ���������amarsoft.xml");

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
        	    throw new Exception("�������ݿ�ʧ�ܣ����Ӳ�����<br>DataSource:"+sDataSource);
        	}

            CurUser = (ASUser)CurARC.getAttribute("CurUser");
            CurOrg = (ASOrg)CurARC.getAttribute("CurOrg");
			//SessionID�Ǵ��ڻ����е�dw��ASDataWindow
            sSessionID = DataConvert.toRealString(5,(String)request.getParameter("SessionID"));
            if( sSessionID == null || sSessionID.equals("") )
                sSessionID = DataConvert.toRealString(5,(String)request.getParameter("dw"));
            if( sSessionID == null || sSessionID.equals("") )
                throw new Exception("------û�л��DW����------");

            //����ͻ��˱��
            sCompClientID = StringFunction.getSeparate(sSessionID,"|",2);
            sPageClientID = StringFunction.getSeparate(sSessionID,"|",3);

            //��session��ȡ�����ʵ����
            CurCompSession = (ASComponentSession)CurARC.getAttribute("CurCompSession");

            //�����ʵ�������ҵ��ÿͻ��˱�ŵ����ʵ��
            if(sCompClientID!=null && !sCompClientID.equals(""))
            {
                CurComp = CurCompSession.lookUp(sCompClientID);
              	//��һ�������ǣ��������ҳ��A��رգ��ص�listҳ�����ˢ�£�list����������ڴ���ע�����������ٴ�Aҳ�棬Aҳ���ٴ򿪷����ҳ�潫�Ҳ���list�������ʱ�ᱨ��
              	//�Ӹ�rand=amarRand()�ܽ��������������⣬����ڲ���Ҫ�������������ã�������ص����������ڷ������˻�destroy,��ʱ�ٴ�����л���Ļ�����������������������ٽ�һ����ҳ�潫
				//��������ڻ��Ҳ�������
				//��������������������
                if(CurComp==null){
                    throw new Exception("DW�����������ҳ���ѹ��ڻ��Ҳ�����Ӧ�����"+sCompClientID);
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

            //Ϊ�˴ӵײ�֧��SQL��־������Ҫ��Sqlca�д�ŵ�ǰ����ľ�� byhu 2006.08.02
            //Sqlca.setComponent(CurComp);

            if(CurComp!=null){
                if(sPageClientID!=null && !sPageClientID.equals(""))
                {
                    CurPage = CurComp.lookUpPage(sPageClientID);
                }else{
                    throw new Exception("DW�����޷��ҵ�ASPageʵ����"+sPageClientID);
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
			//���DW������Դ�Ǳ��������Դ 
			String sDataSource0 = CurConfig.getConfigure("DataSource");
			String sDataSourceReport0 = CurConfig.getConfigure("DataSource_Report");
			if(dwTemp0.getDataSourceName().equals(sDataSourceReport0))
			{
				//������������Դ����ϵͳ������Դһ�£��������»�ȡ���ݿ�����
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
					    throw new Exception("�������ݿ�ʧ�ܣ����Ӳ�����<br>DataSource_Report:"+sDataSourceReport0);
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
    top.status="��ǰ������<%=CurOrg.OrgID%>-<%=CurOrg.OrgName%>  ��ǰ�û��ǣ�<%=CurUser.UserID%>-<%=CurUser.UserName%> ";
</script>
<%
        }
%>