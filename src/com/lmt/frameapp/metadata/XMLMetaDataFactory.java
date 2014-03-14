package com.lmt.frameapp.metadata;

import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import com.lmt.app.util.xml.Document;
import com.lmt.app.util.xml.Element;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.io.FileTool;
import com.lmt.frameapp.sql.SQLConstants;

// Referenced classes of package com.amarsoft.are.metadata:
//            MetaDataFactory, DataSourceMetaData, DefaultDataSourceMetaData, DefaultColumnMetaData, 
//            DefaultTableMetaData, DefaultColumnUIMetaData

public class XMLMetaDataFactory extends MetaDataFactory
{

    public XMLMetaDataFactory()
    {
        schemas = null;
        dataSources = new HashMap(4);
    }

    public DataSourceMetaData getInstance(String s)
    {
        return (DataSourceMetaData)dataSources.get(s.toUpperCase());
    }

    public void initMetaDataFactory()
    {
        String s = getSchemas();
        if(s != null)
        {
            s = s.replaceAll("^\\s+", "").replaceAll("\\s+$", "").replaceAll("\\s*,\\s*", ",");
            String as[] = s.split(",");
            for(int i = 0; i < as.length; i++)
            {
                DataSourceMetaData datasourcemetadata = buildDataSource(as[i]);
                if(datasourcemetadata != null)
                    dataSources.put(datasourcemetadata.getName().toUpperCase(), datasourcemetadata);
            }

        }
    }

    private DataSourceMetaData buildDataSource(String s)
    {
        java.io.File file = FileTool.findFile(s);
        if(file == null)
        {
            ARE.getLog().error("Schema File '" + s + "' not exists!");
            return null;
        }
        Document document = null;
        try
        {
            document = new Document(file);
        }
        catch(Exception exception)
        {
            ARE.getLog().debug("Build datasource '" + s + "' failed!", exception);
            return null;
        }
        Element element = document.getRootElement();
        String s1 = element.getChildTextTrim("name");
        String s2 = element.getChildTextTrim("encoding");
        DefaultDataSourceMetaData defaultdatasourcemetadata = new DefaultDataSourceMetaData(s1, s2);
        defaultdatasourcemetadata.setLabel(element.getChildTextTrim("label"));
        defaultdatasourcemetadata.setDescribe(element.getChildTextTrim("describe"));
        Element element1 = element.getChild("product");
        if(element1 != null)
        {
            defaultdatasourcemetadata.setProductName(element1.getChildTextTrim("name"));
            defaultdatasourcemetadata.setProductVersion(element1.getChildTextTrim("version"));
            defaultdatasourcemetadata.setProviderName(element1.getChildTextTrim("provider"));
        }
        Element element2 = element.getChild("extendProperties");
        if(element2 != null)
        {
            Element element4;
            for(Iterator iterator = element2.getChildren("property").iterator(); iterator.hasNext(); defaultdatasourcemetadata.setProperty(element4.getAttributeValue("name"), element4.getAttributeValue("value")))
                element4 = (Element)iterator.next();

        }
        Element element3 = element.getChild("tables");
        if(element3 != null)
        {
            Iterator iterator1 = element3.getChildren("table").iterator();
            do
            {
                if(!iterator1.hasNext())
                    break;
                Element element5 = (Element)iterator1.next();
                DefaultTableMetaData defaulttablemetadata = buildTable(element5);
                if(defaulttablemetadata != null)
                    defaultdatasourcemetadata.addTable(defaulttablemetadata);
            } while(true);
        }
        return defaultdatasourcemetadata;
    }

