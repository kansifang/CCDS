package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
/**
 * ���ݳ�����ˮ�Ż�ȡ�ñ�ҵ���µĵ���Ѻ����
 * @author wangdw
 * input ������ˮ��
 * out   ����Ѻ�����м��á�@���ָ�
 */
public class GetGuarantyIdByPutOutNo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		// TODO Auto-generated method stub
		String sGUARANTYID = "";
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		ASResultSet rs = null;
		if(sObjectNo==null)sObjectNo="";
		String sSql = "select GUARANTYID from GUARANTY_INFO where GUARANTYID in " +
				"(select GUARANTYID from GUARANTY_RELATIVE where objectno=(select CONTRACTSERIALNO  " +
				"from BUSINESS_PUTOUT where serialno='"+sObjectNo+"') ) and GUARANTYSTATUS <>'02'";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sGUARANTYID +=rs.getString("GUARANTYID")+"@";
		}
		rs.getStatement().close();
		return sGUARANTYID;
	}

}
