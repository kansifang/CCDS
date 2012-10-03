<%
/* Copyright 2005-2008 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: jjwang  2008.10.16
 * Tester:
 *
 * Content: 文档管理
 * Input Param:
 *				对象类型：Type
 *						—BusinessApply（申请对象）
 *          					—Customer（客户对象）
 *				对象编号：ObjectNo
 *						—申请/合同流水号码/客户编号
 *	      			 权限标志：EditRight
 *                 				 01(查看详情)
 *                 				 02（新增、删除、修改和查看详情）
 * Output param:
 *				对象类型：ObjectType
 *					—BusinessApply（申请对象）
 *          				—Customer（客户对象）
 *					—NPAWardReport（监控报告对象）
 *				对象编号：ObjectNo
 *					—申请/合同流水号/客户编号
 *				文档编号：DocNo
 *
 * History Log:
 *			
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<head>
<title>文档信息列表</title>
</head>

<%

	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window_open
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("Type"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sEditRight= DataConvert.toRealString(iPostChange,(String)request.getParameter("EditRight"));
	String sStatus= DataConvert.toRealString(iPostChange,(String)request.getParameter("Status"));
	
	if(sEditRight == null)	sEditRight = "";
			
	//定义变量：SQL语句、表名
	String sSql = "",sTableName = "";
	
	//文档列表
	String sHeaders[][]={
					 {"DocType","文档类型"},
					 {"DocTitle","文档名称"},
					 {"FileName","附件名称"},
					 {"BeginTime","上传时间"},							
					 {"UserName","登记人"},
					 {"OrgName","登记机构"}
			   };
	
	sTableName = "DOC_LIBRARY,DOC_RELATIVE,DOC_ATTACHMENT1";
	
	sSql = 	" select DL.DocNo,getItemName('DocumentType',DL.DocType) as DocType, "+
			" DL.DocTitle,DA.FileName,DA.BeginTime,DL.UserName,DL.OrgName, "+
			" DA.AttachmentNo "+
   		" from DOC_LIBRARY DL,DOC_RELATIVE DR,DOC_ATTACHMENT1 DA "+
   		" where DR.ObjectType = '"+sObjectType+"' "+
   		"  and DR.ObjectNo = '"+sObjectNo+"' " +
   		" and DR.DocNo = DL.DocNo " +
   		" and DL.DocNo = DA.DocNo " +
   		" order by BeginTime ";
   		
		
	//设置DataObject
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	//设置数据表名和主键
	doTemp.UpdateTable = sTableName;
	doTemp.setKey("DocNo,AttachmentNo,ObjectType,ObjectNo",true);
	doTemp.setVisible("DocNo,AttachmentNo",false);
	
	//设置字段显示风格和双击功能 
	doTemp.setHTMLStyle("BeginTime,UserName,OrgName"," style={width:80px} ondblclick=\"javascript:parent.onDBLClick()\"");
	doTemp.setHTMLStyle("DocType"," style={width:200px} ondblclick=\"javascript:parent.onDBLClick()\"");
	doTemp.setHTMLStyle("FileName,DocTitle,BeginTime"," style={width:120px} ondblclick=\"javascript:parent.onDBLClick()\"");
	
	//设置DataWindow
	ASDataWindow dwTemp = new ASDataWindow("bmDocumentList",doTemp,Sqlca);
	
	//设置为Grid风格
	dwTemp.Style="1";
	
	//设置为只读
	dwTemp.ReadOnly = "1";

	//生成HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i = 0;i < vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
%>

<body class="ListPage" leftmargin="0" topmargin="0" onload="" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
	<tr id="ListTitle" class="ListTitle">
	    <td>
	    </td>
	</tr>
	<tr id="buttonback" class="buttonback">
	<td>
		<table>
			<tr>
				<%
				//xhwang1  2007-04-27  提交后的文档不能删除与新增
				if(sEditRight.equals("02")&&!sStatus.equals("02"))
				{
				%>
				<td>
					<%=HTMLControls.generateButton("新增","新增文档","javascript:my_Add();",sResourcesPath)%>
				</td>

				<%
				}
				%>
				
				<td>
					<%=HTMLControls.generateButton("查看详情","查看附件信息","javascript:viewBoard();",sResourcesPath)%>
				</td>
				
				<%
				if(sEditRight.equals("02")&&!sStatus.equals("02"))
				{
				%>
				
				<td>
						<%=HTMLControls.generateButton("删除","删除","javascript:my_Del();",sResourcesPath)%>
				</td>
				<%
				}
				%>
				
				<% if(sObjectType.equals("NPAWardReport"))
				{
				%>
				<td>
					<%=HTMLControls.generateButton("关闭","关闭当前窗口","javascript:Close();",sResourcesPath)%>
				</td>
				<%
				}
				%>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td >
		<iframe name="myiframe0" width=100% height=100% frameborder=0></iframe>
	</td>
</tr>
</table>

</body>
</html>


<script language=javascript>
	//新增
	function my_Add()
	{
		window.open("<%=sWebRootPath%>/PublicInfo/AddDocumentPreMessage.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&rand="+randomNumber(),"_blank","width=500,height=150,top=200,left=170;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 	
	}
	
	//查看附件详情
	function viewBoard() 
	{
	   	sDocNo=getItemValue(0,getRow(),"DocNo");
	   	sAttachmentNo=getItemValue(0,getRow(),"AttachmentNo");
	   	if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
	   	{
	   		alert(getHtmlMessage('1'));	//请先选择一个附件
	   	}
	   	else   	
	   		window.open("<%=sWebRootPath%>/PublicInfo/AttachmentView.jsp?DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo+"&rand="+randomNumber(),"addb","width=700,height=500,left=50,top=50");
	}
	
	//双击功能        
	function onDBLClick()
	{
		viewBoard();
	}
	
	function Close()
  {
  	self.close();
  }
	
	//删除
	function my_Del()
	{
		//文档编号
		sDocNo=getItemValue(0,getRow(),"DocNo");		
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
	   	{
	   		alert(getHtmlMessage('1'));	//请先选择一个附件
	   	}
	   	else
		{	    
			if(confirm(getHtmlMessage(2)))
			{
				sReturn = self.showModalDialog("<%=sWebRootPath%>/PublicInfo/DelDocAction.jsp?DocNo="+sDocNo+"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=20;center:no;status:no;statusbar:no");
				if (sReturn=="true")
				{
					alert(getHtmlMessage('7'));	//删除成功
					window.location.reload();
				}
				else
				{
					alert(getHtmlMessage('8'));	//操作失败
				}
			}				
		}
  }
  

</script>

<script language=javascript>
	bShowUnloadMessage=false;
	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,"myiframe0");
</script>

<%@ include file="/IncludeEnd.jsp"%>