/*
Author:   wangdw 2012/08/24
Tester:
Describe: 根据合同号获取申请编号
Input Param:
		SerialNo: 流程流水号
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetShenqinghaoByHetonghao extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{	
		String sSerialNo ="";
		String sql1 = "";
		String sql2 = "";
		String sRELATIVESERIALNO = "";
		String sAPPLYTYPE = "";
		String sCREDITAGGREEMENT = "";
		ASResultSet rs1 = null;
		ASResultSet rs2 = null;
		//获取参数
		sSerialNo = (String)this.getAttribute("SerialNo");
		sql1= "select nvl(RELATIVESERIALNO,'') as RELATIVESERIALNO,nvl(APPLYTYPE,'') as APPLYTYPE,nvl(CREDITAGGREEMENT,'') as CREDITAGGREEMENT from BUSINESS_CONTRACT where serialno='"+sSerialNo+"'";
		rs1 = Sqlca.getASResultSet(sql1);
		if(rs1.next())
		{
			sRELATIVESERIALNO = rs1.getString("RELATIVESERIALNO");		//申请编号
			sAPPLYTYPE 		  = rs1.getString("APPLYTYPE");				//申请方式
			sCREDITAGGREEMENT = rs1.getString("CREDITAGGREEMENT");		//使用授信协议号	
		}
		rs1.getStatement().close();
		//如果是额度项下业务
		if("DependentApply".equals(sAPPLYTYPE))
		{
			sql2 = "select RELATIVESERIALNO from BUSINESS_CONTRACT where where serialno=serialno='"+sCREDITAGGREEMENT+"'";
			rs2 = Sqlca.getASResultSet(sql2);
			if(rs2.next())
			{
				sRELATIVESERIALNO = rs2.getString("RELATIVESERIALNO");	//申请编号
			}
		}
		return sRELATIVESERIALNO;
	}
}