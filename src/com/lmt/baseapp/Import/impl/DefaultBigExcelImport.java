package com.lmt.baseapp.Import.impl;

import java.sql.SQLException;
import java.util.List;

import com.lmt.baseapp.Import.base.ExcelHandler;
import com.lmt.baseapp.Import.base.XxlsAbstract;
import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class DefaultBigExcelImport extends XxlsAbstract{
	/**
	 * ����xls �����ݲ������ݱ���
	 * @throws Exception 
	 */
	public DefaultBigExcelImport(Transaction Sqlca, String files,ASUser CurUser) throws Exception {
		super(Sqlca, files,new ExcelHandler(Sqlca,CurUser));
	}
	public boolean checkObj() throws Exception{
		boolean isPass=true;
		/*
		int currentrow=this.ERS.getCurrentRow()+1;
		//����Ѻ���Ų���Ϊ��
		String sImpawnID1=DataConvert.toString(this.getERS().getStringWH(""));
		String sImpawnID2=DataConvert.toString(this.ERS.getStringWH("��Ѻ����"));
		if(sImpawnID1.length()==0&&sImpawnID2.length()==0){
			//throw new Exception("��ȷ�ϱ���"+this.ERS.getSheet().getName()+"���е�"+currentrow+"��---"+(this.ERS.getRowSize()-1)+"���������У�����ǵ�Ѻ���Ż���Ѻ���Ų���Ϊ�գ�������ѡ����Щ�е���Ҽ�����ɾ����");
			isPass=false;
		}
		//�Ŀ�ƾ֤�Ų���Ϊ��
		String sPackageNo=DataConvert.toString(this.ERS.getStringWH("�Ŀ�ƾ֤���"));
		if(sPackageNo.length()==0){
			//throw new Exception("��ȷ�ϱ���"+this.ERS.getSheet().getName()+"���е�"+currentrow+"��---"+(this.ERS.getRowSize()-1)+"���������У�����ǣ��Ŀ�ƾ֤��Ų���Ϊ�գ�������ѡ����Щ�е���Ҽ�����ɾ����");
			isPass=false;
		}
		//�Ŀ�ƾ֤�Ų���Ϊ��
		String sRightDoc=DataConvert.toString(this.ERS.getStringWH("Ȩ֤����"));
		String sRightDocNo=DataConvert.toString(this.ERS.getStringWH("Ȩ֤���"));
		if(sRightDoc.length()==0||sRightDocNo.length()==0){
			//throw new Exception("��ȷ�ϱ���"+this.ERS.getSheet().getName()+"���е�"+currentrow+"��---"+(this.ERS.getRowSize()-1)+"���������У�����ǣ��Ŀ�ƾ֤��Ų���Ϊ�գ�������ѡ����Щ�е���Ҽ�����ɾ����");
			isPass=false;
		}
		//������Ѻ�����ͱ���ͱ�����ͬ
		String sImpawnType1=DataConvert.toString(this.ERS.getStringWH("��Ѻ������"));
		String sImpawnType2=DataConvert.toString(this.ERS.getStringWH("��Ѻ������"));
		String sSheetName=this.ERS.getSheet().getName();
		if(!sImpawnType1.equals(this.ERS.getSheet().getName())&&!sImpawnType2.equals(this.ERS.getSheet().getName())){
			throw new Exception("��ȷ�ϱ���"+sSheetName+"������������е�"+currentrow+"��-"+this.ERS.getRowSize()+"�С���Ѻ�����͡�����Ѻ�����͡��Ƿ�һ��?���������������ѡ����Щ�е���Ҽ�����ɾ����");
		}
		*/
		return isPass;
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
		String insertSql="insert into Batch_Case_Import("+
				column+
				")"+
				"values("+
				columnf+
				")";
		ps= Sqlca.conn.prepareStatement(insertSql);
	}
	/**
	 * ƴ��SQL
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
				ps.setDouble(i+1, this.getERS().getDouble(i));
			}else{
				ps.setString(i+1, this.getERS().getString(i));
			}
		}
		this.iCount++;
		ps.addBatch();
	}
}