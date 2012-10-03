/*
		Author: --xhyong 2009/01/20
		Tester:
		Describe: --探测不良业务申请风险探测
		Input Param:
				ObjectType: 对象类型
				ObjectNo: 对象编号
		Output Param:
				Message：风险提示信息
		HistoryLog: 
*/

package com.amarsoft.app.lending.bizlets;


import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.biz.bizlet.Bizlet;



public class CheckBadBizApplyRisk extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//获取参数：对象类型和对象编号
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//将空值转化成空字符串
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		 
		//定义变量：提示信息、SQL语句、产品类型、客户类型
		String sMessage = "",sSql = "";
		//定义变量：查询结果集
		ASResultSet rs = null;	
		//暂存标志,申请类型
		String sTempSaveFlag = "",sApplyType = "";
		int iAssetCount = 0,iContractCount = 0,iFiContractCount = 0;
		int iLwContractCount = 0,iCount1 = 0, iCount2 = 0,iCount3 = 0;
		//根据对象类型获取主体表名
			//--------------第一步：检查申请信息是否全部输入---------------
		//从相应的对象主体表中获取暂存标志,申请类型
		sSql = 	" select TempSaveFlag,ApplyType "+
				" from BADBIZ_APPLY where SerialNo = '"+sObjectNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		while (rs.next()) { 	
			sTempSaveFlag = rs.getString("TempSaveFlag");
			sApplyType = rs.getString("ApplyType");
			if(!"2".equals(sTempSaveFlag))
			sMessage = "未填写申请基本信息，请先填写完申请基本信息并点击保存按钮！"+"@";									
		}
		rs.getStatement().close();
		/*
			//--------------第二步：检查抵债资产收取相关信息是否录入---------------	
		if("010".equals(sApplyType))
		{			
			//是否填写抵债资产信息
			sSql = 	" select count(SerialNo) as iCount "+
						" from ASSET_INFO where  ObjectType='BadBizApply' and ObjectNo = '"+sObjectNo+"'  ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) { 	
				iAssetCount=rs.getInt("iCount");							
			}
			if(iAssetCount < 1)
			sMessage += "未填写抵债资产信息，请先填写完抵债资产信息并保存！"+"@";		
			rs.getStatement().close();
			//是否填写关联合同信息
			sSql = 	" select count(AB.SerialNo) as iCount "+
			" from ASSET_BIZ AB,BUSINESS_CONTRACT BC "+
			" where  AB.ContractSerialNo = BC.SerialNo and "+
			" AB.ObjectType='BadBizApply' and ObjectNo = '"+sObjectNo+"'  ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) { 	
				iContractCount=rs.getInt("iCount");							
			}
			if(iContractCount < 1)
			sMessage += "未填写关联合同信息，请先填写关联合同信息并保存！"+"@";		
			rs.getStatement().close();
		}
			//--------------第三步：检查抵债资产处置相关信息是否录入---------------	
			//--------------第四步：检查核销相关信息是否录入---------------	
		if("030".equals(sApplyType))
		{
			
		}
			//--------------第五步：检查贷款终结相关信息是否录入---------------
		if("040".equals(sApplyType))
		{
				//是否填写关联合同信息
				sSql = 	" select count(BR.ObjectNo) as iCount "+
					" from BUSINESS_CONTRACT BC,BADBIZ_RELATIVE BR  "+
					" where BR.ObjectNo=BC.SerialNo and BR.ObjectType='FinishContract' "+
					" and BR.SerialNo='"+sObjectNo+"'  ";
				rs = Sqlca.getASResultSet(sSql);
				if (rs.next()) { 	
					iFiContractCount=rs.getInt("iCount");							
				}
				if(iFiContractCount < 1)
					sMessage += "未填写合同信息，请先填写合同信息！"+"@";		
				rs.getStatement().close();
		}
			//--------------第六步：检查诉讼案件相关信息是否录入---------------	
		if("050".equals(sApplyType))
		{
			//是否填写关联合同信息
			sSql = 	" select count(BR.ObjectNo) as iCount "+
				" from BUSINESS_CONTRACT BC,BADBIZ_RELATIVE BR  "+
				" where BR.ObjectNo=BC.SerialNo and BR.ObjectType='LawCaseContract' "+
				" and BR.SerialNo in (select SerialNo from LAWCASE_INFO "+
						"where  ObjectType = 'BadBizApply' and ObjectNo='"+sObjectNo+"')  ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) { 	
				iLwContractCount=rs.getInt("iCount");							
			}
			if(iLwContractCount < 1)
				sMessage += "未填写相关合同信息，请先填写相关合同信息！"+"@";		
			rs.getStatement().close();
			//案件当事人信息
			sSql = 	" select count(SerialNo) as iCount "+
				" from LAWCASE_PERSONS  "+
				" where PersonType = '01' "+
				" and ObjectNo in (select SerialNo from LAWCASE_INFO "+
						"where  ObjectType = 'BadBizApply' and ObjectNo='"+sObjectNo+"')  ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) { 	
				iCount1=rs.getInt("iCount");							
			}
			if(iCount1 < 1)
				sMessage += "未填写案件当事人信息，请先填写案件当事人信息！"+"@";		
			rs.getStatement().close();
			//案件当事人信息
			sSql = 	" select count(SerialNo) as iCount "+
				" from LAWCASE_PERSONS  "+
				" where PersonType = '02' "+
				" and ObjectNo in (select SerialNo from LAWCASE_INFO "+
						"where  ObjectType = 'BadBizApply' and ObjectNo='"+sObjectNo+"')  ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) { 	
				iCount2=rs.getInt("iCount");							
			}
			if(iCount2 < 1)
				sMessage += "未填写受理机关人员信息，请先填写受理机关人员信息！"+"@";		
			rs.getStatement().close();
			//案件当事人信息
			sSql = 	" select count(SerialNo) as iCount "+
				" from LAWCASE_PERSONS  "+
				" where PersonType = '03' "+
				" and ObjectNo in (select SerialNo from LAWCASE_INFO "+
						"where  ObjectType = 'BadBizApply' and ObjectNo='"+sObjectNo+"')  ";
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next()) { 	
				iCount3=rs.getInt("iCount");							
			}
			if(iCount3 < 1)
				sMessage += "未填写代理人信息，请先填写代理人信息！"+"@";		
			rs.getStatement().close();
		}
		
		*/
				
		return sMessage;
	 }
	

}
