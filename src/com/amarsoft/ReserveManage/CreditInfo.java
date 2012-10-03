package com.amarsoft.ReserveManage;

import java.util.ArrayList;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;


public class CreditInfo {
	
	private Transaction Sqlca = null;
	
	public CreditInfo(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;			
	}
		
	/**
	 * ������֯���������ȡ�ͻ���Ϣ
	 * @param sCertID ��֯��������
	 * @return ArrayList ����Ϊ���ͻ���š��ͻ����ơ����ڵ������Ƿ�������ҵ����ҵ��𡢾������͡���ҵ��ģ
	 */
	public ArrayList getCustomerInfo(String sCertID) throws Exception
	{
		//�������		
		ArrayList alCustomerInfo = new ArrayList();
		ASResultSet rs = null;
		String sSql = "";
		
		//������֯���������ȡ�ͻ���Ϣ
		sSql = 	" select EI.CustomerID,EI.EnterpriseName,EI.RegionCode, "+
				" EI.ListingCorpOrNot,substr(EI.IndustryType2, 1,1) as IndustryType2, substr(EI.EconomyType,1,2) as EconomyType, "+
				" EI.Scope "+
				" from CUSTOMER_INFO CI,ENT_INFO EI "+
				" where CI.CustomerID = EI.CustomerID "+
				" and CI.othercustomerid = '"+sCertID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			alCustomerInfo.add(0, rs.getString("CustomerID")== null ? "" : rs.getString("CustomerID"));
			alCustomerInfo.add(1, rs.getString("EnterpriseName")== null ? "" : rs.getString("EnterpriseName"));
			alCustomerInfo.add(2, rs.getString("RegionCode")== null ? "" : rs.getString("RegionCode"));
			alCustomerInfo.add(3, rs.getString("ListingCorpOrNot")== null ? "" : rs.getString("ListingCorpOrNot"));
			alCustomerInfo.add(4, rs.getString("IndustryType2")== null ? "" : rs.getString("IndustryType2"));
			alCustomerInfo.add(5, rs.getString("EconomyType")== null ? "" : rs.getString("EconomyType"));
			alCustomerInfo.add(6, rs.getString("Scope")== null ? "" : rs.getString("Scope"));
		}
		rs.getStatement().close();
		
