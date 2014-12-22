package com.lmt.app.crawler.removenoise.vips;

import java.util.ArrayList;

import org.lobobrowser.html.domimpl.HTMLElementImpl;
import org.lobobrowser.html.domimpl.UINode;
import org.w3c.dom.NodeList;

public class CHTMLNode {
	// 涓嬮潰鐨勫睘鎬т负HTML鏈韩鐨勫睘鎬�
	public String innerHTML;
	public String outerHTML;
	public String innerText;
	public String outerText;

	public String tagName;

	public long offsetTop;
	public long offsetLeft;
	public long offsetRight;
	public long offsetButtom;

	public long offsetWidth;
	public long offsetHeight;

	public HTMLElementImpl htmlElement;
	// public HTMLElementImpl htmlElement2;
	// public HTMLElementImpl htmlElement3;
	// public HTMLElementImpl htmlElement4;

	private int behaviorID;// 鐢ㄤ互鏍囪褰撳墠Node涓婄殑琛屼负

	// 涓嬮潰鐨勫睘鎬у睘浜嶸IPS鏈韩鐨勫睘鎬�
	// 褰撳墠缁撶偣鎵�湪鐨勭粨鐐规睜
	public NodePool nodePool;

	private ArrayList nodeBehaviorList;
	private ArrayList heightList;
	private boolean isTRNode;
	public int DOC;
	// 濡傛灉topLevel涓�,鍚屾椂瀹冨湪鏁翠釜鍏勫紵涓帓琛�,閭ｄ箞璇ョ粨鐐圭殑缂栧彿涓�-2-3-4

	// 璇ョ粨鐐瑰洓鍛ㄧ殑鍒嗗壊鏉�
	public Splitter spLeft; // 璇ョ粨鐐瑰乏渚х殑鍒嗗壊鏉�
	public Splitter spUp; // 涓婁晶鐨勫垎鍓叉潯
	public Splitter spRight; // 鍙充晶鐨勫垎鍓叉潯
	public Splitter spButtom; // 涓嬩晶鐨勫垎鍓叉潯

	// 褰撳墠缁撶偣涓彲鑳藉瓨鍦ㄧ殑鏄惧紡鍒嗛殧鏉�
	private ArrayList explicitSpList;

	public boolean textNode;

	public CHTMLNode(String textString) {
		innerHTML = textString;
		innerText = innerHTML;
		textNode = true;
		tagName = "#text";
	}

	// 浼犲叆褰撳墠缁撶偣鐨処HTMLElement缁撴瀯
	public CHTMLNode(HTMLElementImpl inNode) {
		nodePool = null;
		// 鍒嗛殧鏉″垵濮嬪寲
		spLeft = null;
		spRight = null;
		spUp = null;
		spButtom = null;

		nodeBehaviorList = new ArrayList();
		explicitSpList = new ArrayList();

		htmlElement = inNode;

		innerHTML = inNode.getInnerHTML();
		outerHTML = inNode.getOuterHTML();
		innerText = inNode.getInnerText();
		outerText = inNode.getInnerText();

		HTMLElementImpl bodyNode = inNode;
		// while(bodyNode.offsetParent !=null)
		// bodyNode = bodyNode.offsetParent;

		HTMLElementImpl currentNode = inNode;
		if (currentNode.getParentNode() != null) {
			// if(currentNode.offsetParent == bodyNode) {
			//    offsetTop = currentNode.offsetParent.offsetTop + currentNode.offsetTop;
			//	  offsetLeft = currentNode.offsetParent.offsetLeft + currentNode.offsetLeft;
			// }
			// else
			{
				while (currentNode.getParentNode() != null) {
					offsetTop = offsetTop + (int) currentNode.getUINode().getBounds().y;
					offsetLeft = offsetLeft + currentNode.getUINode().getBounds().x;

					currentNode = (HTMLElementImpl) currentNode.getParentNode();
				}
				// offsetTop = bodyNode + offsetTop;
				// offsetLeft = bodyNode.offsetLeft + offsetLeft;
			}
		} else {
			offsetTop = inNode.getUINode().getBounds().y;
			offsetLeft = inNode.getUINode().getBounds().x;
		}

		offsetWidth = inNode.getUINode().getBounds().width;
		offsetHeight = inNode.getUINode().getBounds().height;

		offsetRight = offsetLeft + offsetWidth;
		offsetButtom = offsetTop + offsetHeight;

		// 鏍规嵁IHTMLElement缁撶偣寰楀埌璇ョ粨鐐圭殑IHTMLElement2缁撴瀯
		// int sourceindex = inNode.getId();
		// IHTMLDocument2 docu =(IHTMLDocument2)inNode.document;
		// htmlElement2 = (IHTMLElement2)docu.all.item(sourceindex,0);
		// htmlElement3 = (IHTMLElement3)docu.all.item(sourceindex,0);
		// htmlElement4 = (IHTMLElement4)docu.all.item(sourceindex,0);

		tagName = inNode.getTagName();

		if (inNode.getTagName() == "TR") {
			heightList = new ArrayList(1);
			htmlElement = inNode;
			isTRNode = true;
		} else
			isTRNode = false;

		textNode = false;
	}

