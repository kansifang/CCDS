package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;


public class UpdateTrade6030 extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {
	 	//自动获得传入的参数值 商业贷款申请流水号，委贷贷款号，商贷贷款号
		ASResultSet rs = null;
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		String sCommercialNo   = (String)this.getAttribute("CommercialNo");
		String sAccumulationNo   = (String)this.getAttribute("AccumulationNo");
		if(sObjectNo==null) sObjectNo="";
		if(sCommercialNo==null) sCommercialNo="";
		if(sAccumulationNo==null) sAccumulationNo="";
		//定义变量,关联委贷申请号，申请核心客户号,客户编号
		String sApplyMFCustomerID="",sApplyCustomerID = "";
		String sSql = "";
		String sSql1 = "";
		String sMessage ="";
		String sMFCustomerID = ""; //客户号
 		String sCertType = ""; //证件类型
 		String sCertID = ""; //证件号码
 		String sCustomerName = ""; //姓名
 		String sBusinessType = ""; //商贷贷款业务类型
 		String sBusinessCurrency = ""; //币种
 		double dBusinessSum1 = 0.00; //商贷申请金额
 		double dBusinessSum2 = 0.00; //委贷申请金额
 		int iTermMonth = 0;//贷款期限（月）
 		int iTermDay = 0;//贷款期限（天）
 		String sCorpusPayMethod = "";//还款方式
 		String sPayCyc = ""; //还款间隔
 		String sPayDateType = "";//还款日期确定方式
 		String sType1 = "";//还款账号类型
 		String sAccountNo = "";//还款账号
 		String sInterestCType = "";//利息计算标志
 		String sloanType = ""; //放款方式
 		String sType3 = "";//划款方向
 		String sType2 = "";//划款账号类型
 		String sLoanAccountNo = "";//划款账号
 		double dRateFloat1 = 0.00; //商贷利率浮动比
 		String sBaseRateType1 = "";//商贷基准利率类型
 		double dRateFloat2 = 0.00; //委贷利率浮动比
 		String sBaseRateType2 = "";//委贷基准利率类型
 		String sOverdueAddRate = ""; //逾期加罚率
 		String sInputOrgID = ""; //机构号
 		String sOperateUserID = "";//经办人员
 		String sInputUserID = ""; //申请人员
 		String sdescribe1 = "";//房屋贷款属性
 		
 		String sGDInputOrgID = "";//贷款承办银行支行机构代码
 		String sGDSerialNo = "";//申请表编号
 		String ssex = "";//借款人性别
 		String sRetireAge = "";//退休年龄
 		String sRetireLoanType = "";//贷款类别
 		String sIsLocalFlag = "";//借款人户籍是否在本市
 		String sEduDegree = "";//文化程度
 		String sOccupation = "";//职业
 		String sNativePlace = "";//户籍所在地详细地址
 		String sFamilyAdd = "";//家庭地址
 		String sFamilyZIP = "";//家庭邮政编码
 		String sFamilyTel = "";//家庭电话
 		String sMobileTelephone = "";//借款人手机号码
 		String sWorkCorp = "";//工作单位名称
 		String sWorkAdd = "";//单位地址
 		String sWorkZip = "";//单位邮政编码
 		String sWorkTel = "";//单位电话
 		String sCommAdd = "";//通讯地址
 		String sConsortInstanceFlag = "";//借款人配偶情况
 		String sConsortShareHouse = "";//配偶是否为共同购房人
 		String sConsortName = "";//配偶姓名
 		String sConsortCertID = "";//配偶身份证号
 		String sConsortOtherCertID = "";//配偶其它证件号码
 		String sConsortTel = "";//配偶手机号码
 		String sConsortWorkCorp = "";//配偶工作单位
 		String sConsortWorkAdd = "";//配偶单位地址
 		String sConsortWorkZip = "";//配偶单位邮编
 		String sConsortWorkTel = "";//配偶单位电话
 		String sShareName1 = "";//其它共同购房人1姓名
 		String sShareCertID1 = "";//其它共同购房人1身份证号
 		String sShareConsortName1 = "";//其它共同购房人1配偶姓名
 		String sShareConsortCertID1 = "";//其它共同购房人1配偶身份证号
 		String sShareConsortSH1 = "";//其它共同购房人1配偶是否为共同购房人
 		String sShareName2 = "";//其它共同购房人2姓名
 		String sShareCertID2 = "";//其它共同购房人2身份证号
 		String sShareConsortName2 = "";//其它共同购房人2配偶姓名
 		String sShareConsortCertID2 = "";//其它共同购房人2配偶身份证号
 		String sShareConsortSH2 = "";//其它共同购房人2配偶是否为共同购房人
 		String sCreditSource1 = "";//征信信息中准贷记卡透支180天以上余额
 		String sCreditSource2 = "";//征信信息中贷记卡当前逾期期数
 		String sCreditSource3 = "";//征信信息中贷记卡12个月内未偿还最低还款额次数
 		String sCreditSource4 = "";//征信信息中当前贷款逾期总额
 		String sCreditSource5 = "";//征信信息中本月贷款应还款额
 		String sCreditSource6 = "";//征信信息中24个月内贷款连续逾期期数
 		String sCreditSource7 = "";//征信信息中住房贷款笔数
 		String sCreditSource8 = "";//征信信息中最近24个月内特殊交易
 		String sCreditSource9 = "";//征信信息中特别记录
 		String sCreditSource10 = "";//借款人累计逾期期数
 		String sCCreditSource1 = "";//借款人配偶征信信息中准贷记卡透支180天以上余额
 		String sCCreditSource2 = "";//借款人配偶征信信息中贷记卡当前逾期期数
 		String sCCreditSource3 = "";//借款人配偶征信信息中贷记卡12个月内未偿还最低还款额次数
 		String sCCreditSource4 = "";//借款人配偶征信信息中当前贷款逾期总额
 		String sCCreditSource5 = "";//借款人配偶征信信息中本月贷款应还款额
 		String sCCreditSource6 = "";//借款人配偶征信信息中24个月内贷款连续逾期期数
 		String sCCreditSource7 = "";//借款人配偶征信信息中住房贷款笔数
 		String sCCreditSource8 = "";//借款人配偶征信信息中最近24个月内特殊交易
 		String sCCreditSource9 = "";//借款人配偶征信信息中历史特别记录
 		String sCCreditSource10 = "";//借款人配偶累计逾期期数
 		String sBuyHouseUseType = "";//贷款购建修房用途类型
 		String sBuyContractNo = "";//购房合同协议编号
 		String sHouseSeller = "";//出卖人
 		String sSellOpenBank = "";//出卖人开户行
 		String sSellAccountNo = "";//出卖人账号
 		String sBuyItemName = "";//购房项目名称
 		String sBuyHouseAdd1 = "";//购建修房坐落区县
 		String sBuyHouseAdd2 = "";//购建修房详细地址道(路、街)
 		String sBuyHouseAdd3 = "";//购建房详细地址中小区（里）地址
 		String sBuyHouseAdd4 = "";//购建房详细地址中楼号
 		String sBuyHouseAdd5 = "";//层次室号(楼门号与屋号等用'-'分隔)
 		double dBuildArea = 0.00;//建筑面积
 		double dHousePrice = 0.00;//房屋售价
 		double dSelfPrice = 0.00;//自筹资金额
 		String sSelfAccounts = "";//自筹款存款帐号
 		double dRightRate = 0.00;//借款人家庭所占产权比例
 		double dEvaluateValue = 0.00;//评估价格
 		double dBudgetValue = 0.00;//建修房预算价值
 		String sIsUseConsortPact = "";//是否使用配偶额度
 		String sTermUseType = "";//贷款额度期限确定方式
 		int iMostTermMonth=0;//最长（确定）贷款期限(月)
 		double dMostLoanValue = 0.00;//最高（确定）住房公积金贷款额度
 		double dTotalBusinessSum = 0.00;//贷款金额合计
 		String sStartDate = "";//贷款起日(年月日)
 		String sEndDate = "";//贷款止日(年月日)
 		double dRiseFallRate = 0.00;//等额本息递增或递减比例
 		double dMonthReturnSum = 0.00;//月还款额
 		String sCreditUseInfo = "";//借款人公积金贷款使用情况
 		int iOverdueTerms = 0;//借款人最近24个月内连续逾期期数
 		String sUnusualRecord = "";//借款人公积金贷款是否存在特别记录
 		double dOverdueTermsSum = 0.00;//借款人住房公积金贷款累计逾期期数
 		String sUnusualDeal = "";//借款人住房公积金贷款最近24个月特殊交易情况
 		String sReCreditUseInfo = "";//配偶公积金贷款使用情况
 		int iReOverdueTerms = 0;//配偶近最近24个月内连续逾期期数
 		String sReUnusualRecord = "";//配偶公积金贷款是否存在特别记录
 		double dReOverdueTermsSum = 0.00;//配偶住房公积金贷款累计逾期期数
 		String sReUnusualDeal = "";//配偶住房公积金贷款最近24个月特殊交易情况
 		String sVouchType = "";//担保方式
 		String sLoanHappenDate = "";//借款受理日期
 		String sGuarantorID = "";//担保客户ID
 		String sGuarantyCertType = "";//担保人证件类型
 		String sGuarantLoanCardNo = "";//担保人贷跨卡
 		String sApplyInputUserID = "";//申请人
 		String sApplyBusinessType = "";//业务申请业务品种
 		String sChangType = "";//变更类型
 		
