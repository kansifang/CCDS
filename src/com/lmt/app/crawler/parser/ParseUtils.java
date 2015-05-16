/*
 * Copyright (C) 2014 hu
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

package com.lmt.app.crawler.parser;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.UnsupportedEncodingException;

import org.apache.html.dom.HTMLDocumentImpl;
import org.cyberneko.html.parsers.DOMFragmentParser;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.w3c.dom.DocumentFragment;
import org.w3c.dom.Node;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.lmt.app.crawler.model.Page;
import com.lmt.app.crawler.util.CharsetDetector;

/**
 * 解析辅助类
 * @author hu
 */
public class ParseUtils {
	public static Page parseDocumentJsoup(Page page){
        Document doc=parseDocumentJsoup(page.getContent(), page.getUrl());
        page.setDoc(doc);
        return page;
    }
	//使用Jsoup解析html
    public static Document parseDocumentJsoup(byte[] content,String url){
        String charset=CharsetDetector.guessEncoding(content);
        String html;
        try {
            html = new String(content,charset);
        } catch (UnsupportedEncodingException ex) {
            return null;
        }
        Document doc=Jsoup.parse(html);
        doc.setBaseUri(url);
        return doc;
    } 
    //对文件输入进行解析
    public static Node parseDocumentNeko(File file) {
		DataInputStream in = null;
		byte[] bytes = new byte[(int) file.length()];
		try {
			in = new DataInputStream(new FileInputStream(file));
			in.readFully(bytes);
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				in.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return ParseUtils.parseDocumentNeko(bytes);
	}
    //对字节数组进行解析
    //使用CyberNeko解析html
    public static DocumentFragment parseDocumentNeko(byte[] content){
        String charset=CharsetDetector.guessEncoding(content);
        DocumentFragment doc=ParseUtils.parseDocumentNeko(content,charset);
        return doc;
    } 
    public static DocumentFragment parseDocumentNeko(byte[] bytes,String charset) {
		DocumentFragment node = null;
		InputSource input = null;
		ByteArrayInputStream stream = new ByteArrayInputStream(bytes);
		input = new InputSource(stream);
		try {
			node = ParseUtils.parseDocumentNeko(input,charset);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				stream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return node;
	}
    //CyberNeko 是一个HTML解析器,它可以将HTML文件解析成w3c的Document对象。
  	public static DocumentFragment parseDocumentNeko(InputSource input,String charset) throws Exception {
  		DOMFragmentParser parser = new DOMFragmentParser();
  		HTMLDocumentImpl doc = new HTMLDocumentImpl();
  		try {
  			parser.setProperty("http://cyberneko.org/html/properties/default-encoding",charset);
  			parser.setFeature("http://cyberneko.org/html/features/augmentations", false);
  			parser.setFeature("http://cyberneko.org/html/features/scanner/ignore-specified-charset",true);
  			parser.setFeature("http://cyberneko.org/html/features/balance-tags/ignore-outside-content",false);
  			parser.setFeature("http://cyberneko.org/html/features/balance-tags/document-fragment",true);
  			parser.setFeature("http://cyberneko.org/html/features/report-errors", false);
  		} catch (SAXException e) {
  		}
  		doc.setErrorChecking(true);
  		DocumentFragment res = doc.createDocumentFragment();
  		
  		DocumentFragment frag = doc.createDocumentFragment();
  		parser.parse(input, frag);
  		res.appendChild(frag);
  		try {
  			while (true) {
  				frag = doc.createDocumentFragment();
  				parser.parse(input, frag);
  				if (!frag.hasChildNodes())
  					break;
  				System.out.println(" - new frag, "+ frag.getChildNodes().getLength() + " nodes.");
  				res.appendChild(frag);
  			}
  		} catch (Exception e) {
  			e.printStackTrace();
  		}
  		return res;
  	}
}