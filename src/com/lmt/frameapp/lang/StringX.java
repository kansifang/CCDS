/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.lang;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

// Referenced classes of package com.amarsoft.are.lang:
//            DataElement

public class StringX
{

    public StringX()
    {
    }

    public static Date parseDate(String str)
    {
        if(str == null)
            return null;
        Date d = null;
        String format = null;
        char split[] = {
            '/', '-', '.'
        };
        if(str.length() < 8)
            return d;
        if(str.length() > 10)
            str = str.substring(0, 10);
        int i = 0;
        do
        {
            if(i >= split.length)
                break;
            int k = str.indexOf(split[i]);
            if(k >= 0)
            {
                if(k == 4)
                    format = "yyyy" + split[i] + 'M' + split[i] + 'd';
                else
                if(k < 4)
                    format = (77 + split[i] + 100 + split[i]) + "yyyy";
                else
                    return null;
                break;
            }
            i++;
        } while(true);
        if(format == null)
            if(str.substring(0, 2).compareTo("12") > 0)
                format = "yyyyMMdd";
            else
                format = "MMddyyyy";
        SimpleDateFormat df = new SimpleDateFormat(format);
        try
        {
            d = df.parse(str);
        }
        catch(ParseException e)
        {
            d = null;
        }
        return d;
    }

    public static boolean parseBoolean(String str)
    {
        return str != null ? str.equalsIgnoreCase("true") || str.equalsIgnoreCase("t") || str.equalsIgnoreCase("yes") || str.equalsIgnoreCase("y") || str.matches(".*[1-9]+.*") : false;
    }

    public static String[] parseArray(String str)
    {
        if(str == null)
            return null;
        ArrayList l = new ArrayList();
        int sc = 0;
        int ec = 0;
        int p = 0;
        int sp = -1;
        for(; p < str.length(); p++)
        {
            if(str.charAt(p) == '{')
            {
                if(++sc == 1)
                    sp = p + 1;
                continue;
            }
            if(str.charAt(p) == '}' && ++ec == sc)
            {
                l.add(str.substring(sp, p));
                sp = -1;
                sc = 0;
                ec = 0;
            }
        }

        return (String[])l.toArray(new String[0]);
    }

    public static Properties parseProperties(String str)
    {
        Properties p = new Properties();
        String s[] = parseArray(str);
        if(s != null && s.length > 0)
        {
            for(int i = 0; i < s.length; i++)
            {
                int p0 = s[i].indexOf('=');
                if(p0 < 1 || p0 == s[i].length())
                    continue;
                String n = trimAll(s[i].substring(0, p0));
                if(n != "")
                {
                    String v = s[i].substring(p0 + 1);
                    p.setProperty(n, v);
                }
            }

        }
        return p;
    }

    public static String bytesToHexString(byte bytes[], boolean toUpperCase)
    {
        if(bytes == null)
            return null;
        StringBuffer sb = new StringBuffer();
        for(int i = 0; i < bytes.length; i++)
        {
            int t = bytes[i];
            sb.append(Integer.toString(t >> 4 & 15, 16)).append(Integer.toString(t & 15, 16));
        }

        String ret = sb.toString();
        return toUpperCase ? ret.toUpperCase() : ret.toLowerCase();
    }

    public static String trimStart(String str)
    {
        String s = null;
        int p = 0;
        if(str != null)
        {
            for(p = 0; p < str.length() && Character.isSpaceChar(str.charAt(p)); p++);
            s = p >= str.length() ? "" : str.substring(p);
        }
        return s;
    }

    public static String trimEnd(String str)
    {
        String s = null;
        int p = 0;
        if(str != null)
        {
            for(p = str.length() - 1; p >= 0 && Character.isSpaceChar(str.charAt(p)); p--);
            s = p < 0 ? "" : str.substring(0, p + 1);
        }
        return s;
    }

    public static String trimAll(String str)
    {
        String s = null;
        if(str != null)
            s = trimEnd(trimStart(str));
        return s;
    }

    public static boolean isEmpty(String str)
    {
        return str == null || str.equals("");
    }

    public static boolean isSpace(String str)
    {
        if(str == null)
            return true;
        boolean r = true;
        int i = 0;
        do
        {
            if(i >= str.length())
                break;
            if(!Character.isSpaceChar(str.charAt(i)))
            {
                r = false;
                break;
            }
            i++;
        } while(true);
        return r;
    }

    public static boolean isEmpty(DataElement de)
    {
        return de == null || de.isNull() || isEmpty(de.getString());
    }

    public static boolean isSpace(DataElement de)
    {
        return isEmpty(de) || isSpace(de.getString());
    }
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\ALS7\WebRoot\WEB-INF\lib\are-1.0b88-m1_g.jar
	Total time: 152 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/