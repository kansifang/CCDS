package com.lmt.baseapp.Import.base;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;
public class TextHandler extends DefaultHandler {
	private BufferedReader reader;
	private boolean fixLengthMode = false;
	private String separator = "";
	// 把表头和数据库字段对应起来，形成insert语句插入数据库
	public TextHandler(ObjRow or,Transaction sqlca) throws Exception {
		super(or,sqlca);
	}
	public BufferedReader getReader() {
		return reader;
	}
	public void setReader(BufferedReader reader) {
		this.reader = reader;
	}
	public void initPara() throws Exception {
		this.setCurrentRow(0);
		this.setEof(false);
		this.setValueToCode(this.Sqlca);
	}
	public boolean next() throws Exception {
		this.currentRow += 1;
		String rowString = "";
		try {
			rowString = reader.readLine();
		} catch (IOException e) {
			throw new Exception("Read line error.", e);
		}
		if (rowString == null) {
			this.eof = true;
			return false;
		}
		if (rowString.trim().equals("")) {
			return next();
		}
		if (!this.fixLengthMode) {
			String[] rowBuffer = rowString.split(this.separator, -1);
			if(rowBuffer.length!=this.record.getColumnTCount()){
				throw new SQLException("配置的列数和数据文件的列数不等!");
			}
			try {
				for (int i = 0; i < this.record.getColumnTCount(); ++i) {
					this.record.setString(i + 1, rowBuffer[i].trim());
				}
			} catch (Exception ex) {
				throw new Exception("Split row error", ex);
			}
		} else {
			int start = 0;
			byte[] rowStringArray = rowString.getBytes();
			if (rowStringArray.length != this.record.getRowTSize()) {
				throw new SQLException("数据文件的总长度和配置的总长度不等（一个字节一个长度）!");
			}
			for (int i = 0; i < this.record.getColumnTCount(); ++i) {
				if(this.record.containsIndexInFile(i)&&!this.record.getColumnObjWIF(i).isOutFileColumn()){
					int columnSize=this.record.getColumnObjWIF(i).getColumnSize();
					String value=new String(rowStringArray, start,columnSize).trim();
					this.record.setString(i,value);
					start += columnSize;
				}
			}
		}
		return true;
	}
	public String getSeparator() {
		return separator;
	}

	public void setSeparator(String separator) {
		this.separator = separator;
	}

	public boolean isFixLengthMode() {
		return fixLengthMode;
	}

	public void setFixLengthMode(boolean fixLengthMode) {
		this.fixLengthMode = fixLengthMode;
	}
}
