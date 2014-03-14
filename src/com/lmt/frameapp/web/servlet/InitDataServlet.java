package com.lmt.frameapp.web.servlet;

import java.sql.DatabaseMetaData;
import java.util.Iterator;
import java.util.Properties;

import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.sql.DataSource;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.sql.ConnectionManager;
import com.lmt.frameapp.sql.Transaction;

public class InitDataServlet extends HttpServlet
  implements Servlet
{
  private static final long serialVersionUID = 1L;

  public void init()
    throws ServletException
  {
    super.init();

    ARE.getLog().info("**********************************InitDataServlet Start*********************************");
    try
    {
      ARE.getLog().info("**============System  Property Begin==============================================**");
      Properties ps = System.getProperties();
      Iterator ir = ps.keySet().iterator();
      for (int i = 1; ir.hasNext(); i++) {
        String sKey = (String)ir.next();
        ARE.getLog().info("(" + i + ")" + sKey + " = [" + ps.getProperty(sKey) + "]");
      }
      ARE.getLog().info("**============System  Property End=================================================**");

      Transaction Sqlca = null;
      try
      {
        String sConfigFile = getInitParameter("ConfigFile");
        if ((sConfigFile != null) && (!"".equals(sConfigFile))) {
          ASConfigure.setXMLFile(sConfigFile);
          ARE.getLog().info("ConfigFile       = [" + sConfigFile + "]");
        }

        ASConfigure asc = ASConfigure.getASConfigure(getServletContext());
        Sqlca = getSqlca(asc);
        ARE.getLog().info("**============DataBase And JDBC Property Begin=====================================**");
        DatabaseMetaData dbmd = Sqlca.conn.getMetaData();
        ARE.getLog().info("DatabaseName[" + dbmd.getDatabaseProductName() + "]  Version[" + dbmd.getDatabaseProductVersion() + "]");
        ARE.getLog().info("Driver Name[" + dbmd.getDriverName() + "]  Version[" + dbmd.getDriverVersion() + "]");
        ARE.getLog().info("JDBC MajorVersion[" + dbmd.getJDBCMajorVersion() + "] MinorVersion[" + dbmd.getJDBCMinorVersion() + "]");
        ARE.getLog().info("URL[" + dbmd.getURL() + "] UserName[" + dbmd.getUserName() + "]");
        ARE.getLog().info("DatabaseState IsAutoCommit[" + Sqlca.conn.getAutoCommit() + "] TransactionIsolation[" + Sqlca.conn.getTransactionIsolation() + "]");
        ARE.getLog().info("**============DataBase And JDBC Property End=======================================**");

        ARE.getLog().info("Init Cache Data[ALL]            .......... Starting" + StringFunction.getNow());
        ASConfigure.getSysConfig("ASCodeSet", Sqlca);
        ARE.getLog().info("Init Cache Data[SYSCONFIG_CODE] .......... Success!" + StringFunction.getNow());
        ASConfigure.getSysConfig("ASCompSet", Sqlca);
        ARE.getLog().info("Init Cache Data[SYSCONFIG_COMP] .......... Success!" + StringFunction.getNow());
        ASConfigure.getSysConfig("ASFuncSet", Sqlca);
        ARE.getLog().info("Init Cache Data[SYSCONFIG_FUNC] .......... Success!" + StringFunction.getNow());
        ASConfigure.getSysConfig("ASRoleSet", Sqlca);
        ARE.getLog().info("Init Cache Data[SYSCONFIG_ROLE] .......... Success!" + StringFunction.getNow());
        ARE.getLog().info("Init Cache Data[ALL]            .......... Success!" + StringFunction.getNow());
      }
      catch (Exception e) {
        ARE.getLog().info("InitDataServerlet :error", e);
        e.printStackTrace();
        throw new RuntimeException("构造系统配置时出错：" + e);
      } finally {
        try {
          if (Sqlca != null) {
            Sqlca.conn.commit();
            Sqlca.disConnect();
            Sqlca = null;
          }
        } catch (Exception e1) {
        }
      }
    } catch (Exception e) {
      ARE.getLog().info("InitDataServerlet :error", e);
      e.printStackTrace();
    }
    ARE.getLog().info("**********************************InitDataServlet Success*********************************");
    ARE.getLog().info("");
  }

  private Transaction getSqlca(ASConfigure asc) {
    DataSource ds = null;
    try
    {
      Transaction.iChange = Integer.valueOf(asc.getConfigure("DBChange")).intValue();
      ds = ConnectionManager.getDataSource(asc.getConfigure("DataSource"));
      Transaction Sqlca = ConnectionManager.getTransaction(ds);
      return Sqlca;
    } catch (Exception e) {
      ARE.getLog().info("InitDataServerlet :getSqlca():" + e.getMessage(), e);
    }
    return null;
  }

  public void destroy() {
    super.destroy();
  }
}