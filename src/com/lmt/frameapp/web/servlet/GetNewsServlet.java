package com.lmt.frameapp.web.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lmt.app.crawler.Crawler;
import com.lmt.app.crawler.dao.HtmlDao;

/**
 *
 * @author Administrator
 */
public class GetNewsServlet extends HttpServlet {
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {
        processRequest(request, response);
    }
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(final HttpServletRequest request, final HttpServletResponse response)
            throws ServletException, IOException {
            response.setContentType("text/html;charset=GBK");
            String url = request.getParameter("newsfield");  
            Thread thread = new Thread(new Runnable() {
                public void run() {
                    new Crawler().crawling();
                }
            });
            thread.start();
            HtmlDao news=new HtmlDao();
            request.getSession().setAttribute("newsList",news.getNewsList("SerialNo,NewsTitle,NewsAuthor,NewsContent,NewsURL,NewsDate"," from Batch_Html where 1=1",1,8));
            response.sendRedirect("Data/Report/CrawlerList.jsp?CompClientID="+request.getParameter("CompClientID"));
    }
}
