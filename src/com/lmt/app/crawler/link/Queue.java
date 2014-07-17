/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.lmt.app.crawler.link;

import java.util.LinkedList;

/**
 * 数据结构队列
 */
public class Queue<T> {

    private LinkedList<T> queue = new LinkedList<T>();

    public void add(T t) {
        queue.addLast(t);
    }

    public T poll() {
        return queue.removeFirst();
    }

    public boolean isQueueEmpty() {
        return queue.isEmpty();
    }

    public boolean contians(T t) {
        return queue.contains(t);
    }

    public boolean isEmpty() {
        return queue.isEmpty();
    }
}