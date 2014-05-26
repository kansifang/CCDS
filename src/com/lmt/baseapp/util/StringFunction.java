package com.lmt.baseapp.util;

import java.sql.Time;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import com.lmt.frameapp.ARE;
public class StringFunction
{

    public StringFunction()
    {
    }

    public static String removeSpaces(String s)
    {
        StringTokenizer stringtokenizer = new StringTokenizer(s, " ", false);
        String s1;
        for(s1 = ""; stringtokenizer.hasMoreElements(); s1 = s1 + stringtokenizer.nextElement());
        return s1;
    }

    public static String ltrim(String s)
    {
        if(s == null)
            return s;
        else
            return s.replaceAll("^\\s+", "");
    }

    public static String rtrim(String s)
    {
        if(s == null)
            return s;
        else
            return s.replaceAll("\\s+$", "");
    }

    public static String itrim(String s)
    {
        return s.replaceAll("\\b\\s{2,}\\b", " ");
    }

    public static String trim(String s)
    {
        return itrim(ltrim(rtrim(s)));
    }

    public static String lrtrim(String s)
    {
        return ltrim(rtrim(s));
    }

    public static String getFileName(String s)
    {
        s = DataConvert.toString(s);
        int i = 0;
        i = s.lastIndexOf('/');
        if(i != -1)
            return s.substring(i + 1, s.length());
        i = s.lastIndexOf('\\');
        if(i != -1)
            return s.substring(i + 1, s.length());
        else
            return s;
    }

    public static String replace(String s, String s1, String s2)
    {
        if(s != null && s.length() < 256)
        {
            for(int i = s.indexOf(s1, 0); i != -1; i = s.indexOf(s1, i + s2.length()))
                s = s.substring(0, i) + s2 + s.substring(i + s1.length());
            return s;
        }
        if(s == null)
        {
            return null;
        } else
        {
            Pattern pattern = null;
            Matcher matcher = null;
            pattern = Pattern.compile(convert2Reg(s1));
            matcher = pattern.matcher(s);
            return matcher.replaceAll(s2);
        }
    }

    public static String convert2Reg(String s)
    {
        Hashtable hashtable = new Hashtable();
        hashtable.put(new Character('\n'), new Character('n'));
        hashtable.put(new Character('\r'), new Character('r'));
        hashtable.put(new Character('\\'), new Character('\\'));
        hashtable.put(new Character('{'), new Character('{'));
        hashtable.put(new Character('['), new Character('['));
        hashtable.put(new Character('$'), new Character('$'));
        hashtable.put(new Character('^'), new Character('^'));
        hashtable.put(new Character('|'), new Character('|'));
        hashtable.put(new Character('('), new Character('('));
        hashtable.put(new Character(')'), new Character(')'));
        hashtable.put(new Character('*'), new Character('*'));
        hashtable.put(new Character('+'), new Character('+'));
        StringBuffer stringbuffer = new StringBuffer();
        char ac[] = s.toCharArray();
        for(int i = 0; i < ac.length; i++)
        {
            Character character = new Character(ac[i]);
            if(hashtable.containsKey(character))
            {
                stringbuffer.append('\\');
                stringbuffer.append(((Character)hashtable.get(character)).charValue());
            } else
            {
                stringbuffer.append(ac[i]);
            }
        }

        return stringbuffer.toString();
    }
/**
 * 
 * @param s XXX#ABBB#B
 * @param s1 形如 String A,String,B.....
 * @param s2 valuea,valueb
 * @return
 */
    public static String applyArgs(String s, String s1, String s2)
    {
        StringTokenizer stringtokenizer = new StringTokenizer(s1.trim(), ", ");//注意分隔符", "表示碰到任意一个都可以视为分隔符
        String s3;
        String s4;
        for(StringTokenizer stringtokenizer1 = new StringTokenizer(s2.trim(), ","); stringtokenizer.hasMoreTokens() && stringtokenizer1.hasMoreTokens(); s = replace(s, "#" + s4, s3))
        {
            String s5 = stringtokenizer.nextToken().trim();
            s4 = stringtokenizer.nextToken().trim();
            s3 = stringtokenizer1.nextToken().trim();
            if(s5.equals("String"))
                continue;
            if(s5.equals("Number"))
            {
                if(s3.substring(0, 1).equals("'") || s3.substring(0, 1).equals(String.valueOf('"')))
                    s3 = s3.substring(1, s3.length() - 1);
            } else
            if(!s5.equals("Date"));
        }

        return s;
    }

