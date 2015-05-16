package tests;

import java.io.IOException;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.methods.GetMethod;

public class httpC {
    public volatile static int count = 0;
    public static void inc() {
        //这里延迟1毫秒，使得结果明显
        try {
            Thread.sleep(1);
        } catch (InterruptedException e) {

        }
        count++;

    }
    public static void main(String[] args) throws HttpException, IOException {
        //同时启动1000个线程，去进行i++计算，看看实际结果
        for (int i = 0; i < 0; i++) {
            new Thread(new Runnable() {
                public void run() {
                    httpC.inc();
                }
            }).start();
        }
        //这里每次运行的值都有可能不同,可能为1000
        System.out.println("运行结果:Counter.count=" + httpC.count);
        HttpClient httpClient =new HttpClient();
        GetMethod gm=new GetMethod("http://www.ifeng.com");
        int statusCode=httpClient.executeMethod(gm);
        System.out.println("response="+gm.getResponseBodyAsString());
        gm.releaseConnection();
        String[][] SArray=new String[21][3];
        System.out.println(SArray.length);
    }

}