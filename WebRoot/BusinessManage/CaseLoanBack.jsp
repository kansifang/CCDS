
<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBegin.jsp"%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List00;Describe=ע����;]~*/
%>
	<%
		/*
			Author: jytian 2004-12-21
			Tester:
			Describe:�ĵ������б�
			Input Param:
	       		�ĵ����:BatchNo
			Output Param:

			HistoryLog:zywei 2005/09/03 �ؼ����
		 */
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List01;Describe=����ҳ������;]~*/
%>
	<%
		String PG_TITLE = "�ĵ������б�"; // ��������ڱ��� <title> PG_TITLE </title>
	%>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List02;Describe=�����������ȡ����;]~*/
%>
<%
	//�������                     
    String sSql = "";   	
	//���ҳ�����
	
	//����������
	String sSerialNo = DataConvert.toString(DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("SerialNo")));
%>
<%
	/*~END~*/
%>
<html>
<head>������Ϣ</head>
	<body leftmargin="0" topmargin="0" class="windowbackground" style="{overflow:scroll;overflow-x:visible;overflow-y:visible}">
				<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
					<tr>
		              <td nowrap bgcolor= #dcdcdc bordercolorlight='#dcdcdc' bordercolordark='#dcdcdc' class="pt9song">
			            <table width=97% border=0 align="right" cellpadding=5 height=100%>
			              <tr>
			                    <td class="pt9song">
			                    <font color="#FFFFFF">
			                    <marquee behavior="scroll" DIRECTION="up" width=100% height=100%  scrollamount=2 scrolldelay=50 onMouseOver="this.stop();" onMouseOut="this.start();" bgcolor="#6382BC" style="padding-left:5">
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><zhp>&nbsp</p><p>&nbsp</p><p>&nbsp</p><!--�ӿ��н���������������-->
				                 <%
				                 	String sInputDate = "",sLCustomerName = "",sActualPayBackDate="";
				                 		                  Double dActualPayBackSum=0.0,dBalance=0.0;
				                 		                  ASResultSet rs = Sqlca.getASResultSet("select InputDate,"+
				                 		                  								"LCustomerName,"+
				                 		                  								"LSum,"+
				                 		                  								"ActualPayBackDate,"+
				                 		                  								"ActualPayBackSum,"+
				                 				                  						"Balance"+
				                 		                  								" from Batch_Case_History"+
				                 				                  						" where SerialNo = '"+sSerialNo+"'");
				                 		                  while(rs.next()){
				                 		                    sInputDate = DataConvert.toString(rs.getString("InputDate"));
				                 		                    sLCustomerName = DataConvert.toString(rs.getString("LCustomerName"));
				                 		                    sActualPayBackDate = DataConvert.toString(rs.getString("ActualPayBackDate"));
				                 		                    dActualPayBackSum = rs.getDouble("ActualPayBackSum");
				                 		                    dBalance = rs.getDouble("Balance");
				                 		                    out.print("<li style='cursor:hand' >");
				                 		                    // out.print("<span onclick='javascript:openFile(\""+rs.getString(1)+"\")'>"+rs.getString(2)+"</span>");
				                 		                    out.print("<span>��"+sInputDate+"����"+dActualPayBackSum+"Ԫ�����"+dBalance+"Ԫ</span>");
				                 		                    //out.print("<img src='"+sResourcesPath+"/new.gif' border=0>");
				                 		                    out.print("<br><br>");
				                 		                  }
				                 		                  rs.getStatement().close();
				                 %>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
			                	</marquee>
			                    </font>
			                  </td>
			                 </tr>
		                </table>
	                 </td>
	                 <td nowrap bgcolor= #dcdcdc bordercolorlight='#dcdcdc' bordercolordark='#dcdcdc' class="pt9song">
			            <table width=97% border=0 align="right" cellpadding=5 height=100%>
			              <tr>
			                    <td class="pt9song">
			                    <font color="#FFFFFF">
			                    <marquee behavior="scroll" DIRECTION="up" width=100% height=100%  scrollamount=2 scrolldelay=50 onMouseOver="this.stop();" onMouseOut="this.start();" bgcolor="#6382BC" style="padding-left:5">
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><zhp>&nbsp</p><p>&nbsp</p><p>&nbsp</p><!--�ӿ��н���������������-->
				                 <%
				                 	rs = Sqlca.getASResultSet("select InputDate,"+
				                 		                  								"LCustomerName,"+
				                 		                  								"LSum,"+
				                 		                  								"ActualPayBackDate,"+
				                 		                  								"ActualPayBackSum,"+
				                 				                  						"Balance"+
				                 		                  								" from Batch_Case_History"+
				                 				                  						" where SerialNo = '"+sSerialNo+"'");
				                 		                  while(rs.next()){
				                 		                    sInputDate = DataConvert.toString(rs.getString("InputDate"));
				                 		                    sLCustomerName = DataConvert.toString(rs.getString("LCustomerName"));
				                 		                    sActualPayBackDate = DataConvert.toString(rs.getString("ActualPayBackDate"));
				                 		                    dActualPayBackSum = rs.getDouble("ActualPayBackSum");
				                 		                    dBalance = rs.getDouble("Balance");
				                 		                    out.print("<li style='cursor:hand' >");
				                 		                    // out.print("<span onclick='javascript:openFile(\""+rs.getString(1)+"\")'>"+rs.getString(2)+"</span>");
				                 		                    out.print("<span>��"+sInputDate+"����"+dActualPayBackSum+"Ԫ�����"+dBalance+"Ԫ</span>");
				                 		                    //out.print("<img src='"+sResourcesPath+"/new.gif' border=0>");
				                 		                    out.print("<br><br>");
				                 		                  }
				                 		                  rs.getStatement().close();
				                 %>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
				                 <p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p><p>&nbsp</p>
			                	</marquee>
			                    </font>
			                  </td>
			                 </tr>
		                </table>
	                 </td>
	                </tr>
				</table>
	</body>
</html>

<%
	/*~BEGIN~�ɱ༭��~[Editable=true;CodeAreaID=List03;Describe=�������ݶ���;]~*/
%>
<%
	
%>
<%
	/*~END~*/
%>

<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>
	//---------------------���尴ť�¼�------------------------------------
	var bIsInsert = false; //���DW�Ƿ��ڡ�����״̬��
	//---------------------���尴ť�¼�------------------------------------
	/*~[Describe=����;InputParam=�����¼�;OutPutParam=��;]~*/
	function saveRecord(sPostEvents)
	{
		//¼��������Ч�Լ��
		if (!ValidityCheck()) return;
		if(bIsInsert){
			beforeInsert();
		}
		beforeUpdate();
		as_save("myiframe0","");
	}
    /*~[Describe=����;InputParam=��;OutPutParam=��;]~*/
    function doReturn(sIsRefresh){
		sObjectNo = getItemValue(0,getRow(),"CodeNo");
		parent.sObjectInfo = sObjectNo+"@"+sIsRefresh;
		parent.closeAndReturn();
	}
</script>
<%
	/*~END~*/
%>


<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List06;Describe=�Զ��庯��;]~*/
%>
	<script language=javascript>


	</script>
<%
	/*~END~*/
%>




<%
	/*~BEGIN~�ɱ༭��~[Editable=false;CodeAreaID=List07;Describe=ҳ��װ��ʱ�����г�ʼ��;]~*/
%>
<%
	/*~END~*/
%>

<%@	include file="/IncludeEnd.jsp"%>
