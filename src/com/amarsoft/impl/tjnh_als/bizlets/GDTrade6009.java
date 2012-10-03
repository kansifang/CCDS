package com.amarsoft.impl.tjnh_als.bizlets;


import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.*;


/**
 * ����ȡ��(6009)
 * @author zrli
 * @date 2010-03-25
 *
 */
public class GDTrade6009 implements GDTradeInterface {
	public String runGDTrade(SocketManager sm,String sObjectNo,String sObjectType,Transaction Sqlca,String sFilePath,String sTradeDate){
		
		if(sTradeDate.equals("")) sTradeDate = StringFunction.getToday("-");
		String sTradeID = "6009";
		String S_URL = sFilePath+"SEN_"+sTradeID+".xml";
		String R_URL = sFilePath+"RCV_"+sTradeID+".xml";
		GDMessageBuilder mb = new GDMessageBuilder(S_URL, R_URL);
		String sSql="",sReturn="",sOutMsgID="";
		String BuildAgreement="",CooperateID="",sOrgID="",Cooperator="";
		String sContractSerialNo="";
		ASResultSet rs,rs1=null;
		
		sSql="select BP.BusinessSum,BC.ProjectFlag,BC.BuildAgreement,GetMFOrgID(BP.InputOrgID) as InputOrgID,BP.ContractSerialNo " +
		" from BUSINESS_PUTOUT BP,BUSINESS_CONTRACT BC " +
		" where BP.SerialNo='"+sObjectNo+"' and BP.ContractSerialNo=BC.SerialNo";
		try{	
			rs=Sqlca.getResultSet(sSql);
			if(rs.next()){
				////////////////������//////////////////
				sOrgID = rs.getString("InputOrgID");
				sContractSerialNo = rs.getString("ContractSerialNo");
				if(sContractSerialNo == null) sContractSerialNo = "";
				BuildAgreement = rs.getString("BuildAgreement");
				if(BuildAgreement == null) BuildAgreement = "";
				CooperateID = BuildAgreement;
				////////////////ȡ��������Ϣ////////////////////////
				sSql="select CustomerID from ent_agreement where SerialNo='"+BuildAgreement+"'";
				rs1=Sqlca.getResultSet(sSql);
				if(rs1.next()){
					Cooperator=rs1.getString("CustomerID");
					if(Cooperator == null) Cooperator="";
					
				}
				rs1.close();
			//-----------------��ϱ���----------------------
			try {
				// �������ļ��ж�ȡ����,��ɱ���ͷ
				sm.write(mb.setValue("WholeLength"));
				sm.write(mb.setValue("MessageType"));
				sm.write(mb.setValue("TradeCode",sTradeID));
				sm.write(mb.setValue("TradeDate",sTradeDate));
				sm.write(mb.setValue("SysDate",sTradeDate));
				sm.write(mb.setValue("TradeTime",StringFunction.getNow()));
				sm.write(mb.setValue("OrgID","909020000"));//ȡĬ��ҵ�������
				sm.write(mb.setValue("TerminiterID"));
				sm.write(mb.setValue("UserID","908908"));//ȡĬ���Ŵ�Ա���
				sm.write(mb.setValue("TradeFlag"));
				sm.write(mb.setValue("TradeSerialNo",sObjectNo));//������ˮ��
				sm.write(mb.setValue("Flag1"));
				sm.write(mb.setValue("Flag2"));
				sm.write(mb.setValue("Flag3"));
				sm.write(mb.setValue("Flag4"));
				sm.write(mb.setValue("ConfirmUserID","908908"));
				//����Ϊ����ͷ���֣�����Ϊ�����岿��
				sm.write(mb.setValue("BPSerialNo",sObjectNo));//Э���ͬ��
				sm.write(mb.setValue("BusinessSum",rs.getString("BusinessSum")));//������ 
				sm.write(mb.setValue("IsCooperate",rs.getString("ProjectFlag")));//�Ƿ����Э��
				sm.write(mb.setValue("CooperateID",CooperateID));//����Э����
				sm.write(mb.setValue("Cooperater",Cooperator));//�����̱�� 
				sm.write(mb.setValue("OperateOrgID",sOrgID));//����֧��
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
					sOutMsgID=mb.getValue("OutMsgID");
					String sOutMsg="";
					rs1=Sqlca.getASResultSet("select MsgBdy from GD_ErrCode where CodeNo='" + sOutMsgID+ "'");
					if(rs1.next())
						sOutMsg = rs1.getString(1);
					sReturn=sOutMsgID+"@"+sOutMsg;
					rs1.close();
					mb.logger.debug("["+sTradeID+"]�������OutMsgID=" + mb.getValue("OutMsgID") + " ������Ϣ="+sOutMsg);

					//����������ش�����ϢΪ��������ȡ������ôҲ��Ϊȡ���ɹ�
					if(sOutMsgID.equals("5024")||sOutMsgID.equals("5023")){
						Sqlca.executeSQL("update  business_contract set pigeonholedate =null where serialno='"+sContractSerialNo+"' ");
						//�÷��ͱ�ʾΪ��
						Sqlca.executeSQL("update  business_putout set SendFlag ='9' where serialno='"+sObjectNo+"' ");
						sReturn="0000000@";
					}
				}else if(mb.getValue("TradeType").equals("1")){
					mb.logger.debug("["+sTradeID+"]���׳ɹ�");
					sReturn="0000000@";
					//�ɹ�����º�ͬ�鵵����
					Sqlca.executeSQL("update  business_contract set pigeonholedate =null where serialno='"+sContractSerialNo+"' ");
					//�÷��ͱ�ʾΪ��
					Sqlca.executeSQL("update  business_putout set SendFlag ='9' where serialno='"+sObjectNo+"' ");
					
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
