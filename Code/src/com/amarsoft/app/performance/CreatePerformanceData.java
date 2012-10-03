/**
		Author: --fhuang 2006-12-28
		Tester:
		Describe: --产生Approve_Performance_D表的数据
				  --以申请表中的数据为基础数据，查找流程流水表中的内容，并将其情况统计入Approve_Performance_D表
				  --每天日终跑一次
		Input Param:
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.performance;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.*;


public class CreatePerformanceData extends Bizlet {	
	public final static String AGREEMENT = "同意";
	public final static String DISAGREEMENT = "否决";
	public final static String DEALING = "退回补充资料";
	
	public Object run(Transaction Sqlca) throws Exception{
		String sSTATISTICDATE = (String)this.getAttribute("STATISTICDATE");//统计日期 
		//统计日期为运行批量的时间,或者为此时间的前一天,根据情况设定
		if(sSTATISTICDATE ==null)
			sSTATISTICDATE = StringFunction.getToday();
		
		String sSerialNo = "";//申请流水号
		String sORGID = "";//审批机构
		String sUSERID = "";//审批人员
		String sFLOWNO = "";//流程编号
		String sPHASENO = "";//阶段编号
		int iCURRDEALCOUNT = 0;//目前待审批总笔数
		double dCURRDEALSUM = 0.00;//目前待审批总金额
		//申请被审批的情况，分批准，否决，在途三种类型，流程阶段要剔除0010(信贷员准备阶段)，3000（退回补充资料）
		int iMAGGREECOUNT = 0;//本月批准总笔数
		int iMDISAGREECOUNT = 0;//本月否决总笔数
		int iMAFLOATCOUNT = 0;//本月在途总笔数	
		int iMAGGREETIME = 0;//本月批准总耗时
		int iMDISAGREETIME = 0;//本月否决总耗时
		int iMAFLOATTIME = 0;//本月在途总耗时	
		//申请被批准，且批准日期为本月的业务
		int iMNAPPROVECOUNT = 0;//本月未签批复总笔数
		double dMNAPPROVESUM = 0.00;//本月未签批复总金额
		int iMNCONTRACTCOUNT = 0;//本月未签合同总笔数
		double dMNCONTRACTSUM = 0.00;//本月未签合同总金额 
		int iMNPUTOUTCOUNT = 0;//本月未放贷笔数
		double dMNPUTOUTSUM = 0.00;//本月未放贷金额 
		//申请被批准，且批准日期为本月的业务(按借据分类)
		double dMNORMALSUM = 0.00;//本月正常余额
		double dMATTENTIONSUM = 0.00;//本月关注余额
		double dMSECONDARYSUM = 0.00;//本月次级余额
		double dMSHADINESSSUM = 0.00;//本月可疑余额
		double dMLOSSSUM = 0.00;//本月损失余额
		//申请日期在本月,且否决,批准或在途的业务金额
		double dMAPPLYSUM = 0.00;//本月申请总金额
	   //申请被审批的情况，分批准，否决，在途三种类型，流程阶段要剔除0010(信贷员准备阶段)，3000（退回补充资料）
		int iYAGGREECOUNT = 0;//本年批准总笔数
		int iYDISAGREECOUNT = 0;//本年否决总笔数
		int iYAFLOATCOUNT = 0;//本年在途总笔数	
		int iYAGGREETIME = 0;//本年批准总耗时
		int iYDISAGREETIME = 0;//本年否决总耗时
		int iYAFLOATTIME = 0;//本年在途总耗时
		//申请被批准，且批准日期为本年的业务
		int iYNAPPROVECOUNT= 0;//本年未签批复总笔数
		double dYNAPPROVESUM = 0.00;//本年未签批复总金额
		int iYNCONTRACTCOUNT = 0;//本年未签合同总笔数
		double dYNCONTRACTSUM = 0.00;//本年未签合同总金额 
		int iYNPUTOUTCOUNT = 0;//本年未放贷笔数
		double dYNPUTOUTSUM = 0.00;//本年未放贷金额
		//申请被批准，且批准日期为本年的业务(按借据分类)
		double dYNORMALSUM = 0.00;//本年正常余额
		double dYATTENTIONSUM = 0.00;//本年关注余额
		double dYSECONDARYSUM = 0.00;//本年次级余额
		double dYSHADINESSSUM = 0.00;//本年可疑余额
		double dYLOSSSUM = 0.00;//本年损失余额
		//申请日期在本年,且否决,批准或在途的业务金额
		double dYAPPLYSUM = 0.00;//本年申请总金额
		
	    //申请被审批的情况，分批准，否决，在途三种类型，流程阶段要剔除0010(信贷员准备阶段)，3000（退回补充资料）
		int iCAGGREECOUNT = 0;//当前累计批准总笔数
		int iCDISAGREECOUNT = 0;//当前累计否决总笔数
		int iCAFLOATCOUNT = 0;//当前累计在途总笔数	
		int iCAGGREETIME = 0;//当前累计批准总耗时
		int iCDISAGREETIME = 0;//当前累计否决总耗时
		int iCAFLOATTIME = 0;//当前累计在途总耗时
		//申请被批准
		int iCNAPPROVECOUNT= 0;//当前累计未签批复总笔数
		double dCNAPPROVESUM = 0.00;//当前累计月未签批复总金额
		int iCNCONTRACTCOUNT = 0;//当前累计未签合同总笔数
		double dCNCONTRACTSUM = 0.00;//当前累计未签合同总金额 
		int iCNPUTOUTCOUNT = 0;//当前累计未放贷笔数
		double dCNPUTOUTSUM = 0.00;//当前累计未放贷金额
		//申请被批准(按借据分类)
		double dCNORMALSUM = 0.00;//当前累计正常余额
		double dCATTENTIONSUM = 0.00;//当前累计关注余额
		double dCSECONDARYSUM = 0.00;//当前累计次级余额
		double dCSHADINESSSUM = 0.00;//当前累计可疑余额
		double dCLOSSSUM = 0.00;//当前累计损失余额		
		//申请日期在当前,且否决,批准或在途的业务金额
		double dCAPPLYSUM = 0.00;//当前累计申请总金额


		//先清空Approve_Performance_D中的数据记录
		clearRecord(Sqlca);		
		String sSql = "";
		ASResultSet rs = null;
		sSql = " select SerialNo,BusinessSum*getERate(BusinessCurrency,'01','"+sSTATISTICDATE+"') "+
			   " as BusinessSum,OccurDate from Business_Apply where exists ("+
			   " select 1 from Flow_Object where ObjectType='CreditApply' "+
			   " and ObjectNo=Business_Apply.SerialNo)";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sSerialNo = rs.getString("SerialNo");//申请流水号
			double dBusinessSum = rs.getDouble("BusinessSum");//申请金额
			String sOccurDate = rs.getString("OccurDate");
			//查找Flow_Task中是否存在除0010,3000（信贷员的）外的阶段。
			String sSql1 = "";
			ASResultSet rs1 = null;
			int iCount = 0;
			sSql1 = " select count(*) from Flow_Task where ObjectType='CreditApply' " +
					" and PhaseNo not in ('0010','3000') and ObjectNo='"+sSerialNo+"'"; 
			rs1 = Sqlca.getASResultSet(sSql1);
			if(rs1.next())
			{
				iCount = rs1.getInt(1);
			}
			rs1.getStatement().close();
			if(iCount==0) continue;
			
			//查找Flow_Object中的该笔业务的状态
			 String sStatus = "";//1000,8000 or 其它
			 sSql1 = " select PhaseNo from Flow_Object where ObjectType='CreditApply' " +
			 		 " and ObjectNo='"+sSerialNo+"'";
			 rs1 = Sqlca.getASResultSet(sSql1);
			 if(rs1.next())
			 {
				 sStatus = rs1.getString("PhaseNo");
			 }
			 else
			 {
				 System.out.println("Flow_Object表中无此业务"+sSerialNo+"记录");
			 }
			 rs1.getStatement().close();
			 //1000表示批准,8000表示否决,其它为在途
			 
			 //查找该笔业务的FlowNo,PhaseNo,UserID的所有组合
			 sSql1 = " select FlowNo,PhaseNo,UserID,Count(*) from Flow_Task where "+
			         " ObjectType='CreditApply' and PhaseNo not in ('0010','1000','3000','8000')"+
			         " and ObjectNo='"+sSerialNo+"' group by FlowNo,PhaseNo,UserID";
			 rs1 = Sqlca.getASResultSet(sSql1);
			 while(rs1.next())
			 {
				 sFLOWNO = rs1.getString("FlowNo");
				 sPHASENO = rs1.getString("PhaseNo");
				 sUSERID = rs1.getString("UserID");
				 iCount = rs1.getInt(4);
				 //根据UserID求出OrgID
				 sORGID = Sqlca.getString("select BelongOrg from User_Info where UserID='"+sUSERID+"'");
				 //根据Flow_Task中EndTime 是否为空来判断目前待审批笔数和金额
				 String sSql2 = " select count(*) from Flow_Task where ObjectType='CreditApply' "+
				                " and ObjectNo='"+sSerialNo+"' and UserID='"+sUSERID+"' "+
				                " and PhaseNo='"+sPHASENO+"' and FlowNo='"+sFLOWNO+"' "+
				                " and EndTime is null";
				ASResultSet rs2 = Sqlca.getASResultSet(sSql2);
				int iCount2 = 0;
				 if(rs2.next())
				 {
					 iCount2 = rs2.getInt(1);
				 }
				 rs2.getStatement().close();
				 if(iCount2>=1)
				 {
					iCURRDEALCOUNT = 1;//目前待审批总笔数
					dCURRDEALSUM = dBusinessSum;//目前待审批总金额
				 }
				 else
				 {
					 iCURRDEALCOUNT = 0;//目前待审批总笔数
					 dCURRDEALSUM = 0.00;//目前待审批总金额
				 }
				 dMAPPLYSUM = getBusinessSum(sOccurDate,sSTATISTICDATE,dBusinessSum,"M");//本月申请总金额
				 dYAPPLYSUM = getBusinessSum(sOccurDate,sSTATISTICDATE,dBusinessSum,"Y");//本年申请总金额
				 dCAPPLYSUM = dBusinessSum;//当前累计申请总金额	
				 //1.业务最终状态不是批准，否决，则是在途。
				 if(!sStatus.equals("1000")&&!sStatus.equals("8000"))
				 {
						iMAGGREECOUNT = 0;//本月批准总笔数
						iMDISAGREECOUNT = 0;//本月否决总笔数
						iMAFLOATCOUNT = 1;//本月在途总笔数	
						iMAGGREETIME = 0;//本月批准总耗时
						iMDISAGREETIME = 0;//本月否决总耗时
						iMAFLOATTIME = getSumTime(sSerialNo,sFLOWNO,sPHASENO,sUSERID,Sqlca);//本月在途总耗时
						iMNAPPROVECOUNT = 0;//本月未签批复总笔数
						dMNAPPROVESUM = 0.00;//本月未签批复总金额
						iMNCONTRACTCOUNT = 0;//本月未签合同总笔数
						dMNCONTRACTSUM = 0.00;//本月未签合同总金额 
						iMNPUTOUTCOUNT = 0;//本月未放贷笔数
						dMNPUTOUTSUM = 0.00;//本月未放贷金额
						dMNORMALSUM = 0.00;//本月正常余额
						dMATTENTIONSUM = 0.00;//本月关注余额
						dMSECONDARYSUM = 0.00;//本月次级余额
						dMSHADINESSSUM = 0.00;//本月可疑余额
						dMLOSSSUM = 0.00;//本月损失余额
						
						iYAGGREECOUNT = 0;//本年批准总笔数
						iYDISAGREECOUNT = 0;//本年否决总笔数
						iYAFLOATCOUNT = 1;//本年在途总笔数	
						iYAGGREETIME = 0;//本年批准总耗时
						iYDISAGREETIME = 0;//本年否决总耗时
						iYAFLOATTIME = iMAFLOATTIME;//本年在途总耗时
						iYNAPPROVECOUNT= 0;//本年未签批复总笔数
						dYNAPPROVESUM = 0.00;//本年未签批复总金额
						iYNCONTRACTCOUNT = 0;//本年未签合同总笔数
						dYNCONTRACTSUM = 0.00;//本年未签合同总金额 
						iYNPUTOUTCOUNT = 0;//本年未放贷笔数
						dYNPUTOUTSUM = 0.00;//本年未放贷金额
						dYNORMALSUM = 0.00;//本年正常余额
						dYATTENTIONSUM = 0.00;//本年关注余额
						dYSECONDARYSUM = 0.00;//本年次级余额
						dYSHADINESSSUM = 0.00;//本年可疑余额
						dYLOSSSUM = 0.00;//本年损失余额
					
						iCAGGREECOUNT = 0;//当前累计批准总笔数
						iCDISAGREECOUNT = 0;//当前累计否决总笔数
						iCAFLOATCOUNT = 1;//当前累计在途总笔数	
						iCAGGREETIME = 0;//当前累计批准总耗时
						iCDISAGREETIME = 0;//当前累计否决总耗时
						iCAFLOATTIME = iMAFLOATTIME;//当前累计在途总耗时
						iCNAPPROVECOUNT= 0;//当前累计未签批复总笔数
						dCNAPPROVESUM = 0.00;//当前累计月未签批复总金额
						iCNCONTRACTCOUNT = 0;//当前累计未签合同总笔数
						dCNCONTRACTSUM = 0.00;//当前累计未签合同总金额 
						iCNPUTOUTCOUNT = 0;//当前累计未放贷笔数
						dCNPUTOUTSUM = 0.00;//当前累计未放贷金额
						dCNORMALSUM = 0.00;//当前累计正常余额
						dCATTENTIONSUM = 0.00;//当前累计关注余额
						dCSECONDARYSUM = 0.00;//当前累计次级余额
					    dCSHADINESSSUM = 0.00;//当前累计可疑余额
						dCLOSSSUM = 0.00;//当前累计损失余额						 
				 }else if (sStatus.equals("8000"))//终审为否决
				 {
						String sPhaseOpinion = getPhaseOpinion(sSerialNo,sFLOWNO,sPHASENO,sUSERID,Sqlca);
						String sEndTime = getEndTime(sSerialNo,sFLOWNO,sPHASENO,sUSERID,Sqlca);
						int sSumTime = getSumTime(sSerialNo,sFLOWNO,sPHASENO,sUSERID,Sqlca);
						//----先算当前的数据
						if(sPhaseOpinion.equals(AGREEMENT))
						{
							iCAGGREECOUNT = 1;//当前累计批准总笔数
							iCDISAGREECOUNT = 0;//当前累计否决总笔数
							iCAGGREETIME = sSumTime;//当前累计批准总耗时
							iCDISAGREETIME = 0;//当前累计否决总耗时
						}else if(sPhaseOpinion.equals(DISAGREEMENT)) 
						{
							iCAGGREECOUNT = 0;//当前累计批准总笔数
							iCDISAGREECOUNT = 1;//当前累计否决总笔数
							iCAGGREETIME = 0;//当前累计批准总耗时
							iCDISAGREETIME = sSumTime;//当前累计否决总耗时
						}
						else
						{
							throw new Exception("Flow_Task中出现了未定义的PhaseOpinion,请检查！");
						}
						iCAFLOATCOUNT = 0;//当前累计在途总笔数	
						iCAFLOATTIME = 0;//当前累计在途总耗时
						iCNAPPROVECOUNT= 0;//当前累计未签批复总笔数
						dCNAPPROVESUM = 0.00;//当前累计月未签批复总金额
						iCNCONTRACTCOUNT = 0;//当前累计未签合同总笔数
						dCNCONTRACTSUM = 0.00;//当前累计未签合同总金额 
						iCNPUTOUTCOUNT = 0;//当前累计未放贷笔数
						dCNPUTOUTSUM = 0.00;//当前累计未放贷金额
						dCNORMALSUM = 0.00;//当前累计正常余额
						dCATTENTIONSUM = 0.00;//当前累计关注余额
						dCSECONDARYSUM = 0.00;//当前累计次级余额
					    dCSHADINESSSUM = 0.00;//当前累计可疑余额
						dCLOSSSUM = 0.00;//当前累计损失余额
						
						if(!sEndTime.equals("") && sEndTime.substring(0,4).equals(sSTATISTICDATE.substring(0,4)))//统计本年
						{
							iYAGGREECOUNT = iCAGGREECOUNT;//本年批准总笔数
							iYDISAGREECOUNT = iCDISAGREECOUNT;//本年否决总笔数
							iYAGGREETIME = iCAGGREETIME;//本年批准总耗时
							iYDISAGREETIME = iCDISAGREETIME;//本年否决总耗时
							iYAFLOATCOUNT = 0;//本年在途总笔数	
							iYAFLOATTIME = 0;//本年在途总耗时
							iYNAPPROVECOUNT= 0;//本年未签批复总笔数
							dYNAPPROVESUM = 0.00;//本年未签批复总金额
							iYNCONTRACTCOUNT = 0;//本年未签合同总笔数
							dYNCONTRACTSUM = 0.00;//本年未签合同总金额 
							iYNPUTOUTCOUNT = 0;//本年未放贷笔数
							dYNPUTOUTSUM = 0.00;//本年未放贷金额
							dYNORMALSUM = 0.00;//本年正常余额
							dYATTENTIONSUM = 0.00;//本年关注余额
							dYSECONDARYSUM = 0.00;//本年次级余额
							dYSHADINESSSUM = 0.00;//本年可疑余额
							dYLOSSSUM = 0.00;//本年损失余额
							if(sEndTime.substring(0,7).equals(sSTATISTICDATE.substring(0,7)))//统计本月数据(本月的数字和本年一样)
							{
								iMAGGREECOUNT = iYAGGREECOUNT;//本月批准总笔数
								iMDISAGREECOUNT = iYDISAGREECOUNT;//本月否决总笔数
								iMAFLOATCOUNT = 0;//本月在途总笔数	
								iMAGGREETIME = iYAGGREETIME;//本月批准总耗时
								iMDISAGREETIME = iYDISAGREETIME;//本月否决总耗时
								iMAFLOATTIME = 0;//本月在途总耗时
								iMNAPPROVECOUNT = 0;//本月未签批复总笔数
								dMNAPPROVESUM = 0.00;//本月未签批复总金额
								iMNCONTRACTCOUNT = 0;//本月未签合同总笔数
								dMNCONTRACTSUM = 0.00;//本月未签合同总金额 
								iMNPUTOUTCOUNT = 0;//本月未放贷笔数
								dMNPUTOUTSUM = 0.00;//本月未放贷金额
								dMNORMALSUM = 0.00;//本月正常余额
								dMATTENTIONSUM = 0.00;//本月关注余额
								dMSECONDARYSUM = 0.00;//本月次级余额
								dMSHADINESSSUM = 0.00;//本月可疑余额
								dMLOSSSUM = 0.00;//本月损失余额
							}
							else//不是本月的值,则当月的值全部为0
							{
								iMAGGREECOUNT = 0;//本月批准总笔数
								iMDISAGREECOUNT = 0;//本月否决总笔数
								iMAFLOATCOUNT = 0;//本月在途总笔数	
								iMAGGREETIME = 0;//本月批准总耗时
								iMDISAGREETIME = 0;//本月否决总耗时
								iMAFLOATTIME = 0;//本月在途总耗时
								iMNAPPROVECOUNT = 0;//本月未签批复总笔数
								dMNAPPROVESUM = 0.00;//本月未签批复总金额
								iMNCONTRACTCOUNT = 0;//本月未签合同总笔数
								dMNCONTRACTSUM = 0.00;//本月未签合同总金额 
								iMNPUTOUTCOUNT = 0;//本月未放贷笔数
								dMNPUTOUTSUM = 0.00;//本月未放贷金额
								dMNORMALSUM = 0.00;//本月正常余额
								dMATTENTIONSUM = 0.00;//本月关注余额
								dMSECONDARYSUM = 0.00;//本月次级余额
								dMSHADINESSSUM = 0.00;//本月可疑余额
								dMLOSSSUM = 0.00;//本月损失余额
							}
								
						}
						else//不是当年的值,则当年当月的值均为0
						{
							iYAGGREECOUNT = 0;//本年批准总笔数
							iYDISAGREECOUNT = 0;//本年否决总笔数
							iYAGGREETIME = 0;//本年批准总耗时
							iYDISAGREETIME = 0;//本年否决总耗时
							iYAFLOATCOUNT = 0;//本年在途总笔数	
							iYAFLOATTIME = 0;//本年在途总耗时
							iYNAPPROVECOUNT= 0;//本年未签批复总笔数
							dYNAPPROVESUM = 0.00;//本年未签批复总金额
							iYNCONTRACTCOUNT = 0;//本年未签合同总笔数
							dYNCONTRACTSUM = 0.00;//本年未签合同总金额 
							iYNPUTOUTCOUNT = 0;//本年未放贷笔数
							dYNPUTOUTSUM = 0.00;//本年未放贷金额
							dYNORMALSUM = 0.00;//本年正常余额
							dYATTENTIONSUM = 0.00;//本年关注余额
							dYSECONDARYSUM = 0.00;//本年次级余额
							dYSHADINESSSUM = 0.00;//本年可疑余额
							dYLOSSSUM = 0.00;//本年损失余额
							iMAGGREECOUNT = 0;//本月批准总笔数
							iMDISAGREECOUNT = 0;//本月否决总笔数
							iMAFLOATCOUNT = 0;//本月在途总笔数	
							iMAGGREETIME = 0;//本月批准总耗时
							iMDISAGREETIME = 0;//本月否决总耗时
							iMAFLOATTIME = 0;//本月在途总耗时
							iMNAPPROVECOUNT = 0;//本月未签批复总笔数
							dMNAPPROVESUM = 0.00;//本月未签批复总金额
							iMNCONTRACTCOUNT = 0;//本月未签合同总笔数
							dMNCONTRACTSUM = 0.00;//本月未签合同总金额 
							iMNPUTOUTCOUNT = 0;//本月未放贷笔数
							dMNPUTOUTSUM = 0.00;//本月未放贷金额
							dMNORMALSUM = 0.00;//本月正常余额
							dMATTENTIONSUM = 0.00;//本月关注余额
							dMSECONDARYSUM = 0.00;//本月次级余额
							dMSHADINESSSUM = 0.00;//本月可疑余额
							dMLOSSSUM = 0.00;//本月损失余额
						}
				 }
				 else//终审为批准
				 {
					String sPhaseOpinion = getPhaseOpinion(sSerialNo,sFLOWNO,sPHASENO,sUSERID,Sqlca);
					String sEndTime = getEndTime(sSerialNo,sFLOWNO,sPHASENO,sUSERID,Sqlca);
					int sSumTime = getSumTime(sSerialNo,sFLOWNO,sPHASENO,sUSERID,Sqlca);
					//System.out.println("审批人意见,"+sPhaseOpinion+",审批时间："+sEndTime+",审批耗时,"+sSumTime);
					//先计算当前的值
					if(sPhaseOpinion.equals(AGREEMENT))
					{
						iCAGGREECOUNT = 1;//当前累计批准总笔数
						iCDISAGREECOUNT = 0;//当前累计否决总笔数
						iCAGGREETIME = sSumTime;//当前累计批准总耗时
						iCDISAGREETIME = 0;//当前累计否决总耗时
					}else if(sPhaseOpinion.equals(DISAGREEMENT)) 
					{
						iCAGGREECOUNT = 0;//当前累计批准总笔数
						iCDISAGREECOUNT = 1;//当前累计否决总笔数
						iCAGGREETIME = 0;//当前累计批准总耗时
						iCDISAGREETIME = sSumTime;//当前累计否决总耗时
					}
					else
					{
						throw new Exception("Flow_Task中出现了未定义的PhaseOpinion,请检查！");
					}
					iCAFLOATCOUNT = 0;//当前累计在途总笔数	
					iCAFLOATTIME = 0;//当前累计在途总耗时
					
					//判断未签金额比较麻烦,以最后一个审批人的审批金额为准.
					sSql2 = " Select count(*) from Business_Approve "+
							" where RelativeSerialNo='"+sSerialNo+"'";
					rs2 = Sqlca.getASResultSet(sSql2);
					//System.out.println(sSql2);
					int iCount3 = 0;
					if(rs2.next())
					{
						iCount3 = rs2.getInt(1);
					}
					rs2.getStatement().close();
					if(iCount3==0)
					{
						iCNAPPROVECOUNT = 1;//当前累计未签批复总笔数
					}
					else
					{
						iCNAPPROVECOUNT= 0;//当前累计未签批复总笔数
					}
					if(iCNAPPROVECOUNT == 1)//未签批复
					{
						String sSql3 = " select BusinessSum*getERate(BusinessCurrency,'01','"+sSTATISTICDATE+
									   "') as BusinessSum from Flow_Opinion "+
									   " where OpinionNo=(select SerialNo from Flow_Task "+
									   " where ObjectType='CreditApply' and PhaseNo='1000' "+
									   " and ObjectNo='"+sSerialNo+"')";
						ASResultSet rs3 = Sqlca.getASResultSet(sSql3);
						
						if(rs3.next())
						{
							dCNAPPROVESUM = rs3.getDouble(1);//当前累计月未签批复总金额
							rs3.getStatement().close();
						}
						else
						{
							rs3.getStatement().close();
							throw new Exception ("未找到业务终审人的意见!");
						}
						//--未签批复的以下所有值均为0
						iCNCONTRACTCOUNT = 0;//当前累计未签合同总笔数
						dCNCONTRACTSUM = 0.00;//当前累计未签合同总金额 
						iCNPUTOUTCOUNT = 0;//当前累计未放贷笔数
						dCNPUTOUTSUM = 0.00;//当前累计未放贷金额
						dCNORMALSUM = 0.00;//当前累计正常余额
						dCATTENTIONSUM = 0.00;//当前累计关注余额
						dCSECONDARYSUM = 0.00;//当前累计次级余额
					    dCSHADINESSSUM = 0.00;//当前累计可疑余额
						dCLOSSSUM = 0.00;//当前累计损失余额
					}
					else
					{
						dCNAPPROVESUM = 0.00;//当前累计月未签批复总金额
						//求出批复流水号和批复金额
						String sSql3 = " Select SerialNo,BusinessSum*getERate(BusinessCurrency,'01','"+sSTATISTICDATE+
									   "') as BusinessSum from Business_Approve "+
									   " where RelativeSerialNo='"+sSerialNo+"'";
						ASResultSet rs3 = Sqlca.getASResultSet(sSql3);
						String sApproveSerialNo = "";
						int iCount4 = 0;
						double dApproveSum = 0.00;
						if(rs3.next())
						{
							sApproveSerialNo = rs3.getString("SerialNo");//批复流水号
							dApproveSum = rs3.getDouble("BusinessSum");//批复表中的金额
						}
						rs3.getStatement().close();
						sSql3 = " Select count(*) from Business_Contract "+
								" where RelativeSerialNo='"+sApproveSerialNo+"'";
						rs3 = Sqlca.getASResultSet(sSql3);
						if(rs3.next())
						{
							iCount4 = rs3.getInt(1);//批复流水号
						}
						rs3.getStatement().close();
						if(iCount4==0)
						{
							iCNCONTRACTCOUNT = 1;//当前累计未签合同总笔数
							dCNCONTRACTSUM = dApproveSum;//当前累计未签合同总金额
							//----未签合同以下的值均为0
							iCNPUTOUTCOUNT = 0;//当前累计未放贷笔数
							dCNPUTOUTSUM = 0.00;//当前累计未放贷金额
							dCNORMALSUM = 0.00;//当前累计正常余额
							dCATTENTIONSUM = 0.00;//当前累计关注余额
							dCSECONDARYSUM = 0.00;//当前累计次级余额
						    dCSHADINESSSUM = 0.00;//当前累计可疑余额
							dCLOSSSUM = 0.00;//当前累计损失余额
						}
						else
						{
							iCNCONTRACTCOUNT = 0;//当前累计未签合同总笔数
							dCNCONTRACTSUM = 0.00;//当前累计未签合同总金额
							//判断是否放贷的依据是ActualPutoutSum是否>0
							String sSql4 = " select count(*) from Business_Contract "+
										   " where ActualPutoutSum>0 and RelativeSerialNo='"+sApproveSerialNo+"'";
							ASResultSet rs4 = Sqlca.getASResultSet(sSql4);
							int iCount5 = 0;
							if(rs4.next())
							{
								iCount5 = rs4.getInt(1);
							}
							rs4.getStatement().close();
							if(iCount5==0)
							{
								iCNPUTOUTCOUNT = 1;//当前累计未放贷笔数
								dCNPUTOUTSUM = dApproveSum;//当前累计未放贷金额
								//----未放贷以下的值均为0
								dCNORMALSUM = 0.00;//当前累计正常余额
								dCATTENTIONSUM = 0.00;//当前累计关注余额
								dCSECONDARYSUM = 0.00;//当前累计次级余额
							    dCSHADINESSSUM = 0.00;//当前累计可疑余额
								dCLOSSSUM = 0.00;//当前累计损失余额
							}else
							{
								iCNPUTOUTCOUNT = 0;//当前累计未放贷笔数
								dCNPUTOUTSUM = 0.00;//当前累计未放贷金额
								String sContractSerialNo = "";
								sContractSerialNo = Sqlca.getString(" Select SerialNo from Business_Contract where RelativeSerialNo='"+sApproveSerialNo+"'");
								int iCount6 = 0;
								sSql4 = " select count(*) from Business_DueBill where RelativeSerialNo2='"+sContractSerialNo+"'";
								rs4 = Sqlca.getASResultSet(sSql4);
								if(rs4.next())
								{
									iCount6 = rs4.getInt(1);
								}
								rs4.getStatement().close();
								if(iCount6==0)
								{
									dCNORMALSUM = 0.00;//当前累计正常余额
									dCATTENTIONSUM = 0.00;//当前累计关注余额
									dCSECONDARYSUM = 0.00;//当前累计次级余额
								    dCSHADINESSSUM = 0.00;//当前累计可疑余额
									dCLOSSSUM = 0.00;//当前累计损失余额
									//System.out.println("--------------"+sContractSerialNo);
								}else
								{
									sSql4 = " select ClassifyResult,sum(balance*getERate(BusinessCurrency,'01','"+sSTATISTICDATE+"')) as Balance "+
										    " from Business_DueBill where RelativeSerialNo2='"+sContractSerialNo+"' group by ClassifyResult";
									rs4 = Sqlca.getASResultSet(sSql4);
									while(rs4.next())
									{
										String sClassifyResult = rs4.getString("ClassifyResult");
										
										if(sClassifyResult==null) sClassifyResult = "";
										if(sClassifyResult.equals("")||sClassifyResult.equals("01"))
											dCNORMALSUM += rs4.getDouble("Balance");//当前累计正常余额(未评级当正常算)
										else if(sClassifyResult.equals("02"))
											dCATTENTIONSUM += rs4.getDouble("Balance");//当前累计关注余额
										else if(sClassifyResult.equals("03"))
											dCSECONDARYSUM += rs4.getDouble("Balance");//当前累计次级余额
										else if(sClassifyResult.equals("04"))
											dCSHADINESSSUM += rs4.getDouble("Balance");//当前累计可疑余额
										else if(sClassifyResult.equals("05"))
											dCLOSSSUM += rs4.getDouble("Balance");//当前累计损失余额
										else
											throw new Exception("出现未知的五级分类的代码,请检查!");
									}
									rs4.getStatement().close();
								}//判断是否有借据
							}//判断是否放贷
						}//判断是否签合同
					}//判断是否签批复
					if(!sEndTime.equals("") && sEndTime.substring(0,4).equals(sSTATISTICDATE.substring(0,4)))//统计本年
					{
						iYAGGREECOUNT = iCAGGREECOUNT;//本年批准总笔数
						iYDISAGREECOUNT = iCDISAGREECOUNT;//本年否决总笔数
						iYAGGREETIME = iCAGGREETIME;//本年批准总耗时
						iYDISAGREETIME = iCDISAGREETIME;//本年否决总耗时
						iYAFLOATCOUNT = iCAFLOATCOUNT;//本年在途总笔数	
						iYAFLOATTIME = iCAFLOATTIME;//本年在途总耗时
						iYNAPPROVECOUNT= iCNAPPROVECOUNT;//本年未签批复总笔数
						dYNAPPROVESUM = dCNAPPROVESUM;//本年未签批复总金额
						iYNCONTRACTCOUNT = iCNCONTRACTCOUNT;//本年未签合同总笔数
						dYNCONTRACTSUM = dCNCONTRACTSUM;//本年未签合同总金额 
						iYNPUTOUTCOUNT = iCNPUTOUTCOUNT;//本年未放贷笔数
						dYNPUTOUTSUM = dCNPUTOUTSUM;//本年未放贷金额
						dYNORMALSUM = dCNORMALSUM;//本年正常余额
						dYATTENTIONSUM = dCATTENTIONSUM;//本年关注余额
						dYSECONDARYSUM = dCSECONDARYSUM;//本年次级余额
						dYSHADINESSSUM = dCSHADINESSSUM;//本年可疑余额
						dYLOSSSUM = dCLOSSSUM;//本年损失余额
						if(sEndTime.substring(0,7).equals(sSTATISTICDATE.substring(0,7)))//统计本月数据(本月的数字和本年一样)
						{
							iMAGGREECOUNT = iCAGGREECOUNT;//本月批准总笔数
							iMDISAGREECOUNT = iCDISAGREECOUNT;//本月否决总笔数
							iMAFLOATCOUNT = iCAFLOATCOUNT;//本月在途总笔数	
							iMAGGREETIME = iCAGGREETIME;//本月批准总耗时
							iMDISAGREETIME = iCDISAGREETIME;//本月否决总耗时
							iMAFLOATTIME = iCAFLOATTIME;//本月在途总耗时
							iMNAPPROVECOUNT = iCNAPPROVECOUNT;//本月未签批复总笔数
							dMNAPPROVESUM = dCNAPPROVESUM;//本月未签批复总金额
							iMNCONTRACTCOUNT = iCNCONTRACTCOUNT;//本月未签合同总笔数
							dMNCONTRACTSUM = dCNCONTRACTSUM;//本月未签合同总金额 
							iMNPUTOUTCOUNT = iCNPUTOUTCOUNT;//本月未放贷笔数
							dMNPUTOUTSUM = dCNPUTOUTSUM;//本月未放贷金额
							dMNORMALSUM = dCNORMALSUM;//本月正常余额
							dMATTENTIONSUM = dCATTENTIONSUM;//本月关注余额
							dMSECONDARYSUM = dCSECONDARYSUM;//本月次级余额
							dMSHADINESSSUM = dCSHADINESSSUM;//本月可疑余额
							dMLOSSSUM = dCLOSSSUM;//本月损失余额
						}
						else//不是本月的值,则当月的值全部为0
						{
							iMAGGREECOUNT = 0;//本月批准总笔数
							iMDISAGREECOUNT = 0;//本月否决总笔数
							iMAFLOATCOUNT = 0;//本月在途总笔数	
							iMAGGREETIME = 0;//本月批准总耗时
							iMDISAGREETIME = 0;//本月否决总耗时
							iMAFLOATTIME = 0;//本月在途总耗时
							iMNAPPROVECOUNT = 0;//本月未签批复总笔数
							dMNAPPROVESUM = 0.00;//本月未签批复总金额
							iMNCONTRACTCOUNT = 0;//本月未签合同总笔数
							dMNCONTRACTSUM = 0.00;//本月未签合同总金额 
							iMNPUTOUTCOUNT = 0;//本月未放贷笔数
							dMNPUTOUTSUM = 0.00;//本月未放贷金额
							dMNORMALSUM = 0.00;//本月正常余额
							dMATTENTIONSUM = 0.00;//本月关注余额
							dMSECONDARYSUM = 0.00;//本月次级余额
							dMSHADINESSSUM = 0.00;//本月可疑余额
							dMLOSSSUM = 0.00;//本月损失余额
						}
					} else//不是当年的值,则当年当月的值均为0
					{
						iYAGGREECOUNT = 0;//本年批准总笔数
						iYDISAGREECOUNT = 0;//本年否决总笔数
						iYAGGREETIME = 0;//本年批准总耗时
						iYDISAGREETIME = 0;//本年否决总耗时
						iYAFLOATCOUNT = 0;//本年在途总笔数	
						iYAFLOATTIME = 0;//本年在途总耗时
						iYNAPPROVECOUNT= 0;//本年未签批复总笔数
						dYNAPPROVESUM = 0.00;//本年未签批复总金额
						iYNCONTRACTCOUNT = 0;//本年未签合同总笔数
						dYNCONTRACTSUM = 0.00;//本年未签合同总金额 
						iYNPUTOUTCOUNT = 0;//本年未放贷笔数
						dYNPUTOUTSUM = 0.00;//本年未放贷金额
						dYNORMALSUM = 0.00;//本年正常余额
						dYATTENTIONSUM = 0.00;//本年关注余额
						dYSECONDARYSUM = 0.00;//本年次级余额
						dYSHADINESSSUM = 0.00;//本年可疑余额
						dYLOSSSUM = 0.00;//本年损失余额
						iMAGGREECOUNT = 0;//本月批准总笔数
						iMDISAGREECOUNT = 0;//本月否决总笔数
						iMAFLOATCOUNT = 0;//本月在途总笔数	
						iMAGGREETIME = 0;//本月批准总耗时
						iMDISAGREETIME = 0;//本月否决总耗时
						iMAFLOATTIME = 0;//本月在途总耗时
						iMNAPPROVECOUNT = 0;//本月未签批复总笔数
						dMNAPPROVESUM = 0.00;//本月未签批复总金额
						iMNCONTRACTCOUNT = 0;//本月未签合同总笔数
						dMNCONTRACTSUM = 0.00;//本月未签合同总金额 
						iMNPUTOUTCOUNT = 0;//本月未放贷笔数
						dMNPUTOUTSUM = 0.00;//本月未放贷金额
						dMNORMALSUM = 0.00;//本月正常余额
						dMATTENTIONSUM = 0.00;//本月关注余额
						dMSECONDARYSUM = 0.00;//本月次级余额
						dMSHADINESSSUM = 0.00;//本月可疑余额
						dMLOSSSUM = 0.00;//本月损失余额
					}
				 }
		 sSql2 = "Insert Into Approve_Performance_D values("+
		 		 "'"+sSerialNo+"', " +
		 		 "'"+sSTATISTICDATE+"', " +
		 		 "'"+sORGID+"', " +
		 		 "'"+sUSERID+"', "+
		 		 "'"+sFLOWNO+"', "+
		 		 "'"+sPHASENO+"', "+
		 		 ""+iCURRDEALCOUNT+", "+
		 		 ""+dCURRDEALSUM+", "+
		 		 ""+iMAGGREECOUNT+", "+
		 		 ""+iMDISAGREECOUNT+", "+
		 		 ""+iMAFLOATCOUNT+", "+
		 		 ""+iMAGGREETIME+", "+
		 		 ""+iMDISAGREETIME+", "+
		 		 ""+iMAFLOATTIME+", "+
		 		 ""+iMNAPPROVECOUNT+", "+
		 		 ""+dMNAPPROVESUM+", "+
		 		 ""+iMNCONTRACTCOUNT+", "+
		 		 ""+dMNCONTRACTSUM+", "+
		 		 ""+iMNPUTOUTCOUNT+", "+
		 		 ""+dMNPUTOUTSUM+", "+
		 		 ""+dMNORMALSUM+", "+
		 		 ""+dMATTENTIONSUM+", "+
		 		 ""+dMSECONDARYSUM+", "+
		 		 ""+dMSHADINESSSUM+", "+
		 		 ""+dMLOSSSUM+", "+
		 		 ""+dMAPPLYSUM+", "+
		 		 ""+iYAGGREECOUNT+", "+
		 		 ""+iYDISAGREECOUNT+", "+
		 		 ""+iYAFLOATCOUNT+", "+
		 		 ""+iYAGGREETIME+", "+
		 		 ""+iYDISAGREETIME+", "+
		 		 ""+iYAFLOATTIME+", "+
		 		 ""+iYNAPPROVECOUNT+", "+
		 		 ""+dYNAPPROVESUM+", "+
		 		 ""+iYNCONTRACTCOUNT+", "+
		 		 ""+dYNCONTRACTSUM+", "+
		 		 ""+iYNPUTOUTCOUNT+", "+
		 		 ""+dYNPUTOUTSUM+", "+
		 		 ""+dYNORMALSUM+", "+
		 		 ""+dYATTENTIONSUM+", "+
		 		 ""+dYSECONDARYSUM+", "+
		 		 ""+dYSHADINESSSUM+", "+
		 		 ""+dYLOSSSUM+", "+
		 		 ""+dYAPPLYSUM+", "+
		 		 ""+iCAGGREECOUNT+", "+
		 		 ""+iCDISAGREECOUNT+", "+
		 		 ""+iCAFLOATCOUNT+", "+
		 		 ""+iCAGGREETIME+", "+
		 		 ""+iCDISAGREETIME+", "+
		 		 ""+iCAFLOATTIME+", "+
		 		 ""+iCNAPPROVECOUNT+", "+
		 		 ""+dCNAPPROVESUM+", "+
		 		 ""+iCNCONTRACTCOUNT+", "+
		 		 ""+dCNCONTRACTSUM+", "+
		 		 ""+iCNPUTOUTCOUNT+", "+
		 		 ""+dCNPUTOUTSUM+", "+
		 		""+dCNORMALSUM+", "+
		 		""+dCATTENTIONSUM+", "+
		 		""+dCSECONDARYSUM+", "+
		 		""+dCSHADINESSSUM+", "+
		 		""+dCLOSSSUM+", "+
		 		""+dCAPPLYSUM+")";
		 //System.out.print(sSql2);
		 Sqlca.executeSQL(sSql2);
		 System.out.println("处理业务流水号为"+sSerialNo+",流程编号为"+sFLOWNO+",所处阶段为"+sPHASENO+",审批人员为"+sUSERID);		 
			 }//end of FLow_Task
			 rs1.getStatement().close();

		}//end of Business_Apply
		rs.getStatement().close();
		System.out.println("日表Approve_Performance_D基础数据完成");
		return "Finish";
	}
	
	//清除表中所有的记录
	 private void clearRecord(Transaction Sqlca) throws Exception
	 {
		 String sSql = "";
		 sSql = " delete from Approve_Performance_D";
		 //执行更新语句
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 /**
	  * 计算本年申请金额和本月申请金额
	  * @param:申请日期，统计日期，申请金额，标志（"M"代表月，"Y"代表年）
	  * @Return:本年申请金额或本月申请金额
	  * */
	 private double getBusinessSum (String sOccurDate,String sSTATISTICDATE,double dBusinessSum,String sFalg)
	 {
		 double dResult = 0.00;
		 if(sOccurDate.length()>=7 && sSTATISTICDATE.length()>=7)//判断长度，避免越界
		 {
			 if(sFalg.equals("M"))
			 {
				 if(sOccurDate.substring(0,7).equals(sSTATISTICDATE.substring(0,7)))
				 {
					 dResult = dBusinessSum;
				 }
				 else 
					 dResult = 0.00;
			 }
			 if(sFalg.equals("Y"))
			 {
				 if(sOccurDate.substring(0,4).equals(sSTATISTICDATE.substring(0,4)))
				 {
					 dResult = dBusinessSum;
				 }
				 else 
					 dResult = 0.00;
			 }
		 }
		 else
		 {
			 System.out.println("发生日期、统计日期为空或者为不合理数据");
			 dResult = 0.00;
		 }
		 return dResult;
	 }
	 /**
	  * 取流程意见
	  * @param:申请流水号，流程类型，所处阶段，审批人员,事务处理对象
	  * @Return:返回该审批人员最后一次审批的意见
	  * 
	  * */  
	 private String getPhaseOpinion (String sSerialNo,String sFlowNo,String sPhaseNo,String sUserID,Transaction Sqlca) throws Exception
	 {
		 String sSql2 = "";
		 String sPhaseOpinion = "";
		 ASResultSet rs2 = null;
		 sSql2 = " Select PhaseOpinion1 from Flow_Task where ObjectType='CreditApply' "+
		         " and ObjectNo='"+sSerialNo+"' and UserID='"+sUserID+"' "+
		         " and PhaseNo='"+sPhaseNo+"' and FlowNo='"+sFlowNo+"' "+
		         " and EndTime =(select Max(EndTime) from Flow_Task where ObjectType='CreditApply' "+
		         " and ObjectNo='"+sSerialNo+"' and UserID='"+sUserID+"' "+
		         " and PhaseNo='"+sPhaseNo+"' and FlowNo='"+sFlowNo+"')";

		 rs2 = Sqlca.getASResultSet(sSql2);
		 if(rs2.next())
		 {
			 sPhaseOpinion = rs2.getString("PhaseOpinion1");//取审批人的意见
		 }
		 else
		 {
			 sPhaseOpinion = "";
		 }
		 rs2.getStatement().close();
		 return sPhaseOpinion;
	 }
	 /**
	  * 取最后一次审批时间
	  * @param:申请流水号，流程类型，所处阶段，审批人员,事务处理对象
	  * @Return:返回该审批人员最后一次审批时间(yyyy/mm/dd)
	  * 
	  * */  
	 private String getEndTime (String sSerialNo,String sFlowNo,String sPhaseNo,String sUserID,Transaction Sqlca) throws Exception
	 {
		 String sSql2 = "";
		 String sEndTime = "";
		 ASResultSet rs2 = null;
		 sSql2 = " Select Max(EndTime) as EndTime from Flow_Task where ObjectType='CreditApply' "+
		         " and ObjectNo='"+sSerialNo+"' and UserID='"+sUserID+"' "+
		         " and PhaseNo='"+sPhaseNo+"' and FlowNo='"+sFlowNo+"' ";

		 rs2 = Sqlca.getASResultSet(sSql2);
		 if(rs2.next())
		 {
			 sEndTime = rs2.getString("EndTime");//取审批人的意见
			 sEndTime = sEndTime.substring(0,10);//取yyyy/mm/dd
		 }
		 else
		 {
			 sEndTime = "";
		 }
		 rs2.getStatement().close();
		 return sEndTime;
	 }
	 /**
	  * 取审批总耗时
	  * @param:申请流水号，流程类型，所处阶段，审批人员,事务处理对象
	  * @Return:返回该审批人员最后一次审批时间(yyyy/mm/dd)
	  * 
	  * */  
	 private int getSumTime (String sSerialNo,String sFlowNo,String sPhaseNo,String sUserID,Transaction Sqlca) throws Exception
	 {
		 String sSql2 = "";
		 int iSum = 0;
		 ASResultSet rs2 = null;
		 sSql2 = " select Sum(ceil(to_date(endtime,'yyyy/mm/dd hh24:mi:ss')-"+
			     " to_date(begintime,'yyyy/mm/dd hh24:mi:ss'))) as Sum1 "+
			     " from Flow_Task where ObjectType='CreditApply' "+
			     " and ObjectNo='"+sSerialNo+"' and UserID='"+sUserID+"' "+
			     " and PhaseNo='"+sPhaseNo+"' and FlowNo='"+sFlowNo+"' "+
			     " and EndTime is not null";
		 rs2 = Sqlca.getASResultSet(sSql2);
		 if(rs2.next())
		 {
			 iSum = rs2.getInt("Sum1");//取审批人的意见
		 }
		 else
		 {
			 iSum = 0;
		 }
		 rs2.getStatement().close();
		 return iSum;
	 }
	 
}
