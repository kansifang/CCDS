package com.lmt.frameapp.script;

import java.util.Vector;

import com.lmt.app.cms.explain.AmarMethod;
import com.lmt.baseapp.util.ASValuePool;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.sql.Transaction;

public class Anything
{
  private String sType;
  private String sValue;
  private double dValue;
  private boolean bValue;
  private LSDate asdValue;
  private Vector vElementList;
  private Transaction Sqlca;
  private ASValuePool context;

  public Anything(ASValuePool vpContext, String Type, String Value)
    throws Exception
  {
    this.context = vpContext;
    this.sType = Type;
    if (Type.equalsIgnoreCase("Number"))
    {
      if ((Value == null) || (Value.equals("")) || (Value.equalsIgnoreCase("Null"))) this.sType = "Null"; else
        try
        {
          this.dValue = Double.parseDouble(Value);
        } catch (Exception ex) {
          throw new Exception("Any Constructor：无法将字符串[" + Value + "] 转换为double型。" + ex.getMessage());
        }
    }
    else if (Type.equalsIgnoreCase("String"))
    {
      if (Value == null) this.sType = "Null"; else
        this.sValue = Value;
    } else if (Type.equalsIgnoreCase("Boolean"))
    {
      if ((Value == null) || (Value.equals("")) || (Value.equals("Null"))) this.sType = "Null"; else
        this.bValue = Boolean.valueOf(Value).booleanValue();
    } else if (Type.equalsIgnoreCase("Date"))
    {
      if ((Value == null) || (Value.equals("")) || (Value.equals("Null"))) this.sType = "Null"; else
        this.asdValue = new LSDate(Value);
    } else if (!Type.equalsIgnoreCase("Null"))
    {
      throw new AnythingException("Any Constructor:无法识别的类型");
    }
  }

  public Anything(ASValuePool vpContext, String Value, Transaction transSql) throws Exception
  {
    this.context = vpContext;
    this.sType = "Method";
    this.Sqlca = transSql;
    if (Value == null) this.sType = "Null"; else
      this.sValue = Value;
  }

  public Anything(ASValuePool vpContext, String Type, Vector ElementList)
  {
    this.context = vpContext;
    this.sType = Type;
    this.vElementList = ElementList;
  }

  public Anything(ASValuePool vpContext, byte Value)
  {
    this.context = vpContext;
    this.sType = "Number";
    this.dValue = Value;
  }

  public Anything(ASValuePool vpContext, short Value)
  {
    this.context = vpContext;
    this.sType = "Number";
    this.dValue = Value;
  }

  public Anything(ASValuePool vpContext, int Value)
  {
    this.context = vpContext;
    this.sType = "Number";
    this.dValue = Value;
  }

  public Anything(ASValuePool vpContext, long Value)
  {
    this.context = vpContext;
    this.sType = "Number";
    this.dValue = Value;
  }

  public Anything(ASValuePool vpContext, float Value)
  {
    this.context = vpContext;
    this.sType = "Number";
    this.dValue = Value;
  }

  public Anything(ASValuePool vpContext, double Value)
  {
    this.context = vpContext;
    this.sType = "Number";
    this.dValue = Value;
  }

  public Anything(ASValuePool vpContext, boolean Value)
  {
    this.context = vpContext;
    this.sType = "Boolean";
    this.bValue = Value;
  }

  public Anything(ASValuePool vpContext, String Value)
  {
    this.context = vpContext;
    if (Value == null) { this.sType = "Null";
    } else
    {
      this.sType = "String";
      this.sValue = Value;
    }
  }

  public Anything(ASValuePool vpContext, LSDate Value)
  {
    this.context = vpContext;
    this.sType = "Date";
    this.asdValue = Value;
  }

