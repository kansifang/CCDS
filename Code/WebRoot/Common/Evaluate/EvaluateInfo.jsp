<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="com.amarsoft.biz.evaluate.*" %>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author: jytian 2004-12-11
		Tester:
  		Content: 	信用等级评估详情
  		Input Param:
         		--Action      :  动作代码
 			    --ObjectType  :  对象类型
 		    	--ObjectNo    :  对象编号
         		--SerialNo    :  评估流水号
 		Output Param:

		HistoryLog:
	 */
	%>
<%/*~END~*/%>


<%   
    //变量定义
   	int    i = 0 ;
	ASResultSet rs;
	Evaluate evaluate;
	String sMessage = "";
	String sSerialNo="",sObjectName="";
	String sAccountMonth="",sModelNo="",sModelName="",sModelType="",sModelTypeName="";
	String sAction="",sItemName="",sItemValue="",sItemNo="",sValueCode="",sValueMethod="",sValueType="",sSql="";
	String sEvaDate="",sEvaResult="";
	float dEvaScore=0;
	String sEvaluateScore="评估得分：",sEvaluateResult="评估结果：",CurYear="";
	//获得页面参数，对象类型、对象号码、 动作代码、评估流水号
	String sObjectType= DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
 	String sObjectNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	sAction           = DataConvert.toRealString(iPostChange,(String)request.getParameter("Action"));
	sSerialNo         = DataConvert.toRealString(iPostChange,(String)request.getParameter("SerialNo"));

	out.println(sAction);
	evaluate    = new Evaluate(sObjectType,sObjectNo,sSerialNo,Sqlca);	
	sAccountMonth = evaluate.AccountMonth;
	sModelNo = evaluate.ModelNo;

	//得到模型名称,类型
	rs = Sqlca.getASResultSet("select ModelName,ModelType from EVALUATE_CATALOG where ModelNo='"+sModelNo+"'");
	if (rs.next())
	{	
		sModelName = rs.getString(1);
		sModelType = rs.getString(2);
	}
	rs.getStatement().close();
	
	//取得评估模型类型名称
	rs = Sqlca.getASResultSet("select ItemName from CODE_LIBRARY where CodeNo='EvaluateModelType' and ItemNo='"+sModelType+"'");
	if (rs.next()) sModelTypeName = rs.getString(1);
	rs.getStatement().close();
	
	//取得评估对象名称			
	if (sObjectType.equals("Customer"))  //客户
	{
		//取客户名称和类别
		rs = Sqlca.getASResultSet("select CustomerName,CustomerType from CUSTOMER_INFO where CustomerID='"+sObjectNo+"'");
		if (rs.next()) 	sObjectName = rs.getString(1);
		rs.getStatement().close();

	}
	
	if(sAction.equals("delete"))
	{
		// 删除评估记录
		sSql = 	 " delete from EVALUATE_DATA where ObjectType='" + sObjectType + "' and ObjectNo='" + sObjectNo + "' "
			+" and SerialNo='"+ sSerialNo + "' ";
		Sqlca.executeSQL(sSql);
		sSql = 	 " delete from EVALUATE_RECORD where ObjectType='" + sObjectType + "' and ObjectNo='" + sObjectNo + "' "
			+" and SerialNo='"+ sSerialNo + "' ";
		Sqlca.executeSQL(sSql);
		%> 
		<script language=javascript>
			alert("数据删除成功");
			self.close();
		</script>
		<%

	} 
	else if(sAction.equals("update") || sAction.equals("evaluate")) //保存,计算时也进行保存
	{
		if (evaluate.Data.first())
		{
			do 
			{
		    	i ++;
		     	sItemName  = "R" + String.valueOf(i);
		     	sItemValue = DataConvert.toRealString(iPostChange,request.getParameter(sItemName));
				sItemNo = evaluate.Data.getString("ItemNo");		     		

		     	if (sItemValue!=null && sItemValue.trim().length()!=0)
		     	{
					Sqlca.executeSQL("update EVALUATE_DATA set ItemValue='"+sItemValue
						+"' where ObjectType='" + sObjectType + "' and ObjectNo='" + sObjectNo + "' and SerialNo='" 
						+ sSerialNo + "' and ItemNo='"+sItemNo+"'");
		     	}
			}
			while(evaluate.Data.next());	
		}
		evaluate.getRecord();
		evaluate.getData(); 

		sMessage =  "评估表数据保存完成！";  		 
	}
		
	if(sAction.equals("evaluate")) //开始计算
	{

		evaluate.evaluate();   //计算
		evaluate.getRecord();  //重新取数据
		evaluate.getData();  
		
		//得到系统评估结果、系统评估日期,更新最终评估结果
		rs = Sqlca.getASResultSet("select EvaluateDate,EvaluateScore,EvaluateResult from EVALUATE_RECORD where ObjectType='" + sObjectType + "' and ObjectNo='" + sObjectNo + "' and SerialNo='"+ sSerialNo + "'");
		if (rs.next())
		{	
			sEvaDate = rs.getString(1);
			dEvaScore = rs.getFloat(2);
			sEvaResult = rs.getString(3);
		}
		rs.getStatement().close();
		
		sSql = " Update EVALUATE_RECORD Set CognDate='"+ sEvaDate +"',CognScore=" + dEvaScore +",CognResult='" +sEvaResult+ "',"+
		       " CognOrgID='"+CurOrg.OrgID+"',CognUserID='"+CurUser.UserID+"'" +
		       " where ObjectType='" + sObjectType + "' and ObjectNo='" + sObjectNo + "' and SerialNo='"+ sSerialNo + "'";
		
		Sqlca.executeSQL(sSql);
		
		sMessage =  "评估表测算完成！";
	}
