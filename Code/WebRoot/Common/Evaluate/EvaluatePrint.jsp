<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import=" java.math.BigDecimal,com.amarsoft.biz.evaluate.*" %>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   
		Tester:	
		Content: 客户列表
		Input Param:
	         ObjectType:  对象类型
             ObjectNo  :  对象编号
             sSerialNo :  流水号码
		Output param:
			               
		History Log: 
			DATE	CHANGER		CONTENT
			2005-07-22  fbkang    新的版本的改写
			2006/11/03 zywei 根据客户类型显示不同的标题
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List01;Describe=定义页面属性;]~*/%>
	<%
	String PG_TITLE = "评估打印"; // 浏览器窗口标题 <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=定义数据对象;]~*/%>

<%
	//定义变量
	String sObjectType = "",sObjectNo = "",sSerialNo = "",sCustomerType = "";
	String sSql = "",sAccountMonth = "",sModelNo = "",sModelName = "";
	String sItemName = "",sValueCode = "",sValueMethod = "",sValueType = "";	
	String sEvaluateResult = "",sEvaluateDate = "",sOrgName = "",sUserName = "";
	String sCognDate = "",sCognResult = "",sCognOrgName = "",sCognUserName = "",sRemark = "";
	String sCustomerName = "",sSetupDate = "",sPreAccountMonth = "",CurYear = "",sIndustryType = "";
	float dEvaluateScore = 0.0f,dPreScore = 0.0f;
	boolean  PreEvaluateabsent;  //判断前一期信用等级是否存在  
	int  iYear = 0;
	ASResultSet rs = null;
	Evaluate evaluate = null,preevaluate = null;
	DecimalFormat df = new DecimalFormat("0.00");
	
	//获取页面参数	
	sObjectType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	sObjectNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	sSerialNo   = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	//将空值转化为空字符串
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sSerialNo == null) sSerialNo = "";
	
	evaluate    = new Evaluate(sObjectType,sObjectNo,sSerialNo,Sqlca);	
%>
<%/*~END~*/%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=List03;Describe=数据准备;]~*/%>
<%
	//当对象类型为Customer（客户），获取客户类型
	if(sObjectType.equals("Customer"))
	{
		sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sObjectNo+"'");
		if(sCustomerType == null) sCustomerType = "";
	}
	
	//获取信用评级信息	
	sSql = " select AccountMonth,ModelNo,EvaluateDate,EvaluateScore, "+
		   " EvaluateResult,getOrgName(OrgID) as OrgName, "+
		   " getUserName(UserID) as UserName,CognDate, "+
		   " CognResult,getOrgName(CognOrgID) as CognOrgName, "+
		   " getUserName(CognUserID) as CognUserName,Remark "+
		   " from EVALUATE_RECORD "+
		   " where ObjectType = '"+sObjectType+"' "+
		   " and ObjectNo = '"+sObjectNo+"' "+
		   " and SerialNo = '"+sSerialNo+"' ";
	rs = Sqlca.getASResultSet(sSql);
	if (rs.next())
	{	
		sAccountMonth   = DataConvert.toString(rs.getString(1));
		sModelNo        = DataConvert.toString(rs.getString(2));
		sEvaluateDate   = DataConvert.toString(rs.getString(3));
		dEvaluateScore  = rs.getFloat(4);
		sEvaluateResult = DataConvert.toString(rs.getString(5));
		sOrgName        = DataConvert.toString(rs.getString(6));
		sUserName       = DataConvert.toString(rs.getString(7));
		sCognDate       = DataConvert.toString(rs.getString(8));
		sCognResult     = DataConvert.toString(rs.getString(9));
		sCognOrgName    = DataConvert.toString(rs.getString(10));
		sCognUserName   = DataConvert.toString(rs.getString(11));
		sRemark         = DataConvert.toString(rs.getString(12));
	}
	rs.getStatement().close();
	
	
	if (!(sRemark==null) && !sRemark.equals(""))
	{
		sRemark = StringFunction.replace(sRemark,"\\r\\n","");
	}
	//取得信用等级模版名称
	if(sCustomerType.equals("03")) //个人
		sModelName = Sqlca.getString("select ModelName from EVALUATE_CATALOG where ModelType='015' and ModelNo='"+sModelNo+"'");
	else
		sModelName = Sqlca.getString("select ModelName from EVALUATE_CATALOG where ModelType='010' and ModelNo='"+sModelNo+"'");
	if(sModelName == null) sModelName = "";
	
	if(sCustomerType.equals("03")) //个人
	{
		//取得姓名、出生日期、单位所属行业
		rs = Sqlca.getASResultSet("select FullName,Birthday,getItemName('IndustryType',UnitKind) as IndustryType from IND_INFO where CustomerID='"+sObjectNo+"'");
		if (rs.next())
		{   sCustomerName = DataConvert.toString(rs.getString(1));  
			sSetupDate    = DataConvert.toString(rs.getString(2));  
			sIndustryType = DataConvert.toString(rs.getString(3));  
		}
		rs.getStatement().close();	
	}else
	{
		//取得客户名称、客户成立日期、行业分类（国标）
		rs = Sqlca.getASResultSet("select EnterpriseName,SetupDate,getItemName('IndustryType',IndustryType) as IndustryType from ENT_INFO where CustomerID='"+sObjectNo+"'");
		if (rs.next())
		{   sCustomerName = DataConvert.toString(rs.getString(1));  
			sSetupDate    = DataConvert.toString(rs.getString(2));  
			sIndustryType = DataConvert.toString(rs.getString(3));  
		}
		rs.getStatement().close();	
	}
	
	//取得
	//计算上期会计月份
	CurYear = sAccountMonth.substring(0,4);
	iYear = Integer.parseInt(CurYear) - 1;
	sPreAccountMonth = String.valueOf(iYear) + "/12";

	//取得上期数据
	rs = Sqlca.getASResultSet("select SerialNo,EvaluateScore from EVALUATE_RECORD where ObjectType='Customer' and ObjectNo='"+sObjectNo+"' and AccountMonth='"+sPreAccountMonth+"' and ModelNo='"+sModelNo+"'");
	if (rs.next())
	{   sSerialNo = DataConvert.toString(rs.getString(1));  
		dPreScore = rs.getFloat(2);  
	              
		PreEvaluateabsent = true;
	}else
	{
		PreEvaluateabsent = false;
	}
	rs.getStatement().close();
	
	preevaluate = new Evaluate(sObjectType,sObjectNo,sSerialNo,Sqlca);	

	dPreScore      = Round(dPreScore,2);
	//dEvaluateScore = Round(dEvaluateScore,2);
				
