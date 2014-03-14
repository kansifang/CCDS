package com.lmt.frameapp.script;

import java.util.EmptyStackException;
import java.util.Stack;
import java.util.Vector;

import com.lmt.app.cms.explain.AmarMethod;
import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.sql.Transaction;

public class AmarScript
{
  private ASValuePool context;

  private Anything getOperateResult(Stack stackOperand, ID idOperator)
    throws Exception
  {
    Anything anyOperateResult = null;

    if (idOperator.Attribute.equalsIgnoreCase("四目"))
    {
      Anything anyOperand4 = popOperand(stackOperand);
      Anything anyOperand3 = popOperand(stackOperand);
      Anything anyOperand2 = popOperand(stackOperand);
      Anything anyOperand1 = popOperand(stackOperand);
      anyOperateResult = anyOperand1.operateWith(idOperator.Content, anyOperand2, anyOperand3, anyOperand4);
    }
    else if (idOperator.Attribute.equalsIgnoreCase("三目"))
    {
      Anything anyOperand3 = popOperand(stackOperand);
      Anything anyOperand2 = popOperand(stackOperand);
      Anything anyOperand1 = popOperand(stackOperand);
      anyOperateResult = anyOperand1.operateWith(idOperator.Content, anyOperand2, anyOperand3);
    }
    else if (idOperator.Attribute.equalsIgnoreCase("双目"))
    {
      Anything anyOperand2 = popOperand(stackOperand);
      Anything anyOperand1 = popOperand(stackOperand);
      anyOperateResult = anyOperand1.operateWith(idOperator.Content, anyOperand2);
    }
    else if (idOperator.Attribute.equalsIgnoreCase("单目"))
    {
      Anything anyOperand1 = popOperand(stackOperand);
      anyOperateResult = anyOperand1.operateWith(idOperator.Content);
    }
    else {
      anyOperateResult = popOperand(stackOperand);
    }

    return anyOperateResult;
  }

  private Anything popOperand(Stack stackOperand)
    throws Exception
  {
    Anything anyOperand = null;

    anyOperand = (Anything)stackOperand.pop();

    return anyOperand;
  }

  public AmarScript(ASValuePool vpContext) {
    this.context = vpContext;
  }

