package com.amarsoft.app.util;
/**
 * 天津农合合同号生成器
 * 主合同编号规则16位：[机构代码] + [客户类别] + [合同类别] + [年度月份]+[流水号]
 *                     5          1           2           4        4
 *
 * Author：lpzhang 2009-8-26
 */


import java.text.DecimalFormat;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;


public class BCSerialNoGenerator {
	
	//数据库操作变量定义
	private static ASResultSet rs=null;
	private static String sSqlforSerialNo=null;
	
	//程序变量定义
	//数据库表所存当日最大流水号
	private static String sMaxSerialNoFromTable="";
	//程序产生最大流水号
	private static String sMaxSerialNo="";
	//客户类别
	private static String sCustomerBCType="";
	//核心机构号
	private static String sMainFrameOrgID="";
	//核心机构号前五位
	private static String sMainOrgIDStr="";
	//合同编号类型
	private static String sBCType="";
	//当前年月
	private static String sCurrentMonth="";
	//表中年月
	private static String sMonthFromTable="";
	//返回新流水
	private static String sNewGCSerialNo="";
	
	private static final  String sTableName="OBJECT_MAXSN_BC";

	public static String getBCSerialNo(String sBusinessType,String sCustomerType,String sOrgID,Transaction Sqlca) throws Exception
	{
		sBCType = Sqlca.getString("select Attribute14 from Business_Type where TypeNo = '"+sBusinessType+"'");
		if (sBCType == null||sBCType.equals("")) 
			throw new Exception("获取业务品种的合同类型错误，请联系系统管理员！");
		
		sMainFrameOrgID = Sqlca.getString("select MainFrameOrgID from Org_Info where OrgID = '"+sOrgID+"'");
		if (sMainFrameOrgID == null||sMainFrameOrgID.equals("")) 
			throw new Exception("获取机构的核心机构号错误，请联系系统管理员！");
		if(sMainFrameOrgID.length()>=5){
			sMainOrgIDStr = sMainFrameOrgID.substring(0,5);
		}else{
			sMainOrgIDStr = sMainFrameOrgID;
			for(int i=sMainFrameOrgID.length();i<5;i++){
				sMainOrgIDStr = "0"+ sMainOrgIDStr;
			}
		}
		if(sCustomerType.startsWith("03"))// 个人
		{
			sCustomerBCType="3";
		}else if(sCustomerType.equals("0107")){//同业
			sCustomerBCType="2";
		}else{
			sCustomerBCType="1";
		}
		
		boolean bOld = Sqlca.conn.getAutoCommit(); 
		try {
			if(bOld)
				Sqlca.conn.setAutoCommit(false);
			
			//得到当前日期
			String TempDate = StringFunction.getToday();
			sCurrentMonth = TempDate.substring(2,4)+TempDate.substring(5,7);
			DecimalFormat decimalformat = new DecimalFormat("0000");
			
			String sSerialIndex = "" , sUpdateSql = "",sInsertSql="",sBeginSerialNo = "";
			
			sSqlforSerialNo = " select MaxSerialNo from "+sTableName+" where MainFrameOrgID = '"+sMainOrgIDStr+"'" +
							  " and CustomerType = '"+sCustomerBCType+"' and BCType = '"+sBCType+"'  with ur";
			rs = Sqlca.getASResultSet(sSqlforSerialNo);
			if(rs.next())
			{
				sMaxSerialNoFromTable = rs.getString("MaxSerialNo");
				if(sMaxSerialNoFromTable == null) sMaxSerialNoFromTable ="";
				
				sMonthFromTable = sMaxSerialNoFromTable.substring(8,12);//表中最大流水截取的月份
				if(sCurrentMonth.equals(sMonthFromTable))
				{
					sSerialIndex = decimalformat.format(Integer.parseInt(sMaxSerialNoFromTable.substring(sMaxSerialNoFromTable.length()-4,sMaxSerialNoFromTable.length())) + 1);
					sMaxSerialNo = sMaxSerialNoFromTable.substring(0,12)+sSerialIndex;
					
					sUpdateSql = " update "+sTableName+"  set MaxSerialNo ='"+sMaxSerialNo + "'" +
								 " where MainFrameOrgID = '"+sMainOrgIDStr+"'" +
								 " and CustomerType = '"+sCustomerBCType+"' and BCType = '"+sBCType+"'  with ur";
					Sqlca.executeSQL(sUpdateSql);
				}else//换月份
				{
					//合同号前12位固定号
					sBeginSerialNo = sMainOrgIDStr+sCustomerBCType+sBCType+sCurrentMonth;
					
					sMaxSerialNo = sBeginSerialNo+"0001";
					
					sUpdateSql = " update "+sTableName+"  set  MaxSerialNo ='"+sMaxSerialNo+"'" +
								 " where MainFrameOrgID = '"+sMainOrgIDStr+"'" +
								 " and CustomerType = '"+sCustomerBCType+"' and BCType = '"+sBCType+"' with ur";
					Sqlca.executeSQL(sUpdateSql);
				}
				
			}else{
				
				//合同号前12位固定号
				sBeginSerialNo = sMainOrgIDStr+sCustomerBCType+sBCType+sCurrentMonth;
				
				sMaxSerialNo = sBeginSerialNo+"0001";
				
				sInsertSql = " insert into "+sTableName+"(MainFrameOrgID,CustomerType,BCType,MaxSerialNo)" +
							 " values('"+sMainOrgIDStr+"', '"+sCustomerBCType+"', '"+sBCType+"', '"+sMaxSerialNo+"') with ur";
				Sqlca.executeSQL(sInsertSql);
				
			}
			rs.getStatement().close();
			
			Sqlca.conn.commit();
			Sqlca.conn.setAutoCommit(bOld);
			
		}catch(Exception e)
		{
			Sqlca.conn.rollback();
			Sqlca.conn.setAutoCommit(bOld);
			throw new Exception("事务处理失败！"+e.getMessage());
		}		
		
		System.out.println("getBCSerialNo(规则取得新合同号)..." + sMaxSerialNo);

		return sMaxSerialNo;
	}
	

}
