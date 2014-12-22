package com.lmt.app.crawler._09_removerepetition.Synonym;

public class TestSynonymDic {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		SynonymDic dicSynonymous = SynonymDic.getInstance();
		String text = "APOTEX INC ¨C ETOBICOKE";
		int offset = 0;
		SynonymDic.PrefixRet ret = new SynonymDic.PrefixRet(null,null);
		
		dicSynonymous.checkPrefix(text, offset, ret);
		System.out.println(ret);
		
	}

}
