package com.lmt.baseapp.Import.base;

import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.lmt.frameapp.sql.Transaction;
/**
 * 
 * @author bllou 2012/08/13
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class DBHandler{
	private ObjRow or=null;
	protected PreparedStatement ps=null;
	protected String sImportTableName="";
	protected int iCount=0;
	// 
	protected Transaction Sqlca = null;
	/**
	 * ����xls �����ݲ������ݱ���
	 * @throws SQLException 
	 */
	public DBHandler(String ImportTableName,ObjRow or,Transaction Sqlca) throws Exception {
		this.or = or;
		this.sImportTableName=ImportTableName;
		this.Sqlca = Sqlca;
		initPS();
	}
	
	public void initPS() throws Exception {
		String column="",columnf="";
		for(int i=0;i<or.getColumnTCount();i++){
			column+=or.getColumnObjWI(i).getColumnName()+",";
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
		this.ps= this.Sqlca.conn.prepareStatement(insertSql);
	}
	public void saveToDB() throws Exception {
		//sheet��ʹ��һ����¼������Ҫ���ֱ�ӻ�����������,û����������ȥ(�˷����ᱨ�쳣��)
		//OHRI.checkObj();
		//OHRI.optRow();
		for(int j=0;j<or.getColumnTCount();j++){
			String columnType=or.getColumnType(j);
			if("Number".equals(columnType)){
				System.out.println(or.getDouble(j));
				ps.setDouble(j+1, or.getDouble(j));
			}else{
				System.out.println(or.getString(j));
				ps.setString(j+1, or.getString(j));
			}
		}
		this.iCount++;
		ps.addBatch();
		if (this.iCount >=500) {
			ps.executeBatch();
			this.iCount=0;
		}
	}
	public void end() throws Exception {
		if(ps!=null){
			// try{
				ps.executeBatch();
			//}catch(SQLException e){
			//	System.out.println(e.getNextException());
			//}
			ps.close();
			ps=null;
		}
	}
	public PreparedStatement getPs(){
		return ps;
	}
	public void setPs(PreparedStatement ps){
		this.ps = ps;
	}
	//1��һ���ļ���Ӧһ��MetaData
	//private String getModelNo(String sFilePathName){
		//sFilePathName=/temp/als6/Upload/yyyy/mm/dd/modelno/docno_attachmentno_filename.*
		   //String sTempPath=StringFunction.replace(sFilePathName, this.fileName,"");
		//�õ�/temp/als6/Upload/yyyy/mm/dd/modelno/
		   //sTempPath=sTempPath.substring(0,sTempPath.length()-1);
		//�õ�modelno
		   //return StringFunction.getFileName(sTempPath);
	//}
}