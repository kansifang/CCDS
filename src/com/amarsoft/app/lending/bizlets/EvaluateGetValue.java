package com.amarsoft.app.lending.bizlets;

/*
 Author: --bllou 2012-09-23
 Tester:
 Describe: --获取评级中的复杂取值
 */
import java.text.DecimalFormat;

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
		String sAccountMonth = DataConvert.toString((String)this.getAttribute("AccountMonth"));
		//财务报类型
		String sReportScope = DataConvert.toString((String)this.getAttribute("ReportScope"));
		//财务报告科目号
		String sRowSubject = DataConvert.toString((String)this.getAttribute("RowSubject"));
		//所取字段
		String sColName = DataConvert.toString((String)this.getAttribute("ColName"));
		int HowMuchY= DataConvert.toInt((String)this.getAttribute("HowMuchY"));
		
		//CheckValue的形式为 ModelNo@ItemNo~rowsubject1@col1value@rowsubject2@col2value....
		//1、统计模型计算
		//2、使用于分子除以分母求比率的情况，校验分子分母同时为负值或分母为0的情况这个是分母科目的值，
		String CheckValue= DataConvert.toString((String)this.getAttribute("CheckValue"));
		
		Double sReturn=0.0;
		
		if(sMethodName.equals("AS")||sMethodName.equals("ASTY")){
			sReturn=AveForRowSubject(sMethodName,Sqlca,sObjectNo,sAccountMonth,sReportScope,sRowSubject,sColName,HowMuchY,CheckValue);
		}
			
		DecimalFormat nf = new DecimalFormat("#0.########################################");//40位小数
		return nf.format(sReturn);
	}
    /**
     * 
     * @param isTY ASTY 同业  AS非同业
     * @param Sqlca
     * @param sObjectNo
     * @param sAccountMonth
     * @param sReportScope
     * @param sRowSubject
     * @param sColName
     * @param firstN 为正数 表示平均，为负数，-1上一年(上一期)，-2为前一年（上两期）等等
     * @param CheckValue 求比率时校验 分子分母同为负数 结果为正的情况 CheckValue的形式为 rowsubject1@col1value@rowsubject2@col2value..~ModelNo@ItemNo
     * @return
     * @throws Exception
     */
    public double AveForRowSubject(String isTY,Transaction Sqlca,String sObjectNo,String sAccountMonth,String sReportScope,String sRowSubject,String sColName,int firstN,String CheckValue) throws Exception {
		double dCurOrYearValue = 0.0;
		//计数标识
		//注意所有报表只针对年报，当前日期不是年报，当期默认是最近一期年报,
		//如果当期（非年报）报表口径和最近一期年报不一致也将造成查不出数据
		int iCurYear =Integer.parseInt(sAccountMonth.substring(0,4));
		String[] sReportDate=null;
		int iCount=0;
		//1、获取年报
		String sMonth=sAccountMonth.substring(4);//2012/09 年报不再以12月份为准，以当前年报月份为准
		if(firstN>0){
			sReportDate=new String[firstN];
			sReportDate[0]=sAccountMonth;
			for(int i=1;i<firstN;i++){
				sReportDate[i]=(iCurYear-i)+sMonth;
			}
		}else{//firstN为负值，求上一个某一年的情况
			sReportDate=new String[1];
			sReportDate[0]=(iCurYear+firstN)+sMonth;
			firstN=1;
		}
		//2、查询财务报表相关值，并作校验
		String sSql="";
		for(String rDate:sReportDate){
			sSql = "SELECT nvl("+sColName+",0) " +
						 " FROM REPORT_DATA RD,REPORT_RECORD RR"+
						 " where RR.ObjectType='CustomerFS'" +
						 " and RR.ObjectNo ='"+sObjectNo+"'"+
						 " and RR.ReportDate = '"+rDate+"'"+
						 " and RR.ReportScope = '"+sReportScope+"'"+
						 " and RD.ReportNo=RR.ReportNo"+
						 " and RD.RowSubject='"+sRowSubject+"'" +
						 " order by RD.ReportNo asc";	
			if("ASTY".equals(isTY)){
				sSql = "select nvl("+sColName+",0) from CUSTOMER_FSRATION " +
						" where CustomerID ='"+sObjectNo+"'"+
						" and ReportDate = '"+rDate+"'";
			}
			ASResultSet rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				double dValue = rs.getDouble(1);
				dCurOrYearValue += this.checkValue(dValue,isTY,Sqlca,sObjectNo,rDate,sReportScope,firstN,CheckValue);
				iCount++;
			}else if("NO".equals(sRowSubject)){
				dCurOrYearValue += this.checkValue(888888888,isTY,Sqlca,sObjectNo,rDate,sReportScope,firstN,CheckValue);
				iCount++;
			}
			rs.getStatement().close();
		}
		if(iCount<firstN){//没那么多年报，就能取多少是多少
			firstN=iCount;
		}
		if(firstN==0){
			dCurOrYearValue=0;
		}else{
			dCurOrYearValue =dCurOrYearValue/firstN;
		}
		return dCurOrYearValue;
    }
    public double checkValue(double dCurOrYearValue,String isTY,Transaction Sqlca,String sObjectNo,String sReportDate,String sReportScope,int FirstN,String CheckValue)throws Exception{
    	//求比率时校验 CheckValue配置的是分母
		String sModelNo="";
		String sItemNo="";
		if(CheckValue.length()>0){
			String []aCV=CheckValue.split("~");
			if(aCV.length>0){
				String []aCheckValue0=aCV[0].split("@");
				if(aCheckValue0.length>1){
					sModelNo=aCheckValue0[0];
					sItemNo=aCheckValue0[1];
				}
			}
			if(aCV.length>2){
				Double dCVFZ =null,dCVFM =null;
				dCVFZ=this.getFZOrFM(aCV[1], isTY, Sqlca, sObjectNo, sReportDate, sReportScope, FirstN);
				dCVFM=this.getFZOrFM(aCV[2], isTY, Sqlca, sObjectNo, sReportDate, sReportScope, FirstN);
				//异常情况： 分子不存在，分子为null,分母不存在，分母为null,分母为0，分子分母同为负值
				if(!sItemNo.endsWith("TJMX")){
					if(dCVFZ==null||dCVFZ==999999999||dCVFM==null||dCVFM==999999999||dCVFM==0){
						if(FirstN==1){//求某一年的财务指标，异常值时，评级取最低分(0)
							Sqlca.executeSQL("update Evaluate_Model set Remark='@true@' where ModelNo='"+sModelNo+"' and ItemNo='"+sItemNo+"'");
						}
						dCurOrYearValue=0;
					}
					if(dCurOrYearValue==888888888){
						dCurOrYearValue =dCVFZ/dCVFM;
					}
					//存在 分子分母进而得到值为正的情况时，更新 当前modelNo当前ItemNo的Remark值为@true@ 
					if(dCurOrYearValue>0&&dCVFM<0){
						if(FirstN==1){//求某一年的财务指标，存在分子分母为负值时，评级取最低分
							Sqlca.executeSQL("update Evaluate_Model set Remark='@true@' where ModelNo='"+sModelNo+"' and ItemNo='"+sItemNo+"'");
							dCurOrYearValue=0-dCurOrYearValue;
						}else{
							//求n年平均值时或为统计模型时存在分子分为负值时，当前结果设为0
							dCurOrYearValue=0;
						}
					}
					
				}else if(sItemNo.endsWith("TJMX")){
					if(dCVFZ==null||dCVFZ==999999999||dCVFM==null||dCVFM==999999999||dCVFM==0||dCurOrYearValue>0&&dCVFM<0){
						if(sItemNo.endsWith("1.1.1.TJMX")||sItemNo.endsWith("1.1.2.TJMX")||sItemNo.endsWith("1.3.1.TJMX")){//应收帐款周转天数、存货周转天数、资产负债率
							dCurOrYearValue=9999;
						}else if(sItemNo.endsWith("1.2.1.TJMX")||sItemNo.endsWith("1.4.1.TJMX")||sItemNo.endsWith("1.5.1.TJMX")){//利息保障倍数、现金比率、利润总额
							dCurOrYearValue=-9999;
						}
					}
					//由周转率求周转天数
					if(sItemNo.equals("1.1.1.TJMX")||sItemNo.equals("1.1.2.TJMX")){
						if(dCurOrYearValue!=0&&dCurOrYearValue!=9999){
							dCurOrYearValue =360/dCurOrYearValue;
						}
					}
				}
			}
		}
		return this.TJMXFormula(dCurOrYearValue, Sqlca, sObjectNo,sReportDate, sModelNo, sItemNo);
    }
    private Double getFZOrFM(String sCV,String isTY,Transaction Sqlca,String sObjectNo,String sReportDate,String sReportScope,int FirstN) throws Exception{
    	Double dCV=null;
    	String sRowSub="";
    	String []aCheckValue1=sCV.split("@");
    	if(aCheckValue1.length>1){
    		String RowSubjects="('";
			String ColNValues="";
			if(aCheckValue1.length==2&&aCheckValue1[1].indexOf("&")<0){//分子或分母只有一个指标时，如果为空设置为999999999
				sRowSub=aCheckValue1[0];
				RowSubjects+=sRowSub+"')";
				ColNValues+=" when RowSubject='"+sRowSub+"' then ";
				ColNValues+="nvl("+aCheckValue1[1]+",999999999)";
			}else{                                                      //分子或分母不只一个指标时，如果为空设置为0
				for(int i=0;i<aCheckValue1.length;i+=2){
					sRowSub=aCheckValue1[i];
					RowSubjects+=sRowSub+"','";
					ColNValues+=" when RowSubject='"+sRowSub+"' then ";
					String[] sColumn=aCheckValue1[i+1].split("&");
					for(String sC:sColumn){
						ColNValues+="nvl("+sC+",0)+";
					}
					ColNValues =ColNValues.substring(0, ColNValues.length()-1);
				}
				RowSubjects =RowSubjects.substring(0, RowSubjects.length()-2)+")";
			}
			String sSql="SELECT sum(case "+ColNValues+" end) FROM REPORT_DATA "+
					 " where ReportNo in "+
					 " (select ReportNo from REPORT_RECORD "+
					 " 	where ObjectType='CustomerFS'" +
					 "	and ObjectNo ='"+sObjectNo+"'"+
					 " 	and ReportDate = '"+sReportDate+"'"+
					 " 	and ReportScope = '"+sReportScope+"')"+
					 " and RowSubject in "+RowSubjects;
			if("ASTY".equals(isTY)){
				sSql="select "+ColNValues+" from CUSTOMER_FSRATION " +
						" where CustomerID ='"+sObjectNo+"'"+
						" and ReportDate = '"+sReportDate+"'";
			}
			dCV = Sqlca.getDouble(sSql);
    	}
		return dCV;
    }
    //统计模型各个指标转换
    /**
     * CheckValue  形式如 ModelNo@ItemNo~808@ColValue
     */
    public double TJMXFormula(double dItemValue,Transaction Sqlca,String sObjectNo,String sReportDate,String sModelNo,String sItemNo) throws Exception {
		double dReturn = dItemValue;
		String sSql ="";
		if(sModelNo!=null&&sModelNo.length()>0&&sItemNo!=null&&sItemNo.length()>0){
			if(sItemNo.endsWith("TJMX")){
				//1、获取统计模型指标配置公式常数
				sSql = " select ItemDescribe,"
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
					double LowerLimit=rs.getDouble(7);
					double UpperLimit=rs.getDouble(8);
					//2、获取各个指标的值和权重
					double dCoefficient =Sqlca.getDouble("select Coefficient from Evaluate_Model" +
															" where ModelNo='"+sModelNo+"'" +
															" and ItemNo ='"+sItemNo+"'");
					//3、校验指标值
					if(dItemValue>=UpperLimit){
						dItemValue =UpperLimit;
					}else if(dItemValue<=LowerLimit){
						dItemValue =LowerLimit;
					}
					//4、利用公式进行计算获取最终该项指标得分
					double RDF=a + b/(1 + Math.exp(c * dItemValue + d));
					if(RDF / (1 - RDF)<0){
						dReturn=0;
					}else{
						double LogScore = Math.log(RDF / (1 - RDF));
						double ItemScore =(LogScore - median)/StDev* 50;
						dReturn=ItemScore*dCoefficient;
					}
				}
				rs.getStatement().close();
			}else if(sItemNo.endsWith("TJMXSUM")){
				//2切换前 1切换后
				double dTotalTJMXZBScore=0;
				String sIsInuse = DataConvert.toString(Sqlca.getString(" select IsInuse  from code_library where codeno = 'UnusedOldEvaluateCard' and itemno='UnusedOldEvaluateCard'"));
				sSql="select nvl(ItemValue,'0') from Evaluate_Data ED" +
						" where ED.ObjectType='"+("1".equals(sIsInuse)?"Customer":"NewEvaluate")+"'"+
						" and ED.ObjectNo='"+sObjectNo+"'" +
						" and ED.ItemNo like '%TJMX'"+
						" and exists(select 1 from Evaluate_Record ER " +
						"	where ER.ObjectType=ED.ObjectType" +
						"		and ER.ObjectNo=ED.ObjectNo" +
						"		and ER.AccountMonth='"+sReportDate+"'" +
						"		and ER.SerialNo=ED.SerialNo)";
				ASResultSet rs=Sqlca.getASResultSet(sSql);
				while(rs.next()){
					String sItemValue =rs.getString(1);
					dTotalTJMXZBScore+=DataConvert.toDouble(sItemValue);
				}
				rs.getStatement().close();
				
				double 统计模型得分=1.5946-dTotalTJMXZBScore;
				double minScore =-1.50201828;
				double maxScore =3.519853887;
				dReturn=100*(统计模型得分-(minScore-0.15))/((maxScore+0.15)-(minScore-0.15));
			}
		}
		return dReturn;
    }
}
