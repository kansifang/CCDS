package com.lmt.baseapp.Import.base;

public interface EntranceImpl {
	public void actionBefore(String configNo,String Key) throws Exception;
	public void action(String configNo,String Key) throws Exception;
}