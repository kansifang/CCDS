<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginDW.jsp"%>
<script language=javascript>
	var obj = window.dialogArguments;
</script>
<div align=center><br><br><font style="font-size:9pt;color:red">正在从服务器获取信息...</font></div>
<%
	String sDWName = DataConvert.toRealString(iPostChange,(String)request.getParameter("dw"));
	String sCurPage = DataConvert.toRealString(iPostChange,(String)request.getParameter("pg"));
	String sSortField = DataConvert.toRealString(iPostChange,(String)request.getParameter("sortfield"));
	String sSortOrder = DataConvert.toRealString(iPostChange,(String)request.getParameter("sortorder")); //0升1降
	//必须去掉
	//if(sSortOrder.equals("1")) 
	//	sSortField = sSortField + " desc ";

	int iCurPage = 0;
	
	if(sCurPage!=null && !sCurPage.equals("")&&!sSortField.equals("*"))
		iCurPage = Integer.valueOf(sCurPage).intValue();
	
	if(sDWName!=null && !sDWName.equals("")&&!sSortField.equals("*"))
	{
		//modify by hxd in 2005/06/06
		//ASDataWindow dwTemp = (ASDataWindow) session.getAttribute(sDWName);
		ASDataWindow dwTemp = null;
		if(CurPage!=null)
			dwTemp = (ASDataWindow) CurPage.getAttribute(sSessionID);
		else
			dwTemp = (ASDataWindow) session.getAttribute(sSessionID);		
		

		dwTemp.Sqlca = Sqlca;
		dwTemp.iCurPage = iCurPage;
		dwTemp.setSortField(sSortField,sSortOrder);//dwTemp.sSortField = sSortField;
				
		Vector vTemp = dwTemp.genHTMLDataWindow("");
		for(int i=0;i<vTemp.size();i++) 
			out.print(StringFunction.replace((String)vTemp.get(i),"DZ","obj.DZ"));
	}
%>
<script language=javascript>
		self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>