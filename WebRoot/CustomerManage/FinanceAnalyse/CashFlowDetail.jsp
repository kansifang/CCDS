<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>


<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=Info00;Describe=ע����;]~*/%>
	<% 
	/*
		Author: 
		Tester:
		Describe: ��ʾ�ͻ���ص��ֽ���Ԥ��
		Input Param:
	        CustomerID �� ��ǰ�ͻ����
			BaseYear   : ��׼���:�������������һ��  
			YearCount  : Ԥ������:default=1
			ReportScope: ����ھ�
		Output Param:
			
		HistoryLog:
		DATE	CHANGER		CONTENT
		2005-7-22 fbkang    �µİ汾�ĸ�д
	 */
%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ��ֽ�����������"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%
    //�������
    ASResultSet rs = null;
	String sCustomerName = "",sReportScopeName="";
    //���ҳ�����
	String sCustomerID  = DataConvert.toRealString(CurPage.getParameter("CustomerID"));
	String sBaseYear    = DataConvert.toRealString(CurPage.getParameter("BaseYear"));
	sBaseYear = sBaseYear.substring(0,4);//�����ַ���ת������double��ת��ΪIntegerʱ�ᱨ��
	String sYearCount   = DataConvert.toRealString(CurPage.getParameter("YearCount"));
	String sReportScope = DataConvert.toRealString(CurPage.getParameter("ReportScope"));
    //����������
%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=��ñ���ֵ;]~*/%>
<%
	rs = Sqlca.getResultSet("select EnterpriseName from ent_info where CustomerID = '" + sCustomerID + "' ");
	if(rs.next())
		sCustomerName = rs.getString(1);
	rs.getStatement().close();
	rs = Sqlca.getResultSet("select getItemName('ReportScope','"+sReportScope+"') from role_info ");
	if(rs.next())
		sReportScopeName = rs.getString(1);
	rs.getStatement().close();


	String sYear1,sYear2,sYear3,sYear4,sYear5,sMonth1,sMonth2,sMonth3,sMonth4,sMonth5;

	sYear1 = sBaseYear;														//ǰһ��
	sMonth1 = sYear1 + "/12";
	sYear2 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 1);		//ǰ����
	sMonth2 = sYear2 + "/12";
	sYear3 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 2);		//ǰ����
	sMonth3 = sYear3 + "/12";
	sYear4 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 3);		//ǰ����
	sMonth4 = sYear4 + "/12";
	sYear5 = String.valueOf(Integer.valueOf(sBaseYear).intValue() - 4);		//ǰ����
	sMonth5 = sYear5 + "/12";

	String sSql = "",sMessage = "";
	//5
	sSql = 	"select count(*) from customer_fsrecord " +
			" where CustomerID = '" + sCustomerID + "' and reportdate ='" + sMonth5 + "' and ReportScope = '" + sReportScope + "' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth5+"��"+sReportScopeName+"����";
	rs.getStatement().close();
	//4
	sSql = 	"select count(*) from customer_fsrecord " +
			" where CustomerID = '" + sCustomerID + "' and reportdate ='" + sMonth4 + "' and ReportScope = '" + sReportScope + "' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth4+"��"+sReportScopeName+"����";
	rs.getStatement().close();
	//3
	sSql = 	"select count(*) from customer_fsrecord " +
			" where CustomerID = '" + sCustomerID + "' and reportdate ='" + sMonth3 + "' and ReportScope = '" + sReportScope + "' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth3+"��"+sReportScopeName+"����";
	rs.getStatement().close();
	//2
	sSql = 	"select count(*) from customer_fsrecord " +
			" where CustomerID = '" + sCustomerID + "' and reportdate ='" + sMonth2 + "' and ReportScope = '" + sReportScope + "' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth2+"��"+sReportScopeName+"����";
	rs.getStatement().close();
	//1
	sSql = 	"select count(*) from customer_fsrecord " +
			" where CustomerID = '" + sCustomerID + "' and reportdate ='" + sMonth1 + "' and ReportScope = '" + sReportScope + "' ";
	rs = Sqlca.getResultSet(sSql);
	if(rs.next() && rs.getInt(1)==0) sMessage += "&nbsp;"+ sMonth1+"��"+sReportScopeName+"����";
	rs.getStatement().close();
