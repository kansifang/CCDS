package com.lmt.baseapp.util;

import java.io.Serializable;

public class ASVarNode
    implements Serializable
{

    public ASVarNode(String s, Object obj)
    {
        sVarKey = null;
        oVarValue = null;
        iVarType = 0;
        bModify = 0;
        initNode(s, obj, true);
    }

    public ASVarNode(String s, Object obj, boolean flag)
    {
        sVarKey = null;
        oVarValue = null;
        iVarType = 0;
        bModify = 0;
        initNode(s, obj, flag);
    }

    private void initNode(String s, Object obj, boolean flag)
    {
        sVarKey = s;
        oVarValue = obj;
        if(flag)
            setBModify(1);
    }

    public Object clone()
    {
        ASVarNode asvarnode = new ASVarNode(sVarKey, oVarValue);
        asvarnode.setBModify(bModify);
        asvarnode.setIVarType(iVarType);
        return asvarnode;
    }

    public void setNodeValue(Object obj)
    {
        oVarValue = obj;
        if(isVarNodeNoChange())
            setBModify(2);
    }

    public Object getNodeValue()
    {
        return oVarValue;
    }

    public boolean isVarNodeNew()
    {
        return bModify == 1;
    }

    public boolean isVarNodeNoChange()
    {
        return bModify == 0;
    }

    public boolean isVarNodeChange()
    {
        return bModify == 2;
    }

    public int hashCode()
    {
        return sVarKey.hashCode();
    }

    public String toString()
    {
        return oVarValue.toString();
    }

    public int getBModify()
    {
        return bModify;
    }

    public void setBModify(int i)
    {
        bModify = i;
    }

    private void setIVarType(int i)
    {
        iVarType = i;
    }

    private static final long serialVersionUID = 1L;
    private String sVarKey;
    private Object oVarValue;
    private int iVarType;
    private int bModify;
    public static final int VARNODE_NOCHANGE = 0;
    public static final int VARNODE_NEWVALUE = 1;
    public static final int VARNODE_CHANGE = 2;
    public static final int VARTYPE_OBJECT = 0;
    public static final int VARTYPE_STRING = 1;
    public static final int VARTYPE_INT = 2;
}