%>
<%/*~END~*/%>
<html>
<head>

<title>打印信用等级评估表</title>

<script language=javascript>		
		function doprint()
		{
			window.print();
		}
		
		function goBack()
		{
			self.close();
		}	
		
        function beforePrint()
		{
			document.all('PrintButton').style.display='none';
		}
		
		function afterPrint()
		{
			document.all('PrintButton').style.display="";
		}		

</script>

</head>

<body onbeforeprint="beforePrint()"  onafterprint="afterPrint()" >
<br>&nbsp;
<center>
<%
	if(sCustomerType.equals("03")) //个人
	{
%>
<b1>个人客户信用等级评估表</b1>
<%
	}else
	{
%>
<b1>公司客户信用等级评估表</b1>
<%
	}
%>
<table width="80%"% style='font-family:宋体,arial,sans-serif;font-size: 8pt;align=center'  bordercolordark='#EEEEEE' bordercolorlight='#CCCCCC'>

<tr><td>评估机构:<%=sOrgName%></td><td>评级人员:<%=sUserName%></td><td>评级时间:<%=DataConvert.toString(sEvaluateDate)%></td></tr>
<%
	if(sCustomerType.equals("03")) //个人
	{
%>
<tr><td>姓名:<%=sCustomerName%></td><td>出生日期:<%=sSetupDate%></td></tr>
<tr><td>单位所属行业:<%=sIndustryType%></td><td>信用等级评估模板:<%=sModelName%></td></tr>
<tr><td>本期评级日期:<%=sAccountMonth%></td></tr>
<%
	}else
	{
%>
<tr><td>客户名称:<%=sCustomerName%></td><td>客户成立日期:<%=sSetupDate%></td></tr>
<tr><td>国标行业类型:<%=sIndustryType%></td><td>信用等级评估模板:<%=sModelName%></td></tr>
<tr><td>本期报表日期:<%=sAccountMonth%></td></tr>
<%
	}
%>
<tr><td>本期总得分:<%=dEvaluateScore%></td></tr>
<tr><td>本期认定结果:<%=sEvaluateResult%></td>
</table>
</center>

