<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>
<%@page import="com.amarsoft.biz.finance.*" %>

<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/%>
	<% 
	/*
		Author: RCZhu  2004-12-16 20:15
		Tester:
		Describe: ��ʾ�Ͳ���ָ��������ˮ�ŵĲ��񱨱�
		Input Param:
			ReportNo�� ָ��������ˮ��
			Operation: ��������
		Output Param:��	
	
		HistoryLog:
	 */
	%>
<%/*~END~*/%>
<%/*~BEGIN~���ɱ༭��~[Editable=true;Describe=��̬������;]~*/%>
	<span id="waitingInfo" style="display:none">
	<table align="center"><tr><td>
	���ڴ�������, ���Ժ�......
	<div style="font-size:2pt;padding:2px;border:solid black 1px">
	<span id="progress1">&nbsp; &nbsp;</span>
	<span id="progress2">&nbsp; &nbsp;</span>
	<span id="progress3">&nbsp; &nbsp;</span>
	<span id="progress4">&nbsp; &nbsp;</span>
	<span id="progress5">&nbsp; &nbsp;</span>
	<span id="progress6">&nbsp; &nbsp;</span>
	<span id="progress7">&nbsp; &nbsp;</span>
	<span id="progress8">&nbsp; &nbsp;</span>
	<span id="progress9">&nbsp; &nbsp;</span>
	<span id="progress10">&nbsp; &nbsp;</span>
	<span id="progress11">&nbsp; &nbsp;</span>
	<span id="progress12">&nbsp; &nbsp;</span>
	<span id="progress13">&nbsp; &nbsp;</span>
	<span id="progress14">&nbsp; &nbsp;</span>
	<span id="progress15">&nbsp; &nbsp;</span>
	<span id="progress16">&nbsp; &nbsp;</span>
	<span id="progress17">&nbsp; &nbsp;</span>
	<span id="progress18">&nbsp; &nbsp;</span>	
	</div>
	</td></tr></table>
	</span>
<%/*~END~*/%>
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/%>
	<%
	String PG_TITLE = "�ͻ����ڲ��񱨱�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%/*~END~*/%>
<script language=javascript src="<%=sResourcesPath%>/financecheck.js"></script>

