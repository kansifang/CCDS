package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class AfterImport{
	public static void beforeProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		//0、先清空目标表 
 		Sqlca.executeSQL("Delete from Batch_Import_Process where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'");
 		//特殊处理
 		//经营类型（新）如果字段为空，更新 经营类型 内的值
 		String sSql="update Batch_Import set ~s借据明细@经营类型(新)e~=~s借据明细@经营类型e~ where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s借据明细@经营类型(新)e~,'')=''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
	}
	
	/**
	 * 导入文件后，加工处理数据
	 * @throws Exception 
	 */
	public static void process(String sConfigNo,String sKey,Transaction Sqlca,String Dimension,String groupBy) throws Exception{
		String sSql="";
 		//1、按条线计算增加额和比例等信息放入处理表中
		String groupColumns=groupBy.replaceAll(",","||'@'||");
		groupColumns=("".equals(groupColumns)?"":groupColumns+",");
 		sSql="select "+
 				"ConfigNo,OneKey,'"+Dimension+"',"+groupColumns+
				"round(sum(case when ~s借据明细@借据起始日e~ like '"+sKey+"%' then ~s借据明细@金额(元)e~*nvl(getErate(~s借据明细@币种e~,'01',''),0) end)/10000,2) as BusinessSum,"+//按月投放金额
				"round(sum(~s借据明细@余额(元)e~*nvl(getErate(~s借据明细@币种e~,'01',''),0))/10000,2) as Balance "+ 
				"from Batch_Import "+
				"where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s借据明细@余额(元)e~,0)>0 "+
				"group by ConfigNo,OneKey"+("".equals(groupBy)?"":","+groupBy);
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance)"+
 				"( "+
 				sSql+
 				")");
	}
	//进一步加工
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
 		//3、更新比例和增长幅度
 		 //a、增加值和幅度更新
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
 		/*
 		ASResultSet rs=Sqlca.getASResultSet(sSql);
 		while(rs.next()){
 			double BalanceToLY =rs.getDouble("BalanceToLY");
 			double BalanceRangeToLY =rs.getDouble("BalanceRangeToLY");
 			System.out.println(BalanceToLY+"@"+BalanceRangeToLY);
 		}
 		*/
 		Sqlca.executeSQL("update Batch_Import_Process "+
 				"set(BalanceTLY,BalanceRangeTLY)="+
 				"(select BalanceToLY,BalanceRangeToLY from "+
 				"("+sSql+") tab2 where Batch_Import_Process.Dimension=tab2.Dimension and Batch_Import_Process.DimensionValue=tab2.DimensionValue"+
 				")"+
 				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'");
 		//b、占比更新
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
 				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'");
	}
}