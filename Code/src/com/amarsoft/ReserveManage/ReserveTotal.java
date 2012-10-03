package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import java.util.Vector;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;

public class ReserveTotal {
	
	private Transaction Sqlca = null;
	private boolean debug = true; 
	
	public ReserveTotal(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;			
	}
	
	/**
	 * 根据会计月份获取相应的贷款数据库中本期贷款帐号
	 * @param sAccountMonth 会计月份
	 * @return Vector 贷款帐号集合
	 */
	public Vector selectReserveTotal(String sAccountMonth) throws Exception
	{
		//定义变量			
		Vector vReserveTotal = new Vector();
		ASResultSet rs = null;
		String sSql = "";
		
		sSql = 	" select LoanAccount from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			vReserveTotal.add(rs.getString("LoanAccount")); //贷款帐号
		}
		rs.getStatement().close();
		
		return vReserveTotal;
	}
	
	/**
	 * 根据会计月份、贷款帐号获取相应的贷款数据信息
	 * @param sAccountMonth 会计月份,sLoanAccountNo 贷款帐号
	 * @return ArrayList 依次为：会计月份、贷款帐号、科目号、......
	 */
	public ArrayList selectReserveTotal(String sAccountMonth,String sLoanAccountNo) throws Exception
	{
		//定义变量			
		ArrayList alReserveTotal = new ArrayList();
		ASResultSet rs = null;
		String sSql = "";
		
		sSql = 	" select * from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' "+
				" and LoanAccount = '"+sLoanAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			alReserveTotal.add(0, rs.getString("AccountMonth")== null ? "" : rs.getString("AccountMonth")); //会计月份
			alReserveTotal.add(1, rs.getString("LoanAccount")== null ? "" : rs.getString("LoanAccount")); //贷款帐号
			alReserveTotal.add(2, rs.getString("SubjectNo")== null ? "" : rs.getString("SubjectNo")); //科目号
			alReserveTotal.add(3, rs.getString("ManageStatFlag")== null ? "" : rs.getString("ManageStatFlag")); //管理层口径贷款标志
			alReserveTotal.add(4, rs.getString("AuditStatFlag")== null ? "" : rs.getString("AuditStatFlag")); //审计口径贷款标志
			alReserveTotal.add(5, rs.getString("BatchTime")== null ? "" : rs.getString("BatchTime")); //非信贷资产转入标志
			alReserveTotal.add(6, rs.getString("DuebillNo")== null ? "" : rs.getString("DuebillNo")); //借据编号
			alReserveTotal.add(7, rs.getString("CustomerID")== null ? "" : rs.getString("CustomerID")); //客户编号
			alReserveTotal.add(8, rs.getString("CustomerName")== null ? "" : rs.getString("CustomerName")); //客户名称
			alReserveTotal.add(9, rs.getString("CustomerOrgCode")== null ? "" : rs.getString("CustomerOrgCode")); //客户组织机构代码
			alReserveTotal.add(10, rs.getString("Region")== null ? "" : rs.getString("Region")); //所在地区
			alReserveTotal.add(11, rs.getString("ListingFlag")== null ? "" : rs.getString("ListingFlag")); //是否上市企业
			alReserveTotal.add(12, rs.getString("IndustryType")== null ? "" : rs.getString("IndustryType")); //行业类别
			alReserveTotal.add(13, rs.getString("EconomyType")== null ? "" : rs.getString("EconomyType")); //经济类型
			alReserveTotal.add(14, rs.getString("Scope")== null ? "" : rs.getString("Scope")); //企业规模
			alReserveTotal.add(15, rs.getString("StatOrgid")== null ? "" : rs.getString("StatOrgid")); //放款机构
			alReserveTotal.add(16, rs.getString("Currency")== null ? "" : rs.getString("Currency")); //贷款币种
			alReserveTotal.add(17, rs.getString("BusinessSum")== null ? "" : rs.getString("BusinessSum")); //借据金额
			alReserveTotal.add(18, rs.getString("PutoutDate")== null ? "" : rs.getString("PutoutDate")); //放款日期
			alReserveTotal.add(19, rs.getString("Maturity")== null ? "" : rs.getString("Maturity")); //到期日期
			alReserveTotal.add(20, rs.getString("LoanType")== null ? "" : rs.getString("LoanType")); //贷款类别
			alReserveTotal.add(21, rs.getString("LoanNature")== null ? "" : rs.getString("LoanNature")); //贷款性质
			alReserveTotal.add(22, rs.getString("LoanTerm")== null ? "" : rs.getString("LoanTerm")); //贷款期限
			alReserveTotal.add(23, rs.getString("VouchType")== null ? "" : rs.getString("VouchType")); //主要担保方式
			alReserveTotal.add(24, rs.getString("Guarantor")== null ? "" : rs.getString("Guarantor")); //保证人/抵押人/出质人名称
			alReserveTotal.add(25, rs.getString("GuarantyEvalValue")== null ? "" : rs.getString("GuarantyEvalValue")); //抵质押物原评估值
			alReserveTotal.add(26, rs.getString("BusinessRate")== null ? "" : rs.getString("BusinessRate")); //贷款年利率
			alReserveTotal.add(27, rs.getString("PdgSum")== null ? "" : rs.getString("PdgSum")); //贷款发生费用
			alReserveTotal.add(28, rs.getString("AuditRate")== null ? "" : rs.getString("AuditRate")); //贷款实际利率
			alReserveTotal.add(29, rs.getString("OldPutoutDate")== null ? "" : rs.getString("OldPutoutDate")); //不良贷款最初放款日
			alReserveTotal.add(30, rs.getString("Balance")== null ? "" : rs.getString("Balance")); //目前余额（原币）
			alReserveTotal.add(31, rs.getString("ExchangeRate")== null ? "" : rs.getString("ExchangeRate")); //汇率
			alReserveTotal.add(32, rs.getString("RMBBalance")== null ? "" : rs.getString("RMBBalance")); //目前余额折合人民币
			alReserveTotal.add(33, rs.getString("FourClassify")== null ? "" : rs.getString("FourClassify")); //四级分类
			alReserveTotal.add(34, rs.getString("MFiveClassify")== null ? "" : rs.getString("MFiveClassify")); //管理层五级分类
			alReserveTotal.add(35, rs.getString("AFiveClassify")== null ? "" : rs.getString("AFiveClassify")); //审计五级分类
			alReserveTotal.add(36, rs.getString("GuarantyNowValue")== null ? "" : rs.getString("GuarantyNowValue")); //抵质押物现评估值
			alReserveTotal.add(37, rs.getString("Interest")== null ? "" : rs.getString("Interest")); //利息调整
			alReserveTotal.add(38, rs.getString("RetSum")== null ? "" : rs.getString("RetSum")); //本期收回金额
			alReserveTotal.add(39, rs.getString("OmitSum")== null ? "" : rs.getString("OmitSum")); //本期核销金额
			alReserveTotal.add(40, rs.getString("GuarantyDiscountValue")== null ? "" : rs.getString("GuarantyDiscountValue")); //抵押物公允价值
			alReserveTotal.add(41, rs.getString("GuarantyAccount")== null ? "" : rs.getString("GuarantyAccount")); //抵押物704帐号
			alReserveTotal.add(42, rs.getString("MCancelReserveSum")== null ? "" : rs.getString("MCancelReserveSum")); //管理层口径核销减值准备
			alReserveTotal.add(43, rs.getString("ACancelReserveSum")== null ? "" : rs.getString("ACancelReserveSum")); //审计口径核销减值准备
			alReserveTotal.add(44, rs.getString("MExforLoss")== null ? "" : rs.getString("MExforLoss")); //管理层口径汇兑损益
			alReserveTotal.add(45, rs.getString("AExforLoss")== null ? "" : rs.getString("AExforLoss")); //审计口径汇兑损益
			alReserveTotal.add(46, rs.getString("MBadLastPrdDiscount")== null ? "" : rs.getString("MBadLastPrdDiscount")); //管理层口径上期预测现金流本期贴现值
			alReserveTotal.add(47, rs.getString("MBadPrdDiscount")== null ? "" : rs.getString("MBadPrdDiscount")); //管理层口径不良贷款本期预测现金流贴现值
			alReserveTotal.add(48, rs.getString("MBadReserveSum")== null ? "" : rs.getString("MBadReserveSum")); //管理层口径不良贷款本期计提减值准备
			alReserveTotal.add(49, rs.getString("MBadMinusSum")== null ? "" : rs.getString("MBadMinusSum")); //管理层口径不良贷款本期冲销减值准备
			alReserveTotal.add(50, rs.getString("MBadRetSum")== null ? "" : rs.getString("MBadRetSum")); //管理层口径不良贷款本期转回减值准备
			alReserveTotal.add(51, rs.getString("MBadReserveBalance")== null ? "" : rs.getString("MBadReserveBalance")); //管理层口径不良贷款本期减值准备余额
			alReserveTotal.add(52, rs.getString("ABadLastprdDiscount")== null ? "" : rs.getString("ABadLastprdDiscount")); //审计口径不良贷款上期预测现金流本期贴现值
			alReserveTotal.add(53, rs.getString("ABadPrdDiscount")== null ? "" : rs.getString("ABadPrdDiscount")); //审计口径不良贷款本期预测现金流贴现值
			alReserveTotal.add(54, rs.getString("ABadReserveSum")== null ? "" : rs.getString("ABadReserveSum")); //审计口径不良贷款本期计提减值准备
			alReserveTotal.add(55, rs.getString("ABadMinusSum")== null ? "" : rs.getString("ABadMinusSum")); //审计口径不良贷款本期冲销减值准备
			alReserveTotal.add(56, rs.getString("ABadRetSum")== null ? "" : rs.getString("ABadRetSum")); //审计口径不良贷款本期转回减值准备
			alReserveTotal.add(57, rs.getString("ABadReserveBalance")== null ? "" : rs.getString("ABadReserveBalance")); //审计口径不良贷款本期减值准备余额
			alReserveTotal.add(58, rs.getString("MNormalReserveSum")== null ? "" : rs.getString("MNormalReserveSum")); //管理层口径正常贷款本期计提减值准备
			alReserveTotal.add(59, rs.getString("MNormalMinusSum")== null ? "" : rs.getString("MNormalMinusSum")); //管理层口径正常贷款本期冲销减值准备
			alReserveTotal.add(60, rs.getString("MNormalReserveBalance")== null ? "" : rs.getString("MNormalReserveBalance")); //管理层口径正常贷款本期减值准备余额
			alReserveTotal.add(61, rs.getString("ANormalReserveSum")== null ? "" : rs.getString("ANormalReserveSum")); //审计口径正常贷款本期计提减值准备
			alReserveTotal.add(62, rs.getString("ANormalMinusSum")== null ? "" : rs.getString("ANormalMinusSum")); //审计口径正常贷款本期冲销减值准备
			alReserveTotal.add(63, rs.getString("ANormalReserveBalance")== null ? "" : rs.getString("ANormalReserveBalance")); //审计口径正常贷款本期减值准备余额
			alReserveTotal.add(64, rs.getString("BatchTime")== null ? "" : rs.getString("BatchTime")); //
			alReserveTotal.add(65, rs.getString("Manageuserid")== null ? "" : rs.getString("Manageuserid")); //借据管户员
			alReserveTotal.add(66, rs.getString("MonthRetSum")== null ? "" : rs.getString("MonthRetSum")); //本月收回金额
			alReserveTotal.add(67, rs.getString("MonthOmitSum")== null ? "" : rs.getString("MonthOmitSum")); //本月核销金额
			alReserveTotal.add(68, rs.getString("LastMFiveClassify")== null ? "" : rs.getString("LastMFiveClassify")); //上期管理层五级分类
			alReserveTotal.add(69, rs.getString("LastAFiveClassify")== null ? "" : rs.getString("LastAFiveClassify")); //上期审计五级分类
            alReserveTotal.add(70, rs.getString("ManageStatFlag")== null ? "" : rs.getString("ManageStatFlag")); //记提方式 1-组合方式  2-单笔计提
            alReserveTotal.add(71, rs.getString("BusinessFlag")== null ? "" : rs.getString("BusinessFlag")); //业务标识 1-对公贷款   2-个人贷款
            alReserveTotal.add(72, rs.getString("OverDueDays")== null ? "" : rs.getString("OverDueDays")); //逾期天数
		}
		rs.getStatement().close();
		
		return alReserveTotal;
	}
		
	/**
	 * 将符合要求的贷款数据插入到贷款信息库中
	 * @param ArrayList 依次为：会计月份、贷款帐号、科目号、......
	 * @return 
	 */
	public void insertReserveTotal(ArrayList alReserveTotal) throws Exception
	{
		//定义变量
		String sSql = "";
		
		sSql = 	" insert into RESERVE_TOTAL( "+
				" AccountMonth, "+ //会计月份
				" LoanAccount, "+ //贷款帐号
				" SubjectNo, "+ //科目号
				" ManageStatFlag, "+ //管理层口径贷款标志
				" AuditStatFlag, "+ //审计口径贷款标志
				" NonCreditTransferFlag, "+ //非信贷资产转入标志
				" DuebillNo, "+ //借据编号
				" CustomerID, "+ //客户编号
				" CustomerName, "+ //客户名称
				" CustomerOrgCode, "+ //客户组织机构代码
				" Region, "+ //所在地区
				" ListingFlag, "+ //是否上市企业
				" IndustryType, "+ //行业类别
				" EconomyType, "+ //经济类型
				" Scope, "+ //企业规模
				" StatOrgid, "+ //放款机构
				" Currency, "+ //贷款币种
				" BusinessSum, "+ //借据金额
				" PutoutDate, "+ //放款日期
				" Maturity, "+ //到期日期
				" LoanType, "+ //贷款类别
				" LoanNature, "+ //贷款性质
				" LoanTerm, "+ //贷款期限
				" VouchType, "+ //主要担保方式
				" Guarantor, "+ //保证人/抵押人/出质人名称
				" GuarantyEvalValue, "+ //抵质押物原评估值
				" BusinessRate, "+ //贷款年利率
				" PdgSum, "+ //贷款发生费用
				" AuditRate, "+ //贷款实际利率
				" OldPutoutDate, "+ //不良贷款最初放款日
				" Balance, "+ //目前余额（原币）
				" ExchangeRate, "+ //汇率
				" RMBBalance, "+ //目前余额折合人民币
				" FourClassify, "+ //四级分类
				" MFiveClassify, "+ //管理层五级分类
				" AFiveClassify, "+ //审计五级分类
				" GuarantyNowValue, "+ //抵质押物现评估值
				" Interest, "+ //利息调整
				" RetSum, "+ //本期收回金额
				" OmitSum, "+ //本期核销金额
				" GuarantyDiscountValue, "+ //抵押物公允价值
				" GuarantyAccount, "+ //抵押物704帐号
				" MCancelReserveSum, "+ //管理层口径核销减值准备
				" ACancelReserveSum, "+ //审计口径核销减值准备
				" MExforLoss, "+ //管理层口径汇兑损益
				" AExforLoss, "+ //审计口径汇兑损益
				" MBadLastPrdDiscount, "+ //管理层口径上期预测现金流本期贴现值
				" MBadPrdDiscount, "+ //管理层口径不良贷款本期预测现金流贴现值
				" MBadReserveSum, "+ //管理层口径不良贷款本期计提减值准备
				" MBadMinusSum, "+ //管理层口径不良贷款本期冲销减值准备
				" MBadRetSum, "+ //管理层口径不良贷款本期转回减值准备
				" MBadReserveBalance, "+ //管理层口径不良贷款本期减值准备余额
				" ABadLastprdDiscount, "+ //审计口径不良贷款上期预测现金流本期贴现值
				" ABadPrdDiscount, "+ //审计口径不良贷款本期预测现金流贴现值
				" ABadReserveSum, "+ //审计口径不良贷款本期计提减值准备
				" ABadMinusSum, "+ //审计口径不良贷款本期冲销减值准备
				" ABadRetSum, "+ //审计口径不良贷款本期转回减值准备
				" ABadReserveBalance, "+ //审计口径不良贷款本期减值准备余额
				" MNormalReserveSum, "+ //管理层口径正常贷款本期计提减值准备
				" MNormalMinusSum, "+ //管理层口径正常贷款本期冲销减值准备
				" MNormalReserveBalance, "+ //管理层口径正常贷款本期减值准备余额
				" ANormalReserveSum, "+ //审计口径正常贷款本期计提减值准备
				" ANormalMinusSum, "+ //审计口径正常贷款本期冲销减值准备
				" ANormalReserveBalance, "+ //审计口径正常贷款本期减值准备余额
				" ReinforceFlag, " + //补登标志
				" Manageuserid, " + //借据管户人
				" MonthRetSum, " + //本月收回金额
				" MonthOmitSum, " + //本月核销金额
				" LastMFiveClassify, " + //上期管理层五级分类
				" LastAFiveClassify " + //上期审计五级分类
				" ) "+ 
				" values(" + 
				" '"+(String)alReserveTotal.get(0)+"', "+ //会计月份
				" '"+(String)alReserveTotal.get(1)+"', "+ //贷款帐号
				" '"+(String)alReserveTotal.get(2)+"', "+ //科目号
				" '"+(String)alReserveTotal.get(3)+"', "+ //管理层口径贷款标志
				" '"+(String)alReserveTotal.get(4)+"', "+ //审计口径贷款标志
				" '"+(String)alReserveTotal.get(5)+"', "+ //非信贷资产转入标志
				" '"+(String)alReserveTotal.get(6)+"', "+ //借据编号
				" '"+(String)alReserveTotal.get(7)+"', "+ //客户编号
				" '"+(String)alReserveTotal.get(8)+"', "+ //客户名称
				" '"+(String)alReserveTotal.get(9)+"', "+ //客户组织机构代码
				" '"+(String)alReserveTotal.get(10)+"', "+ //所在地区
				" '"+(String)alReserveTotal.get(11)+"', "+ //是否上市企业
				" '"+(String)alReserveTotal.get(12)+"', "+ //行业类别
				" '"+(String)alReserveTotal.get(13)+"', "+ //经济类型
				" '"+(String)alReserveTotal.get(14)+"', "+ //企业规模
				" '"+(String)alReserveTotal.get(15)+"', "+ //放款机构
				" '"+(String)alReserveTotal.get(16)+"', "+ //贷款币种
				" "+DataConvert.toDouble((String)alReserveTotal.get(17))+", "+ //借据金额
				" '"+(String)alReserveTotal.get(18)+"', "+ //放款日期
				" '"+(String)alReserveTotal.get(19)+"', "+ //到期日期
				" '"+(String)alReserveTotal.get(20)+"', "+ //贷款类别
				" '"+(String)alReserveTotal.get(21)+"', "+ //贷款性质
				" '"+(String)alReserveTotal.get(22)+"', "+ //贷款期限
				" '"+(String)alReserveTotal.get(23)+"', "+ //主要担保方式
				" '"+(String)alReserveTotal.get(24)+"', "+ //保证人/抵押人/出质人名称
				" "+DataConvert.toDouble((String)alReserveTotal.get(25))+", "+ //抵质押物原评估值
				" "+DataConvert.toDouble((String)alReserveTotal.get(26))+", "+ //贷款年利率 
				" "+DataConvert.toDouble((String)alReserveTotal.get(27))+", "+ //贷款发生费用
				" "+Double.parseDouble((String)alReserveTotal.get(28))+", "+ //贷款实际利率
				" '"+(String)alReserveTotal.get(29)+"', "+ //不良贷款最初放款日
				" "+Double.parseDouble((String)alReserveTotal.get(30))+", "+ //目前余额（原币）
				" "+Double.parseDouble((String)alReserveTotal.get(31))+", "+ //汇率
				" "+Double.parseDouble((String)alReserveTotal.get(32))+", "+ //目前余额折合人民币
				" '"+(String)alReserveTotal.get(33)+"', "+ //四级分类
				" '"+(String)alReserveTotal.get(34)+"', "+ //管理层五级分类
				" '"+(String)alReserveTotal.get(35)+"', "+ //审计五级分类
				" "+Double.parseDouble((String)alReserveTotal.get(36))+", "+ //抵质押物现评估值
				" "+Double.parseDouble((String)alReserveTotal.get(37))+", "+ //利息调整
				" "+Double.parseDouble((String)alReserveTotal.get(38))+", "+ //本期收回金额
				" "+Double.parseDouble((String)alReserveTotal.get(39))+", "+ //本期核销金额
				" "+Double.parseDouble((String)alReserveTotal.get(40))+", "+ //抵押物公允价值
				" '"+(String)alReserveTotal.get(41)+"', "+ //抵押物704帐号
				" "+Double.parseDouble((String)alReserveTotal.get(42))+", "+ //管理层口径核销减值准备
				" "+Double.parseDouble((String)alReserveTotal.get(43))+", "+ //审计口径核销减值准备
				" "+Double.parseDouble((String)alReserveTotal.get(44))+", "+ //管理层口径汇兑损益
				" "+Double.parseDouble((String)alReserveTotal.get(45))+", "+ //审计口径汇兑损益
				" "+Double.parseDouble((String)alReserveTotal.get(46))+", "+ //管理层口径上期预测现金流本期贴现值
				" "+Double.parseDouble((String)alReserveTotal.get(47))+", "+ //管理层口径不良贷款本期预测现金流贴现值
				" "+Double.parseDouble((String)alReserveTotal.get(48))+", "+ //管理层口径不良贷款本期计提减值准备
				" "+Double.parseDouble((String)alReserveTotal.get(49))+", "+ //管理层口径不良贷款本期冲销减值准备
				" "+Double.parseDouble((String)alReserveTotal.get(50))+", "+ //管理层口径不良贷款本期转回减值准备
				" "+Double.parseDouble((String)alReserveTotal.get(51))+", "+ //管理层口径不良贷款本期减值准备余额
				" "+Double.parseDouble((String)alReserveTotal.get(52))+", "+ //审计口径不良贷款上期预测现金流本期贴现值
				" "+Double.parseDouble((String)alReserveTotal.get(53))+", "+ //审计口径不良贷款本期预测现金流贴现值
				" "+Double.parseDouble((String)alReserveTotal.get(54))+", "+ //审计口径不良贷款本期计提减值准备
				" "+Double.parseDouble((String)alReserveTotal.get(55))+", "+ //审计口径不良贷款本期冲销减值准备
				" "+Double.parseDouble((String)alReserveTotal.get(56))+", "+ //审计口径不良贷款本期转回减值准备
				" "+Double.parseDouble((String)alReserveTotal.get(57))+", "+ //审计口径不良贷款本期减值准备余额
				" "+Double.parseDouble((String)alReserveTotal.get(58))+", "+ //管理层口径正常贷款本期计提减值准备
				" "+Double.parseDouble((String)alReserveTotal.get(59))+", "+ //管理层口径正常贷款本期冲销减值准备
				" "+Double.parseDouble((String)alReserveTotal.get(60))+", "+ //管理层口径正常贷款本期减值准备余额
				" "+Double.parseDouble((String)alReserveTotal.get(61))+", "+ //审计口径正常贷款本期计提减值准备
				" "+Double.parseDouble((String)alReserveTotal.get(62))+", "+ //审计口径正常贷款本期冲销减值准备
				" "+Double.parseDouble((String)alReserveTotal.get(63))+", "+ //审计口径正常贷款本期减值准备余额
				" '"+(String)alReserveTotal.get(64)+"', "+ //补登标志	
				" '"+(String)alReserveTotal.get(65)+"', "+ //借据管户员	
				" "+Double.parseDouble((String)alReserveTotal.get(66))+", "+ //本月收回金额
				" "+Double.parseDouble((String)alReserveTotal.get(67))+", "+ //本月核销金额
				" '"+(String)alReserveTotal.get(68)+"', "+ //上期管理层五级分类
				" '"+(String)alReserveTotal.get(69)+"' "+ //上期审计五级分类
				")";
		if(debug)System.out.println(sSql);
		Sqlca.executeSQL(sSql);
	}
	
	/**
	 * 更新贷款信息库中相应会计月份和贷款帐号的记录
	 * @param sAccountMonth 会计月份,sLoanAccountNo 贷款帐号
	 * @return 
	 */
	public void updateReserveTotal(ArrayList alReserveTotal) throws Exception
	{
		//定义变量
		String sSql = "";
		String sAccountMonth = "";
		String sLoanAccountNo = "";
		
		sAccountMonth = (String)alReserveTotal.get(0);
		sLoanAccountNo = (String)alReserveTotal.get(1);
		sSql = 	" update RESERVE_TOTAL set MCancelReserveSum = "+DataConvert.toDouble((String)alReserveTotal.get(2))+ //管理层口径核销减值准备
				", ACancelReserveSum = "+DataConvert.toDouble((String)alReserveTotal.get(3))+//审计口径核销减值准备
				", MExforLoss = "+DataConvert.toDouble((String)alReserveTotal.get(4))+//管理层口径汇兑损益
				", AExforLoss = "+DataConvert.toDouble((String)alReserveTotal.get(5))+ //审计口径汇兑损益
				", MBadLastPrdDiscount = "+DataConvert.toDouble((String)alReserveTotal.get(6))+//管理层口径上期预测现金流本期贴现值
				", MBadPrdDiscount = "+DataConvert.toDouble((String)alReserveTotal.get(7))+//管理层口径不良贷款本期预测现金流贴现值
				", MBadReserveSum = "+DataConvert.toDouble((String)alReserveTotal.get(8))+//管理层口径不良贷款本期计提减值准备
				", MBadMinusSum = "+DataConvert.toDouble((String)alReserveTotal.get(9))+//管理层口径不良贷款本期冲销减值准备
				", MBadRetSum = "+DataConvert.toDouble((String)alReserveTotal.get(10))+//管理层口径不良贷款本期转回减值准备
				", MBadReserveBalance = "+DataConvert.toDouble((String)alReserveTotal.get(11))+//管理层口径不良贷款本期减值准备余额
				", ABadLastprdDiscount = "+DataConvert.toDouble((String)alReserveTotal.get(12))+//审计口径不良贷款上期预测现金流本期贴现值
				", ABadPrdDiscount = "+DataConvert.toDouble((String)alReserveTotal.get(13))+//审计口径不良贷款本期预测现金流贴现值
				", ABadReserveSum = "+DataConvert.toDouble((String)alReserveTotal.get(14))+//审计口径不良贷款本期计提减值准备
				", ABadMinusSum = "+DataConvert.toDouble((String)alReserveTotal.get(15))+//审计口径不良贷款本期冲销减值准备
				", ABadRetSum = "+DataConvert.toDouble((String)alReserveTotal.get(16))+//审计口径不良贷款本期转回减值准备
				", ABadReserveBalance = "+DataConvert.toDouble((String)alReserveTotal.get(17))+//审计口径不良贷款本期减值准备余额
				", MNormalReserveSum = "+DataConvert.toDouble((String)alReserveTotal.get(18))+//管理层口径正常贷款本期计提减值准备
				", MNormalMinusSum = "+DataConvert.toDouble((String)alReserveTotal.get(19))+//管理层口径正常贷款本期冲销减值准备
				", MNormalReserveBalance = "+DataConvert.toDouble((String)alReserveTotal.get(20))+//管理层口径正常贷款本期减值准备余额
				", ANormalReserveSum = "+DataConvert.toDouble((String)alReserveTotal.get(21))+//审计口径正常贷款本期计提减值准备
				", ANormalMinusSum = "+DataConvert.toDouble((String)alReserveTotal.get(22))+//审计口径正常贷款本期冲销减值准备
				", ANormalReserveBalance = "+DataConvert.toDouble((String)alReserveTotal.get(23))+//审计口径正常贷款本期减值准备余额
				", RetSum = "+DataConvert.toDouble((String)alReserveTotal.get(24))+//本期收回金额
				", OmitSum = "+DataConvert.toDouble((String)alReserveTotal.get(25))+//本期核销金额
				" where AccountMonth = '"+sAccountMonth+"' "+
				" and LoanAccount = '"+sLoanAccountNo+"' ";
		if(debug)System.out.println(sSql);
		Sqlca.executeSQL(sSql);
	}
	
	/**
	 * 从贷款信息库中批量删除相应会计月份和贷款帐号的记录
	 * @param sAccountMonth 会计月份,sLoanAccountNo 贷款帐号
	 * @return 
	 */
	public void deleteReserveTotal(String sAccountMonth,String sLoanAccountNo) throws Exception
	{
		//定义变量
		String sSql = "";
		
		sSql = 	" delete from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' "+
				" and LoanAccount = '"+sLoanAccountNo+"' ";
		Sqlca.executeSQL(sSql);
	}

	/**
	 * 从贷款信息库中批量删除相应会计月份的所有记录
	 * @param sAccountMonth 会计月份,sLoanAccountNo 贷款帐号
	 * @return 
	 */
	public void deleteReserveTotal(String sAccountMonth) throws Exception
	{
		//定义变量
		String sSql = "";
		sSql = 	" delete from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' ";
		Sqlca.executeSQL(sSql);
	}
	
	/**
	 * 从贷款信息库中查找相应会计月份和贷款帐号的记录是否存在
	 * @param sAccountMonth 会计月份,sLoanAccountNo 贷款帐号
	 * @return true 存在该会计月份和贷款帐号的记录；false 不存在该会计月份和贷款帐号的记录
	 */
	public boolean findExistReserveTotal(String sAccountMonth,String sLoanAccountNo) throws Exception
	{
		//定义变量
		String sSql = "";
		ASResultSet rs = null;
		boolean bFlag = false;
		
		sSql = 	" select count(LoanAccount) from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' "+
				" and LoanAccount = '"+sLoanAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			if(rs.getInt(1) > 0)
				bFlag = true;
		}
		rs.getStatement().close();
		
		return bFlag;
	}
	
	/**
	 * 从贷款信息库中查找相应贷款帐号的记录是否存在
	 * @param sLoanAccountNo 贷款帐号
	 * @return true 存在该贷款帐号的记录；false 不存在该贷款帐号的记录
	 */
	public boolean findExistReserveTotal(String sLoanAccountNo) throws Exception
	{
		//定义变量
		String sSql = "";
		ASResultSet rs = null;
		boolean bFlag = false;
		
		sSql = 	" select count(LoanAccount) from RESERVE_TOTAL "+
				" where LoanAccount = '"+sLoanAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			if(rs.getInt(1) > 0)
				bFlag = true;
		}
		rs.getStatement().close();
		
		return bFlag;
	}
	
	/**
	 * 检查贷款信息库中本次数据处理是否为首次初始化
	 * @param 
	 * @return true 首次初始化；false 非首次初始化
	 */
	public boolean getFirstRunFlag() throws Exception
	{
		//定义变量
		String sSql = "";
		ASResultSet rs = null;
		boolean bFlag = true;
		
		sSql = 	" select count(LoanAccount) from RESERVE_TOTAL ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			if(rs.getInt(1) > 0)
				bFlag = false;
		}
		rs.getStatement().close();
		
		return bFlag;
	}
	
	/**
	 * 从贷款信息库中查找相应会计月份和贷款帐号的记录是否存在
	 * @param sAccountMonth 会计月份,sLoanAccountNo 贷款帐号
	 * @return true 存在该会计月份和贷款帐号的记录；false 不存在该会计月份和贷款帐号的记录
	 */
	public boolean findExistAmendReserveTotal(String sAccountMonth,String sLoanAccountNo) throws Exception
	{
		//定义变量
		String sSql = "";
		ASResultSet rs = null;
		boolean bFlag = false;
		
		sSql = 	" select count(LoanAccount) from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' "+
				" and LoanAccount = '"+sLoanAccountNo+"' " + 
				" and ReinforceFlag in ('01', '02', '03')";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			if(rs.getInt(1) > 0)
				bFlag = true;
		}
		rs.getStatement().close();
		
		return bFlag;
	}
	
	/**
	 * 根据检查记录的结果更新是否补录标志
	 * @param sAccountMonth 会计月份,sLoanAccountNo 贷款帐号
	 * 补录标志 01－需补录  02－补录完成， 03－不需要补录
	 * @throws Exception
	 */
	public void updAmendFlag(String sAccountMonth,String sLoanAccountNo) throws Exception {
		String sReinforceFlag = "03";
		if(isAmend(sAccountMonth,sLoanAccountNo)){
			sReinforceFlag = "01";
		}
		String sSql = 	" Update RESERVE_TOTAL set ReinforceFlag = '"+ sReinforceFlag + "'" + 
		" where AccountMonth = '"+sAccountMonth+"' "+
		" and LoanAccount = '"+sLoanAccountNo+"' ";
		Sqlca.executeSQL(sSql);
	}
	
	
	/**
	 * 根据指定字段是否有值，决定是否补录该记录
	 * @param sAccountMonth 会计月份
	 * @param sLoanAccountNo 贷款帐号
	 * @return
	 * @throws Exception
	 */
	private boolean isAmend(String sAccountMonth,String sLoanAccountNo) throws Exception {
		boolean bAmend = false;
		String sSql = "Select DuebillNo " +//借据编号    1
		        ", CustomerID" +//客户编号
		        ", CustomerName" +//客户名称
		        ", CustomerOrgCode" +//客户组织机构代码
		        ", Region" +//所在地区                     5
		        ", ListingFlag" +//是否上市企业
		        ", IndustryType" +//行业类别
		        ", EconomyType" +//经济类型
		        ", Scope" +//企业规模
		        ", Currency" +//贷款币种                  10
		        ", BusinessSum" +//合同金额
		        ", PutoutDate" +//放款日期
		        ", Maturity" +//到期日期
		        ", LoanType" +//贷款类别
		        ", LoanNature" +//贷款性质               15
		        ", LoanTerm" +//贷款期限
		        ", VouchType" +//主要担保方式
		        ", Guarantor" +//保证人/抵押人/出质人名
		        ", GuarantyEvalValue" +//抵质押物原评估值
		        ", GuarantyDiscountValue" +//抵押物公允价值   20
		        ", GuarantyNowValue" +//抵质押物现评估值
		        ", OldPutoutDate" +//不良贷款最初放款日
		        ", FourClassify" +//四级分类
		        ", MFiveClassify" +//管理层五级分类
		        ", AFiveClassify" +//审计五级分类         25
		        ", StatOrgid" + //放款机构
				" from RESERVE_TOTAL " + 
		        " where AccountMonth = '"+sAccountMonth+"' "+
		        " and LoanAccount = '"+sLoanAccountNo+"' ";
		ASResultSet rs = null;
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			if(rs.getString(1) == null 
					|| rs.getString(2) == null 
					|| rs.getString(3) == null  
					|| rs.getString(4) == null 
					|| rs.getString(5) == null 
					|| rs.getString(6) == null 
					|| rs.getString(7) == null 
					|| rs.getString(8) == null 
					|| rs.getString(9) == null 
					|| rs.getString(10) == null 
					|| rs.getString(11)== null
					|| rs.getString(12) == null 
					|| rs.getString(13) == null 
					|| rs.getString(14) == null
					|| rs.getString(15) == null 
					|| rs.getString(16) == null 
					|| rs.getString(17) == null 
					//|| rs.getString(18) == null || rs.getString(19) == null
					//|| rs.getString(20) == null || rs.getString(21) == null 
					|| rs.getString(22) == null 
					|| rs.getString(23) == null 
					|| rs.getString(24) == null 
					|| rs.getString(25) == null
					|| rs.getString(26) == null
					)
				bAmend = true;
			
			if(!bAmend && !rs.getString(17).equals("01")){//信用贷款
				if(rs.getString(18) == null || rs.getString(19) == null || rs.getString(20) == null || rs.getString(21) == null ){
					bAmend = true;
				}
			}
		}
		rs.getStatement().close();
        
		return bAmend;
	}
	
	/**
	 * 获取小于指定月份的最大月份
	 * @param sAccountMonth
	 * @param sLoanAccountNo
	 * @return
	 * @throws Exception
	 */
	public String getMaxLTAccountMonth(String sAccountMonth) throws Exception{
		ASResultSet rs = null;
		String sSql = "";
		String sMaxMonth = "";
		
		sSql = 	" select max(AccountMonth) as AccountMonth "+
				" from RESERVE_TOTAL "+
				" where AccountMonth < '"+sAccountMonth+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sMaxMonth = rs.getString("AccountMonth");
			if(sMaxMonth == null) sMaxMonth = "";
		}
		rs.getStatement().close();
		return sMaxMonth;
	}
	
	/**
	 * 获取本期贷款总额
	 * @param sAccountMonth
	 * @return
	 * @throws Exception
	 */
	public double getTotalBalance(String sAccountMonth)throws Exception{
		ASResultSet rs = null;
		String sSql = "";
		double dLoanBalance = 0.0;
		
		sSql = 	" select nvl(sum(RMBBalance),0.0) "+
				" from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dLoanBalance = rs.getDouble(1);
		}
		rs.getStatement().close();
		return dLoanBalance;		
	}
	
	/**
	 * 计算五级分类的贷款余额
	 * @param sAccountMonth
	 * @param sMAScope
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	public double getFiveBalance(String sAccountMonth, String sMAScope, String sFiveResult)throws Exception{
		double dFiveBalance = 0.0;
		String sScopeField = "AuditStatFlag";
		String sFiveField = "AFiveClassify";
		if(sMAScope.equals("M")){
			sFiveField = "MFiveClassify";
			sScopeField = "ManageStatFlag";
		}
		ASResultSet rs = null;
		String sSql = "";
		sSql = 	" select sum(RMBBalance) "+
				" from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' " + 
				" and " + sScopeField + "='1'" + 
				" and " + sFiveField + "= '" + sFiveResult + "'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dFiveBalance = rs.getDouble(1);
		}
		rs.getStatement().close();
		return dFiveBalance;				
	}
	
	/**
	 * 计算五级分类的利息调整
	 * @param sAccountMonth
	 * @param sMAScope
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	public double getFiveInterest(String sAccountMonth, String sMAScope, String sFiveResult)throws Exception{
		double dFiveInterest = 0.0;
		String sScopeField = "AuditStatFlag";
		String sFiveField = "AFiveClassify";
		if(sMAScope.equals("M")){
			sFiveField = "MFiveClassify";
			sScopeField = "ManageStatFlag";
		}
		ASResultSet rs = null;
		String sSql = "";
		sSql = 	" select nvl(sum(Interest),0.0) "+
				" from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' " + 
				" and " + sScopeField + "='1'" + 
				" and " + sFiveField + "= '" + sFiveResult + "'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dFiveInterest = rs.getDouble(1);
		}
		rs.getStatement().close();
		return dFiveInterest;				
	}
	
	/**
	 * 计算五级分类的预测现金流折现值总额
	 * @param sAccountMonth
	 * @param sMAScope
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	public double getFiveCashDiscount(String sAccountMonth, String sMAScope, String sFiveResult)throws Exception{
		double dFiveCashDiscount = 0.0;
		String sScopeField = "AuditStatFlag";
		String sFiveField = "AFiveClassify";
		String sDiscountField = "ABadPrdDiscount";
		if(sMAScope.equals("M")){
			sFiveField = "MFiveClassify";
			sScopeField = "ManageStatFlag";
			sDiscountField = "MBadPrdDiscount";
		}
		ASResultSet rs = null;
		String sSql = "";
		sSql = 	" select nvl(sum(" + sDiscountField + "),0.0) "+
				" from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' " + 
				" and " + sScopeField + "='1'" + 
				" and " + sFiveField + "= '" + sFiveResult + "'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dFiveCashDiscount = rs.getDouble(1);
		}
		rs.getStatement().close();
		return dFiveCashDiscount;				
	}

	/**
	 * 计算五级分类的减值准备总额
	 * @param sAccountMonth
	 * @param sMAScope
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	public double getFiveRBBalance(String sAccountMonth, String sMAScope, String sFiveResult)throws Exception{
		double dFiveRBBalance = 0.0;
		String sScopeField = "AuditStatFlag";
		String sFiveField = "AFiveClassify";
		String sRBField = "ABadReserveBalance";
		if(sMAScope.equals("M")){
			sFiveField = "MFiveClassify";
			sScopeField = "ManageStatFlag";
			sRBField = "MBadReserveBalance";
		}
		ASResultSet rs = null;
		String sSql = "";
		sSql = 	" select nvl(sum(" + sRBField + "),0.0) "+
				" from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' " + 
				" and " + sScopeField + "='1'" + 
				" and " + sFiveField + "= '" + sFiveResult + "'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dFiveRBBalance = rs.getDouble(1);
		}
		rs.getStatement().close();
		return dFiveRBBalance;				
	}

	/**
	 * 计算五级分类的本年核销
	 * @param sAccountMonth
	 * @param sMAScope
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	public double getFiveCancelSum(String sAccountMonth, String sMAScope, String sFiveResult)throws Exception{
		double dFiveRBBalance = 0.0;
		String sScopeField = "AuditStatFlag";
		String sFiveField = "AFiveClassify";
		if(sMAScope.equals("M")){
			sFiveField = "MFiveClassify";
			sScopeField = "ManageStatFlag";
		}
		ASResultSet rs = null;
		String sSql = "";
		sSql = 	" select nvl(sum(OmitSum),0.0) "+
				" from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' " + 
				" and " + sScopeField + "='1'" + 
				" and " + sFiveField + "= '" + sFiveResult + "'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dFiveRBBalance = rs.getDouble(1);
		}
		rs.getStatement().close();
		return dFiveRBBalance;				
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try
		{
			
		}catch(Exception e)
		{
			System.out.println(e.toString());
		}
	}
}
