/**
 * 
 * �����ϵͳʵʱ���ݽӿڣ�����AS400ת�벿��
 * @author zrli
 */
package com.amarsoft.impl.tjnh_als.bizlets;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.text.DecimalFormat;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

/**
 * �����������,ע�����sFilePath�����ļ����λ��
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MFMessageBuilder {

	public final char fixCharRight = ' ';

	public final char fixCharLeft = '0';
	
	public String sFilePath=Thread.currentThread().getContextClassLoader().getResource("").getPath();
	
	public String sCurSlash = System.getProperty("file.separator");
	
	public String SENXML_URL = "";

	public String RCVXML_URL = "";

	public String LOG4J_URL = "";

	public final boolean bCovFlag = true;

	public final String CONV_CODESET = "CP037";// CP037;CP1047

	public Element sen_root;

	public Element rcv_root;

	public String sOldTemp = "";

	public String sNewTemp = "";

	public int iLeng = 0;

	public Logger logger = Logger.getLogger(MFMessageBuilder.class.getName());

	/**
	 * ����MessageBuilder
	 */
	public MFMessageBuilder() {
		InitMessageBuilder();
	}

	/**
	 * ����MessageBuilder
	 */
	public MFMessageBuilder(String SENXML_URL, String RCVXML_URL) {
		this.SENXML_URL = SENXML_URL;
		this.RCVXML_URL = RCVXML_URL;
		InitMessageBuilder();
	}

	/**
	 * ��ʼ������
	 */
	public void InitMessageBuilder() {
		sFilePath=sFilePath.substring(0,sFilePath.length()-8)+"pro"+sCurSlash;
		LOG4J_URL = sFilePath+"log4jlog.properties";
		SAXBuilder sen_sb = new SAXBuilder();
		SAXBuilder rcv_sb = new SAXBuilder();
		Document sen_doc = null;
		Document rcv_doc = null;
		try {
			sen_doc = sen_sb.build(this.SENXML_URL);
			rcv_doc = rcv_sb.build(this.RCVXML_URL);
		} catch (JDOMException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		this.sen_root = sen_doc.getRootElement();
		this.rcv_root = rcv_doc.getRootElement();
		PropertyConfigurator.configure(LOG4J_URL);
		logger.debug("��־��ʼ���ɹ���");
	}

	/**
	 * Ϊָ��������ֵ,String�͡�
	 */
	public byte[] setValue(String sElement) throws UnsupportedEncodingException {
		return setValue(sElement, "");
	}

	/**
	 * Ϊָ��������ֵ,String�͡� sType: R,�Ҳ��գ�L��
	 */
	public byte[] setValue(String sElement, String str2)
			throws UnsupportedEncodingException {
		int iLen = Integer.parseInt(sen_root.getChild(sElement).getChildText(
				"length"));
		byte[] bValue = new byte[iLen];
		
		// ȡ���־
		String sFixed = sen_root.getChild(sElement).getChildText("fixed")
				.toString();
		// ȡ���ı�־
		String sChn = sen_root.getChild(sElement).getChildText("chn")
				.toString();
		if (str2 == null || str2.equals(""))
			str2 = sen_root.getChild(sElement).getChildText("defalutvalue");
		//�ַ����Ҳ��ո�
		if (sFixed.equals("R")){
			if(sChn.equals("Y") && Utils.getA2EByteLen(str2.toCharArray())>=iLen){
				str2 = Utils.getRightFixedStr(new String(Utils.getA2EChar(str2.toCharArray(),iLen)),iLen, fixCharRight);
			}else{
				str2 = Utils.getRightFixedStr(str2, iLen, fixCharRight);
			}
		}
		//����������
		else{
			int iDecimal=0;
			try{
				iDecimal=Integer.parseInt(sen_root.getChild(sElement).getChildText("decimal"));
			}catch(Exception ex){
				logger.error("Ԫ��["+sElement+"]Ϊ�����ͣ���ȱ��decimal���ã�ȡĬ��С����Ϊ0");
			}
			if(str2.equals("")) str2="0";//���Ϊ�ַ�����ô��ֵʱĬ��Ϊ0
			DecimalFormat   df2   =   new   DecimalFormat("###");
			// ͨ��iDecimal����������С�����λ
			str2 = Utils.getLeftFixedStr(df2.format(Double.parseDouble(str2)*Math.pow(10, iDecimal)), iLen, fixCharLeft);
		}
		//��������ľ���Conversion.toEBCDIC()����ת��EBCDIC2GBKConvertor.GBK2EBCDIC()
		//���ʹ��GBK4EBC.A2E()����ת�룬��ת������Ĵ���û������
		if(sChn.equals("Y")){
			System.arraycopy(GBK4EBC.A2E(str2.getBytes("GBK")), 0, bValue, 0, iLen);
			sOldTemp += new String(str2.getBytes("GBK"));
			sNewTemp += new String(GBK4EBC.A2E(str2.getBytes("GBK")));
		//����Ƿ����ľ���str2.getBytes(CONV_CODESET)����ת��,�������ݵ�ת��ֱ��ʹ��GBK4EBC.A2E()Ҳû������
		//�˷�ʽֻ�����һ���ת��Ч��
		}else{
			System.arraycopy(str2.getBytes(CONV_CODESET), 0, bValue, 0, iLen);
			sOldTemp += new String(str2.getBytes());
			sNewTemp += new String(str2.getBytes(CONV_CODESET));
		}
		iLeng += iLen;
		logger.debug(sElement + "=" + str2 + "|length=" + iLen);
		return bValue;
	}

	/**
	 * ȡ�ò���
	 */
	public String getValue(String sElement) throws UnsupportedEncodingException {
		try{
			return rcv_root.getChild(sElement).getAttributeValue("value").trim();
		}catch(Exception ex){
			logger.error("û��["+sElement+"]���Ԫ�أ���˶���������ļ���");
			return "";
		}
	}

	/**
	 * �������÷������ݽ��г�ʼ��xml
	 * 
	 * @param bRevBuf
	 * @param iWholeLen
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public boolean initRcv(byte[] bRevBuf, int iWholeLen)
			throws UnsupportedEncodingException {
		int iBegin = 0;
		boolean bIsSucess = false;
		String sTr = "";
		try {
			for (int i = 0; i < rcv_root.getChildren().size(); i++) {
				Element e = (Element) rcv_root.getChildren().get(i);
				int iLen = Integer.parseInt(e.getChildText("length"));
				String sChn = e.getChildText("chn");
				// ����Ǵ�����Ϣ�����һ���ֶγ���Ҫ�������ȡ��
				if (iLen == -1) {
					iLen = iWholeLen - iBegin;
				}
				// ������׳ɹ���ȡ���ֶ�ֵ
				if ((e.getName().equals("OutMsgID") || e.getName().equals("OutMsg") )&& bIsSucess) {
					continue;
				}
				byte[] bValue = new byte[iLen];
				//���iBegin�Ѿ������������Ⱦ�ֱ���˳�,��Ϊ���������п��ܻ���ڳ���С���趨��ͷ�����
				if(iBegin>iWholeLen-1) break;
				System.arraycopy(bRevBuf, iBegin, bValue, 0, iLen);
				iBegin += iLen;

				//�����������������Msg�Σ�����Ҫ��������ת��Conversion.toASCII_bitmap(iTemp,iLen),�˴�����-12�����ĺ���Ķ����ַ���ֻ֧��GBK2�ַ�
				//���ʹ��GBK4EBC.E2A(Byte[] bTemp)����ת�룬֧��ȫGBK�ַ�
				if (sChn.equals("Y")) {
					/*
					int iTemp[] = new int[iLen];
					for (int j = 0; j < iLen; j++) {
						iTemp[j] = bValue[j];
						iTemp[j] = iTemp[j] > 0 ? iTemp[j] : (iTemp[j] + 256);//���зǸ�ת��
					}
					
					rcv_root.getChild(e.getName()).setAttribute(
							"value",
							Conversion.toASCII_bitmap(iTemp, bIsSucess ? iLen
									: (iLen - 12) > 0 ? (iLen - 12) : iLen));
					*/
					rcv_root.getChild(e.getName()).setAttribute(
							"value",new String (GBK4EBC.E2A(bValue),"GBK"));
					
					logger.debug("iLen=" + iLen);
					// ��Msg��,������ת�������ͨת��
				} else {
					sTr = "";
					sTr = new String(bValue, CONV_CODESET);
					rcv_root.getChild(e.getName()).setAttribute("value", sTr);
					// ������׳ɹ�������isSucessΪture
					if (e.getName().equals("TradeType") && sTr.equals("1")) {
						bIsSucess = true;
					}

				}
				// ������ײ��ɹ�����ô��ȡ��OutMsgID�Ϳ����˳��ˣ�����OutMsg
				// ��Ϊ������ײ��ɹ�����ô��ҪȡOutMsg
				if (e.getName().equals("OutMsg") && !bIsSucess) {
					break;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}

	/**
	 * ���԰���
	 * 
	 * @param args
	 * @throws Exception
	 */
	public static void main(String[] args) throws Exception {
		// ��ʼ��MessageBuilder
		String S_URL = "E:\\workspace\\MFRTI\\pro\\SEN_420191.xml";
		String R_URL = "E:\\workspace\\MFRTI\\pro\\RCV_420191.xml";

		MFMessageBuilder mb = new MFMessageBuilder(S_URL, R_URL);
		mb.logger.info("MessageBuilder��ʼ���ɹ�");
		// 172.16.1.19:30004
		// 100.100.100.11:20004
		SocketManager sm = new SocketManager("100.100.100.11", "20004");
		// ��������
		sm.setupConnection();
		mb.logger.info("Socket��ʼ���ɹ�");
		try {
			// �������ļ��ж�ȡ����,��ɱ���ͷ
			sm.write(mb.setValue("WholeLength"));
			sm.write(mb.setValue("MessageType"));
			sm.write(mb.setValue("TradeCode"));
			sm.write(mb.setValue("TradeDate"));
			sm.write(mb.setValue("SysDate"));
			sm.write(mb.setValue("TradeTime"));
			sm.write(mb.setValue("OrgID"));
			sm.write(mb.setValue("TerminiterID"));
			sm.write(mb.setValue("UserID"));
			sm.write(mb.setValue("TradeFlag"));
			sm.write(mb.setValue("TradeSerialNo"));
			sm.write(mb.setValue("Flag1"));
			sm.write(mb.setValue("Flag2"));
			sm.write(mb.setValue("Flag3"));
			sm.write(mb.setValue("Flag4"));
			sm.write(mb.setValue("ConfirmUserID"));
			/*
			 * //�����ý��� sm.write(mb.setValue("DuebillNo", "925011010000000222"));
			 * sm.write(mb.setValue("SysID"));
			 * sm.write(mb.setValue("CustomerID", "2"));
			 * sm.write(mb.setValue("Currency"));
			 */
			// ������ѯ 420191
			sm.write(mb.setValue("AccountNo", "925011010000000467"));
			sm.flush();
			mb.logger.debug("sOldTemp=" + mb.sOldTemp);
			mb.logger.debug("sNewTemp=" + mb.sNewTemp);
			mb.logger.debug("iLeng=" + mb.iLeng);
			mb.logger.info("���ͳɹ���");
			// ��ȡ���ذ���
			byte[] pckbuf = new byte[4];
			sm.read(pckbuf);
			String s = new String(pckbuf, mb.CONV_CODESET);
			mb.logger.debug("Rcv_Head=" + s);
			int pcklen = Integer.parseInt(s);
			// ��ȡ���ذ�
			byte[] revbuf = new byte[pcklen];
			sm.readFully(revbuf);
			mb.logger.info("��������=" + new String(revbuf, mb.CONV_CODESET));
			// ��ʼ��xml����
			mb.initRcv(revbuf, pcklen);
			mb.logger.debug("TradeCode=" + mb.getValue("TradeCode"));
			mb.logger.debug("TradeType=" + mb.getValue("TradeType"));
			mb.logger.debug("OutMsgID=" + mb.getValue("OutMsgID"));
			mb.logger.debug("AccountName=" + mb.getValue("AccountName"));

			// �ر�����
			sm.teardownConnection();
		} catch (Exception e) {
			e.printStackTrace();
			sm.teardownConnection();
		}
	}
}