package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.sql.Transaction;
public class DataHandlerFactory{
	public static void handle(String sBatchNo,String sFiles,String sFileType,String HandlerFlag,String sConfigNo,String sOneKey,ASUser CurUser,Transaction Sqlca) throws Exception{
		//对数据进行初步加工
		if("Customer".toUpperCase().equals(HandlerFlag)){
			DataCustomerHandler.handle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("Contract".toUpperCase().equals(HandlerFlag)){
			DataContractHandler.handle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("Duebill".toUpperCase().equals(HandlerFlag)){
			DataDuebillInHandler.handle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("DuebillOut".toUpperCase().equals(HandlerFlag)){
			DataDuebillOutHandler.handle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("DuebillR".toUpperCase().equals(HandlerFlag)){
			DataDuebillRetailHandler.handle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("OperationReport".toUpperCase().equals(HandlerFlag)){
			DataOperationReportHandler.handle(HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}else if("ChangeApply".toUpperCase().equals(HandlerFlag)){
			DataChangeApplyHandler.handle(sBatchNo,HandlerFlag,sConfigNo, sOneKey, Sqlca);
		}
	}
}