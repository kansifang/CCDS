package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * 个贷业务，贷款出账6001交易
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
				//////////////////合同号/////////////////////////////////
				sContractSerialNo = rs.getString("ContractSerialNo");
				////////////////机构号//////////////////
				//sOrgID = rs.getString("InputOrgID");
				sOrgID = rs.getString("PutOutOrgID");
				sUserID = rs.getString("InputUserID");
				////////////////楼宇按揭协议//////////////////////
				BuildAgreement = rs.getString("BuildAgreement");
				if(BuildAgreement == null) BuildAgreement = "";
				////////////////工程机械从协议编号/////////////
				ConstructContractNo = rs.getString("ConstructContractNo");
				if(ConstructContractNo == null) ConstructContractNo = "";
				
				
				///////////////////主要担保方式换算/////////////////////
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
				
				///////////////////担保方式换算/////////////////////
				sSql=" select sum(case when guarantytype like '010%' then 2  when guarantytype like '050%' then 4 when guarantytype like '060%' then 8 end)"+
					" from (select distinct GC.GuarantyType from contract_relative CR,guaranty_contract GC where CR.ObjectNo=GC.serialno and CR.Serialno='"+sContractSerialNo+"' ) AS TT ";
				rs1=Sqlca.getResultSet(sSql);
				if(rs1.next()){
					iVouchType=rs1.getInt(1);
					if("005".endsWith(sMainVouchType)) iVouchType+=1;
				}
				rs1.close();
				///////////////////业务类型换算/////////////////////
				BusinessType = rs.getString("BusinessType");
				Describe1 = rs.getString("Describe1");
				if(BusinessType == null) BusinessType = "";
				if(Describe1 == null) Describe1 = "";
				ThirdPartyID1 = rs.getString("ThirdPartyID1");
				//个人二手商业用房贷款,个人二手住房贷款购房协议号置空
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
				
				////////////////取合作商信息////////////////////////
				//如果为工程机械贷款取从协议信息
				if(BusinessType.equals("1140060")){
					CooperateID = ConstructContractNo;
					sSql="select DealerID from Dealer_Agreement where SerialNo='"+ConstructContractNo+"'";
					rs1=Sqlca.getResultSet(sSql);
					if(rs1.next()){
						Cooperator=rs1.getString("DealerID");
						if(Cooperator == null) Cooperator="";
					}
					rs1.close();
				//如果为其它贷款取楼宇按揭协议信息
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
				//////////////取担保抵质押金额信息//////////////////////
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
				//////////////取对应合同是否放完//////////////////////
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
				//-----------------组合报文----------------------
				try {
					// 从配置文件中读取数据,组成报文头
					sm.write(mb.setValue("WholeLength"));
					sm.write(mb.setValue("MessageType"));
					sm.write(mb.setValue("TradeCode",sTradeID));
					sm.write(mb.setValue("TradeDate",sTradeDate));
					sm.write(mb.setValue("SysDate",sTradeDate));
					sm.write(mb.setValue("TradeTime",StringFunction.getNow()));
					sm.write(mb.setValue("OrgID","9090"));//取默认业务机构号
					sm.write(mb.setValue("TerminiterID"));
					sm.write(mb.setValue("UserID",sUserID));//取默认信贷员编号
					sm.write(mb.setValue("TradeFlag"));
					sm.write(mb.setValue("TradeSerialNo",sObjectNo));//交易流水号
					sm.write(mb.setValue("Flag1"));
					sm.write(mb.setValue("Flag2"));
					sm.write(mb.setValue("Flag3"));
					sm.write(mb.setValue("Flag4"));
					sm.write(mb.setValue("ConfirmUserID",sUserID));
					//以上为报文头部分，以下为报文体部分
					sm.write(mb.setValue("BPSerialNo",sObjectNo));//信贷系统出账流水号
					sm.write(mb.setValue("BCSerialNo",sContractSerialNo));//信贷系统合同流水号
					sm.write(mb.setValue("BusinessType",BusinessType));//贷款业务类型      
					sm.write(mb.setValue("BusinessCurrency",rs.getString("BusinessCurrency")));//币种              
					sm.write(mb.setValue("BusinessSum",rs.getString("BusinessSum")));//申请金额          
					sm.write(mb.setValue("LoanBusinessSum",rs.getString("BusinessSum")));//允许贷款金额      
					sm.write(mb.setValue("TermMonth",rs.getString("TermMonth")));//贷款月数          
					sm.write(mb.setValue("TermDay",rs.getString("TermDay")));//贷款天数          
					sm.write(mb.setValue("PayCyc",rs.getString("PayCyc")));//还款间隔
					sm.write(mb.setValue("Type1",rs.getString("Type1")));//还款帐号类型      
					sm.write(mb.setValue("AccountNo",rs.getString("AccountNo")));//还款帐号          
					sm.write(mb.setValue("Type2",rs.getString("Type2")));//划款帐号类型      
					sm.write(mb.setValue("LoanAccountNo",rs.getString("LoanAccountNo")));//划款帐号          
					sm.write(mb.setValue("CorpusPayMethod",rs.getString("CorpusPayMethod")));//还款方式          
					sm.write(mb.setValue("RateFloat",rs.getString("RateFloat")));//利率浮动比        
					sm.write(mb.setValue("Type3",rs.getString("Type3")));//划款方向          
					sm.write(mb.setValue("PutoutMethod"));//放款方式          
					sm.write(mb.setValue("BusinessRate",rs.getString("BusinessRate")));//利率              
					sm.write(mb.setValue("Cooperater",Cooperator));//合作商编号    
					sm.write(mb.setValue("CooperateID",CooperateID));//合作协议编号
					sm.write(mb.setValue("TotalPrice",TotalPrice));//购买总价          
					sm.write(mb.setValue("PaySelf",PaySelf));//自付款            
					sm.write(mb.setValue("Discribe1",Discribe1));//明细信息01        
					sm.write(mb.setValue("Discribe2",Discribe2));//明细字段02        
					sm.write(mb.setValue("Discribe3",Discribe3));//明细字段03        
					sm.write(mb.setValue("VouchType",sMainVouchType));//担保方式          个贷不支持多种担保方式，关闭逻辑 add by zrli
					sm.write(mb.setValue("MainVouchType",sMainVouchType));//主担保方式
					sm.write(mb.setValue("ApplyDate",rs.getString("PutOutDate").replace("/", "-")));//申请日期          
					sm.write(mb.setValue("LoanOfficer",sUserID));//信贷员            
					sm.write(mb.setValue("ApprovalStatus","1"));//审批状态          
					sm.write(mb.setValue("ApproveDate",rs.getString("PutOutDate").replace("/", "-")));//审批通过日期      
					sm.write(mb.setValue("OperateOrgID",sOrgID));//贷款支行          
					sm.write(mb.setValue("CertType",rs.getString("CertType")));//证件类别         
					sm.write(mb.setValue("CertID",rs.getString("CertID")));//证件号码         
					sm.write(mb.setValue("CustomerName",rs.getString("CustomerName")));//姓名             
					sm.write(mb.setValue("Nationality",rs.getString("Nationality")));//民族             
					sm.write(mb.setValue("Sex",rs.getString("Sex")));//性别             
					sm.write(mb.setValue("Birthday",rs.getString("Birthday")==null?"":rs.getString("Birthday").replace("/", "-")));//出生日期         
					sm.write(mb.setValue("FamilyAdd",rs.getString("FamilyAdd")));//家庭住址         
					sm.write(mb.setValue("FamilyZIP",rs.getString("FamilyZIP")));//家庭邮编         
					sm.write(mb.setValue("FamilyTel",rs.getString("FamilyTel")));//家庭电话         
					sm.write(mb.setValue("WorkCorp",rs.getString("WorkCorp")));//单位名称         
					sm.write(mb.setValue("WorkAdd",rs.getString("WorkAdd")));//单位地址         
					sm.write(mb.setValue("WorkZip",rs.getString("WorkZip")));//单位邮编         
					sm.write(mb.setValue("WorkTel",rs.getString("WorkTel")));//单位电话         
					sm.write(mb.setValue("UnitKind","0"));//单位性质         
					sm.write(mb.setValue("HeadShip",rs.getString("HeadShip")));//本人职务         
					sm.write(mb.setValue("Occupation",rs.getString("Occupation")));//职业             
					sm.write(mb.setValue("FamilyMonthIncome",rs.getString("FamilyMonthIncome")));//个人月收入       
					sm.write(mb.setValue("YearIncome",rs.getString("YearIncome")));//家庭年总收入     
					sm.write(mb.setValue("EduDegree",rs.getString("EduExperience")));//文化程度         
					sm.write(mb.setValue("UnitKind1",rs.getString("UnitKind")));//行业             
					sm.write(mb.setValue("Position",rs.getString("Position")));//职称             
					sm.write(mb.setValue("Marriage",rs.getString("Marriage")));//婚姻状况         
					sm.write(mb.setValue("FamilyStatus",rs.getString("FamilyStatus")));//现住房权利       
					sm.write(mb.setValue("ContectType","0"));//联系方式         
					sm.write(mb.setValue("PopulationNum",rs.getString("PopulationNum")));//供养人口         
					sm.write(mb.setValue("PoliceAdd","无"));//户籍（派出所）   
					sm.write(mb.setValue("CompanyStatus","1"));//单位状况         
					sm.write(mb.setValue("IndustryStatus","1"));//行业前景         
					sm.write(mb.setValue("WorkBeginDate","0"));//本岗位工作年限   
					sm.write(mb.setValue("HealthStatus",rs.getString("HealthStatus")));//健康状况
					sm.write(mb.setValue("MFCustomerID",rs.getString("CustomerID")));//客户号 
					sm.write(mb.setValue("InputDate",rs.getString("InputDate").replace("/", "-")));//录入日期         
					sm.write(mb.setValue("NativePlace",rs.getString("NativePlace")));//证件地址 
					sm.write(mb.setValue("PayDateMethod","0"));//还款日期确定方式 
					sm.write(mb.setValue("GuarantySum1",GuarantySum1));//抵押担保主债权金额汇总
					sm.write(mb.setValue("GuarantySum2",GuarantySum2));//质押担保主债权金额汇总
					sm.write(mb.setValue("EvaluateSum1",EvalNetValue1));//抵押评估价值金额汇总
					sm.write(mb.setValue("EvaluateSum2",EvalNetValue2));//质押评估价值金额汇总
					sm.write(mb.setValue("BailAccountNo","0"));//保证金账号
					sm.write(mb.setValue("BailRatio","0"));//最低缴存保证金比例
					sm.write(mb.setValue("PutOutDate",rs.getString("PutOutDate").replace("/", "-")));//合同起始日期
					sm.write(mb.setValue("Maturity",rs.getString("Maturity").replace("/", "-")));//合同到期日期
					sm.write(mb.setValue("InterestSubsidies","0"));//贴息比率
					sm.write(mb.setValue("ContractNo",ThirdPartyID1));//购房合同号
					
					
					//报文体部分填充完毕
					sm.flush();
					mb.logger.debug("sOldTemp=" + mb.sOldTemp);
					mb.logger.debug("sNewTemp=" + mb.sNewTemp);
					mb.logger.debug("iLeng=" + mb.iLeng);
					mb.logger.info("["+sTradeID+"]发送成功！");
					// 读取返回包长
					byte[] pckbuf = new byte[4];
					sm.read(pckbuf);
					String s = new String(pckbuf, mb.CONV_CODESET);
					mb.logger.debug("Rcv_Head=" + s);
					int pcklen = Integer.parseInt(s);
					// 读取返回包
					byte[] revbuf = new byte[pcklen];
					sm.readFully(revbuf);
					mb.logger.info("["+sTradeID+"]返回数据=" + new String(revbuf, mb.CONV_CODESET));
					// 初始化xml对象
					mb.initRcv(revbuf, pcklen);
					mb.logger.debug("["+sTradeID+"]交易标志TradeType（1成功，3失败）=" + mb.getValue("TradeType"));	
					if(mb.getValue("TradeType").equals("3")){
						String sOutMsgID=mb.getValue("OutMsgID");
						String sOutMsg="";
						rs1=Sqlca.getASResultSet("select MsgBdy from GD_ErrCode where CodeNo='" + sOutMsgID+ "'");
						if(rs1.next())
							sOutMsg = rs1.getString(1);
						sReturn=sOutMsgID+"@"+sOutMsg;
						rs1.close();
						mb.logger.debug("["+sTradeID+"]错误代码OutMsgID=" + mb.getValue("OutMsgID") + " 错误信息="+sOutMsg);
					}else if(mb.getValue("TradeType").equals("1")){
						mb.logger.debug("["+sTradeID+"]交易成功");
						sReturn="0000000@"+"贷款号为["+mb.getValue("DuebillSerialNo")+"],借据号为["+mb.getValue("DuebillNo")+"]";
						Sqlca.executeSQL("Update BUSINESS_PUTOUT set SendFlag='1' where SerialNo='"+sObjectNo+"'");
						//如果为非循环合同就直接合同归档。
						if("True".equals(sIsPigeonholeFlag))
						{
							Sqlca.executeSQL("Update BUSINESS_CONTRACT set PigeonholeDate='"+StringFunction.getToday()+"' where SerialNo='"+sContractSerialNo+"' and (CycleFlag is null or CycleFlag = '' or CycleFlag ='2')");
						}
					}else
						sReturn="9999999@["+sTradeID+"]交易失败，可能是网络通讯原因！";
					// 短连接时要 关闭连接，长连接时不关闭
					sm.teardownConnection();
				} catch (Exception e) {
					sReturn="9999999@["+sTradeID+"]交易失败，可能是网络通讯原因！请联系系统管理员！";
					e.printStackTrace();
					sm.teardownConnection();
				}
			}
			rs.close();
		}catch(Exception ex){
			ex.printStackTrace();
			mb.logger.error(sSql+"["+sTradeID+"]执行出错!");
		}
		return sReturn;
	}
}
