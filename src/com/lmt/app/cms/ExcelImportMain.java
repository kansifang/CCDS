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
	 * ģ����Ϣ��ʼ��
	 */
	private static void initMap(){
		coulmnMap = new HashMap(100);
		coulmnMap.put("��ͬ��ˮ��", "SERIALNO");
		coulmnMap.put("��Ӧԭ�к�ͬ���", "RELATIVESERIALNO");
		coulmnMap.put("��ȱ�ţ�����ͨ��������", "RELATIVESERIALNO1");
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
	}
	
	
	
	/**
	 * exl�ı�ͷ�ҳ���Ӧ������
	 * @param key
	 * @return
	 */
	private static String getCoulmnName(String key) {

		return (String) coulmnMap.get(key);

	}
	
	
	/**
	 * ����SQL
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