	private boolean checkRight(ArrayList heightList) {
		// IEnumerator enumer = heightList.GetEnumerator();
		// 瀹氫綅鍒扮涓�釜鍏冪礌涔嬪墠
		int i = 0;

		int firstHeight = (Integer) heightList.get(0);
		for (Object Current : heightList) {
			if (firstHeight == (Integer) Current) {
				i++;
				continue;
			}
			// 鍑虹幇涓嶇浉绛夌殑鎯呭喌
			break;
		}

		if (i == heightList.size() - 1)
			return true;

		// 濡傛灉鍙戠幇骞朵笉鏄墍鏈夌殑鐭╁舰鐨勫彸杈�
		return false;
	}

	// 濡傛灉褰撳墠缁撶偣鏄煩褰㈢殑锛屽垯浠�箞閮戒笉澶勭悊
	// 濡傛灉褰撳墠缁撶偣鏄潪鐭╁舰鐨勶紝鍒欏垎鍒彇鍑烘墍鏈夌殑缁撶偣
	public ArrayList getAllSubNode() {
		ArrayList blockList = new ArrayList();
		if (isRectangular()) {
			blockList.add(this);
		} else {
			NodeList allChild = htmlElement.getChildNodes();
			for (int i = 0; i < allChild.getLength(); ++i) {
				CHTMLNode node = new CHTMLNode((HTMLElementImpl) allChild.item(i));
				if (node.isValidNode()) {
					blockList.add(node);
				} else {
					continue;
				}
			}
		}

		return blockList;
	}

	// 鍒ゆ柇褰撳墠TR鐨勭粨鐐规墍浠ｈ〃鐨勫尯鍩熸槸鍚︽槸鐭╁舰
	public boolean isRectangular() {
		// 閬嶅巻澶勭悊htmlNode鐨勬瘡涓�釜瀛╁瓙缁撶偣,鍒嗗埆璁板綍瀹冧滑鐨勫ぇ灏�
		// 寰楀埌鎵�湁缁撶偣鐨勯泦鍚�
		if (isTRNode == true) {
			NodeList allChild = htmlElement.getChildNodes();
			for (int i = 0; i < allChild.getLength(); ++i) {
				UINode child = ((HTMLElementImpl) allChild).getUINode();
				heightList.add(child.getBounds().y + child.getBounds().height);
			}

			return checkRight(heightList);
		} else{
			return true;
		}
	}

	public int DrawNode(Object obj) {
		// 瀵逛簬褰撳墠缁撶偣鐨勬瘡涓�釜child,閮借皟鐢╝ddbehavior
		// 鏈変竴浜涚壒娈婄殑缁撶偣锛屾瘮濡俆R锛孋ENTER锛孌IV绛夌瓑锛屼娇鐢ㄧ粯鍒舵椂鍊欎笉浼氭樉绀轰换浣曞唴瀹癸紝姝ゆ椂蹇呴』瀵瑰瀛愮粨鐐硅繘琛�
		// 缁樺埗
		if(this.tagName.equals("TR") || this.tagName.equals("CENTER") || this.tagName.equals("DIV")) {
			NodeList allChild =  htmlElement.getChildNodes();
			for(int i=0;i<allChild.getLength();++i) {
				HTMLElementImpl child = (HTMLElementImpl)allChild.item(i);
				CHTMLNode node = new CHTMLNode(child);
				int childBehaviorID = node.DrawNode(obj);
				// behaviorID = htmlElement2.addBehavior(null,ref obj);
				NodeInfo info = new NodeInfo();
				info.node = node.htmlElement;
				info.behaviorID = childBehaviorID;
				nodeBehaviorList.add(info);
			}
			return 0;
		} else {
			//behaviorID = htmlElement.addBehavior(null,obj);
			return behaviorID;
		}
	}

	//
	/*public void UnDrawNode() {
		if (this.tagName.equals("TR") 
				|| this.tagName.equals("CENTER")
				|| this.tagName.equals("DIV") ) {
			NodeList allChild = htmlElement.getChildNodes();
			for (int i = 0; i < allChild.getLength(); i++) {
				// 浠巄ehaviorList涓緱鍒扮i涓猙ehaviorID
				NodeInfo info = (NodeInfo) nodeBehaviorList.getElementAt(i);
				info.node.removeBehavior(info.behaviorID);
			}
		} else{
			htmlElement2.removeBehavior(behaviorID);
		}
	}*/

