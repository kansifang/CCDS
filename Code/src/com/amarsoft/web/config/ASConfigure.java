// Decompiled by DJ v2.9.9.60 Copyright 2000 Atanas Neshkov  Date: 2009-9-10 ÏÂÎç 04:40:13
// Home Page : http://members.fortunecity.com/neshkov/dj.html  - Check often for new version!
// Decompiler options: packimports(3) 

package com.amarsoft.web.config;

import com.amarsoft.are.ARE;
import com.amarsoft.are.log.Log;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.web.config.loader.ASConfigLoaderFactory;
import com.amarsoft.web.config.loader.IConfigLoader;
import java.io.Serializable;
import javax.servlet.ServletContext;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

// Referenced classes of package com.amarsoft.web.config:
//            XmlDocument

public class ASConfigure
    implements Serializable
{

    private ASConfigure(ServletContext servletcontext)
        throws Exception
    {
        init(servletcontext);
    }

    public static synchronized ASConfigure getASConfigure()
    {
        if(asc == null)
            ARE.getLog().info("amarsoft.xml\u6CA1\u6709\u8F7D\u5165\uFF01\u521D\u59CB\u5316\u672A\u5B8C\u6210\uFF01\u8BF7\u68C0\u67E5\u914D\u7F6EInitDataServlet\u914D\u7F6E");
        return asc;
    }

    public static synchronized ASConfigure getASConfigure(ServletContext servletcontext)
        throws Exception
    {
        if(asc == null)
            asc = new ASConfigure(servletcontext);
        return asc;
    }

    public void setWebRootPath(String s)
    {
        sWebRootPath = s;
        ARE.getLog().info("Set WebRootPath   = [" + sWebRootPath + "]");
    }

    public String getWebRootPath()
    {
        return sWebRootPath;
    }

    private static synchronized void init(ServletContext servletcontext)
        throws Exception
    {
        synchronized(vpConfigure)
        {
            ARE.getLog().info("ServerInfo    = [" + servletcontext.getServerInfo() + "]");
            ARE.getLog().info("WebAppVersion = [" + servletcontext.getMajorVersion() + "." + servletcontext.getMinorVersion() + "]");
            ARE.getLog().info("WebRootPath   = [" + servletcontext.getServletContextName() + "]");
            ARE.getLog().info("WebRealPath   = [" + servletcontext.getRealPath("") + "]");
            sWebRootPath = "/" + servletcontext.getServletContextName();
            java.io.InputStream inputstream = null;
            try
            {
                ARE.getLog().info("XMLFile       = [" + getXMLFile() + "]");
                inputstream = servletcontext.getResourceAsStream(sXMLFile);
            }
            catch(Exception exception)
            {
                exception.printStackTrace();
                throw new Exception("\u8BFB\u53D6\u914D\u7F6E\u6587\u4EF6\u65F6\u5931\u8D25\uFF01");
            }
            if(xmlConfigure == null)
                xmlConfigure = new XmlDocument(inputstream);
            initXml(xmlConfigure);
        }
    }

    private static synchronized void initXml(XmlDocument xmldocument)
    {
        try
        {
            synchronized(vpConfigure)
            {
                NodeList nodelist = xmldocument.getRootNode().getChildNodes();
                Object obj = null;
                Object obj1 = null;
                Object obj2 = null;
                for(int i = 0; i < nodelist.getLength(); i++)
                {
                    Node node = nodelist.item(i);
                    String s = node.getNodeName();
                    if("#text".equals(s))
                        continue;
                    String s1;
                    try
                    {
                        s1 = node.getChildNodes().item(0).getNodeValue();
                    }
                    catch(NullPointerException nullpointerexception)
                    {
                        s1 = null;
                    }
                    if(s1 != null)
                    {
                        ARE.getLog().info("* XML[" + i + "] " + s + " = [" + s1 + "]");
                        vpConfigure.setAttribute(s, s1);
                    }
                }

            }
        }
        catch(Exception exception)
        {
            ARE.getLog().info("\u7CFB\u7EDF\u6784\u9020\u914D\u7F6E\u6587\u4EF6\u65F6\u5931\u8D25\uFF01" + exception);
            exception.printStackTrace();
        }
    }

    public synchronized String getConfigure(String s)
        throws Exception
    {
        if(xmlConfigure == null)
            new Exception("\u8BFB\u53D6\u7CFB\u7EDF\u914D\u7F6E\u7F13\u5B58\u53C2\u6570\u51FA\u9519\uFF01");
        String s1 = (String)vpConfigure.getAttribute(s);
        if(s1 != null && s1.equals("/"))
            s1 = "";
        return s1;
    }

    public static ASValuePool getSysConfig(String s, Transaction transaction)
        throws Exception
    {
        Object obj = vpSysConfig.getAttribute(s);
        if(obj == null)
            return ASConfigLoaderFactory.getInstance().createLoader(s).loadConfig(transaction);
        else
            return (ASValuePool)obj;
    }

    public static Object getSysConfig(String s)
        throws Exception
    {
        return vpSysConfig.getAttribute(s);
    }

    public static void setSysConfig(String s, Object obj)
        throws Exception
    {
        vpSysConfig.setAttribute(s, obj);
    }

    public static synchronized void clearXDoc(ServletContext servletcontext)
    {
        synchronized(vpConfigure)
        {
            try
            {
                ARE.getLog().info("clearXDoc Is Start!");
                vpConfigure.resetPool();
                xmlConfigure = null;
                init(servletcontext);
            }
            catch(Exception exception)
            {
                ARE.getLog().info("Reset SysConfigure is Error:" + exception.toString());
            }
        }
    }

    public static void reloadAllConfig(Transaction transaction)
        throws Exception
    {
        ASConfigLoaderFactory.getInstance().createLoader("ASCodeSet").loadConfig(transaction);
        ARE.getLog().info("Init Cache Data[SYSCONFIG_CODE] .......... Success!" + StringFunction.getNow());
        ASConfigLoaderFactory.getInstance().createLoader("ASCompSet").loadConfig(transaction);
        ARE.getLog().info("Init Cache Data[SYSCONFIG_COMP] .......... Success!" + StringFunction.getNow());
        ASConfigLoaderFactory.getInstance().createLoader("ASFuncSet").loadConfig(transaction);
        ARE.getLog().info("Init Cache Data[SYSCONFIG_FUNC] .......... Success!" + StringFunction.getNow());
        ASConfigLoaderFactory.getInstance().createLoader("ASRoleSet").loadConfig(transaction);
        ARE.getLog().info("Init Cache Data[SYSCONFIG_ROLE] .......... Success!" + StringFunction.getNow());
        ASConfigLoaderFactory.getInstance().createLoader("ASPrefSet").loadConfig(transaction);
        ARE.getLog().info("Init Cache Data[SYSCONFIG_PREF] .......... Success!" + StringFunction.getNow());
    }

    public static void reloadConfig(String s, Transaction transaction)
        throws Exception
    {
        ARE.getLog().info("Init Cache Data[" + s + "] .......... Begin!" + StringFunction.getNow());
        ASConfigLoaderFactory.getInstance().createLoader(s).loadConfig(transaction);
        ARE.getLog().info("Init Cache Data[" + s + "] .......... Success!" + StringFunction.getNow());
    }

    public static String getXMLFile()
    {
        return sXMLFile;
    }

    public static void setXMLFile(String s)
    {
        sXMLFile = s;
    }

    private static final long serialVersionUID = 1L;
    private static ASConfigure asc = null;
    private static XmlDocument xmlConfigure = null;
    private static ASValuePool vpConfigure = new ASValuePool();
    private static String sWebRootPath = null;
    public static String sCurSlash = System.getProperty("file.separator");
    private static String sXMLFile = sCurSlash+"WEB-INF"+sCurSlash+"etc"+sCurSlash+"amarsoft.xml";
    private static ASValuePool vpSysConfig = new ASValuePool();
    public static final String SYSCONFIG_ROLE = "ASRoleSet";
    public static final String SYSCONFIG_COMP = "ASCompSet";
    public static final String SYSCONFIG_PAGE = "ASPageSet";
    public static final String SYSCONFIG_FUNC = "ASFuncSet";
    public static final String SYSCONFIG_PREF = "ASPrefSet";
    public static final String SYSCONFIG_CODE = "ASCodeSet";

}