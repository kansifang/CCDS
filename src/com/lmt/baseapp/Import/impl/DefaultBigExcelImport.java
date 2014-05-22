package com.lmt.baseapp.Import.impl;

import java.sql.SQLException;
import java.util.List;

import com.lmt.baseapp.Import.base.ExcelHandler;
import com.lmt.baseapp.Import.base.XxlsAbstract;
import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class DefaultBigExcelImport extends XxlsAbstract{
	/**
	 * 解析xls 将数据插入数据表中
	 * @throws Exception 
	 */
	public DefaultBigExcelImport(Transaction Sqlca, String files,ASUser CurUser) throws Exception {
		super(Sqlca, files,new ExcelHandler(Sqlca,CurUser));
	}
	public boolean checkObj() throws Exception{
		boolean isPass=true;
		/*
		int currentrow=this.ERS.getCurrentRow()+1;
		//抵质押物编号不能为空
		String sImpawnID1=DataConvert.toString(this.getERS().getStringWH(""));
		String sImpawnID2=DataConvert.toString(this.ERS.getStringWH("质押物编号"));
		if(sImpawnID1.length()==0&&sImpawnID2.length()==0){
			//throw new Exception("请确认表单“"+this.ERS.getSheet().getName()+"”中第"+currentrow+"行---"+(this.ERS.getRowSize()-1)+"行是数据行，如果是抵押物编号或质押物编号不能为空，否则，请选中这些行点击右键进行删除！");
			isPass=false;
		}
		//寄库凭证号不能为空
		String sPackageNo=DataConvert.toString(this.ERS.getStringWH("寄库凭证编号"));
		if(sPackageNo.length()==0){
			//throw new Exception("请确认表单“"+this.ERS.getSheet().getName()+"”中第"+currentrow+"行---"+(this.ERS.getRowSize()-1)+"行是数据行，如果是，寄库凭证编号不能为空，否则，请选中这些行点击右键进行删除！");
			isPass=false;
		}
		//寄库凭证号不能为空
		String sRightDoc=DataConvert.toString(this.ERS.getStringWH("权证类型"));
		String sRightDocNo=DataConvert.toString(this.ERS.getStringWH("权证编号"));
		if(sRightDoc.length()==0||sRightDocNo.length()==0){
			//throw new Exception("请确认表单“"+this.ERS.getSheet().getName()+"”中第"+currentrow+"行---"+(this.ERS.getRowSize()-1)+"行是数据行，如果是，寄库凭证编号不能为空，否则，请选中这些行点击右键进行删除！");
			isPass=false;
		}
		//检查抵质押物类型必须和表单名相同
		String sImpawnType1=DataConvert.toString(this.ERS.getStringWH("抵押物类型"));
		String sImpawnType2=DataConvert.toString(this.ERS.getStringWH("质押物类型"));
		String sSheetName=this.ERS.getSheet().getName();
		if(!sImpawnType1.equals(this.ERS.getSheet().getName())&&!sImpawnType2.equals(this.ERS.getSheet().getName())){
			throw new Exception("请确认表单“"+sSheetName+"”的名字与表中第"+currentrow+"行-"+this.ERS.getRowSize()+"行“抵押物类型”或“质押物类型”是否一致?如果不是数据行请选中这些行点击右键进行删除！");
		}
		*/
		return isPass;
	}
	public void prepare() throws Exception {
		int columnl=this.getERS().getColumnTCount();
		String column="",columnf="";
		for(int i=0;i<columnl;i++){
			column+=this.getERS().getColumnObjWI(i).getColumnName()+",";
			columnf+="?,";
		}
		column =column.substring(0, column.length()-1);
		columnf =columnf.substring(0, columnf.length()-1);
		String insertSql="insert into Batch_Case_Import("+
				column+
				")"+
				"values("+
				columnf+
				")";
		ps= Sqlca.conn.prepareStatement(insertSql);
	}
	/**
	 * 拼接SQL
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public void importRow() throws Exception {
		int columnl=this.getERS().getColumnTCount();
		for(int i=0;i<columnl;i++){
			String columnType=this.getERS().getColumnType(i);
			if("Number".equals(columnType)){
				ps.setDouble(i+1, this.getERS().getDouble(i));
			}else{
				ps.setString(i+1, this.getERS().getString(i));
			}
		}
		this.iCount++;
		ps.addBatch();
	}
}