	public void Scroll(int size) {
		//htmlElement.scrollTop = size;
		// htmlElement2.doScroll("down");
	}

	// 鍒ゆ柇褰撳墠鐨勭粨鐐规槸鍚︽槸inline缁撶偣
	// the DOM node with inline text HTML tags, which affect that appearence of
	// text and can be applied to a String
	// of characters without introcducing line break;,such as <B> <BIG> <EM>
	// inline缁撶偣閫氬父鍙奖鍝嶆枃瀛楃殑澶栬,鍥犳瀵逛簬甯冨眬鏈韩褰卞搷涓嶅ぇ
	public boolean isInlineNode() {
		// 鍒ゆ柇褰撳墠缁撶偣鐨則ag鏄惁鏄笅闈㈢殑涓�簺缁勫悎鍗冲彲
		if (htmlElement.getNodeName().equals("B")
				|| htmlElement.getNodeName().equals("BIG")
				|| htmlElement.getNodeName().equals("#text")
				|| htmlElement.getNodeName().equals("EM")
				|| htmlElement.getNodeName().equals("STRONG")
				|| htmlElement.getNodeName().equals("FONT")
				|| htmlElement.getNodeName().equals("I")
				|| htmlElement.getNodeName().equals("U")
				|| htmlElement.getNodeName().equals("SMALL")
				|| htmlElement.getNodeName().equals("STRIKE")
				|| htmlElement.getNodeName().equals("TT")
				|| htmlElement.getNodeName().equals("CODE")
				|| htmlElement.getNodeName().equals("SUB")
				|| htmlElement.getNodeName().equals("SUP")
				|| htmlElement.getNodeName().equals("ADDRESS")
				|| htmlElement.getNodeName().equals("BLOCKQUOTE")
				|| htmlElement.getNodeName().equals("DFN")
				|| htmlElement.getNodeName().equals("SPAN")
				|| htmlElement.getNodeName().equals("IMG")
				|| htmlElement.getNodeName().equals("A")
				|| htmlElement.getNodeName().equals("LI")
				|| htmlElement.getNodeName().equals("VAR")
				|| htmlElement.getNodeName().equals("KBD")
				|| htmlElement.getNodeName().equals("SAMP")
				|| htmlElement.getNodeName().equals("CITE")
				|| htmlElement.getNodeName().equals("H1")
				|| htmlElement.getNodeName().equals("H2")
				|| htmlElement.getNodeName().equals("H3")
				|| htmlElement.getNodeName().equals("H4")
				|| htmlElement.getNodeName().equals("H5")
				|| htmlElement.getNodeName().equals("H6")
				|| htmlElement.getNodeName().equals("BASE")){
			return true;
		} else {
			return false;
		}
	}

	// inline涔嬪鐨勬墍鏈夌殑缁撶偣鎴戜滑缁熺粺绉颁箣涓簂inebreak node
	public boolean isLineBreakNode() {
		return !isInlineNode();
	}

	// 鍦ㄥ瓙缁撶偣涓槸鍚﹀瓨鍦↙ine Break缁撶偣
	private boolean hasLineBreakNodeInChildrens(){
		NodeList allChild =  htmlElement.getChildNodes();
		for(int i=0;i<allChild.getLength();++i) {
			HTMLElementImpl child = (HTMLElementImpl)allChild.item(i);
			CHTMLNode node = new CHTMLNode(child);
			if(node.isLineBreakNode()){
				return true;
			}
		}
		return false;
	}

	private boolean hasHRNodeInChildrens(){
		NodeList allChild =  htmlElement.getChildNodes();
		for(int i=0;i<allChild.getLength();++i) {
			HTMLElementImpl child = (HTMLElementImpl)allChild.item(i);
			if(child.getTagName().equals("HR")){
				return true;
			}
		}
		return false;
	}

	private boolean isVirtual(CHTMLNode node) {
		boolean isVirtualNode = false;

		if(!node.isInlineNode())
			return false;

		NodeList allChild = node.htmlElement.getChildNodes();
		for(int i=0;i<allChild.getLength();++i) {
			HTMLElementImpl child = (HTMLElementImpl)allChild.item(i);
			CHTMLNode cnode = new CHTMLNode(child);
			isVirtualNode =isVirtual(cnode);
			if(isVirtualNode == false)
				return false;
			if(isVirtualNode == true)
				continue;
		}

		return true;
	}

