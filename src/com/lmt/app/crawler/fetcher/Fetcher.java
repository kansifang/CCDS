/*
 * Copyright (C) 2014 hu
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */
package com.lmt.app.crawler.fetcher;

import java.io.IOException;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

import com.lmt.app.crawler.generator.DbUpdater;
import com.lmt.app.crawler.generator.Generator;
import com.lmt.app.crawler.handler.Handler;
import com.lmt.app.crawler.handler.Message;
import com.lmt.app.crawler.model.Content;
import com.lmt.app.crawler.model.CrawlDatum;
import com.lmt.app.crawler.model.Page;
import com.lmt.app.crawler.net.Request;
import com.lmt.app.crawler.net.RequestFactory;
import com.lmt.app.crawler.net.Response;
import com.lmt.app.crawler.parser.ParseResult;
import com.lmt.app.crawler.parser.Parser;
import com.lmt.app.crawler.parser.ParserFactory;
import com.lmt.app.crawler.util.Config;
import com.lmt.app.crawler.util.HandlerUtils;
import com.lmt.app.crawler.util.LogUtils;

/**
 * 抓取器
 * @author hu
 */
public class Fetcher {
	private boolean running;
    public Handler handler = null;
    public RequestFactory requestFactory = null;
    public ParserFactory parserFactory = null;
    public DbUpdater dbUpdater = null;
    private int retry = 3;
    private AtomicInteger activeThreads;
    private AtomicInteger spinWaiting;
    private AtomicLong lastRequestStart;
    private QueueFeeder feeder;
    private FetchQueue fetchQueue;
    private boolean needUpdateDb = true;

    /**
     *解析链接成功和失败
     */
    public static final int FETCH_SUCCESS = 1;
    public static final int FETCH_FAILED = 2;
    private int threads = 10;
    private boolean isContentStored = true;
    private boolean parsing = true;

    /**
     *
     */
    public static class FetchItem {
        /**
         *
         */
        public CrawlDatum datum;
        
        /**
         *
         * @param datum
         */
        public FetchItem(CrawlDatum datum) {
            this.datum = datum;
        }
        public boolean equals(Object obj) {
            if (this == obj)
                return true;
            if (obj == null)
                return false;
            if (getClass() != obj.getClass())
                return false;
            final FetchItem other = (FetchItem) obj;
            if(!this.datum.getUrl().equalsIgnoreCase(other.datum.getUrl()))
                return false;
            return true;
       }
    }

    /**
     *
     */
    public static class FetchQueue {
        /**
         *
         */
        public AtomicInteger totalSize = new AtomicInteger(0);

        /**
         *
         */
        public List<FetchItem> queue = Collections.synchronizedList(new LinkedList<FetchItem>());
        
        /**
         *
         */
        public synchronized void clear() {
            queue.clear();
        }
        
        /**
         *
         * @return
         */
        public int getSize() {
            return queue.size();
        }
        
        /**
         *
         * @param item
         */
        public void addFetchItem(FetchItem item) {
            if (item == null) {
                return;
            }
            String url=item.datum.getUrl();
            if ( url!= null && !url.trim().equals("")&&!queue.contains(item)) {
                queue.add(item);
                totalSize.incrementAndGet();
            }
        }
        /**
         *
         * @return
         */
        public synchronized FetchItem getFetchItem() {
            if (queue.size() == 0) {
                return null;
            }
            return queue.remove(0);
        }

        /**
         *
         */
        public synchronized void dump() {
            for (int i = 0; i < queue.size(); i++) {
                FetchItem it = queue.get(i);
                LogUtils.getLogger().info("  " + i + ". " + it.datum.getUrl());
            }
        }
    }

