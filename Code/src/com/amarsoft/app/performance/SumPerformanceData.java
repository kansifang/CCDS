/**
		Author: --fhuang 2006-12-30
		Tester:
		Describe: --产生Approve_Performance表的数据
				  --汇总Approve_Performance_D中的数据，并将其情况统计入Approve_Performance_D表
				  --每天日终跑一次
		Input Param:
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.performance;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.bizlet.Bizlet;
public class SumPerformanceData  extends Bizlet{
	public Object run(Transaction Sqlca) throws Exception{
		String sSTATISTICDATE = (String)this.getAttribute("STATISTICDATE");//统计日期 
		//统计日期为运行批量的时间,或者为此时间的前一天,根据情况设定
		if(sSTATISTICDATE ==null)
			sSTATISTICDATE = StringFunction.getToday();
		//定义变量
		String sUserID = "";//审批人员
		String sOrgID = "";//审批机构
		String sFlowNo = "";//流程编号
		String sPhaseNo = "";//所处阶段
		
		String sSql = "";
		ASResultSet rs = null;
		int iCount = 0;
		sSql = "select count(*) from Approve_Performance_D where STATISTICDATE='"+sSTATISTICDATE+"'";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			iCount = rs.getInt(1);
		}
		rs.getStatement().close();
		if(iCount==0)
			throw new Exception("Approve_Performance_D中没有统计日期的数据，请检查");
		else
		{
			//先清除当前数据
			clearRecord(Sqlca,sSTATISTICDATE);
			//先按UserID,OrgID,FlowNo,PhaseNo分组来统计
			sSql = " select UserID,OrgID,FlowNo,PhaseNo,Count(*) from Approve_Performance_D "+
			       " where STATISTICDATE='"+sSTATISTICDATE+"' group by UserID,OrgID,FlowNo,PhaseNo ";
			rs = Sqlca.getASResultSet(sSql);
			//System.out.println(sSql);
			while(rs.next())
			{
				sUserID = rs.getString("UserID");//审批人员
				sOrgID = rs.getString("OrgID");//审批机构
				sFlowNo = rs.getString("FlowNo");//流程编号
				sPhaseNo = rs.getString("PhaseNo");//流程编号
				
				String sSql1 = "";
				sSql1 = "Insert into Approve_Performance ("+
						"STATISTICDATE,"+
						"ORGID,"+
						"USERID,"+
						"FLOWNO,"+
						"PHASENO,"+
						"CURRDEALCOUNT,"+
						"CURRDEALSUM,"+
						"MAGGREECOUNT,"+
						"MDISAGREECOUNT,"+
						"MAFLOATCOUNT,"+
						"MAGGREETIME,"+
						"MDISAGREETIME,"+
						"MAFLOATTIME,"+
						"MNAPPROVECOUNT,"+
						"MNAPPROVESUM,"+
						"MNCONTRACTCOUNT,"+
						"MNCONTRACTSUM,"+
						"MNPUTOUTCOUNT,"+
						"MNPUTOUTSUM,"+
						"MNORMALSUM,"+
						"MATTENTIONSUM,"+
						"MSECONDARYSUM,"+
						"MSHADINESSSUM,"+
						"MLOSSSUM,"+
						"MAPPLYSUM,"+
						"YAGGREECOUNT,"+
						"YDISAGREECOUNT,"+
						"YAFLOATCOUNT,"+
						"YAGGREETIME,"+
						"YDISAGREETIME,"+
						"YAFLOATTIME,"+
						"YNAPPROVECOUNT,"+
						"YNAPPROVESUM,"+
						"YNCONTRACTCOUNT,"+
						"YNCONTRACTSUM,"+
						"YNPUTOUTCOUNT,"+
						"YNPUTOUTSUM,"+
						"YNORMALSUM,"+
						"YATTENTIONSUM,"+
						"YSECONDARYSUM,"+
						"YSHADINESSSUM,"+
						"YLOSSSUM,"+
						"YAPPLYSUM,"+
						"CAGGREECOUNT,"+
						"CDISAGREECOUNT,"+
						"CAFLOATCOUNT,"+
						"CAGGREETIME,"+
						"CDISAGREETIME,"+
						"CAFLOATTIME,"+
						"CNAPPROVECOUNT,"+
						"CNAPPROVESUM,"+
						"CNCONTRACTCOUNT,"+
						"CNCONTRACTSUM,"+
						"CNPUTOUTCOUNT,"+
						"CNPUTOUTSUM,"+
						"CNORMALSUM,"+
						"CATTENTIONSUM,"+
						"CSECONDARYSUM,"+
						"CSHADINESSSUM,"+
						"CLOSSSUM,"+
						"CAPPLYSUM ) "+
						"select "+
						"STATISTICDATE,"+
						"ORGID,"+
						"USERID,"+
						"FLOWNO,"+
						"PHASENO,"+
						"sum(CURRDEALCOUNT),"+
						"sum(CURRDEALSUM),"+
						"sum(MAGGREECOUNT),"+
						"sum(MDISAGREECOUNT),"+
						"sum(MAFLOATCOUNT),"+
						"sum(MAGGREETIME),"+
						"sum(MDISAGREETIME),"+
						"sum(MAFLOATTIME),"+
						"sum(MNAPPROVECOUNT),"+
						"sum(MNAPPROVESUM),"+
						"sum(MNCONTRACTCOUNT),"+
						"sum(MNCONTRACTSUM),"+
						"sum(MNPUTOUTCOUNT),"+
						"sum(MNPUTOUTSUM),"+
						"sum(MNORMALSUM),"+
						"sum(MATTENTIONSUM),"+
						"sum(MSECONDARYSUM),"+
						"sum(MSHADINESSSUM),"+
						"sum(MLOSSSUM),"+
						"sum(MAPPLYSUM),"+
						"sum(YAGGREECOUNT),"+
						"sum(YDISAGREECOUNT),"+
						"sum(YAFLOATCOUNT),"+
						"sum(YAGGREETIME),"+
						"sum(YDISAGREETIME),"+
						"sum(YAFLOATTIME),"+
						"sum(YNAPPROVECOUNT),"+
						"sum(YNAPPROVESUM),"+
						"sum(YNCONTRACTCOUNT),"+
						"sum(YNCONTRACTSUM),"+
						"sum(YNPUTOUTCOUNT),"+
						"sum(YNPUTOUTSUM),"+
						"sum(YNORMALSUM),"+
						"sum(YATTENTIONSUM),"+
						"sum(YSECONDARYSUM),"+
						"sum(YSHADINESSSUM),"+
						"sum(YLOSSSUM),"+
						"sum(YAPPLYSUM),"+
						"sum(CAGGREECOUNT),"+
						"sum(CDISAGREECOUNT),"+
						"sum(CAFLOATCOUNT),"+
						"sum(CAGGREETIME),"+
						"sum(CDISAGREETIME),"+
						"sum(CAFLOATTIME),"+
						"sum(CNAPPROVECOUNT),"+
						"sum(CNAPPROVESUM),"+
						"sum(CNCONTRACTCOUNT),"+
						"sum(CNCONTRACTSUM),"+
						"sum(CNPUTOUTCOUNT),"+
						"sum(CNPUTOUTSUM),"+
						"sum(CNORMALSUM),"+
						"sum(CATTENTIONSUM),"+
						"sum(CSECONDARYSUM),"+
						"sum(CSHADINESSSUM),"+
						"sum(CLOSSSUM),"+
						"sum(CAPPLYSUM) "+
						"from Approve_Performance_D "+
						"where STATISTICDATE='" +sSTATISTICDATE+"' "+
						"and UserID='"+sUserID+"' "+
						"and OrgID='"+sOrgID+"' "+
						"and FlowNo='"+sFlowNo+"' "+
						"and PhaseNo='"+sPhaseNo+"' "+
						"group by "+
				        "STATISTICDATE,"+
				        "ORGID,"+
				        "USERID,"+
				        "FLOWNO,"+
				        "PHASENO";
				//System.out.println(sSql1);
				Sqlca.executeSQL(sSql1);
				System.out.println("汇总了数据"+",流程编号为"+sFlowNo+",所处阶段为"+sPhaseNo+",审批机构为"+sOrgID+",审批人员为"+sUserID);		
			}
			rs.getStatement().close();
			System.out.println("汇总了数据完毕");
		}
		return "Finish";
	}
	//清除表中所有的记录
	 private void clearRecord(Transaction Sqlca,String sSTATISTICDATE) throws Exception
	 {
		 String sSql = "";
		 sSql = " delete from Approve_Performance where STATISTICDATE='"+sSTATISTICDATE+"'";
		 //执行更新语句
		 Sqlca.executeSQL(sSql);	 
	 }
}
