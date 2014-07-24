package com.lmt.baseapp.Import.base;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.DataConvert;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

/**
 * @author Administrator
 * 
 */
public class ObjRow {
	protected int columnTCount = 0;//列总数
	protected ArrayList<ObjColumn> columns = new ArrayList<ObjColumn>();
	protected String[][] aReplaceBWithAInValue = null;//字段值中的A需要由B替换 譬如[['A','B'],['C','D']]
	//初始化metadata
	public ObjRow(String configNo,String Key,ASUser curUser,Transaction Sqlca) throws Exception {
		this.columns.clear();
		//加载模板定义
		String isIndex=Sqlca.getString("select CodeTypeOne from Code_Catalog where CodeNo='"+configNo+"'");
		ASResultSet rs=Sqlca.getASResultSet("select ItemDescribe,Attribute1,Attribute2,Attribute3,SortNo from Code_Library where CodeNo='"+configNo+"' and IsInUse='1'");
		if(!"1".equals(isIndex)){
			while(rs.next()){
				this.addColumn(rs.getString(1),rs.getString(2),rs.getString(3),"1".equals(rs.getString(4))?true:false);
			}
		}else{
			while(rs.next()){
				boolean isPrimaryKey="1".equals(rs.getString(4))?true:false;
				if(isPrimaryKey){
					this.addColumn(rs.getString(1),rs.getString(2),rs.getString(3),isPrimaryKey);
				}else{
					this.addColumn(rs.getString(1),ExcelBigHandler.getNumberFromLetter(rs.getString(5))-1,rs.getString(3),isPrimaryKey);
				}
				
			}
		}
		rs.getStatement().close();
		//默认都有这个字段
		this.addColumn("ConfigNo", "配置号","String",true,false);//记录Excel要素和数据要素对应关系的配置信息号，同时标识同一种类型数据（大类）
		this.addColumn("ConfigName", "配置名称","String",true,false);//记录Excel要素和数据要素对应关系的配置信息号，同时标识同一种类型数据（大类）
		this.addColumn("OneKey", "主键","String",true,false);//标识同一种类型数据进一步区分（小类），譬如同一种报表的不同期次，就把ReportDate传进来
		this.addColumn("ImportNo", "批量号","String",true,false);//主要是为了区分批次之间（在大类+小类的前提下的最新和以前批次的区分）
		this.addColumn("ImportIndex", "批量序列号","String",true,false);//记录批次内序列
		this.addColumn("ImportTime", "批量时间","String",true,false);//记录批次时间
		this.addColumn("UserID", "导入人","String",true,false);
		//对字段值中特殊字符处理方式
		this.setaReplaceBWithAInValue(new String[][] { { "￥", "" },{ "\\$", "" }, { ",", "" }, { "\"", "" },{ "渤海银行", "" },{ "渤海银行股份有限公司", "" }});
		String sConfigName=DataConvert.toString(Sqlca.getString("select CodeName from Code_Catalog where CodeNo='"+configNo+"'"));
		//对这些值设恒定值
		this.setString("ConfigNo",configNo);
		this.setString("ConfigName",sConfigName);
		this.setString("OneKey",Key);
		
		SimpleDateFormat sdf=new SimpleDateFormat("'N'yyyyMMddHHmmssSSSS");
		this.setString("ImportNo",sdf.format(new Date())+"000000");
		this.setString("UserID",curUser.UserID);
		//初始化代码表(后期要改造成数据库配置形式)
		//this.setValueToCode(this.Sqlca);
	}
	public void reInit(){
		for(ObjColumn oc:this.columns){
			if(!oc.isOutFileColumn()){
				oc.setIndexInFile(-1);
				oc.setSColumnValue("");
				oc.setDColumnValue(0.0);
				
			}
		}
		SimpleDateFormat sdf=new SimpleDateFormat("'N'yyyyMMddHHmmssSSSS");
		this.setString("ImportNo",sdf.format(new Date())+"000000");
		
	}
	public String[][] getaReplaceBWithAInValue() {
		return aReplaceBWithAInValue;
	}

	public void setaReplaceBWithAInValue(String[][] aReplaceBWithAInValue) {
		this.aReplaceBWithAInValue = aReplaceBWithAInValue;
	}

	public int getColumnTCount() {
		return this.columnTCount;
	}
	public void setColumnTCount(int columnTCount) {
		this.columnTCount = columnTCount;
	}
	public void setColumnTCount() {
		this.columnTCount = this.columns.size();
	}
	public ArrayList<ObjColumn> getColumns() {
		return columns;
	}

	public void setColumns(ArrayList<ObjColumn> columns) {
		this.columns = columns;
	}

