/*jadclipse*/// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.

package com.lmt.frameapp.web.uad;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;

import com.lmt.frameapp.ARE;

// Referenced classes of package com.amarsoft.web.upload:
//            Files, Request, AmarsoftUploadException, File

public class AmarsoftUpload {

	public AmarsoftUpload() {
		m_totalBytes = 0;
		m_currentIndex = 0;
		m_startData = 0;
		m_endData = 0;
		m_boundary = new String();
		m_totalMaxFileSize = 0L;
		m_maxFileSize = 0L;
		m_deniedFilesList = new Vector();
		m_allowedFilesList = new Vector();
		m_denyPhysicalPath = false;
		m_contentDisposition = new String();
		m_files = new Files();
		m_formRequest = new Request();
	}

	public final void init(ServletConfig servletconfig) throws ServletException {
		m_application = servletconfig.getServletContext();
	}

	public void service(HttpServletRequest httpservletrequest,
			HttpServletResponse httpservletresponse) throws IOException,
			ServletException {
		m_request = httpservletrequest;
		m_response = httpservletresponse;
	}

	public final void initialize(ServletConfig servletconfig,
			HttpServletRequest httpservletrequest,
			HttpServletResponse httpservletresponse) throws ServletException {
		m_application = servletconfig.getServletContext();
		m_request = httpservletrequest;
		m_response = httpservletresponse;
	}

	public final void initialize(PageContext pagecontext)
			throws ServletException {
		m_application = pagecontext.getServletContext();
		m_request = (HttpServletRequest) pagecontext.getRequest();
		m_response = (HttpServletResponse) pagecontext.getResponse();
	}

	public final void initialize(ServletContext servletcontext,
			HttpSession httpsession, HttpServletRequest httpservletrequest,
			HttpServletResponse httpservletresponse, JspWriter jspwriter)
			throws ServletException {
		m_application = servletcontext;
		m_request = httpservletrequest;
		m_response = httpservletresponse;
	}

