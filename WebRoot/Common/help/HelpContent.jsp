<%
/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   byhu  2004.8.19
 * Tester:
 *
 * Content: 查看页面结构
 * Input Param:
 *       
 * Output param:
 *
 *
 * History Log:  
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%!

public String generateDocTable(String ObjectType,String ObjectNo,Transaction MySqlca) throws Exception
{
	
	String sReturn = "";
	String sSql = "";
	int iCount = 0;
	String sDocNo = "";

	sReturn += "\n<table  width='95%'  align=center border=1 cellspacing='0' cellpadding='4' bordercolorlight='#99999' bordercolordark='#FFFFFF'>\n";
	sSql = "select * from REG_COMMENT_ITEM where CommentItemID in (select CommentItemID from REG_COMMENT_RELA where ObjectType =  '"+ObjectType+"' and ObjectNo = '"+ObjectNo+"')";
	//return sSql;
	
	ASResultSet rsTemp = MySqlca.getResultSet(sSql);
	while(rsTemp.next()){
		iCount++;
		sDocNo = DataConvert.toString(rsTemp.getString("DocNo"));
		sReturn += "<tr>\n";
			sReturn += "<td bgcolor=#CCCCCC>\n";
				sReturn += "编号："+rsTemp.getString("CommentItemID");
				if (sDocNo!=null && !sDocNo.equals("")) sReturn += " 文档号： "+DataConvert.toString(rsTemp.getString("DocNo"));
				sReturn += " 编写人： "+rsTemp.getString("InputUser");
				sReturn += " 更新人： "+rsTemp.getString("UpdateUser");
			sReturn += "</td>\n";
		sReturn += "</tr>\n";
		sReturn += "<tr>\n";
			sReturn += "<td>\n";
				sReturn += DataConvert.toString(rsTemp.getString("CommentText"));
			sReturn += "</td>\n";
		sReturn += "</tr>\n";
	}
	rsTemp.getStatement().close();

	sReturn += "</table>\n";
	if(iCount==0) return "&nbsp;&nbsp;没有找到"+ObjectType+"-"+ObjectNo+"的文档";
	else return sReturn;
	
}

public String translateHelpText(String sCommentText,String sWebRootPath,Transaction MySqlca) throws Exception
{
	String sHelpText = sCommentText;
	String sReturn = "";
	String sSql = "";
	int iCount = 0,iPosBegin=0,iPosEnd=0;
	
	String sTextToTranslate=null;
	String sTextTranslated=null;
	String sDisplayType = null;
	String sTargetObjectType = null;
	String sTargetCommentItemID = null;
	String sTargetCommentItemName = null;
	String sTargetCommentItemContent = null;
	String sTargetCommentItemType = null;


	while(iPosEnd != sHelpText.length()){
		if(iCount++>20) break;
		iPosBegin = sHelpText.indexOf("#",iPosEnd);
		if(iPosBegin==-1) break;
		iPosEnd = sHelpText.indexOf("#",iPosBegin+1);
		
		sTextToTranslate = sHelpText.substring(iPosBegin+1,iPosEnd);
		sDisplayType = StringFunction.getSeparate(sTextToTranslate,"@",1);
		sTargetObjectType = StringFunction.getSeparate(sTextToTranslate,"@",2);
		sTargetCommentItemID = StringFunction.getSeparate(sTextToTranslate,"@",3);
		
		sSql = "select CommentItemID,CommentItemName,CommentText,GetItemName('CommentItemType',CommentItemType) as CommentItemType from REG_COMMENT_ITEM where CommentItemID = '"+sTargetCommentItemID+"'";
		ASResultSet rsTemp = MySqlca.getResultSet(sSql);
		if(rsTemp.next()){
			sTargetCommentItemID = DataConvert.toString(rsTemp.getString("CommentItemID"));
			sTargetCommentItemName = DataConvert.toString(rsTemp.getString("CommentItemName"));
			sTargetCommentItemContent = DataConvert.toString(rsTemp.getString("CommentText"));
			sTargetCommentItemType = DataConvert.toString(rsTemp.getString("CommentItemType"));
			
			if(sDisplayType.equalsIgnoreCase("embed")){
				if(sTargetObjectType.equals("img"))
					sTextTranslated = " <img src="+sTargetCommentItemContent+"> ";
				else
					sTextTranslated = sTargetCommentItemContent;
			}else if(sDisplayType.equalsIgnoreCase("link")){
				sTextTranslated = "<a href=\"javascript:OpenComp('HelpContent','/Common/help/HelpContent.jsp','CommentItemID="+sTargetCommentItemID+"','_blank',OpenStyle)\" > <span class=HelpLink>["+sTargetCommentItemType+"] "+sTargetCommentItemName+"</span></a>";
			}
	
		}else{
			sTextTranslated = "<b><font color=red>[错误的链接："+sTextToTranslate+"]</font></b>";
		}
		rsTemp.getStatement().close();
		
		
		sHelpText = sHelpText.substring(0,iPosBegin) + sTextTranslated + sHelpText.substring(iPosEnd+1);
		iPosEnd = iPosBegin + sTextTranslated.length();
		
	}
	sHelpText = StringFunction.replace(sHelpText,"$井号","#");
	sHelpText = StringFunction.replace(sHelpText,"^^","");
	return sHelpText;

}

