/***********************************************************************
 * Module:  CreditLineCL.java
 * Author:  lpzhang 2009-9-4 for TJ
 * Modified: 
 * Purpose: Defines the Class CreditLineCL
 ***********************************************************************/

package com.amarsoft.app.creditline.bizlets;

import com.amarsoft.are.ASException;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.ASValuePool;
import com.amarsoft.are.util.StringFunction;

public class CreditLineCL {
	
	 private String lineID = "";
	 private String Style = "";
	 //�ܶ��
	 private ASValuePool CLpool = new ASValuePool();
	 //�Ӷ�ȳ�
	 private ASValuePool Subpool = new ASValuePool();
	//�Ӷ�ȳ�
	 private ASValuePool Memberpool = new ASValuePool();
	 //��ʱ�Ӷ�ȶ���
	 private ASValuePool oCLline = new ASValuePool();
	 
	 
	 private Transaction Sqlca = null;
	 
	 public CreditLineCL(String LineID,String Style, Transaction Sqlca) throws Exception {
		 this.lineID = LineID;
		 this.Style = Style;
		 this.Sqlca =Sqlca;
		 //��ʼ���ܶ��
		 initCL();
		 //��ʼ���Ӷ��
		 initSubCL();
	    }

	 public void initCL() throws Exception {
	     
	        //��ʼ��Attributes
	        String[] sAttKeys = {
	                "LineID","CLTypeID","ApplySerialNo","ApproveSerialNo",
	          		"BCSerialNo","LineContractNo","CustomerID",
	          		"LineSum1*getERate(Currency,'01',ERateDate)","LineSum2","LineSum3",
	          		"Currency","LineEffDate","LineEffFlag","PutOutDeadLine",
	          		"MaturityDeadLine","Rotative","ApprovalPolicy","FreezeFlag",
	          		"RecentCheck","RecentCheckStatus","CheckResult",
	          		"OverflowType","BeginDate","EndDate","ParentLineID",
	          		"UseOrgID","BailRatio","BusinessType","TermMonth","MemberID","MemberName"
	          		};

	        StringBuffer sbSelect = new StringBuffer("");
	        sbSelect.append("select ");
	        for(int i=0;i<sAttKeys.length;i++) sbSelect.append(sAttKeys[i]+",");
	        sbSelect.deleteCharAt(sbSelect.length()-1);
	        sbSelect.append(" from CL_INFO where LineID = '" + this.lineID + "' ");
	        
	        String sSql = sbSelect.toString();
	        
	        String[][] sAttValueMatrix = Sqlca.getStringMatrix(sSql);
	        if(sAttValueMatrix.length!=1) throw new ASException("û���ҵ����<"+this.lineID+">");
	        String[] sAttValues = sAttValueMatrix[0];
	        this.CLpool = StringFunction.convertStringArray2ValuePool(sAttKeys,sAttValues);
	    }
	 
	 
	 public void initSubCL() throws Exception {
	     
	        //��ʼ��Attributes
	        String[] sAttKeys = {
	                "LineID","CLTypeID","ApplySerialNo","ApproveSerialNo",
	          		"BCSerialNo","LineContractNo","CustomerID",
	          		"LineSum1*getERate(Currency,'01',ERateDate)","LineSum2","LineSum3",
	          		"Currency","LineEffDate","LineEffFlag","PutOutDeadLine",
	          		"MaturityDeadLine","Rotative","ApprovalPolicy","FreezeFlag",
	          		"RecentCheck","RecentCheckStatus","CheckResult",
	          		"OverflowType","BeginDate","EndDate","ParentLineID",
	          		"UseOrgID","BailRatio","BusinessType","getBusinessName(BusinessType)","TermMonth","MemberID","MemberName"
	          		};

	        StringBuffer sbSelect = new StringBuffer("");
	        sbSelect.append("select ");
	        for(int i=0;i<sAttKeys.length;i++) sbSelect.append(sAttKeys[i]+",");
	        sbSelect.deleteCharAt(sbSelect.length()-1);
	        sbSelect.append(" from CL_INFO where ParentLineID = '" + this.lineID + "' ");
	        
	        String sSql = sbSelect.toString();
	        
	        String[][] sAttValueMatrix = Sqlca.getStringMatrix(sSql);
	        if(sAttValueMatrix.length != 0) 
	        {
	        	for(int i =0;i<sAttValueMatrix.length;i++)
	        	{
	        		String[] sAttValues = sAttValueMatrix[i];
	 		        this.oCLline = StringFunction.convertStringArray2ValuePool(sAttKeys,sAttValues);
	 		        //���������ù�ͬ���Գ�ԱΪ���䵥λ
	 		        if(this.Style.equals("AssureAgreement") || this.Style.equals("CommunityAgreement") )
	 		        {
	 		        	this.Memberpool.setAttribute((String) this.oCLline.getAttribute("MemberID"),this.oCLline);
	 		        }
	 		        if(this.Style.equals("CreditAggreement"))
	 		        {
	 		        	this.Subpool.setAttribute((String) this.oCLline.getAttribute("BusinessType"),this.oCLline);
	 		        }
	        	}
	        } 
	    }
	 
	public ASValuePool getCLpool() {
		return this.CLpool;
	}

	public ASValuePool getSubpool() {
		return this.Subpool;
	}
	
	public ASValuePool getMemberpool() {
		return this.Memberpool;
	}

}