	// 濡傛灉褰撳墠缁撶偣鍐呴儴鍖呭惈IMG鏍囩锛屽垯鑲畾涓嶆槸InValid缁撶偣
	public boolean hasImgInChilds(CHTMLNode node) {
		boolean hasImage = false;

		if(node.tagName == "IMG")
			hasImage = true;

		NodeList allChild = node.htmlElement.getChildNodes();
		for(int i=0;i<allChild.getLength();++i) 
		{
			HTMLElementImpl child = (HTMLElementImpl)allChild.item(i);
			CHTMLNode cnode = new CHTMLNode(child);
			hasImage = hasImgInChilds(cnode);
			if(hasImage == false)
				continue;
			if(hasImage == true)
				return true;
		}
		return hasImage;
	}

	// 鍒ゆ柇褰撳墠鐨勭粰瀹氬瓧绗︽槸鍚︽槸绫讳技浜嶾r\n \r\n鐨勬牸寮�
	private boolean isRNChar(String inStr) {
		if (inStr == null)
			return true;

		inStr = inStr.trim();
		/*
		 * while(inStr[0]=='\r'&&inStr[1]=='\n') { if(inStr.Length == 2) return
		 * true; else inStr = inStr.SubString(3);
		 * 
		 * if(inStr == "") return true; }
		 */
		if (inStr == "")
			return true;

		return false;
	}

	// 鍒ゆ柇褰撳墠鐨勭粨鐐规槸鍚︽槸鍒嗛殧鏉＄粨鐐�
	public boolean isSplitterNode() {
		// 鍒ゆ柇涓�釜缁撶偣鏄惁鍙兘鏄垎闅旀潯缁撶偣鍙互鏍规嵁涓嬮潰鐨勫嚑涓柟闈�
		// 濡傛灉褰撳墠缁撶偣鏄疕R
		if (this.tagName == "HR")
			return true;

		if (this.tagName == "#comment")
			return false;

		if (this.tagName == "")
			return true;

		if (this.tagName.startsWith("/"))
			return false;

		// form鏍囩鐨勫ぇ灏忎负0,0锛屽洜姝ゅ彲鑳借璇垽涓簊plitternode
		if (this.tagName == "FORM" && this.innerText.trim() != "")
			return false;

		// 鏈夌殑鏃跺�缃戦〉璁捐浜哄憳浼氫娇鐢ㄦ瘮杈冪粏鐨勫浘鐗囧仛涓哄垎闅旂锛屽洜姝ゆ垜浠繀椤昏兘澶熸娴嬪嚭鏉�

		// 濡傛灉褰撳墠缁撶偣鐨勫搴︽垨鑰呴珮搴﹀皬浜�5锛岄偅涔堝簲璇ユ槸鍒嗛殧鏉�
		if (this.offsetHeight <= 10 || this.offsetWidth <= 10)
			return true;

		// 濡傛灉涓�釜TR琚瀹氫负鏄垎闅旀潯缁撶偣锛岄偅涔堝畠鐨勬墍鏈夌殑TD缁撶偣閮戒笉闇�鍐嶅垽鏂�
		return false;
	}

	// 鍒ゆ柇褰撳墠缁撶偣鏄惁鏄湁鏁堢殑缁撶偣
	// 鎵�皳鏈夋晥鐨勭粨鐐瑰氨鏄兘澶熶粠娴忚鍣ㄤ腑瑙傚療鍒扮殑缁撶偣
	public boolean isValidNode() {
		// 濡傛灉缁撶偣鐨勫搴︽垨鑰呴珮搴︿负0,閭ｄ箞璇ョ粨鐐逛负鏃犳晥缁撶偣,姣斿<P>,<BR>绛夌瓑
		if (htmlElement.getUINode().getBounds().width == 0 
				|| htmlElement.getUINode().getBounds().height == 0) {
			if (this.tagName == "FORM" && this.innerText.trim() != "")
				return true;
			return false;
		}

		if (htmlElement.getNodeName().equals("SCRIPT") )
			return false;

		// 瀵逛簬琛ㄦ牸鑰岃█,<TD></TD>涔熷簲璇ヤ负鏃犳晥缁撶偣
		// 濡傛灉缁撶偣鐨刬nnerText涓簄ull锛岄偅涔堝繀椤绘鏌ヨ缁撶偣鍐呴儴鏄惁鏈�
		// IMG鏍囩锛�

		// innerText鎴栬�鏄痭ull,鎴栬�鏄痋r\n \r\n ...褰㈠紡

		if (isRNChar(htmlElement.getInnerText())) {
			if (htmlElement.getNodeName().equals("IMG"))
				return true;

			// 妫�煡褰撳墠缁撶偣鍐呴儴鏄惁鏈塈MG鏍囩
			if (hasImgInChilds(this))
				return true;

			return false;
		} else if (htmlElement.getInnerText().trim().equals(""))
			return false;

		return true;
	}