    public static String getNow()
    {
        Calendar calendar = Calendar.getInstance();
        return String.valueOf(Time.valueOf(String.valueOf(calendar.get(11)) + ":" + String.valueOf(calendar.get(12)) + ":" + String.valueOf(calendar.get(13))));
    }
    //获取不在s2和s3之间的s1在s中的位置
    public static int indexOf(String s, String s1, String s2, String s3, int i)
    {
        int j;
        for(j = s.indexOf(s1, i); j >= 0 && getOccurTimes(s, s2, s3, i, j) != 0; j = s.indexOf(s1, j + s1.length()));
        return j;
    }
    public static int lastIndexOf(String s, String s1, String s2, String s3, int i)
    {
        int j;
        for(j = s.indexOf(s1, i); j >= 0 && getOccurTimes(s, s2, s3, i, j) != 0; j = s.indexOf(s1, j + s1.length()));
        return j;
    }
    public static int indexOf(String s, String s1, int i, int j)
    {
        return s.substring(i, j).indexOf(s1);
    }
    //获取s中s1和s2成对字符串有几个
    public static int getOccurTimes(String s, String s1, String s2, int i, int j)
    {
        s = s.substring(i, j);
        if(s1.equals(s2))
            return getOccurTimes(s, s1) % 2;
        else
            return getOccurTimes(s, s1) - getOccurTimes(s, s2);
    }
    //获取s中si有几个
    public static int getOccurTimes(String s, String s1)
    {
        int i = 0;
        int j = 0;
        for(int k = s1.length(); (i = s.indexOf(s1, i) + k) > k - 1;)
            j++;

        return j;
    }

    public static int getOccurTimesIgnoreCase(String s, String s1)
    {
        int i = 0;
        int j = 0;
        for(int k = s1.length(); (i = s.toLowerCase().indexOf(s1.toLowerCase(), i) + k) > k - 1;)
            j++;

        return j;
    }

    public static String getSeparate(String s, String s1, int i)
    {
        int k = 0;
        int l = 0;
        int i1 = s1.length();
        s = s + s1;
        int j;
        while((j = s.indexOf(s1, k)) >= 0) 
        {
            if(++l == i)
                return s.substring(k, j);
            k = j + i1;
        }
        return "";
    }

    public static int getSeparateSum(String s, String s1)
    {
        if(s == null)
            return 0;
        int i = 0;
        int j = 0;
        for(int k = s1.length(); (i = s.indexOf(s1, i) + k) > k - 1;)
            j++;

        return j + 1;
    }

    public static String[] toStringArray(String s, String s1)
    {
        String as[] = null;
        int i = getSeparateSum(s, s1);
        if(i > 0)
        {
            as = new String[i];
            for(int j = 1; j <= i; j++)
                as[j - 1] = getSeparate(s, s1, j);

        }
        return as;
    }

    public static String toArrayString(String as[], String s)
    {
        String s1 = "";
        int i = as.length;
        for(int j = 1; j <= i; j++)
            s1 = s1 + s + as[j - 1];

        if(s1.length() > 0)
            s1 = s1.substring(s.length());
        return s1;
    }

    public static String[] doubleArray(String as[])
    {
        String as1[] = null;
        int i = as.length;
        as1 = new String[2 * i];
        if(i > 0)
        {
            for(int j = 0; j < i; j++)
            {
                as1[2 * j] = as[j];
                as1[2 * j + 1] = as[j];
            }

        }
        return as1;
    }

    public static String getToday()
    {
        return getToday("/");
    }

    public static String getToday(String s)
    {
        Date date = new Date();
        String s1 = (new java.sql.Date(date.getTime())).toString();
        s1 = replace(s1, "-", s);
        return s1;
    }

