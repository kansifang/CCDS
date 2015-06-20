package com.lmt.app.cms;

import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;


public class CheckPutoutRisk extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//获取参数：对象类型和对象编号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sCurUserID = (String)this.getAttribute("UserID");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sCurUserID == null) sCurUserID = "";
		
		//定义变量：提示信息、SQL语句、产品类型、客户类型
		String sMessage = "",sSql = "",sBusinessType = "";
		//定义变量：客户代码、主体表名、关联表名
		String sCustomerID = "",sMainTable = "",sRelativeTable = "";
		//定义变量：暂存标志、受托支付方式
		String sTempSaveFlag = "",sPaymentType = "";
		//定义变量：合同流水号 add by zytan  2011-01-17
		String sBCSerialNo = "",sCreditAggreement="",sMaturity="",sPutOutDate="";
		//定义变量：业务金额
		double dBusinessSum = 0.0;
	
		//定义变量：查询结果集
		ASResultSet rs = null;
		//add by zytan 初始化用户和机构对象 2011-01-17
		ASUser CurUser = new ASUser(sCurUserID,Sqlca);
		//ASOrg1 CurOrg1 = new ASOrg1(CurUser.OrgID,Sqlca);
		int iCount = 0;
		//BusinessInfo bi =new BusinessInfo("PutOutApply",sObjectNo,Sqlca);
		//--------------第一步：检查申请信息是否全部输入---------------
		//从相应的对象主体表中获取数据信息:暂存状态、业务金额、业务品种、受托支付方式
		//rs =bi.getInfo("getErate(BusinessCurrency,'01','')*BusinessSum,BusinessType,CustomerID,PayType,ContractSerialNo,CreditAggreement,Maturity,PutOutDate", "M", "");
		/*
		while (rs.next()) { 				 
			dBusinessSum = rs.getDouble(1);				
			sBusinessType = rs.getString("BusinessType");
			sCustomerID = rs.getString("CustomerID");
			sPaymentType = rs.getString("PayType");
			sBCSerialNo = rs.getString("ContractSerialNo");		
			sCreditAggreement = rs.getString("CreditAggreement");
			sMaturity = rs.getString("Maturity");
			sPutOutDate = rs.getString("PutOutDate");
		}
		rs.getStatement().close();
		//将空值转化成空字符串
		if (sTempSaveFlag == null) sTempSaveFlag = "";				
		if (sBusinessType == null) sBusinessType = "";
		if (sCustomerID == null) sCustomerID = "";
		if (sPaymentType == null) sPaymentType = "";
		//--------------第二步：检查申请信息是否与受托支付信息一致---------------
		double sPaymentSum = 0.0;//定义变量：受托支付列表中的受托支付金额
		
		sSql = "Select nvl(sum(nvl(BusinessSum,0)),0) as BusinessSum " +
				" from PAYMENT_LIST " +
				"where ObjectNo = '"+sObjectNo+"' and ObjectType = 'PaymentList'";	
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sPaymentSum = rs.getDouble(1);
		}
		rs.getStatement().close();
	
		if((sPaymentType.equals("002")||sPaymentType.equals("003"))&& sPaymentSum <= 0){
			sMessage += "该业务没有受托支付信息！K"+"@";
		}
		
		if(sPaymentType.equals("002") && sPaymentSum != dBusinessSum){//010 贷款人受托支付 ，020 借款人自主支付，030 部分受托部分自主支付
			sMessage += "该业务支付方式为【贷款人受托支付】，但放款金额不等于受托支付金额！K"+"@";
		}
		
		if(sPaymentType.equals("003")  && sPaymentSum >= dBusinessSum){//010 贷款人受托支付 ，020 借款人自主支付，030 部分受托部分自主支付
			sMessage += "该业务支付方式为【贷款人部分受托部分自主支付】，但受托支付金额不小于放款金额！K"+"@";
		}
		
		//if(!sPaymentType.equals("020") && !sPaymentType.equals("030") && sPaymentSum >0){
			//sMessage += "该业务不属受托支付，不能有受托支付列表！K"+"@";
		//}*/
		/****************************第三步：校验受托支付阀值与支付方式之间的关系****************************************/
		/*remark by zytan 甑总要求去掉阀值校验 2011-01-12
		double dConsignedPaySum = 0.0;//定义变量：受托支付阀值
		sSql = "SELECT nvl(ConsignedPaySum,0)*getErate(BusinessCurrency,'01','') "+
			" FROM BUSINESS_CONTRACT "+
			" WHERE SerialNo in(Select ContractSerialNo from BUSINESS_PUTOUT BP where BP.SerialNo = '"+sObjectNo+"') ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			dConsignedPaySum = rs.getDouble(1);
		}
		rs.getStatement().close();
		
		if(dConsignedPaySum >0 && dBusinessSum >dConsignedPaySum && sPaymentType.equals("020")){
			sMessage += "该笔放款金额大于受托支付阀值，必须使用受托支付！K"+"@";
		}
		*/
		
		/******************************第四步：提交人权限校验（解决因浏览器串号问题导致的合同管户人和合同登记人不一致）**********************/
		/*
		if(!"1".equals(CurOrg1.sIfSmallCredit)){//非小贷中心机构
			sSql = "select count(*) " +
				   " from business_contract " +
				   " where nvl(InputUserID,'1')<>nvl(ManageUserID,'1')  " +
				   " and SerialNo = '"+sBCSerialNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				iCount = rs.getInt(1);
			}
			rs.getStatement().close();
			if(iCount > 0 ){
				sMessage += "该笔业务对应合同管户人与合同登记人不是同一人，不能进行后续处理；请取消原合同重新登记！K"+"@";
			}
		}
		*/
		/****************************第五步：校验国际业务出账金额是否等于融资金额***add by ljma 2011-01-10***************/
		/*
		//打包贷款需要验证出账金额与合同相关联的所有信用证打包金额之和是否相等
		if(sBusinessType.equals("1080020")){
			sSql = " select sum(getErate(FinanceCurrency,'01','')*FinanceSum) from LC_INFO where ObjectNo = "+
				   " (Select ContractSerialNo from BUSINESS_PUTOUT BP where BP.SerialNo = '"+sObjectNo+"') and ObjectType = 'BusinessContract' ";
			double dFinanceSum = 0.0;
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()) dFinanceSum = rs.getDouble(1);
			rs.getStatement().close();
			if(dFinanceSum != dBusinessSum)
				sMessage += "出账金额不等于信用证打包金额总和！K"+"@";
		}
		//【出口信用证项下押汇与贴现,出口托收项下押汇与贴现,商业发票贴现,福费廷,出口信用保险贸易融资、出口货权单据押汇】 需要验证出账金额是否等于相关联的融资单据的融资金额
		if(sBusinessType.equals("1080030")||sBusinessType.equals("1080040")||sBusinessType.equals("1080050")
				||sBusinessType.equals("1080060")||sBusinessType.equals("1080090")||sBusinessType.equals("1080100")){
			sSql = " Select getErate(FinanceCurrency,'01','')*FinanceSum from BUSINESS_PUTOUT BP where BP.SerialNo = '"+sObjectNo+"'";
			double dFinanceSum = 0.0;
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()) dFinanceSum = rs.getDouble(1);
			rs.getStatement().close();
			if(dFinanceSum != dBusinessSum) 
				sMessage += "出账金额不等于融资金额！K"+"@";
		}
		*/
		/****************************第六步：新增限额校验***************added by lkzou 2011-04-13*/
		//获取该笔业务申请类型
		/*
		sSql = " select ApplyType from FLOW_OBJECT FO " +
					" where exists(select * from BUSINESS_PUTOUT BP,BUSINESS_APPROVE BAP,BUSINESS_CONTRACT BC " +
					" where BP.ContractSerialNo = BC.SerialNo and BC.RelativeSerialNo = BAP.SerialNo and BAP.RelativeSerialNo = FO.ObjectNo " +
					" and BP.SerialNo = '"+sObjectNo+"') and ObjectType = 'CreditApply'";
		String sApplyType = Sqlca.getString(sSql);
		if(sApplyType == null) sApplyType = "";
		
		Bizlet  ri = new RiskLimitIntake();
		ri.setAttribute("ObjectNo", sObjectNo);
		ri.setAttribute("ObjectType",sObjectType);
		ri.setAttribute("ApplyType",sApplyType);
		sMessage += (String)ri.run(Sqlca);
		*/
		//added by bllou 2012-03-13 
		/************************担保合同金额校验***************************************
		String sVouchType = "";//定义变量：主要担保方式
		dBusinessSum = 0.00;//定义变量：主合同金额
		double dGuarantyValue = 0.00;//定义变量：担保合同总金额
		bi =new BusinessInfo("BusinessContract",sBCSerialNo,Sqlca);
		//获取合同主要担保方式
		rs = bi.getInfo("VouchType,nvl(getErate(BusinessCurrency,'01','')*BusinessSum,0)", "M", "");
		if(rs.next())
		{
			sVouchType = rs.getString("VouchType");
			dBusinessSum=rs.getDouble(2);
			if(sVouchType == null) sVouchType = "";
		}
		rs.getStatement().close();
		//获取担保合同总价值
		rs = bi.getInfo("nvl(sum(getErate(GuarantyCurrency,'01','')*GuarantyValue),0)", "GC", "");
		if(rs.next())
		{
			dGuarantyValue = rs.getDouble(1);
		}
		rs.getStatement().close();
		if(!sVouchType.equals("005")&&dBusinessSum > dGuarantyValue)//主合同担保方式不为信用且判断担保合同总金额小于主合同金额
		{
			sMessage += "合同下的担保合同总金额小于主合同合同金额！K@";
		}
		***/	
		/*** 录入抵押、质押物时的债权总金额必须大于担保合同金额校验放到此时的提交合同时校验******************
		//获取合同相关抵押、质押担保信息
		sSql = " select GC.SerialNo "+
			   " from Guaranty_Relative GR,Guaranty_Contract GC,Guaranty_Info GI"+
		       " where GR.ObjectNo='"+sBCSerialNo+"'"+
		       " and GR.ObjectType = 'BusinessContract'"+
		       " and GR.ContractNo = GC.SerialNo"+
		       " and GR.GuarantyID = GI.GuarantyID"+
		       " group by GC.SerialNo,GC.GuarantyCurrency,GC.GuarantyValue"+
		       " having getErate(GC.GuarantyCurrency,'01','')*GC.GuarantyValue>sum(getErate(GI.GuarantyCurrency,'01','')*GI.ConfirmValue)";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			String sGCSerialNo = rs.getString(1);
			if(sGCSerialNo == null) sGCSerialNo = "";
			//判断担保合同总金额是否小于主合同金额
			sMessage += "担保合同号【"+sGCSerialNo+"】的担保合同总金额大于项下全部债权金额！K@";
		}
		rs.getStatement().close();
		//--------------检查担保企业累计占用金额是否超过担保限额（针对个人部的业务）
		if(sBusinessType.startsWith("1110200")||sBusinessType.startsWith("1110300")){//只针对个人业务品种
			CheckGuarantyEnterpriseLimit  cgel = new CheckGuarantyEnterpriseLimit("BusinessContract",sBCSerialNo,Sqlca);
			String sReturn=cgel.action();
			if(!"true".equals(sReturn)){
				sMessage += cgel.action()+"K@";
			}
			
		}
		//--------------检查担保企业累计占用金额是否超过担保限额（针对所有配置到Guaranty_Limit的担保客户）
		sSql = " select GC.GuarantorName,"+
				" BC.OperateOrgID,BC.BusinessType as BBusinessType," +
				" GL.OrgID,GL.BusinessType as GLBusinessType,GL.Maturity,"+
				" BP.BusinessSum*(1-nvl(BP.BailRatio,0)-nvl(BP.DepositReceiptRatio,0)) as BusinessSum,"+
				" getGuarantyValue(GL.OrgID,GL.BusinessType,GC.GuarantorId,'Sum') as GuarantySumValue,"+
				" getGuarantyValue(GL.OrgID,GL.BusinessType,GC.GuarantorId,'In') as GuarantyInValue,"+
				" getGuarantyValue(GL.OrgID,GL.BusinessType,GC.GuarantorId,'Out') as GuarantyOutValue,"+
				" GL.SumLimit,GL.InLimit,GL.OutLimit"+
				" from Business_Putout BP,Business_Contract BC,Contract_Relative CR,Guaranty_Contract GC,Guaranty_Limit GL"+
				" where BP.SerialNo='"+sObjectNo+"'"+
				" and BC.SerialNo=BP.ContractSerialNo"+
				" and CR.ObjectType='GuarantyContract'"+
				" and CR.SerialNo='"+sBCSerialNo+"'"+
				" and CR.ObjectNo=GC.SerialNo"+
				" and GC.GuarantorID=GL.CustomerID"+
				" and GC.GuarantyType='010010'";//担保方式为保证的
		rs = Sqlca.getASResultSet(sSql);
		int i=0;
		String sGuarantorName="";
		while(rs.next()){
			sGuarantorName = DataConvert.toString(rs.getString("GuarantorName"));
			String sOperateOrgID = DataConvert.toString(rs.getString("OperateOrgID"));
			String sBBusinessType = DataConvert.toString(rs.getString("BBusinessType"));
			String sOrgID = DataConvert.toString(rs.getString("OrgID"));
			String sGLBusinessType = DataConvert.toString(rs.getString("GLBusinessType"));
			sMaturity = DataConvert.toString(rs.getString("Maturity"));
			double BusinessSum = rs.getDouble("BusinessSum");
			if(BusinessSum<0)BusinessSum=0;
			double GuarantySumValue = rs.getDouble("GuarantySumValue")+BusinessSum;
			double GuarantyInValue = rs.getDouble("GuarantyInValue")+(sBBusinessType.substring(0,1).equals("1")?BusinessSum:0.0);
			double GuarantyOutValue = rs.getDouble("GuarantyOutValue")+(sBBusinessType.substring(0,1).equals("2")?BusinessSum:0.0);
			double SumLimit = rs.getDouble("SumLimit");
			double InLimit = rs.getDouble("InLimit");
			double OutLimit = rs.getDouble("OutLimit");
			if(sOrgID.contains(sOperateOrgID)&&sGLBusinessType.contains(sBBusinessType)&&StringFunction.getToday().compareTo(sMaturity)<=0){
				i=1;//存在符合条件的限额
				if(GuarantySumValue>SumLimit || GuarantyInValue>InLimit || GuarantyOutValue>OutLimit){
					sMessage ="担保客户"+sGuarantorName+"的担保额已超出担保限额"+
							"，加上本笔业务总占用是"+DataConvert.toString(GuarantySumValue/10000)+"万，担保的业务合同总限额为"+DataConvert.toString(SumLimit/10000)+"万"+
							"，加上本笔业务（如是表内业务）表内占用是"+DataConvert.toString(GuarantyInValue/10000)+"万，担保的表内业务合同限额为"+DataConvert.toString(InLimit/10000)+"万"+
							"，加上本笔业务（如是表外业务）表外占用是"+DataConvert.toString(GuarantyOutValue/10000)+"万，担保的表外业务合同限额为"+DataConvert.toString(OutLimit/10000)+"万。K@";
					break;
				}else{
					continue;
				}
			}
		}
		rs.getStatement().close();
		if(i==0){//虽然配置了担保客户，但不存在符合当前业务条件的限额
			sMessage +="当前业务不符合担保客户"+sGuarantorName+"的限额条件或限额已过有效期。K@";
		}
		if(!"".equals(sCreditAggreement)){
			// 检查在预设的时间点之前的额度项下业务的到期日不能超过该额度的到期日,该时间点后的单笔业务的到期日不能超过额度到期日后6个月
			String sFront ="0";
			String bool = Sqlca.getString("Select case when (select BeginDate from Business_Contract where Serialno='"+sCreditAggreement+"' )>nvl(itemname,'"+StringFunction.getToday()+"') then 'false' else 'true' end from code_library where codeno='CheckCLDate'  ");
			if("2010".equals(sBusinessType))sFront = Sqlca.getString(" select nvl(ItemName,'3') from Code_library where codeno='CheckCLDateF' ");
			String sBack = Sqlca.getString("Select nvl(ItemName,'6') from code_library where codeno='CheckCLDateB' ");
			String bool1 = Sqlca.getString("Select case when date(replace('"+sMaturity+"','/','-'))>(date(replace(Maturity,'/','-'))+"+sFront+" month) then 'true' else 'flase' end　from Business_Contract where Serialno='"+sCreditAggreement+"' ");
			
			if(Boolean.parseBoolean(bool)&&Boolean.parseBoolean(bool1)){
				if("2010".equals(sBusinessType))sMessage +="该笔放款的到期日不能晚于额度的到期日后"+sFront+"个月！K@";
				else sMessage +="该笔放款的到期日不能晚于额度的到期日！K@";
				}	
			//不受综合额度期限一年限制的业务品种
			boolean flag =true;
			if(sBusinessType.equals("1010020")||("1030").equals(sBusinessType.substring(0, 4))||
					("2040").equals(sBusinessType.substring(0, 4))){
				flag = false;
			}
			String bool2 = Sqlca.getString("Select case　when date(replace('"+sMaturity+"','/','-'))>(date(replace(Maturity,'/','-'))+"+sBack+" month) then 'true' else 'false' end from Business_Contract where serialno='"+sCreditAggreement+"'");
			if(!Boolean.parseBoolean(bool)&& Boolean.parseBoolean(bool2)&&flag){
				sMessage +="该笔放款的到期日不能晚于额度到期日后"+sBack+"个月！K@";
			}
		}
		******/
		
		return sMessage;
	 }
}