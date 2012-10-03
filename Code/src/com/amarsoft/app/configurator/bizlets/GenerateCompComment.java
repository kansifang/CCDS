package com.amarsoft.app.configurator.bizlets;

import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class GenerateCompComment extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception {
		String sSql = "insert into REG_COMMENT_ITEM " +
				"(CommentItemID,CommentItemName,SortNo,CommentItemType,DoGenHelp,Remark)" +
				" " +
					" select 'COMP_'||CompID,CompName,'20'||OrderNo,'020','true','Automatically generated'" +
					" from  REG_COMP_DEF" +
					" where " +
					"  '20'||OrderNo not in (select SortNo from  REG_COMMENT_ITEM)" +
					"  and OrderNo not like '99%'" +
				"  ";
		Sqlca.executeSQL(sSql);
		//System.out.print(sSql);
		sSql = "insert into REG_COMMENT_RELA " +
				"(CommentItemID,ObjectType,ObjectNo)" +
				" " +
					" select 'COMP_'||CompID,'ComponentDefinition',CompID" +
					" from REG_COMP_DEF" +
					" where " +
					" 'COMP_'||CompID in (select CommentItemID from REG_COMMENT_ITEM)" +
					" and 'COMP_'||CompID not in (select CommentItemID from REG_COMMENT_RELA)" +
				" ";
		
		Sqlca.executeSQL(sSql);
		return null;
	}

}
