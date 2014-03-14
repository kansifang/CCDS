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
 * @msg. ģ����Ϣ����
 */
public class LeadingExcelImport {
	public String msg = "";
	
	private Map coulmnMap = new HashMap(100);
	//װ��������
	private Map relativeMap = new HashMap();
	
	private Connection con = null;
	//PreparedStatement pstmt = null;

	/**
	 * ����xls �����ݲ������ݱ���
	 */
	public LeadingExcelImport(Transaction Sqlca, String path, String Today,
			String OrgID, String UserID) {
		try {
			initMapInfo(Sqlca);
			int Columnscount = 0;
			int Rowscount = 0;
			int RealRows = 0;
			int RealColumns = 0;						

			InputStream is = new FileInputStream(new File(path)); //�õ��������ļ�

			Workbook workbook = Workbook.getWorkbook(is);

			int count = workbook.getSheets().length;
 
			for (int i = 0; i < count-2; ++i) {
				String temp;
				//SimpleDateFormat format = new SimpleDateFormat("yyyyMMddhhmmss");
				//String s5 = new String(format.format(new Date())); //��ǰ����
				
				
				Sheet sheet = workbook.getSheet(i);
				Columnscount = sheet.getColumns(); //�õ�������
				Rowscount = sheet.getRows(); //������
				
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
				
				//�������������FOR ѭ���ж��Ƿ�������
				if ((RealColumns == 0) || (RealRows == 0)) {
					is.close();
					workbook.close();
					throw new Exception("gs");
				}
				
				//�ж��ϴ��ļ��ĸ�ʽ�Ƿ����
				String dCol1ValueName = sheet.getCell(0, 0).getContents().trim();
				String dCol2ValueName = sheet.getCell(1, 0).getContents().trim();
				String dCol3ValueName = sheet.getCell(2, 0).getContents().trim();
				String dCol4ValueName = sheet.getCell(3, 0).getContents().trim();
				String dCol5ValueName = sheet.getCell(4, 0).getContents().trim();
				String dCol6ValueName = sheet.getCell(5, 0).getContents().trim();
				
				if ((!(dCol1ValueName.equals("��ȱ�ţ����ղ����Ķ�ȱ�ţ�")))
						|| (!(dCol2ValueName.equals("��Ӧԭ�к�ͬ���")))
						|| (!(dCol3ValueName.equals("��ȱ�ţ�����ͨ��������")))
						|| (!(dCol4ValueName.equals("��������")))
						|| (!(dCol5ValueName.equals("���˻�������")))
						|| (!(dCol6ValueName.equals("���������")))){
					is.close();
					workbook.close();
					throw new Exception("gs");
				}
				
				//�������У��
				//��ȡÿ��ÿ�е�ֵ����У�� ���ݱ�ͷ ����صı��н��в���
				

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
			this.msg = "����ɹ�";
		} catch (Exception e) {
			if (e.getMessage() == "gs") {
				this.msg = "�����ʽ����";
			} else {
				e.printStackTrace();
				this.msg = "����ʧ��";
			}
		}
	}
	
	/**
	 * ���Է���
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
		 * ģ����Ϣ��ʼ��
		 */

		private void initMap(){
			coulmnMap = new HashMap(100);
			coulmnMap.put("��ͬ��ˮ��", "SERIALNO");
			coulmnMap.put("��Ӧԭ�к�ͬ���", "RELATIVESERIALNO");
			coulmnMap.put("��ȱ�ţ�����ͨ��������", "RELATIVESERIALNO1");
			coulmnMap.put("��ȱ�ţ����ղ����Ķ�ȱ�ţ�", "RELATIVESERIALNO2");
			coulmnMap.put("��������", "APPLYSERIALNO");
			coulmnMap.put("���˻�������", "CLTYPEID");
			coulmnMap.put("�����������", "CLTYPENAME");
			coulmnMap.put("��������", "APPLYTYPE");
			coulmnMap.put("����˴���", "CUSTOMERID");
			coulmnMap.put("���������", "CUSTOMERNAME");
			coulmnMap.put("���Ŀͻ�����", "MFCUSTOMERID");
			coulmnMap.put("��Ӧ�ۺ����ź�ͬ��", "CREDITAGGREEMENT");
			coulmnMap.put("��ͬ���", "LINEMANID");
			coulmnMap.put("���Ŷ�Ƚ��", "LINESUM1");
			coulmnMap.put("����޶�", "LINESUM2");
			coulmnMap.put("ҵ�����", "CURRENCY");
			coulmnMap.put("��ʼ��", "BEGINDATE");
			coulmnMap.put("������", "ENDDATE");
			coulmnMap.put("ҵ��Ʒ������", "BUSINESSTYPE");
			coulmnMap.put("������ʽ", "VOUCHTYPE");
			coulmnMap.put("������ʽ����", "VOUCHTYPE1");
			coulmnMap.put("�Ƿ�ѭ��", "ROTATIVE");
			coulmnMap.put("Լ����;", "PURPOSE");
			coulmnMap.put("�ʽ����ʺ�", "OVERSEEACCOUNT");
			coulmnMap.put("ҵ������", "BUSINESSTYPE1");
			coulmnMap.put("��ʽ", "DRAWINGTYPE");
			coulmnMap.put("���ʽ", "REPAYTYPE");
			coulmnMap.put("��Ϣ����", "ICCYC");
			coulmnMap.put("��Ϣ��", "INTTIME");
			coulmnMap.put("ִ��������(%)", "BUSINESSRATE");
			coulmnMap.put("����ֵ", "RATEFLOAT");
			coulmnMap.put("������ʽ", "RATEFLOATTYPE");
			coulmnMap.put("��������", "RATEFLOATDIRECTION");
			coulmnMap.put("������", "GRACEPERIOD");
			coulmnMap.put("���ڷ�Ϣ��׼", "STATNDARD1");
			coulmnMap.put("��ռŲ�ô��Ϣ��׼", "FINERATE");
			coulmnMap.put("������֯��ʽ", "STRUCTUREMODE");
			coulmnMap.put("��������", "LOANTERM");
			coulmnMap.put("�Ƿ�ɶ�����", "STOCFLAG");
			coulmnMap.put("��������", "TRAFLAG");
			coulmnMap.put("�Ƿ��Ѻ", "LOADFLAG");
			coulmnMap.put("����һ��", "CUTFLAG");
			coulmnMap.put("����ʵ��Ͷ��", "DIRECTION");
			coulmnMap.put("����һ̭", "CUTTYPE2");
			coulmnMap.put("�Ƿ���ũ����", "ISARG");
			coulmnMap.put("��������", "OCCURTYPE");
			coulmnMap.put("�Ƿ��������", "ISLOCALCREDIT");
			coulmnMap.put("ί���˴���", "THIRDPARTY1");
			coulmnMap.put("ί��������", "THIRDPARTY2");
			coulmnMap.put("����", "PREPAYSTAND01");
			coulmnMap.put("���ָ�Ϣ��ʽ", "ACCEPTINTTYPE");
			coulmnMap.put("�Ƿ��������", "ISFISTACCEPT");
			coulmnMap.put("��֤�����", "BAILRATIO");
			coulmnMap.put("��֤���Ϣ��ʽ", "BAILTYPE");
			coulmnMap.put("�����ѱ���", "PDGRATIO");
			coulmnMap.put("�տ���", "GATHERINGNAME");
			coulmnMap.put("������ͬ��", "BUYCONTACTNO");
			coulmnMap.put("��������", "SAFEGUARDTYPE");
			coulmnMap.put("������", "BENEFICIARY");
			coulmnMap.put("�������ʱ���", "BUSINESSPROP");
			coulmnMap.put("�Ƿ������", "ISINSURE");
			coulmnMap.put("���������", "TERMDAY");
			coulmnMap.put("ҵ������", "BUSIENSSTYPE2");
			coulmnMap.put("����֤/��Ʊ���", "LCNO");
			coulmnMap.put("���Ž��������֤/��Ʊ������", "OTHERRATE");
			coulmnMap.put("������", "PDGSUM");
			coulmnMap.put("�������㷽ʽ", "AGENTPAYTYPE");
			coulmnMap.put("�Ƿ��ƿػ�Ȩ", "ISCONTROLGOODS");
			coulmnMap.put("���ʻ���", "PUTOUTORGID");
			coulmnMap.put("��ǰ��ͬ�ܻ�����", "MANAGEORGID");
			coulmnMap.put("��ǰ��ͬ�ܻ���", "MANAGUSERID");
			coulmnMap.put("�������", "OPERATEORGID");
			coulmnMap.put("������", "OPERATEUSERID");
			coulmnMap.put("�Ǽǻ���", "INPUTORGID");
			coulmnMap.put("�Ǽ���", "INPUTUSERID");
			coulmnMap.put("�Ǽ�����", "INPUTDATE");
			coulmnMap.put("��������", "UPDATEDATE");
			coulmnMap.put("��ȼ���", "LINELEVEL");
			coulmnMap.put("��Ȳ��", "LMTLEVEL");
			coulmnMap.put("���ʹ�÷�ʽ", "LUSEMOD");
			coulmnMap.put("��������", "LMTCURRENCY");
			coulmnMap.put("������ȱ��", "OWNERLINEID");
			coulmnMap.put("��ע", "REMARK");
			coulmnMap.put("����״̬", "TEMPSAVEFLAG");
			coulmnMap.put("��������", "OUTSTARTDATE");
			coulmnMap.put("��ŵ����", "PROMISESINFO");
			coulmnMap.put("Լ������", "ASSUMPSITIF");
			coulmnMap.put("����ҵ������", "OTHERBUSINESSTYPE");
			coulmnMap.put("�ж�����/�ж���", "ACCEPTOR");
			coulmnMap.put("�Ƿ�ͷ���ҵ��", "ISLOWRISK");
			coulmnMap.put("��Ϣ�ڵ�λ", "INTUNIT");
			coulmnMap.put("���ز�����", "ISHOUSELOAN");
			coulmnMap.put("ũ������", "VILLAGEREGION");
			coulmnMap.put("֧ũ��������", "ZNLOANTYPE");
		}
		
		/**
		 * exl�ı�ͷ�ҳ���Ӧ������
		 * @param key
		 * @return
		 */
		private String getCoulmnName(String key) {
			if (coulmnMap == null)
				return "";
			return (String) coulmnMap.get(key);

		}
		
		
		/**
		 * ƴ��SQL
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
			temp = temp.substring(0, temp.length() - 1); //��ȡ�ֶ��ж���ġ�,��
			values = values.substring(0, values.length() - 1); //��ȡvalues�ж����","
			String sSql = "insert into Business_Contractclinfo_Bak(SERIALNO," + temp+ ") values(?," + values + ")"; //ƴ��SQL
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
				if (!sResult.equals("")) {  //�ж�ĳ�������Ƿ�Ϊ�� ��Ϊ�� ���в���������ݱ��� ����ÿ��sheet�� ��һ�е�ֵ�����жϵ�
					//String Random = getRandomNum(); //�õ�4λ�����
					
					String sSeriaNo = DBFunction.getSerialNo("Business_Contractclinfo_Bak","SERIALNO",Sqlca);
					
					pstmt.setString(1,sSeriaNo); //����ÿ����¼ ��ˮ��
					
					String lastLineID = "";
					String contractID = "";
					
					
					for(int col =1;col < iCount+1;col++){
						try{
							String sItemHead = sheet.getCell(col-1, 0).getContents().trim();
							String sContents = row[col-1].getContents().trim();
							String sItemValue = getItemNo(sItemHead,sContents);
							System.out.println(sItemHead+"~~"+sItemValue);
							
							if("��ȱ�ţ����ղ����Ķ�ȱ�ţ�".equals(sItemHead)){
								lastLineID = sItemValue;
							}
							if("��Ӧԭ�к�ͬ���".equals(sItemHead)){
								contractID = sItemValue;
							}									
							
							pstmt.setString(col+1,sItemValue); //��ÿ�����ɵ�SQL���һһ��ֵ
						}catch(NullPointerException ex){
							System.out.println(" ����Ϊ�գ�����ѭ�� ");
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
										
					pstmt.addBatch(); //����ִ��
					if("" == contractID){
						bstmt.addBatch(); //����ִ��
					}
					vstmt.addBatch(); //����ִ��								
					if(rows % 50 == 0){
						pstmt.executeBatch();
						if("" == contractID){
							bstmt.executeBatch();
						}						
						vstmt.executeBatch();
					}
				}
			}
			pstmt.executeBatch(); //�����ִ��һ��(����©��֮�㰡~)
			vstmt.executeBatch(); //�����ִ��һ��(����©��֮�㰡~)
			bstmt.executeBatch(); //�����ִ��һ��(����©��֮�㰡~)
			
			pstmt.close();
			vstmt.close();
			bstmt.close();
			return vSql;
		}
		
		
		/**
		 * �滻(�ո��滻Ϊ"") 
		 * @param str
		 * @return
		 */
		private String privReplace(String str){
			return str.replaceAll("(\t|\\s|\n|\r)*", "");
		}
		
		
		/**
		 * �õ�4λ�����
		 * @return
		 */
		private String getRandomNum(){
			String temp = String.valueOf(Math.random()).substring(2, 6);//4λ�����
			return temp;
		}
		
		
		
		/**
		 * ������ sheet �� ͨ��������ѡֵ���ֶ���ӵ�map��
		 * @throws Exception 
		 */
		private void initMapInfo(Transaction Sqlca) throws Exception{
			ASResultSet rs = null; //�����
					
			//װ���������ֵ			
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
			yesNoMap.put("��", "1");
			yesNoMap.put("��", "2");
			
//			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'DrawingType'");
//			getMaps(rs, drawingMap);
			drawingMap.put("һ�����", "01");
			drawingMap.put("�ִ����", "02");
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'RepayType1'");
			getMaps(rs, repayType1Map);
			
			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'IntUnit'");
			getMaps(rs, intUnitMap);
			
//			rs = Sqlca.getASResultSet("SELECT Itemname,Itemno FROM Code_Library WHERE Codeno = 'RateFloatType'");
//			getMaps(rs, rateFloatTypeMap);
			rateFloatTypeMap.put("��������", "0");
			rateFloatTypeMap.put("������", "1");
			
			rateFloatDirectionMap.put("�ϸ�", "01");
			rateFloatDirectionMap.put("�¸�", "02");
			
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
			
			isControlGoodsMap.put("��", "01");
			isControlGoodsMap.put("��", "02");
			isControlGoodsMap.put("�Կ�", "03");
			
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
			
			
			//��ʼװ��������
			relativeMap.put("���˻�������", orgMap);
			relativeMap.put("ҵ�����", currencyMap);
			relativeMap.put("ҵ��Ʒ������", businessTypeMap);
			relativeMap.put("������ʽ", vouchTypeMap);
			relativeMap.put("���ʹ�÷�ʽ", lUseModMap);
			relativeMap.put("�Ƿ�ͷ���ҵ��", yesNoMap);
			relativeMap.put("��ʽ", drawingMap);
			relativeMap.put("���ʽ", repayType1Map);
			relativeMap.put("��Ϣ�ڵ�λ", intUnitMap);
			relativeMap.put("������ʽ", rateFloatTypeMap);
			relativeMap.put("��������", rateFloatDirectionMap);
			relativeMap.put("������֯��ʽ", structureModeMap);
			relativeMap.put("��������", loanTermMap);
			relativeMap.put("�Ƿ�ɶ�����", yesNoMap);
			relativeMap.put("��������", yesNoMap);
			relativeMap.put("�Ƿ��Ѻ", yesNoMap);
			relativeMap.put("����һ��", cutFlagMap);
			relativeMap.put("���ز�����", isHouseLoanMap);
			relativeMap.put("����һ̭", cutType2Map);
			relativeMap.put("�Ƿ���ũ����", isArgMap);
			relativeMap.put("ũ������", yesNoMap);
			relativeMap.put("֧ũ��������", ZNLoanTypeMap);
			relativeMap.put("��������", creditNatureMap);
			relativeMap.put("�Ƿ��������", yesNoMap);
			relativeMap.put("��ǰ��ͬ�ܻ�����", orgMap);
			relativeMap.put("�������", orgMap);
			relativeMap.put("�Ǽǻ���", orgMap);
			relativeMap.put("����ҵ������", discountOtherBusinessTypeMap);
			relativeMap.put("���ָ�Ϣ��ʽ", intTypeMap);
			relativeMap.put("�Ƿ��������", yesNoMap);
			relativeMap.put("��֤���Ϣ��ʽ", cautionRateMap);
			relativeMap.put("�Ƿ��ƿػ�Ȩ", isControlGoodsMap);
			relativeMap.put("��������", assureTypeMap);
			relativeMap.put("�Ƿ������", yesNoMap);
			relativeMap.put("ҵ������", busiensstype2Map);
			relativeMap.put("�������㷽ʽ", agentpayTypeMap);
		}

		/**
		 *��ȡSQL ����ֵ
		 * @param rs
		 * @param MapName
		 * @throws Exception
		 */
		private void getMaps(ASResultSet rs, Map MapName) throws Exception {
			while (rs.next()) {
				//��������Ϊkey ���Ϊvalue
				MapName.put(rs.getString(1), rs.getString(2));
			}
		}
		
		/**
		 * ���ݱ�ͷ�����������ݻ�ȡ ��ѡ���ݵ� itemNo
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
		 * ����ģ��ֵ�� У��
		 * @param sHead
		 * @param sValue
		 * @return
		 * @throws Exception 
		 */
		private String checkValues(Transaction Sqlca,String sHead,String sValue) throws Exception{
			ASResultSet rs = null;
			String sSql = "SELECT Count(1) FROM Business_Contract bc WHERE bc.Relativeserialno = '"+sValue+"'";
			if (sHead.equals("��Ӧԭ�к�ͬ���") || sHead.equals("")) {				
				 rs = Sqlca.getASResultSet(sSql);
			}
			return "";
		}
		
		
}