%>
<html>
<head>
<title><%=sModelTypeName%> - 评估表</title>
</head>

<script language=javascript> 
   var sModelNo  = "<%=sModelNo%>";
   var sSerialNo = "<%=sSerialNo%>";
   var sObjectType = "<%=sObjectType%>";
   var sObjectNo = "<%=sObjectNo%>";	   
<%
	String sUserID="";
	rs = Sqlca.getASResultSet("select UserID from EVALUATE_RECORD where SerialNo='"+sSerialNo+"' and ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'");
	if (rs.next())
	{	
		sUserID = rs.getString("UserID");
	}
	rs.getStatement().close();
%>  
      
	function evaluate()
	{
	   	
	   	
	   		var i;
	   		for(i = 0;i<=document.forms(0).elements.length-1;i++){
	   		
	   			if(document.forms(0).elements(i).type.substr(0,6)=="select"){
	   			
	   				if(document.forms(0).elements(i).value=="0"){
	   				
	   					alert("请选择必要的项！");
	   					document.forms(0).elements(i).focus();
	   					return;
	   				}
	   			}
	   		}
	   		document.report.action="EvaluateInfo.jsp?Action=evaluate&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ModelNo="+sModelNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Rand="+randomNumber();
	   		document.report.submit(); 
	   		self.close();
	  		
	} 
   
	function updateData()
	{
		document.report.action="EvaluateInfo.jsp?Action=update&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ModelNo="+sModelNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Rand="+randomNumber();
		document.report.submit(); 
		self.close();				
	}
   
	function deleteData()
	{
		
	
			if (confirm("将要删除此次评估，继续吗？"))
			{
			
				document.report.action="EvaluateInfo.jsp?Action=delete&ObjectType="+sObjectType+"&ObjectNo="+sObjectNo+"&ModelNo="+sModelNo+"&ObjectType="+sObjectType+"&SerialNo="+sSerialNo+"&Rand="+randomNumber();
				document.report.submit(); 
			}
			self.close();
	
	}
   
	function goBack()
	{
		if(confirm("确定关闭本窗口吗？"))
		{
			self.close();
		}   
	}  
      
</script>

<body bgcolor="#DCDCDC" leftmargin="0" topmargin="0">

