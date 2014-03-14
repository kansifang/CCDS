package com.lmt.frameapp;

import com.lmt.frameapp.io.FileTool;
import com.lmt.frameapp.lang.StringX;
import com.lmt.frameapp.log.Log;
import com.lmt.frameapp.log.LogFactory;
import com.lmt.frameapp.metadata.DataSourceMetaData;
import com.lmt.frameapp.metadata.MetaDataFactory;
import com.lmt.frameapp.sql.DBConnectionFactory;
import com.lmt.app.util.xml.Document;
import com.lmt.app.util.xml.Element;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.PrintStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class ARE
{
  public static final int RUN_MODE_STANDALONE = 0;
  public static final int RUN_MODE_WEBCONTAINER = 1;
  public static final int RUN_MODE_EJBCONTAINER = 3;
  private static int runMode = 0;
  private static Pattern varPattern = Pattern.compile("\\{\\$(?:(ARE)|(?:SYSTEM))\\.([^\\{\\}][^\\}]*)\\}");
  private static LinkedHashMap services = new LinkedHashMap();
  private static Properties systemProperties = new Properties();
  private static String version = "0.2";
  private static String configureFile = "are.xml";
  private static boolean initialized = false;
  private static Log log = null;

  public static Connection getDBConnection(String paramString)
    throws SQLException
  {
    return DBConnectionFactory.getConnection(paramString);
  }

  public static DataSourceMetaData getMetaData(String paramString)
    throws SQLException
  {
    return MetaDataFactory.getMetaData(paramString);
  }

  public static Log getLog()
  {
    if (log == null)
      log = LogFactory.getLog("com.amarsoft.are.ARE");
    return log;
  }

  public static Log getLog(String paramString)
  {
    return LogFactory.getLog(paramString);
  }

  public static String getProperty(String paramString)
  {
    return systemProperties.getProperty(paramString);
  }

  public static void setProperty(String paramString1, String paramString2)
  {
    if (paramString2 != null)
      systemProperties.setProperty(paramString1, replaceARETags(paramString2));
    else
      systemProperties.setProperty(paramString1, paramString2);
  }

  public static void init()
  {
    String[] arrayOfString = { "are.xml", "etc/are.xml" };
    int i = 0;
    for (i = 0; i < arrayOfString.length; i++)
    {
      File localFile = new File(arrayOfString[i]);
      if (localFile.exists())
        break;
    }
    if (i < arrayOfString.length)
      init(arrayOfString[i]);
  }

  public static synchronized void init(String paramString)
  {
    if (initialized)
    {
      System.out.println("ARE has initialized,can't do it again!");
      return;
    }
    File localFile = FileTool.findFile(paramString);
    if (localFile == null)
    {
      System.out.println("'" + paramString + "' not exists!");
      System.out.println("Amarsoft Runtime Environment (ARE " + version + ") initializing failed!");
      System.out.println("Application run in an unexpected environment!");
      return;
    }
    init(localFile);
  }

  public static synchronized void init(File paramFile)
  {
    if (initialized)
    {
      System.out.println("ARE has initialized,can't do it again!");
      return;
    }
    if (paramFile == null)
    {
      System.out.println("ARE configure file not exists!");
      System.out.println("Amarsoft Runtime Environment (ARE " + version + ") initializing failed!");
      System.out.println("Application run in an unexpected environment!");
      return;
    }
    try
    {
      init(new FileInputStream(paramFile));
    }
    catch (FileNotFoundException localFileNotFoundException)
    {
      System.out.println("ARE configure file not exists!");
      System.out.println("Amarsoft Runtime Environment (ARE " + version + ") initializing failed!");
      System.out.println("Application run in an unexpected environment!");
      localFileNotFoundException.printStackTrace();
    }
  }

  public static synchronized void init(InputStream paramInputStream)
  {
    if (initialized)
    {
      System.out.println("ARE has initialized,can't do it again!");
      return;
    }
    if (paramInputStream == null)
    {
      System.out.println("ARE configure InputStream is null!");
      System.out.println("Amarsoft Runtime Environment (ARE " + version + ") initializing failed!");
      System.out.println("Application run in an unexpected environment!");
      return;
    }
    try
    {
      Document localDocument = new Document(paramInputStream);
      init(localDocument);
    }
    catch (Exception localException)
    {
      localException.printStackTrace(System.out);
      System.out.println("Parse ARE configure file failed!");
      System.out.println("Amarsoft Runtime Environment (ARE " + version + ") initializing failed!");
      System.out.println("Application run in an unexpected environment!");
      return;
    }
  }

  private static synchronized void init(Document paramDocument)
  {
    Element localElement1 = paramDocument.getRootElement();
    Element localElement2 = localElement1.getChild("SystemProperties");
    loadSystemProperties(localElement2);
    localElement2 = localElement1.getChild("AREServices");
    registerServices(localElement2);
    initStartOnService();
    System.out.println("Amarsoft Runtime Environment (ARE " + version + ") initializing complete!");
    initialized = true;
  }

  public static synchronized boolean isInitOk()
  {
    return initialized;
  }

  private static void loadSystemProperties(Element paramElement)
  {
    System.out.println("Loading system properties......");
    if (paramElement == null)
    {
      System.out.println("No SystemProperties Element Define!");
      return;
    }
    List localList = paramElement.getChildren("Property");
    Element localElement = null;
    String str1 = null;
    String str2 = null;
    for (int i = 0; i < localList.size(); i++)
    {
      localElement = (Element)localList.get(i);
      str1 = localElement.getAttributeValue("name");
      if ((str1 == null) || (str1.equals("")))
        continue;
      str2 = localElement.getAttributeValue("value", "");
      setProperty(str1, str2);
      System.setProperty(str1, getProperty(str1));
    }
    System.out.println("System properties loaded.");
  }

  private static void registerServices(Element paramElement)
  {
    Iterator localIterator1 = paramElement.getChildren("Service").iterator();
    System.out.println("Register ARE services......");
    while (localIterator1.hasNext())
    {
      Element localElement1 = (Element)localIterator1.next();
      String str1 = localElement1.getAttributeValue("id");
      if ((str1 == null) || (str1.equals("")))
      {
        System.out.println("--Ingnore a service with null SID!");
        continue;
      }
      String str2 = localElement1.getAttributeValue("enabled");
      if (str2 == null)
        str2 = "true";
      if (!StringX.parseBoolean(str2))
      {
        System.out.println("--Ingnore disabled service " + str1 + "!");
        continue;
      }
      ContextServiceStub localContextServiceStub = new ContextServiceStub(str1);
      String str3 = localElement1.getAttributeValue("initOnStart");
      localContextServiceStub.initOnStart = StringX.parseBoolean(str3);
      localContextServiceStub.serviceClass = localElement1.getChildTextTrim("ServiceClass");
      if (localContextServiceStub.serviceClass == null)
      {
        System.out.println("--Ingnore service " + str1 + ", because service class is null!");
        continue;
      }
      Element localElement2 = localElement1.getChild("Properties");
      if (localElement2 != null)
      {
        Iterator localIterator2 = localElement2.getChildren("Property").iterator();
        while (localIterator2.hasNext())
        {
          Element localElement3 = (Element)localIterator2.next();
          String str4 = localElement3.getAttributeValue("name");
          String str5 = localElement3.getAttributeValue("value");
          if (str5 != null)
            str5 = replaceEnvVar(replaceComment(str5));
          localContextServiceStub.properties.setProperty(str4, str5);
        }
      }
      services.put(localContextServiceStub.id, localContextServiceStub);
      System.out.println("--Service " + str1 + " registered!");
    }
    System.out.println("Register ARE services complete!");
  }

  private static void initStartOnService()
  {
    System.out.println("Initialize start on services......");
    ContextServiceStub localContextServiceStub = null;
    Iterator localIterator = services.values().iterator();
    while (localIterator.hasNext())
    {
      localContextServiceStub = (ContextServiceStub)localIterator.next();
      if (!localContextServiceStub.isInitOnStart())
        continue;
      try
      {
        localContextServiceStub.loadService();
        localContextServiceStub.initService();
        System.out.println("--Service " + localContextServiceStub.getId() + " initialized!");
      }
      catch (ContextException localAREException)
      {
        getLog().debug(localAREException);
        System.out.println("--Service " + localContextServiceStub.getId() + " initialize failed!");
      }
    }
  }

  public static String getConfigureFile()
  {
    return configureFile;
  }

  public static ContextServiceStub getServiceStub(String paramString)
  {
    ContextServiceStub localContextServiceStub = (ContextServiceStub)services.get(paramString);
    return localContextServiceStub;
  }

  public static int getProperty(String paramString, int paramInt)
  {
    int i = paramInt;
    String str = systemProperties.getProperty(paramString);
    if (str != null)
      try
      {
        i = Integer.parseInt(str);
      }
      catch (Exception localException)
      {
        i = paramInt;
      }
    return i;
  }

  public static double getProperty(String paramString, double paramDouble)
  {
    double d = paramDouble;
    String str = systemProperties.getProperty(paramString);
    if (str != null)
      try
      {
        d = Double.parseDouble(str);
      }
      catch (Exception localException)
      {
        d = paramDouble;
      }
    return d;
  }

  public static boolean getProperty(String paramString, boolean paramBoolean)
  {
    boolean bool = paramBoolean;
    String str = systemProperties.getProperty(paramString);
    if (str != null)
      bool = (str.equalsIgnoreCase("true")) || (str.equalsIgnoreCase("t")) || (str.equalsIgnoreCase("yes")) || (str.equalsIgnoreCase("y")) || (str.equals("1"));
    return bool;
  }

  public static Date getProperty(String paramString, Date paramDate)
  {
    Date localDate = paramDate;
    String str1 = systemProperties.getProperty(paramString);
    if (str1 != null)
    {
      if (str1.indexOf('/') > 0)
        str1 = str1.replaceAll("/", "");
      else if (str1.indexOf('-') > 0)
        str1 = str1.replaceAll("-", "");
      String str2 = "yyyyMMdd";
      if (str1.length() == 6)
        str2 = "yyMMdd";
      try
      {
        localDate = new SimpleDateFormat(str2).parse(str1);
      }
      catch (ParseException localParseException)
      {
        localDate = paramDate;
      }
    }
    return localDate;
  }

  public static Date getProperty(String paramString1, Date paramDate, String paramString2)
  {
    Date localDate = paramDate;
    String str = systemProperties.getProperty(paramString1);
    if (str != null)
    {
      SimpleDateFormat localSimpleDateFormat = new SimpleDateFormat(paramString2);
      try
      {
        localDate = localSimpleDateFormat.parse(str);
      }
      catch (Exception localException)
      {
        localDate = paramDate;
      }
    }
    return localDate;
  }

  public static String getProperty(String paramString1, String paramString2)
  {
    return systemProperties.getProperty(paramString1, paramString2);
  }

  public static String replaceEnvVar(String paramString)
  {
    return replaceVar(paramString);
  }

  private static String replaceVar(String paramString)
  {
    Matcher localMatcher = null;
    StringBuffer localStringBuffer = new StringBuffer();
    localMatcher = varPattern.matcher(paramString);
    while (localMatcher.find())
    {
      String str = null;
      if (localMatcher.group(1) == null)
        str = System.getProperty(localMatcher.group(2));
      else
        str = getProperty(localMatcher.group(2));
      if (str == null)
        str = "";
      localMatcher.appendReplacement(localStringBuffer, str);
    }
    localMatcher.appendTail(localStringBuffer);
    return localStringBuffer.toString();
  }

  public static String replaceComment(String paramString)
  {
    String str = "\\{#[^\\}]*\\}";
    return paramString.replaceAll(str, "");
  }

  public static String replaceARETags(String paramString)
  {
    return replaceEnvVar(replaceComment(paramString));
  }

  public static int getRunMode()
  {
    return runMode;
  }

  public static void setRunMode(int paramInt)
  {
    if ((paramInt != 0) && (paramInt != 1) && (paramInt != 3))
    {
      System.out.println("Invalid run mode: " + paramInt);
      return;
    }
    runMode = paramInt;
  }

  public static void main(String[] paramArrayOfString)
  {
    System.out.println("Amarsoft Runtime Environment, Version " + version);
    System.out.println("(C)Copyright, 2006 Amarsoft Technology Co., Ltd.");
  }
}