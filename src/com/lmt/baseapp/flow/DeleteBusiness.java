package com.lmt.baseapp.flow;

import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class DeleteBusiness extends Bizlet 
{
	private String sObjectTable = "";
	private String sRelativeTable = ""; 
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
		if(sDeleteType.equals("DeleteTask")){
			//删除任务
			//获取关联表
			//删除流程对象信息				
			deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
			//删除流程任务信息
			deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);
			//删除流程意见信息
			deleteTableData("Flow_Opinion",sObjectType,sObjectNo,Sqlca);

		}
		//删除申请和最终审批意见任务
		if(sObjectType.equals("CreditApply") || sObjectType.equals("ApproveApply"))
		{
			//获取关联表
			getRelativeTable(sObjectType,Sqlca);
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
			//删除流程对象信息				
			deleteTableData("Flow_Object",sObjectType,sObjectNo,Sqlca);			
			//删除流程任务信息
			deleteTableData("Flow_Task",sObjectType,sObjectNo,Sqlca);				
		}
		if(sDeleteType.equals("DeleteBusiness"))
		{					
			//删除合同信息
			if(sObjectType.equals("BusinessContract"))
			{
				//获取关联表
				getRelativeTable(sObjectType,Sqlca);
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
				//删除流程相关信息
				delFlowInfo(sObjectNo,"LawCaseApply",Sqlca);
				//删除关联合同的关联关系
				deleteRelativeInfo("LAWCASE_RELATIVE",sObjectNo,Sqlca);
				//删除案件当事人、案件受理人员、代理人信息
				deleteTableData("Lawcase_Persons",sObjectType,sObjectNo,Sqlca);
				//删除案件相关文档
				deleteDocInfo(sObjectType,sObjectNo,Sqlca);
				//删除台账信息
				deleteTableData("Lawcase_Book",sObjectType,sObjectNo,Sqlca);
				//删除庭审记录
				deleteTableData("Lawcase_Cognizance",sObjectType,sObjectNo,Sqlca);
				//删除费用台账
				deleteTableData("Cost_Info",sObjectType,sObjectNo,Sqlca);
				//删除查封资产台账
				deleteTableData("Asset_Info",sObjectType,sObjectNo,Sqlca);

			}
			//add by fhuang 2006.11.30 删除抵债资产的关联信息
			if(sObjectType.equals("AssetInfo"))
			{
				//删除流程相关信息
				delFlowInfo(sObjectNo,"PDAApply",Sqlca);
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

	private void delFlowInfo(String objectNo,String objectType, Transaction sqlca) 
	throws Exception
	{
		sqlca.executeSQL(" delete from flow_task where objectno='"+objectNo+"' and objectType = '"+objectType+"' ");
		sqlca.executeSQL(" delete from flow_object where objectno='"+objectNo+"' and objectType = '"+objectType+"' ");
		sqlca.executeSQL(" delete from flow_opinion where objectno='"+objectNo+"' and objectType = '"+objectType+"' ");
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


}
