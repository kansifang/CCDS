package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;


public class CreditInfo {
	
	private Transaction Sqlca = null;
	
	public CreditInfo(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;			
	}
		
	/**
	 * 根据组织机构代码获取客户信息
	 * @param sCertID 组织机构代码
	 * @return ArrayList 依次为：客户编号、客户名称、所在地区、是否上市企业、行业类别、经济类型、企业规模
	 */
	public ArrayList getCustomerInfo(String sCertID) throws Exception
	{
		//定义变量		
		ArrayList alCustomerInfo = new ArrayList();
		ASResultSet rs = null;
		String sSql = "";
		
		//根据组织机构代码获取客户信息
		sSql = 	" select EI.CustomerID,EI.EnterpriseName,EI.RegionCode, "+
				" EI.ListingCorpOrNot,substr(EI.IndustryType2, 1,1) as IndustryType2, substr(EI.EconomyType,1,2) as EconomyType, "+
				" EI.Scope "+
				" from CUSTOMER_INFO CI,ENT_INFO EI "+
				" where CI.CustomerID = EI.CustomerID "+
				" and CI.othercustomerid = '"+sCertID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			alCustomerInfo.add(0, rs.getString("CustomerID")== null ? "" : rs.getString("CustomerID"));
			alCustomerInfo.add(1, rs.getString("EnterpriseName")== null ? "" : rs.getString("EnterpriseName"));
			alCustomerInfo.add(2, rs.getString("RegionCode")== null ? "" : rs.getString("RegionCode"));
			alCustomerInfo.add(3, rs.getString("ListingCorpOrNot")== null ? "" : rs.getString("ListingCorpOrNot"));
			alCustomerInfo.add(4, rs.getString("IndustryType2")== null ? "" : rs.getString("IndustryType2"));
			alCustomerInfo.add(5, rs.getString("EconomyType")== null ? "" : rs.getString("EconomyType"));
			alCustomerInfo.add(6, rs.getString("Scope")== null ? "" : rs.getString("Scope"));
		}
		rs.getStatement().close();
		