 		//为防止重复插入多条数据删除信息
 		//删除购房信息:
		Sqlca.executeSQL("delete from HOUSE_INFO where serialno in(select ObjectNo from apply_relative where ObjectType='HouseInfo' and SerialNo='"+sObjectNo+"')");
		Sqlca.executeSQL("delete from Apply_relative where ObjectType='HouseInfo' and SerialNo='"+sObjectNo+"'");
		//删除担保信息:
		Sqlca.executeSQL("delete from GUARANTY_INFO where GuarantyId in(select guarantyID from GUARANTY_RELATIVE where ObjectType='CreditApply' and objectno='"+sObjectNo+"')");
		Sqlca.executeSQL("delete from GUARANTY_Contract where SerialNo in(select ContractNo from GUARANTY_RELATIVE where ObjectType='CreditApply' and objectno='"+sObjectNo+"')");
		Sqlca.executeSQL("delete from Apply_relative where ObjectType='GuarantyContract' and SerialNo='"+sObjectNo+"'");
		
		
		//更具参数获取需要的值
		//获取商贷申请相关信息
		sSql= " select getMFCustomerID(CustomerID) as MFCustomerID,CustomerID,InputUserID,BusinessType from BUSINESS_APPLY"+
			  " where SerialNo = '"+sObjectNo+"'";
		rs = Sqlca.getResultSet(sSql);
	    if(rs.next())
	    {
	    	sApplyMFCustomerID = rs.getString("MFCustomerID");
	    	sApplyCustomerID = rs.getString("CustomerID");
	    	sApplyInputUserID = rs.getString("InputUserID");
	    	sApplyBusinessType = rs.getString("BusinessType");
	    }
	    rs.getStatement().close();
	    
 		//获取公积金传入的中间表申请信息
		sSql = " select MFCustomerID,getFromGDCode('CertType',CertType,'Ind11') as CertType,CertID," +
			"CustomerName,BusinessType,getFromGDCode('Currency',BusinessCurrency,'01') as BusinessCurrency" +
			",BusinessSum1,BusinessSum2," +
			"TermMonth,TermDay,getFromGDCode('CorpusPayMethod2',CorpusPayMethod,'') as CorpusPayMethod," +
			"getFromGDCode('GDPayCyc',PayCyc,'') as PayCyc,PayDateType," +
			"getFromGDCode('GDAccountType',Type1,'') as Type1,AccountNo,InterestCType,loanType," +
			"getFromGDCode('GDPayDirection',Type3,'') as Type3," +
			"getFromGDCode('GDAccountType',Type2,'') as Type2,LoanAccountNo,RateFloat1," +
			"getFromGDCode('BaseRateType',BaseRateType1,'') as BaseRateType1,RateFloat2," +
			"getFromGDCode('BaseRateType',BaseRateType2,'') as BaseRateType2,OverdueAddRate," +
			"InputOrgID,OperateUserID,InputUserID, "+
			