%>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List04;Describe=�������ݶ���;]~*/%>
<%
	String sHeaders1[][] =
	{
		{"ParameterCode","����ָ���"},
		{"ParameterName","��������"},
		{"Value1","ǰһ��"},
		{"Value2","ǰ����"},
		{"Value3","ǰ����"},
		{"Value4","ǰ����"},
		{"Value5","ǰ����"},
		{"Valuea","ƽ��ֵ"},
		{"Value0","�ٶ�ֵ"},
		{"name1","��������"}
	};

	sHeaders1[2][1]=sMonth1;
	sHeaders1[3][1]=sMonth2;
	sHeaders1[4][1]=sMonth3;
	sHeaders1[5][1]=sMonth4;
	sHeaders1[6][1]=sMonth5;

	sSql = 	"select CustomerID,BaseYear,ReportScope,ParameterNo,"+
			" ParameterCode,ParameterName,Value5,Value4,Value3,Value2,Value1,Valuea,Value0,ParameterName as name1 "+
			"  from CashFlow_Parameter " +
			" where CustomerID = '" + sCustomerID + "' " +
			"   and BaseYear = " + sBaseYear +
			//"   and ParameterNo >= 0 " +
			"   and ParameterNo >= 1 " +
			" order by ParameterNo";

	//ͨ��sql�������ݴ������
	ASDataObject doPara = new ASDataObject(sSql);
	//���ñ�ͷ
	doPara.setHeader(sHeaders1);
	doPara.UpdateTable = "CashFlow_Parameter";
	doPara.setKey("CustomerID,BaseYear,ReportScope,ParameterNo",true);
	//doPara.setRequired("Value0",true); //ͨ��js�Լ��ж������Ƿ���ȫ
	doPara.setReadOnly("ParameterCode,ParameterName,Value5,Value4,Value3,Value2,Value1,Valuea,name1",true);
	doPara.setVisible("CustomerID,BaseYear,ReportScope,ParameterNo,ParameterCode,name1",false);

	//����html��ʽ
	/*
	doPara.setHTMLStyle("ParameterCode"," style={width:80px} ");
	doPara.setHTMLStyle("ParameterName,name1"," style={width:380px} ");
	doPara.setHTMLStyle("Value5,Value4,Value3,Value2,Value1,Valuea"," style={width:80px} ");
	doPara.setHTMLStyle("Value0"," style={width:80px;background-color:#88FFFF;color:black} ");
	*/
	doPara.setHTMLStyle("ParameterCode"," style={width:60px} ");
	doPara.setHTMLStyle("ParameterName,name1"," style={width:280px} ");
	doPara.setHTMLStyle("Value5,Value4,Value3,Value2,Value1,Valuea"," style={width:60px} ");
	doPara.setHTMLStyle("Value0"," style={width:80px;background-color:#88FFFF;color:black} ");

	doPara.setAlign("Value5,Value4,Value3,Value2,Value1,Valuea,Value0","3");
	doPara.setType("BaseYear,ParameterNo,Value5,Value4,Value3,Value2,Value1,Valuea,Value0","Number");
	//doPara.setCheckFormat("Value5,Value4,Value3,Value2,Value1,Valuea,Value0","2");


	//����ASDataWindow����
	ASDataWindow dwPara = new ASDataWindow(CurPage,doPara,Sqlca);
	dwPara.Style="1";      //����ΪGrid���
	dwPara.ReadOnly = "0"; //����Ϊֻ��
	Vector vPara = dwPara.genHTMLDataWindow("");
	for(int i=0;i<vPara.size();i++) out.print((String)vPara.get(i));
	session.setAttribute(dwPara.Name,dwPara);

	String sHeaders2[][] =
	{
		{"ItemNo","ָ����"},
		{"ItemName","ָ��"},
		{"ItemValue","δ��1��ָ��ֵ"}
	};

	sSql = 	"select ItemNo,ItemName,ItemValue "+
		"  from CashFlow_Data " +
                " where CustomerID = '" + sCustomerID + "' "+
		"   and BaseYear = " + sBaseYear +
		"   and FCN = " + sYearCount +
		" order by ItemNo";

	//ͨ��sql�������ݴ������
	ASDataObject doData = new ASDataObject(sSql);
	//���ñ�ͷ
	doData.setHeader(sHeaders2);

	//����html��ʽ

	doData.setHTMLStyle("ItemNo"," style={width:80px} ");
	doData.setHTMLStyle("ItemName"," style={width:200px} ");
	doData.setAlign("ItemValue","3");
	doData.setType("ItemValue","Number");
	doData.setAlign("ItemNo","2");
	doData.setType("ItemNo","Integer");//by jgao ������ʾ

	//����ASDataWindow����
	ASDataWindow dwData = new ASDataWindow(CurPage,doData,Sqlca);
	dwData.Style="1";      //����ΪGrid���
	dwData.ReadOnly = "1"; //����Ϊֻ��
	Vector vData = dwData.genHTMLDataWindow("");
	for(int i=0;i<vData.size();i++) out.print((String)vData.get(i));
%>
<script language=javascript>
	AsOne.AsInit();
</script>
<%/*~END~*/%>

