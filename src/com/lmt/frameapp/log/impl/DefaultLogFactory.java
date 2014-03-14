package com.lmt.frameapp.log.impl;

import java.util.Hashtable;

import org.apache.log4j.Logger;

import com.lmt.frameapp.log.Log;
import com.lmt.frameapp.log.LogException;
import com.lmt.frameapp.log.LogFactory;

// Referenced classes of package com.amarsoft.are.log.impl:
//            SimpleLog, JDKLog, Log4JLog, DummyLog
public class DefaultLogFactory extends LogFactory
{

    public DefaultLogFactory()
    {
        logType = null;
        logProperties = null;
        instances = new Hashtable();
    }

    public Log getInstance(String s)
        throws LogException
    {
        Log log = (Log)instances.get(s);
        if(log == null)
        {
            log = newInstance(s);
            instances.put(s, log);
        }
        return log;
    }

    public void shutdown()
    {
        instances.clear();
    }

    public String getLogType()
    {
        if(logType == null)
            logType = "SimpleLog";
        return logType;
    }

    protected Log newInstance(String s)
        throws LogException
    {
        Object obj = null;
        String s1 = getLogType();
        if(s1.equalsIgnoreCase("SIMPLE"))
            obj = new SimpleLog(s);
        else
        if(s1.equalsIgnoreCase("JDK"))
            obj = new JDKLog(s);
        else
        if(s1.equalsIgnoreCase("LOG4J"))
            obj = new Log4JLog(Logger.getLogger(s));
        else
            obj = new DummyLog();
        return ((Log) (obj));
    }

    public String getServiceProvider()
    {
        return "Amarsoft";
    }

    public String getServiceDescribe()
    {
        return "\u7F3A\u7701\u7684\u65E5\u5FD7\u5DE5\u5382\u7684\u5B9E\u73B0";
    }

    public String getServiceVersion()
    {
        return "0.1";
    }

    public void initLogFactory()
        throws Exception
    {
        String s = getLogProperties();
        String s1 = getLogType();
        if(s1.equalsIgnoreCase("SIMPLE"))
            SimpleLog.setLogProperties(s);
        else
        if(s1.equalsIgnoreCase("JDK"))
            JDKLog.setLogProperties(s);
        else
        if(s1.equalsIgnoreCase("LOG4J"))
            Log4JLog.setLogProperties(s);
    }

    public final String getLogProperties()
    {
        return logProperties;
    }

    public final void setLogProperties(String s)
    {
        logProperties = s;
    }

    public final void setLogType(String s)
    {
        logType = s;
    }

    private static final String version = "0.1";
    private static final String provider = "Amarsoft";
    private static final String describe = "\u7F3A\u7701\u7684\u65E5\u5FD7\u5DE5\u5382\u7684\u5B9E\u73B0";
    private String logType;
    private String logProperties;
    protected Hashtable instances;
    public static final String LOG_TYPE_SIMPLE = "SIMPLE";
    public static final String LOG_TYPE_JDK = "JDK";
    public static final String LOG_TYPE_DUMMY = "DUMMY";
    public static final String LOG_TYPE_LOG4J = "LOG4J";
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\are-0.2.jar
	Total time: 260 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/