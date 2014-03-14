package com.lmt.app.cms;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.HashMap;
import java.util.Map;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

import com.lmt.baseapp.util.DBFunction;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

/**
 * 
 * @author ylv 2010/06/25
 * @msg. 模板信息导入
 */
public class LeadingExcelImport {
	public String msg = "";
	
	private Map coulmnMap = new HashMap(100);
	//装各下拉框
	private Map relativeMap = new HashMap();
	
	private Connection con = null;
	//PreparedStatement pstmt = null;

	/**
	 * 解析xls 将数据插入数据表中
	 */
	public LeadingExcelImport(Transaction Sqlca, String path, String Today,
			String OrgID, String UserID) {
		try {
			initMapInfo(Sqlca);
			int Columnscount = 0;
			int Rowscount = 0;
			int RealRows = 0;
			int RealColumns = 0;						

			InputStream is = new FileInputStream(new File(path)); //得到输入流文件

			Workbook workbook = Workbook.getWorkbook(is);

			int count = workbook.getSheets().length;
 
			for (int i = 0; i < count-2; ++i) {
				String temp;
				//SimpleDateFormat format = new SimpleDateFormat("yyyyMMddhhmmss");
				//String s5 = new String(format.format(new Date())); //当前日期
				
				
				Sheet sheet = workbook.getSheet(i);
				Columnscount = sheet.getColumns(); //得到所有列
				Rowscount = sheet.getRows(); //所有行
				
				for (RealColumns = 0; RealColumns < Columnscount; ++RealColumns) {
					temp = sheet.getCell(RealColumns, 1).getContents().trim();

					if (temp.equals(""))
						break;
					if (temp == null) {
						break;
					}

				}
				
				for (RealRows = 0; RealRows < Rowscount; ++RealRows) {
					temp = sheet.getCell(0, RealRows).getContents().trim();
					if (temp.equals(""))
						break;
					if (temp == null)
						break;
				}
				
				//根据上面的两个FOR 循环判断是否有数据
				if ((RealColumns == 0) || (RealRows == 0)) {
					is.close();
					workbook.close();
					throw new Exception("gs");
				}
				
				//判断上传文件的格式是否合适
				String dCol1ValueName = sheet.getCell(0, 0).getContents().trim();
				String dCol2ValueName = sheet.getCell(1, 0).getContents().trim();
				String dCol3ValueName = sheet.getCell(2, 0).getContents().trim();
				String dCol4ValueName = sheet.getCell(3, 0).getContents().trim();
				String dCol5ValueName = sheet.getCell(4, 0).getContents().trim();
				String dCol6ValueName = sheet.getCell(5, 0).getContents().trim();
				
				if ((!(dCol1ValueName.equals("额度编号（最终产生的额度编号）")))
						|| (!(dCol2ValueName.equals("对应原有合同编号")))
						|| (!(dCol3ValueName.equals("额度编号（批复通过产生）")))
						|| (!(dCol4ValueName.equals("申请书编号")))
						|| (!(dCol5ValueName.equals("入账机构名称")))
						|| (!(dCol6ValueName.equals("借款人名称")))){
					is.close();
					workbook.close();
					throw new Exception("gs");
				}
				
				//在这进行校验
				//获取每行每列的值进行校验 根据表头 在相关的表中进行查找
				

//				Cell[] row = sheet.getRow(0);
//				int iCol = row.length;
//				System.out.println(iCol);			
//				for (int i = 0; i < iCol; i++) {
//					ColumnName = getCoulmnName( privReplace(row[i].getContents()));
//					if (ColumnName != null) {
//						values += "?,";
//						temp += ColumnName + ",";
//						iCount++;
//					}
//				}
				if (1==1) {
					
					for (int k = 1; k < Rowscount; k++) {
						Cell[] row = sheet.getRow(k);
						int iCol = row.length;
						for (int j = 0; j < iCol; j++) {
							String sItemHead = sheet.getCell(j, 0).getContents().trim();
							String sContents = row[j].getContents().trim();
							System.out.println(sContents+"*************"+sItemHead);
						}
					}
				}
				
				con = Sqlca.conn;
				this.initMap();
				//String sSql1 = getSQLTempalte(Sqlca,sheet,s5);
				String sSql1 = getSQLTempalte(Sqlca,sheet);
				System.out.println(sSql1);
			}
			is.close();
			workbook.close();
			this.msg = "导入成功";
		} catch (Exception e) {
			if (e.getMessage() == "gs") {
				this.msg = "导入格式错误";
			} else {
				e.printStackTrace();
				this.msg = "导入失败";
			}
		}
	}
	
