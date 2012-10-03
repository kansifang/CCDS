/**
 * Author: --lpzhang 2009-9-3 
 * Tester:                               
 * Describe: --额度检查
 * Input Param:                          
 * 		ObjectNo :对象编号  
 * 		ObjectType：对象类型
 * 		LineID：额度编号
 *      BusinessType：业务品种
 * Output Param:   
 * 		sMessage             
 * HistoryLog:   增加额度窜用 lpzhang  2010-5-28                       
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.ASValuePool;


public class CreditLineControl extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
		String sObjectNo = (String)this.getAttribute("ObjectNo"); //对象编号  
		String sObjectType = (String)this.getAttribute("ObjectType"); //对象类型
        String sLineID = (String)this.getAttribute("LineID");//额度编号
        String sBusinessType = (String)this.getAttribute("BusinessType");//业务品种
        String sStyle = (String)this.getAttribute("Style");//额度类型
        String sCustomerID = (String)this.getAttribute("CustomerID");//客户编号
        String sBCSerialNo = (String)this.getAttribute("BCSerialNo");//额度合同号
       
        
    	double dSubLineSum = 0.0,dTotalLineSum=0.0,dBusinessSum=0.0,dBusinessTotalSum=0.0;
    	String sCycFlag="",sSelfUseFlag="";
    	String sMessage="";
		ASValuePool attribute1 = null;
		ASValuePool attribute2 = null;
		//初始化额度对象
		CreditLineCL CC = new CreditLineCL(sLineID,sStyle,Sqlca);
		//初始化业务对象
		CreditLineBusiness CB = new CreditLineBusiness(sObjectType,sObjectNo,sBusinessType,sLineID,sStyle,sBCSerialNo,Sqlca);
		
		System.out.println("sLineID:::::::::::::::::::::::"+sLineID);
		if(sStyle.equals("AssureAgreement") || sStyle.equals("CommunityAgreement")) //联保或者信用共同体
		{
			
			//-------第一步：判断该客户否超过额度控制的客户额度限额-----------------
			attribute1 = (ASValuePool) CC.getMemberpool().getAttribute(sCustomerID);
			if(attribute1 != null )
			{	
				dSubLineSum = Double.valueOf( (String) attribute1.getAttribute("LineSum1*getERate(Currency,'01',ERateDate)")).doubleValue();//取得该用户额度限制
				sCycFlag = (String) attribute1.getAttribute("Rotative");
				System.out.println("((Double)CB.getOALLBusiness().getAttribute(TotalBCSum1)).doubleValue():"+((Double)CB.getOALLBusiness().getAttribute("TotalBCSum1")).doubleValue());
				System.out.println("((Double)CB.getOALLBusiness().getAttribute(TotalBCSum)).doubleValue():"+((Double)CB.getOALLBusiness().getAttribute("TotalBCSum")).doubleValue());
				dBusinessSum =  Double.valueOf((String) CB.getOApply().getAttribute("BusinessSum")).doubleValue()
							   +  (sCycFlag.equals("1")?((Double)CB.getOALLBusiness().getAttribute("TotalBCSum")).doubleValue():((Double)CB.getOALLBusiness().getAttribute("TotalBCSum1")).doubleValue())
							   + ((Double)CB.getOALLBusiness().getAttribute("TotalBASum")).doubleValue();
				System.out.println("dBusinessSum:"+dBusinessSum+"##dSubLineSum:"+dSubLineSum);
				if(dBusinessSum>dSubLineSum)
				{
					sMessage += "该申请超过该成员额度限制！"+"@";
				}
				
				//判断期限是否超过
				double dBATermMonth = (CB.getOApply().getAttribute("TermMonth") == null || "".equals(CB.getOApply().getAttribute("TermMonth")) )? 0.0:Double.valueOf( (String) CB.getOApply().getAttribute("TermMonth")).doubleValue();
				double dSubCLTermMonth =  Double.valueOf( (String)  attribute1.getAttribute("TermMonth")).doubleValue();
				
				if(dBATermMonth>dSubCLTermMonth)
				{
					sMessage += "该申请期限超过该成员额度期限限制！"+"@";
				}
				
			}else{
				sMessage += "未对该用户分配额度，不能做该业务！"+"@";
			}
			
			
		}
		
		//综合授信
		if(sStyle.equals("CreditAggreement"))
		{
			//-------第一步：判断该业务品种是否超过额度控制的业务品种限额-----------------
			attribute1 = (ASValuePool) CC.getSubpool().getAttribute(sBusinessType);
			if(attribute1==null)
			{
				sMessage += "未对该产品进行额度分配！"+"@";
			}
			if(attribute1 != null)
			{
				//查询是否允许额度窜用
				sSelfUseFlag = Sqlca.getString("select SelfUseFlag from Business_Contract where SerialNo = '"+sBCSerialNo+"'");
				if(sSelfUseFlag==null) sSelfUseFlag="";
				
				if(!sSelfUseFlag.equals("1"))//不允许窜用
				{
					dSubLineSum = Double.valueOf( (String) attribute1.getAttribute("LineSum1*getERate(Currency,'01',ERateDate)")).doubleValue();//取得该业务品种额度限制
					sCycFlag = (String) attribute1.getAttribute("Rotative");
					dBusinessSum =  Double.valueOf((String) CB.getOApply().getAttribute("BusinessSum")).doubleValue()
								   +  (sCycFlag.equals("1")?((Double)CB.getOALLBusiness().getAttribute("CycBCSum")).doubleValue():((Double)CB.getOALLBusiness().getAttribute("UnCycBCSum")).doubleValue())
								   + ((Double)CB.getOALLBusiness().getAttribute("TypeBASum")).doubleValue();
					System.out.println("dBusinessSum:"+dBusinessSum+"##dSubLineSum:"+dSubLineSum);
					if(dBusinessSum>dSubLineSum)
					{
						sMessage += "该申请超过该产品额度限制！"+"@";
					}
				}
				//判断期限是否超过
				double dBATermMonth = (CB.getOApply().getAttribute("TermMonth") == null || "".equals(CB.getOApply().getAttribute("TermMonth")) )? 0.0:Double.valueOf( (String) CB.getOApply().getAttribute("TermMonth")).doubleValue();
				double dSubCLTermMonth =  Double.valueOf( (String)  attribute1.getAttribute("TermMonth")).doubleValue();
				
				if(dBATermMonth>dSubCLTermMonth)
				{
					sMessage += "该申请期限超过该产品额度期限限制！"+"@";
				}
				
				//判断保证金是否超过（银行承兑汇票）
				if(sBusinessType.equals("2010"))
				{
					double dBailRatio = (CB.getOApply().getAttribute("BailRatio") == null || "".equals(CB.getOApply().getAttribute("BailRatio")) )? 0.0:Double.valueOf( (String) CB.getOApply().getAttribute("BailRatio")).doubleValue();
					double dSubCLBailRatio =  Double.valueOf( (String)  attribute1.getAttribute("BailRatio")).doubleValue();
					
					if(dBailRatio != dSubCLBailRatio)
					{
						sMessage += "该申请保证金比例与该产品额度保证金比例不等！"+"@";
					}
				}
				
			}else{
				sMessage += "未对该产品分配额度，不能做该业务！"+"@";
			}
			
			//-------第二步：判断该客户所有业务是否超过总额度控制-----------------
			attribute2 = CC.getCLpool();
			dTotalLineSum = (Double.valueOf((String)attribute2.getAttribute("LineSum1*getERate(Currency,'01',ERateDate)"))).doubleValue();//总额度
			
			dBusinessTotalSum = (Double.valueOf((String) CB.getOApply().getAttribute("BusinessSum"))).doubleValue()
			   					+ CB.getBusinessTotalSum(CC);
			
			if(dBusinessTotalSum>dTotalLineSum)
			{
				sMessage += "该申请超过综合业务授信总额度限制！"+"@";
			}
			//-------第三步：判断该客户各个产品是否超过其额度限制-----------------
			if(!sSelfUseFlag.equals("1"))//不允许窜用
			{
				Object[] sTmpContextKeys = CC.getSubpool().getKeys();
				
				for(int i=0;i<sTmpContextKeys.length;i++){
					String sTmpKey =(String)sTmpContextKeys[i];
					if(sTmpKey.equals(sBusinessType))
						continue;
					attribute1 = (ASValuePool) CC.getSubpool().getAttribute(sTmpKey);
					dSubLineSum = Double.valueOf((String)attribute1.getAttribute("LineSum1*getERate(Currency,'01',ERateDate)")).doubleValue();
					sCycFlag = (String) attribute1.getAttribute("Rotative");
					CB.ReSetALLBusiness(sTmpKey);
					
					dBusinessSum = (sCycFlag.equals("1")?((Double)CB.getOALLBusiness().getAttribute("CycBCSum")).doubleValue():((Double)CB.getOALLBusiness().getAttribute("UnCycBCSum")).doubleValue())
								   +  ((Double)CB.getOALLBusiness().getAttribute("TypeBASum")).doubleValue();
								
					if(dBusinessSum>dSubLineSum)
					{
						sMessage += "业务品种【"+(String) attribute1.getAttribute("getBusinessName(BusinessType)")+"】已经超过单产品额度限制！"+"@";
					}
				}
			}
			else//额度允许窜用
			{
				//合同与在途的额度项下业务所在额度之和
				dSubLineSum=0;
				double dSubCLBailRatio =0,dBusinessTypeSum=0,dOtherSubLineSum=0;
				dBusinessTotalSum = CB.getBusinessTotalSum(CC);
				attribute1 = (ASValuePool) CC.getSubpool().getAttribute("2010");
				if(attribute1 != null){
					dSubLineSum = Double.valueOf( (String) attribute1.getAttribute("LineSum1*getERate(Currency,'01',ERateDate)")).doubleValue();
					sCycFlag = (String) attribute1.getAttribute("Rotative");
					dSubCLBailRatio =  (Double.valueOf( (String)  attribute1.getAttribute("BailRatio")).doubleValue()/100);//保证金比例
				}
				//合同与在途的额度项下承兑汇票业务品种业务所在额度之和
				dBusinessTypeSum =  (sCycFlag.equals("1")?((Double)CB.getOALLBusiness().getAttribute("CycADBCSum")).doubleValue():((Double)CB.getOALLBusiness().getAttribute("UnCycADBCSum")).doubleValue())
			   					+ ((Double)CB.getOALLBusiness().getAttribute("TypeADBASum")).doubleValue();
				//其余产品的额度总和
				dOtherSubLineSum = dTotalLineSum - dSubLineSum;
				
				//合同与在途的额度项下其他业务品种业务所在额度之和
				double dOtherBusinessTypeSum = dBusinessTotalSum - dBusinessTypeSum;
				
				//可串用额度与单产品的可用额度之和
				double dSpareSum = 0;
				if(dBusinessTypeSum >= dSubLineSum)
				{
					dSpareSum = (dOtherSubLineSum - dOtherBusinessTypeSum) - (dBusinessTypeSum - dSubLineSum) ; 
				}
				else 
				{
					if("2010".equals(sBusinessType))
					{
						dSpareSum = (dSubLineSum - dBusinessTypeSum)+(dOtherSubLineSum - dOtherBusinessTypeSum);
					}
					else
					{
						dSpareSum = (dSubLineSum - dBusinessTypeSum)*(1-dSubCLBailRatio)+(dOtherSubLineSum - dOtherBusinessTypeSum);
					}
				}
				//本笔申请额度
				double BusinessSum = Double.valueOf((String) CB.getOApply().getAttribute("BusinessSum")).doubleValue();
				if(BusinessSum>dSpareSum)
				{
					attribute1 = (ASValuePool) CC.getSubpool().getAttribute(sBusinessType);
					sMessage += "业务品种【"+(String) attribute1.getAttribute("getBusinessName(BusinessType)")+"】已经超过可串用金额！"+"@";
				}
			}
		}
		

		System.out.println("sMessage:"+sMessage);
		//---------------最后：清理缓存------------------
		CB.CleanCreditData();
		CB.getOALLBusiness().resetPool();
		CC.getCLpool().resetPool();
		CC.getSubpool().resetPool();
		CC.getMemberpool().resetPool();
		
		return sMessage;
	}

}
