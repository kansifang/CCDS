package com.lmt.baseapp.Import.base;

import java.io.FileInputStream;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.DBFunction;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.sql.Transaction;
/**
 * 
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public  class ExcelImport implements ObjImportImpl{
	private ExcelResultSet ERS=null;
	protected PreparedStatement ps=null;
	private ASUser CurUser=null;
	protected String sImportTableName="";
	protected int iCount=0;
	// 装各下拉框
	protected Transaction Sqlca = null;
	private String[] files = null;
	protected String configNo="";
	private String Key="";//批量主键，标示不同类型批量
	/**
	 * 解析xls 将数据插入数据表中
	 * @throws SQLException 
	 */
	public ExcelImport(String files,String ImportTableName,ASUser CurUser,Transaction Sqlca) throws SQLException {
		this.files = files.split("~");
		this.sImportTableName=ImportTableName;
		this.CurUser=CurUser;
		this.Sqlca = Sqlca;
		this.ERS=new ExcelResultSet(Sqlca,CurUser);
	}
	public ExcelResultSet getERS() {
		return ERS;
	}
	public void setERS(ExcelResultSet eRS) {
		ERS = eRS;
	}
	public PreparedStatement getPs() {
		return ps;
	}
	public void setPs(PreparedStatement ps) {
		this.ps = ps;
	}
	public void action(String configNo,String Key) throws Exception {
		//把上一批置上最新标志，刚刚导入的为N开头的
		String sNImportNo=DBFunction.getSerialNo(this.sImportTableName,"ImportNo","'O'yyyyMMdd","000000",new Date(),Sqlca);
	 	Sqlca.executeSQL("update "+this.sImportTableName+" set ImportNo='"+sNImportNo+"' where ConfigNo='"+this.configNo+"' and Key='"+this.Key+"' and ImportNo like 'N%000000'");
	 	//初始化数据结构  一次导入对应一个模板定义，对应一个PS
		//初始化head属性
		this.ERS.initMeta(configNo,Key);
		//初始化PreparedStatement
		this.prepare();
		Workbook workbook = null;
		for(String sFilePathName:this.files){
			String fileName=StringFunction.getFileName(sFilePathName);
			if(fileName.endsWith(".xls")){
				workbook = new HSSFWorkbook(new FileInputStream(new java.io.File(sFilePathName)));
			}else if(fileName.endsWith(".xlsx")){
				workbook = new XSSFWorkbook(new FileInputStream(new java.io.File(sFilePathName)));
			}
			for (int i=0;i<workbook.getNumberOfSheets();i++) {
				Sheet sheet=workbook.getSheetAt(i);
				int rownum=sheet.getLastRowNum();
				if(rownum==0){
					continue;
				}
				this.ERS.setSheet(sheet);
				//sheet标题头不符合要求就直接直接回退整个导入,没商量，完善去(此方法会报异常的)
				this.ERS.checkMeta();
				//初始化必要的值
				this.ERS.initPara();
				while(this.ERS.next()){
					//sheet即使有一条记录不符合要求就直接回退整个导入,没商量，完善去(此方法会报异常的)
					this.checkObj();
					this.importRow();
					if (this.iCount >=500) {
						ps.executeBatch();
						this.iCount=0;
					}
				}
			}
		}
		if(ps!=null){
			//try{
				ps.executeBatch();
			//}catch(SQLException e){
			//	System.out.println(e.getNextException());
			//}
			ps.close();
			ps=null;
		}
	}
	public void prepare() throws Exception {
		int columnl=this.getERS().getColumnTCount();
		String column="",columnf="";
		for(int i=0;i<columnl;i++){
			column+=this.getERS().getColumnObjWI(i).getColumnName()+",";
			columnf+="?,";
		}
		column =column.substring(0, column.length()-1);
		columnf =columnf.substring(0, columnf.length()-1);
		String insertSql="insert into "+this.sImportTableName+"("+
				column+
				")"+
				"values("+
				columnf+
				")";
		ps= Sqlca.conn.prepareStatement(insertSql);
	}
	public boolean checkObj() throws Exception{
		return true;
	}
	/**
	 * 拼接SQL
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public void importRow() throws Exception {
		int columnl=this.getERS().getColumnTCount();
		for(int i=0;i<columnl;i++){
			String columnType=this.getERS().getColumnType(i);
			if("Number".equals(columnType)){
				ps.setDouble(i+1,this.getERS().getDouble(i));
			}else{
				ps.setString(i+1, this.getERS().getString(i));
			}
		}
		this.iCount++;
		ps.addBatch();
	}
	//1、一个文件对应一个MetaData
	//private String getModelNo(String sFilePathName){
		//sFilePathName=/temp/als6/Upload/yyyy/mm/dd/modelno/docno_attachmentno_filename.*
		   //String sTempPath=StringFunction.replace(sFilePathName, this.fileName,"");
		//得到/temp/als6/Upload/yyyy/mm/dd/modelno/
		   //sTempPath=sTempPath.substring(0,sTempPath.length()-1);
		//得到modelno
		   //return StringFunction.getFileName(sTempPath);
	//}
}