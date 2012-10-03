package com.amarsoft.datainit.importobj;

import java.sql.SQLException;
import java.text.NumberFormat;
import java.util.HashMap;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.ars.jxl.core.Cell;
import com.amarsoft.ars.jxl.core.CellType;
import com.amarsoft.ars.jxl.core.NumberCell;
import com.amarsoft.ars.jxl.core.Sheet;

public abstract class ExcelResultSet extends ObjResultSet {
	protected Sheet sheet = null;
	
	// 把表头和数据库字段对应起来，形成insert语句插入数据库
	public ExcelResultSet(Transaction sqlca)throws SQLException {
		super(sqlca);
	}
	public Sheet getSheet() {
		return sheet;
	}
	public void setSheet(Sheet sheet) {
		this.sheet = sheet;
	}
	public boolean next() throws Exception {
		this.init();
		//DecimalFormat nf = new DecimalFormat("#0");
		NumberFormat nf = NumberFormat.getInstance();
		String svalue = "";
		this.currentRow ++;
		try {
			if (this.currentRow >= this.rowCount) {
				return false;
			}
			Cell[] valuerow = this.sheet.getRow(this.currentRow);
			if (valuerow.length == 0) {
				this.eof = true;
				return false;
			}
			for (int i = 0; i < this.columnTCount; ++i) {
				if (i >= valuerow.length) {
					svalue = "";
				} else {
					CellType CT=valuerow[i].getType();
					if(CT==CellType.NUMBER||CT==CellType.NUMBER_FORMULA){
						svalue=nf.format(((NumberCell)valuerow[i]).getValue()  );
					}else{
						svalue=valuerow[i].getContents().trim();
					}
				}
				this.setString(i + 1, svalue);
			}
		} catch (Exception e) {
			throw toException("初始化一行sheet出错！", e);
		}
		return true;
	}
	public void initResultSetPara() throws Exception {
		this.ps.clear();
		this.setCurrentRow(0);
		this.setEof(false);
		this.setValueToCode(this.Sqlca);
		this.setaReplaceBWithAInValue(new String[][] { { "￥", "" },{ "\\$", "" }, { ",", "" }, { "\"", "" },{ "渤海银行", "" },{ "渤海银行股份有限公司", "" }});
		this.setRowCount(this.sheet.getRows());
		this.setColumnTCount(this.sheet.getColumns());
		//自动设置标题序列
		for (int i = 0; i < this.columnTCount; i++) {
			String head=this.sheet.getCell(i, 0).getContents().trim();
			if(this.containsHead(head)&&this.getColumnIndexWH(head)>0){//如果标题字段重复，为本标题字段后面加@再追加本标题字段再作为本标题字段，所以设置一次后必然index>0,所以读excel第二个字段时可以此作判断
				int headCurrentIndex =this.getHeadCurrentIndex(head);
				if(headCurrentIndex!=0){//恢复到默认状态，主要是针对配置
					this.setHeadCurrentIndex(head, 0);
				}
				this.setHeadCurrentIndex(head, headCurrentIndex+1);
				head=head+"@"+(headCurrentIndex+1);
			}
			this.setColumnIndexWH(head, i + 1);
		}
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

		rs = Sqlca.getASResultSet("SELECT ItemNo||' '||ItemName,ItemNo FROM Code_Library WHERE CodeNo = 'ImpawnRightDocType'");
		getMaps(rs, rightTypeMap);
		// 开始装各下拉框
		this.setValueCode("IMPAWNTYPE", impawnTypeMap);
		this.setValueCode("TOTAMOUNTCURRENCY", currencyMap);
		this.setValueCode("RIGHTDOC", rightTypeMap);
		this.setValueCode("RIGHTVALUECURRENCY", currencyMap);
		this.setValueCode("WARRANTTYPE", warrantTypeMap);
		this.setValueCode("INSUREVALUEBY", insureValueByMap);
		this.setValueCode("ISDOCUMENT", yesNoMap);
		this.setValueCode("HOLDAPPLYUSERID", userMap);
		this.setValueCode("HOLDAPPLYORGID", orgMap);
		this.setValueCode("HOLDUNIFIEDORGID", orgMap);
		this.setValueCode("HOLDUNIFIEDORGID", orgMap);
		this.setValueCode("HOLDUNIFIEDUSERID", userMap);
		this.setValueCode("INPUTUSERID", userMap);
		this.setValueCode("UPDATEUSERID", userMap);
		this.setValueCode("INPUTORGID", orgMap);
		this.setValueCode("UPDATEORGID", orgMap);
	}
}
