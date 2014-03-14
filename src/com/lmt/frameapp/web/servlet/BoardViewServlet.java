package com.lmt.frameapp.web.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.lmt.baseapp.util.DataConvert;
import com.lmt.baseapp.util.StringFunction;
import com.lmt.frameapp.ARE;
import com.lmt.frameapp.config.ASConfigure;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.ConnectionManager;
import com.lmt.frameapp.sql.Transaction;

public class BoardViewServlet extends HttpServlet {

	public BoardViewServlet() {
	}

	public void service(HttpServletRequest httpservletrequest,HttpServletResponse httpservletresponse) throws ServletException,IOException {
		Transaction transaction;
		ASResultSet asresultset;
		transaction = null;
		String sSelectSql ="";
		asresultset = null;
		String sType="";
		String sContentType="";
		int sContentLength =0;
		String sFileName="";
		String sFileSavePath="";
		String sFileSaveMode="";
		String sFilePath="";
		String sFullPath="";
		String sRealFileName="";
		InputStream inputstream=null;
		try {
			ServletOutputStream servletoutputstream1 = httpservletresponse.getOutputStream();
			HttpSession httpsession = httpservletrequest.getSession(true);
			if (httpsession == null || httpsession.getAttributeNames() == null)
				throw new Exception("------Timeout------");
			ASConfigure asconfigure = ASConfigure.getASConfigure();
			String sDataSource = asconfigure.getConfigure("DataSource");
			try {
				transaction = ConnectionManager.getTransaction(sDataSource);
			} catch (Exception exception1) {
				exception1.printStackTrace();
				throw new Exception("连接数据库失败！连接参数：<br>DataSource:"+ sDataSource);
			}
			String sqlString = "";
			sqlString = DataConvert.toString(httpservletrequest.getParameter("sqlString"));
			String as[] = StringFunction.toStringArray(sqlString, "@");
			if(as.length!=2){
				return;
			}
			sType = as[0];
			sSelectSql = DataConvert.toString(as[1]);
			if (sSelectSql.equals(""))
				return;
			asresultset = transaction.getASResultSet2(sSelectSql);
			if(asresultset.next()){
				sContentType = DataConvert.toString(asresultset.getString("ContentType"));
				httpservletresponse.setContentType(sContentType + ";charset=GBK");
				
				sContentLength = asresultset.getInt("ContentLength");
				ARE.getLog().info("BoardViewServlet: ContentType[" + sContentType + "] ContentLength["+ sContentLength + "]");
				
				sFileName = DataConvert.toString(asresultset.getString("FileName"));
				sRealFileName = StringFunction.getFileName(sFileName);
				if (sType.equals("view")){
					//这一点必须用3
					httpservletresponse.setHeader("Content-Disposition","filename=" + DataConvert.toRealString(3, sRealFileName)+";");
				}else
					httpservletresponse.setHeader("Content-Disposition","attachment;filename=" + sRealFileName + ";");
				ARE.getLog().info("attachment;filename=" + sRealFileName + ";");
				
				sFileSaveMode = asconfigure.getConfigure("FileSaveMode");
				if (sqlString.indexOf("FileSaveMode") != -1) {
					String s12 = DataConvert.toString(asresultset.getString("FileSaveMode"));
					sFileSaveMode = "".equals(s12)?sFileSaveMode:s12;
				}
				ARE.getLog().info(" FileSaveMode[" + sFileSaveMode + "] FileName[" + sRealFileName + "]");
				
				sFullPath = null;
				if (sqlString.indexOf("FullPath") != -1)
					sFullPath = DataConvert.toString(asresultset.getString("FullPath"));
				sFilePath = null;
				if (sqlString.indexOf("FilePath") != -1)
					sFilePath = DataConvert.toString(asresultset.getString("FilePath"));
				ARE.getLog().info("FilePath[" + sFilePath + "] FullPath[" + sFullPath + "]");
			}else{
				return;
			}
			if (sContentLength == 0)
				return;
			if (sFileSaveMode.equals("Table")) {
				inputstream = asresultset.getBinaryStream("DocContent");
			}else if (sFileSaveMode.equals("Disk")) {
				sFileSavePath = asconfigure.getConfigure("FileSavePath");
				sFullPath = getFullPath(sFullPath, sFilePath, sFileName, sFileSavePath, getServletContext());
				if (sFullPath == null) {
					return;
				}
				inputstream = new FileInputStream(sFullPath);
			}
			byte abyte1[] = new byte[sContentLength];
			int k;
			while ((k = inputstream.read(abyte1, 0, sContentLength)) != -1) {
				ARE.getLog().debug("BoardViewServlet Read:" + k);
				servletoutputstream1.write(abyte1, 0, k);
			}
			inputstream.close();
			servletoutputstream1.flush();
			servletoutputstream1.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (asresultset != null)
					asresultset.getStatement().close();
				if (transaction != null) {
					transaction.conn.commit();
					transaction.disConnect();
					transaction = null;
				}
			} catch (Exception exception3) {
				ARE.getLog().error("BoardViewServlet SQL Error2:", exception3);
			}
		}
	}

	private String getFullPath(String sFullPath, String sFilePath, String sFileName, String sFileSavePath,
			ServletContext servletcontext) throws Exception {
		Object obj = null;
		if (sFullPath != null&&sFullPath.equals("")) {
			File file = new File(sFullPath);
			if (!file.exists()) {
				ARE.getLog().warn(
						"BoardViewServlet \u6587\u4EF6 [" + sFullPath
								+ "]\u4E0D\u5B58\u5728\uFF01\uFF01\uFF01");
				sFullPath = null;
			}
		} else {
			File file1 = new File(sFileSavePath);
			if (!file1.exists()) {
				ARE.getLog().warn(
						"BoardViewServlet FileSavePath [" + sFileSavePath
								+ "]\u4E0D\u5B58\u5728\uFF01\uFF01\uFF01");
				sFileSavePath = servletcontext.getRealPath("/WEB-INF/Upload");
				File file2 = new File(sFileSavePath);
				if (!file2.exists()) {
					ARE.getLog().warn(
							"BoardViewServlet FileSavePath [" + sFileSavePath
									+ "]\u4E0D\u5B58\u5728\uFF01\uFF01\uFF01");
					sFileSavePath = null;
					sFullPath = null;
				}
			}
			if (sFileSavePath != null) {
				sFullPath = sFileSavePath + "/" + sFilePath;
				File file3 = new File(sFullPath);
				if (!file3.exists()) {
					ARE.getLog().warn(
							"BoardViewServlet File FullName...[" + sFullPath
									+ "] Not Exist!");
					sFullPath = null;
				} else {
					ARE.getLog().warn(
							"BoardViewServlet File FullName...[" + sFullPath + "]");
				}
			}
		}
		return sFullPath;
	}

	public String getServletInfo() {
		return "return a String representation of the current time";
	}

	private static final long serialVersionUID = 1L;
}