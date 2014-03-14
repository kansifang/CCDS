/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.baseapp.xquery;

import java.util.Enumeration;
import java.util.StringTokenizer;
import java.util.Vector;

import javax.servlet.ServletRequest;

import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.web.render.ASDataObject;

// Referenced classes of package com.amarsoft.xquery:
//            QueryItem

public class ASQuery
{

    public ASQuery()
    {
        BaseDataObject = new ASDataObject();
        QuerySql = "";
        QuerySelect = "";
        QueryFrom = "";
        QueryWhere = "";
        QueryGroup = "";
        QueryOrder = "";
        BaseSelectFirst = true;
        vSelectItems = new Vector();
        vFromItems = new Vector();
        vWhereItems = new Vector();
        vGroupItems = new Vector();
        vOrderItems = new Vector();
        vLikeItems = new Vector();
        vSetOrderItems = new Vector();
        vArgItems = new Vector();
        vOtherItems = new Vector();
    }

    public ASQuery(ServletRequest servletrequest)
    {
        BaseDataObject = new ASDataObject();
        QuerySql = "";
        QuerySelect = "";
        QueryFrom = "";
        QueryWhere = "";
        QueryGroup = "";
        QueryOrder = "";
        BaseSelectFirst = true;
        vSelectItems = new Vector();
        vFromItems = new Vector();
        vWhereItems = new Vector();
        vGroupItems = new Vector();
        vOrderItems = new Vector();
        vLikeItems = new Vector();
        vSetOrderItems = new Vector();
        vArgItems = new Vector();
        vOtherItems = new Vector();
        init(servletrequest);
    }

    public void init(ServletRequest servletrequest)
    {
        reset();
        Enumeration enumeration = servletrequest.getParameterNames();
        do
        {
            if(!enumeration.hasMoreElements())
                break;
            String s = (String)enumeration.nextElement();
            String s1 = servletrequest.getParameter(s);
            if(!s.startsWith("NOTCONDITION_"))
                addQueryItem(s, s1);
        } while(true);
        setItemsOrder(vSelectItems);
        sortItems(vSelectItems);
        setItemsOrder(vFromItems);
        sortItems(vFromItems);
        setItemsOrder(vWhereItems);
        sortItems(vWhereItems);
        setItemsOrder(vGroupItems);
        sortItems(vGroupItems);
        setItemsOrder(vOrderItems);
        sortItems(vOrderItems);
    }

    private QueryItem findItemByName(Vector vector, String s)
    {
        int i = vector.size();
        for(int j = 0; j < i; j++)
            if(((QueryItem)vector.get(j)).Name.equalsIgnoreCase(s))
                return (QueryItem)vector.get(j);

        return null;
    }

    private QueryItem findItemByContent(String s)
    {
        String s1 = StringFunction.getSeparate(s, ";", 3);
        if(s1 == null || s1.trim().length() == 0)
            s1 = "Where";
        Vector vector;
        if(s1.equalsIgnoreCase("Select"))
            vector = vSelectItems;
        else
        if(s1.equalsIgnoreCase("From"))
            vector = vFromItems;
        else
        if(s1.equalsIgnoreCase("Where"))
            vector = vWhereItems;
        else
        if(s1.equalsIgnoreCase("Like"))
            vector = vLikeItems;
        else
        if(s1.equalsIgnoreCase("Group"))
            vector = vGroupItems;
        else
        if(s1.equalsIgnoreCase("Order"))
            vector = vOrderItems;
        else
        if(s1.equalsIgnoreCase("SetOrder"))
            vector = vSetOrderItems;
        else
        if(s1.equalsIgnoreCase("Arg"))
            vector = vSetOrderItems;
        else
        if(s1.equalsIgnoreCase("Other"))
            vector = vOtherItems;
        else
            vector = vOtherItems;
        return findItemByContent(vector, s);
    }

    private QueryItem findItemByContent(Vector vector, String s)
    {
        int i = vector.size();
        for(int j = 0; j < i; j++)
            if(((QueryItem)vector.get(j)).Content.equalsIgnoreCase(s))
                return (QueryItem)vector.get(j);

        return null;
    }

    private boolean isLike(String s)
    {
        return findItemByName(vLikeItems, s) != null;
    }

    public String getQueryItemValue(String s)
    {
        QueryItem queryitem = findItemByContent(s);
        if(queryitem == null || queryitem.Value == null)
            return "";
        else
            return queryitem.Value;
    }

    public void addQueryItem(String s, String s1)
    {
        String s2 = StringFunction.getSeparate(s, ";", 1);
        String s3 = StringFunction.getSeparate(s, ";", 2);
        String s4 = StringFunction.getSeparate(s, ";", 3);
        String s5 = StringFunction.getSeparate(s, ";", 4);
        String s6 = StringFunction.getSeparate(s, ";", 5);
        if(s3 == null || s3.trim().length() == 0)
            s3 = "String";
        if(s4 == null || s4.trim().length() == 0)
            s4 = "Where";
        if(s5 == null || s5.trim().length() == 0)
            s5 = "=";
        if(s6 == null || s6.trim().length() == 0)
            s6 = "100";
        if(s1 == null || s1.length() == 0)
            s1 = null;
        int i = Integer.valueOf(s6).intValue();
        QueryItem queryitem = new QueryItem(s2, s1, s3, s4, s5, s, i);
        addQueryItem(queryitem);
    }