    private DefaultTableMetaData buildTable(Element element)
    {
        List list = element.getChildren("column");
        if(list.isEmpty())
            return null;
        DefaultColumnMetaData adefaultcolumnmetadata[] = new DefaultColumnMetaData[list.size()];
        Object obj = null;
        String s = element.getAttributeValue("name").toUpperCase();
        String s1 = element.getAttributeValue("type", "TABLE").toUpperCase();
        int i = (adefaultcolumnmetadata.length * (adefaultcolumnmetadata.length + 1)) / 2;
        int j = 0;
        for(int k = 0; k < adefaultcolumnmetadata.length; k++)
        {
            Element element1 = (Element)list.get(k);
            adefaultcolumnmetadata[k] = buildColumn(k + 1, element1);
            j += adefaultcolumnmetadata[k].getIndex();
        }

        if(j != i)
        {
            ARE.getLog().warn("Column index is't a sequence from 1 to " + adefaultcolumnmetadata.length + ",can't construct table " + s + " !");
            return null;
        }
        DefaultTableMetaData defaulttablemetadata = new DefaultTableMetaData(s, s1, adefaultcolumnmetadata);
        defaulttablemetadata.setLabel(element.getAttributeValue("label", s));
        defaulttablemetadata.setDescribe(element.getAttributeValue("describe", s));
        Element element2 = element.getChild("extendProperties");
        if(element2 != null)
        {
            Element element3;
            for(Iterator iterator = element2.getChildren("property").iterator(); iterator.hasNext(); defaulttablemetadata.setProperty(element3.getAttributeValue("name"), element3.getAttributeValue("value")))
                element3 = (Element)iterator.next();

        }
        return defaulttablemetadata;
    }

