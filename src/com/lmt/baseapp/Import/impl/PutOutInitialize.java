package com.lmt.baseapp.Import.impl;

import com.lmt.baseapp.Import.base.EntranceImpl;
import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.sql.Transaction;
/**
 * 
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class PutOutInitialize {
	// Text报表头和数据库对应的表
	// 装各下拉框
	private Transaction Sqlca = null;
	private EntranceImpl OII=null;
	private ASUser CurUser=null;
	/**
	 * 解析xls 将数据插入数据表中
	 */
	public PutOutInitialize(Transaction Sqlca, String[] files,ASUser CurUser)throws Exception {
		this.Sqlca = Sqlca;
		this.CurUser = CurUser;
		this.OII = new PutOutTextImport(Sqlca,files,CurUser);
	}
	public void handle() throws Exception {
		//表示最新批量
		//0、把Text导入数据库
		this.OII.action();
		//1、再导入到business_putout_temp 一份
		String []sP=CopyInfoUtil.getElementsInfoForCopy("(select * from Business_PutOut_Import)BI", "(select * from Business_PutOut_Temp)BT", null, null, null, null, Sqlca);
		if(sP!=null){
			Sqlca.executeSQL("merge into Business_PutOut_Temp BT" +
					" using Business_PutOut_Import BI" +
					" on(BT.SerialNo=BI.SerialNo and BI.ImportNo like 'N"+this.CurUser.UserID+"%000000')" +
					" when not matched then " +
					"	insert("+sP[0]+")values("+sP[1]+") " +
					"	where BI.ImportNo like 'N"+this.CurUser.UserID+"%000000'");
		}
		//2、更新批次号-电票以更新业务号为批次号，纸票更新票号为批次号
		Sqlca.executeSQL("update Business_PutOut_Temp BPT set BPT.PutOutNo=" +
						"(select BPBT.BatchNo from Business_PutOut_Batch_Import BPBT" +
						"		where BPT.PutOutNo=BPBT.DuebillNo and BPBT.ImportNo like 'N"+this.CurUser.UserID+"%000000')"+
						" where exists(select 1 from Business_PutOut_Batch_Import XX where XX.DuebillNo=BPT.PutOutNo and XX.ImportNo like 'N"+this.CurUser.UserID+"%000000')" +
						" and BPT.ImportNo like 'N"+this.CurUser.UserID+"%000000'");
		//3、更新业务信息中的保证金比例和金额
		Sqlca.executeSQL("update Business_PutOut_Temp BPT set BPT.BailRatio=" +
						"(select sum(BWT.BailAccountSum) from Bail_WasteBook_Import BWT " +
						" 	where BWT.BPPutOutNo=BPT.PutOutNo and BWT.ImportNo like 'N"+this.CurUser.UserID+"%000000' group by BWT.BPPutOutNo)"+
						" where exists(select 1 from Bail_WasteBook_Import XX where XX.BPPutOutNo=BPT.PutOutNo and XX.ImportNo like 'N"+this.CurUser.UserID+"%000000') " +
						" and BPT.ImportNo like 'N"+this.CurUser.UserID+"%000000'");
		Sqlca.executeSQL("update Business_PutOut_Temp set BailSum=BusinessSum*BailRatio where ImportNo like 'N"+this.CurUser.UserID+"%000000'");
		//4、生成每笔业务保证金信息 ，先只生成 票据 1600001 信息
		Sqlca.executeSQL("merge into Business_Bail_Info BBI" +
				" using Business_PutOut_Temp BPT " +
				" on (BBI.DuebillNo =BPT.RelativeSerialNo and BBI.PutOutNo=BPT.PutOutNo and BPT.ImportNo like 'N"+this.CurUser.UserID+"%000000')"+
				" when matched then " +
				"      update set BBI.BailPercent=BPT.TotalBailRatio,BBI.BailSum=BPT.TotalBailSum,BBI.PureBailPercent=BPT.BailRatio,BBI.PureBailSum=BPT.BailSum"+
				"      where BPT.TotalBailRatio>0 and BPT.ImportNo like 'N"+this.CurUser.UserID+"%000000'" +
				" when not matched then " +
				"       insert(BBI.PutOutNo,BBI.DuebillNo,BBI.BailPercent,BBI.BailSum,BBI.PureBailPercent,BBI.PureBailSum) " +
				"       values(BPT.PutOutNo,BPT.RelativeSerialNo,BPT.TotalBailRatio,BPT.TotalBailSum,BPT.BailRatio,BPT.BailSum)" +
				"      where BPT.TotalBailRatio>0 and BPT.ImportNo like 'N"+this.CurUser.UserID+"%000000'" 
				);
		//5、合并成总放款信息
		Sqlca.executeSQL("update Business_PutOut_Temp BPT1" +
						" set (BPT1.BusinessSum,BPT1.TotalBailSum,BPT1.BailSum)=" +
						" (select sum(BPT2.BusinessSum),sum(BPT2.TotalBailSum),sum(BPT2.BailSum) " +
						"	from Business_PutOut_Temp BPT2" +
						" 	where BPT1.PutOutNo=BPT2.PutOutNo and BPT2.ImportNo like 'N"+this.CurUser.UserID+"%000000' Group by BPT2.PutOutNo)"+
						" where BPT1.SerialNo in (select min(SerialNo) from Business_PutOut_Temp where ImportNo like 'N"+this.CurUser.UserID+"%000000' group by PutOutNo having count(1)>1)");
		//6、去除放款信息重复项
		Sqlca.executeSQL("delete from Business_PutOut_Temp BPT1" +
				" where BPT1.ImportNo like 'N"+this.CurUser.UserID+"%000000'"+
				" and BPT1.RowID>(select min(BPT2.RowID) from Business_PutOut_Temp BPT2 " +
				"					where BPT1.PutOutNo=BPT2.PutOutNo " +
				"					and BPT2.ImportNo like 'N"+this.CurUser.UserID+"%000000')");
		//7、最终把业务信息更新到目标表
		String []sPVVS=CopyInfoUtil.getElementsInfoForCopy("(select * from Business_PutOut_Temp)BPT", "(select * from Business_PutOut)BP", null, "PutOutNo,RelativeSerialNo", null, null, Sqlca);
		if(sPVVS!=null){
			Sqlca.executeSQL("merge into Business_PutOut BP" +
					" using Business_PutOut_Temp BPT " +
					" on (BP.PutOutNo=BPT.PutOutNo and BPT.ImportNo like 'N"+this.CurUser.UserID+"%000000')"+
					" when matched then " +
					"      update set "+sPVVS[2]+
					"      where BPT.ImportNo like 'N"+this.CurUser.UserID+"%000000'"+
					" when not matched then " +
					"       insert(BP.PutOutNo,"+sPVVS[0]+") " +
					"       values(BPT.PutOutNo,"+sPVVS[1]+")" +
					"      where BPT.ImportNo like 'N"+this.CurUser.UserID+"%000000'");

		}
	}
}