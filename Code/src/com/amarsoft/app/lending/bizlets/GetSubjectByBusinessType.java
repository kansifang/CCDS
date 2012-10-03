/*
Author:   wangdw 2012/08/17
Tester:
Describe: 根据业务品种获取科目号并更新出账表科目字段
Input Param:
		SerialNo: 流程流水号
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetSubjectByBusinessType extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{	
		String sSerialNo ="";
		//获取参数
		sSerialNo = (String)this.getAttribute("SerialNo");
		ASResultSet rs2=null;
		ASResultSet rs3=null;
		String sBusinessType = "";			//业务品种
		String sTermMonth = "";				//期限月
		int iTermMonth = 0;					//期限月
		String sVouchType = "";				//担保方式
		String sTimeLimitType = "";			//期限类型
		String sBankGroupFlag = "";			//银团贷款
		String sSUBJECTNO = "";				//科目号
		String sAGRILOANFLAG = "";			//是否涉农
		String sql2 = "select BusinessType,TermMonth,VouchType from BUSINESS_PUTOUT where serialno='"+sSerialNo+"'";
		String sql3 = "select BC.BankGroupFlag,BC.AGRILOANFLAG from BUSINESS_CONTRACT BC,BUSINESS_PUTOUT BP where " +
				"BP.CONTRACTSERIALNO=BC.serialno and BP.serialno='"+sSerialNo+"'";
		try {
			rs2=Sqlca.getResultSet(sql2);
			rs3=Sqlca.getResultSet(sql3);
			if(rs2.next())
			{
				sBusinessType = rs2.getString("BusinessType")==null?"":rs2.getString("BusinessType");
				sVouchType = rs2.getString("VouchType")==null?"":rs2.getString("VouchType").substring(0, 3);
				sTermMonth = rs2.getString("TermMonth")==null?"":rs2.getString("TermMonth");
				//如果期限类型为空
				if(sTermMonth.equals(null)||sTermMonth.equals(""))
				{
					sTimeLimitType = "";
				}else
				{
					iTermMonth = Integer.parseInt(rs2.getString("TermMonth")==null?"":rs2.getString("TermMonth"));
					//如果期限大于12个月置为中长期
					if(iTermMonth>12)
					{
						sTimeLimitType = "02";//中长期
					}else 
					//如果期限小于等于12个月置为短期	
					{
						sTimeLimitType = "01";//短期
					}
					
				}
			}
			if(rs3.next())
			{
				sBankGroupFlag = rs3.getString("BankGroupFlag")==null?"":rs3.getString("BankGroupFlag");
				//如果该笔贷款是1直接银团或者2间接银团贷款业务则
				//把业务品种置为银团贷款
				if(sBankGroupFlag.equals("1")||sBankGroupFlag.equals("3"))
				{
					//银团贷款
					sBusinessType = "1060";
				}
				//是否涉农 1 是 2 否
				sAGRILOANFLAG = rs3.getString("AGRILOANFLAG")==null?"":rs3.getString("AGRILOANFLAG");
			}
			sql2 = "select SUBJECTNO from BUSINESSTYPE_SUBJECT where BUSINESSTYPE='"+sBusinessType+"' " +
					"and (VOUCHTYPE='"+sVouchType+"' or VOUCHTYPE = '060') and (TIMELIMITTYPE = '"+sTimeLimitType+"' or TIMELIMITTYPE = '09') " +
							"and (isfarmer = '"+sAGRILOANFLAG+"' or isfarmer is null) fetch first 1 rows only";
			rs2=Sqlca.getResultSet(sql2);
			if(rs2.next())
			{
				sSUBJECTNO = rs2.getString("SUBJECTNO")==null?"":rs2.getString("SUBJECTNO");
				Sqlca.executeSQL("update BUSINESS_PUTOUT set subject = "+sSUBJECTNO+" where serialno="+sSerialNo+"");
			}

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		rs2.getStatement().close();
		rs3.getStatement().close();
		return "123";
	}
}

