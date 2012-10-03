package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import java.util.Vector;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;

public class ReserveTotal {
	
	private Transaction Sqlca = null;
	private boolean debug = true; 
	
	public ReserveTotal(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;			
	}
	
	/**
	 * ���ݻ���·ݻ�ȡ��Ӧ�Ĵ������ݿ��б��ڴ����ʺ�
	 * @param sAccountMonth ����·�
	 * @return Vector �����ʺż���
	 */
	public Vector selectReserveTotal(String sAccountMonth) throws Exception
	{
		//�������			
		Vector vReserveTotal = new Vector();
		ASResultSet rs = null;
		String sSql = "";
		
		sSql = 	" select LoanAccount from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			vReserveTotal.add(rs.getString("LoanAccount")); //�����ʺ�
		}
		rs.getStatement().close();
		
		return vReserveTotal;
	}
	
	/**
	 * ���ݻ���·ݡ������ʺŻ�ȡ��Ӧ�Ĵ���������Ϣ
	 * @param sAccountMonth ����·�,sLoanAccountNo �����ʺ�
	 * @return ArrayList ����Ϊ������·ݡ������ʺš���Ŀ�š�......
	 */
	public ArrayList selectReserveTotal(String sAccountMonth,String sLoanAccountNo) throws Exception
	{
		//�������			
		ArrayList alReserveTotal = new ArrayList();
		ASResultSet rs = null;
		String sSql = "";
		
		sSql = 	" select * from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' "+
				" and LoanAccount = '"+sLoanAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			alReserveTotal.add(0, rs.getString("AccountMonth")== null ? "" : rs.getString("AccountMonth")); //����·�
			alReserveTotal.add(1, rs.getString("LoanAccount")== null ? "" : rs.getString("LoanAccount")); //�����ʺ�
			alReserveTotal.add(2, rs.getString("SubjectNo")== null ? "" : rs.getString("SubjectNo")); //��Ŀ��
			alReserveTotal.add(3, rs.getString("ManageStatFlag")== null ? "" : rs.getString("ManageStatFlag")); //�����ھ������־
			alReserveTotal.add(4, rs.getString("AuditStatFlag")== null ? "" : rs.getString("AuditStatFlag")); //��ƿھ������־
			alReserveTotal.add(5, rs.getString("BatchTime")== null ? "" : rs.getString("BatchTime")); //���Ŵ��ʲ�ת���־
			alReserveTotal.add(6, rs.getString("DuebillNo")== null ? "" : rs.getString("DuebillNo")); //��ݱ��
			alReserveTotal.add(7, rs.getString("CustomerID")== null ? "" : rs.getString("CustomerID")); //�ͻ����
			alReserveTotal.add(8, rs.getString("CustomerName")== null ? "" : rs.getString("CustomerName")); //�ͻ�����
			alReserveTotal.add(9, rs.getString("CustomerOrgCode")== null ? "" : rs.getString("CustomerOrgCode")); //�ͻ���֯��������
			alReserveTotal.add(10, rs.getString("Region")== null ? "" : rs.getString("Region")); //���ڵ���
			alReserveTotal.add(11, rs.getString("ListingFlag")== null ? "" : rs.getString("ListingFlag")); //�Ƿ�������ҵ
			alReserveTotal.add(12, rs.getString("IndustryType")== null ? "" : rs.getString("IndustryType")); //��ҵ���
			alReserveTotal.add(13, rs.getString("EconomyType")== null ? "" : rs.getString("EconomyType")); //��������
			alReserveTotal.add(14, rs.getString("Scope")== null ? "" : rs.getString("Scope")); //��ҵ��ģ
			alReserveTotal.add(15, rs.getString("StatOrgid")== null ? "" : rs.getString("StatOrgid")); //�ſ����
			alReserveTotal.add(16, rs.getString("Currency")== null ? "" : rs.getString("Currency")); //�������
			alReserveTotal.add(17, rs.getString("BusinessSum")== null ? "" : rs.getString("BusinessSum")); //��ݽ��
			alReserveTotal.add(18, rs.getString("PutoutDate")== null ? "" : rs.getString("PutoutDate")); //�ſ�����
			alReserveTotal.add(19, rs.getString("Maturity")== null ? "" : rs.getString("Maturity")); //��������
			alReserveTotal.add(20, rs.getString("LoanType")== null ? "" : rs.getString("LoanType")); //�������
			alReserveTotal.add(21, rs.getString("LoanNature")== null ? "" : rs.getString("LoanNature")); //��������
			alReserveTotal.add(22, rs.getString("LoanTerm")== null ? "" : rs.getString("LoanTerm")); //��������
			alReserveTotal.add(23, rs.getString("VouchType")== null ? "" : rs.getString("VouchType")); //��Ҫ������ʽ
			alReserveTotal.add(24, rs.getString("Guarantor")== null ? "" : rs.getString("Guarantor")); //��֤��/��Ѻ��/����������
			alReserveTotal.add(25, rs.getString("GuarantyEvalValue")== null ? "" : rs.getString("GuarantyEvalValue")); //����Ѻ��ԭ����ֵ
			alReserveTotal.add(26, rs.getString("BusinessRate")== null ? "" : rs.getString("BusinessRate")); //����������
			alReserveTotal.add(27, rs.getString("PdgSum")== null ? "" : rs.getString("PdgSum")); //���������
			alReserveTotal.add(28, rs.getString("AuditRate")== null ? "" : rs.getString("AuditRate")); //����ʵ������
			alReserveTotal.add(29, rs.getString("OldPutoutDate")== null ? "" : rs.getString("OldPutoutDate")); //������������ſ���
			alReserveTotal.add(30, rs.getString("Balance")== null ? "" : rs.getString("Balance")); //Ŀǰ��ԭ�ң�
			alReserveTotal.add(31, rs.getString("ExchangeRate")== null ? "" : rs.getString("ExchangeRate")); //����
			alReserveTotal.add(32, rs.getString("RMBBalance")== null ? "" : rs.getString("RMBBalance")); //Ŀǰ����ۺ������
			alReserveTotal.add(33, rs.getString("FourClassify")== null ? "" : rs.getString("FourClassify")); //�ļ�����
			alReserveTotal.add(34, rs.getString("MFiveClassify")== null ? "" : rs.getString("MFiveClassify")); //������弶����
			alReserveTotal.add(35, rs.getString("AFiveClassify")== null ? "" : rs.getString("AFiveClassify")); //����弶����
			alReserveTotal.add(36, rs.getString("GuarantyNowValue")== null ? "" : rs.getString("GuarantyNowValue")); //����Ѻ��������ֵ
			alReserveTotal.add(37, rs.getString("Interest")== null ? "" : rs.getString("Interest")); //��Ϣ����
			alReserveTotal.add(38, rs.getString("RetSum")== null ? "" : rs.getString("RetSum")); //�����ջؽ��
			alReserveTotal.add(39, rs.getString("OmitSum")== null ? "" : rs.getString("OmitSum")); //���ں������
			alReserveTotal.add(40, rs.getString("GuarantyDiscountValue")== null ? "" : rs.getString("GuarantyDiscountValue")); //��Ѻ�﹫�ʼ�ֵ
			alReserveTotal.add(41, rs.getString("GuarantyAccount")== null ? "" : rs.getString("GuarantyAccount")); //��Ѻ��704�ʺ�
			alReserveTotal.add(42, rs.getString("MCancelReserveSum")== null ? "" : rs.getString("MCancelReserveSum")); //�����ھ�������ֵ׼��
			alReserveTotal.add(43, rs.getString("ACancelReserveSum")== null ? "" : rs.getString("ACancelReserveSum")); //��ƿھ�������ֵ׼��
			alReserveTotal.add(44, rs.getString("MExforLoss")== null ? "" : rs.getString("MExforLoss")); //�����ھ��������
			alReserveTotal.add(45, rs.getString("AExforLoss")== null ? "" : rs.getString("AExforLoss")); //��ƿھ��������
			alReserveTotal.add(46, rs.getString("MBadLastPrdDiscount")== null ? "" : rs.getString("MBadLastPrdDiscount")); //�����ھ�����Ԥ���ֽ�����������ֵ
			alReserveTotal.add(47, rs.getString("MBadPrdDiscount")== null ? "" : rs.getString("MBadPrdDiscount")); //�����ھ����������Ԥ���ֽ�������ֵ
			alReserveTotal.add(48, rs.getString("MBadReserveSum")== null ? "" : rs.getString("MBadReserveSum")); //�����ھ���������ڼ����ֵ׼��
			alReserveTotal.add(49, rs.getString("MBadMinusSum")== null ? "" : rs.getString("MBadMinusSum")); //�����ھ���������ڳ�����ֵ׼��
			alReserveTotal.add(50, rs.getString("MBadRetSum")== null ? "" : rs.getString("MBadRetSum")); //�����ھ����������ת�ؼ�ֵ׼��
			alReserveTotal.add(51, rs.getString("MBadReserveBalance")== null ? "" : rs.getString("MBadReserveBalance")); //�����ھ���������ڼ�ֵ׼�����
			alReserveTotal.add(52, rs.getString("ABadLastprdDiscount")== null ? "" : rs.getString("ABadLastprdDiscount")); //��ƿھ�������������Ԥ���ֽ�����������ֵ
			alReserveTotal.add(53, rs.getString("ABadPrdDiscount")== null ? "" : rs.getString("ABadPrdDiscount")); //��ƿھ����������Ԥ���ֽ�������ֵ
			alReserveTotal.add(54, rs.getString("ABadReserveSum")== null ? "" : rs.getString("ABadReserveSum")); //��ƿھ���������ڼ����ֵ׼��
			alReserveTotal.add(55, rs.getString("ABadMinusSum")== null ? "" : rs.getString("ABadMinusSum")); //��ƿھ���������ڳ�����ֵ׼��
			alReserveTotal.add(56, rs.getString("ABadRetSum")== null ? "" : rs.getString("ABadRetSum")); //��ƿھ����������ת�ؼ�ֵ׼��
			alReserveTotal.add(57, rs.getString("ABadReserveBalance")== null ? "" : rs.getString("ABadReserveBalance")); //��ƿھ���������ڼ�ֵ׼�����
			alReserveTotal.add(58, rs.getString("MNormalReserveSum")== null ? "" : rs.getString("MNormalReserveSum")); //�����ھ���������ڼ����ֵ׼��
			alReserveTotal.add(59, rs.getString("MNormalMinusSum")== null ? "" : rs.getString("MNormalMinusSum")); //�����ھ���������ڳ�����ֵ׼��
			alReserveTotal.add(60, rs.getString("MNormalReserveBalance")== null ? "" : rs.getString("MNormalReserveBalance")); //�����ھ���������ڼ�ֵ׼�����
			alReserveTotal.add(61, rs.getString("ANormalReserveSum")== null ? "" : rs.getString("ANormalReserveSum")); //��ƿھ���������ڼ����ֵ׼��
			alReserveTotal.add(62, rs.getString("ANormalMinusSum")== null ? "" : rs.getString("ANormalMinusSum")); //��ƿھ���������ڳ�����ֵ׼��
			alReserveTotal.add(63, rs.getString("ANormalReserveBalance")== null ? "" : rs.getString("ANormalReserveBalance")); //��ƿھ���������ڼ�ֵ׼�����
			alReserveTotal.add(64, rs.getString("BatchTime")== null ? "" : rs.getString("BatchTime")); //
			alReserveTotal.add(65, rs.getString("Manageuserid")== null ? "" : rs.getString("Manageuserid")); //��ݹܻ�Ա
			alReserveTotal.add(66, rs.getString("MonthRetSum")== null ? "" : rs.getString("MonthRetSum")); //�����ջؽ��
			alReserveTotal.add(67, rs.getString("MonthOmitSum")== null ? "" : rs.getString("MonthOmitSum")); //���º������
			alReserveTotal.add(68, rs.getString("LastMFiveClassify")== null ? "" : rs.getString("LastMFiveClassify")); //���ڹ�����弶����
			alReserveTotal.add(69, rs.getString("LastAFiveClassify")== null ? "" : rs.getString("LastAFiveClassify")); //��������弶����
            alReserveTotal.add(70, rs.getString("ManageStatFlag")== null ? "" : rs.getString("ManageStatFlag")); //���᷽ʽ 1-��Ϸ�ʽ  2-���ʼ���
            alReserveTotal.add(71, rs.getString("BusinessFlag")== null ? "" : rs.getString("BusinessFlag")); //ҵ���ʶ 1-�Թ�����   2-���˴���
            alReserveTotal.add(72, rs.getString("OverDueDays")== null ? "" : rs.getString("OverDueDays")); //��������
		}
		rs.getStatement().close();
		
		return alReserveTotal;
	}
		
	/**
	 * ������Ҫ��Ĵ������ݲ��뵽������Ϣ����
	 * @param ArrayList ����Ϊ������·ݡ������ʺš���Ŀ�š�......
	 * @return 
	 */
	public void insertReserveTotal(ArrayList alReserveTotal) throws Exception
	{
		//�������
		String sSql = "";
		
		sSql = 	" insert into RESERVE_TOTAL( "+
				" AccountMonth, "+ //����·�
				" LoanAccount, "+ //�����ʺ�
				" SubjectNo, "+ //��Ŀ��
				" ManageStatFlag, "+ //�����ھ������־
				" AuditStatFlag, "+ //��ƿھ������־
				" NonCreditTransferFlag, "+ //���Ŵ��ʲ�ת���־
				" DuebillNo, "+ //��ݱ��
				" CustomerID, "+ //�ͻ����
				" CustomerName, "+ //�ͻ�����
				" CustomerOrgCode, "+ //�ͻ���֯��������
				" Region, "+ //���ڵ���
				" ListingFlag, "+ //�Ƿ�������ҵ
				" IndustryType, "+ //��ҵ���
				" EconomyType, "+ //��������
				" Scope, "+ //��ҵ��ģ
				" StatOrgid, "+ //�ſ����
				" Currency, "+ //�������
				" BusinessSum, "+ //��ݽ��
				" PutoutDate, "+ //�ſ�����
				" Maturity, "+ //��������
				" LoanType, "+ //�������
				" LoanNature, "+ //��������
				" LoanTerm, "+ //��������
				" VouchType, "+ //��Ҫ������ʽ
				" Guarantor, "+ //��֤��/��Ѻ��/����������
				" GuarantyEvalValue, "+ //����Ѻ��ԭ����ֵ
				" BusinessRate, "+ //����������
				" PdgSum, "+ //���������
				" AuditRate, "+ //����ʵ������
				" OldPutoutDate, "+ //������������ſ���
				" Balance, "+ //Ŀǰ��ԭ�ң�
				" ExchangeRate, "+ //����
				" RMBBalance, "+ //Ŀǰ����ۺ������
				" FourClassify, "+ //�ļ�����
				" MFiveClassify, "+ //������弶����
				" AFiveClassify, "+ //����弶����
				" GuarantyNowValue, "+ //����Ѻ��������ֵ
				" Interest, "+ //��Ϣ����
				" RetSum, "+ //�����ջؽ��
				" OmitSum, "+ //���ں������
				" GuarantyDiscountValue, "+ //��Ѻ�﹫�ʼ�ֵ
				" GuarantyAccount, "+ //��Ѻ��704�ʺ�
				" MCancelReserveSum, "+ //�����ھ�������ֵ׼��
				" ACancelReserveSum, "+ //��ƿھ�������ֵ׼��
				" MExforLoss, "+ //�����ھ��������
				" AExforLoss, "+ //��ƿھ��������
				" MBadLastPrdDiscount, "+ //�����ھ�����Ԥ���ֽ�����������ֵ
				" MBadPrdDiscount, "+ //�����ھ����������Ԥ���ֽ�������ֵ
				" MBadReserveSum, "+ //�����ھ���������ڼ����ֵ׼��
				" MBadMinusSum, "+ //�����ھ���������ڳ�����ֵ׼��
				" MBadRetSum, "+ //�����ھ����������ת�ؼ�ֵ׼��
				" MBadReserveBalance, "+ //�����ھ���������ڼ�ֵ׼�����
				" ABadLastprdDiscount, "+ //��ƿھ�������������Ԥ���ֽ�����������ֵ
				" ABadPrdDiscount, "+ //��ƿھ����������Ԥ���ֽ�������ֵ
				" ABadReserveSum, "+ //��ƿھ���������ڼ����ֵ׼��
				" ABadMinusSum, "+ //��ƿھ���������ڳ�����ֵ׼��
				" ABadRetSum, "+ //��ƿھ����������ת�ؼ�ֵ׼��
				" ABadReserveBalance, "+ //��ƿھ���������ڼ�ֵ׼�����
				" MNormalReserveSum, "+ //�����ھ���������ڼ����ֵ׼��
				" MNormalMinusSum, "+ //�����ھ���������ڳ�����ֵ׼��
				" MNormalReserveBalance, "+ //�����ھ���������ڼ�ֵ׼�����
				" ANormalReserveSum, "+ //��ƿھ���������ڼ����ֵ׼��
				" ANormalMinusSum, "+ //��ƿھ���������ڳ�����ֵ׼��
				" ANormalReserveBalance, "+ //��ƿھ���������ڼ�ֵ׼�����
				" ReinforceFlag, " + //���Ǳ�־
				" Manageuserid, " + //��ݹܻ���
				" MonthRetSum, " + //�����ջؽ��
				" MonthOmitSum, " + //���º������
				" LastMFiveClassify, " + //���ڹ�����弶����
				" LastAFiveClassify " + //��������弶����
				" ) "+ 
				" values(" + 
				" '"+(String)alReserveTotal.get(0)+"', "+ //����·�
				" '"+(String)alReserveTotal.get(1)+"', "+ //�����ʺ�
				" '"+(String)alReserveTotal.get(2)+"', "+ //��Ŀ��
				" '"+(String)alReserveTotal.get(3)+"', "+ //�����ھ������־
				" '"+(String)alReserveTotal.get(4)+"', "+ //��ƿھ������־
				" '"+(String)alReserveTotal.get(5)+"', "+ //���Ŵ��ʲ�ת���־
				" '"+(String)alReserveTotal.get(6)+"', "+ //��ݱ��
				" '"+(String)alReserveTotal.get(7)+"', "+ //�ͻ����
				" '"+(String)alReserveTotal.get(8)+"', "+ //�ͻ�����
				" '"+(String)alReserveTotal.get(9)+"', "+ //�ͻ���֯��������
				" '"+(String)alReserveTotal.get(10)+"', "+ //���ڵ���
				" '"+(String)alReserveTotal.get(11)+"', "+ //�Ƿ�������ҵ
				" '"+(String)alReserveTotal.get(12)+"', "+ //��ҵ���
				" '"+(String)alReserveTotal.get(13)+"', "+ //��������
				" '"+(String)alReserveTotal.get(14)+"', "+ //��ҵ��ģ
				" '"+(String)alReserveTotal.get(15)+"', "+ //�ſ����
				" '"+(String)alReserveTotal.get(16)+"', "+ //�������
				" "+DataConvert.toDouble((String)alReserveTotal.get(17))+", "+ //��ݽ��
				" '"+(String)alReserveTotal.get(18)+"', "+ //�ſ�����
				" '"+(String)alReserveTotal.get(19)+"', "+ //��������
				" '"+(String)alReserveTotal.get(20)+"', "+ //�������
				" '"+(String)alReserveTotal.get(21)+"', "+ //��������
				" '"+(String)alReserveTotal.get(22)+"', "+ //��������
				" '"+(String)alReserveTotal.get(23)+"', "+ //��Ҫ������ʽ
				" '"+(String)alReserveTotal.get(24)+"', "+ //��֤��/��Ѻ��/����������
				" "+DataConvert.toDouble((String)alReserveTotal.get(25))+", "+ //����Ѻ��ԭ����ֵ
				" "+DataConvert.toDouble((String)alReserveTotal.get(26))+", "+ //���������� 
				" "+DataConvert.toDouble((String)alReserveTotal.get(27))+", "+ //���������
				" "+Double.parseDouble((String)alReserveTotal.get(28))+", "+ //����ʵ������
				" '"+(String)alReserveTotal.get(29)+"', "+ //������������ſ���
				" "+Double.parseDouble((String)alReserveTotal.get(30))+", "+ //Ŀǰ��ԭ�ң�
				" "+Double.parseDouble((String)alReserveTotal.get(31))+", "+ //����
				" "+Double.parseDouble((String)alReserveTotal.get(32))+", "+ //Ŀǰ����ۺ������
				" '"+(String)alReserveTotal.get(33)+"', "+ //�ļ�����
				" '"+(String)alReserveTotal.get(34)+"', "+ //������弶����
				" '"+(String)alReserveTotal.get(35)+"', "+ //����弶����
				" "+Double.parseDouble((String)alReserveTotal.get(36))+", "+ //����Ѻ��������ֵ
				" "+Double.parseDouble((String)alReserveTotal.get(37))+", "+ //��Ϣ����
				" "+Double.parseDouble((String)alReserveTotal.get(38))+", "+ //�����ջؽ��
				" "+Double.parseDouble((String)alReserveTotal.get(39))+", "+ //���ں������
				" "+Double.parseDouble((String)alReserveTotal.get(40))+", "+ //��Ѻ�﹫�ʼ�ֵ
				" '"+(String)alReserveTotal.get(41)+"', "+ //��Ѻ��704�ʺ�
				" "+Double.parseDouble((String)alReserveTotal.get(42))+", "+ //�����ھ�������ֵ׼��
				" "+Double.parseDouble((String)alReserveTotal.get(43))+", "+ //��ƿھ�������ֵ׼��
				" "+Double.parseDouble((String)alReserveTotal.get(44))+", "+ //�����ھ��������
				" "+Double.parseDouble((String)alReserveTotal.get(45))+", "+ //��ƿھ��������
				" "+Double.parseDouble((String)alReserveTotal.get(46))+", "+ //�����ھ�����Ԥ���ֽ�����������ֵ
				" "+Double.parseDouble((String)alReserveTotal.get(47))+", "+ //�����ھ����������Ԥ���ֽ�������ֵ
				" "+Double.parseDouble((String)alReserveTotal.get(48))+", "+ //�����ھ���������ڼ����ֵ׼��
				" "+Double.parseDouble((String)alReserveTotal.get(49))+", "+ //�����ھ���������ڳ�����ֵ׼��
				" "+Double.parseDouble((String)alReserveTotal.get(50))+", "+ //�����ھ����������ת�ؼ�ֵ׼��
				" "+Double.parseDouble((String)alReserveTotal.get(51))+", "+ //�����ھ���������ڼ�ֵ׼�����
				" "+Double.parseDouble((String)alReserveTotal.get(52))+", "+ //��ƿھ�������������Ԥ���ֽ�����������ֵ
				" "+Double.parseDouble((String)alReserveTotal.get(53))+", "+ //��ƿھ����������Ԥ���ֽ�������ֵ
				" "+Double.parseDouble((String)alReserveTotal.get(54))+", "+ //��ƿھ���������ڼ����ֵ׼��
				" "+Double.parseDouble((String)alReserveTotal.get(55))+", "+ //��ƿھ���������ڳ�����ֵ׼��
				" "+Double.parseDouble((String)alReserveTotal.get(56))+", "+ //��ƿھ����������ת�ؼ�ֵ׼��
				" "+Double.parseDouble((String)alReserveTotal.get(57))+", "+ //��ƿھ���������ڼ�ֵ׼�����
				" "+Double.parseDouble((String)alReserveTotal.get(58))+", "+ //�����ھ���������ڼ����ֵ׼��
				" "+Double.parseDouble((String)alReserveTotal.get(59))+", "+ //�����ھ���������ڳ�����ֵ׼��
				" "+Double.parseDouble((String)alReserveTotal.get(60))+", "+ //�����ھ���������ڼ�ֵ׼�����
				" "+Double.parseDouble((String)alReserveTotal.get(61))+", "+ //��ƿھ���������ڼ����ֵ׼��
				" "+Double.parseDouble((String)alReserveTotal.get(62))+", "+ //��ƿھ���������ڳ�����ֵ׼��
				" "+Double.parseDouble((String)alReserveTotal.get(63))+", "+ //��ƿھ���������ڼ�ֵ׼�����
				" '"+(String)alReserveTotal.get(64)+"', "+ //���Ǳ�־	
				" '"+(String)alReserveTotal.get(65)+"', "+ //��ݹܻ�Ա	
				" "+Double.parseDouble((String)alReserveTotal.get(66))+", "+ //�����ջؽ��
				" "+Double.parseDouble((String)alReserveTotal.get(67))+", "+ //���º������
				" '"+(String)alReserveTotal.get(68)+"', "+ //���ڹ�����弶����
				" '"+(String)alReserveTotal.get(69)+"' "+ //��������弶����
				")";
		if(debug)System.out.println(sSql);
		Sqlca.executeSQL(sSql);
	}
	
	/**
	 * ���´�����Ϣ������Ӧ����·ݺʹ����ʺŵļ�¼
	 * @param sAccountMonth ����·�,sLoanAccountNo �����ʺ�
	 * @return 
	 */
	public void updateReserveTotal(ArrayList alReserveTotal) throws Exception
	{
		//�������
		String sSql = "";
		String sAccountMonth = "";
		String sLoanAccountNo = "";
		
		sAccountMonth = (String)alReserveTotal.get(0);
		sLoanAccountNo = (String)alReserveTotal.get(1);
		sSql = 	" update RESERVE_TOTAL set MCancelReserveSum = "+DataConvert.toDouble((String)alReserveTotal.get(2))+ //�����ھ�������ֵ׼��
				", ACancelReserveSum = "+DataConvert.toDouble((String)alReserveTotal.get(3))+//��ƿھ�������ֵ׼��
				", MExforLoss = "+DataConvert.toDouble((String)alReserveTotal.get(4))+//�����ھ��������
				", AExforLoss = "+DataConvert.toDouble((String)alReserveTotal.get(5))+ //��ƿھ��������
				", MBadLastPrdDiscount = "+DataConvert.toDouble((String)alReserveTotal.get(6))+//�����ھ�����Ԥ���ֽ�����������ֵ
				", MBadPrdDiscount = "+DataConvert.toDouble((String)alReserveTotal.get(7))+//�����ھ����������Ԥ���ֽ�������ֵ
				", MBadReserveSum = "+DataConvert.toDouble((String)alReserveTotal.get(8))+//�����ھ���������ڼ����ֵ׼��
				", MBadMinusSum = "+DataConvert.toDouble((String)alReserveTotal.get(9))+//�����ھ���������ڳ�����ֵ׼��
				", MBadRetSum = "+DataConvert.toDouble((String)alReserveTotal.get(10))+//�����ھ����������ת�ؼ�ֵ׼��
				", MBadReserveBalance = "+DataConvert.toDouble((String)alReserveTotal.get(11))+//�����ھ���������ڼ�ֵ׼�����
				", ABadLastprdDiscount = "+DataConvert.toDouble((String)alReserveTotal.get(12))+//��ƿھ�������������Ԥ���ֽ�����������ֵ
				", ABadPrdDiscount = "+DataConvert.toDouble((String)alReserveTotal.get(13))+//��ƿھ����������Ԥ���ֽ�������ֵ
				", ABadReserveSum = "+DataConvert.toDouble((String)alReserveTotal.get(14))+//��ƿھ���������ڼ����ֵ׼��
				", ABadMinusSum = "+DataConvert.toDouble((String)alReserveTotal.get(15))+//��ƿھ���������ڳ�����ֵ׼��
				", ABadRetSum = "+DataConvert.toDouble((String)alReserveTotal.get(16))+//��ƿھ����������ת�ؼ�ֵ׼��
				", ABadReserveBalance = "+DataConvert.toDouble((String)alReserveTotal.get(17))+//��ƿھ���������ڼ�ֵ׼�����
				", MNormalReserveSum = "+DataConvert.toDouble((String)alReserveTotal.get(18))+//�����ھ���������ڼ����ֵ׼��
				", MNormalMinusSum = "+DataConvert.toDouble((String)alReserveTotal.get(19))+//�����ھ���������ڳ�����ֵ׼��
				", MNormalReserveBalance = "+DataConvert.toDouble((String)alReserveTotal.get(20))+//�����ھ���������ڼ�ֵ׼�����
				", ANormalReserveSum = "+DataConvert.toDouble((String)alReserveTotal.get(21))+//��ƿھ���������ڼ����ֵ׼��
				", ANormalMinusSum = "+DataConvert.toDouble((String)alReserveTotal.get(22))+//��ƿھ���������ڳ�����ֵ׼��
				", ANormalReserveBalance = "+DataConvert.toDouble((String)alReserveTotal.get(23))+//��ƿھ���������ڼ�ֵ׼�����
				", RetSum = "+DataConvert.toDouble((String)alReserveTotal.get(24))+//�����ջؽ��
				", OmitSum = "+DataConvert.toDouble((String)alReserveTotal.get(25))+//���ں������
				" where AccountMonth = '"+sAccountMonth+"' "+
				" and LoanAccount = '"+sLoanAccountNo+"' ";
		if(debug)System.out.println(sSql);
		Sqlca.executeSQL(sSql);
	}
	
	/**
	 * �Ӵ�����Ϣ��������ɾ����Ӧ����·ݺʹ����ʺŵļ�¼
	 * @param sAccountMonth ����·�,sLoanAccountNo �����ʺ�
	 * @return 
	 */
	public void deleteReserveTotal(String sAccountMonth,String sLoanAccountNo) throws Exception
	{
		//�������
		String sSql = "";
		
		sSql = 	" delete from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' "+
				" and LoanAccount = '"+sLoanAccountNo+"' ";
		Sqlca.executeSQL(sSql);
	}

	/**
	 * �Ӵ�����Ϣ��������ɾ����Ӧ����·ݵ����м�¼
	 * @param sAccountMonth ����·�,sLoanAccountNo �����ʺ�
	 * @return 
	 */
	public void deleteReserveTotal(String sAccountMonth) throws Exception
	{
		//�������
		String sSql = "";
		sSql = 	" delete from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' ";
		Sqlca.executeSQL(sSql);
	}
	
	/**
	 * �Ӵ�����Ϣ���в�����Ӧ����·ݺʹ����ʺŵļ�¼�Ƿ����
	 * @param sAccountMonth ����·�,sLoanAccountNo �����ʺ�
	 * @return true ���ڸû���·ݺʹ����ʺŵļ�¼��false �����ڸû���·ݺʹ����ʺŵļ�¼
	 */
	public boolean findExistReserveTotal(String sAccountMonth,String sLoanAccountNo) throws Exception
	{
		//�������
		String sSql = "";
		ASResultSet rs = null;
		boolean bFlag = false;
		
		sSql = 	" select count(LoanAccount) from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' "+
				" and LoanAccount = '"+sLoanAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			if(rs.getInt(1) > 0)
				bFlag = true;
		}
		rs.getStatement().close();
		
		return bFlag;
	}
	
	/**
	 * �Ӵ�����Ϣ���в�����Ӧ�����ʺŵļ�¼�Ƿ����
	 * @param sLoanAccountNo �����ʺ�
	 * @return true ���ڸô����ʺŵļ�¼��false �����ڸô����ʺŵļ�¼
	 */
	public boolean findExistReserveTotal(String sLoanAccountNo) throws Exception
	{
		//�������
		String sSql = "";
		ASResultSet rs = null;
		boolean bFlag = false;
		
		sSql = 	" select count(LoanAccount) from RESERVE_TOTAL "+
				" where LoanAccount = '"+sLoanAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			if(rs.getInt(1) > 0)
				bFlag = true;
		}
		rs.getStatement().close();
		
		return bFlag;
	}
	
	/**
	 * ��������Ϣ���б������ݴ����Ƿ�Ϊ�״γ�ʼ��
	 * @param 
	 * @return true �״γ�ʼ����false ���״γ�ʼ��
	 */
	public boolean getFirstRunFlag() throws Exception
	{
		//�������
		String sSql = "";
		ASResultSet rs = null;
		boolean bFlag = true;
		
		sSql = 	" select count(LoanAccount) from RESERVE_TOTAL ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			if(rs.getInt(1) > 0)
				bFlag = false;
		}
		rs.getStatement().close();
		
		return bFlag;
	}
	
	/**
	 * �Ӵ�����Ϣ���в�����Ӧ����·ݺʹ����ʺŵļ�¼�Ƿ����
	 * @param sAccountMonth ����·�,sLoanAccountNo �����ʺ�
	 * @return true ���ڸû���·ݺʹ����ʺŵļ�¼��false �����ڸû���·ݺʹ����ʺŵļ�¼
	 */
	public boolean findExistAmendReserveTotal(String sAccountMonth,String sLoanAccountNo) throws Exception
	{
		//�������
		String sSql = "";
		ASResultSet rs = null;
		boolean bFlag = false;
		
		sSql = 	" select count(LoanAccount) from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' "+
				" and LoanAccount = '"+sLoanAccountNo+"' " + 
				" and ReinforceFlag in ('01', '02', '03')";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			if(rs.getInt(1) > 0)
				bFlag = true;
		}
		rs.getStatement().close();
		
		return bFlag;
	}
	
	/**
	 * ���ݼ���¼�Ľ�������Ƿ�¼��־
	 * @param sAccountMonth ����·�,sLoanAccountNo �����ʺ�
	 * ��¼��־ 01���貹¼  02����¼��ɣ� 03������Ҫ��¼
	 * @throws Exception
	 */
	public void updAmendFlag(String sAccountMonth,String sLoanAccountNo) throws Exception {
		String sReinforceFlag = "03";
		if(isAmend(sAccountMonth,sLoanAccountNo)){
			sReinforceFlag = "01";
		}
		String sSql = 	" Update RESERVE_TOTAL set ReinforceFlag = '"+ sReinforceFlag + "'" + 
		" where AccountMonth = '"+sAccountMonth+"' "+
		" and LoanAccount = '"+sLoanAccountNo+"' ";
		Sqlca.executeSQL(sSql);
	}
	
	
	/**
	 * ����ָ���ֶ��Ƿ���ֵ�������Ƿ�¼�ü�¼
	 * @param sAccountMonth ����·�
	 * @param sLoanAccountNo �����ʺ�
	 * @return
	 * @throws Exception
	 */
	private boolean isAmend(String sAccountMonth,String sLoanAccountNo) throws Exception {
		boolean bAmend = false;
		String sSql = "Select DuebillNo " +//��ݱ��    1
		        ", CustomerID" +//�ͻ����
		        ", CustomerName" +//�ͻ�����
		        ", CustomerOrgCode" +//�ͻ���֯��������
		        ", Region" +//���ڵ���                     5
		        ", ListingFlag" +//�Ƿ�������ҵ
		        ", IndustryType" +//��ҵ���
		        ", EconomyType" +//��������
		        ", Scope" +//��ҵ��ģ
		        ", Currency" +//�������                  10
		        ", BusinessSum" +//��ͬ���
		        ", PutoutDate" +//�ſ�����
		        ", Maturity" +//��������
		        ", LoanType" +//�������
		        ", LoanNature" +//��������               15
		        ", LoanTerm" +//��������
		        ", VouchType" +//��Ҫ������ʽ
		        ", Guarantor" +//��֤��/��Ѻ��/��������
		        ", GuarantyEvalValue" +//����Ѻ��ԭ����ֵ
		        ", GuarantyDiscountValue" +//��Ѻ�﹫�ʼ�ֵ   20
		        ", GuarantyNowValue" +//����Ѻ��������ֵ
		        ", OldPutoutDate" +//������������ſ���
		        ", FourClassify" +//�ļ�����
		        ", MFiveClassify" +//������弶����
		        ", AFiveClassify" +//����弶����         25
		        ", StatOrgid" + //�ſ����
				" from RESERVE_TOTAL " + 
		        " where AccountMonth = '"+sAccountMonth+"' "+
		        " and LoanAccount = '"+sLoanAccountNo+"' ";
		ASResultSet rs = null;
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			if(rs.getString(1) == null 
					|| rs.getString(2) == null 
					|| rs.getString(3) == null  
					|| rs.getString(4) == null 
					|| rs.getString(5) == null 
					|| rs.getString(6) == null 
					|| rs.getString(7) == null 
					|| rs.getString(8) == null 
					|| rs.getString(9) == null 
					|| rs.getString(10) == null 
					|| rs.getString(11)== null
					|| rs.getString(12) == null 
					|| rs.getString(13) == null 
					|| rs.getString(14) == null
					|| rs.getString(15) == null 
					|| rs.getString(16) == null 
					|| rs.getString(17) == null 
					//|| rs.getString(18) == null || rs.getString(19) == null
					//|| rs.getString(20) == null || rs.getString(21) == null 
					|| rs.getString(22) == null 
					|| rs.getString(23) == null 
					|| rs.getString(24) == null 
					|| rs.getString(25) == null
					|| rs.getString(26) == null
					)
				bAmend = true;
			
			if(!bAmend && !rs.getString(17).equals("01")){//���ô���
				if(rs.getString(18) == null || rs.getString(19) == null || rs.getString(20) == null || rs.getString(21) == null ){
					bAmend = true;
				}
			}
		}
		rs.getStatement().close();
        
		return bAmend;
	}
	
	/**
	 * ��ȡС��ָ���·ݵ�����·�
	 * @param sAccountMonth
	 * @param sLoanAccountNo
	 * @return
	 * @throws Exception
	 */
	public String getMaxLTAccountMonth(String sAccountMonth) throws Exception{
		ASResultSet rs = null;
		String sSql = "";
		String sMaxMonth = "";
		
		sSql = 	" select max(AccountMonth) as AccountMonth "+
				" from RESERVE_TOTAL "+
				" where AccountMonth < '"+sAccountMonth+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sMaxMonth = rs.getString("AccountMonth");
			if(sMaxMonth == null) sMaxMonth = "";
		}
		rs.getStatement().close();
		return sMaxMonth;
	}
	
	/**
	 * ��ȡ���ڴ����ܶ�
	 * @param sAccountMonth
	 * @return
	 * @throws Exception
	 */
	public double getTotalBalance(String sAccountMonth)throws Exception{
		ASResultSet rs = null;
		String sSql = "";
		double dLoanBalance = 0.0;
		
		sSql = 	" select nvl(sum(RMBBalance),0.0) "+
				" from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dLoanBalance = rs.getDouble(1);
		}
		rs.getStatement().close();
		return dLoanBalance;		
	}
	
	/**
	 * �����弶����Ĵ������
	 * @param sAccountMonth
	 * @param sMAScope
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	public double getFiveBalance(String sAccountMonth, String sMAScope, String sFiveResult)throws Exception{
		double dFiveBalance = 0.0;
		String sScopeField = "AuditStatFlag";
		String sFiveField = "AFiveClassify";
		if(sMAScope.equals("M")){
			sFiveField = "MFiveClassify";
			sScopeField = "ManageStatFlag";
		}
		ASResultSet rs = null;
		String sSql = "";
		sSql = 	" select sum(RMBBalance) "+
				" from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' " + 
				" and " + sScopeField + "='1'" + 
				" and " + sFiveField + "= '" + sFiveResult + "'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dFiveBalance = rs.getDouble(1);
		}
		rs.getStatement().close();
		return dFiveBalance;				
	}
	
	/**
	 * �����弶�������Ϣ����
	 * @param sAccountMonth
	 * @param sMAScope
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	public double getFiveInterest(String sAccountMonth, String sMAScope, String sFiveResult)throws Exception{
		double dFiveInterest = 0.0;
		String sScopeField = "AuditStatFlag";
		String sFiveField = "AFiveClassify";
		if(sMAScope.equals("M")){
			sFiveField = "MFiveClassify";
			sScopeField = "ManageStatFlag";
		}
		ASResultSet rs = null;
		String sSql = "";
		sSql = 	" select nvl(sum(Interest),0.0) "+
				" from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' " + 
				" and " + sScopeField + "='1'" + 
				" and " + sFiveField + "= '" + sFiveResult + "'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dFiveInterest = rs.getDouble(1);
		}
		rs.getStatement().close();
		return dFiveInterest;				
	}
	
	/**
	 * �����弶�����Ԥ���ֽ�������ֵ�ܶ�
	 * @param sAccountMonth
	 * @param sMAScope
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	public double getFiveCashDiscount(String sAccountMonth, String sMAScope, String sFiveResult)throws Exception{
		double dFiveCashDiscount = 0.0;
		String sScopeField = "AuditStatFlag";
		String sFiveField = "AFiveClassify";
		String sDiscountField = "ABadPrdDiscount";
		if(sMAScope.equals("M")){
			sFiveField = "MFiveClassify";
			sScopeField = "ManageStatFlag";
			sDiscountField = "MBadPrdDiscount";
		}
		ASResultSet rs = null;
		String sSql = "";
		sSql = 	" select nvl(sum(" + sDiscountField + "),0.0) "+
				" from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' " + 
				" and " + sScopeField + "='1'" + 
				" and " + sFiveField + "= '" + sFiveResult + "'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dFiveCashDiscount = rs.getDouble(1);
		}
		rs.getStatement().close();
		return dFiveCashDiscount;				
	}

	/**
	 * �����弶����ļ�ֵ׼���ܶ�
	 * @param sAccountMonth
	 * @param sMAScope
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	public double getFiveRBBalance(String sAccountMonth, String sMAScope, String sFiveResult)throws Exception{
		double dFiveRBBalance = 0.0;
		String sScopeField = "AuditStatFlag";
		String sFiveField = "AFiveClassify";
		String sRBField = "ABadReserveBalance";
		if(sMAScope.equals("M")){
			sFiveField = "MFiveClassify";
			sScopeField = "ManageStatFlag";
			sRBField = "MBadReserveBalance";
		}
		ASResultSet rs = null;
		String sSql = "";
		sSql = 	" select nvl(sum(" + sRBField + "),0.0) "+
				" from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' " + 
				" and " + sScopeField + "='1'" + 
				" and " + sFiveField + "= '" + sFiveResult + "'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dFiveRBBalance = rs.getDouble(1);
		}
		rs.getStatement().close();
		return dFiveRBBalance;				
	}

	/**
	 * �����弶����ı������
	 * @param sAccountMonth
	 * @param sMAScope
	 * @param sFiveResult
	 * @return
	 * @throws Exception
	 */
	public double getFiveCancelSum(String sAccountMonth, String sMAScope, String sFiveResult)throws Exception{
		double dFiveRBBalance = 0.0;
		String sScopeField = "AuditStatFlag";
		String sFiveField = "AFiveClassify";
		if(sMAScope.equals("M")){
			sFiveField = "MFiveClassify";
			sScopeField = "ManageStatFlag";
		}
		ASResultSet rs = null;
		String sSql = "";
		sSql = 	" select nvl(sum(OmitSum),0.0) "+
				" from RESERVE_TOTAL "+
				" where AccountMonth = '"+sAccountMonth+"' " + 
				" and " + sScopeField + "='1'" + 
				" and " + sFiveField + "= '" + sFiveResult + "'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dFiveRBBalance = rs.getDouble(1);
		}
		rs.getStatement().close();
		return dFiveRBBalance;				
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try
		{
			
		}catch(Exception e)
		{
			System.out.println(e.toString());
		}
	}
}
