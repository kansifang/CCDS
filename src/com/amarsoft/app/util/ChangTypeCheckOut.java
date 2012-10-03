/**
 * 判断该笔业务的是否需要进行担保的校验
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
 * 公积金组合贷款变更类型校验
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
			sBusinessType = rs.getString("BusinessType"); // 业务品种
			sOccurType = rs.getString("OccurType"); 	  // 发生类型
			sChangType = rs.getString("ChangType"); 	  // 变更类型
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
	 * 其他贷款贷款变更类型校验:如果1、业务品种是非公积金2、发生类型是变更3、变更对象是合同信息4、变更类型是“05用途”则返回false，表示不校验担保信息
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
				sBusinessType = rs.getString("BusinessType"); // 业务品种
				sOccurType = rs.getString("OccurType"); 	  // 发生类型
				sChangType = rs.getString("ChangType"); 	  // 变更类型
				sChangeObject = rs.getString("ChangeObject"); // 变更对象
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
