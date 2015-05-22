<%@page contentType="text/html; charset=GBK"%>
<%@page buffer="64kb" errorPage="/ErrorPage.jsp"%>

<%@page import="com.lmt.baseapp.util.*"%>
<%@page import="com.lmt.baseapp.user.*"%>
<%@page import="com.lmt.frameapp.web.*"%>
<%@page import="com.lmt.frameapp.ARE"%>
<%@page import="com.lmt.frameapp.sql.*"%>
<%@page import="com.lmt.frameapp.config.ASConfigure"%>
<%@page import="com.lmt.frameapp.config.dal.*"%>
<script language="javascript">
function randomNumber()
{
	today = new Date();
	num = Math.abs(Math.sin(today.getTime()));
	return num;  
}
</script>
<%
	java.util.Date dBeginTime = new java.util.Date();
 	String sServletURL = request.getServletPath();
	String sCurJspName=request.getContextPath()+sServletURL;

	ARE.getLog().trace("Redirector.jsp session="+session+" isNew="+session.isNew());
	if(session==null || session.isNew()) throw new Exception("------Timeout------");
	Transaction SqlcaRepository = null;

    ASConfigure CurConfig = ASConfigure.getASConfigure();
    if(CurConfig==null) throw new Exception("读取配置文件错误！请检查amarsoft.xml");

    String sCurRunMode = CurConfig.getConfigure("RunMode");
    String sDebugMode = CurConfig.getConfigure("DebugMode");
    int iPostChange = Integer.valueOf(CurConfig.getConfigure("PostChange")).intValue();

    ASRuntimeContext CurARC = (ASRuntimeContext)session.getAttribute("CurARC");
	String sWebRootPath = (String)CurARC.getAttribute("WebRootPath");

	ASUser CurUser = (ASUser)CurARC.getAttribute("CurUser");
	ASOrg CurOrg = (ASOrg)CurARC.getAttribute("CurOrg");
    try
	{
		//获得数据库连接，并在后面关闭
   		String sDataSource = CurConfig.getConfigure("DataSource");
       	try{
       		SqlcaRepository = ConnectionManager.getTransaction(sDataSource);
       	}catch(Exception e) {
       		ARE.getLog().error("连接数据库失败！连接参数：<br>DataSource:"+sDataSource,e);
       		e.printStackTrace();
       	    throw new Exception("连接数据库失败！连接参数：<br>DataSource:"+sDataSource);
       	}
	
		CurUser.setTransaction(SqlcaRepository);
	
		String sComponentID = DataConvert.toRealString(iPostChange,(String)request.getParameter("ComponentID"));
		String sComponentName = DataConvert.toRealString(iPostChange,(String)request.getParameter("ComponentName"));
		String sComponentType = DataConvert.toRealString(iPostChange,(String)request.getParameter("ComponentType"));
		String sComponentURL = DataConvert.toRealString(iPostChange,(String)request.getParameter("ComponentURL"));
		String sParentClientID = DataConvert.toRealString(iPostChange,(String)request.getParameter("ParentClientID"));
		String sOpenerClientID = DataConvert.toRealString(iPostChange,(String)request.getParameter("OpenerClientID"));
		String sOpenerFunctionName = DataConvert.toRealString(iPostChange,(String)request.getParameter("OpenerFunctionName"));
		String sToDestroyClientID = DataConvert.toRealString(iPostChange,(String)request.getParameter("ToDestroyClientID"));
		String sToDestroyAllComponent = DataConvert.toRealString(iPostChange,(String)request.getParameter("ToDestroyAllComponent"));
		String sToInheritObj = DataConvert.toRealString(iPostChange,(String)request.getParameter("ToInheritObj"));
		
		String sNow = StringFunction.getToday() + " " + StringFunction.getNow();
		String sDBComponentName=null,sDBComponentURL=null,sDBComponentType=null,sOrderNo=null;
		String sAppID=null;
		String sOpenerCompID=null;
		String sRightID=null;
		ASComponent destoyedComp = null,parentOfDestroyedComp = null;
		
		//add by byhu 20041119, 添加 sToInheritObj 参数
		if(sParentClientID==null || sParentClientID.equals("")){
			sParentClientID=sOpenerClientID;
		}

		ASComponentSession CurCompSession = (ASComponentSession)CurARC.getAttribute("CurCompSession");

		//先找一下Opener的CompID,用于注册组件关联,以防Opener被销毁后无法找到
		if(sOpenerClientID==null && sParentClientID!=null) 
			sOpenerClientID = sParentClientID;
		
		if(sOpenerClientID!=null && !sOpenerClientID.equals("")){
			if(CurCompSession.lookUp(sOpenerClientID)!=null)
				sOpenerCompID = CurCompSession.lookUp(sOpenerClientID).ID;
		}
		
	    //"返回首页" 时，释放所有资源
		if(sToDestroyAllComponent!=null && sToDestroyAllComponent.equals("Y")){
			//remmed by byhu 20050421 同时销毁session中的dw实例
			//CurCompSession.clear();
			//added by byhu 20050421 同时销毁session中的dw实例
			CurCompSession.clear(session);
		}

	    //销毁指定的组件
		if(sToDestroyClientID!=null && !sToDestroyClientID.equals("") && !sToDestroyClientID.equals("undefined")){
			//remmed by byhu 20050421 同时销毁session中的dw实例
			//CurCompSession.lookUpAndDestroy(sToDestroyClientID);
			
			//add by byhu 20050728 暂时建立parentOfDestroyedComp，用于设置为当前组件的parent
			destoyedComp = CurCompSession.lookUp(sToDestroyClientID);
			if(destoyedComp!=null)
				parentOfDestroyedComp = destoyedComp.compParentComponent;
			
			//added by byhu 20050421 同时销毁session中的dw实例
			CurCompSession.lookUpAndDestroy(sToDestroyClientID,session);
		}
		
		ASResultSet rs = null;
		String sSql = "";
		
		//add by zxu 20050509 
		ASValuePool definitions;
	    ASCompDefinition definition;
	    
	    definitions = ASConfigure.getSysConfig(ASConfigure.SYSCONFIG_COMP,SqlcaRepository);
	    Object oTmpDef = definitions.getAttribute(sComponentID.trim());
	    
	    //如果获取不到当前ID的组件定义，说明数据库中没有，则注册到数据库中，并重新LoadConfig
	    if(oTmpDef==null){
			//在开发模式下自动注册该组件
			if(sCurRunMode!=null && sCurRunMode.equals("Development")){
				//自动注册该组件,
				if(sComponentURL==null) 
					throw new Exception("请在第一次调用组件时，传入URL，格式：ComponentURL=/Main.jsp");
				sSql = "insert into REG_COMP_DEF(CompID,OrderNo,InputTime,InputUser,InputOrg,UpdateUser,UpdateTime) values"+
								"('"+sComponentID+"','999999','"+sNow+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sNow+"')";
				try{
					SqlcaRepository.executeSQL(sSql);
					(ASConfigLoaderFactory.getInstance().createLoader(ASConfigure.SYSCONFIG_COMP)).loadConfig(SqlcaRepository);
					System.out.println("自动注册组件:"+sComponentID);
				 }catch(Exception ex){
					System.out.println("自动注册组件失败！");
				}
			}
	    }else{
	        definition = (ASCompDefinition)oTmpDef;
		    sDBComponentURL = (String)definition.getAttribute("CompURL");
		    sDBComponentType = (String)definition.getAttribute("CompType");
		    sAppID = (String)definition.getAttribute("AppID");
		    sRightID = (String)definition.getAttribute("RightID");
		    sDBComponentName = (String)definition.getAttribute("CompName");
		    sOrderNo = (String)definition.getAttribute("OrderNo");
	    }
		
		if(sCurRunMode!=null && sCurRunMode.equals("Development")){
			//更新组件名称
			if(sDBComponentName==null && sComponentName!=null){
				sSql = "update REG_COMP_DEF set CompName='"+sComponentName+"',UpdateUser='"+CurUser.UserID+"',UpdateTime='"+sNow+"' where CompID='"+sComponentID+"'";
				SqlcaRepository.executeSQL(sSql);
				SqlcaRepository.conn.commit();
			}
			//更新组件地址
			if(sDBComponentURL==null && (sComponentURL!=null && !sComponentURL.equals(""))){
				sSql = "update REG_COMP_DEF set CompURL='"+sComponentURL+"',UpdateUser='"+CurUser.UserID+"',UpdateTime='"+sNow+"' where CompID='"+sComponentID+"'";
				SqlcaRepository.executeSQL(sSql);
				SqlcaRepository.conn.commit();
			}
			//更新组件类型
			if(sDBComponentType==null && sComponentType!=null){
				sSql = "update REG_COMP_DEF set CompType='"+sComponentType+"',UpdateUser='"+CurUser.UserID+"',UpdateTime='"+sNow+"' where CompID='"+sComponentID+"'";
				SqlcaRepository.executeSQL(sSql);
				SqlcaRepository.conn.commit();
			}
			//建立组件关联
			if(sOpenerClientID!=null && sOpenerFunctionName!=null){
				sSql = "update REG_FUNCTION_DEF set TargetComp = '"+sComponentID+"',UpdateUser='"+CurUser.UserID+"',UpdateTime='"+sNow+"' where FunctionID='"+sOpenerCompID+"'||'-'||'"+sOpenerFunctionName+"'";
				SqlcaRepository.executeSQL(sSql);
				SqlcaRepository.conn.commit();
			}
			//注册权限点
			if(sRightID==null || sRightID.equals("")){
				sRightID = "组件-"+sComponentID;
			
				sSql = "update REG_COMP_DEF set RightID = '"+sRightID+"',UpdateUser='"+CurUser.UserID+"',UpdateTime='"+sNow+"' where CompID='"+sComponentID+"'";
				try{
					SqlcaRepository.executeSQL(sSql);
					SqlcaRepository.conn.commit();
				}catch(Exception ex){
					System.out.print(ex.toString());
				}
				
				//注册权限点
				sSql = 	" insert into RIGHT_INFO(RightID,RightName,RightStatus,InputTime,InputUser,InputOrg,UpdateUser,UpdateTime) "+
				" values('"+sRightID+"','"+sRightID+"','1','"+sNow+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sNow+"')";
		
				System.out.println("注册权限点："+sRightID);
				try{
					SqlcaRepository.executeSQL(sSql);
					SqlcaRepository.conn.commit();
				}catch(Exception ex){
					System.out.print(ex.toString());
				}
			
				//将权限默认赋给普通用户(800)
				sSql = 	" insert into ROLE_RIGHT(RoleID,RightID,InputTime,InputUser,InputOrg,UpdateUser,UpdateTime) "+
				" values('800','"+sRightID+"','"+sNow+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sNow+"')";
				try{
					SqlcaRepository.executeSQL(sSql);
					SqlcaRepository.conn.commit();
				}catch(Exception ex){
					System.out.print(ex.toString());
				}
		
				CurUser.initUser(CurUser.UserID,SqlcaRepository);//重新计算用户权限
				((ASRoleDefinitionLoader)ASConfigLoaderFactory.getInstance().createLoader(ASConfigure.SYSCONFIG_ROLE)).loadConfig(SqlcaRepository);
				CurUser.initUser(CurUser.UserID,SqlcaRepository);//重新计算用户权限
				System.out.println("将权限默认赋给普通用户(800)："+sRightID);
			}
		}
		
		//判断当前用户是否拥有该组件的权限
		if(!CurUser.hasRight(sRightID)){
			throw new Exception("您没有访问该组件的权限！<br>组件权限点："+sRightID+"<br><a href=\"javascript:window.open('"+sWebRootPath+"/index.html','_top');\">点击此处重新登录。</a>");
		}
/*****************Redirector.jsp主要作用就是产生ClientID号，并注册相关页面和功能点及权限，并和父组件产生关联*******************/		
		//创建当前组件实例，存储传入的parameter,并且在组件会话中注册
		ASComponent CurComp = CurCompSession.creatComponent(sComponentID,sComponentName,CurUser,(HttpServletRequest)request);
		CurComp.setAttribute("iPostChange",String.valueOf(iPostChange));
		CurComp.appID = sAppID;
		
		ASComponent CurCompParent = null;
		if(sParentClientID!=null) CurCompParent = CurCompSession.lookUp(sParentClientID);
		if(CurCompParent!=null) 
			CurComp.compParentComponent = CurCompParent;
		else if(parentOfDestroyedComp!=null) 
			CurComp.compParentComponent = parentOfDestroyedComp;
		
		//如果传入的URL与找到的URL不相同，则有可能不同组件命名重复，报错
		if(sDBComponentURL!=null && !sDBComponentURL.equals("") && sComponentURL!=null && !sComponentURL.equals("") && !sComponentURL.equals(sDBComponentURL)){
			if(sCurRunMode.equalsIgnoreCase("Production"))
				throw new Exception("指定的组件ID已经被注册了。\n传入地址与注册地址不同。\n组件ID:["+sComponentID+"]\n注册地址:["+sDBComponentURL+"]\n传入地址:["+sComponentURL+"]");
%>
			<script>
				if(confirm("传入地址与注册地址不同。\n\n注册地址:<%=sDBComponentURL%>]\n传入地址:[<%=sComponentURL%>]\n\n您可以\n 1.使用另外一个组件号（如果组件ID [<%=sComponentID%>] 已经被别的开发人员注册了），或者\n 2.更改组件注册地址（如果该组件注册信息中的地址有误）。\n\n现在更新组件注册信息吗？点击“确认”编辑组件注册信息。"))
					window.showModalDialog("<%=sWebRootPath%>/Frame/OpenCompDialog.jsp?CompClientID=<%=CurComp.ClientID%>&ComponentID=UpdateCompInfo&ComponentURL=/Common/Configurator/CompManage/CompInfo.jsp&ParaString=CompID=<%=sComponentID%>&rand="+randomNumber(),"diaglogwidth:640px,diaglogheight:480px");
			</script>
			<%
		}
			//更新SortNo
			if(sCurRunMode!=null && sCurRunMode.equals("Development") && (sDBComponentName==null || sOrderNo==null || sOrderNo.indexOf("99")==0)){
			%>
			<script language="javascript">
					if("<%=sComponentID%>"!="UpdateCompInfo" && "<%=sComponentID%>"!="SelectComp"){
						if(confirm("组件 [<%=sComponentID%>] 的注册信息不完善。\n名称: [<%=sDBComponentName%>]\n排序号[<%=sOrderNo%>]\n\n现在更新组件注册信息吗？"))
							window.showModalDialog("<%=sWebRootPath%>/Frame/OpenCompDialog.jsp?CompClientID=<%=CurComp.ClientID%>&ComponentID=UpdateCompInfo&ComponentURL=/Common/Configurator/CompManage/CompInfo.jsp&ParaString=CompID=<%=sComponentID%>&rand="+randomNumber(),"diaglogwidth:640px,diaglogheight:480px");
					}
					</script>
			<%
				}

				//begin 设置权限信息---------------------------------------------------------
				//对象查看器将控制子组件的权限
				if(CurCompParent!=null && sToInheritObj!=null && sToInheritObj.equalsIgnoreCase("y")){
					String sObjectType = (String)CurComp.compParentComponent.getAttribute("CompObjectType");
					String sObjectNo = (String)CurComp.compParentComponent.getAttribute("CompObjectNo");
					String sRightType = (String)CurComp.compParentComponent.getAttribute("RightType");

					if(sRightType!=null){
						//System.out.println("setting attribute to "+CurComp.ID+":"+sRightType);
						CurComp.setAttribute("RightType",sRightType);
					}
					if(sObjectType!=null){
						//System.out.println("setting attribute to "+CurComp.ID+":"+sObjectType);
						CurComp.setAttribute("CompObjectType",sObjectType);
					}
					if(sObjectNo!=null){
						//System.out.println("setting attribute to "+CurComp.ID+":"+sObjectNo);
						CurComp.setAttribute("CompObjectNo",sObjectNo);
					}
				}
				//取信息修改权限（对象权限）信息
				sSql = "select * from REG_FUNCTION_DEF where CompID='"+sComponentID+"'";
				rs = SqlcaRepository.getASResultSet(sSql);
				while(rs.next()){
					CurComp.setAttribute("RightTypeOf_"+rs.getString("FunctionID"),rs.getString("InfoRightType"));
				}
				rs.getStatement().close();
			    //over ---------------------------------------------------------

					//断掉数据库连接
					if(SqlcaRepository!=null)
					{
						SqlcaRepository.conn.commit();
						SqlcaRepository.disConnect();
						SqlcaRepository = null;
					}
					
					if((sComponentURL==null || sComponentURL.equals("")) && sDBComponentURL!=null){
						sComponentURL = sDBComponentURL;
					}
					if(sComponentURL==null || sComponentURL.equals("")){
						if(sCurRunMode.equalsIgnoreCase("Production")) throw new Exception("该组件尚未定义访问地址!组件ID:"+sComponentID);
			%>
						<script language=javascript>
						if(confirm("组件 [<%=sComponentID%>] 尚未定义访问地址。\n\n现在更新组件注册信息吗？"))
							window.showModalDialog("<%=sWebRootPath%>/Frame/OpenCompDialog.jsp?CompClientID=<%=CurComp.ClientID%>&ComponentID=UpdateCompInfo&ComponentURL=/Common/Configurator/CompManage/CompInfo.jsp&ParaString=CompID=<%=sComponentID%>&rand="+randomNumber(),"diaglogwidth:640px,diaglogheight:480px");
						</script>
			<%
						return;
					}
					//目前做到了浏览器地址栏始终只显示Main.jsp,所以此处对这个Main.jsp也进行混淆隐藏，达到全部真实地址都隐藏的目的
					if(sComponentURL.contains("/Main.jsp")){
						sComponentURL = sComponentURL.replace("Main.jsp", "123456")+CurComp.ClientID;
						sComponentURL = sWebRootPath+sComponentURL;
					}else{
						sComponentURL = sComponentURL+"?CompClientID="+CurComp.ClientID;
						sComponentURL = sWebRootPath+sComponentURL;
					}
					
			%>
			<!--<jsp22:forward page="<1%=sComponentURL%>" /> -->
					<script language="javascript">
						window.open("<%=sComponentURL%>","_self","");
					</script>
		<%
			}catch(Exception e){	
				if(SqlcaRepository!=null)
				{
					SqlcaRepository.conn.rollback();
					SqlcaRepository.disConnect();
					SqlcaRepository = null;
				}
				throw e;
			}
			finally
			{
				if(SqlcaRepository!=null)
				{
					SqlcaRepository.conn.commit();
					SqlcaRepository.disConnect();
					SqlcaRepository = null;
				}
		        if(sDebugMode!=null && sDebugMode.equals("1")) {
		        	java.util.Date dEndTime = new java.util.Date();
		            java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss:SSS");
		        	double iTimeConsuming = (dEndTime.getTime()-dBeginTime.getTime())/1000.0;
		        	ARE.getLog().debug("[RED]"+sdf.format(dBeginTime)+" : "+iTimeConsuming+" ["+CurUser.UserID+"]["+sCurJspName+"]");
				}
			}
		%>