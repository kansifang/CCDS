package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.baseapp.util.StringUtils;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. ��ʷѺƷ��Ϣ�����ʼ��
 */
public class DataDuebillOutHandler{
	public static void beforeHandle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca)throws Exception{
		//�������úźͱ�������
 		//String sSerialNo  = DBFunction.getSerialNo("Batch_Case","SerialNo",Sqlca);
 		//Sqlca.executeSQL("update "+sImportTableName+" set ReportDate='"+sReportDate+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and ImportNo like 'N%000000'");
		//���Ŀ��� 
		Sqlca.executeSQL("Delete from Batch_Import_Process where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	}
	/**
	 * �����ݵ������
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public static void handle(String HandlerFlag,String sConfigNo,String sOneKey,Transaction Sqlca) throws Exception {
		//�ȵ��뵽���ݿ�,�����Ŀ���Ϊ���ݴ�����׼��
		DataDuebillOutHandler.beforeHandle(HandlerFlag, sConfigNo, sOneKey, Sqlca);
		//0�����м�����ݽ������⴦�� 	 		 	
		DataDuebillOutHandler.interimProcess(sConfigNo, sOneKey, Sqlca);
		//1�����ȫ��
 		String groupBy="'����'LJF@case "+
			 			"when nvl(~s������ϸ@��֤�����(%)e~,0)=100 and (~s������ϸ@��Ҫ������ʽe~ like '%���д浥' or ~s������ϸ@��Ҫ������ʽe~ like '%��֤��' or ~s������ϸ@��Ҫ������ʽe~ like '%��������Ҵ��%') then 'ȫ���������' "+
			 			"else '����������' end";
 		DataDuebillOutHandler.process(HandlerFlag,sConfigNo,sOneKey,Sqlca,"���ȫ�����гжһ�Ʊ",groupBy,"and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'");
		//3����֤�����
 		groupBy="QZ'A'QZ" +
 				"complementstring(trim(replace(" +
 					"case when ~s������ϸ@��֤�����(%)e~>=1 then char(~s������ϸ@��֤�����(%)e~)" +
 					"else '0'||char(~s������ϸ@��֤�����(%)e~) end" +
 					",'.000000','%')),'0',4,'Before')" +
 				"LJF@~s������ϸ@��Ҫ������ʽe~";
 				//"QZNumber:0:4:BeforeQZQZ'A'QZ~s������ϸ@��Ҫ������ʽe~";
 		DataDuebillOutHandler.process(HandlerFlag,sConfigNo,sOneKey,Sqlca,"���гжһ�Ʊ��֤�����",groupBy,"and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'");
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
	 	//4���жҰ���Ӫ���ͣ��£�
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
 		DataDuebillOutHandler.process(HandlerFlag,sConfigNo,sOneKey,Sqlca,"���гжһ�Ʊ��Ӫ����(��)",groupBy,"and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'");
 		
	 	//2�����жҰ���һ������ʽ
 		groupBy="case when ~s������ϸ@��Ҫ������ʽe~ like '��֤-%' then '��֤' "+
	 			"when ~s������ϸ@��Ҫ������ʽe~ like '��Ѻ-%' then '��Ѻ' "+
	 			"when ~s������ϸ@��Ҫ������ʽe~ = '����' then '����' "+
	 			"when ~s������ϸ@��Ҫ������ʽe~ like '%��Ѻ-%' or ~s������ϸ@��Ҫ������ʽe~='��֤��' then '��Ѻ' "+
	 			"else '����' end";
 		DataDuebillOutHandler.process(HandlerFlag,sConfigNo,sOneKey,Sqlca,"���гжһ�Ʊ��һ����",groupBy,"and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ' and not(nvl(~s������ϸ@��֤�����(%)e~,0)=100 and (~s������ϸ@��Ҫ������ʽe~ like '%���д浥' or ~s������ϸ@��Ҫ������ʽe~ like '%��֤��' or ~s������ϸ@��Ҫ������ʽe~ like '%��������Ҵ��%'))");
 		groupBy="case when ~s������ϸ@��ҵ��ģe~ = 'С����ҵ' or ~s������ϸ@��ҵ��ģe~ = '΢С����ҵ' then '0��С΢����ҵ' "+
 				"when ~s������ϸ@��ҵ��ģe~ = '������ҵ' then '1��������ҵ'"+
	 			"else '2��'||~s������ϸ@��ҵ��ģe~ end";
 		DataDuebillOutHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"���гжһ�Ʊ��ҵ��ģ",groupBy,"and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ' and not(nvl(~s������ϸ@��֤�����(%)e~,0)=100 and (~s������ϸ@��Ҫ������ʽe~ like '%���д浥' or ~s������ϸ@��Ҫ������ʽe~ like '%��֤��' or ~s������ϸ@��Ҫ������ʽe~ like '%��������Ҵ��%'))");
	 		 	
	 	groupBy="case  "+
	 			"when ~s������ϸ@���ҵ���e~ like '%������%' then 'B-������' "+
	 			"when ~s������ϸ@���ҵ���e~ like '%������%' then 'C-������' "+
	 			"when ~s������ϸ@���ҵ���e~ like '%�ٷ���%' then 'D-�ٷ���' "+
	 			"when ~s������ϸ@���ҵ���e~ like '%�˳���%' then 'E-�˳���' "+
	 			"when ~s������ϸ@���ҵ���e~ like '%������%' then 'F-������' "+
	 			"when ~s������ϸ@���ҵ���e~ like '%˷����%' then 'G-˷����' "+
	 			"when ~s������ϸ@���ҵ���e~ like '%������%' then 'H-������' "+
	 			"when ~s������ϸ@���ҵ���e~ like '%��ͬ��%' then 'I-��ͬ��' "+
	 			"when ~s������ϸ@���ҵ���e~ like '%������%' then 'J-������' "+
	 			"when ~s������ϸ@���ҵ���e~ like '%��Ȫ��%' then 'K-��Ȫ��' "+
	 			//"when ~s������ϸ@���ҵ���e~ like '%ʯ��ׯ��%' then 'ʯ��ׯ��' "+
	 			//"when ~s������ϸ@���ҵ���e~ like '%�人��%' then '�人��' "+
	 			"when ~s������ϸ@���ҵ���e~ like '%��ɽ��%' then 'L-��ɽ��' "+
	 			"else 'A-̫ԭ��' end";//ʣ�µ�Ĭ�϶���̫ԭ��when ~s������ϸ@���ҵ���e~ like '%̫ԭ��%' then '̫ԭ��'
	 	DataDuebillOutHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"���гжһ�Ʊ����",groupBy,"and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ' and not(nvl(~s������ϸ@��֤�����(%)e~,0)=100 and (~s������ϸ@��Ҫ������ʽe~ like '%���д浥' or ~s������ϸ@��Ҫ������ʽe~ like '%��֤��' or ~s������ϸ@��Ҫ������ʽe~ like '%��������Ҵ��%'))");
	 	
	 	DataDuebillOutHandler.process(HandlerFlag,sConfigNo, sOneKey, Sqlca,"���гжһ�Ʊ����","~s������ϸ@ֱ��������e~","and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ' and not(nvl(~s������ϸ@��֤�����(%)e~,0)=100 and (~s������ϸ@��Ҫ������ʽe~ like '%���д浥' or ~s������ϸ@��Ҫ������ʽe~ like '%��֤��' or ~s������ϸ@��Ҫ������ʽe~ like '%��������Ҵ��%'))");
 		//�������һЩ���ӵĲ���
	 	DataDuebillOutHandler.afterProcess1(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	 	//4���ӹ��󣬽��кϼƣ������������
	 	DataDuebillOutHandler.afterProcess(HandlerFlag,sConfigNo, sOneKey, Sqlca);
	}
	//�Ե������ݼӹ�����,���뵽�м��Batch_Import_Interim
	public static void interimProcess(String sConfigNo,String sKey,Transaction Sqlca) throws Exception{
 		String sSql="";
		//2�� 
 		//b����Ӫ���ͣ��£�����һ����׼���ڣ������������������Ϊ׼�� ���µ�����ʱ���֮ǰ�ģ�����ҵ�񲻶ϱ仯�����ھ�Ӫ���ͻ᲻�ϱ仯����һ�����һ�λ��Ǿ�ĳ�����ڲ����أ����Ǹ�����
 		//��ȡ 2014/05��ǰ����2014/05Ϊ׼���˺�͵�ǰΪ׼���ֲ���
 		//ԭ���ϵ����ݶ���Ҫ�ٵ�����ֻ����������
 		String AdjustDate="2014/05";//StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0);
 		if(1==1&&sKey.compareTo(AdjustDate)<0){
 			sSql="update Batch_Import_Interim BII set ~s������ϸ@��Ӫ����(��)e~="+
 					"(select ~s������ϸ@��Ӫ����(��)e~ from Batch_Import BI "+
 					"where BI.ConfigNo=BII.ConfigNo and BI.OneKey='"+AdjustDate+"' and BI.~s������ϸ@�����ˮ��e~=BII.~s������ϸ@�����ˮ��e~) "+
 			" where BII.ConfigNo='"+sConfigNo+"' and BII.OneKey='"+sKey+"'"+
 			" and exists(select 1 from Batch_Import BI1 where BI1.ConfigNo=BII.ConfigNo and BI1.OneKey='"+AdjustDate+"' and BI1.~s������ϸ@�����ˮ��e~=BII.~s������ϸ@�����ˮ��e~)";
 			sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 			Sqlca.executeSQL(sSql);
 		}
		//a����Ӫ���ͣ��£�����ֶ�Ϊ�գ����� ��Ӫ���� �ڵ�ֵ
 		sSql="update Batch_Import_Interim set ~s������ϸ@��Ӫ����(��)e~=~s������ϸ@��Ӫ����e~ where ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"' and (nvl(~s������ϸ@��Ӫ����(��)e~,'')='' or ~s������ϸ@��Ӫ����(��)e~='����' and nvl(~s������ϸ@��Ӫ����e~,'')<>'' and ~s������ϸ@��Ӫ����(��)e~<>~s������ϸ@��Ӫ����e~)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
		//c���Ե���Ŀͻ���ϢΪ׼���¾�Ӫ����(��)----����������Զ�Խ���Ϊ׼������������໹��̫�󣬲��Ǻ�׼����ʱ���ΰɣ�
		/*
		sSql="update Batch_Import_Interim BII set ~s������ϸ@��Ӫ����(��)e~="+
				"(select ~s�ͻ���ϸ@��Ӫ����(��)e~ from Batch_Import_Interim BII1 "+
				"where BII1.ConfigName='�ͻ���ϸ' and BII1.OneKey='"+StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)+"' and BII1.~s�ͻ���ϸ@�ͻ�����e~=BII.~s������ϸ@�ͻ�����e~) "+
		" where BII.ConfigNo='"+sConfigNo+"' and BII.OneKey='"+sKey+"'"+
		" and exists(select 1 from Batch_Import BII2 where BII2.ConfigName='�ͻ���ϸ' and BII2.OneKey='"+StringFunction.getRelativeAccountMonth(StringFunction.getToday(), "month", 0)+"' and BII2.~s�ͻ���ϸ@�ͻ�����e~=BII.~s������ϸ@�ͻ�����e~)";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
		*/
 		//3��ֱ�������� ���ǡ����С�����ֱ�������ƣ����� �ܻ��� ���ֺ���������ڵı�־����
 		sSql="update Batch_Import_Interim set ~s������ϸ@ֱ��������e~="+
 					"case when ~s������ϸ@�ܻ���e~ like '%����%' or ~s������ϸ@�ܻ���e~='���ֻ�' then '���Ƿ���' "+
 					"when ~s������ϸ@�ܻ���e~ like '%����%' then '���з���' "+
 					"when ~s������ϸ@�ܻ���e~ like '%����%' then '���η���' "+
 					"else ~s������ϸ@ֱ��������e~ end "+
 					"where ConfigNo='"+sConfigNo+"' "+
 					"and OneKey='"+sKey+"' "+
 					"and nvl(~s������ϸ@�ܻ���e~,'')<>''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql); 
 		//4���ܻ����� Ϊӭ��֧�е�ֱ���������� ����Ӫҵ�� ��Ϊ ����ֱ��֧��
 		sSql="update Batch_Import_Interim set ~s������ϸ@ֱ��������e~='����ֱ��֧��'"+
 					" where ConfigNo='"+sConfigNo+"' "+
 					" and OneKey='"+sKey+"' "+
 					" and nvl(~s������ϸ@ֱ��������e~,'')='����Ӫҵ��'"+
 					" and nvl(~s������ϸ@�ܻ�����e~,'')='����Ӫҵ��'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//4��ֱ���������д��������е� ��� ���� �ܻ����� ������
 		sSql="update Batch_Import_Interim set ~s������ϸ@ֱ��������e~=~s������ϸ@�ܻ�����e~"+
 					" where ConfigNo='"+sConfigNo+"' "+
 					" and OneKey='"+sKey+"' "+
 					" and nvl(~s������ϸ@ֱ��������e~,'')='��������'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		sSql="update Batch_Import_Interim set ~s������ϸ@��ҵ��ģe~='������ҵ��λ'"+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and nvl(~s������ϸ@��ҵ��ģe~,'')=''";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql); 
 		//7��ͳһ���±��ֵ�����ң���� �������Ӧת��
 		sSql="update Batch_Import_Interim set ~s������ϸ@����e~='01',"+
			 		"~s������ϸ@���(Ԫ)e~=~s������ϸ@���(Ԫ)e~*nvl(getErate(~s������ϸ@����e~,'01',''),1),"+
			 		"~s������ϸ@���(Ԫ)e~=~s������ϸ@���(Ԫ)e~*nvl(getErate(~s������ϸ@����e~,'01',''),1) "+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and nvl(~s������ϸ@����e~,'')<>'01'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//8������Ǳ��д浥��֤�𣬱�֤�������0����Ȼ���ڽ��Ҳ��0���ĳжһ�Ʊ�ı�֤��������100 ���ճ��ڱ�Ϊ0
 		sSql="update Batch_Import_Interim set ~s������ϸ@��֤�����(%)e~=100,~s������ϸ@���ճ���e~=0"+
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and (nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%��֤��%' or nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%���д浥%' or nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%��������Ҵ��%')"+
 					" and nvl(~s������ϸ@��֤�����(%)e~,0)=0"+
 					" and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//9������Ǳ�֤�������Ϊ100����Ȼ����>0������Ҫ������ʽΪ���д浥��֤��ĳжһ�Ʊ��,��Ϻ�ͬ��ϸ��������� ������������ʽ�� ������Ѻ������Ҫ������ʽ��Ϊ��Ѻ
 		sSql="update Batch_Import_Interim BII1 set " +
 					"~s������ϸ@��Ҫ������ʽe~='��Ѻ-' " +
 					" where ConfigNo='"+sConfigNo+"'"+
 					" and OneKey='"+sKey+"'"+
 					" and (nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%��֤��%' or nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%���д浥%' or nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%��������Ҵ��%')"+
 					" and nvl(~s������ϸ@��֤�����(%)e~,0)<>100"+
 					" and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'" +
 					" and exists(select 1 from Batch_Import_Interim BII2 " +
 					"			where BII2.ConfigName='��ͬ��ϸ'" +
 					"				and BII2.OneKey=BII1.OneKey" +
 					"				and BII2.~s��ͬ��ϸ@�ͻ����e~=BII1.~s������ϸ@�ͻ����e~" +
 					"				and BII2.~s��ͬ��ϸ@ҵ��Ʒ��e~=BII1.~s������ϸ@ҵ��Ʒ��e~" +
 					"				and BII2.~s��ͬ��ϸ@��Ҫ������ʽe~=BII1.~s������ϸ@��Ҫ������ʽe~" +
 					"				and locate('��Ѻ',BII2.~s��ͬ��ϸ@����������ʽe~)>0)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//10������Ǳ�֤�������Ϊ100����Ȼ����>0������Ҫ������ʽΪ���д浥��֤��ĳжһ�Ʊ��,��Ϻ�ͬ��ϸ��������� ������������ʽ�� ������֤������Ҫ������ʽ��Ϊ��֤
 		sSql="update Batch_Import_Interim BII1 set " +
					"~s������ϸ@��Ҫ������ʽe~='��֤-һ����ҵ' " +
					" where ConfigNo='"+sConfigNo+"'"+
					" and OneKey='"+sKey+"'"+
					" and (nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%��֤��%' or nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%���д浥%' or nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%��������Ҵ��%')"+
					" and nvl(~s������ϸ@��֤�����(%)e~,0)<>100"+
					" and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'" +
					" and exists(select 1 from Batch_Import_Interim BII2 " +
					"			where BII2.ConfigName='��ͬ��ϸ'" +
					"				and BII2.OneKey=BII1.OneKey" +
					"				and BII2.~s��ͬ��ϸ@�ͻ����e~=BII1.~s������ϸ@�ͻ����e~" +
					"				and BII2.~s��ͬ��ϸ@ҵ��Ʒ��e~=BII1.~s������ϸ@ҵ��Ʒ��e~" +
					"				and BII2.~s��ͬ��ϸ@��Ҫ������ʽe~=BII1.~s������ϸ@��Ҫ������ʽe~" +
					"				and locate('��֤',BII2.~s��ͬ��ϸ@����������ʽe~)>0)";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//11����Ҫ������ʽΪ���гжһ�Ʊ��,�����֤�����Ϊ100����֤��������0 ���ճ��ڱ�Ϊ���
 		sSql="update Batch_Import_Interim set ~s������ϸ@��֤�����(%)e~=0,~s������ϸ@���ճ���e~=~s������ϸ@���(Ԫ)e~"+
					" where ConfigNo='"+sConfigNo+"'"+
					" and OneKey='"+sKey+"'"+
					" and nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%���гжһ�Ʊ%'"+
					" and nvl(~s������ϸ@��֤�����(%)e~,0)=100"+
					" and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
 		//12�����Ĵ���δ�⸶��215w���ڴ˵���ȫ�����
 		sSql="insert into Batch_Import_Interim" +
 					"(ConfigNo,OneKey,~s������ϸ@ҵ��Ʒ��e~,~s������ϸ@��Ҫ������ʽe~,~s������ϸ@��֤�����(%)e~,~s������ϸ@���(Ԫ)e~,~s������ϸ@��Ӫ����(��)e~)" +
 					"values('"+sConfigNo+"','"+sKey+"','���гжһ�Ʊ','��Ѻ-������ѺƷ-��֤��-��֤��',100,2150000,'ú̿����')";
 		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL(sSql);
 		//13��2014�� ��Ҫ������ʽ ��Ѻ-������ѺƷ-Ʊ��-���гжһ�Ʊ ��ǰΪ ��Ѻ-���гжһ�Ʊ(4��������)�����б�Ʊ
 		//�����ٴ�ͳһ����
 		sSql="update Batch_Import_Interim set ~s������ϸ@��Ҫ������ʽe~='��Ѻ-������ѺƷ-Ʊ��-���гжһ�Ʊ'"+
				" where ConfigNo='"+sConfigNo+"'"+
				" and OneKey='"+sKey+"'"+
				" and nvl(~s������ϸ@��Ҫ������ʽe~,'') like '��Ѻ-���гжһ�Ʊ%'"+
				" and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
		//13��2014�� ��Ҫ������ʽ ��Ѻ-������ѺƷ-��֤��-��֤�� ��ǰΪ ��֤��
 		//�����ٴ�ͳһ����
 		sSql="update Batch_Import_Interim set ~s������ϸ@��Ҫ������ʽe~='��Ѻ-������ѺƷ-��֤��-��֤��'"+
				" where ConfigNo='"+sConfigNo+"'"+
				" and OneKey='"+sKey+"'"+
				" and nvl(~s������ϸ@��Ҫ������ʽe~,'') like '%��֤��%'"+
				" and nvl(~s������ϸ@ҵ��Ʒ��e~,'')='���гжһ�Ʊ'";
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
		Sqlca.executeSQL(sSql);
	}
	/**
	 * ������ά�Ȳ��뵽�������
	 * @throws Exception 
	 * 
	 * groupBy ��ʽ��QZ��ʾ��ѯֵ��ǰ׺ ��QZXXQZ��ʽ����������� д��QZNumberQZȻ������ֶ�֮ǰ����׺������Ҫ�Ժ��ټ�
	 */
	public static void process(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca,String Dimension,String groupBy,String sWhere) throws Exception{
		//�Ƿ񼾱������걨���걨�·ݣ�ԭ��ֻ���Ǽ����������ֶ��õ�Season��������չ�ˣ��˴����������ݿ��ֶβ��ٱ仯
		//��ǰ�·�Ϊ03,09�ͱ�ʾ������06�ͱ�ʾ���걨 12�ͱ�ʾ�걨
		boolean isSeason=false;
		String startsmonth="";
		if(StringFunction.isLike(sKey, "%03")||StringFunction.isLike(sKey, "%09")){
			startsmonth=StringFunction.getRelativeAccountMonth(sKey,"month", -2);
			isSeason=true;
		}
		if(StringFunction.isLike(sKey, "%06")){
			startsmonth=StringFunction.getRelativeAccountMonth(sKey,"month", -5);
			isSeason=true;
		}
		if(StringFunction.isLike(sKey, "%12")){
			startsmonth=StringFunction.getRelativeAccountMonth(sKey,"month", -11);
			isSeason=true;
		}
		String[] groupColumnClause=StringUtils.replaceWithRealSql(groupBy);
		//1��������ά�Ȼ��ܵ��������
		String sSql="select "+
 				"'"+HandlerFlag+"',ConfigNo,OneKey,'"+Dimension+"',"+groupColumnClause[0]+
				"round(sum(case when ~s������ϸ@�����ʼ��e~ like '"+sKey+"%' then ~s������ϸ@���(Ԫ)e~ end)/10000,2) as BusinessSum,"+//����Ͷ�Ž��
				(isSeason==true?"round(sum(case when ~s������ϸ@�����ʼ��e~ >= '"+startsmonth+"/01' and ~s������ϸ@�����ʼ��e~ <= '"+sKey+"/31' then ~s������ϸ@���(Ԫ)e~ end)/10000,2)":"0")+","+//����Ǽ���ĩ�����㰴��Ͷ�Ž��,����ǰ���ĩ�������Ͷ�ţ�����....
				"round(case when sum(~s������ϸ@���(Ԫ)e~)<>0 then sum(~s������ϸ@���(Ԫ)e~*~s������ϸ@ִ��������(%)e~)/sum(~s������ϸ@���(Ԫ)e~) else 0 end,2) as BusinessRate, "+//��Ȩ����
				"round(sum(~s������ϸ@���(Ԫ)e~)/10000,2) as Balance, "+
				"round(sum(~s������ϸ@���ճ���e~)/10000,2) as CKBalance, "+
				"count(distinct ~s������ϸ@�ͻ�����e~) "+
				"from Batch_Import_Interim "+
				" where ConfigNo='"+sConfigNo+"'" +
				" and OneKey='"+sKey+"'" +
				" and nvl(~s������ϸ@���(Ԫ)e~,0)>0 "+sWhere+
				" group by ConfigNo,OneKey"+groupColumnClause[1];
		sSql=StringUtils.replaceWithConfig(sSql, Sqlca);
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,BusinessRate,Balance,CKBalance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
	}
	//��ΪSQL��临�� process�޷�ͨ����ɣ���Ҫ�˴��������
	public static void afterProcess1(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		//���ȫ�������һ���������
		String sSql=" select "+
				"HandlerFlag,ConfigNo,OneKey,Dimension,'���г������',CKBalance"+
				" from Batch_Import_Process " +
				" where HandlerFlag ='"+HandlerFlag+"'" +
				" and OneKey ='"+sKey+"'" +
				" and Dimension='���ȫ�����гжһ�Ʊ'"+
				" and DimensionValue='����@����������'";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,Balance)"+
 				"("+
 				sSql+
 				")");
	}
	//����С�� �ϼ� ��������Ƚ�ֵ С������ DimensionValue ����@�ָ�Ϊ��־
	public static void afterProcess(String HandlerFlag,String sConfigNo,String sKey,Transaction Sqlca)throws Exception{
		String sSql="";
		String sLastYearEnd=StringFunction.getRelativeAccountMonth(sKey.substring(0, 4)+"/12","year",-1);
		//1���������ά�ȵ�С��
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)||'@С��',"+
			"round(sum(BusinessSum),2)," +
			"round(sum(BusinessSumSeason),2)," +
			"round(sum(Balance),2)," +
			"round(sum(CKBalance),2)," +
			"sum(TotalTransaction) "+
			" from Batch_Import_Process "+
			" where HandlerFlag='"+HandlerFlag+"'" +
			" and ConfigNo='"+sConfigNo+"'" +
			" and OneKey ='"+sKey+"'" +
			" and locate('@',DimensionValue)>0 "+
			" group by HandlerFlag,ConfigNo,OneKey,Dimension,substr(DimensionValue,1,locate('@',DimensionValue)-1)";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,CKBalance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
		//2���������ά�ȵ��ܼ�
 		sSql="select "+
 				"HandlerFlag,ConfigNo,OneKey,Dimension,'Z-�ܼ�@�ܼ�',"+
			"round(sum(BusinessSum),2)," +
			"round(sum(BusinessSumSeason),2)," +
			"round(sum(Balance),2)," +
			"round(sum(CKBalance),2)," +
			"sum(TotalTransaction) "+
			" from Batch_Import_Process "+
			" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('С��',DimensionValue)=0"+
			" group by HandlerFlag,ConfigNo,OneKey,Dimension";
 		Sqlca.executeSQL("insert into Batch_Import_Process "+
 				"(HandlerFlag,ConfigNo,OneKey,Dimension,DimensionValue,"+
 				"BusinessSum,BusinessSumSeason,Balance,CKBalance,TotalTransaction)"+
 				"( "+
 				sSql+
 				")");
 		//3��ռ�ȣ��ܼƣ�С�ƵȻ��ܵ�ֵҪ������������ֵһ�����ӵõ�����Ҫ��ԭʼֵ��ӣ���Ϊ�����������ɲ�׼������
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
		 				"case when nvl(tab2.BusinessSum,0)<>0 then round(tab1.BusinessSum/tab2.BusinessSum*100,2) else 0 end as BusinessSumRatio,"+
		 				"case when nvl(tab2.BusinessSumSeason,0)<>0 then round(tab1.BusinessSumSeason/tab2.BusinessSumSeason*100,2) else 0 end as BusinessSumSeasonRatio,"+
		 				"case when nvl(tab2.Balance,0)<>0 then round(tab1.Balance/tab2.Balance*100,2) else 0 end as BalanceRatio, " +
		 				"case when nvl(tab2.CKBalance,0)<>0 then round(tab1.CKBalance/tab2.CKBalance*100,2) else 0 end as CKBalanceRatio " +
		 				"from "+
							"(select Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance,CKBalance "+
								"from Batch_Import_Process "+
								"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
							")tab1,"+
							"(select Dimension,DimensionValue,BusinessSum,BusinessSumSeason,Balance,CKBalance "+	
								"from Batch_Import_Process "+
								"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"' and locate('�ܼ�',DimensionValue)>0"+
							")tab2"+
					" where tab1.Dimension=tab2.Dimension)tab3"+
				" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BusinessSumRatio,BusinessSumSeasonRatio,BalanceRatio,CKBalanceRatio)="+
 				"(select tab3.BusinessSumRatio,tab3.BusinessSumSeasonRatio,tab3.BalanceRatio,tab3.CKBalanceRatio "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 					" and exists(select 1 "+sSql+")"
 				);
 		//4�����ǰһ�������ֵ�ͷ��ȸ���
 		sSql="from (select tab1.Dimension,tab1.DimensionValue,"+
		 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
		 				"(nvl(tab1.CKBalance,0)-nvl(tab2.CKBalance,0)) as CKBalanceTLY,"+
		 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
		 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY,"+
		 				"(nvl(tab1.BalanceRatio,0)-nvl(tab2.BalanceRatio,0)) as BalanceRatioTLY,"+
		 				"case when nvl(tab2.CKBalance,0)<>0 then cast(round((nvl(tab1.CKBalance,0)/nvl(tab2.CKBalance,0)-1)*100,2) as numeric(24,6)) else 0 end as CKBalanceRangeTLY,"+
		 				"(nvl(tab1.CKBalanceRatio,0)-nvl(tab2.CKBalanceRatio,0)) as CKBalanceRatioTLY"+
		 				" from "+
							"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio,CKBalance,CKBalanceRatio "+
								"from Batch_Import_Process "+
								"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
							")tab1,"+
							"(select Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio,CKBalance,CKBalanceRatio "+	
							"from Batch_Import_Process "+
								"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sLastYearEnd+"'"+
							")tab2"+
					" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
			" where tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";	
 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 				"set(BalanceTLY,CKBalanceTLY,BusinessRateTLY,BalanceRangeTLY,BalanceRatioTLY,CKBalanceRangeTLY,CKBalanceRatioTLY)="+
 				"(select tab3.BalanceTLY,tab3.CKBalanceTLY,tab3.BusinessRateTLY,tab3.BalanceRangeTLY,tab3.BalanceRatioTLY,tab3.CKBalanceRangeTLY,tab3.CKBalanceRatioTLY "+
 				sSql+
 				")"+
 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey='"+sKey+"'"+
 				" and exists(select 1 "+sSql+")"
 				);
 		//�������ȵ��룬������һ��������·ݵ�����ֵ������ֵ�ͷ��ȸ���
 		if(StringFunction.isLike(sKey, "%/12")){
 			sSql="select distinct OneKey from Batch_Import_Process where ConfigNo='"+sConfigNo+"' and OneKey>'"+sKey+"'";
 			String[] sOneKey=Sqlca.getStringArray(sSql);
 			String OneKeys=StringFunction.toArrayString(sOneKey, "','");
 			sSql="from (select tab1.OneKey,tab1.Dimension,tab1.DimensionValue,"+
		 	 				"(nvl(tab1.Balance,0)-nvl(tab2.Balance,0)) as BalanceTLY,"+
		 	 				"(nvl(tab1.CKBalance,0)-nvl(tab2.CKBalance,0)) as CKBalanceTLY,"+
		 	 				"(nvl(tab1.BusinessRate,0)-nvl(tab2.BusinessRate,0)) as BusinessRateTLY,"+
		 	 				"case when nvl(tab2.Balance,0)<>0 then cast(round((nvl(tab1.Balance,0)/nvl(tab2.Balance,0)-1)*100,2) as numeric(24,6)) else 0 end as BalanceRangeTLY," +
		 	 				"(nvl(tab1.BalanceRatio,0)-nvl(tab2.BalanceRatio,0)) as BalanceRatioTLY,"+
		 	 				"case when nvl(tab2.CKBalance,0)<>0 then cast(round((nvl(tab1.CKBalance,0)/nvl(tab2.CKBalance,0)-1)*100,2) as numeric(24,6)) else 0 end as CKBalanceRangeTLY,"+
			 				"(nvl(tab1.CKBalanceRatio,0)-nvl(tab2.CKBalanceRatio,0)) as CKBalanceRatioTLY"+
		 	 				" from "+
		 				"(select OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio,CKBalance,CKBalanceRatio "+
		 					"from Batch_Import_Process "+
		 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
		 				")tab1,"+
		 				"(select OneKey,Dimension,DimensionValue,BusinessSum,BusinessRate,Balance,BalanceRatio,CKBalance,CKBalanceRatio "+	
		 				"from Batch_Import_Process "+
		 					"where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey ='"+sKey+"'"+
		 				")tab2"+
		 				" where tab1.Dimension=tab2.Dimension and tab1.DimensionValue=tab2.DimensionValue)tab3"+
 				" where tab.OneKey=tab3.OneKey and tab.Dimension=tab3.Dimension and tab.DimensionValue=tab3.DimensionValue";	
 	 		Sqlca.executeSQL("update Batch_Import_Process tab "+
 	 				"set(BalanceTLY,CKBalanceTLY,BusinessRateTLY,BalanceRangeTLY,BalanceRatioTLY,CKBalanceRangeTLY,CKBalanceRatioTLY)="+
 	 				"(select tab3.BalanceTLY,tab3.CKBalanceTLY,tab3.BusinessRateTLY,tab3.BalanceRangeTLY,tab3.BalanceRatioTLY,tab3.CKBalanceRangeTLY,tab3.CKBalanceRatioTLY "+
 	 				sSql+
 	 				")"+
 	 				" where HandlerFlag='"+HandlerFlag+"' and ConfigNo='"+sConfigNo+"' and OneKey in('"+OneKeys+"')"+
 	 				" and exists(select 1 "+sSql+")"
 	 				);
 		}
	}
}