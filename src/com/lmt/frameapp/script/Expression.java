package com.lmt.frameapp.script;

import java.util.EmptyStackException;
import java.util.Stack;
import java.util.Vector;

import com.lmt.app.cms.explain.ASMethod;
import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.sql.Transaction;

public class Expression
{
  public static Any getExpressionValue(String sExpression, Transaction Sqlca)
    throws Exception
  {
    if ((sExpression == null) || (sExpression.equals(""))) 
    	return new Any("");

    int iScanPos = 0;

    Any anyOperateResult = new Any(0);
    Stack StackOperand = new Stack();
    Stack StackOperator = new Stack();

    ID idLast = new ID("��ʼ", "", "", "", 0);
    int iExpressionLen = sExpression.length();
    ARE.getLog().trace("getExpressionValue:" + sExpression);
    try
    {
      while (iScanPos < iExpressionLen){
        ID idCurrent = IDManager.getID(sExpression, iScanPos);

        if (idCurrent.Name.equalsIgnoreCase("������")){
          StackOperand.push(new Any(idCurrent.Attribute, idCurrent.Value));
        }else if (idCurrent.Name.equalsIgnoreCase("�����")){
          if ((idCurrent.Content.equalsIgnoreCase("-")) && (!idLast.Name.equalsIgnoreCase("������")) && (!idLast.Name.equalsIgnoreCase("������")) && (!idLast.Name.equalsIgnoreCase("�������")) && (!idLast.Name.equalsIgnoreCase("�ⲿ����")))
          {
            ID idNext = IDManager.getID(sExpression, iScanPos + 1);
            if (idNext.Attribute.equalsIgnoreCase("Number")){
              idNext.Content = ("-" + idNext.Content);
              idNext.Value = ("-" + idNext.Value);
              idCurrent = idNext;
              StackOperand.push(new Any(idCurrent.Attribute, idCurrent.Value));
            }else {
              throw new ExpressionException("Expression:���ʽ��д����1" + sExpression);
            }
          }else if (StackOperator.empty()){
            StackOperator.push(idCurrent);
          }else{
            idLast = (ID)StackOperator.lastElement();
            if (idCurrent.Order > idLast.Order){
              StackOperator.push(idCurrent);
            }else{
              ID idOperator;
              do{
                idOperator = (ID)StackOperator.pop();
                anyOperateResult = getOperateResult(StackOperand, idOperator);
                StackOperand.push(anyOperateResult);
                if (StackOperator.empty())
                  continue;
                idOperator = (ID)StackOperator.lastElement();
              }while ((idCurrent.Order <= idOperator.Order) && (!StackOperator.empty()));
              StackOperator.push(idCurrent);
            }
          }
        }else if ((idCurrent.Name.equalsIgnoreCase("������")) || (idCurrent.Name.equalsIgnoreCase("����"))){
          StackOperator.push(idCurrent);
        }else if (idCurrent.Name.equalsIgnoreCase("������")){
          ID idOperator;
          do{
            idOperator = (ID)StackOperator.pop();
            anyOperateResult = getOperateResult(StackOperand, idOperator);
            StackOperand.push(anyOperateResult);
            if (idOperator.Name.equalsIgnoreCase("������")) break; 
          }while (!idOperator.Name.equalsIgnoreCase("����"));
        }else if (idCurrent.Name.equalsIgnoreCase("���鿪ʼ")){
          StackOperator.push(idCurrent);
        }else if (idCurrent.Name.equalsIgnoreCase("�������")){
          String sOperandType = "";
          Vector vOperandList = new Vector();
          ID idOperator;
          do {
            idOperator = (ID)StackOperator.pop();
            if (idOperator.Name.equalsIgnoreCase("�����")){
              anyOperateResult = getOperateResult(StackOperand, idOperator);
              StackOperand.push(anyOperateResult);
            }else {
              Any anyOperand = popOperand(StackOperand);
              if (sOperandType.equals("")) sOperandType = anyOperand.getType();
              else if (!sOperandType.equals(anyOperand.getType()))
              {
                throw new ExpressionException("Expression:���ʽ������Ԫ�����Ͳ�һ��" + sExpression);
              }
              vOperandList.insertElementAt(anyOperand, 0);
            }
          }while (!idOperator.Name.equalsIgnoreCase("���鿪ʼ"));
          if (vOperandList.size() > 0){ 
        	  anyOperateResult = new Any(sOperandType + "[]", vOperandList); 
          }else {
            anyOperateResult = new Any("Null", "");
          }
          StackOperand.push(anyOperateResult);
        }else if (idCurrent.Name.equalsIgnoreCase("�ָ���")){//����һ������㣬�ָ�������","
          ID idLastOperator = (ID)StackOperator.lastElement();
          while ((!idLastOperator.Name.equalsIgnoreCase("����"))&& (!idLastOperator.Name.equalsIgnoreCase("���鿪ʼ")) && (!idLastOperator.Name.equalsIgnoreCase("�ָ���"))){
            ID idOperator = (ID)StackOperator.pop();
            anyOperateResult = getOperateResult(StackOperand, idOperator);
            StackOperand.push(anyOperateResult);
            idLastOperator = (ID)StackOperator.lastElement();
          }
          StackOperator.push(idCurrent);
        }else if (idCurrent.Name.equalsIgnoreCase("�ⲿ����")){
          anyOperateResult = new Any(idCurrent.Content, Sqlca);
          StackOperand.push(anyOperateResult);
        }else{
          if (idCurrent.Name.equalsIgnoreCase("����"))
          {
            iScanPos += idCurrent.Content.length();
            continue;
          }
          iScanPos++;
          continue;
        }
        iScanPos += idCurrent.Content.length();
        idLast = idCurrent;
      }
      while (!StackOperator.empty()){
        ID idOperator = (ID)StackOperator.pop();
        anyOperateResult = getOperateResult(StackOperand, idOperator);
        StackOperand.push(anyOperateResult);
      }

      if (StackOperand.size() == 1){
        anyOperateResult = popOperand(StackOperand);
      }
      else {
        throw new ExpressionException("Expression:���ʽ��д����3" + sExpression);
      }
    }
    catch (EmptyStackException e)
    {
      throw new ExpressionException("Expression:���ʽ��������������������ƥ��" + sExpression);
    }
    catch (AnyException e)
    {
      throw new ExpressionException(e.getMessage() + sExpression, e.getErrorLevel());
    }
    if (anyOperateResult.getType().equalsIgnoreCase("Method"))
    	anyOperateResult = anyOperateResult.methodValue();
    return anyOperateResult;
  }

