package com.amarsoft.app.lending.bizlets;
/*
		Author: --xyong 2012/03/05
		Tester:
		Describe: --删除追加担保合同;
		Input Param:
				ObjectType: --对象类型。
				ObjectNo: --对象编号。
				SerialNo:--担保合同号
		Output Param:
				return：返回值（SUCCEEDED --删除成功）

		HistoryLog:
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.*;

public class DeleteAddGuarantyContract extends Bizlet {

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
		
		//该担保合同是否只有一条记录
		int iCount = 0;
		sSql = 	" select count(GC.SerialNo) " +
				" from GUARANTY_CONTRACT GC,CONTRACT_RELATIVE CR " +
				"where GC.SerialNo=CR.ObjectNo " +
				" and CR.ObjectType='GuarantyContract' " +
				" and GC.ContractStatus = '010'  "+
				" and GC.SerialNo = '"+sSerialNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			iCount = rs.getInt(1);
		rs.getStatement().close();
		
		if(iCount == 1)
		{
			//删除与担保合同有关且未入库的抵质押物
			sSql =  " delete from GUARANTY_INFO "+
					" where GuarantyID in "+
					" (select GuarantyID from GUARANTY_RELATIVE "+
					" where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo='"+sObjectNo+"' "+
					" and ContractNo = '"+sSerialNo+"' ) "+
					" and GuarantyStatus = '01' ";
			Sqlca.executeSQL(sSql);
						
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
	
		return "SUCCEEDED";
	}
}
