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
	// �ѱ�ͷ�����ݿ��ֶζ�Ӧ�������γ�insert���������ݿ�
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
				throw new SQLException("���õ������������ļ�����������!");
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
				throw new SQLException("�����ļ����ܳ��Ⱥ����õ��ܳ��Ȳ��ȣ�һ���ֽ�һ�����ȣ�!");
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
