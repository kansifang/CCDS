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
		//导入前对表的处理
		ImportFactory.beforeImport("Batch_Import",HandlerFlag, sConfigNo, sOneKey, CurUser, Sqlca);
		ImportFactory.beforeImport("Batch_Import_Interim",HandlerFlag, sConfigNo, sOneKey, CurUser, Sqlca);
		//根据导入文件类型调用不同引擎对文件进行导入
		if("01".equals(sFileType)){//小型excel
			//导入文件到原始表，始终保持原滋原味
		 	EntranceImpl efih=new ExcelEntrance(sFiles,"Batch_Import",CurUser,Sqlca);
		 	efih.action(sConfigNo,sOneKey);
			//再导入到中间表，可以进行加工
		 	EntranceImpl efih_Iterim=new ExcelEntrance(sFiles,"Batch_Import_Interim",CurUser,Sqlca);
		 	efih_Iterim.action(sConfigNo,sOneKey);
		}else if("03".equals(sFileType)){//大型Excel
			EntranceImpl efih=new ExcelBigEntrance(sFiles,"Batch_Import",CurUser,Sqlca);
		 	efih.action(sConfigNo,sOneKey);
			//再导入到中间表，可以进行加工
		 	EntranceImpl efih_Iterim=new ExcelBigEntrance(sFiles,"Batch_Import_Interim",CurUser,Sqlca);
		 	efih_Iterim.action(sConfigNo,sOneKey);
		}else if("02".equals(sFileType)){//text
			//导入文件到原始表，始终保持原滋原味
		 	EntranceImpl efih=new TextEntrance(sFiles,"Batch_Import",CurUser,Sqlca);
		 	efih.action(sConfigNo,sOneKey);
			//再导入到中间表，可以进行加工
		 	EntranceImpl efih_Iterim=new TextEntrance(sFiles,"Batch_Import_Interim",CurUser,Sqlca);
		 	efih_Iterim.action(sConfigNo,sOneKey);
		}
	}
	public static void beforeImport(String sTable,String HandlerFlag,String sConfigNo,String sOneKey,ASUser CurUser,Transaction Sqlca) throws Exception{
		//1、保留导入历史记录情况下，把上一批置上最新标志，刚刚导入的为N开头的
		String sNImportNo=DBFunction.getSerialNo(sTable,"ImportNo","'O'yyyyMMdd","000000",new Date(),Sqlca);
	 	Sqlca.executeSQL("update "+sTable+" set ImportNo='"+sNImportNo+"' where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"' and ImportNo like 'N%000000'");
	 	//2、不保留历史记录，直接把以前导入的同期次同类型的数据清掉
	 	//导入文件到原始表，始终保持原滋原味
 		//Sqlca.executeSQL("Delete from "+sTable+" where ConfigNo='"+sConfigNo+"' and OneKey='"+sOneKey+"'");
	}
}