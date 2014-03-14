package com.lmt.app.util.xml;

import com.lmt.frameapp.lang.StringX;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Attribute
{
  private String name = null;
  private String value = null;

  public Attribute(String paramString)
  {
    this.name = paramString;
  }

  public Attribute(String paramString1, String paramString2)
  {
    this.name = paramString1;
    this.value = paramString2;
  }

  public String getName()
  {
    return this.name;
  }

  public String getValue()
  {
    return this.value;
  }

  public void setValue(String paramString)
  {
    this.value = paramString;
  }

  public final int getValue(int paramInt)
  {
    int i = paramInt;
    if (this.value != null)
      try
      {
        i = Integer.parseInt(this.value);
      }
      catch (Exception localException)
      {
        i = paramInt;
      }
    return i;
  }

  public final double getValue(double paramDouble)
  {
    double d = paramDouble;
    if (this.value != null)
      try
      {
        d = Double.parseDouble(this.value);
      }
      catch (Exception localException)
      {
        d = paramDouble;
      }
    return d;
  }

  public final boolean getValue(boolean paramBoolean)
  {
    boolean bool = paramBoolean;
    if (this.value != null)
      bool = StringX.parseBoolean(this.value);
    return bool;
  }

  public final Date getValue(Date paramDate)
  {
    Date localDate = paramDate;
    if (this.value != null)
      localDate = StringX.parseDate(this.value);
    return localDate;
  }

  public final Date getValue(Date paramDate, String paramString)
  {
    Date localDate = paramDate;
    if (this.value != null)
    {
      SimpleDateFormat localSimpleDateFormat = new SimpleDateFormat(paramString);
      try
      {
        localDate = localSimpleDateFormat.parse(this.value);
      }
      catch (Exception localException)
      {
        localDate = paramDate;
      }
    }
    return localDate;
  }

  public final String getValue(String paramString)
  {
    return this.value == null ? paramString : this.value;
  }
}