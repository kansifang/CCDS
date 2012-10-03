<!--
/************************************************************************/
/* PRODUCT: AMARSOFT CO,.LTD                                            */
/*                                               						*/
/* & Amarsoft Technology CO.,LTD.										*/
/*======================================================================*/
/*									                              		*/
/* DESCRIPTION:    VwR3Cf				                  		        */
/* INPUT PARAMETERS:													*/
/*  				1)		 		                              		*/
/*  				2)				                              		*/
/*  				3)		 		                              		*/
/* OUTPUT PARAMETERS:													*/
/*  				1)	 			                              		*/
/*  				2)				                              		*/
/*  				3)		 		                              		*/
/* MODIFICATION LOG		                                          		*/
/*                                                                		*/
/* HISTORY           DATE           DESCRIPTION                       	*/
/* ~~~~~~~           ~~~~           ~~~~~~~~~~~                     	*/
/*  JodgeYao         2004/07/19      Initial version                   	*/
/*  JodgeYao         2004/07/19      				                   	*/
/*                                                                		*/
/************************************************************************/
-->
<!--created by JodgeYao 2004/07/19-->
<!-- msowcvba.chm  -->
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%
	//��ͬ��
	String sCustomerID = "",sReportNo="",sAccountMonth="",sObjectType="",sReportDate="",sCustomerName="";
	sCustomerName = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerName"));
	sCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	sObjectType = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ObjectType"));
	sReportDate = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportDate"));
	sReportNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportNo"));
	
	
	String sSql = "",sReportName = "",sTitle[],sTitles="",sDisPlayMethod="";
	sTitle = new String[8];
	ASResultSet rs = null;
	int i =0,j=0,iRowCount=0,k=3;
%>
<script language=javascript src="<%=sWebRootPath%>/SystemManage/Support/as_dz.js"> </script>
<html>
<head>
<title>���񱨱�����ͨ��Excel�ļ�����</title>
<link rel="stylesheet" href="<%=sResourcesPath%>/Style.css">
<link rel="STYLESHEET" href="" type="text/css">
</head>
<script language="javascript">
function rtCurPage()
{
	self.close();
}

function DataPre()
{
	//�ļ�����:form1.btnRead.value;
	alert(form1.filename.value);
}

</script>

<body  bgColor="#DEDFCE">
<form name="form1" action="ReportDataCommit.jsp" target="_self" method="post">
<table>
<tr>
	<td>ѡ�񱾻�������񱨱��Excel�ļ���<input type="file" name="filename" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5; border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border="1"></td>
	<td><input type="button" name="btnRead" value="Ԥ��" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5; border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border="1"></td>
	<td><input type=button name=btnShow value="���뵽������" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5; border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border="1"></td>
	<td><input type="button" value="����" onclick="rtCurPage();" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5; border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border="1"></td>
	<td><input type="hidden" name="CustomerID" value="<%=sCustomerID%>"></td>
	<td><input type="hidden" name="AccountMonth" value="<%=sReportDate%>"></td>
	<td><input type="hidden" name="ReportNo" value="<%=sReportNo%>"></td>
	<td><input type="hidden" name="excelData1" value=""></td>
	<td><input type="hidden" name="excelData2" value=""></td>
	<td><input type="hidden" name="iRowCount" value=""></td>
	<td><input type="hidden" name="DisPlayMethod" value=""></td>
