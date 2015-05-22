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
    if(CurConfig==null) throw new Exception("��ȡ�����ļ���������amarsoft.xml");

    String sCurRunMode = CurConfig.getConfigure("RunMode");
    String sDebugMode = CurConfig.getConfigure("DebugMode");
    int iPostChange = Integer.valueOf(CurConfig.getConfigure("PostChange")).intValue();

    ASRuntimeContext CurARC = (ASRuntimeContext)session.getAttribute("CurARC");
	String sWebRootPath = (String)CurARC.getAttribute("WebRootPath");

	ASUser CurUser = (ASUser)CurARC.getAttribute("CurUser");
	ASOrg CurOrg = (ASOrg)CurARC.getAttribute("CurOrg");
    try
	{
		//������ݿ����ӣ����ں���ر�
   		String sDataSource = CurConfig.getConfigure("DataSource");
       	try{
       		SqlcaRepository = ConnectionManager.getTransaction(sDataSource);
       	}catch(Exception e) {
       		ARE.getLog().error("�������ݿ�ʧ�ܣ����Ӳ�����<br>DataSource:"+sDataSource,e);
       		e.printStackTrace();
       	    throw new Exception("�������ݿ�ʧ�ܣ����Ӳ�����<br>DataSource:"+sDataSource);
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
		
		//add by byhu 20041119, ��� sToInheritObj ����
		if(sParentClientID==null || sParentClientID.equals("")){
			sParentClientID=sOpenerClientID;
		}

		ASComponentSession CurCompSession = (ASComponentSession)CurARC.getAttribute("CurCompSession");

		//����һ��Opener��CompID,����ע���������,�Է�Opener�����ٺ��޷��ҵ�
		if(sOpenerClientID==null && sParentClientID!=null) 
			sOpenerClientID = sParentClientID;
		
		if(sOpenerClientID!=null && !sOpenerClientID.equals("")){
			if(CurCompSession.lookUp(sOpenerClientID)!=null)
				sOpenerCompID = CurCompSession.lookUp(sOpenerClientID).ID;
		}
		
	    //"������ҳ" ʱ���ͷ�������Դ
		if(sToDestroyAllComponent!=null && sToDestroyAllComponent.equals("Y")){
			//remmed by byhu 20050421 ͬʱ����session�е�dwʵ��
			//CurCompSession.clear();
			//added by byhu 20050421 ͬʱ����session�е�dwʵ��
			CurCompSession.clear(session);
		}

	    //����ָ�������
		if(sToDestroyClientID!=null && !sToDestroyClientID.equals("") && !sToDestroyClientID.equals("undefined")){
			//remmed by byhu 20050421 ͬʱ����session�е�dwʵ��
			//CurCompSession.lookUpAndDestroy(sToDestroyClientID);
			
			//add by byhu 20050728 ��ʱ����parentOfDestroyedComp����������Ϊ��ǰ�����parent
			destoyedComp = CurCompSession.lookUp(sToDestroyClientID);
			if(destoyedComp!=null)
				parentOfDestroyedComp = destoyedComp.compParentComponent;
			
			//added by byhu 20050421 ͬʱ����session�е�dwʵ��
			CurCompSession.lookUpAndDestroy(sToDestroyClientID,session);
		}
		
		ASResultSet rs = null;
		String sSql = "";
		
		//add by zxu 20050509 
		ASValuePool definitions;
	    ASCompDefinition definition;
	    
	    definitions = ASConfigure.getSysConfig(ASConfigure.SYSCONFIG_COMP,SqlcaRepository);
	    Object oTmpDef = definitions.getAttribute(sComponentID.trim());
	    
	    //�����ȡ������ǰID��������壬˵�����ݿ���û�У���ע�ᵽ���ݿ��У�������LoadConfig
	    if(oTmpDef==null){
			//�ڿ���ģʽ���Զ�ע������
			if(sCurRunMode!=null && sCurRunMode.equals("Development")){
				//�Զ�ע������,
				if(sComponentURL==null) 
					throw new Exception("���ڵ�һ�ε������ʱ������URL����ʽ��ComponentURL=/Main.jsp");
				sSql = "insert into REG_COMP_DEF(CompID,OrderNo,InputTime,InputUser,InputOrg,UpdateUser,UpdateTime) values"+
								"('"+sComponentID+"','999999','"+sNow+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sNow+"')";
				try{
					SqlcaRepository.executeSQL(sSql);
					(ASConfigLoaderFactory.getInstance().createLoader(ASConfigure.SYSCONFIG_COMP)).loadConfig(SqlcaRepository);
					System.out.println("�Զ�ע�����:"+sComponentID);
				 }catch(Exception ex){
					System.out.println("�Զ�ע�����ʧ�ܣ�");
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
			//�����������
			if(sDBComponentName==null && sComponentName!=null){
				sSql = "update REG_COMP_DEF set CompName='"+sComponentName+"',UpdateUser='"+CurUser.UserID+"',UpdateTime='"+sNow+"' where CompID='"+sComponentID+"'";
				SqlcaRepository.executeSQL(sSql);
				SqlcaRepository.conn.commit();
			}
			//���������ַ
			if(sDBComponentURL==null && (sComponentURL!=null && !sComponentURL.equals(""))){
				sSql = "update REG_COMP_DEF set CompURL='"+sComponentURL+"',UpdateUser='"+CurUser.UserID+"',UpdateTime='"+sNow+"' where CompID='"+sComponentID+"'";
				SqlcaRepository.executeSQL(sSql);
				SqlcaRepository.conn.commit();
			}
			//�����������
			if(sDBComponentType==null && sComponentType!=null){
				sSql = "update REG_COMP_DEF set CompType='"+sComponentType+"',UpdateUser='"+CurUser.UserID+"',UpdateTime='"+sNow+"' where CompID='"+sComponentID+"'";
				SqlcaRepository.executeSQL(sSql);
				SqlcaRepository.conn.commit();
			}
			//�����������
			if(sOpenerClientID!=null && sOpenerFunctionName!=null){
				sSql = "update REG_FUNCTION_DEF set TargetComp = '"+sComponentID+"',UpdateUser='"+CurUser.UserID+"',UpdateTime='"+sNow+"' where FunctionID='"+sOpenerCompID+"'||'-'||'"+sOpenerFunctionName+"'";
				SqlcaRepository.executeSQL(sSql);
				SqlcaRepository.conn.commit();
			}
			//ע��Ȩ�޵�
			if(sRightID==null || sRightID.equals("")){
				sRightID = "���-"+sComponentID;
			
				sSql = "update REG_COMP_DEF set RightID = '"+sRightID+"',UpdateUser='"+CurUser.UserID+"',UpdateTime='"+sNow+"' where CompID='"+sComponentID+"'";
				try{
					SqlcaRepository.executeSQL(sSql);
					SqlcaRepository.conn.commit();
				}catch(Exception ex){
					System.out.print(ex.toString());
				}
				
				//ע��Ȩ�޵�
				sSql = 	" insert into RIGHT_INFO(RightID,RightName,RightStatus,InputTime,InputUser,InputOrg,UpdateUser,UpdateTime) "+
				" values('"+sRightID+"','"+sRightID+"','1','"+sNow+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sNow+"')";
		
				System.out.println("ע��Ȩ�޵㣺"+sRightID);
				try{
					SqlcaRepository.executeSQL(sSql);
					SqlcaRepository.conn.commit();
				}catch(Exception ex){
					System.out.print(ex.toString());
				}
			
				//��Ȩ��Ĭ�ϸ�����ͨ�û�(800)
				sSql = 	" insert into ROLE_RIGHT(RoleID,RightID,InputTime,InputUser,InputOrg,UpdateUser,UpdateTime) "+
				" values('800','"+sRightID+"','"+sNow+"','"+CurUser.UserID+"','"+CurOrg.OrgID+"','"+CurUser.UserID+"','"+sNow+"')";
				try{
					SqlcaRepository.executeSQL(sSql);
					SqlcaRepository.conn.commit();
				}catch(Exception ex){
					System.out.print(ex.toString());
				}
		
				CurUser.initUser(CurUser.UserID,SqlcaRepository);//���¼����û�Ȩ��
				((ASRoleDefinitionLoader)ASConfigLoaderFactory.getInstance().createLoader(ASConfigure.SYSCONFIG_ROLE)).loadConfig(SqlcaRepository);
				CurUser.initUser(CurUser.UserID,SqlcaRepository);//���¼����û�Ȩ��
				System.out.println("��Ȩ��Ĭ�ϸ�����ͨ�û�(800)��"+sRightID);
			}
		}
		
		//�жϵ�ǰ�û��Ƿ�ӵ�и������Ȩ��
		if(!CurUser.hasRight(sRightID)){
			throw new Exception("��û�з��ʸ������Ȩ�ޣ�<br>���Ȩ�޵㣺"+sRightID+"<br><a href=\"javascript:window.open('"+sWebRootPath+"/index.html','_top');\">����˴����µ�¼��</a>");
		}
/*****************Redirector.jsp��Ҫ���þ��ǲ���ClientID�ţ���ע�����ҳ��͹��ܵ㼰Ȩ�ޣ����͸������������*******************/		
		//������ǰ���ʵ�����洢�����parameter,����������Ự��ע��
		ASComponent CurComp = CurCompSession.creatComponent(sComponentID,sComponentName,CurUser,(HttpServletRequest)request);
		CurComp.setAttribute("iPostChange",String.valueOf(iPostChange));
		CurComp.appID = sAppID;
		
		ASComponent CurCompParent = null;
		if(sParentClientID!=null) CurCompParent = CurCompSession.lookUp(sParentClientID);
		if(CurCompParent!=null) 
			CurComp.compParentComponent = CurCompParent;
		else if(parentOfDestroyedComp!=null) 
			CurComp.compParentComponent = parentOfDestroyedComp;
		
		//��������URL���ҵ���URL����ͬ�����п��ܲ�ͬ��������ظ�������
		if(sDBComponentURL!=null && !sDBComponentURL.equals("") && sComponentURL!=null && !sComponentURL.equals("") && !sComponentURL.equals(sDBComponentURL)){
			if(sCurRunMode.equalsIgnoreCase("Production"))
				throw new Exception("ָ�������ID�Ѿ���ע���ˡ�\n�����ַ��ע���ַ��ͬ��\n���ID:["+sComponentID+"]\nע���ַ:["+sDBComponentURL+"]\n�����ַ:["+sComponentURL+"]");
%>
			<script>
				if(confirm("�����ַ��ע���ַ��ͬ��\n\nע���ַ:<%=sDBComponentURL%>]\n�����ַ:[<%=sComponentURL%>]\n\n������\n 1.ʹ������һ������ţ�������ID [<%=sComponentID%>] �Ѿ�����Ŀ�����Աע���ˣ�������\n 2.�������ע���ַ����������ע����Ϣ�еĵ�ַ���󣩡�\n\n���ڸ������ע����Ϣ�𣿵����ȷ�ϡ��༭���ע����Ϣ��"))
					window.showModalDialog("<%=sWebRootPath%>/Frame/OpenCompDialog.jsp?CompClientID=<%=CurComp.ClientID%>&ComponentID=UpdateCompInfo&ComponentURL=/Common/Configurator/CompManage/CompInfo.jsp&ParaString=CompID=<%=sComponentID%>&rand="+randomNumber(),"diaglogwidth:640px,diaglogheight:480px");
			</script>
			<%
		}
			//����SortNo
			if(sCurRunMode!=null && sCurRunMode.equals("Development") && (sDBComponentName==null || sOrderNo==null || sOrderNo.indexOf("99")==0)){
			%>
			<script language="javascript">
					if("<%=sComponentID%>"!="UpdateCompInfo" && "<%=sComponentID%>"!="SelectComp"){
						if(confirm("��� [<%=sComponentID%>] ��ע����Ϣ�����ơ�\n����: [<%=sDBComponentName%>]\n�����[<%=sOrderNo%>]\n\n���ڸ������ע����Ϣ��"))
							window.showModalDialog("<%=sWebRootPath%>/Frame/OpenCompDialog.jsp?CompClientID=<%=CurComp.ClientID%>&ComponentID=UpdateCompInfo&ComponentURL=/Common/Configurator/CompManage/CompInfo.jsp&ParaString=CompID=<%=sComponentID%>&rand="+randomNumber(),"diaglogwidth:640px,diaglogheight:480px");
					}
					</script>
			<%
				}

				//begin ����Ȩ����Ϣ---------------------------------------------------------
				//����鿴���������������Ȩ��
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
				//ȡ��Ϣ�޸�Ȩ�ޣ�����Ȩ�ޣ���Ϣ
				sSql = "select * from REG_FUNCTION_DEF where CompID='"+sComponentID+"'";
				rs = SqlcaRepository.getASResultSet(sSql);
				while(rs.next()){
					CurComp.setAttribute("RightTypeOf_"+rs.getString("FunctionID"),rs.getString("InfoRightType"));
				}
				rs.getStatement().close();
			    //over ---------------------------------------------------------

					//�ϵ����ݿ�����
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
						if(sCurRunMode.equalsIgnoreCase("Production")) throw new Exception("�������δ������ʵ�ַ!���ID:"+sComponentID);
			%>
						<script language=javascript>
						if(confirm("��� [<%=sComponentID%>] ��δ������ʵ�ַ��\n\n���ڸ������ע����Ϣ��"))
							window.showModalDialog("<%=sWebRootPath%>/Frame/OpenCompDialog.jsp?CompClientID=<%=CurComp.ClientID%>&ComponentID=UpdateCompInfo&ComponentURL=/Common/Configurator/CompManage/CompInfo.jsp&ParaString=CompID=<%=sComponentID%>&rand="+randomNumber(),"diaglogwidth:640px,diaglogheight:480px");
						</script>
			<%
						return;
					}
					//Ŀǰ�������������ַ��ʼ��ֻ��ʾMain.jsp,���Դ˴������Main.jspҲ���л������أ��ﵽȫ����ʵ��ַ�����ص�Ŀ��
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