package com.lmt.frameapp.config.dal;

import java.util.Vector;

import com.lmt.baseapp.util.ASValuePool;

public class ASCodeDefinition extends ASConfigDefinition
{
  public Vector items = new Vector();

  public ASValuePool getItem(String sItemNo)
    throws Exception
  {
    for (int i = 0; i < this.items.size(); i++) {
      String sCurItemNo = (String)((ASValuePool)this.items.get(i)).getAttribute("ItemNo");
      if (sCurItemNo.equals(sItemNo)) return (ASValuePool)this.items.get(i);
    }

    return null;
  }

  public ASValuePool getItem(int i) throws Exception
  {
    return (ASValuePool)this.items.get(i);
  }

  public String getItemAttribute(String sItemNo, String sColumn) throws Exception
  {
    ASValuePool item = getItem(sItemNo);
    if (item == null) return null;
    return (String)item.getAttribute(sColumn);
  }
}