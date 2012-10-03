/*
Author:   wangdw 2012/08/24
Tester:
Describe: 获取放款中心机构编号
Input Param:
		SerialNo: 申请流水号
Output Param:
HistoryLog:
 */
package com.amarsoft.app.lending.bizlets;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GetLoanOrgID extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception{	
		String sSerialNo ="";
		String sOrgFlag  ="";
		String sOrgID = "";
		String sLoanOrgID = "";
		String sRelativeOrgID = "";
		String sAPPROVEUSERID = "";
		boolean isZhongXiao = false;
		boolean isGeRen = false;
		String zhongXiao = "0N6";
		String geRen = "0B8";
		String sql1 = "";
		String sql2 = "";
		ASResultSet rs1=null;
		ASResultSet rs2=null;
		sSerialNo = (String)this.getAttribute("SerialNo");
		sql1 = "select nvl(OrgFlag,'') as OrgFlag,OrgID from Org_info where OrgID = (select OrgID from FLOW_TASK where " +
				"ObjectType = 'CreditApply' and ObjectNo =  '"+sSerialNo+"'  and PhaseNo='0010')";
		rs1 = Sqlca.getResultSet(sql1);
		if(rs1.next())
		{
			sOrgFlag = rs1.getString("OrgFlag");
			sOrgID   = rs1.getString("OrgID");
		}
		rs1.getStatement().close();
		//判断发起机构是否是直属支行发起业务
		//直属支行发起
		if(sOrgFlag.equals("030"))
		{
			//取得最终审批人id
			sql2 = "select nvl(APPROVEUSERID,'') as APPROVEUSERID from BUSINESS_APPLY where serialno =  '"+sSerialNo+"'";
			rs2 = Sqlca.getResultSet(sql2);
			if(rs2.next())
			{
				sAPPROVEUSERID = rs2.getString("APPROVEUSERID");
			}
			rs2.getStatement().close();
			//判断该业务的最终审批人是否具有中小企业最终审批权
			sql2 = "select * from user_role where userid='"+sAPPROVEUSERID+"' and roleid='"+zhongXiao+"'";
			rs2 = Sqlca.getResultSet(sql2);
			if(rs2.next())
			{
				isZhongXiao = true;
			}
			rs2.getStatement().close();
			//判断该业务的最终审批人是否具有个人业务最终审批权
			sql2 = "select * from user_role where userid='"+sAPPROVEUSERID+"' and roleid='"+geRen+"'";
			rs2 = Sqlca.getResultSet(sql2);
			if(rs2.next())
			{
				isGeRen = true;
			}
			//查询codelibrary
			//取最终审批人的角色
			//判断最终审批人是否有0N6中小企业分部最终审批人--总行中小企业放款中心
			//判断最终审批人是否有0B8个人业务审批分部负责人--总行个人放款中心
			//其他情况是 总行放款中心
			rs2.getStatement().close();
			if(isZhongXiao)
			{
				sql2 = "select itemno from code_library where codeno = 'LoanOrgIDMain' where itemname = '"+zhongXiao+"'";
				rs2 = Sqlca.getResultSet(sql2);
				if(rs2.next())
				{
					sLoanOrgID = rs2.getString("itemno");
				}
			}else if (isGeRen)
			{
				sql2 = "select itemno from code_library where codeno = 'LoanOrgIDMain' where itemname = '"+geRen+"'";
				rs2 = Sqlca.getResultSet(sql2);
				if(rs2.next())
				{
					sLoanOrgID = rs2.getString("itemno");
				}
			}else
			{
				sql2 = "select itemno from code_library where codeno = 'LoanOrgIDMain' where itemname != '"+geRen+"' and itemname != '"+geRen+"'";
				rs2 = Sqlca.getResultSet(sql2);
				if(rs2.next())
				{
					sLoanOrgID = rs2.getString("itemno");
				}
			}
		}else{
			//sLoanOrgID = "中心支行放款中心";
			//取得发起机构的orgflag 如果是010信用社/支行 则取上级机构的放款中心字段
			//取得发起机构的orgflag 如果是020区县联社/040区县联社 则取本机构的放款中心字段
			if(sOrgFlag.equals("010"))
			{
				sql2 = "SELECT RelativeOrgID FROM  ORG_INFO WHERE OrgID ='"+sOrgID+"'";
				rs2 = Sqlca.getResultSet(sql2);
				if(rs2.next())
				{
					sRelativeOrgID = rs2.getString("RelativeOrgID");
				}
				sql2 = "select LoanOrgID  from ORG_INFO where OrgID ='"+sRelativeOrgID+"'";
				rs2 = Sqlca.getResultSet(sql2);
				if(rs2.next())
				{
					sLoanOrgID = rs2.getString("LoanOrgID");
				}
			}else if(sOrgFlag.equals("020")||sOrgFlag.equals("040"))
			{
				sql2 = "select LoanOrgID  from ORG_INFO where OrgID ='"+sOrgID+"'";
				rs2 = Sqlca.getResultSet(sql2);
				if(rs2.next())
				{
					sLoanOrgID = rs2.getString("LoanOrgID");
				}
			}
		}
		rs2.getStatement().close();
		return sLoanOrgID;
	}
}