	/**
	 * 测试方法
	 */
	/*
	private void testImport() throws FileNotFoundException, SQLException{

			String path = "C:\\test.xls";

			InputStream is = new FileInputStream(new File(path));

			Workbook workbook;
			try {
				workbook = Workbook.getWorkbook(is);

				int count = workbook.getSheets().length;

				if (count == 0)
					return;

				Sheet sheet;

				for (int i = 0; i < count; i++) {
					sheet = workbook.getSheet(i);

					getSQLTempalte(sheet);
				}

			} catch (BiffException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		*/
		
		
		/**
		 * 模板信息初始化
		 */

		private void initMap(){
			coulmnMap = new HashMap(100);
			coulmnMap.put("合同流水号", "SERIALNO");
			coulmnMap.put("对应原有合同编号", "RELATIVESERIALNO");
			coulmnMap.put("额度编号（批复通过产生）", "RELATIVESERIALNO1");
			coulmnMap.put("额度编号（最终产生的额度编号）", "RELATIVESERIALNO2");
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
			coulmnMap.put("农村区域", "VILLAGEREGION");
			coulmnMap.put("支农贷款类型", "ZNLOANTYPE");
		}
		
		/**
		 * exl的表头找出对应的列名
		 * @param key
		 * @return
		 */
		private String getCoulmnName(String key) {
			if (coulmnMap == null)
				return "";
			return (String) coulmnMap.get(key);

		}
		
		
		/**
		 * 拼接SQL
		 * @param sheet
		 * @param icol
		 * @return
		 * @throws Exception 
		 */
		public String getSQLTempalte(Transaction Sqlca,Sheet sheet) throws Exception {

			String temp = "";
			String values = "";
			String ColumnName ="";
			int iCount = 0;
			
			

			Cell[] row = sheet.getRow(0);
			
			int iCol = row.length;

			System.out.println(iCol);
			
			for (int i = 0; i < iCol; i++) {
				
				ColumnName = getCoulmnName( privReplace(row[i].getContents()));
				
				if (ColumnName != null) {
					values += "?,";
					temp += ColumnName + ",";
					iCount++;
				}
			}
			System.out.println(iCount);
			temp = temp.replaceAll("null,", "");
			temp = temp.substring(0, temp.length() - 1); //截取字段中多余的“,”
			values = values.substring(0, values.length() - 1); //截取values中多余的","
			String sSql = "insert into Business_Contractclinfo_Bak(SERIALNO," + temp+ ") values(?," + values + ")"; //拼接SQL
			String vSql = "insert into templet_relatedinfo(Lineid,Bcseriano) values(?,?)"; 
			String bSql = "insert into Business_Contract(Serialno,Relativeserialno) values(?,?)";
			
			
			System.out.println("INSERT SQL:=="+sSql);
			PreparedStatement pstmt = con.prepareStatement(sSql);
			PreparedStatement vstmt = con.prepareStatement(vSql);			
			PreparedStatement bstmt = con.prepareStatement(bSql);
			
			for (int rows = 1;rows < sheet.getRows();rows++){
				row = sheet.getRow(rows);	
				String sResult = sheet.getCell(0, rows).getContents().trim();
				
				System.out.println("sResult=="+sResult);
				if(sResult == null ) sResult ="";
				if (!sResult.equals("")) {  //判断某行数据是否为空 若为空 此行不会插入数据表中 根据每个sheet的 第一列的值进行判断的
					//String Random = getRandomNum(); //得到4位随机数
					
					String sSeriaNo = DBFunction.getSerialNo("Business_Contractclinfo_Bak","SERIALNO",Sqlca);
					
					pstmt.setString(1,sSeriaNo); //赋给每条记录 流水号
					
					String lastLineID = "";
					String contractID = "";
					
					
					for(int col =1;col < iCount+1;col++){
						try{
							String sItemHead = sheet.getCell(col-1, 0).getContents().trim();
							String sContents = row[col-1].getContents().trim();
							String sItemValue = getItemNo(sItemHead,sContents);
							System.out.println(sItemHead+"~~"+sItemValue);
							
							if("额度编号（最终产生的额度编号）".equals(sItemHead)){
								lastLineID = sItemValue;
							}
							if("对应原有合同编号".equals(sItemHead)){
								contractID = sItemValue;
							}									
							
							pstmt.setString(col+1,sItemValue); //给每条生成的SQL语句一一赋值
						}catch(NullPointerException ex){
							System.out.println(" 内容为空！跳出循环 ");
							break;
						}
					}
					
					if("" == contractID){
						bstmt.setString(1,lastLineID);
						bstmt.setString(2,"MD"+lastLineID);
						
						vstmt.setString(1,lastLineID); 
						vstmt.setString(2,"MD"+lastLineID); 
					}
					if(contractID != ""){						
						vstmt.setString(1,lastLineID); 
						vstmt.setString(2,"MD"+contractID); 
					}
										
					pstmt.addBatch(); //批量执行
					if("" == contractID){
						bstmt.addBatch(); //批量执行
					}
					vstmt.addBatch(); //批量执行								
					if(rows % 50 == 0){
						pstmt.executeBatch();
						if("" == contractID){
							bstmt.executeBatch();
						}						
						vstmt.executeBatch();
					}
				}
			}
			pstmt.executeBatch(); //最后在执行一次(避免漏网之鱼啊~)
			vstmt.executeBatch(); //最后在执行一次(避免漏网之鱼啊~)
			bstmt.executeBatch(); //最后在执行一次(避免漏网之鱼啊~)
			
			pstmt.close();
			vstmt.close();
			bstmt.close();
			return vSql;
		}
		
		
		/**
		 * 替换(空格替换为"") 
		 * @param str
		 * @return
		 */
		private String privReplace(String str){
			return str.replaceAll("(\t|\\s|\n|\r)*", "");
		}
		
		
		/**
		 * 得到4位随机数
		 * @return
		 */
		private String getRandomNum(){
			String temp = String.valueOf(Math.random()).substring(2, 6);//4位随机数
			return temp;
		}
		
		
		