<style type="text/css">
<!--
.thisinput {border-style:none;border-width:thin;border-color:#e9e9e9}
.thistable {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}
.thistd {  border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px}
.thisinputnumber {border-style:none;border-width:thin;border-color:#e9e9e9;text-align:right;}
.FSPage{background-color:#DCDCDC;background-image:url(GridBG_everbright.gif);margin-top:0px;margin-left:0px;margin-bottom:0px;margin-right:0px;}
.FSTable{}
.FSHeaderTR{text-align:left;}
.FSHeaderTDText{background-color:#CCC8EB;background-image:url(FSHeaderBG.gif);height:24px;color:black;padding-left:2px;}
.FSTR{}
.FSTD{}
.FSInput1{border-style:none;border-color:#e9e9e9;background-color:#F6F5FA;}
.FSInput2{border-style:none;border-color:#e9e9e9;background-color:#EDEBF6;}
.FSInputNumber1{border-style:none;border-color:#e9e9e9;text-align:right;background-color:#F6F5FA;}
.FSInputNumber2{border-style:none;border-color:#e9e9e9;text-align:right;background-color:#EDEBF6;}
.FSInputNote1{border-style:none;border-color:#e9e9e9;color:red;text-align:right;background-color:#F6F5FA;}
.FSInputNote2{border-style:none;border-color:#e9e9e9;color:red;text-align:right;background-color:#EDEBF6;}
.FSHighLightInput{border-style:none;border-color:#DCDCDC;text-align:right;background-color:#DCDCDC;}
-->
</style> 
<%/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/%>
<%

	//�������
	int i = 0,iColCount = 0,iHalfRowCount = 0;
	String sAlertStirng = "",sCustomerName = "";
	String sCreditColumn1Value = "",sCreditColumn2Value = "",sDebitColumn1Value = "",sDebitColumn2Value = "";
	String[] sTitle = null;
	Report rReport = null;
	double dDiff1 = 0.00,dDiff2 = 0.00;
	String sStyle = "";
	boolean isEditable=true;
		
	//����������
	String sReportNo = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("ReportNo"));
	String sRole = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Role"));
	String sCustomerID =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	String sRecordNo =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("RecordNo"));
	String sEditable =  DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("Editable"));
	if("false".equals(sEditable))isEditable=false;

	//����ֵת��Ϊ���ַ���
	if(sReportNo == null) sReportNo = "";
	if(sRole == null) sRole = "";
	if(sCustomerID == null) sCustomerID = "";	
	if(sRecordNo == null) sRecordNo = "";
	
	//���ҳ�����
	String sOperation = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Operation"));
	//����ֵת��Ϊ���ַ���
	if(sOperation == null) sOperation="";
	
	rReport = new Report(sReportNo,Sqlca);
	
	//��ÿͻ�����
	ASResultSet rsTemp = Sqlca.getResultSet("select CustomerName from CUSTOMER_INFO where CustomerID='"+rReport.ObjectNo+"'");
	if(rsTemp.next()) sCustomerName = rsTemp.getString(1);
	rsTemp.getStatement().close();
	
	String sReportUnitName = "Ԫ";
	rsTemp = Sqlca.getResultSet("select ItemName from CODE_LIBRARY where CodeNo='ReportUnit' and ItemNo='"+rReport.ReportUnit+"' and IsInUse = '1' ");
	if(rsTemp.next()) sReportUnitName = rsTemp.getString(1);
	rsTemp.getStatement().close();
	
	String sReportPeriodName = "";
	rsTemp = Sqlca.getResultSet("select getItemName('ReportPeriod',ReportPeriod) from CUSTOMER_FSRECORD where CustomerID='"+rReport.ObjectNo+"' and ReportDate = '"+rReport.ReportDate+"'");
	if(rsTemp.next()) sReportPeriodName = rsTemp.getString(1);
	rsTemp.getStatement().close();
	
	//ȡ���񱨱���
	String sModelNo = "";
	rsTemp = Sqlca.getResultSet("select ModelNo from REPORT_RECORD where ReportNo= '"+sReportNo+"'");
	if(rsTemp.next()) sModelNo = rsTemp.getString(1);
	rsTemp.getStatement().close();
	
%>
<%/*~END~*/%>

<%
	if(sOperation.equals("delete"))
	{
		rReport.delete();
		%> 
		<script language=javascript>
			alert("����ɾ���ɹ�");
			window.close();
		</script>
		<%
	}else if( sOperation.equals("save"))
	{
		rReport.updateRows(request);
		rReport.save();	
		String sSqlu="Update CUSTOMER_FSRECORD set OrgID='"+CurOrg.OrgID+"',UserID='"+CurUser.UserID+"',UpdateDate='"+StringFunction.getToday()+"' where RecordNo='"+sRecordNo+"'";
		Sqlca.executeSQL(sSqlu);
		sAlertStirng = "������ɹ�";
		%>
		<script language=javascript>
			alert("<%=sAlertStirng%>");
		</script>
		<%	
	}else if(sOperation.equals("calc")) 
	{
		if("0009".equals(sModelNo) || "0199".equals(sModelNo) || "0509".equals(sModelNo))//����ָ���0509
		{
			String sSqlu = "Update CUSTOMER_FSRECORD set ReportFlagZB ='1'  where RecordNo='"+sRecordNo+"'";
    		Sqlca.executeSQL(sSqlu);
		}
		
		rReport.updateRows(request);
		rReport.calculate();
		//�ж��Ƿ�Ϊ�ʲ���ծ��΢С�ʲ���ծ����������ƽ��У��
		if(rReport.getReportRowBySubject("804")==null||rReport.getReportRowBySubject("807")==null)
		{
			
			String sSqlu="Update CUSTOMER_FSRECORD set  OrgID='"+CurOrg.OrgID+"',UserID='"+CurUser.UserID+"',UpdateDate='"+StringFunction.getToday()+"' where RecordNo='"+sRecordNo+"'";
    		Sqlca.executeSQL(sSqlu);
    		if("0501".equals(sModelNo))
			{
				sSqlu = "Update CUSTOMER_FSRECORD set ReportFlag ='1'  where RecordNo='"+sRecordNo+"'";
	    		Sqlca.executeSQL(sSqlu);
			}
    		sAlertStirng = "�������ɹ�";
		}else
		{
			//ȡ�����ʲ�
			sCreditColumn1Value = rReport.getReportRowBySubject("804").ColDisplay[0]; //�ڳ���
			sCreditColumn2Value = rReport.getReportRowBySubject("804").ColDisplay[1]; //��ĩ��
			//ȡ���ܸ�ծ
			sDebitColumn1Value = rReport.getReportRowBySubject("809").ColDisplay[0]; //�ڳ���
			sDebitColumn2Value = rReport.getReportRowBySubject("809").ColDisplay[1]; //��ĩ��

			//�ڳ����Ƚ�
			dDiff1 = Double.parseDouble(sCreditColumn1Value) - Double.parseDouble(sDebitColumn1Value);
			//��ĩ���Ƚ�
			dDiff2 = Double.parseDouble(sCreditColumn2Value) - Double.parseDouble(sDebitColumn2Value);
			
			if(sReportUnitName.equals("Ԫ")){
				if(Math.abs(dDiff1) > 0.01 )
				{
					if("0501".equals(sModelNo))
					{
						sAlertStirng = sAlertStirng+"�������ծ���ʲ�С"+dDiff1;
					}else{
						sAlertStirng = sAlertStirng+"���ֵ����ծ���ʲ�С"+dDiff1;
					}
				}
				if(Math.abs(dDiff2) > 0.01 )
				{
					if("0501".equals(sModelNo))
					{
						sAlertStirng = "  "+sAlertStirng+"    ��ʵ����ծ���ʲ�С"+dDiff2;
					}else{
				   		sAlertStirng = "  "+sAlertStirng+"    ��ĩֵ����ծ���ʲ�С"+dDiff2;
					}
				}
			}else{

				if(Math.abs(dDiff1) > 0.00001 )
				{
					if("0501".equals(sModelNo))
					{
						sAlertStirng = sAlertStirng+"�������ծ���ʲ�С"+dDiff1;
					}else{
						sAlertStirng = sAlertStirng+"���ֵ����ծ���ʲ�С"+dDiff1;
					}
				}
				if(Math.abs(dDiff2) > 0.00001 )
				{
					if("0501".equals(sModelNo))
					{
						sAlertStirng = "  "+sAlertStirng+"    ��ʵ����ծ���ʲ�С"+dDiff2;
					}else{
				   		sAlertStirng = "  "+sAlertStirng+"    ��ĩֵ����ծ���ʲ�С"+dDiff2;
					}
				}
			}
			
			if(sAlertStirng==null||sAlertStirng.equals(""))
			{
				if("0001".equals(sModelNo) || "0191".equals(sModelNo)||"0501".equals(sModelNo) )
				{
					String sSqlu = "Update CUSTOMER_FSRECORD set ReportFlag ='1'  where RecordNo='"+sRecordNo+"'";
		    		Sqlca.executeSQL(sSqlu);
				}
	    		
				sAlertStirng = "����ƽ�⣡";
			}else
			{
				sAlertStirng = "����ƽ��!  "+sAlertStirng;
			}
		}
		%>
		<script language=javascript>
			alert("<%=sAlertStirng%>");
		</script>
		<%
	}
	
	// ��ñ�����ʾ��ʽ

	if(rReport.DisplayMethod.equals("1")) iColCount = 4; // ����
	else if (rReport.DisplayMethod.equals("2"))  iColCount = 8; // ˫��
	else iColCount = 3;  // ����
	
	sTitle = new String[iColCount];
	
	//��ñ�ͷ
	StringTokenizer st = new StringTokenizer(rReport.HeaderMethod,"&");
	while (st.hasMoreTokens())
	{
		sTitle[i++] = st.nextToken("&");	
	}

	%>


<body leftmargin="0" topmargin="0" bgcolor="#FFFFFF" <%=sStyle%>>
<table id="amarhidden" cellpadding="0" cellspacing="0" border="0" width="100%" height="100%">
  <tr>
  <td>
  <table>
    <tr> 
    <td width="1" height="17">&nbsp; </td>
    <td align="left" width="450" height="17" bgcolor="#FFFFFF"> 
     <%=sCustomerName+" >> "+rReport.ReportDate+" >> "+rReport.ReportName+"   ��λ:"+(rReport.ModelNo.equals("0009")||rReport.ModelNo.equals("0199")?"&#37":sReportUnitName)+"  >>  "+sReportPeriodName%>&nbsp;</td>
    <td align="right" width="560" height="17"> 
      <table width="300" border="0" cellspacing="0" cellpadding="0" height="30">
        <tr>
        <%
            if(sRole.equals("has"))
            {
            	if(isEditable){
        %>
          <!--<td>
						<%=HTMLControls.generateButton("��&nbsp;��","������񱨱�����","javascript:importReport()",sResourcesPath)%>
		  </td>-->
          <td>
						<%=HTMLControls.generateButton("��&nbsp;��","������񱨱�","javascript:saveReport()",sResourcesPath)%>
		  </td>
		  <td>
						<%=HTMLControls.generateButton("��&nbsp;��","������񱨱�","javascript:calcReport()",sResourcesPath)%>
		  </td>
		  <%
		      if(rReport.ModelNo.equals("0008")){	
		   %>
		  <td>
						<%=HTMLControls.generateButton("У���ֹ�����(�ȱ���)","У���ֹ�����","javascript:verifyReport()",sResourcesPath)%>
		  </td>		  
		  
		  <% }
		  		}
            }%>
		  <td>
						<%=HTMLControls.generateButton("ת�������ӱ��","ת�������ӱ��","javascript:spreadsheetTransfer(formatContent());",sResourcesPath)%>
		  </td>
		  <td>&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>

   <!--    <td>&nbsp; &nbsp; &nbsp;<a href="javascript:deleteReport();"> ɾ�� </a>&nbsp; &nbsp; &nbsp; </td>
        
          <td>&nbsp; &nbsp; &nbsp;<a href="javascript:closeSelf()">�ر� </a>&nbsp; &nbsp; &nbsp;</td>
   -->          
        </tr>
      </table>
      
    </td>
    <td align="center" colspan="2" height="17" width="1">&nbsp; </td>
  </tr>
  <tr> 
    <td width="1"></td>
    <td align="left" colspan="4" valign="top"> 
      
        <!-- ������ʾ -->
        <form name="report" Method="post" action="" >
          <table border=1 cellpadding=0 cellspacing=0 align="center" class="thistable">
   	  <input type=hidden name="Operation" value="">
   	  <input type=hidden name=CompClientID value='<%=sCompClientID%>'>
        <!-- ��ʾ��ͷ --> 
            <tr align="center" bgcolor="#CCCCCC"> 
          
<%
	
	for(i=0;i<iColCount;i++)
	{	
%>
	 	<td class="thistd" nowrap><%=sTitle[i]%></td>
<%
	}
%>
			</tr>
<%    
     
     	String sRowAttribute,sStyle1,sStyle2,sReadOnly1,sReadOnly2,sNameC,sNameC2,sName1,sName2,sName3,sName4;
     	String sCol1Value,sCol2Value;
     	
	// ���ɱ�����ÿ���ֶε�����
	if (rReport.DisplayMethod.equals("1") || rReport.DisplayMethod.equals("3"))
	{
		// ����/������ʾ
		
		for(i=0;i<rReport.ReportRows.length;i++)
		{ 
		      
		      sRowAttribute = DataConvert.toString(rReport.ReportRows[i].RowAttribute);
		      sStyle1 = StringFunction.getProfileString(sRowAttribute,"style");
		      sReadOnly1 = StringFunction.getProfileString(sRowAttribute,"readonly");
		      sReadOnly1= sReadOnly1.trim().equals("true")?"readonly":"";
		      if (sStyle1.equals("")) sStyle1 = "thisinput";
		      
		      sNameC = "R" + String.valueOf(i+1) + "CC";
		      sName1 = "R" + String.valueOf(i+1) + "C1";
		      sName2 = "R" + String.valueOf(i+1) + "C2";
		      
		    //add by lpzhang 2010-5-26 �޸Ĳ��񱨱���ʾ0.00�����
       		  String s1="",s2="";
        	  if((rReport.ReportRows[i].ColDisplay[0]==null || rReport.ReportRows[i].ColDisplay[0].equals("") || DataConvert.toHTMLMoney(rReport.ReportRows[i].ColDisplay[0]).equals("0.00")) &&   sStyle1.equals("thisinput"))
        		  s1="";
        	  else
        	      s1 =DataConvert.toHTMLMoney(rReport.ReportRows[i].ColDisplay[0]);
        	  //-----------------------------------------
        	  if((rReport.ReportRows[i].ColDisplay[1]==null || rReport.ReportRows[i].ColDisplay[1].equals("") || DataConvert.toHTMLMoney(rReport.ReportRows[i].ColDisplay[1]).equals("0.00"))  && sStyle1.equals("thisinput"))
        		  s2="";
        	  else
        	      s2 =DataConvert.toHTMLMoney(rReport.ReportRows[i].ColDisplay[1]);

		      
		      if( rReport.DisplayMethod.equals("1"))
		      {
		      %> 
		            <tr align="center"> 
		              <td class="thistd"  width=216 style="<%=sStyle1%>" align=left wrap > 
		              	<%=StringFunction.replace(DataConvert.toString(rReport.ReportRows[i].RowName)," ","&nbsp;")%>
		                <input class="thisinput" style="<%=sStyle1%>" type=hidden readonly size="36" value='<%=DataConvert.toString(rReport.ReportRows[i].RowName)%>' title='<%=DataConvert.toString(rReport.ReportRows[i].RowName)%>' name=<%=sNameC%> >
		              </td>
		              <td class="thistd" > 
		                <input class="thisinput" style="<%=sStyle1%>;width=100px" type=text readonly size="4"  value='<%=i+1%>' name="text2">
		              </td>
		              <td class="thistd"> 
		                <input class="thisinputnumber" onKeyDown="gridValueChange()"  onblur="javascript:amarMoneyControl('<%=sName1%>');unsetHighLight(this);" <%=sReadOnly1%> onfocus="setHighLight(this);" style="<%=sStyle1%>" type=text  size="18" onKeyUp="moveFocus('<%=sName1%>')" name=<%=sName1%> value='<%=s1%>'>
		              </td>
		              <td class="thistd"> 
		                <input class="thisinputnumber" onKeyDown="gridValueChange()"  onblur="javascript:amarMoneyControl('<%=sName2%>');unsetHighLight(this);" <%=sReadOnly1%> onfocus="setHighLight(this);" style="<%=sStyle1%>" type=text  size="18" onKeyUp="moveFocus('<%=sName2%>')" name=<%=sName2%> value='<%=s2%>'>
		              </td>
		            </tr>
		      <%
		      } 
		      if( rReport.DisplayMethod.equals("3"))
		      {
		      %> 
		            <input class="thisinput" style="<%=sStyle1%>" type=hidden  size="18" name=<%=sName1%> value='<%=DataConvert.toMoney(rReport.ReportRows[i].ColDisplay[0])%>'>         
		            <tr align="center"> 
		              <td class="thistd" width=288 style="<%=sStyle1%>" align=left wrap > 
<%=StringFunction.replace(DataConvert.toString(rReport.ReportRows[i].RowName)," ","&nbsp;")%>
<input class="thisinput" style="<%=sStyle1%>" type=hidden readonly size="48" value='<%=DataConvert.toString(rReport.ReportRows[i].RowName)%>' name=<%=sNameC%> >
		              </td>
		              <td class="thistd" > 
		                <input class="thisinput" style="<%=sStyle1%>;width=80px" type=text readonly size="4"  value='<%=i+1%>' name="text2">
		              </td>
		              <td class="thistd"> 
		                <input class="thisinputnumber" onKeyDown="gridValueChange()"  onblur="javascript:amarMoneyControl('<%=sName2%>');unsetHighLight(this);" <%=sReadOnly1%> onfocus="setHighLight(this);" style="<%=sStyle1%>" type=text  size="18" onKeyUp="moveFocus('<%=sName2%>')" name=<%=sName2%> value='<%=s2%>'>
		              </td>
		            </tr>
		      <%
		      } 
		}
	
	}else// ˫����ʾ
	{ 
		iHalfRowCount = rReport.ReportRows.length/2;
		for(i=0;i<iHalfRowCount;i++)
		{ 
		      sRowAttribute = DataConvert.toString(rReport.ReportRows[i].RowAttribute);
		      sStyle1 = StringFunction.getProfileString(sRowAttribute,"style");
		      if (sStyle1.equals("")) sStyle1 = "thisinput";
		      
		      sReadOnly1 = StringFunction.getProfileString(sRowAttribute,"readonly");
		      sReadOnly1 = sReadOnly1.trim().equals("true")?"readonly":"";
		      
		      sRowAttribute = DataConvert.toString(rReport.ReportRows[i+iHalfRowCount].RowAttribute);
		      sStyle2 = StringFunction.getProfileString(sRowAttribute,"style");
		      if (sStyle2.equals("")) sStyle2 = "thisinput";
		      
		      sReadOnly2 = StringFunction.getProfileString(sRowAttribute,"readonly");
		      sReadOnly2 = sReadOnly2.trim().equals("true")?"readonly":"";
		      
		      sNameC = "R" + String.valueOf(i+1) + "CC";
		      sName1 = "R" + String.valueOf(i+1) + "C1";
		      sName2 = "R" + String.valueOf(i+1) + "C2";
		      sNameC2 = "R" + String.valueOf(i+1+iHalfRowCount) + "CC";
		      sName3 = "R" + String.valueOf(i+1+iHalfRowCount) + "C1";
		      sName4 = "R" + String.valueOf(i+1+iHalfRowCount) + "C2";
		      //add by lpzhang 2010-5-26 �޸Ĳ��񱨱���ʾ0.00�����
       		  String s1="",s2="",t1="",t2="";
        	  if((rReport.ReportRows[i].ColDisplay[0]==null || rReport.ReportRows[i].ColDisplay[0].equals("") || DataConvert.toHTMLMoney(rReport.ReportRows[i].ColDisplay[0]).equals("0.00")) && sStyle1.equals("thisinput"))
        		  s1="";
        	  else
        	      s1 =DataConvert.toHTMLMoney(rReport.ReportRows[i].ColDisplay[0]);
        	  //-----------------------------------------
        	  if((rReport.ReportRows[i].ColDisplay[1]==null || rReport.ReportRows[i].ColDisplay[1].equals("") || DataConvert.toHTMLMoney(rReport.ReportRows[i].ColDisplay[1]).equals("0.00"))&& sStyle1.equals("thisinput"))
        		  s2="";
        	  else
        	      s2 =DataConvert.toHTMLMoney(rReport.ReportRows[i].ColDisplay[1]);
        	//-----------------------------------------
        	  if((rReport.ReportRows[i+iHalfRowCount].ColDisplay[0]==null || rReport.ReportRows[i+iHalfRowCount].ColDisplay[0].equals("") || DataConvert.toMoney(rReport.ReportRows[i+iHalfRowCount].ColDisplay[0]).equals("0.00")) && sStyle2.equals("thisinput"))
        		  t1="";
        	  else
        	      t1 =DataConvert.toMoney(rReport.ReportRows[i+iHalfRowCount].ColDisplay[0]);
        	//-----------------------------------------
        	  if((rReport.ReportRows[i+iHalfRowCount].ColDisplay[1]==null || rReport.ReportRows[i+iHalfRowCount].ColDisplay[1].equals("") || DataConvert.toMoney(rReport.ReportRows[i+iHalfRowCount].ColDisplay[1]).equals("0.00")) && sStyle2.equals("thisinput"))
        		  t2="";
        	  else
        	      t2 =DataConvert.toMoney(rReport.ReportRows[i+iHalfRowCount].ColDisplay[1]);
        	  
        	  
		  	
		    %> 
	            <tr align="center"> 
	              <td class="thistd"  width=216 style="<%=sStyle1%>" align=left wrap > 
	              	<%=StringFunction.replace(DataConvert.toString(rReport.ReportRows[i].RowName)," ","&nbsp;")%>
	                <input class="thisinput" style="<%=sStyle1%>" type=hidden readonly size="36"  value='<%=DataConvert.toString(rReport.ReportRows[i].RowName)%>' title='<%=DataConvert.toString(rReport.ReportRows[i].RowName)%>' name=<%=sNameC%> >
	              </td>
	              <td class="thistd" > 
	                <input class="thisinput" style="<%=sStyle1%>" type=text readonly size="4"  value='<%=i+1%>' name="text2">
	              </td>
	              <td class="thistd"> 
	                <input class="thisinputnumber" onKeyDown="gridValueChange()"  onblur="javascript:amarMoneyControl('<%=sName1%>');unsetHighLight(this);" <%=sReadOnly1%> onfocus="setHighLight(this);" style="<%=sStyle1%>" type=text  size="16" onKeyUp="moveFocus('<%=sName1%>')" name=<%=sName1%> value='<%=s1%>'>
	              </td>
	              <td class="thistd"> 
	                <input class="thisinputnumber" onKeyDown="gridValueChange()"  onblur="javascript:amarMoneyControl('<%=sName2%>');unsetHighLight(this);" <%=sReadOnly1%> onfocus="setHighLight(this);" style="<%=sStyle1%>" type=text  size="16" onKeyUp="moveFocus('<%=sName2%>')" name=<%=sName2%> value='<%=s2%>'>
	              </td>
	              <td class="thistd"  width=216 style="<%=sStyle2%>" align=left wrap > 
	              	<%=StringFunction.replace(DataConvert.toString(rReport.ReportRows[i+iHalfRowCount].RowName)," ","&nbsp;")%>
	                <input class="thisinput" style="<%=sStyle2%>" type=hidden readonly size="34" value='<%=DataConvert.toString(rReport.ReportRows[i+iHalfRowCount].RowName)%>' title='<%=DataConvert.toString(rReport.ReportRows[i+iHalfRowCount].RowName)%>' name=<%=sNameC2%> >
	              </td>
	              <td class="thistd"> 
	                <input class="thisinput" style="<%=sStyle2%>" type=text readonly size="4"  value='<%=i+1+iHalfRowCount%>' name="text2">
	              </td>
	              <td class="thistd"> 
	                <input class="thisinputnumber" onKeyDown="gridValueChange()"  <%=sReadOnly2%> onblur="javascript:amarMoneyControl('<%=sName3%>');unsetHighLight(this);" onfocus="setHighLight(this);" style="<%=sStyle2%>" type=text  size="16" onKeyUp="moveFocus('<%=sName3%>')" name=<%=sName3%> value='<%=t1%>'>
	              </td>
	              <td class="thistd"> 
	                <input class="thisinputnumber" onKeyDown="gridValueChange()"  <%=sReadOnly2%> onblur="javascript:amarMoneyControl('<%=sName4%>');unsetHighLight(this);" onfocus="setHighLight(this);" style="<%=sStyle2%>" type=text  size="16" onKeyUp="moveFocus('<%=sName4%>')" name=<%=sName4%> value='<%=t2%>'>
	              </td>
	            </tr>
	            <%
	        }     
	}
	%>

      		</table>
        </form>
    </td>
 </td>
 </tr>
    <tr> 
    <td width="1" height="17">&nbsp; </td>
    <td align="left" width="450" height="17" bgcolor="#FFFFFF"> 
     <%=rReport.ReportNo%> >> ���񱨱� >> <%=rReport.ReportDate+" >> "+rReport.ReportName%>&nbsp;</td>
    <td align="right" width="560" height="17"> 
      <table width="300" border="0" cellspacing="0" cellpadding="0" height="30">
        <tr>
        <%
            if(sRole.equals("has"))
            {
            	if(isEditable){
        %>
          <td>
						<%=HTMLControls.generateButton("��&nbsp;��","������񱨱�","javascript:saveReport()",sResourcesPath)%>
		  </td>
		  <td>
						<%=HTMLControls.generateButton("��&nbsp;��","������񱨱�","javascript:calcReport()",sResourcesPath)%>
		  </td>
		 <% 	}
            }%>
		  <td>
						<%=HTMLControls.generateButton("ת�������ӱ��","ת�������ӱ��","javascript:spreadsheetTransfer(formatContent());",sResourcesPath)%>
		  </td>
		  <td>&nbsp; &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
      </table>
      
    </td>
    <td align="center" colspan="2" height="17" width="1">&nbsp; </td>
  </tr>


</table>

 <script language=javascript>
 
   function deleteReport()
   {
   	if (confirm("��Ҫɾ���ñ���������"))
   	{
		document.report.action="ReportData.jsp?ReportNo=<%=sReportNo%>&rand="+randomNumber();
	   	document.report.elements("Operation").value = "delete";
	   	document.report.submit(); 
   	}     
   }
   
   function saveReport()
   {
   	//add by thong 2005.09.07
   	//������ʾ	
   	amarhidden.style.display = "none";
   	var sUrl = "ReportData.jsp?ReportNo=<%=sReportNo%>&rand="+randomNumber();
	document.report.elements("Operation").value = "save";
   	//�¼����μ�common.js   	---�������������OpenPage()---onSubmit(sUrl,sParameter);
   	onFromAction(sUrl,'report');   
   	//***************************************************************************************
   	//document.report.action="ReportData.jsp?ReportNo=<%//=sReportNo%>&rand="+randomNumber();	*
   	//document.report.elements("Operation").value = "save";									*
   	//document.report.submit(); 															*
   	//***************************************************************************************
   }
   	   
   function calcReport()
   {
  	//add by thong 2005.09.07
   	//������ʾ	
   	amarhidden.style.display = "none";
   	var sUrl = "ReportData.jsp?ReportNo=<%=sReportNo%>&rand="+randomNumber();
	document.report.elements("Operation").value = "calc";
   	//�¼����μ�common.js   	---�������������OpenPage()---onSubmit(sUrl,sParameter)
   	//onFromAction ��װ��document.formname.action ��Ҫ�ύ���ĵ����������,�������onSubmit(sUrl,sParameter)
   	onFromAction(sUrl,'report');  
   	   
   	//***************************************************************************************
   	//document.report.action="ReportData.jsp?ReportNo=<%//=sReportNo%>&rand="+randomNumber();	*
   	//document.report.elements("Operation").value = "calc";									*
   	//document.report.submit(); 															*
   	//***************************************************************************************
   }

   function moveFocus(sName)
   {
   	iRowCount = <%=rReport.ReportRows.length%>;
   	//ȡ�õ�ǰλ��   	
   	iRowPos = sName.indexOf("R");
	iColPos = sName.indexOf("C");
	iRow = parseInt(sName.substring(iRowPos+1,iColPos-iRowPos)); 
	sCol = sName.substring(iColPos); 	
	
   	if(event.keyCode==38) //�����ƶ�
   	{
		if(iRow>1) 
		{ iRow--;
		  sName = "R" + new String(iRow) + sCol;
		  document.report.elements(sName).focus();
		}  
   	}else if(event.keyCode==40 || event.keyCode==13) //�����ƶ�
   	{
   		if(iRow<iRowCount) 
   		{ iRow++;
		  sName = "R" + new String(iRow) + sCol;
		  document.report.elements(sName).focus();
		  //�������ӻس�������ʾ��С����ǰ add by zrli 2010-1-5
		  var range=document.report.elements(sName).createTextRange(); 
		  range.collapse(true);
		  range.moveStart('character',1);
		  range.select();
		}  
   	}
   }
   //���뱨��
   function importReport()
   {
		OpenComp("ReportImport","/Common/FinanceReport/ReportImport.jsp","ReportNo=<%=sReportNo%>&CustomerName=<%=sCustomerName%>&CustomerID=<%=sCustomerID%>&ReportDate=<%=rReport.ReportDate%>&ModelNo=<%=rReport.ModelNo%>","_blank","OpenStyle");
		reloadSelf();
   
   }
   function closeSelf()
   {
   	
   	if(confirm("ȷ���رձ�������"))
   	{
   		window.close();
   	}
   	
   }
	
	//�ֽ��������ֹ�����У��	
	function verifyReport(){
		sReportNo = "<%=sReportNo%>";
		sReturn = RunMethod("CustomerManage","CheckReportData",sReportNo);
		if("equals" == sReturn){
			alert("����ƽ�⣡");
		}else{
			alert(sReturn);
		}
	}
	
	function amarMoneyControl(sName)
	{
		dMoney = parseFloat(document.report.elements(sName).value.replace(/,/g, ""));
		if(dMoney==0)	return;
		if (dMoney==null || dMoney=="" || typeof(dMoney)=='undefined' || dMoney=="-NaN.Na" || dMoney=="NaN" || isNaN(dMoney)) 
		{
			document.report.elements(sName).value = "";
			return "";
		}
	
		var sMoney="",i,sTemp="",itemCount,iLength,digit=3,sign="",s1="",s2="";
		
		if(dMoney>=0) 
		{
			dMoney = dMoney + 0.0005;
			sign = "";
		}else	
		{
			dMoney = Math.abs(dMoney - 0.0005);
			sign = "-";
		}
		sMoney=dMoney.toString(10);
		s2 = sMoney.substring(sMoney.indexOf(".")+1,sMoney.indexOf(".")+3);
		sMoney=parseInt(dMoney,10).toString(10);
		iLength = sMoney.length;
		itemCount = parseInt((iLength-1) / digit,10) ;		
		for (i=0;i<itemCount;i++) 
		{
			sTemp = ","+sMoney.substring(iLength-digit*(i+1),iLength-digit*i)+sTemp;
		}		
		sMoney = sign+sMoney.substring(0,iLength-digit*i)+sTemp+"."+s2;	
	
		document.report.elements(sName).value = sMoney;
		
		return sMoney;		
	}
	
	function formatNull(sNull)
	{
		if(sNull==null || sNull=="")
			return("");//return("&nbsp;");
		else
			return(sNull.replace(/ /g,"&nbsp;"));
	}

	function formatNumber2(sNull)
	{
		if(sNull=="undefined")
			return "";
		else
			return sNull;
	}
		
	function formatContent()
	{
		var sContentNew = "",i=0;
		var iRowCount = <%=rReport.ReportRows.length%>;
		var iColCount = <%=iColCount%>;
		var sHeader = "<%=sCustomerName%> <%=rReport.ReportDate%> <%=rReport.ReportName%>";

		sContentNew += "<STYLE>";
		sContentNew += ".table {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}";
		sContentNew += ".td {  font-size: 9pt;border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px}.inputnumber {border-style:none;border-width:thin;border-color:#e9e9e9;text-align:right;}.pt16songud{font-family: '����','����';font-size: 16pt;font-weight:bold;text-decoration: none}.myfont{font-family: '����','����';font-size: 9pt;font-weight:bold;text-decoration: none}"
		sContentNew += "</STYLE>";

		sContentNew += "<table align=center border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF >";
		sContentNew += "<tr>";
		sContentNew += "    <td colspan="+iColCount+" align=middle >"+sHeader+"</td>";
		sContentNew += "</tr>";
		sContentNew += "<tr>";
<%		for(i=0;i<iColCount;i++) { %>
		sContentNew += "    <td align=left  style='background-color:#CCC8EB;color:black;padding-left:2px;' ><%=sTitle[i]%></td>";
<%		} %>
		sContentNew += "</tr>";
		
<%
		if(rReport.DisplayMethod.equals("1"))
		{
%>		
			for(i=1;i<=iRowCount;i++)
			{
				var sStyle = " style=\" "+document.forms("report").elements("R"+i+"CC").style.cssText+" \" ";
				sContentNew += "<tr>";
				sContentNew += "    <td align=left  "+sStyle+" >"+formatNull(document.forms("report").elements("R"+i+"CC").value)+"</td>";
				sContentNew += "    <td align=middle  "+sStyle+" >"+i+"</td>";
				sContentNew += "    <td align=right  "+sStyle+" >"+formatNumber2(document.forms("report").elements("R"+i+"C1").value)+"</td>";
				sContentNew += "    <td align=right  "+sStyle+" >"+formatNumber2(document.forms("report").elements("R"+i+"C2").value)+"</td>";
				sContentNew += "</tr>";
			}
<%			
		}
		else if(rReport.DisplayMethod.equals("3"))
		{
%>		


			for(i=1;i<=iRowCount;i++)
			{
				var sStyle = " style=\" "+document.forms("report").elements("R"+i+"CC").style.cssText+" \" ";
				sContentNew += "<tr>";
				sContentNew += "    <td align=left "+sStyle+" >"+formatNull(document.forms("report").elements("R"+i+"CC").value)+"</td>";
				sContentNew += "    <td align=middle  "+sStyle+" >"+i+"</td>";
				sContentNew += "    <td align=right  "+sStyle+" >"+formatNumber2(document.forms("report").elements("R"+i+"C2").value)+"</td>";
				sContentNew += "</tr>";
			}		
<%			
		}
		else
		{
%>		
			for(i=1;i<=iRowCount/2;i++)
			{
				var sStyle =  " style=\" "+document.forms("report").elements("R"+i+"CC").style.cssText+" \" ";
				var sStyle2 = " style=\" "+document.forms("report").elements("R"+(i+iRowCount/2)+"CC").style.cssText+" \" ";
				sContentNew += "<tr>";
				sContentNew += "    <td align=left "+sStyle+" >"+formatNull(document.forms("report").elements("R"+i+"CC").value)+"</td>";
				sContentNew += "    <td align=middle "+sStyle+" >"+i+"</td>";
				sContentNew += "    <td align=right "+sStyle+" >"+formatNumber2(document.forms("report").elements("R"+i+"C1").value)+"</td>";
				sContentNew += "    <td align=right "+sStyle+" >"+formatNumber2(document.forms("report").elements("R"+i+"C2").value)+"</td>";
				sContentNew += "    <td align=left  "+sStyle2+" >"+formatNull(document.forms("report").elements("R"+(i+iRowCount/2)+"CC").value)+"</td>";
				sContentNew += "    <td align=middle  "+sStyle2+" >"+(i+iRowCount/2)+"</td>";
				sContentNew += "    <td align=right  "+sStyle2+" >"+formatNumber2(document.forms("report").elements("R"+(i+iRowCount/2)+"C1").value)+"</td>";
				sContentNew += "    <td align=right  "+sStyle2+" >"+formatNumber2(document.forms("report").elements("R"+(i+iRowCount/2)+"C2").value)+"</td>";
				sContentNew += "</tr>";
			}
<%			
		}
%>

		sContentNew += "</table>";
		//��ֹ���񱨱�������̫С������EXCELʱ�������
		sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		
		return(sContentNew);		
	}


	var dataModified = false; //�����Ƿ��޸Ĺ�
	function gridValueChange(){
		dataModified = true;
	}

</script>
</body>
</html>
<%@ include file="/IncludeEnd.jsp"%>

