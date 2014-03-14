package com.lmt.baseapp.util;

import com.lmt.frameapp.sql.Transaction;

public class SpecialTools
{

    public SpecialTools()
    {
    }

    public static String real2Amarsoft(String s)
        throws Exception
    {
        String s1 = "";
        if(s != null)
        {
            s1 = s;
            for(int i = 0; i < sAmarReplace.length; i++)
                s1 = StringFunction.replace(s1, sAmarReplace[i][0], sAmarReplace[i][1]);

        } else
        {
            s1 = null;
        }
        return s1;
    }

    public static String amarsoft2Real(String s)
        throws Exception
    {
        String s1 = "";
        if(s != null)
        {
            s1 = s;
            s1 = StringFunction.macroReplace(sAmarReplace, s1, "~[", "]", 1, 0);
        } else
        {
            s1 = null;
        }
        return s1;
    }

    public static String amarsoft2DB(String s)
        throws Exception
    {
        String s1 = "";
        if(s != null)
        {
            s1 = s;
            s1 = StringFunction.macroReplace(sAmarReplace, s1, "~[", "]", 1, 2);
        } else
        {
            s1 = null;
        }
        return s1;
    }

    public static String amarsoft2Informix(String s)
        throws Exception
    {
        String s1 = "";
        if(s != null)
        {
            s1 = s;
            s1 = StringFunction.macroReplace(sAmarReplace, s1, "~[", "]", 1, 5);
        } else
        {
            s1 = null;
        }
        return s1;
    }

    public static String db2Informix(String s)
        throws Exception
    {
        String s1 = "";
        if(s != null)
        {
            s1 = s;
            for(int i = 0; i < sAmarReplace.length; i++)
                if(!sAmarReplace[i][2].equals(sAmarReplace[i][5]))
                    s1 = StringFunction.replace(s1, sAmarReplace[i][2], sAmarReplace[i][5]);

        } else
        {
            s1 = null;
        }
        return s1;
    }

    public static String informix2DB(String s)
        throws Exception
    {
        String s1 = "";
        if(s != null)
        {
            s1 = s;
            for(int i = 0; i < sAmarReplace.length; i++)
                if(!sAmarReplace[i][5].equals(sAmarReplace[i][2]))
                    s1 = StringFunction.replace(s1, sAmarReplace[i][5], sAmarReplace[i][2]);

        } else
        {
            s1 = null;
        }
        return s1;
    }

    public static String replaceAll(String s, String s1, String s2)
        throws Exception
    {
        if(s == null || s.equals(""))
            return "";
        String s3 = s;
        for(int i = s3.indexOf(s1); i >= 0; i = s3.indexOf(s1, i + s2.length()))
            s3 = s3.substring(0, i) + s2 + s3.substring(i + s1.length(), s3.length());

        return s3;
    }

    public static String htmlEncoder(String s)
        throws Exception
    {
        if(s == null || s.equals(""))
        {
            return "";
        } else
        {
            String s1 = s;
            s1 = replaceAll(s1, "<", "&lt;");
            s1 = replaceAll(s1, ">", "&rt;");
            s1 = replaceAll(s1, "\"", "&quot;");
            s1 = replaceAll(s1, "'", "&#039;");
            s1 = replaceAll(s1, " ", "&nbsp;");
            s1 = replaceAll(s1, "\r\n", "<br>");
            s1 = replaceAll(s1, "\r", "<br>");
            s1 = replaceAll(s1, "\n", "<br>");
            return s1;
        }
    }

    public static String xmlEncoder(String s)
        throws Exception
    {
        if(s == null || s.equals(""))
        {
            return "";
        } else
        {
            String s1 = s;
            s1 = replaceAll(s1, "&", "&amp;");
            s1 = replaceAll(s1, "<", "&lt;");
            s1 = replaceAll(s1, ">", "&gt;");
            s1 = replaceAll(s1, "\"", "&quot;");
            s1 = replaceAll(s1, "'", "&acute;");
            return s1;
        }
    }

