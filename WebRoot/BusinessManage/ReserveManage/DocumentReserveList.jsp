<%
/* Copyright 2005-2008 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.
 * Use is subject to license terms.
 * Author: jjwang  2008.10.16
 * Tester:
 *
 * Content: �ĵ�����
 * Input Param:
 *				�������ͣ�Type
 *						��BusinessApply���������
 *          					��Customer���ͻ�����
 *				�����ţ�ObjectNo
 *						������/��ͬ��ˮ����/�ͻ����
 *	      			 Ȩ�ޱ�־��EditRight
 *                 				 01(�鿴����)
 *                 				 02��������ɾ�����޸ĺͲ鿴���飩
 * Output param:
 *				�������ͣ�ObjectType
 *					��BusinessApply���������
 *          				��Customer���ͻ�����
 *					��NPAWardReport����ر������
 *				�����ţ�ObjectNo
 *					������/��ͬ��ˮ��/�ͻ����
 *				�ĵ���ţ�DocNo
 *
 * History Log:
 *			
 */
%>


<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<head>
<title>�ĵ���Ϣ�б�</title>
</head>

<%

	//ҳ�����֮��Ĵ���һ��Ҫ��DataConvert.toRealString(iPostChange,ֻҪһ������)�����Զ���Ӧwindow_open
	String sObjectType = DataConvert.toRealString(iPostChange,(String)request.getParameter("Type"));
	String sObjectNo = DataConvert.toRealString(iPostChange,(String)request.getParameter("ObjectNo"));
	String sEditRight= DataConvert.toRealString(iPostChange,(String)request.getParameter("EditRight"));
	String sStatus= DataConvert.toRealString(iPostChange,(String)request.getParameter("Status"));
	
	if(sEditRight == null)	sEditRight = "";
			
	//���������SQL��䡢����
	String sSql = "",sTableName = "";
	
	//�ĵ��б�
	String sHeaders[][]={
					 {"DocType","�ĵ�����"},
					 {"DocTitle","�ĵ�����"},
					 {"FileName","��������"},
					 {"BeginTime","�ϴ�ʱ��"},							
					 {"UserName","�Ǽ���"},
					 {"OrgName","�Ǽǻ���"}
			   };
	
	sTableName = "DOC_LIBRARY,DOC_RELATIVE,DOC_ATTACHMENT1";
	
	sSql = 	" select DL.DocNo,getItemName('DocumentType',DL.DocType) as DocType, "+
			" DL.DocTitle,DA.FileName,DA.BeginTime,DL.UserName,DL.OrgName, "+
			" DA.AttachmentNo "+
   		" from DOC_LIBRARY DL,DOC_RELATIVE DR,DOC_ATTACHMENT1 DA "+
   		" where DR.ObjectType = '"+sObjectType+"' "+
   		"  and DR.ObjectNo = '"+sObjectNo+"' " +
   		" and DR.DocNo = DL.DocNo " +
   		" and DL.DocNo = DA.DocNo " +
   		" order by BeginTime ";
   		
		
	//����DataObject
	ASDataObject doTemp = new ASDataObject(sSql);
	doTemp.setHeader(sHeaders);
	
	//�������ݱ���������
	doTemp.UpdateTable = sTableName;
	doTemp.setKey("DocNo,AttachmentNo,ObjectType,ObjectNo",true);
	doTemp.setVisible("DocNo,AttachmentNo",false);
	
	//�����ֶ���ʾ����˫������ 
	doTemp.setHTMLStyle("BeginTime,UserName,OrgName"," style={width:80px} ondblclick=\"javascript:parent.onDBLClick()\"");
	doTemp.setHTMLStyle("DocType"," style={width:200px} ondblclick=\"javascript:parent.onDBLClick()\"");
	doTemp.setHTMLStyle("FileName,DocTitle,BeginTime"," style={width:120px} ondblclick=\"javascript:parent.onDBLClick()\"");
	
	//����DataWindow
	ASDataWindow dwTemp = new ASDataWindow("bmDocumentList",doTemp,Sqlca);
	
	//����ΪGrid���
	dwTemp.Style="1";
	
	//����Ϊֻ��
	dwTemp.ReadOnly = "1";

	//����HTMLDataWindow
	Vector vTemp = dwTemp.genHTMLDataWindow("");
	for(int i = 0;i < vTemp.size();i++) out.print((String)vTemp.get(i));
	session.setAttribute(dwTemp.Name,dwTemp);
