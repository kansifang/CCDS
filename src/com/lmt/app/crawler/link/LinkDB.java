package com.lmt.app.crawler.link;

import java.util.HashSet;
import java.util.Set;

/**
 * 用来保存已经访问过 Url 和待访问的 Url 的类
 */
public class LinkDB {

    //已访问的 url 集合
    private static Set<String> visitedUrl = new HashSet<String>();
    //待访问的 url 集合
    private static Queue<String> unVisitedUrl = new Queue<String>();
    // 获得URL队列
    public static Queue<String> getUnVisitedUrl() {
        return unVisitedUrl;
    }
    // 添加到访问过的URL队列中
    public static void addVisitedUrl(String url) {
        visitedUrl.add(url);
    }
    // 移除访问过的URL
    public static void removeVisitedUrl(String url) {
        visitedUrl.remove(url);
    }
    // 未访问的URL出队列
    public static String unVisitedUrlDeQueue() {
        return unVisitedUrl.poll();
    }

    // 保证每个 url 只被访问一次
    public static void addUnvisitedUrl(String url) {
        if (url != null && !url.trim().equals("") && !visitedUrl.contains(url) && !unVisitedUrl.contians(url)) {
            unVisitedUrl.add(url);
        }
    }
    // 获得已经访问的URL数目
    public static int getVisitedUrlNum() {
        return visitedUrl.size();
    }
    // 判断未访问的URL队列中是否为空
    public static boolean unVisitedUrlsEmpty() {
        return unVisitedUrl.isEmpty();
    }
}

