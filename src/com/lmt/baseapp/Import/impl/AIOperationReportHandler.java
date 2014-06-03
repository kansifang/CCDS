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
					"and (nvl(~s"+sConfigNo+"@项目e~,'')='' or ~s"+sConfigNo+"@项目e~ like '版本号:%' or ~s"+sConfigNo+"@项目e~ like '%色底为%')";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
		
	}
	/**
	 * 按各个维度插入到处理表中
	 * @throws Exception 
	 */
	public static void process(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		String sSql="";
		String sConfigName=Sqlca.getString("select CodeName from Code_Catalog where CodeNo='"+sConfigNo+"'");
 		//1、 对G0103_存贷款 报表进行进行处理
 		if("G0103_存贷款".equals(sConfigName)){
 			sSql="select "+
 					"'"+HandlerFlag+"',ConfigNo,OneKey,'贷款明细',~s"+sConfigName+"@项目e~"+
 					",~s"+sConfigName+"@本外币合计e~"+//按月投放金额
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
 		}else if("G0107_行业贷款".equals(sConfigName)){
 			//2、 对G0107_行业贷款 报表进行进行处理
 	 		sSql="select "+
 	 				"'"+HandlerFlag+"',ConfigNo,OneKey,'行业明细',~s"+sConfigName+"@项目e~"+
 					",~s"+sConfigName+"@本外币合计e~"+//按月投放金额
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' ";
 			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 	 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 	 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue"+
 	 				",Balance)"+
 	 				"( "+
 	 				sSql+
 	 				")");
 		}else if("S6301_五级分类担保_企业规模".equals(sConfigName)){
 			//3、 对S6301_五级分类担保_企业规模 报表进行进行处理
 	 		sSql="select "+
 	 				"'"+HandlerFlag+"',ConfigNo,OneKey,'企业规模明细','大型企业@'||~s"+sConfigName+"@项目e~"+
 					",~s"+sConfigName+"@大型企业e~"+
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
 					" union all "+
 					"select "+
 					"'"+HandlerFlag+"',ConfigNo,OneKey,'企业规模明细','中型企业@'||~s"+sConfigName+"@项目e~"+
 					",~s"+sConfigName+"@中型企业e~"+
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
 					" union all "+
 					" select "+
 					"'"+HandlerFlag+"',ConfigNo,OneKey,'企业规模明细','小型企业@'||~s"+sConfigName+"@项目e~"+
 					",~s"+sConfigName+"@小型企业e~"+
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
 					" union all "+
 					" select "+
 					"'"+HandlerFlag+"',ConfigNo,OneKey,'企业规模明细','微型企业@'||~s"+sConfigName+"@项目e~"+
 					",~s"+sConfigName+"@微型企业e~"+
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
 					" union all "+
 					" select "+
 					"'"+HandlerFlag+"',ConfigNo,OneKey,'企业规模明细','单户授信总额500万元以下的小微型企业@'||~s"+sConfigName+"@项目e~"+
 					",~s"+sConfigName+"@单户授信总额500万元以下的小微型企业e~"+//按月投放金额
 					" from Batch_Import_Interim "+
 					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' ";
 			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 	 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 	 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue"+
 	 				",Balance)"+
 	 				"( "+
 	 				sSql+
 	 				")");
 		}
	}
	//加入小计 合计 横向纵向比较值
	public static void afterProcess(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		//1、插入各个维度的小计
 		sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)||'小计',"+
			"round(sum(BusinessSum),2) as BusinessSum,round(sum(Balance),2) as Balance "+
			"from Batch_Import_Process "+
			"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('@',DimensionValue)>0 "+
			"group by ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance)"+
 				"( "+
 				sSql+
 				")");
		//2、插入各个维度的总计
 		sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,Dimension,'总计',"+
			"round(sum(BusinessSum),2) as BusinessSum,round(sum(Balance),2) as Balance "+
			"from Batch_Import_Process "+
			"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('小计',DimensionValue)=0 "+
			"group by ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance)"+
 				"( "+
 				sSql+
 				")");
 		//3、计算占比
 		sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 				"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio from "+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,Balance "+
				"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1,"+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,Balance "+	
				"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and DimensionValue='总计'"+
			")tab2"+
			" where tab1.Dimension=tab2.Dimension";
 		Sqlca.executeSQL("update Batch_Import_Process tab3 "+
 				"set(BalanceRatio)="+
 				"( select BalanceRatio from "+
 				"("+sSql+") tab4 where tab3.Dimension=tab4.Dimension and tab3.DimensionValue=tab4.DimensionValue"+
 				")"+
 				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 from ("+sSql+") tab22 where tab3.Dimension=tab22.Dimension and tab3.DimensionValue=tab22.DimensionValue)"
 				);
 		//4、相对前一年度增加值和幅度更新
 		sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
 				"(nvl(tab1.BalanceRatio,0)-nvl(tab2.BalanceRatio,0)) as BalanceRatioTLY,"+
 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY from "+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BalanceRatio,Balance "+
				"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1,"+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BalanceRatio,Balance "+	
			"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
			")tab2"+
			" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab3 "+
 				"set(BalanceTLY,BalanceRatioTLY,BalanceRangeTLY)="+
 				"(select BalanceTLY,BalanceRatioTLY,BalanceRangeTLY from "+
 				"("+sSql+") tab4 where tab3.Dimension=tab4.Dimension and tab3.DimensionValue=tab4.DimensionValue"+
 				")"+
 				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 from ("+sSql+") tab22 where tab3.Dimension=tab22.Dimension and tab3.DimensionValue=tab22.DimensionValue)"
 				);
 			//如果是年度导入，更新下一年度所有月份的增加值、增加值和幅度更新
 		if(StringFunction.isLike(sKey, "%/12")){
 			sSql="select distinct OneKey from Batch_Import_Process where ConfigNo='"+sConfigNo+"' and OneKey>'"+sKey+"'";
 			String[] sOneKey=Sqlca.getStringArray(sSql);
 			String OneKeys=StringFunction.toArrayString(sOneKey, "','");
 			sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 	 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
 	 				"(nvl(tab1.BalanceRatio,0)-nvl(tab2.BalanceRatio,0)) as BalanceRatioTLY,"+
 	 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY from "+
 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+
 					"from Batch_Import_Process "+
 					"where ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 				")tab1,"+
 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+	
 				"from Batch_Import_Process "+
 					"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
 				")tab2"+
 				" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue";
 	 		Sqlca.executeSQL("update Batch_Import_Process tab3 "+
 	 				"set(BalanceTLY,BalanceRatioTLY,BalanceRangeTLY)="+
 	 				"(select BalanceTLY,BalanceRatioTLY,BalanceRangeTLY from "+
 	 				"("+sSql+") tab4 where tab3.OneKey=tab4.OneKey and tab3.Dimension=tab4.Dimension and tab3.DimensionValue=tab4.DimensionValue"+
 	 				")"+
 	 				" where ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 	 				" and exists(select 1 from ("+sSql+") tab22 where tab3.OneKey=tab22.OneKey and tab3.Dimension=tab22.Dimension and tab3.DimensionValue=tab22.DimensionValue)"
 	 				);
 		}
	}
}