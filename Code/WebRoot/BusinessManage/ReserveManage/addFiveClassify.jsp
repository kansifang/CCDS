<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:  2008.10.29  jjwang
		Tester:
		Content: 没有五级分类的借据，增加五级分类
		Input Param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	String sLoanAccount = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("LoanAccount"));
	if(sLoanAccount == null) sLoanAccount = "";
	String sAccountMonth = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("AccountMonth"));
	if(sAccountMonth == null) sAccountMonth = "";
%>
<html>
<head> 
<title>新会计准则系统</title>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main02;Describe=定义变量，获取参数;]~*/%>
	<%
	//定义变量
	
	//获得组件参数	

	//获得页面参数	：客户类型
	%>
<%/*~END~*/%>

<script language=javascript>
	function addFiveClassify()
	{
		if(document.all("FiveClassify").value=="")
		{
			alert("请选择五级分类");
			return false;
		}
		else
		{
			var fiveClassify = document.all("FiveClassify").value;
			if(fiveClassify=="03" || fiveClassify=="04" || fiveClassify=="05")
			{
				if(confirm("您确认将该笔业务该期次的五级分类为损失类吗？\n 确认后则不能再次修改，该比业务将进行逐笔计提!"))
				{
		    		RunMethod("新会计准则","addFiveClassify","<%=sLoanAccount%>"+","+"<%=sAccountMonth%>"+","+fiveClassify+","+"<%=CurUser.UserID%>"+","+"<%=StringFunction.getTodayNow()%>");
		    	}
		    }else
		    {
		    	if(confirm("您确认将该笔业务该期次的五级分类为正常类吗？\n 确认后则不能再次修改，该比业务将进行组合计提!"))
		    	{
		    		RunMethod("新会计准则","addFiveClassify1","<%=sLoanAccount%>"+","+"<%=sAccountMonth%>"+","+fiveClassify+","+"<%=CurUser.UserID%>"+","+"<%=StringFunction.getTodayNow()%>");
		    	}
		    }
		}		
        self.close();
	}
</script>
<style>
.black9pt {  font-size: 9pt; color: #000000; text-decoration: none}
</style>
</head>

<!--取消复制、粘贴功能 added by hysun 2006.06.22-->
<body onselectstart="return false" oncontextmenu=self.event.returnvalue=false bgcolor="#DCDCDC">
<br>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >请选择五级分类：</td>
      <td nowarp bgcolor="#DCDCDC" > 
        <select name="FiveClassify">
        	<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'MFiveClassify' order by SortNo ",1,2,"")%>
        </select>
      </td>
    </tr>    
    <tr>
      	<td nowarp align="right" bgcolor="#DCDCDC" height="25"> 
        <input type="button" name="next" value="确认" onClick="addFiveClassify()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      	</td>
      	<td nowarp bgcolor="#DCDCDC" height="25">
      	<input type="button" name="Cancel" value="取消" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      	</td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>