	public void upload() throws AmarsoftUploadException, IOException,
			ServletException {
		int i = 0;
		long l = 0L;
		boolean flag1 = false;
		String s4 = new String();
		String s5 = new String();
		String s6 = new String();
		String s7 = new String();
		String s8 = new String();
		String s9 = new String();
		String s10 = new String();
		m_totalBytes = m_request.getContentLength();
		ARE.getLog().debug(
				(new StringBuilder())
						.append("upload: Upload Begin TotalBytes[")
						.append(m_totalBytes).append("]").toString());
		m_binArray = new byte[m_totalBytes];
		int iReadSum = 0;
		do {
			if (i >= m_totalBytes)
				break;
			int j;
			try {
				j = m_request.getInputStream().read(m_binArray, i,
						m_totalBytes - i);
				ARE.getLog().trace(
						(new StringBuilder()).append("upload: read ").append(j)
								.toString());
				iReadSum += j;
				if (j <= 0) {
					ARE.getLog().trace("upload: read <=0 .......err,break");
					break;
				}
			} catch (Exception exception) {
				ARE.getLog().error(
						(new StringBuilder()).append("upload: readSumSize ")
								.append(iReadSum).toString());
				throw new AmarsoftUploadException(
						"[Amarsoft Upload]Unable to upload.");
			}
			i += j;
		} while (true);
		if (iReadSum != m_totalBytes) {
			ARE.getLog().trace(
					(new StringBuilder()).append("upload: readSumSize ")
							.append(iReadSum).toString());
			throw new AmarsoftUploadException(
					"[Amarsoft Upload]upload err for size.");
		}
		ARE.getLog().trace("upload: Upload 1");
		for (; !flag1 && m_currentIndex < m_totalBytes; m_currentIndex++)
			if (m_binArray[m_currentIndex] == 13)
				flag1 = true;
			else
				m_boundary = (new StringBuilder()).append(m_boundary)
						.append((char) m_binArray[m_currentIndex]).toString();

		ARE.getLog().trace(
				(new StringBuilder()).append("upload: m_boundary.length:[")
						.append(m_boundary.length()).append("]").toString());
		ARE.getLog().trace(
				(new StringBuilder()).append("upload: m_boundary[")
						.append(m_boundary).append("]").toString());
		String sMyHead = "";
		for (int kk = 0; kk < 300 && kk < m_totalBytes; kk++)
			sMyHead = (new StringBuilder()).append(sMyHead)
					.append((char) m_binArray[kk]).toString();

		ARE.getLog().trace(
				(new StringBuilder()).append("upload: myHead[").append(sMyHead)
						.append("]").toString());
		ARE.getLog().trace("upload: Upload 2");
		if (m_currentIndex == 1)
			return;
		m_currentIndex++;
		int iTimes = 0;
		do {
			iTimes++;
			ARE.getLog().trace(
					(new StringBuilder())
							.append("upload: Upload do...while...[")
							.append(iTimes).append("][").append(m_currentIndex)
							.append("]").toString());
			if (iTimes > 102 || m_currentIndex >= m_totalBytes)//iTimes表示允许前台Form之要素的个数，原来为10，只能上传4个文件，改成100，可以上传多谢
				break;
			String s1 = getDataHeader();
			m_currentIndex = m_currentIndex + 2;
			boolean flag3 = s1.indexOf("filename") > 0;
			String s3 = getDataFieldValue(s1, "name");
			if (flag3) {
				s6 = getDataFieldValue(s1, "filename");
				s4 = getFileName(s6);
				s5 = getFileExt(s4);
				s7 = getContentType(s1);
				s8 = getContentDisp(s1);
				s9 = getTypeMIME(s7);
				s10 = getSubTypeMIME(s7);
			}
			getDataSection();
			if (flag3 && s4.length() > 0) {
				if (m_deniedFilesList.contains(s5))
					throw new SecurityException(
							"[Amarsoft Upload]The extension of the file is denied to be uploaded (1015).");
				if (!m_allowedFilesList.isEmpty()
						&& !m_allowedFilesList.contains(s5))
					throw new SecurityException(
							"[Amarsoft Upload]The extension of the file is not allowed to be uploaded (1010).");
				if (m_maxFileSize > 0L
						&& (long) ((m_endData - m_startData) + 1) > m_maxFileSize)
					throw new SecurityException(
							String.valueOf((new StringBuffer(
									"Size exceeded for this file : ")).append(
									s4).append(" (1105).")));
				l += (m_endData - m_startData) + 1;
				if (m_totalMaxFileSize > 0L && l > m_totalMaxFileSize)
					throw new SecurityException(
							"[Amarsoft Upload]Total File Size exceeded (1110).");
			}
			if (flag3) {
				com.lmt.frameapp.web.uad.File file = new com.lmt.frameapp.web.uad.File();
				file.setParent(this);
				file.setFieldName(s3);
				file.setFileName(s4);
				file.setFileExt(s5);
				file.setFilePathName(s6);
				file.setIsMissing(s6.length() == 0);
				file.setContentType(s7);
				file.setContentDisp(s8);
				file.setTypeMIME(s9);
				file.setSubTypeMIME(s10);
				if (s7.indexOf("application/x-macbinary") > 0)
					m_startData = m_startData + 128;
				file.setSize((m_endData - m_startData) + 1);
				file.setStartData(m_startData);
				file.setEndData(m_endData);
				m_files.addFile(file);
			} else {
				String s11 = new String(m_binArray, m_startData,
						(m_endData - m_startData) + 1);
				m_formRequest.putParameter(s3, s11);
			}
			if ((char) m_binArray[m_currentIndex + 1] == '-')
				break;
			m_currentIndex = m_currentIndex + 2;
		} while (true);
		ARE.getLog().trace("upload: Upload End");
	}

