<%@ page contentType="text/html; charset=GBK"%>
<%@ include file="/IncludeBeginMD.jsp"%>

 
<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=Main00;Describe=注释区;]~*/%>
	<%
	/*
		Author: hldu 2012.06.20
		Tester:
		Content: 集团客户额度汇总表
		Input Param:
		Output param:
		History Log: 
	 */
	%>
<%/*~END~*/%>

<%

%> 
<%
    String sGLCustomerID = "" ;   // 关联集团编号
    String sGLCustomerNmae = "" ; // 关联集团名称
    int iCount = 0 ;              // 序号
    double dSum1 = 0.0 ;          // 总审批金额:dSum1sub1+dSum1sub2 
    double dSum1Sub1 = 0.0;		  //审批通过的申请(不包含终结合同对应的申请,不包含额度项下,不包含展期,已做复议)对应的最终审批金额
    double dSum1Sub2 = 0.0;		  //未终结无申请合同金额
    double dSum1Sub3 = 0.0;		  //已失效额度项下业务合同金额
    double dSum2 = 0.0 ;          // 总审批敞口        总审批金额-保证金
    double dSum3 = 0.0 ;          // 敞口余额          贷款余额+银行承兑汇票敞口
    double dSum4 = 0.0 ;          // 贷款余额          指所有表内贷款借据余额   
    double dSum5 = 0.0 ;          // 银行承兑汇票敞口   金额-保证金 
    double dSum6 = 0.0 ;          // 已批未发放总额度   审批金额减合同金额
    double dSum7 = 0.0 ;          // 保证金:dSum7Sub1+dSum7Sub2+dSum7Sub3
    double dSum7Sub1 = 0.0 ;      // 保证金:单笔申请(注:审批通过的申请且不包含终结合同对应的申请,不包含额度项下)保证金金额
    double dSum7Sub2 = 0.0 ;      // 保证金:未终结无申请合同金额保证金金额
    double dSum7Sub3 = 0.0 ;      // 保证金:额度分配保证金金额
    double dSum7Sub4 = 0.0 ;      // 保证金:已失效额度项下业务
    double dSum8 = 0.0 ;          // 合同金额
    double dSum9 = 0.0 ;          // 集团成员总审批金额
    double dSum9Sub1 = 0.0;		  //审批通过的申请(不包含终结合同对应的申请,不包含额度项下,不包含展期,已做复议)对应的最终审批金额
    double dSum9Sub2 = 0.0;		  //未终结无申请合同金额
    double dSum9Sub3 = 0.0;		  //已失效额度项下业务合同金额
    double dSum10 = 0.0 ;         // 集团成员总审批敞口
    double dSum11 = 0.0 ;         // 集团成员保证金
    double dSum11Sub1 = 0.0 ;      // 保证金:单笔申请(注:审批通过的申请且不包含终结合同对应的申请,不包含额度项下)保证金金额
    double dSum11Sub2 = 0.0 ;      // 保证金:未终结无申请合同金额保证金金额
    double dSum11Sub3 = 0.0 ;      // 保证金:额度分配保证金金额
    double dSum11Sub4 = 0.0 ;      // 保证金:已失效额度项下业务
    double dSum12 = 0.0 ;         // 集团成员贷款审批金额
    double dSum12Sub1 = 0.0 ;         // 集团成员贷款(不包含终结合同对应的申请,不包含额度项下)对应的最终审批金额
    double dSum12Sub2 = 0.0 ;         // 集团成员贷款未终结无申请合同金额
    double dSum12Sub3 = 0.0 ;         // 集团成员贷款额度分配金额
    double dSum12Sub4 = 0.0 ;         // 已失效额度项下业务合同金额
    double dSum13 = 0.0 ;         // 集团成员贷款余额
    double dSum14 = 0.0 ;         // 银行承兑汇票金额
    double dSum14Sub1 = 0.0 ;         // 集团成员银行承兑汇票(不包含终结合同对应的申请,不包含额度项下)对应的最终审批金额
    double dSum14Sub2 = 0.0 ;         // 集团成员银行承兑汇票未终结无申请合同金额
    double dSum14Sub3 = 0.0 ;         // 集团成员银行承兑汇票额度分配金额
    double dSum14Sub4 = 0.0 ;         // 已失效额度项下业务额银行承兑合同金额
    double dSum15 = 0.0 ;        	 // 保证金比例
    double dBailSum15Sub1 = 0.0 ;         // 集团成员银行承兑汇票(不包含终结合同对应的申请,不包含额度项下)对应的保证金
    double dBailSum15Sub2 = 0.0 ;         // 集团成员银行承兑汇票未终结无申请保证金
    double dBailSum15Sub3 = 0.0 ;         // 集团成员银行承兑汇票额度分配保证金
    double dBailSum15Sub4 = 0.0 ;         // 集团成员银行承兑汇票已失效额度项下业务额
    double dSum16 = 0.0 ;         // 银行承兑汇票余额
    double dSum17 = 0.0 ;         // 已签发银行承兑汇票保证金比例
    double dSum18 = 0.0 ;         // 银行承兑汇票敞口余额
    double dSum19 = 0.0 ;         // 国际业务审批金额
    double dSum19Sub1 = 0.0 ;         // 审批通过的单笔申请(不包含终结合同对应的申请,不包含额度项下)对应的最终审批金额
    double dSum19Sub2 = 0.0 ;         // 国际业务未终结无申请合同金额
    double dSum19Sub3 = 0.0 ;         // 国际业务额度分配金额
    double dSum19Sub4 = 0.0 ;         // 国际业务已失效额度项下业务合同金额
    double dSum20 = 0.0 ;         // 国际业务授信余额
    double dSum21 = 0.0 ;         // 集团成员已批未发放余额
    String sSum1 = "";
    String sSum2 = "";
    String sSum3 = "";
    String sSum4 = "";
    String sSum5 = "";
    String sSum6 = "";
    String sSum9 = "";
    String sSum10 = "";
    String sSum12 = "";
    String sSum13 = "";
    String sSum14 = "";
    String sSum15 = "";
    String sSum16 = "";
    String sSum17 = "";
    String sSum18 = "";
    String sSum19 = "";
    String sSum20 = "";
    String sSum21 = "";
    String sOrgName= "" ;         // 经办行
    String sRelativeID = "" ;     // 集团成员编号  
    String sCustomerName = "";    // 集团成员名称
    int iMoneyUnit = 10000 ;      // 单位万元
    String sSql = "" ;    
    ASResultSet rs = null;
    int iRow=0;//用于标记行数
	//获得汇总表数据
    //获取关联集团ID
    sGLCustomerID = DataConvert.toRealString(iPostChange,(String)CurComp.getParameter("CustomerID"));
	if(sGLCustomerID == null) sGLCustomerID = "" ;
    sGLCustomerNmae = Sqlca.getString(" select CustomerName from Customer_Info where CustomerID = '"+sGLCustomerID+"'");
    if(sGLCustomerNmae == null) sGLCustomerNmae = "" ;
   
	
	//审批通过的申请(不包含终结合同对应的申请,不包含额度项下)对应的最终审批金额及保证金
	sSql = 	"select Sum(Nvl(BA.BusinessSum,0)*getERate(BA.BusinessCurrency,'01',BA.ERateDate)) as totsum,Sum(nvl(BA.BailSum,0)*getERate(BA.BusinessCurrency,'01',BA.ERateDate)) as ApplyBailSum "+
			"from Business_Apply BA "+
			"where BA.CustomerID in (select RelativeID from Customer_Relative "+
			"where CustomerID = '"+sGLCustomerID+"' and RelationShip like '04%') "+
			" and BA.OrgFlag not like '%1' "+
			"and BA.ApplyType <> 'DependentApply' "+
			"and not exists (select 'X' from Apply_Relative AR where AR.ObjectNo = BA.SerialNo and ObjectType ='BusinessReApply' )"+
			" and not exists(select 'X' from Business_Contract where RelativeSerialno=BA.SerialNo "+
			" and ((FinishDate is not null and FinishDate<>'') or "+
			"(Maturity<'"+StringFunction.getToday()+"' and BusinessType like '3%'))) "
			;
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		dSum1Sub1=rs.getDouble("totsum");
		dSum7Sub1=rs.getDouble("ApplyBailSum");
	}
	rs.getStatement().close();
	
	//未终结无申请合同金额及保证金
	sSql = 	" select Sum(Nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as totsum,Sum(nvl(BailSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as UnApplyBailSum "+
			" from Business_Contract "+
			" where CustomerID in (select RelativeID from Customer_Relative where CustomerID = '"+sGLCustomerID+"' and RelationShip like '04%') "+
			" and ApplyType <> 'DependentApply'"+
			" and (RelativeSerialNo is null or RelativeSerialNo='' or RelativeSerialNo not like 'BA%')"+
			" and (FinishDate is null or FinishDate='') "+
			" and  ((Maturity >='"+StringFunction.getToday()+"' and BusinessType like '3%')" +
			" or BusinessType not like '3%') "
			;
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		dSum1Sub2=rs.getDouble("totsum");
		dSum7Sub2=rs.getDouble("UnApplyBailSum");
	}
	rs.getStatement().close(); 	
	
	//已失效额度的额度项下业务金额及保证金
	sSql = 	" select Sum(nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as totsum,Sum(nvl(BailSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as BailSum "+
			" from BUSINESS_CONTRACT BC "+
			" where CustomerID in (select RelativeID from Customer_Relative where CustomerID = '"+sGLCustomerID+"' and RelationShip like '04%') "+
			" and ApplyType ='DependentApply' "+
			" and (finishdate is null or finishdate='') "+
			" and exists(select 1 from BUSINESS_CONTRACT "+
					"where SerialNo=BC.CreditAggreeMent "+
					"and BusinessType like '3%' and Maturity<'"+StringFunction.getToday()+"' ) "
			;
	rs = Sqlca.getASResultSet(sSql);
	if(rs.next())
	{
		dSum1Sub3=rs.getDouble("totsum");
		dSum7Sub4=rs.getDouble("BailSum");
	}
	rs.getStatement().close(); 
	
	//额度分配保证金信息
	 dSum7Sub3 = Sqlca.getDouble("select sum(Nvl(CL.BailRatio,0)*nvl(CL.LineSum1,0)*0.01*getERate(CL.Currency,'01',CL.ERateDate)) as CLBailSum "+
			 "from CL_INFO CL,BUSINESS_CONTRACT BC "+
			 "where CL.BCSerialno=BC.Serialno "+
			 "and CL.ParentLineID is not null and CL.ParentLineID<>'' "+
			 "and BC.Businesstype='3010' "+
			 " and CL.CustomerID in (select RelativeID from Customer_Relative where CustomerID = '"+sGLCustomerID+"' and RelationShip like '04%')"+
			 " and (BC.FinishDate is null or BC.FinishDate='') " +
			 " and  BC.Maturity >='"+StringFunction.getToday()+"' "
			);  
	
	dSum1 = dSum1Sub1+dSum1Sub2+dSum1Sub3;//总审批金额
    sSum1 = DataConvert.toMoney(dSum1/iMoneyUnit);
    dSum7 = dSum7Sub1+dSum7Sub2+dSum7Sub3+dSum7Sub4;  // 保证金	
    dSum2 = dSum1 - dSum7;
    sSum2=  DataConvert.toMoney(dSum2/iMoneyUnit);//总审批敞口
    
    dSum4 = Sqlca.getDouble("select Sum(Nvl(BC.Balance,0)*getERate(BC.BusinessCurrency,'01',BC.ERateDate)) "+
    		"from Business_CONTRACT BC "+
    		"where BC.CustomerID in (select RelativeID from Customer_Relative where CustomerID = '"+sGLCustomerID+"' and RelationShip like '04%')"+
    		" and BC.BusinessType like '1%'");  // 表内合同余额
    sSum4=  DataConvert.toMoney(dSum4/iMoneyUnit);
    dSum5 = Sqlca.getDouble("select Sum(Nvl(BusinessSum,0)*(1-BailRatio*0.01)*getERate(BusinessCurrency,'01',ERateDate))"+
    		" from Business_Contract where BusinessType = '2010'"+
    		" and CustomerID in (select RelativeID from Customer_Relative where CustomerID = '"+sGLCustomerID+"' and RelationShip like '04%')"+
    		" and FinishDate is not null and FinishDate<>'' "
			);
    sSum5=  DataConvert.toMoney(dSum5/iMoneyUnit);
    dSum3 = dSum4 + dSum5;
    sSum3=  DataConvert.toMoney(dSum3/iMoneyUnit);
    dSum8 = Sqlca.getDouble("select Sum(Nvl(ActualPutOutSum,0)*getERate(BusinessCurrency,'01',ERateDate)) "+
    		" from Business_Contract "+
    		" where CustomerID in (select RelativeID from Customer_Relative where CustomerID = '"+sGLCustomerID+"' and RelationShip like '04%') "+
    		" and (FinishDate is  null and FinishDate='') "+
    		" and BusinessType not like '3%'"
			);//已发放金额
    dSum6 = dSum1 - dSum8;
    sSum6=  DataConvert.toMoney(dSum6/iMoneyUnit);
	