  public Anything getExpressionValue(String sExpression, Transaction Sqlca)
    throws Exception
  {
    if ((sExpression == null) || (sExpression.equals(""))) return new Anything(this.context, "");

    int iScanPos = 0;

    Anything anyOperateResult = new Anything(this.context, 0);
    Stack StackOperand = new Stack();
    Stack StackOperator = new Stack();

    Object[] sTmpContextKeys = this.context.getKeys();
    for (int i = 0; i < sTmpContextKeys.length; i++) {
      String sTmpKey = (String)sTmpContextKeys[i];
      Object oTmp = this.context.getAttribute(sTmpKey);

      boolean isScriptObject = false;
      Class[] interfacesImplmented = oTmp.getClass().getInterfaces();
      for (int j = 0; j < interfacesImplmented.length; j++) {
        if (interfacesImplmented[j].getName().endsWith("IScriptObject")) {
          isScriptObject = true;
        }
      }
      if (!isScriptObject) {
        continue;
      }
      IScriptObject oTmpSO = (IScriptObject)oTmp;

      sExpression = pretreatObjectAttributes(sExpression, sTmpKey, oTmpSO);
    }

    ID idLast = new ID("开始", "", "", "", 0);
    int iExpressionLen = sExpression.length();
    try
    {
      while (iScanPos < iExpressionLen)
      {
        ID idCurrent = IDManager.getID(sExpression, iScanPos);

        if (idCurrent.Name.equalsIgnoreCase("操作数"))
        {
          StackOperand.push(new Anything(this.context, idCurrent.Attribute, idCurrent.Value));
        }
        else if (idCurrent.Name.equalsIgnoreCase("运算符"))
        {
          if ((idCurrent.Content.equalsIgnoreCase("-")) && (!idLast.Name.equalsIgnoreCase("操作数")) && (!idLast.Name.equalsIgnoreCase("右括号")) && (!idLast.Name.equalsIgnoreCase("数组结束")) && (!idLast.Name.equalsIgnoreCase("外部函数")))
          {
            ID idNext = IDManager.getID(sExpression, iScanPos + 1);
            if (idNext.Attribute.equalsIgnoreCase("Number"))
            {
              idNext.Content = ("-" + idNext.Content);
              idNext.Value = ("-" + idNext.Value);
              idCurrent = idNext;
              StackOperand.push(new Anything(this.context, idCurrent.Attribute, idCurrent.Value));
            }
            else {
              throw new AmarScriptException("Expression:表达式书写错误1" + sExpression);
            }

          }
          else if (StackOperator.empty())
          {
            StackOperator.push(idCurrent);
          }
          else
          {
            idLast = (ID)StackOperator.lastElement();
            if (idCurrent.Order > idLast.Order)
            {
              StackOperator.push(idCurrent);
            }
            else
            {
              ID idOperator;
              do
              {
                idOperator = (ID)StackOperator.pop();
                anyOperateResult = getOperateResult(StackOperand, idOperator);
                StackOperand.push(anyOperateResult);

                if (StackOperator.empty())
                  continue;
                idOperator = (ID)StackOperator.lastElement();
              }

              while ((idCurrent.Order <= idOperator.Order) && (!StackOperator.empty()));

              StackOperator.push(idCurrent);
            }
          }

        }
        else if ((idCurrent.Name.equalsIgnoreCase("左括号")) || (idCurrent.Name.equalsIgnoreCase("函数")))
        {
          StackOperator.push(idCurrent);
        }
        else if (idCurrent.Name.equalsIgnoreCase("右括号"))
        {
          ID idOperator;
          do
          {
            idOperator = (ID)StackOperator.pop();
            anyOperateResult = getOperateResult(StackOperand, idOperator);
            StackOperand.push(anyOperateResult);

            if (idOperator.Name.equalsIgnoreCase("左括号")) break; 
          }while (!idOperator.Name.equalsIgnoreCase("函数"));
        }
        else if (idCurrent.Name.equalsIgnoreCase("数组开始"))
        {
          StackOperator.push(idCurrent);
        }
        else if (idCurrent.Name.equalsIgnoreCase("数组结束")) {
          String sOperandType = "";
          Vector vOperandList = new Vector();
          ID idOperator;
          do {
            idOperator = (ID)StackOperator.pop();
            if (idOperator.Name.equalsIgnoreCase("运算符"))
            {
              anyOperateResult = getOperateResult(StackOperand, idOperator);
              StackOperand.push(anyOperateResult);
            }
            else {
              Anything anyOperand = popOperand(StackOperand);
              if (sOperandType.equals("")) sOperandType = anyOperand.getType();
              else if (!sOperandType.equals(anyOperand.getType()))
              {
                throw new AmarScriptException("Expression:表达式中数组元素类型不一致" + sExpression);
              }
              vOperandList.insertElementAt(anyOperand, 0);
            }
          }
          while (!idOperator.Name.equalsIgnoreCase("数组开始"));

          if (vOperandList.size() > 0) anyOperateResult = new Anything(this.context, sOperandType + "[]", vOperandList); else {
            anyOperateResult = new Anything(this.context, "Null", "");
          }
          StackOperand.push(anyOperateResult);
        }
        else if (idCurrent.Name.equalsIgnoreCase("分隔符"))
        {
          ID idLastOperator = (ID)StackOperator.lastElement();

          while ((!idLastOperator.Name.equalsIgnoreCase("函数")) && (!idLastOperator.Name.equalsIgnoreCase("数组开始")) && (!idLastOperator.Name.equalsIgnoreCase("分隔符")))
          {
            ID idOperator = (ID)StackOperator.pop();

            anyOperateResult = getOperateResult(StackOperand, idOperator);
            StackOperand.push(anyOperateResult);

            idLastOperator = (ID)StackOperator.lastElement();
          }

          StackOperator.push(idCurrent);
        }
        else if (idCurrent.Name.equalsIgnoreCase("外部函数"))
        {
          anyOperateResult = new Anything(this.context, idCurrent.Content, Sqlca);
          StackOperand.push(anyOperateResult);
        } else {
          if (idCurrent.Name.equalsIgnoreCase("忽略"))
          {
            iScanPos += idCurrent.Content.length();
            continue;
          }

          throw new AmarScriptException("表达式书写错误2（无法识别关键字类型）请检查：<br>1.表达式中的字符串是否添加了单引号。<br>2.函数是否大小写及拼写正确。<br><br>表达式：<br>" + sExpression);
        }

        iScanPos += idCurrent.Content.length();
        idLast = idCurrent;
      }

      while (!StackOperator.empty())
      {
        ID idOperator = (ID)StackOperator.pop();

        anyOperateResult = getOperateResult(StackOperand, idOperator);
        StackOperand.push(anyOperateResult);
      }

      if (StackOperand.size() == 1)
      {
        anyOperateResult = popOperand(StackOperand);
      }
      else {
        throw new AmarScriptException("表达式书写错误3<br>表达式：<br>" + sExpression);
      }
    }
    catch (EmptyStackException e)
    {
      throw new AmarScriptException("Expression:表达式中运算符与操作数数量不匹配" + sExpression);
    }
    catch (CannotFindContextVariableException e) {
      ARE.getLog().error("=============替换环境变量时发生错误:", e);
      throw e;
    }
    catch (AnythingException e) {
      ARE.getLog().error("=============解析表达式时发生错误(AmarScript.java)。", e);
      throw e;
    }

    if (anyOperateResult.getType().equalsIgnoreCase("Method")) anyOperateResult = anyOperateResult.methodValue();
    return anyOperateResult;
  }

