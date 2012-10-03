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
<%@ page contentType="text/html; charset=gb2312"%>
<%@ include file="/IncludeBegin.jsp"%>
<script language=javascript src="<%=sWebRootPath%>/SystemManage/Support/as_dz.js"> </script>
<%
	String sCustomerID = request.getParameter("CustomerID"); 
	String sAccountMonth = request.getParameter("AccountMonth");
	String sReportNo = request.getParameter("ReportNo");
	String excelData2 = request.getParameter("excelData2");
	String excelData1 = request.getParameter("excelData1");
	String sDisPlayMethod = request.getParameter("DisPlayMethod");
	String ItemNo1[] = StringFunction.toStringArray(excelData1,"@");
	String ItemNo2[] = StringFunction.toStringArray(excelData2,"@");
	double dCol1Value = 0.00;
	double dCol3Value = 0.00;
	int iRowCount = Integer.parseInt(request.getParameter("iRowCount")); 
	String sSql = "";
	if(sDisPlayMethod.equals("2"))
		iRowCount = iRowCount/2*2;
/*	out.println("sCustomerID"+sCustomerID);	
	out.println("sAccountMonth"+sAccountMonth);	
	out.println("sReportNo"+sReportNo);	
	out.println("excelData2"+excelData2);	
	out.println("excelData1"+excelData1);	
	out.println("sDisPlayMethod"+sDisPlayMethod);	
	out.println("iRowCount"+iRowCount);	
*/
	int i=1;
	try
	{
		for(i=1;i<=iRowCount;i++)
		{
			if(ItemNo1[i]==null || ItemNo1[i].equals("")) ItemNo1[i]="0";
			if(ItemNo2[i]==null || ItemNo2[i].equals("")) ItemNo2[i]="0";
			dCol1Value = Double.parseDouble(ItemNo1[i]);
			dCol3Value = Double.parseDouble(ItemNo2[i]);			
			Sqlca.executeSQL("update REPORT_DATA set Col1Value="+dCol1Value+" where ReportNo ='"+sReportNo+"' and RowNo='"+i+"'");
			if(!sDisPlayMethod.equals("3"))
			{
			Sqlca.executeSQL("update REPORT_DATA set Col2Value="+dCol3Value+" where ReportNo ='"+sReportNo+"' and RowNo='"+i+"'");
			}
		   	
		}

	%>
	<script language=javascript>
		alert("数据更新成功");
		self.close();
		window.opener.location.reload();
	</script>
	<%	
	}catch(Exception e)
	{
	%>
	<script language=javascript>
		alert("数据更新失败，错误原因："+"<%=e.toString()%>");
		self.close();
	</script>
	<%
	}
	
%>
<%@ include file="/IncludeEnd.jsp"%>

