package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class AfterImportCustomerHandler{
	//对导入数据加工处理,插入到中间表Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		
		String sSql="";
		
		//1、清除重复客户-----不同sheet同一客户重复时则importNo不同  在一个sheet内重复同一客户时，importNo相同但importIndex不同 ，
		sSql="delete from Batch_Import BI1 where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
					" and ~s客户明细@客户名称e~  in "+
						"(select BI2.~s客户明细@客户名称e~ from Batch_Import BI2"+
						" where BI2.ConfigNo='"+sConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s客户明细@客户名称e~ having count(1)>1)"+
					" and ImportNo||ImportIndex not in "+
						"(select max(ImportNo||ImportIndex) from Batch_Import BI2 "+
						" where BI2.ConfigNo='"+sConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s客户明细@客户名称e~ having count(1)>1)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		
 		sSql="delete from Batch_Import_Interim BI1 where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
				" and ~s客户明细@客户名称e~  in "+
					"(select BI2.~s客户明细@客户名称e~ from Batch_Import_Interim BI2"+
					" where BI2.ConfigNo='"+sConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s客户明细@客户名称e~ having count(1)>1)"+
				" and ImportNo||ImportIndex not in "+
					"(select max(ImportNo||ImportIndex) from Batch_Import_Interim BI2 "+
					" where BI2.ConfigNo='"+sConfigNo+"' and BI2.OneKey='"+sKey+"' group by BI2.~s客户明细@客户名称e~ having count(1)>1)";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
	}
	/**
	 * 按各个维度插入到处理表中
	 * @throws Exception 
	 */
	public static void process(String sConfigNo,String sKey,Transaction Sqlca,String Dimension,String groupBy) throws Exception{
		String sSql="";
 		//1、按条线计算增加额和比例等信息放入处理表中
		String groupColumns=groupBy.replaceAll(",","||'@'||");
		groupColumns=("".equals(groupColumns)?"":groupColumns+",");
 		sSql="select "+
 				"ConfigNo,OneKey,'"+Dimension+"',"+groupColumns+
				"round(sum(case when ~s合同明细@合同起始日e~ like '"+sKey+"%' then ~s合同明细@金额e~*nvl(getErate(~s合同明细@币种e~,'01',''),0) end)/10000,2) as BusinessSum,"+//按月投放金额
				"round(sum(~s合同明细@余额e~*nvl(getErate(~s合同明细@币种e~,'01',''),0))/10000,2) as Balance "+ 
				"from Batch_Import_Interim "+
				"where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s合同明细@余额e~,0)>0 "+
				" and nvl(~s合同明细@业务品种e~,'')<>''"+
				" and nvl(~s合同明细@业务品种e~,'X') not in('国内信用证','进口信用证','银行承兑汇票','贷款担保','进口信用证增额','委托代付-信用证','委托贷款') "+
				" and nvl(~s合同明细@业务品种e~,'X') not like '%保函%' "+
				" and nvl(~s合同明细@业务品种e~,'X') not like '%额度%' "+
				//" and nvl(~s合同明细@业务品种e~,'X') not like '%出口%' "+
				"group by ConfigNo,OneKey"+("".equals(groupBy)?"":","+groupBy);
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance)"+
 				"( "+
 				sSql+
 				")");
	}
	//加入小计 合计 横向纵向比较值
	public static void afterProcess(String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		//1、插入各个维度的小计
 		sSql="select "+
 				"ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)||'小计',"+
			"round(sum(BusinessSum),2) as BusinessSum,round(sum(Balance),2) as Balance "+
			"from Batch_Import_Process "+
			"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('@',DimensionValue)>0 "+
			"group by ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance)"+
 				"( "+
 				sSql+
 				")");
		//2、插入各个维度的总计
 		sSql="select "+
 				"ConfigNo,OneKey,Dimension,'总计',"+
			"round(sum(BusinessSum),2) as BusinessSum,round(sum(Balance),2) as Balance "+
			"from Batch_Import_Process "+
			"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('小计',DimensionValue)=0 "+
			"group by ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance)"+
 				"( "+
 				sSql+
 				")");
 		//3、相对前一年度增加值和幅度更新
 		sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceToLY,"+
 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeToLY from "+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+
				"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1,"+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+	
			"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
			")tab2"+
			" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab1 "+
 				"set(BalanceTLY,BalanceRangeTLY)="+
 				"(select BalanceToLY,BalanceRangeToLY from "+
 				"("+sSql+") tab2 where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue"+
 				")"+
 				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 from ("+sSql+") tab22 where tab1.Dimension=tab22.Dimension and tab1.DimensionValue=tab22.DimensionValue)"
 				);
 			//如果是年度导入，更新下一年度所有月份的增加值、增加值和幅度更新
 		if(StringFunction.isLike(sKey, "%/12")){
 			sSql="select distinct OneKey from Batch_Import_Process where ConfigNo='"+sConfigNo+"' and OneKey>'"+sKey+"'";
 			String[] sOneKey=Sqlca.getStringArray(sSql);
 			String OneKeys=StringFunction.toArrayString(sOneKey, "','");
 			sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 	 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceToLY,"+
 	 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeToLY from "+
 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+
 					"from Batch_Import_Process "+
 					"where ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 				")tab1,"+
 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+	
 				"from Batch_Import_Process "+
 					"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
 				")tab2"+
 				" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue";
 	 		Sqlca.executeSQL("update Batch_Import_Process tab1 "+
 	 				"set(BalanceTLY,BalanceRangeTLY)="+
 	 				"(select BalanceToLY,BalanceRangeToLY from "+
 	 				"("+sSql+") tab2 where tab1.OneKey=tab2.OneKey and tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue"+
 	 				")"+
 	 				" where ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 	 				" and exists(select 1 from ("+sSql+") tab22 where tab1.OneKey=tab22.OneKey and tab1.Dimension=tab22.Dimension and tab1.DimensionValue=tab22.DimensionValue)"
 	 				);
 		}
 		//4、占比更新
 		sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 				"case when nvl(tab2.BusinessSum,0)<>0 then round(tab1.BusinessSum/tab2.BusinessSum*100,2) else 0 end as BusinessSumRatio,"+
 				"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio from "+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+
				"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1,"+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance "+	
				"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and DimensionValue='总计'"+
			")tab2"+
			" where tab1.Dimension=tab2.Dimension";
 		Sqlca.executeSQL("update Batch_Import_Process tab1 "+
 				"set(BusinessSumRatio,BalanceRatio)="+
 				"( select BusinessSumRatio,BalanceRatio from "+
 				"("+sSql+") tab2 where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue"+
 				")"+
 				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 from ("+sSql+") tab22 where tab1.Dimension=tab22.Dimension and tab1.DimensionValue=tab22.DimensionValue)"
 				);
	}
}