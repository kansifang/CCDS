<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginDW.jsp"%>
<script language=javascript>
	var obj = window.dialogArguments;
</script>
<div align=center><br><br><font style="font-size:9pt;color:red">���ڴӷ�������ȡ��Ϣ...</font></div>
<%
	String sDWName = DataConvert.toRealString(iPostChange,(String)request.getParameter("dw"));
	String sRow = DataConvert.toRealString(iPostChange,(String)request.getParameter("row"));
	String sCond = " 1=1 ";

	if(sDWName!=null && !sDWName.equals(""))
	{
		ASDataWindow dwTemp = null;
		if(CurPage!=null)
			dwTemp = (ASDataWindow) CurPage.getAttribute(sSessionID);
		else
			dwTemp = (ASDataWindow) session.getAttribute(sSessionID);		

		dwTemp.Sqlca = Sqlca;

		java.util.Enumeration enuPara = request.getParameterNames();
		while(enuPara.hasMoreElements())
		{
			String sParameterName = (String) enuPara.nextElement();
			if(!sParameterName.equals("dw") && !sParameterName.equals("rand") && !sParameterName.equals("row")) //just col*
			{
				String sParameterValue = DataConvert.toRealString(iPostChange,(String)request.getParameter(sParameterName));
				sParameterValue = com.lmt.baseapp.util.SpecialTools.amarsoft2Real(sParameterValue);
				int iCol = Integer.valueOf(sParameterName.substring(3)).intValue();
				ASColumn acTemp = (ASColumn)dwTemp.DataObject.Columns.get(iCol);
				if(acTemp.getAttribute("Type").equals("Number"))
					sCond += " and " + acTemp.getDBName()+"="+sParameterValue;
				else
					sCond += " and " + acTemp.getDBName()+"='"+sParameterValue+"'";
			}
		}
		//System.out.println("...."+sCond);

		ASDataObject doTemp = new ASDataObject();
		doTemp.SourceSql = dwTemp.DataObject.SourceSql;
		doTemp.SelectClause = dwTemp.DataObject.SelectClause;
		doTemp.FromClause = dwTemp.DataObject.FromClause;
		doTemp.WhereClause = dwTemp.DataObject.WhereClause;
		doTemp.GroupClause = dwTemp.DataObject.GroupClause;
		doTemp.OrderClause = dwTemp.DataObject.OrderClause;
		doTemp.Arguments = dwTemp.DataObject.Arguments;
		doTemp.UpdateTable = dwTemp.DataObject.UpdateTable;
		doTemp.UpdateWhere = dwTemp.DataObject.UpdateWhere;
		doTemp.UpdateKeyInPlace = dwTemp.DataObject.UpdateKeyInPlace;
		doTemp.Updateable = dwTemp.DataObject.Updateable;
		doTemp.multiSelectionEnabled = dwTemp.DataObject.multiSelectionEnabled;
		doTemp.KeyFilter = dwTemp.DataObject.KeyFilter;
		doTemp.JoinClause = dwTemp.DataObject.JoinClause;
		doTemp.Columns = dwTemp.DataObject.Columns;
		doTemp.Filters = dwTemp.DataObject.Filters;

		if(doTemp.WhereClause.equals(""))
			sCond = " where " + sCond;
		else
			sCond = doTemp.WhereClause + " and " + sCond;

		doTemp.WhereClause = sCond;
		doTemp.KeyFilter = "";
		doTemp.composeSourceSql(Sqlca);


		ASDataWindow dwTempCurrRow = new ASDataWindow(doTemp,Sqlca,"DWCURR");
		dwTempCurrRow.sArgumentValue = dwTemp.sArgumentValue;		
			
		try 
		{	
			Vector vTemp = dwTempCurrRow.genHTMLDataWindow(dwTempCurrRow.sArgumentValue);
			String sTemp = "";
			boolean bBegin = false;
			for(int i=0;i<vTemp.size();i++) 
			{
				String sTemp2 = (String)vTemp.get(i);
				if(sTemp2.length()>=11 && sTemp2.substring(0,11).equals("DZ[i][2][0]"))
					bBegin = true;
				if(sTemp2.length()>=16 && sTemp2.substring(0,16).equals("i = DZ.length-1;"))
					break;
				
				if(bBegin) sTemp+=sTemp2;
			}
			out.println("<script language=javascript> obj = window.dialogArguments; i=obj.DZ.length;i=i-1;");
			out.println("obj.DZ[i][2]["+sRow+"]"+sTemp.substring(11));
			System.out.println("obj.DZ[i][2]["+sRow+"]"+sTemp.substring(11));
			out.println("</script>");
		}
		catch(Exception e)
		{		
			System.out.println(e.toString());
		}
		finally
		{

		}
		
	}
%>
<script language=javascript>
		self.close();
</script>
<%@ include file="/IncludeEnd.jsp"%>