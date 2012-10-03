package com.amarsoft.impl.tjnh_als.bizlets;

import com.amarsoft.are.sql.Transaction;

public interface MFTradeInterface {
	public String runMFTrade(SocketManager sm,String ObjectNo,String ObjectType,Transaction Sqlca,String sFilePath,String sTradeDate);
}
