package com.lmt.baseapp.Import.base;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

/**
 * @author Administrator
 * 
 */
public abstract class ObjResultSet {
	protected Transaction Sqlca = null;
	protected int columnTCount = 0;//列总数
	protected int rowCount = 0;
	protected int currentRow = 0;
	protected boolean eof = false;
	protected int rowSize = 0;
	protected ArrayList<ObjColumnMetaData> columns = new ArrayList<ObjColumnMetaData>();
	protected String[][] aReplaceBWithAInValue = null;
	protected boolean reInitPara=true;
	protected String initWho="";
	public ObjResultSet(Transaction sqlca) throws SQLException {
		this.Sqlca = sqlca;
	}
	public Transaction getSqlca() {
		return Sqlca;
	}
	public boolean isReInitPara() {
		return reInitPara;
	}
	public void setReInitPara(boolean reInitPara) {
		this.reInitPara = reInitPara;
	}

	public String getInitWho() {
		return initWho;
	}

	public void setInitWho(String initWho) {
		this.initWho = initWho;
	}

	public void setSqlca(Transaction sqlca) {
		Sqlca = sqlca;
	}

	public int getRowSize() {
		return rowSize;
	}

	public void setRowSize(int rowSize) {
		this.rowSize = rowSize;
	}

	public int getRowCount() {
		return rowCount;
	}
	public void setRowCount(int rowCount) {
		this.rowCount = rowCount;
	}
	public int getCurrentRow() {
		return currentRow;
	}

	public void setCurrentRow(int currentRow) {
		this.currentRow = currentRow;
	}

	public boolean isEof() {
		return eof;
	}

	public void setEof(boolean eof) {
		this.eof = eof;
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
	public ArrayList<ObjColumnMetaData> getColumns() {
		return columns;
	}

	public void setColumns(ArrayList<ObjColumnMetaData> columns) {
		this.columns = columns;
	}

	public ObjColumnMetaData getColumnObjWIF(int index) {
		for (ObjColumnMetaData sC : this.columns) {
			int iTemp = sC.getIndexInFile();
			if (index == iTemp) {
				return sC;
			}
		}
		return null;
	}
	public ObjColumnMetaData getColumnObjWI(int index) {
		for (ObjColumnMetaData sC : this.columns) {
			int iTemp = sC.getIndex();
			if (index == iTemp) {
				return sC;
			}
		}
		return null;
	}
	public ObjColumnMetaData getHead(int index) {
		for (ObjColumnMetaData sC : this.columns) {
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
		ObjColumnMetaData sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getColumnHeadName();
		}
		return null;
	}
	public void setString(int indexInFile, String columnValue) {
		String sTemp = "";
		ObjColumnMetaData sC = this.getColumnObjWIF(indexInFile);
		if (sC != null) {
			sTemp = columnValue;
			for (int i = 0; i < this.aReplaceBWithAInValue.length; i++) {
				sTemp = sTemp.replaceAll(aReplaceBWithAInValue[i][0],aReplaceBWithAInValue[i][1]);
			}
			sC.setSColumnValue(sTemp);
		}
	}
	public void setDouble(int indexInFile, Double columnValue) {
		ObjColumnMetaData sC = this.getColumnObjWIF(indexInFile);
		if (sC != null) {
			sC.setDColumnValue(columnValue);
		}
	}
	public void setString(String column, String columnValue) {
		String sTemp = "";
		if (column==null||column.equals("")) {
			return;
		}
		ObjColumnMetaData sC = this.getColumnObj(column);
		if (sC != null) {
			sTemp = columnValue;
			for (int i = 0; i < this.aReplaceBWithAInValue.length; i++) {
				sTemp = sTemp.replaceAll(aReplaceBWithAInValue[i][0],aReplaceBWithAInValue[i][1]);
			}
			sC.setSColumnValue(sTemp);
		}
	}
	public void setDouble(String column, double columnValue) {
		if (column==null||column.equals("")) {
			return;
		}
		ObjColumnMetaData sC = this.getColumnObj(column);
		if (sC != null) {
			sC.setDColumnValue(columnValue);
		}
	}
	public String getString(int index) {
		ObjColumnMetaData sC = this.getColumnObjWI(index);
		if (sC != null) {
			return sC.getSColumnValue();
		}
		return null;
	}
	public Double getDouble(int index) {
		ObjColumnMetaData sC = this.getColumnObjWI(index);
		if (sC != null) {
			return sC.getDColumnValue();
		}
		return null;
	}
	public ObjColumnMetaData getColumnObj(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		for (ObjColumnMetaData sC : this.columns) {
			if (sC.containsColumnName(column)) {
				return sC;
			}
		}
		return null;
	}
	public String getColumnTypeWIF(int indexInFile) {
		ObjColumnMetaData sC = this.getColumnObjWIF(indexInFile);
		if (sC != null) {
			return sC.getColumnType();
		}
		return null;
	}
	public String getColumnType(int index) {
		ObjColumnMetaData sC = this.getColumnObjWI(index);
		if (sC != null) {
			return sC.getColumnType();
		}
		return null;
	}
	public ObjColumnMetaData getColumnObjWH(String head) {
		if (head == null || head.equals("")) {
			return null;
		}
		for (ObjColumnMetaData sC : this.columns) {
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
		ObjColumnMetaData sC = this.getColumnObjWH(head);
		if (sC != null) {
			return sC.getSColumnValue();
		}
		return null;
	}

	public String getColumnName(String head) {
		if (head == null || head.equals("")) {
			return null;
		}
		ObjColumnMetaData sC = this.getColumnObjWH(head);
		if (sC != null) {
			return sC.getColumnName();
		}
		return null;
	}
	public String getString(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		ObjColumnMetaData sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getSColumnValue();
		}
		return null;
	}
	public Double getDouble(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		ObjColumnMetaData sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getDColumnValue();
		}
		return null;
	}

