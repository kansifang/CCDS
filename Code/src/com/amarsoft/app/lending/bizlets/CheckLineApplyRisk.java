/**
 * Author: --zwhu 2010-03-29
 * Tester:                               
 * Describe: --��ȼ��
 * Input Param:                          
 * 		ObjectNo :������  
 * 		ObjectType����������
 * 		LineID����ȱ��
 *      BusinessType��ҵ��Ʒ��
 * Output Param:   
 * 		sMessage             
 * HistoryLog:                           
 */
package com.amarsoft.app.lending.bizlets;

import java.text.SimpleDateFormat;
import java.util.GregorianCalendar;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.impl.tjnh_als.bizlets.CreditData;
import com.amarsoft.impl.tjnh_als.bizlets.Tools;
import com.amarsoft.script.AmarInterpreter;
import com.amarsoft.script.Anything;

public class CheckLineApplyRisk extends Bizlet {

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//��ȡ�������������ͺͶ�����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
         
		 //Э�����к�ͬͳ������
		CreditData AgreementContract = null;
		 //Э�����к�ͬͳ������
		CreditData AgreementApply = null;
		
		
		//��õ�ǰ����
		String sToday = StringFunction.getToday();
		//����ǰ
		java.util.GregorianCalendar gr=new GregorianCalendar(Integer.parseInt(sToday.substring(0,4)),Integer.parseInt(sToday.substring(5,7)),Integer.parseInt(sToday.substring(8, 10)));
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	    gr.add(GregorianCalendar.MONTH,-7); //����6����
		String Temp = sdf.format(gr.getTime());
		java.util.GregorianCalendar gr1=new GregorianCalendar(Integer.parseInt(sToday.substring(0,4)),Integer.parseInt(sToday.substring(5,7)),Integer.parseInt(sToday.substring(8, 10)));
	 
	    gr1.add(GregorianCalendar.DATE,30); //��30��
		String sMessage = "",sSql = "",sBusinessType = "",sBusinessTypeName = "",sCustomerType = "";
		//�����������Ҫ������ʽ���ͻ����롢�����������������
		String sVouchType = "",sCustomerID = "",sMainTable = "",sRelativeTable = "",sCustomerName = "",sNationRisk="";
		//����������ݴ��־,�Ƿ�ͷ���,�����ھ�ӪȨ
		String sTempSaveFlag = "",sLowRisk = "",sHasIERight="",sRelativeAgreement="",sVouchAggreement="",sConstructContractNo="",sAgriLoanClassify="",sBuildAgreement="";
		//����������������͡��������͡������˴���
		String sOccurType = "",sApplyType = "";
		//�����������Э������ҵ�����,��Э������������������,�Ƹõ������������ĸ�����ͻ�ҵ�����,�Ƹõ������������ĸ�����ͻ�ҵ��������������
		double dAgreementBalance=0.0,dAgreementApplySum=0.0,dCusAgreeBalance=0.0,dCusAgreeApplySum=0.0,dTermMonth=0.0;
		
		//���������ҵ����,�豸������
		double dBusinessSum = 0.0,dEquipmentSum=0.0,dTermDay=0.0; 
		//���������Ʊ������
		int iBillNum = 0,iNum = 0;
		//�����������ѯ�����
		ASResultSet rs = null,rs1 = null;	
		
		String sBusinessCurrency = "" ,sRateFloatType = "" ,sBaseRateType="",sBailCurrency="",sDrawingType="",sCorpusPayMethod="";
		double dBaseRate=0.0 ,dBailSum = 0.0,dBailRatio = 0.0 ,dPdgRatio = 0.0 ,dPdgSum = 0.0,dRateFloat=0.0,dBusinessRate=0.0;
		
		//���ݶ������ͻ�ȡ�������
		sSql = " select ObjectTable,RelativeTable from OBJECTTYPE_CATALOG where ObjectType = '"+sObjectType+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if (rs.next()) { 
			sMainTable = rs.getString("ObjectTable");
			sRelativeTable = rs.getString("RelativeTable");
			//����ֵת���ɿ��ַ���
			if (sMainTable == null) sMainTable = "";
			if (sRelativeTable == null) sRelativeTable = "";
		}
		rs.getStatement().close();
		