%>

<body class="ListPage" leftmargin="0" topmargin="0" onload="" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
	<tr id="ListTitle" class="ListTitle">
	    <td>
	    </td>
	</tr>
	<tr id="buttonback" class="buttonback">
	<td>
		<table>
			<tr>
				<%
				//xhwang1  2007-04-27  �ύ����ĵ�����ɾ��������
				if(sEditRight.equals("02")&&!sStatus.equals("02"))
				{
				%>
				<td>
					<%=HTMLControls.generateButton("����","�����ĵ�","javascript:my_Add();",sResourcesPath)%>
				</td>

				<%
				}
				%>
				
				<td>
					<%=HTMLControls.generateButton("�鿴����","�鿴������Ϣ","javascript:viewBoard();",sResourcesPath)%>
				</td>
				
				<%
				if(sEditRight.equals("02")&&!sStatus.equals("02"))
				{
				%>
				
				<td>
						<%=HTMLControls.generateButton("ɾ��","ɾ��","javascript:my_Del();",sResourcesPath)%>
				</td>
				<%
				}
				%>
				
				<% if(sObjectType.equals("NPAWardReport"))
				{
				%>
				<td>
					<%=HTMLControls.generateButton("�ر�","�رյ�ǰ����","javascript:Close();",sResourcesPath)%>
				</td>
				<%
				}
				%>
			</tr>
		</table>
	</td>
</tr>
<tr>
	<td >
		<iframe name="myiframe0" width=100% height=100% frameborder=0></iframe>
	</td>
</tr>
</table>

</body>
</html>


<script language=javascript>
	//����
	function my_Add()
	{
		window.open("<%=sWebRootPath%>/PublicInfo/AddDocumentPreMessage.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&rand="+randomNumber(),"_blank","width=500,height=150,top=200,left=170;status:no;center:yes;help:no;minimize:no;maximize:no;border:thin;statusbar:no"); 	
	}
	
	//�鿴��������
	function viewBoard() 
	{
	   	sDocNo=getItemValue(0,getRow(),"DocNo");
	   	sAttachmentNo=getItemValue(0,getRow(),"AttachmentNo");
	   	if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
	   	{
	   		alert(getHtmlMessage('1'));	//����ѡ��һ������
	   	}
	   	else   	
	   		window.open("<%=sWebRootPath%>/PublicInfo/AttachmentView.jsp?DocNo="+sDocNo+"&AttachmentNo="+sAttachmentNo+"&rand="+randomNumber(),"addb","width=700,height=500,left=50,top=50");
	}
	
	//˫������        
	function onDBLClick()
	{
		viewBoard();
	}
	
	function Close()
  {
  	self.close();
  }
	
	//ɾ��
	function my_Del()
	{
		//�ĵ����
		sDocNo=getItemValue(0,getRow(),"DocNo");		
		if (typeof(sDocNo)=="undefined" || sDocNo.length==0)
	   	{
	   		alert(getHtmlMessage('1'));	//����ѡ��һ������
	   	}
	   	else
		{	    
			if(confirm(getHtmlMessage(2)))
			{
				sReturn = self.showModalDialog("<%=sWebRootPath%>/PublicInfo/DelDocAction.jsp?DocNo="+sDocNo+"&rand="+randomNumber(),"","dialogWidth=20;dialogHeight=20;center:no;status:no;statusbar:no");
				if (sReturn=="true")
				{
					alert(getHtmlMessage('7'));	//ɾ���ɹ�
					window.location.reload();
				}
				else
				{
					alert(getHtmlMessage('8'));	//����ʧ��
				}
			}				
		}
  }
  

</script>

<script language=javascript>
	bShowUnloadMessage=false;
	AsOne.AsInit();
	init();
	setPageSize(0,20);
	my_load(2,0,"myiframe0");
</script>

<%@ include file="/IncludeEnd.jsp"%>