/*
Author:   xhyong 2009/09/25
Tester:
Describe: 完成抵债资产日常管理监控报告
Input Param:
		SerialNo: 以资抵债流水号
		ReportType: 报告类型
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;

public class FinishNPAReport extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{			
		//获取参数:合同号,报告类型
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sReportType = (String)this.getAttribute("ReportType");
		
		//将空值转化成空字符串
		if(sSerialNo == null) sSerialNo = "";
		if(sReportType == null) sReportType = "";//默认为一般监控
		
		//定义变量:
		String sReturnMessage = "",sAssetStatus = "";
		String sAssetAmount = "",sDescribe1 = "",sDescribe2 = "";
		String sDescribe3 = "",sDescribe4 = "";
		String sAssetCustomerName = "",sAssetLocation = "",sAssetOccurType = "";
		double dAssetAccountSum = 0.00,dAssetSaleSum = 0.00,dAssetLendSum = 0.00;
		double dAssetDisposeSum = 0.00,dAssetAccountBalance = 0.00;
		int dCount = 0;
		double dEvalNetValue = 0.00;
		//定义数据集
		String sSql = "";
		ASResultSet rs=null;
		//查询是否有进行有监控
		sSql = "select count(SerialNo) as Count  from ASSET_REPORT "+
				" where ObjectNo='"+sSerialNo+"'"+
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
			sSql = "select AssetCustomerName,AssetLocation,AssetStatus,EvalNetValue,AssetAmount,Describe1," +
					" Describe2,Describe3,Describe4,AssetOccurType,AssetAccountSum,AssetSaleSum, " +
					" AssetLendSum,AssetDisposeSum,AssetAccountBalance "+
					" from ASSET_REPORT where SerialNo " +
					" in(select Max(SerialNo)  from ASSET_REPORT "+
					" where ObjectNo='"+sSerialNo+"'"+
					" and (FinishDate is null or FinishDate ='') "+
					" and ReportType='010')";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){	
				sAssetStatus = rs.getString("AssetStatus");//抵债资产现状
				dEvalNetValue = rs.getDouble("EvalNetValue");//评估价值/市场公允价值
				sAssetAmount = rs.getString("AssetAmount");//抵债资产数量
				sDescribe1 = rs.getString("Describe1");//抵债资产质量现状和质量暇疵
				sDescribe2 = rs.getString("Describe2");//抵债资产权属现状及权利暇疵
				sDescribe3 = rs.getString("Describe3");//抵债资产权证办理情况及完整、有效程度
				sDescribe4 = rs.getString("Describe4");//抵债资产变现能力分析及处置预案
				sAssetCustomerName = rs.getString("AssetCustomerName");//抵偿人名称
				sAssetLocation = rs.getString("AssetLocation");//坐落(保管)地点
				sAssetOccurType = rs.getString("AssetOccurType");//发生类型
				dAssetAccountSum = rs.getDouble("AssetAccountSum");//抵债资产入账金额
				dAssetSaleSum = rs.getDouble("AssetSaleSum");//抵债资产出售变现金额
				dAssetLendSum = rs.getDouble("AssetLendSum");//抵债资产出租变现金额
				dAssetDisposeSum = rs.getDouble("AssetDisposeSum");//抵债资产处置损失金额
				dAssetAccountBalance = rs.getDouble("AssetAccountBalance");//抵债资产账面余额
			}
			rs.getStatement().close();
			//更新到抵债资产对应信息
			//只针对台帐信息维护
			if(sReportType.equals("010"))
			{
				sSql = " UPDATE ASSET_INFO SET AssetStatus='"+sAssetStatus+"',"+
						" EvalNetValue="+dEvalNetValue+",AssetAmount='"+sAssetAmount+"',"+
						" Describe1='"+sDescribe1+"',Describe2='"+sDescribe2+"',"+
						" Describe3='"+sDescribe3+"',Describe4='"+sDescribe4+"', "+
						" AssetLocation='"+sAssetLocation+"',AssetCustomerName='"+sAssetCustomerName+"',"+
						" AssetOccurType='"+sAssetOccurType+"',AssetAccountSum="+dAssetAccountSum+","+
						" AssetSaleSum='"+dAssetSaleSum+"',AssetLendSum="+dAssetLendSum+","+
						" AssetDisposeSum='"+dAssetDisposeSum+"',AssetAccountBalance="+dAssetAccountBalance+" "+
						" WHERE SerialNo='"+sSerialNo+"'";
				Sqlca.executeSQL(sSql);
			}
			
			//置监控完成标识别
			sSql = " UPDATE ASSET_REPORT SET FinishDate='"+StringFunction.getToday()+"' "+
					" WHERE ObjectNo='"+sSerialNo+"' and (FinishDate is null or FinishDate ='') " +
					" and ReportType='"+sReportType+"'";
			Sqlca.executeSQL(sSql);
			//更新合同监控日期
			if(sReportType.equals("020"))//盘点清查
			{
				sSql = " UPDATE ASSET_INFO SET LiquidateDate='"+StringFunction.getToday()+"' "+
						" WHERE SerialNo='"+sSerialNo+"'";
				Sqlca.executeSQL(sSql);
			}else//台帐维护
			{
				sSql = " UPDATE ASSET_INFO SET VindicateDate='"+StringFunction.getToday()+"' "+
						" WHERE SerialNo='"+sSerialNo+"'";
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

