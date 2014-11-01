package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.Import.base.EntranceImpl;
import com.lmt.baseapp.Import.base.ExcelBigEntrance;
import com.lmt.baseapp.Import.base.ExcelEntrance;
import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.sql.Transaction;
public class AIHandlerFactory{
	public static void beforeHandle(String sFiles,String sFileType,String HandlerFlag,String sConfigNo,String sOneKey,ASUser CurUser,Transaction Sqlca)throws Exception{
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
		//清空目标表 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	}
	public static void handle(String sFiles,String sFileType,String HandlerFlag,String sConfigNo,String sOneKey,ASUser CurUser,Transaction Sqlca) throws Exception{
		//先导入到数据库,并清空目标表，为数据处理做准备
		AIHandlerFactory.beforeHandle(sFiles, sFileType,HandlerFlag, sConfigNo, sOneKey, CurUser, Sqlca);
		//对数据进行初步加工
		if("Customer".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.customerHandle(sConfigNo, sOneKey, Sqlca);
		}else if("Contract".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.contractHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("Duebill".toUpperCase().equals(HandlerFlag)){
			AIDuebillInHandler.dueBillInHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("DuebillOut".toUpperCase().equals(HandlerFlag)){
			AIDuebillOutHandler.dueBillOutHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
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
		/*
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
	 	AIOperationReportHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	 	//4、加工后，进行合计，横向纵向分析
	 	AIOperationReportHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
}