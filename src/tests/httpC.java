package tests;

import java.io.IOException;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.methods.GetMethod;

public class httpC {
    public volatile static int count = 0;
    public static void inc() {
        //�����ӳ�1���룬ʹ�ý������
        try {
            Thread.sleep(1);
        } catch (InterruptedException e) {

        }
        count++;

    }
    public static void main(String[] args) throws HttpException, IOException {
        //ͬʱ����1000���̣߳�ȥ����i++���㣬����ʵ�ʽ��
        for (int i = 0; i < 0; i++) {
            new Thread(new Runnable() {
                public void run() {
                    httpC.inc();
                }
            }).start();
        }
        //����ÿ�����е�ֵ���п��ܲ�ͬ,����Ϊ1000
        System.out.println("���н��:Counter.count=" + httpC.count);
        HttpClient httpClient =new HttpClient();
        GetMethod gm=new GetMethod("http://www.ifeng.com");
        int statusCode=httpClient.executeMethod(gm);
        System.out.println("response="+gm.getResponseBodyAsString());
        gm.releaseConnection();
        String[][] SArray=new String[21][3];
        System.out.println(SArray.length);
    }

}