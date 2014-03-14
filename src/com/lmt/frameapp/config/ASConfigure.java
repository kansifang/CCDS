package com.lmt.frameapp.config;

import java.io.InputStream;
import java.io.Serializable;

import javax.servlet.ServletContext;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.lmt.app.util.xml.XmlDocument;
import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.config.dal.ASConfigLoaderFactory;
import com.lmt.frameapp.sql.Transaction;

public class ASConfigure
  implements Serializable
{
  private static final long serialVersionUID = 1L;
  private static ASConfigure asc = null;
  private static XmlDocument xmlConfigure = null;
  private static ASValuePool vpConfigure = new ASValuePool();
  private static String sWebRootPath = null;
  public static String sCurSlash = System.getProperty("file.separator");
  private static String sXMLFile = "/WEB-INF/amarsoft.xml";
  private static ASValuePool vpSysConfig = new ASValuePool();
  public static final String SYSCONFIG_ROLE = "ASRoleSet";
  public static final String SYSCONFIG_COMP = "ASCompSet";
  public static final String SYSCONFIG_PAGE = "ASPageSet";
  public static final String SYSCONFIG_FUNC = "ASFuncSet";
  public static final String SYSCONFIG_PREF = "ASPrefSet";
  public static final String SYSCONFIG_CODE = "ASCodeSet";

  private ASConfigure(ServletContext paramServletContext)
    throws Exception
  {
    init(paramServletContext);
  }

  public static synchronized ASConfigure getASConfigure()
  {
    if (asc == null)
      ARE.getLog().info("amarsoft.xml没有载入！初始化未完成！请检查配置InitDataServlet配置");
    return asc;
  }

  public static synchronized ASConfigure getASConfigure(ServletContext paramServletContext)
    throws Exception
  {
    if (asc == null)
      asc = new ASConfigure(paramServletContext);
    return asc;
  }

  public void setWebRootPath(String paramString)
  {
    sWebRootPath = paramString;
    ARE.getLog().info("Set WebRootPath   = [" + sWebRootPath + "]");
  }

  public String getWebRootPath()
  {
    return sWebRootPath;
  }

  private static synchronized void init(ServletContext paramServletContext)
    throws Exception
  {
    synchronized (vpConfigure)
    {
      ARE.getLog().info("ServerInfo    = [" + paramServletContext.getServerInfo() + "]");
      ARE.getLog().info("WebAppVersion = [" + paramServletContext.getMajorVersion() + "." + paramServletContext.getMinorVersion() + "]");
      ARE.getLog().info("WebRootPath   = [" + paramServletContext.getServletContextName() + "]");
      ARE.getLog().info("WebRealPath   = [" + paramServletContext.getRealPath("") + "]");
      sWebRootPath = "/" + paramServletContext.getServletContextName();
      InputStream localInputStream = null;
      try
      {
        ARE.getLog().info("XMLFile       = [" + getXMLFile() + "]");
        localInputStream = paramServletContext.getResourceAsStream(sXMLFile);
      }
      catch (Exception localException)
      {
        localException.printStackTrace();
        throw new Exception("读取配置文件时失败！");
      }
      if (xmlConfigure == null)
        xmlConfigure = new XmlDocument(localInputStream);
      initXml(xmlConfigure);
    }
  }

  private static synchronized void initXml(XmlDocument paramXmlDocument)
  {
    try
    {
      synchronized (vpConfigure)
      {
        NodeList localNodeList = paramXmlDocument.getRootNode().getChildNodes();
        Node localNode = null;
        String str1 = null;
        String str2 = null;
        for (int i = 0; i < localNodeList.getLength(); i++){
          localNode = localNodeList.item(i);
          str1 = localNode.getNodeName();
          if ("#text".equals(str1))
            continue;
          try
          {
            str2 = localNode.getChildNodes().item(0).getNodeValue();
          }
          catch (NullPointerException localNullPointerException)
          {
            str2 = null;
          }
          if (str2 == null)
            continue;
          ARE.getLog().info("* XML[" + i + "] " + str1 + " = [" + str2 + "]");
          vpConfigure.setAttribute(str1, str2);
        }
      }
    }
    catch (Exception localException)
    {
      ARE.getLog().info("系统构造配置文件时失败！" + localException);
      localException.printStackTrace();
    }
  }

  public synchronized String getConfigure(String paramString)
    throws Exception
  {
    if (xmlConfigure == null)
      new Exception("读取系统配置缓存参数出错！");
    String str = (String)vpConfigure.getAttribute(paramString);
    if ((str != null) && (str.equals("/")))
      str = "";
    return str;
  }

  public static ASValuePool getSysConfig(String paramString, Transaction paramTransaction)
    throws Exception
  {
    Object localObject = vpSysConfig.getAttribute(paramString);
    if (localObject == null)
      return ASConfigLoaderFactory.getInstance().createLoader(paramString).loadConfig(paramTransaction);
    return (ASValuePool)localObject;
  }

  public static Object getSysConfig(String paramString)
    throws Exception
  {
    return vpSysConfig.getAttribute(paramString);
  }

  public static void setSysConfig(String paramString, Object paramObject)
    throws Exception
  {
    vpSysConfig.setAttribute(paramString, paramObject);
  }

  public static synchronized void clearXDoc(ServletContext paramServletContext)
  {
    synchronized (vpConfigure)
    {
      try
      {
        ARE.getLog().info("clearXDoc Is Start!");
        vpConfigure.resetPool();
        xmlConfigure = null;
        init(paramServletContext);
      }
      catch (Exception localException)
      {
        ARE.getLog().info("Reset SysConfigure is Error:" + localException.toString());
      }
    }
  }

  public static void reloadAllConfig(Transaction paramTransaction)
    throws Exception
  {
    ASConfigLoaderFactory.getInstance().createLoader("ASCodeSet").loadConfig(paramTransaction);
    ARE.getLog().info("Init Cache Data[SYSCONFIG_CODE] .......... Success!" + StringFunction.getNow());
    ASConfigLoaderFactory.getInstance().createLoader("ASCompSet").loadConfig(paramTransaction);
    ARE.getLog().info("Init Cache Data[SYSCONFIG_COMP] .......... Success!" + StringFunction.getNow());
    ASConfigLoaderFactory.getInstance().createLoader("ASFuncSet").loadConfig(paramTransaction);
    ARE.getLog().info("Init Cache Data[SYSCONFIG_FUNC] .......... Success!" + StringFunction.getNow());
    ASConfigLoaderFactory.getInstance().createLoader("ASRoleSet").loadConfig(paramTransaction);
    ARE.getLog().info("Init Cache Data[SYSCONFIG_ROLE] .......... Success!" + StringFunction.getNow());
    ASConfigLoaderFactory.getInstance().createLoader("ASPrefSet").loadConfig(paramTransaction);
    ARE.getLog().info("Init Cache Data[SYSCONFIG_PREF] .......... Success!" + StringFunction.getNow());
  }

  public static void reloadConfig(String paramString, Transaction paramTransaction)
    throws Exception
  {
    ARE.getLog().info("Init Cache Data[" + paramString + "] .......... Begin!" + StringFunction.getNow());
    ASConfigLoaderFactory.getInstance().createLoader(paramString).loadConfig(paramTransaction);
    ARE.getLog().info("Init Cache Data[" + paramString + "] .......... Success!" + StringFunction.getNow());
  }

  public static String getXMLFile()
  {
    return sXMLFile;
  }

  public static void setXMLFile(String paramString)
  {
    sXMLFile = paramString;
  }
}