package com.lmt.app.cms;

import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.baseapp.user.ASUser;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;


public class CheckPutoutRisk extends Bizlet 
{

	public Object  run(Transaction Sqlca) throws Exception
	{		
		//��ȡ�������������ͺͶ�����
		String sObjectType = (String)this.getAttribute("ObjectType");
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		String sCurUserID = (String)this.getAttribute("UserID");
		
		//����ֵת���ɿ��ַ���
		if(sObjectType == null) sObjectType = "";
		if(sObjectNo == null) sObjectNo = "";
		if(sCurUserID == null) sCurUserID = "";
		
		//�����������ʾ��Ϣ��SQL��䡢��Ʒ���͡��ͻ�����
		String sMessage = "",sSql = "",sBusinessType = "";
		//����������ͻ����롢�����������������
		String sCustomerID = "",sMainTable = "",sRelativeTable = "";
		//����������ݴ��־������֧����ʽ
		String sTempSaveFlag = "",sPaymentType = "";
		//�����������ͬ��ˮ�� add by zytan  2011-01-17
		String sBCSerialNo = "",sCreditAggreement="",sMaturity="",sPutOutDate="";
		//���������ҵ����
		double dBusinessSum = 0.0;
	
		//�����������ѯ�����
		ASResultSet rs = null;
		//add by zytan ��ʼ���û��ͻ������� 2011-01-17
		ASUser CurUser = new ASUser(sCurUserID,Sqlca);
		//ASOrg1 CurOrg1 = new ASOrg1(CurUser.OrgID,Sqlca);
		int iCount = 0;
		//BusinessInfo bi =new BusinessInfo("PutOutApply",sObjectNo,Sqlca);
		//--------------��һ�������������Ϣ�Ƿ�ȫ������---------------
		//����Ӧ�Ķ���������л�ȡ������Ϣ:�ݴ�״̬��ҵ���ҵ��Ʒ�֡�����֧����ʽ
		//rs =bi.getInfo("getErate(BusinessCurrency,'01','')*BusinessSum,BusinessType,CustomerID,PayType,ContractSerialNo,CreditAggreement,Maturity,PutOutDate", "M", "");
		/*
		while (rs.next()) { 				 
			dBusinessSum = rs.getDouble(1);				
			sBusinessType = rs.getString("BusinessType");
			sCustomerID = rs.getString("CustomerID");
			sPaymentType = rs.getString("PayType");
			sBCSerialNo = rs.getString("ContractSerialNo");		
			sCreditAggreement = rs.getString("CreditAggreement");
			sMaturity = rs.getString("Maturity");
			sPutOutDate = rs.getString("PutOutDate");
		}
		rs.getStatement().close();
		//����ֵת���ɿ��ַ���
		if (sTempSaveFlag == null) sTempSaveFlag = "";				
		if (sBusinessType == null) sBusinessType = "";
		if (sCustomerID == null) sCustomerID = "";
		if (sPaymentType == null) sPaymentType = "";
		//--------------�ڶ��������������Ϣ�Ƿ�������֧����Ϣһ��---------------
		double sPaymentSum = 0.0;//�������������֧���б��е�����֧�����
		
		sSql = "Select nvl(sum(nvl(BusinessSum,0)),0) as BusinessSum " +
				" from PAYMENT_LIST " +
				"where ObjectNo = '"+sObjectNo+"' and ObjectType = 'PaymentList'";	
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			sPaymentSum = rs.getDouble(1);
		}
		rs.getStatement().close();
	
		if((sPaymentType.equals("002")||sPaymentType.equals("003"))&& sPaymentSum <= 0){
			sMessage += "��ҵ��û������֧����Ϣ��K"+"@";
		}
		
		if(sPaymentType.equals("002") && sPaymentSum != dBusinessSum){//010 ����������֧�� ��020 ���������֧����030 �������в�������֧��
			sMessage += "��ҵ��֧����ʽΪ������������֧���������ſ����������֧����K"+"@";
		}
		
		if(sPaymentType.equals("003")  && sPaymentSum >= dBusinessSum){//010 ����������֧�� ��020 ���������֧����030 �������в�������֧��
			sMessage += "��ҵ��֧����ʽΪ�������˲������в�������֧������������֧����С�ڷſ��K"+"@";
		}
		
		//if(!sPaymentType.equals("020") && !sPaymentType.equals("030") && sPaymentSum >0){
			//sMessage += "��ҵ��������֧��������������֧���б�K"+"@";
		//}*/
		/****************************��������У������֧����ֵ��֧����ʽ֮��Ĺ�ϵ****************************************/
		/*remark by zytan ���Ҫ��ȥ����ֵУ�� 2011-01-12
		double dConsignedPaySum = 0.0;//�������������֧����ֵ
		sSql = "SELECT nvl(ConsignedPaySum,0)*getErate(BusinessCurrency,'01','') "+
			" FROM BUSINESS_CONTRACT "+
			" WHERE SerialNo in(Select ContractSerialNo from BUSINESS_PUTOUT BP where BP.SerialNo = '"+sObjectNo+"') ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next()){
			dConsignedPaySum = rs.getDouble(1);
		}
		rs.getStatement().close();
		
		if(dConsignedPaySum >0 && dBusinessSum >dConsignedPaySum && sPaymentType.equals("020")){
			sMessage += "�ñʷſ����������֧����ֵ������ʹ������֧����K"+"@";
		}
		*/
		
		/******************************���Ĳ����ύ��Ȩ��У�飨�����������������⵼�µĺ�ͬ�ܻ��˺ͺ�ͬ�Ǽ��˲�һ�£�**********************/
		/*
		if(!"1".equals(CurOrg1.sIfSmallCredit)){//��С�����Ļ���
			sSql = "select count(*) " +
				   " from business_contract " +
				   " where nvl(InputUserID,'1')<>nvl(ManageUserID,'1')  " +
				   " and SerialNo = '"+sBCSerialNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				iCount = rs.getInt(1);
			}
			rs.getStatement().close();
			if(iCount > 0 ){
				sMessage += "�ñ�ҵ���Ӧ��ͬ�ܻ������ͬ�Ǽ��˲���ͬһ�ˣ����ܽ��к���������ȡ��ԭ��ͬ���µǼǣ�K"+"@";
			}
		}
		*/
		/****************************���岽��У�����ҵ����˽���Ƿ�������ʽ��***add by ljma 2011-01-10***************/
		/*
		//���������Ҫ��֤���˽�����ͬ���������������֤������֮���Ƿ����
		if(sBusinessType.equals("1080020")){
			sSql = " select sum(getErate(FinanceCurrency,'01','')*FinanceSum) from LC_INFO where ObjectNo = "+
				   " (Select ContractSerialNo from BUSINESS_PUTOUT BP where BP.SerialNo = '"+sObjectNo+"') and ObjectType = 'BusinessContract' ";
			double dFinanceSum = 0.0;
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()) dFinanceSum = rs.getDouble(1);
			rs.getStatement().close();
			if(dFinanceSum != dBusinessSum)
				sMessage += "���˽���������֤�������ܺͣ�K"+"@";
		}
		//����������֤����Ѻ��������,������������Ѻ��������,��ҵ��Ʊ����,����͢,�������ñ���ó�����ʡ����ڻ�Ȩ����Ѻ�㡿 ��Ҫ��֤���˽���Ƿ��������������ʵ��ݵ����ʽ��
		if(sBusinessType.equals("1080030")||sBusinessType.equals("1080040")||sBusinessType.equals("1080050")
				||sBusinessType.equals("1080060")||sBusinessType.equals("1080090")||sBusinessType.equals("1080100")){
			sSql = " Select getErate(FinanceCurrency,'01','')*FinanceSum from BUSINESS_PUTOUT BP where BP.SerialNo = '"+sObjectNo+"'";
			double dFinanceSum = 0.0;
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()) dFinanceSum = rs.getDouble(1);
			rs.getStatement().close();
			if(dFinanceSum != dBusinessSum) 
				sMessage += "���˽��������ʽ�K"+"@";
		}
		*/
		/****************************�������������޶�У��***************added by lkzou 2011-04-13*/
		//��ȡ�ñ�ҵ����������
		/*
		sSql = " select ApplyType from FLOW_OBJECT FO " +
					" where exists(select * from BUSINESS_PUTOUT BP,BUSINESS_APPROVE BAP,BUSINESS_CONTRACT BC " +
					" where BP.ContractSerialNo = BC.SerialNo and BC.RelativeSerialNo = BAP.SerialNo and BAP.RelativeSerialNo = FO.ObjectNo " +
					" and BP.SerialNo = '"+sObjectNo+"') and ObjectType = 'CreditApply'";
		String sApplyType = Sqlca.getString(sSql);
		if(sApplyType == null) sApplyType = "";
		
		Bizlet  ri = new RiskLimitIntake();
		ri.setAttribute("ObjectNo", sObjectNo);
		ri.setAttribute("ObjectType",sObjectType);
		ri.setAttribute("ApplyType",sApplyType);
		sMessage += (String)ri.run(Sqlca);
		*/
		//added by bllou 2012-03-13 
		/************************������ͬ���У��***************************************
		String sVouchType = "";//�����������Ҫ������ʽ
		dBusinessSum = 0.00;//�������������ͬ���
		double dGuarantyValue = 0.00;//���������������ͬ�ܽ��
		bi =new BusinessInfo("BusinessContract",sBCSerialNo,Sqlca);
		//��ȡ��ͬ��Ҫ������ʽ
		rs = bi.getInfo("VouchType,nvl(getErate(BusinessCurrency,'01','')*BusinessSum,0)", "M", "");
		if(rs.next())
		{
			sVouchType = rs.getString("VouchType");
			dBusinessSum=rs.getDouble(2);
			if(sVouchType == null) sVouchType = "";
		}
		rs.getStatement().close();
		//��ȡ������ͬ�ܼ�ֵ
		rs = bi.getInfo("nvl(sum(getErate(GuarantyCurrency,'01','')*GuarantyValue),0)", "GC", "");
		if(rs.next())
		{
			dGuarantyValue = rs.getDouble(1);
		}
		rs.getStatement().close();
		if(!sVouchType.equals("005")&&dBusinessSum > dGuarantyValue)//����ͬ������ʽ��Ϊ�������жϵ�����ͬ�ܽ��С������ͬ���
		{
			sMessage += "��ͬ�µĵ�����ͬ�ܽ��С������ͬ��ͬ��K@";
		}
		***/	
		/*** ¼���Ѻ����Ѻ��ʱ��ծȨ�ܽ�������ڵ�����ͬ���У��ŵ���ʱ���ύ��ͬʱУ��******************
		//��ȡ��ͬ��ص�Ѻ����Ѻ������Ϣ
		sSql = " select GC.SerialNo "+
			   " from Guaranty_Relative GR,Guaranty_Contract GC,Guaranty_Info GI"+
		       " where GR.ObjectNo='"+sBCSerialNo+"'"+
		       " and GR.ObjectType = 'BusinessContract'"+
		       " and GR.ContractNo = GC.SerialNo"+
		       " and GR.GuarantyID = GI.GuarantyID"+
		       " group by GC.SerialNo,GC.GuarantyCurrency,GC.GuarantyValue"+
		       " having getErate(GC.GuarantyCurrency,'01','')*GC.GuarantyValue>sum(getErate(GI.GuarantyCurrency,'01','')*GI.ConfirmValue)";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			String sGCSerialNo = rs.getString(1);
			if(sGCSerialNo == null) sGCSerialNo = "";
			//�жϵ�����ͬ�ܽ���Ƿ�С������ͬ���
			sMessage += "������ͬ�š�"+sGCSerialNo+"���ĵ�����ͬ�ܽ���������ȫ��ծȨ��K@";
		}
		rs.getStatement().close();
		//--------------��鵣����ҵ�ۼ�ռ�ý���Ƿ񳬹������޶��Ը��˲���ҵ��
		if(sBusinessType.startsWith("1110200")||sBusinessType.startsWith("1110300")){//ֻ��Ը���ҵ��Ʒ��
			CheckGuarantyEnterpriseLimit  cgel = new CheckGuarantyEnterpriseLimit("BusinessContract",sBCSerialNo,Sqlca);
			String sReturn=cgel.action();
			if(!"true".equals(sReturn)){
				sMessage += cgel.action()+"K@";
			}
			
		}
		//--------------��鵣����ҵ�ۼ�ռ�ý���Ƿ񳬹������޶����������õ�Guaranty_Limit�ĵ����ͻ���
		sSql = " select GC.GuarantorName,"+
				" BC.OperateOrgID,BC.BusinessType as BBusinessType," +
				" GL.OrgID,GL.BusinessType as GLBusinessType,GL.Maturity,"+
				" BP.BusinessSum*(1-nvl(BP.BailRatio,0)-nvl(BP.DepositReceiptRatio,0)) as BusinessSum,"+
				" getGuarantyValue(GL.OrgID,GL.BusinessType,GC.GuarantorId,'Sum') as GuarantySumValue,"+
				" getGuarantyValue(GL.OrgID,GL.BusinessType,GC.GuarantorId,'In') as GuarantyInValue,"+
				" getGuarantyValue(GL.OrgID,GL.BusinessType,GC.GuarantorId,'Out') as GuarantyOutValue,"+
				" GL.SumLimit,GL.InLimit,GL.OutLimit"+
				" from Business_Putout BP,Business_Contract BC,Contract_Relative CR,Guaranty_Contract GC,Guaranty_Limit GL"+
				" where BP.SerialNo='"+sObjectNo+"'"+
				" and BC.SerialNo=BP.ContractSerialNo"+
				" and CR.ObjectType='GuarantyContract'"+
				" and CR.SerialNo='"+sBCSerialNo+"'"+
				" and CR.ObjectNo=GC.SerialNo"+
				" and GC.GuarantorID=GL.CustomerID"+
				" and GC.GuarantyType='010010'";//������ʽΪ��֤��
		rs = Sqlca.getASResultSet(sSql);
		int i=0;
		String sGuarantorName="";
		while(rs.next()){
			sGuarantorName = DataConvert.toString(rs.getString("GuarantorName"));
			String sOperateOrgID = DataConvert.toString(rs.getString("OperateOrgID"));
			String sBBusinessType = DataConvert.toString(rs.getString("BBusinessType"));
			String sOrgID = DataConvert.toString(rs.getString("OrgID"));
			String sGLBusinessType = DataConvert.toString(rs.getString("GLBusinessType"));
			sMaturity = DataConvert.toString(rs.getString("Maturity"));
			double BusinessSum = rs.getDouble("BusinessSum");
			if(BusinessSum<0)BusinessSum=0;
			double GuarantySumValue = rs.getDouble("GuarantySumValue")+BusinessSum;
			double GuarantyInValue = rs.getDouble("GuarantyInValue")+(sBBusinessType.substring(0,1).equals("1")?BusinessSum:0.0);
			double GuarantyOutValue = rs.getDouble("GuarantyOutValue")+(sBBusinessType.substring(0,1).equals("2")?BusinessSum:0.0);
			double SumLimit = rs.getDouble("SumLimit");
			double InLimit = rs.getDouble("InLimit");
			double OutLimit = rs.getDouble("OutLimit");
			if(sOrgID.contains(sOperateOrgID)&&sGLBusinessType.contains(sBBusinessType)&&StringFunction.getToday().compareTo(sMaturity)<=0){
				i=1;//���ڷ����������޶�
				if(GuarantySumValue>SumLimit || GuarantyInValue>InLimit || GuarantyOutValue>OutLimit){
					sMessage ="�����ͻ�"+sGuarantorName+"�ĵ������ѳ��������޶�"+
							"�����ϱ���ҵ����ռ����"+DataConvert.toString(GuarantySumValue/10000)+"�򣬵�����ҵ���ͬ���޶�Ϊ"+DataConvert.toString(SumLimit/10000)+"��"+
							"�����ϱ���ҵ�����Ǳ���ҵ�񣩱���ռ����"+DataConvert.toString(GuarantyInValue/10000)+"�򣬵����ı���ҵ���ͬ�޶�Ϊ"+DataConvert.toString(InLimit/10000)+"��"+
							"�����ϱ���ҵ�����Ǳ���ҵ�񣩱���ռ����"+DataConvert.toString(GuarantyOutValue/10000)+"�򣬵����ı���ҵ���ͬ�޶�Ϊ"+DataConvert.toString(OutLimit/10000)+"��K@";
					break;
				}else{
					continue;
				}
			}
		}
		rs.getStatement().close();
		if(i==0){//��Ȼ�����˵����ͻ����������ڷ��ϵ�ǰҵ���������޶�
			sMessage +="��ǰҵ�񲻷��ϵ����ͻ�"+sGuarantorName+"���޶��������޶��ѹ���Ч�ڡ�K@";
		}
		if(!"".equals(sCreditAggreement)){
			// �����Ԥ���ʱ���֮ǰ�Ķ������ҵ��ĵ����ղ��ܳ����ö�ȵĵ�����,��ʱ����ĵ���ҵ��ĵ����ղ��ܳ�����ȵ����պ�6����
			String sFront ="0";
			String bool = Sqlca.getString("Select case when (select BeginDate from Business_Contract where Serialno='"+sCreditAggreement+"' )>nvl(itemname,'"+StringFunction.getToday()+"') then 'false' else 'true' end from code_library where codeno='CheckCLDate'  ");
			if("2010".equals(sBusinessType))sFront = Sqlca.getString(" select nvl(ItemName,'3') from Code_library where codeno='CheckCLDateF' ");
			String sBack = Sqlca.getString("Select nvl(ItemName,'6') from code_library where codeno='CheckCLDateB' ");
			String bool1 = Sqlca.getString("Select case when date(replace('"+sMaturity+"','/','-'))>(date(replace(Maturity,'/','-'))+"+sFront+" month) then 'true' else 'flase' end��from Business_Contract where Serialno='"+sCreditAggreement+"' ");
			
			if(Boolean.parseBoolean(bool)&&Boolean.parseBoolean(bool1)){
				if("2010".equals(sBusinessType))sMessage +="�ñʷſ�ĵ����ղ������ڶ�ȵĵ����պ�"+sFront+"���£�K@";
				else sMessage +="�ñʷſ�ĵ����ղ������ڶ�ȵĵ����գ�K@";
				}	
			//�����ۺ϶������һ�����Ƶ�ҵ��Ʒ��
			boolean flag =true;
			if(sBusinessType.equals("1010020")||("1030").equals(sBusinessType.substring(0, 4))||
					("2040").equals(sBusinessType.substring(0, 4))){
				flag = false;
			}
			String bool2 = Sqlca.getString("Select case��when date(replace('"+sMaturity+"','/','-'))>(date(replace(Maturity,'/','-'))+"+sBack+" month) then 'true' else 'false' end from Business_Contract where serialno='"+sCreditAggreement+"'");
			if(!Boolean.parseBoolean(bool)&& Boolean.parseBoolean(bool2)&&flag){
				sMessage +="�ñʷſ�ĵ����ղ������ڶ�ȵ����պ�"+sBack+"���£�K@";
			}
		}
		******/
		
		return sMessage;
	 }
}