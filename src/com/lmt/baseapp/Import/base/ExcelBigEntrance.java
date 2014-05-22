package com.lmt.baseapp.Import.base;

import java.io.InputStream;
import java.sql.SQLException;
import java.util.Date;
import java.util.Iterator;

import org.apache.poi.openxml4j.opc.OPCPackage;
import org.apache.poi.xssf.eventusermodel.XSSFReader;
import org.apache.poi.xssf.model.SharedStringsTable;
import org.xml.sax.InputSource;
import org.xml.sax.XMLReader;
import org.xml.sax.helpers.XMLReaderFactory;

import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.DBFunction;
import com.lmt.frameapp.sql.Transaction;

public class ExcelBigEntrance implements EntranceImpl{
	private ASUser CurUser=null;
	protected String sImportTableName="";
	private ObjRow OR=null;
	private DBHandler HDB=null;
	protected Transaction Sqlca = null;
	private String[] files = null;
	public ExcelBigEntrance(String files,String ImportTableName,ASUser CurUser,Transaction Sqlca) throws SQLException {
		this.sImportTableName = ImportTableName;
		this.files = files.split("~");
		this.CurUser=CurUser;
		this.Sqlca = Sqlca;
	}
	public void actionBefore(String configNo,String Key) throws Exception {//批量主键，标示不同类型批量
		//把上一批置上最新标志，刚刚导入的为N开头的
		String sNImportNo=DBFunction.getSerialNo(this.sImportTableName,"ImportNo","'O'yyyyMMdd","000000",new Date(),Sqlca);
	 	Sqlca.executeSQL("update "+this.sImportTableName+" set ImportNo='"+sNImportNo+"' where ConfigNo='"+configNo+"' and Key='"+Key+"' and ImportNo like 'N%000000'");
	 	//初始化数据结构  一次导入对应一个模板定义，对应一个PS
		//初始化head属性
	 	this.OR=new ObjRow(configNo,Key,this.CurUser,this.Sqlca);
		this.HDB=new DBHandler(sImportTableName,OR,Sqlca);
	}
	public void action(String configNo,String Key) throws Exception {
		actionBefore(configNo,Key);
		for(String sFilePathName:this.files){
			OPCPackage pkg = OPCPackage.open(sFilePathName);
			XSSFReader r = new XSSFReader( pkg );
			SharedStringsTable sst = r.getSharedStringsTable();
			XMLReader parser = fetchSheetParser(sst,configNo,Key);

			Iterator<InputStream> sheets = r.getSheetsData();
			while(sheets.hasNext()) {
				System.out.println("Processing new sheet:\n");
				InputStream sheet = sheets.next();
				InputSource sheetSource = new InputSource(sheet);
				parser.parse(sheetSource);
				sheet.close();
				//System.out.println("");
			}
		}
		try{
			this.HDB.end();
		}catch(SQLException e){
			System.out.println(e.getNextException());
			throw e;
		}
	}

	public XMLReader fetchSheetParser(SharedStringsTable sst,String configNo,String Key) throws Exception {
		XMLReader parser =XMLReaderFactory.createXMLReader("org.apache.xerces.parsers.SAXParser");
		ExcelBigHandler handler = new ExcelBigHandler(this,sst);
		parser.setContentHandler(handler);
		return parser;
	} 
	
	public ObjRow getOR() {
		return OR;
	}
	public void setOR(ObjRow oR) {
		OR = oR;
	}
	public DBHandler getHDB() {
		return HDB;
	}
	public void setHDB(DBHandler hDB) {
		HDB = hDB;
	}
	public Transaction getSqlca() {
		return Sqlca;
	}
	public void setSqlca(Transaction sqlca) {
		Sqlca = sqlca;
	}
	public static void main(String[] args) throws Exception {
		//ExcelBigDateImport example = new ExcelBigDateImport();
		//example.processOneSheet("C:\\20140101_162227865.xlsx");
		// example.processAllSheets(args[0]);
	}
}