	// 璇ョ粨鐐规槸鏂囨湰缁撶偣,绾补鐨勬枃鏈粨鐐�
	public boolean isTextNode() {
		if (htmlElement.getNodeName().equals("#text"))
			return true;
		else
			return false;
	}

	// 鍒ゆ柇褰撳墠缁撶偣宸茬粡褰撳墠缁撶偣涓嬬殑鎵�湁瀛╁瓙缁撶偣鏄惁閮芥槸铏氭嫙鏂囨湰缁撶偣

	// 鍒ゆ柇褰撳墠缁撶偣鏄惁鏄櫄鎷熸枃鏈粨鐐�
	// 濡傛灉褰撳墠缁撶偣鏄痠nlineNode,骞朵笖瀹冪殑鍐呴儴鐨勬墍鏈夌粨鐐归兘鏄痠nline node
	// 鍒欒缁撶偣灏辨槸铏氭嫙鏂囨湰缁撶偣

	// 鍒ゆ柇褰撳墠缁撶偣鐨勫瀛愮粨鐐瑰叏閮ㄦ槸铏氭嫙鏂囨湰缁撶偣
	// 涓�釜缁撶偣鏄櫄鎷熸枃鏈粨鐐癸紝蹇呴』婊¤冻涓嬮潰鐨勫嚑涓潯浠�
	// 1.鎵�湁缁撶偣閮芥槸鏂囨湰缁撶偣
	// 2.濡傛灉涓�釜缁撶偣鏄櫄鎷熸枃鏈粨鐐癸紝璇ョ粨鐐圭殑鐖剁粨鐐逛笉鏄痠nline缁撶偣锛�
	// 浣嗘槸璇ョ粨鐐圭殑鐖剁粨鐐瑰彧鏈夊畠涓�釜瀛╁瓙缁撶偣锛屾病鏈夊叾浣欑殑瀛╁瓙缁撶偣锛岄偅涔堝畠鐨勭埗缁撶偣涔熸槸
	// 铏氭嫙鏂囨湰缁撶偣

	// 浠ュ綋鍓嶇粨鐐逛负鏍圭粨鐐�濡傛灉褰撳墠缁撶偣鐨勫瀛愮粨鐐逛腑鍑虹幇涓�釜linebreak缁撶偣,鍒欒缁撶偣骞朵笉鏄�
	// RealVirtualText缁撶偣
	private boolean isRealVirtualTextNode(CHTMLNode node) {
		NodeList allChild = node.htmlElement.getChildNodes();
		for(int i=0;i<allChild.getLength();++i) {
			HTMLElementImpl child = (HTMLElementImpl)allChild.item(i);
			CHTMLNode cnode = new CHTMLNode(child);
			if(isVirtual(cnode) == false)
				return false;
			continue;
		}
		return true;
	}

	public boolean isVirtualTextNode() {
		if (this.tagName == "LI" || this.tagName == "SELECT" || this.tagName == "MARQUEE" || this.tagName == "FORM")
			return true;

		// 濡傛灉褰撳墠缁撶偣涓�

		if (this.tagName == "UL" || this.tagName == "OL")
			return false;
		// 濡傛灉褰撳墠缁撶偣鏄櫄鎷熸枃鏈粨鐐�
		if (isRealVirtualTextNode(this))
			return true;

		// 瀵瑰綋鍓嶇粨鐐圭殑鎵�湁瀛╁瓙缁撶偣杩涜澶勭悊,濡傛灉褰撳墠鐨勫瀛愮粨鐐逛腑瀛樺湪涓�釜
		// LineBreak缁撶偣,鍒欒繑鍥瀎alse

		// 濡傛灉褰撳墠缁撶偣骞朵笉鏄櫄鎷熺粨鐐�浣嗘槸瀹冪殑绗竴涓瀛愮粨鐐规暟鐩笉涓�鐨勭粨鐐规槸铏氭嫙缁撶偣
		// 閭ｄ箞璇ョ粨鐐逛篃鏄櫄鎷熺粨鐐�
		CHTMLNode tmpNode = getNonOneChildNode(this);
		if (isRealVirtualTextNode(tmpNode))
			return true;

		return false;
	}

	// 濡傛灉褰撳墠缁撶偣鐨勫瀛愮粨鐐逛腑鍖呭惈<HR>鏍囩,鍒欑户缁繘琛屽垎鍓�

	// 寰楀埌褰撳墠缁撶偣鐨勫瀛愮粨鐐规暟鐩�
	public int getChildrenNum() {
		// 鍏堣浆鎹负IHTMLDOMNode缁撶偣
		//IHTMLDOMNode domNode = (IHTMLDOMNode) this.htmlElement;
		//IHTMLDOMChildrenCollection allchild = (IHTMLDOMChildrenCollection) domNode.childNodes;
		
		return this.htmlElement.getChildNodes().getLength();

		// HTMLElementCollection allChild =
		// (HTMLElementCollection)htmlElement.children;
		// return allChild.length;
	}

