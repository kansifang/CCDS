/**
 * �жϸñ�ҵ����Ƿ���Ҫ���е�����У��
 * wangdw
 */
package com.amarsoft.app.util;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;

public class ChangTypeCheckOut {
	private ChangTypeCheckOut() {}
	public static ChangTypeCheckOut changTypeCheckOut = new ChangTypeCheckOut();
	public static ChangTypeCheckOut getInstance() {
		return changTypeCheckOut;
	}
/**
 * 
 * @param Sqlca
 * @param sMainTable
 * @param sObjectNo
 * @return
 * ��������ϴ���������У��
 * @throws Exception
 */
	public boolean changtypecheckout_gjj(Transaction Sqlca, String sMainTable, String sObjectNo)
			throws Exception {
		String sBusinessType = "";
		String sOccurType = "";
		String sChangType = "";
		String sSql = "select businesstype,occurtype,changtype from "
				+ sMainTable + " where SerialNo = '" + sObjectNo + "'";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) {
			sBusinessType = rs.getString("BusinessType"); // ҵ��Ʒ��
			sOccurType = rs.getString("OccurType"); 	  // ��������
			sChangType = rs.getString("ChangType"); 	  // �������
		}
		rs.getStatement().close();
		return true;
//		if (!"1110027".equals(sBusinessType) || !"120".equals(sOccurType)|| !"02".equals(sChangType)) 
//		{
//			return true;
//		} else
//		{
//			return false;
//		}
	}
	/**
	 * 
	 * @param Sqlca
	 * @param sMainTable
	 * @param sObjectNo
	 * @return
	 * �����������������У��:���1��ҵ��Ʒ���Ƿǹ�����2�����������Ǳ��3����������Ǻ�ͬ��Ϣ4����������ǡ�05��;���򷵻�false����ʾ��У�鵣����Ϣ
	 * @throws Exception
	 */
		public boolean changtypecheckout_isnotgjj(Transaction Sqlca, String sMainTable, String sObjectNo)
				throws Exception {
			String sBusinessType = "";
			String sOccurType = "";
			String sChangType = "";
			String sChangeObject = "";
			String sSql = "select businesstype,occurtype,changtype,ChangeObject from "
					+ sMainTable + " where SerialNo = '" + sObjectNo + "'";
			ASResultSet rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) {
				sBusinessType = rs.getString("BusinessType"); // ҵ��Ʒ��
				sOccurType = rs.getString("OccurType"); 	  // ��������
				sChangType = rs.getString("ChangType"); 	  // �������
				sChangeObject = rs.getString("ChangeObject"); // �������
			}
			rs.getStatement().close();
			if (!"1110027".equals(sBusinessType) && "120".equals(sOccurType)&&"05".equals(sChangType)&&"02".equals(sChangeObject)) 
			{
				return false;
			} else
			{
				return true;
			}
		}
	
}
