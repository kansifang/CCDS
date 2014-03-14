<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
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
 */%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%!public String generateDocTable(String ObjectType,String ObjectNo,Transaction MySqlca) throws Exception
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
	String sTextTranslated="";
	String sDisplayType = null;
	String sTargetObjectType = null;
	String sTargetCommentItemID = null;
	String sTargetCommentItemName = null;
	String sTargetCommentItemContent = null;
	String sTargetCommentItemType = null;
	String sTargetCommentItemChapterNo = null;
	String sTargetCommentItemRemark = null;
	String sImgWidth = "0";

	
	while(iPosEnd != sHelpText.length()){
		if(iCount++>20) break;
		iPosBegin = sHelpText.indexOf("#",iPosEnd);
		if(iPosBegin==-1) break;
		iPosEnd = sHelpText.indexOf("#",iPosBegin+1);
		sTextToTranslate = "aaa";
		sTextToTranslate = sHelpText.substring(iPosBegin+1,iPosEnd);
		sDisplayType = StringFunction.getSeparate(sTextToTranslate,"@",1);
		sTargetObjectType = StringFunction.getSeparate(sTextToTranslate,"@",2);
		sTargetCommentItemID = StringFunction.getSeparate(sTextToTranslate,"@",3);
		
		sSql = "select Remark,DoGenHelp,CommentItemID,CommentItemName,ChapterNo,CommentText,GetItemName('CommentItemType',CommentItemType) as CommentItemType from REG_COMMENT_ITEM where CommentItemID = '"+sTargetCommentItemID+"'";
		ASResultSet rsTemp = MySqlca.getResultSet(sSql);
		if(rsTemp.next()){
			sTargetCommentItemID = DataConvert.toString(rsTemp.getString("CommentItemID"));
			sTargetCommentItemName = DataConvert.toString(rsTemp.getString("CommentItemName"));
			sTargetCommentItemContent = DataConvert.toString(rsTemp.getString("CommentText"));
			sTargetCommentItemType = DataConvert.toString(rsTemp.getString("CommentItemType"));
			sTargetCommentItemChapterNo = DataConvert.toString(rsTemp.getString("ChapterNo"));
			sTargetCommentItemRemark = DataConvert.toString(rsTemp.getString("Remark"));
			
			if(DataConvert.toString(rsTemp.getString("DoGenHelp")).equals("true")){
				sTextTranslated = "&nbsp;<a href=\"#"+sTargetCommentItemID+"\" > <span class=HelpLink>"+sTargetCommentItemChapterNo+" "+sTargetCommentItemName+" ["+sTargetCommentItemType+"] </span></a>&nbsp;";
			}else{
				if(sTargetObjectType.equalsIgnoreCase("img")){
				//图片
					sImgWidth = StringFunction.getProfileString(sTargetCommentItemRemark,"width"," ");
					if(sImgWidth==null || sImgWidth.equals("")) sImgWidth="640";
					if (Integer.parseInt(sImgWidth)>480)  //调整图片大小以适应打印
						sTextTranslated = "<p><table bgcolor=#333333 cellspacing=0 cellpadding=1 border=0><tr><td><table width=100% bgcolor=#ECECEC cellspacing=0 cellpadding=4 border=0><tr><td>"+sTargetCommentItemName+"</td></tr><tr><td><img src="+sTargetCommentItemContent+" width=480 height=360></td></tr></table></td></tr></table></p>";
					else
						sTextTranslated = "<p><table bgcolor=#333333 cellspacing=0 cellpadding=1 border=0><tr><td><table width=100% bgcolor=#ECECEC cellspacing=0 cellpadding=4 border=0><tr><td>"+sTargetCommentItemName+"</td></tr><tr><td><img src="+sTargetCommentItemContent+" ></td></tr></table></td></tr></table></p>";
				}else if(sTargetObjectType.equalsIgnoreCase("comment")){
				//注释
				
					sTextTranslated = "<p><table width=100% bgcolor=#333333 cellspacing=0 cellpadding=1 border=0><tr><td><table width=100% bgcolor=#ECECEC cellspacing=0 cellpadding=4 border=0><tr><td>"+sTargetCommentItemName+"</td></tr><tr><td>"+sTargetCommentItemContent+"</td></tr></table></td></tr></table></p>";
				}
			}
	
		}else{
			sTextTranslated = "[错误的链接："+sTextToTranslate+"]";
		}
		rsTemp.getStatement().close();

		sHelpText = sHelpText.substring(0,iPosBegin) + sTextTranslated + sHelpText.substring(iPosEnd+1);
		iPosEnd = iPosBegin + sTextTranslated.length();
		
	}
	sHelpText = StringFunction.replace(sHelpText,"$井号","#");
	sHelpText = StringFunction.replace(sHelpText,"^^","");
	return sHelpText;

}%>

