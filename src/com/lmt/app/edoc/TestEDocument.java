/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.app.edoc;

import java.util.HashMap;

import com.lmt.frameapp.sql.ConnectionManager;
import com.lmt.frameapp.sql.Transaction;

// Referenced classes of package com.amarsoft.app.edoc:
//            EDocument

public class TestEDocument
{

    public TestEDocument()
    {
    }

    public static Transaction getSqlca()
        throws Exception
    {
        String s = "jdbc:oracle:thin:@asn1001:1521:als6";
        String s1 = "oracle.jdbc.driver.OracleDriver";
        String s2 = "SZPAB";
        String s3 = "SZPAB";
        return ConnectionManager.getTransaction(s, s1, s2, s3);
    }

    public static void testEDoc()
        throws Exception
    {
        String sTemplate = "E:/月度经营分析报告2014年01月末/A003_月度经营报告格式定义.doc";
        String sDataDefine = "E:/月度经营分析报告2014年01月末/A003_月度经营报告数据定义.xml";
        String s2 = "D:/tmp/edoc/\u8865\u4EF6\u901A\u77E5\u4E66.doc";
        String s3 = "D:/tmp/edoc/\u8865\u4EF6\u901A\u77E5\u4E66.xml";
        String s4 = "E:/月度经营分析报告2014年01月末/月度经营报告.doc";
        EDocument edocument = new EDocument(sTemplate, sDataDefine);
        System.out.println(edocument.checkTag());
        System.out.println(edocument.getTagList());
        System.out.println(edocument.getDefTagList());
        edocument.saveAsDefault(s4);
    }

    public static void testStamper()
        throws Exception
    {
        String s = "src/com/amarsoft/app/edoc/\u4E24\u65B9\u7B7E\u7AE0\u9875.doc";
        String s1 = "src/com/amarsoft/app/edoc/\u7B7E\u7AE0\u9875\u5B9A\u4E49.xml";
        String s2 = "D:/tmp/edoc/\u7535\u5B50\u7B7E\u7AE0\u9875\uFF08\u4E24\u65B9\uFF09.doc";
        String s3 = "D:/tmp/edoc/\u7B7E\u7AE0\u9875\u6570\u636E.xml";
        String s4 = "D:/tmp/edoc/\u4E24\u65B9\u7B7E\u7AE0\u9875.doc";
        EDocument edocument = new EDocument(s, s1);
        edocument.saveAsDefault(s4);
        HashMap hashmap = new HashMap();
        hashmap.put("EDocName", "    \u501F\u6B3E\u5408\u540C");
        hashmap.put("CustomerName", "\u6DF1\u5733\u5E02\u65B0\u4E16\u754C\u96C6\u56E2\u6709\u9650\u516C\u53F8");
        hashmap.put("ContractID", "C1001101010800028");
        System.out.println("OutFName=" + s2);
    }

    public static void main(String args[])
    {
        try
        {
            testEDoc();
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
    }
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\workspace\ALS7\WebRoot\WEB-INF\lib\edoc-1.1.jar
	Total time: 84 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/