    private DefaultColumnMetaData buildColumn(int i, Element element)
    {
        DefaultColumnMetaData defaultcolumnmetadata = new DefaultColumnMetaData(i);
        defaultcolumnmetadata.setName(element.getAttributeValue("name", "COLUMN_" + i));
        defaultcolumnmetadata.setLabel(element.getAttributeValue("label", "COLUMN_" + i));
        defaultcolumnmetadata.setType(SQLConstants.getSQLDataType(element.getAttributeValue("type", "CHAR")));
        defaultcolumnmetadata.setFormat(element.getAttributeValue("format", ""));
        defaultcolumnmetadata.setPrimaryKey(element.getAttributeValue("primaryKey", "false").equalsIgnoreCase("true"));
        try
        {
            defaultcolumnmetadata.setDisplaySize(Integer.parseInt(element.getAttributeValue("displaySize", "20")));
        }
        catch(NumberFormatException numberformatexception)
        {
            defaultcolumnmetadata.setDisplaySize(20);
            ARE.getLog().debug("Invalid displaySize of column " + defaultcolumnmetadata.getName() + ", set to default 20 !", numberformatexception);
        }
        try
        {
            defaultcolumnmetadata.setPrecision(Integer.parseInt(element.getAttributeValue("precision", "14")));
        }
        catch(NumberFormatException numberformatexception1)
        {
            defaultcolumnmetadata.setPrecision(14);
            ARE.getLog().debug("Invalid precision of column " + defaultcolumnmetadata.getName() + ",set to default 14 ! ", numberformatexception1);
        }
        int j = SQLConstants.SQLTypeToBaseType(defaultcolumnmetadata.getType());
        if(j == 4 || j == 1 || j == 2)
            try
            {
                defaultcolumnmetadata.setScale(Integer.parseInt(element.getAttributeValue("scale", "4")));
            }
            catch(NumberFormatException numberformatexception2)
            {
                defaultcolumnmetadata.setScale(4);
                ARE.getLog().debug("Invalid scale of column " + defaultcolumnmetadata.getName() + ",set to default 4 ! ", numberformatexception2);
            }
        String s = element.getAttributeValue("defaultValue");
        if(s != null)
        {
            s = s.trim();
            switch(j)
            {
            case 3: // '\003'
            case 5: // '\005'
            case 6: // '\006'
            case 7: // '\007'
            case 9: // '\t'
            case 10: // '\n'
            case 11: // '\013'
            case 12: // '\f'
            case 13: // '\r'
            case 14: // '\016'
            case 15: // '\017'
            default:
                break;

            case 0: // '\0'
                defaultcolumnmetadata.setDefaultValue(s);
                break;

            case 1: // '\001'
                try
                {
                    int k = Integer.parseInt(s);
                    defaultcolumnmetadata.setDefaultValue(k);
                }
                catch(Exception exception)
                {
                    ARE.getLog().debug("Invalid default of column " + defaultcolumnmetadata.getName(), exception);
                }
                break;

            case 2: // '\002'
                try
                {
                    long l = Long.parseLong(s);
                    defaultcolumnmetadata.setDefaultValue(l);
                }
                catch(Exception exception1)
                {
                    ARE.getLog().debug("Invalid default of column " + defaultcolumnmetadata.getName(), exception1);
                }
                break;

            case 4: // '\004'
                try
                {
                    double d = Double.parseDouble(s);
                    defaultcolumnmetadata.setDefaultValue(d);
                }
                catch(Exception exception2)
                {
                    ARE.getLog().debug("Invalid default of column " + defaultcolumnmetadata.getName(), exception2);
                }
                break;

            case 16: // '\020'
                try
                {
                    String s1 = defaultcolumnmetadata.getFormat();
                    if(s1 == null)
                        s1 = "yyyy/MM/dd";
                    java.util.Date date = (new SimpleDateFormat(s1)).parse(s);
                    defaultcolumnmetadata.setDefaultValue(new Date(date.getTime()));
                }
                catch(Exception exception3)
                {
                    ARE.getLog().debug("Invalid default of column " + defaultcolumnmetadata.getName(), exception3);
                }
                break;

            case 8: // '\b'
                boolean flag = Boolean.valueOf(s).booleanValue();
                defaultcolumnmetadata.setDefaultValue(flag);
                break;
            }
        }
        String s2 = element.getAttributeValue("index");
        if(s2 != null && s2.matches("\\s*\\d+\\s*"))
            defaultcolumnmetadata.setIndex(Integer.parseInt(s2.trim()));
        Element element1 = element.getChild("extendProperties");
        if(element1 != null)
        {
            Element element3;
            for(Iterator iterator = element1.getChildren("property").iterator(); iterator.hasNext(); defaultcolumnmetadata.setProperty(element3.getAttributeValue("name"), element3.getAttributeValue("value")))
                element3 = (Element)iterator.next();

        }
        Element element2 = element.getChild("uis");
        if(element2 != null)
        {
            List list = element2.getChildren();
            for(int i1 = 0; i1 < list.size(); i1++)
            {
                Element element4 = (Element)list.get(i1);
                String s3 = element4.getAttributeValue("name", "UI_" + String.valueOf(i1));
                defaultcolumnmetadata.addUIMetaData(s3, buildColumnUI(element4));
            }

        }
        return defaultcolumnmetadata;
    }

