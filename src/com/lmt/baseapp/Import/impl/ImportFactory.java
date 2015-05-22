package com.lmt.baseapp.Import.impl;

import java.util.Date;

import com.lmt.baseapp.Import.base.EntranceImpl;
import com.lmt.baseapp.Import.base.ExcelBigEntrance;
import com.lmt.baseapp.Import.base.ExcelEntrance;
import com.lmt.baseapp.Import.base.TextEntrance;
import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.DBFunction;
import com.lmt.frameapp.sql.Transaction;
public class ImportFactory{
	public static void importData(String sFiles,String sFileType,String HandlerFlag,String sConfigNo,String sOneKey,ASUser CurUser,Transaction Sqlca)throws Exception{
		//����ǰ�Ա�Ĵ���
		ImportFactory.beforeImport("Batch_Import",HandlerFlag, sConfigNo, sOneKey, CurUser, Sqlca);
		ImportFactory.beforeImport("Batch_Import_Interim",HandlerFlag, sConfigNo, sOneKey, CurUser, Sqlca);
		//���ݵ����ļ����͵��ò�ͬ������ļ����е���
		if("01".equals(sFileType)){//С��excel
			//�����ļ���ԭʼ��ʼ�ձ���ԭ��ԭζ
		 	EntranceImpl efih=new ExcelEntrance(sFiles,"Batch_Import",CurUser,Sqlca);
		 	efih.action(sConfigNo,sOneKey);
			//�ٵ��뵽�м�����Խ��мӹ�
		 	EntranceImpl efih_Iterim=new ExcelEntrance(sFiles,"Batch_Import_Interim",CurUser,Sqlca);
		 	efih_Iterim.action(sConfigNo,sOneKey);
		}else if("03".equals(sFileType)){//����Excel
			EntranceImpl efih=new ExcelBigEntrance(sFiles,"Batch_Import",CurUser,Sqlca);
		 	efih.action(sConfigNo,sOneKey);
			//�ٵ��뵽�м�����Խ��мӹ�
		 	EntranceImpl efih_Iterim=new ExcelBigEntrance(sFiles,"Batch_Import_Interim",CurUser,Sqlca);
		 	efih_Iterim.action(sConfigNo,sOneKey);
		}else if("02".equals(sFileType)){//text
			//�����ļ���ԭʼ��ʼ�ձ���ԭ��ԭζ
		 	EntranceImpl efih=new TextEntrance(sFiles,"Batch_Import",CurUser,Sqlca);
		 	efih.action(sConfigNo,sOneKey);
			//�ٵ��뵽�м�����Խ��мӹ�
		 	EntranceImpl efih_Iterim=new TextEntrance(sFiles,"Batch_Import_Interim",CurUser,Sqlca);
		 	efih_Iterim.action(sConfigNo,sOneKey);
		}
	}
	public static void beforeImport(String sTable,String HandlerFlag,String sConfigNo,String sOneKey,ASUser CurUser,Transaction Sqlca) throws Exception{
		//1������������ʷ��¼����£�����һ���������±�־���ոյ����ΪN��ͷ��
		String sNImportNo=DBFunction.getSerialNo(sTable,"ImportNo","'O'yyyyMMdd","000000",new Date(),Sqlca);
	 	Sqlca.executeSQL("update "+sTable+" set ImportNo='"+sNImportNo+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"' and ImportNo like 'N%000000'");
	 	//2����������ʷ��¼��ֱ�Ӱ���ǰ�����ͬ�ڴ�ͬ���͵��������
	 	//�����ļ���ԭʼ��ʼ�ձ���ԭ��ԭζ
 		//Sqlca.executeSQL("Delete from "+sTable+" where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	}
}