/**
 * @(#)FlowTask.java	2009-8-14 
 *
 * Copyright 2001-2003 Amarsoft, Inc. All Rights Reserved.
 * 
 * This software is the proprietary information of Amarsoft, Inc.  
 * Use is subject to license terms.
 * 
 * Author:lpzhang
 */
 
package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.ASValuePool;
import java.util.Hashtable;
import com.amarsoft.script.ScriptObject;


	
/**流程任务对象*/
public class CreditFlowBusiness 
{
	//对象类型
	private String ObjectType = "";
    //对象号码
	private String ObjectNo = "" ;
	//sql
	private String Sql = "";
	private Transaction Sqlca = null ;
		//业务及流程对象
	private Hashtable oApply = new Hashtable();
	private Hashtable oFlowModel = new Hashtable();
	
	
	//结果集
	private ASResultSet rs = null;
	
	public CreditFlowBusiness(String ObjectNo,String ObjectType,Transaction Sqlca) throws Exception
	{
		this.ObjectNo = ObjectNo;
		this.ObjectType = ObjectType;
		this.Sqlca = Sqlca;
		System.out.println("$$$$$$$$$$ObjectType$$^^^$:"+ObjectType);
		this.oApply =  ApplyBusiness();
		//InitObjectAll(); 构造函数不进行全部初始化否则影响效率
	}
	