    private DefaultColumnUIMetaData buildColumnUI(Element element)
    {
        DefaultColumnUIMetaData defaultcolumnuimetadata = new DefaultColumnUIMetaData();
        String s = null;
        s = element.getAttributeValue("halignment");
        if(s != null)
        {
            s = s.trim();
            if(s.equalsIgnoreCase("left"))
                defaultcolumnuimetadata.setHAlignment(1);
            else
            if(s.equalsIgnoreCase("right"))
                defaultcolumnuimetadata.setHAlignment(2);
            else
            if(s.equalsIgnoreCase("center"))
                defaultcolumnuimetadata.setHAlignment(0);
        }
        s = element.getAttributeValue("valignment");
        if(s != null)
        {
            s = s.trim();
            if(s.equalsIgnoreCase("top"))
                defaultcolumnuimetadata.setVAlignment(3);
            else
            if(s.equalsIgnoreCase("bottom"))
                defaultcolumnuimetadata.setVAlignment(4);
            else
            if(s.equalsIgnoreCase("center"))
                defaultcolumnuimetadata.setVAlignment(0);
        }
        s = element.getAttributeValue("valueCharacter");
        if(s != null)
        {
            s = s.trim();
            if(s.equalsIgnoreCase("list"))
                defaultcolumnuimetadata.setValueCharacter(1);
            else
            if(s.equalsIgnoreCase("unlimited"))
                defaultcolumnuimetadata.setValueCharacter(0);
            else
            if(s.equalsIgnoreCase("codetable"))
                defaultcolumnuimetadata.setValueCharacter(2);
            else
            if(s.equalsIgnoreCase("range"))
                defaultcolumnuimetadata.setValueCharacter(3);
        }
        s = element.getAttributeValue("inputMask");
        if(s != null)
        {
            s = s.trim();
            defaultcolumnuimetadata.setInputMask(s);
        }
        s = element.getAttributeValue("displayFormat");
        if(s != null)
        {
            s = s.trim();
            defaultcolumnuimetadata.setDisplayFormat(s);
        }
        s = element.getAttributeValue("css");
        if(s != null)
        {
            s = s.trim();
            defaultcolumnuimetadata.setCss(s);
        }
        s = element.getAttributeValue("isKey");
        if(s != null)
        {
            s = s.trim();
            defaultcolumnuimetadata.setKey(s.equalsIgnoreCase("true"));
        }
        s = element.getAttributeValue("readOnly");
        if(s != null)
        {
            s = s.trim();
            defaultcolumnuimetadata.setReadOnly(s.equalsIgnoreCase("true"));
        }
        s = element.getAttributeValue("required");
        if(s != null)
        {
            s = s.trim();
            defaultcolumnuimetadata.setRequried(s.equalsIgnoreCase("true"));
        }
        s = element.getAttributeValue("sortable");
        if(s != null)
        {
            s = s.trim();
            defaultcolumnuimetadata.setSortable(s.equalsIgnoreCase("true"));
        }
        s = element.getAttributeValue("visible");
        if(s != null)
        {
            s = s.trim();
            defaultcolumnuimetadata.setVisible(s.equalsIgnoreCase("true"));
        }
        s = element.getAttributeValue("valueCodetable");
        if(s != null)
        {
            s = s.trim();
            defaultcolumnuimetadata.setValueCodetable(s);
        }
        s = element.getAttributeValue("valueList");
        if(s != null)
        {
            s = s.trim();
            defaultcolumnuimetadata.setValueList(s);
        }
        s = element.getAttributeValue("valueRange");
        if(s != null)
        {
            s = s.trim();
            defaultcolumnuimetadata.setValueRange(s);
        }
        Element element1 = element.getChild("extendProperties");
        if(element1 != null)
        {
            Element element2;
            for(Iterator iterator = element1.getChildren("property").iterator(); iterator.hasNext(); defaultcolumnuimetadata.setProperty(element2.getAttributeValue("name"), element2.getAttributeValue("value")))
                element2 = (Element)iterator.next();

        }
        return defaultcolumnuimetadata;
    }

    public String getServiceProvider()
    {
        return "Amarsoft";
    }

    public String getServiceDescribe()
    {
        return "\u57FA\u4E8EXML\u5B58\u50A8\u7684\u5143\u6570\u636E\u7BA1\u7406";
    }

    public String getServiceVersion()
    {
        return "1.0";
    }

    public void shutdown()
    {
    }

    public final String getSchemas()
    {
        return schemas;
    }

    public final void setSchemas(String s)
    {
        schemas = s;
    }

    public DataSourceMetaData[] getDataSources()
    {
        return (DataSourceMetaData[])dataSources.entrySet().toArray(new DataSourceMetaData[0]);
    }

    private static final String version = "1.0";
    private static final String provider = "Amarsoft";
    private static final String describe = "\u57FA\u4E8EXML\u5B58\u50A8\u7684\u5143\u6570\u636E\u7BA1\u7406";
    private HashMap dataSources;
    private String schemas;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\are-0.2.jar
	Total time: 313 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/