%>

<%
String sCommentItemID = DataConvert.toRealString(iPostChange,CurPage.getParameter("CommentItemID"));
String sSql = "";
ASResultSet rs = null;
String sSortNo="";
String sCommentItemType = "";
int iCountRecord=0;

if(sCommentItemID==null || sCommentItemID.equals("")){
	String sComponentURL = sWebRootPath+"/Common/help/Welcome.jsp?CompClientID="+CurComp.ClientID;
	response.sendRedirect(sComponentURL);
}

%>
<html>
<head>
<title>查看文档</title> 
<style type="text/css">
.HelpLink{ color: #0000FF; text-decoration: underline; font-size: 9pt}
li {
	line-height: 25px;
}
</style>
<script language=javascript>
function RelaGroupWare()
{
		sRelaGroupWareInfo = PopPage("/Common/help/QueryRelaPreMessage.jsp?CommentItemID=<%=sCommentItemID%>&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=25;center:yes;status:no;statusbar:no");

}
function DeleteHelp()
{
	//alert(<%=sCommentItemID%>);
	<%
		int i = 0;
		sSql = "select Count(*) from REG_COMMENT_ITEM where CommentItemID Like '"+sCommentItemID+"%'" ;
		ASResultSet rsTemp = SqlcaRepository.getResultSet(sSql);
		while(rsTemp.next()) {
			i = rsTemp.getInt(1);
			if(i>1) {
	%>
			alert("该注释还有下级子节点，不能删除！");
			<%}else {%>
				var truthBeTold = window.confirm("单击“确定”继续。单击“取消”停止。");
				if(truthBeTold) {
					sReturnVaule = PopPage("/Common/help/del_Comment_Page.jsp?CommentItemid=<%=sCommentItemID%>&rand="+randomNumber(),"", "dialogWidth:280px; dialogHeight:200px; help: no; scroll: no; status: no");
					if(sReturnVaule) OpenComp('','/Common/help/HelpContent.jsp','','_self','') ;
					else return;
				}else {
					return ;
				}
	<%		}	
		}rsTemp.getStatement().close();
	%>
}
function showHideRow(rowID){
	if(document.all('row_'+rowID).style.visibility != "hidden")
		document.all('row_'+rowID).style.visibility="hidden";
	else
		document.all('row_'+rowID).style.visibility="show";
}

function exportToExcel()
{
	var sFileName;
	try
	{
		if ( (sFileName=prompt("请输入文件名称(需要包含路径名,例如C:\\1.xls):", "c:\\1.xls")) )
		{
			var fso = new ActiveXObject("Scripting.FileSystemObject");
			var a = fso.CreateTextFile(sFileName, true);
			//document.myH1.innerText="dear";
			a.WriteLine(document.all('myhtml').outerHTML);
			a.Close();	
			alert("保存成功！文件名为："+sFileName+".");
		}
		else	
			alert("您没有输入正确的文件名！");
	}
	catch(e) 
	{
		alert(e.name+" "+e.number+" :"+e.message);
	}
}
function exportToWord()
{
	var sFileName;
	try
	{
		if ( (sFileName=prompt("请输入文件名称(需要包含路径名,例如C:\\1.xls):", "c:\\1.doc")) )
		{
			var fso = new ActiveXObject("Scripting.FileSystemObject");
			var a = fso.CreateTextFile(sFileName, true);
			//document.myH1.innerText="dear";
			a.WriteLine(document.all('myhtml').outerHTML);
			a.Close();	
			alert("保存成功！文件名为："+sFileName+".");
		}
		else	
			alert("您没有输入正确的文件名！");
	}
	catch(e) 
	{
		alert(e.name+" "+e.number+" :"+e.message);
	}
}

</script>
<script language=vbscript>
function printPreview(data)
	fileName= "c:\temporaryFile.htm"
	s = createTemporaryFile(fileName,data)	
	Set xlApp = CreateObject("Excel.Application")
	Set xlBook = xlApp.Workbooks.open(fileName)	
	xlApp.Application.Visible = True
	xlApp.windows(1).visible = True
	xlBook.Sheets(1).PrintPreview
	xlBook.Close 	
end function	
function createTemporaryFile(fileName,data) 
	set objFS=CreateObject("Scripting.FileSystemObject")
	set f = objFS.CreateTextFile(fileName, True, True)
	f.write(data)
	f.close
end function
</script> 



</head>

<body bgcolor="#FFFFFF" leftmargin="8" topmargin="8" onload="" >
	<table width="20%" border="0" cellspacing="0" cellpadding="1">
		<tr>
			<td>
				<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","编辑","编辑该注释","javascript:OpenComp('CommentItemInfo','/Common/Configurator/CommentManage/CommentItemInfo.jsp','CommentItemID="+sCommentItemID+"','')",sResourcesPath)%>
			</td>
			<td>
				<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","删除","删除该注释","javascript:DeleteHelp()",sResourcesPath)%>
			</td>
			<td>
				<%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","Button","关联到组件","关联到组件","javascript:RelaGroupWare()",sResourcesPath)%>
			</td>				
		</tr>
	</table>
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="5">

<tr>
    <td valign=top> 
	<div id="myhtml"  id="window1">
		<table width="100%" border="0" cellspacing="0" cellpadding="3">

	<%
	sSql = "select SortNo,GetItemName('CommentItemType',CommentItemType) as CommentItemTypeName,CommentItemType,CommentItemID,CommentItemName,CommentText from REG_COMMENT_ITEM where CommentItemID='"+sCommentItemID+"'";
	rs = SqlcaRepository.getASResultSet(sSql);
	while(rs.next()){
		sCommentItemType = DataConvert.toString(rs.getString("CommentItemType"));
		sSortNo = DataConvert.toString(rs.getString("SortNo"));
		%>

			<tr>
			  <td height="1" bgcolor="#104A7B"> </td>
			</tr>

			<tr>
			  <td bgcolor="e6f2ea" style="background-color: #d0dee9"><font face=Arial,Helvetica><font size="-1"><b><%=rs.getString("CommentItemName")%> </b> [<%=rs.getString("CommentItemTypeName")%>] </font></font></td>
			</tr>
			<tr>
			  <td height="1" bgcolor="#104A7B"> </td>
			</tr>
			<tr>
			  <td height="20"> </td>
			</tr>
			<tr>
			  <td>
			  <%
			  if(sCommentItemType.equals("060")){ //图片
			  %>
				<p><img src=<%=rs.getString("CommentText")%> ></p>
			  <%
			  }else{
			  %>
				<p><%=translateHelpText(DataConvert.toString(rs.getString("CommentText")),sWebRootPath,SqlcaRepository)%></p>
			  <%
			  }
			  %>
			  </td>
			</tr>
		<%
	}
	rs.getStatement().close();

%>
			<tr>
			  <td>
			  <UL>

<%
	if(sSortNo==null) sSortNo="";
	int iCurLength=sSortNo.length();
	String sNextLength="0";
	sSql = "select min(CodeLength) as NextLength from OBJECT_LEVEL where ObjectType = 'Comment' and CodeLength>"+iCurLength;
	rs = SqlcaRepository.getASResultSet(sSql);
	while(rs.next()){
		sNextLength = rs.getString("NextLength");
	}
	rs.getStatement().close();
	
	sSql = "select SortNo,GetItemName('CommentItemType',CommentItemType) as CommentItemType,CommentItemID,CommentItemName,CommentText from REG_COMMENT_ITEM where SortNo like '"+sSortNo+"%' and Length(SortNo)="+sNextLength + " and DoGenHelp='true' order by SortNo";
	rs = SqlcaRepository.getASResultSet(sSql);
	while(rs.next()){
		sSortNo = DataConvert.toString(rs.getString("SortNo"));
		%>

				<p><LI><a href="javascript:OpenComp('HelpContent','','CommentItemID=<%=rs.getString("CommentItemID")%>','_self',OpenStyle)"> <%=rs.getString("CommentItemName")%>  [<%=rs.getString("CommentItemType")%>]</LI></p> 
			  
		<%
	}
	rs.getStatement().close();
%>
			  </UL>
			  </td>
			</tr>
			<tr>
				<td height="1"><font color="999999">
			
				<%
				sSql = "select GetUserName(UpdateUser) as UpdateUser,UpdateTime from REG_COMMENT_ITEM where CommentItemID='"+sCommentItemID+"'";
				//return sSql;
				
				rs = SqlcaRepository.getResultSet(sSql);
				if(rs.next()){
					%>
					[
					编写人：<%=DataConvert.toString(rs.getString("UpdateUser"))%> 
					更新时间：<%=DataConvert.toString(rs.getString("UpdateTime"))%> 
					]
					<%
				}
				rs.getStatement().close();
				%>
				</font>
				</td>
			</tr>
		</table>
    	</div>

    </td>
</tr>
<tr>
    <td valign=top> 

		<table width="100%" border="0" cellspacing="0" cellpadding="3">
			<tr>
			  <td height="1" bgcolor="#104A7B"> </td>
			</tr>
			<tr>
			  <td bgcolor="e6f2ea" style="background-color: #d0dee9"><font face=Arial,Helvetica><font size="-1">相关对象</font></font></td>
			</tr>
			<tr>
				<td height="1" ><p>
				<UL>
				
				<%
				sSql = "select ra.objectType as ObjectType,ra.objectno as ObjectNo,oc.ObjectTable as ObjectTable,oc.KeyCol as KeyCol,oc.KeyColName as KeyColName from Objecttype_catalog oc ,REG_Comment_Rela ra where oc.Objecttype = ra.Objecttype and CommentItemID='"+sCommentItemID+"'";
				rs = SqlcaRepository.getASResultSet(sSql);
				while(rs.next()) {
					String sObjectNo = rs.getString("ObjectNo");
					String sObjectTable = rs.getString("ObjectTable");
					String sKeyCol = rs.getString("KeyCol");
					String sKeyColName = rs.getString("KeyColName");
					
					sSql = "select RCR.ObjectType,OC.ObjectName as ObjectTypeName,RCR.ObjectNo,(select "+sKeyColName+" as ObjectName from "+sObjectTable+" where "+sKeyCol+" = '"+sObjectNo+"') as ObjectName from REG_COMMENT_RELA RCR,OBJECTTYPE_CATALOG OC where RCR.ObjectType=OC.ObjectType and CommentItemID='"+sCommentItemID+"' and ObjectNO = '"+sObjectNo+"' order by ObjectTypeName";
//					out.println(sSql) ;
					ASResultSet TempRs = null;
					TempRs = SqlcaRepository.getASResultSet(sSql);
					while(TempRs.next()){
						iCountRecord++;
						%>
						<LI><a href="javascript:OpenComp('OnlineHelp','/Common/help/HelpFrame.jsp','ObjectType=<%=TempRs.getString("ObjectType")%>&ObjectNo=<%=TempRs.getString("ObjectNo")%>','_self',OpenStyle)">[<%=TempRs.getString("ObjectTypeName")%>] <%=TempRs.getString("ObjectName")%></LI></p> 
						
						<%
					}
				
				}
				rs.getStatement().close();
				if(iCountRecord==0) out.println("<p><LI>无</LI></p>");
				iCountRecord=0;
				%>
				</UL>
				</td>
			</tr>
		</table>

    </td>
</tr>

</table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>
