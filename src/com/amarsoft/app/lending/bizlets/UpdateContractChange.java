/*
		Author: --wangdw  2012-9-4
		Tester:
		Describe: --流程判断
		Input Param:
				ObjectNo:对象流水号
				BusinessType：对象类型
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import java.text.DecimalFormat;

import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.script.AmarInterpreter;
import com.amarsoft.script.Anything;

 
public class UpdateContractChange extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{

		//获得对象流水号
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		//获得对象类型
		String sObjectType = (String)this.getAttribute("ObjectType");
		//参数类型
		//将空值转化成空字符串
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		//定义变量：Sql语句
		String sSql = "";
		String sSql1 = "";
		String sChangType = "";			//变更类型
		String sPurpose = "";			//用途
		String sOldContractNo = "";		//老合同号
		String sChangeObject = "";		//变更对象
		String sOccurType = "";			//发生类型
		String sFieldValue = "";
		int iFieldType = 0;
		int iColumnCount = 0;
		String sRelativeSerialNo1 = ""; //新的担保合同号
		ASResultSet rs = null;
		ASResultSet rs1 = null;
		//获取发生类型
		sSql = "select nvl(OccurType,'') as OccurType from business_apply where serialno ='"+sObjectNo+"'";
		sOccurType = Sqlca.getString(sSql);
		//获取变更对象
		sSql = "select nvl(ChangeObject,'') as ChangeObject from business_apply where serialno ='"+sObjectNo+"'";
		sChangeObject = Sqlca.getString(sSql);
		//如果发生类型是变更，并且变更对象是“合同”
		if(sOccurType.equals("120") && sChangeObject.equals("02"))
		{
			sSql = "select nvl(changtype,'') as changtype from business_apply where serialno ='"+sObjectNo+"'";
			sChangType = Sqlca.getString(sSql);//变更类型
			sSql = "select nvl(BCH.serialno,'') as serialno from APPLY_RELATIVE AR,BUSINESS_CONTRACT_HISTORY BCH  " +
					"where AR.objecttype = 'ContractChange' and AR.serialno = '"+sObjectNo+"' and AR.objectno = BCH.order";
			sOldContractNo = Sqlca.getString(sSql);
			//如果变更类型是04 变更担保信息
			if(sChangType.equals("04"))
			{
				//1、根据新的申请编号APPLY_RELATIVE（通过objecttype=GuarantyContract）找到新的申请对应的担保合同号。
				//2、根据新的申请编号通过APPLY_RELATIVE（objecttype=ContractChange）找到历史合同表的id
				//3、根据历史合同表id找到原合同号
				//4、把原合同号与新的担保合同号的对应关系插入contract_RELATIVE
				//5、变更之前的担保合同信息由用户手工去置为失效，系统对此不作处理。
				//拷贝新的贷款合同的已签订合同的信息到老的合同中
				//(合同状态：ContractStatus－010：未签合同；020－已签合同；030－已失效)	
				sSql =  " select GC.SerialNo from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from APPLY_RELATIVE AR "+
				" where AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
				" and ContractStatus = '020' ";
				rs = Sqlca.getASResultSet(sSql);
				while(rs.next())
				{
					sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
							" values('"+sOldContractNo+"','GuarantyContract','"+rs.getString("SerialNo")+"') ";
					Sqlca.executeSQL(sSql);
					
					//根据批复阶段担保信息的流水号查找到相应的担保物信息
					sSql =  " select GuarantyID,Status,Type from GUARANTY_RELATIVE "+
							" where ObjectType = '"+sObjectType+"' "+
							" and ObjectNo = '"+sObjectNo+"' "+
							" and ContractNo = '" +rs.getString("SerialNo")+"' ";
					rs1 = Sqlca.getASResultSet(sSql);				
					while(rs1.next())
					{
						sSql =	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
								" values('GuarantyContract','"+sOldContractNo+"','"+rs.getString("SerialNo")+"', "+
								" '"+rs1.getString("GuarantyID")+"','Copy','"+rs1.getString("Status")+"','"+rs1.getString("Type")+"') ";
						Sqlca.executeSQL(sSql);	
					}
					rs1.getStatement().close();
				}
				rs.getStatement().close();
				//复制新的贷款合同的未签订的担保合同信息，生成新的担保合同信息到老的贷款合同中
				sSql =  " select GC.* from GUARANTY_CONTRACT GC where exists (select AR.ObjectNo from APPLY_RELATIVE AR "+
						" where AR.SerialNo = '"+sObjectNo+"' and AR.ObjectType='GuarantyContract' and AR.ObjectNo = GC.SerialNo) "+
						" and GC.ContractStatus = '010' ";
				System.out.println("sSql::::::::::::::::::WWQQ "+sSql); 
				rs = Sqlca.getASResultSet(sSql);
				//获得担保信息总列数
				iColumnCount = rs.getColumnCount(); 
				double index = 0;//计数器 
				String sGCType = "";
				DecimalFormat decimalformat = new DecimalFormat("00");
				while(rs.next())
				{
					//获得担保信息编号
					sRelativeSerialNo1 = DBFunction.getSerialNo("GUARANTY_CONTRACT","SerialNo","GC",Sqlca);
					String sGuarantyType = rs.getString("GuarantyType");
					if(sGuarantyType == null) sGuarantyType = "";
					if(sGuarantyType.equals("050"))//抵押
						sGCType ="2";
					else if(sGuarantyType.equals("060"))//质押
						sGCType ="3";
					else
						sGCType ="1";
					
					index++;
					
					//sRelativeSerialNo1 = sOldContractNo+sGCType+decimalformat.format(index);
					System.out.println("sRelativeSerialNo1:"+sRelativeSerialNo1);
					//插入担保信息
					sSql = " insert into GUARANTY_CONTRACT values('"+sRelativeSerialNo1+"'";
					for(int i=2;i<= iColumnCount;i++)
					{
						sFieldValue = rs.getString(i);
						iFieldType = rs.getColumnType(i);
						if (isNumeric(iFieldType))					
						{
							if (sFieldValue == null) sFieldValue = "0"; 
							sSql=sSql +","+sFieldValue;
						}else {
							if (sFieldValue == null) sFieldValue = "";
							sSql=sSql +",'"+sFieldValue +"'";
						}
					}
					sSql= sSql + ")";
					Sqlca.executeSQL(sSql);
					
					//更改担保合同状态
					//sSql =	" update GUARANTY_CONTRACT set ContractStatus='020' where SerialNo = '"+sRelativeSerialNo1+"' ";
					//Sqlca.executeSQL(sSql);
					
					//将新拷贝的担保信息与合同建立关联
					sSql =	" insert into CONTRACT_RELATIVE(SerialNo,ObjectType,ObjectNo) "+
							" values('"+sOldContractNo+"','GuarantyContract','"+sRelativeSerialNo1+"')";
					Sqlca.executeSQL(sSql);
								
					//根据批复阶段担保信息的流水号查找到相应的担保物信息
					sSql =  " select GuarantyID,Status,Type from GUARANTY_RELATIVE "+
							" where ObjectType = '"+sObjectType+"' "+
							" and ObjectNo = '"+sObjectNo+"' "+
							" and ContractNo = '" +rs.getString("SerialNo")+"' ";
					rs1 = Sqlca.getASResultSet(sSql);				
					while(rs1.next())
					{
						sSql =	" insert into GUARANTY_RELATIVE(ObjectType,ObjectNo,ContractNo,GuarantyID,Channel,Status,Type) "+
								" values('BusinessContract','"+sOldContractNo+"','"+sRelativeSerialNo1+"', "+
								" '"+rs1.getString("GuarantyID")+"','Copy','"+rs1.getString("Status")+"','"+rs1.getString("Type")+"') ";
						Sqlca.executeSQL(sSql);	
					}
					rs1.getStatement().close();
				}
				rs.getStatement().close();
				
				
			}
			//如果变更类型是05 变更用途
			if(sChangType.equals("05"))
			{
				//1、根据新的申请编号找到变更后的用途。
				//2、根据新的申请编号通过APPLY_RELATIVE（objecttype=ContractChange）找到历史合同表的id
				//3、根据历史合同表id找到原合同号
				//4、更新原合同的用途字段。
				sSql ="select nvl(PURPOSE,'') as PURPOSE from business_apply where serialno ='"+sObjectNo+"'";
				sPurpose = Sqlca.getString(sSql);
				sSql = "update BUSINESS_CONTRACT set PURPOSE = '"+sPurpose+"' where serialno = '"+sOldContractNo+"'";
				Sqlca.executeSQL(sSql);
				
			}
		}
		return "123";
	}
	//判断字段类型是否为数字类型
	private boolean isNumeric(int iType) 
	{
		if (iType==java.sql.Types.BIGINT ||iType==java.sql.Types.INTEGER || iType==java.sql.Types.SMALLINT || iType==java.sql.Types.DECIMAL || iType==java.sql.Types.NUMERIC || iType==java.sql.Types.DOUBLE || iType==java.sql.Types.FLOAT ||iType==java.sql.Types.REAL)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
}
