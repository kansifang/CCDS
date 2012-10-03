<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   xhyong 2012/05/16
		Tester:
		Content: 报告的第0301页
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
	int iDescribeCount = 100;	//这个是页面需要输入的个数，必须写对：客户化1
%>

<%@include file="/FormatDoc/IncludeFDHeader.jsp"%>

<%
	//获得调查报告数据
	//获得调查报告数据
	ASResultSet rs2 = null;
	String sSql = "";
	String sGuarantyLocation = "";//房产地址
	String sGuarantyRightID = "";//房产号
	String sAboutOtherID1 = "";//土地证号
	String sThirdParty1 = "";//土地用途
	double dGuarantyAmount = 0;//建筑面积
	String sGuarantyDate = "";//建筑年代
	String sOwnerTime = "";//使用年限
	
	
	
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("	<form method='post' action='0301.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");	
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=11 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >三、抵押物情况</font></td> ");	
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");	
	sTemp.append("   <td class=td1 align=left colspan=11  >1.抵押物属性</td> ");
	sTemp.append("   </tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left  colspan=11  >1.1 抵押物明细");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	
	sTemp.append("   <tr>");
		sTemp.append("   <td colspan=1 rowspan=2 align=center class=td1 >房产地址 </td>");
	    sTemp.append("   <td colspan=2 align=center class=td1 >产权证号</td>");
	    sTemp.append("   <td colspan=3 align=center class=td1 >土地、房产权属信息</td>");
	    sTemp.append("   <td colspan=1 rowspan=2 align=center class=td1 >建筑面积</td>");
	    sTemp.append("   <td colspan=1 rowspan=2 align=center class=td1 >建成年代</td>");
	    sTemp.append("   <td colspan=1 rowspan=2 align=center class=td1 >结构类型</td>");
	    sTemp.append("   <td colspan=1 rowspan=2 align=center class=td1 >使用期限</td>");
	    sTemp.append("   <td colspan=1 rowspan=2 align=center class=td1 >共有人情况</td>");
	 sTemp.append("   </tr>");
	 sTemp.append("   <tr>");
	    sTemp.append("   <td colspan=1  align=center class=td1 >房产证号</td>");
	    sTemp.append("   <td colspan=1  align=center class=td1 >土地证号</td>");
	    sTemp.append("   <td colspan=1  align=center class=td1 >土地使用权类型</td>");
	    sTemp.append("   <td colspan=1  align=center class=td1 >土地用途</td>");
	    sTemp.append("   <td colspan=1  align=center class=td1 >房屋用途</td>");
	 sTemp.append("   </tr>");
	 int i=2 ;
	//获取抵押物信息
		sSql = "select GI.GuarantyLocation,GI.GuarantyRightID,GI.AboutOtherID1,"+
				" GI.ThirdParty1,GI.GuarantyAmount,GI.GuarantyDate,OwnerTime  "+
			" from GUARANTY_RELATIVE GR,GUARANTY_INFO GI "+
			" where GR.ObjectType='CreditApply' "+
			" and GR.GuarantyID=GI.GuarantyID and GR.ObjectNo='"+sObjectNo+"' ";
		rs2 = Sqlca.getResultSet(sSql);
		while(rs2.next())
		{	
			sGuarantyLocation =  rs2.getString("GuarantyLocation");//房产地址
			if(sGuarantyLocation==null) sGuarantyLocation="";
			sGuarantyRightID =  rs2.getString("GuarantyRightID");//房产号
			if(sGuarantyRightID==null) sGuarantyRightID="";
			sAboutOtherID1 =  rs2.getString("AboutOtherID1");//土地证号
			if(sAboutOtherID1==null) sAboutOtherID1="";
			sThirdParty1 =  rs2.getString("ThirdParty1");//土地用途
			if(sThirdParty1==null) sThirdParty1="";
			dGuarantyAmount =  rs2.getDouble("GuarantyAmount");//建筑面积
			sGuarantyDate =  rs2.getString("GuarantyDate");//建筑年代
			if(sGuarantyDate==null) sGuarantyDate="";
			sOwnerTime =  rs2.getString("OwnerTime");//使用年限
			if(sOwnerTime==null) sOwnerTime="";
			
			 sTemp.append("   <tr>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;"+sGuarantyLocation+"</td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;"+sGuarantyRightID+"</td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;"+sAboutOtherID1+"</td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >");
			    sTemp.append(myOutPut("2",sMethod,"name='describe"+i+"' style='width:100%;' ",getUnitData("describe"+i,sData))+"");
			    sTemp.append("  </td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;"+sThirdParty1+"</td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >");
			    sTemp.append(myOutPut("2",sMethod,"name='describe"+(i+1)+"' style='width:100%;' ",getUnitData("describe"+(i+1),sData))+"");
			    sTemp.append("  </td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;"+dGuarantyAmount+"</td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;"+sGuarantyDate+"</td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >");
			    sTemp.append(myOutPut("2",sMethod,"name='describe"+(i+2)+"' style='width:100%;' ",getUnitData("describe"+(i+2),sData))+"");
			    sTemp.append("  </td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;"+sOwnerTime+"</td>");
			    sTemp.append("   <td colspan=1  align=left class=td1 >");
			    sTemp.append(myOutPut("2",sMethod,"name='describe"+(i+3)+"' style='width:100%;' ",getUnitData("describe"+(i+3),sData))+"");
			    sTemp.append("  </td>");
			 sTemp.append("   </tr>");
			 i=i+4;
			
		}
		rs2.getStatement().close();
		
	/*
	 sTemp.append("   <tr>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	    sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	  	sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
		sTemp.append("   <td colspan=1  align=left class=td1 >&nbsp;</td>");
	sTemp.append("   </tr>");
	*/
	sTemp.append("   <tr>");
	sTemp.append("   <td class=td1 align=left  colspan=11  >注：(1)产权证号：对于房产证和土地证分别办理的地区，须分别填写房产证和土地证号；对于房产与土地两证合一的地区，须填写土地房产权证号；对于不能办理土地证的地区，须填写房产证号。<br>"
			+"(2)土地、房产权属信息：土地使用权类型包括出让、出租和划拨；土地用途包括住宅、商业、工业、城镇混合住宅等；房屋用途包括住宅、商业、工业等。<br>"
			+"(3)结构类型包括：钢混、砖混、砖木等。");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=11 align=left class=td1 >1.2 须确认抵押物中是否存在产品管理办法中明确规定的“三类业务不可以做：土地用途是工业用地的；物业房产证上的用途是厂房的；土地获取方式是划拨的”以及土地用途为公共建筑用地、租赁用地等特殊情况的 <br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=11 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe0' style='width:100%; height:150'",getUnitData("describe0",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=11 align=left class=td1 >1.3 共有人信息：说明抵押物是否存在共有人及共有人的相关信息，本笔贷款申请是否已取得共有权人的同意。 <br>");
	sTemp.append("   </td>");
	sTemp.append("   <tr>");
	sTemp.append("   <td colspan=11 align=left class=td1 >");
	sTemp.append(myOutPut("1",sMethod,"name='describe1' style='width:100%; height:150'",getUnitData("describe1",sData)));
	sTemp.append("   <br>");
	sTemp.append("   </td>");
	sTemp.append("   </tr>");
	
                          	
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
	editor_generate('describe0');		//需要html编辑,input是没必要 
	editor_generate('describe1');		//需要html编辑,input是没必要 
	
																								
<%
	}
%>	
</script>	
	
<%@ include file="/IncludeEnd.jsp"%>

