package com.lmt.app.crawler;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
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

/**
 * 用于对搜狐网站上的新闻进行抓取
 * @author guanminglin <guanminglin@gmail.com>
 */
public class LocalHttpClient {
	private static HttpClient httpClient = null;
	// 设置代理服务器
	static {
		httpClient = new HttpClient();
		// 设置 Http 连接超时 5s
		httpClient.getHttpConnectionManager().getParams().setConnectionTimeout(5000);
		// 设置代理服务器的IP地址和端口
		//httpClient.getHostConfiguration().setProxy("172.17.18.84", 8080);
		
	}
	/* 下载 url 指向的网页 ,以post形式*/
	public static GetMethod getGetMethod(String url){
		/* 生成 GetMethod 对象并设置参数 */
		GetMethod gm = new GetMethod(url);
		// 设置 get 请求超时 5s
		gm.getParams().setParameter(HttpMethodParams.SO_TIMEOUT, 5000);
		// 设置请求重试处理
		gm.getParams().setParameter(HttpMethodParams.RETRY_HANDLER,new DefaultHttpMethodRetryHandler());
		/* 3.执行 HTTP GET 请求 */
		try {
			int statusCode = httpClient.executeMethod(gm);
			// 判断访问的状态码
			if (statusCode != HttpStatus.SC_OK) {
				System.err.println("Method failed: "+gm.getStatusLine());
				return null;
			}
			/* 4.处理 HTTP 响应内容 */
			//byte[] responseBody = gm.getResponseBody();// 读取为字节数组
			// 根据网页 url 生成保存时的文件名
			//filePath = "temp\\"+ getFileNameByUrl(url,gm.getResponseHeader("Content-Type").getValue());
			//saveToLocal(responseBody, filePath);
		} catch (HttpException e) {
			// 发生致命的异常，可能是协议不对或者返回的内容有问题
			System.out.println("Please check your provided http address!");
			e.printStackTrace();
		} catch (IOException e) {
			// 发生网络异常
			System.out.println("Please check your provided internet!");
			e.printStackTrace();
		} 
		return gm;
	}
	/* 下载 url 指向的网页 ,以post形式*/
	public static PostMethod getPostMethod(String url){
		// 得到post方法
		PostMethod pm = new PostMethod(url);
		// 设置post方法的参数
		NameValuePair[] postData = new NameValuePair[2]; 
		postData[0] = new NameValuePair("name","lietu"); 
		postData[1] = new NameValuePair("password","*****");
		pm.addParameters(postData);
		// 执行，返回状态码
		int statusCode=0;
		try {
			statusCode = httpClient.executeMethod(pm);
		} catch (HttpException e) {
			// 发生致命的异常，可能是协议不对或者返回的内容有问题
			System.out.println("Please check your provided http address!");
			e.printStackTrace();
		} catch (IOException e) {
			// 发生网络异常
			System.out.println("Please check your provided internet!");
			e.printStackTrace();
		}
		// 针对状态码进行处理 (简单起见，只处理返回值为200的状态码)
		if (statusCode == HttpStatus.SC_OK) {
			return pm;
		}
		// 若需要转向，则进行转向操作
		if ((statusCode == HttpStatus.SC_MOVED_TEMPORARILY)
				|| (statusCode == HttpStatus.SC_MOVED_PERMANENTLY)
				|| (statusCode == HttpStatus.SC_SEE_OTHER)
				|| (statusCode == HttpStatus.SC_TEMPORARY_REDIRECT)) {
			// 读取新的URL地址
			Header header = pm.getResponseHeader("location");
			if (header != null) {
				String newUrl = header.getValue();
				if (newUrl == null || newUrl.equals("")) {
					newUrl = "/";
					// 获得转向新网址的PostMethod
					return new PostMethod(newUrl);
				}
			}
		}
		return null;
	}
	public static void downloadPage(String filePath,String url){
		GetMethod gm=LocalHttpClient.getGetMethod(url);
		try {
			BufferedInputStream bi = new BufferedInputStream(gm.getResponseBodyAsStream());
			// 得到文件名
			String filename = getFileNameByUrl(url,gm.getResponseHeader("Content-Type").getValue());
			// 根据网页 url 生成保存时的文件名
			File file= new File(filePath+"\\"+filename) ;//这是默认 C//temp/目录下
			// 获得文件输出流
			DataOutputStream out = new DataOutputStream(new FileOutputStream(file));
			// 输出到文件
			int tempByte = -1;
			while ((tempByte = bi.read()) > 0) {
				out.write(tempByte);
			}
			// 关闭输入输出流
			if (bi != null) {
				bi.close();
			}
			if (out != null) {
				out.close();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * 根据 url 和网页类型生成需要保存的网页的文件名 去除掉 url 中非文件名字符
	 */
	private static String getFileNameByUrl(String url, String contentType) {
		// remove http://
		url = url.substring(7);
		// text/html类型
		if (contentType.indexOf("html") != -1) {
			url = url.replaceAll("[\\?/:*|<>\"]", "_") + ".html";
			return url;
		}
		else {// 如application/pdf类型
			return url.replaceAll("[\\?/:*|<>\"]", "_")+"."+contentType.substring(contentType.lastIndexOf("/") + 1);
		}
	}
	//单个文件测试网页
    public static void main(String[] args) {
      //  SohuNews news = new SohuNews();
      LocalHttpClient.downloadPage("d:\\tmp","http://news.sohu.com/20090518/n264012864.shtml");   
    }
}
