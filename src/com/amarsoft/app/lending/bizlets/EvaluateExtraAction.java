package com.amarsoft.app.lending.bizlets;

/*
 Author: --zywei 2006-01-17
 Tester:
 Describe: --新增机构时，同时在ORG_BELONG新增相应的机构间的层次关系
 --目前用于页面：OrgInfo
 Input Param:
 OrgID: 机构编号
 RelativeOrgID: 上级机构编号
 Output Param:

 HistoryLog:
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.biz.evaluate.Evaluate;

public class EvaluateExtraAction {
	private Transaction Sqlca;
	private String sSql="";
	private ASResultSet rs;
	
	private String [][]CreditLevel={{"9","AAA"},{"8","AA"},{"7","A"},
									{"6","BBB"},{"5","BB"},{"4","B"},
									{"3","CCC"},{"2","CC"},{"1","C"}};
	private  Evaluate eEvaluate=null;
	
	private boolean hasEvaluateAdjust=false;
	private String BeforeAdjustResult="";
	
	private String PJTZItemNo="";
	private String PJTZValue="";
	private String[] QZTZItemNo=null;
	private String[] QZTZCodeNo=null;
	public EvaluateExtraAction(Evaluate eEvaluate) throws Exception{
		this.eEvaluate = eEvaluate;
		this.Sqlca=eEvaluate.Sqlca;
		init();
	}
	public void init()throws Exception{
		//1、获取评级调整前的评级
		sSql = " select EvaluateFirstResult from  EVALUATE_RECORD"+
				" where ObjectType='" +this.eEvaluate.ObjectType+"'"+
				" and ObjectNo='" +this.eEvaluate.ObjectNo+"'"+
				" and SerialNo='"+this.eEvaluate.SerialNo+"'";
		this.BeforeAdjustResult =DataConvert.toString(Sqlca.getString(sSql));
		if(this.BeforeAdjustResult.length()>0){
			this.hasEvaluateAdjust=true;
		}
		//2、020、获取评级调整项号及评级调整值， 根据评级调整项对最终结果进行调整
		sSql = "select RelativeCode from Code_Library " +
				" where CodeNo='OperateModelNos' " +
				"	and ItemNo like '020%'"+
				"	and IsInUse='1' "+
				"	and locate('"+this.eEvaluate.ModelNo+"',RelativeCode)>0";
		rs=Sqlca.getASResultSet(sSql);
		if(rs.next()){
			String sTemp=DataConvert.toString(rs.getString(1));
			String[] aArray=sTemp.split(":");
			if(aArray.length>2){
				this.PJTZItemNo=aArray[1];
				this.PJTZValue=aArray[2];
			}
		}
		rs.getStatement().close();
		//3、 030 权重系数调整(一个调整依据一条配置，可以有多个调整依据)
		int iCount=0;
		sSql = "select RelativeCode from Code_Library " +
				" where CodeNo='OperateModelNos' " +
				"	and ItemNo like '030%' "+
				"	and IsInUse='1' "+
				"	and locate('"+this.eEvaluate.ModelNo+"',RelativeCode)>0";
		rs=Sqlca.getASResultSet(sSql);
		this.QZTZItemNo =new String[rs.getRowCount()];
		this.QZTZCodeNo =new String[rs.getRowCount()];
		while(rs.next()){
			String sTemp=DataConvert.toString(rs.getString(1));
			String[] aArray=sTemp.split(":");
			if(aArray.length>2){
				this.QZTZItemNo[iCount]=aArray[1];//模板中调整依据号
				this.QZTZCodeNo[iCount]=aArray[2];
			}
		}
		rs.getStatement().close();
	}
	public String adjustResult(String BeforeAdjustResult) throws Exception{
		this.BeforeAdjustResult=BeforeAdjustResult;
		String sReturn="";
		String AdjustValue="";
		if(this.PJTZItemNo.length()>0&&this.PJTZValue.length()>0){
			sSql="select ItemValue from EVALUATE_DATA " +
					" where ObjectType='"+this.eEvaluate.ObjectType+"'" +
					" and ObjectNo='"+this.eEvaluate.ObjectNo+"'" +
					" and SerialNo='"+this.eEvaluate.SerialNo+"'" +
					" and ItemNo like '"+this.PJTZItemNo+"%'";
			rs =Sqlca.getASResultSet(sSql);
			while(rs.next()){
				String sItemValue=DataConvert.toString(rs.getString(1));
				if(sItemValue.length()>0&&this.PJTZValue.contains(sItemValue)){
					AdjustValue+=sItemValue+"@";
				}
			}
			rs.getStatement().close();
		}
		if(AdjustValue.length()>0){
			this.hasEvaluateAdjust=true;
			int index=0;
			String sAdjustEvaResult="";
			if(AdjustValue.contains("2")){
				index=Integer.valueOf(StringFunction.getAttribute(CreditLevel,BeforeAdjustResult,1,0))-2;
			}else if(AdjustValue.contains("1")){
				index=Integer.valueOf(StringFunction.getAttribute(CreditLevel,BeforeAdjustResult,1,0))-1;
			}
			index=index<=0?1:index;
			sAdjustEvaResult =StringFunction.getAttribute(CreditLevel,String.valueOf(index),0,1);
			if(AdjustValue.contains("D")){
				sAdjustEvaResult="D";
			}
			Sqlca.executeSQL(" Update EVALUATE_RECORD Set" +
								" EvaluateFirstResult='"+BeforeAdjustResult+"',"+
								" EvaluateResult='"+sAdjustEvaResult+"'"+
					       		" where ObjectType='"+this.eEvaluate.ObjectType+"'"+
					       		" and ObjectNo='"+this.eEvaluate.ObjectNo+"'"+
					       		" and SerialNo='"+this.eEvaluate.SerialNo+"'");
			this.eEvaluate.getRecord();
			this.eEvaluate.getData(); 
			sReturn =sAdjustEvaResult;
		}else{
			sReturn =BeforeAdjustResult;
		}
		return sReturn;
	}
	public void updateCoefficient() throws Exception{
		//评级模型每一块内的权重*块的权重
		//boolean isAutoC=Sqlca.conn.getAutoCommit();
		//Sqlca.conn.setAutoCommit(false);
		//获取块的权重
		for(int i=0;i<this.QZTZItemNo.length;i++){
			sSql="select ItemValue from EVALUATE_DATA " +
					" where ObjectType='"+this.eEvaluate.ObjectType+"'" +
					" and ObjectNo='"+this.eEvaluate.ObjectNo+"'" +
					" and SerialNo='"+this.eEvaluate.SerialNo+"'" +
					" and ItemNo='"+this.QZTZItemNo[i]+"'";//权重调整依据号
			rs =Sqlca.getASResultSet(sSql);
			if(rs.next()){
				String sItemValue=DataConvert.toString(rs.getString(1));
				if(sItemValue.length()>0){
					if(this.QZTZCodeNo[i]!=null&&this.QZTZCodeNo[i].contains("@")){//形式为：@211@非银行类打分卡:1.2.3:=Double(0.0)@%@1.1
						String []aItemValueWAndCo=this.QZTZCodeNo[i].split("@");
						String sss= sSql+" and Double(ItemValue) "+aItemValueWAndCo[0];
						ASResultSet rs0=Sqlca.getASResultSet(sss);
						String sSql2="";
						if(rs0.next()){
							sSql2="update Evaluate_Model" +
										" set Coefficient=CoefficientBackup*"+aItemValueWAndCo[2]+
										" where ModelNo='"+this.eEvaluate.ModelNo+"'" +
										" and ItemNo like '"+aItemValueWAndCo[1]+"'"+
										" and length(Coefficient)>0";
							Sqlca.executeSQL(sSql2);
						}else{
							sSql2="update Evaluate_Model" +
										" set Coefficient=CoefficientBackup"+
										" where ModelNo='"+this.eEvaluate.ModelNo+"'" +
										" and ItemNo like '"+aItemValueWAndCo[1]+"'"+
										" and length(Coefficient)>0";
							Sqlca.executeSQL(sSql2);
						}
						rs0.getStatement().close();
						continue;
					}
					String sSql1="select Attribute1 from Code_Library" +
									" where CodeNo='"+this.QZTZCodeNo[i]+"'" +
									" 	and ItemNo='"+sItemValue+"'" +
									"   and IsInUse='1'";
					ASResultSet rs1=Sqlca.getASResultSet(sSql1);
					if(rs1.next()){
						String sTemp=DataConvert.toString(rs1.getString(1));
						String[] aTemp=sTemp.split(":");
						for(int j=0;j<aTemp.length;j++){
							String[]sT=aTemp[j].split("@");
							if(sT.length>1){
								String sSql2="update Evaluate_Model" +
												" set Coefficient=CoefficientBackup*"+sT[1]+
												" where ModelNo='"+this.eEvaluate.ModelNo+"'" +
												" and ItemNo like '"+sT[0]+"'"+
												" and length(Coefficient)>0";
								Sqlca.executeSQL(sSql2);
							}
						}
					}
					rs1.getStatement().close();
				}
			}
			rs.getStatement().close();
		}
		//Sqlca.conn.commit();
		//Sqlca.conn.setAutoCommit(isAutoC);
		this.eEvaluate.getRecord();
		this.eEvaluate.getData(); 
	}
	public boolean isHasEvaluateAdjust() {
		return hasEvaluateAdjust;
	}

	public void setHasEvaluateAdjust(boolean hasEvaluateAdjust) {
		this.hasEvaluateAdjust = hasEvaluateAdjust;
	}
	public String getBeforeAdjustResult() {
		return BeforeAdjustResult;
	}
	public void setBeforeAdjustResult(String beforeAdjustResult) {
		BeforeAdjustResult = beforeAdjustResult;
	}
	
}
