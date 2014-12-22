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
package com.lmt.app.crawler.generator;

import java.io.File;
import java.io.IOException;

import com.lmt.app.crawler.fetcher.FSSegmentWriter;
import com.lmt.app.crawler.fetcher.SegmentUtils;
import com.lmt.app.crawler.fetcher.SegmentWriter;
import com.lmt.app.crawler.model.CrawlDatum;
import com.lmt.app.crawler.model.Link;
import com.lmt.app.crawler.parser.ParseData;
import com.lmt.app.crawler.util.BloomFilter;
import com.lmt.app.crawler.util.Config;
import com.lmt.app.crawler.util.FileUtils;
import com.lmt.app.crawler.util.LogUtils;


/**
 *
 * @author hu
 */
public class FSDbUpdater implements DbUpdater {

    private SegmentWriter segmentWriter = null;
    private String crawlPath;

    private String segmentName;

    /**
     * 构建一个对指定爬取信息文件夹进行更新操作的更新器
     *
     * @param crawlPath
     */
    public FSDbUpdater(String crawlPath) {
        this.crawlPath = crawlPath;

    }

    protected String getLastSegmentName() {
        String[] segment_list = new File(crawlPath, "segments").list();
        if (segment_list == null) {
            return null;
        }
        String segment_path = null;
        long max = 0;
        for (String segment : segment_list) {
            long timestamp = Long.valueOf(segment);
            if (timestamp > max) {
                max = timestamp;
                segment_path = segment;
            }
        }
        return segment_path;
    }

    /**
     * 备份爬取任务列表
     *
     * @throws IOException
     */
    public void backup() throws IOException {
        LogUtils.getLogger().info("backup " + getCrawlPath());
        File oldfile = new File(crawlPath, Config.old_info_path);
        File currentfile = new File(crawlPath, Config.current_info_path);
        FileUtils.copy(currentfile, oldfile);
    }

    /**
     * 判断更新器是否在上锁状态
     *
     * @return 是否上锁
     * @throws IOException
     */
    @Override
    public boolean isLocked() throws IOException {
        File lockfile = new File(crawlPath + "/" + Config.lock_path);
        if (!lockfile.exists()) {
            return false;
        }
        String lock = new String(FileUtils.readFile(lockfile), "utf-8");
        return lock.equals("1");
    }

    /**
     * 上锁该更新器
     *
     * @throws IOException
     */
    @Override
    public void lock() throws IOException {
        FileUtils.writeFile(crawlPath + "/" + Config.lock_path, "1".getBytes("utf-8"));
    }

    /**
     * 解锁该更新器
     *
     * @throws IOException
     */
    @Override
    public void unlock() throws IOException {
        FileUtils.writeFile(crawlPath + "/" + Config.lock_path, "0".getBytes("utf-8"));
    }
    // DataFileWriter<CrawlDatum> dataFileWriter;

    

    /**
     * 关闭该更新器
     *
     * @throws IOException
     */
    @Override
    public void close() throws Exception {
        if (segmentWriter != null) {
            segmentWriter.close();
        }
    }

    int mergeCount = 0;

    public void reportMergeCount() {
        mergeCount++;
        if (mergeCount % 10000 == 0) {
            LogUtils.getLogger().info(mergeCount + " crawldatums merged");

        }
    }
    
    private void install() throws IOException{
        File file_old = new File(crawlPath, Config.old_info_path);
        File file_new = new File(crawlPath, Config.new_info_path);
        File file_current = new File(crawlPath, Config.current_info_path);
        
        if(file_old.exists()){
            file_old.delete();
        }
        
        if(!file_old.getParentFile().exists()){
            file_old.getParentFile().mkdirs();
        }

        
        FileUtils.copy(file_current, file_old);
        file_current.delete();
        FileUtils.copy(file_new, file_current);
        file_new.delete();
    }

    /**
     * 将爬取记录和爬取任务列表合并，更新爬取任务列表
     * @throws IOException
     */
    @Override
    public void merge() throws IOException {
        if (segmentName == null) {
            segmentName = getLastSegmentName();
        }
        if (segmentName == null) {
            return;
        }

        /*
        try {
            backup();
        } catch (IOException ex) {
            LogUtils.getLogger().info("Exception", ex);
        }
*/
        LogUtils.getLogger().info("merge " + getSegmentPath());
        mergeCount = 0;
        File file_fetch = new File(getSegmentPath(), "fetch/info.avro");
        if (!file_fetch.exists()) {
            return;
        }
        File file_current = new File(crawlPath, Config.current_info_path);
        DbReader<CrawlDatum> reader_current = new DbReader<CrawlDatum>(CrawlDatum.class, file_current);
        DbReader<CrawlDatum> reader_fetch = new DbReader<CrawlDatum>(CrawlDatum.class, file_fetch);

        File file_new = new File(crawlPath, Config.new_info_path);
        if (!file_new.getParentFile().exists()) {
            file_new.getParentFile().mkdirs();
        }
        DbWriter<CrawlDatum> writer = new DbWriter<CrawlDatum>(CrawlDatum.class, file_new);

        BloomFilter bloomFilter = new BloomFilter();
        CrawlDatum datum = null;
        while (reader_fetch.hasNext()) {
            datum = reader_fetch.readNext();
            bloomFilter.add(datum.getUrl());
            writer.write(datum);
            reportMergeCount();
        }
        reader_fetch.close();

        while (reader_current.hasNext()) {
            datum = reader_current.readNext();
            if (bloomFilter.contains(datum.getUrl())) {
                continue;
            }
            bloomFilter.add(datum.getUrl());
            writer.write(datum);
            reportMergeCount();
        }
        reader_current.close();

        File file_parse = new File(getSegmentPath(), "parse_data/info.avro");
        if (file_parse.exists()) {
            DbReader<ParseData> reader_parse = new DbReader<ParseData>(ParseData.class, file_parse);
            ParseData parseresult = null;
            while (reader_parse.hasNext()) {
                parseresult = reader_parse.readNext();
                for (Link link : parseresult.getLinks()) {
                    if (bloomFilter.contains(link.getUrl())) {
                        continue;
                    }
                    datum = new CrawlDatum();
                    datum.setUrl(link.getUrl());
                    datum.setStatus(CrawlDatum.STATUS_DB_UNFETCHED);
                    bloomFilter.add(datum.getUrl());
                    writer.write(datum);
                    reportMergeCount();
                }
            }
            reader_parse.close();
        }
        writer.close();
        install();
    }

    @Override
    public SegmentWriter getSegmentWriter() {
        return segmentWriter;
    }

    public String getSegmentPath() {
        return crawlPath + "/segments/" + segmentName;
    }

    public String getCrawlPath() {
        return crawlPath;
    }

    public void setCrawlPath(String crawlPath) {
        this.crawlPath = crawlPath;
    }

    public String getSegmentName() {
        return segmentName;
    }

    public void setSegmentName(String segmentName) {
        this.segmentName = segmentName;
    }

    @Override
    public void clearHistory() {
        File file = new File(crawlPath);
        LogUtils.getLogger().info("clear " + file.getAbsolutePath());
        if (file.exists()) {
            FileUtils.deleteDir(file);
        }
    }

    @Override
    public void initSegmentWriter() throws Exception {
        segmentName = SegmentUtils.createSegmengName();
        segmentWriter = new FSSegmentWriter(crawlPath, getSegmentPath());
    }

}
