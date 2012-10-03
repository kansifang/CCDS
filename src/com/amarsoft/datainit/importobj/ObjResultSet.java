package com.amarsoft.datainit.importobj;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;

/**
 * @author Administrator
 * 
 */
public abstract class ObjResultSet {
	protected Transaction Sqlca = null;
	protected int columnTCount = 0;
	protected int rowCount = 0;
	protected int currentRow = 0;
	protected boolean eof = false;
	protected int rowSize = 0;
	protected ArrayList<ObjColumnMetaData> columns = new ArrayList<ObjColumnMetaData>();
	protected String[][] aReplaceBWithAInValue = null;
	protected HashMap<String,PreparedStatement> ps = new HashMap<String,PreparedStatement>();
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
		return columnTCount;
	}

	public void setColumnTCount(int columnTCount) {
		this.columnTCount = columnTCount;
	}

	public HashMap<String, PreparedStatement> getPs() {
		return ps;
	}

	public void setPs(HashMap<String, PreparedStatement> ps) {
		this.ps = ps;
	}

	public ArrayList<ObjColumnMetaData> getColumns() {
		return columns;
	}

	public void setColumns(ArrayList<ObjColumnMetaData> columns) {
		this.columns = columns;
	}

	public ObjColumnMetaData getColumnObj(int index) {
		if (index < 1) {
			return null;
		}
		for (ObjColumnMetaData sC : this.columns) {
			int iTemp = sC.getIndexInFile();
			if (index == iTemp) {
				return sC;
			}
		}
		return null;
	}

	public ObjColumnMetaData getHead(int index) {
		if (index < 1) {
			return null;
		}
		for (ObjColumnMetaData sC : this.columns) {
			int iTemp = sC.getIndexInFile();
			if (index == iTemp) {
				return sC;
			}
		}
		return null;
	}

	public void setColumnSize(int index, int columnValue) {
		if (index < 1) {
			return;
		}
		ObjColumnMetaData sC = this.getColumnObj(index);
		if (sC != null) {
			sC.setColumnSize(columnValue);
		}
	}

	public int getColumnSize(int index) {
		if (index < 1) {
			return 0;
		}
		ObjColumnMetaData sC = this.getColumnObj(index);
		if (sC != null) {
			return sC.getColumnSize();
		}
		return 0;
	}

	public void setString(int index, String columnValue) {
		String sTemp = "";
		if (index < 1) {
			return;
		}
		ObjColumnMetaData sC = this.getColumnObj(index);
		if (sC != null) {
			sTemp = columnValue;
			for (int i = 0; i < this.aReplaceBWithAInValue.length; i++) {
				sTemp = sTemp.replaceAll(aReplaceBWithAInValue[i][0],
						aReplaceBWithAInValue[i][1]);
			}
			sC.setColumnValue(sTemp);
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
				sTemp = sTemp.replaceAll(aReplaceBWithAInValue[i][0],
						aReplaceBWithAInValue[i][1]);
			}
			sC.setColumnValue(sTemp);
		}
	}
	public String getString(int index) {
		if (index < 1) {
			return null;
		}
		ObjColumnMetaData sC = this.getColumnObj(index);
		if (sC != null) {
			return sC.getColumnValue();
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
			return sC.getColumnValue();
		}
		return null;
	}

	public ArrayList<String> getColumnName(String head) {
		if (head == null || head.equals("")) {
			return null;
		}
		ObjColumnMetaData sC = this.getColumnObjWH(head);
		if (sC != null) {
			return sC.getColumnName();
		}
		return null;
	}

	public ArrayList<String> getHeads(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		ObjColumnMetaData sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getColumnHeadName();
		}
		return null;
	}

	public String getString(String column) {
		if (column == null || column.equals("")) {
			return null;
		}
		ObjColumnMetaData sC = this.getColumnObj(column);
		if (sC != null) {
			return sC.getColumnValue();
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
		ArrayList<String> sNewColumns = EHTCcolumn.getColumnName();
		for (String newcolumn : sNewColumns) {
			if (this.containsColumn(newcolumn)) {
				System.out.println(newcolumn + "字段已存在，不再添加本字段对象！");
				return false;
			}
		}
		ArrayList<String> sNewHeadColumns = EHTCcolumn.getColumnHeadName();
		for (String newhead : sNewHeadColumns) {
			if (this.containsHead(newhead)) {//如果标题字段已存在，就后续相同标题加上序号
				System.out.println(newhead + "标题字段已存在，为本标题字段后面加@再追加本标题字段再作为本标题字段！");//譬如文件中有两个“登记人”标题，第二个以“登记人@登记人”作为标题
				int currentHeadIndex=this.getHeadCurrentIndex(newhead)+1;
				EHTCcolumn.replaceColumnHeadName(newhead, newhead+"@"+currentHeadIndex);
				this.setHeadCurrentIndex(newhead, currentHeadIndex);
			}
		}
		this.columns.add(EHTCcolumn);
		return true;
	}
	public void addColumn(String[] columnName, String[] headName,int index) {
		ObjColumnMetaData eh = new ObjColumnMetaData(columnName,headName,index);
		this.addColumn(eh);
	}
	public void addColumn(String[] columnName, String[] headName) {
		ObjColumnMetaData eh = new ObjColumnMetaData(columnName,headName,0);
		this.addColumn(eh);
	}
	public void addColumn(String columnName, String headName, int index) {
		ObjColumnMetaData eh = new ObjColumnMetaData(columnName, "STRING",headName, index);
		this.addColumn(eh);
	}
	public void addColumn(String columnName, String headName) {
		ObjColumnMetaData eh = new ObjColumnMetaData(columnName,"STRING",headName,0);
		this.addColumn(eh);
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
	public int getHeadCurrentIndex(String head) {
		if (head == null || "".equals(head)) {
			return 0;
		}
		ObjColumnMetaData sC = this.getColumnObjWH(head);
		if (sC != null) {
			return sC.getHeadCurrentIndex();
		}
		return 0;
	}
	public void setHeadCurrentIndex(String head, int index) {
		if (head == null || "".equals(head)) {
			return;
		}
		ObjColumnMetaData sC = this.getColumnObjWH(head);
		if (sC != null) {
			sC.setHeadCurrentIndex(index);
		}
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
			this.initResultSetMeta(this.initWho);
			this.initResultSetPara();
			this.reInitPara=false;
		}
	}
	public abstract void initResultSetMeta(String initWho) throws Exception;
	public abstract void initResultSetPara() throws Exception;
	public abstract boolean next() throws Exception;
}