    public static String getAmarscriptLangSpec(Transaction transaction)
        throws Exception
    {
        String s = "";
        StringBuffer stringbuffer = new StringBuffer("");
        String s1 = "";
        stringbuffer.append("<?xml version='1.0' encoding='GB2312' ?>\r\n");
        stringbuffer.append("<AmarWebControls>\r\n");
        stringbuffer.append("  <Components>\r\n");
        stringbuffer.append("    <Component Name='ResoureTreeList' Type='TreeList'>\r\n");
        stringbuffer.append("    <Node Name='01' Title='\u7C7B.\u65B9\u6CD5' Describe='\u5E38\u7528\u7684\u65B9\u6CD5' Value=''/>\r\n");
        s = "select ClassName,ClassDescribe from CLASS_CATALOG order by ClassName";
        String as[][] = transaction.getStringMatrix(s, 2, 2);
        s = "select ClassName,MethodName,MethodDescribe||'<br>\u53C2\u6570:'||MethodArgs||'<br>\u8FD4\u56DE\u503C\u7C7B\u578B:'||ReturnType||'<br>\u66F4\u65B0\u4EBA:'||UpdateUser||' <br>\u66F4\u65B0\u65F6\u95F4:'||UpdateTime,MethodArgs from CLASS_METHOD order by ClassName,MethodName";
        String as1[][] = transaction.getStringMatrix(s);
        for(int i = 0; i < as.length; i++)
        {
            String s2 = add0BeforeString(Integer.toString(i), 3);
            stringbuffer.append("    <Node Name='01" + s2 + "' Title='" + as[i][0] + "' Describe='" + as[i][1] + "' Value=''/>\r\n");
            for(int j = 0; j < as1.length; j++)
                if(as1[j][0].equals(as[i][0]))
                    stringbuffer.append("    <Node Name='01" + s2 + add0BeforeString(Integer.toString(j), 3) + "' Title='" + real2Amarsoft(as1[j][1]) + "' Describe='" + real2Amarsoft(as1[j][2]) + "' Value='" + "!" + as1[j][0] + "." + as1[j][1] + "(" + as1[j][3] + ")'/>\r\n");

        }

        stringbuffer.append("    </Component>\r\n");
        stringbuffer.append("  </Components>\r\n");
        stringbuffer.append("</AmarWebControls>\r\n");
        String s3 = stringbuffer.toString();
        return s3;
    }

    public static String add0BeforeString(String s, int i)
    {
        String s1;
        for(s1 = s; s1.length() < i; s1 = "0" + s1);
        return s1;
    }

    public static void main(String args[])
        throws Exception
    {
        String s = "abc'\"\\";
        String s1 = "\u793A\u4F8B'<textarea>aaa</textarea>";
        System.out.println(real2Amarsoft(s));
        System.out.println(real2Amarsoft(s1));
    }

    static String sAmarReplace[][] = {
        {"\\", "~[isl]", "\\", "\\\\", "&#92;", "\\"}, 
        {"'", "~[sqt]", "''", "\\'", "&#39;", "''"}, 
        {"\"", "~[dqt]", "\"", "\"", "&#34;", "\""},
        {"<", "~[alt]", "<", "<", "&#60;", "<"}, 
        {">", "~[agt]", ">", ">", "&#62;", ">"}, 
        {"\r\n", "~[arn]", "\r\n", "\\r\\n", "\r\n", "\\r\\n"},
        {"\r", "~[aor]", "\r\n", "\\r\\n", "\r\n", "\\r"}, 
        {"\n", "~[aon]", "\r\n", "\\r\\n", "\r\n", "\\n"}, 
        {"#", "~[pds]", "#", "#", "#", "#"}, 
        {"(", "~[lpr]", "(", "(", "(", "("}, 
        {")", "~[rpr]", ")", ")", ")", ")"}, 
        {"+", "~[pls]", "+", "+", "+", "+"}
    };

}
