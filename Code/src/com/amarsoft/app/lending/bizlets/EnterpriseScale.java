package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.DBFunction;

public class EnterpriseScale extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		// �Զ���ô���Ĳ���ֵ
		String sCustomerID = (String) this.getAttribute("CustomerID");

		Double EmployeeNumber = Double.parseDouble((String) this
				.getAttribute("EmployeeNumber"));// ��ҵ��Ա

		Double SellSum = Double.parseDouble((String) this
				.getAttribute("SellSum"));// Ӫҵ����

		Double TotalAssets = Double.parseDouble((String) this
				.getAttribute("TotalAssets"));// �ʲ��ܶ�

		String sIndustryName = (String) this.getAttribute("IndustryName");// ��ҵ��ģ������ҵ����
		String sScopeLarge = "2";
		String sScopeMedium = "3";
		String sScopeSmall = "4";
		String sScopeExtraSmall = "5";
		String result = "";

		String dLockEntScale = "";
		Double dEmployeeSmallType = 0.0, dSellSmallType = 0.0, dAssetsSmallType = 0.0;
		Double dEmployeeLargeType = 0.0, dSellLargeType = 0.0, dAssetsLargeType = 0.0;
		Double dEmployeeMediumType = 0.0, dSellMediumType = 0.0, dAssetsMediumType = 0.0;
		// �����������ʾ��Ϣ��SQL���,�ͻ�����
		String sSql = "";
		// �����������ѯ�����
		ASResultSet rs = null;

		sSql = " select lockentscale from ENT_INFO where customerid = '"
				+ sCustomerID + "'";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) {
			dLockEntScale = rs.getString("LockEntScale");
		}
		rs.getStatement().close();
        
		//�ж���ҵ��ģ�Ƿ�����
		if ("01".equals(dLockEntScale)) {
			return result;
		}
		// ��ҵ��Ա
		sSql = " select ExtraSmallType,SmallType,MediumType,LargeType"
				+ " from INDUSTRY_CFG where IndustryName = '" + sIndustryName
				+ "' and GuideName = '01'";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) {

			dEmployeeSmallType = Double.parseDouble(rs.getString("SmallType"));
			dEmployeeMediumType = Double
					.parseDouble(rs.getString("MediumType"));
			dEmployeeLargeType = Double.parseDouble(rs.getString("LargeType"));
		}
		rs.getStatement().close();

		// Ӫҵ����
		sSql = " select ExtraSmallType,SmallType,MediumType,LargeType"
				+ " from INDUSTRY_CFG where IndustryName = '" + sIndustryName
				+ "' and GuideName = '02'";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) {

			dSellSmallType = Double.parseDouble(rs.getString("SmallType"));
			dSellMediumType = Double.parseDouble(rs.getString("MediumType"));
			dSellLargeType = Double.parseDouble(rs.getString("LargeType"));
		}
		rs.getStatement().close();

		// �ʲ��ܶ�
		sSql = " select ExtraSmallType,SmallType,MediumType,LargeType"
				+ " from INDUSTRY_CFG where IndustryName = '" + sIndustryName
				+ "' and GuideName = '03'";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) {

			dAssetsSmallType = Double.parseDouble(rs.getString("SmallType"));
			dAssetsMediumType = Double.parseDouble(rs.getString("MediumType"));
			dAssetsLargeType = Double.parseDouble(rs.getString("LargeType"));
		}
		rs.getStatement().close();

		boolean Condition1 = true;
		boolean Condition2 = true;
		boolean Condition3 = true;
		boolean Condition4 = true;
		boolean Condition5 = true;
		boolean Condition6 = true;
		boolean Condition7 = true;
		boolean Condition8 = true;
		boolean Condition9 = true;

		// ��ҵ��Ա�����ж�
		if (dEmployeeLargeType > 0) {
			Condition1 = EmployeeNumber >= dEmployeeLargeType;
		} else {
			Condition1 = true;
		}
		// ��ҵ��Ա�����ж�
		if (dEmployeeMediumType > 0) {
			Condition4 = EmployeeNumber >= dEmployeeMediumType;
		} else {
			Condition4 = true;
		}
		// ��ҵ��ԱС���ж�
		if (dEmployeeSmallType > 0) {
			Condition7 = EmployeeNumber >= dEmployeeSmallType;
		} else {
			Condition7 = true;
		}
		// Ӫҵ��������ж�
		if (dSellLargeType > 0) {
			Condition2 = SellSum >= dSellLargeType;
		} else {
			Condition2 = true;
		}
		// Ӫҵ���������ж�
		if (dSellMediumType > 0) {
			Condition5 = SellSum >= dSellMediumType;
		} else {
			Condition5 = true;
		}
		// Ӫҵ����С���ж�
		if (dSellSmallType > 0) {
			Condition8 = SellSum >= dSellSmallType;
		} else {
			Condition8 = true;
		}
		// �ʲ��ܶ�����ж�
		if (dAssetsLargeType > 0) {
			Condition3 = TotalAssets >= dAssetsLargeType;
		} else {
			Condition3 = true;
		}
		// �ʲ��ܶ������ж�
		if (dAssetsMediumType > 0) {
			Condition6 = TotalAssets >= dAssetsMediumType;
		} else {
			Condition6 = true;
		}
		// �ʲ��ܶ�С���ж�
		if (dAssetsSmallType > 0) {
			Condition9 = TotalAssets >= dAssetsSmallType;
		} else {
			Condition9 = true;
		}

		if (Condition1 && Condition2 && Condition3) {
			result = sScopeLarge;
		} else if (Condition4 && Condition5 && Condition6) {
			result = sScopeMedium;
		} else if (Condition7 && Condition8 && Condition9) {
			result = sScopeSmall;
		} else {
			result = sScopeExtraSmall;
		}

		if (dEmployeeLargeType == 0 && dAssetsLargeType == 0
				&& dSellLargeType == 0) {
			return result = "NODATA";
		}
		/*
		 * if(dEmployeeLargeType == null && dSellLargeType != null &&
		 * dAssetsLargeType != null) { if(SellSum >= dSellLargeType &&
		 * TotalAssets >= dAssetsLargeType){ result = sScopeLarge; }else
		 * if(SellSum >= dSellMediumType && TotalAssets >= dAssetsMediumType){
		 * result = sScopeMedium; }else if(SellSum >= dSellSmallType &&
		 * TotalAssets >= dAssetsSmallType){ result = sScopeSmall; }else result =
		 * sScopeExtraSmall; } else if(dSellLargeType == null &&
		 * dEmployeeLargeType != null && dAssetsLargeType != null) {
		 * if(EmployeeNumber >= dEmployeeLargeType && TotalAssets >=
		 * dAssetsLargeType){ result = sScopeLarge; }else if(EmployeeNumber >=
		 * dEmployeeMediumType && TotalAssets >= dAssetsMediumType){ result =
		 * sScopeMedium; }else if(EmployeeNumber >= dEmployeeSmallType &&
		 * TotalAssets >= dAssetsSmallType){ result = sScopeSmall; }else result =
		 * sScopeExtraSmall; } else if(dAssetsLargeType == null &&
		 * dEmployeeLargeType != null && dSellLargeType != null) {
		 * if(EmployeeNumber >= dEmployeeLargeType && SellSum >=
		 * dSellLargeType){ result = sScopeLarge; }else if(EmployeeNumber >=
		 * dEmployeeMediumType && SellSum >= dSellMediumType){ result =
		 * sScopeMedium; }else if(EmployeeNumber >= dEmployeeSmallType &&
		 * SellSum >= dSellSmallType){ result = sScopeSmall; }else result =
		 * sScopeExtraSmall; } else if(dAssetsLargeType == null &&
		 * dSellLargeType == null && dEmployeeLargeType != null) {
		 * if(EmployeeNumber >= dEmployeeLargeType ){ result = sScopeLarge;
		 * }else if(EmployeeNumber >= dEmployeeMediumType ){ result =
		 * sScopeMedium; }else if(EmployeeNumber >= dEmployeeSmallType ){ result =
		 * sScopeSmall; }else result = sScopeExtraSmall; } else
		 * if(dEmployeeLargeType == null && dSellLargeType == null &&
		 * dAssetsLargeType != null) { if(TotalAssets >= dAssetsLargeType ){
		 * result = sScopeLarge; }else if(TotalAssets >= dAssetsMediumType ){
		 * result = sScopeMedium; }else if(TotalAssets >= dAssetsSmallType ){
		 * result = sScopeSmall; }else result = sScopeExtraSmall; } else
		 * if(dEmployeeLargeType == null && dAssetsLargeType == null &&
		 * dSellLargeType != null) { if(SellSum >= dSellLargeType ){ result =
		 * sScopeLarge; }else if(SellSum >= dSellMediumType ){ result =
		 * sScopeMedium; }else if(SellSum >= dSellSmallType ){ result =
		 * sScopeSmall; }else result = sScopeExtraSmall; } else
		 * if(dEmployeeLargeType != null && dAssetsLargeType != null &&
		 * dSellLargeType != null) { if(EmployeeNumber >= dEmployeeLargeType &&
		 * SellSum >= dSellLargeType && TotalAssets >= dAssetsLargeType){ result =
		 * sScopeLarge; }else if(EmployeeNumber >= dEmployeeMediumType &&
		 * SellSum >= dSellMediumType && TotalAssets >= dAssetsMediumType){
		 * result = sScopeMedium; }else if(EmployeeNumber >= dEmployeeSmallType &&
		 * SellSum >= dSellSmallType && TotalAssets >= dAssetsSmallType){ result =
		 * sScopeSmall; }else result = sScopeExtraSmall; } // }
		 */
		return result;
	}
}