%>

<%/*~BEGIN~可编辑区~[Editable=true;CodeAreaID=ReportInfo;Describe=生成报告信息;客户化2;]~*/%>

<html>
<head>
<title></title> 
</head>
<body bgcolor="#DCDCDC" leftmargin="0" topmargin="0" scroll = "auto" >  
<center>
	<form method='post' action='GroupCreditCollect.jsp' name='reportInfo'>	
	<div>
	<table class=table1 width='1280' align=center border=2 cellspacing=0 cellpadding=2 bgcolor="#DCDCDC" bordercolor=black bordercolordark=black >
	<tr height=1 valign=top id="buttonback" >
		<td colspan=22>
			<table>
				<tr>
					<td>
						&nbsp;
	    		</td>
				<td class="buttonback">
				    	<table>
						<tr>
				  		<td>
							<%=
								HTMLControls.generateButton("导出excel","导出excel","spreadsheetTransfer(formatContent());",sResourcesPath)
							%>
						</td> 
						</tr>
				    	</table>
				</td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>	
	<td class=td1 align=right colspan=22 bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >单位：万元</font></td>
	</tr>
	<tr>
  	<td rowspan=3 colspan=1 align=center class=td1 >序号</td>
  	<td rowspan=3 colspan=1 align=center class=td1 >集团客户名称</td>
  	<td rowspan=3 colspan=1 align=center class=td1 >总审批金额</td>
  	<td rowspan=3 colspan=1 align=center class=td1 >总审批敞口</td>
    <td rowspan=3 colspan=1 align=center class=td1 >贷款余额+银行承兑汇票敞口（敞口余额）</td>
  	<td rowspan=3 colspan=1 align=center class=td1 >贷款余额</td>
  	<td rowspan=3 colspan=1 align=center class=td1 >银行承兑汇票敞口</td>
  	<td rowspan=3 colspan=1 align=center class=td1 >已批未发放总额度</td>
  	<td rowspan=3 colspan=1 align=center class=td1 >集团成员名称</td>
  	<td rowspan=3 colspan=1 align=center class=td1 >总审批金额</td>
  	<td rowspan=3 colspan=1 align=center class=td1 >总审批敞口</td>
  	<td rowspan=2 colspan=2 align=center class=td1 >贷款部分</td>
  	<td rowspan=1 colspan=5 align=center class=td1 >银行承兑汇票</td>
   	<td rowspan=2 colspan=2 align=center class=td1 >国际业务部分</td>
   	<td rowspan=3 colspan=1 align=center class=td1 >已批未发放余额</td>
   	<td rowspan=3 colspan=1 align=center class=td1 >经办行</td>
	</tr>
  	<tr>
  	<td rowspan=1 colspan=2 align=center class=td1 >审批情况</td>
    <td rowspan=1 colspan=3 align=center class=td1 >已签发情况</td>
  	</tr>
  	<tr>
  	<td rowspan=1 colspan=1 align=center class=td1 >贷款审批金额</td>
  	<td rowspan=1 colspan=1 align=center class=td1 >贷款余额</td>
  	<td rowspan=1 colspan=1 align=center class=td1 >银行承兑汇票金额</td>
  	<td rowspan=1 colspan=1 align=center class=td1 >保证金比例</td>
    <td rowspan=1 colspan=1 align=center class=td1 >银行承兑汇票余额</td>
  	<td rowspan=1 colspan=1 align=center class=td1 >已签发银行承兑汇票保证金比例</td>	
    <td rowspan=1 colspan=1 align=center class=td1 >银行承兑汇票敞口余额</td>
  	<td rowspan=1 colspan=1 align=center class=td1 >国际业务审批金额</td>
  	<td rowspan=1 colspan=1 align=center class=td1 >国际业务授信余额</td>
    </tr>
