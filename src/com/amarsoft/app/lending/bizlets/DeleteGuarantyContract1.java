package com.amarsoft.app.lending.bizlets;
/*
		Author: --xhyong 2011/09/01
		Tester:
		Describe: --删除担保合同;
		Input Param:
				ObjectType: --对象类型(业务阶段)。
				ObjectNo: --对象编号（申请/批复/合同流水号）。
				SerialNo:--担保合同号
		Output Param:
				return：返回值（SUCCEEDED --删除成功）

		HistoryLog:
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.*;

public class DeleteGuarantyContract1 extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sSerialNo = (String)this.getAttribute("SerialNo");

		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sSerialNo == null) sSerialNo = "";
				
		//根据对象类型获得关联表名
		String sRelativeTableName = "";
		String sSql = " select RelativeTable from OBJECTTYPE_CATALOG "+
			          " where ObjectType = '"+sObjectType+"' ";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			sRelativeTableName = DataConvert.toString(rs.getString("RelativeTable"));
		rs.getStatement().close();
		
		//获取申请流水号
		String sRelativeSerialNo = "";
		 sSql = " select RelativeSerialNo from BUSINESS_CONTRACT "+
			          " where SerialNo = '"+sObjectNo+"' ";
		 rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			sRelativeSerialNo = DataConvert.toString(rs.getString("RelativeSerialNo"));
		rs.getStatement().close();
		
		//该担保合同是否已被其他业务使用过
		int iCount = 0;
		sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT "+
				" where SerialNo = '"+sSerialNo+"' "+
				" and ContractType = '020' "+
				" and (ContractStatus = '020' "+
				" or ContractStatus = '030')";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		if(iCount <= 0)//非最高额担保合同
		{					
			//删除担保合同
			sSql =  " delete from GUARANTY_CONTRACT "+
					" where SerialNo = '"+sSerialNo+"' ";
			Sqlca.executeSQL(sSql);
		}
		
		//删除担保合同与抵质押物的关联关系
		sSql =  " delete from GUARANTY_RELATIVE "+
				" where ObjectType = '"+sObjectType+"' "+
				" and ObjectNo = '"+sObjectNo+"' "+
				" and ContractNo = '"+sSerialNo+"' ";
		Sqlca.executeSQL(sSql);
		
		//删除业务与担保合同的关联关系
		sSql =  " delete from "+sRelativeTableName+" "+
				" where SerialNo = '"+sObjectNo+"' "+
				" and ObjectType = 'GuarantyContract' "+
				" and ObjectNo='"+sSerialNo+"' ";
		Sqlca.executeSQL(sSql);
		
		//置原申请担保合同未登记
		sSql =  " update GUARANTY_CONTRACT " +
				"set ApplyGuarantyContract=null " +
				"where ApplyGuarantyContract =  '"+sSerialNo+"'" ;
		Sqlca.executeSQL(sSql);
		
		return "SUCCEEDED";
	}
}
