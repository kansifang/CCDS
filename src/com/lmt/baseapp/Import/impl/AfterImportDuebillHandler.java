package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class AfterImportDuebillHandler{
	//对导入数据加工处理,插入到中间表Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		//1、归属条线 个人条线统一修改为 零售条线
		String sSql="update Batch_Import_Interim set ~s借据明细@归属条线e~='公司条线' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s借据明细@归属条线e~,'')='个人条线'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//修改 王秀梅这个贷款 短期流动资金贷款 由零售条线 修改为 公司条线 ，
 		sSql="update Batch_Import_Interim set ~s借据明细@归属条线e~='公司条线',~s借据明细@国家地区e~='太原市' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s借据明细@借据流水号e~,'')='2740124368501101'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//2、 
 		//b、经营类型（新）以从当前月份借据的 经营类型（新） 为准更新到2013/12等之前的，因为之前的不准确(建立基准)
 		if(!StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0).equals(sKey)){
 			sSql="update Batch_Import_Interim BII set ~s借据明细@经营类型(新)e~="+
 					"(select ~s借据明细@经营类型(新)e~ from Batch_Import BI "+
 					"where BI.ConfigNo=BII.ConfigNo and BI.OneKey='"+StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)+"' and BI.~s借据明细@借据流水号e~=BII.~s借据明细@借据流水号e~) "+
 			" where BII.ConfigNo='"+sConfigNo+"' and BII.OneKey='"+sKey+"'"+
 			" and exists(select 1 from Batch_Import BI1 where BI1.ConfigNo=BII.ConfigNo and BI1.OneKey='"+StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)+"' and BI1.~s借据明细@借据流水号e~=BII.~s借据明细@借据流水号e~)";
 			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 			Sqlca.executeSQL(sSql);
 		}
		//a、经营类型（新）如果字段为空，更新 经营类型 内的值
 		sSql="update Batch_Import_Interim set ~s借据明细@经营类型(新)e~=~s借据明细@经营类型e~ where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s借据明细@经营类型(新)e~,'')=''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
		//c、以导入的客户信息为准更新经营类型(新)----导入日期永远以今天为准（这个其他种类还是太大，不是很准，暂时屏蔽吧）
		/*
		sSql="update Batch_Import_Interim BII set ~s借据明细@经营类型(新)e~="+
				"(select ~s客户明细@经营类型(新)e~ from Batch_Import_Interim BII1 "+
				"where BII1.ConfigName='客户明细' and BII1.OneKey='"+StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)+"' and BII1.~s客户明细@客户名称e~=BII.~s借据明细@客户名称e~) "+
		" where BII.ConfigNo='"+sConfigNo+"' and BII.OneKey='"+sKey+"'"+
		" and exists(select 1 from Batch_Import BII2 where BII2.ConfigName='客户明细' and BII2.OneKey='"+StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)+"' and BII2.~s客户明细@客户名称e~=BII.~s借据明细@客户名称e~)";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
		*/
 		//3、直属行名称 晋城、晋中、长治直属行名称，根据 管户人 名字后面的括号内的标志更新
 		sSql="update Batch_Import_Interim set ~s借据明细@直属行名称e~="+
 					"case when ~s借据明细@管户人e~ like '%晋城%' or ~s借据明细@管户人e~='段林虎' then '晋城分行筹备组' "+
 					"when ~s借据明细@管户人e~ like '%晋中%' then '晋中分行筹备组' "+
 					"when ~s借据明细@管户人e~ like '%长治%' then '长治分行' "+
 					"else ~s借据明细@直属行名称e~ end "+
 					"where ConfigNo='"+sConfigNo+"' "+
 					"and OneKey='"+sKey+"' "+
 					"and nvl(~s借据明细@管户人e~,'')<>''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql); 
 		//4、直属行名称中带晋商银行的 如果 根据 管户机构 来更新
 		sSql="update Batch_Import_Interim set ~s借据明细@直属行名称e~=~s借据明细@管户机构e~"+
 					" where ConfigNo='"+sConfigNo+"' "+
 					" and OneKey='"+sKey+"' "+
 					" and nvl(~s借据明细@直属行名称e~,'')='晋商银行'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//5、业务品种 存在 期限月加期限日明显是长期贷款，业务品种却是短期流动资金贷款的情况，故在此更新成 中长期流动资金贷款
 		sSql="update Batch_Import_Interim set ~s借据明细@业务品种e~='中长期流动资金贷款'"+
 					" where ConfigNo='"+sConfigNo+"' "+
 					" and OneKey='"+sKey+"' "+
 					" and nvl(~s借据明细@业务品种e~,'')='短期流动资金贷款'"+
 					" and (nvl(~s借据明细@期限日e~,0)>0 and nvl(~s借据明细@期限月e~,0)+1>12 or nvl(~s借据明细@期限月e~,0)>12)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql); 
 		//业务品种 存在 期限月加期限日明显是短期贷款，业务品种却是中长期流动资金贷款的情况，故在此更新成 短期流动资金贷款
 		sSql="update Batch_Import_Interim set ~s借据明细@业务品种e~='短期流动资金贷款'"+
 					" where ConfigNo='"+sConfigNo+"' "+
 					" and OneKey='"+sKey+"' "+
 					" and nvl(~s借据明细@业务品种e~,'')='中长期流动资金贷款'"+
 					" and (nvl(~s借据明细@期限日e~,0)>0 and nvl(~s借据明细@期限月e~,0)+1<=12 or nvl(~s借据明细@期限月e~,0)<=12)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql); 
 		//6、企业规模 为空的为 医院、学校、事业单位等
 		sSql="update Batch_Import_Interim set ~s借据明细@企业规模e~='机关事业单位'"+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and nvl(~s借据明细@企业规模e~,'')=''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql); 
 		//7、统一更新币种到人民币，余额 金额做相应转化
 		sSql="update Batch_Import_Interim set ~s借据明细@币种e~='01',"+
			 		"~s借据明细@金额(元)e~=~s借据明细@金额(元)e~*nvl(getErate(~s借据明细@币种e~,'01',''),1),"+
			 		"~s借据明细@余额(元)e~=~s借据明细@余额(元)e~*nvl(getErate(~s借据明细@币种e~,'01',''),1) "+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and nvl(~s借据明细@币种e~,'')<>'01'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
	}
	/**
	 * 按各个维度插入到处理表中
	 * @throws Exception 
	 */
	public static void process(String sConfigNo,String sKey,Transaction Sqlca,String Dimension,String groupBy) throws Exception{
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
 				"ConfigNo,OneKey,'"+Dimension+"',"+groupColumns+
				"round(sum(case when ~s借据明细@借据起始日e~ like '"+sKey+"%' then ~s借据明细@金额(元)e~ end)/10000,2) as BusinessSum,"+//按月投放金额
				(isSeason==true?"round(sum(case when ~s借据明细@借据起始日e~ like '"+last2month+"%' or ~s借据明细@借据起始日e~ like '"+last1month+"%' or ~s借据明细@借据起始日e~ like '"+sKey+"%' then ~s借据明细@金额(元)e~ end)/10000,2)":"0")+","+//如果是季度末，计算按季投放金额
				"round(case when sum(~s借据明细@金额(元)e~)<>0 then sum(~s借据明细@金额(元)e~*~s借据明细@执行年利率(%)e~)/sum(~s借据明细@金额(元)e~) else 0 end,2) as Balance, "+//加权利率
				"round(sum(~s借据明细@余额(元)e~)/10000,2) as Balance, "+
				"count(distinct ~s借据明细@客户名称e~) "+
				"from Batch_Import_Interim "+
				"where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s借据明细@余额(元)e~,0)>0 "+
				"group by ConfigNo,OneKey"+("".equals(groupBy)?"":","+groupBy);
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,BusinessRate,Balance,TotalTransaction)"+
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
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2),sum(TotalTransaction) "+
			"from Batch_Import_Process "+
			"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('@',DimensionValue)>0 "+
			"group by ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
		//2、插入各个维度的总计
 		sSql="select "+
 				"ConfigNo,OneKey,Dimension,'总计',"+
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2) as Balance,sum(TotalTransaction) "+
			"from Batch_Import_Process "+
			"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('小计',DimensionValue)=0 "+
			"group by ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
 		//3、相对前一年度增加值和幅度更新
 		sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY from "+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+
				"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			")tab1,"+
			"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+	
			"from Batch_Import_Process "+
				"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
			")tab2"+
			" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab1 "+
 				"set(BalanceTLY,BusinessRateTLY,BalanceRangeTLY)="+
 				"(select BalanceTLY,BusinessRateTLY,BalanceRangeTLY from "+
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
 	 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
 	 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
 	 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY from "+
 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+
 					"from Batch_Import_Process "+
 					"where ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 				")tab1,"+
 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance "+	
 				"from Batch_Import_Process "+
 					"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
 				")tab2"+
 				" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue";
 	 		Sqlca.executeSQL("update Batch_Import_Process tab1 "+
 	 				"set(BalanceTLY,BusinessRateTLY,BalanceRangeTLY)="+
 	 				"(select BalanceTLY,BusinessRateTLY,BalanceRangeTLY from "+
 	 				"("+sSql+") tab2 where tab1.OneKey=tab2.OneKey and tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue"+
 	 				")"+
 	 				" where ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 	 				" and exists(select 1 from ("+sSql+") tab22 where tab1.OneKey=tab22.OneKey and tab1.Dimension=tab22.Dimension and tab1.DimensionValue=tab22.DimensionValue)"
 	 				);
 		}
 		//4、占比更新
 		sSql="select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
 				"case when nvl(tab2.BusinessSum,0)<>0 then round(tab1.BusinessSum/tab2.BusinessSum*100,2) else 0 end as BusinessSumRatio,"+
 				"case when nvl(tab2.BusinessSumSeason,0)<>0 then round(tab1.BusinessSumSeason/tab2.BusinessSumSeason*100,2) else 0 end as BusinessSeasonRatio,"+
 				"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio from "+
					"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance "+
						"from Batch_Import_Process "+
						"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
					")tab1,"+
					"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance "+	
						"from Batch_Import_Process "+
						"where ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and DimensionValue='总计'"+
					")tab2"+
				" where tab1.Dimension=tab2.Dimension";
 		Sqlca.executeSQL("update Batch_Import_Process tab1 "+
 				"set(BusinessSumRatio,BusinessSumSeasonRatio,BalanceRatio)="+
 				"( select BusinessSumRatio,BusinessSumSeasonRatio,BalanceRatio from "+
 				"("+sSql+") tab2 where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue"+
 				")"+
 				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 from ("+sSql+") tab22 where tab1.Dimension=tab22.Dimension and tab1.DimensionValue=tab22.DimensionValue)"
 				);
	}
}