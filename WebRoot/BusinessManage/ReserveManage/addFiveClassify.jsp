<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:  2008.10.29  jjwang
		Tester:
		Content: û���弶����Ľ�ݣ������弶����
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
<title>�»��׼��ϵͳ</title>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//�������
	
	//����������	

	//���ҳ�����	���ͻ�����
	%>
<%/*~END~*/%>

<script language=javascript>
	function addFiveClassify()
	{
		if(document.all("FiveClassify").value=="")
		{
			alert("��ѡ���弶����");
			return false;
		}
		else
		{
			var fiveClassify = document.all("FiveClassify").value;
			if(fiveClassify=="03" || fiveClassify=="04" || fiveClassify=="05")
			{
				if(confirm("��ȷ�Ͻ��ñ�ҵ����ڴε��弶����Ϊ��ʧ����\n ȷ�Ϻ������ٴ��޸ģ��ñ�ҵ�񽫽�����ʼ���!"))
				{
		    		RunMethod("�»��׼��","addFiveClassify","<%=sLoanAccount%>"+","+"<%=sAccountMonth%>"+","+fiveClassify+","+"<%=CurUser.UserID%>"+","+"<%=StringFunction.getTodayNow()%>");
		    	}
		    }else
		    {
		    	if(confirm("��ȷ�Ͻ��ñ�ҵ����ڴε��弶����Ϊ��������\n ȷ�Ϻ������ٴ��޸ģ��ñ�ҵ�񽫽�����ϼ���!"))
		    	{
		    		RunMethod("�»��׼��","addFiveClassify1","<%=sLoanAccount%>"+","+"<%=sAccountMonth%>"+","+fiveClassify+","+"<%=CurUser.UserID%>"+","+"<%=StringFunction.getTodayNow()%>");
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

<!--ȡ�����ơ�ճ������ added by hysun 2006.06.22-->
<body onselectstart="return false" oncontextmenu=self.event.returnvalue=false bgcolor="#DCDCDC">
<br>
  <table align="center" width="329" border='1' cellspacing='0' bordercolor='#999999' bordercolordark='#FFFFFF'>
    <tr> 
      
      <td nowarp align="right" class="black9pt" bgcolor="#DCDCDC" >��ѡ���弶���ࣺ</td>
      <td nowarp bgcolor="#DCDCDC" > 
        <select name="FiveClassify">
        	<%=HTMLControls.generateDropDownSelect(Sqlca,"select ItemNo,ItemName from CODE_LIBRARY where CodeNo = 'MFiveClassify' order by SortNo ",1,2,"")%>
        </select>
      </td>
    </tr>    
    <tr>
      	<td nowarp align="right" bgcolor="#DCDCDC" height="25"> 
        <input type="button" name="next" value="ȷ��" onClick="addFiveClassify()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      	</td>
      	<td nowarp bgcolor="#DCDCDC" height="25">
      	<input type="button" name="Cancel" value="ȡ��" onClick="javascript:self.returnValue='_CANCEL_';self.close()" style="font-size:9pt;padding-top:3;padding-left:5;padding-right:5;background-image:url(../../Resources/functionbg.gif); border: #DEDFCE;  border-style: outset; border-top-width: 1px; border-right-width: 1px;  border-bottom-width: 1px; border-left-width: 1px" border='1'>
      	</td>
    </tr>
  </table>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>