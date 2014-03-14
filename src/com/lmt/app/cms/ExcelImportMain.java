package com.lmt.app.cms;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;

public class ExcelImportMain {
	
	
	private static Map coulmnMap;
	private static Connection con = null;
	/**
	 * @param args
	 * @throws FileNotFoundException 
	 * @throws SQLException 
	 */
	public static void main(String[] args) throws FileNotFoundException, SQLException {

		String path = "C:\\aaa.xls";
		
		initMap();

		InputStream is = new FileInputStream(new File(path));

		Workbook workbook;
		try {
			workbook = Workbook.getWorkbook(is);

			int count = workbook.getSheets().length;

			if (count == 0)
				return;

			Sheet sheet;

			for (int i = 0; i < count - 1; i++) {
				sheet = workbook.getSheet(i);
				sheet.getRows();
				String str = getSQLTempalte(sheet);
				
			}

		} catch (BiffException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	
	/**
	 * 模板信息初始化
	 */
	private static void initMap(){
		coulmnMap = new HashMap(100);
		coulmnMap.put("合同流水号", "SERIALNO");
		coulmnMap.put("对应原有合同编号", "RELATIVESERIALNO");
		coulmnMap.put("额度编号（批复通过产生）", "RELATIVESERIALNO1");
		coulmnMap.put("申请书编号", "APPLYSERIALNO");
		coulmnMap.put("入账机构名称", "CLTYPEID");
		coulmnMap.put("额度类型名称", "CLTYPENAME");
		coulmnMap.put("申请类型", "APPLYTYPE");
		coulmnMap.put("借款人代码", "CUSTOMERID");
		coulmnMap.put("借款人名称", "CUSTOMERNAME");
		coulmnMap.put("核心客户代码", "MFCUSTOMERID");
		coulmnMap.put("对应综合授信合同号", "CREDITAGGREEMENT");
		coulmnMap.put("合同编号", "LINEMANID");
		coulmnMap.put("授信额度金额", "LINESUM1");
		coulmnMap.put("最大限额", "LINESUM2");
		coulmnMap.put("业务币种", "CURRENCY");
		coulmnMap.put("起始日", "BEGINDATE");
		coulmnMap.put("到期日", "ENDDATE");
		coulmnMap.put("业务品种名称", "BUSINESSTYPE");
		coulmnMap.put("担保方式", "VOUCHTYPE");
		coulmnMap.put("担保方式描述", "VOUCHTYPE1");
		coulmnMap.put("是否循环", "ROTATIVE");
		coulmnMap.put("约定用途", "PURPOSE");
		coulmnMap.put("资金监管帐号", "OVERSEEACCOUNT");
		coulmnMap.put("业务类型", "BUSINESSTYPE1");
		coulmnMap.put("提款方式", "DRAWINGTYPE");
		coulmnMap.put("还款方式", "REPAYTYPE");
		coulmnMap.put("计息周期", "ICCYC");
		coulmnMap.put("结息日", "INTTIME");
		coulmnMap.put("执行年利率(%)", "BUSINESSRATE");
		coulmnMap.put("浮动值", "RATEFLOAT");
		coulmnMap.put("浮动方式", "RATEFLOATTYPE");
		coulmnMap.put("浮动方向", "RATEFLOATDIRECTION");
		coulmnMap.put("宽限期", "GRACEPERIOD");
		coulmnMap.put("逾期罚息标准", "STATNDARD1");
		coulmnMap.put("挤占挪用贷款罚息标准", "FINERATE");
		coulmnMap.put("贷款组织方式", "STRUCTUREMODE");
		coulmnMap.put("贷款期限", "LOANTERM");
		coulmnMap.put("是否股东贷款", "STOCFLAG");
		coulmnMap.put("关联交易", "TRAFLAG");
		coulmnMap.put("是否货押", "LOADFLAG");
		coulmnMap.put("两高一资", "CUTFLAG");
		coulmnMap.put("贷款实际投向", "DIRECTION");
		coulmnMap.put("三高一汰", "CUTTYPE2");
		coulmnMap.put("是否涉农贷款", "ISARG");
		coulmnMap.put("授信性质", "OCCURTYPE");
		coulmnMap.put("是否异地授信", "ISLOCALCREDIT");
		coulmnMap.put("委托人代码", "THIRDPARTY1");
		coulmnMap.put("委托人名称", "THIRDPARTY2");
		coulmnMap.put("费率", "PREPAYSTAND01");
		coulmnMap.put("贴现付息方式", "ACCEPTINTTYPE");
		coulmnMap.put("是否先贴后查", "ISFISTACCEPT");
		coulmnMap.put("保证金比例", "BAILRATIO");
		coulmnMap.put("保证金计息方式", "BAILTYPE");
		coulmnMap.put("手续费比率", "PDGRATIO");
		coulmnMap.put("收款人", "GATHERINGNAME");
		coulmnMap.put("购销合同号", "BUYCONTACTNO");
		coulmnMap.put("保函种类", "SAFEGUARDTYPE");
		coulmnMap.put("受益人", "BENEFICIARY");
		coulmnMap.put("单笔融资比率", "BUSINESSPROP");
		coulmnMap.put("是否办理保险", "ISINSURE");
		coulmnMap.put("单笔最长期限", "TERMDAY");
		coulmnMap.put("业务种类", "BUSIENSSTYPE2");
		coulmnMap.put("信用证/发票编号", "LCNO");
		coulmnMap.put("授信金额与信用证/发票金额比率", "OTHERRATE");
		coulmnMap.put("手续费", "PDGSUM");
		coulmnMap.put("代付结算方式", "AGENTPAYTYPE");
		coulmnMap.put("是否掌控货权", "ISCONTROLGOODS");
		coulmnMap.put("入帐机构", "PUTOUTORGID");
		coulmnMap.put("当前合同管户机构", "MANAGEORGID");
		coulmnMap.put("当前合同管户人", "MANAGUSERID");
		coulmnMap.put("经办机构", "OPERATEORGID");
		coulmnMap.put("经办人", "OPERATEUSERID");
		coulmnMap.put("登记机构", "INPUTORGID");
		coulmnMap.put("登记人", "INPUTUSERID");
		coulmnMap.put("登记日期", "INPUTDATE");
		coulmnMap.put("更新日期", "UPDATEDATE");
		coulmnMap.put("额度级别", "LINELEVEL");
		coulmnMap.put("额度层次", "LMTLEVEL");
		coulmnMap.put("额度使用方式", "LUSEMOD");
		coulmnMap.put("币种限制", "LMTCURRENCY");
		coulmnMap.put("所属额度编号", "OWNERLINEID");
		coulmnMap.put("备注", "REMARK");
		coulmnMap.put("保存状态", "TEMPSAVEFLAG");
		coulmnMap.put("出具日期", "OUTSTARTDATE");
		coulmnMap.put("承诺事项", "PROMISESINFO");
		coulmnMap.put("约定条件", "ASSUMPSITIF");
		coulmnMap.put("贴现业务种类", "OTHERBUSINESSTYPE");
		coulmnMap.put("承兑银行/承兑人", "ACCEPTOR");
		coulmnMap.put("是否低风险业务", "ISLOWRISK");
		coulmnMap.put("计息期单位", "INTUNIT");
		coulmnMap.put("房地产贷款", "ISHOUSELOAN");
	}
	
	
	
	/**
	 * exl的表头找出对应的列名
	 * @param key
	 * @return
	 */
	private static String getCoulmnName(String key) {

		return (String) coulmnMap.get(key);

	}
	
	
	/**
	 * 返回SQL
	 * @param sheet
	 * @param icol
	 * @return
	 * @throws SQLException 
	 */
	public static String getSQLTempalte(Sheet sheet) throws SQLException {

		String temp = "";
		String values = "";

		Cell[] row = sheet.getRow(0);
		int iCol = row.length;

		for (int i = 0; i < iCol; i++) {
			
			//temp = row[i].getContents();			
			//System.out.println(temp+":"+getCoulmnName(temp));
			if (getCoulmnName(row[i].getContents()) != null) {
				values += "?,";
			}
			temp += getCoulmnName(row[i].getContents()) + ",";
		}
		temp = temp.replaceAll("null,", "");
		temp = temp.substring(0, temp.length() - 1);
		values = values.substring(0, values.length() - 1);
		String sSql = "insert into BUSINESS_CONTRACTCLINFO_BAK_LV(" + temp+ ") values(" + values + ")";
		System.out.println(sSql);
		PreparedStatement pstmt = con.prepareStatement(sSql);

		
		for (int rows = 1;rows < sheet.getRows();rows++){
			row = sheet.getRow(rows);
			for(int col = 0;col < iCol;col++){
				pstmt.setString(col+1, row[col].getContents().trim());
			}
			pstmt.addBatch();
			
			if(rows % 100 == 0){
				pstmt.executeBatch();
			}
			
		}
		
		pstmt.close();
		
		
		System.out.println(sSql);
		return "";
	}
}
