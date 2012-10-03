package com.amarsoft.impl.tjnh_als.bizlets;

import java.util.List;
import java.util.ArrayList;

public class Utils {
	public Utils() {
	}

	/**
	 * 将给定的字符串按指定的分隔符拆分成数组
	 * 
	 * @param param：给定的字符串
	 * @param regex：分隔符
	 * @return List
	 */
	public static List split(String param, String regex) {
		List list = new ArrayList();
		try {
			param = param.trim();
			while (param.length() > 0) {
				if (param.indexOf(regex) != -1) {
					list.add(trim(param.substring(0, param.indexOf(regex))));
					param = param.substring(param.indexOf(regex) + 1);
					if (trim(param).equals("")) {
						list.add("");
					}
				} else {

					list.add(trim(param));
					param = "";
				}
			}
		} catch (Exception e) {
			System.out.println("解析字符串错误" + e.getMessage());
			return null;
		}
		return list;
	}

	public static String trim(String str) {
		if (str == null) {
			return "";
		}
		return str.trim();
	}

	/**
	 * 如果字符串不够长，右填充空格，对于汉字长度为1
	 * 
	 * @param str
	 * @param len
	 * @param fixChar
	 * @return
	 */
	//
	public static String getRightFixedStr(String str, int len, char fixChar) {
		int nowlen = str.length();
		if (nowlen >= len) {
			return str.substring(0, len);
		}

		String s = "";
		for (int i = len - nowlen - 1; i >= 0; i--) {
			s = s + fixChar;
		}
		// System.out.println("fixed[" + (str + s) + "]");
		return str + s;
	}
	
	/**
	 * 如果字符串不够长，右填充空格  使用byte长度
	 * 
	 * @param str
	 * @param len
	 * @param fixChar
	 * @return
	 */
	//
	public static String getRightFixedByte(String str, int len, char fixChar) {
		//int nowlen = str.length(); //中文时长度为一
		int nowlen = str.getBytes().length;
		if (nowlen >= len) {
			byte[] strOld = str.getBytes();
			byte[] strNew = new byte[len];
			for(int i = 0;i<len;i++){
				strNew[i] = strOld[i];
			}
			return new String(strNew);
		}

		String s = "";
		for (int i = len - nowlen - 1; i >= 0; i--) {
			s = s + fixChar;
		}
		// System.out.println("fixed[" + (str + s) + "]");
		return str + s;
	}

	/**
	 * 如果字符串不够长，右填充空格，适用于中文处理
	 * @param str 字符串
	 * @param strLen 原字符串长度
	 * @param len 字符串返回长度
	 * @param fixChar 填充字符
	 * @return
	 */
	public static String getRightFixedStr(String str, int strLen,int len, char fixChar) {
		int nowlen = strLen;
		if (nowlen >= len) {
			return str.substring(0, len);
		}

		String s = "";
		for (int i = len - nowlen - 1; i >= 0; i--) {
			s = s + fixChar;
		}
		// System.out.println("fixed[" + (str + s) + "]");
		return str + s;
	}

	/**
	 * 如果字符串不够长，左填充零
	 * 
	 * @param str
	 * @param len
	 * @param fixChar
	 * @return
	 */
	public static String getLeftFixedStr(String str, int len, char fixChar) {
		int nowlen = str.length();
		if (nowlen >= len) {
			return str.substring(0, len);
		}
		String s = "";
		for (int i = len - nowlen - 1; i >= 0; i--) {
			s = s + fixChar;
		}
		//如果为负数，那么零补在负号之后
		if("-".equals(str.substring(0,1))){
			return "-" + s + str.substring(1, nowlen);
		}else{
			return s + str;
		}
	}

	/**
	 * int 型转为 byte型
	 * 
	 * @param n
	 * @return
	 */
	public static byte[] int2byte(int n) {
		byte b[] = new byte[4];
		b[0] = (byte) (n >> 24);
		b[1] = (byte) (n >> 16);
		b[2] = (byte) (n >> 8);
		b[3] = (byte) n;
		return b;
	}

