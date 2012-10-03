/*
		Author: --bqliu 2011-05-27
		Tester:
		Describe: --抵质押信息是否输入完整
		Input Param:
				ObjectType: 对象类型
				ObjectNo: 对象编号
		Output Param:
				Message：提示信息
		HistoryLog:lpzhang 2009-9-1 FOR TJ
*/

package com.amarsoft.app.lending.bizlets;

import com.amarsoft.app.util.ChangTypeCheckOut;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.script.AmarInterpreter;
import com.amarsoft.script.Anything;


public class CheckVouchInfo extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//获取参数：对象类型和对象编号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
				
		
		//定义变量：提示信息、SQL语句
		String sMessage = "",sSql = "";
		//定义变量：主要担保方式、主体表名、关联表名
		String sVouchType = "",sMainTable = "",sRelativeTable = "";
		//定义变量：继续检查标志
		String sContinueCheckFlag = "TRUE";		
		//定义变量: 用于判断在公积金组合贷款变更并且变更类型为变更借款人的时候不判断是否有担保 业务品种、发生类型、变更类型---add by wangdw
		String sBusinessType = "",sOccurType = "",sChangType = "";
		int iNum = 0;
		//
		//定义变量：查询结果集
		ASResultSet rs = null,rs1 = null;			
		
		//根据对象类型获取主体表名
		sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) { 
			sMainTable = rs.getString("ObjectTable");
			sRelativeTable = rs.getString("RelativeTable");
			//将空值转化成空字符串
			if (sMainTable == null) sMainTable = "";
			if (sRelativeTable == null) sRelativeTable = "";
		}
		rs.getStatement().close();
		
		if (!sMainTable.equals("")) {
			//--------------第一步：从相应的对象主体表中获取担保类型---------------
			sSql = 	" select TempSaveFlag,VouchType,getCustomerType(CustomerID) as CustomerType "+
					" from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			while (rs.next()) { 			
				sVouchType = rs.getString("VouchType");
				//将空值转化成空字符串
				if (sVouchType == null) sVouchType = "";
			}
			rs.getStatement().close(); 
		}
		//判断该笔申请是否是1、业务品种为“公积金组合贷款”&&2、发生类型为“变更”&&3、变更类型为“借款人变更”
		//如果符合上述条件不校验担保信息-----------------------------------------add by wangdw
		if(ChangTypeCheckOut.getInstance().changtypecheckout_gjj(Sqlca, sMainTable, sObjectNo))
		{
			//判断判断该笔申请是否是1、业务品种为“非公积金组合贷款”&&2、发生类型为“变更”&&3、变更类型为“非担保变更”
			//如果符合上述条件不校验担保信息-----------------------------------------add by wangdw 2012-06-01
			if(ChangTypeCheckOut.getInstance().changtypecheckout_isnotgjj(Sqlca, sMainTable, sObjectNo))
			{	
			if(sContinueCheckFlag.equals("TRUE"))
			{					
				//--------------第二步：检查担保合同是否全部输入---------------
				if (!sVouchType.equals("005")) {//假如业务基本信息中的主要担保方式为保证、或抵押、或质押，则判断是否输入担保信息
					if(sVouchType.length()>=3) {
						//假如业务基本信息中的主要担保方式为保证,必须输入保证担保信息
						if(sVouchType.substring(0,3).equals("010") && !sVouchType.equals("0105080"))
						{
							//检查担保合同信息中是否存在保证担保
							sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
									" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
									" and GuarantyType like '010%' having count(SerialNo) > 0 ";
							rs = Sqlca.getASResultSet(sSql);
							if(rs.next()) 
								iNum = rs.getInt(1);
							rs.getStatement().close();
							
							if(iNum == 0)
								sMessage  += "在业务中选择的主要担保方式为保证，可没有输入与保证有关的担保信息！请调整主要担保方式或输入保证担保信息！"+"";
						}
						
						//假如业务基本信息中的主要担保方式为抵押,必须输入抵押担保信息
						if(sVouchType.substring(0,3).equals("020"))	{
							//检查担保合同信息中是否存在抵押担保
							sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
									" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
									" and GuarantyType like '050%' having count(SerialNo) > 0 ";
							rs = Sqlca.getASResultSet(sSql);
							if(rs.next()) 
								iNum = rs.getInt(1);
							rs.getStatement().close();
							
							if(iNum == 0){
								sMessage  += "在业务中选择的主要担保方式为抵押，可没有输入与抵押有关的担保信息！请调整主要担保方式或输入抵押担保信息！"+"";
							}
						}
						
						//假如业务基本信息中的主要担保方式为质押,必须输入质押担保信息
						if(sVouchType.substring(0,3).equals("040"))	{
							//检查担保合同信息中是否存在质押担保
							sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
									" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
									" and GuarantyType like '060%' having count(SerialNo) > 0 ";
							rs = Sqlca.getASResultSet(sSql);
							if(rs.next()) 
								iNum = rs.getInt(1);
							rs.getStatement().close();
							System.out.println("iNum=" + iNum);
							if(iNum == 0)								
								sMessage  += "在业务中选择的主要担保方式为质押，可没有输入与质押有关的担保信息！请调整主要担保方式或输入质押担保信息！"+"";
						}
						
						sSql = " select SerialNo,GuarantyType from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from APPLY_RELATIVE where "+
					       " SerialNo= '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and ContractStatus = '010' and GuarantyType like '050%' ";
						rs = Sqlca.getASResultSet(sSql);
						
						while(rs.next()) //循环判断每个抵押合同
						{
							String sGCNo =  rs.getString("SerialNo");  //获得担保合同流水号
							String sSql1 = " select Count(GuarantyID) from GUARANTY_INFO "+
							       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType='"+sObjectType+"'"+
							       " and ObjectNo ='"+sObjectNo+"' and ContractNo = '"+sGCNo+"') "; 
							rs1 = Sqlca.getASResultSet(sSql1);
							if(rs1.next())
							{
								iNum = rs1.getInt(1); 
							}
							rs1.getStatement().close();
							//判断担保合同项下是否有对应的
							if (iNum <= 0)
							{
							    sMessage +="担保合同编号为:"+sGCNo+"的担保合同项下无对应的抵质押信息！";
							}
					     }
					     rs.getStatement().close();
					     
					     sSql = " select SerialNo from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from APPLY_RELATIVE where "+
					       " SerialNo= '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and ContractStatus = '010' and GuarantyType like '060%'";
						rs = Sqlca.getASResultSet(sSql);
						while(rs.next()) //循环判断每个质押合同
						{
							String sGCNo =  rs.getString("SerialNo");  //获得担保合同流水号
							String sSql1 = " select Count(GuarantyID) from GUARANTY_INFO "+
							       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType='"+sObjectType+"'"+
							       " and ObjectNo ='"+sObjectNo+"' and ContractNo = '"+sGCNo+"') "; 
							rs1 = Sqlca.getASResultSet(sSql1);
							if(rs1.next())
							{
								iNum = rs1.getInt(1); 
							}
							rs1.getStatement().close();
							//判断担保合同项下是否有对应的
							if (iNum <= 0)
							{
							    sMessage +="担保合同编号为:"+sGCNo+"的担保合同项下无对应的抵质押信息！";
							}
					     }
					     rs.getStatement().close();
					}else{
						sMessage  += "代码表中定义的主要担保方式编号小于3位（CODE_LIBRARY.VouchType:"+sVouchType+"），申请的某些风险要素不能探测出来，请核对后再重新探测！"+"";
					}
				}
				
			}
		}
		}
		return sMessage;
	 }
	 

}