<%
	String sCommentItemID = "";
String sSql = "";
ASResultSet rs = null,rs1=null;
String sLevel = "";
int iCountRecord=0;
%>
<html>
<head>
<title>AMARBANK6_HELP</title> 
<style type="text/css">
.HelpLink{ color: #0000FF; text-decoration: underline; font-size: 9pt; background-color:#ECECEC}
</style>
</head>

<body bgcolor="#FFFFFF" leftmargin="8" topmargin="8" onload="" >
<p>&nbsp;</p>
<p>&nbsp;</p>

	<%
		sSql = "select ChapterNo,SortNo,Length(SortNo) as SortNoLength,GetItemName('CommentItemType',CommentItemType) as CommentItemType,CommentItemID,CommentItemName,CommentText from REG_COMMENT_ITEM where SortNo is not null and DoGenHelp='true' order by SortNo";
		rs = SqlcaRepository.getASResultSet(sSql);
		while(rs.next()){
			sCommentItemID = DataConvert.toString(rs.getString("CommentItemID"));
			sSql = "select ObjectLevel from OBJECT_LEVEL where ObjectType = 'Comment' and CodeLength="+rs.getInt("SortNoLength");
			rs1 = SqlcaRepository.getASResultSet(sSql);
			if(rs1.next()){
		sLevel = rs1.getString("ObjectLevel");
			}
			rs1.getStatement().close();
			if(sLevel!=null && (sLevel.equals("1") ||sLevel.equals("2")  )){
		out.println("<br clear=all style='mso-special-character:line-break;page-break-before:always'>");
			}
	%>
			<p style='background:#EEEEEE'>
				<h<%=sLevel%>>
				  <a name="<%=sCommentItemID%>"></a>
				  <font size="3">
				  <%=rs.getString("ChapterNo")%>
				  <%=rs.getString("CommentItemName")%>
				  [<%=rs.getString("CommentItemType")%>]
				  </font>
				</h<%=sLevel%>>
			</p>
			
			<p>
			<%=translateHelpText(DataConvert.toString(rs.getString("CommentText")),sWebRootPath,SqlcaRepository)%>
			&nbsp;
			</p>
			
			<%
							sSql = "select RCR.ObjectType,OC.ObjectName as ObjectTypeName,RCR.ObjectNo,GetObjectName(RCR.ObjectType,RCR.ObjectNo) as ObjectName from REG_COMMENT_RELA RCR,OBJECTTYPE_CATALOG OC where RCR.ObjectType=OC.ObjectType and CommentItemID='"+sCommentItemID+"' order by ObjectTypeName";
							rs1 = SqlcaRepository.getASResultSet(sSql);
							while(rs1.next()){
								iCountRecord++;
								if(iCountRecord==1){
						%>
					<table bgcolor=#333333 cellspacing=0 cellpadding=1 border=0 width=100%><tr><td>
					<table bgcolor=#FFFFFF cellspacing=0 cellpadding=4 border=0 width=100%>
					<tr><td>相关对象</td></tr>
					<tr><td>
					<UL><%
						}
					%>
				<p><LI>[<%=rs1.getString("ObjectTypeName")%>] <%=rs1.getString("ObjectName")%></LI></p> 
				
				<%
 									}
 									rs1.getStatement().close();
 									if(iCountRecord>0) {
 								%>
				</UL></td></tr></table></td></tr></table>
				<%
					}
					iCountRecord=0;
				%>
				
			</p>
			<p>&nbsp;</p>
			
		
		<%
								}
								rs.getStatement().close();
							%>

</body>
</html>
<script>
	function ShowHelp(sObjectType,sObjectNo)
 	{
		//self.open("<%=sWebRootPath%>/SystemManage/Tools/ShowHelp.jsp?HelpID="+sHelpID+"&rand="+randomNumber(),"_blank","width=750,height=550,left=20,top=20,scrollbars=yes,resizable=yes");
		OpenComp('OnlineHelp','/SystemManage/Tools/OnlineHelp.jsp','ObjectType='+sObjectType+'&ObjectNo='+sObjectNo+'&CommentType=Help','_blank','top=20,left=20,width=640,height=480,resizable=yes');
	}
</script>
<%@ include file="/IncludeEnd.jsp"%>
