/*
		Author: --zrli 2009-8-26
		Tester:
		Describe: --天津农合五级分类
		Input Param:
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import java.sql.ResultSet;
import java.sql.SQLException;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
/**
 *    此方法为天津农合五级分类自动分类的核心处理类，主要包括两部分功能，一部分为25号进行分类初始化生成CLASSIFY_RECORD记录
 * 另一部分为月末进行记录的认定完成。第一部分针对对私贷款的矩阵法进行生成分类记录，对公贷款直接延用上次分类的结果生成
 * 本期次分类记录；第二部分针对对私贷款和对公贷款完成认定。
 * @author zrli
 * @version 1.0
 *
 */
public class Classify_TJNH  extends Bizlet {
	//================================================================================

	public Object run(Transaction Sqlca) throws Exception{
		
		String sContractSerialNo = (String)this.getAttribute("SerialNo");
		if(sContractSerialNo == null) sContractSerialNo = "";
		//合同号，业务品种、机构号
		 String sBusinessType = "",sManageOrgID = "",sManageUserID ="",sVouchTypeTemp="",
			sVouchType="",sCustomerID="",sCustomerType = "",sLowRisk = "",sCreditLevel = "",sLockClassifyResult="";
		
		//合同余额
		double dBlance =0;
			
		//逾期天数
		int iOverDueDays = 0;
		
		//初分结果,临时结果
		String sResult1="01",sResultTemp="";
		
		//本期意见
		String sOpition="";
		
		//插入Classify_Record的流水号

		String sSql= "select " +
		" SerialNo,nvl(BusinessType,'1010010') as BusinessType," +
		" ManageOrgID,ManageUserID,nvl(Balance,0) as Balance,VouchType,CustomerID,OverDueDays,LowRisk,LockClassifyResult " +
		" from Business_Contract where Balance >0 " +
		" and businesstype is not null " +
		" and businesstype <>'' " +
		" and vouchtype is not null " +
		" and vouchtype <>'' " +
		" and (finishdate is null or finishdate = '') " +
		" and left(BusinessType,1) <>'3'"+
		" and PutOutDate is not null and PutOutDate<>''"+
		" and serialno = '"+sContractSerialNo+"'";
		
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		if (rs.next()){
			sContractSerialNo = rs.getString("SerialNo");
			sBusinessType = rs.getString("BusinessType");
			sManageOrgID = rs.getString("ManageOrgID");
			sManageUserID  = rs.getString("ManageUserID");
			dBlance = rs.getDouble("Balance");
			sVouchType= rs.getString("VouchType");
			sCustomerID= rs.getString("CustomerID");
			iOverDueDays= rs.getInt("OverDueDays");
			sLowRisk = rs.getString("LowRisk");
			sLockClassifyResult = rs.getString("LockClassifyResult");
			if(sContractSerialNo==null) sContractSerialNo="";
			if(sBusinessType==null) sBusinessType="";
			if(sManageOrgID==null) sManageOrgID="";
			if(sManageUserID==null) sManageUserID="";
			if(sVouchType==null) sVouchType="";
			if(sCustomerID==null) sCustomerID="";
			if(sLowRisk==null) sLowRisk="";
			if(sLockClassifyResult==null) sLockClassifyResult="";
		}
		rs.getStatement().close();
		sResult1 = "";
		//绑定风险分类
		if(!sLockClassifyResult.equals(""))
		{
			sResult1 = sLockClassifyResult;
		}else{
			
			sVouchTypeTemp = sVouchType;
			if(sVouchType.length()>3) sVouchType=sVouchType.substring(0,3);
			
			//取得客户类型
			sCustomerType = getCustomerType(Sqlca,sCustomerID);
			
			//如果为小企业
			if(sCustomerType.equals("010")){
				//如果为低风险
				if(sLowRisk.equals("1")){
					sOpition="小企业低风险逾期天数十级分类结果";
					sResult1 = ClassifyModel.ClassifyModelWithOverDueDays(iOverDueDays, ClassifyModel.M1);
				}else{
					sOpition="小企业非低风险逾期天数十级分类结果";
					sResult1 = ClassifyModel.ClassifyModelWithVouchTypeOverdueDays(sVouchType,iOverDueDays, ClassifyModel.M2);
				}
			//如果为一般企业
			}else if(sCustomerType.equals("020")){
				//如果为低风险
				if(sLowRisk.equals("1")){
					sOpition="一般企业低风险逾期天数十级分类结果";
					sResult1 = ClassifyModel.ClassifyModelWithOverDueDays(iOverDueDays, ClassifyModel.M5);
				}else{
					sCreditLevel = getCreditLevel(Sqlca,sCustomerID);
					sResult1 = "0101";//先进行初始化
					sResultTemp = "0101";//先进行初始化
					sResultTemp = ClassifyModel.ClassifyModelWithOverDueDays(iOverDueDays, ClassifyModel.M6);
					sResult1 = compareClassify(sResult1,sResultTemp);
					sResultTemp = ClassifyModel.ClassifyModelWithCreditLevelVouchType(sCreditLevel,sVouchTypeTemp, ClassifyModel.M9);
					sResult1 = compareClassify(sResult1,sResultTemp);
					if(sResult1.equals(sResultTemp)){
						sOpition="一般企业非低风险信用等级、担保方式十级分类结果";
					}
					else
					{
						sOpition="一般企业非低风险逾期天数十级分类结果";
					}
				}
			//如果为农户
			}else if(sCustomerType.equals("030")){
				sOpition="农户担保方式、逾期天数十级分类结果";
				sResult1 = ClassifyModel.ClassifyModelWithVouchTypeOverdueDays(sVouchType, iOverDueDays, ClassifyModel.M10);
			//如果为非农户
			}else if(sCustomerType.equals("040")){
				sOpition="非农户担保方式、逾期天数十级分类结果";
				sResult1 = ClassifyModel.ClassifyModelWithVouchTypeOverdueDays(sVouchType, iOverDueDays, ClassifyModel.M11);
			}
		}
		return sResult1 +","+sOpition;
	}

