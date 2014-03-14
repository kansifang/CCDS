package com.lmt.frameapp.config;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.config.dal.ASCodeDefinition;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

// Referenced classes of package com.amarsoft.web.config:
//            ASConfigure

public class CodeManager
{

    public CodeManager()
    {
    }

    public static String getItemName(String s, String s1, Transaction transaction)
        throws Exception
    {
        ASCodeDefinition ascodedefinition = (ASCodeDefinition)ASConfigure.getSysConfig("ASCodeSet", transaction).getAttribute(s);
        if(ascodedefinition == null)
        {
            String s2 = transaction.getString("select ItemName from CODE_LIBRARY where CodeNo='" + s + "' and ItemNo='" + s1 + "'");
            return s2;
        }
        for(int i = 0; i < ascodedefinition.items.size(); i++)
        {
            ASValuePool asvaluepool = ascodedefinition.getItem(i);
            if(s1.equals((String)asvaluepool.getAttribute("ItemNo")))
                return (String)asvaluepool.getAttribute("ItemName");
        }

        return "";
    }

    public static String[] getItemArray(String s, Transaction transaction)
        throws Exception
    {
        int i = 0;
        Object obj = null;
        String as1[] = null;
        ASCodeDefinition ascodedefinition = (ASCodeDefinition)ASConfigure.getSysConfig("ASCodeSet", transaction).getAttribute(s);
        if(ascodedefinition != null)
            i = ascodedefinition.items.size();
        if(i > 0)
        {
            String as[] = new String[i * 2];
            int j = 0;
            for(int k = 0; k < i; k++)
            {
                ASValuePool asvaluepool = ascodedefinition.getItem(k);
                if(asvaluepool.getAttribute("IsInUse") == null || asvaluepool.getAttribute("IsInUse").equals("1"))
                {
                    as[j * 2] = (String)asvaluepool.getAttribute("ItemNo");
                    as[j * 2 + 1] = (String)asvaluepool.getAttribute("ItemName");
                    j++;
                }
            }

            if(j > 0)
            {
                as1 = new String[j * 2];
                for(int l = 0; l < j * 2; l++)
                    as1[l] = as[l];

            }
        }
        return as1;
    }

    public static String getItemList(String s, Transaction transaction)
        throws Exception
    {
        String s1 = "select ItemNo,ItemName from CODE_LIBRARY where CodeNo = '" + s + "' and IsInUse= '1' order by ItemNo";
        return getItemListFromSql(s1, transaction);
    }

    public static String getItemListFromSql(String s, Transaction transaction)
        throws Exception
    {
        String s1 = "";
        ASResultSet asresultset;
        for(asresultset = transaction.getResultSet(s); asresultset.next();)
            s1 = s1 + "," + asresultset.getString(1) + "," + asresultset.getString(2);

        if(s1.length() > 0)
            s1 = s1.substring(1);
        asresultset.getStatement().close();
        return s1;
    }

    public static String[] getItemArrayFromSql(String s, Transaction transaction)
        throws Exception
    {
        String s1 = getItemListFromSql(s, transaction);
        return StringFunction.toStringArray(s1, ",");
    }
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 168 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/