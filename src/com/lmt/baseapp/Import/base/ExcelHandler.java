package com.lmt.baseapp.Import.base;

import java.sql.SQLException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;

import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class ExcelHandler extends DefaultHandler {
	protected Sheet sheet = null;
	// 把表头和数据库字段对应起来，形成insert语句插入数据库
	public ExcelHandler(ObjRow or,Transaction sqlca)throws SQLException {
		super(or,sqlca);
	}
	public Sheet getSheet() {
		return sheet;
	}
	public void setSheet(Sheet sheet) {
		this.sheet = sheet;
	}
	
	public boolean checkMeta() throws Exception{
		//初始化开始行
		this.initCurrentRow();
		//校验上传文件是否为空
		StringBuffer sb=new StringBuffer("");
		Row headrow =getSheet().getRow(this.currentRow);
		if(headrow.getPhysicalNumberOfCells()==0){
			throw new Exception("上传文件为空文件！");
		}
		//校验上传文件中标题头是否重复
		for(int i=0;i<headrow.getPhysicalNumberOfCells();i++){
			String headrow1=this.changeCellToString(headrow.getCell(i));;
			if("".equals(headrow1)){
				continue;
			}
			for(int j=i+1;j<headrow.getPhysicalNumberOfCells();j++){
				String headrow2=this.changeCellToString(headrow.getCell(j));
				if(headrow1.equals(headrow2)){
					sb.append("Excel文件中"+headrow.getCell(i).getStringCellValue().trim()+"有多个，请调整；");
				}
			}
		}
		//校验模板里面定义的要素标题是否在上传文件中都具备，
		//初始化设置要素标题在文件中序号 indexInFile,
		//如果配置中标示直接以序号初始化,就直接更新序列号啦
		for (ObjColumn sC : this.record.columns) {
			int k=0;
			String headD = sC.getColumnHeadName();
			String headName="";
			if(!sC.isOutFileColumn()){
				if(this.record.getColumnIndexWH(headD)>=0){
					continue;
				}
				for (int i =0;i < headrow.getPhysicalNumberOfCells();i++) {
					headName=headrow.getCell(i).getStringCellValue().trim().replaceAll("\\s", "");
					if(headD.equals(headName)){
						this.record.setColumnIndexWH(headD,i);
						k=1;
						break;
					}
				}
				if(k==0){
					sb.append("~"+headD+"~");
				}
			}
		}
		if(sb.length()>0){
			throw new Exception("当前批次所选择的模板定义中配置的"+sb.toString()+"在上传Excel文件中没有对应的要素；");
		}
		return true;
	}
	//单个文件开始时需要初始化的各种值
	public void initPara() throws Exception {
		this.setRowCount(this.sheet.getLastRowNum()+1);
		this.setEof(false);
	}
	private void initCurrentRow() throws Exception{
		int cr=-1;
		int RowNumMaxt=this.sheet.getLastRowNum();
		label:
		for(int j=0;j<=RowNumMaxt;j++){
			//解析文件每一条记录到结果集中
			Row rr = this.sheet.getRow(j);
			if(rr==null){
				continue;
			}
			for (int i = 0; i <= rr.getLastCellNum(); ++i) {
				Cell cell=rr.getCell(i);
				if(cell==null){
					continue;
				}
				String value=changeCellToString(cell);
				if(this.record.containsHead(value)&&this.record.getColumnObjWH(value).isPrimaryKey()){
					cr=j;
					break label;
				}
			}
		}
		if(cr==-1){
			throw new Exception("无法确定起始行，请确认数据文件中是否存在配置信息中配置的主标签！");
		}
		this.setCurrentRow(cr);
	}
	public boolean next() throws Exception {
		//DecimalFormat nf = new DecimalFormat("#0");
		this.currentRow ++;
		if (this.currentRow >= this.rowCount) {
			return false;
		}
		Row rr = this.sheet.getRow(this.currentRow);
		if (rr.getPhysicalNumberOfCells() == 0) {
			this.eof = true;
			return false;
		}
		//解析文件下一条记录到结果集中
		for (int i = 0; i <= rr.getLastCellNum(); ++i) {
			Cell cell=rr.getCell(i);
			if(cell==null){
				if(this.record.containsIndexInFile(i)&&this.record.getColumnObjWIF(i).isPrimaryKey()){
					return false;//如果主标示为空直接表示没记录了
				}else{
					continue;
				}
			}
			int CT=cell.getCellType();
			if(this.record.containsIndexInFile(i)&&!this.record.getColumnObjWIF(i).isOutFileColumn()){
				if("Number".equals(this.record.getColumnTypeWIF(i))){
					if(CT!=HSSFCell.CELL_TYPE_NUMERIC&&CT!=HSSFCell.CELL_TYPE_FORMULA){
						//throw new Exception("第"+(this.currentRow+1)+"行第"+(i+1)+"列应为数字型，不符合要求"); 不是数据型就默认空 不再抛异常
						this.record.setDouble(i,0.0);
					}else{
						this.record.setDouble(i,cell.getNumericCellValue());//nf.parse(svalue).doubleValue()
					}
				}else{
					this.record.setString(i,changeCellToString(cell));
				}
			}
		}
		//设置文件外的一些要素的值，譬如导入日期，此处设置显然是每天记录是不一样的
		this.record.setString("ImportIndex", (this.currentRow+1)+"");
		this.record.setString("ImportTime", StringFunction.getTodayNow());
		return true;
	}
	//这里HSSFCell 有几种数据类型，如果想进行类型转换，再加一个方法进行转换，这里给的例子是都转换成String类型的数据
	private String changeCellToString(Cell cell){
		String returnValue = "";
		if(null != cell){
			switch(cell.getCellType()){
				case Cell.CELL_TYPE_NUMERIC:   //数字
					String []mm=cell.toString().split("-");
					if(mm.length>2){
						SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
						Date doubleValue1= cell.getDateCellValue();
						returnValue=sdf.format(doubleValue1);
					}else{
						//主要针对身份证号之类，Excel常变成 xxx,xxxx,xxx.0,所以在此转化一下
						NumberFormat nf = NumberFormat.getInstance();
						Double doubleValue = cell.getNumericCellValue();
						String str=nf.format(doubleValue);
						str = str.replace(".0", "");
						returnValue = str.replace(",", "");
					}
					break;
				case Cell.CELL_TYPE_STRING:    //字符串
					returnValue = cell.getStringCellValue().trim().replaceAll("\\s+", "pp");
					break;
				case Cell.CELL_TYPE_BOOLEAN:   //布尔
					Boolean booleanValue=cell.getBooleanCellValue();
					returnValue = booleanValue.toString();
					break;
				case Cell.CELL_TYPE_BLANK:     // 空值
					returnValue = "";
					break;
				case Cell.CELL_TYPE_FORMULA:   // 公式
					returnValue = cell.getCellFormula();
					break;
				case Cell.CELL_TYPE_ERROR:     // 故障
					returnValue = "";
					break;
				default:
					System.out.println("未知类型");
					break;
			}
		}
		return returnValue;
	}
}