	public ObjColumn getColumnObjWIF(int index) {
		for (ObjColumn sC : this.columns) {
			int iTemp = sC.getIndexInFile();
			if (index == iTemp) {
				return sC;
			}
		}
		return null;
	}
	public ObjColumn getColumnObjWI(int index) {
		for (ObjColumn sC : this.columns) {
			int iTemp = sC.getIndex();
			if (index == iTemp) {
				return sC;
			}
		}
		return null;
	}
	public ObjColumn getHead(int index) {
		for (ObjColumn sC : this.columns) {
			int iTemp = sC.getIndexInFile();
			if (index == iTemp) {
				return sC;
			}
		}
		return null;
	}
	public String getHeadName(int index) {
		return this.getHead(index).getColumnHeadName();
	}
	public String getHeadName(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getColumnHeadName();
		}
		return null;
	}
	public void setString(int indexInFile, String columnValue) {
		String sTemp = "";
		ObjColumn sC = this.getColumnObjWIF(indexInFile);
		if (sC != null) {
			sTemp = columnValue;
			for (int i = 0; i < this.aReplaceBWithAInValue.length; i++) {
				sTemp = sTemp.replaceAll(aReplaceBWithAInValue[i][0],aReplaceBWithAInValue[i][1]);
			}
			sC.setSColumnValue(sTemp.trim());
		}
	}
	public void setDouble(int indexInFile, Double columnValue) {
		ObjColumn sC = this.getColumnObjWIF(indexInFile);
		if (sC != null) {
			sC.setDColumnValue(columnValue);
		}
	}
	public void setString(String column, String columnValue) {
		String sTemp = "";
		if (column==null||column.equals("")) {
			return;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			sTemp = columnValue;
			for (int i = 0; i < this.aReplaceBWithAInValue.length; i++) {
				sTemp = sTemp.replaceAll(aReplaceBWithAInValue[i][0],aReplaceBWithAInValue[i][1]);
			}
			sC.setSColumnValue(sTemp.trim());
		}
	}
	public void setDouble(String column, double columnValue) {
		if (column==null||column.equals("")) {
			return;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			sC.setDColumnValue(columnValue);
		}
	}
	public String getString(int index) {
		ObjColumn sC = this.getColumnObjWI(index);
		if (sC != null) {
			return sC.getSColumnValue();
		}
		return null;
	}
	public Double getDouble(int index) {
		ObjColumn sC = this.getColumnObjWI(index);
		if (sC != null) {
			return sC.getDColumnValue();
		}
		return null;
	}
	public ObjColumn getColumnObj(String columnEName) {
		if (columnEName == null || columnEName.equals("")) {
			return null;
		}
		for (ObjColumn sC : this.columns) {
			if (sC.containsColumnName(columnEName)) {
				return sC;
			}
		}
		return null;
	}
	public String getColumnTypeWIF(int indexInFile) {
		ObjColumn sC = this.getColumnObjWIF(indexInFile);
		if (sC != null) {
			return sC.getColumnType();
		}
		return null;
	}
	public String getColumnType(int index) {
		ObjColumn sC = this.getColumnObjWI(index);
		if (sC != null) {
			return sC.getColumnType();
		}
		return null;
	}
	public ObjColumn getColumnObjWH(String head) {
		if (head == null || head.equals("")) {
			return null;
		}
		for (ObjColumn sC : this.columns) {
			if (sC.containsHeadName(head)) {
				return sC;
			}
		}
		return null;
	}

	public String getStringWH(String head) {
		if (head == null || head.equals("")) {
			return null;
		}
		ObjColumn sC = this.getColumnObjWH(head);
		if (sC != null) {
			return sC.getSColumnValue();
		}
		return null;
	}

	public String getColumnName(String head) {
		if (head == null || head.equals("")) {
			return null;
		}
		ObjColumn sC = this.getColumnObjWH(head);
		if (sC != null) {
			return sC.getColumnName();
		}
		return null;
	}
	public String getString(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getSColumnValue();
		}
		return null;
	}
	public Double getDouble(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getDColumnValue();
		}
		return null;
	}

	public HashMap<String, String> getValueCode(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getColumnValueToCode();
		}
		return null;
	}

	public String getCodeWH(String head) {
		String sDisplayValue = "";
		ObjColumn sC = this.getColumnObjWH(head);
		if (sC != null) {
			HashMap<String, String> valueToCode = sC.getColumnValueToCode();
			sDisplayValue = this.getStringWH(head);
			if (valueToCode.containsKey(sDisplayValue)) {
				return valueToCode.get(sDisplayValue);
			}
		}
		return sDisplayValue;
	}

	public String getCode(String columnEName) {
		String sDisplayValue = "";
		ObjColumn sC = this.getColumnObj(columnEName);
		if (sC != null) {
			HashMap<String, String> valueToCode = sC.getColumnValueToCode();
			sDisplayValue = this.getString(columnEName);
			if (valueToCode.containsKey(sDisplayValue)) {
				return valueToCode.get(sDisplayValue);
			}
		}
		return sDisplayValue;
	}

	/**
	 * 
	 * @param EHTCcolumn
	 * @return false 已存在 故没有添加 true 添加了
	 */
	public boolean addColumn(ObjColumn EHTCcolumn) {
		String sNewColumn = EHTCcolumn.getColumnName();
		if (this.containsColumn(sNewColumn)) {
			System.out.println(sNewColumn + "字段已存在，不再添加本字段对象！");
			return false;
		}
		String sNewHeadColumn = EHTCcolumn.getColumnHeadName();
		if (this.containsHead(sNewHeadColumn)) {
			System.out.println(sNewHeadColumn + "标题字段已存在，不再添加本字段对象！！");
			return false;
		}
		this.columns.add(EHTCcolumn);
		this.columnTCount++;
		return true;
	}
	public void addColumn(String columnName, String headName, int indexInFile) {
		ObjColumn eh = new ObjColumn(columnName, "String",headName, indexInFile,this.columnTCount,false,false);
		this.addColumn(eh);
	}
	public void addColumn(String columnName, String headName,String columnType,boolean outFileColumn,boolean primaryKey) {
		ObjColumn eh = new ObjColumn(columnName,columnType,headName,-1,this.columnTCount,outFileColumn,primaryKey);
		this.addColumn(eh);
	}
	public void addColumn(String columnName, String headName,String columnType,boolean primaryKey) {
		ObjColumn eh = new ObjColumn(columnName,columnType,headName,-1,this.columnTCount,false,primaryKey);
		this.addColumn(eh);
	}
	public void addColumn(String columnName, int indexInFile,String columnType,boolean primaryKey) {
		ObjColumn eh = new ObjColumn(columnName,columnType,"",indexInFile,this.columnTCount,false,primaryKey);
		this.addColumn(eh);
	}
	public void addColumn(String columnName, String headName) {
		ObjColumn eh = new ObjColumn(columnName,"String",headName,-1,this.columnTCount,false,false);
		this.addColumn(eh);
	}
	public boolean containsIndexInFile(int indexInFile) {
		ObjColumn sC = this.getColumnObjWIF(indexInFile);
		if (sC != null) {
			return true;
		}
		return false;
	}
	public boolean containsColumn(String column) {
		if (column == null || "".equals(column)) {
			return false;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			return true;
		}
		return false;
	}

	public boolean containsHead(String head) {
		if (head == null || "".equals(head)) {
			return false;
		}
		ObjColumn sC = this.getColumnObjWH(head);
		if (sC != null) {
			return true;
		}
		return false;
	}

	public int getColumnIndexWH(String head) {
		if (head == null || "".equals(head)) {
			return 0;
		}
		ObjColumn sC = this.getColumnObjWH(head);
		if (sC != null) {
			return sC.getIndexInFile();
		}
		return 0;
	}
	public int getColumnIndex(String column) {
		if (column == null || "".equals(column)) {
			return 0;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getIndexInFile();
		}
		return 0;
	}

	public void setColumnIndexWH(String head, int index) {
		if (head == null || "".equals(head)) {
			return;
		}
		ObjColumn sC = this.getColumnObjWH(head);
		if (sC != null) {
			sC.setIndexInFile(index);
		}
	}

	public void setIndexWithColumn(String column, int index) {
		if (column == null || "".equals(column)) {
			return;
		}
		ObjColumn sC = this.getColumnObj(column);
		if (sC != null) {
			sC.setIndexInFile(index);
		}
	}

	protected Exception toException(String message, Exception e) {
		e.printStackTrace();
		return new Exception(message);
	}
	// 主要是处理 在excel中的显示值和在数据库中是代码值的情况
	/**
	 * 将所有 sheet 中 通过下拉框选值的字段添加到map中 形如：男 1，女 2..
	 * 
	 * @throws Exception
	 */
	public void setValueToCode(Transaction Sqlca) throws Exception {
		ASResultSet rs = null; // 结果集
		HashMap<String, String> currencyMap = new HashMap<String, String>();
		rs = Sqlca.getASResultSet("SELECT ItemName,ItemNo FROM Code_Library WHERE Codeno = 'Currency'");
		getMaps(rs, currencyMap);
		this.setValueCode("币种", currencyMap);
	}
	/**
	 *把 从数据库中获取的显示值 代码值放入Map
	 * 
	 * @param rs
	 * @param MapName
	 * @throws Exception
	 */
	private void getMaps(ASResultSet rs, HashMap<String, String> MapName)
			throws Exception {
		while (rs.next()) {
			// 将名称作为key 编号为value
			MapName.put(rs.getString(1), rs.getString(2));
		}
		rs.getStatement().close();
	}
	private void setValueCode(String columnHeadName, HashMap<String, String> valueToCode) {
		ObjColumn sC = this.getColumnObjWH(columnHeadName);
		if (sC != null) {
			sC.setColumnValueToCode(valueToCode);
		}
	}
}
