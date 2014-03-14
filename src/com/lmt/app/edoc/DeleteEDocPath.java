/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.app.edoc;

import java.io.File;

import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.log.Log;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class DeleteEDocPath extends Bizlet
{

    public DeleteEDocPath()
    {
        logger = ARE.getLog();
    }

    public Object run(Transaction transaction)
        throws Exception
    {
        String s = (String)getAttribute("EDocNo");
        if(s == null)
            s = "";
        String s1 = "select FullPathfmt,FullPathdef from EDOC_DEFINE where EDocNo='" + s + "'";
        ASResultSet asresultset = transaction.getASResultSet(s1);
        String s2 = "";
        String s3;
        for(s3 = ""; asresultset.next(); s3 = asresultset.getString("FullPathdef"))
            s2 = asresultset.getString("FullPathfmt");

        try
        {
            if(s2 != null && !s2.equals(""))
            {
                File file = new File(s2);
                file.delete();
            }
            if(s3 != null && !s3.equals(""))
            {
                File file1 = new File(s3);
                file1.delete();
            }
        }
        catch(RuntimeException runtimeexception)
        {
            logger.debug("\u6587\u4EF6\u5730\u5740\u4E0D\u5B58\u5728\uFF01", runtimeexception);
            return "0";
        }
        return "1";
    }

    Log logger;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\workspace\ALS7\WebRoot\WEB-INF\lib\edoc-1.1.jar
	Total time: 76 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/