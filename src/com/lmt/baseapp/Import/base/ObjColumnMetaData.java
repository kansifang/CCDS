package com.lmt.baseapp.Import.base;

import java.util.ArrayList;
import java.util.HashMap;

public class ObjColumnMetaData {
	private  String columnName=null;
	private  String columnType="";
	private  boolean primaryKey=false;//是否主键
	private  int indexInFile=0;//字段在上传文件中对应列序号，从0开始
	private  int index=0;//字段在ExcelResultset(即内存)中的序号，从0开始，
	private  int columnSize=0;
	private  String columnSValue="";//字段是String情况下会有值
	private  Double columnDValue=null;//字段是double情况下会有值
	private  String columnHeadName=null;//字段在文件中的标题名
	private  boolean outFileColumn=false;//不在文件中的字段，指的是导入文件时另外加的值，文件中不提供，但又有必要，比如导入号等，辅助性的东西
	private  HashMap<String,String> columnValueToCode=new HashMap<String,String>();
	public ObjColumnMetaData(String columnName,String columnHeadName,int indexInFile) {
		this.columnName=columnName;
		this.columnHeadName=columnHeadName;
		this.indexInFile = indexInFile;
	}
	/**
	 * 
	 * @param columnName
	 * @param columnType
	 * @param columnHeadName
	 * @param indexInFile
	 * @param index 字段序号
	 * @param outFileColumn
	 */
	public ObjColumnMetaData(String columnName,String columnType,String columnHeadName,int indexInFile,int index,boolean outFileColumn,boolean primaryKey) {
		this.columnName = columnName.toUpperCase();
		this.columnType = columnType;
		this.primaryKey=primaryKey;
		this.columnHeadName = columnHeadName;
		this.indexInFile = indexInFile;
		this.index = index;
		this.outFileColumn=outFileColumn;
	}
	public ObjColumnMetaData(String columnName, String columnType,HashMap<String, String> columnValueToCode) {
		this.columnName = columnName.toUpperCase();
		this.columnType = columnType;
		this.columnValueToCode = columnValueToCode;
	}
	public void setColumnName(String columnName) {
		this.columnName = columnName.toUpperCase();
	}
	public String getColumnName() {
		return columnName;
	}
	public boolean isPrimaryKey() {
		return primaryKey;
	}
	public boolean isOutFileColumn() {
		return outFileColumn;
	}
	public void setOutFileColumn(boolean outFileColumn) {
		this.outFileColumn = outFileColumn;
	}
	public int getColumnSize() {
		return columnSize;
	}
	public int getIndex() {
		return index;
	}
	public void setIndex(int index) {
		this.index = index;
	}
	public void setColumnSize(int columnSize) {
		this.columnSize = columnSize;
	}
	public void setColumnType(String columnType) {
		this.columnType = columnType;
	}
	public String getColumnType() {
		return columnType;
	}
	public void setColumnHeadName(String columnHeadName) {
		this.columnHeadName = columnHeadName;
	}
	public String getColumnHeadName() {
		return columnHeadName;
	}
	public boolean containsColumnName(String column) {
		if(column==null||"".equals(column)){
			return false;
		}
		if(this.columnName.contains(column.toUpperCase())){
			return true;
		}
		return false;
	}
	public boolean containsHeadName(String headName) {
		if(headName==null||"".equals(headName)){
			return false;
		}
		if(this.columnHeadName.contains(headName)){
			return true;
		}
		return false;
	}
	public void setColumnValueToCode(HashMap<String, String> columnValueToCode) {
		this.columnValueToCode = columnValueToCode;
	}
	public HashMap<String, String> getColumnValueToCode() {
		return columnValueToCode;
	}
	public int getIndexInFile() {
		return indexInFile;
	}
	public void setIndexInFile(int indexInFile) {
		this.indexInFile = indexInFile;
	}
	public String getSColumnValue() {
		return columnSValue;
	}
	public void setSColumnValue(String columnValue) {
		this.columnSValue = columnValue;
	}
	public Double getDColumnValue() {
		return columnDValue;
	}
	public void setDColumnValue(Double columnValue) {
		this.columnDValue = columnValue;
	}
	private ArrayList<String> toList(String[]aS){
		ArrayList<String> aTemp=new ArrayList<String>();
		for(String sT:aS){
			aTemp.add(sT.toUpperCase());
		}
		return aTemp;
	}
}
