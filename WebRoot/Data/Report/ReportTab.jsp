<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main00;Describe=ע����;]~*/%>
	<%
	/*
		Author:   cchang 2004-12-16 20:35
		Tester:
		Content: ��ʾ����ҵ����Ϣ
		Input Param:
            ObjectNo:����
            InspectType:��������
                010	������;����
				020	�����鱨��
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "��ʾ����ҵ����Ϣ"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main02;Describe=�����������ȡ����;]~*/%>
	<%
	//����������	
	String sSerialNo   = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")));
	%>
<%/*~END~*/%>     


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Main03;Describe=�����ǩ;]~*/%>
<script language="JavaScript">
	var tabstrip = new Array();
  	<%
		String sSql = "";
		String sItemName = "";
		String sPurposeInspectItems = "";
		String sTitle="";
	  	String sAddStringArray[] = null;
	  	String sTabStrip[][] = new String[30][3];
		int initTab = 1;//�趨Ĭ�ϵ� tab ����ֵ����ڼ���tab
		String sConfigNo="",sOneKey="";		
		ASResultSet rs=Sqlca.getASResultSet("select ReportConfigNo,OneKey from Batch_Report where SerialNo='"+sSerialNo+"'");
		if(rs.next()){
			sConfigNo=DataConvert.toString(rs.getString(1));
			sOneKey=DataConvert.toString(rs.getString(2));
		}
		rs.getStatement().close();
		//��ȡ
		sSql = "select AttachmentNo,FileName,Attribute1,Attribute2 from Doc_Attachment where DocNo ='"+sConfigNo+"' order by FileName asc";
		rs = Sqlca.getResultSet(sSql);
		int tabs=0;
		int tabsEveryRow=6;//ÿ����ʾ6��
		while(rs.next()){
			sAddStringArray = new String[] {"",rs.getString(2),"doTabAction('"+
					rs.getString(3).replaceAll("#AttachmentNo",rs.getString(1))
						.replaceAll("#Type", rs.getString(4))
						.replaceAll("#OneKey", sOneKey)
						+"')"};
			sTabStrip = HTMLTab.addTabArray(sTabStrip,sAddStringArray);
			tabs++;
		}
		rs.getStatement().close();
		int rows=tabs%tabsEveryRow==0?tabs/tabsEveryRow:tabs/tabsEveryRow+1;
		//�趨����
		sTitle = "������;����";
		//���ݶ��������� tab
		//out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","document.all('tabtd')"));
		out.println(HTMLTab.genTabArray(sTabStrip,"tab_DeskTopInfo","tabtd",tabsEveryRow));
		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=98% height=98%";
		String sTabHeadStyle = "";
		String sTabHeadText = "<br>";
		String sTopRight = "";
		String sTabID = "tabtd";
		String sIframeName = "TabContentFrame";
		String sDefaultPage = sWebRootPath+"/Blank.jsp?TextToShow=���ڴ�ҳ�棬���Ժ�";
		String sIframeStyle = "width=100% height=100% frameborder=0	hspace=0 vspace=0 marginwidth=0	marginheight=0 scrolling=yes";
	%>
</script>
<%/*~END~*/%>


<%/*~BEGIN~���ɱ༭��[Editable=false;CodeAreaID=Main04;Describe=����ҳ��]~*/%>
<html>
<head>
<title><%=sTitle%></title>
</head> 
<body leftmargin="0" topmargin="0" class="pagebackground">
	<%@include file="/Resources/CodeParts/Tab04.jsp"%>
</body>
</html>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main05;Describe=��ͼ�¼�;]~*/%>
	<script language=javascript>
  	function doTabAction(ssOpenUrl)
  	{	
  	  	var sOpenUrl=ssOpenUrl;
  	    sOpenUrl=sOpenUrl.replace(/~/g,"\""); 
  		//sOpenUrl=sOpenUrl.replace(/#TargetJSP/g,"<%="sCurrentItemNo".substring(0,"sCurrentItemNo".length()-3)%>");  
  		//sOpenUrl=sOpenUrl.replace("#AttachmentNo","<%=sConfigNo%>");
  		//sOpenUrl=sOpenUrl.replace("#SerialNo","<%=sSerialNo%>");
		eval(sOpenUrl);
		return true;
  	}
  	
	</script>
<%/*~END~*/%>


<%/*~BEGIN~�ɱ༭��[Editable=true;CodeAreaID=Main06;Describe=��ҳ��װ��ʱִ��,��ʼ��;]~*/%>
	<script language=javascript>
	//���ݶ�����tab�Զ����tr td��ǩ
	function addRow(tdidfortab){//ÿ���һ����Ӱ�ť������һ���ϴ��� 
  		var obj = document.getElementById("tabtid");
  		//table ����һ��tr
  		var r = obj.insertRow(); 
  		//����һ��td
  	    var c =r.insertCell();
  		c.style.backgroundColor="#D8D8AF";
  		c.align="right";
  		c.id=tdidfortab;
  		c.setAttribute("class","tabtd");
  		c =r.insertCell();
  		c.innerHTML+="";
  		c.setAttribute("valign","top");
  		c.setAttribute("class","tabbar");
  	}
	//��ʼ�����з���tab
  	for(var i=0;i<parseInt("<%=rows%>");i++){
  		addRow("tabtd"+i);
  		hc_drawTabToTable("tab_DeskTopInfo"+i,tabs[i],1,document.all('tabtd'+i));
  	}
	//�趨Ĭ��ҳ��
	<%=sTabStrip[initTab-1][2]%>;
	</script>	
<%/*~END~*/%>
	
<%@ include file="/IncludeEnd.jsp"%>