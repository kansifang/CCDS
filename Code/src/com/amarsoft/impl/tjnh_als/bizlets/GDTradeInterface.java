package com.amarsoft.impl.tjnh_als.bizlets;

import com.amarsoft.are.sql.Transaction;

public interface GDTradeInterface {
	public String runGDTrade(SocketManager sm,String ObjectNo,String ObjectType,Transaction Sqlca,String sFilePath,String sTradeDate);
}