  public int compareTo(Anything anyOther)
    throws Exception
  {
    int CompareResult = 0;

    Anything anyThis = this;

    if (this.sType.equalsIgnoreCase("Method")) anyThis = methodValue();
    if (anyOther.sType.equalsIgnoreCase("Method")) anyOther = anyOther.methodValue();

    if (anyThis.sType.equalsIgnoreCase(anyOther.getType()))
    {
      if (anyThis.sType.equalsIgnoreCase("String"))
      {
        CompareResult = anyThis.sValue.compareTo(anyOther.stringValue());
      }
      else if (anyThis.sType.equalsIgnoreCase("Number"))
      {
        CompareResult = new Double(anyThis.dValue).compareTo(new Double(anyOther.doubleValue()));
      }
      else if (anyThis.sType.equalsIgnoreCase("Boolean"))
      {
        if (anyThis.bValue == anyOther.booleanValue())
        {
          CompareResult = 0;
        }
        else
        {
          CompareResult = 1;
        }
      } else if (anyThis.sType.equalsIgnoreCase("Date"))
      {
        CompareResult = anyThis.asdValue.compareTo(anyOther.dateValue());
      } else if (anyThis.sType.equalsIgnoreCase("Null"))
      {
        CompareResult = 0;
      } else if (anyThis.sType.indexOf("[]") != -1)
      {
        CompareResult = 0;
        int iSize1 = anyThis.vElementList.size();
        int iSize2 = anyOther.vElementList.size();
        int iSize;
        if (iSize1 >= iSize2) iSize = iSize2; else {
          iSize = iSize1;
        }
        int i = 0;
        while (i < iSize)
        {
          CompareResult = ((Anything)anyThis.vElementList.get(i)).compareTo((Anything)anyOther.vElementList.get(i));
          if (CompareResult != 0) return CompareResult;
          i++;
        }

        if (iSize1 > iSize2) CompareResult = 1;
        else if (iSize1 < iSize2) CompareResult = -1;
      }
    }
    else
    {
      throw new AnythingException("Any: Compare Type not Match:比较类型不匹配！");
    }

    return CompareResult;
  }

  public Anything getCompareResult(Anything anyOther, String sOperator)
    throws Exception
  {
    String sNull = null;
    Anything anyOperateResult = new Anything(this.context, sNull);

    int CompareResult = compareTo(anyOther);
    boolean le;
    boolean e;
    boolean ne;
    boolean lg;
    boolean ge;
    boolean lt;
    if (CompareResult == 0)
    {
      e = true; 
      ne = false;  
      lg = false; 
      ge = true; 
      lt = false; 
      le = true;
    }
    else
    {
      if (CompareResult > 0)
      {
        e = false; 
        ne = true; 
        lg = true; 
        ge = true; 
        lt = false; 
        le = false;
      }
      else {
        e = false; ne = true; lg = false; ge = false; lt = true; le = true;
      }
    }
    if (sOperator.equalsIgnoreCase("=")) anyOperateResult = new Anything(this.context, e);
    else if (sOperator.equalsIgnoreCase("<>")) anyOperateResult = new Anything(this.context, ne);
    else if (sOperator.equalsIgnoreCase(">")) anyOperateResult = new Anything(this.context, lg);
    else if (sOperator.equalsIgnoreCase(">=")) anyOperateResult = new Anything(this.context, ge);
    else if (sOperator.equalsIgnoreCase("<")) anyOperateResult = new Anything(this.context, lt);
    else if (sOperator.equalsIgnoreCase("<=")) anyOperateResult = new Anything(this.context, le);
    return anyOperateResult;
  }

  public static boolean isCompareOperator(String sOperator)
  {
    boolean bResult = false;
    if ((sOperator.equals("=")) || (sOperator.equals("<>")) || (sOperator.equals(">")) || (sOperator.equals(">=")) || (sOperator.equals("<")) || (sOperator.equals("<=")))
      bResult = true;
    return bResult;
  }

  public Anything operateWith(String sOperator)
    throws Exception
  {
    Anything anyOperateResult = null;

    Anything anyThis = this;

    if (this.sType.equalsIgnoreCase("Method")) anyThis = methodValue();

    if (sOperator.equalsIgnoreCase("("))
    {
      anyOperateResult = anyThis;
    }
    else if (sOperator.equalsIgnoreCase("toString("))
    {
      anyOperateResult = new Anything(this.context, "String", anyThis.toStringValue());
    } else if (sOperator.equalsIgnoreCase("toNumber("))
    {
      String sTmp = anyThis.toStringValue();
      if ((sTmp == null) || (sTmp.equals("")) || (sTmp.equalsIgnoreCase("null"))) sTmp = "0"; else {
        try
        {
          Double.parseDouble(sTmp);
        } catch (Exception ex) {
          sTmp = "0";
        }
      }
      anyOperateResult = new Anything(this.context, "Number", sTmp);
    } else if (sOperator.equalsIgnoreCase("toDate("))
    {
      String sTmp = anyThis.toStringValue();

      anyOperateResult = new Anything(this.context, "Date", sTmp);
    }
    else if (anyThis.sType.equalsIgnoreCase("Boolean"))
    {
      if (sOperator.equalsIgnoreCase("not"))
      {
        anyOperateResult = new Anything(this.context, !anyThis.bValue);
      }
      else
        throw new AnythingException("Any: " + sOperator + "运算中，操作数错误！");
    }
    else if (anyThis.sType.equalsIgnoreCase("String"))
    {
      if (sOperator.equalsIgnoreCase("length("))
      {
        anyOperateResult = new Anything(this.context, anyThis.stringValue().length());
      }
      else
        throw new AnythingException("Any: " + sOperator + "运算中，操作数错误！");
    }
    else if (anyThis.sType.indexOf("[]") != -1)
    {
      if (sOperator.equalsIgnoreCase("length("))
      {
        anyOperateResult = new Anything(this.context, anyThis.vElementList.size());
      }
      else {
        throw new AnythingException("Any: " + sOperator + "运算中，操作数错误！");
      }

    }

    return anyOperateResult;
  }

