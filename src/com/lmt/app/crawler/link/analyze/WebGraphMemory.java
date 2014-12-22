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
	/**���������ǰ� url ӳ��� ���� ���෴
	 * A Map storing relationships from URLs to numeric identifiers, usefull for
	 * storing Web graphs
	 */
	private Map<String, Map<String, Integer>> URLToIdentifyer;
	// ��ÿ��URLӳ��Ϊһ���������洢��webͼ��
	private Map<Integer, String> IdentifyerToURL;
	//�ٶ�һ����ַ�����б��붼��һ���ģ����Դ˴��洢һ�������ı���
	private Map<String, String> HostToEncode;
	/**
	 * �洢��ȣ�����������һ��������URL��ID���ڶ��������Ǵ��ָ�����URL���ӵ�Map��Double��ʾȨ��
	 */
	private Map<Integer, Map<Integer, Double>> InLinks;

	/**
	 * �洢���ȣ����е�һ��������URL��ID���ڶ��������Ǵ����ҳ�еĳ����ӣ�Double��ʾȨ��
	 */
	private Map<Integer, Map<Integer, Double>> OutLinks;
	/** ͼ�нڵ����Ŀ */
	private int nodeCount=0;

	/**
	 * ���캯����0���ڵ�Ĺ��캯��
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
	 * ��һ���ı��ļ���ȡ�ýڵ�Ĺ��캯���� ÿ�а���һ��ָ���ϵ�����磺 http://url1.com -> http://url2.com 1.0
	 * ��ʾ "http://url1.com" ����һ�������� "http://url2.com", ������������ӵ�Ȩ����1.0
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
				index1 = url2.indexOf(" ");//�Կո�ָ�������� Ȩ��
				if (index1 != -1){
					strength = new Double(url2.substring(index1 + 1).trim());
					url2 = url2.substring(0, index1).trim();
				}
				addLink(url1, url2, strength);
			}
		}
	}
	/**
	 * ��һ���ı��ļ���ȡ�ýڵ�Ĺ��캯���� ÿ�а���һ��ָ���ϵ�����磺 http://url1.com -> http://url2.com 1.0
	 * ��ʾ "http://url1.com" ����һ�������� "http://url2.com", ������������ӵ�Ȩ����1.0
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
				index1 = url2.indexOf(" ");//�Կո�ָ�������� Ȩ��
				if (index1 != -1){
					strength = new Double(url2.substring(index1 + 1).trim());
					url2 = url2.substring(0, index1).trim();
				}
				addLink(url1, url2, strength);
			}
		}
	}
	/**
	 * ��һ���ı��ļ���ȡ�ýڵ�Ĺ��캯���� ÿ�а���һ��ָ���ϵ�����磺 http://url1.com -> http://url2.com 1.0
	 * ��ʾ "http://url1.com" ����һ�������� "http://url2.com", ������������ӵ�Ȩ����1.0
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
				Double strength = new Double(1.0);//Ĭ��Ȩ�ض���1
				addLink(url1, toUrl, strength);
			}
		}while (it.hasNext());
	}
	/**
	 * �������ڵ�������һ����Ӧ��ϵ������ڵ㲻���ڣ����´����ڵ�
	 */
	public Double addLink(String fromLink, String toLink, Double weight) {
		Integer id1 = addLink(fromLink);
		Integer id2 = addLink(toLink);
		return addLink(id1, id2, weight);
	}
	/**
	 * ��ͼ������һ���ڵ�
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
	 * �������ڵ�������һ����Ӧ��ϵ������ڵ㲻���ڣ����´����ڵ�
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
	 * ����URL�ƶ�����ID
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
	 * ����ID���URL
	 */
	public String IdentifyerToURL(Integer id) {
		return (IdentifyerToURL.get(id));
	}
	public void setHostToEncode(String URL,String Encoding) {
		HostToEncode.put(this.splitUrl(URL,1),Encoding);
	}
	/**
	 * ����URL��ø���վ���ַ�����
	 */
	public String hostToEncode(String URL) {
		return (HostToEncode.get(this.splitUrl(URL,1)));
	}
	/**
	 * ���ָ����URL���ذ���������ȵ����ӵ�Map
	 */
	public Map inLinks(String URL) {
		Integer id = URLToIdentifyer(URL);
		return inLinks(id);
	}

	/**
	 * ���ָ����URL���ذ���������ȵ����ӵ�Map
	 */
	public Map<Integer, Double> inLinks(Integer link) {
		if (link == null)
			return null;
		Map<Integer, Double> aux = (InLinks.get(link));
		return aux;
	}

	/**
	 * ���ָ����URL���ذ������ĳ��ȵ����ӵ�Map
	 */
	public Map<Integer, Double> outLinks(String URL) {
		Integer id = URLToIdentifyer(URL);
		return outLinks(id);
	}

	/**
	 * ���ָ����URL���ذ������ĳ��ȵ����ӵ�Map
	 */
	public Map<Integer, Double> outLinks(Integer link) {
		if (link == null)
			return null;
		Map<Integer, Double> aux = OutLinks.get(link);
		return aux;
	}

	/**
	 * ���������ڵ�֮���Ȩ�أ�����ڵ�û�����ӣ��ͷ���0
	 */
	public Double inLink(String fromLink, String toLink) {
		Integer id1 = URLToIdentifyer(fromLink);
		Integer id2 = URLToIdentifyer(toLink);
		return inLink(id1, id2);
	}

	/**
	 * ���������ڵ�֮���Ȩ�أ�����ڵ�û�����ӣ��ͷ���0
	 */
	public Double outLink(String fromLink, String toLink) {
		Integer id1 = URLToIdentifyer(fromLink);
		Integer id2 = URLToIdentifyer(toLink);
		return outLink(id1, id2);
	}

	/**
	 * ���������ڵ�֮���Ȩ�أ�����ڵ�û�����ӣ��ͷ���0
	 */
	public Double inLink(Integer fromLink, Integer toLink) {
		Map<Integer, Double> aux = inLinks(toLink);
		if (aux == null)
			return new Double(0);
		Double weight = (aux.get(fromLink));
		return (weight == null) ? new Double(0) : weight;
	}

	/**
	 * ���������ڵ�֮���Ȩ�أ�����ڵ�û�����ӣ��ͷ���0
	 */
	public Double outLink(Integer fromLink, Integer toLink) {
		Map<Integer, Double> aux = outLinks(fromLink);
		if (aux == null)
			return new Double(0);
		Double weight = (aux.get(toLink));
		return (weight == null) ? new Double(0) : weight;
	}

	/**
	 * ������ͼ��Ϊ����ͼ��
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
	 * ɾ���ڲ����ӣ��ڲ����Ӿ���ָ��ͬһ�����ϵ�����
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
					Integer link2 = (Integer) (it2.next());//it2������it�������Ǵ��
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
	 * ɾ���ڲ��������ӡ�
	 */
	public void removeNepotistic() {
		removeInternalLinks();
	}

	/**
	 * ɾ�� stop URLs.��
	 */
	public void removeStopLinks(String stopURLs[]) {
		HashMap aux = new HashMap();
		for (int i = 0; i < stopURLs.length; i++)
			aux.put(stopURLs[i], null);
		removeStopLinks(aux);
	}

	/**
	 * ɾ�� stop URLs��
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
	//��������������Ĵ���
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
	// ��һ���ַ�������ȡ��host groupIndex 1��ʾ http://www.ifeng.com/xxx..�е� http://www.ifeng.com 2��ʾxx..
	private String splitUrl(String link,int groupIndex) {
		//��һ����������*?̰��ģʽ����Ϊ�˾������ٵ�ƥ�䣬Ҫ�� ���� http://www.ifeng.com/xxx/yyy/0.html,��ƥ�䵽yyy������.com
		//�ڶ��������ڲ�Ҫ�� *?���ַ�̰��ģʽ�����˻ᵼ��ƥ��һ���ַ������������ˣ��������ݻ�ȡ����
		String urlDomaiPattern = "(https?://.*?)/(.*)";//���������ǵ�ͬ��
		//String urlDomaiPattern = "(https?://[^/]*" + "/)(.*)";
		Pattern pattern = Pattern.compile(urlDomaiPattern,Pattern.CASE_INSENSITIVE + Pattern.DOTALL);
		Matcher matcher = pattern.matcher(link);
		String url = "";
		while (matcher.find()) {
			int start = matcher.start(groupIndex);
			int end = matcher.end(groupIndex);//ע�������ƥ��ķ�������һ���ַ�����ƫ����+1
			url = link.substring(start, end).trim();
		}
		return url;
	}
	public static void main(String[] args) {
		WebGraphMemory wm=new WebGraphMemory();
		System.out.println(wm.splitUrl("http://www.ifeng.com/xxx/shtml.html", 2));
	}
}