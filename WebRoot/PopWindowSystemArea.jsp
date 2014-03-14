<% 
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: RCZhu 2003.7.18
 * Tester:
 *
 * Content: 主页面的Top的SystemArea 
 * Input Param:
 * Output param:
 *
 * History Log: 2003.07.18 RCZhu
 *              2003.08.10 XDHou
 */
%>
<%
String sPopWindowCompID = CurPage.getParameter("PopWindowCompID");
if(sPopWindowCompID==null || sPopWindowCompID.equals(""))
	sPopWindowCompID = CurComp.ID;

%>
<script language="JavaScript">
       
	function MM_swapImgRestore() 
	{ //v3.0
	    var i,x,a=document.MM_sr; 
		for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) 
			x.src=x.oSrc;
	}
	
	function MM_preloadImages() 
	{ //v3.0
	    var d=document; 
		if(d.images){ 
			if(!d.MM_p) 
				d.MM_p=new Array();
	    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; 
	    for(i=0; i<a.length; i++)
	   		if (a[i].indexOf("#")!=0){ 
	   			d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];
	   			}
	    }
	}
	
	function MM_findObj(n, d) 
	{ //v4.0
	    var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
	        d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
	    if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
	    for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
	    if(!x && document.getElementById) x=document.getElementById(n); return x;
	}
	
	function MM_swapImage() 
	{ //v3.0
	    var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
	    if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
	}
	
	function MM_reloadPage(init) 
	{  //reloads the window if Nav4 resized
	    if (init==true)
	    	with (navigator) {
	    		if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    	   	 		document.MM_pgW=innerWidth; 
    	   	 		document.MM_pgH=innerHeight; 
    	   	 		onresize=MM_reloadPage;
    	   	 		}
	    		}else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) 
	    			location.reload();
	}

	function refreshMe(){
		try{
			openComponentInMe();
		}catch(e){
		}
	}
    
    function ModifyPass()
    {
        self.open("<%=sWebRootPath%>/UserManage/ModifyPassword.jsp?rand="+randomNumber(),"PassWord","width=350,height=200,left=300,top=200");
    }
     
 	function exitPopWindow()
 	{
 		self.close();
	}

	function BoardList() {
			
		self.open("SystemManage/BoardManage/BoardList.jsp?rand="+randomNumber(),"boardList","width=600,height=400,left=100,top=100,scrollbars=yes"); 
	}
	
	MM_reloadPage(true);

	var LastRetrievedCompID = "<%=CurComp.ID%>";
	function ShowLastRetrievedCompHelp()
 	{ 					
        	ShowCompHelp(LastRetrievedCompID);
	}
	      
</script> 
   
<table border="0" cellspacing="0" cellpadding="0">  
<tr>
  <td nowrap> &nbsp;&nbsp;

    <script> drawImgButton("icon_refresh","Refresh 刷新","refreshMe()","<%=sResourcesPath%>"); </script>
    <script> drawImgButton("icon_close","Sign Out 退出","exitPopWindow()","<%=sResourcesPath%>"); </script>
  </td>
  <td nowrap>
  <%
  	//取系统名称
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
    		
    		sSysAreaCompNameSql = "select * from REG_COMP_DEF where CompID = '"+sPopWindowCompID+"'";
    		rsSysAreaCompName = SqlcaRepository.getASResultSet(sSysAreaCompNameSql);
    		if(rsSysAreaCompName.next()) sSortNo = rsSysAreaCompName.getString("OrderNo");
    		rsSysAreaCompName.getStatement().close();
    		
			sSysAreaCompNameSql = "select CompID,CompName from REG_COMP_DEF where  OrderNo like  '"+sSortNo+"%' and OrderNo is not null and OrderNo not like '99%' and (OrderNo = '"+sSortNo+"'  or ( length(OrderNo)= length('"+sSortNo+"') +4 ) )  order by OrderNo ";
			//帮助
    		//sSysAreaCompNameSql = "select * from REG_COMP_DEF where '"+sSortNo+"' like OrderNo||'%' and OrderNo is not null and OrderNo not like '99%' order by OrderNo ";
    		rsSysAreaCompName = SqlcaRepository.getASResultSet(sSysAreaCompNameSql);
    		while(rsSysAreaCompName.next()){
    			sSysAreaCompName = rsSysAreaCompName.getString("CompName");
    			if(sSysAreaCompName==null || sSysAreaCompName.equals("")) sSysAreaCompName="未命名";
    			sSysAreaCompNameString += " - <a href=\"#\" onClick=\"javascript:ShowCompHelp('"+rsSysAreaCompName.getString("CompID")+"')\" ><span class=pageversion>" + sSysAreaCompName + "</span></a>";
    			iCountSysAreaCompName++;
    			if(iCountSysAreaCompName>5) break;
    		}
    		rsSysAreaCompName.getStatement().close();
    		out.println(sSysAreaCompNameString);
    	}
		*/
    	%>
    
    
    </span>
  </td>
</tr>
</table>