<div id="Layer1" style="position:absolute; left:24px; top:9px; width:26px; height:20px; z-index:1"></div>
<table border="0" width="80%" align="center">
	<tr> 
		<td align=center width="25%"> 
      			<input type="button" name="save" value="保存" onClick="javascript:updateData()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
    		</td>
		<td align=center width="25%"> 
			<input type="button" name="evaluate" value="测算" onClick="javascript:evaluate()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>        
 		</td>
		<td align=center width="25%"> 
			<input type="button" name="close" value="关闭" onClick="javascript:goBack()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>          				
		</td>
	</tr>
	<tr> 
		<td colspan="5"> 
			<hr noshade size="1" color="orange">
		</td>
	</tr>
	<tr> 
		<td width="200%" align = center colspan="5"><B><%=sObjectName +"&nbsp;"+ evaluate.AccountMonth %></B><%=sModelName%></td>
	</tr>
	<tr> 
    	<td width="200%" align = center colspan="5">
    		<%=sEvaluateScore%><B><%=DataConvert.toMoney(evaluate.EvaluateScore)%></B> 
    		<%=sEvaluateResult%><B><%=DataConvert.toString(evaluate.EvaluateResult)%></B>
    	</td>
    </tr>
	<tr> 
	</tr>
	<tr> 
		<td colspan="5">
	<form name="report" method="post">
		<table cellspacing=1 cellpadding=1 align="center">
			<tr bgcolor="#CCCCCC"> 
				<td nowrap width="50"  align="center"><font color="#000099">编号</font></td>
				<td nowrap width="180" align="center"><font color="#000099">项目名称</font></td>
				<td nowrap width="150" align="center"><font color="#000099">项目值</font></td>
				<td nowrap width="70"  align="center"><font color="#000099">评估分值</font></td>
			</tr>
	<%
	i = 0;
	String myS="",myItemName="",sDisplayNo="",sTitle="";
	if(evaluate.Data.first())
	{
		do
		{
		i ++;
     	sItemName = "R" + String.valueOf(i);          
     	myItemName=DataConvert.toString(evaluate.Data.getString("ItemName"));
	%> 
          <tr bgcolor="#e9e9e9"> 
            <td nowrap ><%=DataConvert.toString(evaluate.Data.getString("DisplayNo"))%></td>
            <td nowrap ><%=myItemName%></td>
            <%
	 	sValueCode   = evaluate.Data.getString("ValueCode"); 
	 	sValueMethod = evaluate.Data.getString("ValueMethod"); 
	 	sValueType   = evaluate.Data.getString("ValueType"); 
	 	
	 	if (sValueCode != null && sValueCode.trim().length() > 0) //如果有代码则显示代码列表
	 	{
	 		sSql = "select ItemNo,ItemDescribe,ItemName from CODE_LIBRARY where CodeNo = '" + sValueCode + "' order by ItemNo";
	 	%> 
            <td nowrap align="right" > 
              <select name=<%=sItemName%> align="right">
                <option value='0'> </option>
                <%=HTMLControls.generateDropDownSelect(Sqlca,sSql,1,3,DataConvert.toString(evaluate.Data.getString("ItemValue")))%> 
              </select>
            </td>
            <%
	 	}else if ((sValueMethod != null && sValueMethod.trim().length() > 0) || sValueType==null || sValueType.trim().length() == 0) //如果有取值方法则不能进行修改
	 	{
	 		//取显示序号
	 		sDisplayNo=DataConvert.toString(evaluate.Data.getString("DisplayNo"));
	 		myS=DataConvert.toString(evaluate.Data.getString("ItemValue"));
	 		
	 		if(myS!=null && !myS.equalsIgnoreCase("null") && !myS.equals(""))
	 		{
				
				if(sValueType !=null && sValueType.equals("Number"))	
	 			{	
	 				myS=DataConvert.toMoney(String.valueOf(evaluate.Data.getDouble("ItemValue")));
	 				if(myS.equals("")) myS="0.00";
	 			}else	myS=evaluate.Data.getString("ItemValue");
	 		
	 		}
	 		else{ myS="";}
	 		
	 		if (sDisplayNo.length()==1)
	 			myS="";
	 	%> 
            <td nowrap  height='22' align="right" name="<%=sItemName%>"><%=myS%></td>
            <%
	 	}else //否则可以进行修改
	 	{
	 	%> 
            <td nowrap  align="right" > 
              <input class="no_border_number" type=text name="<%=sItemName%>" value='<%=DataConvert.toString(evaluate.Data.getString("ItemValue"))%>'>
            </td>
            <%
	 	}	
            
		
		if (sValueType != null)
	 	{
	 		
	 		//取显示序号
	 		sDisplayNo=DataConvert.toString(evaluate.Data.getString("DisplayNo"));
	 		
	 		//zbdeng:在进行风险度评估时不使用 
	 		//sTitle=DataConvert.toMoney(evaluate.Data.getString("ItemValue"));
	 		
	 		if (sDisplayNo.length()>1)
	 		{	
	 				
	 	%> 
            <td nowrap  align="right"><%=DataConvert.toMoney(evaluate.Data.getDouble("EvaluateScore"))%></td>
		<%	
			}else
			{
			%>
            <td nowrap  align="right"><%=sTitle%></td>			
			<%
			}
		}else 
		{
		%> 
            <td nowrap align="right"></td>
            <td nowrap align="right"></td>
            <%	
		}
		%> </tr>
		<%
	}while(evaluate.Data.next());
 }
 
%> 
        </table>
      </form>
    </td>
  </tr>
</table>
<%
if(!(sAction.equals("new") || sAction.equals("display")))
{
%>
<script language=javascript> 
	alert('<%=sMessage%>');
</script>
<%	 
}
evaluate.close();

%> 
</body>
</html>



<%@ include file="/IncludeEnd.jsp"%>