package com.lmt.baseapp.Import.base;

import java.util.ArrayList;
import java.util.HashMap;

public class ObjColumnMetaData {
	private  String columnName=null;
	private  String columnType="";
	private  boolean primaryKey=false;//�Ƿ�����
	private  int indexInFile=0;//�ֶ����ϴ��ļ��ж�Ӧ����ţ���0��ʼ
	private  int index=0;//�ֶ���ExcelResultset(���ڴ�)�е���ţ���0��ʼ��
	private  int columnSize=0;
	private  String columnSValue="";//�ֶ���String����»���ֵ
	private  Double columnDValue=null;//�ֶ���double����»���ֵ
	private  String columnHeadName=null;//�ֶ����ļ��еı�����
	private  boolean outFileColumn=false;//�����ļ��е��ֶΣ�ָ���ǵ����ļ�ʱ����ӵ�ֵ���ļ��в��ṩ�������б�Ҫ�����絼��ŵȣ������ԵĶ���
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
	 * @param index �ֶ����
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
