/**
 * 
 * 与核心系统实时数据接口，包括AS400转码部分
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
 * 数据组包程序,注意更新sFilePath配置文件存放位置
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
	 * 构造MessageBuilder
	 */
	public MFMessageBuilder() {
		InitMessageBuilder();
	}

	/**
	 * 构造MessageBuilder
	 */
	public MFMessageBuilder(String SENXML_URL, String RCVXML_URL) {
		this.SENXML_URL = SENXML_URL;
		this.RCVXML_URL = RCVXML_URL;
		InitMessageBuilder();
	}

	/**
	 * 初始化数据
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
		logger.debug("日志初始化成功！");
	}

	/**
	 * 为指定参数附值,String型。
	 */
	public byte[] setValue(String sElement) throws UnsupportedEncodingException {
		return setValue(sElement, "");
	}

	/**
	 * 为指定参数附值,String型。 sType: R,右补空；L，
	 */
	public byte[] setValue(String sElement, String str2)
			throws UnsupportedEncodingException {
		int iLen = Integer.parseInt(sen_root.getChild(sElement).getChildText(
				"length"));
		byte[] bValue = new byte[iLen];
		
		// 取填补标志
		String sFixed = sen_root.getChild(sElement).getChildText("fixed")
				.toString();
		// 取中文标志
		String sChn = sen_root.getChild(sElement).getChildText("chn")
				.toString();
		if (str2 == null || str2.equals(""))
			str2 = sen_root.getChild(sElement).getChildText("defalutvalue");
		//字符型右补空格
		if (sFixed.equals("R")){
			if(sChn.equals("Y") && Utils.getA2EByteLen(str2.toCharArray())>=iLen){
				str2 = Utils.getRightFixedStr(new String(Utils.getA2EChar(str2.toCharArray(),iLen)),iLen, fixCharRight);
			}else{
				str2 = Utils.getRightFixedStr(str2, iLen, fixCharRight);
			}
		}
		//数字型左补零
		else{
			int iDecimal=0;
			try{
				iDecimal=Integer.parseInt(sen_root.getChild(sElement).getChildText("decimal"));
			}catch(Exception ex){
				logger.error("元素["+sElement+"]为数字型，但缺少decimal设置，取默认小数点为0");
			}
			if(str2.equals("")) str2="0";//如果为字符型那么无值时默认为0
			DecimalFormat   df2   =   new   DecimalFormat("###");
			// 通过iDecimal来决定保留小数点后几位
			str2 = Utils.getLeftFixedStr(df2.format(Double.parseDouble(str2)*Math.pow(10, iDecimal)), iLen, fixCharLeft);
		}
		//如果是中文就用Conversion.toEBCDIC()进行转码EBCDIC2GBKConvertor.GBK2EBCDIC()
		//最后使用GBK4EBC.A2E()进行转码，此转码对中文处理没有问题
		if(sChn.equals("Y")){
			System.arraycopy(GBK4EBC.A2E(str2.getBytes("GBK")), 0, bValue, 0, iLen);
			sOldTemp += new String(str2.getBytes("GBK"));
			sNewTemp += new String(GBK4EBC.A2E(str2.getBytes("GBK")));
		//如果是非中文就用str2.getBytes(CONV_CODESET)进行转码,所有数据的转码直接使用GBK4EBC.A2E()也没有问题
		//此方式只会提高一点点转换效率
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
	 * 取得参数
	 */
	public String getValue(String sElement) throws UnsupportedEncodingException {
		try{
			return rcv_root.getChild(sElement).getAttributeValue("value").trim();
		}catch(Exception ex){
			logger.error("没有["+sElement+"]这个元素！请核对相关配置文件！");
			return "";
		}
	}

	/**
	 * 根据所得返回数据进行初始化xml
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
				// 如果是错误信息则最后一个字段长度要相减计算取得
				if (iLen == -1) {
					iLen = iWholeLen - iBegin;
				}
				// 如果交易成功不取此字段值
				if ((e.getName().equals("OutMsgID") || e.getName().equals("OutMsg") )&& bIsSucess) {
					continue;
				}
				byte[] bValue = new byte[iLen];
				//如果iBegin已经大于整包长度就直接退出,因为正常报文中可能会存在长度小于设定包头的情况
				if(iBegin>iWholeLen-1) break;
				System.arraycopy(bRevBuf, iBegin, bValue, 0, iLen);
				iBegin += iLen;

				//如果是有中文字样的Msg段，就需要进行中文转码Conversion.toASCII_bitmap(iTemp,iLen),此处长度-12是中文后面的多余字符，只支持GBK2字符
				//最后使用GBK4EBC.E2A(Byte[] bTemp)进行转码，支持全GBK字符
				if (sChn.equals("Y")) {
					/*
					int iTemp[] = new int[iLen];
					for (int j = 0; j < iLen; j++) {
						iTemp[j] = bValue[j];
						iTemp[j] = iTemp[j] > 0 ? iTemp[j] : (iTemp[j] + 256);//进行非负转换
					}
					
					rcv_root.getChild(e.getName()).setAttribute(
							"value",
							Conversion.toASCII_bitmap(iTemp, bIsSucess ? iLen
									: (iLen - 12) > 0 ? (iLen - 12) : iLen));
					*/
					rcv_root.getChild(e.getName()).setAttribute(
							"value",new String (GBK4EBC.E2A(bValue),"GBK"));
					
					logger.debug("iLen=" + iLen);
					// 非Msg段,无中文转码就用普通转码
				} else {
					sTr = "";
					sTr = new String(bValue, CONV_CODESET);
					rcv_root.getChild(e.getName()).setAttribute("value", sTr);
					// 如果交易成功，就置isSucess为ture
					if (e.getName().equals("TradeType") && sTr.equals("1")) {
						bIsSucess = true;
					}

				}
				// 如果交易不成功，那么读取完OutMsgID就可以退出了，不读OutMsg
				// 改为如果交易不成功，那么还要取OutMsg
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
	 * 测试案例
	 * 
	 * @param args
	 * @throws Exception
	 */
	public static void main(String[] args) throws Exception {
		// 初始化MessageBuilder
		String S_URL = "E:\\workspace\\MFRTI\\pro\\SEN_420191.xml";
		String R_URL = "E:\\workspace\\MFRTI\\pro\\RCV_420191.xml";

		MFMessageBuilder mb = new MFMessageBuilder(S_URL, R_URL);
		mb.logger.info("MessageBuilder初始化成功");
		// 172.16.1.19:30004
		// 100.100.100.11:20004
		SocketManager sm = new SocketManager("100.100.100.11", "20004");
		// 建立连接
		sm.setupConnection();
		mb.logger.info("Socket初始化成功");
		try {
			// 从配置文件中读取数据,组成报文头
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
			 * //测试用交易 sm.write(mb.setValue("DuebillNo", "925011010000000222"));
			 * sm.write(mb.setValue("SysID"));
			 * sm.write(mb.setValue("CustomerID", "2"));
			 * sm.write(mb.setValue("Currency"));
			 */
			// 户名查询 420191
			sm.write(mb.setValue("AccountNo", "925011010000000467"));
			sm.flush();
			mb.logger.debug("sOldTemp=" + mb.sOldTemp);
			mb.logger.debug("sNewTemp=" + mb.sNewTemp);
			mb.logger.debug("iLeng=" + mb.iLeng);
			mb.logger.info("发送成功！");
			// 读取返回包长
			byte[] pckbuf = new byte[4];
			sm.read(pckbuf);
			String s = new String(pckbuf, mb.CONV_CODESET);
			mb.logger.debug("Rcv_Head=" + s);
			int pcklen = Integer.parseInt(s);
			// 读取返回包
			byte[] revbuf = new byte[pcklen];
			sm.readFully(revbuf);
			mb.logger.info("返回数据=" + new String(revbuf, mb.CONV_CODESET));
			// 初始化xml对象
			mb.initRcv(revbuf, pcklen);
			mb.logger.debug("TradeCode=" + mb.getValue("TradeCode"));
			mb.logger.debug("TradeType=" + mb.getValue("TradeType"));
			mb.logger.debug("OutMsgID=" + mb.getValue("OutMsgID"));
			mb.logger.debug("AccountName=" + mb.getValue("AccountName"));

			// 关闭连接
			sm.teardownConnection();
		} catch (Exception e) {
			e.printStackTrace();
			sm.teardownConnection();
		}
	}
}