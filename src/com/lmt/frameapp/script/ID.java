package com.lmt.frameapp.script;

public class ID
{
  public String Name;
  public String Value;
  public String Content;
  public String Attribute;
  public int Order;

  public ID(String sName, String sValue, String sContent, String sAttribute, int iOrder)
  {
    this.Name = sName;
    this.Value = sValue;
    this.Content = sContent;
    this.Attribute = sAttribute;
    this.Order = iOrder;
  }
}