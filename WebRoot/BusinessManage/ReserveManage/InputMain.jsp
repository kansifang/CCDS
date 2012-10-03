  <%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: xhwang1  2007-16
 * Tester:
 *
 * Content: 合同信息详情
 * Input Param:
 *				 LoanAccount:对象编号（贷款账号）
 *				 BackPage:关闭窗口标志
 * Output param:
 *
 * History Log:
 *				
 *				
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<html>
<head>
<title>合同信息详情</title>
</head>

<%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,参数)它会自动适应window_open
	//获得对象编号、关闭窗口标志、选择类型
	String sLoanAccount  = DataConvert.toRealString(iPostChange,(String)request.getParameter("LoanAccount"));
	String sAccountMonth  = DataConvert.toRealString(iPostChange,(String)request.getParameter("AccountMonth"));
	//保留上一页面的查询条件及动作标志
	String sType = DataConvert.toRealString(iPostChange,(String)request.getParameter("Type"));
	if(sType == null) sType = "";
	if(sLoanAccount==null) sLoanAccount = "";
	if(sAccountMonth==null) sAccountMonth = "";	
%>

<script language=javascript>
	//点击菜单项，链接到相应的页面
	function doAction(sAction)
	{		
		//不良贷款信息录入
		if (sAction=="BadBaseInfo"){
			window.open("<%=sWebRootPath%>/BusinessManage/ReserveManage/BadLoanBaseInfo.jsp?LoanAccount=<%=sLoanAccount%>&AccountMonth=<%=sAccountMonth%>&rand="+randomNumber(),"right","");
		}

		//贷款损失失败区间
		if (sAction=="LossConfirm"){
			window.open("<%=sWebRootPath%>/BusinessManage/ReserveManage/BadLoanInfo.jsp?LoanAccount=<%=sLoanAccount%>&AccountMonth=<%=sAccountMonth%>&rand="+randomNumber(),"right","");
		}
		
		if (sAction=="PredictCash1"){
			window.open("<%=sWebRootPath%>/BusinessManage/ReserveManage/CashPredictList.jsp?LoanAccount=<%=sLoanAccount%>&AccountMonth=<%=sAccountMonth%>&Grade=01&rand="+randomNumber(),"right","");
		}
		if (sAction=="PredictCash2"){
			window.open("<%=sWebRootPath%>/BusinessManage/ReserveManage/CashPredictList.jsp?LoanAccount=<%=sLoanAccount%>&AccountMonth=<%=sAccountMonth%>&Grade=02&rand="+randomNumber(),"right","");
		}
		if (sAction=="PredictCash3"){
			window.open("<%=sWebRootPath%>/BusinessManage/ReserveManage/CashPredictList.jsp?LoanAccount=<%=sLoanAccount%>&AccountMonth=<%=sAccountMonth%>&Grade=03&rand="+randomNumber(),"right","");
		}
		if (sAction=="PredictCash4"){
			window.open("<%=sWebRootPath%>/BusinessManage/ReserveManage/CashPredictList.jsp?LoanAccount=<%=sLoanAccount%>&AccountMonth=<%=sAccountMonth%>&Grade=04&rand="+randomNumber(),"right","");
		}
		if (sAction=="PredictCash5"){
			window.open("<%=sWebRootPath%>/BusinessManage/ReserveManage/CashPredictList.jsp?LoanAccount=<%=sLoanAccount%>&AccountMonth=<%=sAccountMonth%>&Grade=05&rand="+randomNumber(),"right","");
		}
		if (sAction=="PredictCash6"){
			window.open("<%=sWebRootPath%>/BusinessManage/ReserveManage/CashPredictList.jsp?LoanAccount=<%=sLoanAccount%>&AccountMonth=<%=sAccountMonth%>&Grade=06&rand="+randomNumber(),"right","");
		}
		//返回
		if (sAction=="goBack"){
			self.close();
			opener.location.reload();
		}
   }
	
	function startMenu()
	{
<%
		String sFolder1 = "";
		int iFlag = 0;
		
		HTMLTreeView tviTemp = new HTMLTreeView("预测现金流录入列表","right");
		tviTemp.ImageDirectory = sResourcesPath;	//设置资源文件目录（图片、CSS）
		tviTemp.insertPage("root","不良贷款信息录入","不良贷款信息录入","javascript:parent.doAction(\"BadBaseInfo\",\"\")",iFlag++);
		tviTemp.insertPage("root","贷款损失识别区间","贷款损失识别区间","javascript:parent.doAction(\"LossConfirm\",\"\")",iFlag++);
		tviTemp.insertPage("root","预测现金流信息","预测现金流信息","javascript:parent.doAction(\"PredictCash1\",\"\")",iFlag++);
		if(sType.equals("Confirm") && (CurUser.hasRight("715") || CurUser.hasRight("725") || CurUser.hasRight("735") || CurUser.hasRight("745"))){
		   tviTemp.insertPage("root","支行预测现金流信息","支行预测现金流信息","javascript:parent.doAction(\"PredictCash2\",\"\")",iFlag++);
		}
		if(sType.equals("Confirm") && (CurUser.hasRight("725") || CurUser.hasRight("735") || CurUser.hasRight("745"))){//分行认定员、总行认定员与最终认定员
        	tviTemp.insertPage("root","分行预测现金流信息","分行预测现金流信息","javascript:parent.doAction(\"PredictCash3\",\"\")",iFlag++);
        }
		if(sType.equals("Confirm") && (CurUser.hasRight("735") || CurUser.hasRight("745"))){//总行认定员与最终认定员
		   tviTemp.insertPage("root","总行预测现金流信息","总行预测现金流信息","javascript:parent.doAction(\"PredictCash4\",\"\")",iFlag++);
		}
		if(sType.equals("Confirm") && (CurUser.hasRight("745") || CurUser.hasRight("741"))){//最终认定员
		   tviTemp.insertPage("root","最终预测现金流信息","最终预测现金流信息","javascript:parent.doAction(\"PredictCash5\",\"\")",iFlag++);
		}
		if(sType.equals("Audit") && CurUser.hasRight("741")){////审计录入人员
		   tviTemp.insertPage("root","审计预测现金流信息","审计预测现金流信息","javascript:parent.doAction(\"PredictCash6\",\"\")",iFlag++);
		}
		
		//返回
		tviTemp.insertPage("root","返回","javascript:parent.doAction(\"goBack\",\"\")",iFlag++);
		out.println(tviTemp.generateHTMLTreeView());
%>
	}

