package com.lmt.frameapp.log.impl;

public class ConsoleHandler extends SimpleHandler
{
  public static final String systemPrefix = "com.amarsoft.are.log.impl.ConsoleHandler.";

  public ConsoleHandler()
  {
    configure();
  }

  public void configure()
  {
    super.configure();
    String str = getStringProperty("com.amarsoft.are.log.impl.ConsoleHandler.level");
    if (str != null)
      setLogLevel(str);
  }
}