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
	    double dBalance=0;//�������
		double dInterest=0;//ǷϢ���
		double dFlee=0;//���Ϸ�
		
		double dBackSum1=0;//��һ���ƻ�������
		double dFleeSum1=0;//��һ���ƴ��÷���
		double dBackNSum1=0;//��һ���ƻ����ֽ�
		
		double dBackSum2=0;//�ڶ����ƻ�������
		double dFleeSum2=0;//�ڶ����ƴ��÷���
		double dBackNSum2=0;//��һ���ƻ����ֽ�
		
		double dBackSum3=0;//�������ƻ�������
		double dFleeSum3=0;//�������ƴ��÷���
		double dBackNSum3=0;//��һ���ƻ����ֽ�
    	String sFlag=request.getParameter("flag");
    	if("1".equals(sFlag)){
    		dBalance=Double.valueOf(request.getParameter("Balance"));//�������
       	 dInterest=Double.valueOf(request.getParameter("Interest"));//ǷϢ���
       	 dFlee=Double.valueOf(request.getParameter("Flee"));//���Ϸ�
       	
       	 dBackSum1=Double.valueOf(request.getParameter("BackSum1"));//��һ���ƻ�������
       	 dFleeSum1=Double.valueOf(request.getParameter("FleeSum1"));//��һ���ƴ��÷���
       	 dBackNSum1=Double.valueOf(dBackSum1-dFleeSum1);//��һ���ƻ����ֽ�
       	
       	 dBackSum2=Double.valueOf(DataConvert.toMoney(dBackSum1*0.8));//�ڶ����ƻ�������
       	 dFleeSum2=Double.valueOf(request.getParameter("FleeSum2"));//�ڶ����ƴ��÷���
       	 dBackNSum2=Double.valueOf(dBackSum2-dFleeSum2);//��һ���ƻ����ֽ�
       	
       	 dBackSum3=Double.valueOf(DataConvert.toMoney(dBackSum2*0.8));//�������ƻ�������
       	 dFleeSum3=Double.valueOf(request.getParameter("FleeSum3"));//�������ƴ��÷���
       	 dBackNSum3=Double.valueOf(dBackSum3-dFleeSum3);//��һ���ƻ����ֽ�
    	}
    %>
    <form name="SelectAttachment" method="post"  action="CrawlerList22.jsp?CompClientID=<%=CurComp.ClientID%>" align="center">
        <table border="0">
        		<tr>
            	<td>
            	<table>
            	<tr style="LINE-HEIGHT: 40px;background:lightgray">
	            	<td class="black9pt">Ƿ�����<td>
	            	<td><input type="text"  name="Balance" value="<%=dBalance%>"/>��Ԫ</td>
	            	<td class="black9pt">ǷϢ���<td>
	            	<td><input type="text"  name="Interest" value="<%=dInterest%>"/>��Ԫ</td>
            	</tr>
            	<tr style="LINE-HEIGHT: 40px;background:lightgray">
            		<td class="black9pt">���Ϸ�<td>
            		<td><input type="text"  name="Flee" value="<%=dFlee%>"/>��Ԫ</td>
            		<td class="black9pt">��һ���ƻ�������<td>
            		<td><input type="text"  name="BackSum1" value="<%=dBackSum1%>"/>��Ԫ</td>
            	</tr>
            	<tr style="LINE-HEIGHT: 40px;background:lightgray">
            		<td class="black9pt">��һ���ƴ��÷�<td>
            		<td><input type="text"  name="FleeSum1" value="<%=dFleeSum1%>"/>��Ԫ</td>
            		<td class="black9pt">�ڶ����ƴ��÷�<td>
            		<td><input type="text"  name="FleeSum2" value="<%=dFleeSum2%>"/>��Ԫ</td>
            	</tr>
            	<tr style="LINE-HEIGHT: 40px;background:lightgray">
            		<td class="black9pt" colspan=2>�������ƴ��÷�<td>
            		<td class="black9pt" colspan=2><input type="text"  name="FleeSum3" value="<%=dFleeSum3%>"/>��Ԫ</td>
            	</tr>
            	</table>
            	</td>
            	</tr>
            	<tr>
            	<td>
            	<table>
            		<tr style="LINE-HEIGHT: 40px;background:lightgray">
            		<td class="black9pt" colspan=2>ծȨ�ܶ�</td>
            		<td class="black9pt" colspan=4><%=DataConvert.toMoney(dBalance+dInterest+dFlee)%>��Ԫ</td>
                    <td class="black9pt" colspan=2>����(δ�����Ϸ�)ռ�������</td>
                    <td class="black9pt" colspan=4><%=DataConvert.toMoney((dBackSum1-dFlee)/dBalance*100)%>%</td>
	                </tr>
	                <tr style="LINE-HEIGHT: 40px;background:lightgray">
	                    <td class="black9pt">��һ���ƻ�������</td><td class="black9"><%=DataConvert.toMoney(dBackSum1)%>��Ԫ</td>
	                    <td class="black9pt">��һ���ƻ����ֽ�</td><td class="black9"><%=DataConvert.toMoney(dBackNSum1)%>��Ԫ</td>
	                    <td class="black9pt">����������</td><td class="black9"><%=DataConvert.toMoney(dBackNSum1/dBalance*100)%>%</td>
	                    <td class="black9pt">����ծȨ������</td><td class="black9"><%=DataConvert.toMoney(dBackNSum1/(dBalance+dInterest+dFlee)*100)%>%</td>
	                    <td class="black9pt">�������ʧ</td><td class="black9"><%=DataConvert.toMoney(dBalance-dBackNSum1+dFlee)%>��Ԫ</td>
	                    <td class="black9pt">��Ϣ��ʧ</td><td class="black9"><%=DataConvert.toMoney(dBackNSum1>dBalance?(dBackNSum1-dBalance-dInterest):dInterest)%>��Ԫ</td>
	                </tr>
	                <tr style="LINE-HEIGHT: 40px;background:lightgray">
	                    <td class="black9pt">�ڶ����ƻ�������</td><td class="black9"><%=DataConvert.toMoney(dBackSum2)%>��Ԫ</td>
	                    <td class="black9pt">�ڶ����ƻ����ֽ�</td><td class="black9"><%=DataConvert.toMoney(dBackNSum2)%>��Ԫ</td>
	                    <td class="black9pt">����������</td><td class="black9"><%=DataConvert.toMoney(dBackNSum2/dBalance*100)%>%</td>
	                    <td class="black9pt">����ծȨ������</td><td class="black9"><%=DataConvert.toMoney(dBackNSum2/(dBalance+dInterest+dFlee)*100)%>%</td>
	                    <td class="black9pt">�������ʧ</td><td class="black9"><%=DataConvert.toMoney(dBalance-dBackNSum2+dFlee)%>��Ԫ</td>
	                    <td class="black9pt">��Ϣ��ʧ</td><td class="black9"><%=DataConvert.toMoney(dBackNSum2>dBalance?(dBackNSum2-dBalance-dInterest):dInterest)%>��Ԫ</td>
	                </tr>
	                <tr style="LINE-HEIGHT: 20px;background:lightgray">
	                    <td class="black9pt">�������ƻ�������</td><td class="black9"><%=DataConvert.toMoney(dBackSum3)%>��Ԫ</td>
	                    <td class="black9pt">�������ƻ����ֽ�</td><td class="black9"><%=DataConvert.toMoney(dBackNSum3)%>��Ԫ</td>
	                    <td class="black9pt">����������</td><td class="black9"><%=DataConvert.toMoney(dBackNSum3/dBalance*100)%>%</td>
	                    <td class="black9pt">����ծȨ������</td><td class="black9"><%=DataConvert.toMoney(dBackNSum3/(dBalance+dInterest+dFlee)*100)%>%</td>
	                    <td class="black9pt">�������ʧ</td><td class="black9"><%=DataConvert.toMoney(dBalance-dBackNSum3+dFlee)%>��Ԫ</td>
	                    <td class="black9pt">��Ϣ��ʧ</td><td class="black9"><%=DataConvert.toMoney(dBackNSum3>dBalance?(dBackNSum3-dBalance-dInterest):dInterest)%>��Ԫ</td>
	                </tr>
            	</table>
            	</td>
            	</tr>
        </table>
        <input type="hidden" name="flag" value="0">
        <input type="button" value="����" onClick="javascipt:myclick();">
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