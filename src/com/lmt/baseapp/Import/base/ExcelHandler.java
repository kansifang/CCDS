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
	// �ѱ�ͷ�����ݿ��ֶζ�Ӧ�������γ�insert���������ݿ�
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
		//��ʼ����ʼ��
		this.initCurrentRow();
		//У���ϴ��ļ��Ƿ�Ϊ��
		StringBuffer sb=new StringBuffer("");
		Row headrow =getSheet().getRow(this.currentRow);
		if(headrow.getPhysicalNumberOfCells()==0){
			throw new Exception("�ϴ��ļ�Ϊ���ļ���");
		}
		//У���ϴ��ļ��б���ͷ�Ƿ��ظ�
		for(int i=0;i<headrow.getPhysicalNumberOfCells();i++){
			String headrow1=this.changeCellToString(headrow.getCell(i));;
			if("".equals(headrow1)){
				continue;
			}
			for(int j=i+1;j<headrow.getPhysicalNumberOfCells();j++){
				String headrow2=this.changeCellToString(headrow.getCell(j));
				if(headrow1.equals(headrow2)){
					sb.append("Excel�ļ���"+headrow.getCell(i).getStringCellValue().trim()+"�ж�����������");
				}
			}
		}
		//У��ģ�����涨���Ҫ�ر����Ƿ����ϴ��ļ��ж��߱���
		//��ʼ������Ҫ�ر������ļ������ indexInFile,
		//��������б�ʾֱ������ų�ʼ��,��ֱ�Ӹ������к���
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
			throw new Exception("��ǰ������ѡ���ģ�嶨�������õ�"+sb.toString()+"���ϴ�Excel�ļ���û�ж�Ӧ��Ҫ�أ�");
		}
		return true;
	}
	//�����ļ���ʼʱ��Ҫ��ʼ���ĸ���ֵ
	public void initPara() throws Exception {
		this.setRowCount(this.sheet.getLastRowNum()+1);
		this.setEof(false);
	}
	private void initCurrentRow() throws Exception{
		int cr=-1;
		int RowNumMaxt=this.sheet.getLastRowNum();
		label:
		for(int j=0;j<=RowNumMaxt;j++){
			//�����ļ�ÿһ����¼���������
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
			throw new Exception("�޷�ȷ����ʼ�У���ȷ�������ļ����Ƿ����������Ϣ�����õ�����ǩ��");
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
		//�����ļ���һ����¼���������
		for (int i = 0; i <= rr.getLastCellNum(); ++i) {
			Cell cell=rr.getCell(i);
			if(cell==null){
				if(this.record.containsIndexInFile(i)&&this.record.getColumnObjWIF(i).isPrimaryKey()){
					return false;//�������ʾΪ��ֱ�ӱ�ʾû��¼��
				}else{
					continue;
				}
			}
			int CT=cell.getCellType();
			if(this.record.containsIndexInFile(i)&&!this.record.getColumnObjWIF(i).isOutFileColumn()){
				if("Number".equals(this.record.getColumnTypeWIF(i))){
					if(CT!=HSSFCell.CELL_TYPE_NUMERIC&&CT!=HSSFCell.CELL_TYPE_FORMULA){
						//throw new Exception("��"+(this.currentRow+1)+"�е�"+(i+1)+"��ӦΪ�����ͣ�������Ҫ��"); ���������;�Ĭ�Ͽ� �������쳣
						this.record.setDouble(i,0.0);
					}else{
						this.record.setDouble(i,cell.getNumericCellValue());//nf.parse(svalue).doubleValue()
					}
				}else{
					this.record.setString(i,changeCellToString(cell));
				}
			}
		}
		//�����ļ����һЩҪ�ص�ֵ��Ʃ�絼�����ڣ��˴�������Ȼ��ÿ���¼�ǲ�һ����
		this.record.setString("ImportIndex", (this.currentRow+1)+"");
		this.record.setString("ImportTime", StringFunction.getTodayNow());
		return true;
	}
	//����HSSFCell �м����������ͣ�������������ת�����ټ�һ����������ת����������������Ƕ�ת����String���͵�����
	private String changeCellToString(Cell cell){
		String returnValue = "";
		if(null != cell){
			switch(cell.getCellType()){
				case Cell.CELL_TYPE_NUMERIC:   //����
					String []mm=cell.toString().split("-");
					if(mm.length>2){
						SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
						Date doubleValue1= cell.getDateCellValue();
						returnValue=sdf.format(doubleValue1);
					}else{
						//��Ҫ������֤��֮�࣬Excel����� xxx,xxxx,xxx.0,�����ڴ�ת��һ��
						NumberFormat nf = NumberFormat.getInstance();
						Double doubleValue = cell.getNumericCellValue();
						String str=nf.format(doubleValue);
						str = str.replace(".0", "");
						returnValue = str.replace(",", "");
					}
					break;
				case Cell.CELL_TYPE_STRING:    //�ַ���
					returnValue = cell.getStringCellValue().trim().replaceAll("\\s+", "pp");
					break;
				case Cell.CELL_TYPE_BOOLEAN:   //����
					Boolean booleanValue=cell.getBooleanCellValue();
					returnValue = booleanValue.toString();
					break;
				case Cell.CELL_TYPE_BLANK:     // ��ֵ
					returnValue = "";
					break;
				case Cell.CELL_TYPE_FORMULA:   // ��ʽ
					returnValue = cell.getCellFormula();
					break;
				case Cell.CELL_TYPE_ERROR:     // ����
					returnValue = "";
					break;
				default:
					System.out.println("δ֪����");
					break;
			}
		}
		return returnValue;
	}
}
