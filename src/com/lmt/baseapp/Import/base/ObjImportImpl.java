package com.lmt.baseapp.Import.base;

public interface ObjImportImpl {
	public void action(String configNo,String Key) throws Exception;
	public boolean checkObj() throws Exception;
	public void prepare() throws Exception;
	public void importRow() throws Exception;
}