			"GDInputOrgID,GDSerialNo,getFromGDCode('Sex',sex,'') as sex,RetireAge,"+
			"getFromGDCode('RetireLoanType',RetireLoanType,'') as RetireLoanType," +
			"getFromGDCode('YesNo',IsLocalFlag,'') as IsLocalFlag," +
			"getFromGDCode('EducationExperience',EduDegree,'') as EduDegree,getFromGDCode('Occupation',Occupation,'0') as Occupation,NativePlace," +
			"FamilyAdd,FamilyZIP,FamilyTel,MobileTelephone,WorkCorp," +
			"WorkAdd,WorkZip,WorkTel,getFromGDCode('CommAddFlag',CommAdd,'') as CommAdd,ConsortInstanceFlag," +
			"getFromGDCode('YesNo',ConsortShareHouse,'') as ConsortShareHouse," +
			"ConsortName,ConsortCertID,ConsortOtherCertID," +
			"ConsortTel,ConsortWorkCorp,ConsortWorkAdd,ConsortWorkZip,ConsortWorkTel," +
			"ShareName1,ShareCertID1,ShareConsortName1,ShareConsortCertID1," +
			"getFromGDCode('YesNo',ShareConsortSH1,'') as ShareConsortSH1,ShareName2,ShareCertID2,ShareConsortName2,ShareConsortCertID2," +
			"getFromGDCode('YesNo',ShareConsortSH2,'') as ShareConsortSH2,CreditSource1,CreditSource2,CreditSource3,CreditSource4," +
			"CreditSource5,CreditSource6,CreditSource7,CreditSource8,CreditSource9," +
			"CreditSource10,CCreditSource1,CCreditSource2,CCreditSource3,CCreditSource4," +
			"CCreditSource5,CCreditSource6,CCreditSource7,CCreditSource8,CCreditSource9," +
			"CCreditSource10,getFromGDCode('HouseUseType',BuyHouseUseType,'') as BuyHouseUseType," +
			"BuyContractNo,HouseSeller,SellOpenBank," +
			"SellAccountNo,BuyItemName," +
			"getFromGDCode('AreaCode',BuyHouseAdd1,'') as BuyHouseAdd1,BuyHouseAdd2,BuyHouseAdd3," +
			"BuyHouseAdd4,BuyHouseAdd5,BuildArea,HousePrice,SelfPrice,SelfAccounts," +
			"RightRate ,EvaluateValue,BudgetValue," +
			"getFromGDCode('YesNo',IsUseConsortPact,'') as IsUseConsortPact," +
			"getFromGDCode('TermUseType',TermUseType,'') as TermUseType," +
			"MostTermMonth,MostLoanValue,TotalBusinessSum,StartDate,EndDate," +
			"RiseFallRate,MonthReturnSum," +
			"getFromGDCode('CreditUseInfo',CreditUseInfo,'') as CreditUseInfo,OverdueTerms," +
			"getFromGDCode('UnusualRecord',UnusualRecord,'') as UnusualRecord," +
			"OverdueTermsSum," +
			"getFromGDCode('UnusualDeal',UnusualDeal,'') as UnusualDeal," +
			"getFromGDCode('CreditUseInfo',ReCreditUseInfo,'') as ReCreditUseInfo,ReOverdueTerms," +
			"getFromGDCode('UnusualRecord',ReUnusualRecord,'') as ReUnusualRecord," +
			"ReOverdueTermsSum," +
			"getFromGDCode('UnusualDeal',ReUnusualDeal,'') as ReUnusualDeal," +
			"VouchType,LoanHappenDate,ChangType "+
			" from GD_BUSINESSAPPLY"+
			" where CommercialNo = '"+sCommercialNo+"' and AccumulationNo='"+sAccumulationNo+"'";
		rs = Sqlca.getResultSet(sSql);
	    if(rs.next())
	    {
	    	sMFCustomerID    = rs.getString("MFCustomerID");
	    	sCertType        = rs.getString("CertType");
	    	sCertID          = rs.getString("CertID");
	    	sCustomerName    = rs.getString("CustomerName");
	    	sBusinessType    = rs.getString("BusinessType");
	    	if(sBusinessType.equals("102")||sBusinessType.equals("106"))
			{
	    		sBusinessType = "1110010";
	    		sdescribe1 = "01";
			}else if(sBusinessType.equals("104")||sBusinessType.equals("113"))
			{
				sBusinessType = "1110020";
				sdescribe1 = "02";	
			}
	    	sBusinessCurrency= rs.getString("BusinessCurrency");
	    	dBusinessSum1    = rs.getDouble("BusinessSum1");
	    	dBusinessSum2    = rs.getDouble("BusinessSum2");
	    	iTermMonth       = rs.getInt("TermMonth");
	    	iTermDay         = rs.getInt("TermDay");
	    	sCorpusPayMethod = rs.getString("CorpusPayMethod");
	    	sPayCyc          = rs.getString("PayCyc");
	    	sPayDateType     = rs.getString("PayDateType");
	    	sType1           = rs.getString("Type1");
	    	sAccountNo       = rs.getString("AccountNo");
	    	sInterestCType   = rs.getString("InterestCType");
	    	sloanType        = rs.getString("loanType");
	    	sType3           = rs.getString("Type3");
	    	sType2           = rs.getString("Type2");
	    	sLoanAccountNo   = rs.getString("LoanAccountNo");
	    	dRateFloat1      = rs.getDouble("RateFloat1");
	    	sBaseRateType1   = rs.getString("BaseRateType1");
	    	dRateFloat2      = rs.getDouble("RateFloat2");
	    	sBaseRateType2   = rs.getString("BaseRateType2");
	    	sOverdueAddRate  = rs.getString("OverdueAddRate");
	    	sInputOrgID      = rs.getString("InputOrgID");
	    	sOperateUserID   = rs.getString("OperateUserID");
	    	sInputUserID     = rs.getString("InputUserID");
	    	
	    	
	    	sGDInputOrgID			=rs.getString("GDInputOrgID");
	    	sGDSerialNo             =rs.getString("GDSerialNo");
	    	ssex                    =rs.getString("sex");
	    	sRetireAge              =rs.getString("RetireAge");
	    	sRetireLoanType         =rs.getString("RetireLoanType");
	    	sIsLocalFlag            =rs.getString("IsLocalFlag");
	    	sEduDegree              =rs.getString("EduDegree");
	    	sOccupation             =rs.getString("Occupation");
	    	sNativePlace            =rs.getString("NativePlace");
	    	sFamilyAdd              =rs.getString("FamilyAdd");
	    	sFamilyZIP              =rs.getString("FamilyZIP");
	    	sFamilyTel              =rs.getString("FamilyTel");
	    	sMobileTelephone        =rs.getString("MobileTelephone");
	    	sWorkCorp               =rs.getString("WorkCorp");
	    	sWorkAdd                =rs.getString("WorkAdd");
	    	sWorkZip                =rs.getString("WorkZip");
	    	sWorkTel                =rs.getString("WorkTel");
	    	sCommAdd                =rs.getString("CommAdd");
	    	sConsortInstanceFlag    =rs.getString("ConsortInstanceFlag");
	    	sConsortShareHouse      =rs.getString("ConsortShareHouse");
	    	sConsortName            =rs.getString("ConsortName");
	    	sConsortCertID          =rs.getString("ConsortCertID");
	    	sConsortOtherCertID     =rs.getString("ConsortOtherCertID");
	    	sConsortTel             =rs.getString("ConsortTel");
	    	sConsortWorkCorp        =rs.getString("ConsortWorkCorp");
	    	sConsortWorkAdd         =rs.getString("ConsortWorkAdd");
	    	sConsortWorkZip         =rs.getString("ConsortWorkZip");
	    	sConsortWorkTel         =rs.getString("ConsortWorkTel");
	    	sShareName1             =rs.getString("ShareName1");
	    	sShareCertID1           =rs.getString("ShareCertID1");
	    	sShareConsortName1      =rs.getString("ShareConsortName1");
	    	sShareConsortCertID1    =rs.getString("ShareConsortCertID1");
	    	sShareConsortSH1        =rs.getString("ShareConsortSH1");
	    	sShareName2             =rs.getString("ShareName2");
	    	sShareCertID2           =rs.getString("ShareCertID2");
	    	sShareConsortName2      =rs.getString("ShareConsortName2");
	    	sShareConsortCertID2    =rs.getString("ShareConsortCertID2");
	    	sShareConsortSH2        =rs.getString("ShareConsortSH2");
	    	sCreditSource1          =rs.getString("CreditSource1");
	    	sCreditSource2          =rs.getString("CreditSource2");
	    	sCreditSource3          =rs.getString("CreditSource3");
	    	sCreditSource4          =rs.getString("CreditSource4");
	    	sCreditSource5          =rs.getString("CreditSource5");
	    	sCreditSource6          =rs.getString("CreditSource6");
	    	sCreditSource7          =rs.getString("CreditSource7");
	    	sCreditSource8          =rs.getString("CreditSource8");
	    	sCreditSource9          =rs.getString("CreditSource9");
	    	sCreditSource10         =rs.getString("CreditSource10");
	    	sCCreditSource1         =rs.getString("CCreditSource1");
	    	sCCreditSource2         =rs.getString("CCreditSource2");
	    	sCCreditSource3         =rs.getString("CCreditSource3");
	    	sCCreditSource4         =rs.getString("CCreditSource4");
	    	sCCreditSource5         =rs.getString("CCreditSource5");
	    	sCCreditSource6         =rs.getString("CCreditSource6");
	    	sCCreditSource7         =rs.getString("CCreditSource7");
	    	sCCreditSource8         =rs.getString("CCreditSource8");
	    	sCCreditSource9         =rs.getString("CCreditSource9");
	    	sCCreditSource10        =rs.getString("CCreditSource10");
	    	sBuyHouseUseType        =rs.getString("BuyHouseUseType");
	    	sBuyContractNo          =rs.getString("BuyContractNo");
	    	sHouseSeller            =rs.getString("HouseSeller");
	    	sSellOpenBank           =rs.getString("SellOpenBank");
	    	sSellAccountNo          =rs.getString("SellAccountNo");
	    	sBuyItemName            =rs.getString("BuyItemName");
	    	sBuyHouseAdd1           =rs.getString("BuyHouseAdd1");
	    	sBuyHouseAdd2           =rs.getString("BuyHouseAdd2");
	    	sBuyHouseAdd3           =rs.getString("BuyHouseAdd3");
	    	sBuyHouseAdd4           =rs.getString("BuyHouseAdd4");
	    	sBuyHouseAdd5           =rs.getString("BuyHouseAdd5");
	    	dBuildArea              =rs.getDouble("BuildArea")/10000.00;
	    	dHousePrice             =rs.getDouble("HousePrice")/10000.00;
	    	dSelfPrice              =rs.getDouble("SelfPrice")/10000.00;
	    	sSelfAccounts           =rs.getString("SelfAccounts");
	    	dRightRate              =rs.getDouble("RightRate")/10000.00;
	    	dEvaluateValue          =rs.getDouble("EvaluateValue")/10000.00;
	    	dBudgetValue            =rs.getDouble("BudgetValue")/10000.00;
	    	sIsUseConsortPact       =rs.getString("IsUseConsortPact");
	    	sTermUseType            =rs.getString("TermUseType");
	    	iMostTermMonth          =Integer.parseInt(rs.getString("MostTermMonth").equals("")?"0":rs.getString("MostTermMonth"))/10000;
	    	dMostLoanValue          =rs.getDouble("MostLoanValue")/10000.00;
	    	dTotalBusinessSum       =rs.getDouble("TotalBusinessSum")/10000.00;
	    	sStartDate              =rs.getString("StartDate");
	    	sEndDate                =rs.getString("EndDate");
	    	dRiseFallRate           =Double.parseDouble(rs.getString("RiseFallRate").equals("")?"0":rs.getString("RiseFallRate"))/10000.00;
	    	dMonthReturnSum         =rs.getDouble("MonthReturnSum")/10000.00;
	    	sCreditUseInfo          =rs.getString("CreditUseInfo");
	    	iOverdueTerms           =rs.getInt("OverdueTerms")/10000;
	    	sUnusualRecord          =rs.getString("UnusualRecord");
	    	dOverdueTermsSum        =rs.getDouble("OverdueTermsSum")/10000.00;
	    	sUnusualDeal            =rs.getString("UnusualDeal");
	    	sReCreditUseInfo        =rs.getString("ReCreditUseInfo");
	    	iReOverdueTerms         =rs.getInt("ReOverdueTerms")/10000;
	    	sReUnusualRecord        =rs.getString("ReUnusualRecord");
	    	dReOverdueTermsSum      =rs.getDouble("ReOverdueTermsSum")/10000.00;
	    	sReUnusualDeal          =rs.getString("ReUnusualDeal");
	    	sVouchType              =rs.getString("VouchType");
	    	sChangType				=rs.getString("ChangType");
	    	if("1".equals(sVouchType))
	    	{
	    		sVouchType = "020";
	    	}else if("2".equals(sVouchType))
	    	{
	    		sVouchType = "040";
	    	}else if("3".equals(sVouchType))
	    	{
	    		sVouchType = "010";
	    	}else{
	    		sVouchType = "005";
	    	}
	    	sLoanHappenDate         =rs.getString("LoanHappenDate");
	    	if(sLoanHappenDate.length()>=8)
	    	{
	    		sLoanHappenDate = sLoanHappenDate.substring(0,4)+"/"+sLoanHappenDate.substring(4,6)+"/"+sLoanHappenDate.substring(6,8);
	    	}else{
	    		sLoanHappenDate="";
	    	}
	    	
	    }
	    rs.getStatement().close();
	    if("".equals(sApplyMFCustomerID))
	    {
	    	sMessage="请先获取核心客户号！";
	    	return sMessage;
	    }else if(!sMFCustomerID.equals(sApplyMFCustomerID))
	    {
	    	sMessage="该申请客户与公积金系统客户不一致，请重新申请!";
	    	return sMessage;
	    }
	    //更新商贷申请信息
	    sSql=" update BUSINESS_APPLY set " +
	    			//" BusinessType='"+sBusinessType+"',"+
					" describe1='"+sdescribe1+"',"+
			        " BusinessCurrency='"+sBusinessCurrency+"',"+
			        " BusinessSum="+("1110027".equals(sApplyBusinessType)?dBusinessSum1:dBusinessSum2)+","+
			        " TermMonth="+iTermMonth+","+
			        " TermDay="+iTermDay+","+
			        " CorpusPayMethod='"+sCorpusPayMethod+"',"+
			        " RateFloatType='0',"+
			        " RateFloat="+dRateFloat1+","+
			        " BaseRateType='"+sBaseRateType1+"', "+
			        
