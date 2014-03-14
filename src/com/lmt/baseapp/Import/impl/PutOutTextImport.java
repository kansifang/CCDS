package com.lmt.baseapp.Import.impl;

import java.sql.PreparedStatement;
import java.util.HashMap;

import com.lmt.baseapp.Import.base.CopyInfoUtil;
import com.lmt.baseapp.Import.base.TextImport;
import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.DBFunction;
import com.lmt.baseapp.util.DataConvert;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class PutOutTextImport extends TextImport {
	private final String[] sTables = new String[] { "Business_PutOut_Import"};
	public PutOutTextImport(Transaction Sqlca, String[] files,ASUser CurUser)throws Exception {
		super(Sqlca, files, new PutOutTextResultSet(Sqlca,CurUser));
	}
	public boolean checkObj() throws Exception {
		boolean isPass = true;
		int currentrow=this.TRS.getCurrentRow();
		// 上传文件的格式是否合适
		String sResult = DataConvert.toString(this.TRS.getString(5).trim());// 业务号
		if (sResult.length()==0) {
			throw new Exception("第"+currentrow+"行：业务编号不能为空");
		}
		return isPass;
	}
	public void importObj() throws Exception {
		HashMap<String, String> mm0 = null;
		for (String sTable : sTables) {
			PreparedStatement ps = this.TRS.getPs().get(sTable);
			String sLineID = DataConvert.toString(this.TRS.getString(3).trim());//额度编号
			String sBusinessType = DataConvert.toString(this.TRS.getString(4).trim());//产品代码
			mm0 = new HashMap<String, String>();
			ASResultSet rs = Sqlca.getASResultSet("select BCC.CustomerID,"
							+ " BCC.BusinessRate,"
							+ " BCC.RateFloat,"
							+ " BCC.RateFloatType,"
							+ " BCC.RateFloatDirection"
							+ " from CL_Info CI,Business_ContractCLInfo BCC"
							+ " where CI.LineID='"+sLineID+"'" +
								" and CI.ApplySerialNo=BCC.ApplySerialNo" +
								" and BCC.BusinessType='"+sBusinessType+"'");
			if (rs.next()) {
				mm0.put("CustomerID", DataConvert.toString(rs.getString(1)));
				mm0.put("BusinessRate", DataConvert.toString(rs.getString(2)));
				mm0.put("FloatRate", DataConvert.toString(rs.getString(3)));
				mm0.put("RateFloatType", DataConvert.toString(rs.getString(4)));
				mm0.put("FloatDirect", DataConvert.toString(rs.getString(5)));
			}
			rs.getStatement().close();
			String sSeriaNo = DBFunction.getSerialNo("Business_PutOut","SerialNo", Sqlca);//用正式表生成序列号
			mm0.put("SerialNo", sSeriaNo);
			ps = CopyInfoUtil.copyInfo("insert",this.TRS,"select * from "+sTable,"",null, null,mm0, Sqlca, ps);
			ps.addBatch();
			this.TRS.getPs().put(sTable, ps);
			this.iCount++;
		}
	}
}