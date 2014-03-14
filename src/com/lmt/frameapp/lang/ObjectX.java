package com.lmt.frameapp.lang;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Date;

public class ObjectX
{
  public static boolean setProperty(Object paramObject, String paramString, int paramInt, boolean paramBoolean)
  {
    if (paramObject == null)
      return false;
    try
    {
      setObjectProperty(paramObject, paramString, Integer.TYPE, new Integer(paramInt), paramBoolean);
      return true;
    }
    catch (Exception localException)
    {
    }
    return false;
  }

  public static boolean setProperty(Object paramObject, String paramString, long paramLong, boolean paramBoolean)
  {
    if (paramObject == null)
      return false;
    try
    {
      setObjectProperty(paramObject, paramString, Long.TYPE, new Long(paramLong), paramBoolean);
      return true;
    }
    catch (Exception localException)
    {
    }
    return false;
  }

  public static boolean setProperty(Object paramObject, String paramString, double paramDouble, boolean paramBoolean)
  {
    if (paramObject == null)
      return false;
    try
    {
      setObjectProperty(paramObject, paramString, Double.TYPE, new Double(paramDouble), paramBoolean);
      return true;
    }
    catch (Exception localException)
    {
    }
    return false;
  }

  public static boolean setProperty(Object paramObject, String paramString, char paramChar, boolean paramBoolean)
  {
    if (paramObject == null)
      return false;
    try
    {
      setObjectProperty(paramObject, paramString, Character.TYPE, new Character(paramChar), paramBoolean);
      return true;
    }
    catch (Exception localException)
    {
    }
    return false;
  }

  public static boolean setProperty(Object paramObject, String paramString, byte paramByte, boolean paramBoolean)
  {
    if (paramObject == null)
      return false;
    try
    {
      setObjectProperty(paramObject, paramString, Character.TYPE, new Byte(paramByte), paramBoolean);
      return true;
    }
    catch (Exception localException)
    {
    }
    return false;
  }

  public static boolean setProperty(Object paramObject, String paramString, boolean paramBoolean1, boolean paramBoolean2)
  {
    if (paramObject == null)
      return false;
    try
    {
      setObjectProperty(paramObject, paramString, Boolean.TYPE, Boolean.valueOf(paramBoolean1), paramBoolean2);
      return true;
    }
    catch (Exception localException)
    {
    }
    return false;
  }

  public static boolean setProperty(Object paramObject, String paramString, Date paramDate, boolean paramBoolean)
  {
    if (paramObject == null)
      return false;
    try
    {
      setObjectProperty(paramObject, paramString, Date.class, paramDate, paramBoolean);
      return true;
    }
    catch (Exception localException)
    {
    }
    return false;
  }

  public static boolean setProperty(Object paramObject, String paramString1, String paramString2, boolean paramBoolean)
  {
    if (paramObject == null)
      return false;
    try
    {
      setObjectProperty(paramObject, paramString1, String.class, paramString2, paramBoolean);
      return true;
    }
    catch (Exception localException)
    {
    }
    return false;
  }

  private static void setObjectProperty(Object paramObject1, String paramString, Class paramClass, Object paramObject2, boolean paramBoolean)
    throws SecurityException, NoSuchMethodException, IllegalArgumentException, IllegalAccessException, InvocationTargetException
  {
    String str1 = null;
    Class localClass = paramObject1.getClass();
    if (paramBoolean)
    {
      if (!paramString.startsWith(localClass.getName() + "."))
        throw new IllegalArgumentException("Class not match: " + paramString);
      str1 = paramString.substring(localClass.getName().length() + 1);
    }
    else
    {
      str1 = paramString;
    }
    String str2 = "set" + str1.substring(0, 1).toUpperCase() + str1.substring(1);
    Method localMethod = localClass.getMethod(str2, new Class[] { paramClass });
    localMethod.invoke(paramObject1, new Object[] { paramObject2 });
  }

  public static boolean setPropertyX(Object paramObject, String paramString1, String paramString2, boolean paramBoolean)
  {
    int i = 1;
    if (paramBoolean)
    {
      String str = paramObject.getClass().getName() + ".";
      if (!paramString1.startsWith(str))
        return false;
    }
    try
    {
      setObjectProperty(paramObject, paramString1, String.class, paramString2, paramBoolean);
      i = 0;
    }
    catch (Exception localException1)
    {
    }
    if (i != 0)
      try
      {
        setObjectProperty(paramObject, paramString1, Date.class, StringX.parseDate(paramString2), paramBoolean);
        i = 0;
      }
      catch (Exception localException2)
      {
      }
    if (i != 0)
      try
      {
        setObjectProperty(paramObject, paramString1, Boolean.TYPE, new Boolean(StringX.parseBoolean(paramString2)), paramBoolean);
        i = 0;
      }
      catch (Exception localException3)
      {
      }
    if ((paramString2 == null) || (paramString2.equals("")))
      return false;
    if (i != 0)
      try
      {
        setObjectProperty(paramObject, paramString1, Integer.TYPE, Integer.valueOf(paramString2), paramBoolean);
        i = 0;
      }
      catch (Exception localException4)
      {
      }
    if (i != 0)
      try
      {
        setObjectProperty(paramObject, paramString1, Long.TYPE, Long.valueOf(paramString2), paramBoolean);
        i = 0;
      }
      catch (Exception localException5)
      {
      }
    if (i != 0)
      try
      {
        setObjectProperty(paramObject, paramString1, Byte.TYPE, Byte.valueOf(paramString2), paramBoolean);
        i = 0;
      }
      catch (Exception localException6)
      {
      }
    if (i != 0)
      try
      {
        setObjectProperty(paramObject, paramString1, Character.TYPE, new Character(paramString2.charAt(0)), paramBoolean);
        i = 0;
      }
      catch (Exception localException7)
      {
      }
    if (i != 0)
      try
      {
        setObjectProperty(paramObject, paramString1, Double.TYPE, Double.valueOf(paramString2), paramBoolean);
        i = 0;
      }
      catch (Exception localException8)
      {
      }
    return i == 0;
  }
}