package com.lmt.frameapp.config.dal;

import com.lmt.baseapp.util.ASValuePool;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

// Referenced classes of package com.amarsoft.web.config.loader:
//            IConfigLoader

public class ASPrefDefinitionLoader
    implements IConfigLoader
{

    public ASPrefDefinitionLoader()
    {
    }

    public ASValuePool loadConfig(Transaction transaction)
        throws Exception
    {
        ASValuePool LSValuePool = null;
        Object obj = null;
        Object obj1 = null;
        ASResultSet LSResultSet = null;
        LSValuePool = new ASValuePool(100);
        String s2 = "select PreferenceId,DefaultValue from User_Pref_Def ";
        String s;
        String s1;
        for(LSResultSet = transaction.getASResultSet(s2); LSResultSet.next(); LSValuePool.setAttribute(s, s1, false))
        {
            s = LSResultSet.getString(1);
            if(LSResultSet.getString(2) == null)
                s1 = "";
            else
                s1 = LSResultSet.getString(2).trim();
        }

        LSResultSet.getStatement().close();
        ASConfigure.setSysConfig("ASPrefSet", LSValuePool);
        return LSValuePool;
    }
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 275 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/