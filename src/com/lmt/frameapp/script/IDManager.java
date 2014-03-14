package com.lmt.frameapp.script;

import java.util.Calendar;

import com.lmt.baseapp.util.StringFunction;

public class IDManager
{
  private static String[] sIDName = { "������", "�����", "�����", "�����", "�����", "������", "������", "����", "����", "����", "������", "����", "�ָ���", "������", "������", "������", "������", "���鿪ʼ", "�������", "�ⲿ����" };

  private static String[] sIDAttribute = { "Number", "˫Ŀ", "˫Ŀ", "˫Ŀ", "��Ŀ", "Boolean", "��Ŀ", "��Ŀ", "��Ŀ", "��Ŀ", "������", "����", "�ָ���", "String", "Date", "�޲κ���", "Null", "���鿪ʼ", "�������", "�ⲿ����" };

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

        if (idFind.Name.equalsIgnoreCase("�����"))
        {
          idFind.Order = getOperatorOrder(sHeader);
        }

        if (idFind.Attribute.equalsIgnoreCase("String"))
        {
          int iStringEnd = sExpression.indexOf(sHeader, iStartPos + 1);
          if (iStringEnd == -1)
          {
            throw new IDException("�ַ����Ͳ���������ʱ����(IDManager): �ַ������岻����!���������Ƿ���ԡ�");
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
            throw new IDException("�����Ͳ���������ʱ����(IDManager):�ַ������岻����!�����������Ƿ���ԡ�");
          }

          idFind.Content = sExpression.substring(iStartPos, iStringEnd + 1);

          idFind.Value = idFind.Content.substring(1, idFind.Content.length() - 1);
        }
        else if (idFind.Attribute.equalsIgnoreCase("�޲κ���"))
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
        } else if (idFind.Attribute.equalsIgnoreCase("�ⲿ����"))
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