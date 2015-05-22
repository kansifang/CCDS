package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class DataDuebillOutHandler{
	public static void beforeHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca)throws Exception{
		//更新配置号和报表日期
 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and ImportNo like 'N%000000'");
		//清空目标表 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	}
	/**
	 * 表外借据导入后处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public static void handle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//先导入到数据库,并清空目标表，为数据处理做准备
		DataDuebillOutHandler.beforeHandle(HandlerFlag, sConfigNo, sOneKey, Sqlca);
		//0、对中间表数据进行特殊处理 	 		 	
		DataDuebillOutHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//1、差额全额
 		String groupBy="'银承'LJF@case "+
			 			"when nvl(~s表外明细@保证金比例(%)e~,0)=100 and (~s表外明细@主要担保方式e~ like '%本行存单' or ~s表外明细@主要担保方式e~ like '%保证金' or ~s表外明细@主要担保方式e~ like '%我行人民币存款%') then '全额银承余额' "+
			 			"else '差额银承余额' end";
 		DataDuebillOutHandler.process(HandlerFlag,sConfigNo,sOneKey,Sqlca,"差额全额银行承兑汇票",groupBy,"and nvl(~s表外明细@业务品种e~,'')='银行承兑汇票'");
		//3、保证金比例
 		groupBy="QZ'A'QZ" +
 				"complementstring(trim(replace(" +
 					"case when ~s表外明细@保证金比例(%)e~>=1 then char(~s表外明细@保证金比例(%)e~)" +
 					"else '0'||char(~s表外明细@保证金比例(%)e~) end" +
 					",'.000000','%')),'0',4,'Before')" +
 				"LJF@~s表外明细@主要担保方式e~";
 				//"QZNumber:0:4:BeforeQZQZ'A'QZ~s表外明细@主要担保方式e~";
 		DataDuebillOutHandler.process(HandlerFlag,sConfigNo,sOneKey,Sqlca,"银行承兑汇票保证金比例",groupBy,"and nvl(~s表外明细@业务品种e~,'')='银行承兑汇票'");
	 	/*原来老的，为了统一月度经营报告和全面风险报告，用下面那个
	 	groupBy="case "+
 				"when ~s表外明细@经营类型(新)e~ like '%煤炭开采%' or ~s表外明细@经营类型(新)e~ like '%煤炭洗选%' then '煤炭' "+
 				"when ~s表外明细@经营类型(新)e~ like '%焦碳%' then '焦碳' "+//焦碳—
 				"when ~s表外明细@经营类型(新)e~ like '%制造业%' or ~s表外明细@经营类型(新)e~ like '%一般加工%' then '制造业' "+//制造业—
 				"when ~s表外明细@经营类型(新)e~ like '%批发零售%' then '批发零售' "+//批发零售—
 				"when ~s表外明细@经营类型(新)e~ like '%钢铁%' then '钢铁' "+
 				"when ~s表外明细@经营类型(新)e~ like '%化工化肥%' then '化工化肥' "+
	 			"when ~s表外明细@经营类型(新)e~ like '%房地产%' then '房地产' "+
	 			"when ~s表外明细@经营类型(新)e~ like '%建筑施工%' then '建筑施工' "+
	 			"when ~s表外明细@经营类型(新)e~ like '%铁矿开采%' then '铁矿开采' "+
	 			"when ~s表外明细@经营类型(新)e~ like '%农林牧副渔%' then '农林牧副渔' "+
	 			"when ~s表外明细@经营类型(新)e~ like '%政府平台%' then '政府平台' "+
				"when ~s表外明细@经营类型(新)e~ like '%钢贸户%' or ~s表外明细@经营类型(新)e~ like '%钢材销售%' then '钢贸户' "+
				"when ~s表外明细@经营类型(新)e~ like '%医药制造%' then '医药制造' "+
				"when ~s表外明细@经营类型(新)e~ like '%燃气生产和供应%' then '燃气生产和供应' "+
				"when ~s表外明细@经营类型(新)e~ like '%汽车维修及销售%' then '汽车维修及销售' "+
				"when ~s表外明细@经营类型(新)e~ like '%电力%' then '电力' "+
				"when ~s表外明细@经营类型(新)e~ like '%住宿餐饮%' then '住宿餐饮' "+
	 			"when ~s表外明细@经营类型(新)e~ like '%交通运输%' then '交通运输' "+
	 			"when ~s表外明细@经营类型(新)e~ like '%医院学校%' then '医院学校' "+
	 			"when ~s表外明细@经营类型(新)e~ like '%信息技术%' then '信息技术' "+
	 			"when ~s表外明细@经营类型(新)e~ like '%文化娱乐%' then '文化娱乐' "+
				"when ~s表外明细@经营类型(新)e~ like '%有色冶炼%' then '有色冶炼' "+
	 			"else '其他' end";
	 	*/
	 	//4、承兑按经营类型（新）
 		groupBy="case "+
 				"when ~s表外明细@经营类型(新)e~ is null or ~s表外明细@经营类型(新)e~ = '' or ~s表外明细@经营类型(新)e~='其他' then 'V-其他' "+
 				"when ~s表外明细@经营类型(新)e~ like '煤炭开采' then 'A-煤炭@开采'" +
 				"when ~s表外明细@经营类型(新)e~ like '煤炭洗选' then 'A-煤炭@洗选' "+
 				"when ~s表外明细@经营类型(新)e~ like '焦碳—独立焦化' then 'B-焦碳@独立焦化' "+//焦碳—
 				"when ~s表外明细@经营类型(新)e~ like '焦碳—煤焦一体' or ~s表外明细@经营类型(新)e~ = '焦碳' then 'B-焦碳@煤焦一体' "+//焦碳—
 				"when ~s表外明细@经营类型(新)e~ like '焦碳—焦钢一体' then 'B-焦碳@焦钢一体' "+//焦碳—
 				"when ~s表外明细@经营类型(新)e~ like '焦碳—限期保留' then 'B-焦碳@限期保留' "+//焦碳—
 				"when ~s表外明细@经营类型(新)e~ like '焦碳—气源厂' then 'B-焦碳@气源厂' "+//焦碳—
 				"when ~s表外明细@经营类型(新)e~ like '焦碳—热回收' then 'B-焦碳@热回收' "+//焦碳—
 				"when ~s表外明细@经营类型(新)e~ like '批发零售%' then 'C-批发零售' "+//批发零售—
 				"when ~s表外明细@经营类型(新)e~ like '制造业—水泥' then 'D-制造业@水泥' "+//制造业—
 				"when ~s表外明细@经营类型(新)e~ like '制造业—平板玻璃' then 'D-制造业@平板玻璃' "+//制造业—
 				"when ~s表外明细@经营类型(新)e~ like '制造业%' then 'D-制造业@其他' "+//制造业—
 				"when ~s表外明细@经营类型(新)e~ like '钢铁' then 'E-钢铁' "+
 				"when ~s表外明细@经营类型(新)e~ like '房地产' then 'F-房地产' "+
 				"when ~s表外明细@经营类型(新)e~ like '化工化肥' then 'G-化工化肥' "+
	 			"when ~s表外明细@经营类型(新)e~ like '建筑施工' or ~s表外明细@经营类型(新)e~ like '工程建筑' or ~s表外明细@经营类型(新)e~ like '建筑工程' then 'H-建筑施工' "+
	 			"when ~s表外明细@经营类型(新)e~ like '铁矿开采' then 'I-铁矿开采' "+
	 			"when ~s表外明细@经营类型(新)e~ like '农林牧副渔' then 'J-农林牧副渔' "+
	 			"when ~s表外明细@经营类型(新)e~ like '政府平台' then 'K-政府平台' "+
				"when ~s表外明细@经营类型(新)e~ like '钢贸户' or ~s表外明细@经营类型(新)e~ like '%钢材销售%' then 'L-钢贸户' "+
				"when ~s表外明细@经营类型(新)e~ like '医药制造' then 'M-医药制造' "+
				"when ~s表外明细@经营类型(新)e~ like '燃气生产和供应' then 'N-燃气生产和供应' "+
				"when ~s表外明细@经营类型(新)e~ like '汽车维修及销售' then 'O-汽车维修及销售' "+
				"when ~s表外明细@经营类型(新)e~ like '电力' then 'P-电力' "+
				"when ~s表外明细@经营类型(新)e~ like '住宿餐饮' then 'Q-住宿餐饮' "+
	 			"when ~s表外明细@经营类型(新)e~ like '交通运输' then 'R-交通运输' "+
	 			"when ~s表外明细@经营类型(新)e~ like '医院学校' then 'S-医院学校' "+
	 			"when ~s表外明细@经营类型(新)e~ like '信息技术' then 'T-信息技术' "+
	 			"when ~s表外明细@经营类型(新)e~ like '文化娱乐' then 'U-文化娱乐' "+
	 			"else 'W-'||~s表外明细@经营类型(新)e~ end";
 		DataDuebillOutHandler.process(HandlerFlag,sConfigNo,sOneKey,Sqlca,"银行承兑汇票经营类型(新)",groupBy,"and nvl(~s表外明细@业务品种e~,'')='银行承兑汇票'");
 		
	 	//2、差额承兑按单一担保方式
 		groupBy="case when ~s表外明细@主要担保方式e~ like '保证-%' then '保证' "+
	 			"when ~s表外明细@主要担保方式e~ like '抵押-%' then '抵押' "+
	 			"when ~s表外明细@主要担保方式e~ = '信用' then '信用' "+
	 			"when ~s表外明细@主要担保方式e~ like '%质押-%' or ~s表外明细@主要担保方式e~='保证金' then '质押' "+
	 			"else '其他' end";
 		DataDuebillOutHandler.process(HandlerFlag,sConfigNo,sOneKey,Sqlca,"银行承兑汇票单一担保",groupBy,"and nvl(~s表外明细@业务品种e~,'')='银行承兑汇票' and not(nvl(~s表外明细@保证金比例(%)e~,0)=100 and (~s表外明细@主要担保方式e~ like '%本行存单' or ~s表外明细@主要担保方式e~ like '%保证金' or ~s表外明细@主要担保方式e~ like '%我行人民币存款%'))");
 		groupBy="case when ~s表外明细@企业规模e~ = '小型企业' or ~s表外明细@企业规模e~ = '微小型企业' then '0、小微型企业' "+
 				"when ~s表外明细@企业规模e~ = '中型企业' then '1、中型企业'"+
	 			"else '2、'||~s表外明细@企业规模e~ end";
 		DataDuebillOutHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"银行承兑汇票企业规模",groupBy,"and nvl(~s表外明细@业务品种e~,'')='银行承兑汇票' and not(nvl(~s表外明细@保证金比例(%)e~,0)=100 and (~s表外明细@主要担保方式e~ like '%本行存单' or ~s表外明细@主要担保方式e~ like '%保证金' or ~s表外明细@主要担保方式e~ like '%我行人民币存款%'))");
	 		 	
	 	groupBy="case  "+
	 			"when ~s表外明细@国家地区e~ like '%吕梁市%' then 'B-吕梁市' "+
	 			"when ~s表外明细@国家地区e~ like '%晋中市%' then 'C-晋中市' "+
	 			"when ~s表外明细@国家地区e~ like '%临汾市%' then 'D-临汾市' "+
	 			"when ~s表外明细@国家地区e~ like '%运城市%' then 'E-运城市' "+
	 			"when ~s表外明细@国家地区e~ like '%长治市%' then 'F-长治市' "+
	 			"when ~s表外明细@国家地区e~ like '%朔州市%' then 'G-朔州市' "+
	 			"when ~s表外明细@国家地区e~ like '%忻州市%' then 'H-忻州市' "+
	 			"when ~s表外明细@国家地区e~ like '%大同市%' then 'I-大同市' "+
	 			"when ~s表外明细@国家地区e~ like '%晋城市%' then 'J-晋城市' "+
	 			"when ~s表外明细@国家地区e~ like '%阳泉市%' then 'K-阳泉市' "+
	 			//"when ~s表外明细@国家地区e~ like '%石家庄市%' then '石家庄市' "+
	 			//"when ~s表外明细@国家地区e~ like '%武汉市%' then '武汉市' "+
	 			"when ~s表外明细@国家地区e~ like '%佛山市%' then 'L-佛山市' "+
	 			"else 'A-太原市' end";//剩下的默认都是太原市when ~s表外明细@国家地区e~ like '%太原市%' then '太原市'
	 	DataDuebillOutHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"银行承兑汇票地区",groupBy,"and nvl(~s表外明细@业务品种e~,'')='银行承兑汇票' and not(nvl(~s表外明细@保证金比例(%)e~,0)=100 and (~s表外明细@主要担保方式e~ like '%本行存单' or ~s表外明细@主要担保方式e~ like '%保证金' or ~s表外明细@主要担保方式e~ like '%我行人民币存款%'))");
	 	
	 	DataDuebillOutHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"银行承兑汇票机构","~s表外明细@直属行名称e~","and nvl(~s表外明细@业务品种e~,'')='银行承兑汇票' and not(nvl(~s表外明细@保证金比例(%)e~,0)=100 and (~s表外明细@主要担保方式e~ like '%本行存单' or ~s表外明细@主要担保方式e~ like '%保证金' or ~s表外明细@主要担保方式e~ like '%我行人民币存款%'))");
 		//单独完成一些复杂的操作
	 	DataDuebillOutHandler.afterProcess1(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	 	//4、加工后，进行合计，横向纵向分析
	 	DataDuebillOutHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	//对导入数据加工处理,插入到中间表Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
 		String sSql="";
		//2、 
 		//b、经营类型（新）设置一个基准日期，其他日期以这个日期为准， 更新到其他时间的之前的，随着业务不断变化，后期经营类型会不断变化，以一年调整一次还是就某个日期不变呢，这是个问题
 		//采取 2014/05以前的以2014/05为准，此后就当前为准保持不变
 		//原则报上的数据都不要再调整，只灵活调整当期
 		String AdjustDate="2014/05";//StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0);
 		if(1==1&&sKey.compareTo(AdjustDate)<0){
 			sSql="update Batch_Import_Interim BII set ~s表外明细@经营类型(新)e~="+
 					"(select ~s表外明细@经营类型(新)e~ from Batch_Import BI "+
 					"where BI.ConfigNo=BII.ConfigNo and BI.OneKey='"+AdjustDate+"' and BI.~s表外明细@借据流水号e~=BII.~s表外明细@借据流水号e~) "+
 			" where BII.ConfigNo='"+sConfigNo+"' and BII.OneKey='"+sKey+"'"+
 			" and exists(select 1 from Batch_Import BI1 where BI1.ConfigNo=BII.ConfigNo and BI1.OneKey='"+AdjustDate+"' and BI1.~s表外明细@借据流水号e~=BII.~s表外明细@借据流水号e~)";
 			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 			Sqlca.executeSQL(sSql);
 		}
		//a、经营类型（新）如果字段为空，更新 经营类型 内的值
 		sSql="update Batch_Import_Interim set ~s表外明细@经营类型(新)e~=~s表外明细@经营类型e~ where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and (nvl(~s表外明细@经营类型(新)e~,'')='' or ~s表外明细@经营类型(新)e~='其他' and nvl(~s表外明细@经营类型e~,'')<>'' and ~s表外明细@经营类型(新)e~<>~s表外明细@经营类型e~)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
		//c、以导入的客户信息为准更新经营类型(新)----导入日期永远以今天为准（这个其他种类还是太大，不是很准，暂时屏蔽吧）
		/*
		sSql="update Batch_Import_Interim BII set ~s表外明细@经营类型(新)e~="+
				"(select ~s客户明细@经营类型(新)e~ from Batch_Import_Interim BII1 "+
				"where BII1.ConfigName='客户明细' and BII1.OneKey='"+StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)+"' and BII1.~s客户明细@客户名称e~=BII.~s表外明细@客户名称e~) "+
		" where BII.ConfigNo='"+sConfigNo+"' and BII.OneKey='"+sKey+"'"+
		" and exists(select 1 from Batch_Import BII2 where BII2.ConfigName='客户明细' and BII2.OneKey='"+StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)+"' and BII2.~s客户明细@客户名称e~=BII.~s表外明细@客户名称e~)";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
		*/
 		//3、直属行名称 晋城、晋中、长治直属行名称，根据 管户人 名字后面的括号内的标志更新
 		sSql="update Batch_Import_Interim set ~s表外明细@直属行名称e~="+
 					"case when ~s表外明细@管户人e~ like '%晋城%' or ~s表外明细@管户人e~='段林虎' then '晋城分行' "+
 					"when ~s表外明细@管户人e~ like '%晋中%' then '晋中分行' "+
 					"when ~s表外明细@管户人e~ like '%长治%' then '长治分行' "+
 					"else ~s表外明细@直属行名称e~ end "+
 					"where ConfigNo='"+sConfigNo+"' "+
 					"and OneKey='"+sKey+"' "+
 					"and nvl(~s表外明细@管户人e~,'')<>''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql); 
 		//4、管户机构 为迎泽支行的直属行名称由 总行营业部 变为 龙城直属支行
 		sSql="update Batch_Import_Interim set ~s表外明细@直属行名称e~='龙城直属支行'"+
 					" where ConfigNo='"+sConfigNo+"' "+
 					" and OneKey='"+sKey+"' "+
 					" and nvl(~s表外明细@直属行名称e~,'')='总行营业部'"+
 					" and nvl(~s表外明细@管户机构e~,'')='总行营业部'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//4、直属行名称中带晋商银行的 如果 根据 管户机构 来更新
 		sSql="update Batch_Import_Interim set ~s表外明细@直属行名称e~=~s表外明细@管户机构e~"+
 					" where ConfigNo='"+sConfigNo+"' "+
 					" and OneKey='"+sKey+"' "+
 					" and nvl(~s表外明细@直属行名称e~,'')='晋商银行'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		sSql="update Batch_Import_Interim set ~s表外明细@企业规模e~='机关事业单位'"+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and nvl(~s表外明细@企业规模e~,'')=''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql); 
 		//7、统一更新币种到人民币，余额 金额做相应转化
 		sSql="update Batch_Import_Interim set ~s表外明细@币种e~='01',"+
			 		"~s表外明细@金额(元)e~=~s表外明细@金额(元)e~*nvl(getErate(~s表外明细@币种e~,'01',''),1),"+
			 		"~s表外明细@余额(元)e~=~s表外明细@余额(元)e~*nvl(getErate(~s表外明细@币种e~,'01',''),1) "+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and nvl(~s表外明细@币种e~,'')<>'01'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//8、如果是本行存单或保证金，保证金比例是0（当然敞口金额也是0）的承兑汇票的保证金比例变成100 风险敞口变为0
 		sSql="update Batch_Import_Interim set ~s表外明细@保证金比例(%)e~=100,~s表外明细@风险敞口e~=0"+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and (nvl(~s表外明细@主要担保方式e~,'') like '%保证金%' or nvl(~s表外明细@主要担保方式e~,'') like '%本行存单%' or nvl(~s表外明细@主要担保方式e~,'') like '%我行人民币存款%')"+
 					" and nvl(~s表外明细@保证金比例(%)e~,0)=0"+
 					" and nvl(~s表外明细@业务品种e~,'')='银行承兑汇票'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//9、如果是保证金比例不为100（当然敞口>0），主要担保方式为本行存单或保证金的承兑汇票的,结合合同明细，如果其中 “其他担保方式” 包含抵押，则主要担保方式变为抵押
 		sSql="update Batch_Import_Interim BII1 set " +
 					"~s表外明细@主要担保方式e~='抵押-' " +
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and (nvl(~s表外明细@主要担保方式e~,'') like '%保证金%' or nvl(~s表外明细@主要担保方式e~,'') like '%本行存单%' or nvl(~s表外明细@主要担保方式e~,'') like '%我行人民币存款%')"+
 					" and nvl(~s表外明细@保证金比例(%)e~,0)<>100"+
 					" and nvl(~s表外明细@业务品种e~,'')='银行承兑汇票'" +
 					" and exists(select 1 from Batch_Import_Interim BII2 " +
 					"			where BII2.ConfigName='合同明细'" +
 					"				and BII2.OneKey=BII1.OneKey" +
 					"				and BII2.~s合同明细@客户编号e~=BII1.~s表外明细@客户编号e~" +
 					"				and BII2.~s合同明细@业务品种e~=BII1.~s表外明细@业务品种e~" +
 					"				and BII2.~s合同明细@主要担保方式e~=BII1.~s表外明细@主要担保方式e~" +
 					"				and locate('抵押',BII2.~s合同明细@其他担保方式e~)>0)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//10、如果是保证金比例不为100（当然敞口>0），主要担保方式为本行存单或保证金的承兑汇票的,结合合同明细，如果其中 “其他担保方式” 包含保证，则主要担保方式变为保证
 		sSql="update Batch_Import_Interim BII1 set " +
					"~s表外明细@主要担保方式e~='保证-一般企业' " +
					" where ConfigNo='"+sConfigNo+"'"+
					" and OneKey='"+sKey+"'"+
					" and (nvl(~s表外明细@主要担保方式e~,'') like '%保证金%' or nvl(~s表外明细@主要担保方式e~,'') like '%本行存单%' or nvl(~s表外明细@主要担保方式e~,'') like '%我行人民币存款%')"+
					" and nvl(~s表外明细@保证金比例(%)e~,0)<>100"+
					" and nvl(~s表外明细@业务品种e~,'')='银行承兑汇票'" +
					" and exists(select 1 from Batch_Import_Interim BII2 " +
					"			where BII2.ConfigName='合同明细'" +
					"				and BII2.OneKey=BII1.OneKey" +
					"				and BII2.~s合同明细@客户编号e~=BII1.~s表外明细@客户编号e~" +
					"				and BII2.~s合同明细@业务品种e~=BII1.~s表外明细@业务品种e~" +
					"				and BII2.~s合同明细@主要担保方式e~=BII1.~s表外明细@主要担保方式e~" +
					"				and locate('保证',BII2.~s合同明细@其他担保方式e~)>0)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//11、主要担保方式为银行承兑汇票的,如果保证金比例为100，保证金比例变成0 风险敞口变为余额
 		sSql="update Batch_Import_Interim set ~s表外明细@保证金比例(%)e~=0,~s表外明细@风险敞口e~=~s表外明细@余额(元)e~"+
					" where ConfigNo='"+sConfigNo+"'"+
					" and OneKey='"+sKey+"'"+
					" and nvl(~s表外明细@主要担保方式e~,'') like '%银行承兑汇票%'"+
					" and nvl(~s表外明细@保证金比例(%)e~,0)=100"+
					" and nvl(~s表外明细@业务品种e~,'')='银行承兑汇票'";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
 		//12、核心存在未解付的215w，在此当成全额插入
 		sSql="insert into Batch_Import_Interim" +
 					"(ConfigNo,OneKey,~s表外明细@业务品种e~,~s表外明细@主要担保方式e~,~s表外明细@保证金比例(%)e~,~s表外明细@余额(元)e~,~s表外明细@经营类型(新)e~)" +
 					"values('"+sConfigNo+"','"+sKey+"','银行承兑汇票','质押-金融质押品-保证金-保证金',100,2150000,'煤炭开采')";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//13、2014年 主要担保方式 质押-金融质押品-票据-银行承兑汇票 以前为 质押-银行承兑汇票(4个月以下)、银行本票
 		//所以再次统一更新
 		sSql="update Batch_Import_Interim set ~s表外明细@主要担保方式e~='质押-金融质押品-票据-银行承兑汇票'"+
				" where ConfigNo='"+sConfigNo+"'"+
				" and OneKey='"+sKey+"'"+
				" and nvl(~s表外明细@主要担保方式e~,'') like '质押-银行承兑汇票%'"+
				" and nvl(~s表外明细@业务品种e~,'')='银行承兑汇票'";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
		//13、2014年 主要担保方式 质押-金融质押品-保证金-保证金 以前为 保证金
 		//所以再次统一更新
 		sSql="update Batch_Import_Interim set ~s表外明细@主要担保方式e~='质押-金融质押品-保证金-保证金'"+
				" where ConfigNo='"+sConfigNo+"'"+
				" and OneKey='"+sKey+"'"+
				" and nvl(~s表外明细@主要担保方式e~,'') like '%保证金%'"+
				" and nvl(~s表外明细@业务品种e~,'')='银行承兑汇票'";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
	}
	/**
	 * 按各个维度插入到处理表中
	 * @throws Exception 
	 * 
	 * groupBy 形式：QZ表示查询值加前缀 以QZXXQZ形式，如果是数字 写成QZNumberQZ然后放在字段之前，后缀根据需要以后再加
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
				"round(sum(case when ~s表外明细@借据起始日e~ like '"+sKey+"%' then ~s表外明细@金额(元)e~ end)/10000,2) as BusinessSum,"+//按月投放金额
				(isSeason==true?"round(sum(case when ~s表外明细@借据起始日e~ >= '"+startsmonth+"/01' and ~s表外明细@借据起始日e~ <= '"+sKey+"/31' then ~s表外明细@金额(元)e~ end)/10000,2)":"0")+","+//如果是季度末，计算按季投放金额,如果是半年末计算半年投放，整年....
				"round(case when sum(~s表外明细@金额(元)e~)<>0 then sum(~s表外明细@金额(元)e~*~s表外明细@执行年利率(%)e~)/sum(~s表外明细@金额(元)e~) else 0 end,2) as BusinessRate, "+//加权利率
				"round(sum(~s表外明细@余额(元)e~)/10000,2) as Balance, "+
				"round(sum(~s表外明细@风险敞口e~)/10000,2) as CKBalance, "+
				"count(distinct ~s表外明细@客户名称e~) "+
				"from Batch_Import_Interim "+
				" where ConfigNo='"+sConfigNo+"'" +
				" and OneKey='"+sKey+"'" +
				" and nvl(~s表外明细@余额(元)e~,0)>0 "+sWhere+
				" group by ConfigNo,OneKey"+groupColumnClause[1];
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,BusinessRate,Balance,CKBalance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
	}
	//因为SQL语句复杂 process无法通用完成，需要此处独立完成
	public static void afterProcess1(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		//差额全额里面插一条敞口余额
		String sSql=" select "+
				"HandlerFlag,ConfigNo,OneKey,Dimension,'银承敞口余额',CKBalance"+
				" from Batch_Import_Process " +
				" where HandlerFlag ='"+HandlerFlag+"'" +
				" and OneKey ='"+sKey+"'" +
				" and Dimension='差额全额银行承兑汇票'"+
				" and DimensionValue='银承@差额银承余额'";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,Balance)"+
 				"("+
 				sSql+
 				")");
	}
	//加入小计 合计 横向纵向比较值 小计总以 DimensionValue 中以@分割为标志
	public static void afterProcess(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		//1、插入各个维度的小计
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)||'@小计',"+
			"round(sum(BusinessSum),2)," +
			"round(sum(BusinessSumSeason),2)," +
			"round(sum(Balance),2)," +
			"round(sum(CKBalance),2)," +
			"sum(TotalTransaction) "+
			" from Batch_Import_Process "+
			" where HandlerFlag='"+HandlerFlag+"'" +
			" and ConfigNo='"+sConfigNo+"'" +
			" and OneKey ='"+sKey+"'" +
			" and locate('@',DimensionValue)>0 "+
			" group by HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,CKBalance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
		//2、插入各个维度的总计
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,'Z-总计@总计',"+
			"round(sum(BusinessSum),2)," +
			"round(sum(BusinessSumSeason),2)," +
			"round(sum(Balance),2)," +
			"round(sum(CKBalance),2)," +
			"sum(TotalTransaction) "+
			" from Batch_Import_Process "+
			" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('小计',DimensionValue)=0"+
			" group by HandlerFlag,ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,CKBalance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
 		//3、占比（总计，小计等汇总的值要靠四舍五入后的值一层层相加得到，不要以原始值相加，因为四舍五入会造成不准）更新
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
		 				"case when nvl(tab2.BusinessSum,0)<>0 then round(tab1.BusinessSum/tab2.BusinessSum*100,2) else 0 end as BusinessSumRatio,"+
		 				"case when nvl(tab2.BusinessSumSeason,0)<>0 then round(tab1.BusinessSumSeason/tab2.BusinessSumSeason*100,2) else 0 end as BusinessSumSeasonRatio,"+
		 				"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio, " +
		 				"case when nvl(tab2.CKBalance,0)<>0 then round(tab1.CKBalance/tab2.CKBalance*100,2) else 0 end as CKBalanceRatio " +
		 				"from "+
							"(select Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance,CKBalance "+
								"from Batch_Import_Process "+
								"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
							")tab1,"+
							"(select Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance,CKBalance "+	
								"from Batch_Import_Process "+
								"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('总计',DimensionValue)>0"+
							")tab2"+
					" where tab1.Dimension=tab2.Dimension)tab3"+
				" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BusinessSumRatio,BusinessSumSeasonRatio,BalanceRatio,CKBalanceRatio)="+
 				"(select tab3.BusinessSumRatio,tab3.BusinessSumSeasonRatio,tab3.BalanceRatio,tab3.CKBalanceRatio "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 "+sSql+")"
 				);
 		//4、相对前一年度增加值和幅度更新
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
		 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
		 				"(nvl(tab1.CKBalance,0)-nvl(tab2.CKBalance,0)) as CKBalanceTLY,"+
		 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
		 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY,"+
		 				"(nvl(tab1.BalanceRatio,0)-nvl(tab2.BalanceRatio,0)) as BalanceRatioTLY,"+
		 				"case when nvl(tab2.CKBalance,0)<>0 then cast(round((nvl(tab1.CKBalance,0)/nvl(tab2.CKBalance,0)-1)*100,2) as numeric(24,6)) else 0 end as CKBalanceRangeTLY,"+
		 				"(nvl(tab1.CKBalanceRatio,0)-nvl(tab2.CKBalanceRatio,0)) as CKBalanceRatioTLY"+
		 				" from "+
							"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio,CKBalance,CKBalanceRatio "+
								"from Batch_Import_Process "+
								"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
							")tab1,"+
							"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio,CKBalance,CKBalanceRatio "+	
							"from Batch_Import_Process "+
								"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
							")tab2"+
					" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
			" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";	
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BalanceTLY,CKBalanceTLY,BusinessRateTLY,BalanceRangeTLY,BalanceRatioTLY,CKBalanceRangeTLY,CKBalanceRatioTLY)="+
 				"(select tab3.BalanceTLY,tab3.CKBalanceTLY,tab3.BusinessRateTLY,tab3.BalanceRangeTLY,tab3.BalanceRatioTLY,tab3.CKBalanceRangeTLY,tab3.CKBalanceRatioTLY "+
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
		 	 				"(nvl(tab1.CKBalance,0)-nvl(tab2.CKBalance,0)) as CKBalanceTLY,"+
		 	 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
		 	 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY," +
		 	 				"(nvl(tab1.BalanceRatio,0)-nvl(tab2.BalanceRatio,0)) as BalanceRatioTLY,"+
		 	 				"case when nvl(tab2.CKBalance,0)<>0 then cast(round((nvl(tab1.CKBalance,0)/nvl(tab2.CKBalance,0)-1)*100,2) as numeric(24,6)) else 0 end as CKBalanceRangeTLY,"+
			 				"(nvl(tab1.CKBalanceRatio,0)-nvl(tab2.CKBalanceRatio,0)) as CKBalanceRatioTLY"+
		 	 				" from "+
		 				"(select OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio,CKBalance,CKBalanceRatio "+
		 					"from Batch_Import_Process "+
		 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
		 				")tab1,"+
		 				"(select OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio,CKBalance,CKBalanceRatio "+	
		 				"from Batch_Import_Process "+
		 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
		 				")tab2"+
		 				" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
 				" where tab.OneKey=tab3.OneKey and tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";	
 	 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 	 				"set(BalanceTLY,CKBalanceTLY,BusinessRateTLY,BalanceRangeTLY,BalanceRatioTLY,CKBalanceRangeTLY,CKBalanceRatioTLY)="+
 	 				"(select tab3.BalanceTLY,tab3.CKBalanceTLY,tab3.BusinessRateTLY,tab3.BalanceRangeTLY,tab3.BalanceRatioTLY,tab3.CKBalanceRangeTLY,tab3.CKBalanceRatioTLY "+
 	 				sSql+
 	 				")"+
 	 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 	 				" and exists(select 1 "+sSql+")"
 	 				);
 		}
	}
}