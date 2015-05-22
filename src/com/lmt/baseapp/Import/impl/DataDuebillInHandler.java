package com.lmt.baseapp.Import.impl;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class DataDuebillInHandler{
	public static void beforeHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca)throws Exception{
		//更新配置号和报表日期
 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and ImportNo like 'N%000000'");
		//清空目标表 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	}
	/**
	 * 表内借据导入后处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public static void handle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//先导入到数据库,并清空目标表，为数据处理做准备
		DataDuebillInHandler.beforeHandle(HandlerFlag, sConfigNo, sOneKey, Sqlca);
		//1、对中间表数据进行特殊处理 	 		 	
		DataDuebillInHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//经营类型分组
 		String groupBy="case "+
 				"when ~s借据明细@经营类型(新)e~ is null or ~s借据明细@经营类型(新)e~ = '' or ~s借据明细@经营类型(新)e~='其他' then 'V-其他' "+
 				"when ~s借据明细@经营类型(新)e~ like '煤炭开采' then 'A-煤炭@开采'" +
 				"when ~s借据明细@经营类型(新)e~ like '煤炭洗选' then 'A-煤炭@洗选' "+
 				"when ~s借据明细@经营类型(新)e~ like '焦碳—独立焦化' then 'B-焦碳@独立焦化' "+//焦碳—
 				"when ~s借据明细@经营类型(新)e~ like '焦碳—煤焦一体' or ~s借据明细@经营类型(新)e~ = '焦碳' then 'B-焦碳@煤焦一体' "+//焦碳—
 				"when ~s借据明细@经营类型(新)e~ like '焦碳—焦钢一体' then 'B-焦碳@焦钢一体' "+//焦碳—
 				"when ~s借据明细@经营类型(新)e~ like '焦碳—限期保留' then 'B-焦碳@限期保留' "+//焦碳—
 				"when ~s借据明细@经营类型(新)e~ like '焦碳—气源厂' then 'B-焦碳@气源厂' "+//焦碳—
 				"when ~s借据明细@经营类型(新)e~ like '焦碳—热回收' then 'B-焦碳@热回收' "+//焦碳—
 				"when ~s借据明细@经营类型(新)e~ like '批发零售%' then 'C-批发零售' "+//批发零售—
 				"when ~s借据明细@经营类型(新)e~ like '制造业—水泥' then 'D-制造业@水泥' "+//制造业—
 				"when ~s借据明细@经营类型(新)e~ like '制造业—平板玻璃' then 'D-制造业@平板玻璃' "+//制造业—
 				"when ~s借据明细@经营类型(新)e~ like '制造业%' then 'D-制造业@其他' "+//制造业—
 				"when ~s借据明细@经营类型(新)e~ like '钢铁' then 'E-钢铁' "+
 				"when ~s借据明细@经营类型(新)e~ like '房地产' then 'F-房地产' "+
 				"when ~s借据明细@经营类型(新)e~ like '化工化肥' then 'G-化工化肥' "+
	 			"when ~s借据明细@经营类型(新)e~ like '建筑施工' or ~s借据明细@经营类型(新)e~ like '工程建筑' or ~s借据明细@经营类型(新)e~ like '建筑工程' then 'H-建筑施工' "+
	 			"when ~s借据明细@经营类型(新)e~ like '铁矿开采' then 'I-铁矿开采' "+
	 			"when ~s借据明细@经营类型(新)e~ like '农林牧副渔' then 'J-农林牧副渔' "+
	 			"when ~s借据明细@经营类型(新)e~ like '政府平台' then 'K-政府平台' "+
				"when ~s借据明细@经营类型(新)e~ like '钢贸户' or ~s借据明细@经营类型(新)e~ like '%钢材销售%' then 'L-钢贸户' "+
				"when ~s借据明细@经营类型(新)e~ like '医药制造' then 'M-医药制造' "+
				"when ~s借据明细@经营类型(新)e~ like '燃气生产和供应' then 'N-燃气生产和供应' "+
				"when ~s借据明细@经营类型(新)e~ like '汽车维修及销售' then 'O-汽车维修及销售' "+
				"when ~s借据明细@经营类型(新)e~ like '电力' then 'P-电力' "+
				"when ~s借据明细@经营类型(新)e~ like '住宿餐饮' then 'Q-住宿餐饮' "+
	 			"when ~s借据明细@经营类型(新)e~ like '交通运输' then 'R-交通运输' "+
	 			"when ~s借据明细@经营类型(新)e~ like '医院学校' then 'S-医院学校' "+
	 			"when ~s借据明细@经营类型(新)e~ like '信息技术' then 'T-信息技术' "+
	 			"when ~s借据明细@经营类型(新)e~ like '文化娱乐' then 'U-文化娱乐' "+
	 			"else 'W-'||~s借据明细@经营类型(新)e~ end";
	 	DataDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"经营类型(新)",groupBy,"");
	 	//期限业务品种分组
	 	groupBy="case when case when ~s借据明细@期限日e~>0 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=6  then '1M6]' "+
	 						"when case when ~s借据明细@期限日e~>1 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=12 then '2M(6-12]' "+//常常有12个月零1天那种，先处理为12个月吧，遗留数据有几笔（00000231001，00000230881，00000231541，00000253001）
	 						"when case when ~s借据明细@期限日e~>0 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=36 then '3M(12-36]' "+
	 						"when case when ~s借据明细@期限日e~>0 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=60 then '4M(36-60]' "+
	 						"else '5M(60' endLJF@~s借据明细@业务品种e~";
	 	DataDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"期限业务品种",groupBy,"");
	 	
	 	groupBy="case when ~s借据明细@主要担保方式e~ like '保证-%' then '保证' "+
	 			"when ~s借据明细@主要担保方式e~ like '抵押-%' then '抵押' "+
	 			"when ~s借据明细@主要担保方式e~ = '信用' then '信用' "+
	 			"when ~s借据明细@主要担保方式e~ like '%质押-%' or ~s借据明细@主要担保方式e~='保证金' then '质押' "+
	 			"else '其他' end";
	 	DataDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"贷款单一担保方式",groupBy,"");
	 	
	 	groupBy="case " +
	 				" when ~s借据明细@业务品种e~ like '%垫款'  then 'G-上浮50%以上@0-垫款' "+
	 				" when ~s借据明细@归属条线e~ = '小企业条线' and (~s借据明细@利率浮动方式e~='浮动比率(%)' and ~s借据明细@利率浮动值e~>50 or ~s借据明细@利率浮动方式e~='浮动点' and ~s借据明细@利率浮动值e~/(~s借据明细@执行年利率(%)e~-~s借据明细@利率浮动值e~)*100>50) then 'G-上浮50%以上@1-公司条线' "+
	 				" when ~s借据明细@归属条线e~ = '公司条线' and (~s借据明细@利率浮动方式e~='浮动比率(%)' and ~s借据明细@利率浮动值e~>50 or ~s借据明细@利率浮动方式e~='浮动点' and ~s借据明细@利率浮动值e~/(~s借据明细@执行年利率(%)e~-~s借据明细@利率浮动值e~)*100>50) then 'G-上浮50%以上@2-小企业条线' "+
	 				" when ~s借据明细@归属条线e~ = '零售条线' and (~s借据明细@利率浮动方式e~='浮动比率(%)' and ~s借据明细@利率浮动值e~>50 or ~s借据明细@利率浮动方式e~='浮动点' and ~s借据明细@利率浮动值e~/(~s借据明细@执行年利率(%)e~-~s借据明细@利率浮动值e~)*100>50) then 'G-上浮50%以上@3-零售条线' "+
	 				" when ~s借据明细@利率浮动方式e~='浮动比率(%)' and ~s借据明细@利率浮动值e~>30 or ~s借据明细@利率浮动方式e~='浮动点' and ~s借据明细@利率浮动值e~/(~s借据明细@执行年利率(%)e~-~s借据明细@利率浮动值e~)*100>30 then 'F-上浮30%-50%（含50%）' "+
	 				" when ~s借据明细@利率浮动方式e~='浮动比率(%)' and ~s借据明细@利率浮动值e~>20 or ~s借据明细@利率浮动方式e~='浮动点' and ~s借据明细@利率浮动值e~/(~s借据明细@执行年利率(%)e~-~s借据明细@利率浮动值e~)*100>20 then 'E-上浮20%-30%（含30%）' "+
	 				" when ~s借据明细@利率浮动方式e~='浮动比率(%)' and ~s借据明细@利率浮动值e~>10 or ~s借据明细@利率浮动方式e~='浮动点' and ~s借据明细@利率浮动值e~/(~s借据明细@执行年利率(%)e~-~s借据明细@利率浮动值e~)*100>10 then 'D-上浮10%-20%（含20%）' "+
	 				" when ~s借据明细@利率浮动方式e~='浮动比率(%)' and ~s借据明细@利率浮动值e~>0 or ~s借据明细@利率浮动方式e~='浮动点' and ~s借据明细@利率浮动值e~/(~s借据明细@执行年利率(%)e~-~s借据明细@利率浮动值e~)*100>0 then 'C-上浮10%以内（含10%）' "+
	 				" when ~s借据明细@利率浮动方式e~='浮动比率(%)' and ~s借据明细@利率浮动值e~=0 or ~s借据明细@利率浮动方式e~='浮动点' and ~s借据明细@利率浮动值e~/(~s借据明细@执行年利率(%)e~-~s借据明细@利率浮动值e~)*100=0 then 'B-基准利率' "+
	 				" else 'A-下浮10%以内（含10%）' end";
	 	DataDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"利率浮动区间",groupBy,"");//and ~s借据明细@业务品种e~ not like '%垫款'
	 	
	 	DataDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"企业规模","~s借据明细@企业规模e~","");
	 	
	 	DataDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"业务品种","~s借据明细@业务品种e~","");
	 	
	 	groupBy="case  "+
	 			"when ~s借据明细@国家地区e~ like '%吕梁市%' then 'B-吕梁市' "+
	 			"when ~s借据明细@国家地区e~ like '%晋中市%' then 'C-晋中市' "+
	 			"when ~s借据明细@国家地区e~ like '%临汾市%' then 'D-临汾市' "+
	 			"when ~s借据明细@国家地区e~ like '%运城市%' then 'E-运城市' "+
	 			"when ~s借据明细@国家地区e~ like '%长治市%' then 'F-长治市' "+
	 			"when ~s借据明细@国家地区e~ like '%朔州市%' then 'G-朔州市' "+
	 			"when ~s借据明细@国家地区e~ like '%忻州市%' then 'H-忻州市' "+
	 			"when ~s借据明细@国家地区e~ like '%大同市%' then 'I-大同市' "+
	 			"when ~s借据明细@国家地区e~ like '%晋城市%' then 'J-晋城市' "+
	 			"when ~s借据明细@国家地区e~ like '%阳泉市%' then 'K-阳泉市' "+
	 			//"when ~s借据明细@国家地区e~ like '%石家庄市%' then '石家庄市' "+
	 			//"when ~s借据明细@国家地区e~ like '%武汉市%' then '武汉市' "+
	 			//"when ~s借据明细@国家地区e~ like '%佛山市%' then 'L-佛山市' "+
	 			"else 'A-太原市' end";//剩下的默认都是太原市when ~s借据明细@国家地区e~ like '%太原市%' then '太原市'
	 	DataDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"地区分类",groupBy,"");
	 	
	 	DataDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"机构分类","~s借据明细@直属行名称e~","");
	 	
	 	//单独完成一些复杂的操作
	 	DataDuebillInHandler.afterProcess1(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	 	//4、加工后，进行合计，横向纵向分析
	 	DataDuebillInHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	//对导入数据加工处理,插入到中间表Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		//修改 王秀梅这个贷款 短期流动资金贷款 由零售条线 修改为 公司条线 ，经营类型为 批发零售—其它
		String sSql="update Batch_Import_Interim set ~s借据明细@归属条线e~='公司条线',~s借据明细@国家地区e~='太原市',~s借据明细@经营类型(新)e~='批发零售—其它' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s借据明细@借据流水号e~,'')='2740124368501101'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
		//1、归属条线 个人条线统一修改为 零售条线
		sSql="update Batch_Import_Interim set ~s借据明细@归属条线e~='零售条线' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and (nvl(~s个人明细@归属条线e~,'')='个人条线' or nvl(~s个人明细@归属条线e~,'')='微小条线')";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//2、 
 		//b、经营类型（新）设置一个基准日期，其他日期以这个日期为准， 更新到其他时间的之前的，随着业务不断变化，后期经营类型会不断变化，以一年调整一次还是就某个日期不变呢，这是个问题
 		//采取 2014/05以前的以2014/05为准，此后就当前为准保持不变
 		//原则报上的数据都不要再调整，只灵活调整当期
 		String AdjustDate="2014/05";//StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0);
 		if(1==1&&sKey.compareTo(AdjustDate)<0){
 			sSql="update Batch_Import_Interim BII set ~s借据明细@经营类型(新)e~="+
 					"(select ~s借据明细@经营类型(新)e~ from Batch_Import BI "+
 					"where BI.ConfigNo=BII.ConfigNo and BI.OneKey='"+AdjustDate+"' and BI.~s借据明细@借据流水号e~=BII.~s借据明细@借据流水号e~) "+
 			" where BII.ConfigNo='"+sConfigNo+"' and BII.OneKey='"+sKey+"'"+
 			" and exists(select 1 from Batch_Import BI1 where BI1.ConfigNo=BII.ConfigNo and BI1.OneKey='"+AdjustDate+"' and BI1.~s借据明细@借据流水号e~=BII.~s借据明细@借据流水号e~)";
 			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 			Sqlca.executeSQL(sSql);
 		}
		//a、经营类型（新）如果字段为空，更新 经营类型 内的值
 		sSql="update Batch_Import_Interim set ~s借据明细@经营类型(新)e~=~s借据明细@经营类型e~ where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and (nvl(~s借据明细@经营类型(新)e~,'')='' or ~s借据明细@经营类型(新)e~='其他' and nvl(~s借据明细@经营类型e~,'')<>'' and ~s借据明细@经营类型(新)e~<>~s借据明细@经营类型e~)";
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
 		//4、管户机构 为迎泽支行的直属行名称由 总行营业部 变为 龙城直属支行
 		sSql="update Batch_Import_Interim set ~s借据明细@直属行名称e~='龙城直属支行'"+
 					" where ConfigNo='"+sConfigNo+"' "+
 					" and OneKey='"+sKey+"' "+
 					" and nvl(~s借据明细@直属行名称e~,'')='总行营业部'"+
 					" and nvl(~s借据明细@管户机构e~,'')='总行营业部'";
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
 					" and (nvl(~s借据明细@期限日e~,0)>0 and nvl(~s借据明细@期限月e~,0)+1>12 or nvl(~s借据明细@期限月e~,0)>12) ";//or nvl(~s借据明细@期限类型e~,0)='中长期'
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
	public static void process(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca,String Dimension,String groupBy,String sWhere) throws Exception{
		//是否季报，半年报，年报月份，原来只考虑季报，所以字段用的Season，现在扩展了，此处变量和数据库字段不再变化
		//当前月份为03,09就表示季报，06就表示半年报 12就表示年报
		boolean isSeason=false;
		String startsmonth="";
		if(StringFunction.isLike(sKey, "%03")||StringFunction.isLike(sKey, "%09")){
			startsmonth=StringFunction.getRelativeAccountMonth(sKey,"month", -2);
			isSeason=true;
		}
		if(StringFunction.isLike(sKey, "%06")){
			startsmonth=StringFunction.getRelativeAccountMonth(sKey,"month", -5);
			isSeason=true;
		}
		if(StringFunction.isLike(sKey, "%12")){
			startsmonth=StringFunction.getRelativeAccountMonth(sKey,"month", -11);
			isSeason=true;
		}
		String[] groupColumnClause=StringUtils.replaceWithRealSql(groupBy);
 		//1、按各种维度汇总到处理表中
		String sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,'"+Dimension+"',"+groupColumnClause[0]+
				"round(sum(case when ~s借据明细@借据起始日e~ like '"+sKey+"%' then ~s借据明细@金额(元)e~ end)/10000,2) as BusinessSum,"+//按月投放金额
				(isSeason==true?"round(sum(case when ~s借据明细@借据起始日e~ >= '"+startsmonth+"/01' and ~s借据明细@借据起始日e~ <= '"+sKey+"/31' then ~s借据明细@金额(元)e~ end)/10000,2)":"0")+","+//如果是季度末，计算按季投放金额,如果是半年末计算半年投放，整年....
				"round(case when sum(~s借据明细@金额(元)e~)<>0 then sum(~s借据明细@金额(元)e~*~s借据明细@执行年利率(%)e~)/sum(~s借据明细@金额(元)e~) else 0 end,2) as BusinessRate, "+//加权利率
				"round(sum(~s借据明细@余额(元)e~)/10000,2) as Balance, "+
				"count(distinct ~s借据明细@客户名称e~) "+
				"from Batch_Import_Interim "+
				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s借据明细@余额(元)e~,0)>0 "+sWhere+
				" group by ConfigNo,OneKey"+groupColumnClause[1];
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,BusinessRate,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
	}
	//因为SQL语句复杂 process无法通用完成，需要此处独立完成
	public static void afterProcess1(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		//贷款金额区间(按户数来)
		String groupBy="case when BalanceSum>=500000000 then 'A-5亿以上（含5亿）' "+
	 			"when BalanceSum>=300000000 then 'B-3亿至5亿（含3亿）' "+
	 			"when BalanceSum>=200000000 then 'C-2亿至3亿（含2亿）' "+
	 			"when BalanceSum>=100000000 then 'D-1亿至2亿（含1亿）' "+
	 			"when BalanceSum>=50000000 then 'E-5000万至1亿（含5000万）' "+
	 			"else case when MDF like '%公司条线' then 'F-5000万以下@公司条线' else 'F-5000万以下@小企业条线' end end";
		String sSql="select " +
				"'"+HandlerFlag+"','"+sConfigNo+"','"+sKey+"','贷款余额区间',"+groupBy+",round(sum(BalanceSum)/10000,2),count(CustomerName)"+
				" from " +
				" (select ~s借据明细@客户名称e~ as CustomerName," +
				" max(~s借据明细@借据起始日e~||~s借据明细@归属条线e~) as MDF," +
				"sum(~s借据明细@余额(元)e~) as BalanceSum " +
				" from Batch_Import_Interim BII" +
				" where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and nvl(~s借据明细@余额(元)e~,0)>0 "+
				" group by ConfigNo,OneKey,~s借据明细@客户名称e~)tab"+
				" group by "+groupBy;
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
	}
			
	//加入小计 合计 横向纵向比较值 小计总以 DimensionValue 中以@分割为标志
	public static void afterProcess(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		//0、插入各个维度的小计
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)||'@小计',"+
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2),sum(TotalTransaction) "+
			" from Batch_Import_Process "+
			" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('@',DimensionValue)>0 "+
			" group by HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
 		//1、插入各个维度的中计 以~为标记
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('~',DimensionValue)-1)||'@中计',"+
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2),sum(TotalTransaction) "+
			"from Batch_Import_Process "+
			"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('小计',DimensionValue)=0 and locate('~',DimensionValue)>0 "+
			"group by HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('~',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
		//2、插入各个维度的总计
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,'ZZ-总计@总计',"+
			"round(sum(BusinessSum),2),round(sum(BusinessSumSeason),2),round(sum(Balance),2) as Balance,sum(TotalTransaction) "+
			" from Batch_Import_Process "+
			" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('小计',DimensionValue)=0"+
			" group by HandlerFlag,ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
 		//3、占比（总计，小计等汇总的值要靠四舍五入后的值一层层相加得到，不要以原始值相加，因为四舍五入会造成不准）更新
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
		 				"case when nvl(tab2.BusinessSum,0)<>0 then round(tab1.BusinessSum/tab2.BusinessSum*100,2) else 0 end as BusinessSumRatio,"+
		 				"case when nvl(tab2.BusinessSumSeason,0)<>0 then round(tab1.BusinessSumSeason/tab2.BusinessSumSeason*100,2) else 0 end as BusinessSumSeasonRatio,"+
		 				"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio from "+
					"(select Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance "+
						"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
					")tab1,"+
					"(select Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance "+	
						"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('总计',DimensionValue)>0"+
					")tab2"+
					" where tab1.Dimension=tab2.Dimension)tab3"+
				" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BusinessSumRatio,BusinessSumSeasonRatio,BalanceRatio)="+
 				"(select tab3.BusinessSumRatio,tab3.BusinessSumSeasonRatio,tab3.BalanceRatio "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 "+sSql+")"
 				);
 		//4、相对前一年度增加值和幅度更新
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
		 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
		 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
		 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY,"+
		 				"(nvl(tab1.BalanceRatio,0)-nvl(tab2.BalanceRatio,0)) as BalanceRatioTLY"+
		 				" from "+
					"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio "+
						"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
					")tab1,"+
					"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio "+	
					"from Batch_Import_Process "+
						"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
					")tab2"+
					" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
			" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";	
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BalanceTLY,BusinessRateTLY,BalanceRangeTLY,BalanceRatioTLY)="+
 				"(select tab3.BalanceTLY,tab3.BusinessRateTLY,tab3.BalanceRangeTLY,BalanceRatioTLY "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 "+sSql+")"
 				);
 		//如果是年度导入，更新下一年度所有月份的增加值、增加值和幅度更新
 		if(StringFunction.isLike(sKey, "%/12")){
 			sSql="select distinct OneKey from Batch_Import_Process where ConfigNo='"+sConfigNo+"' and OneKey>'"+sKey+"'";
 			String[] sOneKey=Sqlca.getStringArray(sSql);
 			String OneKeys=StringFunction.toArrayString(sOneKey, "','");
 			sSql="from (select tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
		 	 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
		 	 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
		 	 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY," +
		 	 				"(nvl(tab1.BalanceRatio,0)-nvl(tab2.BalanceRatio,0)) as BalanceRatioTLY"+
		 	 				" from "+
		 				"(select OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio "+
		 					"from Batch_Import_Process "+
		 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
		 				")tab1,"+
		 				"(select OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio "+	
		 				"from Batch_Import_Process "+
		 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
		 				")tab2"+
		 				" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
 				" where tab.OneKey=tab3.OneKey and tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";	
 	 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 	 				"set(BalanceTLY,BusinessRateTLY,BalanceRangeTLY,BalanceRatioTLY)="+
 	 				"(select tab3.BalanceTLY,tab3.BusinessRateTLY,tab3.BalanceRangeTLY,tab3.BalanceRatioTLY "+
 	 				sSql+
 	 				")"+
 	 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 	 				" and exists(select 1 "+sSql+")"
 	 				);
 		}
	}
}