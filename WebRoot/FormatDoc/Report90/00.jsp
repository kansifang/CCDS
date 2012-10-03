<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xiongtao  2005.02.18
		Tester:
		Content: 报告的第0页
		Input Param:
			必须传入的参数：
				DocID:	  文档template
				ObjectNo：业务号
				SerialNo: 调查报告流水号
			可选的参数：
				Method:   其中 1:display;2:save;3:preview;4:export
				FirstSection: 判断是否为报告的第一页
		Output param:

		History Log: 
	 */
	%>
<%/*~END~*/%>

<%
	int iDescribeCount = 0;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>
<% 
	sButtons[1][0] = "false";
%>
<%
	//获得调查报告数据
	String sCustomerName = "";       //客户名称
	String sSex = "";                //性别
	String sBirthDay = "";           //生日 
	String sNativePlace = "";        //户籍
	String sWorkCorp = "";           //工作单位
	String sHeadShip = "";           //职务
	String sEduExperience = "";      //学历
	String sMarriage = "";           //婚姻状况
	String sOperateOrgName = "";     //经办行
	String sOrgName = "";            //呈报机构
	int iCount = 0 ;                 //供养子女数
	int iOld = 0;                    //年龄  
	String sOrgID = CurOrg.OrgID;    //当前用户机构号
	//获取供养子女个数
	iCount = Integer.parseInt(Sqlca.getString("select count(*) as Child from customer_relative where RelationShip = '0603' and CustomerID =(select CustomerID from BUSINESS_APPLY where SerialNo ='"+sObjectNo+"')"));
	//获取呈报机构名称
	sOrgName = Sqlca.getString("select getOrgName('"+sOrgID+"') as sOrgName from ORG_INFO");
	//获取客户其他信息
	ASResultSet rs2 = Sqlca.getResultSet("select FullName,getItemName('Sex1',Sex) as Sex,BirthDay,NativePlace,WorkCorp,getItemName('HeadShip',HeadShip) as HeadShip,getItemName('EducationExperience1',EduExperience) as EduExperience,getItemName('Marriage',Marriage) as Marriage,getOrgName(InputOrgID) as OperateOrgName from IND_INFO where CustomerID=(select CustomerID from BUSINESS_APPLY where SerialNo ='"+sObjectNo+"')");
	if(rs2.next())
	{
		sCustomerName = rs2.getString("FullName");
		if(sCustomerName == null) sCustomerName = "";
		sSex = rs2.getString("Sex");
		if(sSex == null) sSex = " ";
		sBirthDay = rs2.getString("BirthDay");
		if(sBirthDay == null) sBirthDay = "";
		sNativePlace = rs2.getString("NativePlace");
		if(sNativePlace == null) sNativePlace = "";
		sWorkCorp = rs2.getString("WorkCorp");
		if(sWorkCorp == null) sWorkCorp = "";
		sHeadShip = rs2.getString("HeadShip");
		if(sHeadShip == null) sHeadShip = "  ";
		sEduExperience = rs2.getString("EduExperience");
		if(sEduExperience == null) sEduExperience = "";
		sMarriage = rs2.getString("Marriage");
		if(sMarriage == null) sMarriage = "  ";
		sOperateOrgName = rs2.getString("OperateOrgName");
		if(sOperateOrgName == null) sOperateOrgName = "";
	}	
	rs2.getStatement().close();	
	if(!sBirthDay.equals(""))
	{	
	   sBirthDay = sBirthDay.substring(0,4);
	   iOld = Integer.parseInt(StringFunction.getToday().substring(0,4))-Integer.parseInt(sBirthDay);
	}
	//获取客户年龄
	//iOld = Integer.parseInt(StringFunction.getToday().substring(0,4))-Integer.parseInt(sBirthDay);
	//select count(*) from customer_relative where RelationShip = '0603' and CustomerID = '2010011300000008'
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();

	sTemp.append("	<form method='post' action='00.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=center colspan=10 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >个人贷款调查报告(消费类)</font></td> ");	
	sTemp.append(" </tr>");	
	sTemp.append(" <tr>");
  	sTemp.append(" <td colspan=3 align=center class=td1 > 呈报机构：</td>");
  	sTemp.append(" <td colspan=2 align=left class=td1 >"+sOrgName+"&nbsp</td>");
  	sTemp.append(" <td colspan=3 align=center class=td1 > 经办行：</td>");
    sTemp.append(" <td colspan=2 align=left class=td1 >"+sOperateOrgName+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append(" <tr>");
  	sTemp.append(" <td colspan=3 align=center class=td1 > 被授信人：</td>");
    sTemp.append(" <td colspan=2 align=left class=td1 >"+sCustomerName+"&nbsp</td>");
    sTemp.append(" <td colspan=3 align=center class=td1 > 年龄及性别：</td>");
    sTemp.append(" <td colspan=2 align=left class=td1 >"+iOld+""+sSex+"&nbsp</td>");
    sTemp.append(" </tr>");
	sTemp.append(" <tr>");
  	sTemp.append(" <td colspan=3 align=center class=td1 > 户籍所在地：</td>");
    sTemp.append(" <td colspan=2  align=left class=td1 >"+sNativePlace+"&nbsp;</td>");
    sTemp.append(" <td colspan=3 align=center class=td1 > 现在工作单位：</td>");
    sTemp.append(" <td colspan=2  align=left class=td1 >"+sWorkCorp+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append(" <tr>");
  	sTemp.append(" <td colspan=3 align=center class=td1 > 职务：</td>");
    sTemp.append(" <td colspan=2  align=left class=td1 >"+sHeadShip+"&nbsp;</td>");
    sTemp.append(" <td colspan=3 align=center class=td1 > 学历：</td>");
    sTemp.append(" <td colspan=2  align=left class=td1 >"+sEduExperience+"&nbsp;</td>");
    sTemp.append(" </tr>");
    sTemp.append(" <tr>");
  	sTemp.append(" <td colspan=3 align=center class=td1 > 婚姻状况：</td>");
    sTemp.append(" <td colspan=2  align=left class=td1 >"+sMarriage+"&nbsp;</td>");
    sTemp.append(" <td colspan=3 align=center class=td1 > 供养子女：</td>");
    sTemp.append(" <td colspan=2  align=left class=td1 >"+iCount+"&nbsp;</td>");
    sTemp.append(" </tr>");
	sTemp.append("</table>");	
	sTemp.append("</div>");	
	sTemp.append("<input type='hidden' name='Method' value='1'>");
	sTemp.append("<input type='hidden' name='SerialNo' value='"+sSerialNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectNo' value='"+sObjectNo+"'>");
	sTemp.append("<input type='hidden' name='ObjectType' value='"+sObjectType+"'>");
	sTemp.append("<input type='hidden' name='Rand' value=''>");
	sTemp.append("<input type='hidden' name='CompClientID' value='"+CurComp.ClientID+"'>");
	sTemp.append("<input type='hidden' name='PageClientID' value='"+CurPage.ClientID+"'>");
	sTemp.append("</form>");
	
	

	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
%>
<%/*~END~*/%>

<%@include file="/FormatDoc/IncludeFDFooter.jsp"%>

<script language=javascript>
<%	
	if(sMethod.equals("1"))  //1:display
	{
%>
	//客户化3
	var config = new Object();  
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