<style type="text/css">
<!--
.thistable {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}
.thistd {  border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px;height:25px}
.thistd1 {  border-color: #000000; border-style: solid; border-top-width: 1px;border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px;width:295px;height:25px}
.thistd2 {  border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px;width:65px;height:25px}
/*根据宽度，自适应换行样式*/
.breaktd{word-break:break-all}
-->
</style>
<%
if(evaluate.Data.first())
{
%>
<div id="Layer1" style="position:absolute; left:24px; top:9px; width:26px; height:20px; z-index:1" bordercolordark='#EEEEEE' bordercolorlight='#CCCCCC'></div>
<table align="center">
	<tr>
	<td>
	<form name="report" method="post">
		<table width="100%" cellspacing="0" border="1"  height="1" cellpadding="0" class="thistable" align="center">
			<tr bgcolor="#CCCCCC"> 
				<td  align="center" width="45" class="thistd">编号</font></td>
				<td  align="center" class="thistd">指标名称</font></td>
				<td  align="center"  class="thistd1">上期结果</font></td>
				<td  align="center" class="thistd2">上期得分</font></td>
				<td  align="center"  class="thistd1">本期结果</font></td>
				<td  align="center" class="thistd2">本期得分</font></td>		
			</tr>
<%!     
	//将数字的小数位保留两位
	float Round(float value,int l)
	{
		BigDecimal bigvalue = new BigDecimal(value);
		String str = bigvalue.toString();
		Double ReturnValue=0.00;
		int p = str.indexOf(".");         //小数点位置
		int q = str.length() - p - 1;     //小数点后位数

		if (q > l)
       	{
			//要保留的数字
			String s1 = str.substring(0, p + l + 1);
			//要考虑四舍五入的数字
			String s2 = str.substring(p + l + 1, p + l + 2);

			//转换为数字进行处理
			BigDecimal bigs1 = new BigDecimal(s1);
			int ints2 = Integer.parseInt(s2);

			//如果大于等于5则进1
			if (ints2 >= 5)
			{
				BigDecimal addvalue = new BigDecimal(Math.pow(10, -l));
				bigs1 = bigs1.add(addvalue);
			}
			str = bigs1.toString();
		} 
		return Float.parseFloat(str);
	} 
%>

<%
	int    i = 0 ;
	float  fTitle=0.00f,fTitle1=0.00f,fTitle2=0.00f; 
	String sTitle="",sTitle1="";
	String myS="",myItemName="",sItem="",sItName="";
	String sPreItem="",sPreItName="",sPreValueCode="",sPreValueMethod="",sPreValueType="";
	String myPre="",myPreItemName="",sDisplayNo="";
	if(PreEvaluateabsent && evaluate.Data.first())
	{
		do
		{
		i ++;
     	sItemName = "R" + String.valueOf(i);          
     	myItemName=DataConvert.toString(evaluate.Data.getString("ItemName"));
     	if (myItemName.equals("实有净资产") || myItemName.equals("有形长期资产"))
		{
		%> 
          <tr> 
            <td class="thistd" nowrap ><%=DataConvert.toString(evaluate.Data.getString("DisplayNo"))%></td>
            <td class="thistd" nowrap ><%=myItemName%>(万元)</td>
		<%
		}else
		{
		%>
          <tr> 
            <td class="thistd" nowrap ><%=DataConvert.toString(evaluate.Data.getString("DisplayNo"))%></td>
            <td class="thistd" nowrap ><%=myItemName%></td>		
		<%
		}
	 	sValueCode   = evaluate.Data.getString("ValueCode"); 
	 	sValueMethod = evaluate.Data.getString("ValueMethod"); 
	 	sValueType   = evaluate.Data.getString("ValueType"); 

	 	sPreValueCode   = preevaluate.Data.getString("ValueCode"); 
	 	sPreValueMethod = preevaluate.Data.getString("ValueMethod"); 
	 	sPreValueType   = preevaluate.Data.getString("ValueType"); 
	 		 	
	 	if (sValueCode != null && sValueCode.trim().length() > 0) //如果有代码则显示代码列表
	 	{
	 		sItName = DataConvert.toString(evaluate.Data.getString("ItemValue"));
	 		rs = Sqlca.getASResultSet("select ItemName from CODE_LIBRARY where CodeNo = '" + sValueCode + "' and ItemNo='"+sItName+"'");
			if (rs.next()) sItem = rs.getString(1);
			rs.getStatement().close();		

	 		sPreItName = DataConvert.toString(preevaluate.Data.getString("ItemValue"));
	 		rs = Sqlca.getASResultSet("select ItemName from CODE_LIBRARY where CodeNo = '" + sPreValueCode + "' and ItemNo='"+sPreItName+"'");
			if (rs.next()) sPreItem = rs.getString(1);
			rs.getStatement().close();				
			 		
	 	%> 
            <td nowrap align="right" class="thistd1 breaktd">&nbsp;<%=sPreItem%></td>
            <td nowrap  align="right"class="thistd">&nbsp;
            <%
            	if(preevaluate.Data.getFloat("Coefficient")>0)
            	{
            %>
            <%=df.format(Round(preevaluate.Data.getFloat("EvaluateScore"),2))%>
           	<% 
            	}
            %>
            </td>
            <td nowrap align="right" class="thistd1 breaktd">&nbsp;<%=sItem%></td>
            <td nowrap  align="right"class="thistd">&nbsp;
            <%
            	if(evaluate.Data.getFloat("Coefficient")>0)
            	{
            %>
            <%=df.format(Round(evaluate.Data.getFloat("EvaluateScore"),2))%>
            <% 
            	}
            %>
            </td>
		<%
	 	}else if ((sValueMethod != null && sValueMethod.trim().length() > 0) || sValueType==null || sValueType.trim().length() == 0) //如果有取值方法则不能进行修改
	 	{
	 		myS=DataConvert.toString(evaluate.Data.getString("ItemValue"));
	 		if(myS==null || myS.equalsIgnoreCase("null") || myS.equals(""))
	 		{
				myS="0.00";
	 		}

	 		myPre=DataConvert.toString(preevaluate.Data.getString("ItemValue"));
	 		if(myPre==null || myPre.equalsIgnoreCase("null") || myPre.equals(""))
	 		{
				myPre="0.00";
	 		}
	 		
	 		if (sValueType != null)
			{
				if (myItemName.equals("实有净资产") || myItemName.equals("有形长期资产"))
				{
		%> 
           
            <td nowrap  align="right" class="thistd">&nbsp;<%=df.format(preevaluate.Data.getFloat("ItemValue")/10000)%></td>
            <td nowrap  align="right" class="thistd">&nbsp;
            <%
            	if(preevaluate.Data.getFloat("Coefficient")>0)
            	{
            %>
            <%=df.format(Round(preevaluate.Data.getFloat("EvaluateScore"),2))%>
            <% 
            	}
            %>
            </td>
            <td nowrap  align="right" class="thistd" name=<%=sItemName%>>&nbsp;<%=df.format(evaluate.Data.getFloat("ItemValue")/10000)%></td>
            <td nowrap  align="right" class="thistd">&nbsp;
            <%
            	if(evaluate.Data.getFloat("Coefficient")>0)
            	{
            %>
            <%=df.format(Round(evaluate.Data.getFloat("EvaluateScore"),2))%>
            <%
            	}
            %>
            </td>
		<%
				}else
				{
					sDisplayNo=DataConvert.toString(evaluate.Data.getString("DisplayNo"));
					if (sDisplayNo.length()>1)
					{
				%>
            <td nowrap  align="right" class="thistd">&nbsp;<%=df.format(Round(Float.parseFloat(myPre),2))%></td>
            <td nowrap  align="right" class="thistd">&nbsp;
            <%
            	if(preevaluate.Data.getFloat("Coefficient")>0)
            	{
            %>
            <%=df.format(Round(preevaluate.Data.getFloat("EvaluateScore"),2))%>
            <% 
            	}
            %>
            </td>
            <td nowrap  align="right" class="thistd" name=<%=sItemName%>>&nbsp;<%=df.format(Round(Float.parseFloat(myS),2))%></td>
            <td nowrap  align="right" class="thistd">&nbsp;
            <%
            	if(evaluate.Data.getFloat("Coefficient")>0)
            	{
            %>
            <%=df.format(Round(evaluate.Data.getFloat("EvaluateScore"),2))%>
            <% 
            	}
            %>
            </td>
				<%
					}else //显示大标题的分数
					{
						sTitle=DataConvert.toString(preevaluate.Data.getString("ItemValue"));
						sTitle1=DataConvert.toString(evaluate.Data.getString("ItemValue"));
						if (sTitle==null || sTitle.equals(""))
							sTitle="0.00";
						if (sTitle1==null || sTitle1.equals(""))
							sTitle1="0.00";
							
						fTitle=Float.parseFloat(sTitle);
						fTitle1=Float.parseFloat(sTitle1);
						if (sDisplayNo.equals("1") || sDisplayNo.equals("7") || sDisplayNo.equals("8"))
						{
							fTitle2=fTitle1;
						}else
						{
							
							fTitle2=(fTitle*30+fTitle1*70)/100;
						}
					%>
            		<td nowrap  align="right" class="thistd">&nbsp;</td>
            		<td nowrap  align="right" class="thistd">&nbsp;<%=df.format(Round(fTitle,2))%></td>
            		<td nowrap  align="right" class="thistd1 breaktd" name=<%=sItemName%>>&nbsp;</td>
            		<td nowrap  align="right" class="thistd">&nbsp;<%=df.format(Round(fTitle1,2))%></td>
					<%					
					}
				}
			}else
			{
			%>
            <td nowrap  align="right" class="thistd">&nbsp; </td>
            <td nowrap  align="right" class="thistd">&nbsp;</td>
            <td nowrap  align="right" class="thistd">&nbsp; </td>
            <td nowrap  align="right" class="thistd">&nbsp; </td>        			
		<%
			}
	 	}else
	 	{
		%> 
            <td nowrap  align="right" class="thistd">&nbsp;<%=df.format(preevaluate.Data.getFloat("ItemValue"))%></td>
            <td nowrap  align="right" class="thistd">&nbsp;
            <%
            	if(preevaluate.Data.getFloat("Coefficient")>0)
            	{
            %>
            <%=df.format(Round(preevaluate.Data.getFloat("EvaluateScore"),2))%>
            <% 
            	}
            %>
            </td>
            <td nowrap  align="right" class="thistd">&nbsp;<%=df.format(evaluate.Data.getFloat("ItemValue"))%></td>
            <td nowrap  align="right" class="thistd">&nbsp;
             <%
            	if(evaluate.Data.getFloat("Coefficient")>0)
            	{
            %>
            <%=df.format(Round(evaluate.Data.getFloat("EvaluateScore"),2))%>
            <%
            	}
            %>
            </td>
		<%	 	
	 	
	 	}
            %>
		</tr>
          <%
		}while(evaluate.Data.next()&& preevaluate.Data.next());
	}else
	{
		do
		{
		i ++;
     	sItemName = "R" + String.valueOf(i);          
     	myItemName=DataConvert.toString(evaluate.Data.getString("ItemName"));
     	if (myItemName.equals("实有净资产") || myItemName.equals("有形长期资产"))
		{     	
		%> 
          <tr> 
            <td nowrap class="thistd"><%=DataConvert.toString(evaluate.Data.getString("DisplayNo"))%></td>
            <td nowrap class="thistd"><%=myItemName%>(万元)</td>
		<%
		}else
		{
		%>
          <tr> 
            <td nowrap class="thistd breaktd"><%=DataConvert.toString(evaluate.Data.getString("DisplayNo"))%></td>
            <td nowrap class="thistd1 breaktd"><%=myItemName%></td>		
		<%
		}
	 	sValueCode   = evaluate.Data.getString("ValueCode"); 
	 	sValueMethod = evaluate.Data.getString("ValueMethod"); 
	 	sValueType   = evaluate.Data.getString("ValueType"); 

	 	if (sValueCode != null && sValueCode.trim().length() > 0) //如果有代码则显示代码列表
	 	{
	 		sItName = DataConvert.toString(evaluate.Data.getString("ItemValue"));
	 		rs = Sqlca.getASResultSet("select ItemName from CODE_LIBRARY where CodeNo = '" + sValueCode + "' and ItemNo='"+sItName+"'");
			if (rs.next()) sItem = rs.getString(1);
			rs.getStatement().close();		
	 		
	 	%> 
            <td nowrap align="right" class="thistd">&nbsp;</td>
            <td nowrap  align="right"class="thistd">&nbsp;</td>
            <td nowrap align="right" class="thistd1 breaktd">&nbsp;<%=sItem%></td>
            <td nowrap  align="right" class="thistd">&nbsp;
            <%
            	if(evaluate.Data.getFloat("Coefficient")>0)
            	{
            %>
            <%=df.format(Round(evaluate.Data.getFloat("EvaluateScore"),2))%>
            <% 
            	}
            %>
            </td>
		<%
	 	}else if ((sValueMethod != null && sValueMethod.trim().length() > 0) || sValueType == null || sValueType.trim().length() == 0) //如果有取值方法则不能进行修改
	 	{
	 		myS=DataConvert.toString(evaluate.Data.getString("ItemValue"));
	 		if(myS==null || myS.equalsIgnoreCase("null") || myS.equals(""))
	 		{
				 myS="0.00";
	 		}

			if (sValueType != null)
			{
				float fvalue = Round(evaluate.Data.getFloat("EvaluateScore")*evaluate.Data.getFloat("Coefficient"),2);
				float fvalue1 = Round(evaluate.Data.getFloat("EvaluateScore")*7/10,2) ;
				if (myItemName.equals("实有净资产") || myItemName.equals("有形长期资产"))
				{
			%> 
            <td nowrap  align="right" class="thistd">&nbsp;</td>
            <td nowrap  align="right" class="thistd">&nbsp;</td>
            <td nowrap  align="right" class="thistd" name=<%=sItemName%>>&nbsp;<%=df.format(evaluate.Data.getFloat("ItemValue")/10000)%></td>
            <td nowrap  align="right" class="thistd">&nbsp;
             <%
            	if(evaluate.Data.getFloat("Coefficient")>0)
            	{
            %>
            <%=df.format(fvalue)%>
            <%
            	}
            %>
            </td>           
			<%
				}else
				{
					sDisplayNo=DataConvert.toString(evaluate.Data.getString("DisplayNo"));
					if (sDisplayNo.length()>1)
					{
				%>
            <td nowrap  align="right" class="thistd">&nbsp;</td>
            <td nowrap  align="right" class="thistd">&nbsp;</td>
            <td nowrap  align="right" class="thistd" name=<%=sItemName%>>&nbsp;<%=df.format(Round(Float.parseFloat(myS),2))%></td>
            <td nowrap  align="right" class="thistd">&nbsp;
             <%
            	if(evaluate.Data.getFloat("Coefficient")>0)
            	{
            %>
            <%=df.format(fvalue)%>
            <% 
            	}
            %>
            </td>       				
					<%
					}else //显示大标题的小计分数
					{		
						sTitle=DataConvert.toString(evaluate.Data.getString("ItemValue"));
						if (sTitle==null || sTitle.equals(""))
							sTitle="0.00";
						fTitle=Float.parseFloat(sTitle);
						if (sDisplayNo.equals("1") || sDisplayNo.equals("7") || sDisplayNo.equals("8"))
						{
							fTitle1=fTitle;
						}else
						{
							fTitle1=fTitle*7/10;
						}
					%>
            		<td nowrap  align="right" class="thistd">&nbsp; </td>
            		<td nowrap  align="right" class="thistd">&nbsp;</td>
            		<td nowrap  align="right" class="thistd">&nbsp; </td>
            		<td nowrap  align="right" class="thistd">&nbsp;<%=df.format(Round(fTitle,2))%> </td>           			
					<%
					}				
				}
			}else
			{
			%>
            <td nowrap  align="right" class="thistd">&nbsp; </td>
            <td nowrap  align="right" class="thistd">&nbsp;</td>
            <td nowrap  align="right" class="thistd">&nbsp; </td>
            <td nowrap  align="right" class="thistd">&nbsp;</td>          			
			<%
			}
	 	}else
	 	{	 	
		%> 
            <td nowrap  align="right" class="thistd">&nbsp;</td>
            <td nowrap  align="right" class="thistd">&nbsp;</td>
            <td nowrap  align="right" class="thistd">&nbsp;<%=df.format(evaluate.Data.getFloat("ItemValue"))%></td>
            <td nowrap  align="right" class="thistd">&nbsp;
            <%
            	if(evaluate.Data.getFloat("Coefficient")>0)
            	{
            %>
            <%=df.format(Round(evaluate.Data.getFloat("EvaluateScore"),2))%>
            <%
	 			}
            %>
            </td>           
		<%
	 	}
            %>
		</tr>
          <%
		}while(evaluate.Data.next()); 
 	}
 
%> 
        </table>
      </form>
	</td>
	</tr>
</table>
<%}%>
<br>
    <div id='PrintButton'> 
	<table border="0" width="80%" align="center">
		<tr> 
			<td align=center width="25%"> 
			   <input type="button" name="next" value="打印" onClick="javascript:doprint()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
			   <!--不能用当前的语句来处理，有问题
                       <p class="orange9pt"><a href="javascript:doprint()">打印</a></p>-->
			</td>
			<td align=center width="25%"> 
			   <input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_none_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
			   <!--不能用当前的语句来处理，有问题
			    <p class="orange9pt"><a href="javascript:goBack()">关闭</a></p>-->
			</td>
		</tr>
	</table>
</div>

<%
evaluate.close();
preevaluate.close();
%> 
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>