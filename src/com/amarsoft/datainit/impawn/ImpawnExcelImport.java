package com.amarsoft.datainit.impawn;

import java.sql.PreparedStatement;
import java.util.HashMap;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.ars.jxl.core.Cell;
import com.amarsoft.context.ASUser;
import com.amarsoft.datainit.importobj.CopyInfoUtil;
import com.amarsoft.datainit.importobj.ExcelImport;
/**
 * @author bllou 2012/08/13
 * @msg. 历史押品信息导入初始化
 */
public class ImpawnExcelImport extends ExcelImport{
	private String[] sTables=new String[]{"Impawn_Total_Import"};
	/**
	 * 解析xls 将数据插入数据表中
	 * @throws Exception 
	 */
	public ImpawnExcelImport(Transaction Sqlca, String[] files,ASUser CurUser) throws Exception {
		super(Sqlca, files,new ImpawnExcelResultSet(Sqlca,CurUser));
	}
	public boolean checkHead() throws Exception{
		int iCount=0;
		boolean isPass=true;
		Cell[]headrow =this.ERS.getSheet().getRow(0);
		// 上传文件的格式是否合适
		for (int iColumns = 0; iColumns < headrow.length; ++iColumns) {
			String temp = headrow[iColumns].getContents().trim();
			if (temp.equals("寄库凭证编号")){
				iCount++;
				if(!headrow[++iColumns].getContents().trim().equals("寄库封签号")
						|| !headrow[++iColumns].getContents().trim().equals("入库日期")
						|| !headrow[++iColumns].getContents().trim().equals("寄库凭证金额")
						|| !headrow[++iColumns].getContents().trim().equals("寄库凭证币种")
						|| !headrow[++iColumns].getContents().trim().equals("入库申请人")
						|| !headrow[++iColumns].getContents().trim().equals("入库申请机构")
						|| !headrow[++iColumns].getContents().trim().equals("入库机构")
						|| !headrow[++iColumns].getContents().trim().equals("入库柜员")
						|| !headrow[++iColumns].getContents().trim().equals("权证编号")
						|| !headrow[++iColumns].getContents().trim().equals("权证类型")
						|| !headrow[++iColumns].getContents().trim().equals("权证名称")
						|| !headrow[++iColumns].getContents().trim().equals("抵质押权利起始日期")
						|| !headrow[++iColumns].getContents().trim().equals("抵质押权利到期日期")
						|| !headrow[++iColumns].getContents().trim().equals("权利价值（权证有标注的要填写）")
						|| !headrow[++iColumns].getContents().trim().equals("权利价值币种") 
						|| !headrow[++iColumns].getContents().trim().equals("发证机关")){
					isPass=false;
				}
			}
		}
		if(iCount==0){
			isPass=false;
		}
		return isPass;
	}
	public boolean checkObj() throws Exception{
		boolean isPass=true;
		int currentrow=this.ERS.getCurrentRow()+1;
		//抵质押物编号不能为空
		String sImpawnID1=DataConvert.toString(this.ERS.getStringWH("抵押物编号"));
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
		return isPass;
	}
	/**
	 * 拼接SQL
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws Exception 
	 * @throws Exception
	 */
	public void importObj() throws Exception {
		// 押品管理申请
		HashMap<String, String> mm0 = null;
		for(String sTable:sTables){
			PreparedStatement ps=this.ERS.getPs().get(sTable);
			//插入excel内容到数据库临时表中
			String sImpawnID =DataConvert.toString(this.ERS.getStringWH("抵押物编号"));
			sImpawnID=sImpawnID.length()==0?DataConvert.toString(this.ERS.getStringWH("质押物编号")):sImpawnID;
			String sMFCustomerID = "";
			String sApplySerialNo = "";
			String sLineManID = "";
			String sImpawnStatus = "";
			ASResultSet rs = Sqlca.getASResultSet("select GI.GuarantyStatus," +
								" getMFCustomerID(BCC.CustomerID) as MFCustomerID,"
								+ " BCC.CustomerID,"
								+ " getCustomerName(BCC.CustomerID),"
								+ " BCC.SerialNo,"
								+ " BCC.ApplySerialNo,"
								+ " BCC.LineManID"
								+ " from Guaranty_Info GI,Guaranty_Relative GR,Business_ContractCLInfo BCC"
								+ " where GI.GuarantyID='"+sImpawnID+"'"
								+ " and GI.GuarantyID=GR.GuarantyID"
								+ " and GR.ObjectType in('BusinessContract','CBBusContract')"
								+ " and GR.ObjectNo=BCC.RelativeSerialNo"
								+ " and BCC.SerialNo=BCC.CreditAggreeMent");
			if (rs.next()) {
				sMFCustomerID = DataConvert.toString(rs.getString("MFCustomerID"));
				sApplySerialNo = DataConvert.toString(rs.getString("ApplySerialNo"));
				sLineManID = DataConvert.toString(rs.getString("LineManID"));
				sImpawnStatus = DataConvert.toString(rs.getString("GuarantyStatus"));
			}
			rs.getStatement().close();
			// 总的临时表
			String sSeriaNo = DBFunction.getSerialNo("Impawn_Total_Import", "SerialNo", Sqlca);//以申请管理表生成序列号
			mm0 =new HashMap<String, String>();
			mm0.put("SerialNo", sSeriaNo);
			mm0.put("ObjectType", "ImpawnInApply");
			mm0.put("MFCustomerID", sMFCustomerID);
			mm0.put("ApplySerialNo", sApplySerialNo);
			mm0.put("RightDocStatus", "0103");//已入库
			mm0.put("LineManID", sLineManID);
			mm0.put("ImpawnStatus", sImpawnStatus);//原Guaranty_Info中的状态
			mm0.put("PackageStatus", "0103");//已入库
			mm0.put("ImpawnClass", "30");//普通类
			mm0.put("IsHold", "1");//已入库
			mm0.put("InputDataType", "copy");
			mm0.put("HoldType", "1010");
			ps =CopyInfoUtil.copyInfo("insert",this.ERS,"select * from "+sTable,"",null,null, mm0, Sqlca, ps);
			ps.addBatch();
			this.ERS.getPs().put(sTable,ps);
			this.iCount++;
		}
	}
}