	public int save(String s) throws AmarsoftUploadException, IOException,
			ServletException {
		return save(s, 0);
	}

	public int save(String s, int i) throws AmarsoftUploadException,
			IOException, ServletException {
		int j = 0;
		if (s == null)
			s = m_application.getRealPath("/");
		if (s.indexOf("/") != -1) {
			if (s.charAt(s.length() - 1) != '/')
				s = String.valueOf(s).concat("/");
		} else if (s.charAt(s.length() - 1) != '\\')
			s = String.valueOf(s).concat("\\");
		for (int k = 0; k < m_files.getCount(); k++)
			if (!m_files.getFile(k).isMissing()) {
				m_files.getFile(k).saveAs(
						(new StringBuilder()).append(s)
								.append(m_files.getFile(k).getFileName())
								.toString(), i);
				j++;
			}

		return j;
	}

	public int getSize() {
		return m_totalBytes;
	}

	public byte getBinaryData(int i) {
		byte byte0;
		try {
			byte0 = m_binArray[i];
		} catch (Exception exception) {
			throw new ArrayIndexOutOfBoundsException(
					"[Amarsoft Upload]Index out of range (1005).");
		}
		return byte0;
	}

	public Files getFiles() {
		return m_files;
	}

	public Request getRequest() {
		return m_formRequest;
	}

	public void downloadFile(String s) throws AmarsoftUploadException,
			IOException, ServletException {
		downloadFile(s, null, null);
	}

	public void downloadFile(String s, String s1)
			throws AmarsoftUploadException, IOException, ServletException {
		downloadFile(s, s1, null);
	}

	public void downloadFile(String s, String s1, String s2)
			throws AmarsoftUploadException, IOException, ServletException {
		downloadFile(s, s1, s2, 65000);
	}

	public void downloadFile(String s, String s1, String s2, int i)
			throws AmarsoftUploadException, IOException, ServletException {
		if (s == null)
			throw new IllegalArgumentException(
					String.valueOf((new StringBuffer("File '")).append(s)
							.append("' not found (1040).")));
		if (s.equals(""))
			throw new IllegalArgumentException(
					String.valueOf((new StringBuffer("File '")).append(s)
							.append("' not found (1040).")));
		if (!isVirtual(s) && m_denyPhysicalPath)
			throw new SecurityException(
					"[Amarsoft Upload]Physical path is denied (1035).");
		if (isVirtual(s))
			s = m_application.getRealPath(s);
		File file = new File(s);
		FileInputStream fileinputstream = new FileInputStream(file);
		long l = file.length();
		int k = 0;
		byte abyte0[] = new byte[i];
		if (s1 == null)
			m_response.setContentType("application/x-msdownload");
		else if (s1.length() == 0)
			m_response.setContentType("application/x-msdownload");
		else
			m_response.setContentType(s1);
		m_response.setContentLength((int) l);
		m_contentDisposition = m_contentDisposition != null ? m_contentDisposition
				: "attachment;";
		if (s2 == null)
			m_response.setHeader("Content-Disposition", String
					.valueOf((new StringBuffer(String
							.valueOf(m_contentDisposition))).append(
							" filename=").append(getFileName(s))));
		else if (s2.length() == 0)
			m_response.setHeader("Content-Disposition", m_contentDisposition);
		else
			m_response.setHeader("Content-Disposition", String
					.valueOf((new StringBuffer(String
							.valueOf(m_contentDisposition))).append(
							" filename=").append(s2)));
		while ((long) k < l) {
			int j = fileinputstream.read(abyte0, 0, i);
			k += j;
			m_response.getOutputStream().write(abyte0, 0, j);
		}
		fileinputstream.close();
	}

