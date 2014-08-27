package com.lmt.baseapp.util;

import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.text.NumberFormat;

public class DataConvert
{
  public static int iChange = 1;

  public static String toString(String paramString)
  {
    if (paramString == null)
      return "";
    return paramString;
  }

  public static String toString(String paramString1, String paramString2)
  {
    if (paramString1 == null)
      return paramString2;
    return paramString1;
  }

  public static String toHTMLString(String paramString)
  {
    if ((paramString == null) || (paramString.equals("")))
      return "&nbsp;";
    return paramString;
  }

  public static String toHTMLMoney(String paramString)
  {
    if ((paramString == null) || (paramString.equals("")))
      return "&nbsp;";
    return toMoney(paramString);
  }

  public static String toString(Short paramShort)
  {
    if (paramShort == null)
      return "";
    return String.valueOf(paramShort);
  }

  public static String toString(Double paramDouble)
  {
    if (paramDouble == null)
      return "";
    return String.valueOf(paramDouble);
  }

  public static String toString(BigDecimal paramBigDecimal)
  {
    if (paramBigDecimal == null)
      return "";
    return String.valueOf(paramBigDecimal);
  }

  public static String toMoney(String paramString)
  {
    try
    {
      if ((paramString == null) || (paramString == "") || (paramString.equalsIgnoreCase("Null")))
        return "";
      return toMoney(Double.valueOf(paramString).doubleValue());
    }
    catch (Exception localException)
    {
    }
    return paramString;
  }

  public static String toMoney(Double paramDouble)
  {
    if (paramDouble == null)
      return "";
    return toMoney(paramDouble.doubleValue());
  }

  public static String toMoney(double paramDouble)
  {
    NumberFormat localNumberFormat = NumberFormat.getInstance();
    localNumberFormat.setMinimumFractionDigits(2);
    localNumberFormat.setMaximumFractionDigits(2);
    return localNumberFormat.format(paramDouble);
  }

  public static String toMoney(BigDecimal paramBigDecimal)
  {
    return toMoney(String.valueOf(paramBigDecimal));
  }

  public static String toDate_YMD(String paramString)
  {
    String str1 = paramString.substring(0, 4);
    String str2 = paramString.substring(4, 6);
    String str3 = paramString.substring(6, 8);
    String str4 = str1 + "年" + str2 + "月" + str3 + "日";
    return str4;
  }

  public static String toDate_YMD2(String paramString1, String paramString2)
  {
    String str1 = paramString1.substring(0, 4);
    String str2 = paramString2.substring(0, 4);
    String str3 = paramString1.substring(4, 6);
    String str4 = paramString2.substring(4, 6);
    String str5 = paramString1.substring(6, 8);
    String str6 = paramString2.substring(6, 8);
    String str7 = str1 + "年" + str3 + "月" + str5 + "日至" + str2 + "年" + str4 + "月" + str6 + "日";
    return str7;
  }

  public static String toDate_YM(String paramString)
  {
    String str1 = paramString.substring(0, 4);
    String str2 = paramString.substring(4, 6);
    String str3 = str1 + "年" + str2 + "月";
    return str3;
  }

  public static String toDate_Y(String paramString)
  {
    String str1 = paramString.substring(0, 4);
    String str2 = str1 + "年";
    return str2;
  }

  public static String toDate_YMD0(String paramString)
  {
    String str1 = paramString.substring(0, 4);
    String str2 = paramString.substring(4, 6);
    String str3 = paramString.substring(6, 8);
    String str4 = "-";
    String str5 = str1 + str4 + str2 + str4 + str3;
    return str5;
  }

  public static String toDate_YM2(String paramString)
  {
    String str1 = paramString.substring(0, 4);
    String str2 = paramString.substring(4, 6);
    String str3 = str1 + "年" + str2 + "月";
    return str3;
  }

  public static String toRealString_old(String paramString)
  {
    try
    {
      String str = paramString;
      if (str != null)
        str = new String(str.getBytes(), "ISO8859_1");
      return str;
    }
    catch (UnsupportedEncodingException localUnsupportedEncodingException)
    {
    }
    return paramString;
  }

  public static String toRealString(String paramString)
  {
    return toRealString(iChange, paramString);
  }

  public static String toRealString(int paramInt, String paramString)
  {
    if (paramString == null)
      return null;
    try
    {
      String str = paramString;
      if (paramInt == 1)
        return str;
      if (str != null)
      {
        if (paramInt == 0)
          str = new String(str.getBytes(), "ISO8859_1");
        if (paramInt == 2)
          str = new String(str.getBytes("ISO8859_1"), "GBK");
        if (paramInt == 3)
          str = new String(str.getBytes("GBK"), "ISO8859_1");
        if (paramInt == 5)
          str = decode(str, "GBK");
      }
      return str;
    }
    catch (UnsupportedEncodingException localUnsupportedEncodingException)
    {
      return paramString;
    }
    catch (Exception localException)
    {
    }
    return paramString;
  }

  public static String decode(String paramString1, String paramString2)
    throws Exception
  {
    if (paramString1 == null)
      return paramString1;
    StringBuffer localStringBuffer = new StringBuffer();
    for (int i = 0; i < paramString1.length(); i++)
    {
      char c = paramString1.charAt(i);
      switch (c)
      {
      case '+':
        localStringBuffer.append(' ');
        break;
      case '%':
        try
        {
          localStringBuffer.append((char)Integer.parseInt(paramString1.substring(i + 1, i + 3), 16));
        }
        catch (NumberFormatException localNumberFormatException)
        {
          throw new IllegalArgumentException();
        }
        i += 2;
        break;
      default:
        localStringBuffer.append(c);
      }
    }
    String str = localStringBuffer.toString();
    byte[] arrayOfByte = str.getBytes("8859_1");
    return new String(arrayOfByte, paramString2);
  }

  public static double toDouble(String paramString)
  {
    if ((paramString == null) || (paramString.equals("")))
      return 0.0D;
    return Double.parseDouble(paramString);
  }

  public static int toInt(String paramString)
  {
    if ((paramString == null) || (paramString.equals("")))
      return 0;
    return Integer.parseInt(paramString);
  }
  public static String complementSpace(int size) {
		String spaceString = "";
		for (int i = 0; i < size; i++) {
			spaceString = spaceString + " ";
		}
		return spaceString;
	}

	public static String complementSpace(String str, int length , String encoding) {

		int size = getBytes(str , encoding).length;
		for (int i = size; i < length; i++) {
			str = str + " ";
		}
		return str;
	}
	public static byte[] getBytes(String str , String encoding) {
		try {
			return str.getBytes(encoding);
		} catch (UnsupportedEncodingException e) {
			return str.getBytes();
		}
	}
}