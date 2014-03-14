/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.sql;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.commons.dbcp.cpdsadapter.DriverAdapterCPDS;
import org.apache.commons.dbcp.datasources.SharedPoolDataSource;

import com.lmt.app.util.xml.Document;
import com.lmt.app.util.xml.Element;
import com.lmt.baseapp.util.DESEncrypt;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.io.FileTool;

// Referenced classes of package com.amarsoft.are.sql:
//            DBConnectionFactory

public class PooledConnectionFactory extends DBConnectionFactory
{

    public PooledConnectionFactory()
    {
        resourceFile = null;
        if(dataSources == null)
            dataSources = new Hashtable();
    }

    public Connection getInstance(String s)
        throws SQLException
    {
        if(s == null)
            throw new IllegalArgumentException("Database name is null!");
        Object obj = null;
        DataSource datasource = (DataSource)dataSources.get(s);
        if(datasource == null)
        {
            throw new SQLException("amarsoft.sql.ConnectionPool: No this DataSource '" + s + "' defined!");
        } else
        {
            Connection connection = datasource.getConnection();
            return connection;
        }
    }

    private void addDataSource(String s, Properties properties)
        throws ClassNotFoundException
    {
        DriverAdapterCPDS driveradaptercpds = new DriverAdapterCPDS();
        driveradaptercpds.setDriver(properties.getProperty("driver"));
        driveradaptercpds.setUrl(properties.getProperty("url"));
        driveradaptercpds.setUser(properties.getProperty("user"));
        driveradaptercpds.setPassword(properties.getProperty("password"));
        driveradaptercpds.setLoginTimeout(Integer.parseInt(properties.getProperty("loginTimeout", "0")));
        String s1 = properties.getProperty("logWriter", null);
        PrintWriter printwriter = null;
        if(s1 == null)
        {
            printwriter = null;
        } else
        {
            Object obj = null;
            if(s1.equalsIgnoreCase("system.err"))
                obj = System.err;
            else
            if(s1.equalsIgnoreCase("system.out"))
                obj = System.out;
            else
                try
                {
                    obj = new FileOutputStream(s1);
                }
                catch(FileNotFoundException filenotfoundexception)
                {
                    ARE.getLog().warn("Set logPrintWriter error.", filenotfoundexception);
                }
            if(obj != null)
                try
                {
                    printwriter = new PrintWriter(new OutputStreamWriter(((java.io.OutputStream) (obj)), "GBK"), true);
                }
                catch(UnsupportedEncodingException unsupportedencodingexception)
                {
                    printwriter = new PrintWriter(new OutputStreamWriter(((java.io.OutputStream) (obj))), true);
                }
        }
        if(printwriter != null)
            driveradaptercpds.setLogWriter(printwriter);
        SharedPoolDataSource sharedpooldatasource = new SharedPoolDataSource();
        sharedpooldatasource.setConnectionPoolDataSource(driveradaptercpds);
        sharedpooldatasource.setMaxActive(Integer.parseInt(properties.getProperty("maxActive", "10")));
        sharedpooldatasource.setMaxWait(Integer.parseInt(properties.getProperty("maxWait", "1000")));
        sharedpooldatasource.setMaxIdle(Integer.parseInt(properties.getProperty("maxIdle", "10")));
        dataSources.put(s, sharedpooldatasource);
    }

    public void shutdown()
    {
        Iterator iterator = dataSources.values().iterator();
        Object obj = null;
        do
        {
            if(!iterator.hasNext())
                break;
            SharedPoolDataSource sharedpooldatasource = (SharedPoolDataSource)iterator.next();
            if(sharedpooldatasource != null)
                try
                {
                    sharedpooldatasource.close();
                }
                catch(Exception exception)
                {
                    ARE.getLog().warn(exception.getMessage());
                }
        } while(true);
        dataSources.clear();
    }

    public String[] getInstanceList()
    {
        return (String[])dataSources.keySet().toArray(new String[0]);
    }

    public String getServiceProvider()
    {
        return "Amarsoft";
    }

    public String getServiceDescribe()
    {
        return "Amarsoft\u6570\u636E\u5E93\u8FDE\u63A5\u6C60";
    }

    public String getServiceVersion()
    {
        return "1.0";
    }

    public void initConnectionFactory()
        throws Exception
    {
        String s = getResourceFile();
        java.io.File file = FileTool.findFile(s);
        if(file == null)
            throw new SQLException("com.amarsoft.sql.PooledConnectionFactory: Configure File '" + s + "' not exists");
        Document document;
        try
        {
            document = new Document(file);
        }
        catch(Exception exception)
        {
            throw new SQLException("com.amarsoft.sql.PooledConnectionFactory: new XDocument error--" + exception.getMessage());
        }
        Object obj = null;
        Object obj1 = null;
        boolean flag = false;
        Element element2 = document.getRootElement().getChild("resources");
        if(element2 == null)
            throw new SQLException("com.amarsoft.sql.PooledConnectionFactory: resource file format error--no resources defined");
        List list = element2.getChildren("resource");
        Iterator iterator = list.iterator();
        do
        {
            if(!iterator.hasNext())
                break;
            Element element = (Element)iterator.next();
            if(element.getAttributeValue("type").equals("jdbc"))
            {
                boolean flag1 = Boolean.valueOf(element.getAttributeValue("encrypt", "false")).booleanValue();
                Properties properties = new Properties();
                List list1 = element.getChildren();
                Iterator iterator1 = list1.iterator();
                String s1 = element.getAttributeValue("name", null);
                if(s1 == null)
                {
                    Element element3 = element.getChild("name");
                    if(element3 != null)
                        s1 = element3.getTextTrim();
                }
                String s2;
                String s3;
                for(; iterator1.hasNext(); properties.setProperty(s2, s3))
                {
                    Element element1 = (Element)iterator1.next();
                    s2 = element1.getName();
                    s3 = element1.getTextTrim();
                    if(flag1 && (s2.equals("driver") || s2.equals("url") || s2.equals("user") || s2.equals("password")))
                        s3 = DESEncrypt.decrypt(s3);
                }

                try
                {
                    if(element.getAttributeValue("jndiName", null) != null && ARE.getRunMode() == 1)
                    {
                        String s4 = element.getAttributeValue("jndiName");
                        InitialContext initialcontext = new InitialContext();
                        DataSource datasource = (DataSource)initialcontext.lookup(s4);
                        dataSources.put(s1, datasource);
                    } else
                    {
                        addDataSource(s1, properties);
                    }
                }
                catch(ClassNotFoundException classnotfoundexception)
                {
                    throw new SQLException("com.amarsoft.sql.PooledConnectionFactory: Driver class not found--" + classnotfoundexception.getMessage());
                }
                catch(NamingException namingexception)
                {
                    throw new SQLException("com.amarsoft.sql.PooledConnectionFactory: JNDI Name not found--" + namingexception.getMessage());
                }
            }
        } while(true);
    }

    public final String getResourceFile()
    {
        return resourceFile;
    }

    public final void setResourceFile(String s)
    {
        resourceFile = s;
    }

    private static Map dataSources = null;
    private final String version = "1.0";
    private final String provider = "Amarsoft";
    private final String describe = "Amarsoft\u6570\u636E\u5E93\u8FDE\u63A5\u6C60";
    private String resourceFile;

}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\are-0.2.jar
	Total time: 225 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/