			        " PayCyc='"+sCorpusPayMethod+"',"+
			        " EquipmentSum="+dBusinessSum1+", "+
			        " InvoiceSum="+dBusinessSum2+", "+
			        " GDSerialNo='"+sGDSerialNo+"', "+
			        " RetireLoanType='"+sRetireLoanType+"', "+
			        " IsUseConsortPact='"+sIsUseConsortPact+"', "+
			        " TermUseType='"+sTermUseType+"', "+
			        " MostTermMonth="+iMostTermMonth+", "+
			        " MostLoanValue="+dMostLoanValue+", "+
			        " TotalBusinessSum="+dTotalBusinessSum+", "+
			        " RiseFallRate="+dRiseFallRate+", "+
			        " MonthReturnSum="+dMonthReturnSum+", "+
			        " CreditUseInfo='"+sCreditUseInfo+"', "+
			        " OverdueTerms="+iOverdueTerms+", "+
			        " UnusualRecord='"+sUnusualRecord+"', "+
			        //" StartDate='"+sStartDate+"', "+
			        //" EndDate='"+sEndDate+"', "+
			        " OverdueTermsSum="+dOverdueTermsSum+", "+
			        " UnusualDeal='"+sUnusualDeal+"', "+
			        " ReCreditUseInfo='"+sReCreditUseInfo+"', "+
			        " ReOverdueTerms="+iReOverdueTerms+", "+
			        " ReUnusualRecord='"+sReUnusualRecord+"', "+
			        " ReOverdueTermsSum="+dReOverdueTermsSum+", "+
			        " ReUnusualDeal='"+sReUnusualDeal+"', "+
			        " VouchType='"+sVouchType+"',  "+
			        " OccurDate='"+sLoanHappenDate+"', "+
			        " ChangType='"+sChangType+"' "+
			   "where SerialNo='"+sObjectNo+"'";
	    Sqlca.executeSQL(sSql);

