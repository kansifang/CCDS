package com.lmt.app.crawler.removenoise.SST;

import java.io.UnsupportedEncodingException;

import org.w3c.dom.Node;

import com.lmt.app.crawler.parser.ParseUtils;

import junit.framework.TestCase;

public class testStyleTree extends TestCase {
        private static String str1 = "<tr><a href=\"www.daum.net\">中国</a></tr>";
        private static String str2 = "<tr><a href=\"www.daum.net\">中国</a><p>汽车</p></tr>";
        public void testEquals() throws UnsupportedEncodingException {
                Node node = null;
                StyleTree sTree = new StyleTree();
                
                sTree.train(str1.getBytes());
                sTree.train(str2.getBytes());
                sTree.printInformation();
        }
}