	public void downloadField(ResultSet resultset, String s, String s1,
			String s2) throws SQLException, IOException, ServletException {
		if (resultset == null)
			throw new IllegalArgumentException(
					"[Amarsoft Upload]The RecordSet cannot be null (1045).");
		if (s == null)
			throw new IllegalArgumentException(
					"[Amarsoft Upload]The columnName cannot be null (1050).");
		if (s.length() == 0)
			throw new IllegalArgumentException(
					"[Amarsoft Upload]The columnName cannot be empty (1055).");
		byte abyte0[] = resultset.getBytes(s);
		if (s1 == null)
			m_response.setContentType("application/x-msdownload");
		else if (s1.length() == 0)
			m_response.setContentType("application/x-msdownload");
		else
			m_response.setContentType(s1);
		m_response.setContentLength(abyte0.length);
		if (s2 == null)
			m_response.setHeader("Content-Disposition", "attachment;");
		else if (s2.length() == 0)
			m_response.setHeader("Content-Disposition", "attachment;");
		else
			m_response.setHeader("Content-Disposition",
					"attachment; filename=".concat(String.valueOf(s2)));
		m_response.getOutputStream().write(abyte0, 0, abyte0.length);
	}

	public void fieldToFile(ResultSet resultset, String s, String s1)
			throws SQLException, AmarsoftUploadException, IOException,
			ServletException {
		try {
			if (m_application.getRealPath(s1) != null)
				s1 = m_application.getRealPath(s1);
			InputStream inputstream = resultset.getBinaryStream(s);
			FileOutputStream fileoutputstream = new FileOutputStream(s1);
			char c = '\u1064';
			byte abyte0[] = new byte[c];
			int i;
			while ((i = inputstream.read(abyte0, 0, c)) != -1)
				fileoutputstream.write(abyte0, 0, i);
			fileoutputstream.close();
		} catch (Exception e) {
			ARE.getLog().error("fieldToFile error", e);
			throw new AmarsoftUploadException(
					"[Amarsoft Upload]Unable to save file from the DataBase (1020).");
		}
	}

	private String getDataFieldValue(String s, String s1) {
		String s2 = new String();
		String s3 = new String();
		int i = 0;
		s2 = String.valueOf((new StringBuffer(String.valueOf(s1))).append("=")
				.append('"'));
		i = s.indexOf(s2);
		if (i > 0) {
			int j = i + s2.length();
			int k = j;
			s2 = "\"";
			int l = s.indexOf(s2, j);
			if (k > 0 && l > 0)
				s3 = s.substring(k, l);
		}
		return s3;
	}

	private String getFileExt(String s) {
		String s1 = new String();
		int i = 0;
		int j = 0;
		if (s == null)
			return null;
		i = s.lastIndexOf('.') + 1;
		j = s.length();
		s1 = s.substring(i, j);
		if (s.lastIndexOf('.') > 0)
			return s1;
		else
			return "";
	}

	private String getContentType(String s) {
		String s1 = new String();
		String s2 = new String();
		int i = 0;
		s1 = "Content-Type:";
		i = s.indexOf(s1) + s1.length();
		if (i != -1) {
			int j = s.length();
			s2 = s.substring(i, j);
		}
		return s2;
	}

	private String getTypeMIME(String s) {
		int i = 0;
		i = s.indexOf("/");
		if (i != -1)
			return s.substring(1, i);
		else
			return s;
	}

	private String getSubTypeMIME(String s) {
		int i = 0;
		i = s.indexOf("/") + 1;
		if (i != -1) {
			int j = s.length();
			return s.substring(i, j);
		} else {
			return s;
		}
	}

	private String getContentDisp(String s) {
		String s1 = new String();
		int i = 0;
		int j = 0;
		i = s.indexOf(":") + 1;
		j = s.indexOf(";");
		s1 = s.substring(i, j);
		return s1;
	}

	private void getDataSection() {
		int i = m_currentIndex;
		int j = 0;
		int k = m_boundary.length();
		m_startData = m_currentIndex;
		m_endData = 0;
		do {
			if (i >= m_totalBytes)
				break;
			if (m_binArray[i] == (byte) m_boundary.charAt(j)) {
				if (j == k - 1) {
					m_endData = ((i - k) + 1) - 3;
					break;
				}
				i++;
				j++;
			} else {
				i++;
				j = 0;
			}
		} while (true);
		m_currentIndex = m_endData + k + 3;
	}

