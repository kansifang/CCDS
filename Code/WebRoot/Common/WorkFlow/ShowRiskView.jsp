<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: xhyong 2012/08/23
 * Tester:
 *
 * Content: ҵ����ʾ��Ϣ
 * Input Param:
 *      Flag������̽����  
 * Output param:
 *	
 * History Log: zywei 2005/08/01

 */
%>

<html>
<head>
<title>ҵ����Ϣ��ʾ</title>
</head>
<body bgcolor="#EAEAEA" >
<br>
<table align="center" width="100%" >
	<tr>
		<td>
			<font face="Geneva, Arial, Helvetica, sans-serif, ��������">
				<strong>
					��ʾ��Ϣ���£� 
				</strong>
			</font>
		</td>
	</tr>
	
</table> 
<br>
<table width="100%" border="1" cellspacing="0" cellpadding="3"  bordercolordark="#EAEAEA">

<%
	//��÷���̽����
	String sExistFlag = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Flag"));	
	if (sExistFlag == null)  sExistFlag = "";
			
	int i = 0,iCount = 0;
	StringTokenizer st = new StringTokenizer(sExistFlag,"@");
	String [] sRiskTip = new String[st.countTokens()];  
	while (st.hasMoreTokens()) 
	{
		sRiskTip[i] = st.nextToken();                
		i ++;
	}
	
	String sTipsFlag="<img src='"+sResourcesPath+"/alarm/icon4.gif' width=12 height=12 alt=''>&nbsp;";
       
	for(int j = 0 ; j < sRiskTip.length ; j ++)
	{
	    iCount = iCount + 1;	   
	    out.println("<tr bgcolor=#fafafa height=20px><td nowrap align=\"left\" class=\"black9pt\" bgcolor=\"#D8D8AF\" >"+sTipsFlag+"<font color=black>"+iCount+"��&nbsp&nbsp"+sRiskTip[j]+"</font></tr></td>");
	}
	  
%>
	<tr>
		<td align = "center" valign = "bottom"  nowrap height=100px class="black9pt" bgcolor="#D8D8AF" > 
       		 	<input type="button" style="width:70px"  value=" ��  �� " class="button" onclick="javascipt:self.close()">
    		</td>
	</tr>
</table>
</body>
</html>


<%@ include file="/IncludeEnd.jsp"%>
