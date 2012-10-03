/*
Author:   xhyong 2009/09/22
Tester:
Describe: 不良资产日常管理完成监控相关操作
Input Param:
		ContractSerialNo: 合同流水号
		ReportType: 报告类型
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishMonitor extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//获取参数:合同号,报告类型
		String sContractSerialNo = (String)this.getAttribute("ContractSerialNo");
		String sReportType = (String)this.getAttribute("ReportType");
		
		//将空值转化成空字符串
		if(sContractSerialNo == null) sContractSerialNo = "";
		if(sReportType == null) sReportType = "010";//默认为一般监控
		
		//定义变量:申请方式
		String sApplyType = "",sReturnMessage = "";
		String sBadType = "",sFactUser = "",sBorrowerManageStatus = "";
		String sBorrowerAssetStatus = "",sBorrowerAttitude = "",sDebtInstance = "";
		String sFactVouchDegree = "" ,sVouchEffectDate = "",sLawEffectDate = "";
		String sExistNewType = "",sTextDocStatus = "",sBadLoanCaliber = "";
		int dCount = 0;
		//定义数据集
		String sSql = "";
		ASResultSet rs=null;
		//查询是否有进行有监控报告
		sSql = "select count(SerialNo) as Count  from MONITOR_REPORT "+
				" where ObjectNo='"+sContractSerialNo+"'"+
				" and (FinishDate is null or FinishDate ='') "+
				" and ReportType='"+sReportType+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			dCount=rs.getInt("Count");
		}
		rs.getStatement().close();
		if(dCount >0)//如果有记录
		{
			//查询监控报告记录信息
			sSql = "select BadType,FactUser,BorrowerManageStatus,BorrowerAssetStatus," +
					" BorrowerAttitude,DebtInstance,FactVouchDegree,VouchEffectDate," +
					" LawEffectDate,ExistNewType,TextDocStatus,BadLoanCaliber " +
					" from MONITOR_REPORT where SerialNo " +
					" in(select Max(SerialNo)  from MONITOR_REPORT "+
					" where ObjectNo='"+sContractSerialNo+"'"+
					" and (FinishDate is null or FinishDate ='') "+
					" and ReportType='010')";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){	
				sBadType = rs.getString("BadType");//不良类型
				sFactUser = rs.getString("FactUser");//实际用款人
				sBorrowerManageStatus = rs.getString("BorrowerManageStatus");//借款人经营状况
				sBorrowerAssetStatus = rs.getString("BorrowerAssetStatus");//借款人资产状况
				sBorrowerAttitude = rs.getString("BorrowerAttitude");//借款人态度
				sDebtInstance = rs.getString("DebtInstance");//债务落实情况
				sFactVouchDegree = rs.getString("FactVouchDegree");//实际担保程度
				sVouchEffectDate = rs.getString("VouchEffectDate");//担保时效
				sLawEffectDate = rs.getString("LawEffectDate");//诉讼时效
				sExistNewType = rs.getString("ExistNewType");//存量新增类型
				sTextDocStatus = rs.getString("TextDocStatus");//文本档案情况
				sBadLoanCaliber = rs.getString("BadLoanCaliber");//不良贷款口径
			}
			rs.getStatement().close();
			//更新到合同对应信息
			//只针对账面不良贷款、股金置换不良贷款、央行票据置换一般监控报告进行更新
			if(sBadType.equals("010")||sBadType.equals("020")||sBadType.equals("030"))
			{
				sSql = " UPDATE BUSINESS_CONTRACT SET FactUser='"+sFactUser+"',"+
						" BorrowerManageStatus='"+sFactUser+"',BorrowerAssetStatus='"+sBorrowerAssetStatus+"',"+
						" BorrowerAttitude='"+sBorrowerAttitude+"',DebtInstance='"+sDebtInstance+"',"+
						" FactVouchDegree='"+sFactVouchDegree+"',VouchEffectDate='"+sVouchEffectDate+"',"+
						" LawEffectDate='"+sLawEffectDate+"',ExistNewType='"+sExistNewType+"',"+
						" TextDocStatus='"+sTextDocStatus+"',BadLoanCaliber='"+sBadLoanCaliber+"' "+
						" WHERE SerialNo='"+sContractSerialNo+"'";
				Sqlca.executeSQL(sSql);
			}
			//置监控完成标识别
			sSql = " UPDATE MONITOR_REPORT SET FinishDate='"+StringFunction.getToday()+"' "+
					" WHERE ObjectNo='"+sContractSerialNo+"' and (FinishDate is null or FinishDate ='') " +
					" and ReportType='"+sReportType+"'";
			Sqlca.executeSQL(sSql);
			//更新合同监控日期
			if(sReportType.equals("020"))//重点监控监控日期
			{
				sSql = " UPDATE BUSINESS_CONTRACT SET EMonitorDate='"+StringFunction.getToday()+"' "+
						" WHERE SerialNo='"+sContractSerialNo+"'";
				Sqlca.executeSQL(sSql);
			}else//一般监控监控日期
			{
				sSql = " UPDATE BUSINESS_CONTRACT SET CMonitorDate='"+StringFunction.getToday()+"' "+
						" WHERE SerialNo='"+sContractSerialNo+"'";
				Sqlca.executeSQL(sSql);
			}
			sReturnMessage="True";//操作成功
		}else
		{
			sReturnMessage="None";//没有找到对应的监控信息
		}
		return sReturnMessage;
	}

}

