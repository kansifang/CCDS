package com.amarsoft.app.lending.bizlets;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.DBFunction;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;


public class CopyApplyFlow extends Bizlet 
{

 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//��������
		String sObjectType = (String)this.getAttribute("ObjectType");
		//������
		String sObjectNo = (String)this.getAttribute("ObjectNo");
		
		
		String sSql = "",sNewObjectNo = "";
		ASResultSet rs = null;   
		//��ѯCL_INFO�и�LinIDΪ�յ���ҵ�����LineID����Ϊ���Ƶ���ʼ�㣬Ȼ���������LineID�����Ƴ��� ---jgao
		sSql = "select LineID from CL_INFO where ApplySerialNo='"+sObjectNo+"' and (ParentLineID IS NULL or ParentLineID = '' or ParentLineID = ' ')";
	    rs = Sqlca.getASResultSet(sSql);
		String sLineID="";
		while(rs.next())
		{
			sLineID = rs.getString("LineID");
		}
		rs.getStatement().close();
		//����������Ϣ
		sNewObjectNo = DBFunction.getSerialNo("BUSINESS_APPLY","SerialNo",Sqlca);
		sSql = "insert into BUSINESS_APPLY (serialno,relativeserialno,occurdate,customerid,customername,businesstype,businesssubtype,occurtype,fundsource,operatetype,currenylist,currencymode,businesstypelist,calculatemode,useorglist,cycleflag,flowreduceflag,contractflag,subcontractflag,selfuseflag,creditaggreement,relativeagreement,loanflag,totalsum,ourrole,reversibility,billnum,housetype,lctermtype,riskattribute,suretype,safeguardtype,businesscurrency,businesssum,businessprop,termyear,termmonth,termday,lgterm,baseratetype,baserate,ratefloattype,ratefloat,businessrate,ictype,iccyc,pdgratio,pdgsum,pdgpaymethod,pdgpayperiod,promisesfeeratio,promisesfeesum,promisesfeeperiod,promisesfeebegin,mfeeratio,mfeesum,mfeepaymethod,agentfee,dealfee,totalcast,discountinterest,purchaserinterest,bargainorinterest,discountsum,bailratio,bailcurrency,bailsum,bailaccount,fineratetype,finerate,drawingtype,firstdrawingdate,drawingperiod,paytimes,paycyc,graceperiod,overdraftperiod,oldlcno,oldlctermtype,oldlccurrency,oldlcsum,oldlcloadingdate,oldlcvaliddate,direction,purpose,planallocation,immediacypaysource,paysource,corpuspaymethod,interestpaymethod,thirdparty1,thirdpartyid1,thirdparty2,thirdpartyid2,thirdparty3,thirdpartyid3,thirdpartyregion,thirdpartyaccounts,cargoinfo,projectname,operationinfo,contextinfo,securitiestype,securitiesregion,constructionarea,usearea,flag1,flag2,flag3,tradecontractno,invoiceno,tradecurrency,tradesum,paymentdate,operationmode,vouchclass,vouchtype,vouchtype1,vouchtype2,vouchflag,warrantor,warrantorid,othercondition,guarantyvalue,guarantyrate,baseevaluateresult,riskrate,lowrisk,otherarealoan,lowriskbailsum,originalputoutdate,extendtimes,lngotimes,golntimes,drtimes,baseclassifyresult,applytype,bailrate,finishorg,operateorgid,operateuserid,operatedate,inputorgid,inputuserid,inputdate,updatedate,pigeonholedate,remark,flag4,paycurrency,paydate,describe1,describe2,classifyresult,classifydate,classifyfrequency,vouchnewflag,adjustratetype,adjustrateterm,rateadjustcyc,fzanbalance,acceptinttype,fixcyc,thirdpartyadd1,thirdpartyzip1,thirdpartyadd2,thirdpartyzip2,thirdpartyadd3,thirdpartyzip3,effectarea,termdate1,termdate2,termdate3,ratio,tempsaveflag)" +
				" select '"+sNewObjectNo+"',relativeserialno,occurdate,customerid,customername,businesstype,businesssubtype,occurtype,fundsource,operatetype,currenylist,currencymode,businesstypelist,calculatemode,useorglist,cycleflag,flowreduceflag,contractflag,subcontractflag,selfuseflag,creditaggreement,relativeagreement,loanflag,totalsum,ourrole,reversibility,billnum,housetype,lctermtype,riskattribute,suretype,safeguardtype,businesscurrency,businesssum,businessprop,termyear,termmonth,termday,lgterm,baseratetype,baserate,ratefloattype,ratefloat,businessrate,ictype,iccyc,pdgratio,pdgsum,pdgpaymethod,pdgpayperiod,promisesfeeratio,promisesfeesum,promisesfeeperiod,promisesfeebegin,mfeeratio,mfeesum,mfeepaymethod,agentfee,dealfee,totalcast,discountinterest,purchaserinterest,bargainorinterest,discountsum,bailratio,bailcurrency,bailsum,bailaccount,fineratetype,finerate,drawingtype,firstdrawingdate,drawingperiod,paytimes,paycyc,graceperiod,overdraftperiod,oldlcno,oldlctermtype,oldlccurrency,oldlcsum,oldlcloadingdate,oldlcvaliddate,direction,purpose,planallocation,immediacypaysource,paysource,corpuspaymethod,interestpaymethod,thirdparty1,thirdpartyid1,thirdparty2,thirdpartyid2,thirdparty3,thirdpartyid3,thirdpartyregion,thirdpartyaccounts,cargoinfo,projectname,operationinfo,contextinfo,securitiestype,securitiesregion,constructionarea,usearea,flag1,flag2,flag3,tradecontractno,invoiceno,tradecurrency,tradesum,paymentdate,operationmode,vouchclass,vouchtype,vouchtype1,vouchtype2,vouchflag,warrantor,warrantorid,othercondition,guarantyvalue,guarantyrate,baseevaluateresult,riskrate,lowrisk,otherarealoan,lowriskbailsum,originalputoutdate,extendtimes,lngotimes,golntimes,drtimes,baseclassifyresult,applytype,bailrate,finishorg,operateorgid,operateuserid,operatedate,inputorgid,inputuserid,inputdate,updatedate,pigeonholedate,remark,flag4,paycurrency,paydate,describe1,describe2,classifyresult,classifydate,classifyfrequency,vouchnewflag,adjustratetype,adjustrateterm,rateadjustcyc,fzanbalance,acceptinttype,fixcyc,thirdpartyadd1,thirdpartyzip1,thirdpartyadd2,thirdpartyzip2,thirdpartyadd3,thirdpartyzip3,effectarea,termdate1,termdate2,termdate3,ratio,tempsaveflag" +
				" from BUSINESS_APPLY where SerialNo='"+sObjectNo+"'";
		Sqlca.executeSQL(sSql);
		
