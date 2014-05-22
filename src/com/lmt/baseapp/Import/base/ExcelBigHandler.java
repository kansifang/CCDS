package com.lmt.baseapp.Import.base;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.model.SharedStringsTable;
import org.apache.poi.xssf.usermodel.XSSFRichTextString;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

/**
 * sheet�������������ÿһ��Excel�е�sheet,XMlReader��������������ϴ���������Ԫ�أ�
 * ����startElement,endElementҪʵ�֣�������Ҳ�ǻ�ȡԪ��ֵ��ȡԪ��ֵ��ʱ����Ե�Ԫ��Ԫ��c����
 * ����������Ԫ��r��������һ�����ݵ�ʱ��
 * 
 * SAX��Excel���ɵ�xml��ʽ�� 
 * 
1.<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">  
2.    <dimension ref="A1:C2"/>  
3.    <sheetViews>  
4.        <sheetView tabSelected="1" workbookViewId="0">  
5.        <selection activeCell="A2" sqref="A2"/></sheetView>  
6.    </sheetViews>  
7.    <sheetFormatPr defaultRowHeight="13.5"/>  
8.        <cols>  
9.            <col min="1" max="1" width="15.375" customWidth="1"/>  
10.            <col min="2" max="2" width="19.25" customWidth="1"/>  
11.            <col min="3" max="3" width="13.75" customWidth="1"/>  
12.        </cols>  
13.    <sheetData>  
14.        <row r="1" spans="1:3">  
15.            <c r="A1" s="1" t="s">  
16.                <v>0</v>  
17.            </c>  
18.            <c r="B1" s="1"/>  
19.            <c r="C1" s="1">  
20.                <v>111.1</v>  
21.            </c>  
22.        </row>  
23.        <row r="2" spans="1:3">  
24.            <c r="C2">  
25.                <v>222.2</v>  
26.            </c>  
27.        </row>  
28.    </sheetData>  
29.    <phoneticPr fontId="1" type="noConversion"/>  
30.    <pageMargins left="0.7" right="0.7" top="0.75" bottom="0.75" header="0.3" footer="0.3"/>  
31.    <pageSetup paperSize="9" orientation="portrait" horizontalDpi="200" verticalDpi="200" r:id="rId1"/>  
32.</worksheet> 
 */
public class ExcelBigHandler extends DefaultHandler {
	protected Transaction Sqlca = null;
	private DBHandler HDB=null;
	protected ObjRow record=null;
	private SharedStringsTable sst;
	private String lastContents;
	private boolean nextIsString;

