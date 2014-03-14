package com.lmt.frameapp.script;

import java.sql.Date;
import java.util.Calendar;
import java.util.StringTokenizer;

import com.lmt.baseapp.util.StringFunction;

public class LSDate
{
  public Date Value;
  public String Type = "YMD";

  public LSDate(long lDate) throws Exception
  {
    this.Value = new Date(lDate);
  }

  public LSDate(int iYear, int iMonth, int iDay) throws Exception
  {
    Calendar cal = Calendar.getInstance();
    cal.set(iYear, iMonth - 1, iDay);
    this.Value = new Date(cal.getTimeInMillis());
  }

  public LSDate(String sValue)
    throws Exception
  {
    StringTokenizer st = new StringTokenizer(sValue.trim(), "/-. :");
    int iDay;
    int iYear;
    int iMonth;
    if (st.countTokens() == 3)
    {
      iYear = Integer.valueOf(st.nextToken()).intValue();
      iMonth = Integer.valueOf(st.nextToken()).intValue();
      iDay = Integer.valueOf(st.nextToken()).intValue();
    }
    else
    {
      if (st.countTokens() == 2)
      {
        this.Type = "YM";
        iYear = Integer.valueOf(st.nextToken()).intValue();
        iMonth = Integer.valueOf(st.nextToken()).intValue();
        iDay = 1;
      }
      else
      {
        if (sValue.length() == 8)
        {
          iYear = Integer.valueOf(sValue.substring(0, 4)).intValue();
          iMonth = Integer.valueOf(sValue.substring(4, 6)).intValue();
          iDay = Integer.valueOf(sValue.substring(6, 8)).intValue();
        }
        else
        {
          if (sValue.length() == 6)
          {
            this.Type = "YM";
            iYear = Integer.valueOf(sValue.substring(0, 4)).intValue();
            iMonth = Integer.valueOf(sValue.substring(4, 6)).intValue();
            iDay = 1;
          } else if (sValue.length() == 19)
          {
            iYear = Integer.valueOf(sValue.substring(0, 4)).intValue();
            iMonth = Integer.valueOf(sValue.substring(5, 7)).intValue();
            iDay = Integer.valueOf(sValue.substring(8, 10)).intValue();
          }
          else {
            throw new LSDateException("ASDate Constructor :String Format Error");
          }
        }
      }
    }
    Calendar cal = Calendar.getInstance();
    cal.set(iYear, iMonth - 1, iDay);
    this.Value = new Date(cal.getTimeInMillis());
  }

  public int compareTo(Date dateValue)
  {
    return this.Value.compareTo(dateValue);
  }

  public int compareTo(LSDate asdValue)
  {
    return this.Value.compareTo(asdValue.Value);
  }

  public int compareTo(String sValue) throws Exception
  {
    return this.Value.compareTo(new LSDate(sValue).Value);
  }

  public String toString()
  {
    return toString("/");
  }

  public String toString(String sFormat)
  {
    String sValue = StringFunction.replace(this.Value.toString(), "-", sFormat);
    if (this.Type.equals("YM")) sValue = sValue.substring(0, 7);
    return sValue;
  }

  public int getDifference(LSDate asdOther)
    throws Exception
  {
    int iDifference;
    if (this.Type.equalsIgnoreCase(asdOther.Type))
    {
      if (this.Type.equalsIgnoreCase("YMD"))
      {
        iDifference = new Long((this.Value.getTime() - asdOther.Value.getTime()) / 86400000L).intValue();
      }
      else {
        Calendar cal = Calendar.getInstance();
        cal.setTime(this.Value);
        Calendar cal2 = Calendar.getInstance();
        cal2.setTime(asdOther.Value);
        iDifference = cal.get(1) * 12 + cal.get(2) - (cal2.get(1) * 12 + cal2.get(2));
      }
    }
    else {
      throw new LSDateException("ASDate getiDifference() Error");
    }
    return iDifference;
  }

  public LSDate getRelativeDate(int iDifference)
    throws Exception
  {
    LSDate asdRelative;
    if (this.Type.equalsIgnoreCase("YMD"))
    {
      asdRelative = new LSDate(this.Value.getTime() + iDifference * 86400000L);
    }
    else {
      Calendar cal = Calendar.getInstance();
      cal.setTime(this.Value);
      int iYear = cal.get(1);
      int iMonth = cal.get(2);

      iYear = (iYear * 12 + iMonth + iDifference) / 12;
      iMonth = (iYear * 12 + iMonth + iDifference) % 12;
      asdRelative = new LSDate(iYear, iMonth + 1, 1);
      asdRelative.Type = "YM";
    }
    return asdRelative;
  }
}