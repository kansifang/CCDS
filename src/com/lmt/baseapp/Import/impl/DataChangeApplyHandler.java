package com.lmt.baseapp.Import.impl;

import java.sql.SQLException;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class DataChangeApplyHandler{
	public static void beforeHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca)throws Exception{
		//更新配置号和报表日期
 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and ImportNo like 'N%000000'");
		//清空目标表 
		//Sqlca.executeSQL("Delete from Batch_Case where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	}
	/**
	 * 月度经营报告处理
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public static void handle(String sBatchNo,String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//先导入到数据库,并清空目标表，为数据处理做准备
		DataChangeApplyHandler.beforeHandle(HandlerFlag, sConfigNo, sOneKey, Sqlca);
		//1、对中间表数据进行特殊处理 	 		 	
		DataChangeApplyHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
	 	DataChangeApplyHandler.process(sBatchNo,HandlerFlag,sConfigNo, sOneKey, Sqlca);
	 	//4、加工后，进行合计，横向纵向分析
	 	//DataChangeApplyHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	//对导入数据加工处理,插入到中间表Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
		//String sSql="";
 		//1、清除掉项目名为空，类似“版本号:1410 蓝色底为含公式区域  灰色底为不填数部分”的内容 
		//sSql="delete from Batch_Import_Interim "+
		//			"where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' "+
		//			"and (nvl(~s"+sConfigNo+"@项目e~,'')='' or ~s"+sConfigNo+"@项目e~ like '版本号:%' or ~s"+sConfigNo+"@项目e~ like '%色底为%' or ~s"+sConfigNo+"@项目e~ like '附：%')";
 		//sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		//Sqlca.executeSQL(sSql);
	}
	/**
	 * 按各个维度插入到处理表中
	 * @throws Exception 
	 */
	public static void process(String sBatchNo,String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String columnS_I="",columnT_I="",columnS_U="",columnT_U="",table="",keyColumnS="",keyColumnT="";
		ASResultSet rs=Sqlca.getASResultSet("select ItemDescribe,InputUser,InputTime,Attribute3,BankNo from Code_Library where CodeNo='"+sConfigNo+"' and IsInUse='1'");
		while(rs.next()){
			String sourceColumn=rs.getString(1);
			String targetColumn=rs.getString(3);
			if("1".equals(rs.getString(4))){//是否主键
				table=rs.getString(2);
				keyColumnS=sourceColumn;
				keyColumnT=targetColumn;
			}
			if("1".equals(rs.getString(5))){//是否可更新字段
				columnS_U+=sourceColumn+",";
				columnT_U+=targetColumn+",";
			}
			columnS_I+=sourceColumn+",";
			columnT_I+=targetColumn+",";
		}
		rs.getStatement().close();
		columnS_I =columnS_I.substring(0, columnS_I.length()-1);
		columnT_I =columnT_I.substring(0, columnT_I.length()-1);
		columnS_U =columnS_U.substring(0, columnS_U.length()-1);
		columnT_U =columnT_U.substring(0, columnT_U.length()-1);
		String sChangeNoS="";
		String sSql="select "+keyColumnS+" from  Batch_Import_Interim "+
					" where ConfigNo='"+sConfigNo+"'" +
					" and OneKey='"+sKey+"'"+
					" and ImportNo like 'N%000000'"+
					" and nvl("+keyColumnS+",'')<>''"+
					" group by "+keyColumnS+" having count(1)>1";
		rs=Sqlca.getASResultSet(sSql);
		while(rs.next()){
			sChangeNoS+=rs.getString(1)+"，";
		}
		rs.getStatement().close();
		if(sChangeNoS.length()>0){
			throw new Exception("文件中存在变更号【"+sChangeNoS.substring(0, sChangeNoS.length()-1)+"】重复的记录"); 
		}
		sSql="update "+table+" tab1 "+
 				"set("+columnT_U+")="+
 				"(select "+columnS_U+" from Batch_Import_Interim tab2"+
 				" where tab2.ConfigNo='"+sConfigNo+"'" +
				" and tab2.OneKey='"+sKey+"'"+
				" and tab2."+keyColumnS+"=tab1."+keyColumnT+
				" and tab2.ImportNo like 'N%000000'"+
				")"+
				" where exists(select 1 from Batch_Import_Interim tab3 " +
					" where tab3.ConfigNo='"+sConfigNo+"'" +
					" and tab3.OneKey='"+sKey+"'"+
					" and tab3."+keyColumnS+"=tab1."+keyColumnT+"" +
					" and tab3.ImportNo like 'N%000000'"+
					")"
				;
		Sqlca.executeSQL(sSql);
		sSql="insert into "+table+
				" (BatchNo,"+columnT_I+")" +
				" (select '"+sBatchNo+"',"+columnS_I+" " +
				" from Batch_Import_Interim " +
				" where ConfigNo='"+sConfigNo+"'" +
				" and OneKey='"+sKey+"'"+
				" and ImportNo like 'N%000000'"+
				" and not exists(select 1 from "+table+" where nvl("+keyColumnS+",'')="+keyColumnT+")"+
				")";
		Sqlca.executeSQL(sSql);
	}
}