	/**
	 * 功能获取业务信息模型
	 * @throws Exception 
	 */
	public Hashtable ApplyBusiness() throws Exception
	{
		String Sql1 = "select BA.*,getCustomerType(CustomerID) as CustomerType,getUserName(OperateUserID) as OperateUserName,getOrgName(OperateUserID) as OperateOrgName from BUSINESS_APPLY BA where BA.SerialNo = '"+this.ObjectNo+"'";
		rs = Sqlca.getASResultSet(Sql1);
		if(rs.next()){
			String SerialNo = rs.getString("SerialNo"); if(SerialNo == null) SerialNo="";
			String BusinessType = rs.getString("BusinessType"); if(BusinessType == null) BusinessType="";
			String CustomerID = rs.getString("CustomerID"); if(CustomerID == null) CustomerID="";
			String CustomerType = rs.getString("CustomerType"); if(CustomerType == null) CustomerType="";
			String ApplyType = rs.getString("ApplyType"); if(ApplyType == null) ApplyType="";
			String CreditAggreement = rs.getString("CreditAggreement"); if(CreditAggreement == null) CreditAggreement="";
			String BusinessCurrency = rs.getString("BusinessCurrency"); if(BusinessCurrency == null) BusinessCurrency="";
			String LowRisk = rs.getString("LowRisk"); if(LowRisk == null) LowRisk="";
			String OperateOrgID = rs.getString("OperateOrgID"); if(OperateOrgID == null) OperateOrgID="";
			String OperateOrgName = rs.getString("OperateOrgName"); if(OperateOrgName == null) OperateOrgName="";
			String OperateUserID = rs.getString("OperateUserID"); if(OperateUserID == null) OperateUserID="";
			String OperateUserName = rs.getString("OperateUserName"); if(OperateUserName == null) OperateUserName="";
			String UpdateDate = rs.getString("UpdateDate"); if(UpdateDate == null) UpdateDate="";
			String OccurType = rs.getString("OccurType"); if(OccurType == null) OccurType="";
			oApply.put("SerialNo",SerialNo); //合同编号
			oApply.put("BusinessType",BusinessType); //业务品种
			oApply.put("CustomerID",CustomerID); //客户编号
			oApply.put("CustomerType",CustomerType); //客户类型
			oApply.put("ApplyType",ApplyType); //申请类型
			oApply.put("CreditAggreement",CreditAggreement); //申请协议号 
			oApply.put("BusinessCurrency",BusinessCurrency); //业务币种
			oApply.put("BusinessSum",String.valueOf(rs.getDouble("BusinessSum"))); //授信金额
			oApply.put("TermMonth",String.valueOf(rs.getDouble("TermMonth"))); //期限
			oApply.put("LowRisk",LowRisk); //是否低风险
			oApply.put("OperateOrgID",OperateOrgID); //创建机构
			oApply.put("OperateOrgName",OperateOrgName); //创建机构名称
			oApply.put("OperateUserID",OperateUserID); //创建人
			oApply.put("OperateUserName",OperateUserName); //创建人姓名
			oApply.put("UpdateDate",UpdateDate); //更新日期
			oApply.put("OccurType",OccurType); //发生方式
 		}else{
 			throw new Exception("初始化业务对象出错：没有找到业务对象["+this.ObjectNo+"]");
 		}
		rs.getStatement().close();
		
		return oApply;
	}
	/**
	 * 功能获取流程模型
	 * @throws Exception 
	 */
	public Hashtable FlowModel(String sFlowNo,String sPhaseNo) throws Exception
	{
		Sql = "select * from FLOW_MODEL where FlowNo = '"+sFlowNo+"' and PhaseNo='"+sPhaseNo+"'";
		rs = Sqlca.getASResultSet(Sql);
		if(rs.next()){
			String FlowNo = rs.getString("FlowNo"); if(FlowNo == null) FlowNo="";
			String PhaseNo = rs.getString("PhaseNo"); if(PhaseNo == null) PhaseNo="";
			String PhaseType = rs.getString("PhaseType"); if(PhaseType == null) PhaseType="";
			String PhaseName = rs.getString("PhaseName"); if(PhaseName == null) PhaseName="";
			String PhaseDescribe = rs.getString("PhaseDescribe"); if(PhaseDescribe == null) PhaseDescribe="";
			String PhaseAttribute = rs.getString("PhaseAttribute"); if(PhaseAttribute == null) PhaseAttribute="";
			String Prescript = rs.getString("Prescript"); if(Prescript == null) Prescript="";
			String InitScript = rs.getString("InitScript"); if(InitScript == null) InitScript="";
			String ChoiceDescribe = rs.getString("ChoiceDescribe"); if(ChoiceDescribe == null) ChoiceDescribe="";
			String ChoiceScript = rs.getString("ChoiceScript"); if(ChoiceScript == null) ChoiceScript="";
			String ActionDescribe = rs.getString("ActionDescribe"); if(ActionDescribe == null) ActionDescribe="";
			String ActionScript = rs.getString("ActionScript"); if(ActionScript == null) ActionScript="";
			String PostScript = rs.getString("PostScript"); if(PostScript == null) PostScript="";
			oFlowModel.put("FlowNo",FlowNo);//流程名称
			oFlowModel.put("PhaseNo",PhaseNo);//阶段号
			oFlowModel.put("PhaseType",PhaseType);//阶段类型
			oFlowModel.put("PhaseName",PhaseName);//阶段名称
			oFlowModel.put("PhaseDescribe",PhaseDescribe);//阶段描述
			oFlowModel.put("PhaseAttribute",PhaseAttribute);//阶段属性
			oFlowModel.put("Prescript",Prescript);//前沿检查script
			oFlowModel.put("InitScript",InitScript);//承办人初始化script
			oFlowModel.put("ChoiceDescribe",ChoiceDescribe);//意见提示文字
			oFlowModel.put("ChoiceScript",ChoiceScript);//意见生成script
			oFlowModel.put("ActionDescribe",ActionDescribe);//动作提交提示文字
			oFlowModel.put("ActionScript",ActionScript);//动作生成script
			oFlowModel.put("PostScript",PostScript);//后续判断script
		}
		rs.getStatement().close();
		return oFlowModel;
	}
	
