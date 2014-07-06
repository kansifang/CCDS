package com.lmt.app.crawler.Chap10.SVM.test;

import com.lmt.app.crawler.Chap10.SVM.classify.ClassifierParam;

public class TestClassifierParam {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		ClassifierParam theClassifier = new ClassifierParam();
		
		theClassifier.getFromFile("D:/lg/work/yipin/model/params.dat");
		System.out.println(theClassifier);
	}

}
