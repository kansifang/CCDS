package com.lmt.frameapp.config.dal;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import com.lmt.frameapp.ARE;

public class ASConfigLoaderFactory
{
  private static ASConfigLoaderFactory instance = null;
  private static Properties setting;

  private void init()
  {
    try
    {
      InputStream localInputStream = getClass().getClassLoader().getResourceAsStream("/SysConfig.properties");
      setting = new Properties();
      setting.load(localInputStream);
    }
    catch (IOException localIOException)
    {
      ARE.getLog().error("Error: Read SysConfig.properties file failed!!!", localIOException);
      localIOException.printStackTrace();
    }
  }

  public static synchronized ASConfigLoaderFactory getInstance()
  {
    if (instance == null)
    {
      instance = new ASConfigLoaderFactory();
      instance.init();
    }
    return instance;
  }

  public IConfigLoader createLoader(String paramString)
    throws Exception
  {
    String str = null;
    try
    {
      str = (String)setting.get(paramString);
    }
    catch (Exception localException1)
    {
      throw new Exception("δ��������[" + paramString + "]��Ӧ������������/WEB-INF/classes/SysConfig.properties�ļ���");
    }
    if ((str == null) || (str.trim().length() == 0))
      throw new Exception("δ�ҵ�[" + paramString + "]��Ӧ������������/WEB-INF/classes/SysConfig.properties�ļ���");
    IConfigLoader localIConfigLoader;
    try
    {
      Class localClass = Class.forName(str);
      localIConfigLoader = (IConfigLoader)localClass.newInstance();
    }
    catch (Exception localException2)
    {
      throw new Exception("��̬��" + str + "�ļ��س���:" + localException2);
    }
    return localIConfigLoader;
  }
}