		return alCustomerInfo;
	}
	
	/**
	 * 根据贷款帐号获取贷款的出帐流水号和合同流水号
	 * @param sLoanAccountNo 贷款帐号
	 * @return ArrayList 依次为：出帐流水号、合同流水号
	 */
	public ArrayList getPutoutInfo(String sLoanAccountNo) throws Exception
	{
		//定义变量		
		ArrayList al=new ArrayList();
		ASResultSet rs = null;
		String sSql = "";
		
		//根据贷款帐号获取出帐流水号和合同流水号
		sSql = 	" select SerialNo,RelativeSerialNo "+
				" from BUSINESS_PUTOUT "+
				" where Attribute1 = '"+sLoanAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			al.add(0, rs.getString("SerialNo")== null ? "" : rs.getString("SerialNo"));
			al.add(1, rs.getString("RelativeSerialNo")== null ? "" : rs.getString("RelativeSerialNo"));						
		}
		rs.getStatement().close();
		
		return al;
	}
	
	/**
	 * 根据贷款帐号获取借据相关信息
	 * @param sPayAccount 贷款帐号
	 * @return ArrayList 依次为：贷款期限、借据流水号、放款日期、到期日期、五级分类、放贷机构、借据金额、贷款年利率、借据管户员、合同编号。
	 */
	public ArrayList getDuebillInfo(String sPayAccount) throws Exception
	{
		//定义变量
		ArrayList alDuebillInfo = new ArrayList();
		ASResultSet rs = null;
		String sSql = "";
		
		//根据出帐流水号获取借据相关信息
		sSql = 	" select case when floor(to_date(Maturity,'yyyy/mm/dd')-to_date(ActualPutoutDate,'yyyy/mm/dd'))<=366 then '1' else '2' end as LoanTerm, "+
				" SerialNo,ActualPutoutDate,Maturity,ConveyReturnFlag,StatOrgID,BusinessSum,BusinessRate , Manageuserid,  RelativeSerialNo2 as ContractNo "+
				" from BUSINESS_DUEBILL "+
				" where PayAccount = '"+sPayAccount+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			alDuebillInfo.add(0, rs.getString("LoanTerm")== null ? "" : rs.getString("LoanTerm"));
			alDuebillInfo.add(1, rs.getString("SerialNo")== null ? "" : rs.getString("SerialNo"));			
			alDuebillInfo.add(2, rs.getString("ActualPutoutDate")== null ? "" : rs.getString("ActualPutoutDate"));
			alDuebillInfo.add(3, rs.getString("Maturity")== null ? "" : rs.getString("Maturity"));
			alDuebillInfo.add(4, rs.getString("ConveyReturnFlag")== null ? "" : rs.getString("ConveyReturnFlag"));
			alDuebillInfo.add(5, rs.getString("StatOrgID")== null ? "" : rs.getString("StatOrgID"));
			alDuebillInfo.add(6, rs.getString("BusinessSum")== null ? "" : rs.getString("BusinessSum"));
			alDuebillInfo.add(7, rs.getString("BusinessRate")== null ? "" : rs.getString("BusinessRate"));	
			alDuebillInfo.add(8, rs.getString("Manageuserid")== null ? "" : rs.getString("Manageuserid"));	
			alDuebillInfo.add(9, rs.getString("ContractNo")== null ? "" : rs.getString("ContractNo"));	//合同编号，自动生成的合同编号
		}
		rs.getStatement().close();
		
		return alDuebillInfo;
	}
	
	/**
	 * 根据合同流水号获取合同相关信息
	 * @param sContractNo 合同流水号
	 * @return ArrayList 依次为：贷款类别（即业务品种）、贷款性质（即发生类型）、主要担保方式、704帐号。
	 */
	public ArrayList getContractInfo(String sContractNo) throws Exception
	{
		//定义变量
		ArrayList alContractInfo = new ArrayList();
		ASResultSet rs = null;
		String sSql = "";
		
		//根据合同流水号获取合同相关信息
		sSql = 	" select BusinessType,OccurType,substr(VouchType, 1,2) as VouchType,GuarantyAccount "+
				" from BUSINESS_CONTRACT "+
				" where SerialNo = '"+sContractNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{			
			alContractInfo.add(0, rs.getString("BusinessType")== null ? "" : rs.getString("BusinessType"));
			alContractInfo.add(1, rs.getString("OccurType")== null ? "" : rs.getString("OccurType"));
			alContractInfo.add(2, rs.getString("VouchType")== null ? "" : rs.getString("VouchType"));
			alContractInfo.add(3, rs.getString("GuarantyAccount")== null ? "" : rs.getString("GuarantyAccount"));
		}
		rs.getStatement().close();
		
		return alContractInfo;
	}
	
	/**
	 * 根据704帐号获取抵质押物相关信息
	 * @param sGuarantyAccountNo 704帐号
	 * @return ArrayList 依次为：抵押人/出质人名称、抵质押物原评估价值、抵质押物现评估值
	 */
	public ArrayList getGuarantyInfo(String sGuarantyAccountNo) throws Exception
	{
		//定义变量	
		ArrayList alGuarantyInfo = new ArrayList();
		ASResultSet rs = null;
		String sSql = "";
		String sGuarantyType = "";
		String sSigneeName = "";
		double dBeforeEvalValue = 0.0;
		double dEvalValue = 0.0;
		String sSigneeNameStr = "";
		double dTotalBeforeEvalValue = 0.0;
		double dTotalEvalValue = 0.0;
		
		
		//根据704帐号获取抵质押物信息
		sSql = 	" select GuarantyType,SigneeName,BeforeEvalValue,EvalValue "+
				" from GUARANTY_DETAIL "+
				" where GuarantyAccount = '"+sGuarantyAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sGuarantyType = rs.getString("GuarantyType");
			sSigneeName = rs.getString("SigneeName");
			dBeforeEvalValue = rs.getDouble("BeforeEvalValue");
			dEvalValue = rs.getDouble("EvalValue");
			//将空值转换为空字符串
			if(sGuarantyType == null) sGuarantyType = "";
			if(sSigneeName == null) sSigneeName = "";
			
			//进行抵押人/出质人名称的合并
			if(!sSigneeName.equals(""))
				sSigneeNameStr += sSigneeName +",";
			//如果抵押质物类型为质押，则抵质押物原评估价值即为抵质押物现评估值
			if(sGuarantyType.substring(0,2).equals("04"))
			{
				dTotalBeforeEvalValue += dEvalValue;
				dTotalEvalValue += dEvalValue;
			}else
			{
				dTotalBeforeEvalValue += dBeforeEvalValue;
				dTotalEvalValue += dEvalValue;
			}				
		}
		rs.getStatement().close();
		
		//去掉抵押人/出质人名称字符串最末尾的","
		if(sSigneeNameStr.length() > 0)
			sSigneeNameStr = sSigneeNameStr.substring(0, sSigneeNameStr.length()-1);
		
		//将需要的数据存放在ArrayList中
		alGuarantyInfo.add(0, sSigneeNameStr);
		alGuarantyInfo.add(1, String.valueOf(dTotalBeforeEvalValue));
		alGuarantyInfo.add(2, String.valueOf(dTotalEvalValue));	
		
		return alGuarantyInfo;
	}
	
	/**
	 * 根据合同流水号获取保证人名称
	 * @param sContractNo 合同流水号
	 * @return String 保证人名称拼成的字符串
	 */
	public String getSigneeName(String sContractNo) throws Exception
	{
		//定义变量
		ASResultSet rs = null;
		String sSql = "";		
		String sSigneeName = "";		
		String sSigneeNameStr = "";
		
		//根据合同流水号获取保证人信息
		sSql = 	" select SigneeName "+
				" from GUARANTY_INFO "+
				" where ObjectType = 'BusinessContract' "+
				" and ObjectNo = '"+sContractNo+"' "+
				" and GuarantyType like '02%' ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{			
			sSigneeName = rs.getString("SigneeName");			
			//将空值转换为空字符串			
			if(sSigneeName == null) sSigneeName = "";
			
			//进行保证人名称的合并
			if(!sSigneeName.equals(""))
				sSigneeNameStr += sSigneeName +",";							
		}
		rs.getStatement().close();
		
		//去掉保证人名称字符串最末尾的","
		if(sSigneeNameStr.length() > 0)
			sSigneeNameStr = sSigneeNameStr.substring(0, sSigneeNameStr.length()-1);
						
		return sSigneeNameStr;
	}
	
	/**
	 * 根据科目号获取四级分类信息
	 * @param sSubject 科目号
	 * @return String 四级分类
	 */
	public String getFourClassify(String sSubject) throws Exception
	{
		//定义变量			
		ASResultSet rs = null;
		String sSql = "";
		String sFourClassify = "";
						
		if(sSubject.equals("13001") || sSubject.equals("13002")) //13001、13002为逾期
			sFourClassify = "2";  //逾期
		else if(sSubject.equals("13003")) //13003为呆滞
			sFourClassify = "3";  //呆滞
		else if(sSubject.equals("13004")) //13004为呆帐
			sFourClassify = "4";  //呆帐
		else //其它为正常
			sFourClassify = "1";  //正常
		return sFourClassify;
	}
	
	/**
	 * 根据十二级分类转换为五级分类
	 * @param sCreditFiveClassify 十二级分类（信贷系统）
	 * @return String 五级分类（减值准备）
	 */
	public String getReserveFiveClassify(String sCreditFiveClassify) throws Exception
	{
		//定义变量			
		ASResultSet rs = null;
		String sSql = "";
		String sReserveFiveClassify = "";
		
		//01-06为正常一至正常六
		if(sCreditFiveClassify.equals("01") || sCreditFiveClassify.equals("02")
		|| sCreditFiveClassify.equals("03") || sCreditFiveClassify.equals("04")
		|| sCreditFiveClassify.equals("05") || sCreditFiveClassify.equals("06"))
			sReserveFiveClassify = "01";  //正常
		else if(sCreditFiveClassify.equals("07")) //关注
			sReserveFiveClassify = "02";  //关注
		else if(sCreditFiveClassify.equals("08") || sCreditFiveClassify.equals("09")) //08-09为次级一至次级二
			sReserveFiveClassify = "03";  //次级
		else if(sCreditFiveClassify.equals("10") || sCreditFiveClassify.equals("11")) //08-09为可疑一至可疑二
			sReserveFiveClassify = "04";  //可疑
		else if(sCreditFiveClassify.equals("12")) //损失
			sReserveFiveClassify = "05";  //损失
		return sReserveFiveClassify;
	}
	
	/**
	 * 根据贷款帐号获取客户的组织机构代码
	 * @param sLoanAccount
	 * @return
	 * @throws Exception
	 */
	public String getCustomerOrgCode(String sLoanAccount)throws Exception{
		String sCustomerOrgCode = "";
		String sSql = "select othercustomerid from customer_info where customerid = " + 
		   "(select customerid from business_duebill where payaccount = '" + sLoanAccount + "')";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sCustomerOrgCode = rs.getString(1) == null ? "" : rs.getString(1) ;
		}
		rs.getStatement().close();
		return sCustomerOrgCode;
	}
	
	/**
	 * 根据贷款帐号和会计月份获取借据的五级分类最终认定结果
	 * @param sDuebillNo   借据编号
	 * @param sAccountMonth  会计月份
	 * @return
	 * @throws Exception
	 */
	public String getFiveClassify(String sDuebillNo, String sAccountMonth)throws Exception{
		String sFiveClassify = "";
		String sSql = "select Result4 from CLASSIFY_RECORD where AccountMonth = '" + sAccountMonth + "'" +
		   " and ObjectNo = '" + sDuebillNo + "' and ObjectType = 'BusinessDueBill'";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sFiveClassify = rs.getString(1) == null ? "" : rs.getString(1) ;
		}
		rs.getStatement().close();
		return sFiveClassify;	
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
