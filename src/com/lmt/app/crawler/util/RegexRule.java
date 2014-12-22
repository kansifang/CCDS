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
package com.lmt.app.crawler.util;

import java.util.ArrayList;
import java.util.regex.Pattern;

/**
 *
 * @author hu
 */
public class RegexRule {
    
    public RegexRule(){
        
    }
    
    public boolean isEmpty(){
        return positive.isEmpty();
    }

    private ArrayList<String> positive = new ArrayList<String>();
    private ArrayList<String> negative = new ArrayList<String>();

    /**1.至少能匹配一条正则
     * 添加一个正正则规则
     *
     * @param positiveregex
     */
    public void addPositive(String positiveregex) {
        positive.add(positiveregex);
    }

    /**2.不能和任何反正则匹配
     * 添加一个反正则规则
     *
     * @param negativeregex
     */
    public void addNegative(String negativeregex) {
        negative.add(negativeregex);
    }

    /**
     * 获取下一个符合正则规则的爬取任务 URL符合正则规则需要满足下面条件： 1.至少能匹配一条正正则 2.不能和任何反正则匹配
     *
     * @return 下一个符合正则规则的爬取任务，如果没有符合规则的任务，返回null
     */
    public boolean satisfy(String str) {
        for (String nregex : negative) {
            if (Pattern.matches(nregex, str)) {
                return false;
            }
        }
        int count = 0;
        for (String pregex : positive) {
            if (Pattern.matches(pregex, str)) {
                count++;
            }
        }
        if (count == 0) {
            return false;
        } else {
            return true;
        }
    }
}
