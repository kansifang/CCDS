package com.amarsoft.app.lending.bizlets;

/*
 Author: --bllou 2012-09-23
 Tester:
 Describe: --获取评级中的复杂取值
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.biz.bizlet.Bizlet;

public class EvaluateGetValue extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception
	{
		//获取参数：方法名、对象编号，视图ID，用户编号		
		String sMethodName = DataConvert.toString((String)this.getAttribute("MethodName"));	
		//对象流水号\客户ID
		String sObjectNo = DataConvert.toString((String)this.getAttribute("ObjectNo"));
		//财务报表月份
		String sAccountMonth = DataConvert.toString((String)this.getAttribute("AccountMonth"));//MethodName ="TJMX" ObjectType
		//财务报类型
		String sReportScope = DataConvert.toString((String)this.getAttribute("ReportScope"));//..SerialNo
		//财务报告科目号
		String sRowSubject = DataConvert.toString((String)this.getAttribute("RowSubject"));//..ModelNo
		//所取字段
		
		String sItemName = DataConvert.toString((String)this.getAttribute("ItemName"));//..ItemNo
		int FistN=0;
		String sSubItemNo="";
		//所取字段
		if("TJMX".equals(sMethodName)){
			sSubItemNo= DataConvert.toString((String)this.getAttribute("HowMuchY"));//..SubItemNo     1.1.1@1.1.2
		}else{
			FistN= DataConvert.toInt((String)this.getAttribute("HowMuchY"));
		}
		
		Double sReturn=0.0;
		if(sMethodName.equals("GSB"))
			sReturn=GuarantySumBalance(Sqlca,sObjectNo);
		else if(sMethodName.equals("MAE"))
			sReturn=MaxGuarantySumBalanceACCEnterprise(Sqlca,sObjectNo,FistN);
		else if(sMethodName.equals("MAI"))
			sReturn=MaxGuarantySumBalanceACCIndustry(Sqlca,sObjectNo);
		else if(sMethodName.equals("AS"))
			sReturn=AveForRowSubject(false,Sqlca,sObjectNo,sAccountMonth,sReportScope,sRowSubject,sItemName,FistN);
		else if(sMethodName.equals("ASTY"))
			sReturn=AveForRowSubject(true,Sqlca,sObjectNo,sAccountMonth,sReportScope,sRowSubject,sItemName,FistN);
		else if(sMethodName.equals("TJMX"))
			sReturn=TJMXFormula(Sqlca,sObjectNo,sAccountMonth,sReportScope,sRowSubject,sItemName,sSubItemNo);

		return String.valueOf(sReturn);
	}
	//担保企业融资性担保责任余额
    public Double GuarantySumBalance(Transaction Sqlca,String sObjectNo) throws Exception {
    	Double sReturn = 0.0;
    	String sSql= "SELECT sum(GC.GuarantyValue*getErate(GC.GuarantyCurrency,'01',''))" +
					" FROM Guaranty_Contract GC,Contract_Relative CR,Business_Contract BC" +
					" where GC.GuarantorID='"+sObjectNo+"'" +
					" and GC.SerialNo=CR.ObjectNo " +
					" and CR.ObjectType='GuarantyContract' " +
					" and CR.SerialNo=BC.SerialNo " +
					" and BC.Balance>0 " +
					" and BC.BusinessType like '1%'";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
        if (rs.next()) {
        	sReturn = rs.getDouble(1);
        }
        rs.getStatement().close();
        return sReturn;
    }
    //担保企业前n名被担保人提供的融资性担保责任余额
    public Double MaxGuarantySumBalanceACCEnterprise(Transaction Sqlca,String sObjectNo,int firstN) throws Exception {
    	Double sReturn = 0.0;
    	int iCount=0;
		String sSql="SELECT sum(GC.GuarantyValue*getErate(GC.GuarantyCurrency,'01',''))" +
					" FROM Guaranty_Contract GC,Contract_Relative CR,Business_Contract BC" +
					" where GC.GuarantorID='"+sObjectNo+"'" +
					" and GC.SerialNo=CR.ObjectNo " +
					" and CR.ObjectType='GuarantyContract' " +
					" and CR.SerialNo=BC.SerialNo " +
					" and BC.Balance>0 " +
					" and BC.BusinessType like '1%'" +
					" group by BC.CustomerID" +
					" order by sum(GC.GuarantyValue*getErate(GC.GuarantyCurrency,'01','')) desc";
		ASResultSet rs = Sqlca.getASResultSet(sSql);
        while(rs.next()) {
        	sReturn += rs.getDouble(1);
        	iCount++;
        	if(iCount==firstN){
        		break;
        	}
        }
        rs.getStatement().close();
        return sReturn;
    }
   // 单个行业在保责任余额最大额
    public Double MaxGuarantySumBalanceACCIndustry(Transaction Sqlca,String sObjectNo) throws Exception {
    	Double sReturn = 0.0;
    	String sSql="SELECT sum(GC.GuarantyValue*getErate(GC.GuarantyCurrency,'01',''))" +
					" FROM Guaranty_Contract GC,Contract_Relative CR,Business_Contract BC" +
					" where GC.GuarantorID='"+sObjectNo+"'" +
					" and GC.SerialNo=CR.ObjectNo " +
					" and CR.ObjectType='GuarantyContract' " +
					" and CR.SerialNo=BC.SerialNo " +
					" and BC.Balance>0 " +
					" and BC.BusinessType like '1%'" +
					" group by BC.Direction" +
					" order by sum(GC.GuarantyValue*getErate(GC.GuarantyCurrency,'01','')) desc";
		ASResultSet rs= Sqlca.getASResultSet(sSql);
        if (rs.next()) {
        	sReturn = rs.getDouble(1);
        }
        rs.getStatement().close();
        return sReturn;
    }
    /**
     * 
     * @param Sqlca
     * @param sObjectNo
     * @param sAccountMonth
     * @param sReportScope
     * @param sRowSubject
     * @param sItemName
     * @param firstN 为正数 表示平均，为负数，-1上一年(上一期)，-2为前一年（上两期）等等
     * @return
     * @throws Exception
     */
    public Double AveForRowSubject(boolean isTY,Transaction Sqlca,String sObjectNo,String sAccountMonth,String sReportScope,String sRowSubject,String sItemName,int firstN) throws Exception {
		double dCurOrYearValue = 0.0;
		//计数标识
		//注意所有报表只针对年报，当前日期不是年报，当期默认是最近一期年报,
		//如果当期（非年报）报表口径和最近一期年报不一致也将造成查不出数据
		int iCurYear =Integer.parseInt(sAccountMonth.substring(0,4));
		String sReportDate="";
		int iCount=firstN;
		if(iCount>0){
			if(sAccountMonth!=null&&!sAccountMonth.endsWith("/12")){
				iCount++;
				sReportDate="('";
			}else{
				sReportDate="('"+sAccountMonth+"','";
			}
			for(int i=1;i<iCount;i++){
				sReportDate+=(iCurYear-i)+"/12','";
			}
			sReportDate =sReportDate.substring(0, sReportDate.length()-2)+")";
		}else{
			if(sAccountMonth!=null&&!sAccountMonth.endsWith("/12")){
				sReportDate="('"+((iCurYear-1)-iCount)+"/12')";
			}else{
				sReportDate="('"+(iCurYear-iCount)+"/12')";
			}
			firstN=1;
		}
		//查询今年财务报表相关值
		String sSql = "SELECT nvl("+sItemName+",0) FROM REPORT_DATA "+
						 " where ReportNo in "+
						 " (select ReportNo from REPORT_RECORD "+
						 " 	where ObjectNo ='"+sObjectNo+"'"+
						 " 	and ReportDate in "+sReportDate+
						 " 	and ReportScope = '"+sReportScope+"')"+
						 " and RowSubject='"+sRowSubject+"'";	
		if(isTY){
			sSql = "select nvl("+sItemName+",0) from CUSTOMER_FSRATION " +
						" where CustomerID ='"+sObjectNo+"'"+
						" and ReportDate in "+sReportDate;
		}
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		iCount=0;
		iCount=rs.getRowCount();
		if(iCount<firstN){//没那么多年报，就能取多少是多少
			firstN=iCount;
		}
		iCount=0;
		while(rs.next())
		{
			dCurOrYearValue += rs.getDouble(1);
			iCount++;
			if(iCount==firstN){
				break;
			}
		}
		rs.getStatement().close();
		if(firstN==0){
			dCurOrYearValue=0;
		}else{
			dCurOrYearValue =dCurOrYearValue/firstN;
		}
		return dCurOrYearValue;
    }
    public Double TJMXFormula(Transaction Sqlca,String sObjectNo,String sObjectType,String sSerialNo,String sModelNo,String sItemNo,String sSubItemNos) throws Exception {
		double dReturn = 0.0;
		//1、040、获取统计模型配置
		// 获取公式常数
		String sSql = " select ItemDescribe,"
				+ " Attribute1,"
				+ " Attribute2,"
				+ " Attribute3,"
				+ " Attribute4,"
				+ " Attribute5,"
				+ " Attribute6,"
				+ " Attribute7"
				+ " from Code_Library "
				+ " where CodeNo = 'ScoreToItemValue'"
				+ " and ItemName='"+sModelNo+"'"
				+ " and SortNo='"+sItemNo+"'"
				+ " and IsInUse='1'";
		ASResultSet rs=Sqlca.getASResultSet(sSql);
		if(rs.next()){
			double a=rs.getDouble(1);
			double b=rs.getDouble(2);
			double c=rs.getDouble(3);
			double d=rs.getDouble(4);
			double median=rs.getDouble(5);
			double StDev=rs.getDouble(6);
			double minScore=rs.getDouble(7);
			double maxScore=rs.getDouble(8);
			//2、获取各个指标的值和权重
			sSql="select ItemValue from Evaluate_Data" +
					" where ObjectType='"+sObjectType+"'" +
					" and ObjectNo='"+sObjectNo+"'" +
					" and SerialNo='"+sSerialNo+"'" +
					" and ItemNo in ('"+sSubItemNos.replaceAll("@", "','")+"')";
			String []ItemValues =Sqlca.getStringArray(sSql);
			sSql="select Coefficient from Evaluate_Model" +
					" where ModelNo='"+sModelNo+"'" +
					" and ItemNo in ('"+sSubItemNos.replaceAll("@", "','")+"')";
			String[] Coefficients=Sqlca.getStringArray(sSql);
			if(ItemValues==null||Coefficients==null||ItemValues.length!=Coefficients.length){
				return 0.0;
			}
			//3、利用公私进行计算
			double FinalItemScore=0.0;
			for(int i=0;i<ItemValues.length;i++){
				double RDF=a + b/(1 + Math.exp(c * DataConvert.toDouble(ItemValues[i]) + d));
				double LogScore = Math.log(RDF / (1 - RDF));
				double ItemScore =(LogScore - median)/StDev* 50;
				FinalItemScore+=ItemScore*DataConvert.toDouble(Coefficients[i]);
			}
			double 统计模型得分=FinalItemScore-1.5946;
			dReturn=100*(统计模型得分-(minScore-0.15))/((maxScore+0.15)-(minScore-0.15));
		}
		rs.getStatement().close();
		return dReturn;
    }
}
