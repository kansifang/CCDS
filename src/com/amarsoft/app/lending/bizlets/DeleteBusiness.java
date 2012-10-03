package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class DeleteBusiness extends Bizlet 
{
	private String sObjectTable = "";
	private String sRelativeTable = ""; 
	private String sRelativeNo = ""; 
	public Object  run(Transaction Sqlca) throws Exception
	{		

		//自动获得传入的参数值		
		String sObjectType   = (String)this.getAttribute("ObjectType");
		String sObjectNo   = (String)this.getAttribute("ObjectNo");
		String sDeleteType = (String)this.getAttribute("DeleteType");


		//将空值转化成空字符串		
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sDeleteType == null) sDeleteType = "";


		//删除任务
		if(sDeleteType.equals("DeleteTask"))
		{
			//删除申请和最终审批意见任务
			if(sObjectType.equals("CreditApply") || sObjectType.equals("ApproveApply"))
			{
				//获取关联表
				getRelativeTable(sObjectType,Sqlca);
				//删除重组方案
				deleteNPAReformApply("CapitalReform",sObjectNo,Sqlca);
				//删除工程机械协议
				deleteAgreement("ProjectAgreement",sObjectNo,Sqlca);
				//删除共同申请人
				deleteTableData("Business_Applicant",sObjectType,sObjectNo,Sqlca);
				//删除业务调查报告
				deleteTableData("Business_Report",sObjectType,sObjectNo,Sqlca);
				//删除票据信息
				deleteTableData("Bill_Info",sObjectType,sObjectNo,Sqlca);
				//信用证信息
				deleteTableData("LC_Info",sObjectType,sObjectNo,Sqlca);
				//删除贸易合同信息
				deleteTableData("Contract_Info",sObjectType,sObjectNo,Sqlca);
				//删除增值税发票信息
				deleteTableData("Invoice_Info",sObjectType,sObjectNo,Sqlca);
				//删除其它提供贷款人信息
				deleteTableData("Business_Provider",sObjectType,sObjectNo,Sqlca);
				//删除保函信息
				deleteTableData("LG_Info",sObjectType,sObjectNo,Sqlca);
				//删除中介信息
				deleteAgencyInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//删除提单信息
				deleteTableData("Bol_Info",sObjectType,sObjectNo,Sqlca);
				//删除房屋买卖装修信息
				deleteTableData("Building_Deal",sObjectType,sObjectNo,Sqlca);
				//删除汽车信息
				deleteTableData("Vehicle_Info",sObjectType,sObjectNo,Sqlca);
				//删除消费信息
				deleteTableData("Consume_Info",sObjectType,sObjectNo,Sqlca);
				//删除设备信息
				deleteTableData("Equipment_Info",sObjectType,sObjectNo,Sqlca);
				//删除留助学信息
				deleteTableData("Study_Info",sObjectType,sObjectNo,Sqlca);
				//删除开发商楼盘信息
				deleteTableData("Building_Info",sObjectType,sObjectNo,Sqlca);
				//删除担保物信息
				deleteGuarantyInfo(sObjectType,sObjectNo,Sqlca);
				//删除担保物与业务关联关系
				deleteTableData("Guaranty_Relative",sObjectType,sObjectNo,Sqlca);
				//删除担保合同信息
				deleteGuarantyContract(this.sRelativeTable,sObjectNo,Sqlca);
				//删除风险度评估明细信息
				deleteTableData("Evaluate_Data",sObjectType,sObjectNo,Sqlca);
				//删除风险度评估信息
				deleteTableData("Evaluate_Record",sObjectType,sObjectNo,Sqlca);
				//删除格式化调查报告信息
				deleteTableData("FormatDoc_Data",sObjectType,sObjectNo,Sqlca);
				//删除购房信息
				deleteHouseInfo("HouseInfo",sObjectNo,Sqlca);
				//删除文档信息
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);	
				//删除项目信息
				deleteTableData("Project_Relative",sObjectType,sObjectNo,Sqlca);
				//删除授信方案明细信息
				deleteCLInfo(sObjectType,sObjectNo,Sqlca);				
				//删除历史记录信息表
				deleteHistoryInfo("ContractChange",sObjectNo,Sqlca);
				//删除关联信息
				deleteRelativeInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//删除主体对象信息
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
				//删除流程对象信息				
				deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
				//删除流程任务信息
				deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);
				//删除风险度
				deleteTableData("Risk_Evaluate",sObjectType,sObjectNo,Sqlca);
			}

			//删除放贷任务
			if(sObjectType.equals("PutOutApply"))
			{
				//获取关联表
				getRelativeTable(sObjectType,Sqlca);
				//删除主体对象信息
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
				//删除流程对象信息				
				deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
				//删除流程任务信息
				deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);
			}
			
			//删除数据修改任务
			if(sObjectType.equals("DataModApply"))
			{
				//获取关联表
				getRelativeTable(sObjectType,Sqlca);
				//删除主体对象信息
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
				//删除流程对象信息				
				deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
				//删除流程任务信息
				deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);
			}

		
		}

		if(sDeleteType.equals("DeleteBusiness"))
		{					
			//删除合同信息
			if(sObjectType.equals("BusinessContract"))
			{
				//获取关联表
				getRelativeTable(sObjectType,Sqlca);
				//如果是申请信息变更的话删除原申请的归档标志 add by wangdw
				deletePigeonholeDateInfo(sObjectType,sObjectNo,Sqlca);
				//删除共同申请人
				deleteTableData("Business_Applicant",sObjectType,sObjectNo,Sqlca);
				//删除业务调查报告
				deleteTableData("Business_Report",sObjectType,sObjectNo,Sqlca);
				//删除票据信息
				deleteTableData("Bill_Info",sObjectType,sObjectNo,Sqlca);
				//信用证信息
				deleteTableData("LC_Info",sObjectType,sObjectNo,Sqlca);
				//删除贸易合同信息
				deleteTableData("Contract_Info",sObjectType,sObjectNo,Sqlca);
				//删除增值税发票信息
				deleteTableData("Invoice_Info",sObjectType,sObjectNo,Sqlca);
				//删除其它提供贷款人信息
				deleteTableData("Business_Provider",sObjectType,sObjectNo,Sqlca);
				//删除保函信息
				deleteTableData("LG_Info",sObjectType,sObjectNo,Sqlca);
				//删除中介信息
				deleteAgencyInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//删除提单信息
				deleteTableData("Bol_Info",sObjectType,sObjectNo,Sqlca);
				//删除房屋买卖装修信息
				deleteTableData("Building_Deal",sObjectType,sObjectNo,Sqlca);
				//删除汽车信息
				deleteTableData("Vehicle_Info",sObjectType,sObjectNo,Sqlca);
				//删除消费信息
				deleteTableData("Consume_Info",sObjectType,sObjectNo,Sqlca);
				//删除设备信息
				deleteTableData("Equipment_Info",sObjectType,sObjectNo,Sqlca);
				//删除留助学信息
				deleteTableData("Study_Info",sObjectType,sObjectNo,Sqlca);
				//删除开发商楼盘信息
				deleteTableData("Building_Info",sObjectType,sObjectNo,Sqlca);
				//删除担保物信息
				deleteGuarantyInfo(sObjectType,sObjectNo,Sqlca);
				//删除担保物与业务关联关系
				deleteTableData("Guaranty_Relative",sObjectType,sObjectNo,Sqlca);
				//删除担保合同信息
				deleteGuarantyContract(this.sRelativeTable,sObjectNo,Sqlca);
				//删除风险度评估明细信息
				deleteTableData("Evaluate_Data",sObjectType,sObjectNo,Sqlca);
				//删除风险度评估信息
				deleteTableData("Evaluate_Record",sObjectType,sObjectNo,Sqlca);
				//删除格式化调查报告信息
				deleteTableData("FormatDoc_Data",sObjectType,sObjectNo,Sqlca);
				//删除文档信息
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);				
				//删除项目信息
				deleteTableData("Project_Relative",sObjectType,sObjectNo,Sqlca);
				//删除授信方案明细信息
				deleteCLInfo(sObjectType,sObjectNo,Sqlca);				
				//删除关联信息
				deleteRelativeInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//删除主体对象信息
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
			}

			//删除重组方案信息
			if(sObjectType.equals("NPAReformApply"))	
			{
				//获取关联表
				getRelativeTable(sObjectType,Sqlca);
				//删除关联信息
				deleteRelativeInfo(this.sRelativeTable,sObjectNo,Sqlca);
				//删除主体对象信息
				deleteObjectInfo(this.sObjectTable,sObjectNo,Sqlca);
			}
			//add by fhuang 2006.11.29 删除法律事务的关联信息
			if(sObjectType.equals("LawcaseInfo"))
			{
				//删除关联合同的关联关系
				deleteRelativeInfo("LAWCASE_RELATIVE",sObjectNo,Sqlca);
				//删除案件当事人、案件受理人员、代理人信息
				deleteTableData("Lawcase_Persons",sObjectType,sObjectNo,Sqlca);
				//删除案件相关文档
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);
				//删除台帐信息
				deleteTableData("Lawcase_Book",sObjectType,sObjectNo,Sqlca);
				//删除庭审记录
				deleteTableData("Lawcase_Cognizance",sObjectType,sObjectNo,Sqlca);
				//删除费用台帐
				deleteTableData("Cost_Info",sObjectType,sObjectNo,Sqlca);
				//删除查封资产台帐
				deleteTableData("Asset_Info",sObjectType,sObjectNo,Sqlca);

			}
			//add by fhuang 2006.11.30 删除抵债资产的关联信息
			if(sObjectType.equals("AssetInfo"))
			{
				//删除关联合同的关联关系				
				deleteAssetContract(sObjectNo,Sqlca);
				//删除相关保险信息
				deleteTableData("Insurance_Info",sObjectType,sObjectNo,Sqlca);
				//删除价值评估记录
				deleteTableData("Evaluate_Info",sObjectType,sObjectNo,Sqlca);
				//删除价值变动记录
				deleteTableData("OtherChange_Info",sObjectType,sObjectNo,Sqlca);
				//删除案件相关文档
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);				
			}
		}
		return "1";
	}

	//获取关联表名
	private void getRelativeTable(String sObjectType,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";	 
		ASResultSet rs = null;
		//根据sObjectType的不同，得到不同的关联表名
		sSql = "select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType='"+sObjectType+"'";	 
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			this.sObjectTable = rs.getString("ObjectTable");
			this.sRelativeTable = rs.getString("RelativeTable");
		}
		rs.getStatement().close();	 	 
	}

