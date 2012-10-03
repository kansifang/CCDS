/*
		Author: --zywei 2006-08-18
		Tester:
		Describe: 更新抵质押物状态，并保存入库/出库痕迹
		Input Param:
			GuarantyID：抵质押物编号
			GuarantyStatus：抵质押物状态
			UserID：登记人编号	
		Output Param:

		HistoryLog:
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.context.ASUser;
import com.amarsoft.biz.bizlet.Bizlet;


public class InsertGuarantyAudit extends Bizlet 
{
	public Object  run(Transaction Sqlca) throws Exception
	 {
		//自动获得传入的参数值
		String sGuarantyID = (String)this.getAttribute("GuarantyID");
		if(sGuarantyID == null) sGuarantyID = "";
		String sGuarantyStatus = (String)this.getAttribute("GuarantyStatus");
		if(sGuarantyStatus == null) sGuarantyStatus = "";		
		String sInputUser   = (String)this.getAttribute("InputUser");
		if(sInputUser == null) sInputUser = "";
				
		//定义变量
		String sSql = "",sUpdateSql = "",sInsertSql = "",sGuarantyName = "";
		String sCurDate = "",sInputOrg = "",sSerialNo = "",sGuarantyType = "";
		ASResultSet rs = null;
		
		//获取抵质押物信息
		sSql = 	" select GuarantyName,GuarantyType from GUARANTY_INFO "+
				" where GuarantyID='"+sGuarantyID+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sGuarantyName = rs.getString("GuarantyName");
			sGuarantyType = rs.getString("GuarantyType");
			//将空值转化为空字符串
			if(sGuarantyName == null) sGuarantyName = "";
			if(sGuarantyType == null) sGuarantyType = "";
		}
		rs.getStatement().close();
		
		//获取流水号
		sSerialNo = DBFunction.getSerialNo("GUARANTY_AUDIT","SerialNo",Sqlca);
		//获取系统日期
		sCurDate = StringFunction.getToday();
		//获取用户所在机构
		ASUser CurUser = new ASUser(sInputUser,Sqlca);
		sInputOrg = CurUser.OrgID;
		
		//更新抵质押物状态
		sUpdateSql = " update GUARANTY_INFO set GuarantyStatus='"+sGuarantyStatus+"' "+
					 " where GuarantyID ='"+sGuarantyID+"' ";
		Sqlca.executeSQL(sUpdateSql);
		//新增入库/出库痕迹信息
		if(sGuarantyStatus.equals("02")) //入库
			sInsertSql = " insert into GUARANTY_AUDIT(SerialNo,GuarantyID,GuarantyName,GuarantyType, "+
					 	 " GuarantyStatus,HoldDate,InputOrg,InputUser,InputDate,UpdateDate) "+
					 	 " values('"+sSerialNo+"','"+sGuarantyID+"','"+sGuarantyName+"','"+sGuarantyType+"', "+
					 	 " '"+sGuarantyStatus+"','"+sCurDate+"','"+sInputOrg+"','"+sInputUser+"','"+sCurDate+"', "+
					 	 " '"+sCurDate+"') ";
		if(sGuarantyStatus.equals("04")) //出库
			sInsertSql = " insert into GUARANTY_AUDIT(SerialNo,GuarantyID,GuarantyName,GuarantyType, "+
					 	 " GuarantyStatus,LostDate,InputOrg,InputUser,InputDate,UpdateDate) "+
					 	 " values('"+sSerialNo+"','"+sGuarantyID+"','"+sGuarantyName+"','"+sGuarantyType+"', "+
					 	 " '"+sGuarantyStatus+"','"+sCurDate+"','"+sInputOrg+"','"+sInputUser+"','"+sCurDate+"', "+
					 	 " '"+sCurDate+"') ";
		Sqlca.executeSQL(sInsertSql);
		return "1";
	 }

}