	/**
	 * 取客户类型包括 010小企业  020一般企业  030农户  040非农户  050无客户信息
	 * @param sCustomerID
	 * @return
	 */
	private String getCustomerType(Transaction Sqlca,String sCustomerID) throws Exception{
		String sCustomerType = "";
		String sFarmerType = "";
		double dBalanceSum = 0;
		ResultSet rs = null;
		try {
			//先查找客户类型
			sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"'");
			if(sCustomerType == null) sCustomerType = "";
			
			//如果为个人客户
			if("".equals(sCustomerType)){
				sCustomerType = "050";
			}
			else if(sCustomerType.startsWith("03")){
				
				sFarmerType = Sqlca.getString("select IndRPRType from IND_INFO where CustomerID = '"+sCustomerID+"'");
				if(sFarmerType == null) sFarmerType = "";

				//如果为农户
				if(sFarmerType.equals("010")){
					sCustomerType = "030";
				}else{
					sCustomerType = "040";
				}
			}else{

				dBalanceSum = Sqlca.getDouble("select sum(Balance) as Balance from BUSINESS_CONTRACT where CustomerID = '"+sCustomerID+"'");

				//如果单户余额小于500万那么为小企业
				if(dBalanceSum <= 5000000){
					sCustomerType = "010";
				}else{
					sCustomerType = "020";
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return sCustomerType;
	}
	
	/**
	 * 取客户的即期信用等级
	 * @param sCustomerID
	 * @return
	 */
	private String getCreditLevel(Transaction Sqlca,String sCustomerID) throws Exception{
		String sCreditLevel = "";
		try {
			sCreditLevel = Sqlca.getString("select CreditLevel from ENT_INFO where CustomerID = '"+sCustomerID+"'");
			if(sCreditLevel == null) sCreditLevel = "";
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return sCreditLevel;
	}
	/**
	 * 十级分类结果大小比较 返回差的级别
	 * @param sResult1
	 * @param sResult2
	 * @return
	 */
	private String compareClassify(String sResult1,String sResult2){
		String sBadResult = "";
		try{
		if(Integer.parseInt(sResult1)>Integer.parseInt(sResult2)){
			sBadResult =  sResult1;
		}else{
			sBadResult = sResult2;
		}
		}catch(Exception ex){
			sBadResult = sResult1.length()>0?sResult1:sResult2;
		}
		return sBadResult;
	}
}
