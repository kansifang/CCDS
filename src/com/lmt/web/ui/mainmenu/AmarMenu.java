/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.web.ui.mainmenu;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.SortedSet;
import java.util.TreeSet;

import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

// Referenced classes of package com.amarsoft.web.ui.mainmenu:
//            MenuItem, ItemNode, ItemNodes, ItemNodeComparator

public class AmarMenu
    implements Serializable
{

    public AmarMenu()
    {
        menuItemList = new ArrayList();
        pushedNodes = new Hashtable();
    }

    public void initWithTable(String tableName, String idColumn, String labelColumn, String visiableColumn, String scriptColumn, String attributeColunm, String sortColumn, 
            String whereClause, Transaction Sqlca)
        throws Exception
    {
        StringBuffer sbSql = new StringBuffer("");
        ArrayList itemList = new ArrayList();
        sbSql.append("SELECT ").append(sortColumn).append(",").append(idColumn).append(",").append(labelColumn).append(",").append(visiableColumn).append(",").append(scriptColumn).append(",").append(attributeColunm).append(" FROM ").append(tableName).append(" WHERE 1=1 ").append(whereClause).append(" order by ").append(sortColumn).append(" asc");
        ASResultSet rs;
        MenuItem menuItem;
        for(rs = Sqlca.getASResultSet(sbSql.toString()); rs.next(); itemList.add(menuItem))
        {
            String sort = rs.getString(sortColumn);
            String id = rs.getString(idColumn);
            String label = rs.getString(labelColumn);
            String visiable = rs.getString(visiableColumn);
            String script = rs.getString(scriptColumn);
            String attribute = rs.getString(attributeColunm);
            menuItem = new MenuItem(id != null ? id : "", sort != null ? sort : "", label != null ? label : "", "", script != null ? script : "", "", "", label != null ? label : "");
        }

        rs.getStatement().close();
        rs = null;
        initMenu(itemList);
    }

    public void addToMenuBar(ItemNode node)
    {
        menuItemList.add(node);
    }

    public void initMenu(ArrayList itemList)
        throws Exception
    {
        ArrayList menuPannel = splitMenuPannel(itemList);
        for(int i = 0; i < menuPannel.size(); i++)
        {
            ArrayList signalPannel = (ArrayList)menuPannel.get(i);
            String sRootSortNo = ((MenuItem)signalPannel.get(0)).getSortNo();
            boolean rootVisible = ((MenuItem)signalPannel.get(0)).isVisible();
            if(!rootVisible)
                continue;
            ItemNodes m = setupMenuPannel(signalPannel, sRootSortNo);
            for(int k = 0; k < m.getNodesNumber(); k++)
                addToMenuBar((ItemNode)m.getNode(k));

        }

    }

    private ArrayList splitMenuPannel(ArrayList itemList)
        throws Exception
    {
        ArrayList menuPannel = new ArrayList();
        String sRootSortNo = "";
        ArrayList signalPannel = new ArrayList();
        for(int i = 0; i < itemList.size(); i++)
        {
            MenuItem menuItem = (MenuItem)itemList.get(i);
            String sortCol = menuItem.getSortNo();
            String idCol = menuItem.getMenuID();
            sortCol = sortCol != null ? sortCol : "";
            idCol = idCol != null ? idCol : "";
            if(i == 0)
                sRootSortNo = sortCol;
            if(sortCol == null || sortCol.length() <= 0)
                throw new Exception((new StringBuilder()).append("ID\u4E3A[").append(idCol).append("]\u7684\u83DC\u5355\u6392\u5E8F\u53F7\u4E3A\u7A7A").toString());
            if(sortCol.startsWith(sRootSortNo))
            {
                signalPannel.add(menuItem);
            } else
            {
                if(signalPannel != null && signalPannel.size() > 0)
                    menuPannel.add(signalPannel);
                signalPannel = new ArrayList();
                signalPannel.add(menuItem);
                sRootSortNo = sortCol;
            }
            if(i == itemList.size() - 1 && signalPannel.size() > 0)
                menuPannel.add(signalPannel);
        }

        return menuPannel;
    }

    private ItemNodes setupMenuPannel(ArrayList list, String baseSortNo)
    {
        ItemNodes menuItems = new ItemNodes();
        if(list == null || list.size() <= 0)
            return null;
        ItemNode menuPannel = null;
        for(int i = 0; i < list.size(); i++)
        {
            MenuItem menuItem = (MenuItem)list.get(i);
            if(!menuItem.isVisible())
                continue;
            String sortNo = menuItem.getSortNo();
            if(!sortNo.startsWith(baseSortNo) || pushedNodes.containsKey(sortNo))
                continue;
            menuPannel = new ItemNode(menuItem);
            menuItems.addNode(menuPannel);
            pushedNodes.put(sortNo, Boolean.valueOf(true));
            ItemNodes items = setupMenuPannel(list, sortNo);
            if(items == null)
                continue;
            for(int k = 0; k < items.getNodesNumber(); k++)
                menuPannel.addChildNode((ItemNode)items.getNode(k));

        }

        return menuItems;
    }

    public String genMenuBar(String barID)
    {
        StringBuffer sbItem = new StringBuffer();
        sbItem.append((new StringBuilder()).append("<ul id='").append(barID).append("' class='MenuHeaderUl'>").toString());
        SortedSet menus = new TreeSet(new ItemNodeComparator());
        menus.addAll(menuItemList);
        for(Iterator i$ = menus.iterator(); i$.hasNext(); sbItem.append("</li>"))
        {
            ItemNode item = (ItemNode)i$.next();
            sbItem.append((new StringBuilder()).append("<li class='MenuHeaderLi' id='MenuHeaderLi").append(item.getId()).append("' _action='").append(item.getScript()).append("' >").toString());
            sbItem.append((new StringBuilder()).append("<a href='javascript:void(0)' class='MenuHeaderLiA'>").append(item.getLabel()).append("</a>").toString());
            StringBuffer caseItem = showMenuItem(item);
            if(caseItem != null)
                sbItem.append(caseItem);
        }

        sbItem.append("</ul>");
        return sbItem.toString();
    }

    public StringBuffer showMenuItem(ItemNode item)
    {
        StringBuffer sbItem = new StringBuffer("");
        if(item == null || item.getChildsNumber() <= 0)
            return null;
        sbItem.append((new StringBuilder()).append("<ul class='SubMenuUl' id='SubMenuUl").append(item.getId()).append("'>").toString());
        for(int i = 0; i < item.getChildsNumber(); i++)
        {
            ItemNode childItem = item.getChildNode(i);
            sbItem.append((new StringBuilder()).append("<li id='SubMenuLi").append(childItem.getId()).append("' _action='").append(childItem.getScript()).append("'>").toString());
            sbItem.append((new StringBuilder()).append("<a href='javascript:void(0)'>").append(childItem.getLabel()).append("</a>").toString());
            StringBuffer sbTmp = showMenuItem(childItem);
            if(sbTmp != null && sbTmp.length() > 0)
                sbItem.append(sbTmp);
            sbItem.append("</li>");
        }

        sbItem.append("</ul>");
        return sbItem;
    }

    public String getMenusFromSubSys(String sAppID)
    {
        StringBuffer sbItem = new StringBuffer();
        SortedSet menus = new TreeSet(new ItemNodeComparator());
        menus.addAll(menuItemList);
        int i = 0;
        for(Iterator i$ = menus.iterator(); i$.hasNext();)
        {
            ItemNode item = (ItemNode)i$.next();
            sbItem.append("<div class='menu_2' style='height:180px;' >");
            sbItem.append("<ul>");
            sbItem.append("<li>");
            sbItem.append("<div class='menu_2_root'>");
            sbItem.append("<a href='#'");
            sbItem.append(getRedirectAction(item, sAppID));
            sbItem.append(">");
            sbItem.append((new StringBuilder()).append("<div class='menu_all_text1'>").append(i + 1).append(".").append(item.getLabel()).append("</div>").toString());
            sbItem.append("</a>");
            sbItem.append("</div>");
            sbItem.append("</li>");
            if(item.getChildsNumber() > 0)
            {
                for(int j = 0; j < item.getChildsNumber(); j++)
                {
                    ItemNode item2 = item.getChildNode(j);
                    sbItem.append((new StringBuilder()).append("<li><div class='menu_2_cls'><a href='#'").append(getRedirectAction(item2, sAppID)).append(">").toString());
                    sbItem.append((new StringBuilder()).append("<div class='menu_all_text2'>").append(item2.getLabel()).append("</div></a></div></li>").toString());
                    if(item2.getChildsNumber() <= 0)
                        continue;
                    for(int k = 0; k < item2.getChildsNumber(); k++)
                    {
                        ItemNode item3 = item2.getChildNode(k);
                        sbItem.append((new StringBuilder()).append("<li><div class='menu_2_thd'><a href='#'").append(getRedirectAction(item3, sAppID)).append(">").toString());
                        sbItem.append((new StringBuilder()).append("<div class='menu_all_text3'>").append(item3.getLabel()).append("</div></a></div></li>").toString());
                    }

                }

                sbItem.append("\n");
            }
            sbItem.append("</ul></div>");
            i++;
        }

        return sbItem.toString();
    }

    private String getRedirectAction(ItemNode item, String sAppID)
    {
        String script = item.getMenuItem().getUrl();
        if(script != null && script.length() > 0)
            script = (new StringBuilder()).append(" onclick=\"").append(script.replaceAll("\"", "'").replace("_self", "_top")).append("\" ").toString();
        else
            script = "";
        return script;
    }

    private static final long serialVersionUID = 1L;
    private ArrayList menuItemList;
    private Hashtable pushedNodes;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\workspace\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 179 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/