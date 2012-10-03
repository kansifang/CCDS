package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.context.ASUser;

public class AddCLContractInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		//合同流水号
		String sBCSerialNo = (String)this.getAttribute("BCSerialNo");	
		//客户编号
		String sCustomerID = (String)this.getAttribute("CustomerID");
		//客户名称
		String sCustomerName = (String)this.getAttribute("CustomerName");
		//授信金额
		String sLineSum1 = (String)this.getAttribute("LineSum1");
		//币种
		String sCurrency = (String)this.getAttribute("Currency");
		//起始日
		String sPutOutDate = (String)this.getAttribute("PutOutDate");
		//到期日
		String sMaturity = (String)this.getAttribute("Maturity");
		//额度使用最迟日期
		String sLimitationTerm = (String)this.getAttribute("LimitationTerm");
		//额度项下业务最迟到期日期
		String sUseTerm = (String)this.getAttribute("UseTerm");
		//额度生效日
		String sBeginDate = (String)this.getAttribute("BeginDate");
		//登记人
		String sInputUser = (String)this.getAttribute("InputUser");
		
		//将空值转化为空字符串
		if(sBCSerialNo == null) sBCSerialNo = "";		
		if(sCustomerID == null) sCustomerID = "";
		if(sCustomerName == null) sCustomerName = "";
		if(sLineSum1 == null) sLineSum1 = "";
		if(sCurrency == null) sCurrency = "";
		if(sPutOutDate == null) sPutOutDate = "";
		if(sMaturity == null) sMaturity = "";
		if(sLimitationTerm == null) sLimitationTerm = "";
		if(sUseTerm == null) sUseTerm = "";
		if(sBeginDate == null) sBeginDate = "";
		if(sInputUser == null) sInputUser = "";
		//业务品种
		String sBusinessType=Sqlca.getString("select BusinessType from Business_Contract where SerialNo='"+sBCSerialNo+"'");
		if(sBusinessType==null)sBusinessType="";
		//获得当前时间
	    String sCurDate = StringFunction.getToday();
	    //获取用户实例
	    ASUser CurUser = new ASUser(sInputUser,Sqlca);
	    
	    String sSql = "";
	    int iCount = 0;
	    ASResultSet rs = null;
	    
	   	sSql =  " select Count(SerialNo) from BUSINESS_CONTRACT where SerialNo = '"+sBCSerialNo+"' ";
	    rs = Sqlca.getASResultSet(sSql);		
		if(rs.next()) iCount = rs.getInt(1);
		rs.getStatement().close();
		if(iCount > 0 )
		{
			sSql = 	" update BUSINESS_CONTRACT set CustomerID = '"+sCustomerID+"', "+
					" CustomerName = '"+sCustomerName+"',BusinessSum = "+sLineSum1+", "+
					" BusinessCurrency = '"+sCurrency+"',PutOutDate = '"+sPutOutDate+"', "+
					" Maturity = '"+sMaturity+"',LimitationTerm = '"+sLimitationTerm+"', "+
					" UseTerm = '"+sUseTerm+"',BeginDate = '"+sBeginDate+"',BusinessType = '"+sBusinessType+"', "+
					" ManageOrgID = '"+CurUser.OrgID+"',ManageUserID = '"+CurUser.UserID+"', "+
					" OperateOrgID = '"+CurUser.OrgID+"',OperateUserID = '"+CurUser.UserID+"', "+
					" InputOrgID = '"+CurUser.OrgID+"',InputUserID = '"+CurUser.UserID+"', "+
					" OperateDate = '"+sCurDate+"',InputDate = '"+sCurDate+"',UpdateDate =  '"+sCurDate+"' "+
					" where SerialNo = '"+sBCSerialNo+"' ";
		}else
		{
			sSql = 	" insert into BUSINESS_CONTRACT(SerialNo,CustomerID,CustomerName,BusinessSum, "+
					" BusinessCurrency,PutOutDate,Maturity,LimitationTerm,UseTerm,BeginDate,BusinessType,ManageOrgID,ManageUserID,OperateOrgID, "+
					" OperateUserID,InputOrgID,InputUserID,OperateDate,InputDate,UpdateDate) "+
					" values('"+sBCSerialNo+"','"+sCustomerID+"','"+sCustomerName+"', "+
					" "+sLineSum1+",'"+sCurrency+"','"+sPutOutDate+"','"+sMaturity+"', "+
					" '"+sLimitationTerm+"','"+sUseTerm+"','"+sBeginDate+"','"+sBusinessType+"','"+CurUser.OrgID+"', "+
					" '"+CurUser.UserID+"','"+CurUser.OrgID+"','"+CurUser.UserID+"','"+CurUser.OrgID+"', "+
					" '"+CurUser.UserID+"','"+sCurDate+"','"+sCurDate+"','"+sCurDate+"')";
		}
		
		Sqlca.executeSQL(sSql);
		
		return "1";			
	}	
}
