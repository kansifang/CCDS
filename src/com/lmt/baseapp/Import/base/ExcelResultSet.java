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
	// �ѱ�ͷ�����ݿ��ֶζ�Ӧ�������γ�insert���������ݿ�
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
	//��ʼ��metadata
	public void initMeta() throws Exception {
		this.columns.clear();
		//����ģ�嶨��
		ASResultSet rs=this.Sqlca.getASResultSet("select ItemDescribe,Attribute1,Attribute2,Attribute3 from Code_Library where CodeNo='"+this.initWho+"' and IsInUse='1'");
		while(rs.next()){
			this.addColumn(rs.getString(1),rs.getString(2),rs.getString(3),"1".equals(rs.getString(4))?true:false);
		}
		//Ĭ�϶�������ֶ�
		this.addColumn("ImportNo", "������","String",true,false);//��Ҫ��Ϊ����������֮��
		this.addColumn("ImportIndex", "�������к�","String",true,false);//��¼����������
		this.addColumn("ImportTime", "����ʱ��","String",true,false);//��¼����ʱ��
		this.addColumn("ConfigNo", "���ú�","String",true,false);//��¼����ʱ��
		//�����ֶ���
	}
	public boolean checkMeta()throws Exception{
		//��ʼ����ʼ��
		this.initCurrentRow();
		//У���ϴ��ļ��Ƿ�Ϊ��
		StringBuffer sb=new StringBuffer("");
		Row headrow =getSheet().getRow(this.currentRow);
		if(headrow.getPhysicalNumberOfCells()==0){
			throw new Exception("�ϴ��ļ�Ϊ���ļ���");
		}
		//У���ϴ��ļ��б���ͷ�Ƿ��ظ�
		for(int i=0;i<headrow.getPhysicalNumberOfCells();i++){
			String headrow1=headrow.getCell(i).getStringCellValue().trim().replaceAll("\\s", "");
			if("".equals(headrow1)){
				continue;
			}
			for(int j=i+1;j<headrow.getPhysicalNumberOfCells();j++){
				String headrow2=headrow.getCell(j).getStringCellValue().trim().replaceAll("\\s", "");
				if(headrow1.equals(headrow2)){
					sb.append("Excel�ļ���"+headrow.getCell(i).getStringCellValue().trim()+"�ж�����������");
				}
			}
		}
		//У��ģ�����涨���Ҫ�ر����Ƿ����ϴ��ļ��ж��߱���
		//��ʼ������Ҫ�ر������ļ������ indexInFile
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
			throw new Exception("��ǰ������ѡ���ģ�嶨�������õ�"+sb.toString()+"���ϴ�Excel�ļ���û�ж�Ӧ��Ҫ�أ�");
		}
		return true;
	}
	//��ʼ������ָ��ֵ
	public void initPara() throws Exception {
		this.setRowCount(this.sheet.getLastRowNum()+1);
		this.setEof(false);
		//��ʼ�������
		this.setValueToCode(this.Sqlca);
		//���������ַ�
		this.setaReplaceBWithAInValue(new String[][] { { "��", "" },{ "\\$", "" }, { ",", "" }, { "\"", "" },{ "��������", "" },{ "�������йɷ����޹�˾", "" }});
		//�����ļ���һЩҪ�ص�ֵ���˴����õĶ��Ǻ㶨ֵ
		SimpleDateFormat sdf=new SimpleDateFormat("'N"+CurUser.UserID+"'yyyyMMddhhmm");
		this.setString("ImportNo",sdf.format(new Date())+"000000");
		this.setString("ConfigNo",this.initWho);
	}
	private void initCurrentRow() throws Exception{
		int cr=-1;
		int RowNumMaxt=this.sheet.getLastRowNum();
		label:
		for(int j=0;j<=RowNumMaxt;j++){
			//�����ļ�ÿһ����¼���������
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
			throw new Exception("�޷�ȷ����ʼ�У���ȷ�������ļ����Ƿ����������Ϣ�����õ�����ǩ��");
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
		//�����ļ���һ����¼���������
		for (int i = 0; i <= rr.getLastCellNum(); ++i) {
			Cell cell=rr.getCell(i);
			if(cell==null)
				continue;
			int CT=cell.getCellType();
			if(this.containsIndexInFile(i)&&!this.getColumnObjWIF(i).isOutFileColumn()){
				if("Number".equals(this.getColumnTypeWIF(i))){
					if(CT!=HSSFCell.CELL_TYPE_NUMERIC&&CT!=HSSFCell.CELL_TYPE_FORMULA){
						//throw new Exception("��"+(this.currentRow+1)+"�е�"+(i+1)+"��ӦΪ�����ͣ�������Ҫ��"); ���������;�Ĭ�Ͽ� �������쳣
						this.setDouble(i,0.0);
					}else{
						this.setDouble(i,cell.getNumericCellValue());//nf.parse(svalue).doubleValue()
					}
				}else{
					this.setString(i,changeCellToString(cell));
				}
			}
		}
		//�����ļ����һЩҪ�ص�ֵ��Ʃ�絼�����ڣ��˴�������Ȼ��ÿ���¼�ǲ�һ����
		this.setString("ImportIndex", (this.currentRow+1)+"");
		this.setString("ImportTime", StringFunction.getTodayNow());
		return true;
	}
	//����HSSFCell �м����������ͣ�������������ת�����ټ�һ����������ת����������������Ƕ�ת����String���͵�����
	private String changeCellToString(Cell cell){
		String returnValue = "";
		if(null != cell){
			switch(cell.getCellType()){
				case Cell.CELL_TYPE_NUMERIC:   //����
					String []mm=cell.toString().split("-");
					if(mm.length>1){
						SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
						Date doubleValue1= cell.getDateCellValue();
						returnValue=sdf.format(doubleValue1);
					}else{
						//��Ҫ������֤��֮�࣬Excel����� xxx,xxxx,xxx.0,�����ڴ�ת��һ��
						NumberFormat nf = NumberFormat.getInstance();
						Double doubleValue = cell.getNumericCellValue();
						String str=nf.format(doubleValue);
						str = str.replace(".0", "");
						returnValue = str.replace(",", "");
					}
					break;
				case Cell.CELL_TYPE_STRING:    //�ַ���
					returnValue = cell.getStringCellValue();
					break;
				case Cell.CELL_TYPE_BOOLEAN:   //����
					Boolean booleanValue=cell.getBooleanCellValue();
					returnValue = booleanValue.toString();
					break;
				case Cell.CELL_TYPE_BLANK:     // ��ֵ
					returnValue = "";
					break;
				case Cell.CELL_TYPE_FORMULA:   // ��ʽ
					returnValue = cell.getCellFormula();
					break;
				case Cell.CELL_TYPE_ERROR:     // ����
					returnValue = "";
					break;
				default:
					System.out.println("δ֪����");
					break;
			}
		}
		return returnValue;
	}
	// ��Ҫ�Ǵ��� ��excel�е���ʾֵ�������ݿ����Ǵ���ֵ�����
	/**
	 * ������ sheet �� ͨ��������ѡֵ���ֶ���ӵ�map�� ���磺�� 1��Ů 2..
	 * 
	 * @throws Exception
	 */
	protected void setValueToCode(Transaction Sqlca) throws Exception {
		ASResultSet rs = null; // �����
		// װ���������ֵ
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

		HashMap<String, String> rightTypeMap = new HashMap<String, String>();// Ȩ֤����
		HashMap<String, String> currencyMap = new HashMap<String, String>();
		HashMap<String, String> yesNoMap = new HashMap<String, String>();
		HashMap<String, String> insureValueByMap = new HashMap<String, String>();// Ͷ����ֵ����
		HashMap<String, String> warrantTypeMap = new HashMap<String, String>();// ��������
		HashMap<String, String> userMap = new HashMap<String, String>();// �û�
		HashMap<String, String> orgMap = new HashMap<String, String>();// ����

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
		// yesNoMap.put("��", "1");
		// yesNoMap.put("��", "2");

		// rs =
		// Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'DrawingType'");
		// getMaps(rs, drawingMap);
		drawingMap.put("һ�����", "01");
		drawingMap.put("�ִ����", "02");

		rs = Sqlca
				.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'RepayType1'");
		getMaps(rs, repayType1Map);

		rs = Sqlca
				.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'IntUnit'");
		getMaps(rs, intUnitMap);

		// rs =
		// Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'RateFloatType'");
		// getMaps(rs, rateFloatTypeMap);
		rateFloatTypeMap.put("��������", "0");
		rateFloatTypeMap.put("������", "1");

		rateFloatDirectionMap.put("�ϸ�", "01");
		rateFloatDirectionMap.put("�¸�", "02");

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

		isControlGoodsMap.put("��", "01");
		isControlGoodsMap.put("��", "02");
		isControlGoodsMap.put("�Կ�", "03");

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
		// ��ʼװ��������
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
