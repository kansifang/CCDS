package com.amarsoft.datainit.batchno;

import java.sql.PreparedStatement;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.context.ASUser;
import com.amarsoft.datainit.importobj.CopyInfoUtil;
import com.amarsoft.datainit.importobj.TextImport;
/**
 * @author bllou 2012/08/13
 * @msg.业务批次对照信息导入
 */
public class BatchNoTextImport extends TextImport {
	private final String[] sTables = new String[] {"Business_PutOut_Batch_Import"};
	public BatchNoTextImport(Transaction Sqlca, String[] files,ASUser CurUser)throws Exception {
		super(Sqlca, files, new BatchNoTextResultSet(Sqlca,CurUser));
	}
	public boolean checkObj() throws Exception {
		boolean isPass = true;
		int currentrow=this.TRS.getCurrentRow();
		String sPutOutNo1=DataConvert.toString(this.TRS.getStringWH("票号"));
		String sPutOutNo2=DataConvert.toString(this.TRS.getStringWH("业务编号"));
		String sPutOutNo3=DataConvert.toString(this.TRS.getStringWH("批次号"));
		if(sPutOutNo1.length()==0&&sPutOutNo2.length()==0&&sPutOutNo3.length()==0){
			throw new Exception("第"+currentrow+"行：票号与批次号或业务编号与批次号不能为空");
		}
		// 上传文件的格式是否合适
		return isPass;
	}
	public void importObj() throws Exception {
		// 插入Text内容到数据库目标表中
		for (String sTable : sTables) {
			PreparedStatement ps = this.TRS.getPs().get(sTable);
			ps = CopyInfoUtil.copyInfo("insert",this.TRS, "select * from "+sTable,"",null, null,null, Sqlca, ps);
			ps.addBatch();
			this.TRS.getPs().put(sTable, ps);
			this.iCount++;
		}
	}
}