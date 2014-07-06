package com.lmt.app.crawler.Chap10.DocCluster.test;

import com.lmt.app.crawler.Chap10.DocCluster.knncluster.KMeans;

public class KMeansTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		int m = 10;
		int n = 20;
		
		int[] ret = KMeans.randperm(n, m);
		for(int i : ret)
			System.out.println(i);
	}

}
