package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.DBFunction;

public class AddGroupInfo extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//自动获得传入的参数值	   
		String sCustomerID = (String)this.getAttribute("CustomerID");
		String sRelativeID = (String)this.getAttribute("RelativeID");
		String sUserID  = (String)this.getAttribute("UserID");
		//将空值转化为空字符串
		if(sCustomerID == null) sCustomerID = "";
		if(sRelativeID == null) sRelativeID = "";		
		if(sUserID == null) sUserID = "";
		
		//定义变量
		ASResultSet rs = null;//查询结果集
		String sSql = "";//Sql语句
		String sCustomerType = "";//客户类型
		String sGroupFlag = "";//集团标志
		String sCustomerName = "";//客户名称
		String sCertType = "";//证件类型
		String sCertID = "";//证件编号
				
		//实例化用户对象
		ASUser CurUser = new ASUser(sUserID,Sqlca);
		
		//根据集团客户代码获取集团客户类型
		sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"'");
		if(sCustomerType == null) sCustomerType = "";
		
		//根据集团成员代码获取集团成员名称、证件类型、证件编号
		sSql = 	" select CustomerName,CertType,CertID "+
				" from CUSTOMER_INFO "+
				" where CustomerID = '"+sRelativeID+"' ";
		rs = Sqlca.getASResultSet(sSql);	
		if (rs.next()) 
		{					
			sCustomerName = rs.getString("CustomerName");	
			sCertType = rs.getString("CertType");
			sCertID = rs.getString("CertID");
			if(sCustomerName == null) sCustomerName = "";
			if(sCertType == null) sCertType = "";
			if(sCertID == null) sCertID = "";
		}
		rs.getStatement().close();
		
		//更新集团成员的所属集团
		sSql =  " update CUSTOMER_INFO set BelongGroupID = '"+sCustomerID+"' "+
				" where CustomerID = '"+sRelativeID+"' ";
		Sqlca.executeSQL(sSql);
			
		//更新集团成员的集团标志	
		if(sCustomerType.equals("0201")) sGroupFlag = "1";
		if(sCustomerType.equals("0202")) sGroupFlag = "2";
		sSql = 	" update ENT_INFO set GroupFlag = '"+sGroupFlag+"' "+
				" where CustomerID = '"+sRelativeID+"' ";
		Sqlca.executeSQL(sSql);
		
		//新增集团成员变更记录
		//变更流水号，集团代码，客户代码，变动类型，原客户名称，变动日期，操作机构，操作人员，客户名称，组织机构代码
		//变动标志：010：新增；020：删除；030：更名； 040：二类转一类；050：一类转二类
		String sSerialNo = DBFunction.getSerialNo("GROUP_CHANGE","SerialNo",Sqlca);
		if(sCertType.equals("Ent01"))//只有证件类型为组织机构代码证时，才记录组织机构代码
		{
			sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
				   " values('"+sSerialNo+"','"+sCustomerID+"','"+sRelativeID+"','010','"+sCustomerName+"','"+StringFunction.getToday()+"','"+CurUser.OrgID+"', "+
				   " '"+CurUser.UserID+"','"+sCustomerName+"','"+sCertID+"')";
		}else
		{
			sSql = " insert into GROUP_CHANGE(SerialNo,GroupNo,CustomerID,ChangeType,OldName,UpdateDate,UpdateOrgid,UpdateUserid,CustomerName,Corp)"+
				   " values('"+sSerialNo+"','"+sCustomerID+"','"+sRelativeID+"','010','"+sCustomerName+"','"+StringFunction.getToday()+"','"+CurUser.OrgID+"', "+
				   " '"+CurUser.UserID+"','"+sCustomerName+"','')";
		}
		Sqlca.executeSQL(sSql);				
				
		return "1";
	}		
}