    public static String date2String(java.sql.Date date, String s)
    {
        String s1 = date.toString();
        s1 = replace(s1, "-", s);
        return s1;
    }

    public static String date2String(Date date, String s)
    {
        String s1 = (new java.sql.Date(date.getTime())).toString();
        s1 = replace(s1, "-", s);
        return s1;
    }

    public static String[] encodingStrings(String as[], String s)
    {
        int i = as.length;
        String as1[] = new String[i];
        try
        {
            for(int j = 0; j < i; j++)
                as1[j] = new String(as[j].getBytes(s));

        }
        catch(Exception exception)
        {
            ARE.getLog().error("encodingStrings error!", exception);
        }
        return as1;
    }

    public static String getProfileString(String s, String s1, String s2)
    {
        if(s == null)
            return "";
        int k = s.indexOf(s1 + "=");
        if(k < 0)
            return "";
        int j = (s + s2).indexOf(s2, k);
        if(j < 0)
            return "";
        int i = s.indexOf("=", k);
        if(i < 0)
            return "";
        else
            return s.substring(i + 1, j);
    }

    public static String getProfileString(String s, String s1)
    {
        return getProfileString(s, s1, ";");
    }

    public static String[] toStringArray(String s, String s1, String s2, int i)
    {
        if(s1 == null || s1.equals(""))
            s1 = " ";
        if(s2 == null || s2.equals(""))
            s2 = " ";
        int k = getSeparateSum(s, s1);
        String as[] = new String[k];
        for(int j = 1; j <= k; j++)
        {
            String s3 = getSeparate(s, s1, j);
            as[j - 1] = getSeparate(s3, s2, i);
        }

        return as;
    }

    public static boolean isLike(String s, String s1)
    {
        int i = s.length();
        int j = s1.length();
        if(replace(s1, "%", "").length() > i)
            return false;
        int l = 0;
        int k = 0;
        boolean flag = true;
        char c = ' ';
        char c1 = ' ';
        while((k < i || l < j) && flag) 
        {
            if(k < i)
                c = s.charAt(k);
            if(l < j)
                c1 = s1.charAt(l);
            if(c == c1){
                k++;
                l++;
            } else if(c1 == '_'){
                if(l < j && k < i)
                    return isLike(s.substring(k + 1), s1.substring(l + 1));
                flag = false;
            } else if(c1 == '%'){
                int i1 = 0;
                for(l++; (c1 == '_' || c1 == '%') && l < j; l++)
                {
                    if(c1 == '_')
                        i1++;
                    c1 = s1.charAt(l);
                }
                l--;
                if(c1 != '%'){
                    boolean flag1 = false;
                    for(k = s.indexOf(c1, k + i1); k >= 0 && !flag1; k = s.indexOf(c1, k + 1))
                        flag1 = isLike(s.substring(k), s1.substring(l));

                    return flag1;
                }
                k++;
                l = j;
            } else
            {
                flag = false;
            }
        }
        return flag;
    }

    public static boolean setAttribute(String as[][], String s, String s1)
    {
        boolean flag = false;
        for(int i = 0; i < as.length; i++)
            if(as[i][0].equalsIgnoreCase(s))
            {
                as[i][1] = s1;
                flag = true;
                return flag;
            }

        return flag;
    }

    public static String getAttribute(String as[][], String s)
    {
        return getAttribute(as, s, 0, 1);
    }

    public static String getAttribute(String as[][], String s, int i, int j)
    {
        String s1 = null;
        for(int k = 0; k < as.length; k++)
            if(as[k][i].equalsIgnoreCase(s))
            {
                s1 = as[k][j];
                return s1;
            }

        return s1;
    }

    public static long getQuot(String s, String s1)
    {
        long l = 0L;
        SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyy/MM/dd");
        try
        {
            Date date = simpledateformat.parse(s);
            Date date1 = simpledateformat.parse(s1);
            l = date.getTime() - date1.getTime();
            l = l / 1000L / 60L / 60L / 24L;
        }
        catch(ParseException parseexception)
        {
            parseexception.printStackTrace();
        }
        return l;
    }

