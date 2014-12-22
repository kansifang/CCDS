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
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class TextEntrance implements EntranceImpl {
	private String sImportTableName="";
	private DBHandler HDB=null;
	private ObjRow OR=null;
	private TextHandler TH=null;
	private ASUser CurUser=null;
	// װ��������
	protected Transaction Sqlca = null;
	private String[] files = null;
	/**
	 * ����xls �����ݲ������ݱ���
	 */
	public TextEntrance(String files,String ImportTableName,ASUser CurUser,Transaction Sqlca) {
		this.files = files.split("~");
		this.sImportTableName = ImportTableName;
		this.CurUser=CurUser;
		this.Sqlca = Sqlca;
	}
	public void actionBefore(String configNo,String Key) throws Exception {//������������ʾ��ͬ��������
		//����һ���������±�־���ոյ����ΪN��ͷ��----Ŀǰû��Ҫ���������¼���¼�¼����ɾ���ϼ�¼����
		//String sNImportNo=DBFunction.getSerialNo(this.sImportTableName,"ImportNo","'O'yyyyMMdd","000000",new Date(),Sqlca);
	 	//Sqlca.executeSQL("update "+this.sImportTableName+" set ImportNo='"+sNImportNo+"' where ConfigNo='"+configNo+"' and OneKey='"+Key+"' and ImportNo like 'N%000000'");
	 	//��ʼ�����ݽṹ  һ�ε����Ӧһ��ģ�嶨�壬��Ӧһ��PS
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
     * ����һ�� �ļ� 
     */  
    private void process(String fileName) throws Exception { 
		BufferedReader br = new BufferedReader(new FileReader(fileName));
		this.TH.setReader(br);
		this.TH.setFixLengthMode(true);
		//��ʼ����Ҫ��ֵ
		this.TH.initPara();
		while(this.TH.next()){
			//sheet��ʹ��һ����¼������Ҫ���ֱ�ӻ�����������,û����������ȥ(�˷����ᱨ�쳣��)
			this.HDB.saveToDB();
		}
    }
}