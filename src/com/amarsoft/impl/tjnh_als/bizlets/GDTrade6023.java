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
public class GDTrade6023 implements GDTradeInterface {
	public String runGDTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "6023";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		GDMessageBuilder mb = new GDMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="",sContractSerialNo="",sOrgID="",sUserID="";
		String sIsPigeonholeFlag = "";
		ASResultSet rs,rs1=null;
		String  EvalNetValue1 = "",GuarantySum1 = "",EvalNetValue2 = "",GuarantySum2="";
		String sBuinessType = "";
		double dContractSum = 0.0,dPutOutTotalSum=0.0;
		
		
		sSql="select BP.ContractSerialNo as ContractSerialNo,BP.ContractSum as ContractSum,GetMFUserID(BP.InputUserID) as InputUserID,GetMFOrgID(BP.InputOrgID) as InputOrgID," +
				"BP.InputDate,BC.ThirdParty1,BC.Describe1,BC.ConstructContractNo,BP.COMMERCIALNO,BP.ACCUMULATIONNO, "+
				"BP.BusinessType as BusinessType "+
				" from BUSINESS_PUTOUT BP,IND_INFO II,BUSINESS_CONTRACT BC " +
				" where BP.SerialNo='"+sObjectNo+"' and BP.CustomerID=II.CustomerID and BP.ContractSerialNo=BC.SerialNo";
		try{
			rs=Sqlca.getResultSet(sSql);
			if(rs.next()){
				////////////////机构号//////////////////
				sOrgID = rs.getString("InputOrgID");
				sUserID = rs.getString("InputUserID");
				sContractSerialNo = rs.getString("ContractSerialNo");
				sBuinessType = rs.getString("BusinessType");
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
					sm.write(mb.setValue("CommercialNo",rs.getString("COMMERCIALNO")));//商贷号
					sm.write(mb.setValue("AccumulationNo",rs.getString("ACCUMULATIONNO")));//委贷号
					sm.write(mb.setValue("GuarantySum1",GuarantySum1));//抵押担保主债权金额汇总
					sm.write(mb.setValue("GuarantySum2",GuarantySum2));//质押担保主债权金额汇总
					sm.write(mb.setValue("EvaluateSum1",EvalNetValue1));//抵押评估价值金额汇总
					sm.write(mb.setValue("EvaluateSum2",EvalNetValue2));//质押评估价值金额汇总
					sm.write(mb.setValue("BailAccountNo","0"));//保证金账号
					sm.write(mb.setValue("BailRatio","0"));//最低缴存保证金比例
					sm.write(mb.setValue("PutOutUserID",sUserID));//信贷员
					sm.write(mb.setValue("PutOutOrgID",sOrgID));//贷款支行
					
					
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
						if("2110020".equals(sBuinessType))
						{
							sReturn="0000000@"+"贷款号为["+rs.getString("ACCUMULATIONNO")+"],借据号为["+mb.getValue("AccumulationDuebillNo")+"]";
						}else{
							sReturn="0000000@"+"贷款号为["+rs.getString("COMMERCIALNO")+"],借据号为["+mb.getValue("CommercialDuebillNo")+"]";
						}
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