	    //更新客户信息:CustomerID
	    sSql=" update IND_INFO set " +
			" sex ='"+ssex+"',"+
			" RetiringAge='"+sRetireAge+"',"+
	        " IsLocalFlag='"+sIsLocalFlag+"',"+
	        " EduDegree='"+sEduDegree+"',"+
	        " Occupation='"+sOccupation+"',"+
	        " NativePlace='"+sNativePlace+"',"+
	        " FamilyAdd='"+sFamilyAdd+"',"+
	        " FamilyTel='"+sFamilyTel+"',"+
	        " FamilyZIP='"+sFamilyZIP+"',"+
	        " MobileTelephone='"+sMobileTelephone+"',"+
	        " WorkCorp='"+sWorkCorp+"',"+
	        " WorkAdd='"+sWorkAdd+"',"+
	        " WorkZip='"+sWorkZip+"',"+
	        " WorkTel='"+sWorkTel+"',"+
	        " CommAdd='"+sCommAdd+"',"+
	       // " ConsortInstanceFlag='"+sConsortInstanceFlag+"',"+
	        " ConsortSHFLag='"+sConsortShareHouse+"' "+
        "where CustomerID='"+sApplyCustomerID+"'";
	    Sqlca.executeSQL(sSql);
	    
	    //更新配偶信息 是否新增
	    sSql=" update CUSTOMER_RELATIVE set " +
	        " Describe='"+sConsortWorkCorp+"',"+
	        " WorkAdd='"+sConsortWorkAdd+"',"+
	        " WorkZip='"+sConsortWorkZip+"',"+
	        " WorkTel='"+sConsortWorkTel+"'"+
        "where CertType='Ind01' and CertID ='"+sConsortCertID+"'";
	    Sqlca.executeSQL(sSql);
	    // 插入购房信息
	    String sHISerialNo1 = DBFunction.getSerialNo("HOUSE_INFO","SerialNo","",Sqlca);
	    sSql = "insert into HOUSE_INFO " +
	    		"(SerialNO,HouseUseType,ShareName1,ShareCertID1,ShareConsortName1,ShareConsortCertID1," +
	    		"ShareConsortSH1,ShareName2,ShareCertID2,ShareConsortName2," +
	    		"ShareConsortCertID2,ShareConsortSH2,HouseContractNo,HouseSeller," +
	    		"SellOpenBank,SellAccountNo,ItemName,HouseAdd1," +
	    		"HouseAdd2,HouseAdd3,HouseAdd4,HouseAdd5,BuildArea," +
	    		"HousePrice,SelfPrice,SelfAccounts,RightRate,EvaluateValue,BudgetValue)"+
	    		"values("+
	    		"'"+sHISerialNo1+"',"+
	    		"'"+sBuyHouseUseType+"',"+
	    		"'"+sShareName1+"',"+
	    		"'"+sShareCertID1+"',"+
	    		"'"+sShareConsortName1+"',"+
	    		"'"+sShareConsortCertID1+"',"+
	    		"'"+sShareConsortSH1+"',"+
	    		"'"+sShareName2+"',"+
	    		"'"+sShareCertID2+"',"+
	    		"'"+sShareConsortName2+"',"+
	    		"'"+sShareConsortCertID2+"',"+
	    		"'"+sShareConsortSH2+"',"+
	    		"'"+sBuyContractNo+"',"+
	    		"'"+sHouseSeller+"',"+
	    		"'"+sSellOpenBank+"',"+
	    		"'"+sSellAccountNo+"',"+
	    		"'"+sBuyItemName+"',"+
	    		"'"+sBuyHouseAdd1+"',"+
	    		"'"+sBuyHouseAdd2+"',"+
	    		"'"+sBuyHouseAdd3+"',"+
	    		"'"+sBuyHouseAdd4+"',"+
	    		"'"+sBuyHouseAdd5+"',"+
	    		""+dBuildArea+","+
	    		""+dHousePrice+","+
	    		""+dSelfPrice+","+
	    		"'"+sSelfAccounts+"',"+
	    		""+dRightRate+","+
	    		""+dEvaluateValue+","+
	    		""+dBudgetValue+" "+
	    		")";
	    Sqlca.executeSQL(sSql);
	    
