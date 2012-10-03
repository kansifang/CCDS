/**
 * Author: --lpzhang 2009-9-3 
 * Tester:                               
 * Describe: --��ȼ��
 * Input Param:                          
 * 		ObjectNo :������  
 * 		ObjectType����������
 * 		LineID����ȱ��
 *      BusinessType��ҵ��Ʒ��
 * Output Param:   
 * 		sMessage             
 * HistoryLog:   ���Ӷ�ȴ��� lpzhang  2010-5-28                       
 */
package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.ASValuePool;


public class CreditLineControl extends Bizlet {

	/* (non-Javadoc)
	 * @see com.amarsoft.biz.bizlet.Bizlet#run(com.amarsoft.are.sql.Transaction)
	 */
	public Object run(Transaction Sqlca) throws Exception {
		String sObjectNo = (String)this.getAttribute("ObjectNo"); //������  
		String sObjectType = (String)this.getAttribute("ObjectType"); //��������
        String sLineID = (String)this.getAttribute("LineID");//��ȱ��
        String sBusinessType = (String)this.getAttribute("BusinessType");//ҵ��Ʒ��
        String sStyle = (String)this.getAttribute("Style");//�������
        String sCustomerID = (String)this.getAttribute("CustomerID");//�ͻ����
        String sBCSerialNo = (String)this.getAttribute("BCSerialNo");//��Ⱥ�ͬ��
       
        
    	double dSubLineSum = 0.0,dTotalLineSum=0.0,dBusinessSum=0.0,dBusinessTotalSum=0.0;
    	String sCycFlag="",sSelfUseFlag="";
    	String sMessage="";
		ASValuePool attribute1 = null;
		ASValuePool attribute2 = null;
		//��ʼ����ȶ���
		CreditLineCL CC = new CreditLineCL(sLineID,sStyle,Sqlca);
		//��ʼ��ҵ�����
		CreditLineBusiness CB = new CreditLineBusiness(sObjectType,sObjectNo,sBusinessType,sLineID,sStyle,sBCSerialNo,Sqlca);
		
		System.out.println("sLineID:::::::::::::::::::::::"+sLineID);
		if(sStyle.equals("AssureAgreement") || sStyle.equals("CommunityAgreement")) //�����������ù�ͬ��
		{
			
			//-------��һ�����жϸÿͻ��񳬹���ȿ��ƵĿͻ�����޶�-----------------
			attribute1 = (ASValuePool) CC.getMemberpool().getAttribute(sCustomerID);
			if(attribute1 != null )
			{	
				dSubLineSum = Double.valueOf( (String) attribute1.getAttribute("LineSum1*getERate(Currency,'01',ERateDate)")).doubleValue();//ȡ�ø��û��������
				sCycFlag = (String) attribute1.getAttribute("Rotative");
				System.out.println("((Double)CB.getOALLBusiness().getAttribute(TotalBCSum1)).doubleValue():"+((Double)CB.getOALLBusiness().getAttribute("TotalBCSum1")).doubleValue());
				System.out.println("((Double)CB.getOALLBusiness().getAttribute(TotalBCSum)).doubleValue():"+((Double)CB.getOALLBusiness().getAttribute("TotalBCSum")).doubleValue());
				dBusinessSum =  Double.valueOf((String) CB.getOApply().getAttribute("BusinessSum")).doubleValue()
							   +  (sCycFlag.equals("1")?((Double)CB.getOALLBusiness().getAttribute("TotalBCSum")).doubleValue():((Double)CB.getOALLBusiness().getAttribute("TotalBCSum1")).doubleValue())
							   + ((Double)CB.getOALLBusiness().getAttribute("TotalBASum")).doubleValue();
				System.out.println("dBusinessSum:"+dBusinessSum+"##dSubLineSum:"+dSubLineSum);
				if(dBusinessSum>dSubLineSum)
				{
					sMessage += "�����볬���ó�Ա������ƣ�"+"@";
				}
				
				//�ж������Ƿ񳬹�
				double dBATermMonth = (CB.getOApply().getAttribute("TermMonth") == null || "".equals(CB.getOApply().getAttribute("TermMonth")) )? 0.0:Double.valueOf( (String) CB.getOApply().getAttribute("TermMonth")).doubleValue();
				double dSubCLTermMonth =  Double.valueOf( (String)  attribute1.getAttribute("TermMonth")).doubleValue();
				
				if(dBATermMonth>dSubCLTermMonth)
				{
					sMessage += "���������޳����ó�Ա����������ƣ�"+"@";
				}
				
			}else{
				sMessage += "δ�Ը��û������ȣ���������ҵ��"+"@";
			}
			
			
		}
		
		//�ۺ�����
		if(sStyle.equals("CreditAggreement"))
		{
			//-------��һ�����жϸ�ҵ��Ʒ���Ƿ񳬹���ȿ��Ƶ�ҵ��Ʒ���޶�-----------------
			attribute1 = (ASValuePool) CC.getSubpool().getAttribute(sBusinessType);
			if(attribute1==null)
			{
				sMessage += "δ�Ըò�Ʒ���ж�ȷ��䣡"+"@";
			}
			if(attribute1 != null)
			{
				//��ѯ�Ƿ������ȴ���
				sSelfUseFlag = Sqlca.getString("select SelfUseFlag from Business_Contract where SerialNo = '"+sBCSerialNo+"'");
				if(sSelfUseFlag==null) sSelfUseFlag="";
				
				if(!sSelfUseFlag.equals("1"))//���������
				{
					dSubLineSum = Double.valueOf( (String) attribute1.getAttribute("LineSum1*getERate(Currency,'01',ERateDate)")).doubleValue();//ȡ�ø�ҵ��Ʒ�ֶ������
					sCycFlag = (String) attribute1.getAttribute("Rotative");
					dBusinessSum =  Double.valueOf((String) CB.getOApply().getAttribute("BusinessSum")).doubleValue()
								   +  (sCycFlag.equals("1")?((Double)CB.getOALLBusiness().getAttribute("CycBCSum")).doubleValue():((Double)CB.getOALLBusiness().getAttribute("UnCycBCSum")).doubleValue())
								   + ((Double)CB.getOALLBusiness().getAttribute("TypeBASum")).doubleValue();
					System.out.println("dBusinessSum:"+dBusinessSum+"##dSubLineSum:"+dSubLineSum);
					if(dBusinessSum>dSubLineSum)
					{
						sMessage += "�����볬���ò�Ʒ������ƣ�"+"@";
					}
				}
				//�ж������Ƿ񳬹�
				double dBATermMonth = (CB.getOApply().getAttribute("TermMonth") == null || "".equals(CB.getOApply().getAttribute("TermMonth")) )? 0.0:Double.valueOf( (String) CB.getOApply().getAttribute("TermMonth")).doubleValue();
				double dSubCLTermMonth =  Double.valueOf( (String)  attribute1.getAttribute("TermMonth")).doubleValue();
				
				if(dBATermMonth>dSubCLTermMonth)
				{
					sMessage += "���������޳����ò�Ʒ����������ƣ�"+"@";
				}
				
				//�жϱ�֤���Ƿ񳬹������гжһ�Ʊ��
				if(sBusinessType.equals("2010"))
				{
					double dBailRatio = (CB.getOApply().getAttribute("BailRatio") == null || "".equals(CB.getOApply().getAttribute("BailRatio")) )? 0.0:Double.valueOf( (String) CB.getOApply().getAttribute("BailRatio")).doubleValue();
					double dSubCLBailRatio =  Double.valueOf( (String)  attribute1.getAttribute("BailRatio")).doubleValue();
					
					if(dBailRatio != dSubCLBailRatio)
					{
						sMessage += "�����뱣֤�������ò�Ʒ��ȱ�֤��������ȣ�"+"@";
					}
				}
				
			}else{
				sMessage += "δ�Ըò�Ʒ�����ȣ���������ҵ��"+"@";
			}
			
			//-------�ڶ������жϸÿͻ�����ҵ���Ƿ񳬹��ܶ�ȿ���-----------------
			attribute2 = CC.getCLpool();
			dTotalLineSum = (Double.valueOf((String)attribute2.getAttribute("LineSum1*getERate(Currency,'01',ERateDate)"))).doubleValue();//�ܶ��
			
			dBusinessTotalSum = (Double.valueOf((String) CB.getOApply().getAttribute("BusinessSum"))).doubleValue()
			   					+ CB.getBusinessTotalSum(CC);
			
			if(dBusinessTotalSum>dTotalLineSum)
			{
				sMessage += "�����볬���ۺ�ҵ�������ܶ�����ƣ�"+"@";
			}
			//-------���������жϸÿͻ�������Ʒ�Ƿ񳬹���������-----------------
			if(!sSelfUseFlag.equals("1"))//���������
			{
				Object[] sTmpContextKeys = CC.getSubpool().getKeys();
				
				for(int i=0;i<sTmpContextKeys.length;i++){
					String sTmpKey =(String)sTmpContextKeys[i];
					if(sTmpKey.equals(sBusinessType))
						continue;
					attribute1 = (ASValuePool) CC.getSubpool().getAttribute(sTmpKey);
					dSubLineSum = Double.valueOf((String)attribute1.getAttribute("LineSum1*getERate(Currency,'01',ERateDate)")).doubleValue();
					sCycFlag = (String) attribute1.getAttribute("Rotative");
					CB.ReSetALLBusiness(sTmpKey);
					
					dBusinessSum = (sCycFlag.equals("1")?((Double)CB.getOALLBusiness().getAttribute("CycBCSum")).doubleValue():((Double)CB.getOALLBusiness().getAttribute("UnCycBCSum")).doubleValue())
								   +  ((Double)CB.getOALLBusiness().getAttribute("TypeBASum")).doubleValue();
								
					if(dBusinessSum>dSubLineSum)
					{
						sMessage += "ҵ��Ʒ�֡�"+(String) attribute1.getAttribute("getBusinessName(BusinessType)")+"���Ѿ���������Ʒ������ƣ�"+"@";
					}
				}
			}
			else//����������
			{
				//��ͬ����;�Ķ������ҵ�����ڶ��֮��
				dSubLineSum=0;
				double dSubCLBailRatio =0,dBusinessTypeSum=0,dOtherSubLineSum=0;
				dBusinessTotalSum = CB.getBusinessTotalSum(CC);
				attribute1 = (ASValuePool) CC.getSubpool().getAttribute("2010");
				if(attribute1 != null){
					dSubLineSum = Double.valueOf( (String) attribute1.getAttribute("LineSum1*getERate(Currency,'01',ERateDate)")).doubleValue();
					sCycFlag = (String) attribute1.getAttribute("Rotative");
					dSubCLBailRatio =  (Double.valueOf( (String)  attribute1.getAttribute("BailRatio")).doubleValue()/100);//��֤�����
				}
				//��ͬ����;�Ķ�����³жһ�Ʊҵ��Ʒ��ҵ�����ڶ��֮��
				dBusinessTypeSum =  (sCycFlag.equals("1")?((Double)CB.getOALLBusiness().getAttribute("CycADBCSum")).doubleValue():((Double)CB.getOALLBusiness().getAttribute("UnCycADBCSum")).doubleValue())
			   					+ ((Double)CB.getOALLBusiness().getAttribute("TypeADBASum")).doubleValue();
				//�����Ʒ�Ķ���ܺ�
				dOtherSubLineSum = dTotalLineSum - dSubLineSum;
				
				//��ͬ����;�Ķ����������ҵ��Ʒ��ҵ�����ڶ��֮��
				double dOtherBusinessTypeSum = dBusinessTotalSum - dBusinessTypeSum;
				
				//�ɴ��ö���뵥��Ʒ�Ŀ��ö��֮��
				double dSpareSum = 0;
				if(dBusinessTypeSum >= dSubLineSum)
				{
					dSpareSum = (dOtherSubLineSum - dOtherBusinessTypeSum) - (dBusinessTypeSum - dSubLineSum) ; 
				}
				else 
				{
					if("2010".equals(sBusinessType))
					{
						dSpareSum = (dSubLineSum - dBusinessTypeSum)+(dOtherSubLineSum - dOtherBusinessTypeSum);
					}
					else
					{
						dSpareSum = (dSubLineSum - dBusinessTypeSum)*(1-dSubCLBailRatio)+(dOtherSubLineSum - dOtherBusinessTypeSum);
					}
				}
				//����������
				double BusinessSum = Double.valueOf((String) CB.getOApply().getAttribute("BusinessSum")).doubleValue();
				if(BusinessSum>dSpareSum)
				{
					attribute1 = (ASValuePool) CC.getSubpool().getAttribute(sBusinessType);
					sMessage += "ҵ��Ʒ�֡�"+(String) attribute1.getAttribute("getBusinessName(BusinessType)")+"���Ѿ������ɴ��ý�"+"@";
				}
			}
		}
		

		System.out.println("sMessage:"+sMessage);
		//---------------���������------------------
		CB.CleanCreditData();
		CB.getOALLBusiness().resetPool();
		CC.getCLpool().resetPool();
		CC.getSubpool().resetPool();
		CC.getMemberpool().resetPool();
		
		return sMessage;
	}

}