	/**
	 * 
	 * 对字符串进行Cylcic Redundancy Check(CRC16)校验 1 + x + x^5 + x^12 + x^16 is
	 * irreducible polynomial.
	 * 此方法返回值有问题，请使用CRC16Hex(String)方法进行CRC16的换算
	 * @author zrli
	 * @param sSource
	 * @return
	 */
	public static short CRC16(String sSource) {
		short crc = (short) 0xFFFF; // initial contents of LFSR
		char c;
		byte[] bSource = sSource.getBytes();
		for (int j = 0; j < bSource.length; j++) {
			c = (char) bSource[j];
			System.out.println("c=" + Integer.toHexString(c));
			for (int i = 0; i < 8; i++) {
				boolean c15 = ((crc >> 15 & 1) == 1);
				boolean bit = ((c >> (7 - i) & 1) == 1);
				crc <<= 1;
				if (c15 ^ bit)
					crc ^= 0x1021; // 0001 0000 0010 0001 (0, 5, 12)
			}
		}
		//System.out.println("CRC16   =   " + crc);
		//System.out.println("CRC16   =   " + Integer.toHexString(crc));
		return crc;
	}
	
	final static int[] table = { 0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301,
			0x03C0, 0x0280, 0xC241, 0xC601, 0x06C0, 0x0780, 0xC741, 0x0500,
			0xC5C1, 0xC481, 0x0440, 0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00,
			0xCFC1, 0xCE81, 0x0E40, 0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901,
			0x09C0, 0x0880, 0xC841, 0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00,
			0xDBC1, 0xDA81, 0x1A40, 0x1E00, 0xDEC1, 0xDF81, 0x1F40, 0xDD01,
			0x1DC0, 0x1C80, 0xDC41, 0x1400, 0xD4C1, 0xD581, 0x1540, 0xD701,
			0x17C0, 0x1680, 0xD641, 0xD201, 0x12C0, 0x1380, 0xD341, 0x1100,
			0xD1C1, 0xD081, 0x1040, 0xF001, 0x30C0, 0x3180, 0xF141, 0x3300,
			0xF3C1, 0xF281, 0x3240, 0x3600, 0xF6C1, 0xF781, 0x3740, 0xF501,
			0x35C0, 0x3480, 0xF441, 0x3C00, 0xFCC1, 0xFD81, 0x3D40, 0xFF01,
			0x3FC0, 0x3E80, 0xFE41, 0xFA01, 0x3AC0, 0x3B80, 0xFB41, 0x3900,
			0xF9C1, 0xF881, 0x3840, 0x2800, 0xE8C1, 0xE981, 0x2940, 0xEB01,
			0x2BC0, 0x2A80, 0xEA41, 0xEE01, 0x2EC0, 0x2F80, 0xEF41, 0x2D00,
			0xEDC1, 0xEC81, 0x2C40, 0xE401, 0x24C0, 0x2580, 0xE541, 0x2700,
			0xE7C1, 0xE681, 0x2640, 0x2200, 0xE2C1, 0xE381, 0x2340, 0xE101,
			0x21C0, 0x2080, 0xE041, 0xA001, 0x60C0, 0x6180, 0xA141, 0x6300,
			0xA3C1, 0xA281, 0x6240, 0x6600, 0xA6C1, 0xA781, 0x6740, 0xA501,
			0x65C0, 0x6480, 0xA441, 0x6C00, 0xACC1, 0xAD81, 0x6D40, 0xAF01,
			0x6FC0, 0x6E80, 0xAE41, 0xAA01, 0x6AC0, 0x6B80, 0xAB41, 0x6900,
			0xA9C1, 0xA881, 0x6840, 0x7800, 0xB8C1, 0xB981, 0x7940, 0xBB01,
			0x7BC0, 0x7A80, 0xBA41, 0xBE01, 0x7EC0, 0x7F80, 0xBF41, 0x7D00,
			0xBDC1, 0xBC81, 0x7C40, 0xB401, 0x74C0, 0x7580, 0xB541, 0x7700,
			0xB7C1, 0xB681, 0x7640, 0x7200, 0xB2C1, 0xB381, 0x7340, 0xB101,
			0x71C0, 0x7080, 0xB041, 0x5000, 0x90C1, 0x9181, 0x5140, 0x9301,
			0x53C0, 0x5280, 0x9241, 0x9601, 0x56C0, 0x5780, 0x9741, 0x5500,
			0x95C1, 0x9481, 0x5440, 0x9C01, 0x5CC0, 0x5D80, 0x9D41, 0x5F00,
			0x9FC1, 0x9E81, 0x5E40, 0x5A00, 0x9AC1, 0x9B81, 0x5B40, 0x9901,
			0x59C0, 0x5880, 0x9841, 0x8801, 0x48C0, 0x4980, 0x8941, 0x4B00,
			0x8BC1, 0x8A81, 0x4A40, 0x4E00, 0x8EC1, 0x8F81, 0x4F40, 0x8D01,
			0x4DC0, 0x4C80, 0x8C41, 0x4400, 0x84C1, 0x8581, 0x4540, 0x8701,
			0x47C0, 0x4680, 0x8641, 0x8201, 0x42C0, 0x4380, 0x8341, 0x4100,
			0x81C1, 0x8081, 0x4040, };
	/**
	 * 用table取CRC16校验码<br/>
	 * ----------------------<br/>
	 * System.out.println(CRC16Hex("0000000002"));<br/>
	 * 显示：67c0<br/>
	 * ----------------------<br/>
	 * @author zrli
	 * @param s
	 * @return
	 */
	public static String CRC16Hex(String s) {
		if (s == null)
			s = "";
		byte[] bytes = s.getBytes();
		int crc = 0x0000;
		for (byte b : bytes) {
			crc = (crc >>> 8) ^ table[(crc ^ b) & 0xff];
		}
		return Integer.toHexString(crc);
	}
	
