package com.lmt.app.crawler.link.analyze;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

public class HITS {
	/** 存储web图的数据结构 */
	private WebGraphMemory graph;

	/** 包含每个网页的评分 */
	private Map<Integer,Double> hubScores; //<id,value>
	
	/** 包含每个网页的Authority  */
	private Map<Integer,Double> authorityScores;//<id,value>
	
	/** 
	 *构造函数
	 */
	public HITS (WebGraphMemory graph ) {
		this.graph = graph;
		this.hubScores = new HashMap<Integer,Double>();
		this.authorityScores = new HashMap<Integer,Double>();
		int numLinks = graph.numNodes();
		for(int i=1; i<=numLinks; i++) { 
			hubScores.put(new Integer(i),new Double(1));
			authorityScores.put(new Integer(i),new Double(1));
		}
		computeHITS();
	}
	//利用插入法进行排序---暂时没用
	private void InsertSort(int a[], int n)  
	{  
	    for(int i= 1; i<n; i++){  
	        if(a[i] < a[i-1]){               //若第i个元素大于i-1元素，直接插入。小于的话，移动有序表后插入  
	            int j= i-1;   
	            int x = a[i];        //复制为哨兵，即存储待排序元素  
	            a[i] = a[i-1];           //先后移一个元素  
	            while(x < a[j]){  //查找在有序表的插入位置  
	                a[j+1] = a[j];  
	                j--;         //元素后移  
	            }  
	            a[j+1] = x;      //插入到正确位置  
	        }  
	    }  
	}  

	/**
	 * 计算网页的 Hub 和 Authority scores 
		 */
	public void computeHITS() {
		computeHITS(25);
	}
	
	/**
	 *计算网页的 Hub 和 Authority scores
	 * 
     */
	public void computeHITS(int numIterations) {
		while(numIterations-->0 ) {
			for (int i = 1; i <= graph.numNodes(); i++) {
				Map<Integer,Double> inlinks    = graph.inLinks(new Integer(i));
				Map<Integer,Double> outlinks  = graph.outLinks(new Integer(i));
				double authorityScore = 0;
				double hubScore = 0;
				for (Integer id:inlinks.keySet()) {
					authorityScore += (hubScores.get(id)==null?0:hubScores.get(id).doubleValue());
				}
				
				for (Integer id:outlinks.keySet()) {
					hubScore += (authorityScores.get(id)==null?0:authorityScores.get(id).doubleValue());
				}
				authorityScores.put(new Integer(i),new Double(authorityScore));
				hubScores.put(new Integer(i),new Double(hubScore));
			}
			normalize(authorityScores);
			normalize(hubScores);
		}
	}
	
	public void computeWeightedHITS(int numIterations) {
		while(numIterations-- >0 ) {
			for (int i = 1; i <= graph.numNodes(); i++) {
				Map<Integer,Double> inlinks    = graph.inLinks(new Integer(i));
				Map<Integer,Double> outlinks  = graph.outLinks(new Integer(i));
				double authorityScore = 0;
				double hubScore = 0;
				for (Map.Entry<Integer,Double> in:inlinks.entrySet()) {
					authorityScore += (hubScores.get(in.getKey())).doubleValue() * in.getValue();
				}
				for (Map.Entry<Integer,Double> out:outlinks.entrySet()) {
					hubScore += (authorityScores.get(out.getKey())).doubleValue() * out.getValue();
				}
				
				authorityScores.put(new Integer(i),new Double(authorityScore));
				hubScores.put(new Integer(i),new Double(hubScore));
			}
			normalize(authorityScores);
			normalize(hubScores);
		}
	}
	
	/**
	 * Normalize the set 
	 */
	private void normalize(Map<Integer,Double> scoreSet)
	{
		Iterator<Integer> iter = scoreSet.keySet().iterator();
		double summation = 0.0;
		while (iter.hasNext()){
			summation += ((scoreSet.get((Integer)(iter.next())))).doubleValue();
		}
		iter = scoreSet.keySet().iterator();
		while (iter.hasNext()){
			Integer id = iter.next();
			scoreSet.put(id , (scoreSet.get(id)).doubleValue()/summation);
		}
	}
	
	/**
	 *  返回与给定链接关联的Hub score 
	 */
	public Double hubScore(String link) {
		return hubScore(graph.URLToIdentifyer(link));	
	}
	
	/**
	 *返回与给定链接关联的Hub score 

	 */
	private Double hubScore(Integer id) {
		return (Double)(hubScores.get(id));
	}

	/**
	 *初始化与给定链接关联的Hub score 
	 */
	public void initializeHubScore(String link, double value) {
		Integer id = graph.URLToIdentifyer(link);
		if(id!=null) 
			hubScores.put(id,new Double(value));	
	}
	
	/**
	 *初始化与给定链接关联的Hub score
	 */
	public void initializeHubScore(Integer id, double value) {
		if(id!=null) 
			hubScores.put(id,new Double(value));	
	}

	/**
	 *返回与给定链接关联的 Authority score	 
	 */
	public Double authorityScore(String link) {
		return authorityScore(graph.URLToIdentifyer(link));	
	}
	
	/**
	 *返回与给定链接关联的 Authority score	
	 */
	public Double authorityScore(Integer id) {
		return (Double)(authorityScores.get(id));
	}

	/**
	 *初始化与给定链接关联的 Authority score	
	 */
	public void initializeAuthorityScore(String link, double value) {
		Integer id = graph.URLToIdentifyer(link);
		if(id!=null) 
			authorityScores.put(id,new Double(value));	
	}
	
	/**
	 *初始化与给定链接关联的 Authority score	
	 */
	public void initializeAuthorityScore(Integer id, double value) {
		if(id!=null) authorityScores.put(id,new Double(value));	
	}

}

