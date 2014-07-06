package com.lmt.app.crawler;

import java.io.IOException;
import java.util.Set;

import org.apache.commons.httpclient.HttpException;

public class MyCrawler {
	/**
	 * ʹ�����ӳ�ʼ�� URL ����
	 * @return
	 * @param seeds ����URL
	 */ 
	private void initCrawlerWithSeeds(String[] seeds)
	{
		for(int i=0;i<seeds.length;i++)
			LinkQueue.addUnvisitedUrl(seeds[i]);
	}	
	/**
	 * ץȡ����
	 * @return
	 * @param seeds
	 */
	public void crawling(String[] seeds){//�������������ȡ��http://www.lietu.com��ͷ������
		LinkFilter filter = new LinkFilter(){
			public boolean accept(String url){
				if(url.startsWith("http://www.lietu.com"))
					return true;
				else
					return false;
			}
		};
		//��ʼ�� URL ����
		initCrawlerWithSeeds(seeds);
		//ѭ����������ץȡ�����Ӳ�����ץȡ����ҳ������1000
		while(!LinkQueue.unVisitedUrlsEmpty()&&LinkQueue.getVisitedUrlNum()<=1000){
			//1����ͷURL������
			String visitUrl=(String)LinkQueue.unVisitedUrlDeQueue();
			if(visitUrl==null)
				continue;
			RetrivePage downLoader=new RetrivePage();
			//2��������ҳ
			try {
				downLoader.downloadPageWPost(visitUrl);
			} catch (HttpException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			//3���� url ���뵽�ѷ��ʵ� URL ��
			LinkQueue.addVisitedUrl(visitUrl);
			//4����ȡ��������ҳ�е� URL
			Set<String> links=ExtractLink.extracLinks(visitUrl,filter);
			//5���µ�δ���ʵ� URL ���
			for(String link:links){
				LinkQueue.addUnvisitedUrl(link);
			}
		}
	}
	//main �������
	public static void main(String[]args)
	{
		MyCrawler crawler = new MyCrawler();
		crawler.crawling(new String[]{"http://www.twt.edu.cn"});
	}
}