</tr>
</table>
</form>
<OBJECT classid="clsid:0002E510-0000-0000-C000-000000000046" height=80% id=Spreadsheet1 
	style="LEFT: 0px; TOP: 0px" width="100%" VIEWASTEXT>
	<PARAM NAME="HTMLURL" VALUE="html/Finance.htm">
	<PARAM NAME="DataType" VALUE="HTMLURL">
	<PARAM NAME="AutoFit" VALUE="0">
	<PARAM NAME="DisplayColHeaders" VALUE="-1">
	<PARAM NAME="DisplayGridlines" VALUE="-1">
	<PARAM NAME="DisplayHorizontalScrollBar" VALUE="-1">
	<PARAM NAME="DisplayRowHeaders" VALUE="-1">
	<PARAM NAME="DisplayTitleBar" VALUE="-1">
	<PARAM NAME="DisplayToolbar" VALUE="-1">
	<PARAM NAME="DisplayVerticalScrollBar" VALUE="-1">
	<PARAM NAME="EnableAutoCalculate" VALUE="-1">
	<PARAM NAME="EnableEvents" VALUE="-1">
	<PARAM NAME="MoveAfterReturn" VALUE="-1">
	<PARAM NAME="MoveAfterReturnDirection" VALUE="0">
	<PARAM NAME="RightToLeft" VALUE="0">
	<PARAM NAME="ViewableRange" VALUE="1:65536">
</OBJECT>
</body>

<script language="javascript">
//�����ӵı���������䵽excel��
	<%
	sSql = "select ReportName,HeaderMethod,DisPlayMethod from REPORT_CATALOG FC,REPORT_RECORD FR "
			+" WHERE FR.ModelNo=FC.ModelNo AND FR.REPORTNO='"+sReportNo+"'"
			+" and FR.ReportDate='"+sReportDate+"' and FR.ObjectNo='"+sCustomerID+"'";
	rs = Sqlca.getResultSet(sSql);
	while(rs.next())
	{
		sReportName = rs.getString("ReportName");
		sTitles = rs.getString(2);
		sDisPlayMethod = rs.getString(3);
	}
	rs.getStatement().close();
	
	StringTokenizer st = new StringTokenizer(sTitles,"&");
	while (st.hasMoreTokens())
	{
		sTitle[i++] = st.nextToken("&");
		j=i;	
	}
	%>
	//��һ��Ϊ��������
	Spreadsheet1.Cells(1,1) = "<%=sReportName%>";
	<%
	for(i=0;i<j;i++)
	{
	%>
	//�ڶ���Ϊ������
		Spreadsheet1.Cells(2,<%=i+1%>) = "<%=sTitle[i]%>";
	<%
	}
	//ȡ�ñ�������
	sSql = " select RowName,RowNo,Col1Value,Col2Value "
			+" from REPORT_DATA WHERE REPORTNO='"+sReportNo+"'"
			+" order by cast (RowNo as integer)";
	rs   = Sqlca.getASResultSet(sSql);
	rs.last();
	iRowCount = rs.getRow();
	rs.beforeFirst();
	i=3;
	j=1;
	String s1="",s2="";
	while(rs.next())
	{
		if((sDisPlayMethod.equals("2") && j<=iRowCount/2) ||  !sDisPlayMethod.equals("2"))
		{
			%>
			Spreadsheet1.Cells(<%=i%>,1) = '<%=DataConvert.toString(rs.getString(1))%>';
			Spreadsheet1.Cells(<%=i%>,2) = '<%=DataConvert.toString(rs.getString(2))%>';
			Spreadsheet1.Cells(<%=i%>,3) = '<%=DataConvert.toMoney(Arith.round(rs.getDouble(3),2))%>';
			
			<%
			if(!sDisPlayMethod.equals("3"))
			{
			%>
				Spreadsheet1.Cells(<%=i%>,4) = "<%=DataConvert.toMoney(Arith.round(rs.getDouble(4),2))%>";
			<%
			}
		}
	//������ʾ��
	//j<=iRowCount/2*2�˹�ʽ��ȥ�������ֵ�����
		if(sDisPlayMethod.equals("2") && j>iRowCount/2 && j<=iRowCount/2*2)
		{
		%>
			Spreadsheet1.Cells(<%=k%>,5) = '<%=DataConvert.toString(rs.getString(1))%>';
			Spreadsheet1.Cells(<%=k%>,6) = '<%=DataConvert.toString(rs.getString(2))%>';
			Spreadsheet1.Cells(<%=k%>,7) = "<%=DataConvert.toMoney(Arith.round(rs.getDouble(3),2))%>";
			Spreadsheet1.Cells(<%=k%>,8) = "<%=DataConvert.toMoney(Arith.round(rs.getDouble(4),2))%>";
		<%
			k++;
		}
		i++;
		j++;
	}

	rs.getStatement().close();
	%>

