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
 * sheet处理器，即针对每一个Excel中的sheet,XMlReader都会调用它来不断处理遇到的元素，
 * 所以startElement,endElement要实现，并且这也是获取元素值存取元素值的时候（针对单元格元素c），
 * 更是遇到行元素r，处理这一行数据的时候
 * 
 * SAX读Excel生成的xml格式： 
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
	private boolean listIsNull = true;//表示rowlist有没有初始化，没有的用空字符串初始化之
	protected int rows = 0;//总记录数
	protected int cols = 0;//总记录数
	private boolean allNull = true;//表示Excel当前行所有Cell都是空
	public ExcelBigHandler(ExcelBigEntrance ebe,SharedStringsTable sst) throws SAXException {
		this.record=ebe.getOR();
		this.Sqlca =ebe.getSqlca();
		this.HDB=ebe.getHDB();
		this.sst=sst;
	}
	//重写
	public void startElement(String uri, String localName, String name,
			Attributes attributes) throws SAXException {
		// c => cell单元格
		if (name.equals("c")) {
			// Print the cell reference 如果下一个元素是 SST 的索引，则将nextIsString标记为true
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
			// 设置行号
			curRow = Integer.parseInt(attributes.getValue("r"));
			// 以第一行为行数据标准 获取列数(后面可以起始行为标准)
			if (curRow == 1) {
				cols = getColumns(attributes.getValue("spans"));
			}
		} else if (name.equals("dimension")) {
			// <dimension ref="A1:C2"/>
			// 获得总计录数
			String d = attributes.getValue("ref");
			rows = getNumber(d.substring(d.indexOf(":") + 1, d.length()));
		}
		// Clear contents cache
		lastContents = "";
	}
	//重写
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
		// v => 单元格的值，如果单元格是字符串则v标签的值为该字符串在SST(SharedStringsTable sst =
		// xr.getSharedStringsTable())中的索引
		// 将单元格内容加入rowlist中，在这之前先去掉字符串前后的空白符
		if (name.equals("v")) {
			String value = lastContents.trim();
			if (allNull && !value.equals("")) {
				allNull = false;
			}
			if (curCol <= cols) {
				if(curRow==1){//默认第一行为标题行，在此设置记录集字段在文件中的序号（0开始）
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
			if (name.equals("row") && !allNull&&curRow!=1) {//第一行是标题行，不保存到数据库
				//设置文件外的一些要素的值，譬如导入日期，此处设置显然是每天记录是不一样的
				this.record.setString("ImportIndex", (curRow-1)+"");
				this.record.setString("ImportTime", StringFunction.getTodayNow());
				try {
					this.HDB.saveToDB();
					//(sheetIndex, curRow, rowlist);// 这时可以处理一行数据了，譬如可以PreparedStatement中，到一定记录插入数据库
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
	//重写
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