		/**
		 * 将所有 sheet 中 通过下拉框选值的字段添加到map中
		 * @throws Exception 
		 */
		private void initMapInfo(Transaction Sqlca) throws Exception{
			ASResultSet rs = null; //结果集
					
			//装各下拉框的值			
			Map orgMap = new HashMap();
			Map currencyMap = new HashMap();
			Map businessTypeMap = new HashMap();
			Map vouchTypeMap = new HashMap();
			Map lUseModMap = new HashMap();
			Map yesNoMap = new HashMap();
			Map drawingMap = new HashMap();
			Map repayType1Map = new HashMap();
			Map intUnitMap = new HashMap();
			Map rateFloatTypeMap = new HashMap();
			Map rateFloatDirectionMap = new HashMap();
			Map structureModeMap = new HashMap();
			Map loanTermMap = new HashMap();
			Map cutFlagMap = new HashMap();
			Map isHouseLoanMap = new HashMap();
			Map cutType2Map = new HashMap();
			Map isArgMap = new HashMap();
			Map creditNatureMap = new HashMap();
			Map discountOtherBusinessTypeMap = new HashMap();
			Map intTypeMap = new HashMap();
			Map cautionRateMap = new HashMap();
			Map isControlGoodsMap = new HashMap();
			Map assureTypeMap = new HashMap();
			Map busiensstype2Map = new HashMap();
			Map repayType2Map = new HashMap();
			Map agentpayTypeMap = new HashMap();
			Map businessFinacneContractMap = new HashMap();
			Map businessLCContractMap = new HashMap();
			Map businessDicountContractMap = new HashMap();
			Map businessInfo0360ContractNewMap = new HashMap();
			Map ZNLoanTypeMap = new HashMap();
			
			
			rs = Sqlca.getASResultSet("SELECT OrgName,OrgID FROM org_info ORDER BY OrgLevel");
			getMaps(rs, orgMap);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'Currency'");
			getMaps(rs, currencyMap);
			
			rs = Sqlca.getASResultSet("SELECT Typename,Typeno FROM Business_Type");
			getMaps(rs, businessTypeMap);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'VouchType'");
			getMaps(rs, vouchTypeMap);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'LUseMod'");
			getMaps(rs, lUseModMap);
			
//			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'YesNo'");
//			getMaps(rs, yesNoMap);
			yesNoMap.put("是", "1");
			yesNoMap.put("否", "2");
			
//			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'DrawingType'");
//			getMaps(rs, drawingMap);
			drawingMap.put("一次提款", "01");
			drawingMap.put("分次提款", "02");
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'RepayType1'");
			getMaps(rs, repayType1Map);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'IntUnit'");
			getMaps(rs, intUnitMap);
			
//			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'RateFloatType'");
//			getMaps(rs, rateFloatTypeMap);
			rateFloatTypeMap.put("浮动比率", "0");
			rateFloatTypeMap.put("浮动点", "1");
			
			rateFloatDirectionMap.put("上浮", "01");
			rateFloatDirectionMap.put("下浮", "02");
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'StructureMode'");
			getMaps(rs, structureModeMap);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'LoanTerm'");
			getMaps(rs, loanTermMap);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'CutFlag'");
			getMaps(rs, cutFlagMap);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'IsHouseLoan'");
			getMaps(rs, isHouseLoanMap);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'CutType2'");
			getMaps(rs, cutType2Map);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'IsArg'");
			getMaps(rs, isArgMap);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'CreditNature'");
			getMaps(rs, creditNatureMap);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'DiscountOtherBusinessType'");
			getMaps(rs, discountOtherBusinessTypeMap);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'IntType'");
			getMaps(rs, intTypeMap);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'CautionRate'");
			getMaps(rs, cautionRateMap);
			
			isControlGoodsMap.put("是", "01");
			isControlGoodsMap.put("否", "02");
			isControlGoodsMap.put("皆可", "03");
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'AssureType'");
			getMaps(rs, assureTypeMap);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'Busiensstype2'");
			getMaps(rs, busiensstype2Map);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'RepayType2'");
			getMaps(rs, repayType2Map);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'AgentpayType'");
			getMaps(rs, agentpayTypeMap);
			
			rs = Sqlca.getASResultSet("SELECT * FROM Business_Type WHERE Displaytemplet5 = 'BusinessFinacneContract'");
			getMaps(rs, businessFinacneContractMap);
			
			rs = Sqlca.getASResultSet("SELECT * FROM Business_Type WHERE Displaytemplet5 = 'BusinessLCContract'");
			getMaps(rs, businessLCContractMap);
			
			rs = Sqlca.getASResultSet("SELECT * FROM Business_Type WHERE Displaytemplet5 = 'BusinessDicountContract'");
			getMaps(rs, businessDicountContractMap);
			
			rs = Sqlca.getASResultSet("SELECT * FROM Business_Type WHERE Displaytemplet5 = 'BusinessInfo0360ContractNew'");
			getMaps(rs, businessInfo0360ContractNewMap);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'ZNLoanType'");
			getMaps(rs, ZNLoanTypeMap);		
			
			
			//开始装各下拉框
			relativeMap.put("入账机构名称", orgMap);
			relativeMap.put("业务币种", currencyMap);
			relativeMap.put("业务品种名称", businessTypeMap);
			relativeMap.put("担保方式", vouchTypeMap);
			relativeMap.put("额度使用方式", lUseModMap);
			relativeMap.put("是否低风险业务", yesNoMap);
			relativeMap.put("提款方式", drawingMap);
			relativeMap.put("还款方式", repayType1Map);
			relativeMap.put("计息期单位", intUnitMap);
			relativeMap.put("浮动方式", rateFloatTypeMap);
			relativeMap.put("浮动方向", rateFloatDirectionMap);
			relativeMap.put("贷款组织方式", structureModeMap);
			relativeMap.put("贷款期限", loanTermMap);
			relativeMap.put("是否股东贷款", yesNoMap);
			relativeMap.put("关联交易", yesNoMap);
			relativeMap.put("是否货押", yesNoMap);
			relativeMap.put("两高一资", cutFlagMap);
			relativeMap.put("房地产贷款", isHouseLoanMap);
			relativeMap.put("三高一汰", cutType2Map);
			relativeMap.put("是否涉农贷款", isArgMap);
			relativeMap.put("农村区域", yesNoMap);
			relativeMap.put("支农贷款类型", ZNLoanTypeMap);
			relativeMap.put("授信性质", creditNatureMap);
			relativeMap.put("是否异地授信", yesNoMap);
			relativeMap.put("当前合同管户机构", orgMap);
			relativeMap.put("经办机构", orgMap);
			relativeMap.put("登记机构", orgMap);
			relativeMap.put("贴现业务种类", discountOtherBusinessTypeMap);
			relativeMap.put("贴现付息方式", intTypeMap);
			relativeMap.put("是否先贴后查", yesNoMap);
			relativeMap.put("保证金计息方式", cautionRateMap);
			relativeMap.put("是否掌控货权", isControlGoodsMap);
			relativeMap.put("保函种类", assureTypeMap);
			relativeMap.put("是否办理保险", yesNoMap);
			relativeMap.put("业务种类", busiensstype2Map);
			relativeMap.put("代付结算方式", agentpayTypeMap);
		}

