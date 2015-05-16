package com.lmt.app.crawler.removenoise.SST;

import junit.framework.TestCase;

import org.w3c.dom.Node;

import com.lmt.app.crawler.parser.ParseUtils;

public class testElementNode extends TestCase {
        private ElementNode elementNode;
        private final static String ahrefString = "<a href=\"www.daum.net\">abc</a>";
        private final static String textString = "abc";
        protected void setUp() {
        }
        
        protected void tearDown() {
        }
        
        public void testRootToString() {
                this.elementNode = ElementNode.getInstanceOf();
                assertEquals(elementNode.nodeToString(this.elementNode.getNode()), "root");
        }
        
        public void testAhrefToString() {
                this.elementNode = ElementNode.getInstanceOf((Node)ParseUtils.parseDocumentNeko(ahrefString.getBytes()));
                assert(ahrefString.equalsIgnoreCase(elementNode.nodeToString(elementNode.getNode())));
        }
        
        public void testTextToString() {
                this.elementNode = ElementNode.getInstanceOf((Node)ParseUtils.parseDocumentNeko(textString.getBytes()));
                //assert(textString.equalsIgnoreCase(elementNode.nodeToString(elementNode.getNode())));
        }
        
        public void testAddSameStyleNode() {
                Node node = null;
                this.elementNode = ElementNode.getInstanceOf();
                
                node = (Node)ParseUtils.parseDocumentNeko(ahrefString.getBytes());;
                this.elementNode.trainNode(node);
                assertEquals(1, this.elementNode.getChildren().size());
                
                node = (Node)ParseUtils.parseDocumentNeko(ahrefString.getBytes());
                this.elementNode.trainNode(node);
                assertEquals(1, this.elementNode.getChildren().size());
        }
        
        public void testAddDifferentStyleNode() {
                Node node = null;
                this.elementNode = ElementNode.getInstanceOf();
                
                node = (Node)ParseUtils.parseDocumentNeko(ahrefString.getBytes());;
                this.elementNode.trainNode(node);
                assertEquals(1, this.elementNode.getChildren().size());
                
                node = (Node)ParseUtils.parseDocumentNeko(textString.getBytes());
                this.elementNode.trainNode(node);
                assertEquals(2, this.elementNode.getChildren().size());
        }
}