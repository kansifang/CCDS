/*
		Author: --bllou 2011-02-26
		Tester:
		Describe: --对存在的数据进行相关操作
 */
package com.amarsoft.datainit.importobj;

import java.sql.PreparedStatement;
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;

public class CopyInfoUtil {
	// 下面三个方法推荐级别是主机下降的，推荐下面的获取目标表和源表对应字段关系，形成insert into purposeTable(purColumn1,purColumn2) (select sourColumn1,sourColumn2)
	//这样的sql语句一下子搞定效率会比较高
	//
	// 第三个把源结果集传进来，然后通过循环复制表，所以结果集指针处于初始状态，效率是比较低的，而且sql语句不能重复使用
	// 第二个是循环在外面，传进来的只是源结果集指针指向某一条记录，就是使用PreparedStatement，效率较第三个是比较高的，但循环仍在JAVA中，相比第一个较低
	/*****
	 * 可以直接形成sql让数据库处理去
	 */
	public static String[] getElementsInfoForCopy(String sSourceSelectClause,String sPurposeSelectClause, String sPurposePrimaryKey,String sPurposeColumnExcept,
			HashMap<String, String> mPurposeColToSourceCol,HashMap<String, String> mColumnSetValuePurpose, Transaction Sqlca)throws Exception {
		mColumnSetValuePurpose = CopyInfoUtil.toUpperCaseForMap(mColumnSetValuePurpose);
		String[] sPVVS =null;
		String sInsertColumns="";
		String sInsertValues="";
		String sUpdate="";
		
		String sRealSourceSelectClause=StringFunction.getXProfileString(sSourceSelectClause, "(", ")");
		String sSourceTableAlias=StringFunction.getSeparate(sSourceSelectClause, ")", 2);
		String sRealPurposeSelectClause=StringFunction.getXProfileString(sPurposeSelectClause, "(", ")");
		String sPurposeTableAlias=StringFunction.getSeparate(sPurposeSelectClause, ")", 2);
		
		ASResultSet rsSource = Sqlca.getASResultSet(sRealSourceSelectClause);
		ASResultSet rsPurpose = Sqlca.getASResultSet(sRealPurposeSelectClause);
		if(rsSource.next()){
			sPVVS = CopyInfoUtil.getElementsInfoForCopy(rsSource,rsPurpose, sPurposePrimaryKey, sPurposeColumnExcept,mPurposeColToSourceCol,mColumnSetValuePurpose);
			String[] sColumns=sPVVS[0].split(",");
			String[] sSourceColumns=sPVVS[3].split(",");
			for(int i=0;i<sColumns.length;i++){
				sInsertColumns+=sPurposeTableAlias+"."+sColumns[i]+",";
				sUpdate+=sPurposeTableAlias+"."+sColumns[i]+"=";
				if(mColumnSetValuePurpose!=null&&mColumnSetValuePurpose.containsKey(sColumns[i])){
					sInsertValues+=sSourceColumns[i]+",";
					sUpdate+=sSourceColumns[i]+",";
				}else{
					sInsertValues+=sSourceTableAlias+"."+sSourceColumns[i]+",";
					sUpdate+=sSourceTableAlias+"."+sSourceColumns[i]+",";
				}
			}
			sInsertColumns=sInsertColumns.substring(0,sInsertColumns.length()-1);
			sInsertValues=sInsertValues.substring(0,sInsertValues.length()-1);
			sUpdate=sUpdate.substring(0,sUpdate.length()-1);
			return new String[] { sInsertColumns,sInsertValues, sUpdate};
		}
		rsSource.getStatement().close();
		rsPurpose.getStatement().close();
		return null;
	}
	/**
	 * 
	 * 获取表复制的sql要素信息
	 * 
	 * @param rsSource
	 * @param rsPurpose
	 * @param sPurposePrimaryKey
	 * @param mPurposeColToSourceCol
	 * @param mColumnSetValuePurpose
	 * @return 形式如："purposecolumn1,purposecolumn2" "?,?" "value1,value2"
	 *         "sourcecolumn1,sourcecolumn2" "primaryvalue1,primaryvalue2"
	 * @throws Exception
	 */
	public static String[] getElementsInfoForCopy(Object rsSource,
			ASResultSet rsPurpose, String sPurposePrimaryKey,String sPurposeColumnExcept,
			HashMap<String, String> mPurposeColToSourceCol,
			HashMap<String, String> mColumnSetValuePurpose) throws Exception {
		mPurposeColToSourceCol = CopyInfoUtil.toUpperCaseForMap(mPurposeColToSourceCol);
		mColumnSetValuePurpose = CopyInfoUtil.toUpperCaseForMap(mColumnSetValuePurpose);
		String sColumnsPurpose = "";
		String sValuesForPS = "";// 生成preparedStatement的?
		String sValues = "";
		String sColumnsSource = "";// insert语句中的select字段
		String sPrimaryColumns = "";// 主键字段
		String sPrimaryValuesForPS = "";// 生成preparedStatement的?
		String sPrimaryValues = "";// insert语句中的select字段
		int columnCountPurpose = rsPurpose.getColumnCount();
		// 用查询出来的相应的值填充
		AA:
		for (int j = 1; j <= columnCountPurpose; j++) {
			String sColumnPurpose = rsPurpose.getColumnName(j);
			int iFieldType = rsPurpose.getColumnType(j);
			String sValue = "", sColumnSource = "";
			// 源字段和目标字段是否有对应关系
			if(mColumnSetValuePurpose != null&& mColumnSetValuePurpose.containsKey(sColumnPurpose)) {
				sValue = mColumnSetValuePurpose.get(sColumnPurpose);
				sColumnSource = CopyInfoUtil.getColumnValueForSql(iFieldType,sValue);
			}else if(mPurposeColToSourceCol != null&& mPurposeColToSourceCol.containsKey(sColumnPurpose)) {
				sColumnSource = mPurposeColToSourceCol.get(sColumnPurpose);
				sValue = rsSource instanceof ASResultSet?((ASResultSet)rsSource).getString(sColumnSource):((ObjResultSet) rsSource).getCode(sColumnSource);
				//直接以源字段作为目标字段是否有对应关系
			}else if((rsSource instanceof ASResultSet?((ASResultSet)rsSource).getColumnIndex(sColumnPurpose):((ObjResultSet) rsSource).getColumnIndex(sColumnPurpose))>0){
				sValue = rsSource instanceof ASResultSet?((ASResultSet)rsSource).getString(sColumnPurpose):((ObjResultSet)rsSource).getCode(sColumnPurpose);
				sColumnSource = sColumnPurpose;
			}else{
				continue;
			}
			//主键设置
			if(sPurposePrimaryKey!=null&&sPurposePrimaryKey.length()>0){
				for(String sTemp:sPurposePrimaryKey.split(",")){
					if(sColumnPurpose.equals(sTemp.toUpperCase())){
						sPrimaryColumns+=sColumnPurpose+",";
						sPrimaryValuesForPS += "?,";
						sPrimaryValues += CopyInfoUtil.getColumnValueForSql(iFieldType,sValue)+ ",";
					}
				}
			}
			if(sPurposeColumnExcept!=null&&sPurposeColumnExcept.length()>0){
				for(String sTemp:sPurposeColumnExcept.split(",")){
					if(sColumnPurpose.equals(sTemp.toUpperCase())){
						continue AA;
					}
				}
			}
			sColumnsPurpose += sColumnPurpose + ",";
			sValuesForPS += "?,";
			sValues += CopyInfoUtil.getColumnValueForSql(iFieldType, sValue)+ ",";
			sColumnsSource += sColumnSource + ",";
		}
		sColumnsPurpose = sColumnsPurpose.substring(0,sColumnsPurpose.length() - 1); // 截取字段中多余的","
		sValuesForPS = sValuesForPS.substring(0, sValuesForPS.length() - 1); // 截取sValues中多余的","
		sValues = sValues.substring(0, sValues.length() - 1); // 截取sValues中多余的","
		sColumnsSource = sColumnsSource.substring(0,sColumnsSource.length() - 1); // 截取sValues中多余的","
		if (!"".equals(sPrimaryValuesForPS)) {
			sPrimaryColumns = sPrimaryColumns.substring(0, sPrimaryColumns.length() - 1); // 截取sValues中多余的","
			sPrimaryValuesForPS = sPrimaryValuesForPS.substring(0,sPrimaryValuesForPS.length() - 1); // 截取sValues中多余的","
			sPrimaryValues = sPrimaryValues.substring(0, sPrimaryValues.length() - 1); // 截取sValues中多余的","
		}
		//System.out.println("insert into Business_PutOut_Import("+sColumnsPurpose+") values("+sValues+")");
		return new String[] { sColumnsPurpose, sValuesForPS, sValues,
				sColumnsSource,sPrimaryColumns,sPrimaryValuesForPS, sPrimaryValues };
	}
	/**
	 * preparedstatement
	 * 
	 * @param rsSource
	 * @param rsPurpose
	 * @param mPurposeColToSourceCol
	 * @param mColumnSetValuePurpose
	 * @param Sqlca
	 * @param ps
	 * @return
	 * @throws Exception
	 */
	public static PreparedStatement copyInfo(String iActionContent,Object ASResultSetOrobjResultSet, String PurposeSelectClause,
			String sPurposePrimaryKey,String sPurposeColumnExcept,
			HashMap<String, String> mPurposeColToSourceCol,
			HashMap<String, String> mColumnSetValuePurpose, Transaction Sqlca,
			PreparedStatement ps) throws Exception {
		if(iActionContent==null){
			return null;
		}
		mPurposeColToSourceCol = CopyInfoUtil.toUpperCaseForMap(mPurposeColToSourceCol);
		mColumnSetValuePurpose = CopyInfoUtil.toUpperCaseForMap(mColumnSetValuePurpose);
		String PurposeTableName = CopyInfoUtil.getTableName(PurposeSelectClause);
		if ("".equals(PurposeTableName)) {
			return null;
		}
		String sSql = "";
		String[] sPVVS = null;
		ASResultSet rsPurpose = Sqlca.getASResultSet(PurposeSelectClause);
		if (ASResultSetOrobjResultSet instanceof ASResultSet) {
			sPVVS = CopyInfoUtil.getElementsInfoForCopy((ASResultSet) ASResultSetOrobjResultSet, rsPurpose, sPurposePrimaryKey,sPurposeColumnExcept,mPurposeColToSourceCol, mColumnSetValuePurpose);
		} else if (ASResultSetOrobjResultSet instanceof ObjResultSet) {
			sPVVS = CopyInfoUtil.getElementsInfoForCopy((ObjResultSet) ASResultSetOrobjResultSet, rsPurpose, sPurposePrimaryKey,sPurposeColumnExcept,mPurposeColToSourceCol, mColumnSetValuePurpose);
		}
		rsPurpose.getStatement().close();
		int newPurposeCount=0;
		if(iActionContent.toUpperCase().startsWith("INSERT")||iActionContent.toUpperCase().startsWith("UPDATE")){
			if("".equals(sPVVS[0])){
				return null;
			}
			newPurposeCount=sPVVS[0].split(",").length;
		}else if(iActionContent.toUpperCase().startsWith("DELETE")){
			if("".equals(sPVVS[4])){
				return null;
			}
			newPurposeCount=sPVVS[4].split(",").length;
		}
		if(ps!=null&&ps.getParameterMetaData().getParameterCount()!=newPurposeCount){
			ps.executeBatch();
			ps.close();
			ps=null;
		}
		if(ps==null) {//当ps为null 或ps语句数量有变化时要重新生成ps
			if(iActionContent.toUpperCase().startsWith("INSERT")) {
				sSql = "insert into " + PurposeTableName + "(" + sPVVS[0]+ ") values(" + sPVVS[1] + ")";
			}else if(iActionContent.toUpperCase().startsWith("UPDATE")) {
				sSql = "update " + PurposeTableName + " set ("+sPVVS[0]+") =(select " + sPVVS[1] + " from dual) where ("+ sPVVS[4]+")=(select " + sPVVS[5]+" from dual)";
			}else if(iActionContent.toUpperCase().startsWith("DELETE")) {
			sSql = "delete from " + PurposeTableName + " where ("+sPVVS[4]+")=(select "+sPVVS[5]+" from dual)";
			}
			ps = Sqlca.conn.prepareStatement(sSql);
		}
		String[] values = sPVVS[2].split(",");
		int iCount = 1;
		for (String value : values) {
			ps.setString(iCount++, value.replaceAll("'", ""));// 现在只能都设置成String形式，以后可以根据数据类型达到具体配置(oracle支持自动转型)
		}
		if (!"".equals(sPVVS[6])) {
			String[] primaryValues = sPVVS[6].split(",");
			for (String primaryValue : primaryValues) {
				ps.setString(iCount++, primaryValue.replaceAll("'", ""));// 现在只能都设置成String形式，以后可以根据数据类型达到具体配置(oracle支持自动转型)
			}
		}
		//System.out.println(sSql);
		return ps;
	}

