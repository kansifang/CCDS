package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class AIContractHandler{
	//对导入数据加工处理,插入到中间表Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		String sSql="";
		//1、主要担保方式为信用的以从2014/05月份合同的 其他担保方式 为准更新到2014/03，因为03月份不准确(建立基准)
		String AdjustDate="2014/05";//StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0);
 		if(1==1&&sKey.compareTo(AdjustDate)<0){
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
		sSql="update Batch_Import_Interim set ~s合同明细@余额e~=475000000"+//直接写这个数吧，不能和借据搅合在一起，每次使用合同时都要验证这笔业务借据余额是否变化
					//"(select ~s借据明细@余额(元)e~ from Batch_Import_Interim "+
					//"where ConfigName='借据明细' and OneKey='"+sKey+"' and ~s借据明细@借据流水号e~='00000167523')"+
					" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
					" and nvl(~s合同明细@合同流水号e~,'')='20130412000007'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//4、统一更新币种到人民币，余额 金额做相应转化
 		sSql="update Batch_Import_Interim set ~s合同明细@币种e~='01',"+
			 		"~s合同明细@金额e~=~s合同明细@金额e~*nvl(getErate(~s合同明细@币种e~,'01',''),1),"+
			 		"~s合同明细@余额e~=~s合同明细@余额e~*nvl(getErate(~s合同明细@币种e~,'01',''),1) "+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and nvl(~s合同明细@币种e~,'')<>'01'";
 		//sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		//Sqlca.executeSQL(sSql);
 		//5、如果是本行存单或保证金，保证金比例是0（当然敞口金额也是0）的承兑汇票的保证金比例变成100 风险敞口变为0
 		sSql="update Batch_Import_Interim set ~s合同明细@保证金比例(%)e~=100"+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and (nvl(~s合同明细@主要担保方式e~,'') like '%保证金%' or nvl(~s合同明细@主要担保方式e~,'') like '%本行存单%' or nvl(~s合同明细@主要担保方式e~,'') like '%我行人民币存款%')"+
 					" and nvl(~s合同明细@保证金比例(%)e~,0)=0"+
 					" and nvl(~s合同明细@业务品种e~,'')='银行承兑汇票'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//6、如果是保证金比例不为100（当然敞口>0），主要担保方式为本行存单或保证金的承兑汇票的,结合合同明细，如果其中 “其他担保方式” 包含抵押，则主要担保方式变为抵押
 		sSql="update Batch_Import_Interim BII1 set ~s合同明细@主要担保方式e~=" +
 					" case when ~s合同明细@其他担保方式e~ like '%抵押%' then '抵押-' " +
 					" else '保证-' end " +
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and (nvl(~s合同明细@主要担保方式e~,'') like '%保证金%' or nvl(~s合同明细@主要担保方式e~,'') like '%本行存单%' or nvl(~s合同明细@主要担保方式e~,'') like '%我行人民币存款%')"+
 					" and nvl(~s合同明细@保证金比例(%)e~,0)<>100"+
 					" and nvl(~s合同明细@业务品种e~,'')='银行承兑汇票'" +
 					" and (nvl(~s合同明细@其他担保方式e~,'') like '%抵押%' or nvl(~s合同明细@其他担保方式e~,'') like '%保证%')";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//11、主要担保方式为银行承兑汇票的,如果保证金比例为100，保证金比例变成0
 		sSql="update Batch_Import_Interim set ~s合同明细@保证金比例(%)e~=0"+
					" where ConfigNo='"+sConfigNo+"'"+
					" and OneKey='"+sKey+"'"+
					" and nvl(~s合同明细@主要担保方式e~,'') like '%银行承兑汇票%'"+
					" and nvl(~s合同明细@保证金比例(%)e~,0)=100"+
					" and nvl(~s合同明细@业务品种e~,'')='银行承兑汇票'";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
		//11、山西海星物贸有限公司(20110303000008)合同（20140702000060）保证比例为50% 表外借据（434805-434811）保证金比例却为0---待去系统查找原因 此处更新成0，先于借据保持一致
 		sSql="update Batch_Import_Interim set ~s合同明细@保证金比例(%)e~=0"+
					" where ConfigNo='"+sConfigNo+"'"+
					" and OneKey='"+sKey+"'"+
					" and nvl(~s合同明细@合同流水号e~,'') = '20140702000060'";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
 		//12、核心存在未解付的215w，在此当成全额插入
 		sSql="insert into Batch_Import_Interim" +
 					"(ConfigNo,OneKey,~s合同明细@业务品种e~,~s合同明细@主要担保方式e~,~s合同明细@保证金比例(%)e~,~s合同明细@余额e~,~s合同明细@经营类型(新)e~)" +
 					"values('"+sConfigNo+"','"+sKey+"','银行承兑汇票','保证金',100,2150000,'煤炭开采')";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//4、管户机构 为迎泽支行的直属行名称由 总行营业部 变为 龙城直属支行
 		sSql="update Batch_Import_Interim set ~s合同明细@直属行e~='龙城直属支行'"+
 					" where ConfigNo='"+sConfigNo+"' "+
 					" and OneKey='"+sKey+"' "+
 					" and nvl(~s合同明细@直属行e~,'')='总行营业部'"+
 					" and nvl(~s合同明细@管户机构e~,'')='总行营业部'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
	}
	/**
	 * 合同导入后处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public static void contractHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1、对中间表数据进行特殊处理 	 		 	
		AIContractHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//对公贷款混合担保（按照合同的其他担保方式直接分组，此处不再case when...）
	 	String groupBy="case when ~s合同明细@其他担保方式e~ like '%保证%' and ~s合同明细@其他担保方式e~ like '%软抵押%' then '保证+软抵押' "+
	 			"when ~s合同明细@其他担保方式e~ like '%保证%' and ~s合同明细@其他担保方式e~ like '%抵押%' and ~s合同明细@其他担保方式e~ like '%质押%' then '保证+抵质押' "+
	 			"when ~s合同明细@其他担保方式e~ = '保证' then '单一保证' "+
	 			"when ~s合同明细@其他担保方式e~ like '%信用%' and ~s合同明细@其他担保方式e~ like '%软抵押%' then '信用+软抵押' "+
	 			"when ~s合同明细@其他担保方式e~ = '信用' then '单一信用' "+
	 			"when ~s合同明细@其他担保方式e~ = '抵押' then '单一抵押' "+
	 			"when ~s合同明细@其他担保方式e~ = '质押' then '单一质押' "+
	 			"when ~s合同明细@其他担保方式e~ like '%抵押%' and ~s合同明细@其他担保方式e~ like '%质押%' then '抵押+质押' "+
	 			"else '其他担保' end";
	 	String sWhere=" and nvl(~s合同明细@业务品种e~,'X') not in('国内信用证','进口信用证','银行承兑汇票','贷款担保','进口信用证增额','委托代付-信用证','委托贷款')";
	 	AIContractHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"对公贷款混合担保","~s合同明细@其他担保方式e~",sWhere);
	 	//银承混合担保
	 	groupBy="case when ~s合同明细@主要担保方式e~ like '%质押%' and not(~s合同明细@主要担保方式e~ like '%本行存单' or ~s合同明细@主要担保方式e~ like '%保证金' or ~s合同明细@主要担保方式e~ like '%我行人民币存款%') then ~s合同明细@其他担保方式e~" +
	 			//" ~s合同明细@主要担保方式e~ like '%保证%' and ~s合同明细@其他担保方式e~ like '%保证%' " +
	 			//		"  and ~s合同明细@其他担保方式e~ like '%质押%' " +
	 			//		"  and ~s合同明细@其他担保方式e~ not like '%软抵押%' " +
	 			//		"  and ~s合同明细@其他担保方式e~ not like '%抵押%' then '保证' "+
	 			//"when ~s合同明细@其他担保方式e~ like '%保证%' and ~s合同明细@其他担保方式e~ like '%抵押%' and ~s合同明细@其他担保方式e~ like '%质押%' then '保证+抵质押' "+
	 			//"when ~s合同明细@其他担保方式e~ = '保证' then '单一保证' "+
	 			//"when ~s合同明细@其他担保方式e~ like '%信用%' and ~s合同明细@其他担保方式e~ like '%软抵押%' then '信用+软抵押' "+
	 			//"when ~s合同明细@其他担保方式e~ = '信用' then '单一信用' "+
	 			//"when ~s合同明细@其他担保方式e~ = '抵押' then '单一抵押' "+
	 			//"when ~s合同明细@其他担保方式e~ = '质押' then '单一质押' "+
	 			//"when ~s合同明细@其他担保方式e~ like '%抵押%' and ~s合同明细@其他担保方式e~ like '%质押%' then '抵押+质押' "+
	 			" else replace(~s合同明细@其他担保方式e~,'质押','') end";
	 	sWhere="and nvl(~s合同明细@业务品种e~,'')='银行承兑汇票' and not(nvl(~s合同明细@保证金比例(%)e~,0)=100 and (~s合同明细@主要担保方式e~ like '%本行存单' or ~s合同明细@主要担保方式e~ like '%保证金' or ~s合同明细@主要担保方式e~ like '%我行人民币存款%'))";
	 	AIContractHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"银行承兑汇票混合担保",groupBy,sWhere);
	 	//4、加工后，进行合计，横向纵向分析
	 	AIContractHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	/**
	 * 按各个维度插入到处理表中
	 * @throws Exception 
	 */
	public static void process(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca,String Dimension,String groupBy,String sWhere) throws Exception{
		String sSql="";
 		//1、按条线计算增加额和比例等信息放入处理表中
		String[] groupColumnClause=StringUtils.replaceWithRealSql(groupBy);
 		sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,'"+Dimension+"',"+groupColumnClause[0]+
				" round(sum(case when ~s合同明细@合同起始日e~ like '"+sKey+"%' then ~s合同明细@金额e~ else 0 end)/10000,2) as BusinessSum,"+//按月投放金额
				" round(sum(~s合同明细@余额e~)/10000,2) as Balance,"+ 
				" round(sum(~s合同明细@余额e~*(100-nvl(~s合同明细@保证金比例(%)e~,0))/100)/10000,2) as CKBalance"+
				" from Batch_Import_Interim "+
				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s合同明细@余额e~,0)>0 "+
				" and nvl(~s合同明细@业务品种e~,'') <> '' "+
				" and nvl(~s合同明细@业务品种e~,'X') not like '%保函%' "+
				" and nvl(~s合同明细@业务品种e~,'X') not like '%额度%' "+
				sWhere+
				//" and nvl(~s合同明细@业务品种e~,'X') not like '%出口%' "+
				"group by ConfigNo,OneKey"+groupColumnClause[1];
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance,CKBalance)"+
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
 				"'"+HandlerFlag+"',ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)||'@小计',"+
			"round(sum(BusinessSum),2) as BusinessSum," +
			"round(sum(Balance),2) as Balance, "+
			" round(sum(CKBalance),2) as CKBalance"+
			" from Batch_Import_Process "+
			" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('@',DimensionValue)>0 "+
			" group by ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance,CKBalance)"+
 				"( "+
 				sSql+
 				")");
		//2、插入各个维度的总计
 		sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,Dimension,'总计@总计',"+
			"round(sum(BusinessSum),2) as BusinessSum," +
			"round(sum(Balance),2) as Balance,"+
			" round(sum(CKBalance),2) as CKBalance"+
			" from Batch_Import_Process "+
			"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('小计',DimensionValue)=0 "+
			"group by ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,Balance,CKBalance)"+
 				"( "+
 				sSql+
 				")");
 		//3、占比更新
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
	 					"case when nvl(tab2.BusinessSum,0)<>0 then round(tab1.BusinessSum/tab2.BusinessSum*100,2) else 0 end as BusinessSumRatio,"+
	 					"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio, " +
	 					"case when nvl(tab2.CKBalance,0)<>0 then round(tab1.CKBalance/tab2.CKBalance*100,2) else 0 end as CKBalanceRatio " +
	 					"from "+
						"(select Dimension,DimensionValue,BusinessSum,Balance,CKBalance "+
							"from Batch_Import_Process "+
							"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
						")tab1,"+
						"(select Dimension,DimensionValue,BusinessSum,Balance,CKBalance "+	
							"from Batch_Import_Process "+
							"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('总计',DimensionValue)>0"+
						")tab2"+
						" where tab1.Dimension=tab2.Dimension)tab3 "+
			" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BusinessSumRatio,BalanceRatio,CKBalanceRatio)="+
 				"(select tab3.BusinessSumRatio,tab3.BalanceRatio,tab3.CKBalanceRatio "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 "+sSql+")"
 				);
 		//4、相对前一年度增加值和幅度更新
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
	 					"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceToLY,"+
	 					"(nvl(tab1.CKBalance,0)-nvl(tab2.CKBalance,0)) as CKBalanceToLY,"+
	 					"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeToLY, "+
	 					"case when nvl(tab2.CKBalance,0)<>0 then cast(round((nvl(tab1.CKBalance,0)/nvl(tab2.CKBalance,0)-1)*100,2) as numeric(24,6)) else 0 end as CKBalanceRangeToLY " +
	 				" from "+
						"(select Dimension,DimensionValue,BusinessSum,Balance,CKBalance "+
							"from Batch_Import_Process "+
							"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
						")tab1"+
						" left join " +
						"(select Dimension,DimensionValue,BusinessSum,Balance,CKBalance "+	
						"from Batch_Import_Process "+
							"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
						")tab2"+
						" on tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
				" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BalanceTLY,CKBalanceTLY,BalanceRangeTLY,CKBalanceRangeTLY)="+
 				"(select tab3.BalanceToLY,tab3.CKBalanceToLY,tab3.BalanceRangeToLY,tab3.CKBalanceRangeToLY  "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 "+sSql+")"
 				);
 			//如果是年度导入，更新下一年度所有月份的增加值、增加值和幅度更新
 		if(StringFunction.isLike(sKey, "%/12")){
 			sSql="select distinct OneKey from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey>'"+sKey+"'";
 			String[] sOneKey=Sqlca.getStringArray(sSql);
 			String OneKeys=StringFunction.toArrayString(sOneKey, "','");
 			sSql="from (select tab1.ConfigNo,tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
		 	 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceToLY,"+
		 	 				"(nvl(tab1.CKBalance,0)-nvl(tab2.CKBalance,0)) as CKBalanceToLY,"+
		 	 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeToLY, " +
		 	 				"case when nvl(tab2.CKBalance,0)<>0 then cast(round((nvl(tab1.CKBalance,0)/nvl(tab2.CKBalance,0)-1)*100,2) as numeric(24,6)) else 0 end as CKBalanceRangeToLY " +
		 	 			" from "+
			 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance,CKBalance "+
			 					"from Batch_Import_Process "+
			 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
			 				")tab1,"+
			 				"(select ConfigNo,OneKey,Dimension,DimensionValue,BusinessSum,Balance,CKBalance "+	
			 				"from Batch_Import_Process "+
			 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
			 				")tab2"+
			 				" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
		 		" where tab.OneKey=tab3.OneKey and tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";
 	 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 	 				"set(BalanceTLY,CKBalanceTLY,BalanceRangeTLY,CKBalanceRangeTLY)="+
 	 				"(select tab3.BalanceToLY,tab3.CKBalanceToLY,tab3.BalanceRangeToLY,tab3.CKBalanceRangeToLY "+
 	 				sSql+""+
 	 				")"+
 	 				" where ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 	 				" and exists(select 1 "+sSql+")"
 	 				);
 		}
	}
}