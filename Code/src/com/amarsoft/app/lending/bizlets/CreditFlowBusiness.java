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


	
/**�����������*/
public class CreditFlowBusiness 
{
	//��������
	private String ObjectType = "";
    //�������
	private String ObjectNo = "" ;
	//sql
	private String Sql = "";
	private Transaction Sqlca = null ;
		//ҵ�����̶���
	private Hashtable oApply = new Hashtable();
	private Hashtable oFlowModel = new Hashtable();
	
	
	//�����
	private ASResultSet rs = null;
	
	public CreditFlowBusiness(String ObjectNo,String ObjectType,Transaction Sqlca) throws Exception
	{
		this.ObjectNo = ObjectNo;
		this.ObjectType = ObjectType;
		this.Sqlca = Sqlca;
		System.out.println("$$$$$$$$$$ObjectType$$^^^$:"+ObjectType);
		this.oApply =  ApplyBusiness();
		//InitObjectAll(); ���캯��������ȫ����ʼ������Ӱ��Ч��
	}
	
	/**
	 * ���ܻ�ȡҵ����Ϣģ��
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
			oApply.put("SerialNo",SerialNo); //��ͬ���
			oApply.put("BusinessType",BusinessType); //ҵ��Ʒ��
			oApply.put("CustomerID",CustomerID); //�ͻ����
			oApply.put("CustomerType",CustomerType); //�ͻ�����
			oApply.put("ApplyType",ApplyType); //��������
			oApply.put("CreditAggreement",CreditAggreement); //����Э��� 
			oApply.put("BusinessCurrency",BusinessCurrency); //ҵ�����
			oApply.put("BusinessSum",String.valueOf(rs.getDouble("BusinessSum"))); //���Ž��
			oApply.put("TermMonth",String.valueOf(rs.getDouble("TermMonth"))); //����
			oApply.put("LowRisk",LowRisk); //�Ƿ�ͷ���
			oApply.put("OperateOrgID",OperateOrgID); //��������
			oApply.put("OperateOrgName",OperateOrgName); //������������
			oApply.put("OperateUserID",OperateUserID); //������
			oApply.put("OperateUserName",OperateUserName); //����������
			oApply.put("UpdateDate",UpdateDate); //��������
			oApply.put("OccurType",OccurType); //������ʽ
 		}else{
 			throw new Exception("��ʼ��ҵ��������û���ҵ�ҵ�����["+this.ObjectNo+"]");
 		}
		rs.getStatement().close();
		
		return oApply;
	}
	/**
	 * ���ܻ�ȡ����ģ��
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
			oFlowModel.put("FlowNo",FlowNo);//��������
			oFlowModel.put("PhaseNo",PhaseNo);//�׶κ�
			oFlowModel.put("PhaseType",PhaseType);//�׶�����
			oFlowModel.put("PhaseName",PhaseName);//�׶�����
			oFlowModel.put("PhaseDescribe",PhaseDescribe);//�׶�����
			oFlowModel.put("PhaseAttribute",PhaseAttribute);//�׶�����
			oFlowModel.put("Prescript",Prescript);//ǰ�ؼ��script
			oFlowModel.put("InitScript",InitScript);//�а��˳�ʼ��script
			oFlowModel.put("ChoiceDescribe",ChoiceDescribe);//�����ʾ����
			oFlowModel.put("ChoiceScript",ChoiceScript);//�������script
			oFlowModel.put("ActionDescribe",ActionDescribe);//�����ύ��ʾ����
			oFlowModel.put("ActionScript",ActionScript);//��������script
			oFlowModel.put("PostScript",PostScript);//�����ж�script
		}
		rs.getStatement().close();
		return oFlowModel;
	}
	
	/** ���ܣ���ʼ������
	 * ���� TASK��ˮ��
	 * @throws Exception */
	public void InitWorkFlow(String TaskNo) throws Exception
	{
		
		String  FlowNo = "",sSuperCertType=""; //����ģ��,��ͬ����
		String  sInitPhase ="",sFlowName="",sSerialNo = ""; //��ʼ���׶�,��������,TASK��ˮ��
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
			//��ʾģ����
			//String sTempletNo = Sqlca.getString("select ApplyDetailNo from Business_Type where TypeNo ='"+sBusinessType+"' ");
			String sReformType = Sqlca.getString("select ApplyType from REFORM_INFO where serialno in" +
						" ( select objectno from apply_Relative where serialno = '"+sSerialNo+"'" +
						" and objecttype = 'CapitalReform')");
			
			if("030".equals(sOccurType) && "01".equals(sReformType))//������� (һ������)
			{
				//FlowNo = "ReformFlow";
				if(((String) oApply.get("CustomerType")).startsWith("01"))//�Թ� 
				{
					FlowNo = "EntCreditFlowTJ01";
				}else//��˽
				{
					FlowNo = "IndCreditFlowTJ01";
				}
				//��ũ���˾
				if("918010100".equals(sOperateOrgID)){
					FlowNo = "CreditCompanyFlow";
				}
			}else if("DependentApply".equals(sApplyType))//�������
			{
				FlowNo = "CreditFlow01";
			}
			else if("918010100".equals(sOperateOrgID)){
				FlowNo = "CreditCompanyFlow";
			}
			else{
				if(sBusinessType.equals("3015"))//ͬҵ�������
				{
					FlowNo = "CreditFlow03";
				}else if(sBusinessType.equals("3010") )//��˾�ۺ�����
				{
					String sSmallEntFlag = Sqlca.getString("select SmallEntFlag from ENT_INFO where CustomerID ='"+sCustomerID+"' ");
					if("1".equals(sSmallEntFlag)){
						FlowNo = "CreditFlow02"; //΢С�ͻ�
					}
					else if(LowRiskFalg)//�ͷ���
					{
						FlowNo = "EntCreditFlowTJ02";
					}else
					{
						FlowNo = "EntCreditFlowTJ01";
					}
				}else if(sBusinessType.equals("3040"))//�����ۺ�����
				{
					if(LowRiskFalg)//�ͷ���
						FlowNo = "IndCreditFlowTJ02";
					else
						FlowNo = "IndCreditFlowTJ01";
				}
				else if(sBusinessType.equals("3060"))//���ù�ͬ�����Ŷ��
				{
					sSuperCertType = Sqlca.getString("select SuperCertType FROM ENT_INFO where CustomerID = '"+sCustomerID+"'");
					if(sSuperCertType == null) sSuperCertType="";
					
					if(sSuperCertType.equals("010"))//����
					{
						FlowNo = "EntCreditFlowTJ01";
					}else{
						FlowNo = "IndCreditFlowTJ01";
					}
				}else if(sBusinessType.equals("3050"))//����С����
				{
					FlowNo = "IndCreditFlowTJ01";
				}
				else
				{
					if(((String) oApply.get("CustomerType")).startsWith("01"))//�Թ� 
					{
						String sSmallEntFlag = Sqlca.getString("select SmallEntFlag from ENT_INFO where CustomerID ='"+sCustomerID+"' ");
						if(sSmallEntFlag == null) sSmallEntFlag="";
						String sNationRisk = Sqlca.getString("select NationRisk  from Business_Apply where SerialNo = '"+this.ObjectNo+"'");
						if(sNationRisk == null) sNationRisk="";
						if("1".equals(sNationRisk))//����ҵ��ͷ���
						{
							FlowNo = "EntCreditFlowTJ02";
						}else if("1".equals(sSmallEntFlag))
						{
							if(LowRiskFalg)//�ͷ���
								FlowNo = "EntCreditFlowTJ02";
							else
								FlowNo = "CreditFlow02"; //΢С�ͻ�
						}else
						{
							if(LowRiskFalg)//�ͷ���
								FlowNo = "EntCreditFlowTJ02";
							else
								FlowNo = "EntCreditFlowTJ01";
						}
					
					}else//��˽
					{
						if(LowRiskFalg)//�ͷ���
							FlowNo = "IndCreditFlowTJ02";
						else
							FlowNo = "IndCreditFlowTJ01";
					}
				}
			
			}
			System.out.println("FlowNo:"+FlowNo);
			//FlowNo = "EntCreditFlowTJ01";//����
			
			//��ʼ��CATALOG
			Sql = "select InitPhase,FlowName from FLOW_CATALOG where FlowNo = '"+FlowNo+"'";
			rs = Sqlca.getASResultSet(Sql);
			if(rs.next())
			{
				sFlowName = rs.getString("FlowName"); //��������
				sInitPhase = rs.getString("InitPhase"); //��ʼ���׶�
				if(sFlowName == null) sFlowName ="";
				if(sInitPhase == null) sInitPhase ="";
			}
			rs.getStatement().close();
			if( sInitPhase.trim().equals(""))
				throw new Exception("��������"+FlowNo+"û�г�ʼ���׶α�ţ�");
			//��ʼ��ģ��
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

			
			
		   
		    //ִ�в������
		    Sqlca.executeSQL(sSql1);
		    Sqlca.executeSQL(sSql2);
											
		}
		
	}
	
	
	/** ���ܣ��ж��Ƿ�ͷ��� 
	 * @throws Exception */
	public boolean CheckLowRisk() 
	{
		String sLowRisk = "";
		try {
			System.out.println("(String) oApply.get(LowRisk):"+(String) oApply.get("LowRisk"));
			sLowRisk = (String) oApply.get("LowRisk");
		} catch (Exception e) {
			try {
				throw new Exception("���ܽ�[LowRisk]����ΪString����");
			} catch (Exception e1) {
				e1.printStackTrace();
			}
		}
		
		if(sLowRisk.equals("1"))
			return true;
		else
			return false;
	}
	/** ���ܣ���ʼ�����ж���
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