	private String getDataHeader() {
		int i = m_currentIndex;
		int j = 0;
		boolean flag1 = false;
		while (!flag1)
			if (m_binArray[m_currentIndex] == 13
					&& m_binArray[m_currentIndex + 2] == 13) {
				flag1 = true;
				j = m_currentIndex - 1;
				m_currentIndex = m_currentIndex + 2;
			} else {
				m_currentIndex++;
			}
		String s = new String(m_binArray, i, (j - i) + 1);
		return s;
	}

	private String getFileName(String s) {
		int i = 0;
		i = s.lastIndexOf('/');
		if (i != -1)
			return s.substring(i + 1, s.length());
		i = s.lastIndexOf('\\');
		if (i != -1)
			return s.substring(i + 1, s.length());
		else
			return s;
	}

	public void setDeniedFilesList(String s) throws SQLException, IOException,
			ServletException {
		if (s != null) {
			String s2 = "";
			for (int i = 0; i < s.length(); i++)
				if (s.charAt(i) == ',') {
					if (!m_deniedFilesList.contains(s2))
						m_deniedFilesList.addElement(s2);
					s2 = "";
				} else {
					s2 = (new StringBuilder()).append(s2).append(s.charAt(i))
							.toString();
				}

			if (s2 != "")
				m_deniedFilesList.addElement(s2);
		} else {
			m_deniedFilesList = null;
		}
	}

	public void setAllowedFilesList(String s) {
		if (s != null) {
			String s2 = "";
			for (int i = 0; i < s.length(); i++)
				if (s.charAt(i) == ',') {
					if (!m_allowedFilesList.contains(s2))
						m_allowedFilesList.addElement(s2);
					s2 = "";
				} else {
					s2 = (new StringBuilder()).append(s2).append(s.charAt(i))
							.toString();
				}

			if (s2 != "")
				m_allowedFilesList.addElement(s2);
		} else {
			m_allowedFilesList = null;
		}
	}

	public void setDenyPhysicalPath(boolean flag) {
		m_denyPhysicalPath = flag;
	}

	public void setContentDisposition(String s) {
		m_contentDisposition = s;
	}

	public void setTotalMaxFileSize(long l) {
		m_totalMaxFileSize = l;
	}

	public void setMaxFileSize(long l) {
		m_maxFileSize = l;
	}