  public Anything operateWith(String sOperator, Anything anyOther)
    throws Exception
  {
    Anything anyOperateResult = null;

    Anything anyThis = this;

    if (this.sType.equalsIgnoreCase("Method")) anyThis = methodValue();
    if (anyOther.sType.equalsIgnoreCase("Method")) anyOther = anyOther.methodValue();

    if (anyThis.sType.equalsIgnoreCase(anyOther.getType()))
    {
      if (anyThis.sType.equalsIgnoreCase("String"))
      {
        if (sOperator.equalsIgnoreCase("+"))
        {
          anyOperateResult = new Anything(this.context, anyThis.sValue + anyOther.stringValue());
        }
        else if (isCompareOperator(sOperator))
        {
          anyOperateResult = anyThis.getCompareResult(anyOther, sOperator);
        }
        else if (sOperator.equalsIgnoreCase("like"))
        {
          anyOperateResult = new Anything(this.context, StringFunction.isLike(anyThis.sValue, anyOther.stringValue()));
        }
        else if (sOperator.equalsIgnoreCase("in"))
        {
          if (anyOther.stringValue().indexOf(anyThis.sValue) >= 0) anyOperateResult = new Anything(this.context, true); else
            anyOperateResult = new Anything(this.context, false);
        } else if (sOperator.equalsIgnoreCase("not in"))
        {
          if (anyOther.stringValue().indexOf(anyThis.sValue) >= 0) anyOperateResult = new Anything(this.context, false); else
            anyOperateResult = new Anything(this.context, true);
        }
        else {
          throw new AnythingException("Any: Operator Error in String Operation: 字符串运算中，运算符错误！");
        }
      }
      else if (anyThis.sType.equalsIgnoreCase("Number"))
      {
        if (sOperator.equalsIgnoreCase("+"))
        {
          anyOperateResult = new Anything(this.context, anyThis.dValue + anyOther.doubleValue());
        } else if (sOperator.equalsIgnoreCase("-"))
        {
          anyOperateResult = new Anything(this.context, anyThis.dValue - anyOther.doubleValue());
        } else if (sOperator.equalsIgnoreCase("*"))
        {
          anyOperateResult = new Anything(this.context, anyThis.dValue * anyOther.doubleValue());
        } else if (sOperator.equalsIgnoreCase("/"))
        {
          if (anyOther.doubleValue() == 0.0D)
          {
            throw new AnythingException("Any:Div by Zero 数值运算中，除数为0！", 2);
          }

          anyOperateResult = new Anything(this.context, anyThis.dValue / anyOther.doubleValue());
        }
        else if (sOperator.equalsIgnoreCase("%"))
        {
          anyOperateResult = new Anything(this.context, anyThis.dValue % anyOther.doubleValue());
        }
        else if (sOperator.equalsIgnoreCase("^"))
        {
          anyOperateResult = new Anything(this.context, Math.pow(anyThis.dValue, anyOther.doubleValue()));
        }
        else if (isCompareOperator(sOperator))
        {
          anyOperateResult = anyThis.getCompareResult(anyOther, sOperator);
        }
        else
        {
          throw new AnythingException("Any: Operator Error in Number Operation :数值运算中，运算符错误！");
        }
      }
      else if (anyThis.sType.equalsIgnoreCase("Boolean"))
      {
        if (sOperator.equalsIgnoreCase("and"))
        {
          anyOperateResult = new Anything(this.context, (anyThis.bValue) && (anyOther.booleanValue()));
        }
        else if (sOperator.equalsIgnoreCase("or"))
        {
          anyOperateResult = new Anything(this.context, (anyThis.bValue) || (anyOther.booleanValue()));
        }
        else if (sOperator.equalsIgnoreCase("="))
        {
          anyOperateResult = new Anything(this.context, anyThis.bValue == anyOther.booleanValue());
        }
        else if (sOperator.equalsIgnoreCase("<>"))
        {
          anyOperateResult = new Anything(this.context, anyThis.bValue != anyOther.booleanValue());
        }
        else
        {
          throw new AnythingException("Any: Operator Error in Boolean Operation :布尔值运算中，运算符" + sOperator + "错误！");
        }
      }
      if (anyThis.sType.equalsIgnoreCase("Date"))
      {
        if (sOperator.equalsIgnoreCase("-"))
        {
          anyOperateResult = new Anything(this.context, anyThis.asdValue.getDifference(anyOther.dateValue()));
        }
        else if (isCompareOperator(sOperator))
        {
          anyOperateResult = anyThis.getCompareResult(anyOther, sOperator);
        }
        else
        {
          throw new AnythingException("Any:Operator Error in Date Operation: 日期运算中，运算符错误！");
        }
      }
      else if (anyThis.sType.indexOf("[]") != -1)
      {
        if (sOperator.equalsIgnoreCase("+"))
        {
          anyThis.vElementList.addAll(anyOther.vElementList);
          anyOperateResult = anyThis;
        } else if (sOperator.equalsIgnoreCase("-"))
        {
          int iSize1 = anyThis.vElementList.size();
          int iSize2 = anyOther.vElementList.size();

          for (int i = 0; i < iSize1; i++)
          {
            Anything anyTemp1 = (Anything)anyThis.vElementList.get(i);
            for (int j = 0; j < iSize2; j++)
            {
              Anything anyTemp2 = (Anything)anyOther.vElementList.get(j);
              if (anyTemp1.compareTo(anyTemp2) != 0)
                continue;
              anyThis.vElementList.remove(i);
              iSize1--;
              i--;
            }
          }

          anyOperateResult = anyThis;
        } else if (sOperator.equalsIgnoreCase("in"))
        {
          boolean bFind = false;
          int iSize = anyOther.vElementList.size();

          for (int i = 0; (i < iSize) && (!bFind); i++)
          {
            Anything anyTemp = (Anything)anyOther.vElementList.get(i);
            if (anyThis.compareTo(anyTemp) != 0) continue; bFind = true;
          }
          anyOperateResult = new Anything(this.context, bFind);
        } else if (isCompareOperator(sOperator))
        {
          anyOperateResult = anyThis.getCompareResult(anyOther, sOperator);
        }
        else
        {
          throw new AnythingException("Any: Operator Error in Array Operation: 数组运算中，运算符错误！");
        }
      } else if (anyThis.sType.equalsIgnoreCase("Null"))
      {
        if ((sOperator.equalsIgnoreCase("=")) || (sOperator.equalsIgnoreCase(">=")) || (sOperator.equalsIgnoreCase("<=")))
        {
          anyOperateResult = new Anything(this.context, true);
        } else if ((sOperator.equalsIgnoreCase("<>")) || (sOperator.equalsIgnoreCase(">")) || (sOperator.equalsIgnoreCase("<")))
        {
          anyOperateResult = new Anything(this.context, false);
        }
        else {
          anyOperateResult = new Anything(this.context, "Null", "");
        }
      }
    }
    else if ((anyThis.sType.equalsIgnoreCase("Date")) && (anyOther.getType().equalsIgnoreCase("Number")))
    {
      LSDate asdResult;
      if (sOperator.equalsIgnoreCase("+"))
      {
        asdResult = anyThis.asdValue.getRelativeDate(anyOther.intValue());
      }
      else if (sOperator.equalsIgnoreCase("-"))
      {
        asdResult = anyThis.asdValue.getRelativeDate(0 - anyOther.intValue());
      }
      else
      {
        throw new AnythingException("Any: Operator Error in Date + Number Operaton:日期运算中，运算符错误！");
      }
      anyOperateResult = new Anything(this.context, asdResult);
    } else if ((anyThis.sType.equalsIgnoreCase("Number")) && (anyOther.getType().equalsIgnoreCase("Date")))
    {
      LSDate asdResult;
      if (sOperator.equalsIgnoreCase("+"))
      {
        asdResult = anyThis.asdValue.getRelativeDate(anyOther.intValue());
      }
      else if (sOperator.equalsIgnoreCase("-"))
      {
        asdResult = anyThis.asdValue.getRelativeDate(0 - anyOther.intValue());
      }
      else
      {
        throw new AnythingException("Any: Operator Error in Number + Date Operaton:日期运算中，运算符错误！");
      }
      anyOperateResult = new Anything(this.context, asdResult);
    } else if (anyOther.getType().indexOf(anyThis.sType) != -1)
    {
      int i = 0;
      boolean blTemp = false;

      int iSize = anyOther.vElementList.size();

      if (sOperator.equalsIgnoreCase("in"))
      {
        while ((i < iSize) && (!blTemp))
        {
          Anything anyTemp = ((Anything)anyOther.vElementList.get(i)).operateWith("=", anyThis);
          blTemp = anyTemp.booleanValue();
          i++;
        }
        anyOperateResult = new Anything(this.context, blTemp);
      }
      else if (sOperator.equalsIgnoreCase("not in"))
      {
        while ((i < iSize) && (!blTemp))
        {
          Anything anyTemp = ((Anything)anyOther.vElementList.get(i)).operateWith("=", anyThis);
          blTemp = anyTemp.booleanValue();
          i++;
        }
        anyOperateResult = new Anything(this.context, !blTemp);
      }
      else
      {
        throw new AnythingException("Any:Error in (not inDate + Number Operaton: 日期运算中，运算符错误！");
      }
    }
    else if ((anyThis.sType.equalsIgnoreCase("Null")) || (anyOther.getType().equalsIgnoreCase("Null")))
    {
      if ((sOperator.equalsIgnoreCase("=")) || (sOperator.equalsIgnoreCase(">=")) || (sOperator.equalsIgnoreCase("<=")) || (sOperator.equalsIgnoreCase("<>")) || (sOperator.equalsIgnoreCase(">")) || (sOperator.equalsIgnoreCase("<")))
      {
        anyOperateResult = new Anything(this.context, false);
      }
      else
        anyOperateResult = new Anything(this.context, "Null", "");
    }
    else
    {
      throw new AnythingException("Any: Type Not Match in Operation:运算中类型不匹配！");
    }
    return anyOperateResult;
  }