	/** 功能：初始化流程
	 * 返回 TASK流水号
	 * @throws Exception */
	public void InitWorkFlow(String TaskNo) throws Exception
	{
		
		String  FlowNo = "",sSuperCertType=""; //流程模型,共同类型
		String  sInitPhase ="",sFlowName="",sSerialNo = ""; //初始化阶段,流程名称,TASK流水号
		String  sPhaseType = "",sPhaseName ="",sOperateOrgID ="",sOperateOrgName="",sOperateUserID ="",sOperateUserName="";
		if(ObjectType.equals("CreditApply"))
		{
			boolean LowRiskFalg =  CheckLowRisk();
			String  sBusinessType = (String) oApply.get("BusinessType");
			String  sApplyType = (String) oApply.get("ApplyType");
			String  sCustomerID = (String) oApply.get("CustomerID");
			String  sOccurType =  (String) oApply.get("OccurType");
			sOperateOrgID = (String) oApply.get("OperateOrgID");
			sSerialNo = (String) oApply.get("SerialNo");
			//显示模板编号
			//String sTempletNo = Sqlca.getString("select ApplyDetailNo from Business_Type where TypeNo ='"+sBusinessType+"' ");
			String sReformType = Sqlca.getString("select ApplyType from REFORM_INFO where serialno in" +
						" ( select objectno from apply_Relative where serialno = '"+sSerialNo+"'" +
						" and objecttype = 'CapitalReform')");
			
			if("030".equals(sOccurType) && "01".equals(sReformType))//重组贷款 (一般重组)
			{
				//FlowNo = "ReformFlow";
				if(((String) oApply.get("CustomerType")).startsWith("01"))//对公 
				{
					FlowNo = "EntCreditFlowTJ01";
				}else//对私
				{
					FlowNo = "IndCreditFlowTJ01";
				}
				//兴农贷款公司
				if("918010100".equals(sOperateOrgID)){
					FlowNo = "CreditCompanyFlow";
				}
			}else if("DependentApply".equals(sApplyType))//额度项下
			{
				FlowNo = "CreditFlow01";
			}
			else if("918010100".equals(sOperateOrgID)){
				FlowNo = "CreditCompanyFlow";
			}
			else{
				if(sBusinessType.equals("3015"))//同业额度授信
				{
					FlowNo = "CreditFlow03";
				}else if(sBusinessType.equals("3010") )//公司综合授信
				{
					String sSmallEntFlag = Sqlca.getString("select SmallEntFlag from ENT_INFO where CustomerID ='"+sCustomerID+"' ");
					if("1".equals(sSmallEntFlag)){
						FlowNo = "CreditFlow02"; //微小客户
					}
					else if(LowRiskFalg)//低风险
					{
						FlowNo = "EntCreditFlowTJ02";
					}else
					{
						FlowNo = "EntCreditFlowTJ01";
					}
				}else if(sBusinessType.equals("3040"))//个人综合授信
				{
					if(LowRiskFalg)//低风险
						FlowNo = "IndCreditFlowTJ02";
					else
						FlowNo = "IndCreditFlowTJ01";
				}
				else if(sBusinessType.equals("3060"))//信用共同体授信额度
				{
					sSuperCertType = Sqlca.getString("select SuperCertType FROM ENT_INFO where CustomerID = '"+sCustomerID+"'");
					if(sSuperCertType == null) sSuperCertType="";
					
					if(sSuperCertType.equals("010"))//城区
					{
						FlowNo = "EntCreditFlowTJ01";
					}else{
						FlowNo = "IndCreditFlowTJ01";
					}
				}else if(sBusinessType.equals("3050"))//联保小组额度
				{
					FlowNo = "IndCreditFlowTJ01";
				}
				else
				{
					if(((String) oApply.get("CustomerType")).startsWith("01"))//对公 
					{
						String sSmallEntFlag = Sqlca.getString("select SmallEntFlag from ENT_INFO where CustomerID ='"+sCustomerID+"' ");
						if(sSmallEntFlag == null) sSmallEntFlag="";
						String sNationRisk = Sqlca.getString("select NationRisk  from Business_Apply where SerialNo = '"+this.ObjectNo+"'");
						if(sNationRisk == null) sNationRisk="";
						if("1".equals(sNationRisk))//国际业务低风险
						{
							FlowNo = "EntCreditFlowTJ02";
						}else if("1".equals(sSmallEntFlag))
						{
							if(LowRiskFalg)//低风险
								FlowNo = "EntCreditFlowTJ02";
							else
								FlowNo = "CreditFlow02"; //微小客户
						}else
						{
							if(LowRiskFalg)//低风险
								FlowNo = "EntCreditFlowTJ02";
							else
								FlowNo = "EntCreditFlowTJ01";
						}
					
					}else//对私
					{
						if(LowRiskFalg)//低风险
							FlowNo = "IndCreditFlowTJ02";
						else
							FlowNo = "IndCreditFlowTJ01";
					}
				}
			
			}
			System.out.println("FlowNo:"+FlowNo);
			//FlowNo = "EntCreditFlowTJ01";//测试
			
			//初始化CATALOG
			Sql = "select InitPhase,FlowName from FLOW_CATALOG where FlowNo = '"+FlowNo+"'";
			rs = Sqlca.getASResultSet(Sql);
			if(rs.next())
			{
				sFlowName = rs.getString("FlowName"); //流程名称
				sInitPhase = rs.getString("InitPhase"); //初始化阶段
				if(sFlowName == null) sFlowName ="";
				if(sInitPhase == null) sInitPhase ="";
			}
			rs.getStatement().close();
			if( sInitPhase.trim().equals(""))
				throw new Exception("审批流程"+FlowNo+"没有初始化阶段编号！");
			//初始化模型
			FlowModel(FlowNo,sInitPhase);
			sPhaseType = (String) oFlowModel.get("PhaseType");
			sPhaseName = (String) oFlowModel.get("PhaseName");
			sOperateOrgID = (String) oApply.get("OperateOrgID");
			sOperateOrgName = (String) oApply.get("OperateOrgName");
			sOperateUserID =  (String) oApply.get("OperateUserID");
			sOperateUserName =  (String) oApply.get("OperateUserName");
			
			
			String sSql1 = " Update FLOW_OBJECT set PhaseType  ='"+sPhaseType+"',FlowNo ='"+FlowNo+"'," +
					       " FlowName ='"+sFlowName+"',PhaseNo='"+sInitPhase+"',PhaseName='"+sPhaseName+"'" +
					       " where ObjectNo = '"+ObjectNo+"' and ObjectType ='"+ObjectType+"'";
			
			String sSql2 = " Update FLOW_TASK set PhaseType  ='"+sPhaseType+"',FlowNo ='"+FlowNo+"'," +
					       " FlowName ='"+sFlowName+"',PhaseNo='"+sInitPhase+"',PhaseName='"+sPhaseName+"'" +
					       " where ObjectNo = '"+ObjectNo+"' and ObjectType ='"+ObjectType+"' and SerialNo ='"+TaskNo+"'";

			
			
		   
		    //执行插入语句
		    Sqlca.executeSQL(sSql1);
		    Sqlca.executeSQL(sSql2);
											
		}
		
	}
	
	
	/** 功能：判段是否低风险 
	 * @throws Exception */
	public boolean CheckLowRisk() 
	{
		String sLowRisk = "";
		try {
			System.out.println("(String) oApply.get(LowRisk):"+(String) oApply.get("LowRisk"));
			sLowRisk = (String) oApply.get("LowRisk");
		} catch (Exception e) {
			try {
				throw new Exception("不能将[LowRisk]造型为String类型");
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}
		
		if(sLowRisk.equals("1"))
			return true;
		else
			return false;
	}
	/** 功能：初始化所有对象
	 * @return 
	 * @throws Exception */
	public  void InitObjectAll() throws Exception
	{
		this.oApply =  ApplyBusiness();
		this.oFlowModel =  FlowModel(ObjectNo, ObjectType);
		//memory.put("Apply",this.oApply);
		
		//return memory;
	}
	/*
	public static void Main(String[] sArgs)
	{
		try {
			//CreditFlowBusiness CB = new CreditFlowBusiness("BA20090814000001","CreditApply",Sqlca);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}*/
	
}	