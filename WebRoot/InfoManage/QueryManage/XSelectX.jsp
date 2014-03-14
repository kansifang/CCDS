<%@ page contentType="text/html; charset=GBK"%>
<%@page import="com.lmt.baseapp.xquery.*"%>
<%@ page import="org.w3c.dom.*"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: 
		Tester:
		Describe: 选择查询字段要显示的数据项
		Input Param:
			--sSelectCol  :字段列
			--sSelectedCol：条件
		Output Param:
			

		HistoryLog:
			
	 */
	%>
<%/*~END~*/%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "选择查询字段要显示的数据项"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List02;Describe=定义变量，获取参数;]~*/%>
<%

	//获得页面参数，字段列、条件
	String sSelectedCol   = DataConvert.toRealString(iPostChange,CurPage.getParameter("SelectedCol"));
	String sColName = DataConvert.toRealString(iPostChange,CurPage.getParameter("ColName"));
	String sSelectCol="";
	
	XQuery xquery = new XQuery((String)session.getAttribute("xmlPath"),(String)session.getAttribute("queryType"));
	String as1[] = xquery.getCodeItemDefinition(sColName);
	String as2[][] = {
						{ "CodeItemName", as1[0].trim(), "" },
						{ "ColumnName", sColName, "" },
						{ "ColumnNameWithoutID",
								StringFunction.replace(sColName, "ID", "Name"), "" },
						{ "RelatedDataObjectName", "", "" },
						{ "LeftEmbrace", "<", "" },
						{ "RightEmbrace", ">", "" },
						{ "EnvironmentOrgID", CurUser.OrgID, "" } ,
						{ "QueryType", xquery.querytype, "" } 
	};
	Vector vector = xquery.convertStringArrayToParameterVector(as2);
	String sSql = xquery.getStringWithParameterReplaced(as1[1], vector);
	ASResultSet rs=Sqlca.getASResultSet(sSql);
  while(rs.next()){
  	sSelectCol+=rs.getString(1)+"@"+rs.getString(2)+"@@";
  }
  rs.getStatement().close();
%>
<%/*~END~*/%>


<html>
<head>
<title>字段选择器</title>
</head>
<body leftmargin="0" topmargin="0" bgcolor='#DDDDDD'>
<form method='POST' align='center' name='customize'>
<table width='100%' border='1' align='center' cellpadding='0' cellspacing='8' bgcolor='#DDDDDD'>
<tr>
	<td bgcolor='#DDDDDD'>
		<span class='dialog-label'>&nbsp;可选取字段列表</span>
	</td>
</tr>
<tr>
	<td align='center'>
		<select name='select1'  size='17'  style='width:100%;' width='100%' multiple='true'>
		<option></option>
		</select>
	</td>
</tr>
<tr>
    	<td align='center'>
      		<input type="button" style="width:70px"  value="确 定" onclick="javascript:doQuery();">
      		<input type="button" style="width:70px"  value="清 空" onclick="javascript:doBack();">
      		<input type="button" style="width:70px"  value="取 消" onclick="javascript:doCancel();">
    	</td>
</tr>
</table>
</form>
</body>
</html>
<%/*~BEGIN~可编辑区~[Editable=false;CodeAreaID=List06;Describe=自定义函数;]~*/%>

<script language=javascript>

       //---------------------定义按钮事件--------------------------//
	/*~[Describe=取消;InputParam=无;OutPutParam=无;]~*/
	function doCancel(){
		self.returnValue="XXXXXXXXXXXXXXX";
		self.close();
	}
	/*~[Describe=确定;InputParam=无;OutPutParam=无;]~*/
	function doQuery(){
		text="";
		var m=0;
		for (i=0; i < customize.select1.length; i++){
			if(customize.select1.item(i).selected){
					m=i;
					break;
			}
		}
		for (i=0; i < customize.select1.length; i++){
			if(customize.select1.item(i).selected){
				if(m==i){
					text=customize.select1.options[i].text+"@"+customize.select1.options[i].value;
				}
				else{
					text= text+"@@"+customize.select1.options[i].text+"@"+customize.select1.options[i].value;
				}
			}
		}
		self.returnValue=text;
		
		window.close();
	}
	/*~[Describe=返回;InputParam=无;OutPutParam=无;]~*/
	function doBack(){
		for (i=0; i < customize.select1.length; i++){
			if(customize.select1.item(i).selected){
				customize.select1.item(i).selected=false;
			}
		}
	}
	/*~[Describe=缺省;InputParam=无;OutPutParam=无;]~*/
	function doDefault(stemp,stemp2){
		for(s=customize.select1.options.length-1;s>=0;s--){
			customize.select1.options[s]=null;
		}
		var sTemp1=stemp.split("@@");
		var sTemp4=stemp2.split("@");
		for(s=0;s<sTemp1.length;s++){
			var sTemp2=sTemp1[s].split("@");
			customize.select1.options[s]=new Option(sTemp2[1],sTemp2[0]);
		}
	
		for(f=0;f<customize.select1.options.length;f++){
			for(d=0;d<sTemp4.length;d++){
				if(sTemp4[d].length!=0){
					if(sTemp4[d]==customize.select1.item(f).value){
						customize.select1.options[f].selected=true;
					}
				}
			}
		}
	}
	doDefault("<%=sSelectCol%>","<%=sSelectedCol%>");
</script>
<%/*~END~*/%>


<%@ include file="/IncludeEnd.jsp"%>