<%@page import="java.lang.reflect.Array"%>
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
	String sSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")));
	String sConfigNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportConfigNo")));
	String sOneKey   =DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("OneKey")));	
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
		//��ǩ�����ڵļ�¼ parentAttachmentNo=attachmentNo
		sSql = "select AttachmentNo,Attribute4 from Doc_Attachment where DocNo ='"+sConfigNo+"' and nvl(AttachmentNo,'')=nvl(ParentAttachmentNo,'') order by Attribute4 asc";
		ASResultSet rs = Sqlca.getResultSet(sSql);
		int tabs=0;
		int tabsEveryRow=6;//ÿ����ʾ6��
		while(rs.next()){
			String sPatentAttachmentNo=rs.getString(1);
			String sTabName=rs.getString(2);
			sSql = "select replace(Attribute1,'#AttachmentNo',AttachmentNo) "+//AttachmentNo������ҳ���SQL
					" from Doc_Attachment where DocNo ='"+sConfigNo+"'"+
					" and nvl(ParentAttachmentNo,'')='"+sPatentAttachmentNo+"' order by FileName asc";
			String[]sAURLS=Sqlca.getStringArray(sSql);
			String sURLS=StringFunction.toArrayString(sAURLS,"@");
			sAddStringArray = new String[]{"",sTabName,
					"doTabAction('"+
						sURLS.replaceAll("#OneKey", sOneKey)//����͵�ǰ�����������
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
		String sTableStyle = "align=center cellspacing=0 cellpadding=0 border=0 width=100% height=100%";
		String sTabHeadStyle = "";
		String sTabHeadText = "�������";
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
  	  	var ssOpenUrl=ssOpenUrl.replace(/~/g,"\"");
  	  	var sOpenUrl=ssOpenUrl.split("@");
  		eval(sOpenUrl[0]);
  		//�и���ҳ��������
  		var OpenStyle="width="+(sScreenWidth*0.6)+"px,height="+sScreenHeight*0.8+"px,top=0,right=0,toolbar=no,scrollbars=yes,resizable=yes,status=no,menubar=no";
  		if(sOpenUrl.length>1){
  			for(var i=1;i<sOpenUrl.length;i++){
				var xxx=sOpenUrl[i].replace("<%=sIframeName%>",""+i).replace("#style",OpenStyle);
  				eval(xxx);
  			}
  		}
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
  		c.align="left";
  		c.id=tdidfortab;
  		//c.colspan="2";
  		c.width="100%";
  		//c.setAttribute("class","tabtd");
  		//c.setAttribute("colspan","3");
  		/*��ǩ�в�һ����Ԫ������������
  		c =r.insertCell();
  		c.innerHTML+="ccc";
  		c.setAttribute("valign","top");
  		c.setAttribute("class","tabbar");
  		*/
  	}
	//��ʼ�����з���tab,ÿһ��tabsһ�� <table></table>
  	for(var i=0;i<parseInt("<%=rows%>");i++){
  		addRow("tabtd"+i);
  		hc_drawTabToTable("tab_DeskTopInfo"+i,tabs[i],1,document.all('tabtd'+i));
  	}
	//�趨Ĭ��ҳ��
	<%=sTabStrip[initTab-1][2]%>;
	</script>	
<%/*~END~*/%>
	
<%@ include file="/IncludeEnd.jsp"%>