//	删除中介信息
	private void deleteAgencyInfo(String sRelativeTable,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";
		sSql = " delete from AGENCY_INFO where SerialNo in (select ObjectNo from "+
		" "+sRelativeTable+" where SerialNo = '"+sObjectNo+"' and ObjectType "+
		" = 'AgencyInfo') ";
		//执行删除语句
		Sqlca.executeSQL(sSql);	 
	}

//	删除担保物信息(未入库)
	private void deleteGuarantyInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";

		sSql = " delete from GUARANTY_INFO where GuarantyID in (select GuarantyID "+
		" from GUARANTY_RELATIVE where ObjectType = '"+sObjectType+"' "+
		" and ObjectNo = '"+sObjectNo+"' and Channel = 'New') "+
		" and GuarantyStatus = '01' ";	 
		//执行删除语句
		Sqlca.executeSQL(sSql);	 
	}
//	删除担保信息
	private void deleteGuarantyContract(String sRelativeTable,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";

		sSql = " delete from GUARANTY_CONTRACT "+
		" where SerialNo in (select ObjectNo "+
		" from "+sRelativeTable+" "+
		" where ObjectType = 'GuarantyContract' "+
		" and SerialNo = '"+sObjectNo+"' ) "+
		" and (ContractStatus = '010' or ContractType <> '020')";
		//执行删除语句
		Sqlca.executeSQL(sSql);	 
	}