		/**
		 *获取SQL 返回值
		 * @param rs
		 * @param MapName
		 * @throws Exception
		 */
		private void getMaps(ASResultSet rs, Map MapName) throws Exception {
			while (rs.next()) {
				//将名称作为key 编号为value
				MapName.put(rs.getString(1), rs.getString(2));
			}
		}
		
		/**
		 * 根据表头和下拉框内容获取 所选内容的 itemNo
		 * @param sHead
		 * @param scontent
		 * @return
		 */		
		private String getItemNo(String sHead,String scontent){
			Map tempMap = (Map)relativeMap.get(sHead);
			String sItemValue = "";
			if (tempMap != null && !scontent.equals("")) {				
				sItemValue = tempMap.get(scontent).toString();
			}
			if (sItemValue == null || tempMap == null || sItemValue.equals("")) {
				sItemValue = scontent;
			}
			return sItemValue;
		}
		
		/**
		 * 进行模板值的 校验
		 * @param sHead
		 * @param sValue
		 * @return
		 * @throws Exception 
		 */
		private String checkValues(Transaction Sqlca,String sHead,String sValue) throws Exception{
			ASResultSet rs = null;
			String sSql = "SELECT Count(1) FROM Business_Contract bc WHERE bc.Relativeserialno = '"+sValue+"'";
			if (sHead.equals("对应原有合同编号") || sHead.equals("")) {				
				 rs = Sqlca.getASResultSet(sSql);
			}
			return "";
		}
		
		
}