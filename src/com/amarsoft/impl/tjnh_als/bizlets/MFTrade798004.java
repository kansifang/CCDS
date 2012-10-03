package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * ʵʱ����ѯ798004
 * @author zrli
 * @��������ʮ��������
 *
 */
public class MFTrade798004 implements MFTradeInterface {
	public String runMFTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "798004";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		MFMessageBuilder mb = new MFMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="";
		ASResultSet rs,rs1=null;
		double dBalance = 0.0;
		double dNormalBalance = 0.0;
		double dOverdueBalance = 0.0;
		double dDullBalance = 0.0;
		double dBadBalance = 0.0;
		double dInterestBalance1 = 0.0;
		double dInterestBalance2 = 0.0;
		
		try {
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
			sm.write(mb.setValue("BCSerialNo",sObjectNo));//sObjectNo
								
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
				sReturn=sOutMsgID+"@"+sOutMsg+"|"+mb.getValue("OutMsg");
				rs1.close();
				mb.logger.debug("["+sTradeID+"]�������OutMsgID=" + mb.getValue("OutMsgID") + " ������Ϣ="+sOutMsg+"|"+mb.getValue("OutMsg"));
			}else if(mb.getValue("TradeType").equals("1")){
				dBalance = Double.parseDouble(mb.getValue("Balance"))/100.00;
				dNormalBalance = Double.parseDouble(mb.getValue("NormalBalance"))/100.00;
				dOverdueBalance = Double.parseDouble(mb.getValue("OverdueBalance"))/100.00;
				dDullBalance = Double.parseDouble(mb.getValue("DullBalance"))/100.00;
				dBadBalance = Double.parseDouble(mb.getValue("BadBalance"))/100.00;
				dInterestBalance1 = Double.parseDouble(mb.getValue("InterestBalance1"))/100.00;
				dInterestBalance2 = Double.parseDouble(mb.getValue("InterestBalance2"))/100.00;
				mb.logger.debug("["+sTradeID+"]���׳ɹ�,���="+dBalance);
				sReturn="0000000@���="+DataConvert.toMoney(dBalance)+";����ǷϢ="+dInterestBalance1+";����ǷϢ="+dInterestBalance2;
				Sqlca.executeSQL("Update BUSINESS_CONTRACT "+
						"set Balance="+dBalance+","+
						" NormalBalance="+dNormalBalance+","+
						" OverdueBalance="+dOverdueBalance+","+
						" DullBalance="+dDullBalance+","+
						" BadBalance="+dBadBalance+","+
						" InterestBalance1="+dInterestBalance1+","+
						" InterestBalance2="+dInterestBalance2+
						" where SerialNo='"+sObjectNo+"'");
				if(dBalance == 0|| dNormalBalance ==0|| dOverdueBalance ==0||dDullBalance==0||dBadBalance==0||dInterestBalance1==0||dInterestBalance2==0){
					String sUpdateBalance = "Update BUSINESS_DUEBILL set ";
					if(dBalance == 0){
						sUpdateBalance+=" Balance=0,";
					}
					if(dNormalBalance == 0){
						sUpdateBalance+=" NormalBalance=0,";
					}
					if(dOverdueBalance == 0){
						sUpdateBalance+=" OverdueBalance=0,";
					}
					if(dDullBalance == 0){
						sUpdateBalance+=" DullBalance=0,";
					}
					if(dBadBalance == 0){
						sUpdateBalance+=" BadBalance=0,";
					}
					if(dInterestBalance1 == 0){
						sUpdateBalance+=" InterestBalance1=0,";
					}
					if(dInterestBalance2 == 0){
						sUpdateBalance+=" InterestBalance2=0,";
					}
					sUpdateBalance+=" LcStatus = LcStatus where RelativeSerialNo2='"+sObjectNo+"'";
					Sqlca.executeSQL(sUpdateBalance);
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