//	删除文档信息
	private void deleteDocInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";
		//删除文档的附件
		sSql = " delete from DOC_ATTACHMENT  where DocNo in (select DocNo "+
		" from DOC_RELATIVE where ObjectType = '"+sObjectType+"' "+
		" and ObjectNo = '"+sObjectNo+"') ";
		//执行删除语句
		Sqlca.executeSQL(sSql);
		//删除文档详情
		sSql=  " delete from DOC_LIBRARY where DocNo in (select DocNo "+
		" from DOC_RELATIVE where ObjectType = '"+sObjectType+"' "+
		" and ObjectNo = '"+sObjectNo+"') ";
		//执行删除语句
		Sqlca.executeSQL(sSql);
		//删除文档与业务的关联关系
		sSql= 	" delete from DOC_RELATIVE where ObjectType = '"+sObjectType+"' "+
		" and ObjectNo = '"+sObjectNo+"'";	
		//执行删除语句
		Sqlca.executeSQL(sSql);	 
	}
//	删除授信方案明细信息
	private void deleteCLInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";
		//根据对象类型进行删除操作处理
		if(sObjectType.equals("CreditApply"))
		{
			sSql = " select LineID from CL_INFO where ApplySerialNo = '"+sObjectNo+"' ";
			String sLineID = Sqlca.getString(sSql);
			sSql = " delete from CL_LIMITATION_SET where LineID = '"+sLineID+"' ";
			//执行删除语句
			Sqlca.executeSQL(sSql);
			sSql = " delete from CL_LIMITATION where LineID = '"+sLineID+"' ";
			//执行删除语句
			Sqlca.executeSQL(sSql);
			sSql = " delete from CL_INFO where LineID = '"+sLineID+"' ";
			//执行删除语句
			Sqlca.executeSQL(sSql);
			sSql = " delete from CL_INFO where ParentLineID = '"+sLineID+"' ";
			//执行删除语句
			Sqlca.executeSQL(sSql);
		}else
		{
			//在最终审批意见中录入的授信方案明细没有删除
			if(sObjectType.equals("ApproveApply"))
				sSql = " update CL_INFO set ApproveSerialNo = null "+
				" where ApproveSerialNo = '"+sObjectNo+"' ";
			//在合同中录入的授信方案明细没有删除
			if(sObjectType.equals("BusinessContract"))
				sSql = " update CL_INFO set BCSerialNo = null,LineContractNo = null "+
				" where BCSerialNo = '"+sObjectNo+"' ";

			//执行删除语句
			Sqlca.executeSQL(sSql);	 
		}
	}

