<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
<title>您需要什么帮助？</title>
</head>
<%
	String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
String sObjectNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
//out.println("sObjectNo:"+sObjectNo+"   sObjectType="+sObjectType);
String sObjectName="",sObjectTable="", sKeyCol="", sKeyColName="";
String sSql = "";
int iCountRecord=0;
ASResultSet rs = null;
sSql = "select ObjectTable,KeyCol,KeyColName,objecttype from objecttype_catalog where ObjectType =  '"+sObjectType+"'";
rs = SqlcaRepository.getResultSet(sSql);
if(rs.next()){
	sObjectTable = rs.getString("ObjectTable") ;
	sKeyCol = rs.getString("KeyCol") ;
	sKeyColName = rs.getString("KeyColName") ;
}
//out.println(sObjectTable+"-"+sKeyCol+"-"+sKeyColName);
sSql = "select "+sKeyColName+" as ObjectName from "+sObjectTable+" where "+sKeyCol+" = '"+sObjectNo+"'";
//out.println(sSql);
rs = SqlcaRepository.getResultSet(sSql);
if(rs.next()) {
	sObjectName = rs.getString("ObjectName");
	if(sObjectName==null) sObjectName=sObjectNo;
}
rs.getStatement().close();
/*
sSql = "select GetObjectName('"+sObjectType+"','"+sObjectNo+"') as ObjectName from OBJECTTYPE_CATALOG where ObjectType='"+sObjectType+"'";

rs = SqlcaRepository.getResultSet(sSql);
if(rs.next()){
	sObjectName = rs.getString("ObjectName");
	if(sObjectName==null) sObjectName=sObjectNo;
}
*/
%>
<body>
	<div style="width: 100%;height:100%;overflow:auto;visibility: inherit">
	<table width="100%" border="0" cellspacing="0" cellpadding="3">
		<tr>
		  <td height="1" bgcolor="#104A7B"> </td>
		</tr>
		<tr>
		  <td bgcolor="e6f2ea" style="background-color: #d0dee9"><font face=Arial,Helvetica><font size="-1">有关于 <b>[<%=sObjectName%>]</b>  的帮助信息</font></font></td>
		</tr>
		<tr>
		  <td height="20"> </td>
		</tr>
		<tr>
			<td height="1" ><p>
			<UL>
		
			<%
						sSql = "select CommentItemID,CommentItemName,GetItemName('CommentItemType',CommentItemType) as CommentItemType from REG_COMMENT_ITEM where CommentItemID in (select CommentItemID from REG_COMMENT_RELA where ObjectType =  '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"')";
						rs = SqlcaRepository.getResultSet(sSql);
						while(rs.next()){
							iCountRecord++;
							out.println("<p><LI><a href=\"javascript:OpenComp('OnlineHelp','/Common/help/HelpFrame.jsp','CommentItemID="+rs.getString("CommentItemID")+"','_self','')\" >["+rs.getString("CommentItemType")+"] "+DataConvert.toString(rs.getString("CommentItemName"))+"</a></LI></p>");
						}
						rs.getStatement().close();
						if(iCountRecord==0) out.println("<p><LI>无</LI></p>");
						iCountRecord=0;
					%>
			<p><LI><a href="javascript:OpenComp('OnlineHelp','/Common/help/HelpFrame.jsp','','_self','')" >更多...</a></LI></p>			
			<p><LI>
            <%=ASWebInterface.generateControl(SqlcaRepository,CurComp,sServletURL,"","HyperLinkText","添加","","javascript:OpenComp('CommentItemInfo','/Common/Configurator/CommentManage/CommentItemInfo.jsp','ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"','')",sResourcesPath)%>
            
            </LI></p>			
			</UL>
			</td>
		</tr>

		<tr>
		  <td height="20"> </td>
		</tr>
		
		
<!--  如果是对象类型为“组件”，则显示相关联的组件和功能，如果对象类型为功能，则显示相关联的组件  -->
<%
	String sTargetObjectNo="",sTargetObjectName="";
	String sSortNo="";
	if(sObjectType!=null && sObjectType.equals("ComponentDefinition"))
	{
%>
		<tr>
			<td height="1"><font color="999999">
			上级组件：
			<%
				String sCompSortNo="";
					    		String sSysAreaCompNameSql ="";
					    		ASResultSet rsSysAreaCompName;
					    		String sSysAreaCompName="",sSysAreaCompNameString="";
					    		int iCountSysAreaCompName=0;
					    		
					    		sSysAreaCompNameSql = "select * from REG_COMP_DEF where CompID = '"+sObjectNo+"'";
					    		rsSysAreaCompName = SqlcaRepository.getASResultSet(sSysAreaCompNameSql);
					    		if(rsSysAreaCompName.next()) sCompSortNo = rsSysAreaCompName.getString("OrderNo");
					    		rsSysAreaCompName.getStatement().close();
					    		
					    		sSysAreaCompNameSql = "select * from REG_COMP_DEF where length(OrderNo)<length('"+sCompSortNo+"') and  OrderNo is not null order by OrderNo ";
					    		rsSysAreaCompName = SqlcaRepository.getASResultSet(sSysAreaCompNameSql);
					    		while(rsSysAreaCompName.next()){
					    			iCountRecord++;
					    			sSysAreaCompName = rsSysAreaCompName.getString("CompName");
					    			if(sSysAreaCompName==null || sSysAreaCompName.equals("")) sSysAreaCompName="未命名";
					    			if(iCountSysAreaCompName!=0) sSysAreaCompNameString += " - ";
					    			sSysAreaCompNameString += " <a href=\"javascript:OpenComp('OnlineHelp','','ObjectNo="+rsSysAreaCompName.getString("CompID")+"&ObjectType=ComponentDefinition','_self','')\" >" + sSysAreaCompName + "</a>";
					    			iCountSysAreaCompName++;
					    			if(iCountSysAreaCompName>5) break;
					    		}
					if(iCountRecord==0) sSysAreaCompNameString = "无";
					iCountRecord=0;
					    		rsSysAreaCompName.getStatement().close();
					    		out.println(sSysAreaCompNameString);
			%>
			</font>
			</td>
		</tr>
		<tr>
			<td height="1"><font color="999999">
		
			<%
						sSql = "select GetUserName(UpdateUser) as UpdateUser,UpdateTime,GetItemName('ComponentType',CompType) as CompType,RightID from REG_COMP_DEF where CompID='"+sObjectNo+"'";
						//return sSql;
						
						rs = SqlcaRepository.getResultSet(sSql);
						if(rs.next()){
					%>
				[
				注册人：<%=DataConvert.toString(rs.getString("UpdateUser"))%> 
				注册时间：<%=DataConvert.toString(rs.getString("UpdateTime"))%> 
				类型：<%=DataConvert.toString(rs.getString("CompType"))%> 
				权限ID：<%=DataConvert.toString(rs.getString("RightID"))%> 
				]
				<%
						}
						rs.getStatement().close();
					%>
			</font>
			</td>
		</tr>
		<tr>
		  <td height="10"> </td>
		</tr>
		<tr>
		  <td height="1" bgcolor="#104A7B"> </td>
		</tr>
		<tr>
		  <td bgcolor="e6f2ea" style="background-color: #d0dee9"><font face=Arial,Helvetica><font size="-1">下级组件</font></font></td>
		</tr>
		<tr>
		  <td height="20"> </td>
		</tr>

		<tr>
			<td height="1" ><p>
			<UL>
			<%
				//取当前组件的排序号
				sSql = "select OrderNo from REG_COMP_DEF where CompID='"+sObjectNo+"'";
				rs = SqlcaRepository.getASResultSet(sSql);
				if(rs.next()){
					sSortNo = DataConvert.toString(rs.getString("OrderNo"));
				}
				rs.getStatement().close();
				
				//取当前组件的下级别排序号长度
				if(sSortNo==null) sSortNo="";
				int iCurLength=sSortNo.length();
				String sNextLength="0";
				sSql = "select min(CodeLength) as NextLength from OBJECT_LEVEL where ObjectType = 'ComponentDefinition' and CodeLength>"+iCurLength ;
				rs = SqlcaRepository.getASResultSet(sSql);
				while(rs.next()){
					sNextLength = rs.getString("NextLength");
				}
				rs.getStatement().close();

				//取当前组件的下一级别组件
				sSql = "select CompID as TargetObjectNo,CompName as TargetObjectName ,OrderNo from REG_COMP_DEF where OrderNo like '"+sSortNo+"%' and Length(OrderNo)="+sNextLength + " order by OrderNo";
				//out.println(sSql);
				//return sSql;
				
				rs = SqlcaRepository.getResultSet(sSql);
				while(rs.next()){
					iCountRecord++;
					out.println("<P><LI><a href=\"javascript:OpenComp('OnlineHelp','','ObjectNo="+rs.getString("TargetObjectNo")+"&ObjectType=ComponentDefinition','_self','')\" >"+DataConvert.toString(rs.getString("TargetObjectName"))+"</a></LI></P>");
				}
				rs.getStatement().close();
				if(iCountRecord==0) out.println("<p><LI>无</LI></p>");
				iCountRecord=0;
			%>
			</UL>
			</td>
		</tr>
		<tr>
		  <td height="20"> </td>
		</tr>
		<tr>
		  <td height="1" bgcolor="#104A7B"> </td>
		</tr>
		<tr>
		  <td bgcolor="e6f2ea" style="background-color: #d0dee9"><font face=Arial,Helvetica><font size="-1">相关功能</font></font></td>
		</tr>
		<tr>
		  <td height="20"> </td>
		</tr>

		<tr>
			<td height="1" ><p>
			<UL>
		
			<%
						sSql = "select FunctionID as TargetObjectNo,FunctionName as TargetObjectName from REG_FUNCTION_DEF where CompID='"+sObjectNo+"'";
						//return sSql;
						
						rs = SqlcaRepository.getResultSet(sSql);
						while(rs.next()){
							iCountRecord++;
							out.println("<P><LI><a href=\"javascript:OpenComp('OnlineHelp','','ObjectNo="+rs.getString("TargetObjectNo")+"&ObjectType=Function','_self','')\" >"+DataConvert.toString(rs.getString("TargetObjectName"))+"</a></LI></P>");
						}
						rs.getStatement().close();
						if(iCountRecord==0) out.println("<p><LI>无</LI></p>");
						iCountRecord=0;
					%>
			</UL>
			</td>
		</tr>
		<tr>
		  <td height="20"> </td>
		</tr>
		
<%
			}else if(sObjectType!=null && sObjectType.equals("Function"))
			{
		%>
		<tr>
		  <td height="1" bgcolor="#104A7B"> </td>
		</tr>
		<tr>
		  <td bgcolor="e6f2ea" style="background-color: #d0dee9"><font face=Arial,Helvetica><font size="-1">所属组件</font></font></td>
		</tr>
		<tr>
			<td height="1" ><p>
			<UL>
		
			<%
						sSql = "select CompID as TargetObjectNo,GetObjectName(CompID) as TargetObjectName from REG_FUNCTION_DEF where FunctionID='"+sObjectNo+"'";
						//return sSql;
						
						rs = SqlcaRepository.getResultSet(sSql);
						while(rs.next()){
							iCountRecord++;
							sTargetObjectNo = DataConvert.toString(rs.getString("TargetObjectNo"));
							sTargetObjectName = DataConvert.toString(rs.getString("TargetObjectName"));
							
							out.println("<LI><a href=\"javascript:OpenComp('OnlineHelp','','ObjectNo="+sTargetObjectNo+"&ObjectType=ComponentDefinition','_self','')\" >"+sTargetObjectName+"</a></LI>");
						}
						rs.getStatement().close();
						if(iCountRecord==0) out.println("<p><LI>无</LI></p>");
						iCountRecord=0;
					%>
			</UL>
			</td>
		</tr>
		<tr>
		  <td height="20"> </td>
		</tr>
		<tr>
		  <td height="1" bgcolor="#104A7B"> </td>
		</tr>
		<tr>
		  <td bgcolor="e6f2ea" style="background-color: #d0dee9"><font face=Arial,Helvetica><font size="-1">所属组件的其他功能</font></font></td>
		</tr>
		<tr>
			<td height="1" ><p>
			<UL>
		
			<%
						sSql = "select FunctionID as TargetObjectNo,FunctionName as TargetObjectName from REG_FUNCTION_DEF where CompID='"+sTargetObjectNo+"' and FunctionID<>'"+sObjectNo+"'";
						//return sSql;
						
						rs = SqlcaRepository.getResultSet(sSql);
						while(rs.next()){
							iCountRecord++;
							sTargetObjectNo = DataConvert.toString(rs.getString("TargetObjectNo"));
							sTargetObjectName = DataConvert.toString(rs.getString("TargetObjectName"));
							
							out.println("<LI><a href=\"javascript:OpenComp('OnlineHelp','','ObjectNo="+sTargetObjectNo+"&ObjectType=Function','_self','')\" >"+sTargetObjectName+"</a></LI>");
						}
						rs.getStatement().close();
						if(iCountRecord==0) out.println("<p><LI>无</LI></p>");
						iCountRecord=0;
					%>
			</UL>
			</td>
		</tr>
		<tr>
		  <td height="20"> </td>
		</tr>
<%
	}
%>
	</table>
	</div>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>