  public Anything operateWith(String sOperator, Anything anyOther1, Anything anyOther2)
    throws Exception
  {
    Anything anyThis = this;

    if (this.sType.equalsIgnoreCase("Method")) anyThis = methodValue();
    if (!sOperator.equalsIgnoreCase("if("))
    {
      if (anyOther1.sType.equalsIgnoreCase("Method")) anyOther1 = anyOther1.methodValue();
      if (anyOther2.sType.equalsIgnoreCase("Method")) anyOther2 = anyOther2.methodValue();
    }
    Anything anyOperateResult;
    if ((anyThis.sType.equalsIgnoreCase("Null")) || ((!sOperator.equalsIgnoreCase("if(")) && ((anyOther1.getType().equalsIgnoreCase("Null")) || (anyOther2.getType().equalsIgnoreCase("Null")))))
    {
      anyOperateResult = new Anything(this.context, "Null", "");
    }
    else if (sOperator.equalsIgnoreCase("if("))
    {
      if (anyThis.sType.equalsIgnoreCase("Boolean"))
      {
        if (anyThis.bValue)
        {
          if (anyOther1.getType().equalsIgnoreCase("Method")) anyOther1 = anyOther1.methodValue();
          anyOperateResult = anyOther1;
        }
        else
        {
          if (anyOther2.getType().equalsIgnoreCase("Method")) anyOther2 = anyOther2.methodValue();
          anyOperateResult = anyOther2;
        }
      }
      else {
        throw new AnythingException("Any: Operand Error in IF( Operation:三目运算中，操作数错误！");
      }
    } else if (sOperator.equalsIgnoreCase("substring("))
    {
      if ((anyThis.sType.equalsIgnoreCase("String")) && (anyOther1.getType().equalsIgnoreCase("Number")) && (anyOther2.getType().equalsIgnoreCase("Number")))
      {
        String sTemp = anyThis.stringValue().substring(anyOther1.intValue(), anyOther2.intValue());
        anyOperateResult = new Anything(this.context, sTemp);
      }
      else {
        throw new AnythingException("Any: Operand Error in substring( Operation:三目运算中，操作数错误！");
      }
    } else if (sOperator.equalsIgnoreCase("getSeparate("))
    {
      Vector vTemp = new Vector();

      if (((anyThis.sType.equalsIgnoreCase("String")) || (anyThis.sType.equalsIgnoreCase("String[]"))) && (anyOther1.getType().equalsIgnoreCase("String")) && (anyOther2.getType().equalsIgnoreCase("Number")))
      {
        if (anyThis.sType.equalsIgnoreCase("String"))
        {
          String sTemp = StringFunction.getSeparate(anyThis.stringValue(), anyOther1.stringValue(), anyOther2.intValue());
          anyOperateResult = new Anything(this.context, sTemp);
        }
        else {
          String[] sArray = anyThis.toStringArray();
          for (int i = 0; i < sArray.length; i++)
          {
            String sTemp = StringFunction.getSeparate(sArray[i], anyOther1.stringValue(), anyOther2.intValue());
            Anything anyTemp = new Anything(this.context, sTemp);
            vTemp.addElement(anyTemp);
          }
          anyOperateResult = new Anything(this.context, anyThis.sType, vTemp);
        }
      }
      else
      {
        throw new AnythingException("Any:Operand Error in GetSepatrate( Operation: 三目运算中，操作数错误！");
      }
    }
    else {
      throw new AnythingException("Any: Operator Error in 3 Operand Operation: 三目运算中，运算符错误！");
    }

    return anyOperateResult;
  }

