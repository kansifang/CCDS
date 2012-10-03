package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * ����ҵ�񣬴������6001����
 * @author zrli
 * @date 2010-03-01
 *
 */
public class GDTrade6001 implements GDTradeInterface {
	public String runGDTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "6001";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		GDMessageBuilder mb = new GDMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="",sCustomerID="",sMainVouchType="",sContractSerialNo="",sOrgID="",sUserID="";
		String BusinessType="",CooperateID="",TotalPrice="",PaySelf="",Discribe1="",Discribe2="",
			Discribe3="",GuarantySum1="",GuarantySum2="",BuildAgreement="",Cooperator = "",EvalNetValue1 = "",
			Describe1="",EvalNetValue2 = "",ConstructContractNo = "",sIsPigeonholeFlag = "",ThirdPartyID1 = "";
		ASResultSet rs,rs1=null;
		double dContractSum = 0.0,dPutOutTotalSum=0.0;
		int iVouchType = 0;
		
		
		sSql="select BP.ContractSerialNo,getMFCustomerid(BP.CustomerID) as CustomerID,BP.CustomerName,BP.BusinessSum," +
				"BP.BusinessType,BP.BusinessCurrency,BP.BusinessRate,BP.ContractSum,BP.VouchType," +
				"BP.TermMonth,BP.TermDay,BP.PutOutDate,BP.Maturity,BP.MaterialFlag," +
				"BP.ApprovalNo,BP.Type1,BP.AccountNo,BP.Type2,BP.LoanAccountNo," +
				"BP.PayCyc,BP.CorpusPayMethod,BP.RateFloat,BP.Type3," +
				"getGDCode('CertType',II.CertType,'') as CertType,II.CertID,getGDCode('Sex',II.Sex,'') as Sex,II.Birthday,"+
				"getGDCode('EducationExperience',II.EduExperience,'') as EduExperience," +
				"getGDCode('EducationDegree',II.EduDegree,'') as EduDegree,II.SINo,II.Staff,getGDCode('Nationality',II.Nationality,'') as Nationality,II.NativePlace," +
				"II.IndRPRType,II.BizHouseFlag,II.HousemasterFlag,II.GovServiceFlag,II.CreditBelong," +
				"II.CreditLevel,II.PoliticalFace,getGDCode('Marriage',II.Marriage,'') as Marriage,"+
				"getGDCode('HealthStatus',II.HealthStatus,'') as HealthStatus,II.CountryCode," +
				"II.RegionCode,II.FamilyAdd,II.FamilyZIP,II.FamilyTel,getGDCode('FamilyStatus',II.FamilyStatus,'') as FamilyStatus," +
				"II.MobileTelephone,II.EmailAdd,II.CommAdd,II.CommZip,getGDCode('Occupation',II.Occupation,'') as Occupation," +
				"getGDCode('HeadShip',II.HeadShip,'') as HeadShip,getGDCode('TechPost',II.Position,'') as Position,II.FamilyMonthIncome,II.MonthReturnSum,II.YearIncome," +
				"II.IncomeSource,II.PopulationNum,II.IndRate,II.Character,getGDCode('IndustryType',II.UnitKind,'') as UnitKind," +
				"II.WorkCorp,II.WorkAdd,II.WorkZip,II.WorkTel,II.WorkBeginDate,BC.BuildAgreement," +
				"II.EduRecord,GetMFUserID(BP.InputUserID) as InputUserID,GetMFOrgID(BP.InputOrgID) as InputOrgID," +
				"BP.InputDate,BC.ThirdParty1,BC.ThirdPartyID1,BC.Describe1,BC.ConstructContractNo,getMFOrgID(BP.PutOutOrgID) as PutOutOrgID "+
				" from BUSINESS_PUTOUT BP,IND_INFO II,BUSINESS_CONTRACT BC " +
				" where BP.SerialNo='"+sObjectNo+"' and BP.CustomerID=II.CustomerID and BP.ContractSerialNo=BC.SerialNo";
		try{
			rs=Sqlca.getResultSet(sSql);
			if(rs.next()){
				//////////////////��ͬ��/////////////////////////////////
				sContractSerialNo = rs.getString("ContractSerialNo");
				////////////////������//////////////////
				//sOrgID = rs.getString("InputOrgID");
				sOrgID = rs.getString("PutOutOrgID");
				sUserID = rs.getString("InputUserID");
				////////////////¥���Э��//////////////////////
				BuildAgreement = rs.getString("BuildAgreement");
				if(BuildAgreement == null) BuildAgreement = "";
				////////////////���̻�е��Э����/////////////
				ConstructContractNo = rs.getString("ConstructContractNo");
				if(ConstructContractNo == null) ConstructContractNo = "";
				
				
				///////////////////��Ҫ������ʽ����/////////////////////
				sMainVouchType = rs.getString("VouchType");
				if(sMainVouchType == null) sMainVouchType = "";
				if(sMainVouchType.startsWith("005"))
					sMainVouchType="0";
				else if(sMainVouchType.startsWith("010"))
					sMainVouchType="1";
				else if(sMainVouchType.startsWith("020"))
					sMainVouchType="2";
				else if(sMainVouchType.startsWith("040"))
					sMainVouchType="3";
				
				///////////////////������ʽ����/////////////////////
				sSql=" select sum(case when guarantytype like '010%' then 2  when guarantytype like '050%' then 4 when guarantytype like '060%' then 8 end)"+
					" from (select distinct GC.GuarantyType from contract_relative CR,guaranty_contract GC where CR.ObjectNo=GC.serialno and CR.Serialno='"+sContractSerialNo+"' ) AS TT ";
				rs1=Sqlca.getResultSet(sSql);
				if(rs1.next()){
					iVouchType=rs1.getInt(1);
					if("005".endsWith(sMainVouchType)) iVouchType+=1;
				}
				rs1.close();
				///////////////////ҵ�����ͻ���/////////////////////
				BusinessType = rs.getString("BusinessType");
				Describe1 = rs.getString("Describe1");
				if(BusinessType == null) BusinessType = "";
				if(Describe1 == null) Describe1 = "";
				ThirdPartyID1 = rs.getString("ThirdPartyID1");
				//���˶�����ҵ�÷�����,���˶���ס�������Э����ÿ�
				if("1110020".equals(BusinessType)||"1140020".equals(BusinessType))
				{
					ThirdPartyID1="";
				}
				if(BusinessType.equals("1110010"))
				{
					if("01".equals(Describe1))
					{
						BusinessType = "102";
					}else if("02".equals(Describe1)){
						BusinessType = "106";
					}else
					{
						BusinessType = "131";
					}
				}else if(BusinessType.equals("1110020"))
				{
					if("01".equals(Describe1))
					{
						BusinessType = "104";
					}else if("02".equals(Describe1))
					{
						BusinessType = "113";
					}else
					{
						BusinessType = "132";
					}
				}else if(BusinessType.equals("1110025"))
				{
					if("01".equals(Describe1))
					{
						BusinessType = "141";
					}else if("02".equals(Describe1))
					{
						BusinessType = "142";
					}else
					{
						BusinessType = "143";
					}
				}else if(BusinessType.equals("1140110"))
					BusinessType = "114";
				else if(BusinessType.equals("1140010"))
					BusinessType = "103";
				else if(BusinessType.equals("1140020"))
					BusinessType = "152";
				else if(BusinessType.equals("1140025"))
					BusinessType = "151";
				else if(BusinessType.equals("1140060"))
					BusinessType = "112";
				else if(BusinessType.equals("2110010"))
					BusinessType = "105"; 
				
				////////////////ȡ��������Ϣ////////////////////////
				//���Ϊ���̻�е����ȡ��Э����Ϣ
				if(BusinessType.equals("1140060")){
					CooperateID = ConstructContractNo;
					sSql="select DealerID from Dealer_Agreement where SerialNo='"+ConstructContractNo+"'";
					rs1=Sqlca.getResultSet(sSql);
					if(rs1.next()){
						Cooperator=rs1.getString("DealerID");
						if(Cooperator == null) Cooperator="";
					}
					rs1.close();
				//���Ϊ��������ȡ¥���Э����Ϣ
				}else{
					CooperateID = BuildAgreement;
					sSql="select CustomerID from ent_agreement where SerialNo='"+BuildAgreement+"'";
					rs1=Sqlca.getResultSet(sSql);
					if(rs1.next()){
						Cooperator=rs1.getString("CustomerID");
						if(Cooperator == null) Cooperator="";
					}
					rs1.close();
				}
				//////////////ȡ��������Ѻ�����Ϣ//////////////////////
				sSql="  select  sum(case when guarantytype like '010%' then EvalNetValue else 0 end) as EvalNetValue1 , "+
					"sum(case when guarantytype like '010%' then AboutSum2 else 0 end) as GuarantySum1, "+
					"sum(case when guarantytype like '020%' then EvalNetValue else 0 end) as EvalNetValue2, "+
					"sum(case when guarantytype like '020%' then AboutSum2 else 0 end) as GuarantySum2 from GUARANTY_INFO "+ 
					"where GuarantyID in (select GuarantyID from GUARANTY_RELATIVE where ObjectType = 'BusinessContract' and ObjectNo = '"+sContractSerialNo+"' ) ";
				rs1=Sqlca.getResultSet(sSql);
				if(rs1.next()){
					EvalNetValue1=rs1.getString("EvalNetValue1");
					GuarantySum1=rs1.getString("GuarantySum1");
					EvalNetValue2=rs1.getString("EvalNetValue2");
					GuarantySum2=rs1.getString("GuarantySum2");
					
				}
				rs1.close();
				//////////////ȡ��Ӧ��ͬ�Ƿ����//////////////////////
				dContractSum=rs.getDouble("ContractSum");
				sSql="  select SUM(BusinessSum) as PutOutTotalSum from BUSINESS_PUTOUT where ContractSerialNo='"+sContractSerialNo+"'";
				rs1=Sqlca.getResultSet(sSql);
				if(rs1.next()){
					dPutOutTotalSum=rs1.getDouble("PutOutTotalSum");
				}
				rs1.close();
				if(dPutOutTotalSum>=dContractSum)
				{
					sIsPigeonholeFlag="True";
				}
				//-----------------��ϱ���----------------------
				try {
					// �������ļ��ж�ȡ����,��ɱ���ͷ
					sm.write(mb.setValue("WholeLength"));
					sm.write(mb.setValue("MessageType"));
					sm.write(mb.setValue("TradeCode",sTradeID));
					sm.write(mb.setValue("TradeDate",sTradeDate));
					sm.write(mb.setValue("SysDate",sTradeDate));
					sm.write(mb.setValue("TradeTime",StringFunction.getNow()));
					sm.write(mb.setValue("OrgID","9090"));//ȡĬ��ҵ�������
					sm.write(mb.setValue("TerminiterID"));
					sm.write(mb.setValue("UserID",sUserID));//ȡĬ���Ŵ�Ա���
					sm.write(mb.setValue("TradeFlag"));
					sm.write(mb.setValue("TradeSerialNo",sObjectNo));//������ˮ��
					sm.write(mb.setValue("Flag1"));
					sm.write(mb.setValue("Flag2"));
					sm.write(mb.setValue("Flag3"));
					sm.write(mb.setValue("Flag4"));
					sm.write(mb.setValue("ConfirmUserID",sUserID));
					//����Ϊ����ͷ���֣�����Ϊ�����岿��
					sm.write(mb.setValue("BPSerialNo",sObjectNo));//�Ŵ�ϵͳ������ˮ��
					sm.write(mb.setValue("BCSerialNo",sContractSerialNo));//�Ŵ�ϵͳ��ͬ��ˮ��
					sm.write(mb.setValue("BusinessType",BusinessType));//����ҵ������      
					sm.write(mb.setValue("BusinessCurrency",rs.getString("BusinessCurrency")));//����              
					sm.write(mb.setValue("BusinessSum",rs.getString("BusinessSum")));//������          
					sm.write(mb.setValue("LoanBusinessSum",rs.getString("BusinessSum")));//���������      
					sm.write(mb.setValue("TermMonth",rs.getString("TermMonth")));//��������          
					sm.write(mb.setValue("TermDay",rs.getString("TermDay")));//��������          
					sm.write(mb.setValue("PayCyc",rs.getString("PayCyc")));//������
					sm.write(mb.setValue("Type1",rs.getString("Type1")));//�����ʺ�����      
					sm.write(mb.setValue("AccountNo",rs.getString("AccountNo")));//�����ʺ�          
					sm.write(mb.setValue("Type2",rs.getString("Type2")));//�����ʺ�����      
					sm.write(mb.setValue("LoanAccountNo",rs.getString("LoanAccountNo")));//�����ʺ�          
					sm.write(mb.setValue("CorpusPayMethod",rs.getString("CorpusPayMethod")));//���ʽ          
					sm.write(mb.setValue("RateFloat",rs.getString("RateFloat")));//���ʸ�����        
					sm.write(mb.setValue("Type3",rs.getString("Type3")));//�����          
					sm.write(mb.setValue("PutoutMethod"));//�ſʽ          
					sm.write(mb.setValue("BusinessRate",rs.getString("BusinessRate")));//����              
					sm.write(mb.setValue("Cooperater",Cooperator));//�����̱��    
					sm.write(mb.setValue("CooperateID",CooperateID));//����Э����
					sm.write(mb.setValue("TotalPrice",TotalPrice));//�����ܼ�          
					sm.write(mb.setValue("PaySelf",PaySelf));//�Ը���            
					sm.write(mb.setValue("Discribe1",Discribe1));//��ϸ��Ϣ01        
					sm.write(mb.setValue("Discribe2",Discribe2));//��ϸ�ֶ�02        
					sm.write(mb.setValue("Discribe3",Discribe3));//��ϸ�ֶ�03        
					sm.write(mb.setValue("VouchType",sMainVouchType));//������ʽ          ������֧�ֶ��ֵ�����ʽ���ر��߼� add by zrli
					sm.write(mb.setValue("MainVouchType",sMainVouchType));//��������ʽ
					sm.write(mb.setValue("ApplyDate",rs.getString("PutOutDate").replace("/", "-")));//��������          
					sm.write(mb.setValue("LoanOfficer",sUserID));//�Ŵ�Ա            
					sm.write(mb.setValue("ApprovalStatus","1"));//����״̬          
					sm.write(mb.setValue("ApproveDate",rs.getString("PutOutDate").replace("/", "-")));//����ͨ������      
					sm.write(mb.setValue("OperateOrgID",sOrgID));//����֧��          
					sm.write(mb.setValue("CertType",rs.getString("CertType")));//֤�����         
					sm.write(mb.setValue("CertID",rs.getString("CertID")));//֤������         
					sm.write(mb.setValue("CustomerName",rs.getString("CustomerName")));//����             
					sm.write(mb.setValue("Nationality",rs.getString("Nationality")));//����             
					sm.write(mb.setValue("Sex",rs.getString("Sex")));//�Ա�             
					sm.write(mb.setValue("Birthday",rs.getString("Birthday")==null?"":rs.getString("Birthday").replace("/", "-")));//��������         
					sm.write(mb.setValue("FamilyAdd",rs.getString("FamilyAdd")));//��ͥסַ         
					sm.write(mb.setValue("FamilyZIP",rs.getString("FamilyZIP")));//��ͥ�ʱ�         
					sm.write(mb.setValue("FamilyTel",rs.getString("FamilyTel")));//��ͥ�绰         
					sm.write(mb.setValue("WorkCorp",rs.getString("WorkCorp")));//��λ����         
					sm.write(mb.setValue("WorkAdd",rs.getString("WorkAdd")));//��λ��ַ         
					sm.write(mb.setValue("WorkZip",rs.getString("WorkZip")));//��λ�ʱ�         
					sm.write(mb.setValue("WorkTel",rs.getString("WorkTel")));//��λ�绰         
					sm.write(mb.setValue("UnitKind","0"));//��λ����         
					sm.write(mb.setValue("HeadShip",rs.getString("HeadShip")));//����ְ��         
					sm.write(mb.setValue("Occupation",rs.getString("Occupation")));//ְҵ             
					sm.write(mb.setValue("FamilyMonthIncome",rs.getString("FamilyMonthIncome")));//����������       
					sm.write(mb.setValue("YearIncome",rs.getString("YearIncome")));//��ͥ��������     
					sm.write(mb.setValue("EduDegree",rs.getString("EduExperience")));//�Ļ��̶�         
					sm.write(mb.setValue("UnitKind1",rs.getString("UnitKind")));//��ҵ             
					sm.write(mb.setValue("Position",rs.getString("Position")));//ְ��             
					sm.write(mb.setValue("Marriage",rs.getString("Marriage")));//����״��         
					sm.write(mb.setValue("FamilyStatus",rs.getString("FamilyStatus")));//��ס��Ȩ��       
					sm.write(mb.setValue("ContectType","0"));//��ϵ��ʽ         
					sm.write(mb.setValue("PopulationNum",rs.getString("PopulationNum")));//�����˿�         
					sm.write(mb.setValue("PoliceAdd","��"));//�������ɳ�����   
					sm.write(mb.setValue("CompanyStatus","1"));//��λ״��         
					sm.write(mb.setValue("IndustryStatus","1"));//��ҵǰ��         
					sm.write(mb.setValue("WorkBeginDate","0"));//����λ��������   
					sm.write(mb.setValue("HealthStatus",rs.getString("HealthStatus")));//����״��
					sm.write(mb.setValue("MFCustomerID",rs.getString("CustomerID")));//�ͻ��� 
					sm.write(mb.setValue("InputDate",rs.getString("InputDate").replace("/", "-")));//¼������         
					sm.write(mb.setValue("NativePlace",rs.getString("NativePlace")));//֤����ַ 
					sm.write(mb.setValue("PayDateMethod","0"));//��������ȷ����ʽ 
					sm.write(mb.setValue("GuarantySum1",GuarantySum1));//��Ѻ������ծȨ������
					sm.write(mb.setValue("GuarantySum2",GuarantySum2));//��Ѻ������ծȨ������
					sm.write(mb.setValue("EvaluateSum1",EvalNetValue1));//��Ѻ������ֵ������
					sm.write(mb.setValue("EvaluateSum2",EvalNetValue2));//��Ѻ������ֵ������
					sm.write(mb.setValue("BailAccountNo","0"));//��֤���˺�
					sm.write(mb.setValue("BailRatio","0"));//��ͽɴ汣֤�����
					sm.write(mb.setValue("PutOutDate",rs.getString("PutOutDate").replace("/", "-")));//��ͬ��ʼ����
					sm.write(mb.setValue("Maturity",rs.getString("Maturity").replace("/", "-")));//��ͬ��������
					sm.write(mb.setValue("InterestSubsidies","0"));//��Ϣ����
					sm.write(mb.setValue("ContractNo",ThirdPartyID1));//������ͬ��
					
					
					//�����岿��������
					sm.flush();
					mb.logger.debug("sOldTemp=" + mb.sOldTemp);
					mb.logger.debug("sNewTemp=" + mb.sNewTemp);
					mb.logger.debug("iLeng=" + mb.iLeng);
					mb.logger.info("["+sTradeID+"]���ͳɹ���");
					// ��ȡ���ذ���
					byte[] pckbuf = new byte[4];
					sm.read(pckbuf);
					String s = new String(pckbuf, mb.CONV_CODESET);
					mb.logger.debug("Rcv_Head=" + s);
					int pcklen = Integer.parseInt(s);
					// ��ȡ���ذ�
					byte[] revbuf = new byte[pcklen];
					sm.readFully(revbuf);
					mb.logger.info("["+sTradeID+"]��������=" + new String(revbuf, mb.CONV_CODESET));
					// ��ʼ��xml����
					mb.initRcv(revbuf, pcklen);
					mb.logger.debug("["+sTradeID+"]���ױ�־TradeType��1�ɹ���3ʧ�ܣ�=" + mb.getValue("TradeType"));	
					if(mb.getValue("TradeType").equals("3")){
						String sOutMsgID=mb.getValue("OutMsgID");
						String sOutMsg="";
						rs1=Sqlca.getASResultSet("select MsgBdy from GD_ErrCode where CodeNo='" + sOutMsgID+ "'");
						if(rs1.next())
							sOutMsg = rs1.getString(1);
						sReturn=sOutMsgID+"@"+sOutMsg;
						rs1.close();
						mb.logger.debug("["+sTradeID+"]�������OutMsgID=" + mb.getValue("OutMsgID") + " ������Ϣ="+sOutMsg);
					}else if(mb.getValue("TradeType").equals("1")){
						mb.logger.debug("["+sTradeID+"]���׳ɹ�");
						sReturn="0000000@"+"�����Ϊ["+mb.getValue("DuebillSerialNo")+"],��ݺ�Ϊ["+mb.getValue("DuebillNo")+"]";
						Sqlca.executeSQL("Update BUSINESS_PUTOUT set SendFlag='1' where SerialNo='"+sObjectNo+"'");
						//���Ϊ��ѭ����ͬ��ֱ�Ӻ�ͬ�鵵��
						if("True".equals(sIsPigeonholeFlag))
						{
							Sqlca.executeSQL("Update BUSINESS_CONTRACT set PigeonholeDate='"+StringFunction.getToday()+"' where SerialNo='"+sContractSerialNo+"' and (CycleFlag is null or CycleFlag = '' or CycleFlag ='2')");
						}
					}else
						sReturn="9999999@["+sTradeID+"]����ʧ�ܣ�����������ͨѶԭ��";
					// ������ʱҪ �ر����ӣ�������ʱ���ر�
					sm.teardownConnection();
				} catch (Exception e) {
					sReturn="9999999@["+sTradeID+"]����ʧ�ܣ�����������ͨѶԭ������ϵϵͳ����Ա��";
					e.printStackTrace();
					sm.teardownConnection();
				}
			}
			rs.close();
		}catch(Exception ex){
			ex.printStackTrace();
			mb.logger.error(sSql+"["+sTradeID+"]ִ�г���!");
		}
		return sReturn;
	}
}
