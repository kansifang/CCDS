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

package com.lmt.app.crawler.plugin.redis;

import com.lmt.app.crawler.fetcher.SegmentWriter;
import com.lmt.app.crawler.model.Content;
import com.lmt.app.crawler.model.CrawlDatum;
import com.lmt.app.crawler.parser.ParseResult;

/**
 *
 * @author hu
 */
public class RedisSegmentWriter implements SegmentWriter{

    private RedisHelper redisHelper;
    public RedisSegmentWriter(RedisHelper redisHelper) {
        this.redisHelper=redisHelper;
    }
    
    
    

    @Override
    public void wrtieFetch(CrawlDatum fetch) throws Exception {
        redisHelper.addFetch(fetch);
    }

    @Override
    public void wrtieContent(Content content) throws Exception {
    }

    @Override
    public void wrtieParse(ParseResult parseresult) throws Exception {
        if(parseresult!=null){
            redisHelper.addParse(parseresult.getParsedata());
        }
    }

    @Override
    public void close() throws Exception {
    }

   
    
    
}