<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  --
		Tester:	
		Content: --�ͻ����񱨱����
		Input Param:
                 CustomerID��--�ͻ���
                 Term --�����������²������ݣ�
                    ReportCount ��--���������
                    AccountMonth1��--���������
                    Scope��--����Χ
		Output param:
                 CustomerID��--�ͻ���
                 ReportNo:--�����
			               
		History Log: 
			DATE	CHANGER		CONTENT
			2005-7-21 fbkang	�°汾�ĸ�д
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ṹ����"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
   //�������
   
   //���ҳ��������ͻ����롢Term�����Ĳ������������������������¡�����Χ��
	String sCustomerID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("CustomerID"));
	String sTerm       = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Term"));
	sTerm = sTerm.replace('@','&');
	
	//����������
	
%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ҳ��ı�д;]~*/%>

<html>
<head>
	<title>�ṹ����</title>
</head>
<body class="ListPage" leftmargin="0" topmargin="0" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}" onload="resizeTo(screen.width,screen.height,moveTo(0,0));" oncontextmenu="return false">
<table align='center' cellspacing=0 cellpadding=0 border=0 width=100% height="100%">
  <tr>
       <td valign='top' colspan=2 class='tabhead'>
       	<table>
       		<tr>
       			<td>&nbsp;</td>
       			<td>
       				<%=HTMLControls.generateButton("��&nbsp;��","�رմ���","javascript:confirm('�رյ�ǰ���ڣ�')?self.close():''",sResourcesPath)%>
       			</td>
       		</tr>
       	</table>
       </td>
  </tr>                         
   <tr>  
       <td valign='top' align='left' id="tabtd" class="tabtd" height=20 align='left' width=100%> 
  				<iframe class="tabpage" name="DeskTopTab" src="" width=100% height=20 frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"></iframe>
      </td>
  </tr>
  
  <tr> 
       <td class='tabcontent' align='center' valign='top'>  
				<table cellspacing=0 cellpadding=4 border=0 width='100%' height='100%'>
				<tr> 
				<td valign="top" id="TabBodyTable" class="TabBodyTable">
						<iframe name="DeskTopInfo" src="" width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 ></iframe>
				</td>
				</tr>
				</table> 
      </td>
  </tr>
</table>
</body>
</html>

<script language="JavaScript">
	
	var tabstrip = new Array();
	<%
	    /*~[Describe=��tab��ʽ����ҳ��;InputParam=��;OutPutParam=��;]~*/
	    
		String sFinanceBelong = "";//--���񱨱�����
		ASResultSet rs = Sqlca.getASResultSet("select FinanceBelong from ENT_INFO where CustomerID= '" + sCustomerID + "'");
		if(rs.next()) sFinanceBelong = rs.getString(1);		
		rs.getStatement().close();
		
		String sReportNo = "";//--�����
		String sReportName = "";//--��������
		int iCount = 0;//--������
		String sSql = "select ReportNo,ReportName from FINANCE_CATALOG where FINANCE_CATALOG.BelongIndustry ='" + sFinanceBelong + "'"+" order by ReportNo";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sReportNo = rs.getString(1);
			sReportName = rs.getString(2);
			if(Double.parseDouble(sReportNo.substring(3,4))> 2)
				break;
	%>
			tabstrip[<%=iCount%>] = new Array("block<%=iCount%>","<%=sReportName%>","javascript:parent.drawTab(<%=iCount+1%>,'<%=sReportNo%>');");
	<%	
			iCount++;
		}
		rs.beforeFirst();
		if(rs.next())
			sReportNo = rs.getString(1);
		rs.getStatement().close();
	%>

	hc_drawTabToIframe("tab_DeskTopInfo",tabstrip,1,DeskTopTab);
	
        OpenPage("/CustomerManage/FinanceAnalyse/StructureDetail.jsp?CustomerID=<%=sCustomerID%>&ReportNo=<%=sReportNo%><%=sTerm%>","DeskTopInfo");
		
	function drawTab(selectedStrip,reportNo)
	{ 	
		hc_drawTabToIframe("tab_DeskTopInfo",tabstrip,selectedStrip,DeskTopTab);
	    OpenPage("/CustomerManage/FinanceAnalyse/StructureDetail.jsp?CustomerID=<%=sCustomerID%>&ReportNo="+reportNo+"<%=sTerm%>","DeskTopInfo");
   	}
	
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>
