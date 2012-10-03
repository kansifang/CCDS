package com.amarsoft.impl.tjnh_esb.bizlets;


import java.util.ArrayList;
import java.util.List;

import spc.webos.data.ICompositeNode;
import spc.webos.data.IMessage;
import spc.webos.data.Status;
import spc.webos.endpoint.ESB;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.ibm.mq.MQException;

/**
 * ISS000000120获取业务参考号
 * @author hldu 2012-04-17
 * 发送 custNo-核心客户号,bussClass-业务品种
 * 接收 bussConsNo-业务参考号,custNo-核心客户号,currType-币种,bussClass-业务品种,amt-申请金额,note-备注
 */
public class ESBGJTradeISS000000120 implements ESBGJTradeInterface {
	public String runESBGJTrade(String sObjectNo,String sObjectType,String sTradeType,Transaction Sqlca,String sTradeDate){
	
		//获取参数：交易日期，交易编码
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		if(sTradeType.equals("")) sTradeType = "ISS000000120";
		
		//定义变量
		String sReturn = "";       					//此类的返回参数
		String sSql = "";          					//sql 语句
		String sMFCustomerID ="";  					//核心客户号
		String sBusinessType = "";					//国结业务品种
		String sConsultNo = "";						//国结业务参考号
		String sCurrency = "";						//国结业务币种
		String sRemark = "" ;						//国结业务发票号
		Double dBusinessSum = 0.0 ;					//国结业务金额
		ASResultSet rs = null;                      //sql游标
		String sCustName = "";                      //客户中文名称
		
		/******************************获取请求数据***********************************/
		sSql =  " select CI.MFCustomerID,BP.BusinessType,BP.CustomerID " +
				" from CUSTOMER_INFO CI,BUSINESS_PUTOUT BP" +
				" where BP.SerialNo='"+sObjectNo+"' and CI.CustomerID=BP.CustomerID ";
		try{
			rs = Sqlca.getASResultSet(sSql);
			if (rs.next())
			{ 
				sMFCustomerID = rs.getString("MFCustomerID");
				sBusinessType = rs.getString("BusinessType");
			}
			rs.getStatement().close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		/*****************************设置请求报文**************************************/
		// 构造一个空报文
		ESB esb = ESB.getInstance();
		spc.webos.data.Message reqmsg = esb.newMessage(); 
		
		// 以下是设置请求报文内容
		// 具体请参照 天津农商行SOA平台接口XML报文规范-V1.0.doc
		// 请求报文头:
		reqmsg.setMsgCd(sTradeType); 							//设置此次请求的服务报文编号(必需)
		reqmsg.setRcvAppCd("ISS");								//设置此次请求的接收系统编号（必需）
		reqmsg.setCallType ("SYN");								//调用方式SYN 表示同步调用
		
		//请求报文体		
		reqmsg.setInRequest("custNo", sMFCustomerID);   		//核心客户号
		reqmsg.setInRequest("bussClass", sBusinessType);     	//业务品种             

		// 打印即将发送的报文内容
		System.out.println("req msg:请求报文 " 	+ reqmsg.toXml(true));
		/******************************获取反馈报文*******************************/
		IMessage repmsg;
		try {
			repmsg = esb.execute(reqmsg);								//发送并获取返回报文
			ICompositeNode body = repmsg.getBody();						// 获取报文体
			Status status = repmsg.getStatus();							// 获取报文状态信息

			//打印应答报文
			System.out.println("rep msg:应答报文 " 	+ repmsg.toXml(true));
			//返回成功时，将返回的国结业务信息存贮到表CONSULT_INFO中
			List ls =  new ArrayList();
		//	ls = (List) repmsg.findArrayInResponse ("result",null).plainListValue(); 
			ls = (List) repmsg.findArrayInResponse ("result",null);
			ICompositeNode node;
			if("000000".equals(status.getRetCd())&&ls.size()>0)
			{
				//删除该笔出账申请对应的查询过来的国结业务 
				Sqlca.executeSQL(" delete from CONSULT_INFO where SerialNo='"+sObjectNo+"'");
				//获取循环报文体中的报文信息
				//获取response标签中result标签元素，listValue 转为List类型
				
				for(int i=0;i<ls.size();i++)
				{					
					node = (ICompositeNode)ls.get(i);
					sConsultNo = node.get("bussConsNo").toString();
					sMFCustomerID = node.get("custNo").toString();
					sCurrency = node.get("currType").toString();
					sBusinessType = node.get("bussClass").toString();
					dBusinessSum = Double.parseDouble(node.get("amt").toString());
					sRemark = node.get("note").toString();
					sCustName = node.get("custName").toString();
		            
					//将获取的国结业务信息存贮进表
					Sqlca.executeSQL("insert into CONSULT_INFO(SerialNo,CONSULTNO,MFCUSTOMERID,CURRENCY,BUSINESSTYPE,BUSINESSSUM,REMARK,CUSTNAME) "+
							"values('"+sObjectNo+"','"+sConsultNo+"','"+sMFCustomerID+"','"+sCurrency+"','"+sBusinessType+"',"+dBusinessSum+",'"+sRemark+"','"+sCustName+"') ");
				}
				sReturn="0000000";
			}else{
				sReturn="9999999@["+sTradeType+"]交易失败，该客户在国结系统中没有找到对应的业务！";
			}	
			//ESB销毁此次连接API
			ESB.getInstance().destory();	
		}catch (MQException mqe) {
			sReturn="9999999@["+sTradeType+"]交易失败，可能是接收国结报文时连接国结服务器失败！请联系系统管理员！";
		}catch (Exception e) {
			// TODO Auto-generated catch block
			sReturn="9999999@["+sTradeType+"]交易失败，可能是组装发送报文时连接国结服务器失败！请联系系统管理员！";
			//e.printStackTrace();
		}
		return sReturn;
	}
}
