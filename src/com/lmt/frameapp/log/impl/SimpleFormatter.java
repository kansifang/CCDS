/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) radix(10) lradix(10) 

package com.lmt.frameapp.log.impl;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.logging.Formatter;
import java.util.logging.LogRecord;

public class SimpleFormatter extends Formatter
{

    public SimpleFormatter()
    {
    }

    public synchronized String format(LogRecord logrecord)
    {
        StringBuffer stringbuffer = new StringBuffer();
        int i = inferCaller(logrecord);
        String s = logrecord.getLoggerName();
        if(s != null)
        {
            stringbuffer.append(s);
            stringbuffer.append(" ");
        }
        if(logrecord.getSourceClassName() != null)
            stringbuffer.append(logrecord.getSourceClassName());
        if(logrecord.getSourceMethodName() != null)
        {
            stringbuffer.append('.');
            stringbuffer.append(logrecord.getSourceMethodName());
            if(i != -1)
                stringbuffer.append("().").append(Integer.toString(i));
            else
                stringbuffer.append("()");
        }
        stringbuffer.append(' ');
        stringbuffer.append(logrecord.getMessage());
        if(logrecord.getThrown() != null)
            try
            {
                StringWriter stringwriter = new StringWriter();
                PrintWriter printwriter = new PrintWriter(stringwriter);
                logrecord.getThrown().printStackTrace(printwriter);
                printwriter.close();
                stringbuffer.append(stringwriter.toString());
            }
            catch(Exception exception) { }
        return stringbuffer.toString();
    }

    private int inferCaller(LogRecord logrecord)
    {
        StackTraceElement astacktraceelement[] = (new Throwable()).getStackTrace();
        int i = -1;
        int j = 0;
        do
        {
            if(j >= astacktraceelement.length)
                break;
            StackTraceElement stacktraceelement = astacktraceelement[j];
            String s = stacktraceelement.getClassName();
            if(s.equals("com.amarsoft.are.log.impl.SimpleLog"))
                break;
            j++;
        } while(true);
        do
        {
            if(j >= astacktraceelement.length)
                break;
            StackTraceElement stacktraceelement1 = astacktraceelement[j];
            i = astacktraceelement[j].getLineNumber();
            String s1 = stacktraceelement1.getClassName();
            if(!s1.equals("com.amarsoft.are.log.impl.SimpleLog"))
                break;
            j++;
        } while(true);
        return i;
    }
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\are-0.2.jar
	Total time: 174 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/