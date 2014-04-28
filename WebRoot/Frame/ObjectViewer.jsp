<%@ page import="com.lmt.app.object.*"%>
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%
	//��ȡҳ��������������͡������š���ͼ���
	String sObjectType  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectType"));
	String sObjectNo  = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ObjectNo"));
	String sViewID = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("ViewID"));
	//����ֵת��Ϊ���ַ���
	if(sObjectType == null) sObjectType = "";
	if(sObjectNo == null) sObjectNo = "";
	if(sViewID == null) sViewID = "";
	
	//�������
	String sRightType = "",sObjectTypeName = "",sOjbectTypeURL = "",sViewToOpen = "",sViews = "";
	
	IBizObject bo = BizObjectFactory.getInstance().createBizObject(Sqlca,sObjectType,sObjectNo);
	sRightType = bo.getRightType(Sqlca,CurUser.UserID,sViewID);
	
	if(sRightType == null) sRightType="None";
	sViews = (String)bo.getType().getAttribute("ViewType");
	
	if (sViewID.equals("") || sViewID.equalsIgnoreCase("null"))
		sViewToOpen = (String)bo.getType().getAttribute("DefaultView");
	else
		sViewToOpen = sViewID;
		
	sObjectTypeName = bo.getType().name;
	sOjbectTypeURL = (String)bo.getType().getAttribute("PagePath");
	
	//��Component�д洢����
	CurComp.setAttribute("CompObjectType",sObjectType);
	CurComp.setAttribute("CompObjectNo",sObjectNo);
	CurComp.setAttribute("RightType",sRightType);
%>

<html>
<head>

<title><%=sObjectTypeName%>-<%=bo.name()%>-����<%=(sRightType.equalsIgnoreCase("ReadOnly")?"-ֻ��":(sRightType.equalsIgnoreCase("all")?"-���޸�":"-��Ȩ��"))%></title>
<script language="JavaScript">
	setDialogTitle("<%=sObjectTypeName%>-<%=bo.name()%>-����<%=(sRightType.equalsIgnoreCase("ReadOnly")?"-ֻ��":(sRightType.equalsIgnoreCase("all")?"-���޸�":"-��Ȩ��"))%>");
</script>
</head> 

<body leftmargin="0" topmargin="0" class="pagebackground" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}">
   <table align='center' cellspacing=0 cellpadding=0 border=0 width=100% height="100%">
      <tr>
           <td>
                <%
                	if (sRightType!=null && sRightType.equalsIgnoreCase("None")){
                %>
                	�Բ�����û�в鿴[<%=bo.name()%>]��ͼ["+sViewToOpen+"]��Ȩ��.
                <%
                	}else{
                %>
					<iframe name="DeskTopInfo" src="<%=sWebRootPath%>/Blank.jsp?TextToShow = ���ڴ�ҳ��,���Ժ�..." width=100% height=100% frameborder=0 hspace=0 vspace=0 marginwidth=0 marginheight=0 scrolling="no"></iframe>
			    <%
			    	}
			    %>
			</td>
      </tr>                         
   </table>
</body>
</html>


<script language=javascript>

	<%if (sRightType!=null && sRightType.equalsIgnoreCase("None")){%>
		alert("�Բ�����û�в鿴����["+bo.name()+"]��ͼ["+sViewToOpen+"]��Ȩ��.");
	<%}else{%>
		OpenComp("<%=sViews%>","<%=sOjbectTypeURL%>","ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&ViewID=<%=sViewToOpen%>&ToInheritObj=y","DeskTopInfo","");
	<%}%>
	
</script>
<%
	
%>
<%@ include file="/IncludeEnd.jsp"%>
