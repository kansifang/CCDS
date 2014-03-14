package com.lmt.baseapp.flow;
/**
 * 流程完成后后续动作  bzhang 2009.06.15
 */
import com.lmt.app.cms.javainvoke.Bizlet;
import com.lmt.baseapp.util.DataConvert;
import com.lmt.baseapp.util.DateUtils;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class FinishFlow extends Bizlet{

	public Object run(Transaction Sqlca) throws Exception {
		String sObjectNo = DataConvert.toString((String)this.getAttribute("sObjectNo"));
		String sObjectType = DataConvert.toString((String)this.getAttribute("sObjectType"));  
		String sSql = "",sFOSerialNo="",sPhase = "",sBDSerialNo = "";
		double dBalance = 0.00;
		ASResultSet rs = null;
		//将空值转化为空字符串
		//查询认定完成后，最终认定人的审批流程任务编号
		sSql = 	" select MAX(OpinionNo) as OpinionNo from Flow_Opinion"+
				" where ObjectType='"+sObjectType+"'"+
				" and ObjectNo='"+sObjectNo+"'";
		rs= Sqlca.getASResultSet(sSql);
		if(rs.next()){	
			DataConvert.toString(sFOSerialNo=rs.getString("OpinionNo"));
		}
		rs.getStatement().close();
		
		if("ApplyCaseDistOT1".equals(sObjectType)){
			Sqlca.executeSQL("Update Batch_Case set"+
							" ClassifyResult = '"+sPhase+"',"+
							" UpdateDate='"+DateUtils.getToday()+"'"+
							" where SerialNo = '"+sObjectNo+"'");
		}else if(1!=1){
			sSql = " Select BD.Balance,FO.PhaseOpinion2,BD.SerialNo"+
					" from Flow_Opinion FO,Classify_Record CR,Business_Duebill BD "+
				    " where FO.ObjectNo = CR.SerialNo"+
					" and CR.ObjectNo = BD.serialNo"+
				    " and FO.ObjectType = '"+sObjectType+"' "+
				    " and FO.OpinionNo = '"+sFOSerialNo+"'";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next()){	
				dBalance      = rs.getDouble(1);
				sPhase        = rs.getString(2);
				sBDSerialNo   = rs.getString(3);
			}
			rs.getStatement().close();
			
			if(sPhase.startsWith("01"))
			{
				sSql=" UPDATE Classify_Record SET Finallyresult='"+sPhase+"',sum1 = "+dBalance+
				     " WHERE SerialNo='"+sObjectNo+"' AND ObjectType='"+sObjectType+"'";
			}else if(sPhase.startsWith("02"))
			{
				sSql=" UPDATE Classify_Record SET Finallyresult='"+sPhase+"',sum2 = "+dBalance+
			     " WHERE SerialNo='"+sObjectNo+"' AND ObjectType='"+sObjectType+"'";
			}else if(sPhase.startsWith("03"))
			{
				sSql=" UPDATE Classify_Record SET Finallyresult='"+sPhase+"',sum3 = "+dBalance+
			     " WHERE SerialNo='"+sObjectNo+"' AND ObjectType='"+sObjectType+"'";
			}else if(sPhase.startsWith("04"))
			{
				sSql=" UPDATE Classify_Record SET Finallyresult='"+sPhase+"',sum4 = "+dBalance+
			     " WHERE SerialNo='"+sObjectNo+"' AND ObjectType='"+sObjectType+"'";
			}else if(sPhase.startsWith("05"))
			{
				sSql=" UPDATE Classify_Record SET Finallyresult='"+sPhase+"',sum5 = "+dBalance+
			     " WHERE SerialNo='"+sObjectNo+"' AND ObjectType='"+sObjectType+"'";
			}
			Sqlca.executeSQL(sSql);
			Sqlca.executeSQL2("Update Business_Duebill set ClassifyResult = '"+sPhase+"',UpdateDate='"+DateUtils.getToday()+"' where SerialNo = '"+sBDSerialNo+"'");
		}
		return "";
	}

}
