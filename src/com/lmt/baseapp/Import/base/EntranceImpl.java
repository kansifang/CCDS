package com.lmt.baseapp.Import.base;

public interface EntranceImpl {
	//configNo是描述数据文件的配置号，Key是主键，两个结合决定了一个批次导入
	public void actionBefore(String configNo,String Key) throws Exception;
	public void action(String configNo,String Key) throws Exception;
}