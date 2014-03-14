package com.lmt.app.cms.explain;

import java.util.StringTokenizer;
import java.util.Vector;

import com.lmt.app.cms.javainvoke.BizletExecutor;
import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ASException;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.script.AmarScript;
import com.lmt.frameapp.script.Anything;
import com.lmt.frameapp.script.ScriptObject;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class AmarMethod
{
  private Transaction Sqlca;
  private String Class;
  private String Name;
  private String Type;
  private String ReturnType;
  private String Code;
  private String[][] arguments;
  public ASValuePool context = null;
  public ASValuePool parameters = new ASValuePool();

  public AmarMethod(String sClass, String sName, ASValuePool vpContext, Transaction transSql) throws Exception
  {
    this.Sqlca = transSql;
    this.context = vpContext;
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
      this.Type = rsMethod.getString("MethodType");
      this.ReturnType = rsMethod.getString("ReturnType");
      String sArgs = rsMethod.getString("MethodArgs");
      this.Code = rsMethod.getString("MethodCode");
      if (sArgs == null) sArgs = "";
      if (this.Code == null) this.Code = "";

      if (!sArgs.equals(""))
      {
        StringTokenizer stArgs = new StringTokenizer(sArgs.trim(), ", ");
        int iCountTokens = stArgs.countTokens();
        if (iCountTokens % 2 != 0) throw new Exception("ASMethod�����������!");

        this.arguments = new String[iCountTokens / 2][5];

        for (int i = 0; i < this.arguments.length; i++)
        {
          this.arguments[i][0] = stArgs.nextToken();
          this.arguments[i][1] = stArgs.nextToken();
        }
      }
      else {
        String sArgSql = "select ARGTYPE,ARGNAME,OBJECTTYPE,ARGDESCRIBE,'' from METHOD_ARGS where ClassName='" + sClass + "' and MethodName='" + sName + "' order by SortNo";
        String[][] DBArguments;
        try
        {
          DBArguments = this.Sqlca.getStringMatrix(sArgSql);
        }
        catch (Exception ex)
        {
         
          throw new Exception("��ȡ���������������(METHOD_ARGS)��������Ϣ��" + ex.toString());
        }
        this.arguments = DBArguments;
      }
    }
    else {
      throw new AmarMethodException("ASMethod:" + sClass + "." + sName + "����������!");
    }
    rsMethod.getStatement().close();
  }

  public void addContextObject(String sKey, Object oTemp) throws Exception
  {
    this.context.setAttribute(sKey, oTemp);
  }

  public Anything execute(String sArgsValue)
    throws Exception
  {
    Anything anyResult = null;

    int iPosBegin = 0; int iPosEnd = 0; int iPosEnd1 = 0; int iPosEnd2 = 0;

    String sCode = this.Code.trim();
    try
    {
      for (int iCurArg = 0; (iCurArg < this.arguments.length) && (iPosEnd >= 0); iCurArg++)
      {
        String sArgType = this.arguments[iCurArg][0];

        String sArgName = this.arguments[iCurArg][1];

        if ((sArgType == null) || (sArgName == null)) throw new Exception("ASMethod�����������!");

        sArgType = sArgType.trim();
        sArgName = sArgName.trim();

        iPosEnd1 = StringFunction.indexOf(sArgsValue, ",", "'", "'", iPosBegin);
        iPosEnd2 = StringFunction.indexOf(sArgsValue, ",", "[", "]", iPosBegin);

        if (iPosEnd1 >= iPosEnd2) iPosEnd = iPosEnd1; else
          iPosEnd = iPosEnd2;
        if ((iPosEnd1 < 0) || (iPosEnd2 < 0)) iPosEnd = -1;
        String sArgValue;
        if (iPosEnd >= 0) sArgValue = sArgsValue.substring(iPosBegin, iPosEnd); else {
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
            if (!sArgType.equals("ScriptObject"));
          }

        }

        if (sArgType.equals("ScriptObject"))
        {
          if (sArgValue.charAt(0) == '#') 
        	  sArgValue = sArgValue.substring(1);
          Object oTmp = this.context.getAttribute(sArgValue);
          if (oTmp == null)
        	  throw new Exception("û�������������ҵ�script����[" + sArgValue + "]��ʵ����");
          this.parameters.setAttribute(sArgName, oTmp);
          ScriptObject boTmp = (ScriptObject)oTmp;
          sCode = AmarScript.pretreatObjectAttributes(sCode, sArgName, boTmp);
        } else {
          sCode = StringFunction.replace(sCode, "#" + sArgName, sArgValue);
          this.parameters.setAttribute(sArgName, sArgValue);
        }

      }
      if (this.Type.equalsIgnoreCase("Sql")){
        try {
          sCode = AmarScript.pretreatMethod(sCode, this.parameters, this.Sqlca);
        } catch (Exception ex) {
          ARE.getLog().error("============ִ��Sql���͵�ASMethod,Ԥ������ʱ����(AmarMethod.java)��", ex);
          throw ex;
        }
        anyResult = new Anything(this.context, "Null", "");
        Vector vTemp = new Vector();

        if ((sCode.substring(0, 6).equalsIgnoreCase("update")) || (sCode.substring(0, 6).equalsIgnoreCase("insert")) || (sCode.substring(0, 6).equalsIgnoreCase("delete")) || (StringFunction.replace(sCode, " ", "").substring(0, 5).equalsIgnoreCase("{call")))
        {
          int i = 0;
          try {
            i = this.Sqlca.executeSQL(sCode);
          } catch (Exception ex) {
            throw new ASException("ִ������ΪSQL��Update����ASMethod��������" + ex.getMessage());
          }
          anyResult = new Anything(this.parameters, "Number", String.valueOf(i));
        }
        else
        {
          ASResultSet rsResult = null;
          try {
            rsResult = this.Sqlca.getASResultSet(sCode);
          } catch (Exception ex) {
            throw new ASException("ִ������ΪSQL(select)��ASMethodʱ�������󡣴���" + ex.getMessage());
          }

          if (this.ReturnType.indexOf("[]") == -1)
          {
            if (rsResult.next()) {
              String sTmpResult = null;
              try {
                sTmpResult = rsResult.getStringValue(1);
              } catch (Exception ex) {
                throw new ASException("�ӽ����ȡֵ����" + ex.getMessage());
              }

              try
              {
                anyResult = new Anything(this.parameters, this.ReturnType, sTmpResult);
              } catch (Exception ex) {
                throw new ASException("����ת��ʱ��������Ŀ�����ͣ�" + this.ReturnType + " ����ֵ��" + sTmpResult + " ������Ϣ��" + ex.getMessage());
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
                anyResult = new Anything(this.parameters, sValueType, sTmpResult);
              } catch (Exception ex) {
                throw new ASException("����ת��ʱ��������Ŀ�����ͣ�" + this.ReturnType + " ����ֵ��" + sTmpResult + " ������Ϣ��" + ex.getMessage());
              }
              vTemp.addElement(anyResult);
            }

            if (vTemp.size() > 0) anyResult = new Anything(this.parameters, this.ReturnType, vTemp);
          }
          rsResult.getStatement().close();
        }
      } else if (this.Type.equalsIgnoreCase("Expression")){
        try {
          AmarScript script = new AmarScript(this.parameters);
          anyResult = script.getExpressionValue(sCode, this.Sqlca);
        } catch (Exception ex) {
          ARE.getLog().error("===============����ִ�б��ʽʱ����(AmarMethod.java)�����ʽ��" + sCode, ex);
          throw ex;
        }
      }else if (this.Type.equalsIgnoreCase("Bizlet")){
        BizletExecutor executor = new BizletExecutor();
        executor.setContext(this.context);
        Object oTemp = null;
        oTemp = executor.execute(this.Sqlca, sCode, this.parameters);
        try
        {
          if (this.ReturnType.indexOf("[]") >= 0)
            anyResult = new Anything(this.parameters, this.ReturnType, (Vector)oTemp);
          else
            anyResult = new Anything(this.parameters, this.ReturnType, (String)oTemp);
        }
        catch (Exception ex)
        {
          String sReturnedType;
          if (oTemp != null)
            sReturnedType = oTemp.getClass().getName();
          else
            sReturnedType = "null";
          throw new ASException("Bizlet����ֵ���ʹ���Ŀ�����ͣ�" + this.ReturnType + "�����ص����ͣ�" + sReturnedType + " ����:" + ex.getMessage());
        }
      }
      return anyResult;
    } catch (ASException ex) {
      ARE.getLog().error("==============ִ��ASMethod[" + this.Class + "." + this.Name + "]ʱ����", ex);
      throw ex;
    } catch (Exception ex) {
      ARE.getLog().error("==============ִ��ASMethod[" + this.Class + "." + this.Name + "]ʱ����", ex);
      throw ex;
    }
  }

  public static Anything executeMethod(String sMethod, ASValuePool vpContext, Transaction Sqlca)
    throws Exception
  {
    Anything anyValue = null;

    int iDot = sMethod.indexOf(".", 0);
    int iArgsBegin = sMethod.indexOf("(", 0);
    int iArgsEnd = StringFunction.indexOf(sMethod, ")", "'", "'", 0);

    if ((iArgsEnd > iArgsBegin) && (iArgsBegin > iDot) && (iDot >= 0))
    {
      String sClassName = sMethod.substring(1, iDot).trim();
      String sMethodName = sMethod.substring(iDot + 1, iArgsBegin).trim();
      String sArgsValue = sMethod.substring(iArgsBegin + 1, iArgsEnd).trim();

      AmarMethod asm = new AmarMethod(sClassName, sMethodName, vpContext, Sqlca);

      if (sArgsValue == null) sArgsValue = "";
      anyValue = asm.execute(sArgsValue);
    }

    return anyValue;
  }
}