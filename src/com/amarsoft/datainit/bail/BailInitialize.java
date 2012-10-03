package com.amarsoft.datainit.bail;

import java.sql.PreparedStatement;
import java.util.HashMap;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.context.ASUser;
import com.amarsoft.datainit.importobj.CopyInfoUtil;
import com.amarsoft.datainit.importobj.ObjImportImpl;

public class BailInitialize {
	// Text报表头和数据库对应的表
	// 装各下拉框
	private Transaction Sqlca = null;
	private ObjImportImpl OII=null;
	private ASUser CurUser=null;
	/**
	 * 解析xls 将数据插入数据表中
	 */
	public BailInitialize(Transaction Sqlca, String[] files,ASUser CurUser)throws Exception {
		this.Sqlca = Sqlca;
		this.CurUser = CurUser;
		this.OII = new BailExcelImport(Sqlca,files,CurUser);
	}
	public void handle() throws Exception {
		HashMap<String, String> mmAutoSet = new HashMap<String, String>();
		PreparedStatement psI1 = null,psI2 = null,
						psU1 = null,psU2 = null;
		//0、把Text导入数据库
		this.OII.action();
		//1、更新批次号-电票以更新业务号为批次号，纸票更新票号为批次号
		Sqlca.executeSQL("update Bail_WasteBook_Import BWT set BWT.BPPutOutNo=" +
						"(select BPBT.BatchNo from  Business_PutOut_Batch_Import BPBT where BWT.BPPutOutNo=BPBT.DuebillNo and BPBT.ImportNo like 'N"+this.CurUser.UserID+"%000000')"+
						" where exists(select 1 from Business_PutOut_Batch_Import XX where XX.DuebillNo=BWT.BPPutOutNo and XX.ImportNo like 'N"+this.CurUser.UserID+"%000000') and BWT.ImportNo like 'N"+this.CurUser.UserID+"%000000'");
		//2、最终把保证金登记簿更新到目标表
		Sqlca.executeSQL("merge into Bail_WasteBook BW" +
				" using Bail_WasteBook_Import BWT " +
				" on (BWT.BPPutOutNo=BW.BPPutOutNo and BWT.BailAccountNo=BW.BailAccountNo and BWT.SubAcct1=BW.SubAcct1 and BWT.ImportNo like 'N"+this.CurUser.UserID+"%000000')"+
				" when matched then " +
				"      update set BW.PLHoldSum=BWT.PLHoldSum," +
				"                 BW.ACHoldSum=BWT.ACHoldSum" +
				"      where BWT.ImportNo like 'N"+this.CurUser.UserID+"%000000'"+
				" when not matched then " +
				"       insert(BW.BPPutOutNo,BW.BailAccountNo,BW.SubAcct1,BW.BailCurrency,BW.PLHoldSum,BW.ACHoldSum) " +
				"       values(BWT.BPPutOutNo,BWT.BailAccountNo,BWT.SubAcct1,BWT.BailCurrency,BWT.PLHoldSum,BWT.ACHoldSum)" +
				"      where BWT.ImportNo like 'N"+this.CurUser.UserID+"%000000'");
		//3、把保证金信息初始化到押品价值占用信息
		Sqlca.executeSQL("merge into GuarantyValue_Book GB" +
				" using (select BailAccountNo,sum(PLHoldSum) as PLHoldSum,sum(ACHoldSum) as ACHoldSum " +
				"		from Bail_WasteBook_Import where ImportNo like 'N"+this.CurUser.UserID+"%000000' and BailAccountNo is not null group by BailAccountNo) BW " +
				" on (GB.ImpawnID =BW.BailAccountNo)"+
				" when matched then " +
				"      update set GB.GuarantyValue=BW.PLHoldSum,GB.GuarantyRightValue=BW.PLHoldSum,GB.UseAbleValue=BW.ACHoldSum,GB.UsedValue=BW.ACHoldSum,GB.ImpawnClass='10'"+
				" when not matched then " +
				"       insert(GB.ImpawnID,GB.GuarantyValue,GB.GuarantyRightValue,GB.UseAbleValue,GB.UsedValue,GB.ImpawnClass) " +
				"       values(BW.BailAccountNo,BW.PLHoldSum,BW.PLHoldSum,BW.ACHoldSum,BW.ACHoldSum,'10')");
		// 4、根据业务信息、额度信息、押品信息生成业务押品对照历史表表
		String sSql = "select BPPutOutNo," +
					" BailAccountNo as ImpawnID," +
					" '020270' as ImpawnType," +
					" '10' as RelativeCreationType," +
					" '30' as ImpawnClass," +
					" '2' as IsChangeFlag," +
					" sum(PLHoldSum) as UsedSum," +
					" sum(PLHoldSum) as InitUsedSum," +
					" sum(PLHoldSum) as CurUsedSum" +
					" from Bail_WasteBook_Import " +
					" where ImportNo like 'N"+this.CurUser.UserID+"%000000' " +
					" and BailAccountNo is not null " +
					" group by BPPutOutNo,BailAccountNo";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		while (rs.next()) {
			String sPutOutNo = DataConvert.toString(rs.getString("BPPutOutNo"));
			String sImpawnID = DataConvert.toString(rs.getString("ImpawnID"));
			double iExist = Sqlca.getDouble("select count(1) from PutOut_Impawn_Relative_His where BPPutOutNo='"+sPutOutNo+ "' and ImpawnID='" +sImpawnID+ "'");
			if (iExist==0) {
				String sBailApplySerialNo = DBFunction.getSerialNo("PutOut_Impawn_Relative_His","BailApplySerialNo",Sqlca);
				mmAutoSet = new HashMap<String, String>();
				mmAutoSet.put("BailApplySerialNo",sBailApplySerialNo);
				psI1 = CopyInfoUtil.copyInfo("insert", rs,"select * from PutOut_Impawn_Relative_His", null, null,null, mmAutoSet, Sqlca, psI1);
				psI1.execute();
				psI2 = CopyInfoUtil.copyInfo("insert", rs,"select * from PutOut_Impawn_Relative", null, null,null, null, Sqlca, psI2);
				psI2.execute();
			}else{
				psU1 = CopyInfoUtil.copyInfo("update",rs,"select * from PutOut_Impawn_Relative_His","BPPutOutNo,ImpawnID", "BPPutOutNo,ImpawnID,BailApplySerialNo", null, null, Sqlca, psU1);
				psU1.execute();
				psU2 = CopyInfoUtil.copyInfo("update",rs,"select * from PutOut_Impawn_Relative","BPPutOutNo,ImpawnID", "BPPutOutNo,ImpawnID,BailApplySerialNo", null, null, Sqlca, psU2);
				psU2.execute();
			}
		}
		rs.getStatement().close();
		if(psI1!=null) psI1.close();
		if(psI2!=null) psI2.close();
		if(psU1!=null) psU1.close();
		if(psU2!=null) psU2.close();
	}
}