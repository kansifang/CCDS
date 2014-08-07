package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class AIOperationReportHandler{
	//对导入数据加工处理,插入到中间表Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		String sSql="";
 		//1、清除掉项目名为空，类似“版本号:1410 蓝色底为含公式区域  灰色底为不填数部分”的内容 
		sSql="delete from Batch_Import_Interim "+
					"where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
					"and (nvl(~s"+sConfigNo+"@项目e~,'')='' or ~s"+sConfigNo+"@项目e~ like '版本号:%' or ~s"+sConfigNo+"@项目e~ like '%色底为%' or ~s"+sConfigNo+"@项目e~ like '附：%')";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
	}
	/**
	 * 按各个维度插入到处理表中
	 * @throws Exception 
	 */
	public static void process(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		String sConfigName=Sqlca.getString("select CodeName from Code_Catalog where CodeNo='"+sConfigNo+"'");
		if("G0101_表外".equals(sConfigName)){
 			AIOperationReportHandler.processG0101(sConfigName, HandlerFlag, sConfigNo, sKey, Sqlca);
 		}else if("G0103_存贷款".equals(sConfigName)){
 			AIOperationReportHandler.processG0103(sConfigName, HandlerFlag, sConfigNo, sKey, Sqlca);
 		}else if("G0107_行业贷款".equals(sConfigName)){
 			AIOperationReportHandler.processG0107(sConfigName, HandlerFlag, sConfigNo, sKey, Sqlca);
 		}else if("S6301_五级分类担保_企业规模".equals(sConfigName)){
 			AIOperationReportHandler.processS63(sConfigName, HandlerFlag, sConfigNo, sKey, Sqlca);
 		}
	}
	//加入小计 合计 横向纵向比较值
	public static void afterProcess(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		String sLastMonthEnd=StringFunction.getRelativeAccountMonth(sKey,"month",-1);
		//3、计算占比
 		sSql="select tab1.Dimension,tab1.DimensionValue,"+
 				"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio from "+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,Balance "+
				"from Batch_Import_Process "+
				"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1,"+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,Balance "+	
				"from Batch_Import_Process "+
				"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and (DimensionValue='1.各项贷款' or DimensionValue='总计@各项贷款余额')"+//前者是针对G0103,G0107,后者针对S63
			")tab2"+
			" where tab1.Dimension=tab2.Dimension";
 		Sqlca.executeSQL("update Batch_Import_Process tab3 "+
 				"set(BalanceRatio)="+
 				"( select BalanceRatio from "+
 				"("+sSql+") tab4 where tab3.Dimension=tab4.Dimension and tab3.DimensionValue=tab4.DimensionValue"+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 from ("+sSql+") tab22 where tab3.Dimension=tab22.Dimension and tab3.DimensionValue=tab22.DimensionValue)"
 				);
 		//4、相对前一年度增加值和幅度更新
 		sSql="select tab1.Dimension,tab1.DimensionValue,"+
 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
 				"(nvl(tab1.BalanceRatio,0)-nvl(tab2.BalanceRatio,0)) as BalanceRatioTLY,"+
 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY,"+
 				"(nvl(tab1.TotalTransaction,0)-nvl(tab2.TotalTransaction,0)) as TotalTransactionTLY,"+
 				"case when nvl(tab2.TotalTransaction,0)<>0 then cast(round((decimal(nvl(tab1.TotalTransaction,0))/decimal(nvl(tab2.TotalTransaction,0))-1)*100,2) as numeric(24,6)) else 0 end as TotalTransactionRangeTLY,"+
 				"(nvl(tab1.Balance,0)-nvl(tab3.Balance,0)) as BalanceTLM,"+
 				"(nvl(tab1.BalanceRatio,0)-nvl(tab3.BalanceRatio,0)) as BalanceRatioTLM,"+
 				"case when nvl(tab3.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab3.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLM,"+
 				"(nvl(tab1.TotalTransaction,0)-nvl(tab3.TotalTransaction,0)) as TotalTransactionTLM,"+
 				"case when nvl(tab3.TotalTransaction,0)<>0 then cast(round((decimal(nvl(tab1.TotalTransaction,0))/decimal(nvl(tab3.TotalTransaction,0))-1)*100,2) as numeric(24,6)) else 0 end as TotalTransactionRangeTLM"+//注意：数据库integer/integer 自动舍去小数，所以小数除以大数永远为0，所以要转为double再除,sum()/sum()浮点数也变整型了，好怪
 			" from "+
			"(select Dimension,DimensionValue,BalanceRatio,Balance,TotalTransaction "+
				"from Batch_Import_Process "+
				"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1"+
			" left join (select Dimension,DimensionValue,BalanceRatio,Balance,TotalTransaction "+	
			"			from Batch_Import_Process "+
			"			where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
			")tab2 on tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue"+
			" left join (select Dimension,DimensionValue,BalanceRatio,Balance,TotalTransaction "+	
			"			from Batch_Import_Process "+
			"			where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastMonthEnd+"'"+
			")tab3 on tab1.Dimension=tab3.Dimension and tab1.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab11 "+
 				"set(BalanceTLY,BalanceRatioTLY,BalanceRangeTLY,TotalTransactionTLY,TotalTransactionRangeTLY,BalanceTLM,BalanceRatioTLM,BalanceRangeTLM,TotalTransactionTLM,TotalTransactionRangeTLM)="+
 				"(select BalanceTLY,BalanceRatioTLY,BalanceRangeTLY,TotalTransactionTLY,TotalTransactionRangeTLY,BalanceTLM,BalanceRatioTLM,BalanceRangeTLM,TotalTransactionTLM,TotalTransactionRangeTLM from "+
 				"("+sSql+") tab12 where tab11.Dimension=tab12.Dimension and tab11.DimensionValue=tab12.DimensionValue"+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 from ("+sSql+") tab13 where tab11.Dimension=tab13.Dimension and tab11.DimensionValue=tab13.DimensionValue)"
 				);
	}
	/**
	 * 按各个维度插入到处理表中---//1、 对G0101_表外业务 报表进行进行处理
	 * @throws Exception 
	 */
	public static void processG0101(String sConfigName,String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		String sSql="select "+
				"'"+HandlerFlag+"',ConfigNo,OneKey,'表外明细',~s"+sConfigName+"@项目e~"+
				",round(~s"+sConfigName+"@本外币合计e~/10000,2)"+
				" from Batch_Import_Interim "+
				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
				" and (~s"+sConfigName+"@项目e~ like '3.%' or ~s"+sConfigName+"@项目e~ like '4.%' or ~s"+sConfigName+"@项目e~ like '5.%' or ~s"+sConfigName+"@项目e~ like '6.%') ";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue"+
 				",Balance)"+
 				"( "+
 				sSql+
 				")");
	}
	/**
	 * 按各个维度插入到处理表中---//2、 对G0103_存贷款 报表进行进行处理
	 * @throws Exception 
	 */
	public static void processG0103(String sConfigName,String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		String sSql="select "+
				"'"+HandlerFlag+"',ConfigNo,OneKey,'贷款明细',~s"+sConfigName+"@项目e~"+
				",round(~s"+sConfigName+"@本外币合计e~/10000,2)"+
				" from Batch_Import_Interim "+
				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
				" and ~s"+sConfigName+"@项目e~ like '1%' ";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue"+
 				",Balance)"+
 				"( "+
 				sSql+
 				")");
	}
	/**
	 * 按各个维度插入到处理表中---//3、对G0107_行业贷款 报表进行进行处理
	 * @throws Exception 
	 */
	public static void processG0107(String sConfigName,String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
 		String sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,'行业明细',~s"+sConfigName+"@项目e~"+
				",round(~s"+sConfigName+"@各项贷款e~/10000,2)"+
				" from Batch_Import_Interim "+
				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
				" and (~s"+sConfigName+"@项目e~ like '1%' or ~s"+sConfigName+"@项目e~ like '2%' or ~s"+sConfigName+"@项目e~ like '4%')";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue"+
 				",Balance)"+
 				"( "+
 				sSql+
 				")");
	}
	/**
	 * 按各个维度插入到处理表中---//4、 对S6301_五级分类担保_企业规模 报表进行进行处理
	 * @throws Exception 
	 */
	public static void processS63(String sConfigName,String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
 		String sSql="select "+
 				"'"+HandlerFlag+"',BII1.ConfigNo,BII1.OneKey,'企业规模明细','大型企业@'||BII1.~s"+sConfigName+"@项目e~"+
				",round(BII1.~s"+sConfigName+"@大型企业e~/10000,2),BII2.~s"+sConfigName+"@大型企业e~"+
				" from Batch_Import_Interim BII1,Batch_Import_Interim BII2 "+
				" where BII1.ConfigNo='"+sConfigNo+"' and BII1.OneKey='"+sKey+"' and BII2.ConfigNo='"+sConfigNo+"' and BII2.OneKey='"+sKey+"' "+
				" and (BII1.~s"+sConfigName+"@项目e~ = '1.境内贷款余额合计' or BII1.~s"+sConfigName+"@项目e~ like '1.1.%' or BII1.~s"+sConfigName+"@项目e~ like '1.2.%') "+
				" and BII2.~s"+sConfigName+"@项目e~ like '%其中：贷款户数%'"+
				" union all "+
				"select "+
				"'"+HandlerFlag+"',BII1.ConfigNo,BII1.OneKey,'企业规模明细','中型企业@'||BII1.~s"+sConfigName+"@项目e~"+
				",round(BII1.~s"+sConfigName+"@中型企业e~/10000,2),BII2.~s"+sConfigName+"@中型企业e~"+
				" from Batch_Import_Interim BII1,Batch_Import_Interim BII2 "+
				" where BII1.ConfigNo='"+sConfigNo+"' and BII1.OneKey='"+sKey+"' and BII2.ConfigNo='"+sConfigNo+"' and BII2.OneKey='"+sKey+"' "+
				" and (BII1.~s"+sConfigName+"@项目e~ = '1.境内贷款余额合计' or BII1.~s"+sConfigName+"@项目e~ like '1.1.%' or BII1.~s"+sConfigName+"@项目e~ like '1.2.%') "+
				" and BII2.~s"+sConfigName+"@项目e~ like '%其中：贷款户数%'"+
				" union all "+
				" select "+
				"'"+HandlerFlag+"',BII1.ConfigNo,BII1.OneKey,'企业规模明细','小型企业@'||BII1.~s"+sConfigName+"@项目e~"+
				",round(BII1.~s"+sConfigName+"@小型企业e~/10000,2),BII2.~s"+sConfigName+"@小型企业e~"+
				" from Batch_Import_Interim BII1,Batch_Import_Interim BII2 "+
				" where BII1.ConfigNo='"+sConfigNo+"' and BII1.OneKey='"+sKey+"' and BII2.ConfigNo='"+sConfigNo+"' and BII2.OneKey='"+sKey+"' "+
				" and (BII1.~s"+sConfigName+"@项目e~ = '1.境内贷款余额合计' or BII1.~s"+sConfigName+"@项目e~ like '1.1.%' or BII1.~s"+sConfigName+"@项目e~ like '1.2.%') "+
				" and BII2.~s"+sConfigName+"@项目e~ like '%其中：贷款户数%'"+
				" union all "+
				" select "+
				"'"+HandlerFlag+"',BII1.ConfigNo,BII1.OneKey,'企业规模明细','微型企业@'||BII1.~s"+sConfigName+"@项目e~"+
				",round(BII1.~s"+sConfigName+"@微型企业e~/10000,2),BII2.~s"+sConfigName+"@微型企业e~"+
				" from Batch_Import_Interim BII1,Batch_Import_Interim BII2 "+
				" where BII1.ConfigNo='"+sConfigNo+"' and BII1.OneKey='"+sKey+"' and BII2.ConfigNo='"+sConfigNo+"' and BII2.OneKey='"+sKey+"' "+
				" and (BII1.~s"+sConfigName+"@项目e~ = '1.境内贷款余额合计' or BII1.~s"+sConfigName+"@项目e~ like '1.1.%' or BII1.~s"+sConfigName+"@项目e~ like '1.2.%') "+
				" and BII2.~s"+sConfigName+"@项目e~ like '%其中：贷款户数%'"+
				" union all "+
				" select "+
				"'"+HandlerFlag+"',BII1.ConfigNo,BII1.OneKey,'企业规模明细','单户授信总额500万元以下的小微型企业@'||BII1.~s"+sConfigName+"@项目e~"+
				",round(BII1.~s"+sConfigName+"@单户授信总额500万元以下的小微型企业e~/10000,2),BII2.~s"+sConfigName+"@单户授信总额500万元以下的小微型企业e~"+
				" from Batch_Import_Interim BII1,Batch_Import_Interim BII2 "+
				" where BII1.ConfigNo='"+sConfigNo+"' and BII1.OneKey='"+sKey+"' and BII2.ConfigNo='"+sConfigNo+"' and BII2.OneKey='"+sKey+"' "+
				" and (BII1.~s"+sConfigName+"@项目e~ = '1.境内贷款余额合计' or BII1.~s"+sConfigName+"@项目e~ like '1.1.%' or BII1.~s"+sConfigName+"@项目e~ like '1.2.%') "+
				" and BII2.~s"+sConfigName+"@项目e~ like '%其中：贷款户数%'"+
				" union all "+
				" select "+
				"'"+HandlerFlag+"','"+sConfigNo+"',OneKey,'企业规模明细','总计@各项贷款余额'"+
				",round(~sG0103_存贷款@本外币合计e~/10000,2),0"+
				" from Batch_Import_Interim "+
				" where ConfigName='G0103_存贷款' and OneKey='"+sKey+"' "+
				" and ~sG0103_存贷款@项目e~ = '1.各项贷款'";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue"+
 				",Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
	}
}