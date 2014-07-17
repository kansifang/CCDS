package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class BDRiskReportHandler{
	//对导入数据加工处理,插入到中间表Batch_Import_Interim
	public static void interimProcess(String sReportConfigNo,String sKey,Transaction Sqlca) throws Exception{
		String sSql="";
		/*
		//1、清除重复客户-----不同sheet同一客户重复时则importNo不同  在一个sheet内重复同一客户时，importNo相同但importIndex不同 ，
		sSql="delete from Batch_Import BI1 where ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"'"+
					" and ~s客户明细@客户名称e~  in "+
						"(select BI2.~s客户明细@客户名称e~ from Batch_Import BI2"+
						" where BI2.ConfigNo='"+sReportConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s客户明细@客户名称e~ having count(1)>1)"+
					" and ImportNo||ImportIndex not in "+
						"(select max(ImportNo||ImportIndex) from Batch_Import BI2 "+
						" where BI2.ConfigNo='"+sReportConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s客户明细@客户名称e~ having count(1)>1)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		
 		sSql="delete from Batch_Import_Interim BI1 where ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"'"+
				" and ~s客户明细@客户名称e~  in "+
					"(select BI2.~s客户明细@客户名称e~ from Batch_Import_Interim BI2"+
					" where BI2.ConfigNo='"+sReportConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s客户明细@客户名称e~ having count(1)>1)"+
				" and ImportNo||ImportIndex not in "+
					"(select max(ImportNo||ImportIndex) from Batch_Import_Interim BI2 "+
					" where BI2.ConfigNo='"+sReportConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s客户明细@客户名称e~ having count(1)>1)";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
		*/
	}
	/**
	 * 按各个维度插入到处理表中
	 * @throws Exception 
	 */
	public static void process(String HandlerFlag,String sReportConfigNo,String sKey,Transaction Sqlca,String Dimension,String groupBy,String sWhere) throws Exception{
		//当前导入月份的前两个月
		boolean isSeason=false;
		String last2month="";
		String last1month="";
		if(StringFunction.isLike(sKey, "%03")||StringFunction.isLike(sKey, "%06")||StringFunction.isLike(sKey, "%09")||StringFunction.isLike(sKey, "%12")){
			last2month=StringFunction.getRelativeAccountMonth(sKey,"month", -2);
			last1month=StringFunction.getRelativeAccountMonth(sKey,"month", -1);
			isSeason=true;
		}
		//1、按条线汇总到处理表中
		String sCSql="select OneKey," +
					" Case when ConfigName='个人明细' then ~s个人明细@客户名称e~ else ~s借据明细@客户名称e~ end CustomerName, " +
					" Case when ConfigName='个人明细' then ~s个人明细@归属条线e~ else ~s借据明细@归属条线e~ end ManageDepartFlag, " +
					" Case when ConfigName='个人明细' then nvl(~s个人明细@金额e~,0) else nvl(~s借据明细@金额(元)e~,0) end BusinessSum, " +
					" Case when ConfigName='个人明细' then nvl(~s个人明细@执行利率(%)e~,0) else nvl(~s借据明细@执行年利率(%)e~,0) end BusinessRate, " +
					" Case when ConfigName='个人明细' then ~s个人明细@借据起始日e~ else ~s借据明细@借据起始日e~ end PutOutDate, " +
					" Case when ConfigName='个人明细' then nvl(~s个人明细@余额e~,0) else nvl(~s借据明细@余额(元)e~,0) end Balance " +
					" from Batch_Import_Interim"+
					" where ConfigName in('个人明细','借据明细') and OneKey='"+sKey+"'"+
					" and (ConfigName='个人明细' and ~s个人明细@业务品种e~ not in('个人委托贷款','个人住房公积金贷款') or ConfigName='借据明细')" +
					sWhere;
		String groupColumns=groupBy.replaceAll(",","||'@'||");
		groupColumns=("".equals(groupColumns)?"":groupColumns+",");
		String sSql="select "+
 				"'"+HandlerFlag+"','"+sReportConfigNo+"',OneKey,'"+Dimension+"',"+groupColumns+
				"round(sum(case when PutOutDate like '"+sKey+"%' then BusinessSum end)/10000,2),"+//按月投放金额
				(isSeason==true?"round(sum(case when PutOutDate like '"+last2month+"%' or PutOutDate like '"+last1month+"%' or PutOutDate like '"+sKey+"%' then BusinessSum end)/10000,2)":"0")+","+//如果是季度末，计算按季投放金额
				"round(case when sum(BusinessSum)<>0 then sum(BusinessSum*BusinessRate)/sum(BusinessSum) else 0 end,2), "+//加权利率
				"round(sum(Balance)/10000,2) as Balance, "+
				"count(distinct CustomerName),'"+StringFunction.getTodayNow()+"'"+
				" from ("+sCSql+")tab"+
				" group by OneKey"+("".equals(groupBy)?"":","+groupBy)+
				" union all"+
				" select "+
				"'"+HandlerFlag+"','"+sReportConfigNo+"','"+sKey+"','"+Dimension+"','贴现',"+
				"0,"+
				"0,"+
				"0,"+
				"round(~sG0103_存贷款@本外币合计e~,2) as Balance,"+
				"0,'"+StringFunction.getTodayNow()+"'"+
				" from Batch_Import_Interim " +
				" where ConfigName ='G0103_存贷款' and OneKey ='"+sKey+"' and ~sG0103_存贷款@项目e~='1.3贴现及买断式转贴现'";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,BusinessRate,Balance,TotalTransaction,InputTime)"+
 				"( "+
 				sSql+
 				")");
	}
	//加入小计 合计 横向纵向比较值
	public static void afterProcess(String HandlerFlag,String sReportConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		//1、插入各个维度的小计
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)||'小计',"+
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2),sum(TotalTransaction) "+
			"from Batch_Import_Process "+
			"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"' and locate('@',DimensionValue)>0 "+
			"group by HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
		//2、插入各个维度的总计
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,'总计',"+
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2) as Balance,sum(TotalTransaction) "+
			"from Batch_Import_Process "+
			"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"' and locate('小计',DimensionValue)=0 "+
			"group by HandlerFlag,ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
 		//3、占比更新
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
		 				"case when nvl(tab2.BusinessSum,0)<>0 then round(tab1.BusinessSum/tab2.BusinessSum*100,2) else 0 end as BusinessSumRatio,"+
		 				"case when nvl(tab2.BusinessSumSeason,0)<>0 then round(tab1.BusinessSumSeason/tab2.BusinessSumSeason*100,2) else 0 end as BusinessSumSeasonRatio,"+
		 				"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio from "+
					"(select Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance "+
						"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"'"+
					")tab1,"+
					"(select Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance "+	
						"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"' and DimensionValue='总计'"+
					")tab2"+
					" where tab1.Dimension=tab2.Dimension)tab3"+
				" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BusinessSumRatio,BusinessSumSeasonRatio,BalanceRatio)="+
 				"(select tab3.BusinessSumRatio,tab3.BusinessSumSeasonRatio,tab3.BalanceRatio "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 "+sSql+")"
 				);
 		//4、相对前一年度增加值和幅度更新
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
		 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
		 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
		 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY from "+
					"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+
						"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"'"+
					")tab1,"+
					"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+	
					"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
					")tab2"+
					" where tab1.Dimension=tab2.Dimension and nvl(tab1.DimensionValue,'')=nvl(tab2.DimensionValue,''))tab3"+
			" where tab.Dimension=tab3.Dimension and nvl(tab.DimensionValue,'')=nvl(tab3.DimensionValue,'')";	
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BalanceTLY,BusinessRateTLY,BalanceRangeTLY)="+
 				"(select tab3.BalanceTLY,tab3.BusinessRateTLY,tab3.BalanceRangeTLY "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 "+sSql+")"
 				);
	}
}