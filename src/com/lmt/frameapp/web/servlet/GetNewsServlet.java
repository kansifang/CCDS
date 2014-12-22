package com.lmt.frameapp.web.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.lmt.app.crawler.ui.BreadthCrawlerUI;

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
            final String sStartDate = request.getParameter("startDate");  
            final String sEndDate = request.getParameter("endDate");  
            /*
            Thread thread = new Thread(new Runnable() {
                public void run() {
                    try {
						new Crawler().crawling(sStartDate,sEndDate);
					} catch (FileNotFoundException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						System.out.println("没有找到种子文件！");
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
						System.out.println("解析文件时出错！");
					}
                }
            });
            thread.start();
            */
            java.awt.EventQueue.invokeLater(new Runnable() {
                public void run() {
                    new BreadthCrawlerUI().setVisible(true);
                }
            });
            response.sendRedirect("Data/Report/CrawlerList.jsp?CompClientID="+request.getParameter("CompClientID"));
    }
}