	/**
	 *取字段A2E之后的长度
	 *@author zrli
	 * 
	 */
	public static int getA2EByteLen(char[] in) {
		int i = 0;
		int len = in.length;
		int byteLen = 0;
		int iadd = 0;
		boolean bHaveChn = false;
		
		char ch;
		for (i = 0; i < in.length; i++) {
			ch = in[i];
			if (GBK4EBC.is_GBK(ch)) {
				if(!bHaveChn) iadd += 2;
				iadd += 1;
				bHaveChn = true;
			}else{
				bHaveChn = false;
			}
		}
		return len + iadd;
	}
	/**
	 *取字段A2E之后加的中文头尾长度
	 *@author zrli
	 * 
	 */
	public static int getA2EBlankLen(char[] in) {
		int i = 0;
		int len = in.length;
		int byteLen = 0;
		int iadd = 0;
		boolean bHaveChn = false;
		
		char ch;
		for (i = 0; i < in.length; i++) {
			ch = in[i];
			if (GBK4EBC.is_GBK(ch)) {
				if(!bHaveChn) iadd += 2;
				bHaveChn = true;
			}else{
				bHaveChn = false;
			}
		}
		return iadd;
	}
	/**
	 *取字段A2E之后加的中文头尾长度
	 *@author zrli
	 * 
	 */
	public static char[] getA2EChar(char[] in,int iLen) {
		int i = 0,t = 0; 
		int len = in.length;
		int byteLen = 0;
		int iadd = 0;
		boolean bHaveChn = false;
		
		char ch;
		for (i = 0; i < in.length; i++) {
			ch = in[i];
			if (GBK4EBC.is_GBK(ch)) {
				if(!bHaveChn) iadd += 2;
				iadd += 2;
				bHaveChn = true;
			}else{
				iadd += 1;
				bHaveChn = false;
			}
			if(iadd >= iLen){
				//如果是最后是中文就少取一个字，如果最后不是中文就全取
				if(bHaveChn) t=i;
				else t=i+1;
				char[] out =new char[t];
				for(int j=0;j<t;j++)
					out[j]=in[j];
				return out;
			}
		}
		return in;
	}
	public static void main(String[] args) {
		String line = "aaaa|bbbb|cccc|";
		System.out.println(split(line, "|"));
		System.out.println(getLeftFixedStr("-100.0",10,'0'));
	}
}
