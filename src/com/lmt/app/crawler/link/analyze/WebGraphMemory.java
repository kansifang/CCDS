package com.lmt.app.crawler.link.analyze;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class WebGraphMemory {
	/**下面两个是把 url 映射成 数字 或相反
	 * A Map storing relationships from URLs to numeric identifiers, usefull for
	 * storing Web graphs
	 */
	private Map<String, Map<String, Integer>> URLToIdentifyer;
	// 把每个URL映射为一个整数，存储在web图中
	private Map<Integer, String> IdentifyerToURL;
	//假定一个网址内所有编码都是一样的，所以此处存储一个主机的编码
	private Map<String, String> HostToEncode;
	/**
	 * 存储入度，其中整数第一个参数是URL的ID，第二个参数是存放指向这个URL链接的Map，Double表示权重
	 */
	private Map<Integer, Map<Integer, Double>> InLinks;

	/**
	 * 存储出度，其中第一个参数是URL的ID，第二个参数是存放网页中的超链接，Double表示权重
	 */
	private Map<Integer, Map<Integer, Double>> OutLinks;
	/** 图中节点的数目 */
	private int nodeCount=0;

	/**
	 * 构造函数，0个节点的构造函数
	 */
	public WebGraphMemory() {
		IdentifyerToURL = new HashMap<Integer, String>();
		URLToIdentifyer = new HashMap<String, Map<String, Integer>>();
		HostToEncode=new HashMap<String,String>();
		InLinks = new HashMap<Integer, Map<Integer, Double>>();
		OutLinks = new HashMap<Integer, Map<Integer, Double>>();
		nodeCount = 0;
	}

	/**
	 * 从一个文本文件中取得节点的构造函数。 每行包含一个指向关系。例如： http://url1.com -> http://url2.com 1.0
	 * 表示 "http://url1.com" 包含一个超链接 "http://url2.com", 并且这个超链接的权重是1.0
	 * /Seeds.properties
	 */
	public WebGraphMemory(String srcFileName) throws IOException, FileNotFoundException {
		this();
		InputStream localInputStream = getClass().getClassLoader().getResourceAsStream("/"+srcFileName);
		BufferedReader reader = new BufferedReader(new InputStreamReader(localInputStream));
		String line;
		while ((line = reader.readLine()) != null) {
			if(line.startsWith("#")){
				continue;
			}
			int index1 = line.indexOf("->");
			if (index1 == -1)
				addLink(line.trim());
			else {
				String url1 = line.substring(0, index1).trim();
				String url2 = line.substring(index1 + 2).trim();
				Double strength = new Double(1.0);
				index1 = url2.indexOf(" ");//以空格分隔，后面跟 权重
				if (index1 != -1){
					strength = new Double(url2.substring(index1 + 1).trim());
					url2 = url2.substring(0, index1).trim();
				}
				addLink(url1, url2, strength);
			}
		}
	}
	/**
	 * 从一个文本文件中取得节点的构造函数。 每行包含一个指向关系。例如： http://url1.com -> http://url2.com 1.0
	 * 表示 "http://url1.com" 包含一个超链接 "http://url2.com", 并且这个超链接的权重是1.0
	 */
	public WebGraphMemory(File file) throws IOException, FileNotFoundException {
		this();
		BufferedReader reader = new BufferedReader(new FileReader(file));
		String line;
		while ((line = reader.readLine()) != null) {
			int index1 = line.indexOf("->");
			if (index1 == -1)
				addLink(line.trim());
			else {
				String url1 = line.substring(0, index1).trim();
				String url2 = line.substring(index1 + 2).trim();
				Double strength = new Double(1.0);
				index1 = url2.indexOf(" ");//以空格分隔，后面跟 权重
				if (index1 != -1){
					strength = new Double(url2.substring(index1 + 1).trim());
					url2 = url2.substring(0, index1).trim();
				}
				addLink(url1, url2, strength);
			}
		}
	}
	/**
	 * 从一个文本文件中取得节点的构造函数。 每行包含一个指向关系。例如： http://url1.com -> http://url2.com 1.0
	 * 表示 "http://url1.com" 包含一个超链接 "http://url2.com", 并且这个超链接的权重是1.0
	 */
	public void addLink(String fromUrl,Set<String> toUrls){
		Iterator<String> it=toUrls.iterator();
		do{
			if(toUrls==null||toUrls.size()==0){
				addLink(fromUrl.trim());
				break;
			}else {
				String url1 = fromUrl.trim();
				String toUrl = it.next().trim();
				Double strength = new Double(1.0);//默认权重都是1
				addLink(url1, toUrl, strength);
			}
		}while (it.hasNext());
	}
	/**
	 * 在两个节点中增加一个对应关系。如果节点不存在，就新创建节点
	 */
	public Double addLink(String fromLink, String toLink, Double weight) {
		Integer id1 = addLink(fromLink);
		Integer id2 = addLink(toLink);
		return addLink(id1, id2, weight);
	}
	/**
	 * 在图中增加一个节点
	 */
	public Integer addLink(String URL) {
		Integer id = URLToIdentifyer(URL);
		if (id == null) {
			id = new Integer(++nodeCount);
			String host = this.splitUrl(URL,1);
			String name = this.splitUrl(URL,2);
			// System.out.println("HOST:"+host + " name:"+name);
			Map<String, Integer> map = (URLToIdentifyer.get(host));
			if (map == null) {
				map = new HashMap<String, Integer>();
				URLToIdentifyer.put(host, map);
			}
			map.put(name, id);
			// error here
			// URLToIdentifyer.put(link,map);
			IdentifyerToURL.put(id, URL);
			InLinks.put(id, new HashMap<Integer, Double>());
			OutLinks.put(id, new HashMap<Integer, Double>());
			// System.out.println("id:"+id);
		}
		return id;
	}

	/**
	 * 在两个节点中增加一个对应关系。如果节点不存在，就新创建节点
	 */
	private Double addLink(Integer fromLink, Integer toLink, Double weight) {
		// System.out.println("from "+fromLink+" to "+toLink);
		Double aux;
		Map<Integer, Double> map1 = InLinks.get(toLink);
		Map<Integer, Double> map2 = OutLinks.get(fromLink);
		aux = (Double) (map1.get(fromLink));
		if (aux == null)
			map1.put(fromLink, weight);
		else if (aux.doubleValue() < weight.doubleValue())
			map1.put(fromLink, weight);
		else
			weight = new Double(aux.doubleValue());
		aux = (map2.get(toLink));
		if (aux == null)
			map2.put(toLink, weight);
		else if (aux.doubleValue() < weight.doubleValue())
			map2.put(toLink, weight);
		else {
			weight = new Double(aux.doubleValue());
			map1.put(fromLink, weight);
		}
		InLinks.put(toLink, map1);
		OutLinks.put(fromLink, map2);
		return weight;
	}
	/**
	 * 根据URL制定它的ID
	 */
	public Integer URLToIdentifyer(String URL) {
		String host = this.splitUrl(URL,1);
		String name = this.splitUrl(URL,2);
		// System.out.println("host:"+host + " name:"+name);
		Map<String, Integer> map = (URLToIdentifyer.get(host));
		if (map == null) {
			// System.out.println("will return null");
			return null;
		}
		// System.out.println("return:"+map.get(""));
		return (map.get(name));
	}

	/**
	 * 根据ID获得URL
	 */
	public String IdentifyerToURL(Integer id) {
		return (IdentifyerToURL.get(id));
	}
	public void setHostToEncode(String URL,String Encoding) {
		HostToEncode.put(this.splitUrl(URL,1),Encoding);
	}
	/**
	 * 根据URL获得该网站的字符编码
	 */
	public String hostToEncode(String URL) {
		return (HostToEncode.get(this.splitUrl(URL,1)));
	}
	/**
	 * 针对指定的URL返回包含它的入度的链接的Map
	 */
	public Map inLinks(String URL) {
		Integer id = URLToIdentifyer(URL);
		return inLinks(id);
	}

	/**
	 * 针对指定的URL返回包含它的入度的链接的Map
	 */
	public Map<Integer, Double> inLinks(Integer link) {
		if (link == null)
			return null;
		Map<Integer, Double> aux = (InLinks.get(link));
		return aux;
	}

	/**
	 * 针对指定的URL返回包含它的出度的链接的Map
	 */
	public Map<Integer, Double> outLinks(String URL) {
		Integer id = URLToIdentifyer(URL);
		return outLinks(id);
	}

	/**
	 * 针对指定的URL返回包含它的出度的链接的Map
	 */
	public Map<Integer, Double> outLinks(Integer link) {
		if (link == null)
			return null;
		Map<Integer, Double> aux = OutLinks.get(link);
		return aux;
	}

	/**
	 * 返回两个节点之间的权重，如果节点没有连接，就返回0
	 */
	public Double inLink(String fromLink, String toLink) {
		Integer id1 = URLToIdentifyer(fromLink);
		Integer id2 = URLToIdentifyer(toLink);
		return inLink(id1, id2);
	}

	/**
	 * 返回两个节点之间的权重，如果节点没有连接，就返回0
	 */
	public Double outLink(String fromLink, String toLink) {
		Integer id1 = URLToIdentifyer(fromLink);
		Integer id2 = URLToIdentifyer(toLink);
		return outLink(id1, id2);
	}

	/**
	 * 返回两个节点之间的权重，如果节点没有连接，就返回0
	 */
	public Double inLink(Integer fromLink, Integer toLink) {
		Map<Integer, Double> aux = inLinks(toLink);
		if (aux == null)
			return new Double(0);
		Double weight = (aux.get(fromLink));
		return (weight == null) ? new Double(0) : weight;
	}

	/**
	 * 返回两个节点之间的权重，如果节点没有连接，就返回0
	 */
	public Double outLink(Integer fromLink, Integer toLink) {
		Map<Integer, Double> aux = outLinks(fromLink);
		if (aux == null)
			return new Double(0);
		Double weight = (aux.get(toLink));
		return (weight == null) ? new Double(0) : weight;
	}

	/**
	 * 把有向图变为无向图。
	 */
	public void transformUnidirectional() {
		Iterator<Integer> it = OutLinks.keySet().iterator();
		while (it.hasNext()) {
			Integer link1 = (Integer) (it.next());
			Map<Integer, Double> auxMap = OutLinks.get(link1);
			Iterator<Integer> it2 = auxMap.keySet().iterator();
			while (it2.hasNext()) {
				Integer link2 = (Integer) (it.next());
				Double weight = auxMap.get(link2);
				addLink(link2, link1, weight);
			}
		}
	}

	/**
	 * 删除内部链接，内部链接就是指在同一主机上的链接
	 */
	public void removeInternalLinks() {
		int index1;
		Iterator it = OutLinks.keySet().iterator();
		while (it.hasNext()) {
			Integer link1 = (Integer) (it.next());
			Map<Integer, Double> auxMap = (OutLinks.get(link1));
			Iterator it2 = auxMap.keySet().iterator();
			if (it2.hasNext()) {
				String host1 = this.getHost(link1);
				while (it2.hasNext()) {
					Integer link2 = (Integer) (it2.next());//it2书上是it，明显是错的
					String host2 = this.getHost(link2);
					if (host1.equals(host2)) {
						auxMap.remove(link2);
						OutLinks.put(link1, auxMap);
						auxMap = (InLinks.get(link2));
						auxMap.remove(link1);
						InLinks.put(link2, auxMap);
					}
				}
			}
		}
	}

	/**
	 * 删除内部导航链接。
	 */
	public void removeNepotistic() {
		removeInternalLinks();
	}

	/**
	 * 删除 stop URLs.。
	 */
	public void removeStopLinks(String stopURLs[]) {
		HashMap aux = new HashMap();
		for (int i = 0; i < stopURLs.length; i++)
			aux.put(stopURLs[i], null);
		removeStopLinks(aux);
	}

	/**
	 * 删除 stop URLs。
	 */
	public void removeStopLinks(Map stopURLs) {
		int index1;
		Iterator it = OutLinks.keySet().iterator();
		while (it.hasNext()) {
			Integer link1 = (Integer) (it.next());
			String host = this.getHost(link1);
			if (stopURLs.containsKey(host)) {
				OutLinks.put(link1, new HashMap());
				InLinks.put(link1, new HashMap());
			}
		}
	}

	public int numNodes() {
		return nodeCount;
	}
	private String getHost(int id){
		String URL = (String) (IdentifyerToURL.get(id));
		return this.splitUrl(URL,1);
	}
	//本方法用用下面的代替
	private String[] splitUrl(String URL){
		int index = URL.indexOf("://");
		if (index != -1)
			URL = URL.substring(index + 3);
		index = URL.indexOf("/");
		if (index != -1){
			return new String[]{URL.substring(0, index),URL.substring(index+1)};//gost,path
		}else{
			return new String[]{URL,""};//gost,path
		}
	}
	// 从一个字符串中提取出host groupIndex 1表示 http://www.ifeng.com/xxx..中的 http://www.ifeng.com 2表示xx..
	private String splitUrl(String link,int groupIndex) {
		//第一个括号内用*?贪婪模式就是为了尽可能少的匹配，要不 形如 http://www.ifeng.com/xxx/yyy/0.html,会匹配到yyy而不是.com
		//第二个括号内不要用 *?这种非贪婪模式，用了会导致匹配一个字符就满足条件了，整个内容获取不到
		String urlDomaiPattern = "(https?://.*?)/(.*)";//上下两个是等同的
		//String urlDomaiPattern = "(https?://[^/]*" + "/)(.*)";
		Pattern pattern = Pattern.compile(urlDomaiPattern,Pattern.CASE_INSENSITIVE + Pattern.DOTALL);
		Matcher matcher = pattern.matcher(link);
		String url = "";
		while (matcher.find()) {
			int start = matcher.start(groupIndex);
			int end = matcher.end(groupIndex);//注意这个是匹配的分组的最后一个字符串的偏移量+1
			url = link.substring(start, end).trim();
		}
		return url;
	}
	public static void main(String[] args) {
		WebGraphMemory wm=new WebGraphMemory();
		System.out.println(wm.splitUrl("http://www.ifeng.com/xxx/shtml.html", 2));
	}
}