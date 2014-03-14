package com.lmt.app.cms.explain;

import java.util.StringTokenizer;
import java.util.Vector;

import com.lmt.app.cms.javainvoke.BizletExecutor;
import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ASException;
import com.lmt.frameapp.script.Any;
import com.lmt.frameapp.script.ClassException;
import com.lmt.frameapp.script.Expression;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class ASMethod
{
  public Transaction Sqlca;
  public String Class;
  public String Name;
  public String Type;
  public String Describe;
  public String ReturnType;
  public String Args;
  public String Code;
  public ASValuePool context = new ASValuePool();
  public ASValuePool parameters = new ASValuePool();

  public ASMethod(String sClass, String sName, Transaction transSql) throws Exception
  {
    this.Sqlca = transSql;
    init(sClass, sName);
  }

  public void init(String sClass, String sName) throws Exception
  {
    String sSql = "select * from CLASS_METHOD where ClassName = '" + sClass + "' and MethodName = '" + sName + "'";
    ASResultSet rsMethod = this.Sqlca.getResultSet(sSql);

    if (rsMethod.next())
    {
      this.Class = sClass;
      this.Name = sName;
      this.Describe = rsMethod.getString("MethodDescribe");
      this.Type = rsMethod.getString("MethodType");
      this.ReturnType = rsMethod.getString("ReturnType");
      this.Args = rsMethod.getString("MethodArgs");
      this.Code = rsMethod.getString("MethodCode");
      if (this.Args == null) this.Args = "";
      if (this.Code == null) this.Code = ""; 
    }
    else
    {
      throw new ClassException("ASMethod:" + sClass + "." + sName + "方法不存在!");
    }
    rsMethod.getStatement().close();
  }

  public void addContextObject(String sKey, Object oTemp) throws Exception
  {
    this.context.setAttribute(sKey, oTemp);
  }

  public Any execute(String sArgsValue)
    throws Exception
  {
    Any anyResult = null;

    int iPosBegin = 0; int iPosEnd = 0; int iPosEnd1 = 0; int iPosEnd2 = 0;

    StringTokenizer stArgs = new StringTokenizer(this.Args.trim(), ", ");

    String sCode = this.Code.trim();
    try
    {
      while ((stArgs.hasMoreTokens()) && (iPosEnd >= 0))
      {
        String sArgType = stArgs.nextToken();
        String sArgName = stArgs.nextToken();
        if ((sArgType == null) || (sArgName == null)) 
        	throw new Exception("ASMethod参数定义错误:" + this.Args);
        sArgType = sArgType.trim();
        sArgName = sArgName.trim();

        iPosEnd1 = StringFunction.indexOf(sArgsValue, ",", "'", "'", iPosBegin);
        iPosEnd2 = StringFunction.indexOf(sArgsValue, ",", "[", "]", iPosBegin);

        if (iPosEnd1 >= iPosEnd2) 
        	iPosEnd = iPosEnd1; 
        else
          iPosEnd = iPosEnd2;
        if ((iPosEnd1 < 0) || (iPosEnd2 < 0)) 
        	iPosEnd = -1;
        String sArgValue;
        if (iPosEnd >= 0) sArgValue = sArgsValue.substring(iPosBegin, iPosEnd); 
        else {
          sArgValue = sArgsValue.substring(iPosBegin);
        }
        if ((sArgValue.length() >= 2) && (sArgValue.substring(0, 1).equals("[")) && (sArgValue.substring(sArgValue.length() - 1).equals("]"))) {
          sArgValue = sArgValue.substring(1, sArgValue.length() - 1);
        }
        iPosBegin = iPosEnd + 1;

        if (!sArgType.equals("String"))
        {
          if (sArgType.equals("Number"))
          {
            if ((sArgValue.substring(0, 1).equals("'")) || (sArgValue.substring(0, 1).equals(String.valueOf('"'))))
            {
              sArgValue = sArgValue.substring(1, sArgValue.length() - 1);
            }
          }
          else if (!sArgType.equals("Date"))
          {
            if (!sArgType.equals("ASObject"));
          }
        }
        if (sArgType.equals("ASObject"))
        {
          Object oTmp = this.context.getAttribute(sArgValue);
          this.parameters.setAttribute(sArgName, oTmp);
          continue;
        }
        sCode = StringFunction.replace(sCode, "#" + sArgName, sArgValue);
        this.parameters.setAttribute(sArgName, sArgValue);
      }

      if (this.Type.equalsIgnoreCase("Sql"))
      {
        try {
          sCode = Expression.pretreatMethod(sCode, this.Sqlca);
        } catch (Exception ex) {
          throw new ASException("预处理方法时出错。错误：" + ex.getMessage());
        }
        anyResult = new Any("Null", "");
        Vector vTemp = new Vector();

        if ((sCode.substring(0, 6).equalsIgnoreCase("update")) || (sCode.substring(0, 6).equalsIgnoreCase("insert")) || (sCode.substring(0, 6).equalsIgnoreCase("delete")) || (StringFunction.replace(sCode, " ", "").substring(0, 5).equalsIgnoreCase("{call")))
        {
          int i = 0;
          try {
            i = this.Sqlca.executeSQL(sCode);
          } catch (Exception ex) {
            throw new ASException("执行类型为SQL（Update）的ASMethod出错。错误：" + ex.getMessage());
          }
          anyResult = new Any("Number", String.valueOf(i));
        }
        else
        {
          ASResultSet rsResult = null;
          try {
            rsResult = this.Sqlca.getASResultSet(sCode);
          } catch (Exception ex) {
            throw new ASException("执行类型为SQL(select)的ASMethod时发生错误。错误：" + ex.getMessage());
          }

          if (this.ReturnType.indexOf("[]") == -1)
          {
            if (rsResult.next()) {
              String sTmpResult = null;
              try {
                sTmpResult = rsResult.getStringValue(1);
              } catch (Exception ex) {
                throw new ASException("从结果集取值错误。" + ex.getMessage());
              }

              try
              {
                anyResult = new Any(this.ReturnType, sTmpResult);
              } catch (Exception ex) {
                throw new ASException("类型转换时发生错误，目标类型：" + this.ReturnType + " 返回值：" + sTmpResult + " 错误信息：" + ex.getMessage());
              }

            }

          }
          else
          {
            String sValueType = StringFunction.replace(this.ReturnType, "[]", "");

            while (rsResult.next())
            {
              String sTmpResult = rsResult.getStringValue(1);
              try {
                anyResult = new Any(sValueType, sTmpResult);
              } catch (Exception ex) {
                throw new ASException("类型转换时发生错误，目标类型：" + this.ReturnType + " 返回值：" + sTmpResult + " 错误信息：" + ex.getMessage());
              }
              vTemp.addElement(anyResult);
            }

            if (vTemp.size() > 0) anyResult = new Any(this.ReturnType, vTemp);
          }
          rsResult.getStatement().close();
        }
      } else if (this.Type.equalsIgnoreCase("Expression"))
      {
        try {
          anyResult = Expression.getExpressionValue(sCode, this.Sqlca);
        } catch (Exception ex) {
          throw new ASException("解释执行表达式时出错。表达式：" + sCode + " 错误：" + ex.getMessage());
        }
      }
      else if (this.Type.equalsIgnoreCase("Bizlet"))
      {
        BizletExecutor executor = new BizletExecutor();
        Object oTemp = null;
        try {
          oTemp = executor.execute(this.Sqlca, sCode, this.parameters);
        } catch (Exception ex) {
          throw new ASException("执行Bizlet时出错。Bizlet：" + sCode + ex.getMessage());
        }
        try
        {
          if (this.ReturnType.indexOf("[]") >= 0)
            anyResult = new Any(this.ReturnType, (Vector)oTemp);
          else
            anyResult = new Any(this.ReturnType, (String)oTemp);
        }
        catch (Exception ex)
        {
          String sReturnedType;
          if (oTemp != null)
            sReturnedType = oTemp.getClass().getName();
          else
            sReturnedType = "null";
          throw new ASException("Bizlet返回值类型错误。目标类型：" + this.ReturnType + "，返回的类型：" + sReturnedType + " 错误:" + ex.getMessage());
        }
      }
      return anyResult; 
     } catch (Exception ex) {
    	  throw new ASException("执行script时出错。script：" + sCode + ex.getMessage());
    }
  }

  public static Any executeMethod(String sMethod, Transaction Sqlca)
    throws Exception
  {
    Any anyValue = null;

    int iDot = sMethod.indexOf(".", 0);
    int iArgsBegin = sMethod.indexOf("(", 0);
    int iArgsEnd = StringFunction.indexOf(sMethod, ")", "'", "'", 0);

    if ((iArgsEnd > iArgsBegin) && (iArgsBegin > iDot) && (iDot >= 0))
    {
      String sClassName = sMethod.substring(1, iDot).trim();
      String sMethodName = sMethod.substring(iDot + 1, iArgsBegin).trim();
      String sArgsValue = sMethod.substring(iArgsBegin + 1, iArgsEnd).trim();

      ASMethod asm = new ASMethod(sClassName, sMethodName, Sqlca);

      if (sArgsValue == null) sArgsValue = "";
      anyValue = asm.execute(sArgsValue);
    }

    return anyValue;
  }
}