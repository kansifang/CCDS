<%
/* Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * Author: jjwang  2008-10-16
 * Tester:
 *
 * Content: 对提交的现金流信息进行检查是否录入完整
 * Input Param:
 * 		  借据流水号：	SerialNo
 * 		  贷款账号：LoanAccount
 * 		  会计月份：	AccountMonth
 *        Type: Input-减值录入人员录入， Confirm-认定人员认定，Audit-审计结果录入，其中（Audit在本页面没有使用）   
 * Output param:
 *        sReturnValue :
 *             99-信息录入不全
 * History Log:
 *
 */
%>

<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

<%
	//页面参数之间的传递一定要用DataConvert.toRealString(iPostChange,只要一个参数)它会自动适应window_open
	//查询条件
	String sCondition = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Condition"));
	String sRightCondi = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("RightCondi"));
	String sSerialNo = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("SerialNo"));
	String sType = DataConvert.toRealString(iPostChange,(String)CurPage.getParameter("Type"));
	if(sType == null) sType = "";
	if(sSerialNo == null) sSerialNo = "";
	if(sCondition == null) sCondition = "";
 	if(sRightCondi == null) sRightCondi = "";
 	String sEqualCondition = "";//配合不同的表使用
 	//String sAccountMonth = "2008/10"; //会计月份
 	String sReturnValue = "";
     int iCount = 100;
     int i = 0;
     String []sDeclareSerialNo = new String[iCount];//借据编号
     String []sDeclareLossInfo = new String[iCount];//损失信息
     String []sDeclareCashInfo = new String[iCount];//现金流信息
     String []sDeclareBaseInfo = new String[iCount];//不良贷款基本信息
     String sSubmitResultField = "";  //判断现金流字段是否为空的标志
    
	try{
	   
	
	   if(!sSerialNo.equals("")){//单笔提交
	       String stemp = "select RR.ObjectNo as DuebillNo, RR.LoanAccount as LoanAccount, RR.AccountMonth as AccountMonth, " + 
	                     " RR.MClassifyResult as MClassifyResult,RR.AClassifyResult as AClassifyResult, RR.ConfirmDate as  ConfirmDate, " + 
	                     " RT.ExtendTime as ExtendTime, RR.Result1 as Result1, RR.Result2 as Result2, RR.Result3 as Result3, RR.Result4 as Result4, RR.MResult as MResult " + 
	                     " from reserve_record RR, Reserve_Total RT " + 
	                     " where RR.serialno = '" + sSerialNo + "'" + 
	                     " and RR.AccountMonth = RT.AccountMonth and RR.LoanAccount = RT.LoanAccount ";
	       ASResultSet rsTemp = Sqlca.getASResultSet(stemp);
	       if(rsTemp.next()){
	          int k = i;
	          String sDuebillNo = rsTemp.getString("DuebillNo")== null ? "" :rsTemp.getString("DuebillNo");
	          String sConfirmDate = rsTemp.getString("ConfirmDate")== null ? "" :rsTemp.getString("ConfirmDate");
	          String sExtendTime = rsTemp.getString("ExtendTime")== null ? "" :rsTemp.getString("ExtendTime");

	          String sResult1 = rsTemp.getString("Result1")== null ? "" : rsTemp.getString("Result1");
	          String sResult2 = rsTemp.getString("Result2")== null ? "" : rsTemp.getString("Result2");
	          String sResult3 = rsTemp.getString("Result3")== null ? "" : rsTemp.getString("Result3");
	          String sResult4 = rsTemp.getString("Result4")== null ? "" : rsTemp.getString("Result4");
	          String sMResult = rsTemp.getString("MResult")== null ? "" : rsTemp.getString("MResult");

		     if(CurUser.hasRole("480") || CurUser.hasRole("280") || CurUser.hasRole("080")){
		         sSubmitResultField = sResult1;
		     }
		     System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"+sSubmitResultField);
		     //由于录入人员有可能是支行或分行的认定人员，那么他们直接更新本级别的finishdate及userid、result,不需要一级一级走上来
		     if(sType.equals("Confirm")){
			     if(CurUser.hasRole("601")){
			         sSubmitResultField = sResult2;
			     }else if(CurUser.hasRole("602")){
			         sSubmitResultField = sResult3;
			     }else if(CurUser.hasRole("603")){
			         sSubmitResultField = sResult4;
			     }
	         } 
	         if(sSubmitResultField.equals("")){
	              sDeclareCashInfo[i] = "减值准备测算值信息不全";
	              k = k+1;
	          }
	         /*
             if(sConfirmDate.equals("")){
	              sDeclareLossInfo[i] = "损失识别期间信息不全";
	              k = k+1;
	          }
             if(sExtendTime.equals("")){
	              sDeclareBaseInfo[i] = "不良贷款信息不全";
	              k = k+1;
	         }
	         */
	         if(k != i){
	             sDeclareSerialNo[i] = sDuebillNo;
	             i = i + 1;
	             sReturnValue = "99";
	          }
	       }
	       rsTemp.getStatement().close();
	   }
	}catch(Exception e){
		sReturnValue = "01";
		e.printStackTrace();
		System.out.println(e.toString());
    }
