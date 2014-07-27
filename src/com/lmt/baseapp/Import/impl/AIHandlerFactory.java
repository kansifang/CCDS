package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.Import.base.EntranceImpl;
import com.lmt.baseapp.Import.base.ExcelBigEntrance;
import com.lmt.baseapp.Import.base.ExcelEntrance;
import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.sql.Transaction;
public class AIHandlerFactory{
	public static void beforeHandle(String sFiles,String sFileType,String Handler,String sConfigNo,String sOneKey,ASUser CurUser,Transaction Sqlca)throws Exception{
		if("01".equals(sFileType)){//小型excel
			//导入文件到原始表，始终保持原滋原味
	 		Sqlca.executeSQL("Delete from Batch_Import where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		 	EntranceImpl efih=new ExcelEntrance(sFiles,"Batch_Import",CurUser,Sqlca);
		 	efih.action(sConfigNo,sOneKey);
			//再导入到中间表，可以进行加工
		 	Sqlca.executeSQL("Delete from Batch_Import_Interim where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		 	EntranceImpl efih_Iterim=new ExcelEntrance(sFiles,"Batch_Import_Interim",CurUser,Sqlca);
		 	efih_Iterim.action(sConfigNo,sOneKey);
		}else if("03".equals(sFileType)){//大型Excel
			//导入文件到原始表，始终保持原滋原味
	 		Sqlca.executeSQL("Delete from Batch_Import where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		 	EntranceImpl efih=new ExcelBigEntrance(sFiles,"Batch_Import",CurUser,Sqlca);
		 	efih.action(sConfigNo,sOneKey);
			//再导入到中间表，可以进行加工
		 	Sqlca.executeSQL("Delete from Batch_Import_Interim where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		 	EntranceImpl efih_Iterim=new ExcelBigEntrance(sFiles,"Batch_Import_Interim",CurUser,Sqlca);
		 	efih_Iterim.action(sConfigNo,sOneKey);
		}
			 	//更新配置号和报表日期
 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and ImportNo like 'N%000000'");
	}
	public static void handle(String sFiles,String sFileType,String HandlerFlag,String sConfigNo,String sOneKey,ASUser CurUser,Transaction Sqlca) throws Exception{
		//先导入到数据库
		AIHandlerFactory.beforeHandle(sFiles, sFileType,HandlerFlag, sConfigNo, sOneKey, CurUser, Sqlca);
		//对数据进行初步加工
		if("Customer".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.customerHandle(sConfigNo, sOneKey, Sqlca);
		}else if("Contract".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.contractHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("Duebill".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.dueBillHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("DuebillR".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.dueBillRHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("OperationReport".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.operationReportHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}
	}
	/**
	 * 客户信息导入后处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void customerHandle(String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1、对中间表数据进行特殊处理 	 		 	
		AICustomerHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//先清空目标表 
		/*Sqlca.executeSQL("Delete from Batch_Import_Process where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	 	String groupBy="case when ~s合同明细@其他担保方式e~ like '%保证%' and ~s合同明细@其他担保方式e~ like '%软抵押%' then '保证+软抵押' "+
	 			"when ~s合同明细@其他担保方式e~ like '%保证%' and ~s合同明细@其他担保方式e~ like '%抵押%' and ~s合同明细@其他担保方式e~ like '%质押%' then '保证+抵质押' "+
	 			"when ~s合同明细@其他担保方式e~ = '保证' then '单一保证' "+
	 			"when ~s合同明细@其他担保方式e~ like '%信用%' and ~s合同明细@其他担保方式e~ like '%软抵押%' then '信用+软抵押' "+
	 			"when ~s合同明细@其他担保方式e~ = '信用' then '单一信用' "+
	 			"when ~s合同明细@其他担保方式e~ = '抵押' then '单一抵押' "+
	 			"when ~s合同明细@其他担保方式e~ = '质押' then '单一质押' "+
	 			"when ~s合同明细@其他担保方式e~ like '%抵押%' and ~s合同明细@其他担保方式e~ like '%质押%' then '抵押+质押' "+
	 			"else '其他担保' end";
	 	AfterImportCustomerHandler.process(sConfigNo, sOneKey, Sqlca,"混合担保方式",groupBy);
	 	//4、加工后，进行合计，横向纵向分析
	 	AfterImportCustomerHandler.afterProcess(sConfigNo, sOneKey, Sqlca);
	 	*/
	}
	/**
	 * 合同导入后处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void contractHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1、对中间表数据进行特殊处理 	 		 	
		AIContractHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//先清空目标表 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	 	String groupBy="case when ~s合同明细@其他担保方式e~ like '%保证%' and ~s合同明细@其他担保方式e~ like '%软抵押%' then '保证+软抵押' "+
	 			"when ~s合同明细@其他担保方式e~ like '%保证%' and ~s合同明细@其他担保方式e~ like '%抵押%' and ~s合同明细@其他担保方式e~ like '%质押%' then '保证+抵质押' "+
	 			"when ~s合同明细@其他担保方式e~ = '保证' then '单一保证' "+
	 			"when ~s合同明细@其他担保方式e~ like '%信用%' and ~s合同明细@其他担保方式e~ like '%软抵押%' then '信用+软抵押' "+
	 			"when ~s合同明细@其他担保方式e~ = '信用' then '单一信用' "+
	 			"when ~s合同明细@其他担保方式e~ = '抵押' then '单一抵押' "+
	 			"when ~s合同明细@其他担保方式e~ = '质押' then '单一质押' "+
	 			"when ~s合同明细@其他担保方式e~ like '%抵押%' and ~s合同明细@其他担保方式e~ like '%质押%' then '抵押+质押' "+
	 			"else '其他担保' end";
	 	AIContractHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"混合担保方式",groupBy);
	 	//4、加工后，进行合计，横向纵向分析
	 	AIContractHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	/**
	 * 借据导入后处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void dueBillHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1、对中间表数据进行特殊处理 	 		 	
		AIDuebillHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//清空目标表 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		
		AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"归属条线","~s借据明细@归属条线e~","");
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
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"经营类型(新)",groupBy,"");
	 	
	 	groupBy="case when case when ~s借据明细@期限日e~>0 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=6  then '1M6]' "+
	 						"when case when ~s借据明细@期限日e~>1 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=12 then '2M(6-12]' "+//常常有12个月零1天那种，先处理为12个月吧，遗留数据有几笔（00000231001，00000230881，00000231541，00000253001）
	 						"when case when ~s借据明细@期限日e~>0 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=36 then '3M(12-36]' "+
	 						"when case when ~s借据明细@期限日e~>0 then (~s借据明细@期限月e~+1) else ~s借据明细@期限月e~ end <=60 then '4M(36-60]' "+
	 						"else '5M(60' end,~s借据明细@业务品种e~";
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"期限业务品种",groupBy,"");
	 	
	 	groupBy="case when ~s借据明细@主要担保方式e~ like '保证-%' then '保证' "+
	 			"when ~s借据明细@主要担保方式e~ like '抵押-%' then '抵押' "+
	 			"when ~s借据明细@主要担保方式e~ = '信用' then '信用' "+
	 			"when ~s借据明细@主要担保方式e~ like '%质押-%' or ~s借据明细@主要担保方式e~='保证金' then '质押' "+
	 			"else '其他' end";
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"单一担保方式",groupBy,"");
	 	//groupBy="case when case when ~s借据明细@主要担保方式e~='软抵押'  then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=6 end then 六个月以下 "+
			//		"when case when ~s借据明细@期限日e~>0 then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=12 end then 十二个月以下"+
			//		"when case when ~s借据明细@期限日e~>0 then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=36 end then 三十六个月以下"+
			//		"when case when ~s借据明细@期限日e~>0 then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=60 end then 六十个月以下"+
			//		"else case when ~s借据明细@期限日e~>0 then ~s借据明细@期限月e~+1 else ~s借据明细@期限月e~<=6 end then 六十个月以上 end,~s借据明细@业务品种e~";
	 	//AfterImport.process(sConfigNo, sOneKey, Sqlca,"混合担保方式",groupBy);
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"企业规模","~s借据明细@企业规模e~","");
	 	
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"业务品种","~s借据明细@业务品种e~","");
	 	
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
	 			"when ~s借据明细@国家地区e~ like '%佛山市%' then 'L-佛山市' "+
	 			"else 'A-太原市' end";//剩下的默认都是太原市when ~s借据明细@国家地区e~ like '%太原市%' then '太原市'
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"地区分类",groupBy,"");
	 	
	 	AIDuebillHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"机构分类","~s借据明细@直属行名称e~","");
	 	
	 	//单独完成一些复杂的操作
	 	AIDuebillHandler.afterProcess1(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	 	//4、加工后，进行合计，横向纵向分析
	 	AIDuebillHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	/**
	 * 零售借据导入后处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void dueBillRHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1、对中间表数据进行特殊处理 	 		 	
		AIDuebillRetailHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//清空目标表 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
 		String groupBy="case "+
		 				" when ~s个人明细@归属条线e~ ='个人条线' or ~s个人明细@归属条线e~ = '微小条线' or ~s个人明细@归属条线e~ = '零售条线' then '零售条线'"+
		 				" when ~s个人明细@归属条线e~ = '小企业条线' then '小企业条线' "+
		 				" else '其他条线' end";
 		AIDuebillRetailHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"归属条线",groupBy,"and (~s个人明细@业务品种e~<>'个人委托贷款' and ~s个人明细@业务品种e~<>'个人住房公积金贷款')");
	 	//4、加工后，进行合计，横向纵向分析
 		AIDuebillRetailHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	/**
	 * 月度经营报告处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void operationReportHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1、对中间表数据进行特殊处理 	 		 	
		AIOperationReportHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//先清空目标表 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	 	AIOperationReportHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	 	//4、加工后，进行合计，横向纵向分析
	 	AIOperationReportHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
}