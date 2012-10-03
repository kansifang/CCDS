package com.amarsoft.datainit.bail;

import java.sql.PreparedStatement;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.context.ASUser;
import com.amarsoft.datainit.importobj.CopyInfoUtil;
import com.amarsoft.datainit.importobj.ExcelImport;
/**
 * @author bllou 2012/08/13
 * @msg. Ʊ�ݱ�֤����Ϣ�����ʼ��
 */
public class BailExcelImport extends ExcelImport{
	private String[]sTables=new String[]{"Bail_WasteBook_Import"};
	
	/**
	 * ����xls �����ݲ������ݱ���
	 * @throws Exception 
	 */
	public BailExcelImport(Transaction Sqlca, String[] files,ASUser CurUser) throws Exception {
		super(Sqlca, files,new BailExcelResultSet(Sqlca,CurUser));
	}
	public boolean checkHead() throws Exception {
		return true;
	}
	public boolean checkObj() throws Exception{
		boolean isPass=true;
		int currentrow=this.ERS.getCurrentRow()+1;
		String sPutOutNo1=DataConvert.toString(this.ERS.getStringWH("Ʊ��"));
		String sPutOutNo2=DataConvert.toString(this.ERS.getStringWH("���κ�"));
		String sPutOutNo3=DataConvert.toString(this.ERS.getStringWH("ҵ����"));
		if(sPutOutNo1.length()==0&&sPutOutNo2.length()==0&&sPutOutNo3.length()==0){
			throw new Exception("�ļ���Ϊ"+this.fileName+"��EXCEL�ĵ�"+currentrow+"�У�Ʊ�Ż����κŻ�ҵ���Ų���Ϊ��");
		}
		String sBailAcctountNo=DataConvert.toString(this.ERS.getStringWH("��֤���˺�"));
		if(sBailAcctountNo.length()==0){
			throw new Exception("�ļ���Ϊ"+this.fileName+"��EXCEL�ĵ�"+currentrow+"�У���֤���˺Ų���Ϊ��");
		}
		String sSubAcct1=DataConvert.toString(this.ERS.getStringWH("�����˺�"));
		if(sSubAcct1.length()==0){
			throw new Exception("�ļ���Ϊ"+this.fileName+"��EXCEL�ĵ�"+currentrow+"�У������˺Ż�����Ϊ��");
		}
		return isPass;
	}
	/**
	 * ƴ��SQL
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public void importObj() throws Exception {
		//����excel���ݵ����ݿ���ʱ����
		for(String sTable:sTables){
			PreparedStatement ps=this.ERS.getPs().get(sTable);
			ps =CopyInfoUtil.copyInfo("insert",this.ERS,"select * from "+sTable,"",null,null, null, Sqlca, ps);
			ps.addBatch();
			this.ERS.getPs().put(sTable,ps);
			this.iCount++;
		}
	}
}