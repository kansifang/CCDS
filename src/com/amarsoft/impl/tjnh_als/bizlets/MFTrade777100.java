package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * 抵质押物入库交易777100交易
 * @author xhyong 2012/07/26
 *
 */
public class MFTrade777100 implements MFTradeInterface {
	public String runMFTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "777100";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		MFMessageBuilder mb = new MFMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="";
		ASResultSet rs,rs1 = null;
		String sLoanOrgID = "",sGuarantyID = "",sBCSerialNO = "",
			sOwnerName = "",sShareCustomerName = "",sGCSerialNo = "",
			sGuarantyType = "",sGuarantyList = "",sGuarantyTypeName = "",
			sFidate = "",sAmount = "",sUnit = "",sModel = "",sVouchType = "",
			sConfirmValue = "",sGuarantyCurrency = "",sEvalNetValue = "",
			sAboutSum2 = "",sRPName = "",sGuarantyRightID = "",sRPOfer	 = "";
		try{
			//如果为申请阶段
			
			sSql="select '' as LoanOrgID,GI.GuarantyID,GR.ObjectNo as BCSerialNo,"+
				" GI.OwnerName,GI.ShareCustomerName,GR.ContractNo as GCSerialNo,"+
				" GI.GuarantyType,'' as GuarantyList,getItemName('GuarantyList',GI.GuarantyType) as GuarantyTypeName,"+
				" '' as Fidate,'' as Amount,'' as Unit,"+
				" '' as Model,(case when GI.GuarantyType like '010%' then '01' else '02' end) as VouchType," +
				" GI.ConfirmValue,GI.GuarantyCurrency,GI.EvalNetValue,GI.AboutSum2,"+
				" '' as RPName,GI.GuarantyRightID,'' as RPOfer "+
			" from GUARANTY_RELATIVE GR,GUARANTY_INFO GI "+
			" where GR.GuarantyID=GI.GuarantyID "+
				"and GR.ObjectType='BusinessContract' "+
				" and GI.GuarantyStatus<>'02' "+
				"and GI.GuarantyID='"+sObjectNo+"' ";
			rs=Sqlca.getResultSet(sSql);
			if(rs.next()){
				sLoanOrgID = rs.getString("LoanOrgID");
				sGuarantyID = rs.getString("GuarantyID");
				sBCSerialNO = rs.getString("BCSerialNO");
				sOwnerName = rs.getString("OwnerName");
				sShareCustomerName = rs.getString("ShareCustomerName");
				sGCSerialNo = rs.getString("GCSerialNo");
				sGuarantyType = rs.getString("GuarantyType");
				sGuarantyList = rs.getString("GuarantyList");
				sGuarantyTypeName = rs.getString("GuarantyTypeName");
				sFidate = rs.getString("Fidate");
				sAmount = rs.getString("Amount");
				sUnit = rs.getString("Unit");
				sModel = rs.getString("Model");
				sVouchType = rs.getString("VouchType");
				sConfirmValue = rs.getString("ConfirmValue");
				sGuarantyCurrency = rs.getString("GuarantyCurrency");
				sEvalNetValue = rs.getString("EvalNetValue");
				sAboutSum2 = rs.getString("AboutSum2");
				sRPName = rs.getString("RPName");
				sGuarantyRightID = rs.getString("GuarantyRightID");
				sRPOfer	 = rs.getString("RPOfer");
			}
			rs.close();
			
		}catch(Exception ex){
			mb.logger.error("查询["+sSql+"]出错！");
			sReturn="9999996@交易失败，查询["+sSql+"]出错！";
			return sReturn;
		}

