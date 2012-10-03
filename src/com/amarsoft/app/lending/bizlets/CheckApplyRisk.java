/*
		Author: --zywei 2005-08-05
		Tester:
		Describe: --̽���������
		Input Param:
				ObjectType: ��������
				ObjectNo: ������
		Output Param:
				Message��������ʾ��Ϣ
		HistoryLog: lpzhang 2009-8-24 for TJ �Ӽ����
*/

package com.amarsoft.app.lending.bizlets;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.GregorianCalendar;

import com.amarsoft.app.util.ChangTypeCheckOut;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.impl.tjnh_als.bizlets.CreditData;
import com.amarsoft.impl.tjnh_als.bizlets.Tools;
import com.amarsoft.impl.tjnh_als.bizlets.WhereClause;
import com.amarsoft.script.AmarInterpreter;
import com.amarsoft.script.Anything;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.DataConvert;


public class CheckApplyRisk extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//��ȡ�������������ͺͶ�����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
         
		ASValuePool oAgreementBusiness = new ASValuePool();
		 //Э�����к�ͬͳ������
		CreditData AgreementContract = null;
		 //Э�����к�ͬͳ������
		CreditData AgreementApply = null;
		
		
		//��õ�ǰ����
		String sToday = StringFunction.getToday();
		//���ȥ��ͬ��
		String sMonth = String.valueOf(Integer.parseInt(sToday.substring(0,4))-1)+sToday.substring(4,7);
		
		//����ǰ
		java.util.GregorianCalendar gr=new GregorianCalendar(Integer.parseInt(sToday.substring(0,4)),Integer.parseInt(sToday.substring(5,7)),Integer.parseInt(sToday.substring(8, 10)));
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
	    gr.add(GregorianCalendar.MONTH,-7); //����6����
		String Temp = sdf.format(gr.getTime());
		
		String sMiddleYear = String.valueOf(Integer.parseInt(Temp.substring(0,4)))+"/"+Temp.substring(5,7);
		
		
		java.util.GregorianCalendar gr1=new GregorianCalendar(Integer.parseInt(sToday.substring(0,4)),Integer.parseInt(sToday.substring(5,7)),Integer.parseInt(sToday.substring(8, 10)));
	 
	    gr1.add(GregorianCalendar.DATE,30); //��30��
	    String sAfterThirDay = sdf.format(gr.getTime());
		
		
			
		//System.out.println("sMiddleYear:"+sMiddleYear); 
		 
		//�����������ʾ��Ϣ��SQL��䡢��Ʒ���͡��ͻ�����
		String sMessage = "",sSql = "",sBusinessType = "",sCustomerType = "", sBizHouseFlag = "";
		//�����������Ҫ������ʽ���ͻ����롢�����������������
		String sVouchType = "",sCustomerID = "",sMainTable = "",sRelativeTable = "",sCustomerName = "",sNationRisk="",sCreditSmallEntFlag="";
		//����������ݴ��־,�Ƿ�ͷ���,�����ھ�ӪȨ
		String sTempSaveFlag = "",sLowRisk = "",sHasIERight="",sRelativeAgreement="",sVouchAggreement="",sConstructContractNo="",sAgriLoanClassify="",sBuildAgreement="";
		//����������������͡��������͡������˴��롢�������
		String sOccurType = "",sApplyType = "",sGuarantorID = "",sOperateOrgID = "",sChangType = "";
		//�����������Э������ҵ�����,��Э������������������,�Ƹõ������������ĸ�����ͻ�ҵ�����,�Ƹõ������������ĸ�����ͻ�ҵ��������������
		double dAgreementBalance=0.0,dAgreementApplySum=0.0,dCusAgreeBalance=0.0,dCusAgreeApplySum=0.0,dTermMonth=0.0;
		
		//���������ҵ����,�豸������
		double dBusinessSum = 0.0,dEquipmentSum=0.0,dTermDay=0.0,dSmallEntSum=0.0,dBusinessSum1=0.0; 
		//���������Ʊ������,ʵ�ʿ����ˣ��߹ܣ���
		int iBillNum = 0,iNum = 0,iCount = 0;
		//�����������ѯ�����
		ASResultSet rs = null,rs1 = null;	
		
		String sBusinessCurrency = "" ,sRateFloatType = "" ,sBaseRateType="",sBailCurrency="",sDrawingType="",sCorpusPayMethod="",sInputOrgID="";
		double dBaseRate=0.0 ,dBailSum = 0.0,dBailRatio = 0.0 ,dPdgRatio = 0.0 ,dPdgSum = 0.0,dRateFloat=0.0,dBusinessRate=0.0;
		String sSmallEntFlag="",sSetupDate="",sAgriLoanFlag = "";
		
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
			sSql = 	" select TempSaveFlag,BusinessSum*getERate(BusinessCurrency,'01',ERateDate) as BusinessSum,BusinessSum as BusinessSum1,BusinessType,BillNum,nvl(TermMonth,0) as TermMonth,nvl(TermDay,0) as TermDay , "+
					" VouchType,CustomerID,getCustomerType(CustomerID) as CustomerType,LowRisk,OccurType,ApplyType,RelativeAgreement,VouchAggreement,ConstructContractNo,AgriLoanClassify,AgriLoanFlag, " +
					" EquipmentSum*getERate(BusinessCurrency,'01',ERateDate) as EquipmentSum,BuildAgreement,CustomerName, "+
					" BusinessCurrency,RateFloatType,BaseRateType,BailCurrency,BaseRate,BailSum,BailRatio,PdgRatio,PdgSum,RateFloat,BusinessRate,NationRisk, "+
					" DrawingType,CorpusPayMethod,InputOrgID,OperateOrgID "+
					" from "+sMainTable+" where SerialNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
			while (rs.next()) { 			
				sTempSaveFlag = rs.getString("TempSaveFlag");	 
				dBusinessSum = rs.getDouble("BusinessSum");		
				dBusinessSum1 = rs.getDouble("BusinessSum1");	
				sBusinessType = rs.getString("BusinessType");
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
				sInputOrgID = rs.getString("InputOrgID");
				sOperateOrgID = rs.getString("OperateOrgID");
				sAgriLoanFlag = rs.getString("AgriLoanFlag");
				//����ֵת���ɿ��ַ���
				if (sTempSaveFlag == null) sTempSaveFlag = "";				
				if (sBusinessType == null) sBusinessType = "";
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
				if(sInputOrgID == null) sInputOrgID = "";
				if(sOperateOrgID == null) sOperateOrgID ="";
				if(sAgriLoanClassify == null) sAgriLoanClassify = "";
				if(sAgriLoanFlag == null) sAgriLoanFlag ="";
				if (sTempSaveFlag.equals("1")) {			
					sMessage = "���������ϢΪ�ݴ�״̬��������д�����������Ϣ��������水ť��"+"@";
												
				}			
			}
			rs.getStatement().close();
		}
		
		
		//--------------�ڶ��������ͻ��ſ��Ƿ�ȫ������---------------	
		if (sCustomerType.length()>1&&sCustomerType.substring(0,2).equals("01")){ //��˾�ͻ�
			
			sSql = "select SmallEntFlag,SetupDate,TempSaveFlag from ENT_INFO where  CustomerID ='"+sCustomerID+"'";
			rs= Sqlca.getASResultSet(sSql);
			if(rs.next()){
				sSmallEntFlag = rs.getString("SmallEntFlag");
				sSetupDate = rs.getString("SetupDate");
			}
			rs.getStatement().close();
			if(sSmallEntFlag == null || "NULL".equals(sSmallEntFlag)) sSmallEntFlag ="";
			if(sSetupDate == null || "NULL".equals(sSetupDate)) sSetupDate ="";
			//ȡ�ÿͻ���Ӧ ʵ�ʿ����ˣ��߹ܣ���Ϣ����
			iCount = Integer.parseInt(Sqlca.getString("select count(*) from CUSTOMER_RELATIVE where RelationShip = '0109' and CustomerID = '"+sCustomerID+"'"));
			if(iCount<1)
			{
				sMessage += "�ͻ��߹���Ϣ�б���¼�뵣��ְ��Ϊʵ�ʿ�������Ϣ��"+"@";
			}		
		}
		if (sCustomerType.length()>1&&sCustomerType.substring(0,2).equals("03")) //��ظ���
			sSql = " select TempSaveFlag from IND_INFO where CustomerID = '"+sCustomerID+"' ";
		
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sTempSaveFlag = rs.getString("TempSaveFlag");
		}
		rs.getStatement().close();
		
		if (sTempSaveFlag == null) sTempSaveFlag = "";
		if (sTempSaveFlag.equals("1"))
			sMessage += "�ͻ��ſ���ϢΪ�ݴ�״̬��������д��ͻ��ſ���Ϣ��������水ť��"+"@";
		
		//--------------���¿ͻ�������������--------------	
		Sqlca.executeSQL(" update FLOW_OPINION SET BusinessCurrency ='"+sBusinessCurrency+"',BusinessSum = "+dBusinessSum1+","+
				 " TermMonth = "+dTermMonth+",TermDay = "+dTermDay+",BaseRateType = '"+sBaseRateType+"',CustomerName = '"+sCustomerName+"',"+
				 " RateFloatType = '"+sRateFloatType+"',RateFloat="+dRateFloat+",BailCurrency = '"+sBailCurrency+"',"+
				 " BusinessRate = "+dBusinessRate+",BailRatio="+dBailRatio+",BailSum = "+dBailSum+","+
				 " PdgRatio = "+dPdgRatio+",PdgSum = "+dPdgSum+",BaseRate = "+dBaseRate+
				 " where SerialNo = "+
				 " (select SerialNo from  FLOW_TASK where ObjectNo = '"+sObjectNo+"' and ObjectType ='CreditApply'  order by SerialNo desc fetch first 1 rows only)" );
		
		if(sBusinessType.endsWith("3015"))//ͬҵ����
		{
			return sMessage ;
		}
		
		if("3010,3040,3050,3060,3015".indexOf(sBusinessType) > -1){
			String sCreditLineID = Sqlca.getString(" select LineID from CL_INFO where ApplySerialNo = '"+sObjectNo+"' and  (ParentLineID ='' or ParentLineID is null) ");
			if(sCreditLineID == null) sCreditLineID ="";
			
			double dLineSum = Sqlca.getDouble("select sum(Nvl(LineSum1,0)*getERate(Currency,'01',ERateDate)) from CL_INFO where ParentLineID = '"+sCreditLineID+"'").doubleValue();
			if(Math.abs((dLineSum-dBusinessSum))>1){
				sMessage  += "���Ŷ�����ѷ���Ķ���ܺͲ���ȣ������·����ȣ�"+"@";
			}
			if("3050".equals(sBusinessType)){
				sSql = "select count(*) from CUSTOMER_RELATIVE where RelationShip like '0501%'and CustomerID='"+sCustomerID+"'";
				rs = Sqlca.getASResultSet(sSql);
				int NumTemp=0;
				if(rs.next())
					 NumTemp = rs.getInt(1);
				rs.getStatement().close();
				if(NumTemp < 5)
				{	
					sMessage += "�ÿͻ�����ũ������С���Աδ�ﵽ5�������ܰ����ҵ��"+"@";
				}
			}	
		}
		if(sLowRisk == null || sLowRisk.equals(""))
		{
			Sqlca.executeSQL("update Business_Apply set LowRisk ='0' where SerialNo = '"+sObjectNo+"' ");
		}
		if("IndependentApply".equals(sApplyType))//��Ե���
		{
			Sqlca.executeSQL("update Business_Apply set LowRisk ='0' where SerialNo = '"+sObjectNo+"' ");
			//������Ҫ������ʽ��Ϊ����������Ҵ浥��Ѻ������������ծȯ��Ѻ��ʱ
			if("0401010".equals(sVouchType)||"0402010".equals(sVouchType))
			{
				Sqlca.executeSQL("update Business_Apply set LowRisk ='1' where SerialNo = '"+sObjectNo+"' ");
			}		
		
			//������Ҫ������ʽ��Ϊ��100%��֤��,�ж϶�ȷ���ҵ���Ƿ��в����ڵͷ���ҵ��Ʒ�֡�����������������гжһ�Ʊ����
			//����������֤�������������Ա���������Ͷ�걣������Լ������Ԥ��������������ά�ޱ������������Ᵽ��������
			//����������֤Ѻ�㡱������������֤���֡�����ί�д��
			if("0105080".equals(sVouchType)&&"2050010,2010,2050030,2040010,2040020,2040030,2030060,2040050,2040110".indexOf(sBusinessType)>-1)
			{
				Sqlca.executeSQL("update Business_Apply set LowRisk ='1' where SerialNo = '"+sObjectNo+"' ");
			}
			//------��������֤Ѻ��,��������֤����ֱ������Ϊ�ͷ���ҵ��---------
			if( "1080030".equals(sBusinessType)||"1080035".equals(sBusinessType))
			{
				Sqlca.executeSQL("update Business_Apply set LowRisk ='1' where SerialNo = '"+sObjectNo+"' ");
			}
		}
		//------���״�,ί�д���ֱ������Ϊ�ͷ���ҵ��---------
		if(sNationRisk.equals("1") || "1140110".equals(sBusinessType)|| "2070".equals(sBusinessType) ||"2110040".equals(sBusinessType))
		{
			Sqlca.executeSQL("update Business_Apply set LowRisk ='1' where SerialNo = '"+sObjectNo+"' ");
		}
		//�жϸñ������Ƿ���1��ҵ��Ʒ��Ϊ����������ϴ��&&2����������Ϊ�������&&3���������Ϊ������˱����
		//�����������������У�鵣����Ϣ-----------------------------------------add by wangdw
		if(ChangTypeCheckOut.getInstance().changtypecheckout_gjj(Sqlca, sMainTable, sObjectNo))
		{
			//�ж��жϸñ������Ƿ���1��ҵ��Ʒ��Ϊ���ǹ�������ϴ��&&2����������Ϊ�������&&3���������Ϊ���ǵ��������
			//�����������������У�鵣����Ϣ-----------------------------------------add by wangdw 2012-06-01
			if(ChangTypeCheckOut.getInstance().changtypecheckout_isnotgjj(Sqlca, sMainTable, sObjectNo))
			{	
			//--------------����������鵣����Ϣ�Ƿ�ȫ������---------------
			//����ҵ�������Ϣ�е���Ҫ������ʽΪ���ã����ж��Ƿ����뵣����Ϣ����������˵�����Ϣ������ʾ
			if (sVouchType.equals("005")) {
				sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
						" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType='GuarantyContract') "+
						" having count(SerialNo) > 0";

				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()) 
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum > 0)
					sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ���ã���Ӧ�����뵣����Ϣ���������Ҫ������ʽ��ɾ��������Ϣ��"+"@";
			}
			//����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤�����Ѻ������Ѻ�����ж��Ƿ����뵣����Ϣ,���ڳ������ñ������ʣ�
			//����Ʊ�����֣���������֤Ѻ��,����͢ȡ���ÿ���
			else if(!"1080030".equals(sBusinessType)&&!"1080035".equals(sBusinessType)
					&&!"1080055".equals(sBusinessType)&&!"1080060".equals(sBusinessType)) 
			{
				if(sVouchType.length()>=3) {
					//����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤,�������뱣֤������Ϣ
					if(sVouchType.substring(0,3).equals("010") && !sVouchType.equals("0105080"))
					{
						//��鵣����ͬ��Ϣ���Ƿ���ڱ�֤����
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '010%' having count(SerialNo) > 0 ";
						rs = Sqlca.getASResultSet(sSql);
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						
						if(iNum == 0)
							sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ��֤����û�������뱣֤�йصĵ�����Ϣ���������Ҫ������ʽ�����뱣֤������Ϣ��"+"@";
					}
					
					//����ҵ�������Ϣ�е���Ҫ������ʽΪ��Ѻ,���������Ѻ������Ϣ�����һ���Ҫ����Ӧ�ĵ�Ѻ����Ϣ
					if(sVouchType.substring(0,3).equals("020"))	{
						//��鵣����ͬ��Ϣ���Ƿ���ڵ�Ѻ����
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '050%' ";
						rs = Sqlca.getASResultSet(sSql);
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						
						if(iNum <= 0)
							sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ��Ѻ����û���������Ѻ�йصĵ�����Ϣ���������Ҫ������ʽ�������Ѻ������Ϣ��"+"@";
						else {							
							sSql = " select SerialNo from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from APPLY_RELATIVE where "+
						       " SerialNo= '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and GuarantyType in ('050')";
							rs = Sqlca.getASResultSet(sSql);
							while(rs.next()) //ѭ���ж�ÿ����Ѻ��ͬ
							{
								String sGCNo =  rs.getString("SerialNo");  //��õ�����ͬ��ˮ��
								
								String sSql1 = " select Count(GuarantyID) from GUARANTY_INFO "+
								       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType='"+sObjectType+"'"+
								       " and ObjectNo ='"+sObjectNo+"' and ContractNo = '"+sGCNo+"') "; 
								rs1 = Sqlca.getASResultSet(sSql1);
								if(rs1.next())
								{
									iNum = rs1.getInt(1); 
								}
								rs1.getStatement().close();
								//�жϵ�����ͬ�����Ƿ��ж�Ӧ��
								if (iNum <= 0)
								{
								    sMessage += "������Ϣ���Ϊ:"+sGCNo+"�ĵ�����Ϣ�����޶�Ӧ�ĵ�Ѻ��Ϣ��@";
								}
						     }
						     rs.getStatement().close();
						}												
					}
					
					//����ҵ�������Ϣ�е���Ҫ������ʽΪ��Ѻ,����������Ѻ������Ϣ�����һ���Ҫ����Ӧ��������Ϣ
					if(sVouchType.substring(0,3).equals("040"))	{
						//��鵣����ͬ��Ϣ���Ƿ������Ѻ����
						sSql = 	" select count(SerialNo) from GUARANTY_CONTRACT where SerialNo in (Select ObjectNo "+
								" from "+sRelativeTable+" where SerialNo='"+sObjectNo+"' and ObjectType = 'GuarantyContract') "+
								" and GuarantyType like '060%' ";
						rs = Sqlca.getASResultSet(sSql);
						if(rs.next()) 
							iNum = rs.getInt(1);
						rs.getStatement().close();
						if(iNum <= 0)								
							sMessage  += "��ҵ����ѡ�����Ҫ������ʽΪ��Ѻ����û����������Ѻ�йصĵ�����Ϣ���������Ҫ������ʽ��������Ѻ������Ϣ��"+"@";
						else {
							sSql = " select SerialNo from GUARANTY_CONTRACT where SerialNo in (select ObjectNo from APPLY_RELATIVE where "+
						       " SerialNo= '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and GuarantyType in ('060')";
							rs = Sqlca.getASResultSet(sSql);
							while(rs.next()) //ѭ���ж�ÿ����Ѻ��ͬ
							{
								String sGCNo =  rs.getString("SerialNo");  //��õ�����ͬ��ˮ��
								String sSql1 = " select Count(GuarantyID) from GUARANTY_INFO "+
								       " where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType='"+sObjectType+"'"+
								       " and ObjectNo ='"+sObjectNo+"' and ContractNo = '"+sGCNo+"') "; 
								rs1 = Sqlca.getASResultSet(sSql1);
								if(rs1.next())
								{
									iNum = rs1.getInt(1); 
								}
								rs1.getStatement().close();
								//�жϵ�����ͬ�����Ƿ��ж�Ӧ��
								if (iNum <= 0)
								{
								    sMessage+= "������Ϣ���Ϊ:"+sGCNo+"�ĵ�����Ϣ�����޶�Ӧ����Ѻ��Ϣ��@";
								}
						     }
						     rs.getStatement().close();
						}						
					}	
				}
			}
			}	
		}
		
		
		//--------------���Ĳ����������ҵ�����Ʊ��ҵ����Ϣһ��---------------
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
					sMessage  += "ҵ�����Ʊ�ݽ���ܺͲ�����"+"@";
				
				sSql = 	" select count(SerialNo) from BILL_INFO  where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' "+
						" having count(SerialNo) = "+iBillNum+" ";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next()) 
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum == 0)
					sMessage += "ҵ���������Ʊ�������������Ʊ������������"+"@";					
			}					
		}
		
		//--------------���岽������Ƿ����ɵ��鱨��---------------	
		
		if(!"DependentApply".equals(sApplyType) && !"1".equals(sSmallEntFlag) && !("1140130,1150060,1150050,1054,1056".indexOf(sBusinessType) > -1)){		
			sSql = "select count(SerialNo),DocID from FORMATDOC_DATA where ObjectType = '"+sObjectType+"' and ObjectNo = '"+sObjectNo+"' group by DocID";
			rs = Sqlca.getASResultSet(sSql);
			String sDocID = "";
			if(rs.next()){
				iNum = rs.getInt(1);
				sDocID = rs.getString(2);
				if(sDocID == null) sDocID = "";
			}
			rs.getStatement().close(); 
			if(iNum == 0)
				sMessage  += "û����д���鱨����Ϣ��"+"@";
			else{
				String sFileName = "";
				sSql=" select SerialNo,SavePath from Formatdoc_Record where ObjectType='"+sObjectType+"' and  ObjectNo='"+sObjectNo+"' and DocID ='"+sDocID+"'";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{
					sFileName = rs.getString("SavePath");
				}
				rs.getStatement().close();
				if(sFileName==null) sFileName="";
				
				java.io.File file = new java.io.File(sFileName);
			    if(!file.exists())
			    	sMessage  += "û�����ɵ��鱨����Ϣ��"+"@";
			}
		}	
		double dNum = Sqlca.getDouble(" select count(*) from  CUSTOMER_SPECIAL  where SectionType ='70' and CustomerId = '"+sCustomerID+"'  "+
									  " and '"+StringFunction.getToday()+"' >= BeginDate and EndDate >= '"+StringFunction.getToday()+"' and InListStatus = '1'").doubleValue();
		if(dNum>0)//����ͻ�
		{
			return sMessage ;
		}
		
		//--------------������������Ƿ��йؼ�����Ϣ--------------- 	
		if (sCustomerType.length()>1&&sCustomerType.substring(0,2).equals("01")) //��˾�ͻ�
		{
		    sSql = " select Count(CustomerID) from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' "+
		           " and RelationShip like '01%'";
		   	rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    	iNum = rs.getInt(1);
		    rs.getStatement().close();
		    
			if(iNum == 0)
		    	sMessage  += "û������ؼ�����Ϣ��"+"@";
		}
		
		//--------------���߲�������Ƿ��йɶ���Ϣ--------------- 
		if (sCustomerType.length()>1&&sCustomerType.substring(0,2).equals("01")&&!sCustomerType.equals("0104")) //��˾�ͻ�
		{
			sBizHouseFlag = Sqlca.getString("select BizHouseFlag from ent_info where customerid = '"+sCustomerID+"'");
			if(sBizHouseFlag == null) sBizHouseFlag = "";
			if(!"1".equals(sBizHouseFlag))
			{	
				sSql = 	" select Count(CustomerID) from CUSTOMER_RELATIVE where CustomerID = '"+sCustomerID+"' "+
						" and RelationShip like '52%' ";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum == 0)
					sMessage  += "û������ɶ���Ϣ��"+"@";
			}	
		}
		
		//--------------�ڰ˲�������Ƿ��������˰��������õȼ�����---------------
		//1.��ҵ��λ����ģʽΪ������ҵ����λ����ҵ��λ������ҵ��������С��һ��Ĺ�˾�ͻ����ͷ���ҵ����⡣
		//2.����ũ��С�����ô���������Ƚ���ũ��������������������ܽ���ҵ������
		if(sCustomerType.startsWith("03") && ("1150010,1150050,1150060,1140130,1150020,1140080".indexOf(sBusinessType)) <0 )//���ˡ�ũ��С�����ô���
		{
			sSql =  " select Count(SerialNo) from EVALUATE_RECORD where ObjectType = 'Customer' "+
        			" and ObjectNo = '"+ sCustomerID +"' and EvaluateResult is not null ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
				iNum = rs.getInt(1);
			rs.getStatement().close();
			if(iNum == 0)
				sMessage  += "������û�н��й����õȼ�������"+"@";   
		}
	/*	modify by xhyong 2009/12/28 ��˾����Ҫ��֤���õȼ�������Ϣ
		//��ҵ�������ڣ�����ģʽ
		String sSetupDate ="",sManageMode="";
		if(!sCustomerType.startsWith("03"))
		{
			sSql = "select SetupDate,ManageMode from ENT_INFO where CustomerID = '"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sSetupDate = rs.getString("SetupDate");
				sManageMode = rs.getString("ManageMode");
				if(sSetupDate == null) sSetupDate ="";
				if(sManageMode == null) sManageMode ="";
			}
			rs.getStatement().close();
			if(!"1".equals(sLowRisk) && !"010".equals(sManageMode) &&  (sMonth.compareTo(sSetupDate) >0) )//��ҵ��λ����ģʽΪ������ҵ����λ����ҵ��λ������ҵ��������С��һ��Ĺ�˾�ͻ����ͷ���ҵ����⡣
			{
				sSql =  " select Count(SerialNo) from EVALUATE_RECORD where ObjectType = 'Customer' "+
	        	" and ObjectNo = '"+ sCustomerID +"' and EvaluateResult is not null "+
	        	" and AccountMonth >= '"+sMiddleYear+"' ";
			   	rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
					iNum = rs.getInt(1);
				rs.getStatement().close();
				
				if(iNum == 0)
					sMessage  += "���������������û�н��й����õȼ�������"+"@";   
				
			}
			
		}
		end modify
	*/
		
		//--------------�ھŲ�����鱣֤�˵Ŀͻ��ſ��Ƿ�����---------------
	    if(sVouchType.length()>=3) {
			//����ҵ�������Ϣ�е���Ҫ������ʽΪ��֤,���ѯ����֤�˿ͻ�����
			if(sVouchType.substring(0,3).equals("010"))
			{
				sSql = 	" select GuarantorID from GUARANTY_CONTRACT where SerialNo in "+
						" (select ObjectNo from "+ sRelativeTable +" where SerialNo = "+
						" '"+sObjectNo+"' and ObjectType = 'GuarantyContract') and "+
						" GuarantyType like '010%' ";
				rs = Sqlca.getASResultSet(sSql);
	        	while(rs.next())
	        	{
	            	sGuarantorID = rs.getString("GuarantorID");
	            	if(sGuarantorID==null) sGuarantorID="";
	            	if("".equals(sGuarantorID))
	            	{
	            		sMessage  += "������ͬ�еı�֤����Ϣ������,��ӵ��������������Ӧ�Ŀͻ���"+"@";
	            	}
	            	String sGuarantorCustomerName="";//��֤������
	            	//��ѯ�����ͻ�����
	            	String sGuarantorCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID='"+sGuarantorID+"'");
	            	//���ݲ�ѯ�ó��ı�֤�˿ͻ����룬��ѯ���ǵĿͻ��ſ��Ƿ�¼������
	            	if(sGuarantorCustomerType.length()>1&&sGuarantorCustomerType.substring(0,2).equals("03"))//����
	            	{
		            		sSql =  " select getCustomerName(CustomerID)  from IND_INFO where "+
		            				" CustomerID = '"+sGuarantorID+"' "+
		            				" and TempSaveFlag <> '2' ";
	            	}else
	            	{
							sSql =  " select  getCustomerName(CustomerID) from ENT_INFO where "+
									" CustomerID = '"+sGuarantorID+"' "+
									" and TempSaveFlag <> '2' ";
	            	}
	            	
	            	//System.out.println("sql:"+sSql);
					rs1 = Sqlca.getASResultSet(sSql);
		        	if(rs1.next())
		        		sGuarantorCustomerName = rs1.getString(1);
		        	rs1.getStatement().close();
		        	if(sGuarantorCustomerName==null)sGuarantorCustomerName = "";
					if(!"".equals(sGuarantorCustomerName))
		        		sMessage  += "��֤��["+sGuarantorCustomerName+"]�ĸſ���ϢΪ�ݴ�״̬��������д��ͻ��ſ���Ϣ��������水ť��"+"@";
				}
				rs.getStatement().close();					
			}
		}
		    
		//--------------��ʮ�������ͻ��Ƿ��ں�������---------------
		sSql = 	" select count(SerialNo) from CUSTOMER_SPECIAL where CustomerID = '"+sCustomerID+"' "+
				" and InListStatus = '1' and InListReason is not null and (EndDate >='"+sToday+"' or EndDate is null)";
		
		rs = Sqlca.getASResultSet(sSql);
	    if(rs.next())
	    	iNum = rs.getInt(1);
	    rs.getStatement().close();
	    
		if(iNum > 0 && sOccurType.equals("010"))//����
	    	sMessage  += "�ÿͻ�����������������ܽ�������ҵ��"+"@";
				 
		//--------------��ʮһ�������ͻ��Ƿ��ڻ�������---------------
		sSql = 	" select count(SerialNo) from CUSTOMER_SPECIAL where CustomerID = '"+sCustomerID+"' "+
				" and specialtype='020'  ";
		rs = Sqlca.getASResultSet(sSql);
	    if(rs.next())
	    	iNum = rs.getInt(1);
	    rs.getStatement().close();
	    
		if(iNum > 0)
	    	sMessage  += "�ÿͻ��������������"+"@"; 

		//------------�ڶ�ʮ�߲���΢С��ҵֻ�ܰ��������ʽ������гжһ�Ʊ���֡����гжһ�Ʊҵ�� ������ʽΪһ���������ʽΪ���»򰴼�����--------------
		if(sCustomerType.startsWith("01"))
		{
			if(sSmallEntFlag.equals("1"))
			{
				double days  = Sqlca.getDouble("select  days(current date) - days(date('"+sSetupDate.replaceAll("/", "-")+"'))  as days from (values 1) as a").doubleValue();
				System.out.println(days);
				if(!(sBusinessType.startsWith("1010") || sBusinessType.equals("1020010") || sBusinessType.equals("2010") || sBusinessType.equals("3010")))
				{
					sMessage  += "�ÿͻ����ܰ����ҵ��!"+"@";
				}
				if(days<365){
					sMessage  += "�ÿͻ���Ӫ���ޱ�����ڵ���1��!"+"@";
				}
				if(sBusinessType.startsWith("1010")){
					if(!("01".equals(sDrawingType))){
						sMessage  += "��ҵ�����ʽ����Ϊһ�������!"+"@";
					}
					if(!("1".equals(sCorpusPayMethod)||"2".equals(sCorpusPayMethod)||"3".equals(sCorpusPayMethod))){
						sMessage  += "��ҵ��Ļ��ʽ����һ���Ի�����»���򰴼�����!"+"@";
					}
				}
				if("1020010".equals(sBusinessType)){
					if(!("2".equals(sCorpusPayMethod)||"3".equals(sCorpusPayMethod))){
						sMessage  += "��ҵ��Ļ��ʽ���谴�»���򰴼�����!"+"@";
					}
				}
				
			}
			
		}
		
		//--------------��ʮ�������Ƿ�����˷��ն�����,���ҷ��ն��������Ƿ�ȡ��������---------------
		if((!sBusinessType.startsWith("30") || sBusinessType.equals("3040")) &&  ("2110040,2070,1150020,1150010,1140030,1140110,1110027,1140080".indexOf(sBusinessType)) < 0  && !"1".equals(sNationRisk) && !("1".equals(sSmallEntFlag) && sCustomerType.startsWith("01")))
		{
			//ȡ���������ֵ
			double dTermMonth1 =0.0; 
			String sVouchResult ="",sEvaluateResult="";
			sSql = " select BA.VouchType,TermMonth, CL.Attribute3 "+
				   " from Business_Apply BA ,Code_library CL where BA.VouchType =CL.ItemNo and CL.CodeNo='VouchType' and BA.SerialNo = '"+sObjectNo+"'" ;
	
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sVouchResult = rs.getString("VouchType");//������ʽ
				dTermMonth1 = rs.getDouble("TermMonth");//��������
				if(sVouchResult == null) sVouchResult = ""; 
				
			}
			rs.getStatement().close();
			
			//ȡ�ÿͻ����õȼ�ֵ,����ͻ�����03��ͷ��Ϊ���˿ͻ�
			String sTableName = Sqlca.getString("select (case when locate('03',CustomerType) = 1 then 'IND_INFO' else 'ENT_INFO' end) as TableName from Customer_Info where CustomerID ='"+sCustomerID+"'");
			//���м������� 
			sSql = "select CreditLevel from "+sTableName+" where CustomerID ='"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sEvaluateResult = rs.getString("CreditLevel"); //�������
				if(sEvaluateResult == null) sEvaluateResult = ""; 
			}
			rs.getStatement().close();

			//�����������Ϊ��ȡ��ǰϵͳ���һ��ĩ(�Թ�)�������һ��(����)���������
			if("".equals(sEvaluateResult))
			{
				if(sCustomerType.startsWith("03"))//����
				{
					sSql = "select EvaluateResult "+
					" from EVALUATE_RECORD R "+
					" where ObjectType = 'Customer' "+
					" and ObjectNo = '"+sCustomerID+"'  order by AccountMonth desc fetch first 1 rows only";
				}else//�Թ�
				{
					sSql = "select EvaluateResult "+
					" from EVALUATE_RECORD R "+
					" where ObjectType = 'Customer' "+
					" and AccountMonth like '%/12' "+
					" and ObjectNo = '"+sCustomerID+"'  order by AccountMonth desc fetch first 1 rows only";
				}
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{
					sEvaluateResult = rs.getString("EvaluateResult"); //�������
					if(sEvaluateResult == null) sEvaluateResult = ""; 	
				}
				rs.getStatement().close();
			}
			
			sSql = "select VouchResult,TermNum,EvaluateResult,RiskEvaluate from Risk_Evaluate where ObjectNo = '"+sObjectNo+"' and ObjectType = '"+sObjectType+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				String pVouchResult = rs.getString("VouchResult"); //������ʽ
				double dTermNum = rs.getDouble("TermNum"); //������ʽ
				String pEvaluateResult = rs.getString("EvaluateResult"); //������ʽ
				double pRiskEvaluate = rs.getDouble("RiskEvaluate");
				if(pVouchResult == null) pVouchResult = ""; 
				if(pEvaluateResult == null) pEvaluateResult = ""; 
				//������ԭ���ݲ����˱仯
				if(sCustomerType.startsWith("03"))
				{
					if(!(pVouchResult.equals(sVouchResult) && pEvaluateResult.equals(sEvaluateResult)))
					{
						sMessage  += "���ն�����ԭ���ݲ����˱仯�������½��з��ն�������"+"@";
					}
				}else{
					if(sBizHouseFlag.equals("1") && sVouchType.equals("005")){
						if(pRiskEvaluate != 1){
							sMessage  += "���ն�����ԭ���ݲ����˱仯�������½��з��ն�������"+"@";
						}
					}
					else if(!(pVouchResult.equals(sVouchResult) && dTermNum==dTermMonth1 &&pEvaluateResult.equals(sEvaluateResult)))
					{
						sMessage  += "���ն�����ԭ���ݲ����˱仯�������½��з��ն�������"+"@";
					}
				}
			}else
			{
				sMessage  += "û�н��з��ն�������"+"@";
			}
			rs.getStatement().close();
		
		}
		//--------------��ʮ����������֤���´�������������֤��������������֤Ѻ�������֣�ȡ�����ƣ�����������Ѻ�������֡�������ҵ��Ʊ���ʡ�����������֤��Ϣ---------------1080020,1080080,1080090,1080030,1080035
		if (sBusinessType.equals("1080020") || sBusinessType.equals("1080080") ||sBusinessType.equals("1080090")||sBusinessType.equals("1080030") ||sBusinessType.equals("1080035"))	{
			sSql = 	" select count(SerialNo) from LC_INFO where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum == 0)
	     		sMessage  += "��������Ѻ�������֡�������ҵ��Ʊ���ʻ�����֤���ҵ��û���������֤��Ϣ��"+"@";
		}

		//--------------��ʮ�Ĳ����������´�������ͬ���´�����������ó�׺�ͬ��Ϣ---------------
		if (sBusinessType.equals("1080020") || sBusinessType.equals("1080010")) {
			sSql = 	" select count(SerialNo) from CONTRACT_INFO where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum == 0)			     	
	     		sMessage  += "���ں�ͬ���������������֤�������ҵ��û�����ó�׺�ͬ��Ϣ��"+"@";
		}

		//--------------��ʮ�岽�����ڱ������ڱ��������ط�Ʊ��Ϣ---------------
		if (sBusinessType.equals("1090020") ||  sBusinessType.equals("1090030")) {
			sSql = 	" select count(SerialNo) from INVOICE_INFO where ObjectType = '"+sObjectType+"' "+
					" and ObjectNo = '"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     		iNum = rs.getInt(1);
	     	rs.getStatement().close();
	     	
			if(iNum == 0)			     	
	     		sMessage  += "���ڱ���ҵ�����ڱ���ҵ��û����ط�Ʊ��Ϣ��"+"@";
		}
		
		//--------------�Ƿ��н����ھ�ӪȨ---------------
		if (sBusinessType.substring(0, 4).equals("1080"))
		{
		sSql = "select HasIERight from ENT_INFO where CustomerID = '"+sCustomerID+"' ";
		rs = Sqlca.getASResultSet(sSql);
	    if(rs.next())
	    	sHasIERight = rs.getString("HasIERight");
	    rs.getStatement().close();
	    if(sHasIERight==null) sHasIERight="";
		if(sHasIERight.equals("2"))
	   		sMessage  += "�޽����ھ�ӪȨ��"+"@";
		}

		//--------------��ʮ�������Ƿ���ڽ������--------------- 
		if(!sBusinessType.equals("3015") && sOccurType.equals("010")&&!sBusinessType.equals("2070")&&!sBusinessType.equals("2110040")&&!"918010100".equals(sInputOrgID))//��Ϊͬҵ����Ϊ�·��� �Ҳ�Ϊί�д���
		{
			sSql = "select count(distinct ManageOrgID) from BUSINESS_CONTRACT where CustomerID = '"+sCustomerID+"' " +
					" and (FinishDate is null or FinishDate='') " +
					" and  ((Maturity >='"+StringFunction.getToday()+"' and BusinessType like '3%')" +
					" or BusinessType not like '3%') and ManageOrgid<>'"+sOperateOrgID+"' and ManageOrgid <> '918010100' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    	iNum = rs.getInt(1);
		    rs.getStatement().close();
		    
			if(iNum > 0)
		   		sMessage  += "���������ڱ��д��ڽ��������Ϣ��"+"@";
		}
		
		//--------------��ʮ�߲����Ƿ���ڲ�����¼---------------
		sSql = 	" select count(SerialNo) from BUSINESS_CONTRACT where " +
				"(nvl(OverDueBalance,0)+nvl(DullBalance,0)+nvl(BadBalance,0)+nvl(InterestBalance1,0)+nvl(InterestBalance2,0))> 0 "+
				" and CustomerID = '"+sCustomerID+"' ";
		rs = Sqlca.getASResultSet(sSql);
	    if(rs.next())
	    	iNum = rs.getInt(1);
	    rs.getStatement().close();
	    
		if(iNum > 0 && sOccurType.equals("010")){//����
    		sMessage  += "���������ڱ��д��ڲ�����¼����������ҵ��"+"@";
		}
		else if(iNum < 1 && sOccurType.equals("010")){
			String sMFCustomerID = Sqlca.getString("select MFCustomerID from Customer_Info where CustomerID = '"+sCustomerID+"'");
			sSql = 	" select count(SerialNo) from BUSINESS_DUEBILL where " +
					"(nvl(OverDueBalance,0)+nvl(DullBalance,0)+nvl(BadBalance,0)+nvl(InterestBalance1,0)+nvl(InterestBalance2,0)) > 0 "+
					" and MFCustomerID = '"+sMFCustomerID+"' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    	iNum = rs.getInt(1);
		    rs.getStatement().close();
			if(iNum > 0)//����
	    		sMessage  += "���������ڱ��д��ڲ�����¼����������ҵ��"+"@";
		}
		//--------------��ʮ�˲���չ��ҵ���Ƿ��뵱ǰ�������---------------
		//��������Ϊչ�ڣ��������չ��ԭҵ����Ϣ
		if(sOccurType.equals("015"))
		{
			String BDSerialNo ="";
			//���պ�ͬչ��
			//sSql = 	" select count (SerialNo) from APPLY_RELATIVE "+
			//		" where SerialNo = '"+sObjectNo+"' " +
			//		" and ObjectType = 'BusinessContract' ";
			//���ս��չ��
			sSql = 	" select ObjectNo from APPLY_RELATIVE "+
					" where SerialNo = '"+sObjectNo+"' " +
					" and ObjectType = 'BusinessDueBill' ";
			rs = Sqlca.getASResultSet(sSql);
			 if(rs.next())
		    {
		    	BDSerialNo = rs.getString("ObjectNo");
		    	if(BDSerialNo == null) BDSerialNo ="";
		    	
		    }
		    else
		    {
		    	sMessage  += "��ҵ������û�й�����չ�ڵ�ԭ��ݣ�"+"@";
		    }
		    rs.getStatement().close();
		    

	    	//ԭ�����Ϣ
		    if(!BDSerialNo.equals(""))
		    {
		    	String BDMaturity ="",BDPutOutDate="";
		    	
		    	sSql = " select count(*) from Business_Apply BA where RelativeAgreement ='"+BDSerialNo+"' and OccurType ='015'" +
		    		   " and  exists (select 'X' from Flow_Object FO where FO.ObjectNo =BA.SerialNo and FO.ObjectType = 'CreditApply' and FO.PhaseType <> '1050')";
		    	rs = Sqlca.getASResultSet(sSql);
		    	if(rs.next())
			    	iNum = rs.getInt(1);
			    rs.getStatement().close();
			    
			    if(iNum >0)
			    {
			    	sMessage  += "����չ�ڵĽ���Ѿ�������չ��ҵ�񣬲����ٴη���չ��ҵ��"+"@";
			    }else
			    {
			    	sSql = " select nvl(balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate) as Balance,PutOutDate,Maturity, " +
			    		   " (nvl(InterestBalance1,0)+nvl(InterestBalance2,0)) as InterestBalance" +
			    		   " from Business_Duebill where SerialNo='"+BDSerialNo+"'";
			    	rs = Sqlca.getASResultSet(sSql);
			    	if(rs.next())
			    	{ 
			    		double dInterestBalance = rs.getDouble("InterestBalance");
			    		BDMaturity = rs.getString("Maturity");
			    		BDPutOutDate = rs.getString("PutOutDate");
			    		if(BDMaturity == null) BDMaturity="";
			    		if(BDPutOutDate == null) BDPutOutDate="";
			    		
			    		if(sAfterThirDay.compareTo(BDMaturity)>0)
			    		{
			    			sMessage  += "�Ѿ�������ݵ���ǰ30�죬���ܷ���չ��ҵ��"+"@";
			    		}
			    		if(dInterestBalance>0)
			    		{
			    			sMessage  += "�ý�ݴ���ǷϢ�����ܷ���չ��ҵ��"+"@";
			    		}
			    		
			    	}
			    	rs.getStatement().close();
			    	
			    	//���ܳ���ԭ��������޿���
			    	java.util.Calendar  calender1 = new GregorianCalendar(Integer.parseInt(BDPutOutDate.substring(0,4)),Integer.parseInt(BDPutOutDate.substring(5,7)),Integer.parseInt(BDPutOutDate.substring(8, 10)));
			    	java.util.Calendar  calender2 = new GregorianCalendar(Integer.parseInt(BDMaturity.substring(0,4)),Integer.parseInt(BDMaturity.substring(5,7)),Integer.parseInt(BDMaturity.substring(8, 10)));
			    	double  diff   =   (double) ((calender2.getTimeInMillis()-calender1.getTimeInMillis())/1000/60/60/24);
			    	System.out.println("diff:"+diff); 
			    	if(diff>365) 
			    	{
				    	if((dTermMonth*30+dTermDay)*2 > diff)
				    	{
				    		sMessage  += "����չ��������ޣ�"+"@";
				    	}
			    	}else
			    	{
			    		if(dTermMonth*30+dTermDay > diff)
				    	{
				    		sMessage  += "����չ��������ޣ�"+"@";
				    	}
			    	}
			    	
			    }
			    
		    }
		    
			
		}
		
		//--------------��ʮ�Ų������»���ҵ���Ƿ��뵱ǰ�������---------------		
		//��������Ϊ���»��ɣ���������»���ҵ����Ϣ
		if(sOccurType.equals("020"))
		{
			//���պ�ͬ���»���
			//sSql = 	" select count (SerialNo) from APPLY_RELATIVE "+
			//		" where SerialNo = '"+sObjectNo+"' " +
			//		" and ObjectType = 'BusinessContract' ";
			//���ս�ݽ��»���
			String BDSerialNo ="";
			String sBDSerialNo= "";
			sSql = 	" select ObjectNo from APPLY_RELATIVE "+
					" where SerialNo = '"+sObjectNo+"' " +
					" and ObjectType = 'BusinessDueBill' ";
			rs = Sqlca.getASResultSet(sSql);
		    while(rs.next())
		    {
		    	BDSerialNo = rs.getString("ObjectNo");
		    	if(BDSerialNo == null) BDSerialNo ="";
		    	sBDSerialNo=sBDSerialNo+"','"+BDSerialNo;
		    }
		    rs.getStatement().close();
		    if("".equals(BDSerialNo))
		    {
		    	sMessage  += "��ҵ������û�й��������»��ɵ�ԭ��ݣ�"+"@";
		    }
		    
		    if(!BDSerialNo.equals(""))
		    {
		    	double dBalance = Sqlca.getDouble("select SUM(nvl(balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)) from Business_Duebill where SerialNo in('"+sBDSerialNo+"')").doubleValue();
		    	if(dBusinessSum>dBalance)
		    	{
		    		sMessage  += "���»���������ܴ���ԭ�����"+"@";
		    	}
		    }
			
		}
		
		//--------------�ڶ�ʮ�����ʲ�����ҵ����ؿ���---------------		
		//��������Ϊ�ʲ����飬������ʲ�����ҵ����Ϣ
		if(sOccurType.equals("030"))
		{			
			String sRSerialNo = "";
			double dRAPPBusinessSum = 0.00,dRBusinessSum = 0.00,dRNewBusinessSum = 0.00;
			double dRBalance = 0.00;
			//����û�й����ʲ����鷽��
			sSql = 	" select count (SerialNo) from APPLY_RELATIVE "+
					" where SerialNo = '"+sObjectNo+"' " +
					" and ObjectType = 'CapitalReform' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    	iNum = rs.getInt(1);
		    rs.getStatement().close();
		    
			if(iNum <= 0)				
				sMessage  += "��ҵ������û�й����ʲ����鷽����"+"@";
			
			//��������������������Ž��֮���Ƿ����������
			sSql = 	" select BI.SerialNo as SerialNo,BA.BusinessSum as APPBusinessSum,"+
					" BI.BusinessSum as BusinessSum,BI.NewBusinessSum as NewBusinessSum "+
					" from BUSINESS_APPLY BA,REFORM_INFO BI,APPLY_RELATIVE AR "+
					" where  AR.ObjectNo=BI.SerialNo "+
					" and AR.SerialNo=BA.SerialNo "+
					" and AR.ObjectType='CapitalReform' "+
					" and BA.SerialNo='"+sObjectNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    {
		    	sRSerialNo = rs.getString("SerialNo");
		    	dRAPPBusinessSum = rs.getDouble("APPBusinessSum");
		    	dRBusinessSum = rs.getDouble("BusinessSum");
		    	dRNewBusinessSum = rs.getDouble("NewBusinessSum");
		    }
		    rs.getStatement().close();
		    
			if(dRAPPBusinessSum != dRBusinessSum+dRNewBusinessSum)				
				sMessage  += "���鷽������������������������Ž��֮�Ͳ����������"+"@";
			
			//��������ͬ���֮���Ƿ�������鷽���������������
			sSql = 	"select sum(BC.Balance) as Balance  "+
					" from BUSINESS_CONTRACT BC,REFORM_RELATIVE AR  "+
					" where BC.SerialNo = AR.ObjectNo and AR.ObjectType= 'BusinessContract' "+
					" and AR.SerialNo = '"+sRSerialNo+"' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    {
		    	dRBalance = rs.getDouble("Balance");
		    }
		    rs.getStatement().close();
		    
			if(dRBusinessSum != dRBalance)				
				sMessage  += "���鷽���й�����������ͬ���֮���ǲ���������������"+"@";
		}
		
		//------------�ڶ�ʮһ�������Ѿ������Ĵ���ܽ���������ҵ��--------------
		if(sOccurType.equals("010"))
		{
			sSql = "select count(*) from BUSINESS_CONTRACT where FinishType like '060%' and CustomerID ='"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    	iNum = rs.getInt(1);
		    rs.getStatement().close();
		    
			if(iNum > 0)				
				sMessage  += "�ÿͻ��к��������������ҵ��"+"@";
		}
		//delete by xhyong 2012/0823
		/*
		//------------�ڶ�ʮһ������һ�ͻ�����������ܸ����ʱ����10��--------------
		if(sOccurType.equals("010"))
		{
			AmarInterpreter interpreter = new AmarInterpreter();
			Anything aReturn =  interpreter.explain(Sqlca,"!��������.�Ƿ��ʱ���("+sObjectNo+","+sObjectType+",2)");
			String sReturn = aReturn.stringValue();
			if(sReturn.equals("TRUE"))
			{
				sMessage  += "�ÿͻ���������+�����������ʱ���10����"+"@";
			}
	        
		}
		*/
		//end
		//ũ������С�����ô������Ҫ����������---ǰ���Ѿ��пͻ�һ����û����������
		
		//------------�ڶ�ʮ���������幤�̻���΢С�̻����������+���--------------
		if(sCustomerType.equals("0103") && sBusinessType.equals("1140120"))
		{
			//��ʷ���---�Ƿ�Ҫ���������еĺ͵ȼ���ͬδ�ſ��
			double dBalanceSum =0.0;
			sSql ="select Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate) as BalanceSum from Business_Contract where CustomerID ='"+sCustomerID+"' and BusinessType ='1140120'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
				dBalanceSum = rs.getDouble("BalanceSum");
			
			rs.getStatement().close();
			double dTotalSum = dBalanceSum+dBusinessSum;
			
			if(dTotalSum>500000)
				sMessage  += "���幤�̻�������΢С�̻����������+��Ʒ�������ܴ���50��!"+"@";
		}
		
		//--------------------�ڶ�ʮ���������ɽ���ҵ��----------------------------
		if(sOccurType.equals("060"))
		{
			String BDSerialNo ="";
			sSql = 	" select ObjectNo from APPLY_RELATIVE "+
					" where SerialNo = '"+sObjectNo+"' " +
					" and ObjectType = 'BusinessDueBill' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    {
		    	BDSerialNo = rs.getString("ObjectNo");
		    	if(BDSerialNo == null) BDSerialNo ="";
		    }
		    else
		    {
		    	sMessage  += "��ҵ������û�й��������ɽ��µ�ԭ��ݣ�"+"@";
		    }
		    rs.getStatement().close();
		    
		    //���Σ�by zwhu 20100721
		    /*if(!BDSerialNo.equals(""))
		    {
		    	double dBalance = Sqlca.getDouble("select nvl(balance,BusinessSum)*getERate(BusinessCurrency,'01','') from Business_Duebill where SerialNo='"+BDSerialNo+"'").doubleValue();
		    	if(dBalance != 0)
		    	{
		    		sMessage  += "���ɽ���ԭ�����Ϊ0��"+"@";
		    	}
		    }	
		    */			        
		}
		//delete by xhyong 2012/0823
		/*
		//--------------�ڶ�ʮ�Ĳ������ų�Ա����ҵ�񣬼�����������+����������ܴ����ʱ���15��---------------
		String JTCustomerID ="";
		sSql = " select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"' "+
			   " and RelationShip like '04%' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			JTCustomerID = rs.getString("CustomerID");
			if(JTCustomerID == null) JTCustomerID ="";
		}
		rs.getStatement().close();
		if(!JTCustomerID.equals(""))
		{
			AmarInterpreter interpreter = new AmarInterpreter();
			Anything aReturn =  interpreter.explain(Sqlca,"!��������.�Ƿ��ʱ���("+sObjectNo+","+sObjectType+",4)");
			String sReturn = aReturn.stringValue();
			if(sReturn.equals("TRUE"))
			{
				sMessage  += "�ñʴ���������+���������������ܴ��ڱ����ʱ����15����"+"@";
			}
		}
		*/	
		//end
		//--------------�������ų�Ա���������ŷ����޶����-------------
		String GLCustomerID ="" ;        // ��������ID
		double dCreditAuthSum = 0.0 ;    // �������ŷ����޶�
		double dSum1 = 0.0 ;             // ��Ա���ų�������
		double dSum3 = 0.0 ;             // ��ͬ���
		double dSum4 = 0.0 ;             // ��֤��
		double dSum2 = 0.0 ;             // ��Ա�������ŷ��ճ���
		double dSum5 = 0.0 ;             // �ñ�������
		double dSum6 = 0.0 ;             // �ñʱ�֤��
		//��Ա���ų�������+��Ա�������ŷ��ճ��ڽ��<=��Ա���ŷ����޶�
		// ��Ա���ų�������:(δ�ſ��ͬ���-��֤��)+(�ѷſ��ͬ���-��֤��)
		// ��Ա�������ŷ��ճ���:��Ա�������ŷ��ճ���=�ñ�������-�ñʱ�֤���
		sSql = " select CustomerID from CUSTOMER_RELATIVE where RelativeID = '"+sCustomerID+"' "+
			   " and RelationShip like '04%' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			GLCustomerID = rs.getString("CustomerID");
			if(GLCustomerID == null) GLCustomerID ="";
		}
		rs.getStatement().close();
		// COGNSCORE-���Ŷ���޶� MODELNO-���� FINISHDATE4-�������� FINISHDATE-��ʼ�� FINISHDATE2-������
		if(!GLCustomerID.equals(""))
		{
			 dCreditAuthSum = Sqlca.getDouble(" select min(Nvl(COGNSCORE,0)*getERate(MODELNO,'01',FINISHDATE4)) from EVALUATE_RECORD where OBJECTNO = '"+GLCustomerID+"' and OBJECTTYPE = 'GroupCreditRisk'  and '"+sToday+"' between FINISHDATE and FINISHDATE2 ");
			 if(dCreditAuthSum>0)
			 {
				 dSum3 = Sqlca.getDouble(" select Sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)) from Business_Contract where CustomerID in (select RelativeID from Customer_Relative where CustomerID = '"+GLCustomerID+"' and RelationShip like '04%')");
				 dSum4 = Sqlca.getDouble(" select Sum(Nvl(BailSum,0)*getERate(BusinessCurrency,'01',ERateDate)) from Business_Contract where CustomerID in (select RelativeID from Customer_Relative where CustomerID = '"+GLCustomerID+"' and RelationShip like '04%') ");
				 dSum1 = dSum3 - dSum4;
				 dSum5 = Sqlca.getDouble(" select Nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate) from Business_Apply where SerialNo = '"+sObjectNo+"' ");
				 dSum6 = Sqlca.getDouble(" select NVL(BailSum,0)*getERate(BusinessCurrency,'01',ERateDate) from Business_Apply where SerialNo = '"+sObjectNo+"' ");
				 dSum2 = dSum5 - dSum6;
				 if(dSum1+dSum2 > dCreditAuthSum)
				 {
				    sMessage  += "��Ա���ų����������Ա������ճ��ڽ��֮�Ͳ��ܴ��ڼ������ŷ����޶"+"@"  ;
				 }
			 }
		}
		
		//--------------�ڶ�ʮ�岽���������׿���---------------
		if(sOccurType.equals("010"))//�·���
		{
			double dBalanceSum =0.0, dNetCapital =0.0 ,dTotalSum =0.0;
			String sCertID ="",sCertType="";
			sSql = " select count(*) as num from CUSTOMER_SPECIAL CS,CUSTOMER_INFO CI where CS.CertID=CI.CertID and CS.CertType=CI.CertType and SectionType='50' and CI.CustomerID ='"+sCustomerID+"'";
			rs = Sqlca.getASResultSet(sSql);
	     	if(rs.next())
	     	{
	     		iNum = rs.getInt("num");
	     	}
	     	rs.getStatement().close();
	     	
	     	if(iNum>0)//�ǹɶ�
	     	{
	     		//���йɶ����������(ͨ���ɶ���֤������ȥ�����ͻ���Ϣ)
	     	  sSql = " select Sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)) as BalanceSum " +
	     	   		 " from Business_Contract where CustomerID in " +
	     	   		 " ( select CS.CustomerID from CUSTOMER_SPECIAL CS,CUSTOMER_INFO CI where CS.CertID=CI.CertID and CS.CertType=CI.CertType and SectionType='50')";
	     	  rs = Sqlca.getASResultSet(sSql);
	     	  if(rs.next())
	     	  {
	     		  dBalanceSum = rs.getDouble("BalanceSum");//�ɶ������
	     	  }
	     	  rs.getStatement().close();
	     	  dTotalSum = dBalanceSum+dBusinessSum;
	     	  
	     	 //�����ʱ���
	     	  sSql = "select Nvl(NetCapital,0) from Org_Info where OrgLevel = '0'";//����
	     	  dNetCapital = Sqlca.getDouble(sSql).doubleValue();
	     	  
	     	  if(dTotalSum>dNetCapital*0.5)
	     	  {
	     		 sMessage  += "�����ɶ�����ҵ���ʱ����޶"+"@";
	     	  }
	     	  
	     	}
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
	     		sMessage  += "�̶��ʲ�������ز����û�������Ŀ��Ϣ��"+"@";
		}
		
		
		//------------�ڶ�ʮ�˲���ũ����ɫ������ͻ��Ƿ��а����ҵ���Ȩ��------------------
		AmarInterpreter interpreter = new AmarInterpreter();
		Anything aReturn1 =  interpreter.explain(Sqlca,"!BusinessManage.CheckCreditCondition("+sBusinessType+","+sCustomerID+")");
		String TempValue = aReturn1.stringValue();
		
		if(!TempValue.equals("") && !TempValue.equals("PASS"))
			sMessage  +=  TempValue+"@";
		
		
		//------------�ڶ�ʮ�Ų�������,�Ѿ�������˵�ҵ��������------------------
		if(sOccurType.equals("090")){
			
			sSql = " select count(*) from Business_Contract BC,Business_PutOut BP " +
				   " where BC.SerialNo = BP.ContractSerialNo " +
				   " and BC.RelativeSerialNo ='"+sRelativeAgreement+"'  ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
				iNum = rs.getInt(1);
			
			rs.getStatement().close();
			if(iNum > 0)
				sMessage += "��Ҫ�����ҵ���Ѿ�������ˣ����ܽ��и���"+"@";
		}
		
		//==============================Э����=============================================
		if(!"".equals(sVouchAggreement) || !"".equals(sConstructContractNo) || !"".equals(sBuildAgreement)){
		String sSql1 = " Select SerialNo,(nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)-nvl(BailSum,0)) as BusinessSum," +
				 	   " BusinessCurrency, ConstructContractNo,BuildAgreement," +
					   " BusinessType,(nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)-nvl(BailSum,0)) as Balance,VouchType,CustomerID,VouchAggreement " +
					   " from Business_Contract BC Where 1=1 and (FinishDate is null or FinishDate ='')  " ;
		 
		 String sSql2 = " select SerialNo,(nvl(BusinessSum,0)*getERate(BusinessCurrency,'01',ERateDate)-nvl(BailSum,0)) as BusinessSum,CustomerID," +
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
				 sMessage  +=  "����Э���ѵ��ڣ�����ʹ�ã�"+"@";
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
				 dCusAgreeApplySum = AgreementApply.getSum("BusinessSum","CustomerID",Tools.EQUALS,sCustomerID);
				 
				 if("".equals(sAgriLoanFlag) || "2".equals(sAgriLoanFlag))//����ũ
					 dCompareSum = dVouchTotalSum-dAgreementBalance-dAgreementApplySum;
				 else
					 dCompareSum = dTopVouchSum-dAgreementBalance-dAgreementApplySum;
				 //System.out.println("dTopVouchSum:"+dTopVouchSum+"*dAgreementBalance:"+dAgreementBalance+"&dAgreementApplySum:"+dAgreementApplySum);
				 if(dBusinessSum-dBailSum>dCompareSum)
					 sMessage  +=  "��������Э�鵣����Ȼ��ߵ����ܶ�����ƣ�"+"@";
					 
				 dCompareSum = dSingleSum-dCusAgreeBalance-dCusAgreeApplySum;
				 if(dBusinessSum-dBailSum>dCompareSum)
					 sMessage  +=  "��������Э�鵥����ߵ���������ƣ�"+"@";
				 /*
				 if(dTermMonth >dEntTermMonth )
					 sMessage  +=  "��������Э����������������ƣ�"+"@";
					 */
				AgreementContract.closeCreditData();
				AgreementApply.closeCreditData(); 
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
					 sMessage  +=  "���̻�е��Э���ѵ��ڣ�����ʹ�ã�"+"@";
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
					 dCusAgreeApplySum = AgreementApply.getSum("BusinessSum","CustomerID",Tools.EQUALS,sCustomerID);
					 System.out.println("dCreditSum:"+dCreditSum+"%dAgreementBalance:"+dAgreementBalance+"*dAgreementApplySum:"+dAgreementApplySum);
					 dCompareSum = dCreditSum-dAgreementBalance-dAgreementApplySum;
					 if(dBusinessSum>dCompareSum)
						 sMessage  +=  "�����þ����̴�Э�������ƣ�"+"@";
						 
					 dCompareSum = dLimitSum-dCusAgreeBalance-dCusAgreeApplySum;
					 if(dBusinessSum>dCompareSum)
						 sMessage  +=  "�������������̴�Э����߶����ƣ�"+"@";
					 
					 if(dTermMonth >dLimitLoanTerm )
						 sMessage  +=  "���������̴�Э����ߴ����������ƣ�"+"@";
					
					 dCompareSum = dLimitLoanRatio*dEquipmentSum;
					 if(dBusinessSum>dCompareSum)
						 sMessage  +=  "���������̴�Э����ߴ���������ƣ�"+"@";
					AgreementContract.closeCreditData();
					AgreementApply.closeCreditData();
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
					 sMessage  +=  "¥���Э���ѵ��ڣ�����ʹ�ã�"+"@";
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
						 sMessage  +=  "����¥���Э���ܶ�����ƣ�"+"@";
					AgreementContract.closeCreditData();
					AgreementApply.closeCreditData();
				 }
			}

		
		}
		
		//--------------------����ʮ������΢С��ҵ����---------------------
		if(sCustomerType.startsWith("01"))
		{
			String sRelativeID="";
			//�ʲ��ܶ�
			double dTotalAssets =0.0,dSellSum=0.0,dTotalSum=0.0, dBalanceSum =0.0;
			sSql = "select SmallEntFlag,TotalAssets,SellSum from ENT_INFO where CustomerID ='"+sCustomerID+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sSmallEntFlag = rs.getString("SmallEntFlag");
				dTotalAssets = rs.getDouble("TotalAssets");
				dSellSum = rs.getDouble("SellSum");
				if(sSmallEntFlag ==null) sSmallEntFlag="";
			}
			rs.getStatement().close();
			
			if("1".equals(sSmallEntFlag))//�϶�Ϊ΢С��ҵ
			{
				//ȡ�øû����Ƿ����΢С��ҵ�ķ���Ȩ������߽�� lpzhang 2010-5-12 
				sSql =  " select CreditSmallEntFlag , SmallEntSum from Org_Info " +
						" where OrgID =(select OrgID from Org_Info where OrgID= '"+sInputOrgID+"')";
				                     
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{
					sCreditSmallEntFlag = rs.getString("CreditSmallEntFlag");
					dSmallEntSum = rs.getDouble("SmallEntSum");
					if(sCreditSmallEntFlag ==null) sCreditSmallEntFlag="";
				}
				rs.getStatement().close();
				
				if(!sCreditSmallEntFlag.equals("1"))
				{
					sMessage  +=  "���������ܰ���΢С��ҵ���"+"@";
				}else{
				
					sSql ="select nvl(sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)),0) as BalanceSum from Business_Contract where CustomerID ='"+sCustomerID+"' and  ApplyType <>'DependentApply'  ";
					rs = Sqlca.getASResultSet(sSql);
					if(rs.next())
						dBalanceSum = rs.getDouble("BalanceSum");
					
					rs.getStatement().close();
					dTotalSum = dBalanceSum+dBusinessSum;
					//��1��	΢С��ҵ��������ӦС�ڵ���׼����
					if(dTotalSum>dSmallEntSum)
						sMessage  +=  "΢С��ҵ�������Ž�����ʷ���ӦС�ڵ���"+dSmallEntSum+"Ԫ��"+"@";
					//��2��	΢С��ҵ����ĩ�ʲ��ܶ�������Ŷ�ȵ�3�� 
					if(dBusinessSum*3/10000>dTotalAssets)
						sMessage  +=  "΢С��ҵ����ĩ�ʲ��ܶ�������Ŷ�ȵ�3����"+"@";
					//��3��	΢С��ҵ������������벻�������Ŷ��3��	
					if(dBusinessSum*3/10000>dSellSum)
						sMessage  +=  "΢С��ҵ������������벻�������Ŷ��3����"+"@";
					//��4��	΢С��ҵ������ӦС�ڵ���2��
					if(dTermMonth>24)
						sMessage  +=  "΢С��ҵ��������ӦС�ڵ���2�꣡"+"@";
				}
				//��5��	��΢С��ҵ������ҵ��΢С��ҵ���˴������ڸ��а�����������
				sRelativeID = Sqlca.getString(" select RelativeID from CUSTOMER_RELATIVE  where CustomerID ='"+sCustomerID+"' and RelationShip = '0100' and EffStatus = '1'"); 
				if(sRelativeID==null)sRelativeID="";
				if("".equals(sRelativeID)){
					sRelativeID = Sqlca.getString(" select RelativeID from CUSTOMER_RELATIVE  where CustomerID ='"+sCustomerID+"' and RelationShip = '0109' and EffStatus = '1'");
					if(sRelativeID==null)sRelativeID="";
				}
				if(!"".equals(sRelativeID)){
					sSql = "select count(*) from BUSINESS_CONTRACT where CustomerID = '"+sRelativeID+"' and (FinishDate is null or FinishDate='')  ";
					rs = Sqlca.getASResultSet(sSql);
				    if(rs.next())
				    	iNum = rs.getInt(1);
				    rs.getStatement().close();
					if(iNum > 0)
				   		sMessage  += "�ÿͻ��ķ��˴����ʵ�ʿ������ڱ����д���ҵ��"+"@";
				}	
				if(!(sBusinessType.equals("2010")))//���гжһ�Ʊҵ���漰��׼����
				{
				//��6��	΢С��ҵ�ĵ���Ѻ���������ڻ�׼�������ϸ�30%������0-30%��
				if((sVouchType.startsWith("020")||sVouchType.startsWith("040") )&& (dRateFloat>30 ||dRateFloat<0)&& !sBusinessType.equals("2010"))
					sMessage  += "΢С��ҵ�ĵ���Ѻ�������ʻ�׼�����ϸ����䣨0-30������"+"@";
				//(7)������֤�������ڻ�׼�������ϸ�30%-80%
				if((sVouchType.startsWith("010")) && (dRateFloat<30 ||dRateFloat>80) && !sBusinessType.equals("2010"))
					sMessage  += "΢С��ҵ��֤������Ӧ���ڻ�׼�������ϸ�30��-80����"+"@";
				}
			}
		}
		/***remarked by lpzhang 2010-4-27 ȡ���ÿ���
		if(sCustomerType.startsWith("03"))
		{
			String sCustomerIDstr = Sqlca.getString("select CustomerID from CUSTOMER_RELATIVE  where RelativeID ='"+sCustomerID+"' and RelationShip = '0100' ");
			if(sCustomerIDstr==null) sCustomerIDstr="";
			
			sSql = "select SmallEntFlag from ENT_INFO where CustomerID ='"+sCustomerIDstr+"' ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sSmallEntFlag = rs.getString("SmallEntFlag");
				if(sSmallEntFlag ==null) sSmallEntFlag="";
			}
			rs.getStatement().close();
			
			if("1".equals(sSmallEntFlag))//΢С��ҵ����
			{
				sSql = "select count(*) from BUSINESS_CONTRACT where CustomerID = '"+sCustomerIDstr+"' and (FinishDate is null or FinishDate='') ";
				rs = Sqlca.getASResultSet(sSql);
			    if(rs.next())
			    	iNum = rs.getInt(1);
			    rs.getStatement().close();
				if(iNum > 0)
			   		sMessage  += "�ÿͻ���΢С��ҵ�ķ��˴�����΢С��ҵ�ڱ��д���ҵ��"+"@";
			}
			
			
		}
		remarked by lpzhang 2010-4-27 ȡ���ÿ���*/
		
		
		//ũ��С�����ô��ũ�����ù�ͬ����ũ�����ũ�����ù�ͬ���������̻�����,�������ù�ͬ���������̻����ũ����������
		if(("1150010,1150050,1150060,1140130,1150020".indexOf(sBusinessType)) > -1){
			sSql = "select count(*) from ASSESSFORM_INFO where CustomerID = '"+sCustomerID+"' and AssessformType in('010','020')";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				iNum = rs.getInt(1);
			}
			rs.getStatement().close();
			if(iNum<1){
				sMessage  += "�ͻ���Ϣ��û�������õȼ�������"+"@";
			}
		}
		
		if("1140070".equals(sBusinessType)){ //��ְ��Ա������������˱����ǹ�ְ��Ա
			sSql = "select GuarantorID from GUARANTY_CONTRACT where serialno in "+
					"(select ObjectNo from apply_relative where objecttype = 'GuarantyContract' and serialNo = '"+sObjectNo+"')";
			rs = Sqlca.getASResultSet(sSql);
			while(rs.next()){
				sGuarantorID = rs.getString("GuarantorID");
				if(sGuarantorID == null) sGuarantorID = "";
				String sGovServiceFlag = Sqlca.getString("select GovServiceFlag from IND_INFO where CustomerID = '"+sGuarantorID+"'");
				if(!"1".equals(sGovServiceFlag)){
					sMessage  += "��ְ��Ա����������˱����ǹ�ְ��Ա��"+"@";
					break;
				}
			}
			rs.getStatement().close();
		}
		
		//��ũ���˾���� add by zwhu 2010098
		if("918010100".equals(sInputOrgID)){
			double dCreditCompanySum = Sqlca.getDouble("Select CreditCompanySum from Org_Info where OrgID = '"+sInputOrgID+"'");
			if(dCreditCompanySum == 0){
				sMessage  += "û�и����˾�ܾ�������Ȩ�ޣ�����ϵϵͳ����Ա��"+"@";
			}
			else {
				double dBalance = Sqlca.getDouble("select nvl(sum(Nvl(Balance,BusinessSum)*getERate(BusinessCurrency,'01',ERateDate)),0) as BalanceSum " +
						"from Business_Contract where CustomerID ='"+sCustomerID+"' and  ApplyType <>'CreditLineApply' and manageorgid = '918010100'");
				if(dBusinessSum+dBalance>dCreditCompanySum)
					sMessage  +=  "���˾ҵ���������Ž�����ʷ���ӦС�ڵ���"+dCreditCompanySum+"Ԫ��"+"@";
			}
		}
		
		/*if("CreditLineApply".equals(sApplyType)){
			sSql = "Select SerialNo from "+sMainTable+" where BAAgreement ='"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			List<String> BAObjectNos = new ArrayList<String>() ; 
			while(rs.next()){
				String sBAObjectNo = rs.getString("SerialNo");
				BAObjectNos.add(sBAObjectNo);
			}
			rs.getStatement().close();
			for(int i=0;i<BAObjectNos.size();i++){
				Anything aReturn =  interpreter.explain(Sqlca,"!BusinessManage.CheckLineApplyRisk("+BAObjectNos.get(i)+","+sObjectType+")");
				sMessage += aReturn ;
			}
		}*/
		//--------------------------------------------
		/*------------------------����ʮ�Ĳ� ��������Ƿ������--------------*/
		if(sBusinessType.startsWith("1")){
			if(dTermMonth + dTermDay<=0)
				sMessage  += "ҵ����������С���㣡"+"@";
		}
		//--------------����ʮ�岽����˾�ۺ����Ŷ���Ƿ�ͷ��տ���---------------
		//�ڡ���˾�ۺ����Ŷ�ȡ�->�����Ŷ�Ȼ�����Ϣ����������Ҫ����Ƿ�ͷ���ҵ�񡱣������б�ѡ��ǡ������񡱣�����ѡ��Ϊ���ǡ�ʱ��
		//1��	�������Ŷ�ȷ��䡱ʱ��ҵ��Ʒ�ֽ�Ϊ����������֤Ѻ�㡱������������֤���֡�����ί�д���е�һ�ֻ���ʱ�����ԡ���Ҫ������ʽ������У�飬�ж�Ϊ�ͷ����������̡�Ȩ�ޡ�
		//2��	������Ҫ������ʽ��Ϊ��100%��֤��ʱ��ֻ�С����Ŷ�ȷ��䡱ʱѡ���ҵ��Ʒ��Ϊ������������������гжһ�Ʊ����
		//����������֤�������������Ա���������Ͷ�걣������Լ������Ԥ��������������ά�ޱ������������Ᵽ��������
		//����������֤Ѻ�㡱������������֤���֡�����ί�д��
		//�е�һ���򼸸�ʱ�����ж�Ϊ�ͷ����������̣�������ִ��һ������������̡�
		//3��	������Ҫ������ʽ��Ϊ����������Ҵ浥��Ѻ������������ծȯ��Ѻ��ʱ���ж��ñ�����ִ�еͷ���ҵ���������̡�Ȩ�ޡ�

		if("3010".equals(sBusinessType))//��˾�ۺ����Ŷ��
		{
			if("1".equals(sLowRisk))//ѡ��Ϊ�ͷ���
			{
				//������Ҫ������ʽ����ΪΪ����������Ҵ浥��Ѻ������������ծȯ��Ѻ��ʱ
				if(!"0401010".equals(sVouchType)&&!"0402010".equals(sVouchType))
				{
					//������Ҫ������ʽ��Ϊ��100%��֤��,�ж϶�ȷ���ҵ���Ƿ��в����ڵͷ���ҵ��Ʒ�֡�����������������гжһ�Ʊ����
					//����������֤�������������Ա���������Ͷ�걣������Լ������Ԥ��������������ά�ޱ������������Ᵽ��������
					//����������֤Ѻ�㡱������������֤���֡�����ί�д��
					if("0105080".equals(sVouchType))
					{
						sSql = 	" select 1 from CL_INFO where ApplySerialNo = '"+sObjectNo+
						"' and BusinessType not in('2050010','2010','2050030','2040010','2040020','2040030','2030060','2040050','2040110','1080030','1080035','2070')  "+
						" and  ParentLineID <>'' and ParentLineID is not null ";
						rs = Sqlca.getASResultSet(sSql);
						if(rs.next()) 
							sMessage  += "���ٴ�ȷ���Ƿ�ͷ���ҵ��"+"@"; 
						rs.getStatement().close();
					}else
					{
						//��Ϊ��������֤Ѻ�㡱������������֤���֡�����ί�д��
						sSql = 	" select 1 from CL_INFO where ApplySerialNo = '"+sObjectNo+
						"' and BusinessType not in('1080030','1080035','2070')  "+
						" and  ParentLineID <>'' and ParentLineID is not null ";
						rs = Sqlca.getASResultSet(sSql);
						if(rs.next()) 
							sMessage  += "���ٴ�ȷ���Ƿ�ͷ���ҵ��"+"@"; 
						rs.getStatement().close();
					}	
				}		
			} 
		}
		//--------------����ʮ����������(����)����ҵ����ʾ---------------
		if(sOccurType.equals("065"))
		{
			String BDSerialNo ="";
			sSql = 	" select ObjectNo from APPLY_RELATIVE "+
					" where SerialNo = '"+sObjectNo+"' " +
					" and ObjectType = 'BusinessDueBill' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    {
		    	BDSerialNo = rs.getString("ObjectNo");
		    	if(BDSerialNo == null) BDSerialNo ="";
		    }
		    else
		    {
		    	sMessage  += "��ҵ������û�й���������(����)��ԭ��ݣ�"+"@";
		    }
		    rs.getStatement().close();		        
		}
		//--------------����ʮ�߲����ж��Ƿ�������»�����Ϣ---------------
		if(!"01".equals(sBusinessCurrency))//��������
		{
			String BDSerialNo ="";
			sSql = 	" select EfficientDate from ERATE_INFO "+
					" where Currency = '"+sBusinessCurrency+"' " +
					" and EfficientDate = '"+sToday+"' ";
			rs = Sqlca.getASResultSet(sSql);
		    if(rs.next())
		    {
		    	Sqlca.executeSQL("update Business_Apply set ERateDate ='"+sToday+"' where SerialNo = '"+sObjectNo+"' ");
		    	if("3010,3040,3050,3060,3015".indexOf(sBusinessType) > -1)//����Ƕ����Ϣ
		    	{
		    		Sqlca.executeSQL("update CL_INFO set ERateDate ='"+sToday+"' where ApplySerialNo = '"+sObjectNo+"' ");
		    	}
		    }
		    else
		    {
		    	sMessage  += "��ҵ���޶�Ӧ���ֵ����»�����Ϣ,����ϵϵͳ����Ա��"+"@";
		    }
		    rs.getStatement().close();		        
		}
		//System.out.println("sMessage:"+sMessage);
		//��෵��5��ֵ
		/*
		String[] TempMsg = sMessage.split("@");
		int i = TempMsg.length;
		if(i>5)
		{
			for(int j=1;j<=5;j++)
			{
				sMsgValue = sMsgValue + TempMsg[j]+"@";
			}
		}else{
			sMsgValue = sMessage;
		}
		*/
		return sMessage;
	 }
	

}