		//��CL_INFO���в���������ݣ�ʵ�ָ���,�Ӹ�LineID�����һ����LineID ---by jgao
		if(sObjectType.equals("CreditApply"))
		{			
		    String sNewLineID1 = DBFunction.getSerialNo("CL_INFO","LineID",Sqlca);
		    sSql = "insert into CL_INFO (LineID,ApplySerialNo,ParentLineID,CustomerID,CustomerName,BusinessType,Rotative,BailRatio,LineSum1,LineSum2,InputOrg,InputUser,InputTime,UpdateTime,CLTypeID,CLTypeName,ApproveSerialNo,BCSerialNo)" +
		           " select '"+sNewLineID1+"','"+sNewObjectNo+"',ParentLineID,CustomerID,CustomerName,BusinessType,Rotative,BailRatio,LineSum1,LineSum2,InputOrg,InputUser,InputTime,UpdateTime,CLTypeID,CLTypeName,ApproveSerialNo,BCSerialNo" + 
		           " from CL_INFO where LineID='"+sLineID+"'";
		    Sqlca.executeSQL(sSql);
		    sSql = "select LineID from CL_INFO where ParentLineID='"+sLineID+"'";
		    rs=Sqlca.getASResultSet(sSql);
		    while(rs.next())
		    {		    	
			    String sNewLineID = DBFunction.getSerialNo("CL_INFO","LineID",Sqlca);
			    sSql = "insert into CL_INFO (LineID,ApplySerialNo,ParentLineID,CustomerID,CustomerName,BusinessType,Rotative,  BailRatio,LineSum1,LineSum2,InputOrg,InputUser,InputTime,UpdateTime,CLTypeID,CLTypeName,ApproveSerialNo,BCSerialNo)" +
			  		   " select '"+sNewLineID+"','"+sNewObjectNo+"','"+sNewLineID1+"',CustomerID,CustomerName,BusinessType,Rotative,BailRatio,LineSum1,LineSum2, InputOrg,InputUser,InputTime,  UpdateTime,CLTypeID,CLTypeName,ApproveSerialNo,BCSerialNo" + 
			  		   " from CL_INFO where LineID='"+rs.getString("LineID")+"'";
		        Sqlca.executeSQL(sSql);
		    }
		    rs.getStatement().close();
		}

	    
		//��ó�ʼ�������Ϣ
		String sApplyType = "",sFlowNo = "",sUserID = "",sOrgID = "",sPhaseNo = "";
		sSql = "select ObjectType,ObjectNo,ApplyType,UserID,OrgID,FlowNo,PhaseNo from FLOW_OBJECT where ObjectNo='"+sObjectNo+"' and ObjectType='"+sObjectType+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sApplyType = rs.getString("ApplyType");
			sUserID = rs.getString("UserID");
			sOrgID = rs.getString("OrgID");
			sFlowNo = rs.getString("FlowNo");
			sPhaseNo = rs.getString("PhaseNo");
		}
		rs.getStatement().close();
		
		//��ʼ��������Ϣ
		Bizlet bzInitFlow = new InitializeFlow();
		bzInitFlow.setAttribute("ObjectType",sObjectType); 
		bzInitFlow.setAttribute("ObjectNo",sNewObjectNo); 
		bzInitFlow.setAttribute("ApplyType",sApplyType); 
		bzInitFlow.setAttribute("UserID",sUserID); 
		bzInitFlow.setAttribute("OrgID",sOrgID); 
		bzInitFlow.setAttribute("FlowNo",sFlowNo); 
		bzInitFlow.setAttribute("PhaseNo",sPhaseNo); 
		bzInitFlow.run(Sqlca);
		
	    return sNewObjectNo;
	    
	 }

}
