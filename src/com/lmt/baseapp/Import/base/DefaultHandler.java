package com.lmt.baseapp.Import.base;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

/**
 * @author Administrator
 * 
 */
public abstract class DefaultHandler {
	protected ObjRow record=null;
	protected Transaction Sqlca = null;
	protected int rowCount = 0;
	protected int currentRow = 0;
	protected boolean eof = false;
	protected int rowSize = 0;
	protected boolean reInitPara=true;
			
	public DefaultHandler(ObjRow or,Transaction sqlca) throws SQLException {
		this.record=or;
		this.Sqlca = sqlca;
	}
	;
	public boolean isReInitPara() {
		return reInitPara;
	}
	public void setReInitPara(boolean reInitPara) {
		this.reInitPara = reInitPara;
	}
	public Transaction getSqlca() {
		return Sqlca;
	}
	public void setSqlca(Transaction sqlca) {
		Sqlca = sqlca;
	}

	public int getRowSize() {
		return rowSize;
	}

	public void setRowSize(int rowSize) {
		this.rowSize = rowSize;
	}

	public int getRowCount() {
		return rowCount;
	}
	public void setRowCount(int rowCount) {
		this.rowCount = rowCount;
	}
	public int getCurrentRow() {
		return currentRow;
	}

	public void setCurrentRow(int currentRow) {
		this.currentRow = currentRow;
	}

	public boolean isEof() {
		return eof;
	}

	public void setEof(boolean eof) {
		this.eof = eof;
	}
	
