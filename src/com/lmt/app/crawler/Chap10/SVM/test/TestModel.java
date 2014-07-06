package com.lmt.app.crawler.Chap10.SVM.test;

import com.lmt.app.crawler.Chap10.SVM.svmLight.Model;

public class TestModel {

	/**
	 * @param args
	 */
	public static void main(String[] args) throws Exception {
		String modelfile = "D:/lg/work/wq/model/model1.mdl";
		Model model = new Model(modelfile);
		
		System.out.println(model.kernel_parm);
	}

}
