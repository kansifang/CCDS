package com.lmt.app.crawler.Chap10.SVM.svmLight;

public class Word {
	public int wnum;
	public float weight;
	
	public Word()
	{}
	
	public Word(int w, float wei)
	{
		wnum = w;
		weight = wei;
	}
	
	public String toString()
	{
		return "wnum:"+wnum+" weight:"+weight;
	}
}
