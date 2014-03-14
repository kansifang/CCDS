package com.lmt.baseapp.util;

import java.io.Serializable;
import java.util.HashMap;

// Referenced classes of package com.amarsoft.are.util:
//            LSVarNode, DataConvert

public class ASValuePool
    implements Serializable
{

    public ASValuePool()
    {
        htDataSet = null;
        initPool(100);
    }

    public ASValuePool(int i)
    {
        htDataSet = null;
        initPool(i);
    }

    private void initPool(int i)
    {
        if(htDataSet == null)
            htDataSet = new HashMap(i);
        else
            htDataSet.clear();
    }

    public void setAttribute(String s, Object obj)
        throws Exception
    {
        setAttribute(s, obj, true);
    }

    public void setAttribute(String s, Object obj, boolean flag)
        throws Exception
    {
        ASVarNode asvarnode = getVarNode(s);
        if(asvarnode == null)
        {
            asvarnode = new ASVarNode(s, obj, flag);
            htDataSet.put(s, asvarnode);
        } else
        {
            asvarnode.setNodeValue(obj);
        }
    }

    public Object getAttribute(String s)
        throws Exception
    {
        ASVarNode asvarnode = getVarNode(s);
        if(asvarnode == null)
            return null;
        else
            return asvarnode.getNodeValue();
    }

    public boolean isVarNodeNew(String s)
        throws Exception
    {
        ASVarNode asvarnode = getVarNode(s);
        if(asvarnode == null)
            return true;
        else
            return asvarnode.isVarNodeNew();
    }

    public boolean isVarNodeNoChange(String s)
        throws Exception
    {
        ASVarNode asvarnode = getVarNode(s);
        if(asvarnode == null)
            return true;
        else
            return asvarnode.isVarNodeNoChange();
    }

    public boolean isVarNodeChange(String s)
        throws Exception
    {
        ASVarNode asvarnode = getVarNode(s);
        if(asvarnode == null)
            return false;
        else
            return asvarnode.isVarNodeChange();
    }

    public void setVarNodeNew(String s)
        throws Exception
    {
        ASVarNode asvarnode = getVarNode(s);
        if(asvarnode != null)
            asvarnode.setBModify(1);
    }

    public void setVarNodeNoChange(String s)
        throws Exception
    {
        ASVarNode asvarnode = getVarNode(s);
        if(asvarnode != null)
            asvarnode.setBModify(0);
    }

    public void setVarNodeChange(String s)
        throws Exception
    {
        ASVarNode asvarnode = getVarNode(s);
        if(asvarnode != null)
            asvarnode.setBModify(2);
    }

    private ASVarNode getVarNode(String s)
        throws Exception
    {
        Object obj = htDataSet.get(s);
        if(obj == null)
            return null;
        else
            return (ASVarNode)obj;
    }

    public boolean containsKey(String s)
    {
        return htDataSet.containsKey(s);
    }

    public boolean containsValue(Object obj)
    {
        return htDataSet.containsValue(obj);
    }

    public int size()
    {
        return htDataSet.size();
    }

    public boolean isEmpty()
    {
        return htDataSet.isEmpty();
    }

    public ASValuePool clonePool()
        throws Exception
    {
        boolean flag = false;
        ASValuePool asvaluepool = new ASValuePool();
        Object aobj[] = getKeys();
        for(int i = 0; i < aobj.length; i++)
            htDataSet.put(aobj[i], getVarNode((String)aobj[i]).clone());

        return asvaluepool;
    }

    public Object delAttribute(String s)
        throws Exception
    {
        Object obj = getAttribute(s);
        if(obj != null)
            htDataSet.remove(s);
        return obj;
    }

    public void uniteFromValuePool(ASValuePool asvaluepool)
        throws Exception
    {
        boolean flag = false;
        Object aobj[] = asvaluepool.getKeys();
        for(int i = 0; i < aobj.length; i++)
            htDataSet.put(aobj[i], asvaluepool.getVarNode((String)aobj[i]).clone());

    }

    public void resetPool()
        throws Exception
    {
        htDataSet.clear();
    }

    public Object[] getKeys()
    {
        return (Object[])htDataSet.keySet().toArray();
    }

    public String getString(String s)
        throws Exception
    {
        try
        {
            String s1 = null;
            s1 = (String)getAttribute(s);
            if(s1 == null)
                s1 = (String)getAttribute(s.toUpperCase());
            return DataConvert.toString(s1);
        }
        catch(Exception exception)
        {
            throw new Exception("\u65E0\u6CD5\u5C06\u53D8\u91CF" + s + "\u8F6C\u6362\u4E3A\u5B57\u7B26\u4E32\u3002");
        }
    }

    public String getNumber(String s)
        throws Exception
    {
        try
        {
            String s1 = null;
            s1 = (String)getAttribute(s);
            if(s1 == null)
                s1 = (String)getAttribute(s.toUpperCase());
            if(s1 == null || s1.equals(""))
                s1 = "null";
            return s1;
        }
        catch(Exception exception)
        {
            throw new Exception("\u65E0\u6CD5\u5C06\u53D8\u91CF" + s + "\u8F6C\u6362\u4E3A\u5B57\u7B26\u4E32\u3002");
        }
    }

    public int getInt(String s)
        throws Exception
    {
        try
        {
            String s1 = null;
            int i = 0;
            s1 = (String)getAttribute(s);
            if(s1 == null)
                s1 = (String)getAttribute(s.toUpperCase());
            if(s1 == null || s1.equals(""))
                i = 0;
            else
                i = Integer.parseInt(s1);
            return i;
        }
        catch(Exception exception)
        {
            throw new Exception("\u65E0\u6CD5\u5C06\u53D8\u91CF" + s + "\u8F6C\u6362\u4E3Aint\u3002");
        }
    }

    private static final long serialVersionUID = 1L;
    private HashMap htDataSet;
}