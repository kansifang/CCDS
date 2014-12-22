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

import java.util.ArrayList;

import com.lmt.app.crawler.generator.BasicInjector;


/**
 *
 * @author hu
 */
public class RedisInjector extends BasicInjector{

    private RedisHelper redisHelper;

    public RedisInjector(String taskName, String ip,int port) {

        redisHelper=new RedisHelper(taskName,ip,port);
    }
    
    
    @Override
    public void inject(ArrayList<String> urls, boolean append) throws Exception {
        for(String url:urls){
            redisHelper.inject(url, append);
        }
    }
    
}
