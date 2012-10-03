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

public class GetClassifyResult extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
	
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
					
		//根据对象类型获得关联表名
		String sRelativeTableName = "";
		String sClassifyLevel = "";
		String sClassifyLevel2 = "";
		String sSql = " select RelativeTable from OBJECTTYPE_CATALOG "+
			          " where ObjectType = '"+sObjectType+"' ";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
			sRelativeTableName = DataConvert.toString(rs.getString("RelativeTable"));
		rs.getStatement().close();
		
		if(sRelativeTableName.equals("CONTRACT_RELATIVE"))
		{    
			sSql = 	" select max(ClassifyResult) as ClassifyLevel,max(BaseClassifyResult)as ClassifyLevel2 " +
				    " from Business_CONTRACT BC " +
				    "where BC.SerialNo in (select RelativeSerialNo2 from Business_DueBill where  SerialNo in (select ObjectNo from Contract_Relative CR where CR.serialno='"+sObjectNo+"' and CR.ObjectType='BusinessDueBill')) ";
		}else if(sRelativeTableName.equals("REFORM_RELATIVE"))
		{
			sSql = 	" select max(ClassifyResult) as ClassifyLevel,max(BaseClassifyResult) as ClassifyLevel2 " +
		            " from Business_CONTRACT BC " +
		            "where BC.SerialNo in (select ObjectNo from Reform_Relative AR where AR.serialno=(select ObjectNo from Contract_Relative CR where CR.SerialNo='"+sObjectNo+"' and CR.ObjectType='CapitalReform') and AR.ObjectType='BusinessContract')";
		} 
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sClassifyLevel = rs.getString("ClassifyLevel");
			sClassifyLevel2 = rs.getString("ClassifyLevel2");
		}
		rs.getStatement().close();
		
		
		return sClassifyLevel +"@"+ sClassifyLevel2;
	}
}