  public Anything operateWith(String sOperator, Anything anyOther1, Anything anyOther2, Anything anyOther3)
    throws Exception
  {
    Vector vTemp = new Vector();

    Anything anyThis = this;

    if (this.sType.equalsIgnoreCase("Method")) anyThis = methodValue();
    if (anyOther1.sType.equalsIgnoreCase("Method")) anyOther1 = anyOther1.methodValue();
    if (anyOther2.sType.equalsIgnoreCase("Method")) anyOther2 = anyOther2.methodValue();
    if (anyOther3.sType.equalsIgnoreCase("Method")) anyOther3 = anyOther3.methodValue();
    Anything anyOperateResult;
    if ((anyThis.sType.equalsIgnoreCase("Null")) || (anyOther1.getType().equalsIgnoreCase("Null")) || (anyOther2.getType().equalsIgnoreCase("Null")) || (anyOther3.getType().equalsIgnoreCase("Null")))
    {
      anyOperateResult = new Anything(this.context, "Null", "");
    }
    else if (sOperator.equalsIgnoreCase("toStringArray("))
    {
      if ((anyThis.sType.equalsIgnoreCase("String")) && (anyOther1.getType().equalsIgnoreCase("String")) && (anyOther2.getType().equalsIgnoreCase("String")) && (anyOther3.getType().equalsIgnoreCase("Number")))
      {
        String[] sArray = StringFunction.toStringArray(anyThis.stringValue(), anyOther1.stringValue(), anyOther2.stringValue(), anyOther3.intValue());
        for (int i = 0; i < sArray.length; i++)
        {
          Anything anyTemp = new Anything(this.context, sArray[i]);
          vTemp.addElement(anyTemp);
        }
        anyOperateResult = new Anything(this.context, "String[]", vTemp);
      }
      else {
        throw new AnythingException("Any:Operand Error in toStringArray() :四目运算中，操作数错误！");
      }
    }
    else {
      throw new AnythingException("Any: Operantor Error in toStringArray():四目运算中，运算符错误！");
    }

    return anyOperateResult;
  }

