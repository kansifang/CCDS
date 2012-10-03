package com.amarsoft.datainit.importobj;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
public abstract class TextResultSet extends ObjResultSet {
	private BufferedReader reader;
	private boolean fixLengthMode = false;
	private String separator = "";
	// 把表头和数据库字段对应起来，形成insert语句插入数据库
	public TextResultSet(Transaction sqlca) throws Exception {
		super(sqlca);
	}
	public BufferedReader getReader() {
		return reader;
	}
	public void setReader(BufferedReader reader) {
		this.reader = reader;
	}
	public void initResultSetPara() throws Exception {
		this.ps.clear();
		this.setCurrentRow(0);
		this.setEof(false);
		this.setValueToCode(this.Sqlca);
		this.setColumnTCount(0);
	}
	public boolean next() throws Exception {
		this.init();
		this.currentRow += 1;
		String rowString = "";
		try {
			rowString = reader.readLine();
		} catch (IOException e) {
			throw toException("Read line error.", e);
		}
		if (rowString == null) {
			this.eof = true;
			return false;
		}
		if (rowString.trim().equals("")) {
			return next();
		}
		if (!(this.fixLengthMode)) {
			String[] rowBuffer = rowString.split(this.separator, -1);
			if(this.getColumnTCount()==0){
				this.setColumnTCount(rowBuffer.length);
			}
			try {
				for (int i = 0; i < this.columnTCount; ++i) {
					this.setString(i + 1, rowBuffer[i].trim());
				}
			} catch (Exception ex) {
				throw toException("Split row error", ex);
			}
		} else {
			int start = 0;
			try {
				byte[] rowStringArray = rowString.getBytes();
				if (rowStringArray.length < this.rowSize) {
					throw new SQLException(" row size error ,check data file and metadata define!");
				}
				if(this.getColumnTCount()==0){
					this.setColumnTCount(this.getColumns().size());
				}
				for (int i = 0; i < this.columnTCount; ++i) {
					this.setString(i + 1, new String(rowStringArray, start,this.getColumnSize(i + 1)).trim());
					start += this.getColumnSize(i + 1);
				}
			} catch (Exception ex) {
				throw toException("Split row error", ex);
			}
		}
		return true;
	}
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

		rs = Sqlca
				.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'Currency'");
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

		rs = Sqlca
				.getASResultSet("SELECT ItemNo||' '||ItemName,ItemNo FROM Code_Library WHERE CodeNo = 'ImpawnRightDocType'");
		getMaps(rs, rightTypeMap);
		// 开始装各下拉框
		this.setValueCode("UnifiedOrgID".toUpperCase(), orgMap);
	}
	public String getSeparator() {
		return separator;
	}

	public void setSeparator(String separator) {
		this.separator = separator;
	}

	public boolean isFixLengthMode() {
		return fixLengthMode;
	}

	public void setFixLengthMode(boolean fixLengthMode) {
		this.fixLengthMode = fixLengthMode;
	}
}
