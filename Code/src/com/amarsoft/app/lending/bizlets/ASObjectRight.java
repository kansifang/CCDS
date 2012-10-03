package com.amarsoft.app.lending.bizlets;
/*
Author: --王业罡 2005-08-11
Tester:
Describe: --权限判断
Input Param:

Output Param:

HistoryLog:
*/


import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.context.ASUser;
import com.amarsoft.biz.bizlet.Bizlet;


public class ASObjectRight extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{
		//获取参数：方法名、对象编号，视图ID，用户编号		
		String sMethodName = (String)this.getAttribute("MethodName");	
		String sObjectType=(String)this.getAttribute("ObjectType");
		String sObjectNo=(String)this.getAttribute("ObjectNo");
		String sViewID=(String)this.getAttribute("ViewID");
		String sUserID=(String)this.getAttribute("UserID");
		
		String sReturn="";
		if(sMethodName.equals("rightOfCustomer"))
			sReturn=rightOfCustomer(Sqlca,sObjectNo,sViewID,sUserID);
		else if(sMethodName.equals("rightOfApply"))
			sReturn=rightOfApply(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		else if(sMethodName.equals("rightOfApprove"))
			sReturn=rightOfApprove(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		else if(sMethodName.equals("rightOfContract"))
			sReturn=rightOfContract(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		else if(sMethodName.equals("rightOfCreditLine"))
			sReturn=rightOfContract(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		else if(sMethodName.equals("rightOfPutOut"))
			sReturn=rightOfPutOut(Sqlca,sObjectType,sObjectNo,sViewID,sUserID);
		else
			sReturn=rightOfViewId(sObjectNo,sViewID,sUserID);
		
		return sReturn;
	}
	
    //  按照ViewID判断,001可编辑，其余只读
	public String rightOfViewId(String pObjectNo, String pViewID, String pUserID) {
		if (pViewID.equals("001"))
			return "All";
		else
			return "ReadOnly";
	}
	
	//客户对象权限判断
    public String rightOfCustomer(Transaction Sqlca,String pObjectNo, String pViewID, String pUserID) throws Exception {
    	String sReturn = "ReadOnly";

		if (pViewID.equals("000"))
		{
			sReturn = "All";
			return sReturn;
		}

		if (!pViewID.equals("001"))
		{
			return sReturn;
		}
		
		ASResultSet rs=null;
		//如果是超级用户，则直接返回所有权限
		rs = Sqlca.getASResultSet("select RoleID from USER_ROLE where RoleID = '000' and UserID = '"+pUserID+"'");
        if (rs.next()) {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
        
        //管户人可以进行数据维护
        String sBelongAttribute1 = ""; //信息查看权
        String sBelongAttribute2 = ""; //信息维护权
        rs = Sqlca.getASResultSet("select BelongAttribute1,BelongAttribute2 from CUSTOMER_BELONG where CustomerID = '"+pObjectNo+"' and UserID = '"+pUserID+"'");
        if (rs.next()) {
        	sBelongAttribute1 = rs.getString("BelongAttribute1");
        	sBelongAttribute2 = rs.getString("BelongAttribute2");
        	//将空值转化为空字符串
        	if(sBelongAttribute1 == null) sBelongAttribute1 = "";
        	if(sBelongAttribute2 == null) sBelongAttribute2 = "";
        	if(sBelongAttribute2.equals("1"))
        		sReturn = "All";
        	else if(sBelongAttribute1.equals("1"))
        		sReturn = "ReadOnly";
        	return sReturn;
        }
        rs.getStatement().close();
        
        return sReturn;
    }

	//申请对象权限判断
	public String rightOfApply(Transaction Sqlca,String pObjectType,String pObjectNo, String pViewID, String pUserID) throws Exception 
	{
        String sReturn = "ReadOnly";
        
		if (pViewID.equals("000"))
		{
			sReturn = "All";
			return sReturn;
		}

		if (!pViewID.equals("001"))
		{
			return sReturn;
		}
        ASResultSet rs = null;

        //如果是超级用户，则直接返回所有权限
        rs = Sqlca.getASResultSet("select RoleID from USER_ROLE where RoleID = '000' and UserID = '"+pUserID+"'");
        if (rs.next()) 
        {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
        //申请登记人可以在申请未提交PhaseNo='0010'或退回补充资料阶段PhaseNo='3000'进行数据维护
        rs = Sqlca.getASResultSet("select ObjectNo from FLOW_OBJECT where ObjectType = '"+pObjectType+"' and ObjectNo = '"+pObjectNo+"' and UserId = '"+pUserID+"' and  (PhaseNo='0010' or PhaseNo='3000')");
        if (rs.next()) 
        {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
        
        return sReturn;
    }
	
	//最终审批意见对象权限判断
	public String rightOfApprove(Transaction Sqlca,String pObjectType,String pObjectNo, String pViewID, String pUserID) throws Exception 
	{
        String sReturn = "ReadOnly";
        
		if (pViewID.equals("000"))
		{
			sReturn = "All";
			return sReturn;
		}

		if (!pViewID.equals("001"))
		{
			return sReturn;
		}
        ASResultSet rs = null;

        //如果是超级用户，则直接返回所有权限
        rs = Sqlca.getASResultSet("select RoleID from USER_ROLE where RoleID = '000' and UserID = '"+pUserID+"'");
        if (rs.next()) 
        {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
        //最终审批意见登记人可以在最终审批意见未提交PhaseNo='0010'或退回补充资料阶段PhaseNo='3000'进行数据维护
        rs = Sqlca.getASResultSet("select ObjectNo from FLOW_OBJECT where ObjectType = '"+pObjectType+"' and ObjectNo = '"+pObjectNo+"' and UserId = '"+pUserID+"' and  (PhaseNo='0010' or PhaseNo='3000')");
        if (rs.next()) 
        {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
        
        return sReturn;
    }
	
	//合同权限判断
	public String rightOfContract(Transaction Sqlca,String pObjectType,String pObjectNo, String pViewID, String pUserID) throws Exception 
	{
        String sReturn = "ReadOnly";

		if (pViewID.equals("000"))
		{
			sReturn = "All";
			return sReturn;
		}
		
		if (!pViewID.equals("001"))
		{
			return sReturn;
		}
		
        ASResultSet rs = null;

        //如果是超级用户，则直接返回所有权限
        rs = Sqlca.getASResultSet("select RoleID from USER_ROLE where RoleID = '000' and UserID = '"+pUserID+"'");
        if (rs.next()) {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
       
        //实例化用户
        ASUser CurUser = new ASUser(pUserID,Sqlca);
        //合同在补登标志为未补等，且当前用户为所辖机构时都可以维护数据
        rs = Sqlca.getASResultSet("select ReinforceFlag from BUSINESS_CONTRACT where SerialNo='"+pObjectNo+"' and ManageOrgID like '"+CurUser.OrgID+"%'");
        if (rs.next()) {
        	String sReinforceFlag = rs.getString("ReinforceFlag");
        	if (sReinforceFlag==null) sReinforceFlag="";
        	if (sReinforceFlag.equals("010")) //补登标志ReinforceFlag（010：未补登；020：已补登）
        	{
        		sReturn = "All";
        		return sReturn;
        	}
        }
        rs.getStatement().close();
        
        //合同为综合授信协议时，如果已经被别的授信项下业务申请占用，也不能进行修改
        String sBusinessType = "";
        rs = Sqlca.getASResultSet("select BusinessType from BUSINESS_CONTRACT where SerialNo='"+pObjectNo+"' ");
        if (rs.next()) {
        	sBusinessType = rs.getString("BusinessType");
        	if(sBusinessType == null) sBusinessType = "";
        }
        rs.getStatement().close();
        
        if(sBusinessType.length() >=1 && sBusinessType.substring(0,1).equals("3")) //额度
        {	
        	rs = Sqlca.getASResultSet("select SerialNo from BUSINESS_APPLY where CreditAggreement = '"+pObjectNo+"'");
        	if (!rs.next())
        	{        		
    			sReturn = "All";
    			return sReturn;        		
        	}
        	rs.getStatement().close();
        }else
        {        
	        //合同管户人、登记人、保全管户人在合同没有提请放贷且合同项下没有借据时可以维护数据
	        rs = Sqlca.getASResultSet("select SerialNo from BUSINESS_CONTRACT where SerialNo='"+pObjectNo+"' and (InputUserID = '"+pUserID+"' or ManageUserID = '"+pUserID+"') and (PigeonholeDate is null or PigeonholeDate='')");
	        if (rs.next()) {        	
	        	rs.getStatement().close();
	        	rs = Sqlca.getASResultSet("select SerialNo from BUSINESS_PUTOUT where ContractSerialNo = '"+pObjectNo+"'");
	        	if (!rs.next())
	        	{
	        		rs.getStatement().close();
	        		rs = Sqlca.getASResultSet("select RelativeSerialNo2  from BUSINESS_DUEBILL where RelativeSerialNo2='"+pObjectNo+"'");
	        		if (!rs.next())
	        		{
	        			sReturn = "All";
	        			return sReturn;
	        		}else
	        		{
	        			rs.getStatement().close();
	        		}
	        	}else
	        	{
	        		rs.getStatement().close();
	        	}
	        }else
	        {
	        	rs.getStatement().close();
	        }
        } 
        return sReturn;
    }
	
	//出帐对象权限判断
	public String rightOfPutOut(Transaction Sqlca,String pObjectType,String pObjectNo,String pViewID, String pUserID) throws Exception 
	{
        String sReturn = "ReadOnly";
        
		if (pViewID.equals("000"))
		{
			sReturn = "All";
			return sReturn;
		}

		if (!pViewID.equals("001"))
		{
			return sReturn;
		}
        ASResultSet rs = null;

        //如果是超级用户，则直接返回所有权限
        rs = Sqlca.getASResultSet("select RoleID from USER_ROLE where RoleID = '000' and UserID = '"+pUserID+"'");
        if (rs.next()) 
        {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
        //出帐登记人可以在出帐未提交PhaseNo='0010'或退回补充资料阶段PhaseNo='3000'进行数据维护
        rs = Sqlca.getASResultSet("select ObjectNo from FLOW_OBJECT where ObjectType = '"+pObjectType+"' and ObjectNo = '"+pObjectNo+"' and UserId = '"+pUserID+"' and  (PhaseNo = '0010' or PhaseNo = '3000')");
        if (rs.next()) 
        {
        	sReturn = "All";
        	return sReturn;
        }
        rs.getStatement().close();
       
        return sReturn;
    }
}