  public String getType()
  {
    return this.sType;
  }

  public double doubleValue() throws AnythingException
  {
    if (this.sType.equalsIgnoreCase("Number"))
    {
      return this.dValue;
    }if (this.sType.equalsIgnoreCase("Null"))
    {
      return 0.0D;
    }

    throw new AnythingException("Any: 取值类型不是double！");
  }

  public int intValue()
    throws AnythingException
  {
    if (this.sType.equalsIgnoreCase("Number"))
    {
      return new Double(this.dValue).intValue();
    }if (this.sType.equalsIgnoreCase("Null"))
    {
      return 0;
    }

    throw new AnythingException("Any: 取值类型不是int！");
  }

  public String stringValue()
    throws AnythingException
  {
    if (this.sType.equalsIgnoreCase("String"))
    {
      return this.sValue;
    }if (this.sType.equalsIgnoreCase("Method"))
    {
      return this.sValue;
    }if (this.sType.equalsIgnoreCase("Null"))
    {
      return "";
    }

    throw new AnythingException("Any: 取值类型不是String！");
  }

  public Anything methodValue()
    throws Exception
  {
    if (this.sType.equalsIgnoreCase("Method"))
    {
      return AmarMethod.executeMethod(stringValue(), this.context, this.Sqlca);
    }

    throw new AnythingException("Any: 取值类型不是Method！");
  }

