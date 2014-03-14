<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>
<%@page import="javax.servlet.jsp.*"%>
<%@page import="javax.servlet.http.*"%>
<%@page import="javax.servlet.*" %>
<%@page import="com.amarsoft.*" %>
<%@page import="java.*" %>


<%
	//获取页面参数
		String sObjectType = DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectType"));
		String sObjectNo= DataConvert.toRealString(iPostChange,CurPage.getParameter("ObjectNo"));
		String sCurFlowNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("FlowNo"));
		String sCurPhaseNo = DataConvert.toRealString(iPostChange,CurPage.getParameter("PhaseNo"));
		String sBusinessType= DataConvert.toRealString(iPostChange,CurPage.getParameter("BusinessType"));
		String sPhaseType = DataConvert.toRealString(iPostChange,CurPage.getParameter("PhaseType"));
		String sDrawingType = DataConvert.toRealString(iPostChange,CurPage.getParameter("DrawingType"));
		ASResultSet rs = null;
		String sManageDepartFlag="",sVouchTypeName="";
		String BarCode = "",ObjectTypeNo = "";//条形码和阶段编号
		String ApplySerialno = sObjectNo , sApproveRelativeSerialNO = "" ;//申请流水号 \批复流水号
		if("BusinessApplyList".equals(sPhaseType)){
	rs = Sqlca.getASResultSet("Select ManageDepartFlag,BusinessType from Business_Apply where serialno='"+sObjectNo+"' ");
	if(rs.next()){
		 sBusinessType = rs.getString("BusinessType");
		 sManageDepartFlag = rs.getString("ManageDepartFlag"); 
	 }
		}else if("BusinessPutOutList".equals(sPhaseType)){
	rs = Sqlca.getASResultSet("Select bc.RelativeSerialNO,bc.ManageDepartFlag,bc.BusinessType, bc.DrawingType from Business_Putout bp,business_contract bc where bp.Serialno='"+sObjectNo+"' and bp.contractserialno=bc.serialno ");
	if(rs.next()){
		sBusinessType = rs.getString("BusinessType");
		sManageDepartFlag = rs.getString("ManageDepartFlag");
		sApproveRelativeSerialNO = rs.getString("RelativeSerialNO");
		//sDrawingType = rs.getString("DrawingType");
	}
	ApplySerialno = Sqlca.getString("SELECT RelativeSerialNO FROM BUSINESS_APPROVE WHERE SERIALNO ='"+sApproveRelativeSerialNO+"'");  
		}
		rs.getStatement().close();
		if(sDrawingType == null) sDrawingType = "01";
		//将空值转化为空字符串
		if(sObjectType==null)sObjectType="";
		if(sObjectNo==null)sObjectNo="";
		if(sCurFlowNo==null)sCurFlowNo="";
		if(sCurPhaseNo==null)sCurPhaseNo="";
		
		String sSql,sOpinionRightType="",sOpinionRightPhases="",sOpinionRightRoles="",sTempPrivilegePhases="",sPhaseAction="";
		boolean bRolePrivilege = false; //哪些阶段能看
		boolean bPhasePrivilege = false;//
		boolean bPhaseMatch = false;//判断当前意见所处阶段是否在对应的特权阶段
		
		//保留2位小数
		NumberFormat nf = NumberFormat.getInstance();
		nf.setMinimumFractionDigits(2);
		nf.setMaximumFractionDigits(2);
		
		String sFlowNo = "";
		String sPhaseNo = "";
		String sSelfOpinionPhase = "";
		String sSelfOpinion = "";
		String sPhaseName = "";
		String sUserName = "";
		String sOrgName = "";
		String sBeginTime = "";
		String sEndTime = "";
		String data[]=new String[3];
		String time[]=new String[2];
		String sCustomerName = "",sCustomerID="", sBusinessTypeName = "";
		String sRateFloatTypeName = "";
		double dBusinessSum = 0.0;
		double dBaseRate = 0.0;
		double dRateFloat = 0.0;
		double dBusinessRate = 0.0;
		double dBailSum = 0.0;
		double dBailRatio = 0.0;
		double dPromisesFeeRatio = 0.0;
		double dPromisesFeeSum = 0.0;
		double dPdgRatio = 0.0;
		double dPdgSum = 0.0;
		int iTermYear = 0;
		int iTermMonth = 0;
		int iTermDay = 0;
		int iCountRecord=0;//用于判断记录是否有审批意见
		double dInsum=0.0;//
		
		String sBusinesssum2="";
		int[] starttime=new int[3];
		int[] endtime=new int[3];
		String sVouchTypename="";
		String sPurpose="";
		
		String sBusinesssum="";
		String sInputdate="";
		StringBuffer sTemp = new StringBuffer();
	if(sBusinessType.startsWith("3")&&"BusinessApplyList".equals(sPhaseType)){
		rs=Sqlca.getResultSet(" select customername,CustomerID,getbusinessname(businesstype) as businessname,businesssum, getorgname(inputorgid)"+
					  " as orgname,inputdate from Business_Approve where RelativeSerialno='"+sObjectNo+"'");
		 if(rs.next()){
	 sCustomerName=rs.getString("customername");
	 sCustomerID = rs.getString("CustomerID");
	 if(sCustomerName==null)sCustomerName="&nbsp;";
	 sBusinessTypeName=rs.getString("businessname");
	 if(sBusinessTypeName==null)sBusinessTypeName="&nbsp;";
	 sBusinesssum=nf.format(rs.getDouble("businesssum")/10000);
	 if(sBusinesssum==null)sBusinesssum="&nbsp;";
	 else sBusinesssum=sBusinesssum+"&nbsp;万元";
	 sOrgName=rs.getString("orgname");
	 if(sOrgName==null)sOrgName="&nbsp;";
	 sInputdate=rs.getString("inputdate");
	 if(sInputdate==null){sInputdate="&nbsp";}
	 else {
		   data=sInputdate.split("/");
		   data[0]=data[0]+"年";
		   data[1]=data[1]+"月";
		   data[2]=data[2]+"日";
	 }
		
	
	  
		sTemp.append("<div   align=center><font style='font-size: 24px; FONT-WEIGHT: bold'>信贷业务调查审查审批表</font></div>");
		sTemp.append("<table width='640' align='center' border='1' cellspacing='2' cellpadding='0' bordercolor='#000000' style='border-collapse:collapse'> ");
		sTemp.append("<tr >  ");
		sTemp.append("<td  ><font style='font-size: 14px; '> ");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;客&nbsp;户&nbsp;名&nbsp;称：&nbsp;"+sCustomerName+"<br/>");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;业&nbsp;务&nbsp;种&nbsp;类：&nbsp;"+sBusinessTypeName+"<br/>  ");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;金&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;额：&nbsp;"+sBusinesssum+"<br/> "); 
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;申&nbsp;报&nbsp;单&nbsp;位：&nbsp;"+sOrgName+"<br/>  ");
		sTemp.append("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;申&nbsp;报&nbsp;日&nbsp;期：&nbsp;"+data[0]+data[1]+data[2]+"<br/></td></font> "); 
		sTemp.append("</tr>  ");
		sTemp.append("</table>  ");

		 
		 }
	}else if("001001".equals(sManageDepartFlag)&&"BusinessApplyList".equals(sPhaseType)){
		rs=Sqlca.getASResultSet(" select  bap.CustomerName,bap.CustomerID,bap.BusinessSum as BusinessSum1,getBusinessName(bap.BusinessType) as BusinessName,"+
		                " getOrgName(bap.inputorgid) as OrgName ,getItemName('VouchType',bap.VouchType) as VouchTypeName,bc.businesssum as"+
		                " businesssum2 ,gc.GuarantorName  from Business_Approve bap left join business_contract bc on bap.creditaggreement=bc.serialno "+
		                " ,apply_relative ar,guaranty_contract gc where bap.Relativeserialno=ar.serialno and objecttype='GuarantyContract' and ar.objectno=gc.serialno  "+
		                "  and bap.Relativeserialno='"+sObjectNo+"'");
		if(rs.next()){
	sCustomerName=rs.getString("CustomerName");
	sCustomerID = rs.getString("CustomerID");
	if(sCustomerName==null)sCustomerName="&nbsp;";
	
	 sBusinessTypeName=rs.getString("BusinessName");
	 if(sBusinessTypeName==null)sBusinessTypeName="&nbsp;";	 
	 sBusinesssum=DataConvert.toMoney(rs.getString("BusinessSum1"));
	 sBusinesssum2=DataConvert.toMoney(rs.getString("BusinessSum2"));
	 if(sBusinesssum2==null) sBusinesssum2 ="&nbsp;&nbsp;&nbsp;&nbsp;";
	 sOrgName=rs.getString("OrgName");
	 if(sOrgName==null)sOrgName="&nbsp;";
	 
	sVouchTypename=rs.getString("VouchTypeName");
	if(sVouchTypename==null)sVouchTypename="&nbsp;";
	
	String GuarantorName=rs.getString("GuarantorName");
	if(GuarantorName==null)GuarantorName="&nbsp;";
		
	sTemp.append("<div align='center'><font style='font-size: 24px; FONT-WEIGHT: bold'>用信审查审批表</p></font> </div>");
	sTemp.append("<table width='640' style='font-size: 14px;' align='center' border='1' cellspacing='2' cellpadding='0' bordercolor='#000000' style='border-collapse:collapse'>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black' >用信申请人</td>");
	sTemp.append("<td class='black' colspan=3>&nbsp;"+sCustomerName+" </td>");
	sTemp.append("<td class='black'>经办机构</td>");
	sTemp.append("<td class='black' >&nbsp;"+sOrgName+" </td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black'>综合授信额度</td>");
	sTemp.append("<td class='black'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sBusinesssum2+" </td>");
	sTemp.append("<td class='black'>已使用额度</td>");
	sTemp.append("<td class='black'>&nbsp; </td>");
	sTemp.append("<td class='black'>剩余额度</td>");
	sTemp.append("<td class='black'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black'  colspan=2>本次申请用信金额</td>");
	sTemp.append("<td class='black'>&nbsp;"+sBusinesssum+" </td>");
	sTemp.append("<td class='black' colspan=2>申请用信品种</td>");
	sTemp.append("<td class='black'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+sBusinessTypeName+" </td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black'>担保方式</td>");
	sTemp.append("<td class='black'  colspan=2>&nbsp; "+sVouchTypename+"</td>");
	sTemp.append("<td class='black'>担保人</td>");
	sTemp.append("<td class='black'  colspan=2>&nbsp;"+GuarantorName+" </td>");
	sTemp.append("</tr>");
	sTemp.append("</table>");
		}

	}else if("001002".equals(sManageDepartFlag)&&"BusinessApplyList".equals(sPhaseType)){
		String sBaseRate = "";//基准年利率
		String sBusinessRate = "";//执行年利率
		String sTermMonth = "";//期限
		rs = Sqlca.getASResultSet(" select CustomerName,CustomerID,getOrgName(InputOrgID) as OrgName,"+
						  " getBusinessName(BusinessType) as BusinessTypeName,BusinessSum,TermMonth,"+
						  " getItemName('VouchType',VouchType) as VouchTypeName,InputDate,Purpose,BaseRate,BusinessRate,"+
						  " TermMonth from BUSINESS_Approve where RelativeSerialNo='"+sObjectNo+"'");
		if(rs.next()){
	sCustomerName=rs.getString("CustomerName");
	sCustomerID = rs.getString("CustomerID");
	if(sCustomerName==null)sCustomerName="&nbsp;";
	
	 sBusinessTypeName=rs.getString("BusinessTypeName");
	 if(sBusinessTypeName==null)sBusinessTypeName="&nbsp;";	 
	 sBusinesssum=DataConvert.toMoney(rs.getString("BusinessSum"));
	 if(sBusinesssum==null) sBusinesssum ="&nbsp;&nbsp;&nbsp;&nbsp;";
	 sOrgName=rs.getString("OrgName");
	 if(sOrgName==null)sOrgName="&nbsp;";
	  sBaseRate=rs.getString("BaseRate");
	 if(sBaseRate==null)sBaseRate="&nbsp;";
	  sBusinessRate=rs.getString("BusinessRate");
	 if(sBusinessRate==null)sBusinessRate="&nbsp;";
	 sTermMonth = rs.getString("TermMonth");
	 if(sTermMonth==null)sTermMonth="&nbsp;";
	sVouchTypename=rs.getString("VouchTypeName");
	if(sVouchTypename==null)sVouchTypename="&nbsp;";
		 
	sTemp.append("<div align='center'><font style='font-size: 24px; FONT-WEIGHT: bold'>小企业审查审批表</p></font><br>");
	sTemp.append("经办部门：&nbsp;"+sOrgName+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 单位：人民币元");
	sTemp.append("</div>");
	sTemp.append("<table width='640' style='font-size: 14px;' align='center' border='1' cellspacing='2' cellpadding='0' bordercolor='#000000' style='border-collapse:collapse'>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black' colspan = 6>客户全称：");
	sTemp.append("&nbsp;"+sCustomerName+" </td>");
	sTemp.append("</tr>");
	sTemp.append("   <tr>");
	sTemp.append("   <td  align=center  class='black' colspan = 6><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black ' >本次拟放款</font></td>");//<br>贷款开立<br></td>");
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black'  align=center>业务品种</td>");
	sTemp.append("<td class='black'  align=center>审批额度 </td>");
	sTemp.append("<td class='black'  align=center>担保方式 </td>");
	sTemp.append("<td class='black'    align=center>期限（月） </td>");
	sTemp.append("<td class='black'  align=center>费率</td>");
	sTemp.append("<td class='black'  align=center>浮动比率 </td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black' align=center>"+sBusinessTypeName+"&nbsp;</td>");
	sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(sBusinesssum)+"&nbsp; </td>");
	sTemp.append("<td class='black' align=center>"+sVouchTypename+"&nbsp;</td>");
	sTemp.append("<td class='black' align=center>"+sTermMonth+"&nbsp; </td>");
	sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(sBaseRate)+"&nbsp; </td>");
	sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(sBusinessRate)+"%&nbsp;</td>");
	sTemp.append("</tr>");
	sTemp.append("</table>");
		}

	}else if(("001004".equals(sManageDepartFlag) || "001003".equals(sManageDepartFlag))&&"BusinessApplyList".equals(sPhaseType)){
		String sTermMonth = "";//期限
		rs = Sqlca.getASResultSet(" select CustomerName,CustomerID,getOrgName(InputOrgID) as OrgName,getBusinessName(BusinessType) as BusinessTypeName,"+
						  " BusinessSum,TermMonth,getItemName('VouchType',VouchType) as VouchTypeName,InputDate,Purpose,"+
						  " TermMonth from BUSINESS_Approve where RelativeSerialNo='"+sObjectNo+"'");
		if(rs.next())
		{			
	sCustomerName=rs.getString("CustomerName");
	if(sCustomerName==null)sCustomerName="&nbsp;";
	
	sCustomerID = rs.getString("CustomerID");
	sBusinesssum=nf.format(rs.getDouble("BusinessSum"));
	sOrgName = rs.getString("OrgName");
	iTermMonth=rs.getInt("TermMonth");
	sVouchTypename=rs.getString("VouchTypeName");
	if(sVouchTypename==null)sVouchTypename="&nbsp;";
	sTermMonth = rs.getString("TermMonth");
	if(sTermMonth==null)sTermMonth="&nbsp;";
	sBusinessTypeName=rs.getString("BusinessTypeName");
	if(sBusinessTypeName==null)sBusinessTypeName="&nbsp;";	 
	sBeginTime=rs.getString("InputDate");
	if(sBeginTime==null){sBeginTime="&nbsp;";}
	else{
		String data1[]=new String[3];
		data1=sBeginTime.split("/");
		starttime[0]=Integer.parseInt(data1[0]);
		starttime[1]=Integer.parseInt(data1[1]);
		starttime[2]=Integer.parseInt(data1[2]);
		
		int month=starttime[1]+iTermMonth;
		if(month<12){
			endtime[0]=starttime[0];
			endtime[1]=month;
			endtime[2]=starttime[2];				
		}else if(month==12){
			endtime[0]=starttime[0]+1;
			endtime[1]=1;
			endtime[2]=starttime[2];
		}else if(month>12){
			if(month%12==0){
				endtime[0]=starttime[0]+Integer.parseInt((month/12)+"");
				endtime[1]=1;
				endtime[2]=starttime[2];
			}else{
				endtime[0]=starttime[0]+Integer.parseInt((month/12)+"");
				endtime[1]=Integer.parseInt((month%12)+"");
				endtime[2]=starttime[2];
			}
		}
	}
	sPurpose=rs.getString("Purpose");
	if(sPurpose==null)sPurpose="&nbsp;";
	
	if("001004".equals(sManageDepartFlag)){
		sTemp.append("<div align='center'><font style='font-size: 24px; FONT-WEIGHT: bold'>个人贷款审查审批表</p></font> </div>");
	}else{
		sTemp.append("<div align='center'><font style='font-size: 24px; FONT-WEIGHT: bold'>微小贷款审查审批表</p></font> </div>");
	}
	
	 
	
	sTemp.append("<table width='640' style='font-size: 14px;' align='center' border='1' cellspacing='2' cellpadding='0' bordercolor='#000000' style='border-collapse:collapse'>");
	sTemp.append("   <tr>");
	sTemp.append("   <td  align=center colspan = 4 class='black' ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black ' >贷     款     审     批     情     况</font></td>");//<br>贷款开立<br></td>");
	sTemp.append("   </tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black' colspan = 1>借款人 </td>");
	sTemp.append("<td class='black' colspan = 3>&nbsp;"+sCustomerName+" </td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black' >贷款金额 </td>");
	sTemp.append("<td class='black' >&nbsp;"+sBusinesssum+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;元 </td>");
	sTemp.append("<td class='black' >贷款期限 </td>");
	sTemp.append("<td class='black' >&nbsp;"+sTermMonth+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月 </td>");
	sTemp.append("</tr>");
	sTemp.append("<tr>");
	sTemp.append("<td class='black' >业务品种</td>");
	sTemp.append("<td class='black' >&nbsp;"+sBusinessTypeName+" </td>");
	sTemp.append("<td class='black' >担保方式</td>");
	sTemp.append("<td class='black' >&nbsp;"+sVouchTypename+" </td>");
	sTemp.append("</tr>");
	sTemp.append("</table>");
		}
	}else 	if( "BusinessPutOutList".equals(sPhaseType)&&sDrawingType.equals("01")){//打印放款信息 add by jlwang 20130624
	 	System.out.println("BusinessPutOutList".equals(sPhaseType)&&sDrawingType.equals("01"));
		String sBaseRate = "";//基准年利率
		String sBusinessRate = "";//执行年利率
		double dInUseSum = 0;//未提款额
		double dContractSum = 0;//已核准额
		double dPromisesfeeSum = 0;//承诺费金额
		double dPDGSum = 0;//手续费金额
		double dPDGRatio = 0;//手续费率
		rs = Sqlca.getASResultSet("select bp.CustomerName,bp.CustomerID,getOrgName(bp.InputOrgID) as OrgName,getBusinessName(bp.BusinessType) as BusinessTypeName,"
				+"bp.BusinessSum,bp.BaseRate,bp.BusinessRate,bp.BusinessSum,bp.PutOutDate,bp.Maturity,bp.ContractSum/10000 as ContractSum,"
				+"bp.PromisesfeeSum,bp.PDGSum,bp.PDGRatio,bp.BailSum,bp.BailRatio,"
				+"getItemName('VouchType',bc.VouchType) as VouchTypeName"
				+" from BUSINESS_PUTOUT bp,business_contract bc where bp.SerialNo='"+sObjectNo+"'"
				+" and bc.serialno=bp.contractserialno ");
		if(rs.next())
		{
			sCustomerName = rs.getString("CustomerName");
			if(sCustomerName == null) sCustomerName = " ";
			
			sCustomerID = rs.getString("CustomerID");
			
			sOrgName = rs.getString("OrgName");
			if(sOrgName == null) sOrgName = " ";
			
			sBusinessTypeName = rs.getString("BusinessTypeName");
			if(sBusinessTypeName == null) sBusinessTypeName = " ";
			
			dContractSum = rs.getDouble("ContractSum");
			dBusinessSum = rs.getDouble("BusinessSum")/10000;
			dBusinessSum = rs.getDouble("BusinessSum")/10000;
			dBailRatio = rs.getDouble("BailRatio")/100;
			dBailSum = dBailRatio*dBusinessSum;		
			dPromisesfeeSum = rs.getDouble("PromisesfeeSum");
			dPDGRatio = rs.getDouble("PDGRatio")*0.1;
			dPDGSum = dPDGRatio*dBusinessSum; 
			
			sBaseRate=rs.getString("BaseRate");
			if(sBaseRate.equals("0.000000") || sBaseRate == null) sBaseRate = Double.toString(dBailSum/dBusinessSum);
			sBusinessRate=rs.getString("BusinessRate");
			if(sBusinessRate.equals("0.000000") || sBusinessRate == null) sBusinessRate = Double.toString((dPromisesfeeSum+dPDGSum)/dBusinessSum);
			
			sBeginTime=rs.getString("PutOutDate");
			if(sBeginTime==null)sBeginTime=" ";
			 
			sEndTime=rs.getString("Maturity");
			if(sEndTime==null)sEndTime="&nbsp;";
			sVouchTypeName = rs.getString("VouchTypeName");
			if(sVouchTypeName==null) sVouchTypeName="&nbsp;";
			
			sTemp.append("<div align='center'><font style='font-size: 24px; FONT-WEIGHT: bold'>信贷业务放款核准审批表</font> 编号：<br/><br/>");
			sTemp.append("经办机构盖章：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 单位：人民币万元");
			sTemp.append("</div>");
			sTemp.append("<table width='640' align='center' border='1' cellspacing='2' cellpadding='0' bordercolor='#000000' style='border-collapse:collapse'>");
			sTemp.append("<tr> <td class='black'  colspan=7>客户全称：&nbsp;&nbsp;"+sCustomerName+"&nbsp;&nbsp;&nbsp;</td></tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class='black' rowspan=2 align=center>业务品种</td>");
			sTemp.append("<td class='black' rowspan=2 align=center>总授信额/本次核准额 </td>");
			sTemp.append("<td class='black' rowspan=2 align=center>担保方式 </td>");
			sTemp.append("<td class='black'  colspan=2  align=center>期限 </td>");
			sTemp.append("<td class='black' rowspan=2 align=center>基准年利率(保证金%)</td>");
			sTemp.append("<td class='black' rowspan=2 align=center>执行年利率(手续费+承诺费%) </td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class='black' align=center>开始日</td>");
			sTemp.append("<td class='black' align=center>到期日 </td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class='black' align=center>"+sBusinessTypeName+"&nbsp;</td>");
			sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(dContractSum)+"/"+DataConvert.toMoney(dBusinessSum)+"&nbsp; </td>");
			sTemp.append("<td class='black' align=center>"+sVouchTypeName+"&nbsp;</td>");
			sTemp.append("<td class='black' align=center>"+sBeginTime+"&nbsp; </td>");
			sTemp.append("<td class='black' align=center>"+sEndTime+"&nbsp;</td>");
			sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(sBaseRate)+"&nbsp; </td>");
			sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(sBusinessRate)+"&nbsp;</td>");
			sTemp.append("</tr>");
			
			}
		String scondition1 = "";
		String scondition2 = "";
		String scondition3 = "";
		String scondition4 = "";
		String scondition5 = "";
		String scondition6 = "";
		
		String sworkable1 = "";
		String sworkable2 = "";
		String sworkable3 = "";
		String sworkable4 = "";
		String sworkable5 = "";
		String sworkable6 = "";
		rs = Sqlca.getASResultSet("SELECT condition1,workable1,"
								 +"condition2,workable2,"
								 +"condition3,workable3,"
								 +"condition4,workable4,"
								 +"condition5,workable5,"
								 +"condition6,workable6"
								 +" FROM flow_task ft,flow_opinion fo where ft.serialno=fo.serialno and ft.objectno='"
								 +sObjectNo
								 +"' and ft.flowno='PutOutFlow'");
		if(rs.next()){
			scondition1 = rs.getString("condition1");
			if(scondition1 == null) scondition1 = " ";
			scondition2 = rs.getString("condition2");
			if(scondition2 == null) scondition2 = " ";
			scondition3 = rs.getString("condition3");
			if(scondition3 == null) scondition3 = " ";
			scondition4 = rs.getString("condition4");
			if(scondition4 == null) scondition4 = " ";
			scondition5 = rs.getString("condition5");
			if(scondition5 == null) scondition5 = " ";
			scondition6 = rs.getString("condition6");
			if(scondition6 == null) scondition6 = " ";
			
			sworkable1 = rs.getString("workable1");
			if(sworkable1 != null){
				if(sworkable1.equals("1")){ sworkable1 = "是";
				}else if(sworkable1.equals("2")){ sworkable1 = "否";
				}else { sworkable1 = " ";}
			}else { sworkable1 = " ";}
			
			sworkable2 = rs.getString("workable2");
			if(sworkable2 != null){
				if(sworkable2.equals("1")){ sworkable2 = "是";
				}else if(sworkable2.equals("2")){ sworkable2 = "否";
				}else { sworkable2 = " ";}
			}else { sworkable2 = " ";}
				
			sworkable3 = rs.getString("workable3");
			if(sworkable3 != null){
				if(sworkable3.equals("1")){ sworkable3 = "是";
				}else if(sworkable3.equals("2")){ sworkable3 = "否";
				}else { sworkable3 = " ";}
			}else { sworkable3= " ";}
				
			sworkable4 = rs.getString("workable4");
			if(sworkable4 != null){
				if(sworkable4.equals("1")){ sworkable4 = "是";
				}else if(sworkable4.equals("2")){ sworkable4 = "否";
				}else { sworkable4 = " ";}
			}else { sworkable4 = " ";}
				
			sworkable5 = rs.getString("workable5");
			if(sworkable5 != null){
				if(sworkable5.equals("1")){ sworkable5 = "是";
				}else if(sworkable5.equals("2")){ sworkable5 = "否";
				}else { sworkable5 = " ";}
			}else { sworkable5 = " ";}
				
			sworkable6 = rs.getString("workable6");
			if(sworkable6 != null){
				if(sworkable6.equals("1")){ sworkable6 = "是";
				}else if(sworkable6.equals("2")){ sworkable6 = "否";
				}else { sworkable6 = " ";}
			}else { sworkable6 = " ";}
		
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=center colspan=4>提款条件</td>");
			sTemp.append("<td class=td1 align=center colspan=3>落实情况</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=4>"+scondition1 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=3>"+sworkable1 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=4>"+scondition2 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=3>"+sworkable2 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=4>"+scondition3 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=3>"+sworkable3 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=4>"+scondition4 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=3>"+sworkable4 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=4>"+scondition5 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=3>"+sworkable5 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=4>"+scondition6 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=3>"+sworkable6 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("</table>");
			}
		} else if("BusinessPutOutList".equals(sPhaseType)&&sDrawingType.equals("02")){
			String sBaseRate = "";//基准年利率
			String sBusinessRate = "";//执行年利率
			double dInUseSum = 0;//未提款额
			double dContractSum = 0;//已核准额
			double dPromisesfeeSum = 0;//承诺费金额
			double dPDGSum = 0;//手续费金额
			double dPDGRatio = 0;//手续费率
			rs = Sqlca.getASResultSet("select CustomerName,CustomerID,getOrgName(InputOrgID) as OrgName,getBusinessName(BusinessType) as BusinessTypeName,"
					+"GETUSDSUM(ContractSerialNo) as InUseSum,BaseRate,BusinessRate,BusinessSum,PutOutDate,Maturity,ContractSum/10000 as ContractSum,"
					+"PromisesfeeSum,PDGSum,PDGRatio,BailSum,BailRatio"
					+" from BUSINESS_PUTOUT where SerialNo='"+sObjectNo+"'");
			if(rs.next())
			{
				sCustomerName = rs.getString("CustomerName");
				if(sCustomerName == null) sCustomerName = " ";
				sCustomerID = rs.getString("CustomerID");
				sOrgName = rs.getString("OrgName");
				if(sOrgName == null) sOrgName = " ";
				
				sBusinessTypeName = rs.getString("BusinessTypeName");
				if(sBusinessTypeName == null) sBusinessTypeName = " ";
				
				dContractSum = rs.getDouble("ContractSum");
				dInUseSum = rs.getDouble("InUseSum")/10000;
				dBusinessSum = rs.getDouble("BusinessSum")/10000;
				dBailRatio = rs.getDouble("BailRatio")/100;
				dBailSum = dBailRatio*dBusinessSum;		
				dPromisesfeeSum = rs.getDouble("PromisesfeeSum");
				dPDGRatio = rs.getDouble("PDGRatio")*0.1;
				dPDGSum = dPDGRatio*dBusinessSum; 
				System.out.println(dBusinessSum);
				sBaseRate=rs.getString("BaseRate");
				if(sBaseRate.equals("0.000000") || sBaseRate == null) sBaseRate = Double.toString(dBailSum/dBusinessSum);
				sBusinessRate=rs.getString("BusinessRate");
				if(sBusinessRate.equals("0.000000") || sBusinessRate == null) sBusinessRate = Double.toString((dPromisesfeeSum+dPDGSum)/dBusinessSum);
				
				sBeginTime=rs.getString("PutOutDate");
				if(sBeginTime==null)sBeginTime=" ";
				 
				sEndTime=rs.getString("Maturity");
				if(sEndTime==null)sEndTime="&nbsp;";

		
				sTemp.append("<div align='center'><font style='font-size: 24px; FONT-WEIGHT: bold'>提款审批表</font> 编号：<br/><br/>");
				sTemp.append("经办机构盖章：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 单位：人民币万元");
				sTemp.append("</div>");
				sTemp.append("<table width='640' align='center' border='1' cellspacing='2' cellpadding='0' bordercolor='#000000' style='border-collapse:collapse'>");
				sTemp.append("<tr> <td class='black'  colspan=7>客户全称：&nbsp;&nbsp;"+sCustomerName +"&nbsp;&nbsp;&nbsp;</td></tr>");
				sTemp.append("<tr>");
				sTemp.append("<td class='black' rowspan=2 align=center>业务品种</td>");
				sTemp.append("<td class='black' rowspan=2 align=center>已核准额/未提款额 </td>");
				sTemp.append("<td class='black' rowspan=2 align=center>本次提款额 </td>");
				sTemp.append("<td class='black'  colspan=2  align=center>期限 </td>");
				sTemp.append("<td class='black' rowspan=2 align=center>基准年利率(保证金%)</td>");
				sTemp.append("<td class='black' rowspan=2 align=center>执行年利率(手续费+承诺费%) </td>");
				sTemp.append("</tr>");
				sTemp.append("<tr>");
				sTemp.append("<td class='black' align=center>开始日</td>");
				sTemp.append("<td class='black' align=center>到期日 </td>");
				sTemp.append("</tr>");
				sTemp.append("<tr>");
				sTemp.append("<td class='black' align=center>"+sBusinessTypeName +"&nbsp;</td>");
				sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(dContractSum) +"/"+dInUseSum +"&nbsp; </td>");
				sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(dBusinessSum) +"&nbsp;</td>");
				sTemp.append("<td class='black' align=center>"+sBeginTime +"&nbsp; </td>");
				sTemp.append("<td class='black' align=center>"+sEndTime +"&nbsp;</td>");
				sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(sBaseRate) +"&nbsp; </td>");
				sTemp.append("<td class='black' align=center>"+DataConvert.toMoney(sBusinessRate)+"&nbsp;</td>");
				sTemp.append("</tr>");
				
		String scondition1 = "";
		String scondition2 = "";
		String scondition3 = "";
		String scondition4 = "";
		String scondition5 = "";
		String scondition6 = "";
		
		String sworkable1 = "";
		String sworkable2 = "";
		String sworkable3 = "";
		String sworkable4 = "";
		String sworkable5 = "";
		String sworkable6 = "";
		
		String sphaseno = "";
		rs = Sqlca.getASResultSet("SELECT condition1,workable1,"
								 +"condition2,workable2,"
								 +"condition3,workable3,"
								 +"condition4,workable4,"
								 +"condition5,workable5,"
								 +"condition6,workable6 "
								 +" FROM flow_task ft,flow_opinion fo where ft.serialno=fo.serialno and ft.objectno='"
								 +sObjectNo
								 +"' and ft.flowno='PutOutFlow'");
		if(rs.next()){
			scondition1 = rs.getString("condition1");
			if(scondition1 == null) scondition1 = " ";
			scondition2 = rs.getString("condition2");
			if(scondition2 == null) scondition2 = " ";
			scondition3 = rs.getString("condition3");
			if(scondition3 == null) scondition3 = " ";
			scondition4 = rs.getString("condition4");
			if(scondition4 == null) scondition4 = " ";
			scondition5 = rs.getString("condition5");
			if(scondition5 == null) scondition5 = " ";
			scondition6 = rs.getString("condition6");
			if(scondition6 == null) scondition6 = " ";
			
			sworkable1 = rs.getString("workable1");
			if(sworkable1 != null){
				if(sworkable1.equals("1")){ sworkable1 = "是";
				}else if(sworkable1.equals("2")){ sworkable1 = "否";
				}else { sworkable1 = " ";}
			}else { sworkable1 = " ";}
			
			sworkable2 = rs.getString("workable2");
			if(sworkable2 != null){
				if(sworkable2.equals("1")){ sworkable2 = "是";
				}else if(sworkable2.equals("2")){ sworkable2 = "否";
				}else { sworkable2 = " ";}
			}else { sworkable2 = " ";}
				
			sworkable3 = rs.getString("workable3");
			if(sworkable3 != null){
				if(sworkable3.equals("1")){ sworkable3 = "是";
				}else if(sworkable3.equals("2")){ sworkable3 = "否";
				}else { sworkable3 = " ";}
			}else { sworkable3= " ";}
				
			sworkable4 = rs.getString("workable4");
			if(sworkable4 != null){
				if(sworkable4.equals("1")){ sworkable4 = "是";
				}else if(sworkable4.equals("2")){ sworkable4 = "否";
				}else { sworkable4 = " ";}
			}else { sworkable4 = " ";}
				
			sworkable5 = rs.getString("workable5");
			if(sworkable5 != null){
				if(sworkable5.equals("1")){ sworkable5 = "是";
				}else if(sworkable5.equals("2")){ sworkable5 = "否";
				}else { sworkable5 = " ";}
			}else { sworkable5 = " ";}
				
			sworkable6 = rs.getString("workable6");
			if(sworkable6 != null){
				if(sworkable6.equals("1")){ sworkable6 = "是";
				}else if(sworkable6.equals("2")){ sworkable6 = "否";
				}else { sworkable6 = " ";}
			}else { sworkable6 = " ";}
			
	
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=center colspan=5>提款条件</td>");
			sTemp.append("<td class=td1 align=center colspan=2>落实情况</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=5>"+scondition1 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=2>"+sworkable1 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=5>"+scondition2 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=2>"+sworkable2 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=5>"+scondition3 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=2>"+sworkable3 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=5>"+scondition4 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=2>"+sworkable4 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=5>"+scondition5 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=2>"+sworkable5 +"&nbsp;</td>");
			sTemp.append("</tr>");
			sTemp.append("<tr>");
			sTemp.append("<td class=td1 align=left colspan=5>"+scondition6 +"&nbsp;</td>");
			sTemp.append("<td class=td1 align=center colspan=2>"+sworkable6 +"&nbsp;</td>");
			sTemp.append("</tr>");
			}
			sTemp.append("</table>");

	}
	}
	
	rs.getStatement().close();
	 

	//各级人员意见保存在 FLOW_OPINION 中 ,如果需要显示一些其他意见需要修改签署意见界面进行配套
	//FLOW_MODEL添加的读于意见查看权限的判断，通过 Attribute2,
	String str =" ";
	String  sum =Sqlca.getString("Select count(*) from flow_task F  where ObjectNo='"+sObjectNo+"'  and ObjectType='"+sObjectType+"' and phaseno='3000'");
	if(Integer.parseInt(sum)>0){
		str =" having phaseNo<>'3000'";
	}
	sSql =	"select FO.SerialNo,FO.objectNo,FO.CustomerName,getItemName('Currency',FO.BusinessCurrency) as BusinessCurrencyName,  "+
	       " FO.TermYear,FO.TermMonth,FO.TermDay,FO.BaseRate,FO.RateFloat,FO.BusinessRate,"+
	       " FT.FlowNo,FT.PhaseNo,FT.PhaseName,"+
	       " FT.UserName,FT.OrgName,FT.PhaseAction,  FT.BeginTime,FT.EndTime,FT.PhaseChoice,FO.PhaseOpinion ,"+
	       " FO.PhaseOpinion1,FO.PhaseOpinion2,FO.PhaseOpinion3"+
	       " from (select max(serialno) as serialno,phaseno from flow_task F  where ObjectNo='"+sObjectNo+"'  and ObjectType='"+sObjectType+"' and phasename not like '%分发%' group by phaseno "+str+") tab1 left join "+
	       " FLOW_TASK FT  on tab1.Serialno=FT.SerialNo"+
	       " left join FLOW_OPINION FO on tab1.Serialno=FO.SerialNo "+
	       " where FO.PhaseOpinion is not null ";
	        if(sSelfOpinionPhase.equals(""))
		         sSql += " ORDER BY tab1.PhaseNo";
	       else
		         sSql += " and FT.PhaseNo <> '"+sSelfOpinionPhase+"' ORDER BY tab1.PhaseNo";
	       rs=Sqlca.getASResultSet(sSql);

	       sTemp.append("<table width='640' align='center' border='1' cellspacing='2' cellpadding='0' bordercolor='#000000' style='border-collapse:collapse'>");

	  String PhaseOpinion="";
        while (rs.next())
        {
        	
	sEndTime=DataConvert.toString(rs.getString("EndTime"));
	data=sEndTime.split("/");
	time=data[2].split("\\s+");

	if("0010".equals(rs.getString("PhaseNo"))&&Integer.parseInt(sum)>0){//获取最新的退回补充资料阶段的意见
	PhaseOpinion =Sqlca.getString(" select fo.PhaseOpinion from flow_opinion fo,flow_task ft where ft.serialno=fo.serialno and ft.objectno ='"+rs.getString("objectNo")+"' and ft.phaseno='3000' and  ft.ObjectType='"+sObjectType+"' order by ft.SerialNo desc fetch first 1 rows only ");	
	}else{
		 PhaseOpinion =StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion")).trim(),"\\r\\n","\r\n");
	}		
	
   
	sTemp.append("	 <tr>");
	sTemp.append("        <td class='black' rowspan=2 width=80  height=90>"+DataConvert.toString(rs.getString("PhaseName")) +"</td>");
	sTemp.append("       <td  colspan=1  height=70>");
	sTemp.append("    \r\n&nbsp;&nbsp;【意见】"+ PhaseOpinion +" \r\n ");
	sTemp.append("                     "+StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion1")).trim(),"\\r\\n","\r\n"));
	sTemp.append("                     "+StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion2")).trim(),"\\r\\n","\r\n")); 
	sTemp.append("                     "+StringFunction.replace(DataConvert.toString(rs.getString("PhaseOpinion3")).trim(),"\\r\\n","\r\n")); 
	sTemp.append("       </td>");
	sTemp.append("      </tr>");
	sTemp.append("      <tr><td class='black'  height=40 align=right>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;签字："+DataConvert.toString(rs.getString("UserName")) +"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+data[0] +"年&nbsp;&nbsp;"+data[1] +"月&nbsp;&nbsp;"+time[0] +"日&nbsp;&nbsp;"+time[1] +"</td></tr>");
    
      }
    rs.getStatement().close();
	sTemp.append("</table>");
	sTemp.append("");
	sTemp.append("<div id='PrintButton'>");
	sTemp.append("<table width='640' align='center'>");
	sTemp.append("<tr>");
	sTemp.append("<td align='center'>"+HTMLControls.generateButton("打印", "资料清单","javascript: my_Print()", sResourcesPath));
	sTemp.append("</td>");
	sTemp.append("<td align='center'>"+HTMLControls.generateButton("上传影像", "上传影像","javascript: upImage()", sResourcesPath));
	sTemp.append("</td>");
	sTemp.append("<td align='center'>"+HTMLControls.generateButton("返回", "返回","javascript: window.close()", sResourcesPath));
	sTemp.append("</td>");
	sTemp.append("</tr>");
	sTemp.append("</table>");
	sTemp.append("</div>");
	sTemp.append("</BODY>");
	String sReportInfo = sTemp.toString();
	String sPreviewContent = "pvw"+java.lang.Math.random();
	session.setAttribute(sPreviewContent,sTemp.toString());
	CurARC.setAttribute("PrintOpinion", sReportInfo);
	out.println(sReportInfo);
%>
<%
	/*~END~*/
%>
<script language="VBScript">
	dim hkey_root,hkey_path,hkey_key
	hkey_root="HKEY_CURRENT_USER"
	hkey_path="\Software\Microsoft\Internet Explorer\PageSetup"
	'//设置网页打印的页眉页脚为空
	function pagesetup_null()
	on error resume next
		Set RegWsh = CreateObject("WScript.Shell")
		hkey_key="\header" 
		RegWsh.RegWrite hkey_root+hkey_path+hkey_key,""
		hkey_key="\footer"
		RegWsh.RegWrite hkey_root+hkey_path+hkey_key,""
	
	end function
	'//设置网页打印的页眉页脚为默认值
	function pagesetup_default()
		on error resume next
		Set RegWsh = CreateObject("WScript.Shell")
		hkey_key="\header" 
		RegWsh.RegWrite hkey_root+hkey_path+hkey_key,"&w&b页码，&p/&P"
		hkey_key="\footer"
		RegWsh.RegWrite hkey_root+hkey_path+hkey_key,"&u&b&d"
	end function
</script>

	<script language="javascript">
		
		function my_Print()
		{
			pagesetup_null();
			beforePrint();
			//pagesetup_default();
			window.print();
			afterPrint();
		}
		function upImage(){
		
			OpenPage("/PublicInfo/ImageAction1.jsp?ObjectType=<%=sObjectType%>&ObjectNo=<%=sObjectNo%>&PhaseType=<%=sPhaseType%>&ManageDepartFlag=<%=sManageDepartFlag%>&BusinessType=<%=sBusinessType%>&ApplySerialno=<%=ApplySerialno%>&OrgName=<%=sOrgName%>&Inputdate=<%=sInputdate%>&BusinessTypeName=<%=sBusinessTypeName%>&CustomerID=<%=sCustomerID%>&CustomerName=<%=sCustomerName%>&DrawingType=<%=sDrawingType%>", "_self","");	 
		
		}
		function my_Cancle()
		{
			self.close();
		}		
		
		function beforePrint()
		{
			document.all('PrintButton').style.display='none';
		}
		
		function afterPrint()
		{
			document.all('PrintButton').style.display="";
		}
		
</script>
</HTML>

<%@ include file="/IncludeEnd.jsp"%>