	private int curRow = 1;
	private int curCol = 1;
	private boolean listIsNull = true;//��ʾrowlist��û�г�ʼ����û�е��ÿ��ַ�����ʼ��֮
	protected int rows = 0;//�ܼ�¼��
	protected int cols = 0;//�ܼ�¼��
	private boolean allNull = true;//��ʾExcel��ǰ������Cell���ǿ�
	public ExcelBigHandler(ExcelBigEntrance ebe,SharedStringsTable sst) throws SAXException {
		this.record=ebe.getOR();
		this.Sqlca =ebe.getSqlca();
		this.HDB=ebe.getHDB();
		this.sst=sst;
	}
	//��д
	public void startElement(String uri, String localName, String name,
			Attributes attributes) throws SAXException {
		// c => cell��Ԫ��
		if (name.equals("c")) {
			// Print the cell reference �����һ��Ԫ���� SST ����������nextIsString���Ϊtrue
			// System.out.print(attributes.getValue("r") + " - ");
			// Figure out if the value is an index in the SST
			// <c r="A1" s="1" t="s">
			// <v>0</v>
			// </c>
			String cellType = attributes.getValue("t");
			if (cellType != null && cellType.equals("s")) {
				nextIsString = true;
			} else {
				nextIsString = false;
			}
			curCol = getNumberFromLetter(attributes.getValue("r"));
		} else if (name.equals("row")) {
			/*
			 * <row r="1" spans="1:3"> <c r="A1" s="1" t="s"> <v>0</v> </c> <c
			 * r="B1" s="1"/> <c r="C1" s="1"> <v>111.1</v> </c> </row>
			 */
			// �����к�
			curRow = Integer.parseInt(attributes.getValue("r"));
			// �Ե�һ��Ϊ�����ݱ�׼ ��ȡ����(���������ʼ��Ϊ��׼)
			if (curRow == 1) {
				cols = getColumns(attributes.getValue("spans"));
			}
		} else if (name.equals("dimension")) {
			// <dimension ref="A1:C2"/>
			// ����ܼ�¼��
			String d = attributes.getValue("ref");
			rows = getNumber(d.substring(d.indexOf(":") + 1, d.length()));
		}
		// Clear contents cache
		lastContents = "";
	}
	//��д
	public void endElement(String uri, String localName, String name)
			throws SAXException {
		// Process the last contents as required.
		// Do now, as characters() may be called more than once
		if (nextIsString) {
			int idx = Integer.parseInt(lastContents);
			lastContents = new XSSFRichTextString(sst.getEntryAt(idx)).toString();
			nextIsString = false;
		}
		// v => contents of a cell
		// v => ��Ԫ���ֵ�������Ԫ�����ַ�����v��ǩ��ֵΪ���ַ�����SST(SharedStringsTable sst =
		// xr.getSharedStringsTable())�е�����
		// ����Ԫ�����ݼ���rowlist�У�����֮ǰ��ȥ���ַ���ǰ��Ŀհ׷�
		if (name.equals("v")) {
			String value = lastContents.trim();
			if (allNull && !value.equals("")) {
				allNull = false;
			}
			if (curCol <= cols) {
				if(curRow==1){//Ĭ�ϵ�һ��Ϊ�����У��ڴ����ü�¼���ֶ����ļ��е���ţ�0��ʼ��
					ObjColumn oc=record.getColumnObjWH(value);
					if(oc!=null){
						oc.setIndexInFile(curCol-1);
					}
				}else{
					ObjColumn oc=record.getColumnObjWIF(curCol-1);
					if(oc!=null){
						if("Number".equals(oc.getColumnType())){
							record.setDouble(curCol-1, new Double(value));
						}else{
							record.setString(curCol-1, value);
						}
					}
				}
			}
		} else {
			if (name.equals("row") && !allNull&&curRow!=1) {//��һ���Ǳ����У������浽���ݿ�
				//�����ļ����һЩҪ�ص�ֵ��Ʃ�絼�����ڣ��˴�������Ȼ��ÿ���¼�ǲ�һ����
				this.record.setString("ImportIndex", (curRow-1)+"");
				this.record.setString("ImportTime", StringFunction.getTodayNow());
				try {
					this.HDB.saveToDB();
					//(sheetIndex, curRow, rowlist);// ��ʱ���Դ���һ�������ˣ�Ʃ�����PreparedStatement�У���һ����¼�������ݿ�
					allNull = true;
				} catch (IllegalArgumentException ie) {
					throw ie;
				} catch (SQLException e) {
					throw new SAXException(e);
				} catch (Exception e) {
					e.printStackTrace();
				}
				resetRowList();
			}
		}
	}
	//��д
	public void characters(char[] ch, int start, int length)
			throws SAXException {
		lastContents += new String(ch, start, length);
	}

	public void resetRowList() {
		for(int j=0;j<record.columnTCount;j++){
			ObjColumn oc=record.getColumnObjWI(j);
			if(!oc.isOutFileColumn()){
				String columnType=oc.getColumnType();
				if("Number".equals(columnType)){
					oc.setDColumnValue(0.0);
				}else{
					oc.setSColumnValue("");
				}
			}
		}
	}

	private static int getColumns(String spans) {
		String number = spans.substring(spans.lastIndexOf(':') + 1,spans.length());
		return Integer.parseInt(number);
	}
	private static int getNumberFromLetter(String column) {  
        String c = column.toUpperCase().replaceAll("[0-9]", "");  
        int number = (int) c.charAt(0) - 64;  
        return number;  
    } 
	private static int getNumber(String column) {
		String c = column.toUpperCase().replaceAll("[A-Z]", "");
		return Integer.parseInt(c);
	}

	public void setAllNull(boolean allNull) {
		this.allNull = allNull;
	}

	public boolean isAllNull() {
		return allNull;
	}
}