	/**statement
	 * 
	 * @param actionFlag 1 不检查是否存在直接插入 2 存在记录就更新  3 删除存在记录再插入 4不作任何操作
	 * @param sSourceSelectClause
	 * @param sPurposeSelectClause
	 * @param sPurposePrimaryKey
	 * @param mPurposeColToSourceCol
	 * @param mColumnSetValuePurpose
	 * @param Sqlca
	 * @throws Exception
	 */
	public static void copyInfo(int actionFlag, Object sSourceOrObjResultSet,
			String PurposeSelectClause, String sPurposePrimaryKey,String sPurposeColumnExcept,
			HashMap<String, String> mPurposeColToSourceCol,
			HashMap<String, String> mColumnSetValuePurpose, Transaction Sqlca)
			throws Exception {
		String sSql = "";
		String PurposeTableName = CopyInfoUtil.getTableName(PurposeSelectClause);
		ASResultSet rsPurpose = Sqlca.getASResultSet(PurposeSelectClause);
		Object rsSource = null;
		String[] sPVVS = null;
		if (sSourceOrObjResultSet instanceof String) {
			rsSource = Sqlca.getASResultSet((String) sSourceOrObjResultSet);
		}else if (sSourceOrObjResultSet instanceof ASResultSet) {
			rsSource = sSourceOrObjResultSet;
		}else if (sSourceOrObjResultSet instanceof ObjResultSet) {
			rsSource = sSourceOrObjResultSet;
		}
		while (rsSource instanceof ASResultSet?((ASResultSet)rsSource).next():((ObjResultSet)rsSource).next()){
			sPVVS = CopyInfoUtil.getElementsInfoForCopy(rsSource,rsPurpose,sPurposePrimaryKey,sPurposeColumnExcept, mPurposeColToSourceCol,mColumnSetValuePurpose);
			if(actionFlag == 1){
				sSql = "insert into " + PurposeTableName +"("+sPVVS[0]+ ") values(" + sPVVS[2] + ")";
			}
			double iCount = Sqlca.getDouble("select count(1) from "+ PurposeTableName + " where (" + sPVVS[4]+ ")=(select " + sPVVS[6] + " from dual)");
			if(actionFlag == 2){
				if (iCount > 0) {
					sSql = "update " + PurposeTableName + " set ("+sPVVS[0] + ") =(select " + sPVVS[2]+" from dual) where (" + sPVVS[4]+")=(select "+sPVVS[6]+" from dual)";
				}else{
					sSql = "insert into " + PurposeTableName +"("+sPVVS[0]+ ") values(" + sPVVS[2] + ")";
				}
			}
			if(actionFlag == 3){
				Sqlca.executeSQL("delete from "+PurposeTableName+" where ("+ sPVVS[4]+")=(select "+sPVVS[6]+" from dual)");
				Sqlca.executeSQL("insert into "+PurposeTableName+"("+sPVVS[0]+") values("+sPVVS[2]+")");
			}
			if(actionFlag == 4){
				if(iCount == 0){
					sSql = "insert into " + PurposeTableName +"("+sPVVS[0]+ ") values(" + sPVVS[2] + ")";
				}
			}
			Sqlca.executeSQL(sSql);
		}
		if (sSourceOrObjResultSet instanceof String) {
			((ASResultSet) rsSource).getStatement().close();
		}
		rsPurpose.getStatement().close();
	}
	
