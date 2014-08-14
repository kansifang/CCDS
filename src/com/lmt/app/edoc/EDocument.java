/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.app.edoc;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Map;

import org.jdom.Document;
import org.jdom.JDOMException;
import org.jdom.input.SAXBuilder;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

import com.lmt.frameapp.sql.Transaction;

// Referenced classes of package com.amarsoft.app.edoc:
//            ETagHandle, EDataHandle

public class EDocument
{

    public EDocument(String templateFName, String dataDefineName)
        throws JDOMException, IOException
    {
        
        this.templateFName = null;
        this.template = null;
        
        this.dataDefFName = null;
        this.datadef = null;
        
        this. templateFName = templateFName;
        this.template = builder.build(new File(templateFName));
        
        if(dataDefineName != null){
        	this.dataDefFName = dataDefineName;
        	this.datadef = builder.build(new File(dataDefineName));
        }
    }

    public static String getTagList(String s)
        throws JDOMException, IOException
    {
        Document document = builder.build(new File(s));
        return ETagHandle.getTagList(document);
    }

    public String getTagList()
        throws JDOMException, IOException
    {
        return ETagHandle.getTagList(template);
    }

    public String getDefTagList()
        throws JDOMException, IOException
    {
        return ETagHandle.getDefTagList(datadef);
    }

    public String checkTag()
        throws JDOMException, IOException
    {
        return ETagHandle.checkTag(template, datadef);
    }

    private static void replaceTag(Document document, Document datadocument)
        throws JDOMException, IOException
    {
        ETagHandle.replaceSimpleTag(document, datadocument);
        //ETagHandle.replaceImageTag(document, datadocument);
        ETagHandle.replaceTableTag(document, datadocument);
    }

    public String saveAsDefault(String s)
        throws FileNotFoundException, IOException, JDOMException
    {
        Format format = Format.getCompactFormat();
        format.setEncoding("UTF-8");
        format.setIndent("   ");
        XMLOutputter xmloutputter = new XMLOutputter(format);
        Document document = builder.build(new File(templateFName));
        Document document1 = builder.build(new File(dataDefFName));
        replaceTag(document, document1);
        xmloutputter.output(document, new FileOutputStream(s));
        return s;
    }

    public String saveDoc(String s, Map map, Transaction transaction)
        throws Exception
    {
        Format format = Format.getCompactFormat();
        format.setEncoding("UTF-8");
        format.setIndent("   ");
        XMLOutputter xmloutputter = new XMLOutputter(format);
        Document document = builder.build(new File(templateFName));
        Document datadocument = builder.build(new File(dataDefFName));
        datadocument = EDataHandle.getData(datadocument, map, transaction);
        replaceTag(document, datadocument);
        xmloutputter.output(document, new FileOutputStream(s));
        return s;
    }

    public String saveData(String s, Map map, Transaction transaction)
        throws Exception
    {
        Format format = Format.getCompactFormat();
        format.setEncoding("UTF-8");
        format.setIndent("   ");
        XMLOutputter xmloutputter = new XMLOutputter(format);
        Document document = builder.build(new File(dataDefFName));
        document = EDataHandle.getData(document, map, transaction);
        xmloutputter.output(document, new FileOutputStream(s));
        return s;
    }

    private static SAXBuilder builder = new SAXBuilder();
    private Document template;
    private Document datadef;
    private String templateFName;
    private String dataDefFName;

}