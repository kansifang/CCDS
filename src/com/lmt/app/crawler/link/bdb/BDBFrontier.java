package com.lmt.app.crawler.link.bdb;

import java.io.FileNotFoundException;
import java.util.Map.Entry;
import java.util.Set;

import com.lmt.app.crawler.dao.HtmlURL;
import com.sleepycat.bind.EntryBinding;
import com.sleepycat.bind.serial.SerialBinding;
import com.sleepycat.collections.StoredMap;
import com.sleepycat.je.DatabaseException;

public class BDBFrontier extends AbstractFrontier implements Frontier {
	private StoredMap pendingUrisDB = null;
	// ʹ��Ĭ�ϵ�·���ͻ����С���캯��
	public BDBFrontier(String homeDirectory) throws DatabaseException,FileNotFoundException {
		super(homeDirectory);
		EntryBinding keyBinding = new SerialBinding(javaCatalog, String.class);
		EntryBinding valueBinding = new SerialBinding(javaCatalog,HtmlURL.class);
		pendingUrisDB = new StoredMap(database, keyBinding, valueBinding, true);
	}

	// �����һ����¼
	public HtmlURL getNext() throws Exception {
		HtmlURL result = null;
		if (!pendingUrisDB.isEmpty()) {
			Set<Entry<String, HtmlURL>> entrys = pendingUrisDB.entrySet();
			System.out.println(entrys);
			Entry<String, HtmlURL> entry = entrys.iterator().next();
			result = entry.getValue();
			delete(entry.getKey());
		}
		return result;
	}

	// ���� URL
	public boolean putUrl(HtmlURL url) {
		put(url.getOriUrl(), url);
		return true;
	}

	// �������ݿ�ķ���
	protected void put(Object key, Object value) {
		pendingUrisDB.put(key, value);
	}

	// ȡ��
	protected Object get(Object key) {
		return pendingUrisDB.get(key);
	}

	// ɾ��
	protected Object delete(Object key) {
		return pendingUrisDB.remove(key);
	}

	// ���� URL �����ֵ������ʹ�ø���ѹ���㷨������ MD5 ��ѹ���㷨
	private String caculateUrl(String url) {
		return url;
	}

	// ���Ժ���
	public static void main(String[] strs) {
		try {
			BDBFrontier bBDBFrontier = new BDBFrontier("c:\\bdb");
			HtmlURL url = new HtmlURL();
			url.setOriUrl("http://www.163.com");
			bBDBFrontier.putUrl(url);
			System.out.println(((HtmlURL) bBDBFrontier.getNext()).getOriUrl());
			bBDBFrontier.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
	}
}