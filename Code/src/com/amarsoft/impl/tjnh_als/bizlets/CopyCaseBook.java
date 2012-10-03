package com.amarsoft.impl.tjnh_als.bizlets;

import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;

public class CopyCaseBook extends Bizlet {


	public Object run(Transaction Sqlca) throws Exception {
		//Á÷Ë®ºÅ
		String sSerialNo = (String)this.getAttribute("SerialNo");
		String sSql = "";
		String sNewSerialNo = "";
		
		sNewSerialNo = DBFunction.getSerialNo("LAWCASE_BOOK","SerialNo",Sqlca);
		sSql = " insert into LAWCASE_BOOK(objecttype,objectno,serialno,booktype,bankruptcyorgid,bankruptcyorgname,review,reviewstyle,reviewcase,retrialphase,retrialtype,applicant,appdate,applyrequest,applysum,applyprincipal,applyininterest,applyoutinterest,applyothersum,applyaimedthings,demurralornot,demurralreason,requisitionbrief,evidencecatalog,received,refusedreason,acceptedno,accepteddate,courtno,acceptedcourt,jointcourt,witnessbrief,changesuitornot,changesuitreason,cchargeornot,cchargereason,agenttype,agentrate,agentno,agentdate,agentapproveno,agentapprovedate,cognizanceresult,intoeffectornot,judgementno,judgeddate,judgementdate,intoeffectdate,judgementbrief,performedstatus,compromisedate,firstrepaydate,compromisebrief,currency,callbacksum,actualsum,actualprincipal,actualininterest,actualoutinterest,actualothersum,materialsevalvalue,bankruptcyrate,withdrawname,withdrawreason,withdrawdate,applyno,applydate,approveno,approvedate,distributeproject,distributescale,meansamount,cash,practicality,currentagent,bankruptcydate,judgesum,confirmpi,picurrency,confirmfee,lawyerfee,otherfee,judgepaysum,judgenopaysum,operateuserid,operateorgid,inputuserid,inputorgid,inputdate,updatedate,remark)"+
		       " select objecttype,objectno,'"+sNewSerialNo+"',booktype,bankruptcyorgid,bankruptcyorgname,review,reviewstyle,reviewcase,retrialphase,retrialtype,applicant,appdate,applyrequest,applysum,applyprincipal,applyininterest,applyoutinterest,applyothersum,applyaimedthings,demurralornot,demurralreason,requisitionbrief,evidencecatalog,received,refusedreason,acceptedno,accepteddate,courtno,acceptedcourt,jointcourt,witnessbrief,changesuitornot,changesuitreason,cchargeornot,cchargereason,agenttype,agentrate,agentno,agentdate,agentapproveno,agentapprovedate,cognizanceresult,intoeffectornot,judgementno,judgeddate,judgementdate,intoeffectdate,judgementbrief,performedstatus,compromisedate,firstrepaydate,compromisebrief,currency,callbacksum,actualsum,actualprincipal,actualininterest,actualoutinterest,actualothersum,materialsevalvalue,bankruptcyrate,withdrawname,withdrawreason,withdrawdate,applyno,applydate,approveno,approvedate,distributeproject,distributescale,meansamount,cash,practicality,currentagent,bankruptcydate,judgesum,confirmpi,picurrency,confirmfee,lawyerfee,otherfee,judgepaysum,judgenopaysum,operateuserid,operateorgid,inputuserid,inputorgid,inputdate,updatedate,remark "+
		       " from LAWCASE_BOOK where SerialNo = '"+sSerialNo+"'";
		Sqlca.executeSQL(sSql);
		return sNewSerialNo;
	}

}