%>
<%if ( i> 0){%>
 <HEAD>
	<title></title>
	<STYLE>
		.table1 {  border: solid; border-width: 1px 1px 2px 2px; border-color: #000000 black #000000 #000000} 
		.td1 {  border-color: #000000 #000000 black black; height:25px;border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px;font-size: 10pt; color: #000000}
	</STYLE>	
</HEAD>

<body class="ReportPage" leftmargin="0" topmargin="0" onload=" " style="overflow-x:scroll;overflow-y:scroll" >
<table align='center' cellspacing=0 cellpadding=0 width='100%' style='display=none;'>
	<tr>
		<td height=30 valign='middle' style='BORDER-bottom: #000000 0px solid;'>
		</td>
	</tr>
</table>

<table border="0" width="100%" height="100%" cellspacing="0" cellpadding="0" >
	<tr id="DetailTitle" class="DetailTitle" >
		<td colspan=2>
		</td>
	</tr>	
	<tr height=1 valign=top id="buttonback" >
		<td colspan=2>
			<table>
				<tr>					
	    		<td>
						<%=HTMLControls.generateButton("关闭","关闭页面","javascript:self.close()",sResourcesPath)%>
	    		</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr height=1 >
		<td colspan=2>&nbsp;</td>
	</tr>	
	<tr valign="top" >
		<td>&nbsp;</td>
	    <td style='BORDER-bottom: #000000 1px solid;' > 
				<div id=reporttable>
					<table class=table1 width="100%" align=left border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >
						<tr> 
					    <td class=td1 align=middle>序号</td>				    
					    <td class=td1 align=middle>信息完备性检查</td>				   			   
						</tr>	
					<%
						for(int j = 0 ; j <i ; j++)
						{
					%>	
						<tr>		
							<td class=td1 align=left>&nbsp;<%=j+1%>.</td>
							<td class=td1 align=left>&nbsp;
							<%
							    if(sDeclareLossInfo[j] != null || sDeclareCashInfo[j] != null || sDeclareBaseInfo[j] != null){
							       out.print("[" + sDeclareSerialNo[j]+ "]: ");
							       if(sDeclareCashInfo[j] != null){
							          out.println(sDeclareCashInfo[j]);
							       }
							       if(sDeclareLossInfo[j] != null){
							          out.println(sDeclareLossInfo[j]);
							       }
							       if(sDeclareBaseInfo[j] != null){
							          out.println(sDeclareBaseInfo[j]);
							       }
							    }
							%>
							</td>
						</tr>
				  	<%
				    		   
				  		}
	  				%>
				</table>
			</div>									
		</td>
	</tr>	
</table>
</body>
</html>
<%}%>
<script language=javascript>
	self.returnValue="<%=sReturnValue%>";
	<%if(i==0){%>
	   self.close();
	<%}%>   
</script>
<%@ include file="/IncludeEnd.jsp"%>
