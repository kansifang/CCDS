/**
 * Author: --zwhu 2010-03-29
 * Tester:                               
 * Describe: --额度检查
 * Input Param:                          
 * 		ObjectNo :对象编号  
 * 		ObjectType：对象类型
 * 		LineID：额度编号
 *      BusinessType：业务品种
 * Output Param:   
 * 		sMessage             
 * HistoryLog:                           
 */
package com.amarsoft.app.lending.bizlets;

import java.text.SimpleDateFormat;
import java.util.GregorianCalendar;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.impl.tjnh_als.bizlets.CreditData;
import com.amarsoft.impl.tjnh_als.bizlets.Tools;
import com.amarsoft.script.AmarInterpreter;
import com.amarsoft.script.Anything;

public class CheckLineApplyRisk extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//获取参数：对象类型和对象编号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
         
		 //协议所有合同统计数据
		CreditData AgreementContract = null;
		 //协议所有合同统计数据
		CreditData AgreementApply = null;
		
		
		//获得当前日期
		String sToday = StringFunction.getToday();
		//半年前
		java.util.GregorianCalendar gr=new GregorianCalendar(Integer.parseInt(sToday.substring(0,4)),Integer.parseInt(sToday.substring(5,7)),Integer.parseInt(sToday.substring(8, 10)));
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	    gr.add(GregorianCalendar.MONTH,-7); //回退6个月
		String Temp = sdf.format(gr.getTime());
		java.util.GregorianCalendar gr1=new GregorianCalendar(Integer.parseInt(sToday.substring(0,4)),Integer.parseInt(sToday.substring(5,7)),Integer.parseInt(sToday.substring(8, 10)));
	 
	    gr1.add(GregorianCalendar.DATE,30); //回30天
		String sMessage = "",sSql = "",sBusinessType = "",sBusinessTypeName = "",sCustomerType = "";
		//定义变量：主要担保方式、客户代码、主体表名、关联表名
		String sVouchType = "",sCustomerID = "",sMainTable = "",sRelativeTable = "",sCustomerName = "",sNationRisk="";
		//定义变量：暂存标志,是否低风险,进出口经营权
		String sTempSaveFlag = "",sLowRisk = "",sHasIERight="",sRelativeAgreement="",sVouchAggreement="",sConstructContractNo="",sAgriLoanClassify="",sBuildAgreement="";
		//定义变量：发生类型、申请类型、担保人代码
		String sOccurType = "",sApplyType = "";
		//定义变量：∑协议项下业务余额,∑协议项下审批中申请金额,∑该担保机构担保的该申请客户业务余额,∑该担保机构担保的该申请客户业务审批中申请金额
		double dAgreementBalance=0.0,dAgreementApplySum=0.0,dCusAgreeBalance=0.0,dCusAgreeApplySum=0.0,dTermMonth=0.0;
		
		//定义变量：业务金额,设备购买金额
		double dBusinessSum = 0.0,dEquipmentSum=0.0,dTermDay=0.0; 
		//定义变量：票据张数
		int iBillNum = 0,iNum = 0;
		//定义变量：查询结果集
		ASResultSet rs = null,rs1 = null;	
		
		String sBusinessCurrency = "" ,sRateFloatType = "" ,sBaseRateType="",sBailCurrency="",sDrawingType="",sCorpusPayMethod="";
		double dBaseRate=0.0 ,dBailSum = 0.0,dBailRatio = 0.0 ,dPdgRatio = 0.0 ,dPdgSum = 0.0,dRateFloat=0.0,dBusinessRate=0.0;
		
		//根据对象类型获取主体表名
		sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) { 
			sMainTable = rs.getString("ObjectTable");
			sRelativeTable = rs.getString("RelativeTable");
			//将空值转化成空字符串
			if (sMainTable == null) sMainTable = "";
			if (sRelativeTable == null) sRelativeTable = "";
		}
		rs.getStatement().close();
		
		if (!sMainTable.equals("")) {
			//--------------第一步：检查申请信息是否全部输入---------------
			//从相应的对象主体表中获取金额、产品类型、票据张数、担保类型
			sSql = 	" select TempSaveFlag,BusinessSum*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum,BusinessType,getBusinessName(BusinessType) as BusinessTypeName, "+
					" BillNum,nvl(TermMonth,0) as TermMonth,nvl(TermDay,0) as TermDay , "+
					" VouchType,CustomerID,getCustomerType(CustomerID) as CustomerType,LowRisk,OccurType,ApplyType,RelativeAgreement,VouchAggreement,ConstructContractNo,AgriLoanClassify, " +
					" EquipmentSum*getERate(BusinessCurrency,'01',ERateDate) as EquipmentSum,BuildAgreement,CustomerName, "+
					" BusinessCurrency,RateFloatType,BaseRateType,BailCurrency,BaseRate,BailSum,BailRatio,PdgRatio,PdgSum,RateFloat,BusinessRate,NationRisk, "+
					" DrawingType,CorpusPayMethod "+
					" from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			while (rs.next()) { 			
				sTempSaveFlag = rs.getString("TempSaveFlag");	 
				dBusinessSum = rs.getDouble("BusinessSum");				
				sBusinessType = rs.getString("BusinessType");
				sBusinessTypeName = rs.getString("BusinessTypeName");
				iBillNum = rs.getInt("BillNum");
				dTermMonth = rs.getDouble("TermMonth");
				sVouchType = rs.getString("VouchType");
				sCustomerID = rs.getString("CustomerID");
				sCustomerName = rs.getString("CustomerName");
				sLowRisk = rs.getString("LowRisk");
				sOccurType = rs.getString("OccurType");
				sApplyType = rs.getString("ApplyType");
				sRelativeAgreement = rs.getString("RelativeAgreement");
				sVouchAggreement = rs.getString("VouchAggreement");
				sConstructContractNo = rs.getString("ConstructContractNo");
				sAgriLoanClassify = rs.getString("AgriLoanClassify");
				dEquipmentSum = rs.getDouble("EquipmentSum");
				sBuildAgreement = rs.getString("BuildAgreement"); 
				sCustomerType = rs.getString("CustomerType");
				dTermDay = rs.getDouble("TermDay");
				sBusinessCurrency = rs.getString("BusinessCurrency");
				sRateFloatType = rs.getString("RateFloatType");
				sBaseRateType = rs.getString("BaseRateType");
				sBailCurrency = rs.getString("BailCurrency");
				dBaseRate = rs.getDouble("BaseRate");
				dBailSum = rs.getDouble("BailSum");
				dBailRatio = rs.getDouble("BailRatio");
				dPdgRatio = rs.getDouble("PdgRatio");
				dPdgSum = rs.getDouble("PdgSum");
				dRateFloat = rs.getDouble("RateFloat");
				dBusinessRate = rs.getDouble("BusinessRate");
				sNationRisk = rs.getString("NationRisk");
				sDrawingType = rs.getString("DrawingType");
				sCorpusPayMethod = rs.getString("CorpusPayMethod");
				//将空值转化成空字符串
				if (sTempSaveFlag == null) sTempSaveFlag = "";				
				if (sBusinessType == null) sBusinessType = "";
				if (sBusinessTypeName == null) sBusinessTypeName = "";
				if (sVouchType == null) sVouchType = "";
				if (sCustomerID == null) sCustomerID = "";
				if (sCustomerName == null) sCustomerName = "";
				if (sLowRisk == null) sLowRisk = "";
				if (sOccurType == null) sOccurType = "";
				if (sApplyType == null) sApplyType = "";
				if (sRelativeAgreement == null) sRelativeAgreement = "";
				if (sVouchAggreement == null) sVouchAggreement ="";
				if (sConstructContractNo == null) sConstructContractNo ="";
				if (sBuildAgreement == null) sBuildAgreement ="";
				if (sCustomerType == null) sCustomerType ="";
				if(sBusinessCurrency == null) sBusinessCurrency = "";
				if(sRateFloatType == null) sRateFloatType = "";
				if(sBaseRateType == null) sBaseRateType = "";
				if(sBailCurrency == null) sBailCurrency = "";
				if(sNationRisk == null) sNationRisk = "";
				if(sDrawingType == null) sDrawingType = "";
				if(sCorpusPayMethod == null) sCorpusPayMethod = "";
				if (sTempSaveFlag.equals("1")) {			
					sMessage = "项下业务"+sObjectNo+"的申请基本信息为暂存状态，请先填写完申请基本信息并点击保存按钮！"+"@";
												
				}			
			}
			rs.getStatement().close();
		}
		
		//--------------第一步：检查贴现业务和其票据业务信息一致---------------
		if(sBusinessType.length()>=4) {
			//如果产品类型为贴现业务
			if(sBusinessType.substring(0,4).equals("1020"))	{
				sSql = 	" select count(SerialNo) from BILL_INFO  where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' "+
						" having sum(BillSum) = "+dBusinessSum+" ";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()) 
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum == 0)
					sMessage  += "项下业务"+sObjectNo+"的金额和票据金额总和不符！"+"@";
				
				sSql = 	" select count(SerialNo) from BILL_INFO  where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' "+
						" having count(SerialNo) = "+iBillNum+" ";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()) 
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum == 0)
					sMessage += "项下业务"+sObjectNo+"中输入的票据张数和输入的票据张数不符！"+"@";					
			}					
		}

		//------------第二步：微小企业只能办理流动资金贷款、银行承兑汇票贴现、银行承兑汇票业务 并且提款方式为一次性提款、还款方式为按月或按季还款--------------
		String sSmallEntFlag="",sSetupDate="";
		if(sCustomerType.startsWith("01"))
		{
			//判断是否为微小企业SmallEntFlag
			sSql = "select SmallEntFlag,SetupDate from ENT_INFO where  CustomerID ='"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sSmallEntFlag = rs.getString("SmallEntFlag");
				sSetupDate = rs.getString("SetupDate");
				if(sSmallEntFlag == null || "NULL".equals(sSmallEntFlag)) sSmallEntFlag ="";
				if(sSetupDate == null || "NULL".equals(sSetupDate)) sSetupDate ="";
			}
			rs.getStatement().close();
			if(sSmallEntFlag.equals("1"))
			{
				double days  = Sqlca.getDouble("select  days(current date) - days(date('"+sSetupDate.replaceAll("/", "-")+"'))  as days from (values 1) as a").doubleValue();
				System.out.println(days);
				if(!(sBusinessType.startsWith("1010") || sBusinessType.equals("1020010") || sBusinessType.equals("2010")))
				{
					sMessage  += "微小企业客户不能办理"+sBusinessTypeName+"业务!"+"@";
				}
				if(days<365){
					sMessage  += "微小企业客户经营期限必需大于等于1年!"+"@";
				}
				if(sBusinessType.startsWith("1010")){
					if(!("01".equals(sDrawingType))){
						sMessage  += "项下业务"+sObjectNo+"的提款方式必需为一次性提款!"+"@";
					}
					if(!("2".equals(sCorpusPayMethod)||"3".equals(sCorpusPayMethod))){
						sMessage  += "项下业务"+sObjectNo+"的还款方式必需按月还款或按季还款!"+"@";
					}
				}
				if("1020010".equals(sBusinessType)){
					if(!("2".equals(sCorpusPayMethod)||"3".equals(sCorpusPayMethod))){
						sMessage  += "项下业务"+sObjectNo+"的还款方式必需按月还款或按季还款!"+"@";
					}
				}
				
			}
			
		}
		
		//--------------第三步：信用证项下打包贷款，出口信用证打包贷款、出口信用证押汇与贴现（取消控制）、出口托收押汇与贴现、出口商业发票融资、检查相关信用证信息---------------1080020,1080080,1080090,1080030,1080035
		if (sBusinessType.equals("1080020") || sBusinessType.equals("1080080") ||sBusinessType.equals("1080090") )	{
			sSql = 	" select count(SerialNo) from LC_INFO where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum == 0)
	     		sMessage  += "项下业务"+sObjectNo+"的"+sBusinessTypeName+"没有相关信用证信息！"+"@";
		}

		//--------------第四步：托收项下打包贷款、合同项下打包贷款，检查相关贸易合同信息---------------
		if (sBusinessType.equals("1080020") || sBusinessType.equals("1080010")) {
			sSql = 	" select count(SerialNo) from CONTRACT_INFO where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum == 0)			     	
	     		sMessage  += "项下业务"+sObjectNo+"的"+sBusinessTypeName+"没有相关贸易合同信息！"+"@";
		}

		//--------------第五步：进口保理、出口保理，检查相关发票信息---------------
		if (sBusinessType.equals("1090020") ||  sBusinessType.equals("1090030")) {
			sSql = 	" select count(SerialNo) from INVOICE_INFO where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum == 0)			     	
	     		sMessage  += "项下业务"+sObjectNo+"的"+sBusinessTypeName+"没有相关发票信息！"+"@";
		}
		
		//--------------第六步：是否有进出口经营权---------------
		if (sBusinessType.substring(0, 4).equals("1080"))
		{
		sSql = "select HasIERight from ENT_INFO where CustomerID = '"+sCustomerID+"' ";
		rs = Sqlca.getASResultSet(sSql);
	    if(rs.next())
	    	sHasIERight = rs.getString("HasIERight");
	    rs.getStatement().close();
	    if(sHasIERight==null) sHasIERight="";
		if(sHasIERight.equals("2"))
	   		sMessage  += "项下业务"+sObjectNo+"的"+sBusinessTypeName+"需要有进出口经营权！"+"@";
		}
	
		//--------------第二十六步:固定资产贷款(基本建设贷款、基础设施贷款、技术改造项目贷款、经营性物业抵押贷款、其他类项目贷款）、房地产贷款（房地产开发贷款、土地储备贷款）)------------------------------
		if ("1030010,1030015,1030020,1030030,1050010,1050020".indexOf(sBusinessType) >-1)	{
			sSql = 	" select count(ProjectNo) from PROJECT_RELATIVE where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum == 0)
	     		sMessage  += "项下业务"+sObjectNo+"的"+sBusinessTypeName+"没有相关项目信息！"+"@";
		}
		
		
		//------------第二十八步：农户特色贷款检查客户是否有办理此业务的权限------------------
		AmarInterpreter interpreter = new AmarInterpreter();
		Anything aReturn1 =  interpreter.explain(Sqlca,"!BusinessManage.CheckCreditCondition("+sBusinessType+","+sCustomerID+")");
		String TempValue = aReturn1.stringValue();
		
		if(!TempValue.equals("") && !TempValue.equals("PASS"))
			sMessage  +=  TempValue+"@";
		
		//==============================协议检查=============================================
		if(!"".equals(sVouchAggreement) || !"".equals(sConstructContractNo) || !"".equals(sBuildAgreement)){
		String sSql1 = " Select SerialNo,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum," +
				 	   " BusinessCurrency, ConstructContractNo,BuildAgreement," +
					   " BusinessType,nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate) as Balance,VouchType,CustomerID,VouchAggreement " +
					   " from Business_Contract BC Where 1=1 and (FinishDate is null or FinishDate ='')  " ;
		 
		 String sSql2 = " select SerialNo,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum,CustomerID," +
				 		" BusinessCurrency,ConstructContractNo,BuildAgreement,BusinessType,VouchType,VouchAggreement" +
				 		" from Business_Apply BA " +
				 		" where exists (select 'X' from Flow_Object FO where BA.SerialNo = FO.ObjectNo and FO.ObjectType = 'CreditApply' and FO.PhaseType in ('1020','1040') )" +
				 		" and (ContractExsitFlag ='' or ContractExsitFlag is null) ";
		 
		 String sEntAgreementNo ="",sAgreeMaturity="",sParentAgreementNo="";
		 double dCompareSum =0.0,dVouchTotalSum=0.0,dTopVouchSum=0.0,dSingleSum=0.0,dEntTermMonth=0.0;
		//-----------第三十步：担保协议检查-----------------------------------------------
		if(!"".equals(sVouchAggreement)){
			 sSql = " select SerialNo,Maturity,VouchTotalSum*getERate(Currency,'01','') as VouchTotalSum," +
			 		" TopVouchSum*getERate(Currency,'01','') as TopVouchSum,TermMonth," +
			 		" nvl(SingleSum,0) as SingleSum from Ent_Agreement where AgreementType='VouchAgreement' and SerialNo ='"+sVouchAggreement+"' ";
			 rs = Sqlca.getASResultSet(sSql);
			 if(rs.next())
			 {
				 sEntAgreementNo = rs.getString("SerialNo");
				 sAgreeMaturity  = rs.getString("Maturity");
				 dVouchTotalSum = rs.getDouble("VouchTotalSum");
				 dTopVouchSum = rs.getDouble("TopVouchSum");
				 dSingleSum = rs.getDouble("SingleSum");
				 dEntTermMonth = rs.getDouble("TermMonth");
				 
				 if(sEntAgreementNo==null) sEntAgreementNo="";
				 if(sAgreeMaturity==null) sAgreeMaturity="";
			 }
			 rs.getStatement().close();
			 if(sAgreeMaturity.compareTo(sToday)<0)
			 {
				 sMessage  +=  "项下业务"+sObjectNo+"的担保协议已到期，不能使用！"+"@";
			 }else
			 {
				 sSql = sSql1+ " and VouchAggreement ='"+sVouchAggreement+"'";
				 AgreementContract = new CreditData(Sqlca,sSql);
				 sSql = sSql2+ " and VouchAggreement ='"+sVouchAggreement+"'";
				 AgreementApply = new CreditData(Sqlca,sSql);
				 
				 dAgreementBalance = AgreementContract.getSum("Balance","VouchAggreement",Tools.EQUALS,sVouchAggreement);//业务向下总余额
				 
				 dAgreementApplySum = AgreementApply.getSum("BusinessSum","VouchAggreement",Tools.EQUALS,sVouchAggreement);//在途金额
				 //个人余额
				 dCusAgreeBalance = AgreementContract.getSum("Balance","CustomerID",Tools.EQUALS,sCustomerID);
				 //个人在途
				 dCusAgreeBalance = AgreementApply.getSum("BusinessSum","CustomerID",Tools.EQUALS,sCustomerID);
				 
				 if(sAgriLoanClassify.equals("") || sAgriLoanClassify.equals("111"))//非涉农
					 dCompareSum = dVouchTotalSum-dAgreementBalance-dAgreementApplySum;
				 else
					 dCompareSum = dTopVouchSum-dAgreementBalance-dAgreementApplySum;
				 //System.out.println("dTopVouchSum:"+dTopVouchSum+"*dAgreementBalance:"+dAgreementBalance+"&dAgreementApplySum:"+dAgreementApplySum);
				 if(dBusinessSum>dCompareSum)
					 sMessage  +=  "项下业务"+sObjectNo+"的超过担保协议担保额度或者担保总额度限制！"+"@";
					 
				 dCompareSum = dSingleSum-dCusAgreeBalance-dCusAgreeBalance;
				 if(dBusinessSum>dCompareSum)
					 sMessage  +=  "项下业务"+sObjectNo+"的超过担保协议单户最高担保金额限制!"+"@";
				 
				 if(dTermMonth >dEntTermMonth )
					 sMessage  +=  "项下业务"+sObjectNo+"的超过担保协议最高融资期限限制!"+"@";
				 
			 }
		}
			//-----------第三十一步：工程机械检查-----------------------------------------------	 
			 double dCreditSum=0.0,dLimitSum=0.0,dLimitLoanTerm=0.0,dLimitLoanRatio=0.0;
			 if(!"".equals(sConstructContractNo)){
				 sSql = " select SerialNo,ObjectNo,nvl(CreditSum,0)*getERate(Currency,'01','') as CreditSum, " +
				 		" nvl(LimitSum,0)*getERate(Currency,'01','') as LimitSum ,LimitLoanTerm,LimitLoanRatio " +
				 		" from Dealer_Agreement where  SerialNo ='"+sConstructContractNo+"' ";
				 rs = Sqlca.getASResultSet(sSql);
				 if(rs.next())
				 {
					 sEntAgreementNo = rs.getString("SerialNo");
					 sParentAgreementNo = rs.getString("ObjectNo");
					 dCreditSum = rs.getDouble("CreditSum");
					 dLimitSum = rs.getDouble("LimitSum");
					 dLimitLoanTerm = rs.getDouble("LimitLoanTerm");
					 dLimitLoanRatio = rs.getDouble("LimitLoanRatio");
					 
					 if(sEntAgreementNo==null) sEntAgreementNo="";
					 if(sAgreeMaturity==null) sAgreeMaturity="";
				 }
				 rs.getStatement().close();
				 
				 sAgreeMaturity = Sqlca.getString("select Maturity from Ent_Agreement where AgreementType='ProjectAgreement' and SerialNo = '"+sParentAgreementNo+"'");
				 if(sAgreeMaturity == null) sAgreeMaturity= "";
				 if(sAgreeMaturity.compareTo(sToday)<0)
				 {
					 sMessage  +=  "项下业务"+sObjectNo+"的工程机械主协议已到期，不能使用!"+"@";
				 }else
				 {
					 sSql = sSql1+ " and ConstructContractNo ='"+sConstructContractNo+"'";
					 AgreementContract = new CreditData(Sqlca,sSql);
					 sSql = sSql2+ " and ConstructContractNo ='"+sConstructContractNo+"'";
					 AgreementApply = new CreditData(Sqlca,sSql);
					 
					
					 dAgreementBalance = AgreementContract.getSum("Balance","ConstructContractNo",Tools.EQUALS,sConstructContractNo);//业务向下总余额
					 dAgreementApplySum = AgreementApply.getSum("BusinessSum","ConstructContractNo",Tools.EQUALS,sConstructContractNo);//在途金额
					 //个人余额
					 dCusAgreeBalance = AgreementContract.getSum("Balance","CustomerID",Tools.EQUALS,sCustomerID);
					 //个人在途
					 dCusAgreeBalance = AgreementApply.getSum("BusinessSum","CustomerID",Tools.EQUALS,sCustomerID);
					 System.out.println("dCreditSum:"+dCreditSum+"%dAgreementBalance:"+dAgreementBalance+"*dAgreementApplySum:"+dAgreementApplySum);
					 dCompareSum = dCreditSum-dAgreementBalance-dAgreementApplySum;
					 if(dBusinessSum>dCompareSum)
						 sMessage  +=  "项下业务"+sObjectNo+"的超过该经销商从协议额度限制!"+"@";
						 
					 dCompareSum = dLimitSum-dCusAgreeBalance-dCusAgreeBalance;
					 if(dBusinessSum>dCompareSum)
						 sMessage  +=  "项下业务"+sObjectNo+"的超过单户经销商从协议最高额限制!"+"@";
					 
					 if(dTermMonth >dLimitLoanTerm )
						 sMessage  +=  "项下业务"+sObjectNo+"的超过经销商从协议最高贷款期限限制!"+"@";
					
					 dCompareSum = dLimitLoanRatio*dEquipmentSum;
					 if(dBusinessSum>dCompareSum)
						 sMessage  +=  "项下业务"+sObjectNo+"的超过经销商从协议最高贷款比例限制!"+"@";
					 
				 }
				 
			 }
			 
			//-----------第三十二步：楼宇按揭协议检查--------- 
			 double  dLoanSum =0.0;
			if(!"".equals(sBuildAgreement)){
					 sSql = " select SerialNo,Maturity,LoanSum*getERate(Currency,'01','') as LoanSum " +
				 		    " from Ent_Agreement where AgreementType='BuildAgreement' and SerialNo ='"+sBuildAgreement+"' ";
				 rs = Sqlca.getASResultSet(sSql);
				 if(rs.next())
				 {
					 sEntAgreementNo = rs.getString("SerialNo");
					 sAgreeMaturity  = rs.getString("Maturity");
					 dLoanSum = rs.getDouble("LoanSum");
					 
					 if(sEntAgreementNo==null) sEntAgreementNo="";
					 if(sAgreeMaturity==null) sAgreeMaturity="";
				 }
				 rs.getStatement().close();
				 if(sAgreeMaturity.compareTo(sToday)<0)
				 {
					 sMessage  +=  "项下业务"+sObjectNo+"的楼宇按揭协议已到期，不能使用!"+"@";
				 }else
				 {
					 sSql = sSql1+ " and BuildAgreement ='"+sBuildAgreement+"'";
					 AgreementContract = new CreditData(Sqlca,sSql);
					 sSql = sSql2+ " and BuildAgreement ='"+sBuildAgreement+"'";
					 AgreementApply = new CreditData(Sqlca,sSql);
					 
					 dAgreementBalance = AgreementContract.getSum("Balance","BuildAgreement",Tools.EQUALS,sBuildAgreement);//业务向下总余额
					 dAgreementApplySum = AgreementApply.getSum("BusinessSum","BuildAgreement",Tools.EQUALS,sBuildAgreement);//在途金额
					 
					 dCompareSum = dLoanSum-dAgreementBalance-dAgreementApplySum;
					 if(dBusinessSum>dCompareSum)
						 sMessage  +=  "项下业务"+sObjectNo+"的超过楼宇按揭协议总额度限制!"+"@";
						 
				 }
			}
				
				AgreementContract.closeCreditData();
				AgreementApply.closeCreditData();
		
		}
		System.out.println("sMessage:"+sMessage);
		return sMessage;
	 }
}
