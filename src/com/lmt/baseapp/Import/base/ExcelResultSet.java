package com.lmt.baseapp.Import.base;

import java.sql.SQLException;
import java.text.NumberFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;

import com.lmt.baseapp.user.ASUser;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class ExcelResultSet extends ObjResultSet {
	private ASUser CurUser=null;
	protected Sheet sheet = null;
	// 把表头和数据库字段对应起来，形成insert语句插入数据库
	public ExcelResultSet(Transaction sqlca,ASUser CurUser)throws SQLException {
		super(sqlca);
		this.CurUser=CurUser;
	}
	public Sheet getSheet() {
		return sheet;
	}
	public void setSheet(Sheet sheet) {
		this.sheet = sheet;
	}
	//初始化metadata
	public void initMeta() throws Exception {
		this.columns.clear();
		//加载模板定义
		ASResultSet rs=this.Sqlca.getASResultSet("select ItemDescribe,Attribute1,Attribute2,Attribute3 from Code_Library where CodeNo='"+this.initWho+"' and IsInUse='1'");
		while(rs.next()){
			this.addColumn(rs.getString(1),rs.getString(2),rs.getString(3),"1".equals(rs.getString(4))?true:false);
		}
		//默认都有这个字段
		this.addColumn("ImportNo", "批量号","String",true,false);//主要是为了区分批次之间
		this.addColumn("ImportIndex", "批量序列号","String",true,false);//记录批次内序列
		this.addColumn("ImportTime", "批量时间","String",true,false);//记录批次时间
		this.addColumn("ConfigNo", "配置号","String",true,false);//记录批次时间
		//设置字段数
	}
	public boolean checkMeta()throws Exception{
		//初始化开始行
		this.initCurrentRow();
		//校验上传文件是否为空
		StringBuffer sb=new StringBuffer("");
		Row headrow =getSheet().getRow(this.currentRow);
		if(headrow.getPhysicalNumberOfCells()==0){
			throw new Exception("上传文件为空文件！");
		}
		//校验上传文件中标题头是否重复
		for(int i=0;i<headrow.getPhysicalNumberOfCells();i++){
			String headrow1=headrow.getCell(i).getStringCellValue().trim().replaceAll("\\s", "");
			if("".equals(headrow1)){
				continue;
			}
			for(int j=i+1;j<headrow.getPhysicalNumberOfCells();j++){
				String headrow2=headrow.getCell(j).getStringCellValue().trim().replaceAll("\\s", "");
				if(headrow1.equals(headrow2)){
					sb.append("Excel文件中"+headrow.getCell(i).getStringCellValue().trim()+"有多个，请调整；");
				}
			}
		}
		//校验模板里面定义的要素标题是否在上传文件中都具备，
		//初始化设置要素标题在文件中序号 indexInFile
		for (ObjColumnMetaData sC : this.columns) {
			int k=0;
			String headD = sC.getColumnHeadName();
			String headName="";
			if(!sC.isOutFileColumn()){
				for (int i =0;i < headrow.getPhysicalNumberOfCells();i++) {
					headName=headrow.getCell(i).getStringCellValue().trim().replaceAll("\\s", "");
					if(headD.equals(headName)){
						this.setColumnIndexWH(headD,i);
						k=1;
						break;
					}
				}
				if(k==0){
					sb.append("~"+headD+"~");
				}
			}
		}
		if(sb.length()>0){
			throw new Exception("当前批次所选择的模板定义中配置的"+sb.toString()+"在上传Excel文件中没有对应的要素；");
		}
		return true;
	}
	//初始化各种指标值
	public void initPara() throws Exception {
		this.setRowCount(this.sheet.getLastRowNum()+1);
		this.setEof(false);
		//初始化代码表
		this.setValueToCode(this.Sqlca);
		//处理特殊字符
		this.setaReplaceBWithAInValue(new String[][] { { "￥", "" },{ "\\$", "" }, { ",", "" }, { "\"", "" },{ "渤海银行", "" },{ "渤海银行股份有限公司", "" }});
		//设置文件外一些要素的值，此处设置的都是恒定值
		SimpleDateFormat sdf=new SimpleDateFormat("'N"+CurUser.UserID+"'yyyyMMddhhmm");
		this.setString("ImportNo",sdf.format(new Date())+"000000");
		this.setString("ConfigNo",this.initWho);
	}
	private void initCurrentRow() throws Exception{
		int cr=-1;
		int RowNumMaxt=this.sheet.getLastRowNum();
		label:
		for(int j=0;j<=RowNumMaxt;j++){
			//解析文件每一条记录到结果集中
			Row rr = this.sheet.getRow(j);
			if(rr==null){
				continue;
			}
			for (int i = 0; i <= rr.getLastCellNum(); ++i) {
				Cell cell=rr.getCell(i);
				if(cell==null){
					continue;
				}
				String value=changeCellToString(cell);
				if(this.containsHead(value)&&this.getColumnObjWH(value).isPrimaryKey()){
					cr=j;
					break label;
				}
			}
		}
		if(cr==-1){
			throw new Exception("无法确定起始行，请确认数据文件中是否存在配置信息中配置的主标签！");
		}
		this.setCurrentRow(cr);
	}
	public boolean next() throws Exception {
		//DecimalFormat nf = new DecimalFormat("#0");
		this.currentRow ++;
		if (this.currentRow >= this.rowCount) {
			return false;
		}
		Row rr = this.sheet.getRow(this.currentRow);
		if (rr.getPhysicalNumberOfCells() == 0) {
			this.eof = true;
			return false;
		}
		//解析文件下一条记录到结果集中
		for (int i = 0; i <= rr.getLastCellNum(); ++i) {
			Cell cell=rr.getCell(i);
			if(cell==null)
				continue;
			int CT=cell.getCellType();
			if(this.containsIndexInFile(i)&&!this.getColumnObjWIF(i).isOutFileColumn()){
				if("Number".equals(this.getColumnTypeWIF(i))){
					if(CT!=HSSFCell.CELL_TYPE_NUMERIC&&CT!=HSSFCell.CELL_TYPE_FORMULA){
						//throw new Exception("第"+(this.currentRow+1)+"行第"+(i+1)+"列应为数字型，不符合要求"); 不是数据型就默认空 不再抛异常
						this.setDouble(i,0.0);
					}else{
						this.setDouble(i,cell.getNumericCellValue());//nf.parse(svalue).doubleValue()
					}
				}else{
					this.setString(i,changeCellToString(cell));
				}
			}
		}
		//设置文件外的一些要素的值，譬如导入日期，此处设置显然是每天记录是不一样的
		this.setString("ImportIndex", (this.currentRow+1)+"");
		this.setString("ImportTime", StringFunction.getTodayNow());
		return true;
	}
	//这里HSSFCell 有几种数据类型，如果想进行类型转换，再加一个方法进行转换，这里给的例子是都转换成String类型的数据
	private String changeCellToString(Cell cell){
		String returnValue = "";
		if(null != cell){
			switch(cell.getCellType()){
				case Cell.CELL_TYPE_NUMERIC:   //数字
					String []mm=cell.toString().split("-");
					if(mm.length>1){
						SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
						Date doubleValue1= cell.getDateCellValue();
						returnValue=sdf.format(doubleValue1);
					}else{
						//主要针对身份证号之类，Excel常变成 xxx,xxxx,xxx.0,所以在此转化一下
						NumberFormat nf = NumberFormat.getInstance();
						Double doubleValue = cell.getNumericCellValue();
						String str=nf.format(doubleValue);
						str = str.replace(".0", "");
						returnValue = str.replace(",", "");
					}
					break;
				case Cell.CELL_TYPE_STRING:    //字符串
					returnValue = cell.getStringCellValue();
					break;
				case Cell.CELL_TYPE_BOOLEAN:   //布尔
					Boolean booleanValue=cell.getBooleanCellValue();
					returnValue = booleanValue.toString();
					break;
				case Cell.CELL_TYPE_BLANK:     // 空值
					returnValue = "";
					break;
				case Cell.CELL_TYPE_FORMULA:   // 公式
					returnValue = cell.getCellFormula();
					break;
				case Cell.CELL_TYPE_ERROR:     // 故障
					returnValue = "";
					break;
				default:
					System.out.println("未知类型");
					break;
			}
		}
		return returnValue;
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
