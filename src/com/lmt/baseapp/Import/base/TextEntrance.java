package com.lmt.baseapp.Import.base;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.FileReader;
import java.sql.PreparedStatement;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.sql.Transaction;
/**
 * 
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class TextEntrance implements EntranceImpl {
	private String sImportTableName="";
	private DBHandler HDB=null;
	private ObjRow OR=null;
	private TextHandler TH=null;
	private ASUser CurUser=null;
	// 装各下拉框
	protected Transaction Sqlca = null;
	private String[] files = null;
	/**
	 * 解析xls 将数据插入数据表中
	 */
	public TextEntrance(String files,String ImportTableName,ASUser CurUser,Transaction Sqlca) {
		this.files = files.split("~");
		this.sImportTableName = ImportTableName;
		this.CurUser=CurUser;
		this.Sqlca = Sqlca;
	}
	public void actionBefore(String configNo,String Key) throws Exception {//批量主键，标示不同类型批量
		//把上一批置上最新标志，刚刚导入的为N开头的----目前没必要保留导入记录，新纪录导入删除老记录即可
		//String sNImportNo=DBFunction.getSerialNo(this.sImportTableName,"ImportNo","'O'yyyyMMdd","000000",new Date(),Sqlca);
	 	//Sqlca.executeSQL("update "+this.sImportTableName+" set ImportNo='"+sNImportNo+"' where ConfigNo='"+configNo+"' and OneKey='"+Key+"' and ImportNo like 'N%000000'");
	 	//初始化数据结构  一次导入对应一个模板定义，对应一个PS
	 	this.OR=new ObjRow(configNo,Key,this.CurUser,this.Sqlca);
	 	this.TH=new TextHandler(OR,this.Sqlca);
		this.HDB=new DBHandler(sImportTableName,OR,Sqlca);
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
		BufferedReader br = new BufferedReader(new FileReader(fileName));
		this.TH.setReader(br);
		this.TH.setFixLengthMode(true);
		//初始化必要的值
		this.TH.initPara();
		while(this.TH.next()){
			//sheet即使有一条记录不符合要求就直接回退整个导入,没商量，完善去(此方法会报异常的)
			this.HDB.saveToDB();
		}
    }
}