<%  
    sSql = " select RelativeID,CustomerName from Customer_Relative where CustomerID = '"+sGLCustomerID+"'and RelationShip like '04%'";
    ASResultSet rs2 = Sqlca.getResultSet(sSql);
    while(rs2.next())
    {
    	iCount++;
    	sRelativeID = rs2.getString("RelativeID");
    	if(sRelativeID == null) sRelativeID = "" ;
    	sCustomerName = rs2.getString("CustomerName");
    	if(sCustomerName == null) sCustomerName = "" ;
    	//审批通过的申请(不包含终结合同对应的申请,不包含额度项下)对应的最终审批金额及保证金
    	sSql = 	"select Sum(Nvl(BA.BusinessSum,0)*getERate(BA.BusinessCurrency,'01',BA.ERateDate)) as totsum,Sum(nvl(BA.BailSum,0)*getERate(BA.BusinessCurrency,'01',BA.ERateDate)) as ApplyBailSum "+
    			"from Business_Apply BA "+
    			"where BA.CustomerID  = '"+sRelativeID+"' "+
    			" and BA.OrgFlag not like '%1' "+
    			"and BA.ApplyType <> 'DependentApply' "+
    			"and not exists (select 'X' from Apply_Relative AR where AR.ObjectNo = BA.SerialNo and ObjectType ='BusinessReApply' )"+
    			" and not exists(select 'X' from Business_Contract where RelativeSerialno=BA.SerialNo "+
    			//" and (FinishDate is not null and FinishDate<>'') )"
    			" and ((FinishDate is not null and FinishDate<>'') or "+
    			"(Maturity<'"+StringFunction.getToday()+"' and BusinessType like '3%'))) "
    			;
    	rs = Sqlca.getASResultSet(sSql);
    	if(rs.next())
    	{
    		dSum9Sub1=rs.getDouble("totsum");
    		dSum11Sub1=rs.getDouble("ApplyBailSum");
    	}
    	rs.getStatement().close();
    	
    	//未终结无申请合同金额及保证金
    	sSql = 	" select Sum(Nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as totsum,Sum(nvl(BailSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as UnApplyBailSum "+
    			" from Business_Contract "+
    			" where CustomerID = '"+sRelativeID+"' "+
    			" and ApplyType <> 'DependentApply'"+
    			" and (RelativeSerialNo is null or RelativeSerialNo='' or RelativeSerialNo not like 'BA%')"+
    			" and (FinishDate is null or FinishDate='') "+
    			" and  ((Maturity >='"+StringFunction.getToday()+"' and BusinessType like '3%')" +
    			" or BusinessType not like '3%') "
    			;
    	rs = Sqlca.getASResultSet(sSql);
    	if(rs.next())
    	{
    		dSum9Sub2=rs.getDouble("totsum");
    		dSum11Sub2=rs.getDouble("UnApplyBailSum");
    	}
    	rs.getStatement().close(); 	
    	
    	//已失效额度的额度项下业务金额及保证金
    	sSql = 	" select Sum(nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as totsum,Sum(nvl(BailSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as BailSum "+
    			" from BUSINESS_CONTRACT BC "+
    			" where  CustomerID = '"+sRelativeID+"' "+
    			" and ApplyType ='DependentApply' "+
    			" and (finishdate is null or finishdate='') "+
    			" and exists(select 1 from BUSINESS_CONTRACT "+
    					"where SerialNo=BC.CreditAggreeMent "+
    					"and BusinessType like '3%' and Maturity<'"+StringFunction.getToday()+"' ) "
    			;
    	rs = Sqlca.getASResultSet(sSql);
    	if(rs.next())
    	{
    		dSum9Sub3=rs.getDouble("totsum");
    		dSum11Sub4=rs.getDouble("BailSum");
    	}
    	rs.getStatement().close(); 
    	
    	//额度分配保证金信息
    	 dSum11Sub3 = Sqlca.getDouble("select sum(Nvl(CL.BailRatio,0)*nvl(CL.LineSum1,0)*0.01*getERate(CL.Currency,'01',CL.ERateDate)) as CLBailSum "+
    			 "from CL_INFO CL,BUSINESS_CONTRACT BC "+
    			 "where CL.BCSerialno=BC.Serialno "+
    			 " and CL.ParentLineID is not null and CL.ParentLineID<>'' "+
    			 " and BC.Businesstype='3010' "+
    			 " and CL.CustomerID='"+sRelativeID+"'"+
    			 " and (BC.FinishDate is null or BC.FinishDate='') " +
    			 " and  BC.Maturity >='"+StringFunction.getToday()+"' "
    			);  
    	
    	dSum9 = dSum9Sub1+dSum9Sub2+dSum9Sub3;//总审批金额
        sSum9 = DataConvert.toMoney(dSum9/iMoneyUnit);
        dSum11 = dSum11Sub1+dSum11Sub2+dSum11Sub3+dSum11Sub4;  // 保证金	
        dSum10 = dSum9 - dSum11;
        sSum10=  DataConvert.toMoney(dSum10/iMoneyUnit);//总审批敞口
        /********************贷款部分**************************/
    	//审批通过的单笔申请(不包含终结合同对应的申请,不包含额度项下)对应的最终审批金额贷款
		sSql = 	"select Sum(Nvl(BA.BusinessSum,0)*getERate(BA.BusinessCurrency,'01',BA.ERateDate)) as totsum "+
				" from Business_Apply BA "+
				"where BA.CustomerID  = '"+sRelativeID+"' "+
				" and BA.OrgFlag not like '%1' "+
				" and BA.ApplyType ='IndependentApply' "+
				" and BusinessType like '1%' "+
				" and not exists (select 'X' from Apply_Relative AR where AR.ObjectNo = BA.SerialNo and ObjectType ='BusinessReApply' )"+
				" and not exists(select 'X' from Business_Contract where RelativeSerialno=BA.SerialNo "+
					" and (FinishDate is not null and FinishDate<>'')) "
				;
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dSum12Sub1=rs.getDouble("totsum");
		}
		rs.getStatement().close();
		
		//未终结无申请贷款合同金额
		sSql = 	" select Sum(Nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as totsum "+
				" from Business_Contract "+
				" where CustomerID  = '"+sRelativeID+"'  "+
				" and ApplyType = 'IndependentApply'"+
				" and BusinessType like '1%' "+
				" and (RelativeSerialNo is null or RelativeSerialNo='' or RelativeSerialNo not like 'BA%')"+
				" and (FinishDate is null or FinishDate='') ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dSum12Sub2=rs.getDouble("totsum");
		}
		rs.getStatement().close();
		//额度分配贷款金额
		 dSum12Sub3 = Sqlca.getDouble("select sum(nvl(CL.LineSum1,0)*getERate(CL.Currency,'01',CL.ERateDate)) as CLBailSum "+
				 "from CL_INFO CL,BUSINESS_CONTRACT BC "+
				 "where CL.BCSerialno=BC.Serialno "+
				 "and CL.ParentLineID is not null and CL.ParentLineID<>'' "+
				 "and BC.Businesstype='3010' "+
				 " and CL.BusinessType like '1%'  "+
				 " and CL.CustomerID  = '"+sRelativeID+"' "+
				 " and (BC.FinishDate is null or BC.FinishDate='') " +
				 " and  BC.Maturity >='"+StringFunction.getToday()+"' "
				); 
		//已失效额度的额度项下业务金额及保证金
	    sSql = 	" select Sum(nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as totsum "+
	    			" from BUSINESS_CONTRACT BC "+
	    			" where  CustomerID = '"+sRelativeID+"' "+
	    			" and ApplyType ='DependentApply' "+
	    			" and BusinessType like '1%' "+
	    			" and (finishdate is null or finishdate='') "+
	    			" and exists(select 1 from BUSINESS_CONTRACT "+
	    					"where SerialNo=BC.CreditAggreeMent "+
	    					"and BusinessType like '3%' and Maturity<'"+StringFunction.getToday()+"' ) "
	    			;
	    rs = Sqlca.getASResultSet(sSql);
	    if(rs.next())
	    {
	    	dSum12Sub4=rs.getDouble("totsum");
	    }
	    rs.getStatement().close(); 
	    	
		dSum12= dSum12Sub1+dSum12Sub2+dSum12Sub3+dSum12Sub4;
		sSum12=  DataConvert.toMoney(dSum12/iMoneyUnit);
		
    	dSum13 = Sqlca.getDouble("select Sum(Nvl(BC.Balance,0)*getERate(BusinessCurrency,'01',ERateDate)) "+
    			"from Business_Contract BC "+
    			"where BC.CustomerID = '"+sRelativeID+"' and BC.BusinessType like '1%' "
    			);                     // 贷款余额		
    	sSum13=  DataConvert.toMoney(dSum13/iMoneyUnit);
    	/**************************银行承兑汇票**********************************/
    	//1.银行承兑审批情况
    	//审批通过的申请(不包含终结合同对应的申请,不包含额度项下)对应的最终审批金额及保证金
		sSql = 	"select Sum(Nvl(BA.BusinessSum,0)*getERate(BA.BusinessCurrency,'01',BA.ERateDate)) as totsum,Sum(nvl(BA.BailSum,0)*getERate(BA.BusinessCurrency,'01',BA.ERateDate)) as ApplyBailSum "+
				"from Business_Apply BA "+
				"where BA.CustomerID = '"+sRelativeID+"'  "+
				" and BA.OrgFlag not like '%1' "+
				" and BA.ApplyType = 'IndependentApply' "+
				" and BA.BusinessType='2010'"+
				"and not exists (select 'X' from Apply_Relative AR where AR.ObjectNo = BA.SerialNo and ObjectType ='BusinessReApply' )"+
				" and not exists(select 'X' from Business_Contract where RelativeSerialno=BA.SerialNo "+
				" and ((FinishDate is not null and FinishDate<>'') or "+
				"(Maturity<'"+StringFunction.getToday()+"' and BusinessType like '3%'))) "
				;
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dSum14Sub1=rs.getDouble("totsum");
			dBailSum15Sub1=rs.getDouble("ApplyBailSum");
		}
		rs.getStatement().close();
		
		//未终结无申请合同金额及保证金
		sSql = 	" select Sum(Nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as totsum,Sum(nvl(BailSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as UnApplyBailSum "+
				" from Business_Contract "+
				" where CustomerID  = '"+sRelativeID+"'  "+
				" and ApplyType = 'IndependentApply' "+
				" and BusinessType='2010' "+
				" and (RelativeSerialNo is null or RelativeSerialNo='' or RelativeSerialNo not like 'BA%')"+
				" and (FinishDate is null or FinishDate='') "+
				" and  ((Maturity >='"+StringFunction.getToday()+"' and BusinessType like '3%')" +
				" or BusinessType not like '3%') "
				;
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dSum14Sub2=rs.getDouble("totsum");
			dBailSum15Sub2=rs.getDouble("UnApplyBailSum");
		}
		rs.getStatement().close(); 	
		//额度分配金额,保证金信息
		sSql = "select sum(Nvl(CL.LineSum1,0)*getERate(CL.Currency,'01',CL.ERateDate)) as CLBusinessSum,"+
				" sum(Nvl(CL.BailRatio,0)*nvl(CL.LineSum1,0)*0.01*getERate(CL.Currency,'01',CL.ERateDate)) as CLBailSum "+
			 "from CL_INFO CL,BUSINESS_CONTRACT BC "+
			 "where CL.BCSerialno=BC.Serialno "+
			 " and CL.ParentLineID is not null and CL.ParentLineID<>'' "+
			 " and BC.Businesstype='3010' "+
			 " and CL.BusinessType='2010' "+
			 " and CL.CustomerID  = '"+sRelativeID+"' "+
			 " and (BC.FinishDate is null or BC.FinishDate='') " +
			 " and  BC.Maturity >='"+StringFunction.getToday()+"' "
			 ;
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dSum14Sub3=rs.getDouble("CLBusinessSum");
			dBailSum15Sub3=rs.getDouble("CLBailSum");
		}
		rs.getStatement().close(); 	
		//已失效额度的额度项下业务金额及保证金(银行承兑汇票)
    	sSql = 	" select Sum(nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as totsum,Sum(nvl(BailSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as BailSum "+
    			" from BUSINESS_CONTRACT BC "+
    			" where  CustomerID = '"+sRelativeID+"' "+
    			" and ApplyType ='DependentApply' "+
    			" and BusinessType='2010' "+
    			" and (finishdate is null or finishdate='') "+
    			" and exists(select 1 from BUSINESS_CONTRACT "+
    					"where SerialNo=BC.CreditAggreeMent "+
    					"and BusinessType like '3%' and Maturity<'"+StringFunction.getToday()+"' ) "
    			;
    	rs = Sqlca.getASResultSet(sSql);
    	if(rs.next())
    	{
    		dSum14Sub4=rs.getDouble("totsum");
    		dBailSum15Sub4=rs.getDouble("BailSum");
    	}
    	rs.getStatement().close(); 
    	
		dSum14 =dSum14Sub1+dSum14Sub2+dSum14Sub3+dSum14Sub4;
		sSum14 =  DataConvert.toMoney(dSum14/iMoneyUnit);
		if(dSum14>0)
		{
			dSum15=(dBailSum15Sub1+dBailSum15Sub2+dBailSum15Sub3+dBailSum15Sub4)*100/dSum14;
		}else{
			dSum15=0.0;
		}
		sSum15 = DataConvert.toMoney(dSum15);
		sSql = 	"select Sum(Nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as BusinessSum,"+
				"Sum(Nvl(Balance,0)) as Balance,"+
				"Sum(Nvl(BailSum,0)) as BailSum "+
			"from Business_Contract "+
			"where BusinessType = '2010' "+
			" and CustomerID= '"+sRelativeID+"' "+
			" and (FinishDate is null or FinishDate='')"
		;
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dSum16 = rs.getDouble("Balance");
			if(rs.getDouble("BusinessSum")>0)
			{
				dSum17 = rs.getDouble("BailSum")*100/rs.getDouble("BusinessSum");
			}else{
				dSum17=0.0;
			}
			dSum18 = rs.getDouble("Balance")-rs.getDouble("BailSum");
			if(dSum18<0)
			{
				dSum18=0.0;
			}
		}
		rs.getStatement().close();
		sSum16= DataConvert.toMoney(dSum16/iMoneyUnit);
		sSum17= DataConvert.toMoney(dSum17);
		sSum18= DataConvert.toMoney(dSum18/iMoneyUnit);
    	/*************国际业务部分****************/
	  //审批通过的单笔申请(不包含终结合同对应的申请,不包含额度项下)对应的最终审批金额国际业务
		sSql = 	"select Sum(Nvl(BA.BusinessSum,0)*getERate(BA.BusinessCurrency,'01',BA.ERateDate)) as totsum "+
				" from Business_Apply BA "+
				"where BA.CustomerID  = '"+sRelativeID+"' "+
				" and BA.OrgFlag not like '%1' "+
				" and BA.ApplyType ='IndependentApply' "+
				" and (BusinessType like '1080%' or BusinessType like '2050%' ) "+
				" and not exists (select 'X' from Apply_Relative AR where AR.ObjectNo = BA.SerialNo and ObjectType ='BusinessReApply' )"+
				" and not exists(select 'X' from Business_Contract where RelativeSerialno=BA.SerialNo "+
					" and (FinishDate is not null and FinishDate<>'')) "
				;
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dSum19Sub1=rs.getDouble("totsum");
		}
		rs.getStatement().close();
		
		//未终结无申请国际业务合同金额
		sSql = 	" select Sum(Nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as totsum "+
				" from Business_Contract "+
				" where CustomerID  = '"+sRelativeID+"'  "+
				" and ApplyType = 'IndependentApply'"+
				" and (BusinessType like '1080%' or BusinessType like '2050%' ) "+
				" and (RelativeSerialNo is null or RelativeSerialNo='' or RelativeSerialNo not like 'BA%')"+
				" and (FinishDate is null or FinishDate='') ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dSum19Sub2=rs.getDouble("totsum");
		}
		rs.getStatement().close(); 	
		//额度分配国际业务金额
		 dSum19Sub3 = Sqlca.getDouble("select sum(nvl(CL.LineSum1,0)*getERate(CL.Currency,'01',CL.ERateDate)) as CLBusinessSum "+
				 "from CL_INFO CL,BUSINESS_CONTRACT BC "+
				 "where CL.BCSerialno=BC.Serialno "+
				 "and CL.ParentLineID is not null and CL.ParentLineID<>'' "+
				 "and BC.Businesstype='3010' "+
				 " and (CL.BusinessType like '1080%' or CL.BusinessType like '2050%' ) "+
				 " and CL.CustomerID  = '"+sRelativeID+"' "+
				 " and (BC.FinishDate is null or BC.FinishDate='') " +
				 " and  BC.Maturity >='"+StringFunction.getToday()+"' "
				);  
		//已失效额度的额度项下业务金额及保证金(银行承兑汇票)
	    	sSql = 	" select Sum(nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)) as totsum "+
	    			" from BUSINESS_CONTRACT BC "+
	    			" where  CustomerID = '"+sRelativeID+"' "+
	    			" and ApplyType ='DependentApply' "+
	    			" and (BusinessType like '1080%' or BusinessType like '2050%' )  "+
	    			" and (finishdate is null or finishdate='') "+
	    			" and exists(select 1 from BUSINESS_CONTRACT "+
	    					"where SerialNo=BC.CreditAggreeMent "+
	    					"and BusinessType like '3%' and Maturity<'"+StringFunction.getToday()+"' ) "
	    			;
	    	rs = Sqlca.getASResultSet(sSql);
	    	if(rs.next())
	    	{
	    		dSum19Sub4=rs.getDouble("totsum");
	    	}
	    	rs.getStatement().close(); 
	    	
		dSum19= dSum19Sub1+dSum19Sub2+dSum19Sub3+dSum19Sub4;
		sSum19=  DataConvert.toMoney(dSum19/iMoneyUnit);
		//国际业务授信余额
    	dSum20 = Sqlca.getDouble("select Sum(Nvl(Balance,0)*getERate(BusinessCurrency,'01',ERateDate)) "+
    			"from Business_Contract "+
    			"where (BusinessType like '1080%' or BusinessType like '2050%' )  "+
    			" and CustomerID = '"+sRelativeID+"' "+
    			" and (FinishDate is  null or FinishDate='')"
    			);
	    sSum20=  DataConvert.toMoney(dSum20/iMoneyUnit);
	    /********************已审批未发放****************************/
	    //已批未放
        dSum21 = dSum9 - Sqlca.getDouble("select Sum(Nvl(ActualPutOutSum,0)*getERate(BusinessCurrency,'01',ERateDate)) "+
        		" from Business_Contract "+
        		" where CustomerID = '"+sRelativeID+"' "+
        		" and (FinishDate is  null or  FinishDate='') "+
        		" and BusinessType not like '3%'"
    			);
	    sSum21=  DataConvert.toMoney(dSum21/iMoneyUnit);
        sOrgName = Sqlca.getString("select getOrgName(OperateOrgID) "+
        		"from Business_Apply "+
        		"where CustomerID = '"+sRelativeID+"' ");
        if(sOrgName == null) sOrgName = "" ;