	public ObjRow getRecord() {
		return record;
	}
	public void setRecord(ObjRow record) {
		this.record = record;
	}
	protected void init()throws Exception{
		if(this.reInitPara){
			this.initPara();
			this.reInitPara=false;
		}
	}
	//初始化metadata
	public void initMeta(String configNo,String Key,ASUser curUser) throws Exception {
		this.record=new ObjRow(configNo,Key, curUser,this.Sqlca);
	}
	public abstract void initPara() throws Exception;
	public abstract boolean next() throws Exception;
	// 主要是处理 在excel中的显示值和在数据库中是代码值的情况
		/**
		 * 将所有 sheet 中 通过下拉框选值的字段添加到map中 形如：男 1，女 2..
		 * 
		 * @throws Exception
		 */
		protected void setValueToCode(Transaction Sqlca) throws Exception {
			ASResultSet rs = null; // 结果集
			// 装各下拉框的值
			HashMap<String, String> businessTypeMap = new HashMap<String, String>();
			HashMap<String, String> vouchTypeMap = new HashMap<String, String>();
			HashMap<String, String> lUseModMap = new HashMap<String, String>();
			HashMap<String, String> drawingMap = new HashMap<String, String>();
			HashMap<String, String> repayType1Map = new HashMap<String, String>();
			HashMap<String, String> intUnitMap = new HashMap<String, String>();
			HashMap<String, String> rateFloatTypeMap = new HashMap<String, String>();
			HashMap<String, String> rateFloatDirectionMap = new HashMap<String, String>();
			HashMap<String, String> structureModeMap = new HashMap<String, String>();
			HashMap<String, String> loanTermMap = new HashMap<String, String>();
			HashMap<String, String> cutFlagMap = new HashMap<String, String>();
			HashMap<String, String> isHouseLoanMap = new HashMap<String, String>();
			HashMap<String, String> impawnTypeMap = new HashMap<String, String>();
			HashMap<String, String> isArgMap = new HashMap<String, String>();
			HashMap<String, String> creditNatureMap = new HashMap<String, String>();
			HashMap<String, String> discountOtherBusinessTypeMap = new HashMap<String, String>();
			HashMap<String, String> intTypeMap = new HashMap<String, String>();
			HashMap<String, String> cautionRateMap = new HashMap<String, String>();
			HashMap<String, String> isControlGoodsMap = new HashMap<String, String>();
			HashMap<String, String> assureTypeMap = new HashMap<String, String>();
			HashMap<String, String> busiensstype2Map = new HashMap<String, String>();
			HashMap<String, String> repayType2Map = new HashMap<String, String>();
			HashMap<String, String> agentpayTypeMap = new HashMap<String, String>();

			HashMap<String, String> rightTypeMap = new HashMap<String, String>();// 权证类型
			HashMap<String, String> currencyMap = new HashMap<String, String>();
			HashMap<String, String> yesNoMap = new HashMap<String, String>();
			HashMap<String, String> insureValueByMap = new HashMap<String, String>();// 投保价值依据
			HashMap<String, String> warrantTypeMap = new HashMap<String, String>();// 保险类型
			HashMap<String, String> userMap = new HashMap<String, String>();// 用户
			HashMap<String, String> orgMap = new HashMap<String, String>();// 机构

			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'Currency'");
			getMaps(rs, currencyMap);

			rs = Sqlca.getASResultSet("SELECT Typename,Typeno FROM Business_Type");
			getMaps(rs, businessTypeMap);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'VouchType'");
			getMaps(rs, vouchTypeMap);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'LUseMod'");
			getMaps(rs, lUseModMap);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'YesNo'");
			getMaps(rs, yesNoMap);
			// yesNoMap.put("是", "1");
			// yesNoMap.put("否", "2");

			// rs =
			// Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'DrawingType'");
			// getMaps(rs, drawingMap);
			drawingMap.put("一次提款", "01");
			drawingMap.put("分次提款", "02");

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'RepayType1'");
			getMaps(rs, repayType1Map);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'IntUnit'");
			getMaps(rs, intUnitMap);

			// rs =
			// Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'RateFloatType'");
			// getMaps(rs, rateFloatTypeMap);
			rateFloatTypeMap.put("浮动比率", "0");
			rateFloatTypeMap.put("浮动点", "1");

			rateFloatDirectionMap.put("上浮", "01");
			rateFloatDirectionMap.put("下浮", "02");

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'StructureMode'");
			getMaps(rs, structureModeMap);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'LoanTerm'");
			getMaps(rs, loanTermMap);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'CutFlag'");
			getMaps(rs, cutFlagMap);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'IsHouseLoan'");
			getMaps(rs, isHouseLoanMap);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'GuarantyList'");
			getMaps(rs, impawnTypeMap);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'IsArg'");
			getMaps(rs, isArgMap);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'CreditNature'");
			getMaps(rs, creditNatureMap);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'DiscountOtherBusinessType'");
			getMaps(rs, discountOtherBusinessTypeMap);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'IntType'");
			getMaps(rs, intTypeMap);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'CautionRate'");
			getMaps(rs, cautionRateMap);

			isControlGoodsMap.put("是", "01");
			isControlGoodsMap.put("否", "02");
			isControlGoodsMap.put("皆可", "03");

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'AssureType'");
			getMaps(rs, assureTypeMap);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'Busiensstype2'");
			getMaps(rs, busiensstype2Map);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'RepayType2'");
			getMaps(rs, repayType2Map);

			rs = Sqlca
					.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'AgentpayType'");
			getMaps(rs, agentpayTypeMap);

			rs = Sqlca
					.getASResultSet("SELECT OrgName,OrgID FROM org_info ORDER BY OrgLevel");
			getMaps(rs, orgMap);

			rs = Sqlca.getASResultSet("SELECT UserName,UserID FROM user_info");
			getMaps(rs, userMap);

			rs = Sqlca
					.getASResultSet("SELECT ItemName,ItemNo FROM Code_Library WHERE CodeNo = 'WarrantType'");
			getMaps(rs, warrantTypeMap);

			rs = Sqlca
					.getASResultSet("SELECT ItemName,ItemNo FROM Code_Library WHERE CodeNo = 'InsureValueBy'");
			getMaps(rs, insureValueByMap);

			rs = Sqlca.getASResultSet("SELECT ItemNo||' '||ItemName,ItemNo FROM Code_Library WHERE CodeNo = 'ImpawnRightDocType'");
			getMaps(rs, rightTypeMap);
			// 开始装各下拉框
			/*
			this.record.setValueCode("IMPAWNTYPE", impawnTypeMap);
			this.record.setValueCode("TOTAMOUNTCURRENCY", currencyMap);
			this.record.setValueCode("RIGHTDOC", rightTypeMap);
			this.record.setValueCode("RIGHTVALUECURRENCY", currencyMap);
			this.record.setValueCode("WARRANTTYPE", warrantTypeMap);
			this.record.setValueCode("INSUREVALUEBY", insureValueByMap);
			this.record.setValueCode("ISDOCUMENT", yesNoMap);
			this.record.setValueCode("HOLDAPPLYUSERID", userMap);
			this.record.setValueCode("HOLDAPPLYORGID", orgMap);
			this.record.setValueCode("HOLDUNIFIEDORGID", orgMap);
			this.record.setValueCode("HOLDUNIFIEDORGID", orgMap);
			this.record.setValueCode("HOLDUNIFIEDUSERID", userMap);
			this.record.setValueCode("INPUTUSERID", userMap);
			this.record.setValueCode("UPDATEUSERID", userMap);
			this.record.setValueCode("INPUTORGID", orgMap);
			this.record.setValueCode("UPDATEORGID", orgMap);
			*/
		}
		/**
		 *把 从数据库中获取的显示值 代码值放入Map
		 * 
		 * @param rs
		 * @param MapName
		 * @throws Exception
		 */
		protected void getMaps(ASResultSet rs, HashMap<String, String> MapName)
				throws Exception {
			while (rs.next()) {
				// 将名称作为key 编号为value
				MapName.put(rs.getString(1), rs.getString(2));
			}
			rs.getStatement().close();
		}
}