    public static String getRelativeAccountMonth(String s, String s1, int i)
    {
        String s2 = s.substring(0, 4);
        String s3 = s.substring(5, 7);
        int j = Integer.valueOf(s2).intValue();
        int k = Integer.valueOf(s3).intValue();
        if(s1.equalsIgnoreCase("year"))
            j += i;
        else
        if(s1.equalsIgnoreCase("month"))
        {
            j += (k + i) / 12;
            k = (k + i) % 12;
            if(k <= 0)
            {
                j--;
                k += 12;
            }
        }
        s2 = String.valueOf(j);
        s3 = String.valueOf(k);
        if(s3.length() == 1)
            s3 = "0" + s3;
        return s2 + "/" + s3;
    }

    public static String getRelativeMonth(String s, int i)
    {
        String s1 = "";
        String s2 = s.substring(0, 4);
        String s3 = s.substring(5, 7);
        String s4 = s.substring(8, 10);
        int j = Integer.valueOf(s2).intValue();
        int k = Integer.valueOf(s3).intValue();
        int l = Integer.valueOf(s4).intValue();
        if(i >= 0)
        {
            j += (k + i) / 12;
            k = (k + i) % 12;
            if(k == 0)
            {
                k = 12;
                j--;
            }
        } else
        if(k > Math.abs(i))
        {
            k += i;
        } else
        {
            j = (j + (k + i) / 12) - 1;
            k = 12 + (k + i) % 12;
        }
        s2 = String.valueOf(j);
        s3 = String.valueOf(k);
        s4 = String.valueOf(l);
        if(s3.length() == 1)
            s3 = "0" + s3;
        if(s4.length() == 1)
            s4 = "0" + s4;
        s1 = s2 + "/" + s3 + "/" + s4;
        return s1;
    }

    public static String getRelativeDate(String s, int i)
    {
        long l2 = 86400000L;
        String s1 = s.substring(0, 4);
        String s2 = s.substring(5, 7);
        String s3 = s.substring(8, 10);
        int j = Integer.valueOf(s1).intValue();
        int k = Integer.valueOf(s2).intValue();
        int l = Integer.valueOf(s3).intValue();
        Calendar calendar = Calendar.getInstance();
        calendar.set(j, k - 1, l);
        long l1 = calendar.getTimeInMillis();
        l1 += (long)i * l2;
        calendar.setTimeInMillis(l1);
        j = calendar.get(1);
        k = calendar.get(2) + 1;
        l = calendar.get(5);
        s1 = String.valueOf(j);
        s2 = String.valueOf(k);
        s3 = String.valueOf(l);
        if(s2.length() == 1)
            s2 = "0" + s2;
        if(s3.length() == 1)
            s3 = "0" + s3;
        return s1 + "/" + s2 + "/" + s3;
    }

