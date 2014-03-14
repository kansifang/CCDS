package com.lmt.frameapp.script;

import java.util.Vector;

import com.lmt.app.cms.explain.ASMethod;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.sql.Transaction;

public class Any
{
  private String sType;
  private String sValue;
  private double dValue;
  private boolean bValue;
  private LSDate asdValue;
  private Vector vElementList;
  private Transaction Sqlca;

  public Any(String Type, String Value)
    throws Exception
  {
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
      throw new AnyException("Any Constructor:无法识别的类型");
    }
  }

  public Any(String Value, Transaction transSql) throws Exception
  {
    this.sType = "Method";
    this.Sqlca = transSql;
    if (Value == null) this.sType = "Null"; else
      this.sValue = Value;
  }

  public Any(String Type, Vector ElementList)
  {
    this.sType = Type;
    this.vElementList = ElementList;
  }

  public Any(byte Value)
  {
    this.sType = "Number";
    this.dValue = Value;
  }

  public Any(short Value)
  {
    this.sType = "Number";
    this.dValue = Value;
  }

  public Any(int Value)
  {
    this.sType = "Number";
    this.dValue = Value;
  }

  public Any(long Value)
  {
    this.sType = "Number";
    this.dValue = Value;
  }

  public Any(float Value)
  {
    this.sType = "Number";
    this.dValue = Value;
  }

  public Any(double Value)
  {
    this.sType = "Number";
    this.dValue = Value;
  }

  public Any(boolean Value)
  {
    this.sType = "Boolean";
    this.bValue = Value;
  }

  public Any(String Value)
  {
    if (Value == null) { this.sType = "Null";
    } else
    {
      this.sType = "String";
      this.sValue = Value;
    }
  }

  public Any(LSDate Value)
  {
    this.sType = "Date";
    this.asdValue = Value;
  }

  public int compareTo(Any anyOther)
    throws Exception
  {
    int CompareResult = 0;

    Any anyThis = this;

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
          CompareResult = ((Any)anyThis.vElementList.get(i)).compareTo((Any)anyOther.vElementList.get(i));
          if (CompareResult != 0) return CompareResult;
          i++;
        }

        if (iSize1 > iSize2) CompareResult = 1;
        else if (iSize1 < iSize2) CompareResult = -1;
      }
    }
    else
    {
      throw new AnyException("Any: Compare Type not Match:比较类型不匹配！");
    }

    return CompareResult;
  }

  public Any getCompareResult(Any anyOther, String sOperator)
    throws Exception
  {
    String sNull = null;
    Any anyOperateResult = new Any(sNull);

    int CompareResult = compareTo(anyOther);
    boolean le;
    boolean e;
    boolean ne;
    boolean lg;
    boolean ge;
    boolean lt;
    if (CompareResult == 0)
    {
       e = true;  ne = false;  lg = false;  ge = true;  lt = false; le = true;
    }
    else
    {
      if (CompareResult > 0)
      {
         e = false;  ne = true;  lg = true;  ge = true;  lt = false; le = false;
      }
      else {
        e = false; ne = true; lg = false; ge = false; lt = true; le = true;
      }
    }
    if (sOperator.equalsIgnoreCase("=")) anyOperateResult = new Any(e);
    else if (sOperator.equalsIgnoreCase("<>")) anyOperateResult = new Any(ne);
    else if (sOperator.equalsIgnoreCase(">")) anyOperateResult = new Any(lg);
    else if (sOperator.equalsIgnoreCase(">=")) anyOperateResult = new Any(ge);
    else if (sOperator.equalsIgnoreCase("<")) anyOperateResult = new Any(lt);
    else if (sOperator.equalsIgnoreCase("<=")) anyOperateResult = new Any(le);
    return anyOperateResult;
  }

  public static boolean isCompareOperator(String sOperator)
  {
    boolean bResult = false;
    if ((sOperator.equals("=")) || (sOperator.equals("<>")) || (sOperator.equals(">")) || (sOperator.equals(">=")) || (sOperator.equals("<")) || (sOperator.equals("<=")))
      bResult = true;
    return bResult;
  }

  public Any operateWith(String sOperator)
    throws Exception
  {
    Any anyOperateResult = null;

    Any anyThis = this;

    if (this.sType.equalsIgnoreCase("Method")) 
    	anyThis = methodValue();
    if (sOperator.equalsIgnoreCase("("))
    {
      anyOperateResult = anyThis;
    }
    else if (sOperator.equalsIgnoreCase("toString("))
    {
      anyOperateResult = new Any("String", anyThis.toStringValue());
    }else if (anyThis.sType.equalsIgnoreCase("Boolean")){
      if (sOperator.equalsIgnoreCase("not")){
        anyOperateResult = new Any(!anyThis.bValue);
      }else
        throw new AnyException("Any: " + sOperator + "运算中，操作数错误！");
    }
    else if (anyThis.sType.equalsIgnoreCase("String"))
    {
      if (sOperator.equalsIgnoreCase("length("))
      {
        anyOperateResult = new Any(anyThis.stringValue().length());
      }
      else
        throw new AnyException("Any: " + sOperator + "运算中，操作数错误！");
    }
    else if (anyThis.sType.indexOf("[]") != -1)
    {
      if (sOperator.equalsIgnoreCase("length("))
      {
        anyOperateResult = new Any(anyThis.vElementList.size());
      }
      else {
        throw new AnyException("Any: " + sOperator + "运算中，操作数错误！");
      }

    }

    return anyOperateResult;
  }

  public Any operateWith(String sOperator, Any anyOther)
    throws Exception
  {
    Any anyOperateResult = null;

    Any anyThis = this;

    if (this.sType.equalsIgnoreCase("Method"))
    	anyThis = methodValue();
    if (anyOther.sType.equalsIgnoreCase("Method")) 
    	anyOther = anyOther.methodValue();

    if (anyThis.sType.equalsIgnoreCase(anyOther.getType()))
    {
      if (anyThis.sType.equalsIgnoreCase("String"))
      {
        if (sOperator.equalsIgnoreCase("+"))
        {
          anyOperateResult = new Any(anyThis.sValue + anyOther.stringValue());
        }
        else if (isCompareOperator(sOperator))
        {
          anyOperateResult = anyThis.getCompareResult(anyOther, sOperator);
        }
        else if (sOperator.equalsIgnoreCase("like"))
        {
          anyOperateResult = new Any(StringFunction.isLike(anyThis.sValue, anyOther.stringValue()));
        }
        else if (sOperator.equalsIgnoreCase("in"))
        {
          if (anyOther.stringValue().indexOf(anyThis.sValue) >= 0) anyOperateResult = new Any(true); else
            anyOperateResult = new Any(false);
        } else if (sOperator.equalsIgnoreCase("not in"))
        {
          if (anyOther.stringValue().indexOf(anyThis.sValue) >= 0) anyOperateResult = new Any(false); else
            anyOperateResult = new Any(true);
        }
        else {
          throw new AnyException("Any: Operator Error in String Operation: 字符串运算中，运算符错误！");
        }
      }
      else if (anyThis.sType.equalsIgnoreCase("Number"))
      {
        if (sOperator.equalsIgnoreCase("+"))
        {
          anyOperateResult = new Any(anyThis.dValue + anyOther.doubleValue());
        } else if (sOperator.equalsIgnoreCase("-"))
        {
          anyOperateResult = new Any(anyThis.dValue - anyOther.doubleValue());
        } else if (sOperator.equalsIgnoreCase("*"))
        {
          anyOperateResult = new Any(anyThis.dValue * anyOther.doubleValue());
        } else if (sOperator.equalsIgnoreCase("/"))
        {
          if (anyOther.doubleValue() == 0.0D)
          {
            throw new AnyException("Any:Div by Zero 数值运算中，除数为0！", 2);
          }

          anyOperateResult = new Any(anyThis.dValue / anyOther.doubleValue());
        }
        else if (sOperator.equalsIgnoreCase("%"))
        {
          anyOperateResult = new Any(anyThis.dValue % anyOther.doubleValue());
        }
        else if (sOperator.equalsIgnoreCase("^"))
        {
          anyOperateResult = new Any(Math.pow(anyThis.dValue, anyOther.doubleValue()));
        }
        else if (isCompareOperator(sOperator))
        {
          anyOperateResult = anyThis.getCompareResult(anyOther, sOperator);
        }
        else
        {
          throw new AnyException("Any: Operator Error in Number Operation :数值运算中，运算符错误！");
        }
      }
      else if (anyThis.sType.equalsIgnoreCase("Boolean"))
      {
        if (sOperator.equalsIgnoreCase("and"))
        {
          anyOperateResult = new Any((anyThis.bValue) && (anyOther.booleanValue()));
        }
        else if (sOperator.equalsIgnoreCase("or"))
        {
          anyOperateResult = new Any((anyThis.bValue) || (anyOther.booleanValue()));
        }
        else if (sOperator.equalsIgnoreCase("="))
        {
          anyOperateResult = new Any(anyThis.bValue == anyOther.booleanValue());
        }
        else if (sOperator.equalsIgnoreCase("<>"))
        {
          anyOperateResult = new Any(anyThis.bValue != anyOther.booleanValue());
        }
        else
        {
          throw new AnyException("Any: Operator Error in Boolean Operation :布尔值运算中，运算符" + sOperator + "错误！");
        }
      }
      if (anyThis.sType.equalsIgnoreCase("Date"))
      {
        if (sOperator.equalsIgnoreCase("-"))
        {
          anyOperateResult = new Any(anyThis.asdValue.getDifference(anyOther.dateValue()));
        }
        else if (isCompareOperator(sOperator))
        {
          anyOperateResult = anyThis.getCompareResult(anyOther, sOperator);
        }
        else
        {
          throw new AnyException("Any:Operator Error in Date Operation: 日期运算中，运算符错误！");
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
            Any anyTemp1 = (Any)anyThis.vElementList.get(i);
            for (int j = 0; j < iSize2; j++)
            {
              Any anyTemp2 = (Any)anyOther.vElementList.get(j);
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
            Any anyTemp = (Any)anyOther.vElementList.get(i);
            if (anyThis.compareTo(anyTemp) != 0) continue; bFind = true;
          }
          anyOperateResult = new Any(bFind);
        } else if (isCompareOperator(sOperator))
        {
          anyOperateResult = anyThis.getCompareResult(anyOther, sOperator);
        }
        else
        {
          throw new AnyException("Any: Operator Error in Array Operation: 数组运算中，运算符错误！");
        }
      } else if (anyThis.sType.equalsIgnoreCase("Null"))
      {
        if ((sOperator.equalsIgnoreCase("=")) || (sOperator.equalsIgnoreCase(">=")) || (sOperator.equalsIgnoreCase("<=")))
        {
          anyOperateResult = new Any(true);
        } else if ((sOperator.equalsIgnoreCase("<>")) || (sOperator.equalsIgnoreCase(">")) || (sOperator.equalsIgnoreCase("<")))
        {
          anyOperateResult = new Any(false);
        }
        else {
          anyOperateResult = new Any("Null", "");
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
        throw new AnyException("Any: Operator Error in Date + Number Operaton:日期运算中，运算符错误！");
      }
      anyOperateResult = new Any(asdResult);
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
        throw new AnyException("Any: Operator Error in Number + Date Operaton:日期运算中，运算符错误！");
      }
      anyOperateResult = new Any(asdResult);
    } else if (anyOther.getType().indexOf(anyThis.sType) != -1)
    {
      int i = 0;
      boolean blTemp = false;

      int iSize = anyOther.vElementList.size();

      if (sOperator.equalsIgnoreCase("in"))
      {
        while ((i < iSize) && (!blTemp))
        {
          Any anyTemp = ((Any)anyOther.vElementList.get(i)).operateWith("=", anyThis);
          blTemp = anyTemp.booleanValue();
          i++;
        }
        anyOperateResult = new Any(blTemp);
      }
      else if (sOperator.equalsIgnoreCase("not in"))
      {
        while ((i < iSize) && (!blTemp))
        {
          Any anyTemp = ((Any)anyOther.vElementList.get(i)).operateWith("=", anyThis);
          blTemp = anyTemp.booleanValue();
          i++;
        }
        anyOperateResult = new Any(!blTemp);
      }
      else
      {
        throw new AnyException("Any:Error in (not inDate + Number Operaton: 日期运算中，运算符错误！");
      }
    }
    else if ((anyThis.sType.equalsIgnoreCase("Null")) || (anyOther.getType().equalsIgnoreCase("Null")))
    {
      if ((sOperator.equalsIgnoreCase("=")) || (sOperator.equalsIgnoreCase(">=")) || (sOperator.equalsIgnoreCase("<=")) || (sOperator.equalsIgnoreCase("<>")) || (sOperator.equalsIgnoreCase(">")) || (sOperator.equalsIgnoreCase("<")))
      {
        anyOperateResult = new Any(false);
      }
      else
        anyOperateResult = new Any("Null", "");
    }
    else
    {
      throw new AnyException("Any: Type Not Match in Operation:运算中类型不匹配！");
    }
    return anyOperateResult;
  }

  public Any operateWith(String sOperator, Any anyOther1, Any anyOther2)
    throws Exception
  {
    Any anyThis = this;

    if (this.sType.equalsIgnoreCase("Method")) anyThis = methodValue();
    if (!sOperator.equalsIgnoreCase("if("))
    {
      if (anyOther1.sType.equalsIgnoreCase("Method")) anyOther1 = anyOther1.methodValue();
      if (anyOther2.sType.equalsIgnoreCase("Method")) anyOther2 = anyOther2.methodValue();
    }
    Any anyOperateResult;
    if ((anyThis.sType.equalsIgnoreCase("Null")) || ((!sOperator.equalsIgnoreCase("if(")) && ((anyOther1.getType().equalsIgnoreCase("Null")) || (anyOther2.getType().equalsIgnoreCase("Null")))))
    {
      anyOperateResult = new Any("Null", "");
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
        throw new AnyException("Any: Operand Error in IF( Operation:三目运算中，操作数错误！");
      }
    } else if (sOperator.equalsIgnoreCase("substring("))
    {
      if ((anyThis.sType.equalsIgnoreCase("String")) && (anyOther1.getType().equalsIgnoreCase("Number")) && (anyOther2.getType().equalsIgnoreCase("Number")))
      {
        String sTemp = anyThis.stringValue().substring(anyOther1.intValue(), anyOther2.intValue());
        anyOperateResult = new Any(sTemp);
      }
      else {
        throw new AnyException("Any: Operand Error in substring( Operation:三目运算中，操作数错误！");
      }
    } else if (sOperator.equalsIgnoreCase("getSeparate("))
    {
      Vector vTemp = new Vector();

      if (((anyThis.sType.equalsIgnoreCase("String")) || (anyThis.sType.equalsIgnoreCase("String[]"))) && (anyOther1.getType().equalsIgnoreCase("String")) && (anyOther2.getType().equalsIgnoreCase("Number")))
      {
        if (anyThis.sType.equalsIgnoreCase("String"))
        {
          String sTemp = StringFunction.getSeparate(anyThis.stringValue(), anyOther1.stringValue(), anyOther2.intValue());
          anyOperateResult = new Any(sTemp);
        }
        else {
          String[] sArray = anyThis.toStringArray();
          for (int i = 0; i < sArray.length; i++)
          {
            String sTemp = StringFunction.getSeparate(sArray[i], anyOther1.stringValue(), anyOther2.intValue());
            Any anyTemp = new Any(sTemp);
            vTemp.addElement(anyTemp);
          }
          anyOperateResult = new Any(anyThis.sType, vTemp);
        }
      }
      else
      {
        throw new AnyException("Any:Operand Error in GetSepatrate( Operation: 三目运算中，操作数错误！");
      }
    }
    else {
      throw new AnyException("Any: Operator Error in 3 Operand Operation: 三目运算中，运算符错误！");
    }

    return anyOperateResult;
  }

  public Any operateWith(String sOperator, Any anyOther1, Any anyOther2, Any anyOther3)
    throws Exception
  {
    Vector vTemp = new Vector();

    Any anyThis = this;

    if (this.sType.equalsIgnoreCase("Method")) anyThis = methodValue();
    if (anyOther1.sType.equalsIgnoreCase("Method")) anyOther1 = anyOther1.methodValue();
    if (anyOther2.sType.equalsIgnoreCase("Method")) anyOther2 = anyOther2.methodValue();
    if (anyOther3.sType.equalsIgnoreCase("Method")) anyOther3 = anyOther3.methodValue();
    Any anyOperateResult;
    if ((anyThis.sType.equalsIgnoreCase("Null")) || (anyOther1.getType().equalsIgnoreCase("Null")) || (anyOther2.getType().equalsIgnoreCase("Null")) || (anyOther3.getType().equalsIgnoreCase("Null")))
    {
      anyOperateResult = new Any("Null", "");
    }
    else if (sOperator.equalsIgnoreCase("toStringArray("))
    {
      if ((anyThis.sType.equalsIgnoreCase("String")) && (anyOther1.getType().equalsIgnoreCase("String")) && (anyOther2.getType().equalsIgnoreCase("String")) && (anyOther3.getType().equalsIgnoreCase("Number")))
      {
        String[] sArray = StringFunction.toStringArray(anyThis.stringValue(), anyOther1.stringValue(), anyOther2.stringValue(), anyOther3.intValue());
        for (int i = 0; i < sArray.length; i++)
        {
          Any anyTemp = new Any(sArray[i]);
          vTemp.addElement(anyTemp);
        }
        anyOperateResult = new Any("String[]", vTemp);
      }
      else {
        throw new AnyException("Any:Operand Error in toStringArray() :四目运算中，操作数错误！");
      }
    }
    else {
      throw new AnyException("Any: Operantor Error in toStringArray():四目运算中，运算符错误！");
    }

    return anyOperateResult;
  }

  public String getType()
  {
    return this.sType;
  }

  public double doubleValue() throws AnyException
  {
    if (this.sType.equalsIgnoreCase("Number"))
    {
      return this.dValue;
    }if (this.sType.equalsIgnoreCase("Null"))
    {
      return 0.0D;
    }

    throw new AnyException("Any: 取值类型不是double！");
  }

  public int intValue()
    throws AnyException
  {
    if (this.sType.equalsIgnoreCase("Number"))
    {
      return new Double(this.dValue).intValue();
    }if (this.sType.equalsIgnoreCase("Null"))
    {
      return 0;
    }

    throw new AnyException("Any: 取值类型不是int！");
  }

  public String stringValue()
    throws AnyException
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

    throw new AnyException("Any: 取值类型不是String！");
  }

  public Any methodValue()
    throws Exception
  {
    if (this.sType.equalsIgnoreCase("Method"))
    {
      return ASMethod.executeMethod(stringValue(), this.Sqlca);
    }

    throw new AnyException("Any: 取值类型不是Method！");
  }

  public boolean booleanValue() throws AnyException
  {
    if (this.sType.equalsIgnoreCase("Boolean"))
    {
      return this.bValue;
    }

    throw new AnyException("Any: 取值类型不是boolean！");
  }

  public LSDate dateValue()
    throws AnyException
  {
    if (this.sType.equalsIgnoreCase("Date"))
    {
      return this.asdValue;
    }

    throw new AnyException("Any: 取值类型不是Date！");
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

      for (int i = 0; i < iSize; i++) sReturnValue = sReturnValue + ((Any)this.vElementList.get(i)).toString() + ",";
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
      for (int i = 0; i < iSize; i++) sArray[i] = ((Any)this.vElementList.get(i)).toStringValue();
    }
    else if (this.sType.equalsIgnoreCase("Null"))
    {
      sArray = null;
    }
    else {
      throw new AnyException("Any: 值类型不是Array！");
    }
    return sArray;
  }
}