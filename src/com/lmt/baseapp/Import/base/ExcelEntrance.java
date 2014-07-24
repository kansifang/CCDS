package com.lmt.baseapp.Import.base;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.lmt.baseapp.Import.impl.AIHandlerFactory;
import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.DBFunction;
import com.lmt.frameapp.sql.Transaction;
/**
 * 
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class ExcelEntrance implements EntranceImpl{
	private String sImportTableName="";
	private DBHandler HDB=null;
	private ObjRow OR=null;
	private ExcelHandler EH=null;
	private ASUser CurUser=null;
	// 
	protected Transaction Sqlca = null;
	private String[] files = null;
	public ExcelEntrance(){
		
	}
	/**
	 * 解析xls 将数据插入数据表中
	 * @throws SQLException 
	 */
	public ExcelEntrance(String files,String ImportTableName,ASUser CurUser,Transaction Sqlca) throws SQLException {
		this.files = files.split("~");
		this.sImportTableName = ImportTableName;
		this.CurUser=CurUser;
		this.Sqlca = Sqlca;
	}
	
	public void actionBefore(String configNo,String Key) throws Exception {//批量主键，标示不同类型批量
		//把上一批置上最新标志，刚刚导入的为N开头的
		String sNImportNo=DBFunction.getSerialNo(this.sImportTableName,"ImportNo","'O'yyyyMMdd","000000",new Date(),Sqlca);
	 	Sqlca.executeSQL("update "+this.sImportTableName+" set ImportNo='"+sNImportNo+"' where ConfigNo='"+configNo+"' and OneKey='"+Key+"' and ImportNo like 'N%000000'");
	 	//初始化数据结构  一次导入对应一个模板定义，对应一个PS
		//初始化head属性
	 	this.OR=new ObjRow(configNo,Key,this.CurUser,this.Sqlca);
	 	this.EH=new ExcelHandler(OR,Sqlca);
		this.HDB=new DBHandler(sImportTableName,OR,Sqlca);
		//this.EH.initMeta(configNo,Key,this.CurUser);
		//初始化PreparedStatement
	}
	public void action(String configNo,String Key) throws Exception {
		actionBefore(configNo,Key);
		for(String sFilePathName:this.files){
			process(sFilePathName);
		}
		this.HDB.end();
	}
	/** 
     * 处理一个 文件 
     */  
    private void process(String fileName) throws Exception { 
    	Workbook workbook = null;
    	if(fileName.endsWith(".xls")){
			workbook = new HSSFWorkbook(new BufferedInputStream(new FileInputStream(new java.io.File(fileName))));
		}else if(fileName.endsWith(".xlsx")){
			workbook = new XSSFWorkbook(new BufferedInputStream(new FileInputStream(new java.io.File(fileName))));
		}
		for (int i=0;i<workbook.getNumberOfSheets();i++) {
			Sheet sheet=workbook.getSheetAt(i);
			int rownum=sheet.getLastRowNum();
			if(rownum==0){
				continue;
			}
			this.EH.setSheet(sheet);
			//sheet标题头不符合要求就直接直接回退整个导入,没商量，完善去(此方法会报异常的)
			this.EH.checkMeta();
			//初始化必要的值
			this.EH.initPara();
			while(this.EH.next()){
				//sheet即使有一条记录不符合要求就直接回退整个导入,没商量，完善去(此方法会报异常的)
				this.HDB.saveToDB();
			}
		}
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