	    //插入申请关联信息
	    sSql = "insert into apply_relative " +
			"(SerialNO,ObjectType,ObjectNo)values('"+sObjectNo+"','HouseInfo','"+sHISerialNo1+"')";
	    Sqlca.executeSQL(sSql);
	    //插入担保合同信息       1.质押，2.抵押，3.保证
	    String sFlag2 = "", sSql4 = "";
	    String wSerialNo = Sqlca.getString("select serialno from business_apply where serialno <> '"+sObjectNo+"' and CommercialNo = '"+sCommercialNo+"' and AccumulationNo='"+sAccumulationNo+"' ");
	    
	    sSql1 = " select SEQUENCENUMBER,OWNERNAME,CERTTYPE,CERTID,GUARANTYTYPE,GUARANTYNAME,EVALCURRENCY,GUARANTYRIGHTID," +
	    		" LOSTDATE,ABOUTSUM1,ABOUTSUM2,GUARANTYRATE,GUARANTYLOCATION,INPUTUSERID,INPUTDATE,GARANTYTYPE,EVALDATE," +
	    		" EVALORGNAME,POLICYHOLDFLAG,BENEFITPERSON1,INSURANCEID,INSURANCEBEGINDATE,INSURANCEENDDATE,CONFIRMVALUE," +
	    		" OTHERGUARANTYRIGHT,QUALITYSTATUS,GUARANTYAMOUNT,GUARANTYUSING,INPUTDEPARTMENT,ASSUREAGREEMENTFLAG," +
	    		" ASSURERTYPE,GUARANTYVALUE,BEGINDATE,ENDDATE,INPUTORGID,EMERGEDATE,CUSTOMERNAME,GUARANTYCONTRACTNO," +
	    		" MFCUSTOMERID,GUARANTYINFOFLAG,"+
	    		" GuarantyRightID1,ShareCustomerName,ShareCertID,ShareConsortName," +
	    		" ShareConsortCertID,ShareAddress,SharePostalCode,SharePhone "+
	    		" from gd_guarantyinfo " +
	    		" where CommercialNo = '"+sCommercialNo+"' and AccumulationNo='"+sAccumulationNo+"' ";
	    rs = Sqlca.getASResultSet(sSql1);
	    while(rs.next())
	    {
	    	String sGuarantyType = rs.getString("GUARANTYTYPE");
	    	if("1".equals(sGuarantyType))
	    	{
	    		sFlag2 = "1";
	    	}else if("2".equals(sGuarantyType))
	    	{
	    		sFlag2 = "2";
	    	}
	    	String sGuarantyInfoFlag = rs.getString("GUARANTYINFOFLAG");
	    	//获取担保人对应信贷客户编号
	    	if("3".equals(sGuarantyInfoFlag))//保证
	    	{
	    		sGuarantyCertType=rs.getString("CERTTYPE");
	    		if("0".equals(sGuarantyCertType))
	    		{
	    			sGuarantyCertType="Ent01";
	    		}else if("2".equals(sGuarantyCertType))
	    		{
	    			sGuarantyCertType="Ind01";
	    		}
	    	}else
	    	{
	    		sGuarantyCertType=getCertType(rs.getString("CERTTYPE"));
	    	}
	    	sGuarantorID = Sqlca.getString("select CustomerID from CUSTOMER_INFO" +
	    	 		" where CertID='"+rs.getString("CERTID")+"' and CertType='"+sGuarantyCertType+"' ");
	 	    if(sGuarantorID == null) sGuarantorID = "";
	 	    sGuarantLoanCardNo = Sqlca.getString("select LoanCardNo from CUSTOMER_INFO" +
	    	 		" where CertID='"+rs.getString("CERTID")+"' and CertType='"+sGuarantyCertType+"' ");
	 	    if(sGuarantLoanCardNo == null) sGuarantLoanCardNo = "";
	 	    
	    	if("1".equals(sGuarantyInfoFlag))    //质押
	    	{
	    		String sSerialNo1 = DBFunction.getSerialNo("GUARANTY_CONTRACT","SerialNo","GC",Sqlca);
	    		String sSql2 = "insert into GUARANTY_CONTRACT " +
		    				" (LoanCardNo,InputUserID,UpdateDate,CustomerID,CertType,InputOrgID," +
		    				" GuarantyType,GuarantorName,SerialNo,InputDate,GuarantorID,GuarantyValue," +
		    				" ContractType,CertID,ContractStatus,GuarantyCurrency,SignDate,BeginDate,EndDate) " +
		    				" values ('"+sGuarantLoanCardNo+"','"+sApplyInputUserID+"','','"+sApplyCustomerID+"'," +  //客户编号
		    				"'"+sGuarantyCertType+"','','060','"+rs.getString("OWNERNAME")+"'," +
		    				"'"+sSerialNo1+"','"+StringFunction.replace(rs.getString("INPUTDATE"), "-", "/")+"','"+sGuarantorID+"'," +  //出质人编号
		    				""+rs.getDouble("ABOUTSUM1")+",'010','"+rs.getString("CERTID")+"','010','"+rs.getString("EVALCURRENCY")+"'," +
		    				"''," +
		    				"''," +
		    				"'')";
	    		Sqlca.executeSQL(sSql2);
	    		String sSql3 = "Insert into Apply_relative (Serialno,ObjectType,ObjectNo) values('"+sObjectNo+"','GuarantyContract','"+sSerialNo1+"')";
	    		Sqlca.executeSQL(sSql3);
	    		String sSql8 = "Insert into Apply_relative (Serialno,ObjectType,ObjectNo) values('"+wSerialNo+"','GuarantyContract','"+sSerialNo1+"')";
	    		Sqlca.executeSQL(sSql8);
	    		String sSerialNo2 = DBFunction.getSerialNo("GUARANTY_INFO","GuarantyID","GI",Sqlca);
	    		if("1".equals(sGuarantyType) || "2".equals(sGuarantyType))
	    		{
	    			sSql4 = "insert into GUARANTY_INFO (InputOrgID,OwnerType,GuarantyLocation,GuarantyCurrency," +
		    				"GuarantyID,OwnerID,AboutSum1,InputDate,OwnerTime,GuarantyRate,LoanCardNo,GuarantyStatus," +
		    				"EvalNetValue,CertID,ThirdParty1,BeginDate,ConfirmValue,GuarantyType,InputUserID,OwnerName," +
		    				"Flag2,UpdateDate,EvalCurrency,GuarantyOwnWay,CertType,GuarantyRightID,GuarantyDescribe3)" +
		    				" values ('','','"+("2".equals(sFlag2)?rs.getString("GUARANTYLOCATION"):"")+"','01','"+sSerialNo2+"','',"+rs.getDouble("ABOUTSUM1")+"," +
		    				"'"+StringFunction.replace(rs.getString("INPUTDATE"), "-", "/")+"','',"+rs.getDouble("GUARANTYRATE")+"," +
		    				"'','01',"+rs.getDouble("ABOUTSUM1")+",'"+rs.getString("CERTID")+"','','"+"'," +
		    				""+rs.getDouble("ABOUTSUM1")*rs.getDouble("GUARANTYRATE")/100+",'020010'," +
		    				"'"+sApplyInputUserID+"','"+rs.getString("OWNERNAME")+"'," +
		    				"'"+sFlag2+"','','01','','"+sGuarantyCertType+"','"+rs.getString("GUARANTYRIGHTID")+"','"+("1".equals(sFlag2)?rs.getString("GuarantyLocation"):"")+"')";
	    		}else if("0".equals(sGuarantyType))
	    		{
	    			sSql4 = "insert into GUARANTY_INFO (InputDate,OwnerType,GuarantyDate,GuarantyCurrency," +
		    				"GuarantyID,OwnerID,GuarantyRate,LoanCardNo,AboutSum1,GuarantyStatus," +
		    				"EvalNetValue,InputUserID,CertID,GuarantyRightID,UpdateDate,BeginDate,ConfirmValue," +
		    				"GuarantyType,InputOrgID,OwnerName,ThirdParty2,EvalCurrency,Remark,CertType,GuarantyName) values (" +
		    				"'"+StringFunction.replace(rs.getString("INPUTDATE"), "-", "/")+"','',''," +
		    				"'01','"+sSerialNo2+"','',"+rs.getDouble("GUARANTYRATE")+",'',"+rs.getDouble("ABOUTSUM1")+"," +
		    				"'01',"+rs.getDouble("ABOUTSUM1")+",'"+sApplyInputUserID+"'," +
		    				"'"+rs.getString("CERTID")+"','"+rs.getString("GUARANTYRIGHTID")+"','',''," +
		    				""+rs.getDouble("ABOUTSUM1")*rs.getDouble("GUARANTYRATE")/100+",'020040',''," +
		    				"'"+rs.getString("OWNERNAME")+"','"+rs.getString("EVALCURRENCY")+"','"+rs.getString("EVALCURRENCY")+"'," +
		    				"'','"+sGuarantyCertType+"','"+rs.getString("GUARANTYNAME")+"')";
	    		}else if("3".equals(sGuarantyType))
	    		{
	    			sSql4 = "into GUARANTY_INFO (InputDate,OwnerType,BeginDate,GuarantyRate,GuarantyID,OwnerID,ThirdParty2," +
		    				"ConfirmValue,LoanCardNo,GuarantyDate,GuarantyStatus,EvalNetValue,InputUserID,CertID,GuarantyName," +
		    				"UpdateDate,GuarantyCurrency,GuarantyType,InputOrgID,OwnerName,AboutSum1,EvalCurrency,Remark," +
		    				"CertType,GuarantyRightID) values (" +
		    				"'"+StringFunction.replace(rs.getString("INPUTDATE"), "-", "/")+"','',''," +
		    				""+rs.getDouble("GUARANTYRATE")+",'"+sSerialNo2+"','','"+rs.getString("EVALCURRENCY")+"'," +
		    				""+rs.getDouble("ABOUTSUM1")*rs.getDouble("GUARANTYRATE")/100+",'','2010/12/20','01',"+rs.getDouble("ABOUTSUM1")+"," +
		    				"'"+sApplyInputUserID+"','"+rs.getString("CERTID")+"','"+rs.getString("+GUARANTYNAME+")+"'," +
		    				"'','"+rs.getString("EVALCURRENCY")+"','020210','','"+rs.getString("OWNERNAME")+"'," +
		    				""+rs.getDouble("ABOUTSUM1")+",'"+rs.getString("EVALCURRENCY")+"','','"+sGuarantyCertType+"','"+rs.getString("GUARANTYRIGHTID")+"')";
	    		}
	    		Sqlca.executeSQL(sSql4);
	    		Sqlca.executeSQL("insert into GUARANTY_RELATIVE(objecttype,objectno,contractno,guarantyid,channel,status,type) values('CreditApply','"+sObjectNo+"','"+sSerialNo1+"','"+sSerialNo2+"','New','1','Add')");
	    	}else if("2".equals(sGuarantyInfoFlag))  //抵押
	    	{
	    		String sSerialNo1 = DBFunction.getSerialNo("GUARANTY_CONTRACT","SerialNo","GC",Sqlca);
	    		String sSql2 = "insert into GUARANTY_CONTRACT (LoanCardNo,InputUserID,UpdateDate,CustomerID," +
	    				" CertType,InputOrgID,GuarantyType,GuarantorName,SerialNo,InputDate,GuarantorID," +
	    				" GuarantyValue,ContractType,CertID,ContractStatus,GuarantyCurrency,SignDate,BeginDate,EndDate) values " +
	    				" ('"+sGuarantLoanCardNo+"','"+sApplyInputUserID+"'," +
	    				"'','"+sApplyCustomerID+"'," +
	    				"'"+sGuarantyCertType+"'," +
	    				"'','050','"+rs.getString("OWNERNAME")+"'," +
	    				"'"+sSerialNo1+"'," +
	    				"'"+StringFunction.replace(rs.getString("INPUTDATE"), "-", "/")+"'," +
	    				"'"+sGuarantorID+"',"+rs.getDouble("ABOUTSUM1")+",'020','"+rs.getString("CERTID")+"','010','"+rs.getString("EVALCURRENCY")+"'," +
	    				"'"+StringFunction.replace(rs.getString("BEGINDATE"), "-", "/")+"'," +
	    				"'"+StringFunction.replace(rs.getString("BEGINDATE"), "-", "/")+"'," +
	    				"'"+StringFunction.replace(rs.getString("ENDDATE"), "-", "/")+"')";
	    		Sqlca.executeSQL(sSql2);
	    		String sSql3 = "Insert into Apply_relative (Serialno,ObjectType,ObjectNo) values('"+sObjectNo+"','GuarantyContract','"+sSerialNo1+"')";
	    		Sqlca.executeSQL(sSql3);
	    		String sSql8 = "Insert into Apply_relative (Serialno,ObjectType,ObjectNo) values('"+wSerialNo+"','GuarantyContract','"+sSerialNo1+"')";
	    		Sqlca.executeSQL(sSql8);
	    		String sSerialNo2 = DBFunction.getSerialNo("GUARANTY_INFO","GuarantyID","GI",Sqlca);
	    		String sSql7 = "insert into GUARANTY_INFO (GuarantyID,GuarantyLocation,GuarantyCurrency,LoanCardNo,HouseOwnerType," +
	    				"HoldType,InputOrgID,EvalOrgName,CertType,GuarantyDescribe1,GuarantyRate,GuarantyStatus,GuarantySubType," +
	    				"EvalNetValue,OwnerName,GuarantyAmount2,EvalMethod,AboutOtherID1,AboutSum2,OwnerTime,UpdateDate," +
	    				"GuarantyRightID,EvalCurrency,OwnerID,GuarantyDescribe3,InputUserID,GuarantyDescript," +
	    				"GuarantyType,GuarantyAmount,ConfirmValue,ThirdParty1,OwnerType,InputDate,EvalDate,CertID,GuarantyDescribe2," +
	    				"AboutOtherID2," +
	    				//"GuarantyRightID1," +
	    				"ShareCustomerName,ShareCertID,ShareConsortName,ShareConsortCertID," +
	    				"ShareAddress,SharePostalCode,SharePhone ) values " +
	    				"('"+sSerialNo2+"','"+rs.getString("GUARANTYLOCATION")+"'," +
	    				"'01','',''," +
	    				"'','','"+rs.getString("EVALORGNAME")+"','"+sGuarantyCertType+"'," +
	    				"''," +
	    				""+rs.getDouble("GUARANTYRATE")+",'01'," +
	    				"'',100000,'"+rs.getString("OWNERNAME")+"',"
	    				+Double.parseDouble(rs.getString("GUARANTYAMOUNT").equals("")?"0":rs.getString("GUARANTYAMOUNT"))/10000.00
	    				+",'01'," +
	    				"'',"+rs.getDouble("CONFIRMVALUE")*rs.getDouble("GUARANTYRATE")/100+"," +
	    				"'','','"+rs.getString("GUARANTYRIGHTID")+"','01'," +
	    				"'',''," +
	    				"'"+sApplyInputUserID+"',''," +
	    				"'010010',"
	    				+Double.parseDouble(rs.getString("GUARANTYAMOUNT").equals("")?"0":rs.getString("GUARANTYAMOUNT"))/10000.00
	    				+","
	    				+Double.parseDouble(rs.getString("CONFIRMVALUE").equals("")?"0":rs.getString("CONFIRMVALUE"))/10000.00
	    				+",'','','"+StringFunction.replace(rs.getString("INPUTDATE"), "-", "/")+"'," +
	    				"'"+StringFunction.replace(rs.getString("EVALDATE"), "-", "/")+"','"+rs.getString("CERTID")+"','',''," +
	    				//"'"+rs.getString("GuarantyRightID1")+"',"+
	    				"'"+rs.getString("ShareCustomerName")+"',"+
	    				"'"+rs.getString("ShareCertID")+"',"+
	    				"'"+rs.getString("ShareConsortName")+"',"+
	    				"'"+rs.getString("ShareConsortCertID")+"',"+
	    				"'"+rs.getString("ShareAddress")+"',"+
	    				"'"+rs.getString("SharePostalCode")+"',"+
	    				"'"+rs.getString("SharePhone")+"' "+
	    				")";
	    		System.out.println(sSql7);
	    		Sqlca.executeSQL(sSql7);
	    		Sqlca.executeSQL("insert into GUARANTY_RELATIVE(objecttype,objectno,contractno,guarantyid,channel,status,type) values('CreditApply','"+sObjectNo+"','"+sSerialNo1+"','"+sSerialNo2+"','New','1','Add')");
	    	}else if("3".equals(sGuarantyInfoFlag))  //保证
	    	{
	    		String sSerialNo1 = DBFunction.getSerialNo("GUARANTY_CONTRACT","SerialNo","GC",Sqlca);
	    		String sSql2 = "insert into GUARANTY_CONTRACT (InputOrgID,CertType,EndDate,CustomerID,ContractStatus,LoanCardNo," +
	    				"InputDate,GuarantyValue,GuarantyType,GuarantorID,BeginDate,SerialNo,OtherDescribe,GuaranteeForm," +
	    				"GuarantorName,GuarantyCurrency,ContractType,InputUserID,SignDate,UpdateDate,VouchMethod,CertID) values " +
	    				"('"+rs.getString("INPUTORGID")+"'," +
	    				"'"+sGuarantyCertType+"'," +
	    				"'"+StringFunction.replace(rs.getString("ENDDATE"), "-", "/")+"'," +
	    				"'"+sApplyCustomerID+"','010','"+sGuarantLoanCardNo+"','"+StringFunction.replace(rs.getString("INPUTDATE"), "-", "/")+"'," +
	    				""+rs.getDouble("GUARANTYVALUE")+",'010010'," +
	    				"'"+sGuarantorID+"','"+StringFunction.replace(rs.getString("BEGINDATE"), "-", "/")+"'," +
	    				"'"+sSerialNo1+"','','1'," +
	    				"'"+rs.getString("CustomerName")+"'," +
	    				"'01','010'," +
	    				"'"+sApplyInputUserID+"','"+StringFunction.replace(rs.getString("BEGINDATE"), "-", "/")+"','','','"+rs.getString("CERTID")+"')";
	    		Sqlca.executeSQL(sSql2);
	    		String sSql3 = "Insert into Apply_relative (Serialno,ObjectType,ObjectNo) values('"+sObjectNo+"','GuarantyContract','"+sSerialNo1+"')";
	    		Sqlca.executeSQL(sSql3);
	    		String sSql8 = "Insert into Apply_relative (Serialno,ObjectType,ObjectNo) values('"+wSerialNo+"','GuarantyContract','"+sSerialNo1+"')";
	    		Sqlca.executeSQL(sSql8);
	    	}
	    		
	    }
	    rs.close();
	    return sMessage;
	 }

 	public String getCertType(String CertType)
 	{
 		String sTemp = "";
 		if("".equals(CertType) || CertType == null)
 		{
 			sTemp = "";
 		}else if("0".equals(CertType))
 		{
 			sTemp = "Ind01";
 		}else if("1".equals(CertType))
 		{
 			sTemp = "Ind04";
 		}else if("2".equals(CertType))
 		{
 			sTemp = "Ind10";
 		}else if("3".equals(CertType))
 		{
 			sTemp = "Ind03";
 		}else if("5".equals(CertType))
 		{
 			sTemp = "Ind05";
 		}else if("6".equals(CertType))
 		{
 			sTemp = "Ind02";
 		}else if("7".equals(CertType))
 		{
 			sTemp = "Ind06";
 		}else if("8".equals(CertType))
 		{
 			sTemp = "Ind11";
 		}
 		return sTemp;
 	}
}
