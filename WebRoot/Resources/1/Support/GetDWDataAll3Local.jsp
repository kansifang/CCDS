<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginDW.jsp"%>
<%
	String sDWName = DataConvert.toRealString(iPostChange,(String)request.getParameter("dw"));
	String sType = DataConvert.toRealString(iPostChange,(String)request.getParameter("type"));
	if(sType==null || sType.equals("") || sType.equals("null")) sType = "export";

	Vector vTemp = null;
	int i = 0;
	if(sDWName!=null && !sDWName.equals(""))
	{
		//modify by hxd in 2005/06/06
		//ASDataWindow dwTemp = (ASDataWindow) session.getAttribute(sDWName);
		ASDataWindow dwTemp = null;
		if(CurPage!=null)
			dwTemp = (ASDataWindow) CurPage.getAttribute(sSessionID);
		else
			dwTemp = (ASDataWindow) session.getAttribute(sSessionID);	

		dwTemp.Sqlca = Sqlca;

		vTemp = dwTemp.genHTMLAll("",999999);
	}
%>
<body>
<iframe name="myiframe0" style="display:none" width=100% height=100% frameborder=0></iframe>
</body>
<script language=javascript>
	var sFileName = "c:\\xddata\\tmp"+f_myDate()+".xls";

<%
	
	if(sType.equals("print"))
	{
%>		   
	try{
		var fs = new ActiveXObject("Scripting.FileSystemObject");
		
		try	{	var b = fs.CreateFolder("c:\\xddata");	b.close();
		} catch(e)  {	}

		var a = fs.CreateTextFile(sFileName, true); 						
		<%
		for(i=0;i<vTemp.size();i++) 
		{
		%>
			a.WriteLine("<%=(String)vTemp.get(i)%>");
		<%
		}
		%>
		a.Close();		

		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.open(sFileName);			
		xlApp.Application.Visible = true;
		xlApp.windows(1).visible = true;
		xlBook.Sheets(1).PrintPreview();
		xlBook.Close();			
		
	} 
	catch(e)  
	{
		alert(e.name+" "+e.number+" :"+e.message); 
	}
<%
	}
	else
	{
%>
	
	try{
		var sFileName0 = "";	
		if ( (sFileName0=prompt("请输入文件名称(需要包含路径名,例如)"+sFileName+":", sFileName)) ) 
		{ 
			var fs = new ActiveXObject("Scripting.FileSystemObject");

			try	{	var b = fs.CreateFolder("c:\\xddata");	b.close();
			} catch(e)  {	}
		
			var a = fs.CreateTextFile(sFileName0, true); 						
			<%
			for(i=0;i<vTemp.size();i++) 
			{
			%>
				a.WriteLine("<%=(String)vTemp.get(i)%>");
			<%
			}
			%>
			a.Close();
			alert("保存成功！文件名为："+sFileName0+"."); 		
		} 
		else	
			alert("您没有输入正确的文件名！"); 

	} 
	catch(e)  
	{
		alert(e.name+" "+e.number+" :"+e.message); 
	}
<%
	}
%>	
		
	top.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>