    public static String numberToChinese(double d)
    {
        DecimalFormat decimalformat = new DecimalFormat("############0.00");
        String s = decimalformat.format(d);
        int i = s.indexOf(".");
        if(s.substring(i).compareTo(".00") == 0)
            s = s.substring(0, i);
        String s1 = "";
        String as[] = new String[4];
        String as1[] = new String[4];
        String as2[] = new String[2];
        String s2 = "";
        String s4 = "";
        String s6 = "";
        int j = 0;
        int k = 0;
        boolean flag = false;
        as[0] = "";
        as[1] = "\u62FE";
        as[2] = "\u4F70";
        as[3] = "\u4EDF";
        as1[0] = "";
        as1[1] = "\u4E07";
        as1[2] = "\u4EBF";
        as1[3] = "\u4E07";
        as2[0] = "\u5206";
        as2[1] = "\u89D2";
        if(s.compareTo("0") == 0 || s.compareTo("0.0") == 0 || s.compareTo("0.00") == 0)
        {
            s6 = "\u96F6\u5143\u6574";
            return s6;
        }
        if(s.indexOf(".") > 0)
            s1 = s.substring(0, s.indexOf("."));
        else
            s1 = s;
        j = s1.length() % 4 == 0 ? s1.length() / 4 : s1.length() / 4 + 1;
        for(int i1 = j; i1 >= 1; i1--)
        {
            int l;
            if(i1 == j && s1.length() % 4 != 0)
                l = s1.length() % 4;
            else
                l = 4;
            String s3 = s1.substring(k, k + l);
            for(int k1 = 0; k1 < s3.length(); k1++)
            {
                if(Integer.parseInt(s3.substring(k1, k1 + 1)) != 0)
                {
                    switch(Integer.parseInt(s3.substring(k1, k1 + 1)))
                    {
                    case 1: // '\001'
                        s6 = s6 + "\u58F9" + as[s3.length() - k1 - 1];
                        break;

                    case 2: // '\002'
                        s6 = s6 + "\u8D30" + as[s3.length() - k1 - 1];
                        break;

                    case 3: // '\003'
                        s6 = s6 + "\u53C1" + as[s3.length() - k1 - 1];
                        break;

                    case 4: // '\004'
                        s6 = s6 + "\u8086" + as[s3.length() - k1 - 1];
                        break;

                    case 5: // '\005'
                        s6 = s6 + "\u4F0D" + as[s3.length() - k1 - 1];
                        break;

                    case 6: // '\006'
                        s6 = s6 + "\u9646" + as[s3.length() - k1 - 1];
                        break;

                    case 7: // '\007'
                        s6 = s6 + "\u67D2" + as[s3.length() - k1 - 1];
                        break;

                    case 8: // '\b'
                        s6 = s6 + "\u634C" + as[s3.length() - k1 - 1];
                        break;

                    case 9: // '\t'
                        s6 = s6 + "\u7396" + as[s3.length() - k1 - 1];
                        break;
                    }
                    continue;
                }
                if(k1 + 1 < s3.length() && s3.charAt(k1 + 1) != '0')
                    s6 = s6 + "\u96F6";
            }

            k += l;
            if(i1 < j)
            {
                if(Integer.parseInt(s3.substring(s3.length() - 1, s3.length())) != 0 || Integer.parseInt(s3.substring(s3.length() - 2, s3.length() - 1)) != 0 || Integer.parseInt(s3.substring(s3.length() - 3, s3.length() - 2)) != 0 || Integer.parseInt(s3.substring(s3.length() - 4, s3.length() - 3)) != 0)
                    s6 = s6 + as1[i1 - 1];
            } else
            {
                s6 = s6 + as1[i1 - 1];
            }
        }

        if(s6.length() > 0)
            s6 = s6 + "\u5143";
        if(s.indexOf(".") > 0)
        {
            String s5 = s.substring(s.indexOf(".") + 1);
            for(int j1 = 0; j1 < 2; j1++)
                if(Integer.parseInt(s5.substring(j1, j1 + 1)) != 0)
                    switch(Integer.parseInt(s5.substring(j1, j1 + 1)))
                    {
                    case 1: // '\001'
                        s6 = s6 + "\u58F9" + as2[1 - j1];
                        break;

                    case 2: // '\002'
                        s6 = s6 + "\u8D30" + as2[1 - j1];
                        break;

                    case 3: // '\003'
                        s6 = s6 + "\u53C1" + as2[1 - j1];
                        break;

                    case 4: // '\004'
                        s6 = s6 + "\u8086" + as2[1 - j1];
                        break;

                    case 5: // '\005'
                        s6 = s6 + "\u4F0D" + as2[1 - j1];
                        break;

                    case 6: // '\006'
                        s6 = s6 + "\u9646" + as2[1 - j1];
                        break;

                    case 7: // '\007'
                        s6 = s6 + "\u67D2" + as2[1 - j1];
                        break;

                    case 8: // '\b'
                        s6 = s6 + "\u634C" + as2[1 - j1];
                        break;

                    case 9: // '\t'
                        s6 = s6 + "\u7396" + as2[1 - j1];
                        break;
                    }
                else
                if(s6.length() > 0)
                    s6 = s6 + "\u96F6";

        } else
        {
            s6 = s6 + "\u6574";
        }
        if(s6.substring(s6.length() - 1).compareTo("\u96F6") == 0)
            s6 = s6.substring(0, s6.length() - 1);
        return s6;
    }

