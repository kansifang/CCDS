package com.lmt.app.crawler.Chap03;
/**
 * <pre>
 * һ��IP��Χ��¼�������������Һ�����Ҳ������ʼIP�ͽ���IP
 * </pre>
 */
public class IPEntry {
    public String beginIp;
    public String endIp;
    public String country;
    public String area;
    
    /**
     * ���캯��
     */
    public IPEntry() {
        beginIp = endIp = country = area = "";
    }
}
