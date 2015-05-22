package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class DataDuebillRetailHandler{
	public static void beforeHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca)throws Exception{
		//更新配置号和报表日期
 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and ImportNo like 'N%000000'");
		//清空目标表 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	}
	/**
	 * 零售借据导入后处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public static void handle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//先导入到数据库,并清空目标表，为数据处理做准备
		DataDuebillRetailHandler.beforeHandle(HandlerFlag, sConfigNo, sOneKey, Sqlca);
		//1、对中间表数据进行特殊处理 	 		 	
		DataDuebillRetailHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
 		String groupBy="case "+
		 				" when ~s个人明细@归属条线e~ ='个人条线' or ~s个人明细@归属条线e~ = '微小条线' or ~s个人明细@归属条线e~ = '零售条线' then '零售条线'"+
		 				" when ~s个人明细@归属条线e~ = '小企业条线' then '小企业条线' "+
		 				" else '其他条线' end";
 		DataDuebillRetailHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"归属条线",groupBy,"and (~s个人明细@业务品种e~<>'个人委托贷款' and ~s个人明细@业务品种e~<>'个人住房公积金贷款')");
	 	//4、加工后，进行合计，横向纵向分析
 		DataDuebillRetailHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	//对导入数据加工处理,插入到中间表Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		//1、归属条线 个人条线统一修改为 零售条线
		String sSql="update Batch_Import_Interim set ~s个人明细@归属条线e~='零售条线' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and (nvl(~s个人明细@归属条线e~,'')='个人条线' or nvl(~s个人明细@归属条线e~,'')='微小条线')";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
	}
	/**
	 * 按各个维度插入到处理表中
	 * @throws Exception 
	 */
	public static void process(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca,String Dimension,String groupBy,String sWhere) throws Exception{
		//当前导入月份的前两个月
		boolean isSeason=false;
		String last2month="";
		String last1month="";
		if(StringFunction.isLike(sKey, "%03")||StringFunction.isLike(sKey, "%06")||StringFunction.isLike(sKey, "%09")||StringFunction.isLike(sKey, "%12")){
			last2month=StringFunction.getRelativeAccountMonth(sKey,"month", -2);
			last1month=StringFunction.getRelativeAccountMonth(sKey,"month", -1);
			isSeason=true;
		}
		String sSql="";
 		//1、按各种维度汇总到处理表中
		String groupColumns=groupBy.replaceAll(",","||'@'||");
		groupColumns=("".equals(groupColumns)?"":groupColumns+",");
 		sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,'"+Dimension+"',"+groupColumns+
				"round(sum(case when ~s个人明细@借据起始日e~ like '"+sKey+"%' then ~s个人明细@金额e~ end)/10000,2) as BusinessSum,"+//按月投放金额
				(isSeason==true?"round(sum(case when ~s个人明细@借据起始日e~ like '"+last2month+"%' or ~s个人明细@借据起始日e~ like '"+last1month+"%' or ~s个人明细@借据起始日e~ like '"+sKey+"%' then ~s个人明细@金额e~ end)/10000,2)":"0")+","+//如果是季度末，计算按季投放金额
				"round(case when sum(~s个人明细@金额e~)<>0 then sum(~s个人明细@金额e~*~s个人明细@执行利率(%)e~)/sum(~s个人明细@金额e~) else 0 end,2) as BusinessRate, "+//加权利率
				"round(sum(~s个人明细@余额e~)/10000,2) as Balance, "+
				"count(distinct ~s个人明细@客户名称e~) "+
				"from Batch_Import_Interim "+
				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s个人明细@余额e~,0)>0 "+sWhere+
				" group by ConfigNo,OneKey"+("".equals(groupBy)?"":","+groupBy);
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,BusinessRate,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
	}
	//加入小计 合计 横向纵向比较值
	public static void afterProcess(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		//1、插入各个维度的小计
 		sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)||'小计',"+
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2),sum(TotalTransaction) "+
			"from Batch_Import_Process "+
			"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('@',DimensionValue)>0 "+
			"group by ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
		//2、插入各个维度的总计
 		sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,Dimension,'总计@总计',"+
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2) as Balance,sum(TotalTransaction) "+
			"from Batch_Import_Process "+
			"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('小计',DimensionValue)=0 "+
			"group by ConfigNo,OneKey,Dimension";
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
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
					")tab1,"+
					"(select Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance "+	
						"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('总计',DimensionValue)>0 "+
					")tab2"+
					" where tab1.Dimension=tab2.Dimension)tab3"+
				" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BusinessSumRatio,BusinessSumSeasonRatio,BalanceRatio)="+
 				"(select tab3.BusinessSumRatio,tab3.BusinessSumSeasonRatio,tab3.BalanceRatio "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 "+sSql+")"
 				);
 		//4、相对前一年度增加值和幅度更新
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
		 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
		 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
		 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY from "+
					"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+
						"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
					")tab1,"+
					"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+	
					"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
					")tab2"+
					" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
			" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";	
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BalanceTLY,BusinessRateTLY,BalanceRangeTLY)="+
 				"(select tab3.BalanceTLY,tab3.BusinessRateTLY,tab3.BalanceRangeTLY "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 "+sSql+")"
 				);
 			//如果是年度导入，更新下一年度所有月份的增加值、增加值和幅度更新
 		if(StringFunction.isLike(sKey, "%/12")){
 			sSql="select distinct OneKey from Batch_Import_Process where ConfigNo='"+sConfigNo+"' and OneKey>'"+sKey+"'";
 			String[] sOneKey=Sqlca.getStringArray(sSql);
 			String OneKeys=StringFunction.toArrayString(sOneKey, "','");
 			sSql="from (select tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
		 	 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
		 	 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
		 	 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY from "+
		 				"(select OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+
		 					"from Batch_Import_Process "+
		 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
		 				")tab1,"+
		 				"(select OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+	
		 				"from Batch_Import_Process "+
		 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
		 				")tab2"+
		 				" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
 				" where tab.OneKey=tab3.OneKey and tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";	
 	 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 	 				"set(BalanceTLY,BusinessRateTLY,BalanceRangeTLY)="+
 	 				"(select tab3.BalanceTLY,tab3.BusinessRateTLY,tab3.BalanceRangeTLY "+
 	 				sSql+
 	 				")"+
 	 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 	 				" and exists(select 1 "+sSql+")"
 	 				);
 		}
	}
}