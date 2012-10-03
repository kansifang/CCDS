package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * ����չ��798005
 * ע��չ�ڳɹ���ѱ��ʺ�ͬ���ս�
 * @author zrli
 * @��������ʮ��������
 *
 */
public class MFTrade798005 implements MFTradeInterface {
	public String runMFTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "798005";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		MFMessageBuilder mb = new MFMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="",RelativeAccountNo="",Maturity="";
		ASResultSet rs,rs1=null;
		double dBalance = 0.0,dContractSum=0.0,dPutOutTotalSum=0.0;
		String sIsPigeonholeFlag = "",sContractSerialNo = "";
		try {
			sSql = "select RelativeAccountNo,Maturity,ContractSum,ContractSerialNo from BUSINESS_PUTOUT Where SerialNo = '"+sObjectNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){
				RelativeAccountNo = rs.getString("RelativeAccountNo");
				Maturity = rs.getString("Maturity");
				dContractSum=rs.getDouble("ContractSum");
				sContractSerialNo = rs.getString("ContractSerialNo");
			}
			rs.close();
			
			// �������ļ��ж�ȡ����,��ɱ���ͷ
			sm.write(mb.setValue("WholeLength"));
			sm.write(mb.setValue("MessageType"));
			sm.write(mb.setValue("TradeCode",sTradeID));
			sm.write(mb.setValue("TradeDate",sTradeDate));
			sm.write(mb.setValue("SysDate",sTradeDate));
			sm.write(mb.setValue("TradeTime",StringFunction.getNow().replace(":", ".")));
			sm.write(mb.setValue("OrgID"));//ȡĬ��ҵ�������
			sm.write(mb.setValue("TerminiterID"));
			sm.write(mb.setValue("UserID"));//ȡĬ���Ŵ�Ա���
			sm.write(mb.setValue("TradeFlag"));
			sm.write(mb.setValue("TradeSerialNo"));
			sm.write(mb.setValue("Flag1"));
			sm.write(mb.setValue("Flag2"));
			sm.write(mb.setValue("Flag3"));
			sm.write(mb.setValue("Flag4"));
			sm.write(mb.setValue("ConfirmUserID"));
			//����Ϊ����ͷ���֣�����Ϊ�����岿��
			sm.write(mb.setValue("BPSerialNo",sObjectNo));//sObjectNo
			sm.write(mb.setValue("BDSerialNo",RelativeAccountNo));//sObjectNo
			sm.write(mb.setValue("ExtendMaturity",Maturity.replace("/", "-")));//sObjectNo
			//////////////ȡ��Ӧ��ͬ�Ƿ����//////////////////////
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
				String sOutMsgID=mb.getValue("OutMsgID").substring(2,9);
				String sOutMsg="";
				rs1=Sqlca.getASResultSet("select MsgBdy from MF_ErrCode where CodeNo='" + sOutMsgID+ "'");
				if(rs1.next())
					sOutMsg = rs1.getString(1);
				sReturn=sOutMsgID+"@"+sOutMsg;
				rs1.close();
				mb.logger.debug("["+sTradeID+"]�������OutMsgID=" + mb.getValue("OutMsgID") + " ������Ϣ="+sOutMsg);
			}else if(mb.getValue("TradeType").equals("1")){
				sReturn="0000000@";
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
			
		return sReturn;
	}
}
