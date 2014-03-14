
package com.lmt.frameapp.web.filter;

import java.io.IOException;
import javax.servlet.*;

public class SetCharacterEncodingFilter
    implements Filter
{

    public SetCharacterEncodingFilter()
    {
        encoding = null;
        filterConfig = null;
        ignore = true;
    }

    public void destroy()
    {
        encoding = null;
        filterConfig = null;
    }

    public void doFilter(ServletRequest servletrequest, ServletResponse servletresponse, FilterChain filterchain)
        throws IOException, ServletException
    {
        if(ignore || servletrequest.getCharacterEncoding() == null)
        {
            String s = selectEncoding(servletrequest);
            if(s != null)
                servletrequest.setCharacterEncoding(s);
        }
        filterchain.doFilter(servletrequest, servletresponse);
    }

    public void init(FilterConfig filterconfig)
        throws ServletException
    {
        filterConfig = filterconfig;
        encoding = filterconfig.getInitParameter("encoding");
        String s = filterconfig.getInitParameter("ignore");
        if(s == null)
            ignore = true;
        else
        if(s.equalsIgnoreCase("true"))
            ignore = true;
        else
        if(s.equalsIgnoreCase("yes"))
            ignore = true;
        else
            ignore = false;
    }

    protected String selectEncoding(ServletRequest servletrequest)
    {
        return encoding;
    }

    protected String encoding;
    protected FilterConfig filterConfig;
    protected boolean ignore;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\360тфел\workspace\SXJS\WebRoot\WEB-INF\lib\ade-1.1beta.jar
	Total time: 167 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/