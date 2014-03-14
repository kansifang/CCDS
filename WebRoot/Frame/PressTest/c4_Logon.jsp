<%@page contentType="text/html; charset=GBK"%>
<%@page buffer="64kb" errorPage="/ErrorPage.jsp"%>
<%@page import="com.amarsoft.are.sql.*"%>
<%@page import="com.amarsoft.are.util.*"%>
<%@page import="com.amarsoft.context.*"%>
<%@page import="com.amarsoft.web.*"%>
<%@page import="com.amarsoft.web.dw.*"%>
<%@page import="com.amarsoft.web.config.ASConfigure"%>

<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: RCZhu 2003.7.18
 * Tester:
 *
 * Content: 登陆页面验证 
 * Input Param:
 * Output param:
 *
 * History Log: 2003.07.18 RCZhu
 *              2003.08.10 XDHou
 *              2004.01.14 FXie
 *              2008.01.10 Fmwu 重新整理
 */
%>

<%!
//口令规则检查
boolean PasswordCheck(String sPwd) 
{
    boolean b1;
    boolean b2;
    String pn1="^(?=.*\\d).{8,}$"; //长度大于8且必须包含数字
    String pn2="^\\d*$"; //必须全是数字
    b1 = java.util.regex.Pattern.matches(pn1, sPwd);
    b2 = !java.util.regex.Pattern.matches(pn2, sPwd);
    return b1&b2;
}

//设置用户偏好,如最近访问时间、访问次数及密码修改标志
void setCurPref(Transaction Sqlca, ASPreference CurPref,String sUserID,String sPassword) throws Exception{
	String sNow = StringFunction.getToday()+" "+StringFunction.getNow();
	String sLastTime = CurPref.getUserPreference(Sqlca,"CurSignInTime");
	CurPref.setUserPreference("LastSignInTime",sLastTime);
	CurPref.setUserPreference("CurSignInTime",sNow);
	String sVisitTimes = CurPref.getUserPreference(Sqlca,"VisitTimes");
	int iVisitTimes = 0;
	if( sVisitTimes.length() > 0 )
		iVisitTimes = Integer.parseInt(sVisitTimes);
	CurPref.setUserPreference("VisitTimes",String.valueOf(iVisitTimes+1));
	String sPasswordState = CurPref.getUserPreference(Sqlca,"PasswordState");

	//如果用户口令本身不通过，就不做修改
	if (sPasswordState == null || sPasswordState.equals("")|| sPasswordState.equals("0")) {
		//用户口令检查
		if (iVisitTimes == 0) {
			CurPref.setUserPreference("PasswordState","3");
			CurPref.setUserPreference("PasswordMessage","你是第一次使用系统，请先变更初始密码！");
		}
		else if (sPassword.equals("C4CA4238A0B923820DCC509A6F75849B")) {
			CurPref.setUserPreference("PasswordState","1");
			CurPref.setUserPreference("PasswordMessage","你的当前密码为系统初始化密码，请先变更密码！");
		}
		else if (!PasswordCheck(sPassword)) {
			CurPref.setUserPreference("PasswordState","1");
			CurPref.setUserPreference("PasswordMessage","你的当前密码不符合要求，密码要求至少8位，一定由数字和字符混合组成，请先变更密码！");
		}
		else {
			String sUpdateDate = Sqlca.getString("select UpdateDate from USER_INFO where UserID='"+sUserID+"'");
			if (sUpdateDate==null||sUpdateDate.equals("")) sUpdateDate="1900-01-01";
			sUpdateDate = StringFunction.getRelativeDate(sUpdateDate,91);
			if (StringFunction.getToday().compareTo(sUpdateDate) > 0) {
				CurPref.setUserPreference("PasswordState","2");
				CurPref.setUserPreference("PasswordMessage","你当前密码连续使用的期限已超过系统所允许的最长期限90天，请先变更密码！");
			}
			else {
				CurPref.setUserPreference("PasswordState","0");
				CurPref.setUserPreference("PasswordMessage","正常");
			}
		}
	}
	CurPref.commitPreference(Sqlca);
}
%>

<script language=javascript>
	function randomNumber()
	{
		today = new Date();
		num = Math.abs(Math.sin(today.getTime()));
		return num;  
	}
