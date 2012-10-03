package com.amarsoft.app.lending.bizlets;
/**
 * 初始化申请信息 2009-7-30 lpzhang
 * 
 * */
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.ASResultSet;


public class InitializeBusiness extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");
		//对象编号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
        		
		//定义变量:SQL
		String sSql = "";
		String sCustomerID="",sOccurType="",sBusinessType="",sRelativeAgreement="",sCustomerType="",sApplyType="";
		String sCreditAggreement="";
		String sApprovalNo = "";
		//定义变量：查询结果集
		ASResultSet rs=null;
		
		//客户信息
		if(sObjectType == null) sObjectType = "";
		if(sObjectType.equals("CreditApply"))
		{
			//找出申请信息
			sSql = "select CustomerID,getCustomerType(CustomerID) as CustomerType,"+
				" Occurtype,BusinessType,RelativeAgreement,ApplyType,CreditAggreement "
				+" from Business_Apply where SerialNo='"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sCustomerID = rs.getString("CustomerID");
				sCustomerType = rs.getString("CustomerType");
				sOccurType = rs.getString("Occurtype");
				sBusinessType = rs.getString("BusinessType");
				sRelativeAgreement = rs.getString("RelativeAgreement");
				sApplyType = rs.getString("ApplyType");
				sCreditAggreement =  rs.getString("CreditAggreement");
				if(sCustomerID == null) sCustomerID = "";
				if(sOccurType == null) sOccurType = "";
				if(sBusinessType == null) sBusinessType = "";
				if(sRelativeAgreement == null) sRelativeAgreement = "";
				if(sCustomerType == null) sCustomerType = "";
				if(sApplyType == null) sApplyType = "";
				if(sCreditAggreement == null) sCreditAggreement = "";
			}
			rs.getStatement().close();
			
			//取得该客户的客户行业投向
			if(!sCustomerType.startsWith("03"))//公司企业
			{
				sSql = "select IndustryType from Ent_Info where CustomerID='"+sCustomerID+"'";
				String sIndustryType = Sqlca.getString(sSql);
				if(sIndustryType == null) sIndustryType = "";
				Sqlca.executeSQL("Update Business_Apply  set Direction = '"+sIndustryType+"' where  SerialNo = '"+sObjectNo+"'");
			}
			
			//默认为人民币
			Sqlca.executeSQL("Update Business_Apply  set BusinessCurrency = '01' where  SerialNo = '"+sObjectNo+"'");
			
			//进口信用证默认保证金为人民币
			if("2050030".equals(sBusinessType))
			{
				Sqlca.executeSQL("Update Business_Apply  set  BailCurrency='01'  where  SerialNo = '"+sObjectNo+"'");
			}
			/*delete by xhyong 2011/06/01
			//好易贷默认可循环
			if("1140090".equals(sBusinessType) || "1140100".equals(sBusinessType))
			{
				Sqlca.executeSQL("Update Business_Apply  set  CycleFlag='1'  where  SerialNo = '"+sObjectNo+"'");
			}
			*/
			//add by xhyong 2011/06/01 所以个人业务默认为不可循环
			//取得该客户的客户行业投向
			if(sCustomerType.startsWith("03")&&!sBusinessType.startsWith("3"))//个人客户非授信额度
			{
				Sqlca.executeSQL("Update Business_Apply  set  CycleFlag='2'  where  SerialNo = '"+sObjectNo+"'");
			}
			//保易贷默认不可循环,主要担保方式为担保质押
			if("1140110".equals(sBusinessType))
			{
				Sqlca.executeSQL("Update Business_Apply  set  CycleFlag='2'  where  SerialNo = '"+sObjectNo+"'");
				Sqlca.executeSQL("Update Business_Apply  set  VouchType='005'  where  SerialNo = '"+sObjectNo+"'");
			}
			/*delete by xhyong 2012/06/20
			//下岗失业人员小额担保贷款
			if("1140080".equals(sBusinessType))
			{
				Sqlca.executeSQL("Update Business_Apply  set  VouchType='01050',VouchCorpName='天津市中小企业信用担保基金管理中心'  where  SerialNo = '"+sObjectNo+"'");
			}
			*/
			//同业额度担保方式为信用 added by zrli 2009-12-29
			if("3015".equals(sBusinessType))
			{
				Sqlca.executeSQL("Update Business_Apply  set  VouchType='005' where  SerialNo = '"+sObjectNo+"'");
			}
			//发起复议，终结合同
			if(sOccurType.equals("090"))
			{	
				sSql = 	" select ObjectNo from APPLY_RELATIVE "+
						" where SerialNo = '"+sObjectNo+"' " +
						" and ObjectType = 'BusinessReApply' ";
				String BASerialNo = Sqlca.getString(sSql);
				if(BASerialNo==null) BASerialNo="";
				Sqlca.executeSQL("Update Business_Contract set FreezeFlag = '4',FinishDate = '"+StringFunction.getToday()+"' where RelativeSerialNo = '"+BASerialNo+"'");
				
			}
			//额度项下
			/*if(sApplyType.equalsIgnoreCase("DependentApply")){
				Sqlca.executeSQL("Update Business_Apply set LowRisk = '1' where SerialNo = '"+sObjectNo+"'");
			}*/
			//更新单笔申请批复号为额度批复号
			if(sApplyType.equalsIgnoreCase("DependentApply")){
				sSql = 	" select ApprovalNo from BUSINESS_CONTRACT "+
				" where SerialNo = '"+sCreditAggreement+"' " ;
				sApprovalNo = Sqlca.getString(sSql);
				if(sApprovalNo==null) sApprovalNo="";
				Sqlca.executeSQL("Update Business_Apply set ApprovalNo = '"+sApprovalNo+"' where SerialNo = '"+sObjectNo+"'");
			}
			
		}
		
	    return "1";
	    
	 }

}
