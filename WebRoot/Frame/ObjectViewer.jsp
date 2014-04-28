<%@ page import="com.lmt.app.object.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//获取页面参数：对象类型、对象编号、视图编号
	String sObjectType  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ViewID"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sViewID == null) sViewID = "";
	
	//定义变量
	String sRightType = "",sObjectTypeName = "",sOjbectTypeURL = "",sViewToOpen = "",sViews = "";
	
	IBizObject bo = BizObjectFactory.getInstance().createBizObject(Sqlca,sObjectType,sObjectNo);
	sRightType = bo.getRightType(Sqlca,CurUser.UserID,sViewID);
	
	if(sRightType == null) sRightType="None";
	sViews = (String)bo.getType().getAttribute("ViewType");
	
	if (sViewID.equals("") || sViewID.equalsIgnoreCase("null"))
		sViewToOpen = (String)bo.getType().getAttribute("DefaultView");
	else
		sViewToOpen = sViewID;
		
	sObjectTypeName = bo.getType().name;
	sOjbectTypeURL = (String)bo.getType().getAttribute("PagePath");
	
	//向Component中存储参数
	CurComp.setAttribute("CompObjectType",sObjectType);
	CurComp.setAttribute("CompObjectNo",sObjectNo);
	CurComp.setAttribute("RightType",sRightType);
%>

<html>
<head>

<title><%=sObjectTypeName%>-<%=bo.name()%>-详情<%=(sRightType.equalsIgnoreCase("ReadOnly")?"-只读":(sRightType.equalsIgnoreCase("all")?"-可修改":"-无权限"))%></title>
<script language="JavaScript">
	setDialogTitle("<%=sObjectTypeName%>-<%=bo.name()%>-详情<%=(sRightType.equalsIgnoreCase("ReadOnly")?"-只读":(sRightType.equalsIgnoreCase("all")?"-可修改":"-无权限"))%>");
</script>
</head> 

<body leftmargin="0" topmargin="0" class="pagebackground" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}">
   <table align='center' cellspacing=0 cellpadding=0 border=0 width=100% height="100%">
      <tr>
           <td>
                <%
                	if (sRightType!=null && sRightType.equalsIgnoreCase("None")){
                %>
                	对不起，您没有查看[<%=bo.name()%>]视图["+sViewToOpen+"]的权限.
                <%
                	}else{
                %>
					<iframe name="DeskTopInfo" src="<%=sWebRootPath%>/Blank.jsp?TextToShow = 正在打开页面,请稍候..." width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"></iframe>
			    <%
			    	}
			    %>
			</td>
      </tr>                         
   </table>
</body>
</html>


<script language=javascript>

	<%if (sRightType!=null && sRightType.equalsIgnoreCase("None")){%>
		alert("对不起，您没有查看对象["+bo.name()+"]视图["+sViewToOpen+"]的权限.");
	<%}else{%>
		OpenComp("<%=sViews%>","<%=sOjbectTypeURL%>","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ViewID=<%=sViewToOpen%>&ToInheritObj=y","DeskTopInfo","");
	<%}%>
	
</script>
<%
	
%>
<%@ include file="/IncludeEnd.jsp"%>
