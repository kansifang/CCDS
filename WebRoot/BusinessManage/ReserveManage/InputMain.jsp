  <%
/* Copyright 2001-2004 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: xhwang1  2007-16
 * Tester:
 *
 * Content: ��ͬ��Ϣ����
 * Input Param:
 *				 LoanAccount:�����ţ������˺ţ�
 *				 BackPage:�رմ��ڱ�־
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
<title>��ͬ��Ϣ����</title>
</head>

<%
	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,����)�����Զ���Ӧwindow_open
	//��ö����š��رմ��ڱ�־��ѡ������
	String sLoanAccount  = DataConvert.toRealString(iPostChange,(String)request.getParameter("LoanAccount"));
	String sAccountMonth  = DataConvert.toRealString(iPostChange,(String)request.getParameter("AccountMonth"));
	//������һҳ��Ĳ�ѯ������������־
	String sType = DataConvert.toRealString(iPostChange,(String)request.getParameter("Type"));
	if(sType == null) sType = "";
	if(sLoanAccount==null) sLoanAccount = "";
	if(sAccountMonth==null) sAccountMonth = "";	
%>

<script language=javascript>
	//����˵�����ӵ���Ӧ��ҳ��
	function doAction(sAction)
	{		
		//����������Ϣ¼��
		if (sAction=="BadBaseInfo"){
			window.open("<%=sWebRootPath%>/BusinessManage/ReserveManage/BadLoanBaseInfo.jsp?LoanAccount=<%=sLoanAccount%>&AccountMonth=<%=sAccountMonth%>&rand="+randomNumber(),"right","");
		}

		//������ʧʧ������
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
		//����
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
		
		HTMLTreeView tviTemp = new HTMLTreeView("Ԥ���ֽ���¼���б�","right");
		tviTemp.ImageDirectory = sResourcesPath;	//������Դ�ļ�Ŀ¼��ͼƬ��CSS��
		tviTemp.insertPage("root","����������Ϣ¼��","����������Ϣ¼��","javascript:parent.doAction(\"BadBaseInfo\",\"\")",iFlag++);
		tviTemp.insertPage("root","������ʧʶ������","������ʧʶ������","javascript:parent.doAction(\"LossConfirm\",\"\")",iFlag++);
		tviTemp.insertPage("root","Ԥ���ֽ�����Ϣ","Ԥ���ֽ�����Ϣ","javascript:parent.doAction(\"PredictCash1\",\"\")",iFlag++);
		if(sType.equals("Confirm") && (CurUser.hasRight("715") || CurUser.hasRight("725") || CurUser.hasRight("735") || CurUser.hasRight("745"))){
		   tviTemp.insertPage("root","֧��Ԥ���ֽ�����Ϣ","֧��Ԥ���ֽ�����Ϣ","javascript:parent.doAction(\"PredictCash2\",\"\")",iFlag++);
		}
		if(sType.equals("Confirm") && (CurUser.hasRight("725") || CurUser.hasRight("735") || CurUser.hasRight("745"))){//�����϶�Ա�������϶�Ա�������϶�Ա
        	tviTemp.insertPage("root","����Ԥ���ֽ�����Ϣ","����Ԥ���ֽ�����Ϣ","javascript:parent.doAction(\"PredictCash3\",\"\")",iFlag++);
        }
		if(sType.equals("Confirm") && (CurUser.hasRight("735") || CurUser.hasRight("745"))){//�����϶�Ա�������϶�Ա
		   tviTemp.insertPage("root","����Ԥ���ֽ�����Ϣ","����Ԥ���ֽ�����Ϣ","javascript:parent.doAction(\"PredictCash4\",\"\")",iFlag++);
		}
		if(sType.equals("Confirm") && (CurUser.hasRight("745") || CurUser.hasRight("741"))){//�����϶�Ա
		   tviTemp.insertPage("root","����Ԥ���ֽ�����Ϣ","����Ԥ���ֽ�����Ϣ","javascript:parent.doAction(\"PredictCash5\",\"\")",iFlag++);
		}
		if(sType.equals("Audit") && CurUser.hasRight("741")){////���¼����Ա
		   tviTemp.insertPage("root","���Ԥ���ֽ�����Ϣ","���Ԥ���ֽ�����Ϣ","javascript:parent.doAction(\"PredictCash6\",\"\")",iFlag++);
		}
		
		//����
		tviTemp.insertPage("root","����","javascript:parent.doAction(\"goBack\",\"\")",iFlag++);
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
		<div id=divDrag title='������' style="z-index:0; CURSOR: url('<%=sResourcesPath%>/ve_split.cur') "	ondrag="if(event.x>16 && event.x<400) {myleft_top.style.display='block';myleft.style.display='block';myleft_bottom.style.display='block';myleft.width=event.x-6;}if(event.x<=16 && event.y>=4) {myleft_top.style.display='none';myleft.style.display='none';myleft_bottom.style.display='none';}if(event.x<4) window.event.returnValue = false;">
			<img name=imgDrag title='������' height=100% width=3 src="<%=sResourcesPath%>/line.gif">
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
	//�������Ͳ˵��һ�ѡ��
	document.frames("left").document.oncontextmenu=Function("return false;");

</script>

<%@ include file="/IncludeEnd.jsp"%>