</script>
<% 	
	//假如Session不是新的，对于不是新开的IE窗口等情况，将Session置成无效
	if(!session.isNew()) {
		session.invalidate();
	}

    session = request.getSession(true);
    com.amarsoft.are.ARE.getLog().trace("Logon.jsp session="+session);

	//数据库连接
	Transaction Sqlca = null;
	try
	{
		//获得传入的参数：用户登录账号、口令、界面风格
		String sUserID   = request.getParameter("UserID");
		String sPassword = request.getParameter("Password");
		String sStyleModel = request.getParameter("StyleModel");
		String sScreenWidth = request.getParameter("ScreenWidth");
		
		//下拉选框用户快速登陆，系统正式运行后可删除
		String sUserIDSelected = "";
		if (sUserID==null||sUserID.equals(""))
		{
			sUserIDSelected = request.getParameter("UserIDSelected");
			sUserID = sUserIDSelected;
		}
		sStyleModel = request.getParameter("StyleModel");
		if (sStyleModel==null || sStyleModel.equals(""))
			sStyleModel="1";
		
		ASConfigure CurConfig  = ASConfigure.getASConfigure(application);
		String sWebRootPath = CurConfig.getWebRootPath();
		String sResourcesPath = sWebRootPath+CurConfig.getConfigure("ResourcesPath");
		sResourcesPath = sResourcesPath + "/" + sStyleModel; 	//修正sResourcesPath
		
		//数据源定义
		String sDataSource = CurConfig.getConfigure("DataSource");
		try  {
			Sqlca = ConnectionManager.getTransaction(sDataSource);         
		}
		catch (Exception e)
		{
			e.printStackTrace();
	    %>
			<script language=javascript>
				alert("<%=StringFunction.replace(e.toString(),"\"","")%>");
				alert("与数据库连接失败，请与系统管理员联系！");
				window.open("index.html","_top");
			</script>			
	    <%
			return;
		}

		String sPostChange = CurConfig.getConfigure("PostChange");
		DataConvert.iChange = Integer.valueOf(sPostChange).intValue();
		Transaction.iChange = Integer.valueOf(CurConfig.getConfigure("DBChange")).intValue();
		Transaction.iDebugMode = Integer.valueOf(CurConfig.getConfigure("TransDebugMode")).intValue();

		ASDataWindow.iDebugMode = Integer.valueOf(CurConfig.getConfigure("DebugMode")).intValue();;
		ASDataWindow.iTransMode = Integer.valueOf(CurConfig.getConfigure("AmarDWTransMode")).intValue();
		ASDataWindow.iChange = Integer.valueOf(CurConfig.getConfigure("AmarDWChange")).intValue();
		ASDataWindow.iMaxRows = Integer.valueOf(CurConfig.getConfigure("AmarDWMaxRows")).intValue();
		DBFunction.sDataSource = sDataSource;				
                
		//取当前用户和机构，并将其放入 Session
		ASUser CurUser = new ASUser(sUserID,sPassword,Sqlca); 	//建立当前用户
		ASOrg CurOrg  = CurUser.BelongOrg;  					//建立当前机构		
		ASPreference CurPref = new ASPreference(Sqlca,sUserID); //建立用户偏好
		//设置用户偏好及口令检查信息
		setCurPref(Sqlca, CurPref,CurUser.UserID,sPassword);

		ASComponentSession CurCompSession = new ASComponentSession();
		ASComponent	CurComp = CurCompSession.creatComponent("Logon","登录",CurUser,(HttpServletRequest)request);
          
		//设置运行上下文参数 CurARC　在IncludeBegin.jsp中使用
		ASRuntimeContext CurARC = new ASRuntimeContext();
	 	String sCABDesc = " CLASSID=\"CLSID:"+CurConfig.getConfigure("CABClassID")+"\" codeBase="+sResourcesPath+"/Support/"+CurConfig.getConfigure("CABName")+"#Version=1,0,0,0 ";
	 	CurARC.setAttribute("CABDesc",sCABDesc); 
		CurARC.setAttribute("ResourcesPath",sResourcesPath);
		CurARC.setAttribute("WebRootPath",sWebRootPath);
		CurARC.setAttribute("PostChange",sPostChange);
		CurARC.setAttribute("CurUser",CurUser);
		CurARC.setAttribute("CurOrg",CurOrg);
		CurARC.setAttribute("CurCompSession",CurCompSession);
		CurARC.setAttribute("CurPref",CurPref);
		CurARC.setAttribute("ScreenWidth",sScreenWidth);

		String sCurRequestURL = request.getRequestURL().toString();
		String sMyPattern = sWebRootPath;
		if(sMyPattern=="")  sMyPattern = "/";	
		String sDefaultHtml = sCurRequestURL.substring(0,sCurRequestURL.indexOf(sMyPattern,8))+sWebRootPath+"/amarsoft.html";

		//add in 2008/04/10 for https
		//sWebRootPath = sCurRequestURL.substring(0,sCurRequestURL.indexOf(sMyPattern,8))+sWebRootPath;
		//CurARC.setAttribute("WebRootPath",sWebRootPath);

		CurARC.setAttribute("DefaultHtml",sDefaultHtml);
		session.setAttribute("CurARC",CurARC);

		//用户登陆成功，记录登陆信息
	    SessionListener sessionListener=new SessionListener(request,session,CurUser,CurOrg);
	    session.setAttribute("listener",sessionListener);

	    CurCompSession.clear(session);
	    out.println("<font color=red>登陆成功！</font>");
	}
	catch (Exception e)
	{
	    out.println("<font color=red>登陆失败！</font>");
		e.printStackTrace();
		//add in 2008/05/07 for trace exception
		e.fillInStackTrace();
		e.printStackTrace(new java.io.PrintWriter(System.out));		
		return;
	}
	finally {
		if(Sqlca!=null) {
			//断掉当前数据连接
			Sqlca.conn.commit();
			Sqlca.disConnect();
			Sqlca = null;
		}
	}
%>		
