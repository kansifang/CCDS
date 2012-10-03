<%@include file="/Resources/Include/IncludeHead1.jsp"%>
<object ID="AsOne" style="display:none" WIDTH=0 HEIGHT=0 <%=sCABDesc%> ></object>
<script language=javascript>
    AsOne.SetDefault("<%=(String)CurARC.getAttribute("DefaultHtml")%>");
</script> 