%>
	    <tr id=<%=iRow++%>>
	    <td colspan=1 align=center class=td1 ><%=iCount%><input type=hidden value='<%=iCount%>' name=<%="R"+String.valueOf(iRow)+"numa"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sGLCustomerNmae%><input type=hidden value='<%=sGLCustomerNmae%>' name=<%="R"+String.valueOf(iRow)+"numb"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum1%><input type=hidden value='<%=sSum1%>' name=<%="R"+String.valueOf(iRow)+"numc"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum2%><input type=hidden value='<%=sSum2%>' name=<%="R"+String.valueOf(iRow)+"numd"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum3%><input type=hidden value='<%=sSum3%>' name=<%="R"+String.valueOf(iRow)+"nume"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum4%><input type=hidden value='<%=sSum4%>' name=<%="R"+String.valueOf(iRow)+"numf"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum5%><input type=hidden value='<%=sSum5%>' name=<%="R"+String.valueOf(iRow)+"numg"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum6%><input type=hidden value='<%=sSum6%>' name=<%="R"+String.valueOf(iRow)+"numh"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sCustomerName%><input type=hidden value='<%=sCustomerName%>' name=<%="R"+String.valueOf(iRow)+"numi"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum9%><input type=hidden value='<%=sSum9%>' name=<%="R"+String.valueOf(iRow)+"numj"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum10%><input type=hidden value='<%=sSum10%>' name=<%="R"+String.valueOf(iRow)+"numk"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum12%><input type=hidden value='<%=sSum12%>' name=<%="R"+String.valueOf(iRow)+"numl"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum13%><input type=hidden value='<%=sSum13%>' name=<%="R"+String.valueOf(iRow)+"numm"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum14%><input type=hidden value='<%=sSum14%>' name=<%="R"+String.valueOf(iRow)+"numn"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum15%><input type=hidden value='<%=sSum15%>' name=<%="R"+String.valueOf(iRow)+"numo"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum16%><input type=hidden value='<%=sSum16%>' name=<%="R"+String.valueOf(iRow)+"nump"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum17%><input type=hidden value='<%=sSum17%>' name=<%="R"+String.valueOf(iRow)+"numq"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum18%><input type=hidden value='<%=sSum18%>' name=<%="R"+String.valueOf(iRow)+"numr"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum19%><input type=hidden value='<%=sSum19%>' name=<%="R"+String.valueOf(iRow)+"nums"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum20%><input type=hidden value='<%=sSum20%>' name=<%="R"+String.valueOf(iRow)+"numt"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sSum21%><input type=hidden value='<%=sSum21%>' name=<%="R"+String.valueOf(iRow)+"numu"%>></td>
	    <td colspan=1 align=center class=td1 ><%=sOrgName%><input type=hidden value='<%=sOrgName%>' name=<%="R"+String.valueOf(iRow)+"numv"%>></td>
	    </tr>