		try{
				
				//-----------------组合报文----------------------
				try {
					// 从配置文件中读取数据,组成报文头
					sm.write(mb.setValue("WholeLength"));
					sm.write(mb.setValue("MessageType"));
					sm.write(mb.setValue("TradeCode"));
					sm.write(mb.setValue("TradeDate",sTradeDate));
					sm.write(mb.setValue("SysDate",sTradeDate));
					sm.write(mb.setValue("TradeTime",StringFunction.getNow().replace(":", ".")));
					sm.write(mb.setValue("OrgID"));//取默认业务机构号
					sm.write(mb.setValue("TerminiterID"));
					sm.write(mb.setValue("UserID"));//取默认信贷员编号
					sm.write(mb.setValue("TradeFlag"));
					sm.write(mb.setValue("TradeSerialNo"));
					sm.write(mb.setValue("Flag1"));
					sm.write(mb.setValue("Flag2"));
					sm.write(mb.setValue("Flag3"));
					sm.write(mb.setValue("Flag4"));
					sm.write(mb.setValue("ConfirmUserID"));
					//以上为报文头部分，以下为报文体部分
					sm.write(mb.setValue("LoanOrgID",sLoanOrgID)); //机构号
					sm.write(mb.setValue("GuarantyID",sGuarantyID)); //担保品编号
					sm.write(mb.setValue("BCSerialNo",sBCSerialNO)); //信贷合同号
					sm.write(mb.setValue("OwnerName",sOwnerName)); //担保品所有人
					sm.write(mb.setValue("ShareCustomerName",sShareCustomerName)); //担保品共有人
					sm.write(mb.setValue("GCSerialNo",sGCSerialNo)); //担保合同编号
					sm.write(mb.setValue("GuarantyType",sGuarantyType)); //担保品种类
					sm.write(mb.setValue("GuarantyList",sGuarantyList)); //担保品分类码
					sm.write(mb.setValue("GuarantyTypeName",sGuarantyTypeName)); //担保品名称
					sm.write(mb.setValue("FIdate",sFidate)); //担保品到期日
					sm.write(mb.setValue("Amount",sAmount)); //数量
					sm.write(mb.setValue("Unit",sUnit)); //单位
					sm.write(mb.setValue("Model",sModel)); //规格型号
					sm.write(mb.setValue("VouchType",sVouchType)); //担保方式
					sm.write(mb.setValue("ConfirmValue",sConfirmValue)); //当前估价
					sm.write(mb.setValue("GuarantyCurrency",sGuarantyCurrency)); //币种
					sm.write(mb.setValue("EvalNetValue",sEvalNetValue)); //评估价值
					sm.write(mb.setValue("AboutSum2",sAboutSum2)); //抵押登记金额
					sm.write(mb.setValue("RPName",sRPName)); //权利证书名称
					sm.write(mb.setValue("GuarantyRightID",sGuarantyRightID)); //权利证书号码
					sm.write(mb.setValue("RPOfer",sRPOfer)); //权利证书提供人
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
						String sOutMsgID=mb.getValue("OutMsgID").substring(2,9);
						String sOutMsg="";
						rs1=Sqlca.getASResultSet("select MsgBdy from MF_ErrCode where CodeNo='" + sOutMsgID+ "'");
						if(rs1.next())
							sOutMsg = rs1.getString(1);
						sReturn=sOutMsgID+"@"+sOutMsg+"|"+mb.getValue("OutMsg");
						rs1.close();
						mb.logger.debug("["+sTradeID+"]错误代码OutMsgID=" + mb.getValue("OutMsgID") + " 错误信息="+sOutMsg+"|"+mb.getValue("OutMsg"));
					}else if(mb.getValue("TradeType").equals("1")){
						mb.logger.debug("["+sTradeID+"]交易成功");
					}else
						sReturn="9999999@["+sTradeID+"]交易失败，可能是网络通讯原因！";
					// 短连接时要 关闭连接，长连接时不关闭
					sm.teardownConnection();
				} catch (Exception e) {
					sReturn="9999999@["+sTradeID+"]交易失败，可能是网络通讯原因！请联系系统管理员！";
					e.printStackTrace();
					sm.teardownConnection();
				}
		}catch(Exception ex){
			ex.printStackTrace();
			mb.logger.error(sSql+"["+sTradeID+"]执行出错!");
		}
		return sReturn;
	}
}