<html>
<head>
<title>�ֽ�����Ԥ��</title>
</head><body bgcolor="#DEDFCE" leftmargin="0" topmargin="0" onload="" >
<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr height=1 valign=top bgcolor='#DEDFCE'>
    <td>
    	<table>
	    	<tr>
       		<td>
              <%=HTMLControls.generateButton("�ֽ���Ԥ��","�����ֽ���Ԥ��","javascript:my_compute()",sResourcesPath)%>
    		</td>
       		<td>
              <%=HTMLControls.generateButton("ת�������ӱ��","ת�������ӱ��","javascript:my_export()",sResourcesPath)%>
    		</td>
       		<td>
              <%=HTMLControls.generateButton("����","�����ֽ���Ԥ���б�","javascript:my_close()",sResourcesPath)%>
    		</td>
    		</tr>
    	</table>
    </td>
</tr>
<tr height=1 valign=top >
	<td style="font-size:9.0pt">&nbsp�ͻ����ƣ�<%=sCustomerName%> </td>
</tr>
<tr height=1 valign=top >
	<td style="font-size:9.0pt">&nbsp����ھ���<%=sReportScopeName%> &nbsp;&nbsp;��λ���������Ԫ &nbsp;&nbsp;<font color=red>ע�⣺<%=sMessage%></font></td>
</tr>
<tr height=1 valign=top >
	<td style="font-size:9.0pt;">&nbsp��ʾ������˰�ʵļٶ�ֵ��Ҫ�ο��˶�������˰�ʣ���Ϣծ���ܶ�ļٶ�ֵ�����һ���Ϊ�ο�����</td>
</tr>

<tr height=1 valign=top align=center>
	<td style="font-size:12.0pt;font-weight:600;">&nbsp�ֽ�����Ԥ�����ѡ��</td>
</tr>
<tr>
    <td>
	<iframe name="myiframe0" width=100% height=100% frameborder=0></iframe>
    </td>
</tr>
<tr height=1 valign=top align=center>
	<td style="font-size:12.0pt;font-weight:600;">&nbsp�ֽ�����Ԥ���</td>
</tr>
<tr>
    <td>
	<iframe name="myiframe1" width=100% height=100% frameborder=0></iframe>
    </td>
</tr>
</table>

</body>
</html>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List05;Describe=�Զ��庯��;]~*/%>
<script language="JavaScript">
   //---------------------���尴ť�¼�------------------------------------
   /*~[Describe=���������ӱ��;InputParam=�����¼�;OutPutParam=��;]~*/
	function my_export()
	{
		var mystr = my_load_save(2,0,"myiframe1");
		spreadsheetTransfer(mystr);
	}
    /*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function my_compute()
	{
		for(ii=0;ii<getRowCount(0);ii++)
		{
			if(getItemValue(0,ii,"Value0")+"A"=="A")
			{
				alert("�������"+(parseInt(ii,10)+1)+"�У���"+getItemValue(0,ii,"ParameterName")+"���ļٶ�ֵ��");
				return;
			}
		}
		as_save('myiframe0','my_compute2()');
	}
	/*~[Describe=�򿪴���;InputParam=��;OutPutParam=��;]~*/
	function my_compute2()
	{
		OpenPage("/CustomerManage/FinanceAnalyse/CashFlowCompute.jsp?CustomerID=<%=sCustomerID%>&YearCount=<%=sYearCount%>&ReportScope=<%=sReportScope%>&BaseYear=<%=sBaseYear%>","_self");
	}
    /*~[Describe=�رմ���;InputParam=��;OutPutParam=��;]~*/
	function my_close()
	{
		OpenPage("/CustomerManage/FinanceAnalyse/CashFlowList.jsp?","_self","");
	}

	function mySelectRow()
	{
		//demo code
		//if(myiframe0.event.srcElement.tagName=="BODY") return;
		//setColor();
		//if(myiframe1.event.srcElement.tagName!="") return;
	}

</script>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=��ҳ���һЩ����;]~*/%>

<script language=javascript>
	bSavePrompt = false;
	bHighlight = false;
	init();

	//��Ҫ����
	needReComputeIndex[0]=0;
	needReComputeIndex[1]=0;   
	
	my_load(2,0,'myiframe0',1);  //1 for change
	my_load(2,0,'myiframe1');
	AsMaxWindow();
	for(ii=0;ii<getRowCount(0);ii++)
		getASObject(0,ii,"Value0").style.cssText = getASObject(0,ii,"Value0").style.cssText + ";width:80px;background-color:#88FFFF;color:black";
	//setItemFocus(0,0,'Value0');

	//����func,Ϊ�˿����븺��
	function reg_Num(str)
	{
		var Letters = "-1234567890.,";
		var j = 0;
		if(str=="" || str==null) return true;
		for (i=0;i<str.length;i++)
		{
			var CheckChar = str.charAt(i);
			if (Letters.indexOf(CheckChar) == -1){return false;}
			if (CheckChar == "."){j = j + 1;}
		}
		if (j > 1){return false;}

		return true;
	}

	document.frames("myiframe1").document.body.onmousedown = Function("return false;");
	document.frames("myiframe1").document.body.onKeyUp = Function("return false;");
	
</script>
<%/*~END~*/%>
<%@ include file="/IncludeEnd.jsp"%>