  private static Any getOperateResult(Stack stackOperand, ID idOperator)
    throws Exception
  {
    Any anyOperateResult = null;

    if (idOperator.Attribute.equalsIgnoreCase("��Ŀ"))
    {
      Any anyOperand4 = popOperand(stackOperand);
      Any anyOperand3 = popOperand(stackOperand);
      Any anyOperand2 = popOperand(stackOperand);
      Any anyOperand1 = popOperand(stackOperand);
      anyOperateResult = anyOperand1.operateWith(idOperator.Content, anyOperand2, anyOperand3, anyOperand4);
    }
    else if (idOperator.Attribute.equalsIgnoreCase("��Ŀ"))
    {
      Any anyOperand3 = popOperand(stackOperand);
      Any anyOperand2 = popOperand(stackOperand);
      Any anyOperand1 = popOperand(stackOperand);
      anyOperateResult = anyOperand1.operateWith(idOperator.Content, anyOperand2, anyOperand3);
    }
    else if (idOperator.Attribute.equalsIgnoreCase("˫Ŀ"))
    {
      Any anyOperand2 = popOperand(stackOperand);
      Any anyOperand1 = popOperand(stackOperand);
      anyOperateResult = anyOperand1.operateWith(idOperator.Content, anyOperand2);
    }
    else if (idOperator.Attribute.equalsIgnoreCase("��Ŀ"))
    {
      Any anyOperand1 = popOperand(stackOperand);
      anyOperateResult = anyOperand1.operateWith(idOperator.Content);
    }
    else {
      anyOperateResult = popOperand(stackOperand);
    }

    return anyOperateResult;
  }

  private static Any popOperand(Stack stackOperand)
    throws Exception
  {
    Any anyOperand = null;

    anyOperand = (Any)stackOperand.pop();

    return anyOperand;
  }

  public static String pretreatMethod(String sExpression, Transaction Sqlca)
    throws Exception
  {
    sExpression = sExpression.trim();

    int iPos = sExpression.indexOf("!", 0);
    int iCycle = 0;
    while (iPos != -1)
    {
      iCycle++;
      if (iCycle > 100) throw new ExpressionException("Expression�еķ�����������100����");

      int iArgsEnd = StringFunction.indexOf(sExpression, ")", "'", "'", iPos);

      String sMethod = sExpression.substring(iPos, iArgsEnd + 1);

      Any anyValue = ASMethod.executeMethod(sMethod, Sqlca);

      if (anyValue == null) throw new ExpressionException("Expression PretreatMethod: ��ֵ�����У�����Nullֵ��", 2);

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
      if ((sKeys[i] != null) && (((String)sKeys[i]).indexOf("#") != 0)) sKeys[i] = ("#" + (String)sKeys[i]);
      sExpression = StringFunction.replace(sExpression, (String)sKeys[i], (String)vpConstant.getAttribute((String)sKeys[i]));
    }

    return sExpression;
  }
}