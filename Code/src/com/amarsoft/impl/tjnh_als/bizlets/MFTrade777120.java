package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * ����Ѻ������״̬��ѯ����777120����
 * @author xhyong 2012/07/26
 *
 */
public class MFTrade777120 implements MFTradeInterface {
	public String runMFTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "777120";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		MFMessageBuilder mb = new MFMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="";
		ASResultSet rs1=null;
		try{		
				//-----------------��ϱ���----------------------
				try {
					// �������ļ��ж�ȡ����,��ɱ���ͷ
					sm.write(mb.setValue("WholeLength"));
					sm.write(mb.setValue("MessageType"));
					sm.write(mb.setValue("TradeCode"));
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
					sm.write(mb.setValue("GuarantyID",sObjectNo));
					
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
						mb.logger.debug("["+sTradeID+"]���׳ɹ�");mb.getValue("GuarantyStatus");
						Sqlca.executeSQL("Update GUARANTY_INFO set GuarantyStatus='"+("1".equals(mb.getValue("GuarantyStatus"))?"1":"2")+"' where GuarantyID='"+sObjectNo+"'");
						
					}else
						sReturn="9999999@["+sTradeID+"]����ʧ�ܣ�����������ͨѶԭ��";
					// ������ʱҪ �ر����ӣ�������ʱ���ر�
					sm.teardownConnection();
				} catch (Exception e) {
					sReturn="9999999@["+sTradeID+"]����ʧ�ܣ�����������ͨѶԭ������ϵϵͳ����Ա��";
					e.printStackTrace();
					sm.teardownConnection();
				}
		}catch(Exception ex){
			ex.printStackTrace();
			mb.logger.error(sSql+"["+sTradeID+"]ִ�г���!");
		}
		return sReturn;
	}
}
