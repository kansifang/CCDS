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

    if (idOperator.Attribute.equalsIgnoreCase("��Ŀ"))
    {
      Anything anyOperand4 = popOperand(stackOperand);
      Anything anyOperand3 = popOperand(stackOperand);
      Anything anyOperand2 = popOperand(stackOperand);
      Anything anyOperand1 = popOperand(stackOperand);
      anyOperateResult = anyOperand1.operateWith(idOperator.Content, anyOperand2, anyOperand3, anyOperand4);
    }
    else if (idOperator.Attribute.equalsIgnoreCase("��Ŀ"))
    {
      Anything anyOperand3 = popOperand(stackOperand);
      Anything anyOperand2 = popOperand(stackOperand);
      Anything anyOperand1 = popOperand(stackOperand);
      anyOperateResult = anyOperand1.operateWith(idOperator.Content, anyOperand2, anyOperand3);
    }
    else if (idOperator.Attribute.equalsIgnoreCase("˫Ŀ"))
    {
      Anything anyOperand2 = popOperand(stackOperand);
      Anything anyOperand1 = popOperand(stackOperand);
      anyOperateResult = anyOperand1.operateWith(idOperator.Content, anyOperand2);
    }
    else if (idOperator.Attribute.equalsIgnoreCase("��Ŀ"))
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

    ID idLast = new ID("��ʼ", "", "", "", 0);
    int iExpressionLen = sExpression.length();
    try
    {
      while (iScanPos < iExpressionLen)
      {
        ID idCurrent = IDManager.getID(sExpression, iScanPos);

        if (idCurrent.Name.equalsIgnoreCase("������"))
        {
          StackOperand.push(new Anything(this.context, idCurrent.Attribute, idCurrent.Value));
        }
        else if (idCurrent.Name.equalsIgnoreCase("�����"))
        {
          if ((idCurrent.Content.equalsIgnoreCase("-")) && (!idLast.Name.equalsIgnoreCase("������")) && (!idLast.Name.equalsIgnoreCase("������")) && (!idLast.Name.equalsIgnoreCase("�������")) && (!idLast.Name.equalsIgnoreCase("�ⲿ����")))
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
              throw new AmarScriptException("Expression:���ʽ��д����1" + sExpression);
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
        else if ((idCurrent.Name.equalsIgnoreCase("������")) || (idCurrent.Name.equalsIgnoreCase("����")))
        {
          StackOperator.push(idCurrent);
        }
        else if (idCurrent.Name.equalsIgnoreCase("������"))
        {
          ID idOperator;
          do
          {
            idOperator = (ID)StackOperator.pop();
            anyOperateResult = getOperateResult(StackOperand, idOperator);
            StackOperand.push(anyOperateResult);

            if (idOperator.Name.equalsIgnoreCase("������")) break; 
          }while (!idOperator.Name.equalsIgnoreCase("����"));
        }
        else if (idCurrent.Name.equalsIgnoreCase("���鿪ʼ"))
        {
          StackOperator.push(idCurrent);
        }
        else if (idCurrent.Name.equalsIgnoreCase("�������")) {
          String sOperandType = "";
          Vector vOperandList = new Vector();
          ID idOperator;
          do {
            idOperator = (ID)StackOperator.pop();
            if (idOperator.Name.equalsIgnoreCase("�����"))
            {
              anyOperateResult = getOperateResult(StackOperand, idOperator);
              StackOperand.push(anyOperateResult);
            }
            else {
              Anything anyOperand = popOperand(StackOperand);
              if (sOperandType.equals("")) sOperandType = anyOperand.getType();
              else if (!sOperandType.equals(anyOperand.getType()))
              {
                throw new AmarScriptException("Expression:���ʽ������Ԫ�����Ͳ�һ��" + sExpression);
              }
              vOperandList.insertElementAt(anyOperand, 0);
            }
          }
          while (!idOperator.Name.equalsIgnoreCase("���鿪ʼ"));

          if (vOperandList.size() > 0) anyOperateResult = new Anything(this.context, sOperandType + "[]", vOperandList); else {
            anyOperateResult = new Anything(this.context, "Null", "");
          }
          StackOperand.push(anyOperateResult);
        }
        else if (idCurrent.Name.equalsIgnoreCase("�ָ���"))
        {
          ID idLastOperator = (ID)StackOperator.lastElement();

          while ((!idLastOperator.Name.equalsIgnoreCase("����")) && (!idLastOperator.Name.equalsIgnoreCase("���鿪ʼ")) && (!idLastOperator.Name.equalsIgnoreCase("�ָ���")))
          {
            ID idOperator = (ID)StackOperator.pop();

            anyOperateResult = getOperateResult(StackOperand, idOperator);
            StackOperand.push(anyOperateResult);

            idLastOperator = (ID)StackOperator.lastElement();
          }

          StackOperator.push(idCurrent);
        }
        else if (idCurrent.Name.equalsIgnoreCase("�ⲿ����"))
        {
          anyOperateResult = new Anything(this.context, idCurrent.Content, Sqlca);
          StackOperand.push(anyOperateResult);
        } else {
          if (idCurrent.Name.equalsIgnoreCase("����"))
          {
            iScanPos += idCurrent.Content.length();
            continue;
          }

          throw new AmarScriptException("���ʽ��д����2���޷�ʶ��ؼ������ͣ����飺<br>1.���ʽ�е��ַ����Ƿ�����˵����š�<br>2.�����Ƿ��Сд��ƴд��ȷ��<br><br>���ʽ��<br>" + sExpression);
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
        throw new AmarScriptException("���ʽ��д����3<br>���ʽ��<br>" + sExpression);
      }
    }
    catch (EmptyStackException e)
    {
      throw new AmarScriptException("Expression:���ʽ��������������������ƥ��" + sExpression);
    }
    catch (CannotFindContextVariableException e) {
      ARE.getLog().error("=============�滻��������ʱ��������:", e);
      throw e;
    }
    catch (AnythingException e) {
      ARE.getLog().error("=============�������ʽʱ��������(AmarScript.java)��", e);
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
      if (iCycle > 100) throw new AmarScriptException("Expression�еķ�����������100����");

      int iArgsEnd = StringFunction.indexOf(sExpression, ")", "'", "'", iPos);

      String sMethod = sExpression.substring(iPos, iArgsEnd + 1);

      Anything anyValue = AmarMethod.executeMethod(sMethod, vpContext, Sqlca);

      if (anyValue == null) throw new AmarScriptException("Expression PretreatMethod: ��ֵ�����У�����Nullֵ��", 2);

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
          throw new CannotFindContextVariableException("û���ҵ���������������ű������ĳ�ʼ��������Լ�ҵ������" + sBeginIdentifier + sAttributeID + sEndIdentifier + "�Ķ��塣");
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