	// 璇ョ粨鐐瑰叿鏈夊敮涓�殑涓�釜缁撶偣,骞朵笖璇ョ粨鐐归潪鏂囨湰缁撶偣
	private boolean hasOnlyOneNoneText(CHTMLNode node) {
		if (node.getChildrenNum() == 1) {
			/*
			 * HTMLElementCollection allChild =
			 * (HTMLElementCollection)htmlElement.children;
			 * foreach(IHTMLElement child in allChild) { CHTMLNode node = new
			 * CHTMLNode(child); if(node.tagName == "#text") return false; }
			 */

			return true;
		}
		return false;
	}

	// 涓嬮潰鐨勫嚑涓柟娉曠敤浠ユ洿鏂归潰鐨勮幏鍙栧綋鍓嶇粨鐐圭殑灞炴�
	// 鑾峰彇褰撳墠缁撶偣鐨勮儗鏅壊
	public String getBgColor() {
		return htmlElement.getStyle().getBackgroundColor();
	}

	// 鑾峰彇瀛椾綋鐨勯鑹�
	public String getFgColor() {
		return htmlElement.getStyle().getColor();
	}

	// 鑾峰彇瀛椾綋鐨勫ぇ灏�
	public String getFontSize() {
		return htmlElement.getStyle().getFontSize();
	}

	// 鑾峰彇瀛椾綋鐨勭矖缁�
	public String getFontWeight() {
		return htmlElement.getStyle().getFontWeight();
	}

	// 鑾峰彇瀛椾綋鐨勭被鍨�
	public String getFontFamily() {
		return htmlElement.getStyle().getFontFamily();
	}

	// 鍒ゆ柇褰撳墠缁撶偣鐨勮儗鏅壊鏄惁涓庢墍鏈夌殑瀛愮粨鐐归兘鐩稿悓
	// 濡傛灉涓嶇浉鍚�鍒欑户缁垎鍓�
	public boolean isSameBgColor() {
		String bgColor = getBgColor();
		// 鍒ゆ柇姣忎竴涓瓙缁撶偣鐨勮儗鏅槸鍚︾浉鍚�
		NodeList allChild = htmlElement.getChildNodes();
		for(int i=0;i<allChild.getLength();++i) {
			HTMLElementImpl child = (HTMLElementImpl)allChild.item(i);
			CHTMLNode node = new CHTMLNode(child);
			if(bgColor != node.getBgColor()) {
				return false;
			}
		}
		return true;

	}

	// 鍒ゆ柇褰撳墠缁撶偣鐨勫瓧浣撶矖缁嗘槸鍚︿笌瀛愮粨鐐圭殑瀹屽叏鐩稿悓
	public boolean isSameFontWeight() {
		String fontWeight = getFontWeight();
		NodeList allChild =  htmlElement.getChildNodes();
		for(int i=0;i<allChild.getLength();++i) {
			HTMLElementImpl child = (HTMLElementImpl)allChild.item(i);
			CHTMLNode node = new CHTMLNode(child);
			if(fontWeight != node.getFontWeight())
				return false;
		}		
		return true;
	}

	// 鍒ゆ柇褰撳墠缁撶偣鐨勫瓧浣撶矖缁嗘槸鍚︿笌瀛愮粨鐐圭殑瀹屽叏鐩稿悓
	public boolean isSameFontSize() {
		String fontSize = getFontSize();
		NodeList allChild =  htmlElement.getChildNodes();
		for(int i=0;i<allChild.getLength();++i) {
			HTMLElementImpl child = (HTMLElementImpl)allChild.item(i);
			CHTMLNode node = new CHTMLNode(child);
			if(fontSize != node.getFontSize())
				return false;
		}
		return true;
	}

	public boolean isSameForeColor() {
		String foreColor = getFgColor();
		// 鍒ゆ柇姣忎竴涓瓙缁撶偣鐨勮儗鏅槸鍚︾浉鍚�
		NodeList allChild =  htmlElement.getChildNodes();
		for(int i=0;i<allChild.getLength();++i) {
			HTMLElementImpl child = (HTMLElementImpl)allChild.item(i);
			CHTMLNode node = new CHTMLNode(child);
			if(foreColor != node.getFgColor())
				return false;
		}
		return true;

	}

	// 褰撳墠缁撶偣鐨勬墍鏈夌殑瀛愮粨鐐圭殑瀛椾綋鏄惁涓�嚧
	// 濡傛灉鏈変竴涓笉涓�嚧,杩斿洖false
	public boolean isSameFontFamily() {
		String fontFamily = getFontFamily();
		NodeList allChild =  htmlElement.getChildNodes();
		for(int i=0;i<allChild.getLength();++i) {
			HTMLElementImpl child = (HTMLElementImpl)allChild.item(i);
			CHTMLNode node = new CHTMLNode(child);
			if(fontFamily != node.getFontFamily())
				return false;
		}		
		return true;
	}

