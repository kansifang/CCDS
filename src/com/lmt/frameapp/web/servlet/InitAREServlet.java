package com.lmt.frameapp.web.servlet;

import java.io.InputStream;
import java.util.Iterator;
import java.util.Properties;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import com.lmt.frameapp.ARE;

public class InitAREServlet extends HttpServlet
  implements Servlet
{
  private static final long serialVersionUID = 1L;

  public void init()
    throws ServletException
  {
    super.init();

    System.out.println("");
    System.out.println("**********************************InitAREServlet Start*********************************");

    System.out.println("**============System  Property Begin==============================================**");
    Properties ps = System.getProperties();
    Iterator ir = ps.keySet().iterator();
    for (int i = 1; ir.hasNext(); i++) {
      String sKey = (String)ir.next();
      System.out.println("(" + i + ")" + sKey + " = [" + ps.getProperty(sKey) + "]");
    }
    System.out.println("**============System  Property End=================================================**");

    String sConfigFile = getInitParameter("ConfigFile");
    System.out.println("ConfigFile       = [" + sConfigFile + "]");
    String sAppHome = getInitParameter("AppHome");
    System.out.println("AppHome          = [" + sAppHome + "]");
    ARE.setProperty("RunInContainer", "true");
    if ((null == sAppHome) || ("".equals(sAppHome)) || (".".equals(sAppHome)) || ("/WEB-INF".equals(sAppHome))) {
      sAppHome = getServletContext().getRealPath("/WEB-INF");
      sAppHome = sAppHome.replace(System.getProperty("file.separator").charAt(0), '/');
    }
    ARE.setProperty("APP_HOME", sAppHome);
    System.out.println("Context.APP_HOME     = [" + ARE.getProperty("APP_HOME") + "]");
    InputStream in = getServletContext().getResourceAsStream(sConfigFile);
    ARE.init(in);
    if (ARE.isInitOk())
      ARE.getLog().info("**********************************InitAREServlet Success*********************************");
  }

  public void destroy()
  {
    super.destroy();
  }
}