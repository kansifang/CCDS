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
		//1、公用基础子查询表，可以不断添加字段满足需要
		String sCSql="select OneKey," +
					" Case when ConfigName='个人明细' then ~s个人明细@客户名称e~ else ~s借据明细@客户名称e~ end CustomerName, " +
					" Case when ConfigName='个人明细' then ~s个人明细@归属条线e~ else ~s借据明细@归属条线e~ end ManageDepartFlag, " +
					" Case when ConfigName='个人明细' then ~s个人明细@五级分类e~ else ~s借据明细@五级分类e~ end Classify, " +
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
 				"HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)||'@小计',"+
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
 				"HandlerFlag,ConfigNo,OneKey,Dimension,'总计@总计',"+
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
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"' and locate('总计',DimensionValue)>0"+
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
 		//5、如果是年度导入，更新下一年度所有月份的增加值、增加值和幅度更新
 		if(StringFunction.isLike(sKey, "%/12")){
 			sSql="select distinct OneKey from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey>'"+sKey+"'";
 			String[] sOneKey=Sqlca.getStringArray(sSql);
 			String OneKeys=StringFunction.toArrayString(sOneKey, "','");
 			sSql="from (select tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
		 	 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
		 	 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
		 	 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY from "+
		 				"(select OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+
		 					"from Batch_Import_Process "+
		 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey in('"+OneKeys+"')"+
		 				")tab1,"+
		 				"(select OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+	
		 				"from Batch_Import_Process "+
		 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"'"+
		 				")tab2"+
		 				" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
 				" where tab.OneKey=tab3.OneKey and tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";	
 	 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 	 				"set(BalanceTLY,BusinessRateTLY,BalanceRangeTLY)="+
 	 				"(select tab3.BalanceTLY,tab3.BusinessRateTLY,tab3.BalanceRangeTLY "+
 	 				sSql+
 	 				")"+
 	 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey in('"+OneKeys+"')"+
 	 				" and exists(select 1 "+sSql+")"
 	 				);
 		}
	}
	public static void lastProcess(String HandlerFlag,String sReportConfigNo,String sKey,Transaction Sqlca)throws Exception{
		//把 我行短期流动资金比例，央行 金融机构短期流动资金比例 中小金融机构短期流动资金比例 汇总到一块儿，以生成折线图
 		String sSql="select  "+
 				"'"+HandlerFlag+"','"+sReportConfigNo+"',OneKey,'短期贷款占比','我行短期贷款占比',"+
 				" round(sum(BIP4.BalanceRatio),2),"+
 				"'"+StringFunction.getTodayNow()+"'"+
 				" from Batch_Import_Process BIP4"+
 				" where BIP4.ConfigNo='b20140522000001' and BIP4.OneKey='"+sKey+"'" +
 				" and BIP4.Dimension='期限业务品种'  " +
 				" and locate('小计',BIP4.DimensionValue)>0 " +
 				" and (DimensionValue like '1M%' or DimensionValue like '2M%') " +
 				" group by BIP4.OneKey"+
 				" union all "+
 				" select "+
 				"'"+HandlerFlag+"','"+sReportConfigNo+"','"+sKey+"','短期贷款占比','中小型银行短期贷款占比',"+
 				"round(case when sum(~s金融机构人民币信贷收支表@"+sKey.substring(sKey.lastIndexOf("/")+1)+"e~)<>0 then sum(case when ~s金融机构人民币信贷收支表@项目Iteme~ like '1.%短期贷款%' then ~s金融机构人民币信贷收支表@"+sKey.substring(sKey.lastIndexOf("/")+1)+"e~ else 0 end)/double(sum(~s金融机构人民币信贷收支表@"+sKey.substring(sKey.lastIndexOf("/")+1)+"e~))*100 else 0 end,2),"+
 				"'"+StringFunction.getTodayNow()+"'"+
 				" from Batch_Import_Interim "+
				" where ConfigNo='b20140720000001' and OneKey like'"+sKey.substring(0,sKey.lastIndexOf("/"))+"%'" +
				" and (~s金融机构人民币信贷收支表@项目Iteme~ like '1.%短期贷款%' or ~s金融机构人民币信贷收支表@项目Iteme~ like '2.%中长期贷款%')"+
				" union all"+
				" select "+
 				"'"+HandlerFlag+"','"+sReportConfigNo+"','"+sKey+"','短期贷款占比','金融机构短期贷款占比',"+
 				"round(case when sum(~s金融机构人民币信贷收支表@"+sKey.substring(sKey.lastIndexOf("/")+1)+"e~)<>0 then sum(case when ~s金融机构人民币信贷收支表@项目Iteme~ like '1.%短期贷款%' then ~s金融机构人民币信贷收支表@"+sKey.substring(sKey.lastIndexOf("/")+1)+"e~ else 0 end)/double(sum(~s金融机构人民币信贷收支表@"+sKey.substring(sKey.lastIndexOf("/")+1)+"e~))*100 else 0 end,2),"+				
 				"'"+StringFunction.getTodayNow()+"'"+
 				" from Batch_Import_Interim "+
				" where ConfigNo='b20140720000002' and OneKey like'"+sKey.substring(0,sKey.lastIndexOf("/"))+"%'" +
				" and (~s金融机构人民币信贷收支表@项目Iteme~ like '1.%短期贷款%' or ~s金融机构人民币信贷收支表@项目Iteme~ like '2.%中长期贷款%')";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BalanceRatio,InputTime)"+
 				"( "+
 				sSql+
 				")");
	}
}