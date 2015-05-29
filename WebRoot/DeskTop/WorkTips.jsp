<%@ page import="com.lmt.baseapp.util.StringFunction" %>
<%@ page import = "com.lmt.frameapp.config.dal.ASCodeDefinition"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/
%>
	<%
		/*
			Author:   
			Tester:
			Content: 我的工作台
			Input Param:
		          
			Output param:
		      
			History Log: 
		 */
	%>
<%
	/*~END~*/
%>
<%
	//从内存中取出代码缓冲池（不使用SQL去查询，提高页面效率）
	//ASValuePool vpCode = CurConfig.getSysConfig(ASConfigure.SYSCONFIG_CODE,Sqlca);
	//取出代码对象
	//ASCodeDefinition codeDef = (ASCodeDefinition)vpCode.getAttribute("WorkTips");
	//int taskNum = codeDef.items.size();
%>

<html>
<head>
<title>日常工作提示</title>
<link rel="stylesheet" href="Style.css">
</head>
<body class="pagebackground" leftmargin="0" topmargin="0" id="mybody" 
onload="
	<%
		String sSql="select ItemNo,ItemName,ItemDescribe,ItemAttribute "+
				" from Code_Library"+
				" where CodeNo='WorkTips' "+
				" and IsInuse='1'"+
				" and (nvl(ItemAttribute,'')='' "+
					" or exists(select 1 from User_Role UR"+ 
							" where UR.UserID='"+CurUser.UserID+"' and locate(UR.RoleID,ItemAttribute)>0))";
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		while(rs.next()){
			String ItemNo=	rs.getString("ItemNo");	
			String HandJsp=	rs.getString("ItemDescribe");	
	%>
		HandleWork('<%=ItemNo%>','<%=HandJsp%>',0);
	<%
		}
	%>
	">
<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
 <tr valign="top">
    <td>
      <div id="Layer1" style="position:absolute;width:100%; height:100%; z-index:1; overflow: auto">
        <table align='center' cellspacing=0 cellpadding=0 border=0 width=95% height="95%">
          <tr>
            <td align='center' valign='top'>
              <table border=0 width='100%' height='100%'>
                <tr>
                  <td valign='top'>
                    <table width="100%" border="0" cellspacing="0" cellpadding="4">
                      <tr>
                      <!-- 
                        <td width="20%" valign="top" align="center">
                          <p><br>
                          <%
                          	String sPic = StringFunction.getNow().substring(7);
                          	sPic+=".wgif";
                          %>
                          <img src="<%=sResourcesPath%>/DailyPics/<%=sPic%>">
                          </p>
                          <p><a href="javascript:self.location.reload();">刷新</a></p>  
                        </td>
                         -->
                        <td valign="top">
                          <table align='left' border="0" cellspacing="0" cellpadding="0" bordercolordark="#FFFFFF" width="100%" >
							<!-------------------循环输出日常工作提示------------------------------------------------->
							 <%
							 rs.beforeFirst();
							 while(rs.next()){
								 	String ItemNo=rs.getString("ItemNo");	
								 	String Title=rs.getString("ItemName");	
									String HandJsp=rs.getString("ItemDescribe");	
							 %>
								 <tr hight="1">
	                                <td align="left" colspan="2"  background="<%=sResourcesPath%>/workTipLine.gif" >
			                          <table border="0" cellspacing="0" cellpadding="0">
										<tr>
											<td onclick="HandleWork('<%=ItemNo%>','<%=HandJsp%>',1);">
												<img style="display: "  class="FilterIcon" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="Plus<%=ItemNo%>" >
												<img style="display:none " class="FilterIcon2" src=<%=sResourcesPath%>/1x1.gif width="1" height="1" id="Minus<%=ItemNo%>" >
											</td>
											<td onclick="HandleWork('<%=ItemNo%>','<%=HandJsp%>',1);">
												<b>
													<a href="#" ><%=Title%>&nbsp;<span id="CountID<%=ItemNo%>" ></span>&nbsp;件</a>
												</b>&nbsp;&nbsp;&nbsp;&nbsp;
									    	</td>
								    	</tr>
								    	</table>
		                           </td>
	                           </tr>
								<tr>
									<td align="left" colspan="2" id="InfoID<%=ItemNo%>"></td>
								</tr>
		                        <tr>
		                        	<td align="left" colspan="2">&nbsp; </td>
		                        </tr>
			                 <%
			                 	}
							 	rs.getStatement().close();
			                 %>
                          </table>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </div>
    </td>
  </tr>
</table>
</body>
</html>
<script   type="text/javascript">
	//ajax公用函数
	function getXmlHttpObject(){
		var xmlHttp = null;
		try {
			// Firefox, Opera 8.0+, Safari
			xmlHttp = new XMLHttpRequest();
		} catch (e) {
			// Internet Explorer
			try {
				xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
			} catch (e) {
				xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			};
		}
		return xmlHttp;
	}
	//Flag 0 计算任务数 1获取明细
	function HandleWork(ItemNo,HandJsp,Flag){
		var message = "";
		var xmlHttp=getXmlHttpObject();
		if (xmlHttp==null){
			  alert ("Your browser does not support AJAX!");
			  return;
		}
		var url="<%=sWebRootPath%>/DeskTop/WorkTipsAJAX/"+HandJsp+".jsp?CompClientID=<%=sCompClientID%>";
		if(Flag==0){
			url=url+"&Flag=0";
			xmlHttp.onreadystatechange = function CountPlanAction(){
				if (xmlHttp.readyState == 4) {
					message = xmlHttp.responseText;
					message="<font color=red>"+message+"</font>";
				}else{
					message = "<img border=0 src='<%=sResourcesPath%>/35.gif'>";
				}
				document.getElementById("CountID"+ItemNo).innerHTML = message;
			};
			xmlHttp.open("GET", url, true);
			xmlHttp.send(null);
		}
		if(Flag==1){
			if(document.all("InfoID"+ItemNo).innerHTML == ""){
				url=url+"&Flag=1";
				xmlHttp.onreadystatechange =function MyPlan(){
					if (xmlHttp.readyState == 4) {
						message = xmlHttp.responseText;
					}else{
						message = "<img border=0 src='<%=sResourcesPath%>/33.gif'>";
					}
					document.all("InfoID"+ItemNo).innerHTML = message;
				};
				xmlHttp.open("GET", url, true);
				xmlHttp.send(null);
				document.getElementById("Plus"+ItemNo).style.display = "none";
				document.getElementById("Minus"+ItemNo).style.display = "";
			}else{
				document.all("InfoID"+ItemNo).innerHTML="";
				document.getElementById("Plus"+ItemNo).style.display = "";
				document.getElementById("Minus"+ItemNo).style.display = "none";
			}
		}
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>