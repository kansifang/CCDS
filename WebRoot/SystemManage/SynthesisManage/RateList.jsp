<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   hxli 2004.02.19
 * Tester:
 *
 * Content: 利率管理_List
 * Input Param:
 *         
 * Output param:
 *					Type:区分基准利率，汇率和折算率
 *						--01为基准利率，02为汇率和折算率
 *           
 * History Log:  
 */%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<html>
<head>
<title>利率管理</title> 
</head>
<%
	String sHeaders[][] = { 
					{"Currency","币种"},
					{"EfficientDate","生效日期"},
		                    {"RateID","利率代号"},
		                    {"RateName","利率名称"},
                            {"Rate","利率(%)"}                 		       			        					        
	               };   				   		
 	String sWhere = DataConvert.toRealString(iPostChange,(String)request.getParameter("Where"));  

	//初始不出纪录，无查询条件不出纪录，避免所有纪录出来，速度很慢
	if(sWhere == null)
	{
	 	sWhere = " 1 = 2 ";
	}
	sWhere = StringFunction.replace(sWhere,"^","=");
	sWhere = StringFunction.replace(sWhere,"*","%");	
		
	String sSql = " select getItemName('Currency',Currency) as Currency,EfficientDate,RateID,RateName,Rate "+
	              " from RATE_INFO where "+sWhere+" ";
	
	//通过sql产生数据窗体对象		
	ASDataObject doTemp = new ASDataObject(sSql);
	//设置表头
	doTemp.setHeader(sHeaders);
	//设置可更新目标表
	doTemp.UpdateTable = "RATE_INFO";
	doTemp.setKey("EfficientDate,RateID",true);
	doTemp.setAlign("Rate","3");
	
	//设置html格式
	doTemp.setHTMLStyle(""," style={width:120px} ");
	doTemp.setHTMLStyle("RateName"," style={width:200px} ");
	//生成ASDataWindow对象，参数一用于本页面内区别其他的ASDataWindow，参数二是ASDataObject对象	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //设置为Grid风格
	dwTemp.ReadOnly = "1"; //设置为只读
	
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i=0;i<vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
%> 
<body class="ListPage" leftmargin="0" topmargin="0" onload="" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
	<tr id="ListTitle" class="ListTitle">
	    <td>
	    </td>
	</tr>
	<tr height=1 id="buttonback" class="buttonback">
     <td>
    	<table>
	    	<tr>
	       		<td>
						<%=HTMLControls.generateButton("查询","请点击输入查询内容，查询所有满足条件的信息","javascript:my_Query()",sResourcesPath)%>
	    		</td>    	    	
    		</tr>
    	</table>
    </td>
</tr>
<tr>
    <td colpsan=3>
	<iframe name="myiframe0" width=100% height=100% frameborder=0></iframe>
    </td>
</tr>
</table>
</body>
</html>
<script language="javascript">

	/*这个函数一定要 */ 
	function mySelectRow()
	{ 
		if(myiframe0.event.srcElement.tagName=="BODY") return;	
		setColor();	
	}

	//查询函数
	function my_Query()
	{ 	  
		//Type:区分基准利率，汇率和折算率--01为基准利率，02为汇率和折算率
		sWhere = self.showModalDialog("<%=sWebRootPath%>/SystemManage/SynthesisManage/MyQuery2.jsp?Type=01&rand="+randomNumber(),"","dialogWidth=19;dialogHeight=11;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no");
		if(typeof(sWhere) != "undefined" && sWhere.length > 0)			
			window.open("<%=sWebRootPath%>/SystemManage/SynthesisManage/RateList.jsp?Where="+sWhere+"&rand="+randomNumber(),"_self","");	
		
	}	
	
</script>
<script language=javascript>	
	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,'myiframe0');
	setColor();
</script>	
<%@ include file="/IncludeEnd.jsp"%>