</script>
<SCRIPT LANGUAGE=VBscript>
//����Ԥ��
sub btnRead_onclick() 
	myModelName = form1.filename.value
	
	if myModelName ="" then
		alert "����ѡһ���ļ���"
		exit sub
	end if
	Set xlApp = CreateObject("Excel.Application")
	Set xlBook = xlApp.Workbooks.open(myModelName)
	I = 3
	excelData1 = ""
	excelData2 = ""
	<%
	//��ʼ������
	i=3;
	j=1;
	k=3;
	for(i=1;i<=iRowCount;i++)
	{
		if((sDisPlayMethod.equals("2") && j<=iRowCount/2) ||  !sDisPlayMethod.equals("2"))
		{
			%>
			excelData1 = xlBook.Sheets(1).Cells(<%=i+2%>,3)
			Spreadsheet1.Cells(<%=i+2%>,3) = excelData1
			<%
			if(!sDisPlayMethod.equals("3"))
			{
			%>
				excelData2 = xlBook.Sheets(1).Cells(<%=i+2%>,4)
				Spreadsheet1.Cells(<%=i+2%>,4) = excelData2
			<%
			}
		}
	//������ʾ��
	//j<=iRowCount/2*2�˹�ʽ��ȥ�������ֵ�����
		if(sDisPlayMethod.equals("2") && j>iRowCount/2 && j<=iRowCount/2*2)
		{
		%>
			excelData1 = xlBook.Sheets(1).Cells(<%=k%>,7)
			excelData2 = xlBook.Sheets(1).Cells(<%=k%>,8)
			Spreadsheet1.Cells(<%=k%>,7) = excelData1
			Spreadsheet1.Cells(<%=k%>,8) = excelData2
		<%
			k++;
		}
		j++;
	}
	%>
	xlApp.Application.Quit
	Set xlApp = Nothing
end sub

//���뵽������
sub btnShow_onclick()
	excelData1 = ""
	excelData2 = ""
	<%
	//��ʼ������
	i=3;
	j=1;
	k=3;
	for(i=1;i<=iRowCount;i++)
	{
		if((sDisPlayMethod.equals("2") && j<=iRowCount/2) ||  !sDisPlayMethod.equals("2"))
		{
			%>
			excelData1 = excelData1 & "@" & Spreadsheet1.Cells(<%=i+2%>,3)
			
			<%
			if(!sDisPlayMethod.equals("3"))
			{
			%>
				excelData2 = excelData2 & "@" & Spreadsheet1.Cells(<%=i+2%>,4)
			<%
			}
		}
	//������ʾ��
	//j<=iRowCount/2*2�˹�ʽ��ȥ�������ֵ�����
		if(sDisPlayMethod.equals("2") && j>iRowCount/2 && j<=iRowCount/2*2)
		{
		%>
			excelData1 = excelData1 & "@" & Spreadsheet1.Cells(<%=k%>,7)
			excelData2 = excelData2 & "@" & Spreadsheet1.Cells(<%=k%>,8)
		<%
			k++;
		}
		j++;
	}
	%>
	form1.excelData1.value = excelData1
	form1.excelData2.value = excelData2
	form1.iRowCount.value = <%=iRowCount%>
	form1.DisPlayMethod.value = <%=sDisPlayMethod%>
	form1.submit()
end sub

</script>

</html>

<%@ include file="/IncludeEnd.jsp"%>