	// 鍒ゆ柇褰撳墠缁撶偣鏄惁鏄疎nd缁撶偣,鍗充笉鍙户缁垎鍓�
	// 瀵逛簬鎵�湁鐨凟nd Node,瀹冪殑DOC鐨勫�灏嗚璁剧疆涓�0,琛ㄧず涓嶅啀鍙互琚垎鍓�
	private boolean isEndNode() {
		// End Node鍖呮嫭涓ょ,涓�灏辨槸鍥剧墖IMG,涓�灏辨槸鏂囨湰
		// is IHTMLImgElement || htmlElement is IHTMLTextElement
		if(htmlElement.getNodeName().equals("IMG")
				|| htmlElement.getNodeName().equals("TEXT") )
			return true;
		else
			return false;
	}

	// 鍒ゆ柇褰撳墠缁撶偣鐨勫瀛愮粨鐐规槸鍚﹂兘鏄悓涓�被鍨�閫氬父鎯呭喌涓�
	private boolean isSameTypeNode() {
		return false;
	}

	// 鍒ゆ柇褰撳墠缁撶偣鏄惁鍙互缁х画鍒嗗壊涓烘洿灏忕殑缁撶偣
	// 鍒ゆ柇缁欏畾鐨勭粨鐐规槸鍚﹀彲浠ュ垎鍓�涓昏閫氳繃浠ヤ笅浠ヤ笅鍘熷垯
	// 1.褰撳墠缁撶偣鏈韩鐨勫睘鎬�
	// 1.濡傛灉褰撳墠缁撶偣骞朵笉鏄煩褰�鍒欏繀椤昏繘琛屽垎鍓�
	// 2.濡傛灉褰撳墠缁撶偣鐨凞OC灏忎簬PDOC,鍒欏繀椤昏繘琛屽垎鍓�
	// 2.褰撳墠缁撶偣鐨勫瓙缁撶偣鐨勫睘鎬�
	// 1.瀛愮粨鐐圭殑绫诲瀷
	// 2.瀛愮粨鐐圭殑鏁扮洰
	public boolean isDividable(int currentLevel, int pDOC) {
		// 褰撳垎鍓插眰娆¤揪鍒颁簡pDOC鍚庨�杩囪繑鍥瀎alse绂佹缁х画鍒嗗壊
		if (currentLevel == pDOC)
			return false;

		// 濡傛灉褰撳墠缁撶偣鏄潪鐭╁舰,蹇呴』缁х画杩涜鍒嗗壊
		if (!isRectangular())
			return true;

		// If the DOM node has only one valid child and the child is not a text
		// node,
		// then divide this node
		if (hasOnlyOneNoneText(this))
			return true;

		// 濡傛灉褰撳墠缁撶偣鏄椤甸潰鍧桪OM鏍戠殑鏍圭粨鐐癸紝鍚屾椂鍙湁涓�釜瀛╁瓙缁撶偣锛岄偅涔堝垎鍓茶缁撶偣

		// 濡傛灉褰撳墠缁撶偣鐨勬墍鏈夌殑瀛╁瓙缁撶偣閮芥槸鏂囨湰缁撶偣鎴栬�鏄櫄鎷熸枃鏈粨鐐癸紝閭ｄ箞涓嶅垎鍓茶鑺傜偣銆�
		// 濡傛灉褰撳墠鎵�湁瀛╁瓙缁撶偣鐨勫瓧浣撳ぇ灏忓拰瀛椾綋閲嶉噺閮芥槸鐩稿悓鐨勶紝閭ｄ箞璇ラ〉闈㈠潡鐨凞oC璁剧疆涓�0锛屽惁鍒欒缃负9銆�
		// 濡傛灉褰撳墠缁撶偣鐨勬墍鏈夌粨鐐归兘鏄櫄鎷熸枃鏈粨鐐癸紝閭ｄ箞璇ョ粨鐐瑰皢涓嶅啀鍒嗛殧
		if (isVirtualTextNode())
			return false;

		// If one of the child nodes of the DOM node is line-break node, then
		// divide this DOM node
		// Rule5
		// 濡傛灉褰撳墠DOM缁撶偣鐨勫瀛愮粨鐐逛腑鏈変竴涓猯ine-break缁撶偣锛岄偅涔堣缁撶偣灏嗚缁х画鍒嗗壊
		if (hasLineBreakNodeInChildrens())
			return true;

		// 濡傛灉褰撳墠缁撶偣鍐呴儴鍖呭惈HR鏍囩,鍒欏繀椤昏繘琛岀户缁垎鍓�
		// Rule6
		if (hasHRNodeInChildrens())
			return true;

		// If the background color of this node is different from one of its
		// children's
		// divide this node and at the same time,the child node with different
		// background color
		// will not divide in this round
		if (!isSameBgColor())
			return true;

		// If the node has at least one text node child or at least one virtual
		// text node child ,and the node's

		return false;
	}