    private void addQueryItem(QueryItem queryitem)
    {
        if(queryitem.Usage.equalsIgnoreCase("Select"))
            addQueryItem(vSelectItems, queryitem);
        else
        if(queryitem.Usage.equalsIgnoreCase("From"))
            addQueryItem(vFromItems, queryitem);
        else
        if(queryitem.Usage.equalsIgnoreCase("Where"))
            addQueryItem(vWhereItems, queryitem);
        else
        if(queryitem.Usage.equalsIgnoreCase("Like"))
            addQueryItem(vLikeItems, queryitem);
        else
        if(queryitem.Usage.equalsIgnoreCase("Group"))
            addQueryItem(vGroupItems, queryitem);
        else
        if(queryitem.Usage.equalsIgnoreCase("Order"))
            addQueryItem(vOrderItems, queryitem);
        else
        if(queryitem.Usage.equalsIgnoreCase("SetOrder"))
            addQueryItem(vSetOrderItems, queryitem);
        else
        if(queryitem.Usage.equalsIgnoreCase("Arg"))
            addQueryItem(vArgItems, queryitem);
        else
        if(queryitem.Usage.equalsIgnoreCase("Other"))
            addQueryItem(vOtherItems, queryitem);
    }

    private void addQueryItem(Vector vector, QueryItem queryitem)
    {
        QueryItem queryitem1 = findItemByContent(vector, queryitem.Content);
        if(queryitem1 == null)
            vector.addElement(queryitem);
        else
            queryitem1.Value = queryitem.Value;
    }

    private void setItemsOrder(Vector vector)
    {
        int i = vector.size();
        for(int j = 0; j < i; j++)
        {
            QueryItem queryitem = (QueryItem)vector.get(j);
            QueryItem queryitem1 = findItemByName(vSetOrderItems, queryitem.Name);
            if(queryitem1 != null)
            {
                queryitem.Order = Integer.valueOf(queryitem1.Value).intValue();
                return;
            }
        }

    }

    private void sortItems(Vector vector)
    {
        int i = vector.size();
        for(int j = 0; j < i; j++)
        {
            QueryItem queryitem = (QueryItem)vector.get(j);
            for(int k = j + 1; k < i; k++)
            {
                QueryItem queryitem1 = (QueryItem)vector.get(k);
                if(queryitem.Order > queryitem1.Order)
                {
                    vector.set(k, queryitem);
                    vector.set(j, queryitem1);
                    queryitem = queryitem1;
                }
            }

        }

    }

    public String genWhere()
    {
        String s = "";
        int i = vWhereItems.size();
        for(int j = 0; j < i; j++)
        {
            QueryItem queryitem = (QueryItem)vWhereItems.get(j);
            if(queryitem.Name.indexOf(" as ") >= 1)
                queryitem.Name = queryitem.Name.substring(0, queryitem.Name.indexOf(" as "));
            if(queryitem.Name.equals("CompClientID"))
                queryitem.Value = null;
            if(queryitem.Value == null)
                continue;
            if(queryitem.Value.equalsIgnoreCase("Null") || queryitem.Value.equalsIgnoreCase("not Null"))
                s = s + " and " + queryitem.Name + " is " + queryitem.Value;
            else
            if(queryitem.Type.equalsIgnoreCase("String"))
            {
                if(isLike(queryitem.Name))
                {
                    StringTokenizer stringtokenizer = new StringTokenizer(queryitem.Value, "@");
                    int k = stringtokenizer.countTokens();
                    boolean flag = false;
                    boolean flag2 = false;
                    if(k > 1)
                    {
                        s = s + " and (";
                        for(int i1 = 0; i1 < k; i1++)
                            s = s + queryitem.Name + " like " + "'" + stringtokenizer.nextToken() + "%' or ";

                        int k1 = s.length();
                        s = s.substring(0, k1 - 4);
                        s = s + " ) ";
                    } else
                    {
                        s = s + " and " + queryitem.Name + " like '" + queryitem.Value + "%'";
                    }
                } else
                if(queryitem.Operator.equalsIgnoreCase("Like"))
                {
                    s = s + " and " + queryitem.Name + " " + queryitem.Operator + " '" + queryitem.Value + "%'";
                } else
                {
                    StringTokenizer stringtokenizer1 = new StringTokenizer(queryitem.Value, "@");
                    int l = stringtokenizer1.countTokens();
                    boolean flag1 = false;
                    boolean flag3 = false;
                    if(l > 1)
                    {
                        s = s + " and (";
                        for(int j1 = 0; j1 < l; j1++)
                            s = s + queryitem.Name + " " + queryitem.Operator + "'" + stringtokenizer1.nextToken() + "' or ";

                        int l1 = s.length();
                        s = s.substring(0, l1 - 4);
                        s = s + " ) ";
                    } else
                    {
                        s = s + " and " + queryitem.Name + queryitem.Operator + "'" + queryitem.Value + "'";
                    }
                }
            } else
            if(queryitem.Type.equalsIgnoreCase("Number"))
                s = s + " and " + queryitem.Name + queryitem.Operator + queryitem.Value;
            else
            if(queryitem.Type.equalsIgnoreCase("Date"))
                s = s + " and " + queryitem.Name + queryitem.Operator + "'" + queryitem.Value + "'";
            s = StringFunction.replace(s, "@", "");
        }

        if(BaseDataObject.WhereClause != null && BaseDataObject.WhereClause.length() > 0)
            s = BaseDataObject.WhereClause + " " + s;
        else
        if(s != null && s.length() > 0)
            s = "where " + s.substring(4);
        return s;
    }