  public static String pretreatMethod(String sExpression, ASValuePool vpContext, Transaction Sqlca)
    throws Exception
  {
    sExpression = sExpression.trim();

    int iPos = sExpression.indexOf("!", 0);
    int iCycle = 0;
    while (iPos != -1)
    {
      iCycle++;
      if (iCycle > 100) throw new AmarScriptException("Expression中的方法数超过了100个。");

      int iArgsEnd = StringFunction.indexOf(sExpression, ")", "'", "'", iPos);

      String sMethod = sExpression.substring(iPos, iArgsEnd + 1);

      Anything anyValue = AmarMethod.executeMethod(sMethod, vpContext, Sqlca);

      if (anyValue == null) throw new AmarScriptException("Expression PretreatMethod: 数值运算中，出现Null值！", 2);

      String sValue = anyValue.toString();

      if (iArgsEnd == sExpression.length() - 1) return sValue;

      sExpression = StringFunction.replace(sExpression, sMethod, sValue);
      iPos = sExpression.indexOf("!", iPos + sValue.length());
    }
    return sExpression;
  }

  public static String pretreatConstant(String sExpression, String[][] sConstant)
    throws Exception
  {
    sExpression = sExpression.trim();

    for (int i = 0; i < sConstant.length; i++)
    {
      sExpression = StringFunction.replace(sExpression, sConstant[i][0], sConstant[i][1]);
    }

    return sExpression;
  }

  public static String pretreatConstant(String sExpression, ASValuePool vpConstant)
    throws Exception
  {
    sExpression = sExpression.trim();
    Object[] sKeys = vpConstant.getKeys();

    for (int i = 0; i < sKeys.length; i++)
    {
      String sTmpValue = (String)vpConstant.getAttribute((String)sKeys[i]);
      if (sTmpValue == null)
        continue;
      if ((sKeys[i] != null) && (((String)sKeys[i]).indexOf("#") != 0)) sKeys[i] = ("#" + (String)sKeys[i]);
      sExpression = StringFunction.replace(sExpression, (String)sKeys[i], sTmpValue);
    }

    return sExpression;
  }

  public static String pretreatConstantEx(String sExpression, ASValuePool vpConstant)
    throws Exception
  {
    sExpression = sExpression.trim();
    Object[] sKeys = vpConstant.getKeys();

    for (int i = 0; i < sKeys.length; i++)
    {
      String sTmpValue = (String)vpConstant.getAttribute((String)sKeys[i]);
      if (sTmpValue == null)
        continue;
      if ((sKeys[i] != null) && (((String)sKeys[i]).indexOf("#") != 0)) sKeys[i] = ("#" + (String)sKeys[i] + "#");
      sExpression = StringFunction.replace(sExpression, (String)sKeys[i], sTmpValue);
    }

    return sExpression;
  }

  public static String pretreatObjectAttributes(String sCode, String sObjName, IScriptObject bo)
    throws Exception
  {
    if (bo == null) return sCode;

    IScriptObject vpTmp = bo;
    ASValuePool vpConstants = new ASValuePool();
    Object[] sKeys = vpTmp.getKeys();
    if (sKeys == null) return sCode;

    for (int i = 0; i < sKeys.length; i++) {
      vpConstants.setAttribute((String)sKeys[i], vpTmp.getAttribute((String)sKeys[i]));
    }
    String sReturn = null;
    sReturn = forceMacroReplace(vpConstants, sCode, "${" + sObjName + ":", "}");
    return sReturn;
  }

  public static String forceMacroReplace(ASValuePool vpAttributes, String sSource, String sBeginIdentifier, String sEndIdentifier)
    throws Exception
  {
    if (sSource == null) return null;
    if ((vpAttributes == null) || (vpAttributes.size() == 0)) return sSource;

    int iPosBegin = 0; int iPosEnd = 0;
    String sAttributeID = "";
    String sAttributeValue = "";
    Object oTmp = null;
    String sReturn = sSource;

    while ((iPosBegin = sReturn.indexOf(sBeginIdentifier, iPosBegin)) >= 0) {
      iPosEnd = sReturn.indexOf(sEndIdentifier, iPosBegin + 1);
      if (iPosEnd >= 0) {
        sAttributeID = sReturn.substring(iPosBegin + sBeginIdentifier.length(), iPosEnd);
        if (!vpAttributes.containsKey(sAttributeID)) {
          throw new CannotFindContextVariableException("没有找到环境变量。请检查脚本场景的初始化程序的以及业务属性" + sBeginIdentifier + sAttributeID + sEndIdentifier + "的定义。");
        }
        oTmp = vpAttributes.getAttribute(sAttributeID);
        sAttributeValue = (String)oTmp;
        if (sAttributeValue == null) sAttributeValue = "";
        sReturn = sReturn.substring(0, iPosBegin) + sAttributeValue + sReturn.substring(iPosEnd + sEndIdentifier.length());
      }
    }

    return sReturn;
  }
}