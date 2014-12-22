<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	String sCompID  = DataConvert.toRealString(iPostChange,(String)request.getParameter("ComponentID"));
	String sComponentURL = DataConvert.toRealString(iPostChange,(String)request.getParameter("ComponentURL"));
	String sParaString = DataConvert.toRealString(iPostChange,(String)request.getParameter("ParaString"));
	String sShowSysArea = DataConvert.toRealString(iPostChange,(String)request.getParameter("ShowSysArea"));
	if(sCompID==null) sCompID="";
	if(sParaString!=null) sParaString = StringFunction.replace(sParaString,"~","&");
	if(sParaString!=null) sParaString = StringFunction.replace(sParaString,"$[and]","&");
	CurPage.setAttribute("PopWindowCompID",sCompID);
%>
<html>
<head> 
<!-- 葎阻匈中胆鉱,萩音勣評茅和中 TITLE 嶄議腎鯉 -->
<%
	//函狼由兆各
	String sImplementationName = CurConfig.getConfigure("ImplementationName");

%>
<title><%=sImplementationName%>
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　 　　　　　　　　　　　　　　　　　
</title>
</head>
<body class="pagebackground" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}" onBeforeUnload="onClose()">
<table width="100%" border='1' height="98%" cellspacing='0' align=center bordercolor='#999999' bordercolordark='#FFFFFF'>
	<tr <%if(sShowSysArea!=null && sShowSysArea.equals("false")) out.println("style={display:none}");%>> 
			<td height=1>
				<%@include file="/PopWindowSystemArea.jsp"%>
			</td>
	</tr>
	<tr id="TitleTR" style="display:none;height:20px;vertical-align: middle;">
		<td bgcolor="#CCCCCC" id="TitleTD">
		</td>
	</tr>                         	
	<form  name="buff" align=center>
	<tr> 
			<td id="selectPage">
				<iframe name="ObjectList" width=100% height=100% frameborder=0 =no src="<%=sWebRootPath%>/Blank.jsp"></iframe>
			</td>
	</tr>
	</form>
</table>

</body>
</html>
<script language=javascript>
	var sObjectInfo="";
	function closeAndReturn()
	{
		if(sObjectInfo==""){
			if(confirm(getHtmlMessage("44"))){
				sObjectInfo="_NONE_";
			}else{
				return;
			}
		}
        self.returnValue=sObjectInfo;
		self.close();
	}
    
    function cancleAndReturn()
	{
		sObjectInfo="_NONE_";
        self.returnValue=sObjectInfo;
		self.close();
	}
	<%
	if(sComponentURL!=null && !sComponentURL.equals("")){
		
        %>
		openComponentInMe();
		<%
	}
	%>
	
	function openComponentInMe(){
		OpenComp("<%=sCompID%>","<%=sComponentURL%>","<%=sParaString%>","ObjectList","");
	}

	function onClose(){
		if(checkFrameModified(self,10)) 
			event.returnValue=sUnloadMessage;		
		else
			self.showModalDialog("<%=sWebRootPath%>/Common/ToolsB/DestroyCompAction.jsp?ToDestroyClientID="+ObjectList.sCompClientID);
		
	}
	
	function checkFrameModified(oFrame,generations)
	{
		if(typeof(generations)=="number")
			iGenerations = generations-1;
		else
			iGenerations = 0;
		
		if(iGenerations<0) return true;
		
		try{
        if(oFrame.bEditHtml && oFrame.bEditHtmlChange )
                return true;
        }catch(e){}
        
		if(typeof(oFrame.isModified)!="undefined")
		{
			for(j=0;j<oFrame.frames.length;j++){ 	
					try{
						if(oFrame.bCheckBeforeUnload==false) continue;
						if(oFrame.isModified(oFrame.frames[j].name)) return true;
					}catch(e){
					}
			}
		}
		

		//殊臥和雫匈中議dw
		if(oFrame.frames.length==0) return false;
		for(var i=0;i<oFrame.frames.length;i++){
			if(checkFrameModified(oFrame.frames[i],iGenerations)) return true;
		}
		return false;
	}


</script>

<%@ include file="/IncludeEnd.jsp"%>
