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
	// 设置代理服务器
	static {
		// 设置代理服务器的IP地址和端口
		httpClient.getHostConfiguration().setProxy("172.17.18.84", 8080);
	}
	/* 下载 url 指向的网页 ,以post形式*/
	public void downloadPageWPost(String url) throws HttpException,IOException{
		InputStream input = null;
		OutputStream output = null;
		// 得到post方法
		PostMethod postMethod = new PostMethod(url);
		// 设置post方法的参数
		NameValuePair[] postData = new NameValuePair[2]; 
		postData[0] = new NameValuePair("name","lietu"); 
		postData[1] = new NameValuePair("password","*****");
		postMethod.addParameters(postData);
		// 执行，返回状态码
		int statusCode = httpClient.executeMethod(postMethod);
		// 针对状态码进行处理 (简单起见，只处理返回值为200的状态码)
		if (statusCode == HttpStatus.SC_OK) {
			input = postMethod.getResponseBodyAsStream();
			// 得到文件名
			String filename = url.substring(url.lastIndexOf('/') + 1);
			// 获得文件输出流
			output = new FileOutputStream(filename);
			// 输出到文件
			int tempByte = -1;
			while ((tempByte = input.read()) > 0) {
				output.write(tempByte);
			}
			// 关闭输入输出流
			if (input != null) {
				input.close();
			}
			if (output != null) {
				output.close();
			}
		}
		// 若需要转向，则进行转向操作
		if ((statusCode == HttpStatus.SC_MOVED_TEMPORARILY)
				|| (statusCode == HttpStatus.SC_MOVED_PERMANENTLY)
				|| (statusCode == HttpStatus.SC_SEE_OTHER)
				|| (statusCode == HttpStatus.SC_TEMPORARY_REDIRECT)) {
			// 读取新的URL地址
			Header header = postMethod.getResponseHeader("location");
			if (header != null) {
				String newUrl = header.getValue();
				if (newUrl == null || newUrl.equals("")) {
					newUrl = "/";
					// 使用post转向
					PostMethod redirect = new PostMethod(newUrl);
					// 发送请求，做进一步处理。。。。。
				}
			}
		}
	}
	/* 下载 url 指向的网页 ,以get形式*/
	public String downloadPageWGet(String url) {
		String filePath = null;
		/* 1.生成 HttpClinet 对象并设置参数 */
		HttpClient httpClient = new HttpClient();
		// 设置 Http 连接超时 5s
		httpClient.getHttpConnectionManager().getParams().setConnectionTimeout(5000);
		/* 2.生成 GetMethod 对象并设置参数 */
		GetMethod getMethod = new GetMethod(url);
		// 设置 get 请求超时 5s
		getMethod.getParams().setParameter(HttpMethodParams.SO_TIMEOUT, 5000);
		// 设置请求重试处理
		getMethod.getParams().setParameter(HttpMethodParams.RETRY_HANDLER,
				new DefaultHttpMethodRetryHandler());

		/* 3.执行 HTTP GET 请求 */
		try {
			int statusCode = httpClient.executeMethod(getMethod);
			// 判断访问的状态码
			if (statusCode != HttpStatus.SC_OK) {
				System.err.println("Method failed: "+getMethod.getStatusLine());
				filePath = null;
			}
			/* 4.处理 HTTP 响应内容 */
			byte[] responseBody = getMethod.getResponseBody();// 读取为字节数组
			// 根据网页 url 生成保存时的文件名
			filePath = "temp\\"+ getFileNameByUrl(url,getMethod.getResponseHeader("Content-Type").getValue());
			saveToLocal(responseBody, filePath);
		} catch (HttpException e) {
			// 发生致命的异常，可能是协议不对或者返回的内容有问题
			System.out.println("Please check your provided http address!");
			e.printStackTrace();
		} catch (IOException e) {
			// 发生网络异常
			e.printStackTrace();
		} finally {
			// 释放连接
			getMethod.releaseConnection();
		}
		return filePath;
	}

	/**
	 * 根据 url 和网页类型生成需要保存的网页的文件名 去除掉 url 中非文件名字符
	 */
	public String getFileNameByUrl(String url, String contentType) {
		// remove http://
		url = url.substring(7);
		// text/html类型
		if (contentType.indexOf("html") != -1) {
			url = url.replaceAll("[\\?/:*|<>\"]", "_") + ".html";
			return url;
		}
		// 如application/pdf类型
		else {
			return url.replaceAll("[\\?/:*|<>\"]", "_") + "."
					+ contentType.substring(contentType.lastIndexOf("/") + 1);
		}
	}

	/**
	 * 保存网页字节数组到本地文件 filePath 为要保存的文件的相对地址
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
	 * 测试代码
	 */
	public static void main(String[] args) {
		// 抓取lietu首页,输出
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
