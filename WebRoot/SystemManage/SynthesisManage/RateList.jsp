<%/* Copyright 2001-2005 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author:   hxli 2004.02.19
 * Tester:
 *
 * Content: ���ʹ���_List
 * Input Param:
 *         
 * Output param:
 *					Type:���ֻ�׼���ʣ����ʺ�������
 *						--01Ϊ��׼���ʣ�02Ϊ���ʺ�������
 *           
 * History Log:  
 */%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<html>
<head>
<title>���ʹ���</title> 
</head>
<%
	String sHeaders[][] = { 
					{"Currency","����"},
					{"EfficientDate","��Ч����"},
		                    {"RateID","���ʴ���"},
		                    {"RateName","��������"},
                            {"Rate","����(%)"}                 		       			        					        
	               };   				   		
 	String sWhere = DataConvert.toRealString(iPostChange,(String)request.getParameter("Where"));  

	//��ʼ������¼���޲�ѯ����������¼���������м�¼�������ٶȺ���
	if(sWhere == null)
	{
	 	sWhere = " 1 = 2 ";
	}
	sWhere = StringFunction.replace(sWhere,"^","=");
	sWhere = StringFunction.replace(sWhere,"*","%");	
		
	String sSql = " select getItemName('Currency',Currency) as Currency,EfficientDate,RateID,RateName,Rate "+
	              " from RATE_INFO where "+sWhere+" ";
	
	//ͨ��sql�������ݴ������		
	ASDataObject doTemp = new ASDataObject(sSql);
	//���ñ�ͷ
	doTemp.setHeader(sHeaders);
	//���ÿɸ���Ŀ���
	doTemp.UpdateTable = "RATE_INFO";
	doTemp.setKey("EfficientDate,RateID",true);
	doTemp.setAlign("Rate","3");
	
	//����html��ʽ
	doTemp.setHTMLStyle(""," style={width:120px} ");
	doTemp.setHTMLStyle("RateName"," style={width:200px} ");
	//����ASDataWindow���󣬲���һ���ڱ�ҳ��������������ASDataWindow����������ASDataObject����	
	ASDataWindow dwTemp = new ASDataWindow(CurPage,doTemp,Sqlca);
	dwTemp.Style="1";      //����ΪGrid���
	dwTemp.ReadOnly = "1"; //����Ϊֻ��
	
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
						<%=HTMLControls.generateButton("��ѯ","���������ѯ���ݣ���ѯ����������������Ϣ","javascript:my_Query()",sResourcesPath)%>
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

	/*�������һ��Ҫ */ 
	function mySelectRow()
	{ 
		if(myiframe0.event.srcElement.tagName=="BODY") return;	
		setColor();	
	}

	//��ѯ����
	function my_Query()
	{ 	  
		//Type:���ֻ�׼���ʣ����ʺ�������--01Ϊ��׼���ʣ�02Ϊ���ʺ�������
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
