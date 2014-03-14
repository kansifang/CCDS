/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.config.dal;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

// Referenced classes of package com.amarsoft.web.config.loader:
//            IConfigLoader

public class ASFuncDefinitionLoader
    implements IConfigLoader
{

    public ASFuncDefinitionLoader()
    {
    }

    public ASValuePool loadConfig(Transaction transaction)
        throws Exception
    {
        ASValuePool asvaluepool = null;
        Object obj = null;
        Object obj1 = null;
        ASResultSet LSResultSet = null;
        asvaluepool = new ASValuePool();
        String s2 = "select FunctionID,RightID from REG_FUNCTION_DEF ";
        String s;
        String s1;
        for(LSResultSet = transaction.getASResultSet(s2); LSResultSet.next(); asvaluepool.setAttribute(s, s1, false))
        {
            s = LSResultSet.getString(1);
            if(LSResultSet.getString(2) == null)
                s1 = "";
            else
                s1 = LSResultSet.getString(2).trim();
        }

        LSResultSet.getStatement().close();
        ASConfigure.setSysConfig("ASFuncSet", asvaluepool);
        return asvaluepool;
    }
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 175 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/