package com.lmt.frameapp.web.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.lmt.baseapp.util.DataConvert;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;

public class FileViewServlet extends HttpServlet
{
  private static final long serialVersionUID = 1L;

  public void service(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException
  {
    try{
      HttpSession httpsession = request.getSession(true);
      if ((httpsession == null) || (httpsession.getAttributeNames() == null)) {
        throw new Exception("------Timeout------");
      }
      String sFileName = "";
      String sContentType = "text/html";
      String sViewType = "view";

      sFileName = DataConvert.toString(DataConvert.decode(request.getParameter("filename"),"UTF-8"));
      sContentType = DataConvert.toString(request.getParameter("contenttype"));
      sViewType = DataConvert.toString(request.getParameter("viewtype"));

      ARE.getLog().info("[FileViewServlet]" + sContentType + ":" + sFileName);

      File dFile = null;
      if(sFileName.equals("")){
    	  return;
      }
      dFile = new File(sFileName);
      if (!dFile.exists()) {
        ARE.getLog().warn("[FileViewServlet-ERR]文件不存在:" + sFileName + "!");
        String sCon = "文件不存在 !";
        ServletOutputStream outStream = response.getOutputStream();
        outStream.println(DataConvert.toRealString(3, sCon));
        outStream.flush();
        outStream.close();
      }else {
        response.setContentType(sContentType + ";charset=GBK");
        if (sViewType.equals("view")){
          response.setHeader("Content-Disposition", "filename=" + DataConvert.toRealString(3,StringFunction.getFileName(sFileName)) + ";");
        }else {
          response.setHeader("Content-Disposition", "attachment;filename=" + StringFunction.getFileName(sFileName) + ";");
        }
        ServletOutputStream outStream2 = response.getOutputStream();
        InputStream inStream = new FileInputStream(sFileName);
        int iContentLength = (int)dFile.length();
        if(iContentLength==0){
        	inStream.close();
        	return;
        }
        if ((iContentLength < 0) || (iContentLength > 102400)){
        	iContentLength = 102400;
        }
        byte[] abyte0 = new byte[iContentLength];
        int k = -1;
        while ((k = inStream.read(abyte0, 0, iContentLength)) != -1) {
          ARE.getLog().debug("[FileViewServlet]Read:" + k);
          outStream2.write(abyte0, 0, k);
        }
        inStream.close();
        outStream2.flush();
        outStream2.close();
        return;
      }
      return;
    } catch (Exception e1) {
      ARE.getLog().error("[FileViewServlet-ERR]", e1);
    } finally {
    }
  }

  public String getServletInfo() {
    return "This is a file view servlet!";
  }
}