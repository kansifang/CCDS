<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList,java.util.Iterator" %>
<%@page import="com.lmt.app.crawler.dao.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=GBK">
        <title>NewsDetail</title>
        <style>
			.black9pt{font-size: 9pt; color: #000000; text-decoration: none}
			.black9{font-size: 9pt; color: red; text-decoration: none}
		</style>
    </head>
    <body>
    <%
	    double dBalance=0;//本金余额
		double dInterest=0;//欠息余额
		double dFlee=0;//诉讼费
		
		double dBackSum1=0;//第一挂牌回收收入
		double dFleeSum1=0;//第一挂牌处置费用
		double dBackNSum1=0;//第一挂牌回收现金
		
		double dBackSum2=0;//第二挂牌回收收入
		double dFleeSum2=0;//第二挂牌处置费用
		double dBackNSum2=0;//第一挂牌回收现金
		
		double dBackSum3=0;//第三挂牌回收收入
		double dFleeSum3=0;//第三挂牌处置费用
		double dBackNSum3=0;//第一挂牌回收现金
    	String sFlag=request.getParameter("flag");
    	if("1".equals(sFlag)){
    		dBalance=Double.valueOf(request.getParameter("Balance"));//本金余额
       	 dInterest=Double.valueOf(request.getParameter("Interest"));//欠息余额
       	 dFlee=Double.valueOf(request.getParameter("Flee"));//诉讼费
       	
       	 dBackSum1=Double.valueOf(request.getParameter("BackSum1"));//第一挂牌回收收入
       	 dFleeSum1=Double.valueOf(request.getParameter("FleeSum1"));//第一挂牌处置费用
       	 dBackNSum1=Double.valueOf(dBackSum1-dFleeSum1);//第一挂牌回收现金
       	
       	 dBackSum2=Double.valueOf(DataConvert.toMoney(dBackSum1*0.8));//第二挂牌回收收入
       	 dFleeSum2=Double.valueOf(request.getParameter("FleeSum2"));//第二挂牌处置费用
       	 dBackNSum2=Double.valueOf(dBackSum2-dFleeSum2);//第一挂牌回收现金
       	
       	 dBackSum3=Double.valueOf(DataConvert.toMoney(dBackSum2*0.8));//第三挂牌回收收入
       	 dFleeSum3=Double.valueOf(request.getParameter("FleeSum3"));//第三挂牌处置费用
       	 dBackNSum3=Double.valueOf(dBackSum3-dFleeSum3);//第一挂牌回收现金
    	}
    %>
    <form name="SelectAttachment" method="post"  action="CrawlerList22.jsp?CompClientID=<%=CurComp.ClientID%>" align="center">
        <table border="0">
        		<tr>
            	<td>
            	<table>
            	<tr style="LINE-HEIGHT: 40px;background:lightgray">
	            	<td class="black9pt">欠款余额<td>
	            	<td><input type="text"  name="Balance" value="<%=dBalance%>"/>万元</td>
	            	<td class="black9pt">欠息余额<td>
	            	<td><input type="text"  name="Interest" value="<%=dInterest%>"/>万元</td>
            	</tr>
            	<tr style="LINE-HEIGHT: 40px;background:lightgray">
            		<td class="black9pt">诉讼费<td>
            		<td><input type="text"  name="Flee" value="<%=dFlee%>"/>万元</td>
            		<td class="black9pt">第一挂牌回收收入<td>
            		<td><input type="text"  name="BackSum1" value="<%=dBackSum1%>"/>万元</td>
            	</tr>
            	<tr style="LINE-HEIGHT: 40px;background:lightgray">
            		<td class="black9pt">第一挂牌处置费<td>
            		<td><input type="text"  name="FleeSum1" value="<%=dFleeSum1%>"/>万元</td>
            		<td class="black9pt">第二挂牌处置费<td>
            		<td><input type="text"  name="FleeSum2" value="<%=dFleeSum2%>"/>万元</td>
            	</tr>
            	<tr style="LINE-HEIGHT: 40px;background:lightgray">
            		<td class="black9pt" colspan=2>第三挂牌处置费<td>
            		<td class="black9pt" colspan=2><input type="text"  name="FleeSum3" value="<%=dFleeSum3%>"/>万元</td>
            	</tr>
            	</table>
            	</td>
            	</tr>
            	<tr>
            	<td>
            	<table>
            		<tr style="LINE-HEIGHT: 40px;background:lightgray">
            		<td class="black9pt" colspan=2>债权总额</td>
            		<td class="black9pt" colspan=4><%=DataConvert.toMoney(dBalance+dInterest+dFlee)%>万元</td>
                    <td class="black9pt" colspan=2>回收(未含诉讼费)占本金比率</td>
                    <td class="black9pt" colspan=4><%=DataConvert.toMoney((dBackSum1-dFlee)/dBalance*100)%>%</td>
	                </tr>
	                <tr style="LINE-HEIGHT: 40px;background:lightgray">
	                    <td class="black9pt">第一挂牌回收收入</td><td class="black9"><%=DataConvert.toMoney(dBackSum1)%>万元</td>
	                    <td class="black9pt">第一挂牌回收现金</td><td class="black9"><%=DataConvert.toMoney(dBackNSum1)%>万元</td>
	                    <td class="black9pt">贷款本金回收率</td><td class="black9"><%=DataConvert.toMoney(dBackNSum1/dBalance*100)%>%</td>
	                    <td class="black9pt">整体债权回收率</td><td class="black9"><%=DataConvert.toMoney(dBackNSum1/(dBalance+dInterest+dFlee)*100)%>%</td>
	                    <td class="black9pt">贷款本金损失</td><td class="black9"><%=DataConvert.toMoney(dBalance-dBackNSum1+dFlee)%>万元</td>
	                    <td class="black9pt">利息损失</td><td class="black9"><%=DataConvert.toMoney(dBackNSum1>dBalance?(dBackNSum1-dBalance-dInterest):dInterest)%>万元</td>
	                </tr>
	                <tr style="LINE-HEIGHT: 40px;background:lightgray">
	                    <td class="black9pt">第二挂牌回收收入</td><td class="black9"><%=DataConvert.toMoney(dBackSum2)%>万元</td>
	                    <td class="black9pt">第二挂牌回收现金</td><td class="black9"><%=DataConvert.toMoney(dBackNSum2)%>万元</td>
	                    <td class="black9pt">贷款本金回收率</td><td class="black9"><%=DataConvert.toMoney(dBackNSum2/dBalance*100)%>%</td>
	                    <td class="black9pt">整体债权回收率</td><td class="black9"><%=DataConvert.toMoney(dBackNSum2/(dBalance+dInterest+dFlee)*100)%>%</td>
	                    <td class="black9pt">贷款本金损失</td><td class="black9"><%=DataConvert.toMoney(dBalance-dBackNSum2+dFlee)%>万元</td>
	                    <td class="black9pt">利息损失</td><td class="black9"><%=DataConvert.toMoney(dBackNSum2>dBalance?(dBackNSum2-dBalance-dInterest):dInterest)%>万元</td>
	                </tr>
	                <tr style="LINE-HEIGHT: 20px;background:lightgray">
	                    <td class="black9pt">第三挂牌回收收入</td><td class="black9"><%=DataConvert.toMoney(dBackSum3)%>万元</td>
	                    <td class="black9pt">第三挂牌回收现金</td><td class="black9"><%=DataConvert.toMoney(dBackNSum3)%>万元</td>
	                    <td class="black9pt">贷款本金回收率</td><td class="black9"><%=DataConvert.toMoney(dBackNSum3/dBalance*100)%>%</td>
	                    <td class="black9pt">整体债权回收率</td><td class="black9"><%=DataConvert.toMoney(dBackNSum3/(dBalance+dInterest+dFlee)*100)%>%</td>
	                    <td class="black9pt">贷款本金损失</td><td class="black9"><%=DataConvert.toMoney(dBalance-dBackNSum3+dFlee)%>万元</td>
	                    <td class="black9pt">利息损失</td><td class="black9"><%=DataConvert.toMoney(dBackNSum3>dBalance?(dBackNSum3-dBalance-dInterest):dInterest)%>万元</td>
	                </tr>
            	</table>
            	</td>
            	</tr>
        </table>
        <input type="hidden" name="flag" value="0">
        <input type="button" value="计算" onClick="javascipt:myclick();">
	</form>
    </body>
    <script>
    	function myclick()
    	{
    		document.getElementById("flag").value="1";
    		self.SelectAttachment.submit();
    	}
    </script>
</html>
<%@	include file="/IncludeEnd.jsp"%>