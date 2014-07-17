package com.lmt.app.crawler.link;

import java.util.HashSet;
import java.util.PriorityQueue;
import java.util.Set;
import java.util.Queue;

public class LinkDBPrio {
	// �ѷ��ʵ� url ����
	private static Set visitedUrl = new HashSet();
	// �����ʵ� url ����
	private static Queue unVisitedUrl = new PriorityQueue();

	// ���URL����
	public static Queue getUnVisitedUrl() {
		return unVisitedUrl;
	}

	// ��ӵ����ʹ���URL������
	public static void addVisitedUrl(String url) {
		visitedUrl.add(url);
	}

	// �Ƴ����ʹ���URL
	public static void removeVisitedUrl(String url) {
		visitedUrl.remove(url);
	}

	
	public static Object unVisitedUrlDeQueue() {
		return unVisitedUrl.poll();
	}

	// ��֤ÿ�� url ֻ������һ��
	public static void addUnvisitedUrl(String url) {
		if (url != null && !url.trim().equals("") && !visitedUrl.contains(url)
				&& !unVisitedUrl.contains(url))
			unVisitedUrl.add(url);
	}

	
	public static int getVisitedUrlNum() {
		return visitedUrl.size();
	}

	
	public static boolean unVisitedUrlsEmpty() {
		return unVisitedUrl.isEmpty();
	}

}
