package com.amarsoft.datainit.batchno;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.datainit.importobj.ObjImportImpl;
/**
 * 
 * @author bllou 2012/08/13
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class BatchNoInitialize {
	// Text����ͷ�����ݿ��Ӧ�ı�
	// װ��������
	private Transaction Sqlca = null;
	private ObjImportImpl OII=null;
	private ASUser CurUser=null;
	/**
	 * ����xls �����ݲ������ݱ���
	 */
	public BatchNoInitialize(Transaction Sqlca, String[] files,ASUser CurUser)throws Exception {
		this.Sqlca = Sqlca;
		this.CurUser = CurUser;
		this.OII = new BatchNoTextImport(Sqlca,files,CurUser);
	}
	public void handle() throws Exception {
		//0����Text�������ݿ�
		this.OII.action();
	}
}