		if (!sMainTable.equals("")) {
			//--------------��һ�������������Ϣ�Ƿ�ȫ������---------------
			//����Ӧ�Ķ���������л�ȡ����Ʒ���͡�Ʊ����������������
			sSql = 	" select TempSaveFlag,BusinessSum*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum,BusinessType,getBusinessName(BusinessType) as BusinessTypeName, "+
					" BillNum,nvl(TermMonth,0) as TermMonth,nvl(TermDay,0) as TermDay , "+
					" VouchType,CustomerID,getCustomerType(CustomerID) as CustomerType,LowRisk,OccurType,ApplyType,RelativeAgreement,VouchAggreement,ConstructContractNo,AgriLoanClassify, " +
					" EquipmentSum*getERate(BusinessCurrency,'01',ERateDate) as EquipmentSum,BuildAgreement,CustomerName, "+
					" BusinessCurrency,RateFloatType,BaseRateType,BailCurrency,BaseRate,BailSum,BailRatio,PdgRatio,PdgSum,RateFloat,BusinessRate,NationRisk, "+
					" DrawingType,CorpusPayMethod "+
					" from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			while (rs.next()) { 			
				sTempSaveFlag = rs.getString("TempSaveFlag");	 
				dBusinessSum = rs.getDouble("BusinessSum");				
				sBusinessType = rs.getString("BusinessType");
				sBusinessTypeName = rs.getString("BusinessTypeName");
				iBillNum = rs.getInt("BillNum");
				dTermMonth = rs.getDouble("TermMonth");
				sVouchType = rs.getString("VouchType");
				sCustomerID = rs.getString("CustomerID");
				sCustomerName = rs.getString("CustomerName");
				sLowRisk = rs.getString("LowRisk");
				sOccurType = rs.getString("OccurType");
				sApplyType = rs.getString("ApplyType");
				sRelativeAgreement = rs.getString("RelativeAgreement");
				sVouchAggreement = rs.getString("VouchAggreement");
				sConstructContractNo = rs.getString("ConstructContractNo");
				sAgriLoanClassify = rs.getString("AgriLoanClassify");
				dEquipmentSum = rs.getDouble("EquipmentSum");
				sBuildAgreement = rs.getString("BuildAgreement"); 
				sCustomerType = rs.getString("CustomerType");
				dTermDay = rs.getDouble("TermDay");
				sBusinessCurrency = rs.getString("BusinessCurrency");
				sRateFloatType = rs.getString("RateFloatType");
				sBaseRateType = rs.getString("BaseRateType");
				sBailCurrency = rs.getString("BailCurrency");
				dBaseRate = rs.getDouble("BaseRate");
				dBailSum = rs.getDouble("BailSum");
				dBailRatio = rs.getDouble("BailRatio");
				dPdgRatio = rs.getDouble("PdgRatio");
				dPdgSum = rs.getDouble("PdgSum");
				dRateFloat = rs.getDouble("RateFloat");
				dBusinessRate = rs.getDouble("BusinessRate");
				sNationRisk = rs.getString("NationRisk");
				sDrawingType = rs.getString("DrawingType");
				sCorpusPayMethod = rs.getString("CorpusPayMethod");
				//����ֵת���ɿ��ַ���
				if (sTempSaveFlag == null) sTempSaveFlag = "";				
				if (sBusinessType == null) sBusinessType = "";
				if (sBusinessTypeName == null) sBusinessTypeName = "";
				if (sVouchType == null) sVouchType = "";
				if (sCustomerID == null) sCustomerID = "";
				if (sCustomerName == null) sCustomerName = "";
				if (sLowRisk == null) sLowRisk = "";
				if (sOccurType == null) sOccurType = "";
				if (sApplyType == null) sApplyType = "";
				if (sRelativeAgreement == null) sRelativeAgreement = "";
				if (sVouchAggreement == null) sVouchAggreement ="";
				if (sConstructContractNo == null) sConstructContractNo ="";
				if (sBuildAgreement == null) sBuildAgreement ="";
				if (sCustomerType == null) sCustomerType ="";
				if(sBusinessCurrency == null) sBusinessCurrency = "";
				if(sRateFloatType == null) sRateFloatType = "";
				if(sBaseRateType == null) sBaseRateType = "";
				if(sBailCurrency == null) sBailCurrency = "";
				if(sNationRisk == null) sNationRisk = "";
				if(sDrawingType == null) sDrawingType = "";
				if(sCorpusPayMethod == null) sCorpusPayMethod = "";
				if (sTempSaveFlag.equals("1")) {			
					sMessage = "����ҵ��"+sObjectNo+"�����������ϢΪ�ݴ�״̬��������д�����������Ϣ��������水ť��"+"@";
												
				}			
			}
			rs.getStatement().close();
		}
		
		//--------------��һ�����������ҵ�����Ʊ��ҵ����Ϣһ��---------------
		if(sBusinessType.length()>=4) {
			//�����Ʒ����Ϊ����ҵ��
			if(sBusinessType.substring(0,4).equals("1020"))	{
				sSql = 	" select count(SerialNo) from BILL_INFO  where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' "+
						" having sum(BillSum) = "+dBusinessSum+" ";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()) 
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum == 0)
					sMessage  += "����ҵ��"+sObjectNo+"�Ľ���Ʊ�ݽ���ܺͲ�����"+"@";
				
				sSql = 	" select count(SerialNo) from BILL_INFO  where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' "+
						" having count(SerialNo) = "+iBillNum+" ";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()) 
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum == 0)
					sMessage += "����ҵ��"+sObjectNo+"�������Ʊ�������������Ʊ������������"+"@";					
			}					
		}

		//------------�ڶ�����΢С��ҵֻ�ܰ��������ʽ������гжһ�Ʊ���֡����гжһ�Ʊҵ�� ������ʽΪһ���������ʽΪ���»򰴼�����--------------
		String sSmallEntFlag="",sSetupDate="";
		if(sCustomerType.startsWith("01"))
		{
			//�ж��Ƿ�Ϊ΢С��ҵSmallEntFlag
			sSql = "select SmallEntFlag,SetupDate from ENT_INFO where  CustomerID ='"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sSmallEntFlag = rs.getString("SmallEntFlag");
				sSetupDate = rs.getString("SetupDate");
				if(sSmallEntFlag == null || "NULL".equals(sSmallEntFlag)) sSmallEntFlag ="";
				if(sSetupDate == null || "NULL".equals(sSetupDate)) sSetupDate ="";
			}
			rs.getStatement().close();
			if(sSmallEntFlag.equals("1"))
			{
				double days  = Sqlca.getDouble("select  days(current date) - days(date('"+sSetupDate.replaceAll("/", "-")+"'))  as days from (values 1) as a").doubleValue();
				System.out.println(days);
				if(!(sBusinessType.startsWith("1010") || sBusinessType.equals("1020010") || sBusinessType.equals("2010")))
				{
					sMessage  += "΢С��ҵ�ͻ����ܰ���"+sBusinessTypeName+"ҵ��!"+"@";
				}
				if(days<365){
					sMessage  += "΢С��ҵ�ͻ���Ӫ���ޱ�����ڵ���1��!"+"@";
				}
				if(sBusinessType.startsWith("1010")){
					if(!("01".equals(sDrawingType))){
						sMessage  += "����ҵ��"+sObjectNo+"����ʽ����Ϊһ�������!"+"@";
					}
					if(!("2".equals(sCorpusPayMethod)||"3".equals(sCorpusPayMethod))){
						sMessage  += "����ҵ��"+sObjectNo+"�Ļ��ʽ���谴�»���򰴼�����!"+"@";
					}
				}
				if("1020010".equals(sBusinessType)){
					if(!("2".equals(sCorpusPayMethod)||"3".equals(sCorpusPayMethod))){
						sMessage  += "����ҵ��"+sObjectNo+"�Ļ��ʽ���谴�»���򰴼�����!"+"@";
					}
				}
				
			}
			
		}
		
		//--------------������������֤���´�������������֤��������������֤Ѻ�������֣�ȡ�����ƣ�����������Ѻ�������֡�������ҵ��Ʊ���ʡ�����������֤��Ϣ---------------1080020,1080080,1080090,1080030,1080035
		if (sBusinessType.equals("1080020") || sBusinessType.equals("1080080") ||sBusinessType.equals("1080090") )	{
			sSql = 	" select count(SerialNo) from LC_INFO where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum == 0)
	     		sMessage  += "����ҵ��"+sObjectNo+"��"+sBusinessTypeName+"û���������֤��Ϣ��"+"@";
		}

		//--------------���Ĳ����������´�������ͬ���´�����������ó�׺�ͬ��Ϣ---------------
		if (sBusinessType.equals("1080020") || sBusinessType.equals("1080010")) {
			sSql = 	" select count(SerialNo) from CONTRACT_INFO where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum == 0)			     	
	     		sMessage  += "����ҵ��"+sObjectNo+"��"+sBusinessTypeName+"û�����ó�׺�ͬ��Ϣ��"+"@";
		}

		//--------------���岽�����ڱ������ڱ��������ط�Ʊ��Ϣ---------------
		if (sBusinessType.equals("1090020") ||  sBusinessType.equals("1090030")) {
			sSql = 	" select count(SerialNo) from INVOICE_INFO where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum == 0)			     	
	     		sMessage  += "����ҵ��"+sObjectNo+"��"+sBusinessTypeName+"û����ط�Ʊ��Ϣ��"+"@";
		}
		
		//--------------���������Ƿ��н����ھ�ӪȨ---------------
		if (sBusinessType.substring(0, 4).equals("1080"))
		{
		sSql = "select HasIERight from ENT_INFO where CustomerID = '"+sCustomerID+"' ";
		rs = Sqlca.getASResultSet(sSql);
	    if(rs.next())
	    	sHasIERight = rs.getString("HasIERight");
	    rs.getStatement().close();
	    if(sHasIERight==null) sHasIERight="";
		if(sHasIERight.equals("2"))
	   		sMessage  += "����ҵ��"+sObjectNo+"��"+sBusinessTypeName+"��Ҫ�н����ھ�ӪȨ��"+"@";
		}
	
		//--------------�ڶ�ʮ����:�̶��ʲ�����(����������������ʩ�������������Ŀ�����Ӫ����ҵ��Ѻ�����������Ŀ��������ز�������ز�����������ش������)------------------------------
		if ("1030010,1030015,1030020,1030030,1050010,1050020".indexOf(sBusinessType) >-1)	{
			sSql = 	" select count(ProjectNo) from PROJECT_RELATIVE where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum == 0)
	     		sMessage  += "����ҵ��"+sObjectNo+"��"+sBusinessTypeName+"û�������Ŀ��Ϣ��"+"@";
		}
		
		
		//------------�ڶ�ʮ�˲���ũ����ɫ������ͻ��Ƿ��а����ҵ���Ȩ��------------------
		AmarInterpreter interpreter = new AmarInterpreter();
		Anything aReturn1 =  interpreter.explain(Sqlca,"!BusinessManage.CheckCreditCondition("+sBusinessType+","+sCustomerID+")");
		String TempValue = aReturn1.stringValue();
		
		if(!TempValue.equals("") && !TempValue.equals("PASS"))
			sMessage  +=  TempValue+"@";
		
		//==============================Э����=============================================
		if(!"".equals(sVouchAggreement) || !"".equals(sConstructContractNo) || !"".equals(sBuildAgreement)){
		String sSql1 = " Select SerialNo,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum," +
				 	   " BusinessCurrency, ConstructContractNo,BuildAgreement," +
					   " BusinessType,nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate) as Balance,VouchType,CustomerID,VouchAggreement " +
					   " from Business_Contract BC Where 1=1 and (FinishDate is null or FinishDate ='')  " ;
		 
		 String sSql2 = " select SerialNo,nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum,CustomerID," +
				 		" BusinessCurrency,ConstructContractNo,BuildAgreement,BusinessType,VouchType,VouchAggreement" +
				 		" from Business_Apply BA " +
				 		" where exists (select 'X' from Flow_Object FO where BA.SerialNo = FO.ObjectNo and FO.ObjectType = 'CreditApply' and FO.PhaseType in ('1020','1040') )" +
				 		" and (ContractExsitFlag ='' or ContractExsitFlag is null) ";
		 
		 String sEntAgreementNo ="",sAgreeMaturity="",sParentAgreementNo="";
		 double dCompareSum =0.0,dVouchTotalSum=0.0,dTopVouchSum=0.0,dSingleSum=0.0,dEntTermMonth=0.0;
		//-----------����ʮ��������Э����-----------------------------------------------
		if(!"".equals(sVouchAggreement)){
			 sSql = " select SerialNo,Maturity,VouchTotalSum*getERate(Currency,'01','') as VouchTotalSum," +
			 		" TopVouchSum*getERate(Currency,'01','') as TopVouchSum,TermMonth," +
			 		" nvl(SingleSum,0) as SingleSum from Ent_Agreement where AgreementType='VouchAgreement' and SerialNo ='"+sVouchAggreement+"' ";
			 rs = Sqlca.getASResultSet(sSql);
			 if(rs.next())
			 {
				 sEntAgreementNo = rs.getString("SerialNo");
				 sAgreeMaturity  = rs.getString("Maturity");
				 dVouchTotalSum = rs.getDouble("VouchTotalSum");
				 dTopVouchSum = rs.getDouble("TopVouchSum");
				 dSingleSum = rs.getDouble("SingleSum");
				 dEntTermMonth = rs.getDouble("TermMonth");
				 
				 if(sEntAgreementNo==null) sEntAgreementNo="";
				 if(sAgreeMaturity==null) sAgreeMaturity="";
			 }
			 rs.getStatement().close();
			 if(sAgreeMaturity.compareTo(sToday)<0)
			 {
				 sMessage  +=  "����ҵ��"+sObjectNo+"�ĵ���Э���ѵ��ڣ�����ʹ�ã�"+"@";
			 }else
			 {
				 sSql = sSql1+ " and VouchAggreement ='"+sVouchAggreement+"'";
				 AgreementContract = new CreditData(Sqlca,sSql);
				 sSql = sSql2+ " and VouchAggreement ='"+sVouchAggreement+"'";
				 AgreementApply = new CreditData(Sqlca,sSql);
				 
				 dAgreementBalance = AgreementContract.getSum("Balance","VouchAggreement",Tools.EQUALS,sVouchAggreement);//ҵ�����������
				 
				 dAgreementApplySum = AgreementApply.getSum("BusinessSum","VouchAggreement",Tools.EQUALS,sVouchAggreement);//��;���
				 //�������
				 dCusAgreeBalance = AgreementContract.getSum("Balance","CustomerID",Tools.EQUALS,sCustomerID);
				 //������;
				 dCusAgreeBalance = AgreementApply.getSum("BusinessSum","CustomerID",Tools.EQUALS,sCustomerID);
				 
				 if(sAgriLoanClassify.equals("") || sAgriLoanClassify.equals("111"))//����ũ
					 dCompareSum = dVouchTotalSum-dAgreementBalance-dAgreementApplySum;
				 else
					 dCompareSum = dTopVouchSum-dAgreementBalance-dAgreementApplySum;
				 //System.out.println("dTopVouchSum:"+dTopVouchSum+"*dAgreementBalance:"+dAgreementBalance+"&dAgreementApplySum:"+dAgreementApplySum);
				 if(dBusinessSum>dCompareSum)
					 sMessage  +=  "����ҵ��"+sObjectNo+"�ĳ�������Э�鵣����Ȼ��ߵ����ܶ�����ƣ�"+"@";
					 
				 dCompareSum = dSingleSum-dCusAgreeBalance-dCusAgreeBalance;
				 if(dBusinessSum>dCompareSum)
					 sMessage  +=  "����ҵ��"+sObjectNo+"�ĳ�������Э�鵥����ߵ����������!"+"@";
				 
				 if(dTermMonth >dEntTermMonth )
					 sMessage  +=  "����ҵ��"+sObjectNo+"�ĳ�������Э�����������������!"+"@";
				 
			 }
		}
			//-----------����ʮһ�������̻�е���-----------------------------------------------	 
			 double dCreditSum=0.0,dLimitSum=0.0,dLimitLoanTerm=0.0,dLimitLoanRatio=0.0;
			 if(!"".equals(sConstructContractNo)){
				 sSql = " select SerialNo,ObjectNo,nvl(CreditSum,0)*getERate(Currency,'01','') as CreditSum, " +
				 		" nvl(LimitSum,0)*getERate(Currency,'01','') as LimitSum ,LimitLoanTerm,LimitLoanRatio " +
				 		" from Dealer_Agreement where  SerialNo ='"+sConstructContractNo+"' ";
				 rs = Sqlca.getASResultSet(sSql);
				 if(rs.next())
				 {
					 sEntAgreementNo = rs.getString("SerialNo");
					 sParentAgreementNo = rs.getString("ObjectNo");
					 dCreditSum = rs.getDouble("CreditSum");
					 dLimitSum = rs.getDouble("LimitSum");
					 dLimitLoanTerm = rs.getDouble("LimitLoanTerm");
					 dLimitLoanRatio = rs.getDouble("LimitLoanRatio");
					 
					 if(sEntAgreementNo==null) sEntAgreementNo="";
					 if(sAgreeMaturity==null) sAgreeMaturity="";
				 }
				 rs.getStatement().close();
				 
				 sAgreeMaturity = Sqlca.getString("select Maturity from Ent_Agreement where AgreementType='ProjectAgreement' and SerialNo = '"+sParentAgreementNo+"'");
				 if(sAgreeMaturity == null) sAgreeMaturity= "";
				 if(sAgreeMaturity.compareTo(sToday)<0)
				 {
					 sMessage  +=  "����ҵ��"+sObjectNo+"�Ĺ��̻�е��Э���ѵ��ڣ�����ʹ��!"+"@";
				 }else
				 {
					 sSql = sSql1+ " and ConstructContractNo ='"+sConstructContractNo+"'";
					 AgreementContract = new CreditData(Sqlca,sSql);
					 sSql = sSql2+ " and ConstructContractNo ='"+sConstructContractNo+"'";
					 AgreementApply = new CreditData(Sqlca,sSql);
					 
					
					 dAgreementBalance = AgreementContract.getSum("Balance","ConstructContractNo",Tools.EQUALS,sConstructContractNo);//ҵ�����������
					 dAgreementApplySum = AgreementApply.getSum("BusinessSum","ConstructContractNo",Tools.EQUALS,sConstructContractNo);//��;���
					 //�������
					 dCusAgreeBalance = AgreementContract.getSum("Balance","CustomerID",Tools.EQUALS,sCustomerID);
					 //������;
					 dCusAgreeBalance = AgreementApply.getSum("BusinessSum","CustomerID",Tools.EQUALS,sCustomerID);
					 System.out.println("dCreditSum:"+dCreditSum+"%dAgreementBalance:"+dAgreementBalance+"*dAgreementApplySum:"+dAgreementApplySum);
					 dCompareSum = dCreditSum-dAgreementBalance-dAgreementApplySum;
					 if(dBusinessSum>dCompareSum)
						 sMessage  +=  "����ҵ��"+sObjectNo+"�ĳ����þ����̴�Э��������!"+"@";
						 
					 dCompareSum = dLimitSum-dCusAgreeBalance-dCusAgreeBalance;
					 if(dBusinessSum>dCompareSum)
						 sMessage  +=  "����ҵ��"+sObjectNo+"�ĳ������������̴�Э����߶�����!"+"@";
					 
					 if(dTermMonth >dLimitLoanTerm )
						 sMessage  +=  "����ҵ��"+sObjectNo+"�ĳ��������̴�Э����ߴ�����������!"+"@";
					
					 dCompareSum = dLimitLoanRatio*dEquipmentSum;
					 if(dBusinessSum>dCompareSum)
						 sMessage  +=  "����ҵ��"+sObjectNo+"�ĳ��������̴�Э����ߴ����������!"+"@";
					 
				 }
				 
			 }
			 
			//-----------����ʮ������¥���Э����--------- 
			 double  dLoanSum =0.0;
			if(!"".equals(sBuildAgreement)){
					 sSql = " select SerialNo,Maturity,LoanSum*getERate(Currency,'01','') as LoanSum " +
				 		    " from Ent_Agreement where AgreementType='BuildAgreement' and SerialNo ='"+sBuildAgreement+"' ";
				 rs = Sqlca.getASResultSet(sSql);
				 if(rs.next())
				 {
					 sEntAgreementNo = rs.getString("SerialNo");
					 sAgreeMaturity  = rs.getString("Maturity");
					 dLoanSum = rs.getDouble("LoanSum");
					 
					 if(sEntAgreementNo==null) sEntAgreementNo="";
					 if(sAgreeMaturity==null) sAgreeMaturity="";
				 }
				 rs.getStatement().close();
				 if(sAgreeMaturity.compareTo(sToday)<0)
				 {
					 sMessage  +=  "����ҵ��"+sObjectNo+"��¥���Э���ѵ��ڣ�����ʹ��!"+"@";
				 }else
				 {
					 sSql = sSql1+ " and BuildAgreement ='"+sBuildAgreement+"'";
					 AgreementContract = new CreditData(Sqlca,sSql);
					 sSql = sSql2+ " and BuildAgreement ='"+sBuildAgreement+"'";
					 AgreementApply = new CreditData(Sqlca,sSql);
					 
					 dAgreementBalance = AgreementContract.getSum("Balance","BuildAgreement",Tools.EQUALS,sBuildAgreement);//ҵ�����������
					 dAgreementApplySum = AgreementApply.getSum("BusinessSum","BuildAgreement",Tools.EQUALS,sBuildAgreement);//��;���
					 
					 dCompareSum = dLoanSum-dAgreementBalance-dAgreementApplySum;
					 if(dBusinessSum>dCompareSum)
						 sMessage  +=  "����ҵ��"+sObjectNo+"�ĳ���¥���Э���ܶ������!"+"@";
						 
				 }
			}
				
				AgreementContract.closeCreditData();
				AgreementApply.closeCreditData();
		
		}
		System.out.println("sMessage:"+sMessage);
		return sMessage;
	 }
}