		return alCustomerInfo;
	}
	
	/**
	 * ���ݴ����ʺŻ�ȡ����ĳ�����ˮ�źͺ�ͬ��ˮ��
	 * @param sLoanAccountNo �����ʺ�
	 * @return ArrayList ����Ϊ��������ˮ�š���ͬ��ˮ��
	 */
	public ArrayList getPutoutInfo(String sLoanAccountNo) throws Exception
	{
		//�������		
		ArrayList al=new ArrayList();
		ASResultSet rs = null;
		String sSql = "";
		
		//���ݴ����ʺŻ�ȡ������ˮ�źͺ�ͬ��ˮ��
		sSql = 	" select SerialNo,RelativeSerialNo "+
				" from BUSINESS_PUTOUT "+
				" where Attribute1 = '"+sLoanAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			al.add(0, rs.getString("SerialNo")== null ? "" : rs.getString("SerialNo"));
			al.add(1, rs.getString("RelativeSerialNo")== null ? "" : rs.getString("RelativeSerialNo"));						
		}
		rs.getStatement().close();
		
		return al;
	}
	
	/**
	 * ���ݴ����ʺŻ�ȡ��������Ϣ
	 * @param sPayAccount �����ʺ�
	 * @return ArrayList ����Ϊ���������ޡ������ˮ�š��ſ����ڡ��������ڡ��弶���ࡢ�Ŵ���������ݽ����������ʡ���ݹܻ�Ա����ͬ��š�
	 */
	public ArrayList getDuebillInfo(String sPayAccount) throws Exception
	{
		//�������
		ArrayList alDuebillInfo = new ArrayList();
		ASResultSet rs = null;
		String sSql = "";
		
		//���ݳ�����ˮ�Ż�ȡ��������Ϣ
		sSql = 	" select case when floor(to_date(Maturity,'yyyy/mm/dd')-to_date(ActualPutoutDate,'yyyy/mm/dd'))<=366 then '1' else '2' end as LoanTerm, "+
				" SerialNo,ActualPutoutDate,Maturity,ConveyReturnFlag,StatOrgID,BusinessSum,BusinessRate , Manageuserid,  RelativeSerialNo2 as ContractNo "+
				" from BUSINESS_DUEBILL "+
				" where PayAccount = '"+sPayAccount+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			alDuebillInfo.add(0, rs.getString("LoanTerm")== null ? "" : rs.getString("LoanTerm"));
			alDuebillInfo.add(1, rs.getString("SerialNo")== null ? "" : rs.getString("SerialNo"));			
			alDuebillInfo.add(2, rs.getString("ActualPutoutDate")== null ? "" : rs.getString("ActualPutoutDate"));
			alDuebillInfo.add(3, rs.getString("Maturity")== null ? "" : rs.getString("Maturity"));
			alDuebillInfo.add(4, rs.getString("ConveyReturnFlag")== null ? "" : rs.getString("ConveyReturnFlag"));
			alDuebillInfo.add(5, rs.getString("StatOrgID")== null ? "" : rs.getString("StatOrgID"));
			alDuebillInfo.add(6, rs.getString("BusinessSum")== null ? "" : rs.getString("BusinessSum"));
			alDuebillInfo.add(7, rs.getString("BusinessRate")== null ? "" : rs.getString("BusinessRate"));	
			alDuebillInfo.add(8, rs.getString("Manageuserid")== null ? "" : rs.getString("Manageuserid"));	
			alDuebillInfo.add(9, rs.getString("ContractNo")== null ? "" : rs.getString("ContractNo"));	//��ͬ��ţ��Զ����ɵĺ�ͬ���
		}
		rs.getStatement().close();
		
		return alDuebillInfo;
	}
	
	/**
	 * ���ݺ�ͬ��ˮ�Ż�ȡ��ͬ�����Ϣ
	 * @param sContractNo ��ͬ��ˮ��
	 * @return ArrayList ����Ϊ��������𣨼�ҵ��Ʒ�֣����������ʣ����������ͣ�����Ҫ������ʽ��704�ʺš�
	 */
	public ArrayList getContractInfo(String sContractNo) throws Exception
	{
		//�������
		ArrayList alContractInfo = new ArrayList();
		ASResultSet rs = null;
		String sSql = "";
		
		//���ݺ�ͬ��ˮ�Ż�ȡ��ͬ�����Ϣ
		sSql = 	" select BusinessType,OccurType,substr(VouchType, 1,2) as VouchType,GuarantyAccount "+
				" from BUSINESS_CONTRACT "+
				" where SerialNo = '"+sContractNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{			
			alContractInfo.add(0, rs.getString("BusinessType")== null ? "" : rs.getString("BusinessType"));
			alContractInfo.add(1, rs.getString("OccurType")== null ? "" : rs.getString("OccurType"));
			alContractInfo.add(2, rs.getString("VouchType")== null ? "" : rs.getString("VouchType"));
			alContractInfo.add(3, rs.getString("GuarantyAccount")== null ? "" : rs.getString("GuarantyAccount"));
		}
		rs.getStatement().close();
		
		return alContractInfo;
	}
	
	/**
	 * ����704�ʺŻ�ȡ����Ѻ�������Ϣ
	 * @param sGuarantyAccountNo 704�ʺ�
	 * @return ArrayList ����Ϊ����Ѻ��/���������ơ�����Ѻ��ԭ������ֵ������Ѻ��������ֵ
	 */
	public ArrayList getGuarantyInfo(String sGuarantyAccountNo) throws Exception
	{
		//�������	
		ArrayList alGuarantyInfo = new ArrayList();
		ASResultSet rs = null;
		String sSql = "";
		String sGuarantyType = "";
		String sSigneeName = "";
		double dBeforeEvalValue = 0.0;
		double dEvalValue = 0.0;
		String sSigneeNameStr = "";
		double dTotalBeforeEvalValue = 0.0;
		double dTotalEvalValue = 0.0;
		
		
		//����704�ʺŻ�ȡ����Ѻ����Ϣ
		sSql = 	" select GuarantyType,SigneeName,BeforeEvalValue,EvalValue "+
				" from GUARANTY_DETAIL "+
				" where GuarantyAccount = '"+sGuarantyAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sGuarantyType = rs.getString("GuarantyType");
			sSigneeName = rs.getString("SigneeName");
			dBeforeEvalValue = rs.getDouble("BeforeEvalValue");
			dEvalValue = rs.getDouble("EvalValue");
			//����ֵת��Ϊ���ַ���
			if(sGuarantyType == null) sGuarantyType = "";
			if(sSigneeName == null) sSigneeName = "";
			
			//���е�Ѻ��/���������Ƶĺϲ�
			if(!sSigneeName.equals(""))
				sSigneeNameStr += sSigneeName +",";
			//�����Ѻ��������Ϊ��Ѻ�������Ѻ��ԭ������ֵ��Ϊ����Ѻ��������ֵ
			if(sGuarantyType.substring(0,2).equals("04"))
			{
				dTotalBeforeEvalValue += dEvalValue;
				dTotalEvalValue += dEvalValue;
			}else
			{
				dTotalBeforeEvalValue += dBeforeEvalValue;
				dTotalEvalValue += dEvalValue;
			}				
		}
		rs.getStatement().close();
		
		//ȥ����Ѻ��/�����������ַ�����ĩβ��","
		if(sSigneeNameStr.length() > 0)
			sSigneeNameStr = sSigneeNameStr.substring(0, sSigneeNameStr.length()-1);
		
		//����Ҫ�����ݴ����ArrayList��
		alGuarantyInfo.add(0, sSigneeNameStr);
		alGuarantyInfo.add(1, String.valueOf(dTotalBeforeEvalValue));
		alGuarantyInfo.add(2, String.valueOf(dTotalEvalValue));	
		
		return alGuarantyInfo;
	}
	
	/**
	 * ���ݺ�ͬ��ˮ�Ż�ȡ��֤������
	 * @param sContractNo ��ͬ��ˮ��
	 * @return String ��֤������ƴ�ɵ��ַ���
	 */
	public String getSigneeName(String sContractNo) throws Exception
	{
		//�������
		ASResultSet rs = null;
		String sSql = "";		
		String sSigneeName = "";		
		String sSigneeNameStr = "";
		
		//���ݺ�ͬ��ˮ�Ż�ȡ��֤����Ϣ
		sSql = 	" select SigneeName "+
				" from GUARANTY_INFO "+
				" where ObjectType = 'BusinessContract' "+
				" and ObjectNo = '"+sContractNo+"' "+
				" and GuarantyType like '02%' ";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{			
			sSigneeName = rs.getString("SigneeName");			
			//����ֵת��Ϊ���ַ���			
			if(sSigneeName == null) sSigneeName = "";
			
			//���б�֤�����Ƶĺϲ�
			if(!sSigneeName.equals(""))
				sSigneeNameStr += sSigneeName +",";							
		}
		rs.getStatement().close();
		
		//ȥ����֤�������ַ�����ĩβ��","
		if(sSigneeNameStr.length() > 0)
			sSigneeNameStr = sSigneeNameStr.substring(0, sSigneeNameStr.length()-1);
						
		return sSigneeNameStr;
	}
	
	/**
	 * ���ݿ�Ŀ�Ż�ȡ�ļ�������Ϣ
	 * @param sSubject ��Ŀ��
	 * @return String �ļ�����
	 */
	public String getFourClassify(String sSubject) throws Exception
	{
		//�������			
		ASResultSet rs = null;
		String sSql = "";
		String sFourClassify = "";
						
		if(sSubject.equals("13001") || sSubject.equals("13002")) //13001��13002Ϊ����
			sFourClassify = "2";  //����
		else if(sSubject.equals("13003")) //13003Ϊ����
			sFourClassify = "3";  //����
		else if(sSubject.equals("13004")) //13004Ϊ����
			sFourClassify = "4";  //����
		else //����Ϊ����
			sFourClassify = "1";  //����
		return sFourClassify;
	}
	
	/**
	 * ����ʮ��������ת��Ϊ�弶����
	 * @param sCreditFiveClassify ʮ�������ࣨ�Ŵ�ϵͳ��
	 * @return String �弶���ࣨ��ֵ׼����
	 */
	public String getReserveFiveClassify(String sCreditFiveClassify) throws Exception
	{
		//�������			
		ASResultSet rs = null;
		String sSql = "";
		String sReserveFiveClassify = "";
		
		//01-06Ϊ����һ��������
		if(sCreditFiveClassify.equals("01") || sCreditFiveClassify.equals("02")
		|| sCreditFiveClassify.equals("03") || sCreditFiveClassify.equals("04")
		|| sCreditFiveClassify.equals("05") || sCreditFiveClassify.equals("06"))
			sReserveFiveClassify = "01";  //����
		else if(sCreditFiveClassify.equals("07")) //��ע
			sReserveFiveClassify = "02";  //��ע
		else if(sCreditFiveClassify.equals("08") || sCreditFiveClassify.equals("09")) //08-09Ϊ�μ�һ���μ���
			sReserveFiveClassify = "03";  //�μ�
		else if(sCreditFiveClassify.equals("10") || sCreditFiveClassify.equals("11")) //08-09Ϊ����һ�����ɶ�
			sReserveFiveClassify = "04";  //����
		else if(sCreditFiveClassify.equals("12")) //��ʧ
			sReserveFiveClassify = "05";  //��ʧ
		return sReserveFiveClassify;
	}
	
	/**
	 * ���ݴ����ʺŻ�ȡ�ͻ�����֯��������
	 * @param sLoanAccount
	 * @return
	 * @throws Exception
	 */
	public String getCustomerOrgCode(String sLoanAccount)throws Exception{
		String sCustomerOrgCode = "";
		String sSql = "select othercustomerid from customer_info where customerid = " + 
		   "(select customerid from business_duebill where payaccount = '" + sLoanAccount + "')";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sCustomerOrgCode = rs.getString(1) == null ? "" : rs.getString(1) ;
		}
		rs.getStatement().close();
		return sCustomerOrgCode;
	}
	
	/**
	 * ���ݴ����ʺźͻ���·ݻ�ȡ��ݵ��弶���������϶����
	 * @param sDuebillNo   ��ݱ��
	 * @param sAccountMonth  ����·�
	 * @return
	 * @throws Exception
	 */
	public String getFiveClassify(String sDuebillNo, String sAccountMonth)throws Exception{
		String sFiveClassify = "";
		String sSql = "select Result4 from CLASSIFY_RECORD where AccountMonth = '" + sAccountMonth + "'" +
		   " and ObjectNo = '" + sDuebillNo + "' and ObjectType = 'BusinessDueBill'";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sFiveClassify = rs.getString(1) == null ? "" : rs.getString(1) ;
		}
		rs.getStatement().close();
		return sFiveClassify;	
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
