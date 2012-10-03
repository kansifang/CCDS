package com.amarsoft.app.lending.bizlets;
/*
		Author: --xyong 2012/03/29
		Tester:
		Describe: --根据发生类型判断是否走营销行长
		Input Param:
				ObjectNo:--申请流水号
		Output Param:
				return：返回值（TRUE --删除成功,FALSE）

		HistoryLog:
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.*;

public class GoVenditionPresident extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectNo = (String)this.getAttribute("ObjectNo");
	
		//将空值转化成空字符串
		if(sObjectNo == null) sObjectNo = "";
		
		String sSql = "";
		ASResultSet rs = null;
		//定义变量:
		String sRelativeSerialNo = "";//关联申请流水号
		String sMainOccurType = "";//主业务担保方式
		String sMessage = "FALSE";//返回值
		
		 sSql = " select OccurType from BUSINESS_APPLY "+
			          " where SerialNo = '"+sObjectNo+"' ";
		 rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sMainOccurType = rs.getString("OccurType");
		}
		rs.getStatement().close();
		
		//如果是复审业务取关联业务的发生类型作为判断
		if("090".equals(sMainOccurType))
		{
			 sSql = " select ObjectNo from APPLY_RELATIVE "+
	          " where SerialNo = '"+sObjectNo+"' and ObjectType='BusinessReApply'  ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sRelativeSerialNo = rs.getString("ObjectNo");
				if(sRelativeSerialNo==null) sRelativeSerialNo="";
			}
			rs.getStatement().close();
			if(!"".equals(sRelativeSerialNo)){
				 sSql = " select OccurType from BUSINESS_APPLY "+
		          " where SerialNo = '"+sRelativeSerialNo+"' ";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{
					sMainOccurType = rs.getString("OccurType");
				}
				rs.getStatement().close();
			}
		}
		//发生类型为:新发生/资产重组/新增（续作）需走营销行长流程
		if("010".equals(sMainOccurType)||"065".equals(sMainOccurType)||"030".equals(sMainOccurType))
		{
			sMessage="TRUE";
		}
		
		
		return sMessage;
	}
}
