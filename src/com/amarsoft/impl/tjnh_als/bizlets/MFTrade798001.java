package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * 新增及查询核心业务系统客户信息798001交易
 * @author zrli
 *
 */
public class MFTrade798001 implements MFTradeInterface {
	public String runMFTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "798001";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		MFMessageBuilder mb = new MFMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="",sCustomerID="",sTable="",sCustomerName="";
		ASResultSet rs,rs1=null;
		try{
			//如果为申请阶段
			if(sObjectType.equals("Customer")){
				sTable="CUSTOMER_INFO";
				sCustomerID = sObjectNo;
			}else if(sObjectType.equals("CreditApply")){
				sTable="BUSINESS_APPLY";
				sSql="select CustomerID From Business_Apply where SerialNo='"+sObjectNo+"'";
				rs1=Sqlca.getResultSet(sSql);
				if(rs1.next()){
					sCustomerID=rs1.getString("CustomerID");
					if(sCustomerID == null) sCustomerID="";
				}
				rs1.close();
			}else if(sObjectType.equals("PutOutApply")){
				sTable="BUSINESS_PUTOUT";
				sSql="select CustomerID From BUSINESS_PUTOUT where SerialNo='"+sObjectNo+"'";
				rs1=Sqlca.getResultSet(sSql);
				if(rs1.next()){
					sCustomerID=rs1.getString("CustomerID");
					if(sCustomerID == null) sCustomerID="";
				}
				rs1.close();
			}else{
				sReturn="9999997@交易失败，ObjectType=["+sObjectType+"]不支持！";
				return sReturn;
			}
		}catch(Exception ex){
			mb.logger.error("查询["+sSql+"]出错！");
			sReturn="9999996@交易失败，查询["+sSql+"]出错！";
			return sReturn;
		}

		sSql="select getMFCode('CertType',CertType,'') as CertType,CertID,CustomerName,"+
			" case when CustomerType='03' then '1' else '2' end as CustomerType "+
			" from CUSTOMER_INFO where CustomerID='"+sCustomerID+"'";
		try{
			rs=Sqlca.getResultSet(sSql);
			if(rs.next()){
				sCustomerName = rs.getString("CustomerName");
				
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
					sm.write(mb.setValue("Channel"));
					sm.write(mb.setValue("CustomerID",sCustomerID));
					sm.write(mb.setValue("CertType",rs.getString("CertType")));
					sm.write(mb.setValue("CertID",rs.getString("CertID")));
					sm.write(mb.setValue("CustomerName",sCustomerName));
					sm.write(mb.setValue("CustomerType",rs.getString("CustomerType")));
					
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
						//如果客户名称可以保持一致就提示成功
						if(sCustomerName.equals(mb.getValue("MFCustomerName"))){
							sReturn="0000000@"+mb.getValue("MFCustomerID")+mb.getValue("MFCustomerName");
							Sqlca.executeSQL("Update Customer_Info set MFCustomerID='"+mb.getValue("MFCustomerID")+"' where CustomerID='"+sCustomerID+"'");
						}else{
							sReturn="0000001@["+mb.getValue("MFCustomerID")+mb.getValue("MFCustomerName")+"]信贷系统与核心系统客户名称不一致！";
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
