<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   
		Tester:
		Content: ��ҳ��
		Input Param:
			          
		Output param:
			      
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
String sToShowClientID = DataConvert.toRealString(iPostChange,CurPage.getParameter("ToShowClientID"));
ASComponent compToShow = CurCompSession.lookUp(sToShowClientID);
if(compToShow==null) throw new Exception("������ѱ����ٻ�ͻ��˺Ŵ����޷���CurCompSession���ҵ�������ͻ��˺ţ�"+sToShowClientID);
%>

<html>
<head>
<title></title> 
</head>
<body class="ListPage" leftmargin="0" topmargin="0" >
<div style="position:absolute;width:100%;height:100%;overflow:auto;">
<table width="100%" border="1" cellspacing="0" cellpadding="4" bodercolorlight="#666666" bodercolordark="#FFFFFF">
  <tr bgcolor="#000066"> 
    <td colspan="2" ><strong><font color="#FFFFFF">���ʵ������</font></strong></td>
  </tr>

  <ul>

  <tr bgcolor="#C8D2DF"> 
    <td>
    <li>����(Name)</li>
    </td>
    <td><%=compToShow.Name%></td>
  </tr>
  <tr bgcolor="#C8D2DF"> 
    <td>
    <li>��ַ(CompURL)</li>
    </td>
    <td ><%=compToShow.CompURL%></td>
  </tr>
  <tr bgcolor="#C8D2DF"> 
    <td>
    <li>����APP</li>
    </td>
    <td><%=compToShow.appID%></td>
  </tr>




  <tr bgcolor="#000066"> 
    <td colspan="2" ><strong><font color="#FFFFFF">����ҳ��</font></strong></td>
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
    	out.println("û���ҵ�ASPageʵ��");
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
    <td colspan="2" ><strong><font color="#FFFFFF">���������</font></strong></td>
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