	private static HashMap<String, String> toUpperCaseForMap(
			Map<String, String> mm) {
		HashMap<String, String> mTemp = new HashMap<String, String>();
		if (mm == null) {
			return null;
		}
		for (String sTemp : mm.keySet()) {
			mTemp.put(sTemp.toUpperCase(), mm.get(sTemp));
		}
		return mTemp;
	}

	private static String getTableName(String sSelectClause) {
		int fromStartIndex = sSelectClause.toUpperCase().indexOf("FROM") + 4;
		if (fromStartIndex != -1) {
			sSelectClause = sSelectClause.substring(fromStartIndex).trim();
			sSelectClause = sSelectClause.replaceAll("\\s", " ");
			int tableNameEndIndex = sSelectClause.indexOf(" ");
			if (tableNameEndIndex != -1) {
				return sSelectClause.substring(0, tableNameEndIndex);
			} else {
				return sSelectClause;
			}
		}
		return "";
	}

	private static String getColumnValueForSql(int iFieldType, String sValue) {
		if (isNumeric(iFieldType)) {
			if (sValue == null || sValue.equals(""))
				sValue = "0";
			return sValue;
		} else {
			if (sValue == null)
				sValue = "";
			return "'" + sValue + "'";
		}
	}

	// 判断字段类型是否为数字类型
	private static boolean isNumeric(int iType) {

		if (iType == java.sql.Types.BIGINT || iType == java.sql.Types.INTEGER
				|| iType == java.sql.Types.SMALLINT
				|| iType == java.sql.Types.DECIMAL
				|| iType == java.sql.Types.NUMERIC
				|| iType == java.sql.Types.DOUBLE
				|| iType == java.sql.Types.FLOAT
				|| iType == java.sql.Types.REAL)
			return true;
		return false;
	}
}
