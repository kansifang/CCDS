package com.lmt.frameapp;

public abstract interface ContextService
{
  public static final String SID_DBCONNECTION = "DBCONNECTION";
  public static final String SID_METADATA = "METADATA";
  public static final String SID_LOG = "LOG";

  public abstract String getServiceId();

  public abstract String getServiceProvider();

  public abstract String getServiceDescribe();

  public abstract String getServiceVersion();

  public abstract String getServiceClass();

  public abstract void init() throws ContextException;

  public abstract void shutdown();
}