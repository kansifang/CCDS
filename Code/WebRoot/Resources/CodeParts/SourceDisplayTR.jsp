
<%
if(sCurRunMode!=null && sCurRunMode.equals("Development")){
%>
	<tr>
	    <td id="ListBottomArea" class="ListBottomArea">
		<span class="pageversion" ondblclick='javascript:openControlCenter()'>CTRLCT</span>
		<span class="pageversion" ondblclick='javascript:displayIframeHTML()'>DWSRC</span>
		<!--a href="#" onclick=location.replace("view-source:"+location)>源码</a-->
		<span class="pageversion" ondblclick='javascript:displayBodyHTML()'>PGSRC</span>
		<span class="pageversion" ondblclick='javascript:displayURL()'>URL</span>
		<span class="pageversion" ondblclick='javascript:displayURLnPara()'>REQ</span>
		<span class="pageversion" ondblclick='javascript:viewCompStructure()'>COMPSESSION</span>
		<span class="pageversion" ondblclick='javascript:viewCompDetail()'>COMP</span>
		<span class="pageversion" ondblclick='javascript:viewPageDetail()'>PAGE</span>
		<span class="pageversion" ondblclick='javascript:editCompReg()'>COMPREG</span>
	    </td>
	</tr>
<script language=javascript>	
	function openControlCenter(oBody){
		popComp("ControlCenter","/Common/Configurator/ControlCenter/ControlCenter.jsp","","","");
	}
	function displayHTML(oBody){
		showModalDialog("<%=sWebRootPath%>/Frame/Debug/testDialog.htm", oBody,"status:no;resizable:yes;center:yes;dialogHeight:688px;dialogWidth:968px;");
	}
	function displayIframeHTML(){
		try{
			displayHTML(myiframe0.document.body);
		}catch(e){
			alert("本页面没有DW");
		}
	}
	function displayBodyHTML(){
		displayHTML(document.body);
	}
	function displayURL(){
		prompt("当前的URL","<%=request.getServletPath()%>");
	}
	function displayURLnPara(){
		prompt("当前的URL及参数",document.URL);
	}
	function viewCompStructure(){
		popComp("CompStructure","/Common/Configurator/ControlCenter/CompStructure.jsp","","","");
	}
	function viewCompDetail(){
		popComp("CompDetail","/Common/Configurator/ControlCenter/CompDetail.jsp","ToShowClientID=<%=sCompClientID%>","","");
	}
	function viewPageDetail(){
		popComp("PageDetail","/Common/Configurator/ControlCenter/PageDetail.jsp","ToShowCompClientID=<%=sCompClientID%>&ToShowPageClientID=<%=sPageClientID%>","","");
	}
	function editCompReg(){
		popComp("CompView","/Common/Configurator/CompManage/CompView.jsp","ObjectNo=<%=CurComp.ID%>","","");
	}
	
	</script>	
<%
}
%>