  public boolean booleanValue() throws AnythingException
  {
    if (this.sType.equalsIgnoreCase("Boolean"))
    {
      return this.bValue;
    }

    throw new AnythingException("Any: 取值类型不是boolean！");
  }

  public LSDate dateValue()
    throws AnythingException
  {
    if (this.sType.equalsIgnoreCase("Date"))
    {
      return this.asdValue;
    }

    throw new AnythingException("Any: 取值类型不是Date！");
  }

  public String toString()
  {
    String sReturnValue = null;
    if (this.sType.equalsIgnoreCase("String"))
    {
      sReturnValue = this.sValue;
    }
    else if (this.sType.equalsIgnoreCase("Number"))
    {
      sReturnValue = String.valueOf(this.dValue);
    }
    else if (this.sType.equalsIgnoreCase("Boolean"))
    {
      sReturnValue = String.valueOf(this.bValue);
    } else if (this.sType.equalsIgnoreCase("Date"))
    {
      sReturnValue = "[" + this.asdValue.toString() + "]";
    }
    if (this.sType.equalsIgnoreCase("Method"))
    {
      sReturnValue = this.sValue;
    }
    else if (this.sType.indexOf("[]") != -1)
    {
      sReturnValue = "{";
      int iSize = this.vElementList.size();
      for (int i = 0; i < iSize; i++)
      {
        if (this.sType.indexOf("String") >= 0)
          sReturnValue = sReturnValue + "'" + this.vElementList.get(i).toString() + "',";
        else {
          sReturnValue = sReturnValue + this.vElementList.get(i).toString() + ",";
        }
      }
      if (sReturnValue.length() > 1) sReturnValue = sReturnValue.substring(0, sReturnValue.length() - 1);
      sReturnValue = sReturnValue + "}";
    }
    else if (this.sType.equalsIgnoreCase("Null"))
    {
      sReturnValue = "Null";
    }

    if (sReturnValue == null) sReturnValue = "";
    return sReturnValue;
  }

  public String toStringValue()
  {
    String sReturnValue = null;
    if (this.sType.equalsIgnoreCase("String"))
    {
      sReturnValue = this.sValue;
    }
    else if (this.sType.equalsIgnoreCase("Number"))
    {
      sReturnValue = String.valueOf(this.dValue);
    }
    else if (this.sType.equalsIgnoreCase("Boolean"))
    {
      sReturnValue = String.valueOf(this.bValue);
    } else if (this.sType.equalsIgnoreCase("Date"))
    {
      sReturnValue = this.asdValue.toString();
    }
    if (this.sType.equalsIgnoreCase("Method"))
    {
      sReturnValue = this.sValue;
    }
    else if (this.sType.indexOf("[]") != -1)
    {
      sReturnValue = "{";
      int iSize = this.vElementList.size();

      for (int i = 0; i < iSize; i++) sReturnValue = sReturnValue + ((Anything)this.vElementList.get(i)).toString() + ",";
      if (sReturnValue.length() > 1) sReturnValue = sReturnValue.substring(0, sReturnValue.length() - 1);
      sReturnValue = sReturnValue + "}";
    }
    else if (this.sType.equalsIgnoreCase("Null"))
    {
      sReturnValue = "Null";
    }

    if (sReturnValue == null) sReturnValue = "";
    return sReturnValue;
  }

  public String[] toStringArray()
    throws Exception
  {
    String[] sArray;
    if (this.sType.indexOf("[]") != -1)
    {
      int iSize = this.vElementList.size();
      sArray = new String[iSize];
      for (int i = 0; i < iSize; i++) {
        sArray[i] = String.valueOf(this.vElementList.get(i));
      }
    }
    else if (this.sType.equalsIgnoreCase("Null"))
    {
      sArray = null;
    }
    else {
      throw new AnythingException("Any: 值类型不是Array！");
    }
    return sArray;
  }
}