    /**
     *
     */
    public static class QueueFeeder extends Thread {
        public FetchQueue queue;
        public Generator generator;
        public int size;
        public QueueFeeder(FetchQueue queue, Generator generator, int size) {
            this.queue = queue;
            this.generator = generator;
            this.size = size;
        }
        @Override
        public void run() {
            boolean hasMore = true;
            while (hasMore) {
                int feed = size - queue.getSize();
                if (feed <= 0){//不可能<0,至多在队列满额的情况下=0，这时等一下，让爬取线程爬一下再往队列里装
                    try {
                        Thread.sleep(1000);
                    } catch (InterruptedException ex) {
                    }
                    continue;
                }
                while (feed > 0 && hasMore) {
                    CrawlDatum datum = generator.next();
                    hasMore = (datum != null);
                    if (hasMore) {
                        queue.addFetchItem(new FetchItem(datum));
                        feed--;
                    }
                }
            }
        }
    }
    //爬取线程
    private class FetcherThread extends Thread {
        @Override
        public void run() {
            activeThreads.incrementAndGet();
            FetchItem item = null;
            try {
                while (true) {
                    try {
                        item = fetchQueue.getFetchItem();
                        if (item == null) {
                        	//装队列线程还活着情况下，休息一下再爬取
                            if (feeder.isAlive() || fetchQueue.getSize() > 0) {
                                spinWaiting.incrementAndGet();
                                try {
                                    Thread.sleep(500);
                                } catch (Exception ex) {
                                }
                                spinWaiting.decrementAndGet();
                                continue;
                            } else {
                                return;
                            }
                        }
                        lastRequestStart.set(System.currentTimeMillis());
                        CrawlDatum crawldatum = new CrawlDatum();
                        String url = item.datum.getUrl();
                        crawldatum.setUrl(url);

                        Request request = requestFactory.createRequest(url);
                        Response response = null;

                        for (int i = 0; i <= retry; i++) {
                            if (i > 0) {
                                LogUtils.getLogger().info("retry " + i + "th " + url);
                            }
                            try {
                                response = request.getResponse(crawldatum);
                                break;
                            } catch (Exception ex) {
                            	System.out.println("请求链接异常，将重试！");
                            }
                        }
                        crawldatum.setStatus(CrawlDatum.STATUS_DB_FETCHED);
                        crawldatum.setFetchTime(System.currentTimeMillis());

                        Page page = new Page();
                        page.setUrl(url);
                        page.setFetchTime(crawldatum.getFetchTime());
                        if (response == null) {
                            LogUtils.getLogger().info("failed " + url);
                            HandlerUtils.sendMessage(handler, new Message(Fetcher.FETCH_FAILED, page), true);
                            continue;
                        }
                        page.setResponse(response);
                        LogUtils.getLogger().info("fetch " + url);
                        String contentType = response.getContentType();
                        if (parsing) {
                            try {
                                Parser parser = parserFactory.createParser(url, contentType);
                                if (parser != null) {
                                	//解析网页到page中
                                    ParseResult parseresult = parser.getParse(page);
                                    page.setParseResult(parseresult);
                                }
                            } catch (Exception ex) {
                                LogUtils.getLogger().info("Exception", ex);
                            }
                        }
                        if (needUpdateDb) {
                            try {
                                dbUpdater.getSegmentWriter().wrtieFetch(crawldatum);
                                if (isContentStored) {
                                    Content content = new Content();
                                    content.setUrl(url);
                                    if (response.getContent() != null) {
                                        content.setContent(response.getContent());
                                    } else {
                                        content.setContent(new byte[0]);
                                    }
                                    content.setContentType(contentType);
                                    dbUpdater.getSegmentWriter().wrtieContent(content);
                                }
                                if (parsing && page.getParseResult() != null) {
                                    dbUpdater.getSegmentWriter().wrtieParse(page.getParseResult());
                                }
                            } catch (Exception ex) {
                                LogUtils.getLogger().info("Exception", ex);
                            }
                        }
                        HandlerUtils.sendMessage(handler, new Message(Fetcher.FETCH_SUCCESS, page), true);
                    } catch (Exception ex) {
                        LogUtils.getLogger().info("Exception", ex);
                    }
                }
            } catch (Exception ex) {
                LogUtils.getLogger().info("Exception", ex);
            } finally {
                activeThreads.decrementAndGet();
            }
        }
    }

