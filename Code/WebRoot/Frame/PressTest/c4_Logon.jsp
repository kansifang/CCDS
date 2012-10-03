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
 * Content: ��½ҳ����֤ 
 * Input Param:
 * Output param:
 *
 * History Log: 2003.07.18 RCZhu
 *              2003.08.10 XDHou
 *              2004.01.14 FXie
 *              2008.01.10 Fmwu ��������
 */
%>

<%!
//���������
boolean PasswordCheck(String sPwd) 
{
    boolean b1;
    boolean b2;
    String pn1="^(?=.*\\d).{8,}$"; //���ȴ���8�ұ����������
    String pn2="^\\d*$"; //����ȫ������
    b1 = java.util.regex.Pattern.matches(pn1, sPwd);
    b2 = !java.util.regex.Pattern.matches(pn2, sPwd);
    return b1&b2;
}

//�����û�ƫ��,���������ʱ�䡢���ʴ����������޸ı�־
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

	//����û������ͨ�����Ͳ����޸�
	if (sPasswordState == null || sPasswordState.equals("")|| sPasswordState.equals("0")) {
		//�û�������
		if (iVisitTimes == 0) {
			CurPref.setUserPreference("PasswordState","3");
			CurPref.setUserPreference("PasswordMessage","���ǵ�һ��ʹ��ϵͳ�����ȱ����ʼ���룡");
		}
		else if (sPassword.equals("C4CA4238A0B923820DCC509A6F75849B")) {
			CurPref.setUserPreference("PasswordState","1");
			CurPref.setUserPreference("PasswordMessage","��ĵ�ǰ����Ϊϵͳ��ʼ�����룬���ȱ�����룡");
		}
		else if (!PasswordCheck(sPassword)) {
			CurPref.setUserPreference("PasswordState","1");
			CurPref.setUserPreference("PasswordMessage","��ĵ�ǰ���벻����Ҫ������Ҫ������8λ��һ�������ֺ��ַ������ɣ����ȱ�����룡");
		}
		else {
			String sUpdateDate = Sqlca.getString("select UpdateDate from USER_INFO where UserID='"+sUserID+"'");
			if (sUpdateDate==null||sUpdateDate.equals("")) sUpdateDate="1900-01-01";
			sUpdateDate = StringFunction.getRelativeDate(sUpdateDate,91);
			if (StringFunction.getToday().compareTo(sUpdateDate) > 0) {
				CurPref.setUserPreference("PasswordState","2");
				CurPref.setUserPreference("PasswordMessage","�㵱ǰ��������ʹ�õ������ѳ���ϵͳ������������90�죬���ȱ�����룡");
			}
			else {
				CurPref.setUserPreference("PasswordState","0");
				CurPref.setUserPreference("PasswordMessage","����");
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
	//����Session�����µģ����ڲ����¿���IE���ڵ��������Session�ó���Ч
	if(!session.isNew()) {
		session.invalidate();
	}

    session = request.getSession(true);
    com.amarsoft.are.ARE.getLog().trace("Logon.jsp session="+session);

	//���ݿ�����
	Transaction Sqlca = null;
	try
	{
		//��ô���Ĳ������û���¼�˺š����������
		String sUserID   = request.getParameter("UserID");
		String sPassword = request.getParameter("Password");
		String sStyleModel = request.getParameter("StyleModel");
		String sScreenWidth = request.getParameter("ScreenWidth");
		
		//����ѡ���û����ٵ�½��ϵͳ��ʽ���к��ɾ��
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
		sResourcesPath = sResourcesPath + "/" + sStyleModel; 	//����sResourcesPath
		
		//����Դ����
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
				alert("�����ݿ�����ʧ�ܣ�����ϵͳ����Ա��ϵ��");
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
                
		//ȡ��ǰ�û��ͻ�������������� Session
		ASUser CurUser = new ASUser(sUserID,sPassword,Sqlca); 	//������ǰ�û�
		ASOrg CurOrg  = CurUser.BelongOrg;  					//������ǰ����		
		ASPreference CurPref = new ASPreference(Sqlca,sUserID); //�����û�ƫ��
		//�����û�ƫ�ü���������Ϣ
		setCurPref(Sqlca, CurPref,CurUser.UserID,sPassword);

		ASComponentSession CurCompSession = new ASComponentSession();
		ASComponent	CurComp = CurCompSession.creatComponent("Logon","��¼",CurUser,(HttpServletRequest)request);
          
		//�������������Ĳ��� CurARC����IncludeBegin.jsp��ʹ��
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

		//�û���½�ɹ�����¼��½��Ϣ
	    SessionListener sessionListener=new SessionListener(request,session,CurUser,CurOrg);
	    session.setAttribute("listener",sessionListener);

	    CurCompSession.clear(session);
	    out.println("<font color=red>��½�ɹ���</font>");
	}
	catch (Exception e)
	{
	    out.println("<font color=red>��½ʧ�ܣ�</font>");
		e.printStackTrace();
		//add in 2008/05/07 for trace exception
		e.fillInStackTrace();
		e.printStackTrace(new java.io.PrintWriter(System.out));		
		return;
	}
	finally {
		if(Sqlca!=null) {
			//�ϵ���ǰ��������
			Sqlca.conn.commit();
			Sqlca.disConnect();
			Sqlca = null;
		}
	}
%>		