//	删除关联信息
	private void deleteRelativeInfo(String sRelativeTable,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";

		sSql = " delete from "+sRelativeTable+" where SerialNo = '"+sObjectNo+"' ";
		//执行删除语句
		Sqlca.executeSQL(sSql);	 
	}

//	删除主体对象信息
	private void deleteObjectInfo(String sObjectTable,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";

		sSql = " delete from "+sObjectTable+" where SerialNo = '"+sObjectNo+"' ";
		//执行删除语句
		Sqlca.executeSQL(sSql);	 
	}
//	删除关联合同的关联关系	
	private void deleteAssetContract(String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";
		sSql = " delete from Asset_Contract where SerialNo = '"+sObjectNo+"' ";
		//执行删除语句
		Sqlca.executeSQL(sSql);	 
	} 
	//删除有ObjectType,ObjectNo作为外键的表
	private void deleteTableData(String sTableName,String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";
		sSql = " delete from "+sTableName+" where ObjectType = '"+sObjectType+"' "+
		" and ObjectNo = '"+sObjectNo+"' ";
		//执行删除语句
		Sqlca.executeSQL(sSql); 
	}
	//删除工程机械按揭协议
	private void deleteAgreement(String AgreementType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		sRelativeNo = Sqlca.getString("select ObjectNo from Apply_Relative where ObjectType='"+AgreementType+"' and SerialNo = '"+sObjectNo+"'");	 
		if(sRelativeNo == null) sRelativeNo = "";
		
		//删除工程机械按揭主协议
		Sqlca.executeSQL("delete from Ent_Agreement where SerialNo = '"+sRelativeNo+"' and AgreementType = '"+AgreementType+"'");
		//删除工程机械按揭从协议
		Sqlca.executeSQL("delete from Dealer_Agreement where ObjectNo = '"+sRelativeNo+"'");
	}
	//删除重组方案
	private void deleteNPAReformApply(String AgreementType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		sRelativeNo = Sqlca.getString("select ObjectNo from Apply_Relative where ObjectType='"+AgreementType+"' and SerialNo = '"+sObjectNo+"'");	 
		if(sRelativeNo == null) sRelativeNo = "";
		/* 不初始化，这样会覆盖正常使用参数，直接指向REFORM_INFO add by zrli 20100523
		
		//获取关联表
		getRelativeTable("NPAReformApply",Sqlca);
		*/
		//删除关联信息
		deleteRelativeInfo("REFORM_RELATIVE",sRelativeNo,Sqlca);
		//删除主体对象信息
		deleteObjectInfo("REFORM_INFO",sRelativeNo,Sqlca);
	}
	
	//删除购房信息
	private void deleteHouseInfo(String ObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		sRelativeNo = Sqlca.getString("select ObjectNo from Apply_Relative where ObjectType='"+ObjectType+"' and SerialNo = '"+sObjectNo+"'");	 
		if(sRelativeNo == null) sRelativeNo = "";
		//删除关联信息
		deleteRelativeInfo("APPLY_RELATIVE",sRelativeNo,Sqlca);
		//删除主体对象信息
		deleteObjectInfo("HOUSE_INFO",sRelativeNo,Sqlca);
	}
	//删除历史记录信息表
	private void deleteHistoryInfo(String ObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		//获取关联合同历史信息表的order
		sRelativeNo = Sqlca.getString("select objectno from Apply_Relative where ObjectType='"+ObjectType+"' and SerialNo = '"+sObjectNo+"'");	 
		if(sRelativeNo == null) sRelativeNo = "";
		
		//删除主体对象信息
		deleteBUSINESS_CONTRACT_HISTORY("BUSINESS_CONTRACT_HISTORY",sRelativeNo,Sqlca);
	}
	//删除变更历史记录信息表
	private void deleteBUSINESS_CONTRACT_HISTORY(String sRelativeTable,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sSql = "";

		sSql = " delete from "+sRelativeTable+" where order = '"+sObjectNo+"' ";
		//执行删除语句
		Sqlca.executeSQL(sSql);	 
	}
	//如果是申请信息变更的话删除原申请的归档标志 add by wangdw
	private void deletePigeonholeDateInfo(String sObjectType,String sObjectNo,Transaction Sqlca)
	throws Exception
	{
		String sOldObjectNo = "";	  //原申请编号
		String sChangeObject = "";	  //变更对象
		String sSql = "";
		ASResultSet rs = null;
		sSql = "select OBJECTTYPE,OBJECTNO from CONTRACT_RELATIVE where SerialNo = '"+sObjectNo+"' and objecttype = 'ApplyChange'";	 
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sOldObjectNo = rs.getString("OBJECTNO");
			sChangeObject = rs.getString("OBJECTTYPE");
		}
		if("ApplyChange".equals(sChangeObject))
		{
			Sqlca.executeSQL("Update BUSINESS_APPLY set PigeonholeDate='' where SerialNo='"+sOldObjectNo+"'");
		}
		
	}
}
