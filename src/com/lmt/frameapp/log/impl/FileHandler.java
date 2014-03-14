/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
//忽略掉了一个openFile（）方法，
package com.lmt.frameapp.log.impl;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.nio.channels.FileChannel;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.logging.Formatter;

import com.lmt.frameapp.ARE;

// Referenced classes of package com.amarsoft.are.log.impl:
//            SimpleHandler

public class FileHandler extends SimpleHandler
{

    public FileHandler()
    {
        pattern = "./log/simple_%g.log";
        append = true;
        datefile = false;
        iLogLength = 0L;
        out = null;
        configure();
    }

    public void configure()
    {
        super.configure();
        String s = getStringProperty("com.amarsoft.are.log.impl.FileHandler.level");
        if(s != null)
            setLogLevel(s);
        pattern = getStringProperty("com.amarsoft.are.log.impl.FileHandler.pattern", pattern);
        pattern = ARE.replaceARETags(pattern);
        if(pattern.indexOf("%D") != -1)
            datefile = true;
        if(datefile)
        {
            date = (new SimpleDateFormat("yyyyMMdd")).format(new Date());
            pattern = pattern.replaceAll("%D", date);
        }
        String s1 = getStringProperty("com.amarsoft.are.log.impl.FileHandler.limit", "10");
        limit = Integer.parseInt(s1);
        String s2 = getStringProperty("com.amarsoft.are.log.impl.FileHandler.count");
        if(s2 != null)
            count = Integer.parseInt(s2);
        String s3 = getStringProperty("com.amarsoft.are.log.impl.FileHandler.append", "true");
        append = "true".equalsIgnoreCase(s3);
        String s4 = getStringProperty("com.amarsoft.are.log.impl.FileHandler.formatter");
        if(s4 != null)
            try
            {
                Class class1 = Thread.currentThread().getContextClassLoader().loadClass(s4);
                setFormatter((Formatter)class1.newInstance());
            }
            catch(Exception exception) { }
    }
    private File generate(String s, int i, int j)
        throws IOException
    {
        File file = null;
        String s1 = "";
        int k = 0;
        boolean flag = false;
        boolean flag1 = false;
        do
        {
            if(k >= s.length())
                break;
            char c = s.charAt(k);
            k++;
            char c1 = '\0';
            if(k < s.length())
                c1 = Character.toLowerCase(s.charAt(k));
            if(c == '/')
            {
                if(file == null)
                    file = new File(s1);
                else
                    file = new File(file, s1);
                s1 = "";
                continue;
            }
            if(c == '%')
            {
                if(c1 == 't')
                {
                    String s2 = System.getProperty("java.io.tmpdir");
                    if(s2 == null)
                        s2 = System.getProperty("user.home");
                    file = new File(s2);
                    k++;
                    s1 = "";
                    continue;
                }
                if(c1 == 'h')
                {
                    file = new File(System.getProperty("user.home"));
                    if(isSetUID())
                        throw new IOException("can't use %h in set UID program");
                    k++;
                    s1 = "";
                    continue;
                }
                if(c1 == 'g')
                {
                    s1 = s1 + i;
                    flag = true;
                    k++;
                    continue;
                }
                if(c1 == 'u')
                {
                    s1 = s1 + j;
                    flag1 = true;
                    k++;
                    continue;
                }
                if(c1 == '%')
                {
                    s1 = s1 + "%";
                    k++;
                    continue;
                }
            }
            s1 = s1 + c;
        } while(true);
        if(count > 1 && !flag)
            s1 = s1 + "." + i;
        if(j > 0 && !flag1)
            s1 = s1 + "." + j;
        if(s1.length() > 0)
            if(file == null)
                file = new File(s1);
            else
                file = new File(file, s1);
        return file;
    }

    private static native boolean isSetUID();

    private synchronized void open(File file, boolean flag)
        throws IOException
    {
        if(flag)
            iLogLength = (int)file.length();
        out = new PrintStream(new FileOutputStream(file, flag));
    }

    private synchronized void rotate()
    {
        int i = getLogLevel();
        setLogLevel(7);
        if(out != null)
        {
            out.close();
            out = null;
        }
        for(int j = count - 2; j >= 0; j--)
        {
            File file = files[j];
            File file1 = files[j + 1];
            if(!file.exists())
                continue;
            if(file1.exists())
                file1.delete();
            file.renameTo(file1);
        }

        try
        {
            if(datefile)
            {
                String s = (new SimpleDateFormat("yyyyMMdd")).format(new Date());
                System.out.println("pattern=" + pattern + s + date);
                if(!s.equals(date))
                {
                    pattern = pattern.replaceAll(date, s);
                    date = s;
                    close();
                }
            }
            open(files[0], false);
        }
        catch(IOException ioexception) { }
        setLogLevel(i);
    }

    private synchronized void writeMsg(String s)
    {
        iLogLength += s.getBytes().length + 1;
        if(files[0].exists() && iLogLength > limit)
        {
            iLogLength = 0L;
            rotate();
        }
        if(out == null)
            out = System.err;
        out.println(s);
    }

    public void publish(String s)
    {
        writeMsg(dateFormatter.format(Calendar.getInstance().getTime()) + " " + s);
    }

    public synchronized void close()
        throws SecurityException
    {
        super.close();
        if(lockFileName == null)
            return;
        try
        {
            lockStream.close();
            (new File(lockFileName)).delete();
        }
        catch(Exception exception) { }
        synchronized(locks)
        {
            locks.remove(lockFileName);
        }
        lockFileName = null;
        lockStream = null;
    }

    private File files[];
    private String pattern;
    private boolean append;
    private boolean datefile;
    private String date;
    private String lockFileName;
    private long iLogLength;
    private PrintStream out;
    private FileOutputStream lockStream;
    private static int count = 10;
    private static long limit = 1024000L;
    private static final int MAX_LOCKS = 100;
    private static HashMap locks = new HashMap();
    public static final String systemPrefix = "com.amarsoft.are.log.impl.FileHandler.";

}