	protected String getPhysicalPath(String s, int i) throws IOException {
		String s1 = new String();
		String s2 = new String();
		String s3 = new String();
		boolean flag = false;
		s3 = System.getProperty("file.separator");
		if (s == null)
			throw new IllegalArgumentException(
					"[Amarsoft Upload]There is no specified destination file (1140).");
		if (s.equals(""))
			throw new IllegalArgumentException(
					"[Amarsoft Upload]There is no specified destination file (1140).");
		if (s.lastIndexOf("\\") >= 0) {
			s1 = s.substring(0, s.lastIndexOf("\\"));
			s2 = s.substring(s.lastIndexOf("\\") + 1);
		}
		if (s.lastIndexOf("/") >= 0) {
			s1 = s.substring(0, s.lastIndexOf("/"));
			s2 = s.substring(s.lastIndexOf("/") + 1);
		}
		s1 = s1.length() != 0 ? s1 : "/";
		File file = new File(s1);
		if (file.exists())
			flag = true;
		if (i == 0) {
			if (isVirtual(s1)) {
				s1 = m_application.getRealPath(s1);
				if (s1.endsWith(s3))
					s1 = (new StringBuilder()).append(s1).append(s2).toString();
				else
					s1 = String.valueOf((new StringBuffer(String.valueOf(s1)))
							.append(s3).append(s2));
				return s1;
			}
			if (flag) {
				if (m_denyPhysicalPath)
					throw new IllegalArgumentException(
							"[Amarsoft Upload]Physical path is denied (1125).");
				else
					return s;
			} else {
				throw new IllegalArgumentException(
						"[Amarsoft Upload]This path does not exist (1135).");
			}
		}
		if (i == 1) {
			if (isVirtual(s1)) {
				s1 = m_application.getRealPath(s1);
				if (s1.endsWith(s3))
					s1 = (new StringBuilder()).append(s1).append(s2).toString();
				else
					s1 = String.valueOf((new StringBuffer(String.valueOf(s1)))
							.append(s3).append(s2));
				return s1;
			}
			if (flag)
				throw new IllegalArgumentException(
						"[Amarsoft Upload]The path is not a virtual path.");
			else
				throw new IllegalArgumentException(
						"[Amarsoft Upload]This path does not exist (1135).");
		}
		if (i == 2) {
			if (flag)
				if (m_denyPhysicalPath)
					throw new IllegalArgumentException(
							"[Amarsoft Upload]Physical path is denied (1125).");
				else
					return s;
			if (isVirtual(s1))
				throw new IllegalArgumentException(
						"[Amarsoft Upload]The path is not a physical path.");
			else
				throw new IllegalArgumentException(
						"[Amarsoft Upload]This path does not exist (1135).");
		} else {
			return null;
		}
	}

	public void uploadInFile(String s) throws AmarsoftUploadException,
			IOException {
		int i = 0;
		int j = 0;
		if (s == null)
			throw new IllegalArgumentException(
					"[Amarsoft Upload]There is no specified destination file (1025).");
		if (s.length() == 0)
			throw new IllegalArgumentException(
					"[Amarsoft Upload]There is no specified destination file (1025).");
		if (!isVirtual(s) && m_denyPhysicalPath)
			throw new SecurityException(
					"[Amarsoft Upload]Physical path is denied (1035).");
		i = m_request.getContentLength();
		m_binArray = new byte[i];
		int k;
		for (; j < i; j += k)
			try {
				k = m_request.getInputStream().read(m_binArray, j, i - j);
			} catch (Exception exception) {
				throw new AmarsoftUploadException(
						"[Amarsoft Upload]Unable to upload.");
			}

		if (isVirtual(s))
			s = m_application.getRealPath(s);
		try {
			File file = new File(s);
			FileOutputStream fileoutputstream = new FileOutputStream(file);
			fileoutputstream.write(m_binArray);
			fileoutputstream.close();
		} catch (Exception exception1) {
			throw new AmarsoftUploadException(
					"[Amarsoft Upload]The Form cannot be saved in the specified file (1030).");
		}
	}

	private boolean isVirtual(String s) {
		if (m_application.getRealPath(s) != null) {
			File file = new File(m_application.getRealPath(s));
			return file.exists();
		} else {
			return false;
		}
	}

	protected byte m_binArray[];
	protected HttpServletRequest m_request;
	protected HttpServletResponse m_response;
	protected ServletContext m_application;
	private int m_totalBytes;
	private int m_currentIndex;
	private int m_startData;
	private int m_endData;
	private String m_boundary;
	private long m_totalMaxFileSize;
	private long m_maxFileSize;
	private Vector m_deniedFilesList;
	private Vector m_allowedFilesList;
	private boolean m_denyPhysicalPath;
	private String m_contentDisposition;
	public static final int SAVE_AUTO = 0;
	public static final int SAVE_VIRTUAL = 1;
	public static final int SAVE_PHYSICAL = 2;
	private Files m_files;
	private Request m_formRequest;
}


/*
	DECOMPILATION REPORT

	Decompiled from: E:\work\ALS7\WebRoot\WEB-INF\lib\awe-c2-b90-rc2_g.jar
	Total time: 277 ms
	Jad reported messages/errors:
	Exit status: 0
	Caught exceptions:
*/