package com.lmt.baseapp.Import.base;

public interface EntranceImpl {
	//configNo�����������ļ������úţ�Key��������������Ͼ�����һ�����ε���
	public void actionBefore(String configNo,String Key) throws Exception;
	public void action(String configNo,String Key) throws Exception;
}