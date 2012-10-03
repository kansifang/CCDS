package com.amarsoft.app.lending.bizlets;
/*
		Author: --wangdw 2012/07/25
		Tester:
		Describe: --根据合同号判断该笔业务的申请信息的最终审批人是否有0N6中小企业审批分部负责人权限
		Input Param:
				CONTRACTNO:--申请流水号
		Output Param:
				return：返回值（TRUE --是中小企业最终审批,FALSE--非中小企业最终审批）

		HistoryLog:
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.*;

public class IsZhongXiaoZuiZhong extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sSql = "";
		ASResultSet rs = null;
		String sObjectNo = "";
		String sCONTRACTNO = "";
		String sReturn = "";
		String sAPPROVEUSERID = "";  //最终审批人id
		String sAPPLYTYPE = "";		 //申请方式
		String sCREDITAGGREEMENT = "";//使用授信协议号
		sObjectNo = (String)this.getAttribute("ObjectNo");

        sSql = "select CONTRACTNO from Guaranty_Apply where SERIALNO = '"+sObjectNo+"'";
        rs = Sqlca.getASResultSet(sSql);
        if(rs.next())
        {
        	sCONTRACTNO = rs.getString("CONTRACTNO");
        }
        //rs.getStatement().close();
        
		sSql = "select  nvl(BA.APPROVEUSERID,'') as APPROVEUSERID,nvl(BA.CREDITAGGREEMENT,'') as CREDITAGGREEMENT,nvl(BC.APPLYTYPE,'') as APPLYTYPE from business_apply BA,BUSINESS_CONTRACT BC where BC.RELATIVESERIALNO=BA.serialno " +
				"and BC.serialno='"+sCONTRACTNO+"'";
		 rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sAPPROVEUSERID    = rs.getString("APPROVEUSERID");
			sAPPLYTYPE 		  = rs.getString("APPLYTYPE");
			sCREDITAGGREEMENT = rs.getString("CREDITAGGREEMENT");
		}
		//如果该笔贷款合同是额度项下的业务，则取该笔额度的最终审批人
		if("DependentApply".equals(sAPPLYTYPE))
		{
			sSql = "select  nvl(BA.APPROVEUSERID,'') from business_apply BA,BUSINESS_CONTRACT BC where BC.RELATIVESERIALNO=BA.serialno " +
			"and BC.serialno='"+sCREDITAGGREEMENT+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sAPPROVEUSERID = rs.getString("APPROVEUSERID");
			}
		}
		sSql = "select * from user_role where userid='"+sAPPROVEUSERID+"' and roleid='0N6'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sReturn = "TRUE";
		}else
		{
			sReturn = "FALSE";
		}
		rs.getStatement().close();
		return sReturn;
	}
}
