package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class AfterImportContractHandler{
	//对导入数据加工处理,插入到中间表Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		
		String sSql="";
		//1、主要担保方式为信用的以从2014/05月份合同的 其他担保方式 为准更新到2014/03，因为03月份不准确(建立基准)
		if(!"2014/05".equals(sKey)){
			sSql="update Batch_Import_Interim BII set ~s合同明细@其他担保方式e~="+
					"(select ~s合同明细@其他担保方式e~ from Batch_Import BI "+
					"where BI.ConfigNo=BII.ConfigNo and BI.OneKey='2014/05' and BI.~s合同明细@合同流水号e~=BII.~s合同明细@合同流水号e~) "+
			"where BII.ConfigNo='"+sConfigNo+"' and BII.OneKey='"+sKey+"'"+// and nvl(BII.~s合同明细@主要担保方式e~,'信用')='信用' "+//不仅仅为信用，凡是2014/05”其他担保方式“有的，都以此为准予以更新
			"and exists(select 1 from Batch_Import BI1 where BI1.ConfigNo=BII.ConfigNo and BI1.OneKey='2014/05' and BI1.~s合同明细@合同流水号e~=BII.~s合同明细@合同流水号e~)";
			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
			Sqlca.executeSQL(sSql);
		}
		
		//2、如果其他担保方式为空，修改为 主要担保方式（一般也就是信用） 如果主要担保方式也是空 就 改为信用
		sSql="update Batch_Import_Interim set ~s合同明细@其他担保方式e~="+
					"case when nvl(~s合同明细@主要担保方式e~,'X') like '抵押%' then '抵押' "+
					"when nvl(~s合同明细@主要担保方式e~,'X') like '质押%' then '质押' "+
					"when nvl(~s合同明细@主要担保方式e~,'X') like '保证%' then '保证' "+
					"else '信用' end "+
					"where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s合同明细@其他担保方式e~,'')=''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		
 		//3、太原市梗阳实业集团有限公司(合同20130412000007) 银团贷款 以借据(借据00000167523）余额为准
		sSql="update Batch_Import_Interim set ~s合同明细@余额e~="+
					"(select ~s借据明细@余额(元)e~ from Batch_Import_Interim "+
					"where ConfigName='借据明细' and OneKey='"+sKey+"' and ~s借据明细@借据流水号e~='00000167523')"+
					"where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
					"and nvl(~s合同明细@合同流水号e~,'')='20130412000007'";
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