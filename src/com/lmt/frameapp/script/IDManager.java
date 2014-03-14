package com.lmt.frameapp.script;

import java.util.Calendar;

import com.lmt.baseapp.util.StringFunction;

public class IDManager
{
  private static String[] sIDName = { "操作数", "运算符", "运算符", "运算符", "运算符", "操作数", "左括号", "函数", "函数", "函数", "右括号", "忽略", "分隔符", "操作数", "操作数", "操作数", "操作数", "数组开始", "数组结束", "外部函数" };

  private static String[] sIDAttribute = { "Number", "双目", "双目", "双目", "单目", "Boolean", "单目", "三目", "四目", "单目", "右括号", "忽略", "分隔符", "String", "Date", "无参函数", "Null", "数组开始", "数组结束", "外部函数" };

  private static String[][] sIDHeader = { 
			  							{ "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", ".", "E-", "E" }, 
			  							{ "+", "-", "*", "/", "%", "^" }, 
			  							{ "<>", ">=", "<=", "=", ">", "<", "like", "in", "not in" },
			  							{ "and", "or" },
			  							{ "not" }, 
			  							{ "true", "false" }, 
			  							{ "(" }, 
			  							{ "if(", "substring(", "getseparate(" }, 
			  							{ "toStringArray(" }, 
			  							{ "length(", "toString(", "toNumber(", "toDate(" }, 
			  							{ ")" }, 
			  							{ " ", "\n", "\r" },
			  							{ "," },
			  							{ "'", String.valueOf('"') },
			  							{ "[" }, 
			  							{ "Today()", "Year()", "Month()", "Day()" }, 
			  							{ "Null" },
			  							{ "{" }, 
			  							{ "}" }, 
			  							{ "!" } 
	  							};

  public static ID getID(String sExpression, int iStartPos)
    throws Exception
  {
    ID idFind = new ID("", "", "", "", 0);

    for (int i = 0; i < sIDHeader.length; i++) {
      for (int j = 0; j < sIDHeader[i].length; j++)
      {
        int iHeaderLength = sIDHeader[i][j].length();
        String sHeader = sIDHeader[i][j];

        if (sExpression.length() < iHeaderLength + iStartPos)
          continue;
        if (!sExpression.substring(iStartPos, iStartPos + iHeaderLength).equalsIgnoreCase(sHeader))
          continue;
        idFind.Name = sIDName[i];
        idFind.Attribute = sIDAttribute[i];

        if (idFind.Name.equalsIgnoreCase("运算符"))
        {
          idFind.Order = getOperatorOrder(sHeader);
        }

        if (idFind.Attribute.equalsIgnoreCase("String"))
        {
          int iStringEnd = sExpression.indexOf(sHeader, iStartPos + 1);
          if (iStringEnd == -1)
          {
            throw new IDException("字符串型操作数解析时错误(IDManager): 字符串定义不完整!请检查引号是否配对。");
          }

          idFind.Content = sExpression.substring(iStartPos, iStringEnd + 1);

          idFind.Value = idFind.Content.substring(1, idFind.Content.length() - 1);
        }
        else if (idFind.Attribute.equalsIgnoreCase("Number"))
        {
          ID idNext = getID(sExpression, iStartPos + sHeader.length());
          if (idNext.Attribute.equalsIgnoreCase(idFind.Attribute))
          {
            idFind.Value = (sHeader + idNext.Value);
            idFind.Content = (sHeader + idNext.Content);
          }
          else {
            idFind.Value = sHeader;
            idFind.Content = sHeader;
          }
        } else if (idFind.Attribute.equalsIgnoreCase("Date"))
        {
          int iStringEnd = sExpression.indexOf("]", iStartPos + 1);
          if (iStringEnd == -1)
          {
            throw new IDException("日期型操作数解析时错误(IDManager):字符串定义不完整!请检查中括号是否配对。");
          }

          idFind.Content = sExpression.substring(iStartPos, iStringEnd + 1);

          idFind.Value = idFind.Content.substring(1, idFind.Content.length() - 1);
        }
        else if (idFind.Attribute.equalsIgnoreCase("无参函数"))
        {
          idFind.Content = sHeader;
          if (idFind.Content.equalsIgnoreCase("Today()"))
          {
            idFind.Attribute = "Date";
            idFind.Value = StringFunction.getToday("/");
          } else if (idFind.Content.equalsIgnoreCase("Year()"))
          {
            idFind.Attribute = "Number";
            idFind.Value = String.valueOf(Calendar.getInstance().get(1) + 1900);
          } else if (idFind.Content.equalsIgnoreCase("Month()"))
          {
            idFind.Attribute = "Number";
            idFind.Value = String.valueOf(Calendar.getInstance().get(2) + 1);
          } else if (idFind.Content.equalsIgnoreCase("Day()"))
          {
            idFind.Attribute = "Number";
            idFind.Value = String.valueOf(Calendar.getInstance().get(5));
          }
        } else if (idFind.Attribute.equalsIgnoreCase("外部函数"))
        {
          int iEnd = StringFunction.indexOf(sExpression, ")", "'", "'", iStartPos);
          idFind.Content = sExpression.substring(iStartPos, iEnd + 1);
          idFind.Value = idFind.Content;
        }
        else
        {
          idFind.Value = sHeader;
          idFind.Content = sHeader;
        }
        return idFind;
      }

    }

    return idFind;
  }

  static int getOperatorOrder(String sOperator)
  {
    String[] sOperatorList = { "+", "-", "*", "/", "%", "^", "<>", ">=", "<=", ">", "<", "=", "like", "in", "not in", "or", "and", "not", "if(", "substring(", "getSeparate(", "length(", "toString(", "toNumber(", "toDate(" };
    int[] iOperatorOrder = { 15, 15, 20, 20, 20, 25, 10, 10, 10, 10, 10, 10, 10, 10, 10, 6, 7, 8, 5, 5, 5, 5, 5, 5, 5 };
    int iOrder = 0;

    for (int i = 0; i < sOperatorList.length; i++)
    {
      if (!sOperator.equalsIgnoreCase(sOperatorList[i]))
        continue;
      iOrder = iOperatorOrder[i];
      return iOrder;
    }

    return iOrder;
  }
}