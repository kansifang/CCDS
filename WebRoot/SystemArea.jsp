<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: RCZhu 2003.7.18
 * Tester:
 *
 * Content: ��ҳ���Top��SystemArea
 * Input Param:
 * Output param:
 *
 * History Log: 2003.07.18 RCZhu
 *              2003.08.10 XDHou
 */
%>

<script language="JavaScript">

	function MM_swapImgRestore()
	{
	    var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
	}

	function MM_preloadImages()
	{
	    var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
	    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
	    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}

	}

	function MM_findObj(n, d)
	{
	    var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	    if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	    for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	    if(!x && document.getElementById) x=document.getElementById(n); return x;
	}

	function MM_swapImage()
	{
	    var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	    if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}

	function MM_reloadPage(init)
	{
	    if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    	    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  	    else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
	}

    function Role()
    {
        self.open("<%=sWebRootPath%>/UserManage/QueryUserRole.jsp?rand="+randomNumber(),"","width=510,height=300,top=150,left=350,toolbar=no,scrollbars=no,resizable=no,status=no,menubar=no");
    }

    function ModifyPass()
    {
        sReturn=PopPage("/DeskTop/ModifyPassword.jsp","","dialogWidth=24;dialogHeight=17;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
		if (typeof(sReturn)=="undefined" || sReturn.length==0)
			return;
		if (sReturn=="SUCCESS")
 			self.open("<%=sWebRootPath%>/SessionOut.jsp?rand="+randomNumber(),"_top","");
    }

 	function sessionOut()
 	{
 		if(confirm("ȷ���˳���ϵͳ��"))
 			OpenComp("SignOut","/SignOut.jsp","","_top","");
	}

	function BoardList() {

		self.open("SystemManage/BoardManage/BoardList.jsp?rand="+randomNumber(),"boardList","width=600,height=400,left=100,top=100,scrollbars=yes");
	}

	function showOnlineUserList()
	{
		OpenPage("/Common/Configurator/ControlCenter/UserList.jsp?rand="+randomNumber());
	}

	MM_reloadPage(true);
 	function goHome()
 	{
		OpenComp("Main","/Main.jsp","ToDestroyAllComponent=Y","_top","");
	}

	var LastRetrievedCompID = "<%=CurComp.ID%>";
	function ShowLastRetrievedCompHelp()
 	{
        	ShowCompHelp(LastRetrievedCompID);
	}
	function versionInfo()
    {
        PopPage("/DeskTop/VersionInfo.jsp","","dialogWidth=24;dialogHeight=17;resizable=no;scrollbars=no;status:yes;maximize:no;help:no;");
    }
</script>

<table border="0" cellspacing="0" cellpadding="0">
<tr>
  <td nowrap>&nbsp;&nbsp;&nbsp;&nbsp;<img class=appversion src=<%=sResourcesPath%>/1x1.gif width="1" height="1">
  <td nowrap> &nbsp;&nbsp;
    <script> drawImgButton("icon_home","Home ��ҳ","goHome()","<%=sResourcesPath%>"); </script>
    <script> drawImgButton("icon_key","Modify Password �޸�����","ModifyPass()","<%=sResourcesPath%>"); </script>
    <script> drawImgButton("icon_help","Help ����","ShowLastRetrievedCompHelp()","<%=sResourcesPath%>"); </script>
    <script> drawImgButton("icon_version","Version Info �汾˵��","versionInfo()","<%=sResourcesPath%>"); </script>    
    <script> drawImgButton("icon_signout","Sign Out �˳�","sessionOut()","<%=sResourcesPath%>"); </script>
  </td>
  </td>
  <td nowrap>
  <%
  	//ȡϵͳ����
	String sImplementationID = CurConfig.getConfigure("ImplementationID");
	String sImplementationVersion = CurConfig.getConfigure("ImplementationVersion");

  %>
    <span class="pageversion" >&nbsp;&nbsp;|&nbsp;&nbsp;<%=sImplementationID+" "+sImplementationVersion%> &nbsp;&nbsp;</span>
  </td>
  <td nowrap>
    <span class="pageversion" >
    	<%
/*
		if(CurComp!=null)
    	{
    		String sSortNo="";
    		String sSysAreaCompNameSql ="";
    		ASResultSet rsSysAreaCompName;
    		String sSysAreaCompName="",sSysAreaCompNameString="";
    		int iCountSysAreaCompName=0;

			ASValuePool definitions;
			com.amarsoft.config.definition.ASCompDefinition definition;

			definitions = ASConfigure.getSysConfig(ASConfigure.SYSCONFIG_COMP,SqlcaRepository);

			Object oTmpDef = definitions.getAttribute(CurComp.ID);

			if(oTmpDef!=null){
				definition = (com.amarsoft.config.definition.ASCompDefinition)oTmpDef;

				sSysAreaCompNameString = (String)definition.getAttribute("SysAreaCompNameString");

				if(sSysAreaCompNameString == null){
					sSysAreaCompNameString = "";
					sSysAreaCompNameSql = "select OrderNo from REG_COMP_DEF where CompID = '"+CurComp.ID+"'";
					rsSysAreaCompName = SqlcaRepository.getASResultSet(sSysAreaCompNameSql);
					if(rsSysAreaCompName.next()) sSortNo = rsSysAreaCompName.getString("OrderNo");
					rsSysAreaCompName.getStatement().close();

					sSysAreaCompNameSql = "select CompID,CompName from REG_COMP_DEF "+
						" where  OrderNo is not null and OrderNo not like '99%' "+
						" and SUBSTRING('"+sSortNo+"' from 1 for length(OrderNo))=OrderNo "+
						" and Length(OrderNo)>length('"+sSortNo+"')"+
						//"(OrderNo = '"+sSortNo+"'  or ( length(OrderNo)= length('"+sSortNo+"') +4 ) )  "+
						" order by OrderNo ";
					rsSysAreaCompName = SqlcaRepository.getASResultSet(sSysAreaCompNameSql);
					while(rsSysAreaCompName.next()){
						sSysAreaCompName = rsSysAreaCompName.getString("CompName");
						if(sSysAreaCompName==null || sSysAreaCompName.equals("")) sSysAreaCompName="δ����";
						sSysAreaCompNameString += " - <a href=\"javascript:ShowCompHelp('"+rsSysAreaCompName.getString("CompID")+"')\" ><span class=pageversion>" + sSysAreaCompName + "</span></a>";
						iCountSysAreaCompName++;
						if(iCountSysAreaCompName>5) break;
					}
					rsSysAreaCompName.getStatement().close();
					definition.setAttribute("SysAreaCompNameString",sSysAreaCompNameString);
				}
				out.println(sSysAreaCompNameString);
			}
    	}
  */
		%>
    </span>
  </td>
</tr>
</table>