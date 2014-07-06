package com.lmt.app.crawler;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.commons.httpclient.DefaultHttpMethodRetryHandler;
import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.params.HttpMethodParams;

public class RetrivePage {
	private static HttpClient httpClient = new HttpClient();
	// ���ô��������
	static {
		// ���ô����������IP��ַ�Ͷ˿�
		httpClient.getHostConfiguration().setProxy("172.17.18.84", 8080);
	}
	/* ���� url ָ�����ҳ ,��post��ʽ*/
	public void downloadPageWPost(String url) throws HttpException,IOException{
		InputStream input = null;
		OutputStream output = null;
		// �õ�post����
		PostMethod postMethod = new PostMethod(url);
		// ����post�����Ĳ���
		NameValuePair[] postData = new NameValuePair[2]; 
		postData[0] = new NameValuePair("name","lietu"); 
		postData[1] = new NameValuePair("password","*****");
		postMethod.addParameters(postData);
		// ִ�У�����״̬��
		int statusCode = httpClient.executeMethod(postMethod);
		// ���״̬����д��� (�������ֻ������ֵΪ200��״̬��)
		if (statusCode == HttpStatus.SC_OK) {
			input = postMethod.getResponseBodyAsStream();
			// �õ��ļ���
			String filename = url.substring(url.lastIndexOf('/') + 1);
			// ����ļ������
			output = new FileOutputStream(filename);
			// ������ļ�
			int tempByte = -1;
			while ((tempByte = input.read()) > 0) {
				output.write(tempByte);
			}
			// �ر����������
			if (input != null) {
				input.close();
			}
			if (output != null) {
				output.close();
			}
		}
		// ����Ҫת�������ת�����
		if ((statusCode == HttpStatus.SC_MOVED_TEMPORARILY)
				|| (statusCode == HttpStatus.SC_MOVED_PERMANENTLY)
				|| (statusCode == HttpStatus.SC_SEE_OTHER)
				|| (statusCode == HttpStatus.SC_TEMPORARY_REDIRECT)) {
			// ��ȡ�µ�URL��ַ
			Header header = postMethod.getResponseHeader("location");
			if (header != null) {
				String newUrl = header.getValue();
				if (newUrl == null || newUrl.equals("")) {
					newUrl = "/";
					// ʹ��postת��
					PostMethod redirect = new PostMethod(newUrl);
					// ������������һ��������������
				}
			}
		}
	}
	/* ���� url ָ�����ҳ ,��get��ʽ*/
	public String downloadPageWGet(String url) {
		String filePath = null;
		/* 1.���� HttpClinet �������ò��� */
		HttpClient httpClient = new HttpClient();
		// ���� Http ���ӳ�ʱ 5s
		httpClient.getHttpConnectionManager().getParams().setConnectionTimeout(5000);
		/* 2.���� GetMethod �������ò��� */
		GetMethod getMethod = new GetMethod(url);
		// ���� get ����ʱ 5s
		getMethod.getParams().setParameter(HttpMethodParams.SO_TIMEOUT, 5000);
		// �����������Դ���
		getMethod.getParams().setParameter(HttpMethodParams.RETRY_HANDLER,
				new DefaultHttpMethodRetryHandler());

		/* 3.ִ�� HTTP GET ���� */
		try {
			int statusCode = httpClient.executeMethod(getMethod);
			// �жϷ��ʵ�״̬��
			if (statusCode != HttpStatus.SC_OK) {
				System.err.println("Method failed: "+getMethod.getStatusLine());
				filePath = null;
			}
			/* 4.���� HTTP ��Ӧ���� */
			byte[] responseBody = getMethod.getResponseBody();// ��ȡΪ�ֽ�����
			// ������ҳ url ���ɱ���ʱ���ļ���
			filePath = "temp\\"+ getFileNameByUrl(url,getMethod.getResponseHeader("Content-Type").getValue());
			saveToLocal(responseBody, filePath);
		} catch (HttpException e) {
			// �����������쳣��������Э�鲻�Ի��߷��ص�����������
			System.out.println("Please check your provided http address!");
			e.printStackTrace();
		} catch (IOException e) {
			// ���������쳣
			e.printStackTrace();
		} finally {
			// �ͷ�����
			getMethod.releaseConnection();
		}
		return filePath;
	}

	/**
	 * ���� url ����ҳ����������Ҫ�������ҳ���ļ��� ȥ���� url �з��ļ����ַ�
	 */
	public String getFileNameByUrl(String url, String contentType) {
		// remove http://
		url = url.substring(7);
		// text/html����
		if (contentType.indexOf("html") != -1) {
			url = url.replaceAll("[\\?/:*|<>\"]", "_") + ".html";
			return url;
		}
		// ��application/pdf����
		else {
			return url.replaceAll("[\\?/:*|<>\"]", "_") + "."
					+ contentType.substring(contentType.lastIndexOf("/") + 1);
		}
	}

	/**
	 * ������ҳ�ֽ����鵽�����ļ� filePath ΪҪ������ļ�����Ե�ַ
	 */
	private void saveToLocal(byte[] data, String filePath) {
		try {
			DataOutputStream out = new DataOutputStream(new FileOutputStream(
					new File(filePath)));
			for (int i = 0; i < data.length; i++)
				out.write(data[i]);
			out.flush();
			out.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	/**
	 * ���Դ���
	 */
	public static void main(String[] args) {
		// ץȡlietu��ҳ,���
		try {
			RetrivePage downLoader=new RetrivePage();
			downLoader.downloadPageWPost("http://www.lietu.com");
		} catch (HttpException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
