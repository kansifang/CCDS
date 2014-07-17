package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class BDSuperviseReportHandler{
	//对导入数据加工处理,插入到中间表Batch_Import_Interim
	public static void interimProcess(String sReportConfigNo,String sKey,Transaction Sqlca) throws Exception{
		//String sSql="";
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
		//1、按对公对私及贴现汇总到处理表中
		//单位：亿元
		String sCSql="select  '对公贷款' as Type, "+
				"		round(sum(~s借据明细@余额(元)e~)/100000000,2) as Balance"+
				"		from Batch_Import_Interim where ConfigName ='借据明细' and OneKey ='"+sKey+"'"+
				"	union all"+
				"	select '对私贷款' as Type, "+
				"		round(sum(~s个人明细@余额e~)/100000000,2) as Balance"+
				"		from Batch_Import_Interim where ConfigName ='个人明细' and OneKey ='"+sKey+"' and ~s个人明细@业务品种e~ not in('个人委托贷款','个人住房公积金贷款')"+
				"	union all"+
				"	select '贴现' as Type, "+
				"		round(~sG0103_存贷款@本外币合计e~/10000,2) as Balance"+
				"		from Batch_Import_Interim where ConfigName ='G0103_存贷款' and OneKey ='"+sKey+"' and ~sG0103_存贷款@项目e~='1.3贴现及买断式转贴现'";
		String sSql="select "+
 				"'"+HandlerFlag+"','"+sReportConfigNo+"','"+sKey+"','"+Dimension+"',Type,Balance,"+
				"'"+StringFunction.getTodayNow()+"'"+
				" from ("+sCSql+")tab";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,Balance,InputTime)"+
 				"( "+
 				sSql+
 				")");
	}
	//加入小计 合计 横向纵向比较值
	public static void afterProcess(String HandlerFlag,String sReportConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		//2、插入各个维度的总计
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,'总计',sum(Balance) "+
			"from Batch_Import_Process "+
			"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"'"+
			"group by HandlerFlag,ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,Balance)"+
 				"( "+
 				sSql+
 				")");
 		//4、相对前一年度增加值和幅度更新
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
			 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
			 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY " +
			 			"from "+
						"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+
							"from Batch_Import_Process "+
							"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"'"+
						")tab1"+
						" left join (select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+	
						"from Batch_Import_Process "+
							"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
						")tab2 on tab1.Dimension=tab2.Dimension and nvl(tab1.DimensionValue,'')=nvl(tab2.DimensionValue,'')" +
					")tab3"+
			" where tab.Dimension=tab3.Dimension and nvl(tab.DimensionValue,'')=nvl(tab3.DimensionValue,'')";	
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 							"set(BalanceTLY,BalanceRangeTLY)="+
 								"(select tab3.BalanceTLY,tab3.BalanceRangeTLY "+sSql+")"+
 						 " where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"'"+
 						 " and exists(select 1 "+sSql+")"
 				);
	}
}