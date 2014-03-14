package com.lmt.frameapp.config.dal;

import com.lmt.baseapp.util.ASValuePool;


public class ASDefinitionFactory
{
  private static ASDefinitionFactory instance = null;

  public static synchronized ASDefinitionFactory getInstance()
  {
    if (instance == null)
      instance = new ASDefinitionFactory();
    return instance;
  }

  public ASConfigDefinition createDefinition(String sType, Object oTmp) throws Exception {
    if (sType.equals("ASCompSet"))
      return createComponentDefinition((ASValuePool)oTmp);
    if (sType.equals("ASRoleSet"))
      return createRoleDefinition((String)oTmp);
    if (sType.equals("ASCodeSet")) {
      return createCodeDefinition((String)oTmp);
    }
    return null;
  }

  public ASCompDefinition createComponentDefinition(ASValuePool valuePool) throws Exception {
    ASCompDefinition compDef = new ASCompDefinition();
    compDef.id = ((String)valuePool.getAttribute("CompID"));
    compDef.name = ((String)valuePool.getAttribute("CompName"));
    Object[] keys = valuePool.getKeys();
    for (int i = 0; i < keys.length; i++) {
      compDef.setAttribute((String)keys[i], valuePool.getAttribute((String)keys[i]));
    }
    return compDef;
  }

  public ASRoleDefinition createRoleDefinition(String roleID) throws Exception {
    ASRoleDefinition roleDef = new ASRoleDefinition();
    roleDef.id = roleID;
    return roleDef;
  }
  public ASCodeDefinition createCodeDefinition(String codeNo) throws Exception {
    ASCodeDefinition codeDef = new ASCodeDefinition();
    codeDef.id = codeNo;
    return codeDef;
  }
}