	public HashMap<String, String> getValueCode(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		ObjColumnMetaData sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getColumnValueToCode();
		}
		return null;
	}

	public void setValueCode(String column, HashMap<String, String> valueToCode) {
		ObjColumnMetaData sC = this.getColumnObj(column);
		if (sC != null) {
			sC.setColumnValueToCode(valueToCode);
		}
	}

	public String getCodeWH(String head) {
		String sDisplayValue = "";
		ObjColumnMetaData sC = this.getColumnObjWH(head);
		if (sC != null) {
			HashMap<String, String> valueToCode = sC.getColumnValueToCode();
			sDisplayValue = this.getStringWH(head);
			if (valueToCode.containsKey(sDisplayValue)) {
				return valueToCode.get(sDisplayValue);
			}
		}
		return sDisplayValue;
	}

	public String getCode(String column) {
		String sDisplayValue = "";
		ObjColumnMetaData sC = this.getColumnObj(column);
		if (sC != null) {
			HashMap<String, String> valueToCode = sC.getColumnValueToCode();
			sDisplayValue = this.getString(column);
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
	public boolean addColumn(ObjColumnMetaData EHTCcolumn) {
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
		ObjColumnMetaData eh = new ObjColumnMetaData(columnName, "String",headName, indexInFile,this.columnTCount,false,false);
		this.addColumn(eh);
	}
	public void addColumn(String columnName, String headName,String columnType,boolean outFileColumn,boolean primaryKey) {
		ObjColumnMetaData eh = new ObjColumnMetaData(columnName,columnType,headName,0,this.columnTCount,outFileColumn,primaryKey);
		this.addColumn(eh);
	}
	public void addColumn(String columnName, String headName,String columnType,boolean primaryKey) {
		ObjColumnMetaData eh = new ObjColumnMetaData(columnName,columnType,headName,0,this.columnTCount,false,primaryKey);
		this.addColumn(eh);
	}
	public void addColumn(String columnName, String headName) {
		ObjColumnMetaData eh = new ObjColumnMetaData(columnName,"String",headName,0,this.columnTCount,false,false);
		this.addColumn(eh);
	}
	public boolean containsIndexInFile(int indexInFile) {
		ObjColumnMetaData sC = this.getColumnObjWIF(indexInFile);
		if (sC != null) {
			return true;
		}
		return false;
	}
	public boolean containsColumn(String column) {
		if (column == null || "".equals(column)) {
			return false;
		}
		ObjColumnMetaData sC = this.getColumnObj(column);
		if (sC != null) {
			return true;
		}
		return false;
	}

	public boolean containsHead(String head) {
		if (head == null || "".equals(head)) {
			return false;
		}
		ObjColumnMetaData sC = this.getColumnObjWH(head);
		if (sC != null) {
			return true;
		}
		return false;
	}

	public int getColumnIndexWH(String head) {
		if (head == null || "".equals(head)) {
			return 0;
		}
		ObjColumnMetaData sC = this.getColumnObjWH(head);
		if (sC != null) {
			return sC.getIndexInFile();
		}
		return 0;
	}
	public int getColumnIndex(String column) {
		if (column == null || "".equals(column)) {
			return 0;
		}
		ObjColumnMetaData sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getIndexInFile();
		}
		return 0;
	}

	public void setColumnIndexWH(String head, int index) {
		if (head == null || "".equals(head)) {
			return;
		}
		ObjColumnMetaData sC = this.getColumnObjWH(head);
		if (sC != null) {
			sC.setIndexInFile(index);
		}
	}

	public void setColumnIndex(String column, int index) {
		if (column == null || "".equals(column)) {
			return;
		}
		ObjColumnMetaData sC = this.getColumnObj(column);
		if (sC != null) {
			sC.setIndexInFile(index);
		}
	}

	/**
	 *把 从数据库中获取的显示值 代码值放入Map
	 * 
	 * @param rs
	 * @param MapName
	 * @throws Exception
	 */
	protected void getMaps(ASResultSet rs, HashMap<String, String> MapName)
			throws Exception {
		while (rs.next()) {
			// 将名称作为key 编号为value
			MapName.put(rs.getString(1), rs.getString(2));
		}
		rs.getStatement().close();
	}

	protected Exception toException(String message, Exception e) {
		e.printStackTrace();
		return new Exception(message);
	}
	protected void init()throws Exception{
		if(this.reInitPara){
			this.initPara();
			this.reInitPara=false;
		}
	}
	public abstract void initMeta() throws Exception;
	public abstract void initPara() throws Exception;
	public abstract boolean next() throws Exception;
}
