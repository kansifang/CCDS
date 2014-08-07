package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.Import.base.EntranceImpl;
import com.lmt.baseapp.Import.base.ExcelBigEntrance;
import com.lmt.baseapp.Import.base.ExcelEntrance;
import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.sql.Transaction;
public class AIHandlerFactory{
	public static void beforeHandle(String sFiles,String sFileType,String HandlerFlag,String sConfigNo,String sOneKey,ASUser CurUser,Transaction Sqlca)throws Exception{
		if("01".equals(sFileType)){//С��excel
			//�����ļ���ԭʼ��ʼ�ձ���ԭ��ԭζ
	 		Sqlca.executeSQL("Delete from Batch_Import where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		 	EntranceImpl efih=new ExcelEntrance(sFiles,"Batch_Import",CurUser,Sqlca);
		 	efih.action(sConfigNo,sOneKey);
			//�ٵ��뵽�м�����Խ��мӹ�
		 	Sqlca.executeSQL("Delete from Batch_Import_Interim where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		 	EntranceImpl efih_Iterim=new ExcelEntrance(sFiles,"Batch_Import_Interim",CurUser,Sqlca);
		 	efih_Iterim.action(sConfigNo,sOneKey);
		}else if("03".equals(sFileType)){//����Excel
			//�����ļ���ԭʼ��ʼ�ձ���ԭ��ԭζ
	 		Sqlca.executeSQL("Delete from Batch_Import where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		 	EntranceImpl efih=new ExcelBigEntrance(sFiles,"Batch_Import",CurUser,Sqlca);
		 	efih.action(sConfigNo,sOneKey);
			//�ٵ��뵽�м�����Խ��мӹ�
		 	Sqlca.executeSQL("Delete from Batch_Import_Interim where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
		 	EntranceImpl efih_Iterim=new ExcelBigEntrance(sFiles,"Batch_Import_Interim",CurUser,Sqlca);
		 	efih_Iterim.action(sConfigNo,sOneKey);
		}
		//�������úźͱ�������
 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and ImportNo like 'N%000000'");
		//���Ŀ��� 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	}
	public static void handle(String sFiles,String sFileType,String HandlerFlag,String sConfigNo,String sOneKey,ASUser CurUser,Transaction Sqlca) throws Exception{
		//�ȵ��뵽���ݿ�,�����Ŀ���Ϊ���ݴ�����׼��
		AIHandlerFactory.beforeHandle(sFiles, sFileType,HandlerFlag, sConfigNo, sOneKey, CurUser, Sqlca);
		//�����ݽ��г����ӹ�
		if("Customer".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.customerHandle(sConfigNo, sOneKey, Sqlca);
		}else if("Contract".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.contractHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("Duebill".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.dueBillInHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("DuebillOut".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.dueBillOutHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("DuebillR".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.dueBillRHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("OperationReport".toUpperCase().equals(HandlerFlag)){
			AIHandlerFactory.operationReportHandle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
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
		AICustomerHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		/*
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
	private static void contractHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		AIContractHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
	 	String groupBy="case when ~s��ͬ��ϸ@����������ʽe~ like '%��֤%' and ~s��ͬ��ϸ@����������ʽe~ like '%���Ѻ%' then '��֤+���Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ like '%��֤%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' then '��֤+����Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '��֤' then '��һ��֤' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ like '%����%' and ~s��ͬ��ϸ@����������ʽe~ like '%���Ѻ%' then '����+���Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '����' then '��һ����' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '��Ѻ' then '��һ��Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ = '��Ѻ' then '��һ��Ѻ' "+
	 			"when ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' and ~s��ͬ��ϸ@����������ʽe~ like '%��Ѻ%' then '��Ѻ+��Ѻ' "+
	 			"else '��������' end";
	 	AIContractHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"��ϵ�����ʽ",groupBy);
	 	//4���ӹ��󣬽��кϼƣ������������
	 	AIContractHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	/**
	 * ���ڽ�ݵ������
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void dueBillInHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		AIDuebillInHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		AIDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"��������","~s�����ϸ@��������e~","");
 		String groupBy="case "+
 				"when ~s�����ϸ@��Ӫ����(��)e~ is null or ~s�����ϸ@��Ӫ����(��)e~ = '' or ~s�����ϸ@��Ӫ����(��)e~='����' then 'V-����' "+
 				"when ~s�����ϸ@��Ӫ����(��)e~ like 'ú̿����' then 'A-ú̿@����'" +
 				"when ~s�����ϸ@��Ӫ����(��)e~ like 'ú̿ϴѡ' then 'A-ú̿@ϴѡ' "+
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '��̼����������' then 'B-��̼@��������' "+//��̼��
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '��̼��ú��һ��' or ~s�����ϸ@��Ӫ����(��)e~ = '��̼' then 'B-��̼@ú��һ��' "+//��̼��
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '��̼������һ��' then 'B-��̼@����һ��' "+//��̼��
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '��̼�����ڱ���' then 'B-��̼@���ڱ���' "+//��̼��
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '��̼����Դ��' then 'B-��̼@��Դ��' "+//��̼��
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '��̼���Ȼ���' then 'B-��̼@�Ȼ���' "+//��̼��
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '��������%' then 'C-��������' "+//�������ۡ�
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '����ҵ��ˮ��' then 'D-����ҵ@ˮ��' "+//����ҵ��
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '����ҵ��ƽ�岣��' then 'D-����ҵ@ƽ�岣��' "+//����ҵ��
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '����ҵ%' then 'D-����ҵ@����' "+//����ҵ��
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '����' then 'E-����' "+
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '���ز�' then 'F-���ز�' "+
 				"when ~s�����ϸ@��Ӫ����(��)e~ like '��������' then 'G-��������' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '����ʩ��' or ~s�����ϸ@��Ӫ����(��)e~ like '���̽���' or ~s�����ϸ@��Ӫ����(��)e~ like '��������' then 'H-����ʩ��' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '���󿪲�' then 'I-���󿪲�' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like 'ũ��������' then 'J-ũ��������' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '����ƽ̨' then 'K-����ƽ̨' "+
				"when ~s�����ϸ@��Ӫ����(��)e~ like '��ó��' or ~s�����ϸ@��Ӫ����(��)e~ like '%�ֲ�����%' then 'L-��ó��' "+
				"when ~s�����ϸ@��Ӫ����(��)e~ like 'ҽҩ����' then 'M-ҽҩ����' "+
				"when ~s�����ϸ@��Ӫ����(��)e~ like 'ȼ�������͹�Ӧ' then 'N-ȼ�������͹�Ӧ' "+
				"when ~s�����ϸ@��Ӫ����(��)e~ like '����ά�޼�����' then 'O-����ά�޼�����' "+
				"when ~s�����ϸ@��Ӫ����(��)e~ like '����' then 'P-����' "+
				"when ~s�����ϸ@��Ӫ����(��)e~ like 'ס�޲���' then 'Q-ס�޲���' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '��ͨ����' then 'R-��ͨ����' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like 'ҽԺѧУ' then 'S-ҽԺѧУ' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '��Ϣ����' then 'T-��Ϣ����' "+
	 			"when ~s�����ϸ@��Ӫ����(��)e~ like '�Ļ�����' then 'U-�Ļ�����' "+
	 			"else 'W-'||~s�����ϸ@��Ӫ����(��)e~ end";
	 	AIDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"��Ӫ����(��)",groupBy,"");
	 	
	 	groupBy="case when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=6  then '1M6]' "+
	 						"when case when ~s�����ϸ@������e~>1 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=12 then '2M(6-12]' "+//������12������1�����֣��ȴ���Ϊ12���°ɣ����������м��ʣ�00000231001��00000230881��00000231541��00000253001��
	 						"when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=36 then '3M(12-36]' "+
	 						"when case when ~s�����ϸ@������e~>0 then (~s�����ϸ@������e~+1) else ~s�����ϸ@������e~ end <=60 then '4M(36-60]' "+
	 						"else '5M(60' end,~s�����ϸ@ҵ��Ʒ��e~";
	 	AIDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"����ҵ��Ʒ��",groupBy,"");
	 	
	 	groupBy="case when ~s�����ϸ@��Ҫ������ʽe~ like '��֤-%' then '��֤' "+
	 			"when ~s�����ϸ@��Ҫ������ʽe~ like '��Ѻ-%' then '��Ѻ' "+
	 			"when ~s�����ϸ@��Ҫ������ʽe~ = '����' then '����' "+
	 			"when ~s�����ϸ@��Ҫ������ʽe~ like '%��Ѻ-%' or ~s�����ϸ@��Ҫ������ʽe~='��֤��' then '��Ѻ' "+
	 			"else '����' end";
	 	AIDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"��һ������ʽ",groupBy,"");
	 	
	 	groupBy="case " +
	 				" when ~s�����ϸ@ҵ��Ʒ��e~ like '%���'  then 'G-�ϸ�50%����@0-���' "+
	 				" when ~s�����ϸ@��������e~ = 'С��ҵ����' and (~s�����ϸ@���ʸ�����ʽe~='��������(%)' and ~s�����ϸ@���ʸ���ֵe~>50 or ~s�����ϸ@���ʸ�����ʽe~='������' and ~s�����ϸ@���ʸ���ֵe~/(~s�����ϸ@ִ��������(%)e~-~s�����ϸ@���ʸ���ֵe~)*100>50) then 'G-�ϸ�50%����@1-��˾����' "+
	 				" when ~s�����ϸ@��������e~ = '��˾����' and (~s�����ϸ@���ʸ�����ʽe~='��������(%)' and ~s�����ϸ@���ʸ���ֵe~>50 or ~s�����ϸ@���ʸ�����ʽe~='������' and ~s�����ϸ@���ʸ���ֵe~/(~s�����ϸ@ִ��������(%)e~-~s�����ϸ@���ʸ���ֵe~)*100>50) then 'G-�ϸ�50%����@2-С��ҵ����' "+
	 				" when ~s�����ϸ@��������e~ = '��������' and (~s�����ϸ@���ʸ�����ʽe~='��������(%)' and ~s�����ϸ@���ʸ���ֵe~>50 or ~s�����ϸ@���ʸ�����ʽe~='������' and ~s�����ϸ@���ʸ���ֵe~/(~s�����ϸ@ִ��������(%)e~-~s�����ϸ@���ʸ���ֵe~)*100>50) then 'G-�ϸ�50%����@3-��������' "+
	 				" when ~s�����ϸ@���ʸ�����ʽe~='��������(%)' and ~s�����ϸ@���ʸ���ֵe~>30 or ~s�����ϸ@���ʸ�����ʽe~='������' and ~s�����ϸ@���ʸ���ֵe~/(~s�����ϸ@ִ��������(%)e~-~s�����ϸ@���ʸ���ֵe~)*100>30 then 'F-�ϸ�30%-50%����50%��' "+
	 				" when ~s�����ϸ@���ʸ�����ʽe~='��������(%)' and ~s�����ϸ@���ʸ���ֵe~>20 or ~s�����ϸ@���ʸ�����ʽe~='������' and ~s�����ϸ@���ʸ���ֵe~/(~s�����ϸ@ִ��������(%)e~-~s�����ϸ@���ʸ���ֵe~)*100>20 then 'E-�ϸ�20%-30%����30%��' "+
	 				" when ~s�����ϸ@���ʸ�����ʽe~='��������(%)' and ~s�����ϸ@���ʸ���ֵe~>10 or ~s�����ϸ@���ʸ�����ʽe~='������' and ~s�����ϸ@���ʸ���ֵe~/(~s�����ϸ@ִ��������(%)e~-~s�����ϸ@���ʸ���ֵe~)*100>10 then 'D-�ϸ�10%-20%����20%��' "+
	 				" when ~s�����ϸ@���ʸ�����ʽe~='��������(%)' and ~s�����ϸ@���ʸ���ֵe~>0 or ~s�����ϸ@���ʸ�����ʽe~='������' and ~s�����ϸ@���ʸ���ֵe~/(~s�����ϸ@ִ��������(%)e~-~s�����ϸ@���ʸ���ֵe~)*100>0 then 'C-�ϸ�10%���ڣ���10%��' "+
	 				" when ~s�����ϸ@���ʸ�����ʽe~='��������(%)' and ~s�����ϸ@���ʸ���ֵe~=0 or ~s�����ϸ@���ʸ�����ʽe~='������' and ~s�����ϸ@���ʸ���ֵe~/(~s�����ϸ@ִ��������(%)e~-~s�����ϸ@���ʸ���ֵe~)*100=0 then 'B-��׼����' "+
	 				" else 'A-�¸�10%���ڣ���10%��' end";
	 	AIDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"���ʸ�������",groupBy,"");//and ~s�����ϸ@ҵ��Ʒ��e~ not like '%���'
	 	
	 	AIDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"��ҵ��ģ","~s�����ϸ@��ҵ��ģe~","");
	 	
	 	AIDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"ҵ��Ʒ��","~s�����ϸ@ҵ��Ʒ��e~","");
	 	
	 	groupBy="case  "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then 'B-������' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then 'C-������' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%�ٷ���%' then 'D-�ٷ���' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%�˳���%' then 'E-�˳���' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then 'F-������' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%˷����%' then 'G-˷����' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then 'H-������' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%��ͬ��%' then 'I-��ͬ��' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%������%' then 'J-������' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%��Ȫ��%' then 'K-��Ȫ��' "+
	 			//"when ~s�����ϸ@���ҵ���e~ like '%ʯ��ׯ��%' then 'ʯ��ׯ��' "+
	 			//"when ~s�����ϸ@���ҵ���e~ like '%�人��%' then '�人��' "+
	 			"when ~s�����ϸ@���ҵ���e~ like '%��ɽ��%' then 'L-��ɽ��' "+
	 			"else 'A-̫ԭ��' end";//ʣ�µ�Ĭ�϶���̫ԭ��when ~s�����ϸ@���ҵ���e~ like '%̫ԭ��%' then '̫ԭ��'
	 	AIDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"��������",groupBy,"");
	 	
	 	AIDuebillInHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"��������","~s�����ϸ@ֱ��������e~","");
	 	
	 	//�������һЩ���ӵĲ���
	 	AIDuebillInHandler.afterProcess1(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	 	//4���ӹ��󣬽��кϼƣ������������
	 	AIDuebillInHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	/**
	 * �����ݵ������
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void dueBillOutHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		AIDuebillOutHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//�жҰ�������ʽ
 		String groupBy="case when ~s������ϸ@��Ҫ������ʽe~ like '��֤-%' then '��֤' "+
	 			"when ~s������ϸ@��Ҫ������ʽe~ like '��Ѻ-%' then '��Ѻ' "+
	 			"when ~s������ϸ@��Ҫ������ʽe~ = '����' then '����' "+
	 			"when ~s������ϸ@��Ҫ������ʽe~ like '%��Ѻ-%' or ~s������ϸ@��Ҫ������ʽe~='��֤��' then '��Ѻ' "+
	 			"else '����' end";
 		AIDuebillOutHandler.process(HandlerFlag,sConfigNo,sOneKey,Sqlca,"���гжһ�Ʊ��һ������ʽ",groupBy,"and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'");
	 	/*ԭ���ϵģ�Ϊ��ͳһ�¶Ⱦ�Ӫ�����ȫ����ձ��棬�������Ǹ�
	 	groupBy="case "+
 				"when ~s������ϸ@��Ӫ����(��)e~ like '%ú̿����%' or ~s������ϸ@��Ӫ����(��)e~ like '%ú̿ϴѡ%' then 'ú̿' "+
 				"when ~s������ϸ@��Ӫ����(��)e~ like '%��̼%' then '��̼' "+//��̼��
 				"when ~s������ϸ@��Ӫ����(��)e~ like '%����ҵ%' or ~s������ϸ@��Ӫ����(��)e~ like '%һ��ӹ�%' then '����ҵ' "+//����ҵ��
 				"when ~s������ϸ@��Ӫ����(��)e~ like '%��������%' then '��������' "+//�������ۡ�
 				"when ~s������ϸ@��Ӫ����(��)e~ like '%����%' then '����' "+
 				"when ~s������ϸ@��Ӫ����(��)e~ like '%��������%' then '��������' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '%���ز�%' then '���ز�' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '%����ʩ��%' then '����ʩ��' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '%���󿪲�%' then '���󿪲�' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '%ũ��������%' then 'ũ��������' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '%����ƽ̨%' then '����ƽ̨' "+
				"when ~s������ϸ@��Ӫ����(��)e~ like '%��ó��%' or ~s������ϸ@��Ӫ����(��)e~ like '%�ֲ�����%' then '��ó��' "+
				"when ~s������ϸ@��Ӫ����(��)e~ like '%ҽҩ����%' then 'ҽҩ����' "+
				"when ~s������ϸ@��Ӫ����(��)e~ like '%ȼ�������͹�Ӧ%' then 'ȼ�������͹�Ӧ' "+
				"when ~s������ϸ@��Ӫ����(��)e~ like '%����ά�޼�����%' then '����ά�޼�����' "+
				"when ~s������ϸ@��Ӫ����(��)e~ like '%����%' then '����' "+
				"when ~s������ϸ@��Ӫ����(��)e~ like '%ס�޲���%' then 'ס�޲���' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '%��ͨ����%' then '��ͨ����' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '%ҽԺѧУ%' then 'ҽԺѧУ' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '%��Ϣ����%' then '��Ϣ����' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '%�Ļ�����%' then '�Ļ�����' "+
				"when ~s������ϸ@��Ӫ����(��)e~ like '%��ɫұ��%' then '��ɫұ��' "+
	 			"else '����' end";
	 	*/
	 	//�жҰ���Ӫ���ͣ��£�
 		groupBy="case "+
 				"when ~s������ϸ@��Ӫ����(��)e~ is null or ~s������ϸ@��Ӫ����(��)e~ = '' or ~s������ϸ@��Ӫ����(��)e~='����' then 'V-����' "+
 				"when ~s������ϸ@��Ӫ����(��)e~ like 'ú̿����' then 'A-ú̿@����'" +
 				"when ~s������ϸ@��Ӫ����(��)e~ like 'ú̿ϴѡ' then 'A-ú̿@ϴѡ' "+
 				"when ~s������ϸ@��Ӫ����(��)e~ like '��̼����������' then 'B-��̼@��������' "+//��̼��
 				"when ~s������ϸ@��Ӫ����(��)e~ like '��̼��ú��һ��' or ~s������ϸ@��Ӫ����(��)e~ = '��̼' then 'B-��̼@ú��һ��' "+//��̼��
 				"when ~s������ϸ@��Ӫ����(��)e~ like '��̼������һ��' then 'B-��̼@����һ��' "+//��̼��
 				"when ~s������ϸ@��Ӫ����(��)e~ like '��̼�����ڱ���' then 'B-��̼@���ڱ���' "+//��̼��
 				"when ~s������ϸ@��Ӫ����(��)e~ like '��̼����Դ��' then 'B-��̼@��Դ��' "+//��̼��
 				"when ~s������ϸ@��Ӫ����(��)e~ like '��̼���Ȼ���' then 'B-��̼@�Ȼ���' "+//��̼��
 				"when ~s������ϸ@��Ӫ����(��)e~ like '��������%' then 'C-��������' "+//�������ۡ�
 				"when ~s������ϸ@��Ӫ����(��)e~ like '����ҵ��ˮ��' then 'D-����ҵ@ˮ��' "+//����ҵ��
 				"when ~s������ϸ@��Ӫ����(��)e~ like '����ҵ��ƽ�岣��' then 'D-����ҵ@ƽ�岣��' "+//����ҵ��
 				"when ~s������ϸ@��Ӫ����(��)e~ like '����ҵ%' then 'D-����ҵ@����' "+//����ҵ��
 				"when ~s������ϸ@��Ӫ����(��)e~ like '����' then 'E-����' "+
 				"when ~s������ϸ@��Ӫ����(��)e~ like '���ز�' then 'F-���ز�' "+
 				"when ~s������ϸ@��Ӫ����(��)e~ like '��������' then 'G-��������' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '����ʩ��' or ~s������ϸ@��Ӫ����(��)e~ like '���̽���' or ~s������ϸ@��Ӫ����(��)e~ like '��������' then 'H-����ʩ��' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '���󿪲�' then 'I-���󿪲�' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like 'ũ��������' then 'J-ũ��������' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '����ƽ̨' then 'K-����ƽ̨' "+
				"when ~s������ϸ@��Ӫ����(��)e~ like '��ó��' or ~s������ϸ@��Ӫ����(��)e~ like '%�ֲ�����%' then 'L-��ó��' "+
				"when ~s������ϸ@��Ӫ����(��)e~ like 'ҽҩ����' then 'M-ҽҩ����' "+
				"when ~s������ϸ@��Ӫ����(��)e~ like 'ȼ�������͹�Ӧ' then 'N-ȼ�������͹�Ӧ' "+
				"when ~s������ϸ@��Ӫ����(��)e~ like '����ά�޼�����' then 'O-����ά�޼�����' "+
				"when ~s������ϸ@��Ӫ����(��)e~ like '����' then 'P-����' "+
				"when ~s������ϸ@��Ӫ����(��)e~ like 'ס�޲���' then 'Q-ס�޲���' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '��ͨ����' then 'R-��ͨ����' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like 'ҽԺѧУ' then 'S-ҽԺѧУ' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '��Ϣ����' then 'T-��Ϣ����' "+
	 			"when ~s������ϸ@��Ӫ����(��)e~ like '�Ļ�����' then 'U-�Ļ�����' "+
	 			"else 'W-'||~s������ϸ@��Ӫ����(��)e~ end";
 		AIDuebillOutHandler.process(HandlerFlag,sConfigNo,sOneKey,Sqlca,"���гжһ�Ʊ��Ӫ����(��)",groupBy,"and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'");
	 	//�������һЩ���ӵĲ���
	 	AIDuebillOutHandler.afterProcess1(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	 	//4���ӹ��󣬽��кϼƣ������������
	 	AIDuebillOutHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	/**
	 * ���۽�ݵ������
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void dueBillRHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		AIDuebillRetailHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
 		String groupBy="case "+
		 				" when ~s������ϸ@��������e~ ='��������' or ~s������ϸ@��������e~ = '΢С����' or ~s������ϸ@��������e~ = '��������' then '��������'"+
		 				" when ~s������ϸ@��������e~ = 'С��ҵ����' then 'С��ҵ����' "+
		 				" else '��������' end";
 		AIDuebillRetailHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"��������",groupBy,"and (~s������ϸ@ҵ��Ʒ��e~<>'����ί�д���' and ~s������ϸ@ҵ��Ʒ��e~<>'����ס�����������')");
	 	//4���ӹ��󣬽��кϼƣ������������
 		AIDuebillRetailHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	/**
	 * �¶Ⱦ�Ӫ���洦��
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	private static void operationReportHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//1�����м�����ݽ������⴦�� 	 		 	
		AIOperationReportHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
	 	AIOperationReportHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	 	//4���ӹ��󣬽��кϼƣ������������
	 	AIOperationReportHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
}