package com.amarsoft.datainit.importobj;

import java.util.ArrayList;
import java.util.HashMap;

public class ObjColumnMetaData {
	private  ArrayList<String> columnName=null;
	private  String columnType="";
	private  int indexInFile=0;//正常情况下从1开始
	private  int columnSize=0;
	private  String columnValue="";
	private  ArrayList<String> columnHeadName=null;
	private  int HeadCurrentIndex=0;//文件中，标题存在重复次数时，当前次数
	private  HashMap<String,String> columnValueToCode=new HashMap<String,String>();
	public ObjColumnMetaData(String[] columnName,String[] columnHeadName,int index) {
		this.columnName=this.toList(columnName);
		this.columnHeadName=this.toList(columnHeadName);
		this.indexInFile = index;
	}
	public ObjColumnMetaData(String columnName,String columnType,String columnHeadName,int index) {
		this.columnName = this.toList(new String[]{columnName.toUpperCase()});
		this.columnType = columnType;
		this.columnHeadName = this.toList(new String[]{columnHeadName});
		this.indexInFile = index;
	}
	public ObjColumnMetaData(String columnName, String columnType,HashMap<String, String> columnValueToCode) {
		this.columnName = this.toList(new String[]{columnName.toUpperCase()});
		this.columnType = columnType;
		this.columnValueToCode = columnValueToCode;
	}
	public void setColumnName(String columnName) {
		this.columnName = this.toList(new String[]{columnName.toUpperCase()});
	}
	public ArrayList<String> getColumnName() {
		return columnName;
	}
	
	public int getHeadCurrentIndex() {
		return HeadCurrentIndex;
	}
	public void setHeadCurrentIndex(int headCurrentIndex) {
		HeadCurrentIndex = headCurrentIndex;
	}
	public void setColumnName(String[] columnName) {
		this.columnName = this.toList(columnName);
	}
	public int getColumnSize() {
		return columnSize;
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
	public void setColumnHeadName(String[] columnHeadName) {
		this.columnHeadName = this.toList(columnHeadName);
	}
	public void replaceColumnHeadName(String oldColumnHeadName,String newColumnHeadName) {
		int i=this.columnHeadName.indexOf(oldColumnHeadName);
		if(i!=-1){
			this.columnHeadName.remove(i);
		}
		this.columnHeadName.add(i, newColumnHeadName);
	}
	public ArrayList<String> getColumnHeadName() {
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
	public boolean addColumnName(String column) {
		if(column==null||"".equals(column)){
			return false;
		}
		if(this.containsColumnName(column)){
			this.columnName.add(column);
			return true;
		}
		return false;
	}
	public boolean addHead(String head) {
		if(head==null||"".equals(head)){
			return false;
		}
		if(this.containsHeadName(head)){
			this.columnName.add(head);
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
	public String getColumnValue() {
		return columnValue;
	}
	public void setColumnValue(String columnValue) {
		this.columnValue = columnValue;
	}
	private ArrayList<String> toList(String[]aS){
		ArrayList<String> aTemp=new ArrayList<String>();
		for(String sT:aS){
			aTemp.add(sT.toUpperCase());
		}
		return aTemp;
	}
}