<%
    }
    rs2.getStatement().close();
%>
	</table>	
	</div>	
	</form>
</center>
</body>
</html>	
<script language=javascript>
	//---------------------定义按钮事件------------------------------------
	function formatContent()
	{
		var sContentNew = "",i=0;
		var iRowCount = 1;
		iRowCount =<%=iRow%>;
		
		var iColCount = 22;
		sContentNew +="<META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=gb_2312-80\">";
		sContentNew += "<STYLE>"; 
		sContentNew += ".table {  border: solid; border-width: 0px 0px 1px 1px; border-color: #000000 black #000000 #000000}";
		sContentNew += ".td {  font-size: 9pt;border-color: #000000; border-style: solid; border-top-width: 1px; border-right-width: 1px; border-bottom-width: 0px; border-left-width: 0px}.inputnumber {border-style:none;border-width:thin;border-color:#e9e9e9;text-align:right;}.pt16songud{font-family: '黑体','宋体';font-size: 16pt;font-weight:bold;text-decoration: none}.myfont{font-family: '黑体','宋体';font-size: 9pt;font-weight:bold;text-decoration: none}"
		sContentNew += "</STYLE>";
		
		sContentNew += "<table align=center border=1 cellspacing=0 cellpadding=0 bgcolor=#E4E4E4 bordercolor=#999999 bordercolordark=#FFFFFF >";
		sContentNew += "<tr>";
		sContentNew += "    <td  align=right colspan="+iColCount+" bgcolor=#aaaaaa ><font style=' font-size: 12pt;FONT-FAMILY:宋体;FONT-WEIGHT: bold;color:black;background-color:#aaaaaa' >单位：万元</font></td>";
		sContentNew += "</tr>";
		sContentNew += "<tr>";
		sContentNew += "	<td rowspan=3 colspan=1 align=center  >序号</td>";
		sContentNew += "	<td rowspan=3 colspan=1 align=center  >集团客户名称</td>";
		sContentNew += "	<td rowspan=3 colspan=1 align=center  >总审批金额</td>";
		sContentNew += "	<td rowspan=3 colspan=1 align=center  >总审批敞口</td>";
		sContentNew += "	<td rowspan=3 colspan=1 align=center  >贷款余额+银行承兑汇票敞口（敞口余额）</td>";
		sContentNew += "	<td rowspan=3 colspan=1 align=center  >贷款余额</td>";
		sContentNew += "	<td rowspan=3 colspan=1 align=center  >银行承兑汇票敞口</td>";
		sContentNew += "	<td rowspan=3 colspan=1 align=center  >已批未发放总额度</td>";
		sContentNew += "	<td rowspan=3 colspan=1 align=center  >集团成员名称</td>";
		sContentNew += "	<td rowspan=3 colspan=1 align=center  >总审批金额</td>";
		sContentNew += "	<td rowspan=3 colspan=1 align=center  >总审批敞口</td>";
		sContentNew += "	<td rowspan=2 colspan=2 align=center  >贷款部分</td>";
		sContentNew += "	<td rowspan=1 colspan=5 align=center  >银行承兑汇票</td>";
		sContentNew += "	<td rowspan=2 colspan=2 align=center  >国际业务部分</td>";
		sContentNew += "	<td rowspan=3 colspan=1 align=center  >已批未发放余额</td>";
		sContentNew += "	<td rowspan=3 colspan=1 align=center  >经办行</td>";
		sContentNew += "</tr>";
		sContentNew += "<tr>";
		sContentNew += "	<td rowspan=1 colspan=2 align=center  >审批情况</td>";
		sContentNew += "	<td rowspan=1 colspan=3 align=center  >已签发情况</td>";
		sContentNew += "</tr>";
		sContentNew += "<tr>";
		sContentNew += "	<td rowspan=1 colspan=1 align=center  >贷款审批金额</td>";
		sContentNew += "	<td rowspan=1 colspan=1 align=center  >贷款余额</td>";
		sContentNew += "	<td rowspan=1 colspan=1 align=center  >银行承兑汇票金额</td>";
		sContentNew += "	<td rowspan=1 colspan=1 align=center  >保证金比例</td>";
		sContentNew += "	<td rowspan=1 colspan=1 align=center  >银行承兑汇票余额</td>";
		sContentNew += "	<td rowspan=1 colspan=1 align=center  >已签发银行承兑汇票保证金比例</td>";	
		sContentNew += "	<td rowspan=1 colspan=1 align=center  >银行承兑汇票敞口余额</td>";
		sContentNew += "	<td rowspan=1 colspan=1 align=center  >国际业务审批金额</td>";
		sContentNew += "	<td rowspan=1 colspan=1 align=center  >国际业务授信余额</td>";
		sContentNew += "</tr>";
		
		for(i=1;i<=iRowCount;i++)
		{
			sContentNew += "<tr>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numa").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numb").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numc").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numd").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"nume").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numf").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numg").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numh").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numi").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numj").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numk").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numl").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numm").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numn").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numo").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"nump").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numq").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numr").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"nums").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numt").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numu").value+"</td>";
			sContentNew += "    <td colspan=1 align=center  >"+document.forms("reportInfo").elements("R"+i+"numv").value+"</td>";
			sContentNew += "</tr>";
			
		}	
		
		sContentNew += "</table>";
		//防止因导出数据量太小，导出EXCEL时变成乱码
		sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		sContentNew += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
		
		return(sContentNew);	
	}
	</script>
<%/*~END~*/%>
		
<%@ include file="/IncludeEnd.jsp"%>

