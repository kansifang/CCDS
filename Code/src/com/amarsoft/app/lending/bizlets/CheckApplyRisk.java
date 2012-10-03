/*
		Author: --zywei 2005-08-05
		Tester:
		Describe: --探测申请风险
		Input Param:
				ObjectType: 对象类型
				ObjectNo: 对象编号
		Output Param:
				Message：风险提示信息
		HistoryLog: lpzhang 2009-8-24 for TJ 从检代码
*/

package com.amarsoft.app.lending.bizlets;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.GregorianCalendar;

import com.amarsoft.app.util.ChangTypeCheckOut;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.impl.tjnh_als.bizlets.CreditData;
import com.amarsoft.impl.tjnh_als.bizlets.Tools;
import com.amarsoft.impl.tjnh_als.bizlets.WhereClause;
import com.amarsoft.script.AmarInterpreter;
import com.amarsoft.script.Anything;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.DataConvert;


public class CheckApplyRisk extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//获取参数：对象类型和对象编号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
         
		ASValuePool oAgreementBusiness = new ASValuePool();
		 //协议所有合同统计数据
		CreditData AgreementContract = null;
		 //协议所有合同统计数据
		CreditData AgreementApply = null;
		
		
		//获得当前日期
		String sToday = StringFunction.getToday();
		//获得去年同期
		String sMonth = String.valueOf(Integer.parseInt(sToday.substring(0,4))-1)+sToday.substring(4,7);
		
		//半年前
		java.util.GregorianCalendar gr=new GregorianCalendar(Integer.parseInt(sToday.substring(0,4)),Integer.parseInt(sToday.substring(5,7)),Integer.parseInt(sToday.substring(8, 10)));
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	    gr.add(GregorianCalendar.MONTH,-7); //回退6个月
		String Temp = sdf.format(gr.getTime());
		
		String sMiddleYear = String.valueOf(Integer.parseInt(Temp.substring(0,4)))+"/"+Temp.substring(5,7);
		
		
		java.util.GregorianCalendar gr1=new GregorianCalendar(Integer.parseInt(sToday.substring(0,4)),Integer.parseInt(sToday.substring(5,7)),Integer.parseInt(sToday.substring(8, 10)));
	 
	    gr1.add(GregorianCalendar.DATE,30); //回30天
	    String sAfterThirDay = sdf.format(gr.getTime());
		
		
			
		//System.out.println("sMiddleYear:"+sMiddleYear); 
		 
		//定义变量：提示信息、SQL语句、产品类型、客户类型
		String sMessage = "",sSql = "",sBusinessType = "",sCustomerType = "", sBizHouseFlag = "";
		//定义变量：主要担保方式、客户代码、主体表名、关联表名
		String sVouchType = "",sCustomerID = "",sMainTable = "",sRelativeTable = "",sCustomerName = "",sNationRisk="",sCreditSmallEntFlag="";
		//定义变量：暂存标志,是否低风险,进出口经营权
		String sTempSaveFlag = "",sLowRisk = "",sHasIERight="",sRelativeAgreement="",sVouchAggreement="",sConstructContractNo="",sAgriLoanClassify="",sBuildAgreement="";
		//定义变量：发生类型、申请类型、担保人代码、变更类型
		String sOccurType = "",sApplyType = "",sGuarantorID = "",sOperateOrgID = "",sChangType = "";
		//定义变量：∑协议项下业务余额,∑协议项下审批中申请金额,∑该担保机构担保的该申请客户业务余额,∑该担保机构担保的该申请客户业务审批中申请金额
		double dAgreementBalance=0.0,dAgreementApplySum=0.0,dCusAgreeBalance=0.0,dCusAgreeApplySum=0.0,dTermMonth=0.0;
		
		//定义变量：业务金额,设备购买金额
		double dBusinessSum = 0.0,dEquipmentSum=0.0,dTermDay=0.0,dSmallEntSum=0.0,dBusinessSum1=0.0; 
		//定义变量：票据张数,实际控制人（高管）数
		int iBillNum = 0,iNum = 0,iCount = 0;
		//定义变量：查询结果集
		ASResultSet rs = null,rs1 = null;	
		
		String sBusinessCurrency = "" ,sRateFloatType = "" ,sBaseRateType="",sBailCurrency="",sDrawingType="",sCorpusPayMethod="",sInputOrgID="";
		double dBaseRate=0.0 ,dBailSum = 0.0,dBailRatio = 0.0 ,dPdgRatio = 0.0 ,dPdgSum = 0.0,dRateFloat=0.0,dBusinessRate=0.0;
		String sSmallEntFlag="",sSetupDate="",sAgriLoanFlag = "";
		
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
			sSql = 	" select TempSaveFlag,BusinessSum*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum,BusinessSum as BusinessSum1,BusinessType,BillNum,nvl(TermMonth,0) as TermMonth,nvl(TermDay,0) as TermDay , "+
					" VouchType,CustomerID,getCustomerType(CustomerID) as CustomerType,LowRisk,OccurType,ApplyType,RelativeAgreement,VouchAggreement,ConstructContractNo,AgriLoanClassify,AgriLoanFlag, " +
					" EquipmentSum*getERate(BusinessCurrency,'01',ERateDate) as EquipmentSum,BuildAgreement,CustomerName, "+
					" BusinessCurrency,RateFloatType,BaseRateType,BailCurrency,BaseRate,BailSum,BailRatio,PdgRatio,PdgSum,RateFloat,BusinessRate,NationRisk, "+
					" DrawingType,CorpusPayMethod,InputOrgID,OperateOrgID "+
					" from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			while (rs.next()) { 			
				sTempSaveFlag = rs.getString("TempSaveFlag");	 
				dBusinessSum = rs.getDouble("BusinessSum");		
				dBusinessSum1 = rs.getDouble("BusinessSum1");	
				sBusinessType = rs.getString("BusinessType");
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
				sInputOrgID = rs.getString("InputOrgID");
				sOperateOrgID = rs.getString("OperateOrgID");
				sAgriLoanFlag = rs.getString("AgriLoanFlag");
				//将空值转化成空字符串
				if (sTempSaveFlag == null) sTempSaveFlag = "";				
				if (sBusinessType == null) sBusinessType = "";
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
				if(sInputOrgID == null) sInputOrgID = "";
				if(sOperateOrgID == null) sOperateOrgID ="";
				if(sAgriLoanClassify == null) sAgriLoanClassify = "";
				if(sAgriLoanFlag == null) sAgriLoanFlag ="";
				if (sTempSaveFlag.equals("1")) {			
					sMessage = "申请基本信息为暂存状态，请先填写完申请基本信息并点击保存按钮！"+"@";
												
				}			
			}
			rs.getStatement().close();
		}
		
		
		//--------------第二步：检查客户概况是否全部输入---------------	
		if (sCustomerType.length()>1&&sCustomerType.substring(0,2).equals("01")){ //公司客户
			
			sSql = "select SmallEntFlag,SetupDate,TempSaveFlag from ENT_INFO where  CustomerID ='"+sCustomerID+"'";
			rs= Sqlca.getASResultSet(sSql);
			if(rs.next()){
				sSmallEntFlag = rs.getString("SmallEntFlag");
				sSetupDate = rs.getString("SetupDate");
			}
			rs.getStatement().close();
			if(sSmallEntFlag == null || "NULL".equals(sSmallEntFlag)) sSmallEntFlag ="";
			if(sSetupDate == null || "NULL".equals(sSetupDate)) sSetupDate ="";
			//取该客户对应 实际控制人（高管）信息条数
			iCount = Integer.parseInt(Sqlca.getString("select count(*) from CUSTOMER_RELATIVE where RelationShip = '0109' and CustomerID = '"+sCustomerID+"'"));
			if(iCount<1)
			{
				sMessage += "客户高管信息中必须录入担任职务为实际控制人信息！"+"@";
			}		
		}
		if (sCustomerType.length()>1&&sCustomerType.substring(0,2).equals("03")) //相关个人
			sSql = " select TempSaveFlag from IND_INFO where CustomerID = '"+sCustomerID+"' ";
		
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sTempSaveFlag = rs.getString("TempSaveFlag");
		}
		rs.getStatement().close();
		
		if (sTempSaveFlag == null) sTempSaveFlag = "";
		if (sTempSaveFlag.equals("1"))
			sMessage += "客户概况信息为暂存状态！请先填写完客户概况信息并点击保存按钮！"+"@";
		
		//--------------更新客户经理的审批意见--------------	
		Sqlca.executeSQL(" update FLOW_OPINION SET BusinessCurrency ='"+sBusinessCurrency+"',BusinessSum = "+dBusinessSum1+","+
				 " TermMonth = "+dTermMonth+",TermDay = "+dTermDay+",BaseRateType = '"+sBaseRateType+"',CustomerName = '"+sCustomerName+"',"+
				 " RateFloatType = '"+sRateFloatType+"',RateFloat="+dRateFloat+",BailCurrency = '"+sBailCurrency+"',"+
				 " BusinessRate = "+dBusinessRate+",BailRatio="+dBailRatio+",BailSum = "+dBailSum+","+
				 " PdgRatio = "+dPdgRatio+",PdgSum = "+dPdgSum+",BaseRate = "+dBaseRate+
				 " where SerialNo = "+
				 " (select SerialNo from  FLOW_TASK where ObjectNo = '"+sObjectNo+"' and ObjectType ='CreditApply'  order by SerialNo desc fetch first 1 rows only)" );
		
		if(sBusinessType.endsWith("3015"))//同业授信
		{
			return sMessage ;
		}
		
		if("3010,3040,3050,3060,3015".indexOf(sBusinessType) > -1){
			String sCreditLineID = Sqlca.getString(" select LineID from CL_INFO where ApplySerialNo = '"+sObjectNo+"' and  (ParentLineID ='' or ParentLineID is null) ");
			if(sCreditLineID == null) sCreditLineID ="";
			
			double dLineSum = Sqlca.getDouble("select sum(Nvl(LineSum1,0)*getERate(Currency,'01',ERateDate)) from CL_INFO where ParentLineID = '"+sCreditLineID+"'").doubleValue();
			if(Math.abs((dLineSum-dBusinessSum))>1){
				sMessage  += "授信额度与已分配的额度总和不相等，请重新分配额度！"+"@";
			}
			if("3050".equals(sBusinessType)){
				sSql = "select count(*) from CUSTOMER_RELATIVE where RelationShip like '0501%'and CustomerID='"+sCustomerID+"'";
				rs = Sqlca.getASResultSet(sSql);
				int NumTemp=0;
				if(rs.next())
					 NumTemp = rs.getInt(1);
				rs.getStatement().close();
				if(NumTemp < 5)
				{	
					sMessage += "该客户所在农户联保小组成员未达到5个，不能办理此业务！"+"@";
				}
			}	
		}
		if(sLowRisk == null || sLowRisk.equals(""))
		{
			Sqlca.executeSQL("update Business_Apply set LowRisk ='0' where SerialNo = '"+sObjectNo+"' ");
		}
		if("IndependentApply".equals(sApplyType))//针对单笔
		{
			Sqlca.executeSQL("update Business_Apply set LowRisk ='0' where SerialNo = '"+sObjectNo+"' ");
			//当“主要担保方式”为“我行人民币存单质押”或“中央政府债券质押”时
			if("0401010".equals(sVouchType)||"0402010".equals(sVouchType))
			{
				Sqlca.executeSQL("update Business_Apply set LowRisk ='1' where SerialNo = '"+sObjectNo+"' ");
			}		
		
			//当“主要担保方式”为“100%保证金”,判断额度分配业务是否有不属于低风险业务品种“提货担保”、“银行承兑汇票”、
			//“进口信用证”、“非融资性保函（包括投标保函、履约保函、预付款保函、付款保函、维修保函、其他特殊保函）”、
			//“出口信用证押汇”、“出口信用证贴现”、“委托贷款”
			if("0105080".equals(sVouchType)&&"2050010,2010,2050030,2040010,2040020,2040030,2030060,2040050,2040110".indexOf(sBusinessType)>-1)
			{
				Sqlca.executeSQL("update Business_Apply set LowRisk ='1' where SerialNo = '"+sObjectNo+"' ");
			}
			//------出口信用证押汇,出口信用证贴现直接设置为低风险业务---------
			if( "1080030".equals(sBusinessType)||"1080035".equals(sBusinessType))
			{
				Sqlca.executeSQL("update Business_Apply set LowRisk ='1' where SerialNo = '"+sObjectNo+"' ");
			}
		}
		//------保易贷,委托贷款直接设置为低风险业务---------
		if(sNationRisk.equals("1") || "1140110".equals(sBusinessType)|| "2070".equals(sBusinessType) ||"2110040".equals(sBusinessType))
		{
			Sqlca.executeSQL("update Business_Apply set LowRisk ='1' where SerialNo = '"+sObjectNo+"' ");
		}
		//判断该笔申请是否是1、业务品种为“公积金组合贷款”&&2、发生类型为“变更”&&3、变更类型为“借款人变更”
		//如果符合上述条件不校验担保信息-----------------------------------------add by wangdw
		if(ChangTypeCheckOut.getInstance().changtypecheckout_gjj(Sqlca, sMainTable, sObjectNo))
		{
			//判断判断该笔申请是否是1、业务品种为“非公积金组合贷款”&&2、发生类型为“变更”&&3、变更类型为“非担保变更”
			//如果符合上述条件不校验担保信息-----------------------------------------add by wangdw 2012-06-01
			if(ChangTypeCheckOut.getInstance().changtypecheckout_isnotgjj(Sqlca, sMainTable, sObjectNo))
			{	
			//--------------第三步：检查担保信息是否全部输入---------------
			//假如业务基本信息中的主要担保方式为信用，则判断是否输入担保信息，如果输入了担保信息给出提示
			if (sVouchType.equals("005")) {
				sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
						" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType='GuarantyContract') "+
						" having count(SerialNo) > 0";

				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()) 
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum > 0)
					sMessage  += "在业务中选择的主要担保方式为信用，不应该输入担保信息！请调整主要担保方式或删除担保信息！"+"@";
			}
			//假如业务基本信息中的主要担保方式为保证、或抵押、或质押，则判断是否输入担保信息,短期出口信用保险融资，
			//出口票据贴现，出口信用证押汇,福费廷取消该控制
			else if(!"1080030".equals(sBusinessType)&&!"1080035".equals(sBusinessType)
					&&!"1080055".equals(sBusinessType)&&!"1080060".equals(sBusinessType)) 
			{
				if(sVouchType.length()>=3) {
					//假如业务基本信息中的主要担保方式为保证,必须输入保证担保信息
					if(sVouchType.substring(0,3).equals("010") && !sVouchType.equals("0105080"))
					{
						//检查担保合同信息中是否存在保证担保
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '010%' having count(SerialNo) > 0 ";
						rs = Sqlca.getASResultSet(sSql);
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						
						if(iNum == 0)
							sMessage  += "在业务中选择的主要担保方式为保证，可没有输入与保证有关的担保信息！请调整主要担保方式或输入保证担保信息！"+"@";
					}
					
					//假如业务基本信息中的主要担保方式为抵押,必须输入抵押担保信息，并且还需要有相应的抵押物信息
					if(sVouchType.substring(0,3).equals("020"))	{
						//检查担保合同信息中是否存在抵押担保
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '050%' ";
						rs = Sqlca.getASResultSet(sSql);
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						
						if(iNum <= 0)
							sMessage  += "在业务中选择的主要担保方式为抵押，可没有输入与抵押有关的担保信息！请调整主要担保方式或输入抵押担保信息！"+"@";
						else {							
							sSql = " select SerialNo from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from APPLY_RELATIVE where "+
						       " SerialNo= '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and GuarantyType in ('050')";
							rs = Sqlca.getASResultSet(sSql);
							while(rs.next()) //循环判断每个抵押合同
							{
								String sGCNo =  rs.getString("SerialNo");  //获得担保合同流水号
								
								String sSql1 = " select Count(GuarantyID) from GUARANTY_INFO "+
								       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType='"+sObjectType+"'"+
								       " and ObjectNo ='"+sObjectNo+"' and ContractNo = '"+sGCNo+"') "; 
								rs1 = Sqlca.getASResultSet(sSql1);
								if(rs1.next())
								{
									iNum = rs1.getInt(1); 
								}
								rs1.getStatement().close();
								//判断担保合同项下是否有对应的
								if (iNum <= 0)
								{
								    sMessage += "担保信息编号为:"+sGCNo+"的担保信息项下无对应的抵押信息！@";
								}
						     }
						     rs.getStatement().close();
						}												
					}
					
					//假如业务基本信息中的主要担保方式为质押,必须输入质押担保信息，并且还需要有相应的质物信息
					if(sVouchType.substring(0,3).equals("040"))	{
						//检查担保合同信息中是否存在质押担保
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '060%' ";
						rs = Sqlca.getASResultSet(sSql);
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						if(iNum <= 0)								
							sMessage  += "在业务中选择的主要担保方式为质押，可没有输入与质押有关的担保信息！请调整主要担保方式或输入质押担保信息！"+"@";
						else {
							sSql = " select SerialNo from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from APPLY_RELATIVE where "+
						       " SerialNo= '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and GuarantyType in ('060')";
							rs = Sqlca.getASResultSet(sSql);
							while(rs.next()) //循环判断每个质押合同
							{
								String sGCNo =  rs.getString("SerialNo");  //获得担保合同流水号
								String sSql1 = " select Count(GuarantyID) from GUARANTY_INFO "+
								       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType='"+sObjectType+"'"+
								       " and ObjectNo ='"+sObjectNo+"' and ContractNo = '"+sGCNo+"') "; 
								rs1 = Sqlca.getASResultSet(sSql1);
								if(rs1.next())
								{
									iNum = rs1.getInt(1); 
								}
								rs1.getStatement().close();
								//判断担保合同项下是否有对应的
								if (iNum <= 0)
								{
								    sMessage+= "担保信息编号为:"+sGCNo+"的担保信息项下无对应的质押信息！@";
								}
						     }
						     rs.getStatement().close();
						}						
					}	
				}
			}
			}	
		}
		
		
		//--------------第四步：检查贴现业务和其票据业务信息一致---------------
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
					sMessage  += "业务金额和票据金额总和不符！"+"@";
				
				sSql = 	" select count(SerialNo) from BILL_INFO  where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' "+
						" having count(SerialNo) = "+iBillNum+" ";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()) 
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum == 0)
					sMessage += "业务中输入的票据张数和输入的票据张数不符！"+"@";					
			}					
		}
		
		//--------------第五步：检查是否生成调查报告---------------	
		
		if(!"DependentApply".equals(sApplyType) && !"1".equals(sSmallEntFlag) && !("1140130,1150060,1150050,1054,1056".indexOf(sBusinessType) > -1)){		
			sSql = "select count(SerialNo),DocID from FORMATDOC_DATA where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' group by DocID";
			rs = Sqlca.getASResultSet(sSql);
			String sDocID = "";
			if(rs.next()){
				iNum = rs.getInt(1);
				sDocID = rs.getString(2);
				if(sDocID == null) sDocID = "";
			}
			rs.getStatement().close(); 
			if(iNum == 0)
				sMessage  += "没有填写调查报告信息！"+"@";
			else{
				String sFileName = "";
				sSql=" select SerialNo,SavePath from Formatdoc_Record where ObjectType='"+sObjectType+"' and  ObjectNo='"+sObjectNo+"' and DocID ='"+sDocID+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{
					sFileName = rs.getString("SavePath");
				}
				rs.getStatement().close();
				if(sFileName==null) sFileName="";
				
				java.io.File file = new java.io.File(sFileName);
			    if(!file.exists())
			    	sMessage  += "没有生成调查报告信息！"+"@";
			}
		}	
		double dNum = Sqlca.getDouble(" select count(*) from  CUSTOMER_SPECIAL  where SectionType ='70' and CustomerId = '"+sCustomerID+"'  "+
									  " and '"+StringFunction.getToday()+"' >= BeginDate and EndDate >= '"+StringFunction.getToday()+"' and InListStatus = '1'").doubleValue();
		if(dNum>0)//特殊客户
		{
			return sMessage ;
		}
		
		//--------------第六步：检查是否有关键人信息--------------- 	
		if (sCustomerType.length()>1&&sCustomerType.substring(0,2).equals("01")) //公司客户
		{
		    sSql = " select Count(CustomerID) from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' "+
		           " and RelationShip like '01%'";
		   	rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    	iNum = rs.getInt(1);
		    rs.getStatement().close();
		    
			if(iNum == 0)
		    	sMessage  += "没有输入关键人信息！"+"@";
		}
		
		//--------------第七步：检查是否有股东信息--------------- 
		if (sCustomerType.length()>1&&sCustomerType.substring(0,2).equals("01")&&!sCustomerType.equals("0104")) //公司客户
		{
			sBizHouseFlag = Sqlca.getString("select BizHouseFlag from ent_info where customerid = '"+sCustomerID+"'");
			if(sBizHouseFlag == null) sBizHouseFlag = "";
			if(!"1".equals(sBizHouseFlag))
			{	
				sSql = 	" select Count(CustomerID) from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' "+
						" and RelationShip like '52%' ";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum == 0)
					sMessage  += "没有输入股东信息！"+"@";
			}	
		}
		
		//--------------第八步：检查是否有申请人半年内信用等级评定---------------
		//1.事业单位管理模式为“非企业化单位的事业单位”、企业成立日期小于一年的公司客户、低风险业务除外。
		//2.办理农户小额信用贷款，必须首先进行农户信用评级，评级后才能进行业务申请
		if(sCustomerType.startsWith("03") && ("1150010,1150050,1150060,1140130,1150020,1140080".indexOf(sBusinessType)) <0 )//个人、农户小额信用贷款
		{
			sSql =  " select Count(SerialNo) from EVALUATE_RECORD where ObjectType = 'Customer' "+
        			" and ObjectNo = '"+ sCustomerID +"' and EvaluateResult is not null ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
				iNum = rs.getInt(1);
			rs.getStatement().close();
			if(iNum == 0)
				sMessage  += "申请人没有进行过信用等级评估！"+"@";   
		}
	/*	modify by xhyong 2009/12/28 公司不需要验证信用等级评估信息
		//企业成立日期，管理模式
		String sSetupDate ="",sManageMode="";
		if(!sCustomerType.startsWith("03"))
		{
			sSql = "select SetupDate,ManageMode from ENT_INFO where CustomerID = '"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sSetupDate = rs.getString("SetupDate");
				sManageMode = rs.getString("ManageMode");
				if(sSetupDate == null) sSetupDate ="";
				if(sManageMode == null) sManageMode ="";
			}
			rs.getStatement().close();
			if(!"1".equals(sLowRisk) && !"010".equals(sManageMode) &&  (sMonth.compareTo(sSetupDate) >0) )//事业单位管理模式为“非企业化单位的事业单位”、企业成立日期小于一年的公司客户、低风险业务除外。
			{
				sSql =  " select Count(SerialNo) from EVALUATE_RECORD where ObjectType = 'Customer' "+
	        	" and ObjectNo = '"+ sCustomerID +"' and EvaluateResult is not null "+
	        	" and AccountMonth >= '"+sMiddleYear+"' ";
			   	rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum == 0)
					sMessage  += "申请人最近半年内没有进行过信用等级评估！"+"@";   
				
			}
			
		}
		end modify
	*/
		
		//--------------第九步：检查保证人的客户概况是否完整---------------
	    if(sVouchType.length()>=3) {
			//假如业务基本信息中的主要担保方式为保证,则查询出保证人客户代码
			if(sVouchType.substring(0,3).equals("010"))
			{
				sSql = 	" select GuarantorID from GUARANTY_CONTRACT where SerialNo in "+
						" (select ObjectNo from "+ sRelativeTable +" where SerialNo = "+
						" '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and "+
						" GuarantyType like '010%' ";
				rs = Sqlca.getASResultSet(sSql);
	        	while(rs.next())
	        	{
	            	sGuarantorID = rs.getString("GuarantorID");
	            	if(sGuarantorID==null) sGuarantorID="";
	            	if("".equals(sGuarantorID))
	            	{
	            		sMessage  += "担保合同中的保证人信息不完善,请从担保详情中引入对应的客户！"+"@";
	            	}
	            	String sGuarantorCustomerName="";//保证人名称
	            	//查询担保客户类型
	            	String sGuarantorCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID='"+sGuarantorID+"'");
	            	//根据查询得出的保证人客户代码，查询他们的客户概况是否录入完整
	            	if(sGuarantorCustomerType.length()>1&&sGuarantorCustomerType.substring(0,2).equals("03"))//个人
	            	{
		            		sSql =  " select getCustomerName(CustomerID)  from IND_INFO where "+
		            				" CustomerID = '"+sGuarantorID+"' "+
		            				" and TempSaveFlag <> '2' ";
	            	}else
	            	{
							sSql =  " select  getCustomerName(CustomerID) from ENT_INFO where "+
									" CustomerID = '"+sGuarantorID+"' "+
									" and TempSaveFlag <> '2' ";
	            	}
	            	
	            	//System.out.println("sql:"+sSql);
					rs1 = Sqlca.getASResultSet(sSql);
		        	if(rs1.next())
		        		sGuarantorCustomerName = rs1.getString(1);
		        	rs1.getStatement().close();
		        	if(sGuarantorCustomerName==null)sGuarantorCustomerName = "";
					if(!"".equals(sGuarantorCustomerName))
		        		sMessage  += "保证人["+sGuarantorCustomerName+"]的概况信息为暂存状态！请先填写完客户概况信息并点击保存按钮！"+"@";
				}
				rs.getStatement().close();					
			}
		}
		    
		//--------------第十步：检查客户是否在黑名单上---------------
		sSql = 	" select count(SerialNo) from CUSTOMER_SPECIAL where CustomerID = '"+sCustomerID+"' "+
				" and InListStatus = '1' and InListReason is not null and (EndDate >='"+sToday+"' or EndDate is null)";
		
		rs = Sqlca.getASResultSet(sSql);
	    if(rs.next())
	    	iNum = rs.getInt(1);
	    rs.getStatement().close();
	    
		if(iNum > 0 && sOccurType.equals("010"))//新增
	    	sMessage  += "该客户被列入黑名单，不能进行新增业务！"+"@";
				 
		//--------------第十一步：检查客户是否在灰名单上---------------
		sSql = 	" select count(SerialNo) from CUSTOMER_SPECIAL where CustomerID = '"+sCustomerID+"' "+
				" and specialtype='020'  ";
		rs = Sqlca.getASResultSet(sSql);
	    if(rs.next())
	    	iNum = rs.getInt(1);
	    rs.getStatement().close();
	    
		if(iNum > 0)
	    	sMessage  += "该客户被列入灰名单！"+"@"; 

		//------------第二十七步：微小企业只能办理流动资金贷款、银行承兑汇票贴现、银行承兑汇票业务 并且提款方式为一次性提款、还款方式为按月或按季还款--------------
		if(sCustomerType.startsWith("01"))
		{
			if(sSmallEntFlag.equals("1"))
			{
				double days  = Sqlca.getDouble("select  days(current date) - days(date('"+sSetupDate.replaceAll("/", "-")+"'))  as days from (values 1) as a").doubleValue();
				System.out.println(days);
				if(!(sBusinessType.startsWith("1010") || sBusinessType.equals("1020010") || sBusinessType.equals("2010") || sBusinessType.equals("3010")))
				{
					sMessage  += "该客户不能办理此业务!"+"@";
				}
				if(days<365){
					sMessage  += "该客户经营期限必需大于等于1年!"+"@";
				}
				if(sBusinessType.startsWith("1010")){
					if(!("01".equals(sDrawingType))){
						sMessage  += "该业务的提款方式必需为一次性提款!"+"@";
					}
					if(!("1".equals(sCorpusPayMethod)||"2".equals(sCorpusPayMethod)||"3".equals(sCorpusPayMethod))){
						sMessage  += "该业务的还款方式必需一次性还款、按月还款或按季还款!"+"@";
					}
				}
				if("1020010".equals(sBusinessType)){
					if(!("2".equals(sCorpusPayMethod)||"3".equals(sCorpusPayMethod))){
						sMessage  += "该业务的还款方式必需按月还款或按季还款!"+"@";
					}
				}
				
			}
			
		}
		
		//--------------第十二步：是否进行了风险度评估,并且风险度评估项是否取最新数据---------------
		if((!sBusinessType.startsWith("30") || sBusinessType.equals("3040")) &&  ("2110040,2070,1150020,1150010,1140030,1140110,1110027,1140080".indexOf(sBusinessType)) < 0  && !"1".equals(sNationRisk) && !("1".equals(sSmallEntFlag) && sCustomerType.startsWith("01")))
		{
			//取得申请各项值
			double dTermMonth1 =0.0; 
			String sVouchResult ="",sEvaluateResult="";
			sSql = " select BA.VouchType,TermMonth, CL.Attribute3 "+
				   " from Business_Apply BA ,Code_library CL where BA.VouchType =CL.ItemNo and CL.CodeNo='VouchType' and BA.SerialNo = '"+sObjectNo+"'" ;
	
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sVouchResult = rs.getString("VouchType");//担保方式
				dTermMonth1 = rs.getDouble("TermMonth");//贷款期限
				if(sVouchResult == null) sVouchResult = ""; 
				
			}
			rs.getStatement().close();
			
			//取得客户信用等级值,如果客户类型03开头则为个人客户
			String sTableName = Sqlca.getString("select (case when locate('03',CustomerType) = 1 then 'IND_INFO' else 'ENT_INFO' end) as TableName from Customer_Info where CustomerID ='"+sCustomerID+"'");
			//本行即期评级 
			sSql = "select CreditLevel from "+sTableName+" where CustomerID ='"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sEvaluateResult = rs.getString("CreditLevel"); //评级结果
				if(sEvaluateResult == null) sEvaluateResult = ""; 
			}
			rs.getStatement().close();

			//如果即期评级为空取当前系统最近一年末(对公)或者最近一期(个人)的评估结果
			if("".equals(sEvaluateResult))
			{
				if(sCustomerType.startsWith("03"))//个人
				{
					sSql = "select EvaluateResult "+
					" from EVALUATE_RECORD R "+
					" where ObjectType = 'Customer' "+
					" and ObjectNo = '"+sCustomerID+"'  order by AccountMonth desc fetch first 1 rows only";
				}else//对公
				{
					sSql = "select EvaluateResult "+
					" from EVALUATE_RECORD R "+
					" where ObjectType = 'Customer' "+
					" and AccountMonth like '%/12' "+
					" and ObjectNo = '"+sCustomerID+"'  order by AccountMonth desc fetch first 1 rows only";
				}
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{
					sEvaluateResult = rs.getString("EvaluateResult"); //评级结果
					if(sEvaluateResult == null) sEvaluateResult = ""; 	
				}
				rs.getStatement().close();
			}
			
			sSql = "select VouchResult,TermNum,EvaluateResult,RiskEvaluate from Risk_Evaluate where ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				String pVouchResult = rs.getString("VouchResult"); //担保方式
				double dTermNum = rs.getDouble("TermNum"); //担保方式
				String pEvaluateResult = rs.getString("EvaluateResult"); //担保方式
				double pRiskEvaluate = rs.getDouble("RiskEvaluate");
				if(pVouchResult == null) pVouchResult = ""; 
				if(pEvaluateResult == null) pEvaluateResult = ""; 
				//评估项原数据产生了变化
				if(sCustomerType.startsWith("03"))
				{
					if(!(pVouchResult.equals(sVouchResult) && pEvaluateResult.equals(sEvaluateResult)))
					{
						sMessage  += "风险度评估原数据产生了变化，请重新进行风险度评估！"+"@";
					}
				}else{
					if(sBizHouseFlag.equals("1") && sVouchType.equals("005")){
						if(pRiskEvaluate != 1){
							sMessage  += "风险度评估原数据产生了变化，请重新进行风险度评估！"+"@";
						}
					}
					else if(!(pVouchResult.equals(sVouchResult) && dTermNum==dTermMonth1 &&pEvaluateResult.equals(sEvaluateResult)))
					{
						sMessage  += "风险度评估原数据产生了变化，请重新进行风险度评估！"+"@";
					}
				}
			}else
			{
				sMessage  += "没有进行风险度评估！"+"@";
			}
			rs.getStatement().close();
		
		}
		//--------------第十三步：信用证项下打包贷款，出口信用证打包贷款、出口信用证押汇与贴现（取消控制）、出口托收押汇与贴现、出口商业发票融资、检查相关信用证信息---------------1080020,1080080,1080090,1080030,1080035
		if (sBusinessType.equals("1080020") || sBusinessType.equals("1080080") ||sBusinessType.equals("1080090")||sBusinessType.equals("1080030") ||sBusinessType.equals("1080035"))	{
			sSql = 	" select count(SerialNo) from LC_INFO where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum == 0)
	     		sMessage  += "出口托收押汇与贴现、出口商业发票融资或信用证相关业务，没有相关信用证信息！"+"@";
		}

		//--------------第十四步：托收项下打包贷款、合同项下打包贷款，检查相关贸易合同信息---------------
		if (sBusinessType.equals("1080020") || sBusinessType.equals("1080010")) {
			sSql = 	" select count(SerialNo) from CONTRACT_INFO where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum == 0)			     	
	     		sMessage  += "出口合同打包贷款或出口信用证打包贷款业务，没有相关贸易合同信息！"+"@";
		}

		//--------------第十五步：进口保理、出口保理，检查相关发票信息---------------
		if (sBusinessType.equals("1090020") ||  sBusinessType.equals("1090030")) {
			sSql = 	" select count(SerialNo) from INVOICE_INFO where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum == 0)			     	
	     		sMessage  += "进口保理业务或出口保理业务，没有相关发票信息！"+"@";
		}
		
		//--------------是否有进出口经营权---------------
		if (sBusinessType.substring(0, 4).equals("1080"))
		{
		sSql = "select HasIERight from ENT_INFO where CustomerID = '"+sCustomerID+"' ";
		rs = Sqlca.getASResultSet(sSql);
	    if(rs.next())
	    	sHasIERight = rs.getString("HasIERight");
	    rs.getStatement().close();
	    if(sHasIERight==null) sHasIERight="";
		if(sHasIERight.equals("2"))
	   		sMessage  += "无进出口经营权！"+"@";
		}

		//--------------第十六步：是否存在交叉贷款--------------- 
		if(!sBusinessType.equals("3015") && sOccurType.equals("010")&&!sBusinessType.equals("2070")&&!sBusinessType.equals("2110040")&&!"918010100".equals(sInputOrgID))//不为同业，且为新发生 且不为委托贷款
		{
			sSql = "select count(distinct ManageOrgID) from BUSINESS_CONTRACT where CustomerID = '"+sCustomerID+"' " +
					" and (FinishDate is null or FinishDate='') " +
					" and  ((Maturity >='"+StringFunction.getToday()+"' and BusinessType like '3%')" +
					" or BusinessType not like '3%') and ManageOrgid<>'"+sOperateOrgID+"' and ManageOrgid <> '918010100' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    	iNum = rs.getInt(1);
		    rs.getStatement().close();
		    
			if(iNum > 0)
		   		sMessage  += "该申请人在本行存在交叉贷款信息！"+"@";
		}
		
		//--------------第十七步：是否存在不良记录---------------
		sSql = 	" select count(SerialNo) from BUSINESS_CONTRACT where " +
				"(nvl(OverDueBalance,0)+nvl(DullBalance,0)+nvl(BadBalance,0)+nvl(InterestBalance1,0)+nvl(InterestBalance2,0))> 0 "+
				" and CustomerID = '"+sCustomerID+"' ";
		rs = Sqlca.getASResultSet(sSql);
	    if(rs.next())
	    	iNum = rs.getInt(1);
	    rs.getStatement().close();
	    
		if(iNum > 0 && sOccurType.equals("010")){//新增
    		sMessage  += "该申请人在本行存在不良记录，不能新增业务！"+"@";
		}
		else if(iNum < 1 && sOccurType.equals("010")){
			String sMFCustomerID = Sqlca.getString("select MFCustomerID from Customer_Info where CustomerID = '"+sCustomerID+"'");
			sSql = 	" select count(SerialNo) from BUSINESS_DUEBILL where " +
					"(nvl(OverDueBalance,0)+nvl(DullBalance,0)+nvl(BadBalance,0)+nvl(InterestBalance1,0)+nvl(InterestBalance2,0)) > 0 "+
					" and MFCustomerID = '"+sMFCustomerID+"' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    	iNum = rs.getInt(1);
		    rs.getStatement().close();
			if(iNum > 0)//新增
	    		sMessage  += "该申请人在本行存在不良记录，不能新增业务！"+"@";
		}
		//--------------第十八步：展期业务是否与当前申请关联---------------
		//发生类型为展期，需关联待展期原业务信息
		if(sOccurType.equals("015"))
		{
			String BDSerialNo ="";
			//按照合同展期
			//sSql = 	" select count (SerialNo) from APPLY_RELATIVE "+
			//		" where SerialNo = '"+sObjectNo+"' " +
			//		" and ObjectType = 'BusinessContract' ";
			//按照借据展期
			sSql = 	" select ObjectNo from APPLY_RELATIVE "+
					" where SerialNo = '"+sObjectNo+"' " +
					" and ObjectType = 'BusinessDueBill' ";
			rs = Sqlca.getASResultSet(sSql);
			 if(rs.next())
		    {
		    	BDSerialNo = rs.getString("ObjectNo");
		    	if(BDSerialNo == null) BDSerialNo ="";
		    	
		    }
		    else
		    {
		    	sMessage  += "该业务申请没有关联待展期的原借据！"+"@";
		    }
		    rs.getStatement().close();
		    

	    	//原借据信息
		    if(!BDSerialNo.equals(""))
		    {
		    	String BDMaturity ="",BDPutOutDate="";
		    	
		    	sSql = " select count(*) from Business_Apply BA where RelativeAgreement ='"+BDSerialNo+"' and OccurType ='015'" +
		    		   " and  exists (select 'X' from Flow_Object FO where FO.ObjectNo =BA.SerialNo and FO.ObjectType = 'CreditApply' and FO.PhaseType <> '1050')";
		    	rs = Sqlca.getASResultSet(sSql);
		    	if(rs.next())
			    	iNum = rs.getInt(1);
			    rs.getStatement().close();
			    
			    if(iNum >0)
			    {
			    	sMessage  += "发生展期的借据已经发生了展期业务，不能再次发生展期业务！"+"@";
			    }else
			    {
			    	sSql = " select nvl(balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate) as Balance,PutOutDate,Maturity, " +
			    		   " (nvl(InterestBalance1,0)+nvl(InterestBalance2,0)) as InterestBalance" +
			    		   " from Business_Duebill where SerialNo='"+BDSerialNo+"'";
			    	rs = Sqlca.getASResultSet(sSql);
			    	if(rs.next())
			    	{ 
			    		double dInterestBalance = rs.getDouble("InterestBalance");
			    		BDMaturity = rs.getString("Maturity");
			    		BDPutOutDate = rs.getString("PutOutDate");
			    		if(BDMaturity == null) BDMaturity="";
			    		if(BDPutOutDate == null) BDPutOutDate="";
			    		
			    		if(sAfterThirDay.compareTo(BDMaturity)>0)
			    		{
			    			sMessage  += "已经超过借据到期前30天，不能发生展期业务！"+"@";
			    		}
			    		if(dInterestBalance>0)
			    		{
			    			sMessage  += "该借据存在欠息，不能发生展期业务！"+"@";
			    		}
			    		
			    	}
			    	rs.getStatement().close();
			    	
			    	//不能超过原贷款的期限控制
			    	java.util.Calendar  calender1 = new GregorianCalendar(Integer.parseInt(BDPutOutDate.substring(0,4)),Integer.parseInt(BDPutOutDate.substring(5,7)),Integer.parseInt(BDPutOutDate.substring(8, 10)));
			    	java.util.Calendar  calender2 = new GregorianCalendar(Integer.parseInt(BDMaturity.substring(0,4)),Integer.parseInt(BDMaturity.substring(5,7)),Integer.parseInt(BDMaturity.substring(8, 10)));
			    	double  diff   =   (double) ((calender2.getTimeInMillis()-calender1.getTimeInMillis())/1000/60/60/24);
			    	System.out.println("diff:"+diff); 
			    	if(diff>365) 
			    	{
				    	if((dTermMonth*30+dTermDay)*2 > diff)
				    	{
				    		sMessage  += "超过展期最大期限！"+"@";
				    	}
			    	}else
			    	{
			    		if(dTermMonth*30+dTermDay > diff)
				    	{
				    		sMessage  += "超过展期最大期限！"+"@";
				    	}
			    	}
			    	
			    }
			    
		    }
		    
			
		}
		
		//--------------第十九步：借新还旧业务是否与当前申请关联---------------		
		//发生类型为借新还旧，需关联借新还旧业务信息
		if(sOccurType.equals("020"))
		{
			//按照合同借新还旧
			//sSql = 	" select count (SerialNo) from APPLY_RELATIVE "+
			//		" where SerialNo = '"+sObjectNo+"' " +
			//		" and ObjectType = 'BusinessContract' ";
			//按照借据借新还旧
			String BDSerialNo ="";
			String sBDSerialNo= "";
			sSql = 	" select ObjectNo from APPLY_RELATIVE "+
					" where SerialNo = '"+sObjectNo+"' " +
					" and ObjectType = 'BusinessDueBill' ";
			rs = Sqlca.getASResultSet(sSql);
		    while(rs.next())
		    {
		    	BDSerialNo = rs.getString("ObjectNo");
		    	if(BDSerialNo == null) BDSerialNo ="";
		    	sBDSerialNo=sBDSerialNo+"','"+BDSerialNo;
		    }
		    rs.getStatement().close();
		    if("".equals(BDSerialNo))
		    {
		    	sMessage  += "该业务申请没有关联待借新还旧的原借据！"+"@";
		    }
		    
		    if(!BDSerialNo.equals(""))
		    {
		    	double dBalance = Sqlca.getDouble("select SUM(nvl(balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)) from Business_Duebill where SerialNo in('"+sBDSerialNo+"')").doubleValue();
		    	if(dBusinessSum>dBalance)
		    	{
		    		sMessage  += "借新还旧申请金额不能大于原借据余额！"+"@";
		    	}
		    }
			
		}
		
		//--------------第二十步：资产重组业务相关控制---------------		
		//发生类型为资产重组，需关联资产重组业务信息
		if(sOccurType.equals("030"))
		{			
			String sRSerialNo = "";
			double dRAPPBusinessSum = 0.00,dRBusinessSum = 0.00,dRNewBusinessSum = 0.00;
			double dRBalance = 0.00;
			//申请没有关联资产重组方案
			sSql = 	" select count (SerialNo) from APPLY_RELATIVE "+
					" where SerialNo = '"+sObjectNo+"' " +
					" and ObjectType = 'CapitalReform' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    	iNum = rs.getInt(1);
		    rs.getStatement().close();
		    
			if(iNum <= 0)				
				sMessage  += "该业务申请没有关联资产重组方案！"+"@";
			
			//拟重组贷款金额与新增授信金额之和是否等于申请金额
			sSql = 	" select BI.SerialNo as SerialNo,BA.BusinessSum as APPBusinessSum,"+
					" BI.BusinessSum as BusinessSum,BI.NewBusinessSum as NewBusinessSum "+
					" from BUSINESS_APPLY BA,REFORM_INFO BI,APPLY_RELATIVE AR "+
					" where  AR.ObjectNo=BI.SerialNo "+
					" and AR.SerialNo=BA.SerialNo "+
					" and AR.ObjectType='CapitalReform' "+
					" and BA.SerialNo='"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    {
		    	sRSerialNo = rs.getString("SerialNo");
		    	dRAPPBusinessSum = rs.getDouble("APPBusinessSum");
		    	dRBusinessSum = rs.getDouble("BusinessSum");
		    	dRNewBusinessSum = rs.getDouble("NewBusinessSum");
		    }
		    rs.getStatement().close();
		    
			if(dRAPPBusinessSum != dRBusinessSum+dRNewBusinessSum)				
				sMessage  += "重组方案中拟重组贷款金额与新增授信金额之和不等于申请金额！"+"@";
			
			//重组贷款合同余额之和是否等于重组方案中拟重组贷款金额
			sSql = 	"select sum(BC.Balance) as Balance  "+
					" from BUSINESS_CONTRACT BC,REFORM_RELATIVE AR  "+
					" where BC.SerialNo = AR.ObjectNo and AR.ObjectType= 'BusinessContract' "+
					" and AR.SerialNo = '"+sRSerialNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    {
		    	dRBalance = rs.getDouble("Balance");
		    }
		    rs.getStatement().close();
		    
			if(dRBusinessSum != dRBalance)				
				sMessage  += "重组方案中关联重组贷款合同余额之和是不等于拟重组贷款金额！"+"@";
		}
		
		//------------第二十一步：有已经核销的贷款不能进行新增的业务--------------
		if(sOccurType.equals("010"))
		{
			sSql = "select count(*) from BUSINESS_CONTRACT where FinishType like '060%' and CustomerID ='"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    	iNum = rs.getInt(1);
		    rs.getStatement().close();
		    
			if(iNum > 0)				
				sMessage  += "该客户有核销贷款，不能新增业务！"+"@";
		}
		//delete by xhyong 2012/0823
		/*
		//------------第二十一步：单一客户的新增贷款不能高于资本金的10％--------------
		if(sOccurType.equals("010"))
		{
			AmarInterpreter interpreter = new AmarInterpreter();
			Anything aReturn =  interpreter.explain(Sqlca,"!审批流程.是否超资本金("+sObjectNo+","+sObjectType+",2)");
			String sReturn = aReturn.stringValue();
			if(sReturn.equals("TRUE"))
			{
				sMessage  += "该客户新增贷款+贷款余额超本行资本金10％！"+"@";
			}
	        
		}
		*/
		//end
		//农户办理小额信用贷款，必须要有信用评级---前面已经有客户一年内没有评级控制
		
		//------------第二十二步：个体工商户（微小商户贷款）申请金额+余额--------------
		if(sCustomerType.equals("0103") && sBusinessType.equals("1140120"))
		{
			//历史余额---是否要加上流程中的和等级合同未放款的
			double dBalanceSum =0.0;
			sSql ="select Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate) as BalanceSum from Business_Contract where CustomerID ='"+sCustomerID+"' and BusinessType ='1140120'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
				dBalanceSum = rs.getDouble("BalanceSum");
			
			rs.getStatement().close();
			double dTotalSum = dBalanceSum+dBusinessSum;
			
			if(dTotalSum>500000)
				sMessage  += "个体工商户，办理微小商户贷款（申请金额+该品种余额）不能大于50万!"+"@";
		}
		
		//--------------------第二十三步：还旧借新业务----------------------------
		if(sOccurType.equals("060"))
		{
			String BDSerialNo ="";
			sSql = 	" select ObjectNo from APPLY_RELATIVE "+
					" where SerialNo = '"+sObjectNo+"' " +
					" and ObjectType = 'BusinessDueBill' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    {
		    	BDSerialNo = rs.getString("ObjectNo");
		    	if(BDSerialNo == null) BDSerialNo ="";
		    }
		    else
		    {
		    	sMessage  += "该业务申请没有关联待还旧借新的原借据！"+"@";
		    }
		    rs.getStatement().close();
		    
		    //屏蔽，by zwhu 20100721
		    /*if(!BDSerialNo.equals(""))
		    {
		    	double dBalance = Sqlca.getDouble("select nvl(balance,BusinessSum)*getERate(BusinessCurrency,'01','') from Business_Duebill where SerialNo='"+BDSerialNo+"'").doubleValue();
		    	if(dBalance != 0)
		    	{
		    		sMessage  += "还旧借新原借据余额不为0！"+"@";
		    	}
		    }	
		    */			        
		}
		//delete by xhyong 2012/0823
		/*
		//--------------第二十四步：集团成员办理业务，集团授信总量+本次申请金额不能大于资本金15％---------------
		String JTCustomerID ="";
		sSql = " select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"' "+
			   " and RelationShip like '04%' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			JTCustomerID = rs.getString("CustomerID");
			if(JTCustomerID == null) JTCustomerID ="";
		}
		rs.getStatement().close();
		if(!JTCustomerID.equals(""))
		{
			AmarInterpreter interpreter = new AmarInterpreter();
			Anything aReturn =  interpreter.explain(Sqlca,"!审批流程.是否超资本金("+sObjectNo+","+sObjectType+",4)");
			String sReturn = aReturn.stringValue();
			if(sReturn.equals("TRUE"))
			{
				sMessage  += "该笔贷款申请金额+集团授信总量不能大于本行资本金额15％！"+"@";
			}
		}
		*/	
		//end
		//--------------关联集团成员在我行授信风险限额控制-------------
		String GLCustomerID ="" ;        // 关联集团ID
		double dCreditAuthSum = 0.0 ;    // 集团授信风险限额
		double dSum1 = 0.0 ;             // 成员授信敞口总量
		double dSum3 = 0.0 ;             // 合同金额
		double dSum4 = 0.0 ;             // 保证金
		double dSum2 = 0.0 ;             // 成员申请授信风险敞口
		double dSum5 = 0.0 ;             // 该笔申请金额
		double dSum6 = 0.0 ;             // 该笔保证金
		//成员授信敞口总量+成员申请授信风险敞口金额<=成员授信风险限额
		// 成员授信敞口总量:(未放款合同金额-保证金)+(已放款合同余额-保证金)
		// 成员申请授信风险敞口:成员申请授信风险敞口=该笔申请金额-该笔保证金额
		sSql = " select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"' "+
			   " and RelationShip like '04%' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			GLCustomerID = rs.getString("CustomerID");
			if(GLCustomerID == null) GLCustomerID ="";
		}
		rs.getStatement().close();
		// COGNSCORE-授信额度限额 MODELNO-币种 FINISHDATE4-更新日期 FINISHDATE-起始日 FINISHDATE2-到期日
		if(!GLCustomerID.equals(""))
		{
			 dCreditAuthSum = Sqlca.getDouble(" select min(Nvl(COGNSCORE,0)*getERate(MODELNO,'01',FINISHDATE4)) from EVALUATE_RECORD where OBJECTNO = '"+GLCustomerID+"' and OBJECTTYPE = 'GroupCreditRisk'  and '"+sToday+"' between FINISHDATE and FINISHDATE2 ");
			 if(dCreditAuthSum>0)
			 {
				 dSum3 = Sqlca.getDouble(" select Sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)) from Business_Contract where CustomerID in (select RelativeID from Customer_Relative where CustomerID = '"+GLCustomerID+"' and RelationShip like '04%')");
				 dSum4 = Sqlca.getDouble(" select Sum(Nvl(BailSum,0)*getERate(BusinessCurrency,'01',ERateDate)) from Business_Contract where CustomerID in (select RelativeID from Customer_Relative where CustomerID = '"+GLCustomerID+"' and RelationShip like '04%') ");
				 dSum1 = dSum3 - dSum4;
				 dSum5 = Sqlca.getDouble(" select Nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) from Business_Apply where SerialNo = '"+sObjectNo+"' ");
				 dSum6 = Sqlca.getDouble(" select NVL(BailSum,0)*getERate(BusinessCurrency,'01',ERateDate) from Business_Apply where SerialNo = '"+sObjectNo+"' ");
				 dSum2 = dSum5 - dSum6;
				 if(dSum1+dSum2 > dCreditAuthSum)
				 {
				    sMessage  += "成员授信敞口总量与成员申请风险敞口金额之和不能大于集团授信风险限额！"+"@"  ;
				 }
			 }
		}
		
		//--------------第二十五步：关联交易控制---------------
		if(sOccurType.equals("010"))//新发生
		{
			double dBalanceSum =0.0, dNetCapital =0.0 ,dTotalSum =0.0;
			String sCertID ="",sCertType="";
			sSql = " select count(*) as num from CUSTOMER_SPECIAL CS,CUSTOMER_INFO CI where CS.CertID=CI.CertID and CS.CertType=CI.CertType and SectionType='50' and CI.CustomerID ='"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     	{
	     		iNum = rs.getInt("num");
	     	}
	     	rs.getStatement().close();
	     	
	     	if(iNum>0)//是股东
	     	{
	     		//所有股东的授信余额(通过股东的证件号码去检索客户信息)
	     	  sSql = " select Sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)) as BalanceSum " +
	     	   		 " from Business_Contract where CustomerID in " +
	     	   		 " ( select CS.CustomerID from CUSTOMER_SPECIAL CS,CUSTOMER_INFO CI where CS.CertID=CI.CertID and CS.CertType=CI.CertType and SectionType='50')";
	     	  rs = Sqlca.getASResultSet(sSql);
	     	  if(rs.next())
	     	  {
	     		  dBalanceSum = rs.getDouble("BalanceSum");//股东总余额
	     	  }
	     	  rs.getStatement().close();
	     	  dTotalSum = dBalanceSum+dBusinessSum;
	     	  
	     	 //总行资本金
	     	  sSql = "select Nvl(NetCapital,0) from Org_Info where OrgLevel = '0'";//总行
	     	  dNetCapital = Sqlca.getDouble(sSql).doubleValue();
	     	  
	     	  if(dTotalSum>dNetCapital*0.5)
	     	  {
	     		 sMessage  += "超过股东申请业务资本金限额！"+"@";
	     	  }
	     	  
	     	}
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
	     		sMessage  += "固定资产贷款、房地产贷款，没有相关项目信息！"+"@";
		}
		
		
		//------------第二十八步：农户特色贷款检查客户是否有办理此业务的权限------------------
		AmarInterpreter interpreter = new AmarInterpreter();
		Anything aReturn1 =  interpreter.explain(Sqlca,"!BusinessManage.CheckCreditCondition("+sBusinessType+","+sCustomerID+")");
		String TempValue = aReturn1.stringValue();
		
		if(!TempValue.equals("") && !TempValue.equals("PASS"))
			sMessage  +=  TempValue+"@";
		
		
		//------------第二十九步：复审,已经发起出账的业务不允许复审------------------
		if(sOccurType.equals("090")){
			
			sSql = " select count(*) from Business_Contract BC,Business_PutOut BP " +
				   " where BC.SerialNo = BP.ContractSerialNo " +
				   " and BC.RelativeSerialNo ='"+sRelativeAgreement+"'  ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
				iNum = rs.getInt(1);
			
			rs.getStatement().close();
			if(iNum > 0)
				sMessage += "需要复审的业务已经发起出账，不能进行复审！"+"@";
		}
		
		//==============================协议检查=============================================
		if(!"".equals(sVouchAggreement) || !"".equals(sConstructContractNo) || !"".equals(sBuildAgreement)){
		String sSql1 = " Select SerialNo,(nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)-nvl(BailSum,0)) as BusinessSum," +
				 	   " BusinessCurrency, ConstructContractNo,BuildAgreement," +
					   " BusinessType,(nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)-nvl(BailSum,0)) as Balance,VouchType,CustomerID,VouchAggreement " +
					   " from Business_Contract BC Where 1=1 and (FinishDate is null or FinishDate ='')  " ;
		 
		 String sSql2 = " select SerialNo,(nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)-nvl(BailSum,0)) as BusinessSum,CustomerID," +
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
				 sMessage  +=  "担保协议已到期，不能使用！"+"@";
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
				 dCusAgreeApplySum = AgreementApply.getSum("BusinessSum","CustomerID",Tools.EQUALS,sCustomerID);
				 
				 if("".equals(sAgriLoanFlag) || "2".equals(sAgriLoanFlag))//非涉农
					 dCompareSum = dVouchTotalSum-dAgreementBalance-dAgreementApplySum;
				 else
					 dCompareSum = dTopVouchSum-dAgreementBalance-dAgreementApplySum;
				 //System.out.println("dTopVouchSum:"+dTopVouchSum+"*dAgreementBalance:"+dAgreementBalance+"&dAgreementApplySum:"+dAgreementApplySum);
				 if(dBusinessSum-dBailSum>dCompareSum)
					 sMessage  +=  "超过担保协议担保额度或者担保总额度限制！"+"@";
					 
				 dCompareSum = dSingleSum-dCusAgreeBalance-dCusAgreeApplySum;
				 if(dBusinessSum-dBailSum>dCompareSum)
					 sMessage  +=  "超过担保协议单户最高担保金额限制！"+"@";
				 /*
				 if(dTermMonth >dEntTermMonth )
					 sMessage  +=  "超过担保协议最高融资期限限制！"+"@";
					 */
				AgreementContract.closeCreditData();
				AgreementApply.closeCreditData(); 
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
					 sMessage  +=  "工程机械主协议已到期，不能使用！"+"@";
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
					 dCusAgreeApplySum = AgreementApply.getSum("BusinessSum","CustomerID",Tools.EQUALS,sCustomerID);
					 System.out.println("dCreditSum:"+dCreditSum+"%dAgreementBalance:"+dAgreementBalance+"*dAgreementApplySum:"+dAgreementApplySum);
					 dCompareSum = dCreditSum-dAgreementBalance-dAgreementApplySum;
					 if(dBusinessSum>dCompareSum)
						 sMessage  +=  "超过该经销商从协议额度限制！"+"@";
						 
					 dCompareSum = dLimitSum-dCusAgreeBalance-dCusAgreeApplySum;
					 if(dBusinessSum>dCompareSum)
						 sMessage  +=  "超过单户经销商从协议最高额限制！"+"@";
					 
					 if(dTermMonth >dLimitLoanTerm )
						 sMessage  +=  "超过经销商从协议最高贷款期限限制！"+"@";
					
					 dCompareSum = dLimitLoanRatio*dEquipmentSum;
					 if(dBusinessSum>dCompareSum)
						 sMessage  +=  "超过经销商从协议最高贷款比例限制！"+"@";
					AgreementContract.closeCreditData();
					AgreementApply.closeCreditData();
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
					 sMessage  +=  "楼宇按揭协议已到期，不能使用！"+"@";
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
						 sMessage  +=  "超过楼宇按揭协议总额度限制！"+"@";
					AgreementContract.closeCreditData();
					AgreementApply.closeCreditData();
				 }
			}

		
		}
		
		//--------------------第三十三步：微小企业控制---------------------
		if(sCustomerType.startsWith("01"))
		{
			String sRelativeID="";
			//资产总额
			double dTotalAssets =0.0,dSellSum=0.0,dTotalSum=0.0, dBalanceSum =0.0;
			sSql = "select SmallEntFlag,TotalAssets,SellSum from ENT_INFO where CustomerID ='"+sCustomerID+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sSmallEntFlag = rs.getString("SmallEntFlag");
				dTotalAssets = rs.getDouble("TotalAssets");
				dSellSum = rs.getDouble("SellSum");
				if(sSmallEntFlag ==null) sSmallEntFlag="";
			}
			rs.getStatement().close();
			
			if("1".equals(sSmallEntFlag))//认定为微小企业
			{
				//取得该机构是否具有微小企业的发起权利和最高金额 lpzhang 2010-5-12 
				sSql =  " select CreditSmallEntFlag , SmallEntSum from Org_Info " +
						" where OrgID =(select OrgID from Org_Info where OrgID= '"+sInputOrgID+"')";
				                     
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{
					sCreditSmallEntFlag = rs.getString("CreditSmallEntFlag");
					dSmallEntSum = rs.getDouble("SmallEntSum");
					if(sCreditSmallEntFlag ==null) sCreditSmallEntFlag="";
				}
				rs.getStatement().close();
				
				if(!sCreditSmallEntFlag.equals("1"))
				{
					sMessage  +=  "本机构不能办理微小企业贷款！"+"@";
				}else{
				
					sSql ="select nvl(sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)),0) as BalanceSum from Business_Contract where CustomerID ='"+sCustomerID+"' and  ApplyType <>'DependentApply'  ";
					rs = Sqlca.getASResultSet(sSql);
					if(rs.next())
						dBalanceSum = rs.getDouble("BalanceSum");
					
					rs.getStatement().close();
					dTotalSum = dBalanceSum+dBusinessSum;
					//（1）	微小企业申请需求应小于等于准入金额
					if(dTotalSum>dSmallEntSum)
						sMessage  +=  "微小企业申请授信金额加历史余额应小于等于"+dSmallEntSum+"元！"+"@";
					//（2）	微小企业上年末资产总额不低于授信额度的3倍 
					if(dBusinessSum*3/10000>dTotalAssets)
						sMessage  +=  "微小企业上年末资产总额不低于授信额度的3倍！"+"@";
					//（3）	微小企业上年度销售收入不低于授信额度3倍	
					if(dBusinessSum*3/10000>dSellSum)
						sMessage  +=  "微小企业上年度销售收入不低于授信额度3倍！"+"@";
					//（4）	微小企业期限上应小于等于2年
					if(dTermMonth>24)
						sMessage  +=  "微小企业授信期限应小于等于2年！"+"@";
				}
				//（5）	若微小企业办理了业务，微小企业法人代表不得在该行办理其它贷款
				sRelativeID = Sqlca.getString(" select RelativeID from CUSTOMER_RELATIVE  where CustomerID ='"+sCustomerID+"' and RelationShip = '0100' and EffStatus = '1'"); 
				if(sRelativeID==null)sRelativeID="";
				if("".equals(sRelativeID)){
					sRelativeID = Sqlca.getString(" select RelativeID from CUSTOMER_RELATIVE  where CustomerID ='"+sCustomerID+"' and RelationShip = '0109' and EffStatus = '1'");
					if(sRelativeID==null)sRelativeID="";
				}
				if(!"".equals(sRelativeID)){
					sSql = "select count(*) from BUSINESS_CONTRACT where CustomerID = '"+sRelativeID+"' and (FinishDate is null or FinishDate='')  ";
					rs = Sqlca.getASResultSet(sSql);
				    if(rs.next())
				    	iNum = rs.getInt(1);
				    rs.getStatement().close();
					if(iNum > 0)
				   		sMessage  += "该客户的法人代表或实际控制人在本行有存在业务！"+"@";
				}	
				if(!(sBusinessType.equals("2010")))//银行承兑汇票业务不涉及基准利率
				{
				//（6）	微小企业的抵质押贷款利率在基准利率上上浮30%（区间0-30%）
				if((sVouchType.startsWith("020")||sVouchType.startsWith("040") )&& (dRateFloat>30 ||dRateFloat<0)&& !sBusinessType.equals("2010"))
					sMessage  += "微小企业的抵质押贷款利率基准利率上浮区间（0-30％）！"+"@";
				//(7)连带保证担保的在基准利率上上浮30%-80%
				if((sVouchType.startsWith("010")) && (dRateFloat<30 ||dRateFloat>80) && !sBusinessType.equals("2010"))
					sMessage  += "微小企业保证担保的应该在基准利率上上浮30％-80％！"+"@";
				}
			}
		}
		/***remarked by lpzhang 2010-4-27 取消该控制
		if(sCustomerType.startsWith("03"))
		{
			String sCustomerIDstr = Sqlca.getString("select CustomerID from CUSTOMER_RELATIVE  where RelativeID ='"+sCustomerID+"' and RelationShip = '0100' ");
			if(sCustomerIDstr==null) sCustomerIDstr="";
			
			sSql = "select SmallEntFlag from ENT_INFO where CustomerID ='"+sCustomerIDstr+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sSmallEntFlag = rs.getString("SmallEntFlag");
				if(sSmallEntFlag ==null) sSmallEntFlag="";
			}
			rs.getStatement().close();
			
			if("1".equals(sSmallEntFlag))//微小企业法人
			{
				sSql = "select count(*) from BUSINESS_CONTRACT where CustomerID = '"+sCustomerIDstr+"' and (FinishDate is null or FinishDate='') ";
				rs = Sqlca.getASResultSet(sSql);
			    if(rs.next())
			    	iNum = rs.getInt(1);
			    rs.getStatement().close();
				if(iNum > 0)
			   		sMessage  += "该客户是微小企业的法人代表，该微小企业在本行存在业务！"+"@";
			}
			
			
		}
		remarked by lpzhang 2010-4-27 取消该控制*/
		
		
		//农户小额信用贷款、农村信用共同体内农户贷款、农村信用共同体内信用商户贷款,城区信用共同体内信用商户贷款、农户联保贷款
		if(("1150010,1150050,1150060,1140130,1150020".indexOf(sBusinessType)) > -1){
			sSql = "select count(*) from ASSESSFORM_INFO where CustomerID = '"+sCustomerID+"' and AssessformType in('010','020')";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				iNum = rs.getInt(1);
			}
			rs.getStatement().close();
			if(iNum<1){
				sMessage  += "客户信息中没有做信用等级评定！"+"@";
			}
		}
		
		if("1140070".equals(sBusinessType)){ //公职人员担保贷款，担保人必须是公职人员
			sSql = "select GuarantorID from GUARANTY_CONTRACT where serialno in "+
					"(select ObjectNo from apply_relative where objecttype = 'GuarantyContract' and serialNo = '"+sObjectNo+"')";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next()){
				sGuarantorID = rs.getString("GuarantorID");
				if(sGuarantorID == null) sGuarantorID = "";
				String sGovServiceFlag = Sqlca.getString("select GovServiceFlag from IND_INFO where CustomerID = '"+sGuarantorID+"'");
				if(!"1".equals(sGovServiceFlag)){
					sMessage  += "公职人员担保贷款担保人必须是公职人员！"+"@";
					break;
				}
			}
			rs.getStatement().close();
		}
		
		//兴农贷款公司控制 add by zwhu 2010098
		if("918010100".equals(sInputOrgID)){
			double dCreditCompanySum = Sqlca.getDouble("Select CreditCompanySum from Org_Info where OrgID = '"+sInputOrgID+"'");
			if(dCreditCompanySum == 0){
				sMessage  += "没有给贷款公司总经理配置权限，请联系系统管理员！"+"@";
			}
			else {
				double dBalance = Sqlca.getDouble("select nvl(sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)),0) as BalanceSum " +
						"from Business_Contract where CustomerID ='"+sCustomerID+"' and  ApplyType <>'CreditLineApply' and manageorgid = '918010100'");
				if(dBusinessSum+dBalance>dCreditCompanySum)
					sMessage  +=  "贷款公司业务申请授信金额加历史余额应小于等于"+dCreditCompanySum+"元！"+"@";
			}
		}
		
		/*if("CreditLineApply".equals(sApplyType)){
			sSql = "Select SerialNo from "+sMainTable+" where BAAgreement ='"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			List<String> BAObjectNos = new ArrayList<String>() ; 
			while(rs.next()){
				String sBAObjectNo = rs.getString("SerialNo");
				BAObjectNos.add(sBAObjectNo);
			}
			rs.getStatement().close();
			for(int i=0;i<BAObjectNos.size();i++){
				Anything aReturn =  interpreter.explain(Sqlca,"!BusinessManage.CheckLineApplyRisk("+BAObjectNos.get(i)+","+sObjectType+")");
				sMessage += aReturn ;
			}
		}*/
		//--------------------------------------------
		/*------------------------第三十四步 检查期限是否大于零--------------*/
		if(sBusinessType.startsWith("1")){
			if(dTermMonth + dTermDay<=0)
				sMessage  += "业务申请期限小于零！"+"@";
		}
		//--------------第三十五步：公司综合授信额度是否低风险控制---------------
		//在“公司综合授信额度”->“授信额度基本信息”界面增加要素项“是否低风险业务”（下拉列表选项“是”、“否”），当选择为“是”时：
		//1、	当“授信额度分配”时的业务品种仅为“出口信用证押汇”、“出口信用证贴现”、“委托贷款”中的一种或几种时，不对“主要担保方式”进行校验，判定为低风险审批流程、权限。
		//2、	当“主要担保方式”为“100%保证金”时，只有“授信额度分配”时选择的业务品种为“提货担保”、“银行承兑汇票”、
		//“进口信用证”、“非融资性保函（包括投标保函、履约保函、预付款保函、付款保函、维修保函、其他特殊保函）”、
		//“出口信用证押汇”、“出口信用证贴现”、“委托贷款”
		//中的一个或几个时，才判定为低风险审批流程，否则，仍执行一般风险审批流程。
		//3、	当“主要担保方式”为“我行人民币存单质押”或“中央政府债券质押”时，判定该笔申请执行低风险业务审批流程、权限。

		if("3010".equals(sBusinessType))//公司综合授信额度
		{
			if("1".equals(sLowRisk))//选择为低风险
			{
				//当“主要担保方式”不为为“我行人民币存单质押”或“中央政府债券质押”时
				if(!"0401010".equals(sVouchType)&&!"0402010".equals(sVouchType))
				{
					//当“主要担保方式”为“100%保证金”,判断额度分配业务是否有不属于低风险业务品种“提货担保”、“银行承兑汇票”、
					//“进口信用证”、“非融资性保函（包括投标保函、履约保函、预付款保函、付款保函、维修保函、其他特殊保函）”、
					//“出口信用证押汇”、“出口信用证贴现”、“委托贷款”
					if("0105080".equals(sVouchType))
					{
						sSql = 	" select 1 from CL_INFO where ApplySerialNo = '"+sObjectNo+
						"' and BusinessType not in('2050010','2010','2050030','2040010','2040020','2040030','2030060','2040050','2040110','1080030','1080035','2070')  "+
						" and  ParentLineID <>'' and ParentLineID is not null ";
						rs = Sqlca.getASResultSet(sSql);
						if(rs.next()) 
							sMessage  += "请再次确认是否低风险业务！"+"@"; 
						rs.getStatement().close();
					}else
					{
						//仅为出口信用证押汇”、“出口信用证贴现”、“委托贷款”
						sSql = 	" select 1 from CL_INFO where ApplySerialNo = '"+sObjectNo+
						"' and BusinessType not in('1080030','1080035','2070')  "+
						" and  ParentLineID <>'' and ParentLineID is not null ";
						rs = Sqlca.getASResultSet(sSql);
						if(rs.next()) 
							sMessage  += "请再次确认是否低风险业务！"+"@"; 
						rs.getStatement().close();
					}	
				}		
			} 
		}
		//--------------第三十六步：新增(续作)关联业务提示---------------
		if(sOccurType.equals("065"))
		{
			String BDSerialNo ="";
			sSql = 	" select ObjectNo from APPLY_RELATIVE "+
					" where SerialNo = '"+sObjectNo+"' " +
					" and ObjectType = 'BusinessDueBill' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    {
		    	BDSerialNo = rs.getString("ObjectNo");
		    	if(BDSerialNo == null) BDSerialNo ="";
		    }
		    else
		    {
		    	sMessage  += "该业务申请没有关联待新增(续作)的原借据！"+"@";
		    }
		    rs.getStatement().close();		        
		}
		//--------------第三十七步：判断是否具有最新汇率信息---------------
		if(!"01".equals(sBusinessCurrency))//如果是外币
		{
			String BDSerialNo ="";
			sSql = 	" select EfficientDate from ERATE_INFO "+
					" where Currency = '"+sBusinessCurrency+"' " +
					" and EfficientDate = '"+sToday+"' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    {
		    	Sqlca.executeSQL("update Business_Apply set ERateDate ='"+sToday+"' where SerialNo = '"+sObjectNo+"' ");
		    	if("3010,3040,3050,3060,3015".indexOf(sBusinessType) > -1)//如果是额度信息
		    	{
		    		Sqlca.executeSQL("update CL_INFO set ERateDate ='"+sToday+"' where ApplySerialNo = '"+sObjectNo+"' ");
		    	}
		    }
		    else
		    {
		    	sMessage  += "该业务无对应币种的最新汇率信息,请联系系统管理员！"+"@";
		    }
		    rs.getStatement().close();		        
		}
		//System.out.println("sMessage:"+sMessage);
		//最多返回5个值
		/*
		String[] TempMsg = sMessage.split("@");
		int i = TempMsg.length;
		if(i>5)
		{
			for(int j=1;j<=5;j++)
			{
				sMsgValue = sMsgValue + TempMsg[j]+"@";
			}
		}else{
			sMsgValue = sMessage;
		}
		*/
		return sMessage;
	 }
	

}
