
<table width=100% height=100% cellspacing="0" cellpadding="0" border="0">

		<%
		String[][] sButtons1stLine = (String[][])CurPage.getAttribute("Buttons1");
		String sLineMaxButtons = (String)CurPage.getAttribute("ButtonsLineMax");
		if(sLineMaxButtons==null){
			String sScreenWidth = (String)CurARC.getAttribute("ScreenWidth");
			if(sScreenWidth==null || sScreenWidth.equals("") || Integer.parseInt(sScreenWidth)<=800){
				sLineMaxButtons = "6";
			}else{
				sLineMaxButtons = "9"; 
			}
		}
		int iButtonsCount = 1;
		if(sButtons1stLine!=null)
		{
			out.println("<tr>");
			out.println("<td class=\"buttonback\" valign=top>");
			out.println("<table>");
			out.println("<tr>");
			for(int iBT=0;iBT<sButtons1stLine.length;iBT++)
			{
				if(sButtons1stLine[iBT][0]==null || !sButtons1stLine[iBT][0].equals("true")) continue;
				
				if(iButtonsCount>Integer.parseInt(sLineMaxButtons))
				{
					out.println("</tr>");
					out.println("</table>");
					out.println("</td>");
					out.println("</tr>");
					out.println("<tr>");
					out.println("<td class=\"buttonback\" valign=top>");
					out.println("<table>");
					out.println("<tr>");
					iButtonsCount = 1;
				}
				iButtonsCount++;
				%>
					<td class="buttontd"><%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,sButtons1stLine[iBT][1],sButtons1stLine[iBT][2],sButtons1stLine[iBT][3],sButtons1stLine[iBT][4],sButtons1stLine[iBT][5],sResourcesPath)%></td>
				<%
			}
				out.println("</tr>");
				out.println("</table>");
				out.println("</td>");
				out.println("</tr>");
		}
		%>

		</table>

		