    private String genPart(Vector vector)
    {
        String s = "";
        int i = vector.size();
        for(int j = 0; j < i; j++)
        {
            QueryItem queryitem = (QueryItem)vector.get(j);
            if(queryitem.Value != null)
                s = s + "," + queryitem.Name;
        }

        return s;
    }

    public String genSelect()
    {
        String s = BaseDataObject.SelectClause;
        String s1 = genPart(vSelectItems);
        if(s.length() >= 6)
            s = s.substring(6).trim();
        if(BaseSelectFirst)
        {
            if(s.length() > 0)
                s1 = "select " + s + " " + s1;
            else
                s1 = "select " + s1.substring(1);
        } else
        if(s.length() > 0)
        {
            s = "," + s;
            if(s1.length() > 0)
                s1 = "select " + s1.substring(1) + s;
            else
                s1 = "select " + s.substring(1);
        } else
        if(s1.length() > 0)
            s1 = "select " + s1.substring(1);
        else
            s1 = "select ";
        return s1;
    }

    public String genFrom()
    {
        String s = genPart(vFromItems);
        if(BaseDataObject.FromClause != null && BaseDataObject.FromClause.length() > 0)
            s = BaseDataObject.FromClause + " " + s;
        else
        if(s != null && s.length() > 0)
            s = "from " + s.substring(1);
        return s;
    }

    public String genGroup()
    {
        String s = genPart(vGroupItems);
        if(BaseDataObject.GroupClause != null && BaseDataObject.GroupClause.length() > 0)
            s = BaseDataObject.GroupClause + " " + s;
        else
        if(s != null && s.length() > 0)
            s = "group by " + s.substring(1);
        return s;
    }

    public String genOrder()
    {
        String s = genPart(vOrderItems);
        if(BaseDataObject.OrderClause != null && BaseDataObject.OrderClause.length() > 0)
            s = BaseDataObject.OrderClause + " " + s;
        else
        if(s != null && s.length() > 0)
            s = "order by " + s.substring(1);
        return s;
    }

    public String genQuerySql()
    {
        QuerySelect = genSelect();
        QueryFrom = genFrom();
        QueryWhere = genWhere();
        QueryGroup = genGroup();
        QueryOrder = genOrder();
        QuerySql = QuerySelect + " " + QueryFrom + " " + QueryWhere + " " + QueryGroup + " " + QueryOrder;
        QuerySql = pretreatSql(QuerySql);
        return QuerySql;
    }

    public String pretreatSql(String s)
    {
        int i = vArgItems.size();
        for(int j = 0; j < i; j++)
        {
            QueryItem queryitem = (QueryItem)vArgItems.get(j);
            String s1 = "!" + queryitem.Name;
            String s2 = queryitem.Value;
            if(queryitem.Type.equalsIgnoreCase("String"))
                s2 = "'" + s2 + "'";
            s = StringFunction.replace(s, s1, s2);
        }

        return s;
    }

    public void setBaseSql(String s)
    {
        try
        {
            BaseDataObject.setSourceSql(s);
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
    }

    public void reset()
    {
        vSelectItems.removeAllElements();
        vFromItems.removeAllElements();
        vWhereItems.removeAllElements();
        vGroupItems.removeAllElements();
        vOrderItems.removeAllElements();
        vLikeItems.removeAllElements();
        vSetOrderItems.removeAllElements();
        vOtherItems.removeAllElements();
    }

    public ASDataObject BaseDataObject;
    public String QuerySql;
    public String QuerySelect;
    public String QueryFrom;
    public String QueryWhere;
    public String QueryGroup;
    public String QueryOrder;
    public boolean BaseSelectFirst;
    private Vector vSelectItems;
    private Vector vFromItems;
    private Vector vWhereItems;
    private Vector vGroupItems;
    private Vector vOrderItems;
    private Vector vLikeItems;
    private Vector vSetOrderItems;
    private Vector vArgItems;
    private Vector vOtherItems;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\CCDSN\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 92 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/