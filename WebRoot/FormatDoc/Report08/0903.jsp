<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>


<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author:   zwhu 20100917
		Tester:
		Content: 报告的第?页
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

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>
<%
	StringBuffer sTemp=new StringBuffer();
	sTemp.append("<form method='post' action='0903.jsp' name='reportInfo'>");	
	sTemp.append("<div id=reporttable>");	
	sTemp.append("<table class=table1 width='640' align=center border=1 cellspacing=0 cellpadding=2 bgcolor=white bordercolor=black bordercolordark=black >	");
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=12 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >5.3、<strong>担保情况情况说明</strong> </font></td>"); 	
	sTemp.append(" </tr>");
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=12 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><strong>质押物情况</strong> </font></td>"); 	
	sTemp.append(" </tr>");
	sTemp.append(" <tr>");
  	sTemp.append(" <td  align=center class=td1 > 质物名称</td>");
    sTemp.append(" <td  align=center class=td1 colspan=2> 单/折编号 </td>");
    sTemp.append(" <td  align=center class=td1 colspan=2> 出质人名称 </td>");
    sTemp.append(" <td  align=center class=td1 colspan=2> 质物金额</td>");
    sTemp.append(" <td  align=center class=td1 > 到期日 </td>");
    sTemp.append(" <td  align=center class=td1 > 质押债权金额 </td>");
    sTemp.append(" <td  align=center class=td1 > 经办银行/债劵代理发行行 </td>");
    sTemp.append(" <td  align=center class=td1 > 汽车合格证号码 </td>");
    sTemp.append(" <td  align=center class=td1 > 提单到期日 </td>");
    sTemp.append(" </tr>");	
	String sGuarantyType ="";
	String sGuarantyName = "";
	String sGuarantyRightID = "";
	String sOwnerName = "";
	String sEvalNetValue = "";
	String sEndDate = "";
	String sConfirmValue = "";
	String sGuarantyLocation = "";
	String sSql = " select GuarantyType,GuarantyName,GuarantyRightID,OwnerName,EvalNetValue,"+
				  " OwnerTime,BeginDate,ConfirmValue,case when Flag2 ='1' then GuarantyDescribe3 else GuarantyLocation end as GuarantyLocation "+
				  " from Guaranty_info where GuarantyID in "+
				  " (select GuarantyID from Guaranty_Relative where ObjectNo = '"+sObjectNo+"' and ObjectType = 'CreditApply')"+
				  " and GuarantyType in ('020010','020040','020070','020140','020120','020260')";
	ASResultSet rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		sGuarantyType = rs.getString("GuarantyType");
		if(sGuarantyType == null) sGuarantyType = "";
		sGuarantyName = rs.getString("GuarantyName");
		if(sGuarantyName == null) sGuarantyName = "";
		sGuarantyRightID = rs.getString("GuarantyRightID");
		if(sGuarantyRightID == null) sGuarantyRightID = "";
		sOwnerName = rs.getString("OwnerName");
		if(sOwnerName == null) sOwnerName = "";
		sEvalNetValue = DataConvert.toMoney(rs.getDouble("EvalNetValue"));
		if(sEvalNetValue == null) sEvalNetValue = "";
		if("020010".equals(sGuarantyType)){
			sEndDate = rs.getString("OwnerTime");
		}
		else if("020040".equals(sGuarantyType)){
			sEndDate = rs.getString("BeginDate");
		}
		if(sEndDate == null) sEndDate = "";
		sConfirmValue = DataConvert.toMoney(rs.getDouble("ConfirmValue"));
		if(sConfirmValue == null) sConfirmValue = "";
		sGuarantyLocation = rs.getString("GuarantyLocation");
		if(sGuarantyLocation == null) sGuarantyLocation = "";
		if("020140".equals(sGuarantyType)){
			sTemp.append(" <tr>");
		 	sTemp.append(" <td  align=center class=td1 > "+sGuarantyName+"&nbsp</td>");
			sTemp.append(" <td  align=center class=td1 colspan=2> "+""+"&nbsp </td>");
			sTemp.append(" <td  align=center class=td1 colspan=2> "+sOwnerName+"&nbsp </td>");
	   		sTemp.append(" <td  align=center class=td1 colspan=2>"+sEvalNetValue+"&nbsp</td>");
	   		sTemp.append(" <td  align=center class=td1 > "+sEndDate+"&nbsp </td>");
	  		sTemp.append(" <td  align=center class=td1 > "+sConfirmValue+"&nbsp </td>");
	  	 	sTemp.append(" <td  align=center class=td1 > "+sGuarantyLocation+"&nbsp </td>");
	  	 	sTemp.append(" <td  align=center class=td1 > "+sGuarantyRightID+"&nbsp </td>");
	  	 	sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp </td>");
	  	 	sTemp.append(" </tr>");	
		}else if("020120".equals(sGuarantyType)){
			sTemp.append(" <tr>");
		 	sTemp.append(" <td  align=center class=td1 > "+sGuarantyName+"&nbsp</td>");
			sTemp.append(" <td  align=center class=td1 colspan=2> "+""+"&nbsp </td>");
			sTemp.append(" <td  align=center class=td1 colspan=2> "+sOwnerName+"&nbsp </td>");
	   		sTemp.append(" <td  align=center class=td1 colspan=2>"+sEvalNetValue+"&nbsp</td>");
	   		sTemp.append(" <td  align=center class=td1 > "+sEndDate+"&nbsp </td>");
	  		sTemp.append(" <td  align=center class=td1 > "+sConfirmValue+"&nbsp </td>");
	  	 	sTemp.append(" <td  align=center class=td1 > "+sGuarantyLocation+"&nbsp </td>");
	  	 	sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp </td>");
	  	 	sTemp.append(" <td  align=center class=td1 > "+sGuarantyRightID+"&nbsp </td>");
	  	 	sTemp.append(" </tr>");	
		}else{
			sTemp.append(" <tr>");
		 	sTemp.append(" <td  align=center class=td1 > "+sGuarantyName+"&nbsp</td>");
			sTemp.append(" <td  align=center class=td1 colspan=2> "+sGuarantyRightID+"&nbsp </td>");
			sTemp.append(" <td  align=center class=td1 colspan=2> "+sOwnerName+"&nbsp </td>");
	   		sTemp.append(" <td  align=center class=td1 colspan=2>"+sEvalNetValue+"&nbsp</td>");
	   		sTemp.append(" <td  align=center class=td1 > "+sEndDate+"&nbsp </td>");
	  		sTemp.append(" <td  align=center class=td1 > "+sConfirmValue+"&nbsp </td>");
	  	 	sTemp.append(" <td  align=center class=td1 > "+sGuarantyLocation+"&nbsp </td>");
	  	 	sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp </td>");
	  	 	sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp </td>");
	  	 	sTemp.append(" </tr>");	
	  	 }	
	}
	rs.getStatement().close();
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=12 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><strong>抵押物情况</strong> </font></td>"); 	
	sTemp.append(" </tr>");	
	sTemp.append(" <tr>");
  	sTemp.append(" <td width=6% align=center class=td1 > 抵押物名称</td>");
    sTemp.append(" <td width=12% align=center class=td1 >抵押物坐落地址/运输工具类型/设备明细/其他 &nbsp  &nbsp&nbsp&nbsp&nbsp&nbsp</td>");
    sTemp.append(" <td width=10% align=center class=td1 > 权利人名称 &nbsp &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>");
    sTemp.append(" <td width=10% align=center class=td1 > 产权证号/房权证号/行驶证/设备规格型号</td>");
    sTemp.append(" <td width=8% align=center class=td1 > 设备数量&nbsp&nbsp&nbsp&nbsp</td>");
    sTemp.append(" <td width=6% align=center class=td1 > 土地性质 &nbsp&nbsp</td>");
    sTemp.append(" <td width=10% align=center class=td1 > 房产类型 &nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</td>");
    sTemp.append(" <td width=6% align=center class=td1 > 建筑面积 </td>");
    sTemp.append(" <td width=8% align=center class=td1 > 评估价格 </td>");
    sTemp.append(" <td width=8% align=center class=td1 > 评估单价 </td>");
    sTemp.append(" <td width=8% align=center class=td1 > 抵押单价 </td>");
    sTemp.append(" <td width=8% align=center class=td1 > 目前现状 </td>");
    sTemp.append(" </tr>");	
	
	String sGuarantyDescribe2="";
	String sThirdParty1="";
	String sGuarantyAmount="";
	String sGuarantyDescribe3="";
	String sGuarantySubType="";
	String sEvalUnitPrice="";
	String sGuarantyUsing="";
	String sAboutSum2 = "";
	double dGuarantyAmount = 0.0,dAboutSum2 = 0.0;	
	sSql = " select GuarantyType,GuarantyName,GuarantyLocation,GuarantyDescribe2,getItemName('DetailedType2',ThirdParty1) as ThirdParty1,"+
		   " OwnerName,GuarantyRightID,GuarantyAmount,getItemName('GuarantyGroundAttribute1',GuarantyDescribe3) as GuarantyDescribe3,"+
		   " getItemName('GagaType',GuarantySubType) as GuarantySubType,EvalNetValue,EvalUnitPrice,"+
		   " AboutSum2,getItemName('GroundStatus',GuarantyUsing) as GuarantyUsing"+
		   " from guaranty_info where GuarantyID in(select GuarantyID from Guaranty_Relative where ObjectNo = '"+sObjectNo+"' and ObjectType = 'CreditApply')"+
		   " and GuarantyType in ('010010','010030','010040','010050')";
	rs = Sqlca.getASResultSet(sSql);
	while(rs.next()){
		sGuarantyType = rs.getString("GuarantyType");
		if(sGuarantyType == null) sGuarantyType = "";
		sGuarantyName = rs.getString("GuarantyName");
		if(sGuarantyName == null) sGuarantyName = "";
		sGuarantyLocation = rs.getString("GuarantyLocation");
		if(sGuarantyLocation == null) sGuarantyLocation = "";
		sGuarantyDescribe2 = rs.getString("GuarantyDescribe2");
		if(sGuarantyDescribe2 == null) sGuarantyDescribe2 = "";
		sThirdParty1 = rs.getString("ThirdParty1");
		if(sThirdParty1 == null) sThirdParty1 = "";
		sOwnerName = rs.getString("OwnerName");
		if(sOwnerName == null) sOwnerName = "";
		sGuarantyRightID = rs.getString("GuarantyRightID");
		if(sGuarantyRightID == null) sGuarantyRightID = "";
		dGuarantyAmount = rs.getDouble("GuarantyAmount");
		sGuarantyAmount = DataConvert.toMoney(dGuarantyAmount);
		if(sGuarantyAmount == null) sGuarantyAmount = "";
		sGuarantyDescribe3 = rs.getString("GuarantyDescribe3");
		if(sGuarantyDescribe3 == null) sGuarantyDescribe3 = "";
		sGuarantySubType = rs.getString("GuarantySubType");
		if(sGuarantySubType == null) sGuarantySubType = "";
		sEvalUnitPrice = DataConvert.toMoney(rs.getDouble("EvalUnitPrice"));
		if(sEvalUnitPrice == null) sEvalUnitPrice = "";
		dAboutSum2 = rs.getDouble("AboutSum2");
		if(dGuarantyAmount == 0)
		{
			sAboutSum2 = "";
		}else
		{
			sAboutSum2 = DataConvert.toMoney(dAboutSum2/dGuarantyAmount);
		}
		if(sAboutSum2 == null) sAboutSum2 = "";
		sEvalNetValue = DataConvert.toMoney(rs.getDouble("EvalNetValue"));
		if(sEvalNetValue == null) sEvalNetValue = "";
		sGuarantyUsing = rs.getString("GuarantyUsing");
		if(sGuarantyUsing == null) sGuarantyUsing = "";
		if("010010".equals(sGuarantyType)){
			sTemp.append(" <tr>");
		  	sTemp.append(" <td  align=center class=td1 > "+sGuarantyName+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 >"+sGuarantyLocation+"&nbsp</td>");
		    sTemp.append(" <td  align=center class=td1 > "+sOwnerName+"&nbsp</td>");
		    sTemp.append(" <td  align=center class=td1 > "+sGuarantyRightID+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sGuarantyDescribe3+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sGuarantySubType+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sGuarantyAmount+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sEvalNetValue+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sEvalUnitPrice+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sAboutSum2+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp  </td>");
		    sTemp.append(" </tr>");	
		}
		else if("010030".equals(sGuarantyType)){
			sTemp.append(" <tr>");
		  	sTemp.append(" <td  align=center class=td1 > "+sGuarantyName+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 >"+sThirdParty1+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sOwnerName+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sGuarantyRightID+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sEvalNetValue+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sEvalUnitPrice+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sAboutSum2+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp  </td>");
		    sTemp.append(" </tr>");	
		}
		else if("010040".equals(sGuarantyType)){
			sTemp.append(" <tr>");
		  	sTemp.append(" <td  align=center class=td1 > "+sGuarantyName+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 >"+sThirdParty1+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sOwnerName+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sGuarantyRightID+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sGuarantyAmount+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sEvalNetValue+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sEvalUnitPrice+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sAboutSum2+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sGuarantyUsing+"&nbsp  </td>");
		    sTemp.append(" </tr>");	
		}
		else if("010050".equals(sGuarantyType)){
			sTemp.append(" <tr>");
		  	sTemp.append(" <td  align=center class=td1 > "+sGuarantyName+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 >"+sThirdParty1+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sOwnerName+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sGuarantyRightID+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sGuarantyAmount+"&nbsp </td>");
		    sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sEvalNetValue+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sEvalUnitPrice+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+sAboutSum2+"&nbsp  </td>");
		    sTemp.append(" <td  align=center class=td1 > "+""+"&nbsp  </td>");
		    sTemp.append(" </tr>");	
		}
	}
	rs.getStatement().close();
	sTemp.append(" <tr>");	
	sTemp.append(" <td class=td1 align=left colspan=12 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><strong>保证情况</strong> </font></td>"); 	
	sTemp.append(" </tr>");	
	sTemp.append(" <tr>");
  	/*
  	sTemp.append(" <td  align=center class=td1 rowspan=2> 序号</td>");
    sTemp.append(" <td  align=center class=td1 rowspan=2> 名称 </td>");
    sTemp.append(" <td  align=center class=td1 rowspan=2> 年收入情况 </td>");
    sTemp.append(" <td  align=center class=td1 rowspan=2 colspan=2> 经营项目/情况</td>");
    sTemp.append(" <td  align=center class=td1 colspan=2> 保证人我行贷款情况 </td>");
    sTemp.append(" <td  align=center class=td1 colspan=2> 保证人他行贷款情况 </td>");
    sTemp.append(" <td  align=center class=td1 colspan=3> 保证人其他对外担保情况 </td>");
    sTemp.append(" </tr>");
    sTemp.append(" <tr>");
    sTemp.append(" <td  align=center class=td1 > 贷款金额 </td>");
    sTemp.append(" <td  align=center class=td1 > 贷款银行 </td>");
    sTemp.append(" <td  align=center class=td1 > 贷款金额 </td>");
    sTemp.append(" <td  align=center class=td1 > 贷款银行 </td>");
    sTemp.append(" <td  align=center class=td1 > 担保金额 </td>");
    sTemp.append(" <td  align=center class=td1 > 借款人 </td>");
    sTemp.append(" <td  align=center class=td1 > 贷款银行 </td>");
    sTemp.append(" </tr>");	

	sSql = "select guarantorid from guaranty_contract where serialno in (select Objectno from apply_relative where serialno = '"+sObjectNo+"' and ObjectType = 'GuarantyContract')";
	rs = Sqlca.getASResultSet(sSql);
	
	int iContract = 0,iOtherContract = 0,iOtherGuaranty =0,iMax=0,iCount=1;
	String sCustomerName = "",sYearIncome = "",sBusinessSum = "",sOccurBank = "";

	ASResultSet rs1 = null ,rs = null;
	while(rs.next()){
		List<String> list1 = new ArrayList<String>() ;
		List<String> list2 = new ArrayList<String>() ;
		List<String> list3 = new ArrayList<String>();
		List<String> list4 = new ArrayList<String>();
		List<String> list5 = new ArrayList<String>();
		List<String> list6 = new ArrayList<String>();
		List<String> list7 = new ArrayList<String>();
		String sGuarantorID = rs.getString("guarantorid");
		iContract = Sqlca.getDouble("select count(*) from business_contract where CustomerID = '"+sGuarantorID+"'").intValue();
		iOtherContract = Sqlca.getDouble("select count(*) from CUSTOMER_OACTIVITY   where CustomerID='"+sGuarantorID+"' and BusinessType in('01','02','03','04','05','06','07')").intValue(); 
		iOtherGuaranty = Sqlca.getDouble("select count(*) from GUARANTY_CONTRACT  where GuarantorID='"+sGuarantorID+"' and ContractStatus = '020' ").intValue();
		String sGuarantorType = Sqlca.getString("select CustomerType from Customer_info where CustomerID = '"+sGuarantorID+"'");
		iMax = iContract>iOtherContract?iContract:iOtherContract;
		iMax = iMax>iOtherGuaranty?iMax:iOtherGuaranty;
		System.out.println(iMax);
		if(sGuarantorType == null) sGuarantorType = "";
		if(sGuarantorType.startsWith("03"))
			sSql = "select getCustomername(customerid) as CustomerName,YearIncome from ind_Info where CustomerID = '"+sGuarantorID+"'";
		else 
			sSql = "select getCustomername(customerid) as CustomerName,SellSum as YearIncome from ent_info where CustomerID = '"+sGuarantorID+"'";	
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sCustomerName = rs.getString("CustomerName");
			if(sCustomerName == null) sCustomerName = "";
			sYearIncome = DataConvert.toMoney(rs.getDouble("YearIncome"));
			if(sYearIncome == null) sYearIncome = "";
		  	sTemp.append(" <tr>");
		  	sTemp.append(" <td  align=center class=td1 rowspan="+(iMax+1)+">保证人"+ iCount +"&nbsp;</td>");
		  	sTemp.append(" <td  align=center class=td1 rowspan="+(iMax+1)+">"+ sCustomerName +"&nbsp;</td>");
		  	sTemp.append(" <td  align=center class=td1 rowspan="+(iMax+1)+">"+ sYearIncome +"&nbsp;</td>");
		  	sTemp.append(" <td  align=center class=td1 rowspan="+(iMax+1)+" colspan=2>"+ "" +"&nbsp;</td>");
		  	sTemp.append(" </tr>");
		  	sSql = "select BusinessSum,getOrgName(ManageOrgID) as ManageOrgName from business_contract where CustomerID = '"+sGuarantorID+"'";
		    rs1 = Sqlca.getASResultSet(sSql);
		    while(rs1.next()){
		    	sBusinessSum = DataConvert.toMoney(rs1.getDouble("BusinessSum"));
		    	if(sBusinessSum == null) sBusinessSum = "";
		    	sOccurBank = rs1.getString("ManageOrgName");
		    	if(sOccurBank == null) sOccurBank = "";
				list1.add(sBusinessSum);
				list2.add(sOccurBank);
		    }
		    while(iContract<iMax){
				list1.add("");
				list2.add("");
				iContract++;
		    }
		    rs1.getStatement().close();
		    
 			  	sSql = "select BusinessSum,OccurOrg from CUSTOMER_OACTIVITY   where CustomerID='"+sGuarantorID+"' and BusinessType in('01','02','03','04','05','06','07')";
		    rs1 = Sqlca.getASResultSet(sSql);
		    while(rs1.next()){
		    	sBusinessSum = DataConvert.toMoney(rs1.getDouble("BusinessSum"));
		    	if(sBusinessSum == null) sBusinessSum = "";
		    	sOccurBank = rs1.getString("OccurOrg");
		    	if(sOccurBank == null) sOccurBank = "";
				list3.add(sBusinessSum);
				list4.add(sOccurBank);
		    }
  			    while(iOtherContract<iMax){
				list3.add("");
				list4.add("");
				iOtherContract++;
		    }
		    rs1.getStatement().close();
		    
  			  	sSql = "select GuarantyValue,getOrgName(InputOrgID) as OrgName,getCustomerName(CustomerID) as Customername from GUARANTY_CONTRACT  where GuarantorID='"+sGuarantorID+"' and ContractStatus = '020' ";
		    rs1 = Sqlca.getASResultSet(sSql);
		    while(rs1.next()){
		    	sBusinessSum = DataConvert.toMoney(rs1.getDouble("GuarantyValue"));
		    	if(sBusinessSum == null) sBusinessSum = "";
		    	sOccurBank = rs1.getString("OrgName");
		    	if(sOccurBank == null) sOccurBank = "";
		    	String sCustomerName1 = rs1.getString("Customername");
		    	if(sCustomerName1 == null) sCustomerName1 = "";
				list5.add(sBusinessSum);
				list6.add(sOccurBank);
				list7.add(sCustomerName1);
		    }
  			    while(iOtherGuaranty <iMax ){
				list5.add("");
				list6.add("");
				list7.add("");
				iOtherGuaranty++;
		    }
		    rs1.getStatement().close();
		    for(int i = 0; i<list1.size();i++){
				sTemp.append(" <tr>");
				sTemp.append(" <td  align=center class=td1 >"+ list1.get(i) +"&nbsp;</td>");	
				sTemp.append(" <td  align=center class=td1 >"+ list2.get(i)  +"&nbsp;</td>");
				sTemp.append(" <td  align=center class=td1 >"+ list3.get(i)  +"&nbsp;</td>");
				sTemp.append(" <td  align=center class=td1 >"+ list4.get(i)  +"&nbsp;</td>");
				sTemp.append(" <td  align=center class=td1 >"+ list5.get(i)  +"&nbsp;</td>");
				sTemp.append(" <td  align=center class=td1 >"+ list7.get(i) +"&nbsp;</td>");
				sTemp.append(" <td  align=center class=td1 >"+ list6.get(i)  +"&nbsp;</td>");
			    sTemp.append(" </tr>");	
			}    
		} 
		rs.getStatement().close();
		iCount++;
	}

	rs.getStatement().close();
	*/
		
	sSql = "select distinct guarantorid,getCustomerName(guarantorid) as GuarantorName from guaranty_contract where serialno in (select Objectno from apply_relative where serialno = '"+sObjectNo+"' and ObjectType = 'GuarantyContract')";
	rs = Sqlca.getASResultSet(sSql);
	ArrayList<String> Guarantors = new ArrayList<String>();
	ArrayList<String> GuarantorNames = new ArrayList<String>();
	while(rs.next()){
		String sGuarantorID = rs.getString("guarantorid");
		if(sGuarantorID == null) sGuarantorID = "";
		Guarantors.add(sGuarantorID);
		String sGuarantorName = rs.getString("GuarantorName");
		if(sGuarantorName == null) sGuarantorName = "";
		GuarantorNames.add(sGuarantorName);
	}
	rs.getStatement().close();
	
	for(int i=0;i<Guarantors.size();i++){
		sTemp.append(" <tr>");	
		sTemp.append(" <td class=td1 align=left colspan=12 bgcolor=#aaaaaa ><font style=' font-size: 11pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' ><strong>"+GuarantorNames.get(i)+"在我行的对外担保情况</strong> </font></td>"); 	
		sTemp.append(" </tr>");	
		sTemp.append("   <tr>");
		sTemp.append("   <td width=25% colspan=2 align=center class=td1 nowrap > 被担保人  </td>");
		sTemp.append("   <td width=10% align=center class=td1 > 币种 </td>");
		sTemp.append("   <td width=12% colspan=2 align=center class=td1 > 担保合同金额(万元) </td>");
		sTemp.append("   <td width=12% colspan=2 align=center class=td1 > 担保合同余额(万元) </td>");
		sTemp.append("   <td width=15% colspan=2 align=center class=td1 > 担保方式 </td>");
		sTemp.append("   <td width=15% align=center class=td1 > 合同到期日 </td>");
		sTemp.append("   <td width=10% colspan=2 align=center class=td1 > 五级分类 </td>");
		sTemp.append("   </tr>");
		sSql =  " select distinct BC.CustomerName,getItemName('GuarantyType',GC.GuarantyType) as GuarantyTypeName,"
				+" getItemName('ClassifyResult',BC.ClassifyResult) as ClassifyResult,"
				+" getItemName('Currency',BC.BUSINESSCURRENCY) as CurrencyType,BC.BusinessSum,BC.BALANCE,BC.Maturity "
				+" from BUSINESS_CONTRACT  BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR"
				+" where CR.ObjectNo = GC.serialNo"
				+" and CR.ObjectType = 'GuarantyContract'"
				+" and BC.SerialNo=CR.SerialNo"
				+" and GC.GuarantorID = '"+Guarantors.get(i)+"'";
		
		String sGuarantorName = "";
		String sGuarantyTypeName = "";
		double dBusinessSum = 0.00;
		String sBusinessSum = "";
		double dBlance = 0.00;
		String sBlance = "";
		sEndDate = "";
		String sClassifyResult = "";
		String sCurrencyType= "";
		
		rs = Sqlca.getResultSet(sSql);
		while(rs.next())
		{
			sGuarantorName = rs.getString(1);
			if(sGuarantorName == null) sGuarantorName = " ";
			sGuarantyTypeName = rs.getString(2);
			if(sGuarantyTypeName == null) sGuarantyTypeName = " ";
			sClassifyResult = rs.getString(3);
			if(sClassifyResult == null ) sClassifyResult = " ";
			sCurrencyType = rs.getString(4);
			if(sCurrencyType == null) sCurrencyType = " ";
			dBusinessSum += rs.getDouble(5)/10000;
			sBusinessSum = DataConvert.toMoney(rs.getDouble(5)/10000);
			if(sBusinessSum == null) sBusinessSum = " ";
			dBlance += rs.getDouble(6)/10000;
			sBlance = DataConvert.toMoney(rs.getDouble(6)/10000);
			if(sBlance == null) sBlance = " ";
			sEndDate = rs.getString(7);
			if(sEndDate == null ) sEndDate = " ";	
			
			sTemp.append("   <tr>");
			sTemp.append("   <td width=25% colspan=2 align=center class=td1 >"+sGuarantorName+"&nbsp; </td>");
			sTemp.append("   <td width=10% align=center class=td1 >"+sCurrencyType+"&nbsp;</td>");
			sTemp.append("   <td width=10% colspan=2 align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
			sTemp.append("   <td width=10% colspan=2 align=center class=td1 >"+sBlance+"&nbsp;</td>");
			sTemp.append("   <td width=15% colspan=2 align=center class=td1 >"+sGuarantyTypeName+"&nbsp;</td>");
			sTemp.append("   <td width=15% align=center class=td1 >"+sEndDate+"&nbsp;</td>");
			sTemp.append("   <td width=15% colspan=2 align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
			sTemp.append("   </tr>");
		}
		rs.getStatement().close();


		
		sSql =  " select sum(nvl(BC.BusinessSum,0)*getERate(BC.BusinessCurrency,'01',BC.ERateDate)) as BusinessSum,"
				+" sum(nvl(BC.Balance,0)*getERate(BC.BusinessCurrency,'01',BC.ERateDate)) "
				+" from BUSINESS_CONTRACT BC where BC.SerialNo in (select BC.SerialNo from "
				+" BUSINESS_CONTRACT  BC,GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR"
				+" where CR.ObjectNo = GC.serialNo"
				+" and CR.ObjectType = 'GuarantyContract'"
				+" and BC.SerialNo=CR.SerialNo"
				+" and GC.GuarantorID = '"+Guarantors.get(i)+"')";
		rs = Sqlca.getResultSet(sSql);
		String sSum = "";
		String sSum1 = "" ;
		while(rs.next())
		{
			sSum += DataConvert.toMoney(rs.getDouble(1)/10000); 
			sSum1 += DataConvert.toMoney(rs.getDouble(2)/10000);
		}	
		rs.getStatement().close();	
		sTemp.append("   <tr>");
		sTemp.append("   <td colspan=2 align=center class=td1 > 合计: </td>");
		sTemp.append("   <td align=center class=td1 > 人民币 </td>");
		sTemp.append("   <td colspan=2 align=center class=td1 >"+sSum+"&nbsp</td>");
		sTemp.append("   <td colspan=2 align=center class=td1 >"+sSum1+"&nbsp</td>");
		sTemp.append("   <td colspan=5 align=left class=td1 >"+"/"+"&nbsp;</td>");
		sTemp.append("</tr>");

	}
	
	for(int i=0;i<Guarantors.size();i++){
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left colspan=13 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' > "+GuarantorNames.get(i)+"在他行未结清授信情况 </font></td>"); 	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=15% colspan=2 align=center class=td1 > 行名  </td>");
	    sTemp.append("   <td width=10% colspan=2 align=center class=td1 > 品种 </td>");
	    sTemp.append("   <td width=10% colspan=2 align=center class=td1 > 授信额度(万元) </td>");
	    sTemp.append("   <td width=11% colspan=2 align=center class=td1 > 余额(万元) </td>");
	    sTemp.append("   <td width=12% align=center class=td1 > 起始日 </td>");
	    sTemp.append("   <td width=12% align=center class=td1 > 到期日 </td>");
	    sTemp.append("   <td width=15% align=center class=td1 > 担保方式 </td>");
	    sTemp.append("   <td width=15% align=center class=td1 > 五级分类 </td>");
		sTemp.append("   </tr>");
		
		sSql = "select OccurOrg,BusinessType,getItemName('OtherBusinessType',BusinessType) as BusinessTypeName, "+
	              "Balance,BeginDate,Maturity,getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,BusinessSum "+
	              "from CUSTOMER_OACTIVITY where CustomerID = '"+Guarantors.get(i)+"'and BusinessType ='02' and Balance >0";
		String sOccurOrg = "";
		String sBusinessType = "";
		String sBusinessTypeName = "";
		String sBalance  = "";
		String sBeginDate = "";
		String sMaturity = "";
		String sClassifyResult = "";
		String sBusinessSum = "";
		String sGuarantyTypeName = "";
		rs = Sqlca.getResultSet(sSql);
		while(rs.next())
		{
			sOccurOrg = rs.getString(1);
			if(sOccurOrg == null) sOccurOrg = " ";
			sBusinessType = rs.getString(2);
			sBusinessTypeName = rs.getString(3);
			if(sBusinessTypeName == null) sBusinessTypeName = " ";
			sBalance = DataConvert.toMoney(rs.getDouble(4)/10000);
			sBeginDate = rs.getString(5);
			if(sBeginDate == null) sBeginDate = " ";
			sMaturity = rs.getString(6);
			if(sMaturity == null) sMaturity = " ";
			sClassifyResult = rs.getString(7);
			if(sClassifyResult == null) sClassifyResult = " ";
			sBusinessSum = DataConvert.toMoney(rs.getDouble(8)/10000);
		//	sGuarantyTypeName = rs.getString(9);
			//if(sGuarantyTypeName == null) sGuarantyTypeName = " ";
			
			if(sBusinessType.equals("020"))
			{
				sTemp.append("   <tr>");
			  	sTemp.append("   <td width=15% colspan=2 align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
			    sTemp.append("   <td width=10% colspan=2 align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
			    sTemp.append("   <td width=10% colspan=2 align=center class=td1 >"+sBusinessSum+"&nbsp; </td>");
			    sTemp.append("   <td width=11% colspan=2 align=center class=td1 >"+sBalance+"&nbsp;</td>");
			    sTemp.append("   <td width=12% align=center class=td1 >"+sBeginDate+"&nbsp;</td>");
			    sTemp.append("   <td width=12% align=center class=td1 >"+sMaturity+"&nbsp;</td>");
			    sTemp.append("   <td width=15% align=center class=td1 >"+sGuarantyTypeName+"/&nbsp;</td>");    
			    sTemp.append("   <td width=15% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
				sTemp.append("   </tr>");
			}
			else
			{
				sTemp.append("   <tr>");
			  	sTemp.append("   <td width=15% colspan=2 align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
			    sTemp.append("   <td width=10% colspan=2 align=center class=td1 >"+sBusinessTypeName+"&nbsp;</td>");
			    sTemp.append("   <td width=10% colspan=2 align=center class=td1 >"+sBusinessSum+"&nbsp; </td>");
			    sTemp.append("   <td width=11% colspan=2 align=center class=td1 >"+sBalance+"&nbsp;</td>");
			    sTemp.append("   <td width=12% align=center class=td1 >"+sBeginDate+"&nbsp;</td>");
			    sTemp.append("   <td width=12% align=center class=td1 >"+sMaturity+"&nbsp;</td>");
			    sTemp.append("   <td width=15% align=center class=td1 >"+sGuarantyTypeName+"&nbsp;</td>");    
			    sTemp.append("   <td width=15% align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
				sTemp.append("   </tr>");
			}
	    }
	    
	    rs.getStatement().close();	
	    
		sSql = "select sum(BusinessSum),sum(Balance) "+
		              "from CUSTOMER_OACTIVITY where CustomerID = '"+Guarantors.get(i)+"'and BusinessType ='02' and Balance >0";
		rs = Sqlca.getResultSet(sSql);
		String sSum = "";
		String sSum1 = "" ;
		while(rs.next())
		{
			sSum += DataConvert.toMoney(rs.getDouble(1)/10000); 
			sSum1 += DataConvert.toMoney(rs.getDouble(2)/10000);
		}	
		rs.getStatement().close();
		sTemp.append("   <tr>");
		sTemp.append("   	<td colspan='4' align=center class=td1 > 合计: </td>");
		sTemp.append("   	<td colspan='2' align=center class=td1 >"+sSum+"&nbsp</td>");
		sTemp.append("   	<td colspan='2' align=center class=td1 >"+sSum1+"&nbsp</td>");
		sTemp.append("   	<td colspan='4' align=left class=td1 >"+"/"+"&nbsp;</td>");
		sTemp.append("</tr>");
	}
	//////////////////////
	for(int i=0;i<Guarantors.size();i++){
		sTemp.append("   <tr>");	
		sTemp.append("   <td class=td1 align=left colspan=12 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' > "+GuarantorNames.get(i)+"在他行的对外担保情况 </font></td>"); 	
		sTemp.append("   </tr>");
		sTemp.append("   <tr>");
	  	sTemp.append("   <td width=20% colspan=2 align=center class=td1 > 行名  </td>");
	  	sTemp.append("   <td width=20% colspan=2 align=center class=td1 > 被担保人  </td>");
	  	sTemp.append("   <td width=10% colspan=2 align=center class=td1 > 币种 </td>");
	    sTemp.append("   <td width=14% colspan=2 align=center class=td1 > 担保金额(万元) </td>");
	    sTemp.append("   <td width=18% colspan=2 align=center class=td1 > 担保到期日 </td>");
		sTemp.append("   <td width=18% colspan=2 align=center class=td1 > 主债权五级分类 </td>");
		sTemp.append("   </tr>");
		sSql = "select OccurOrg,BusinessSum,Maturity,"+
	              "getItemName('ClassifyResult',ClassifyResult) as ClassifyResult,getItemName('Currency',CURRENCY) as currencyType "+
	              "from CUSTOMER_OACTIVITY where BusinessType = '08' and CustomerID = '"+Guarantors.get(i)+"'";
		String sOccurOrg = "";
		String sCurrencyType ="";
		String sMaturity = "";
		String sBusinessSum  = "";
		String sClassifyResult = "";
		double dBusinessSum = 0.0;
		rs = Sqlca.getResultSet(sSql);
		while(rs.next())
		{
			sOccurOrg = rs.getString(1);
			dBusinessSum += rs.getDouble(2);
			sBusinessSum = DataConvert.toMoney(rs.getDouble(2)/10000);;
			sMaturity = rs.getString(3);
			sClassifyResult = rs.getString(4);
			sCurrencyType =rs.getString(5);
			sTemp.append("   <tr>");
		  	sTemp.append("   <td width=20% colspan=2 align=center class=td1 >"+sOccurOrg+"&nbsp;</td>");
		    sTemp.append("   <td width=20% colspan=2 align=right class=td1 >"+""+"&nbsp;</td>");
		    sTemp.append("   <td width=10% colspan=2 align=center class=td1 >"+sCurrencyType+"&nbsp;</td>");
		   	sTemp.append("   <td width=10% colspan=2 align=center class=td1 >"+sBusinessSum+"&nbsp;</td>");
		    sTemp.append("   <td width=14% colspan=2 align=center class=td1 >"+sMaturity+"&nbsp;</td>");
			sTemp.append("   <td width=18% colspan=2 align=center class=td1 >"+sClassifyResult+"&nbsp;</td>");
			sTemp.append("   </tr>");
		}
		rs.getStatement().close();	
		sSql = "select getitemname('Currency',Currency) as CurrencyName,sum(nvl(BusinessSum,0)*getERate(Currency,'01','')) "+
	           "from CUSTOMER_OACTIVITY where BusinessType = '08' and CustomerID = '"+Guarantors.get(i)+"' group by Currency";
	    rs = Sqlca.getResultSet(sSql);
	    String sSum = "";
		while(rs.next())
		{
			sSum += DataConvert.toMoney(rs.getDouble(2)/10000)+"<br>"; 
		}	
		rs.getStatement().close();	
		sTemp.append("   <tr>");
	  	sTemp.append("   <td colspan=4 align=center class=td1 > 合计：  </td>");
	  	sTemp.append("   <td colspan=2 align=center class=td1 > 人民币 </td>");
	    sTemp.append("   <td colspan=2 align=center class=td1 >"+sSum+"&nbsp;</td>");
	    sTemp.append("   <td colspan=4 align=left class=td1 >"+"/ "+"</td>");
	    sTemp.append("   </tr>");
	}

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