	// 鏁翠釜澶勭悊杩囩▼鍒嗕负涓夋:
	// 1.妫�祴閫昏緫鍧�
	// 2.妫�祴鍚勪釜閫昏緫鍧椾箣闂寸殑鍒嗗壊鏉�
	// 3.閲嶆柊鍚堝苟

	// pDOC鏄鍏堣瀹氱殑DOC鍊�
	// currentLevel鏄綋鍓嶇殑鍒嗗壊灞傛,鐢变簬pDOC鏈韩鐨勬蹇靛苟涓嶆槸鐗瑰埆鐨勫鏄撴帉鎻�
	// 鍥犳鎴戜滑鍏堝皾璇曚娇鐢╨evel鐨勬蹇垫浛浠�姣忔divideDOMTree鍚巆urrentLevel閮藉皢澧炲姞涓�
	// 褰揷urrentLevel杈惧埌pDOC涔嬪悗,鍒嗗壊灏嗗仠姝�
	// pool鐩墠鏄痓ody

	// 鑾峰彇褰撳墠缁撶偣鐨勭涓�釜瀛╁瓙缁撶偣
	public CHTMLNode getFirstChildNode() {
		return (CHTMLNode) htmlElement.getFirstChild();
		//if (allChild.length > 0)
		//	return new CHTMLNode((IHTMLElement) allChild.item(0, 0));
		//else
		//	return null;
	}

	// 鑾峰彇璇ョ粰瀹氱粨鐐逛腑绗竴涓瀛愮粨鐐逛笉涓�鐨勭粨鐐�
	// 濡傛灉褰撳墠缁撶偣鏄枃鏈帴鐐癸紝鐩存帴杩斿洖
	private CHTMLNode getNonOneChildNode(CHTMLNode node) {
		CHTMLNode childNode = node;
		while (hasOnlyOneNoneText(childNode)) {
			childNode = childNode.getFirstChildNode();
			if (childNode.isVirtualTextNode())
				break;
		}

		return childNode;
	}

	// 鍒ゆ柇褰撳墠缁撶偣鏄笉鏄彲瑙嗙粨鐐癸紝鎵�皳鍙缁撶偣锛屽氨鏄彲浠ラ�杩囩粯鍒惰竟妗嗘樉绀哄嚭鏉ョ殑
	public boolean isNonVisualNode() {
		if (this.isVirtualTextNode())
			return false;

		if (this.tagName == "CENTER" || this.tagName == "DIV"
				|| this.tagName == "TR" || this.tagName == "P")
			return true;

		return false;
	}

	// 鍑芥暟杩斿洖鐨勬槸鎵�湁鐨勫綋鍓嶅垎闅旀潯鑾峰彇鐨勬墍鏈夌殑鍒嗛殧鏉＄粨鐐瑰垪琛�
	public ArrayList divideDOMTree(NodePool pool, int pDOC) {
		ArrayList list = new ArrayList();
		ArrayList spNodeList = new ArrayList();

		if (this.tagName.equals("TABLE")) {
			TableDividePolicy tablePolicy = new TableDividePolicy();
			return tablePolicy.divideNode(this, pool, pDOC);
		} else if (this.tagName.equals("TD")) {
			TdDividePolicy tdPolicy = new TdDividePolicy();
			return tdPolicy.divideNode(this, pool, pDOC);
		} else if (this.isNonVisualNode()) {
			NonVisualDividePolicy nonVisualPolicy = new NonVisualDividePolicy();
			return nonVisualPolicy.divideNode(this, pool, pDOC);
		} else {
			OtherDividePolicy otherPolicy = new OtherDividePolicy();
			return otherPolicy.divideNode(this, pool, pDOC);
		}
	}

	// direction 0:up,1:buttom,2:left,3:right
	public void setNeighbourSplitter(Splitter sp, int direction) {
		if (direction == 0)
			spUp = sp;
		else if (direction == 1)
			spButtom = sp;
		else if (direction == 2)
			spLeft = sp;
		else
			spRight = sp;
	}

	// 寰楀埌褰撳墠缁撶偣鐨勭埗浜茬粨鐐�
	public CHTMLNode getParent() {
		return new CHTMLNode((HTMLElementImpl) htmlElement.getParentNode());
	}

	// 鑾峰彇鍙缁撶偣
}
