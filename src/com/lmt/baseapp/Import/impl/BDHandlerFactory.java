package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.sql.Transaction;
public class BDHandlerFactory{
	public static void beforeHandle(String HandlerFlag,String sReportConfigNo,String sOneKey,ASUser CurUser,Transaction Sqlca)throws Exception{
		//�����Ŀ��� 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey='"+sOneKey+"'");
	}
	public static void handle(String HandlerFlag,String sReportConfigNo,String sOneKey,ASUser CurUser,Transaction Sqlca) throws Exception{
		BDHandlerFactory.beforeHandle(HandlerFlag,sReportConfigNo,sOneKey,CurUser,Sqlca);
		//Ŀǰֻ�з��ձ�����չʾǰ���ٴ���
		if("RiskReport".toUpperCase().equals(HandlerFlag)){//ȫ����ձ���
			BDHandlerFactory.riskReportHandle(HandlerFlag,sReportConfigNo, sOneKey, Sqlca);
		}else if("SuperviseReport".toUpperCase().equals(HandlerFlag)){
			BDHandlerFactory.superviseReportHandle(HandlerFlag,sReportConfigNo, sOneKey, Sqlca);
		}else if("OperationReport".toUpperCase().equals(HandlerFlag)){//�¶Ⱦ�Ӫ������û�����ô���⴦������ʱ����
			BDHandlerFactory.operationReportHandle(HandlerFlag,sReportConfigNo, sOneKey, Sqlca);
		}
	}
	/**
	 * ���ձ������ݼӹ�
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void riskReportHandle(String HandlerFlag,String sReportConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		BDRiskReportHandler.interimProcess(sReportConfigNo, sOneKey, Sqlca);
		//�������ߣ����� ��˾һ�鿼�ǣ�
		String groupBy="case "+
				" when BusinessType like '%���' then '0-���' " +
				" when OperateOrgID='��Դ��ҵ��' then 'A-��Դ��ҵ��' " +
 				" when ManageDepartFlag is null or ManageDepartFlag='' or ManageDepartFlag = '��˾����' then 'B-��˾����' " +
 				" when ManageDepartFlag = 'С��ҵ����' then 'C-С��ҵ����'"+
 				" when ManageDepartFlag = '��������' then 'D-��������' end";
		BDRiskReportHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca,"��������","'һ�����',"+groupBy,"");
		//�弶���ࣨ���� ��˾һ�鿼�ǣ�
		groupBy="case "+
	 				" when Classify is null or Classify='' or Classify like '����%' then 'A-��������@������' " +
	 				" when Classify like '��ע%' then 'A-��������@��ע��'"+
	 				" when Classify like '�μ�%' then 'B-��������@�μ���' " +
	 				" when Classify like '����%' then 'B-��������@������'"+
	 				" when Classify like '��ʧ%' then 'B-��������@��ʧ��' end";
		BDRiskReportHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca,"�弶����",groupBy,"");
		//4���ӹ��󣬽��кϼƣ������������
	 	BDRiskReportHandler.afterProcess(HandlerFlag,sReportConfigNo, sOneKey, Sqlca);
	 	//����յ�
	 	BDRiskReportHandler.lastProcess(HandlerFlag,sReportConfigNo, sOneKey, Sqlca);
	}
	/**
	 * ���ȼ�ܱ������ݼӹ�
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void superviseReportHandle(String HandlerFlag,String sReportConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		BDSuperviseReportHandler.interimProcess(sReportConfigNo, sOneKey, Sqlca);
		//���ɶԹ���˽��ϸ
		BDSuperviseReportHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca,"�Թ���˽��ϸ","","");
	 	//4���ӹ��󣬽��кϼƣ������������
	 	BDSuperviseReportHandler.afterProcess(HandlerFlag,sReportConfigNo, sOneKey, Sqlca);
	}
	/**
	 * �¶Ⱦ�Ӫ���洦��
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void operationReportHandle(String HandlerFlag,String sReportConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		BDOperationReportHandler.interimProcess(sReportConfigNo, sOneKey, Sqlca);
		//
		BDOperationReportHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca);
	 	//4���ӹ��󣬽��кϼƣ������������
		BDOperationReportHandler.afterProcess(HandlerFlag,sReportConfigNo, sOneKey, Sqlca);
	}
	/**
	 * ��ݵ������
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void dueBillHandle(String HandlerFlag,String sReportConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		AIDuebillInHandler.interimProcess(sReportConfigNo, sOneKey, Sqlca);
		//���Ŀ��� 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey='"+sOneKey+"'");
		
		AIDuebillInHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca,"��������","~s�����ϸ@��������e~","");
		
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
	 	AIDuebillInHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca,"��Ӫ����(��)",groupBy,"");
	 	
	 	groupBy="case when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=6  then '1M6]' "+
	 						"when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=12 then '2M(6-12]' "+
	 						"when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=36 then '3M(12-36]' "+
	 						"when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=60 then '4M(36-60]' "+
	 						"else '5M(60' end,~s�����ϸ@ҵ��Ʒ��e~";
	 	AIDuebillInHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca,"����ҵ��Ʒ��",groupBy,"");
	 	
	 	groupBy="case when ~s�����ϸ@��Ҫ������ʽe~ like '��֤-%' then '��֤' "+
	 			"when ~s�����ϸ@��Ҫ������ʽe~ like '��Ѻ-%' then '��Ѻ' "+
	 			"when ~s�����ϸ@��Ҫ������ʽe~ = '����' then '����' "+
	 			"when ~s�����ϸ@��Ҫ������ʽe~ like '%��Ѻ-%' or ~s�����ϸ@��Ҫ������ʽe~='��֤��' then '��Ѻ' "+
	 			"else '����' end";
	 	AIDuebillInHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca,"��һ������ʽ",groupBy,"");
	 	//groupBy="case when case when ~s�����ϸ@��Ҫ������ʽe~='���Ѻ'  then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=6 end then ���������� "+
			//		"when case when ~s�����ϸ@������e~>0 then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=12 end then ʮ����������"+
			//		"when case when ~s�����ϸ@������e~>0 then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=36 end then ��ʮ����������"+
			//		"when case when ~s�����ϸ@������e~>0 then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=60 end then ��ʮ��������"+
			//		"else case when ~s�����ϸ@������e~>0 then ~s�����ϸ@������e~+1 else ~s�����ϸ@������e~<=6 end then ��ʮ�������� end,~s�����ϸ@ҵ��Ʒ��e~";
	 	//AfterImport.process(sReportConfigNo, sOneKey, Sqlca,"��ϵ�����ʽ",groupBy);
	 	AIDuebillInHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca,"��ҵ��ģ","~s�����ϸ@��ҵ��ģe~","");
	 	
	 	AIDuebillInHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca,"ҵ��Ʒ��","~s�����ϸ@ҵ��Ʒ��e~","");
	 	
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
	 	AIDuebillInHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca,"��������",groupBy,"");
	 	
	 	AIDuebillInHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca,"��������","~s�����ϸ@ֱ��������e~","");
	 	//����������
	 	groupBy="case when ~s�����ϸ@���(Ԫ)e~ >=500000000 then '5�����ϣ���5�ڣ�' "+
	 			"when ~s�����ϸ@���(Ԫ)e~ >=300000000 then '3����5�ڣ���3�ڣ�' "+
	 			"when ~s�����ϸ@���(Ԫ)e~ >=200000000 then '2����3�ڣ���2�ڣ�' "+
	 			"when ~s�����ϸ@���(Ԫ)e~ >=100000000 then '1����2�ڣ���1�ڣ�' "+
	 			"when ~s�����ϸ@���(Ԫ)e~ >=50000000 then '5000����1�ڣ���5000��' "+
	 			"else '5000������' end";
	 	AIDuebillInHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca,"�����������",groupBy,"");
	 	
	 	
	 	//4���ӹ��󣬽��кϼƣ������������
	 	AIDuebillInHandler.afterProcess(HandlerFlag,sReportConfigNo, sOneKey, Sqlca);
	}
	/**
	 * ���۽�ݵ������
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void dueBillRHandle(String HandlerFlag,String sReportConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		AIDuebillRetailHandler.interimProcess(sReportConfigNo, sOneKey, Sqlca);
		//���Ŀ��� 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sReportConfigNo+"' and OneKey='"+sOneKey+"'");
 		String groupBy="case "+
		 				" when ~s������ϸ@��������e~ ='��������' or ~s������ϸ@��������e~ = '΢С����' or ~s������ϸ@��������e~ = '��������' then '��������'"+
		 				" when ~s������ϸ@��������e~ = 'С��ҵ����' then 'С��ҵ����' "+
		 				" else '��������' end";
 		AIDuebillRetailHandler.process(HandlerFlag,sReportConfigNo, sOneKey, Sqlca,"��������",groupBy,"");
	 	//4���ӹ��󣬽��кϼƣ������������
 		AIDuebillRetailHandler.afterProcess(HandlerFlag,sReportConfigNo, sOneKey, Sqlca);
	}
}