<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: 主页面
		Input Param:
			          
		Output param:
			      
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
String sToShowClientID = DataConvert.toRealString(iPostChange,CurPage.getParameter("ToShowClientID"));
ASComponent compToShow = CurCompSession.lookUp(sToShowClientID);
if(compToShow==null) throw new Exception("该组件已被销毁或客户端号错误，无法在CurCompSession中找到。组件客户端号："+sToShowClientID);
%>

<html>
<head>
<title></title> 
</head>
<body class="ListPage" leftmargin="0" topmargin="0" >
<div style="position:absolute;width:100%;height:100%;overflow:auto;">
<table width="100%" border="1" cellspacing="0" cellpadding="4" bodercolorlight="#666666" bodercolordark="#FFFFFF">
  <tr bgcolor="#000066"> 
    <td colspan="2" ><strong><font color="#FFFFFF">组件实例属性</font></strong></td>
  </tr>

  <ul>

  <tr bgcolor="#C8D2DF"> 
    <td>
    <li>名称(Name)</li>
    </td>
    <td><%=compToShow.Name%></td>
  </tr>
  <tr bgcolor="#C8D2DF"> 
    <td>
    <li>地址(CompURL)</li>
    </td>
    <td ><%=compToShow.CompURL%></td>
  </tr>
  <tr bgcolor="#C8D2DF"> 
    <td>
    <li>所属APP</li>
    </td>
    <td><%=compToShow.appID%></td>
  </tr>




  <tr bgcolor="#000066"> 
    <td colspan="2" ><strong><font color="#FFFFFF">下属页面</font></strong></td>
  </tr>

  <ul>
<%
for(int i=0;i<compToShow.pages.size();i++){
%>

  <tr bgcolor="#C8D2DF"> 
    <td>
    <li><%
    out.println(((ASPage)compToShow.pages.get(i)).Name);    
    %></li>
    </td>
    <td>
    <%
    ASPage tmpPage = (ASPage)compToShow.pages.get(i);
    if(tmpPage==null){
    	out.println("没有找到ASPage实例");
    }else{
    	out.println("<a href=\"javascript:viewPageDetail("+tmpPage.ClientID+")\">"+tmpPage.PageURL+"</a>");
    }
    %>
    </td>
  </tr>

<%
}
%>


  </ul>
  



  <tr bgcolor="#000066"> 
    <td colspan="2" ><strong><font color="#FFFFFF">组件参数池</font></strong></td>
  </tr>

  <ul>
<%
for(int i=0;i<compToShow.parameterList.size();i++){
%>

  <tr bgcolor="#C8D2DF"> 
    <td>
    <li><%
    out.println(((ASParameter)compToShow.parameterList.get(i)).paraName);
    Object oTmp=null;
    String sObjType=null;
    oTmp = ((ASParameter)compToShow.parameterList.get(i)).paraValue;
    if(oTmp!=null)
    {
    	sObjType = oTmp.getClass().getName();
    	out.println("["+sObjType+"]");
    }
    
    %></li>
    </td>
    <td><textarea style="width:100%;height:100%"><%
    try{
    	if(sObjType==null){
    		out.print("null");
    	}else if(sObjType.equals("java.lang.String")){
	    	out.print(StringFunction.replace(DataConvert.toRealString(iPostChange,oTmp.toString()),"<","&#60;"));
	    }else if(sObjType.equals("com.amarsoft.web.dw.ASDataWindow")){
	    	out.print(((com.amarsoft.web.dw.ASDataWindow)oTmp).Name);
	    }else{
	    	out.print("[toString]: "+oTmp.toString());
	    }
    }catch(Exception ex){
    	out.print(ex.toString());
    }
    %></textarea>
    </td>
  </tr>

<%
}
%>


  </ul>
  

</table>

</div>
</body>
</html>
<script language="javascript">
	function viewPageDetail(sPara){
		popComp("PageDetail","/Common/Configurator/ControlCenter/PageDetail.jsp","ToShowCompClientID=<%=sToShowClientID%>&ToShowPageClientID="+sPara,"","");
	}

</script>
<%@ include file="/IncludeEnd.jsp"%>