    public static String macroReplace(String as[][], String s, String s1, String s2)
        throws Exception
    {
        return macroReplace(as, s, s1, s2, 0, 1);
    }

    public static String macroReplace(String as[][], String s, String s1, String s2, int i, int j)
        throws Exception
    {
        String s4;
        int k = 0;
        int l = 0;
        String s3 = "";
        s4 = s;
        try
        {
            if(as == null || as.length == 0 || s == null)
                return null;
        }
        catch(Exception exception)
        {
            throw new Exception("\u5B8F\u66FF\u6362\u9519\u8BEF:" + exception.toString());
        }
        while((k = s4.indexOf(s1, k)) >= 0) 
        {
            l = s4.indexOf(s2, k);
            s3 = s4.substring(k, l + s2.length());
            s4 = s4.substring(0, k) + getAttribute(as, s3, i, j) + s4.substring(l + s2.length());
        }
        return s4;
    }

    public static String macroReplace(ASValuePool asvaluepool, String s, String s1, String s2)
        throws Exception
    {
        if(s == null)
            return null;
        if(asvaluepool == null || asvaluepool.size() == 0)
            return s;
        int i = 0;
        boolean flag = false;
        String s3 = "";
        String s5 = "";
        Object obj = null;
        String s7 = s;
        try
        {
            while((i = s7.indexOf(s1, i)) >= 0) 
            {
                int j = s7.indexOf(s2, i);
                String s4 = s7.substring(i + s1.length(), j);
                Object obj1 = asvaluepool.getAttribute(s4);
                if(obj1 == null)
                {
                    i = j;
                } else
                {
                    String s6 = (String)obj1;
                    s7 = s7.substring(0, i) + s6 + s7.substring(j + s2.length());
                }
            }
        }
        catch(Exception exception)
        {
            throw new Exception("\u5B8F\u66FF\u6362\u9519\u8BEF:" + exception.toString());
        }
        return s7;
    }

    public static String macroRepeat(String as[], String s)
        throws Exception
    {
        String s1 = s;
        for(int i = 0; i < as.length; i++)
            s1 = s1 + replace(s1, "[$CIRCULATOR/$]", as[i]);

        return s1;
    }

    public static String getXProfileString(String s, String s1, String s2)
    {
        return s.substring(s.indexOf(s1) + s1.length(), s.indexOf(s2));
    }

    public static String replaceConstants(String s, String s1, String s2)
        throws Exception
    {
        if(s == null || s.equals(""))
            return "";
        String s3 = s;
        for(int i = s3.indexOf(s1); i >= 0; i = s3.indexOf(s1, i + s2.length()))
            s3 = s3.substring(0, i) + s2 + s3.substring(i + s1.length(), s3.length());

        return s3;
    }

    public static ASValuePool convertStringArray2ValuePool(String as[], String as1[])
        throws Exception
    {
        ASValuePool asvaluepool = new ASValuePool();
        for(int i = 0; i < as.length; i++)
            if(as1.length >= i)
            {
                if(as1[i] != null)
                    as1[i] = as1[i].trim();
                asvaluepool.setAttribute(as[i], as1[i]);
            } else
            {
                asvaluepool.setAttribute(as[i], null);
            }

        return asvaluepool;
    }

    public static ASValuePool convertStringArray2ValuePool(String as[][])
        throws Exception
    {
        ASValuePool asvaluepool = new ASValuePool();
        for(int i = 0; i < as.length; i++)
        {
            if(as[i][1] != null)
                as[i][1] = as[i][1].trim();
            asvaluepool.setAttribute(as[i][0], as[i][1]);
        }

        return asvaluepool;
    }

    public static String getTodayNow()
    {
        return getToday("/") + " " + getNow();
    }

    public static String getMathRandom()
    {
        String s = Double.toString(Math.random());
        if(s.length() == 18)
            return s;
        if(s.length() > 18)
            return s.substring(0, 18);
        if(s.length() < 18)
            return (s + "00000000").substring(0, 18);
        else
            return s;
    }

