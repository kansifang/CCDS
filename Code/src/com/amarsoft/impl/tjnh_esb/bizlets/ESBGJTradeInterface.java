package com.amarsoft.impl.tjnh_esb.bizlets;

import com.amarsoft.are.sql.Transaction;

public interface ESBGJTradeInterface {
	public String runESBGJTrade(String ObjectNo,String ObjectType,String TradeType,Transaction Sqlca,String sTradeDate);
}
