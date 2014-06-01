package com.lmt.baseapp.Import.impl;

import com.lmt.frameapp.sql.Transaction;
public class AfterImportHandlerFactory{
	public static void handle(String Handler,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception{
		if("CUSTOMER".equals(Handler)){
			AfterImportHandlerFactory.customerHandle(sConfigNo, sOneKey, Sqlca);
		}else if("CONTRACT".equals(Handler)){
			AfterImportHandlerFactory.contractHandle(sConfigNo, sOneKey, Sqlca);
		}else if("DUEBILL".equals(Handler)){
			AfterImportHandlerFactory.dueBillHandle(sConfigNo, sOneKey, Sqlca);
		}
	}
	/**
	 * �ͻ���Ϣ�������
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void customerHandle(String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		AfterImportCustomerHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//�����Ŀ��� 
		/*Sqlca.executeSQL("Delete from Batch_Import_Process where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	 	String groupBy="case when ~s��ͬ��ϸ@����������ʽe~ like '%��֤%' and ~s��ͬ��ϸ@����������ʽe~ like '%���Ѻ%' then '��֤+���Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ like '%��֤%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' then '��֤+����Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '��֤' then '��һ��֤' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ like '%����%' and ~s��ͬ��ϸ@����������ʽe~ like '%���Ѻ%' then '����+���Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '����' then '��һ����' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '��Ѻ' then '��һ��Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '��Ѻ' then '��һ��Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' then '��Ѻ+��Ѻ' "+
	 			"else '��������' end";
	 	AfterImportCustomerHandler.process(sConfigNo, sOneKey, Sqlca,"��ϵ�����ʽ",groupBy);
	 	//4���ӹ��󣬽��кϼƣ������������
	 	AfterImportCustomerHandler.afterProcess(sConfigNo, sOneKey, Sqlca);
	 	*/
	}
	/**
	 * ��ͬ�������
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void contractHandle(String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		AfterImportContractHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//�����Ŀ��� 
		Sqlca.executeSQL("Delete from Batch_Import_Process where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	 	String groupBy="case when ~s��ͬ��ϸ@����������ʽe~ like '%��֤%' and ~s��ͬ��ϸ@����������ʽe~ like '%���Ѻ%' then '��֤+���Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ like '%��֤%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' then '��֤+����Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '��֤' then '��һ��֤' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ like '%����%' and ~s��ͬ��ϸ@����������ʽe~ like '%���Ѻ%' then '����+���Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '����' then '��һ����' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '��Ѻ' then '��һ��Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '��Ѻ' then '��һ��Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' then '��Ѻ+��Ѻ' "+
	 			"else '��������' end";
	 	AfterImportContractHandler.process(sConfigNo, sOneKey, Sqlca,"��ϵ�����ʽ",groupBy);
	 	//4���ӹ��󣬽��кϼƣ������������
	 	AfterImportContractHandler.afterProcess(sConfigNo, sOneKey, Sqlca);
	}
	/**
	 * ��ݵ������
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void dueBillHandle(String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		AfterImportDuebillHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//���Ŀ��� 
		Sqlca.executeSQL("Delete from Batch_Import_Process where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		
		AfterImportDuebillHandler.process(sConfigNo, sOneKey, Sqlca,"��������","~s�����ϸ@��������e~");
 		String groupBy="case "+
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '%ú̿����%' or ~s�����ϸ@��Ӫ����(��)e~ like '%ú̿ϴѡ%' then 'ú̿' "+
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '%��̼%' then '��̼' "+//��̼��
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '%����ҵ%' or ~s�����ϸ@��Ӫ����(��)e~ like '%һ��ӹ�%' then '����ҵ' "+//����ҵ��
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '%��������%' then '��������' "+//�������ۡ�
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '%����%' then '����' "+
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '%��������%' then '��������' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '%���ز�%' then '���ز�' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '%����ʩ��%' then '����ʩ��' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '%���󿪲�%' then '���󿪲�' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '%ũ��������%' then 'ũ��������' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '%����ƽ̨%' then '����ƽ̨' "+
				"when ~s�����ϸ@��Ӫ����(��)e~ like '%��ó��%' or ~s�����ϸ@��Ӫ����(��)e~ like '%�ֲ�����%' then '��ó��' "+
				"when ~s�����ϸ@��Ӫ����(��)e~ like '%ҽҩ����%' then 'ҽҩ����' "+
				"when ~s�����ϸ@��Ӫ����(��)e~ like '%ȼ�������͹�Ӧ%' then 'ȼ�������͹�Ӧ' "+
				"when ~s�����ϸ@��Ӫ����(��)e~ like '%����ά�޼�����%' then '����ά�޼�����' "+
				"when ~s�����ϸ@��Ӫ����(��)e~ like '%����%' then '����' "+
				"when ~s�����ϸ@��Ӫ����(��)e~ like '%ס�޲���%' then 'ס�޲���' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '%��ͨ����%' then '��ͨ����' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '%ҽԺѧУ%' then 'ҽԺѧУ' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '%��Ϣ����%' then '��Ϣ����' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '%�Ļ�����%' then '�Ļ�����' "+
				"when ~s�����ϸ@��Ӫ����(��)e~ like '%��ɫұ��%' then '��ɫұ��' "+
	 			"else '����' end";
	 	AfterImportDuebillHandler.process(sConfigNo, sOneKey, Sqlca,"��Ӫ����(��)",groupBy);
	 	
	 	groupBy="case when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=6  then '1M6]' "+
	 						"when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=12 then '2M(6-12]' "+
	 						"when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=36 then '3M(12-36]' "+
	 						"when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=60 then '4M(36-60]' "+
	 						"else '5M(60' end,~s�����ϸ@ҵ��Ʒ��e~";
	 	AfterImportDuebillHandler.process(sConfigNo, sOneKey, Sqlca,"����ҵ��Ʒ��",groupBy);
	 	
	 	groupBy="case when ~s�����ϸ@��Ҫ������ʽe~ like '��֤-%' then '��֤' "+
	 			"when ~s�����ϸ@��Ҫ������ʽe~ like '��Ѻ-%' then '��Ѻ' "+
	 			"when ~s�����ϸ@��Ҫ������ʽe~ = '����' then '����' "+
	 			"when ~s�����ϸ@��Ҫ������ʽe~ like '%��Ѻ-%' or ~s�����ϸ@��Ҫ������ʽe~='��֤��' then '��Ѻ' "+
	 			"else '����' end";
	 	AfterImportDuebillHandler.process(sConfigNo, sOneKey, Sqlca,"��һ������ʽ",groupBy);
	 	//groupBy="case when case when ~s�����ϸ@��Ҫ������ʽe~='���Ѻ'  then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=6 end then ���������� "+
			//		"when case when ~s�����ϸ@������e~>0 then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=12 end then ʮ����������"+
			//		"when case when ~s�����ϸ@������e~>0 then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=36 end then ��ʮ����������"+
			//		"when case when ~s�����ϸ@������e~>0 then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=60 end then ��ʮ��������"+
			//		"else case when ~s�����ϸ@������e~>0 then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=6 end then ��ʮ�������� end,~s�����ϸ@ҵ��Ʒ��e~";
	 	//AfterImport.process(sConfigNo, sOneKey, Sqlca,"��ϵ�����ʽ",groupBy);
	 	AfterImportDuebillHandler.process(sConfigNo, sOneKey, Sqlca,"��ҵ��ģ","~s�����ϸ@��ҵ��ģe~");
	 	
	 	AfterImportDuebillHandler.process(sConfigNo, sOneKey, Sqlca,"ҵ��Ʒ��","~s�����ϸ@ҵ��Ʒ��e~");
	 	
	 	groupBy="case when ~s�����ϸ@���ҵ���e~ like '%̫ԭ��%' then '̫ԭ��' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then '������' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then '������' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%˷����%' then '˷����' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%�ٷ���%' then '�ٷ���' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then '������' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%�˳���%' then '�˳���' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then '������' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%��ͬ��%' then '��ͬ��' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then '������' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%��Ȫ��%' then '��Ȫ��' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%ʯ��ׯ��%' then 'ʯ��ׯ��' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%�人��%' then '�人��' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%��ɽ��%' then '��ɽ��' "+
	 			"else '��������' end";
	 	AfterImportDuebillHandler.process(sConfigNo, sOneKey, Sqlca,"��������",groupBy);
	 	
	 	AfterImportDuebillHandler.process(sConfigNo, sOneKey, Sqlca,"��������","~s�����ϸ@ֱ��������e~");
	 	//����������
	 	groupBy="case when ~s�����ϸ@���(Ԫ)e~ >=500000000 then '5�����ϣ���5�ڣ�' "+
	 			"when ~s�����ϸ@���(Ԫ)e~ >=300000000 then '3����5�ڣ���3�ڣ�' "+
	 			"when ~s�����ϸ@���(Ԫ)e~ >=200000000 then '2����3�ڣ���2�ڣ�' "+
	 			"when ~s�����ϸ@���(Ԫ)e~ >=100000000 then '1����2�ڣ���1�ڣ�' "+
	 			"when ~s�����ϸ@���(Ԫ)e~ >=50000000 then '5000����1�ڣ���5000��' "+
	 			"else '5000������' end";
	 	AfterImportDuebillHandler.process(sConfigNo, sOneKey, Sqlca,"�����������",groupBy);
	 	
	 	
	 	//4���ӹ��󣬽��кϼƣ������������
	 	AfterImportDuebillHandler.afterProcess(sConfigNo, sOneKey, Sqlca);
	}
}