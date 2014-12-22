package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class BDOperationReportHandler{
	/**
	 * 月度经营报告处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public static void operationReportHandle(String HandlerFlag,String sReportConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1、对中间表数据进行特殊处理 	 		 	
		BDOperationReportHandler.interimProcess(sReportConfigNo, sOneKey, Sqlca);
		//
		BDOperationReportHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca);
	 	//4、加工后，进行合计，横向纵向分析
		BDOperationReportHandler.afterProcess(HandlerFlag,sReportConfigNo, sOneKey, Sqlca);
	}
	//对导入数据加工处理,插入到中间表Batch_Import_Interim
	public static void interimProcess(String sReportConfigNo,String sKey,Transaction Sqlca) throws Exception{
	}
	/**
	 * 按各个维度插入到处理表中---//4、 对S6301_五级分类担保_企业规模 报表进行进行处理
	 * @throws Exception 
	 */
	public static void processS63(String HandlerFlag,String sReportConfigNo,String sKey,Transaction Sqlca) throws Exception{
 		//下面对 S63处理后的数据汇总生成一个一个不良汇总
		//对大中小微等再生成一条不良余额 形式如 大型企业@不良余额..
		String groupby="case when BII1.DimensionValue like '大型企业%' then 'A-大型企业'" +
						" when BII1.DimensionValue like '中型企业%' then 'B-中型企业'"+
						" when BII1.DimensionValue like '小型企业%' then 'C-小型企业'"+
						" when BII1.DimensionValue like '微型企业%' then 'D-微型企业'"+
						" when BII1.DimensionValue like '单户授信总额500万元以下的小微型企业%' then 'E-单户授信总额500万元以下的小微型企业'"+
						" else 'Z-'||BII1.DimensionValue end";
 		String sSql="select "+
 				"'"+HandlerFlag+"','"+sReportConfigNo+"',BII1.OneKey,'企业规模不良'," +
 				groupby+","+
 				"sum(Balance)"+
				" from Batch_Import_Process BII1"+
				" where BII1.ConfigNo='b20140603000003' and BII1.OneKey='"+sKey+"' and BII1.Dimension='企业规模明细'"+//S63_规模贷款导入配置号
				" and (BII1.DimensionValue like '%1.1.3%' or BII1.DimensionValue like '%1.1.4%' or BII1.DimensionValue like '%1.1.5%' ) " +
				" group by HandlerFlag,ConfigNo,OneKey,'企业规模明细',"+groupby;
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,Balance)"+
 				"( "+
 				sSql+
 				")");
 		//下面是通过借据明细生成
 		//通过借据明细，更新大中小微不良户数
 		sSql="from Batch_Import_Interim BII1"+
 						" where BII1.ConfigName='借据明细' and BII1.OneKey='"+sKey+"' "+
 						" and BII1.~s借据明细@企业规模e~=substr(BIP.DimensionValue,3)"+//形式如：A-大型企业
 						" and nvl(BII1.~s借据明细@余额(元)e~,0)>0"+
 						" and (BII1.~s借据明细@五级分类e~ like '次级%' or BII1.~s借据明细@五级分类e~ like '可疑%' or BII1.~s借据明细@五级分类e~ like '损失%')";
 		String updateSql="update Batch_Import_Process BIP set(TotalTransaction)="+
 	 				"(select count(distinct BII1.~s借据明细@客户名称e~) "+sSql+")"+
 	 				" where BIP.HandlerFlag='"+HandlerFlag+"' and BIP.ConfigNo='"+sReportConfigNo+"' and BIP.OneKey='"+sKey+"' and BIP.Dimension = '企业规模不良'"+
 	 				" and exists"+
 	 				"	(select 1 "+sSql+")";
 		updateSql=StringUtils.replaceWithConfig(updateSql, Sqlca);
 		Sqlca.executeSQL(updateSql);
 		//通过借据明细，单独更新 单户 授信总额500万元以下的小微型企业 不良户数 ---因为借据表中可没有这个规模，他只是小型和微型企业的 授信500万以下部分
 		sSql="from Batch_Import_Interim BII1"+
 						" where BII1.ConfigName='借据明细' and BII1.OneKey='"+sKey+"' "+
 						" and BII1.~s借据明细@企业规模e~ in('小型企业','微小型企业') "+
 						" and (select sum(BII2.~s借据明细@金额(元)e~) from Batch_Import_Interim BII2 " +
 						"		where BII2.ConfigName=BII1.ConfigName " +
 						"			and BII2.OneKey=BII1.OneKey " +
 						"           and nvl(BII2.~s借据明细@余额(元)e~,0)>0"+
 						"			and BII2.~s借据明细@客户名称e~=BII1.~s借据明细@客户名称e~)<=5000000"+
 						" and nvl(BII1.~s借据明细@余额(元)e~,0)>0"+
 						" and (BII1.~s借据明细@五级分类e~ like '次级%' or BII1.~s借据明细@五级分类e~ like '可疑%' or BII1.~s借据明细@五级分类e~ like '损失%')";
 		updateSql="update Batch_Import_Process set(TotalTransaction)="+
 	 				"(select count(distinct BII1.~s借据明细@客户名称e~) "+sSql+")"+
 	 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"' and Dimension = '企业规模不良'"+
 	 				" and DimensionValue='E-单户授信总额500万元以下的小微型企业'";
 		updateSql=StringUtils.replaceWithConfig(updateSql, Sqlca);
 		Sqlca.executeSQL(updateSql);
	}
	/**
	 * 按各个维度插入到处理表中
	 * @throws Exception 
	 */
	public static void process(String HandlerFlag,String sReportConfigNo,String sKey,Transaction Sqlca) throws Exception{
 		BDOperationReportHandler.processS63(HandlerFlag, sReportConfigNo, sKey, Sqlca);
 		//针对S63中的大中小规模明细，生成担保方式维度汇总
 		String sSql="select "+
 				"'"+HandlerFlag+"','"+sReportConfigNo+"','"+sKey+"','贷款单一担保方式',substr(BIP.DimensionValue,locate('@',BIP.DimensionValue)+1),sum(Balance)"+
				" from Batch_Import_Process BIP"+
				" where BIP.ConfigNo='b20140603000003' and BIP.OneKey='"+sKey+"' and BIP.Dimension='企业规模明细'"+//S63_规模贷款导入配置号
				" and BIP.DimensionValue not like '单户授信总额500万元以下的小微型企业%'" +
				" and (BIP.DimensionValue like '%1.2.1%' or BIP.DimensionValue like '%1.2.2%' or BIP.DimensionValue like '%1.2.3%' or BIP.DimensionValue = '总计@各项贷款余额')" +
				" group by substr(BIP.DimensionValue,locate('@',BIP.DimensionValue)+1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,Balance)"+
 				"( "+
 				sSql+
 				")");
	}
	//加入小计 合计 横向纵向比较值
	public static void afterProcess(String HandlerFlag,String sReportConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		String sLastMonthEnd=StringFunction.getRelativeAccountMonth(sKey,"month",-1);
		//2、计算大中小微不良总额的总计
 		//此处计算不良总额，主要是文字描述部分需要这个字段，也要计算不良率
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,'大中小微总计',"+
 				"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2) as Balance,sum(TotalTransaction) "+
 				" from Batch_Import_Process "+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"' and Dimension='企业规模不良'" +
 				" and DimensionValue <> 'E-单户授信总额500万元以下的小微型企业'"+
 				" group by HandlerFlag,ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
		//3、计算不良率（占总额的比）
 		sSql="select "+
 				" case when nvl(BIP2.Balance,0)<>0 then round(BIP1.Balance/BIP2.Balance*100,2) else 0 end"+
				" from Batch_Import_Process BIP2"+
				" where BIP2.HandlerFlag='"+HandlerFlag+"' " +
				" and BIP2.ConfigNo='b20140603000003'" +//S63导入配置号
				" and BIP2.OneKey ='"+sKey+"'" +
				" and BIP2.Dimension='企业规模明细'" +
				" and BIP2.DimensionValue='总计@各项贷款余额'";
 		Sqlca.executeSQL("update Batch_Import_Process BIP1 "+
 				"set(BalanceRatio)="+
 				"("+sSql+")"+
 				" where HandlerFlag='"+HandlerFlag+"'" +
 				" and ConfigNo='"+sReportConfigNo+"'" +
 				" and OneKey='"+sKey+"'" +
 				" and Dimension='企业规模不良'" +
 				" and DimensionValue='大中小微总计'"
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
				"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1"+
			" left join (select Dimension,DimensionValue,BalanceRatio,Balance,TotalTransaction "+	
			"			from Batch_Import_Process "+
			"			where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
			")tab2 on tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue"+
			" left join (select Dimension,DimensionValue,BalanceRatio,Balance,TotalTransaction "+	
			"			from Batch_Import_Process "+
			"			where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey ='"+sLastMonthEnd+"'"+
			")tab3 on tab1.Dimension=tab3.Dimension and tab1.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab11 "+
 				"set(BalanceTLY,BalanceRatioTLY,BalanceRangeTLY,TotalTransactionTLY,TotalTransactionRangeTLY,BalanceTLM,BalanceRatioTLM,BalanceRangeTLM,TotalTransactionTLM,TotalTransactionRangeTLM)="+
 				"(select BalanceTLY,BalanceRatioTLY,BalanceRangeTLY,TotalTransactionTLY,TotalTransactionRangeTLY,BalanceTLM,BalanceRatioTLM,BalanceRangeTLM,TotalTransactionTLM,TotalTransactionRangeTLM from "+
 				"("+sSql+") tab12 where tab11.Dimension=tab12.Dimension and tab11.DimensionValue=tab12.DimensionValue"+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 from ("+sSql+") tab13 where tab11.Dimension=tab13.Dimension and tab11.DimensionValue=tab13.DimensionValue)"
 				);
	}
}