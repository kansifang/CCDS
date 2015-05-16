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

package com.lmt.app.crawler.parser;

/**
 *
 * @author hu
 */
public class ParseResult {
    private ParseData parsedata;
    private ParseText parsetext;
    private Object parseObj;
    public ParseResult(){
        
    }
    public ParseResult(ParseData parsedata, ParseText parsetext) {
        this.parsedata = parsedata;
        this.parsetext = parsetext;
    }

    public ParseData getParsedata() {
        return parsedata;
    }

    public void setParsedata(ParseData parsedata) {
        this.parsedata = parsedata;
    }

    public ParseText getParsetext() {
        return parsetext;
    }

    public void setParsetext(ParseText parsetext) {
        this.parsetext = parsetext;
    }

    public Object getParseObj() {
        return parseObj;
    }

    public void setParseObj(Object parseObj) {
        this.parseObj = parseObj;
    }
}