</script>

<body class="mainpage">
<table  border="0" cellspacing="0" cellpadding="0" width="100%" height="100%" class="content_table"  id="content_table">
  <tr>
    <td id="myleft_left_top_corner" class="myleft_left_top_corner"></td>
    <td id="myleft_top" class="myleft_top"></td>
    <td id="myleft_right_top_corner" class="myleft_right_top_corner"></td>
    <td id="mycenter_top" class="mycenter_top"></td>
    <td id="myright_left_top_corner" class="myright_left_top_corner"></td>
    <td id="myright_top" class="myright_top"></td>
    <td id="myright_right_top_corner" class="myright_right_top_corner"></td>
  </tr>
  <tr>
    <td id="myleft_leftMargin" class="myleft_leftMargin"></td>
    <td id="myleft" >
	    	<iframe name="left" src="" width=100% height=100% frameborder=0 scrolling=no ></iframe>
    </td>
    <td id="myleft_rightMargin" class="myleft_rightMargin"> </td>
    <td id="mycenter" class="mycenter">
		<div id=divDrag title='可拖拉' style="z-index:0; CURSOR: url('<%=sResourcesPath%>/ve_split.cur') "	ondrag="if(event.x>16 && event.x<400) {myleft_top.style.display='block';myleft.style.display='block';myleft_bottom.style.display='block';myleft.width=event.x-6;}if(event.x<=16 && event.y>=4) {myleft_top.style.display='none';myleft.style.display='none';myleft_bottom.style.display='none';}if(event.x<4) window.event.returnValue = false;">
			<img name=imgDrag title='可拖拉' height=100% width=3 src="<%=sResourcesPath%>/line.gif">
		</div>
    </td>
    <td id="myright_leftMargin" class="myright_leftMargin"></td>
    <td id="myright" class="myright">
		 <div  class="RightContentDiv" id="RightContentDiv">

			<iframe name="right" scrolling="no" src="<%=sWebRootPath%>/pre.jsp" width=100% height=100% frameborder=0></iframe>
			
		 </div>
    </td>
    <td id="myright_rightMargin" class="myright_rightMargin"></td>
  </tr>
  <tr>
    <td id="myleft_left_bottom_corner" class="myleft_left_bottom_corner"></td>
    <td id="myleft_bottom" class="myleft_bottom"></td>
    <td id="myleft_right_bottom_corner" class="myleft_right_bottom_corner"></td>
    <td id="mycenter_bottom" class="mycenter_bottom"></td>
    <td id="myright_left_bottom_corner" class="myright_left_bottom_corner"></td>
    <td id="myright_bottom" class="myright_bottom"></td>
    <td id="myright_right_bottom_corner" class="myright_right_bottom_corner"></td>
  </tr>

</table>

</body>
</html>

<script language=javascript>	
	startMenu();
	expandNode('root');
	myleft.width=200;
	//屏蔽树型菜单右击选项
	document.frames("left").document.oncontextmenu=Function("return false;");

</script>

<%@ include file="/IncludeEnd.jsp"%>