    private void before() throws Exception {
        //DbUpdater recoverDbUpdater = createRecoverDbUpdater();
        if (needUpdateDb) {
            try {
                if (dbUpdater.isLocked()) {
                    dbUpdater.merge();
                    dbUpdater.unlock();
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
            dbUpdater.initSegmentWriter();
            dbUpdater.lock();
        }
        running = true;
    }

    /**
     * 抓取当前所有任务，会阻塞到爬取完成
     * @param generator 给抓取提供任务的Generator(抓取任务生成器)
     * @throws IOException
     */
    public void fetchAll(Generator generator) throws Exception {
        before();
        lastRequestStart = new AtomicLong(System.currentTimeMillis());
        activeThreads = new AtomicInteger(0);
        spinWaiting = new AtomicInteger(0);
        fetchQueue = new FetchQueue();
        feeder = new QueueFeeder(fetchQueue, generator, 1000);//队列最长1000个URL
        feeder.start();

        FetcherThread[] fetcherThreads=new FetcherThread[threads];
        for (int i = 0; i < threads; i++) {
            fetcherThreads[i]=new FetcherThread();
            fetcherThreads[i].start();
        }
        do{
            try {
                Thread.sleep(1000);
            } catch (InterruptedException ex) {
            }
            LogUtils.getLogger().info("Fetcher-activeThreads=" + activeThreads.get()
                    + ", spinWaiting=" + spinWaiting.get() + ", "
                    +"fetchQueue.size="+ fetchQueue.getSize());
            if (!feeder.isAlive() && fetchQueue.getSize() < 5) {
                fetchQueue.dump();
            }
            long currentTM=System.currentTimeMillis();
            if ((currentTM- lastRequestStart.get()) > Config.requestMaxInterval) {
                LogUtils.getLogger().info("Aborting with " + activeThreads + " hung threads.");
                break;
            }
        }while (activeThreads.get() > 0 && running);
        for(int i=0;i<threads;i++){
            if(fetcherThreads[i].isAlive()){
                fetcherThreads[i].stop();
            }
        }
        feeder.stop();
        fetchQueue.clear();
        after();
    }
    private void after() throws Exception {
        if (needUpdateDb) {
            dbUpdater.close();
            dbUpdater.merge();
            dbUpdater.unlock();
        }
    }
    /**
     * 停止爬取
     */
    public void stop() {
        running = false;
    }
    /**
     * 返回爬虫的线程数
     *
     * @return 爬虫的线程数
     */
    public int getThreads() {
        return threads;
    }

    /**
     * 设置爬虫的线程数
     *
     * @param threads 爬虫的线程数
     */
    public void setThreads(int threads) {
        this.threads = threads;
    }

    /**
     * 返回处理抓取消息的Handler
     *
     * @return 处理抓取消息的Handler
     */
    public Handler getHandler() {
        return handler;
    }

    /**
     * 设置处理抓取消息的Handler
     *
     * @param handler 处理抓取消息的Handler
     */
    public void setHandler(Handler handler) {
        this.handler = handler;
    }

    /**
     * 返回是否存储爬取信息
     *
     * @return 是否存储爬取信息
     */
    public boolean getNeedUpdateDb() {
        return needUpdateDb;
    }

    /**
     * 设置是否存储爬取信息
     *
     * @param needUpdateDb 是否存储爬取信息
     */
    public void setNeedUpdateDb(boolean needUpdateDb) {
        this.needUpdateDb = needUpdateDb;
    }

    /**
     * 返回http请求失败后重试的次数
     *
     * @return http请求失败后重试的次数
     */
    public int getRetry() {
        return retry;
    }

    /**
     * 设置http请求失败后重试的次数
     *
     * @param retry http请求失败后重试的次数
     */
    public void setRetry(int retry) {
        this.retry = retry;
    }

    /**
     * 返回是否存储网页/文件的内容
     *
     * @return 是否存储网页/文件的内容
     */
    public boolean isIsContentStored() {
        return isContentStored;
    }

    /**
     * 设置是否存储网页／文件的内容
     *
     * @param isContentStored 是否存储网页/文件的内容
     */
    public void setIsContentStored(boolean isContentStored) {
        this.isContentStored = isContentStored;
    }

    /**
     * 返回是否解析网页（解析链接、文本）
     * @return 是否解析网页（解析链接、文本）
     */
    public boolean isParsing() {
        return parsing;
    }

    /**
     * 设置是否解析网页（解析链接、文本）
     * @param parsing 是否解析网页（解析链接、文本）
     */
    public void setParsing(boolean parsing) {
        this.parsing = parsing;
    }

    /**
     * 返回请求生成器
     * @return 请求生成器
     */
    public RequestFactory getRequestFactory() {
        return requestFactory;
    }

    /**
     * 设置请求生成器
     * @param requestFactory 请求生成器
     */
    public void setRequestFactory(RequestFactory requestFactory) {
        this.requestFactory = requestFactory;
    }

    /**
     * 返回解析器生成器
     * @return 解析器生成器
     */
    public ParserFactory getParserFactory() {
        return parserFactory;
    }

    /**
     * 设置解析器生成器
     * @param parserFactory 解析器生成器
     */
    public void setParserFactory(ParserFactory parserFactory) {
        this.parserFactory = parserFactory;
    }
    /**
     * 返回CrawlDB更新器
     * @return CrawlDB更新器
     */
    public DbUpdater getDbUpdater() {
        return dbUpdater;
    }

    /**
     * 设置CrawlDB更新器
     * @param dbUpdater CrawlDB更新器
     */
    public void setDbUpdater(DbUpdater dbUpdater) {
        this.dbUpdater = dbUpdater;
    }
}