    public static String[][] genStringArray(String s)
    {
        int i = getSeparateSum(s, "{") - 1;
        int l = getSeparateSum(s, "}") - 1;
        int k1 = getSeparateSum(s, "\"") - 1;
        int l1 = k1 / 2;
        int i2 = i - 1;
        int j2 = 0;
        int k2 = 0;
        int l2 = 0;
        j2 = l1 / i2;
        String s1 = "";
        if(i < 2 || i != l || k1 % 2 != 0)
            return (String[][])null;
        String s3 = s.trim();
        s3 = s3.substring(s3.indexOf("{") + 1, s3.lastIndexOf("}")).trim();
        String as[][] = new String[i2][j2];
        int i3 = 0;
        do
        {
            if(i3 >= i2)
                break;
            int j = s3.indexOf("{", k2) + 1;
            int i1 = s3.indexOf("}", k2);
            k2 = i1 + 1;
            if(j > i1)
                return (String[][])null;
            String s2 = s3.substring(j, i1).trim();
            System.out.println(s2);
            for(int j3 = 0; j3 < j2; j3++)
            {
                int k = s2.indexOf("\"", l2) + 1;
                int j1 = s2.indexOf("\"", k);
                as[i3][j3] = s2.substring(k, j1);
                System.out.println("strArray2[" + i3 + "][" + j3 + "]=" + as[i3][j3]);
                l2 = j1 + 1;
            }

            l2 = 0;
            if(k2 >= s3.length())
                break;
            i3++;
        } while(true);
        return as;
    }

    public static String filterControlChar(String s)
    {
        return s.replaceAll("\\p{Cntrl}", "");
    }

    public static String fixDigital(String s)
    {
        Matcher matcher = dpattern.matcher(s);
        StringBuffer stringbuffer = new StringBuffer();
        int i;
label0:
        for(; matcher.find(); matcher.appendReplacement(stringbuffer, String.valueOf(i % 10)))
        {
            i = 0;
            int j = 1;
            do
            {
                if(j > 10)
                    continue label0;
                if(matcher.group(j) != null)
                {
                    i = j;
                    continue label0;
                }
                j++;
            } while(true);
        }

        matcher.appendTail(stringbuffer);
        return stringbuffer.toString();
    }

    public static String fixPID(String s)
    {
        String s1 = filterControlChar(s);
        String s2 = fixDigital(s1);
        if(s2.length() != 15)
            return s2.toUpperCase();
        StringBuffer stringbuffer = new StringBuffer(s2);
        stringbuffer.insert(6, "19");
        int i = 0;
        for(int j = 0; j < 17; j++)
            i += Character.digit(stringbuffer.charAt(j), 10) * weight[j];

        stringbuffer.append(vcode[i % 11]);
        return stringbuffer.toString();
    }

    public static void main(String args[])
    {
       // System.out.println(fixPID("150202760929122"));
        //System.out.println(StringFunction.getOccurTimes("xXxYYx2134Y","X" ,"Y", 0, 11));
       // System.out.println(StringFunction.indexOf("xXxYYx2134Y","2","X" ,"Y", 0));
    	System.out.println(StringFunction.getRelativeAccountMonth("2014/03", "month", -1));
    }

    private static int weight[] = {
        7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 
        7, 9, 10, 5, 8, 4, 2, 1
    };
    private static char vcode[] = {
        '1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', 
        '2'
    };
    private static String hzDigital;
    private static Pattern dpattern;

    static 
    {
        hzDigital = "([\uFF11\u4E00\u58F9])|([\uFF12\u4E8C\u8D30])|([\uFF13\u4E09\u53C1])|([\uFF14\u56DB\u8086])|([\uFF15\u4E94\u4F0D])|([\uFF16\u516D\u9646])|([\uFF17\u4E03\u67D2])|([\uFF18\u516B\u634C])|([\uFF19\u4E5D\u7396])|([\uFF10\u3007\u96F6])";
        dpattern = Pattern.compile(hzDigital);
    }
}