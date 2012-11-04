package com.amarsoft.app.lending.bizlets;

/*
 Author: --bllou 2012-09-23
 Tester:
 Describe: --��ȡ�����еĸ���ȡֵ
 */
import java.text.DecimalFormat;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;
import com.amarsoft.biz.bizlet.Bizlet;

public class EvaluateGetValue extends Bizlet {
	public Object  run(Transaction Sqlca) throws Exception
	{
		//��ȡ�������������������ţ���ͼID���û����		
		String sMethodName = DataConvert.toString((String)this.getAttribute("MethodName"));	
		//������ˮ��\�ͻ�ID
		String sObjectNo = DataConvert.toString((String)this.getAttribute("ObjectNo"));
		//���񱨱��·�
		String sAccountMonth = DataConvert.toString((String)this.getAttribute("AccountMonth"));
		//��������
		String sReportScope = DataConvert.toString((String)this.getAttribute("ReportScope"));
		//���񱨸��Ŀ��
		String sRowSubject = DataConvert.toString((String)this.getAttribute("RowSubject"));
		//��ȡ�ֶ�
		String sColName = DataConvert.toString((String)this.getAttribute("ColName"));
		int HowMuchY= DataConvert.toInt((String)this.getAttribute("HowMuchY"));
		
		//CheckValue����ʽΪ ModelNo@ItemNo~rowsubject1@col1value@rowsubject2@col2value....
		//1��ͳ��ģ�ͼ���
		//2��ʹ���ڷ��ӳ��Է�ĸ����ʵ������У����ӷ�ĸͬʱΪ��ֵ���ĸΪ0���������Ƿ�ĸ��Ŀ��ֵ��
		String CheckValue= DataConvert.toString((String)this.getAttribute("CheckValue"));
		
		Double sReturn=0.0;
		
		if(sMethodName.equals("AS")||sMethodName.equals("ASTY")){
			sReturn=AveForRowSubject(sMethodName,Sqlca,sObjectNo,sAccountMonth,sReportScope,sRowSubject,sColName,HowMuchY,CheckValue);
		}
			
		DecimalFormat nf = new DecimalFormat("#0.########################################");//40λС��
		return nf.format(sReturn);
	}
    /**
     * 
     * @param isTY ASTY ͬҵ  AS��ͬҵ
     * @param Sqlca
     * @param sObjectNo
     * @param sAccountMonth
     * @param sReportScope
     * @param sRowSubject
     * @param sColName
     * @param firstN Ϊ���� ��ʾƽ����Ϊ������-1��һ��(��һ��)��-2Ϊǰһ�꣨�����ڣ��ȵ�
     * @param CheckValue �����ʱУ�� ���ӷ�ĸͬΪ���� ���Ϊ������� CheckValue����ʽΪ rowsubject1@col1value@rowsubject2@col2value..~ModelNo@ItemNo
     * @return
     * @throws Exception
     */
    public double AveForRowSubject(String isTY,Transaction Sqlca,String sObjectNo,String sAccountMonth,String sReportScope,String sRowSubject,String sColName,int firstN,String CheckValue) throws Exception {
		double dCurOrYearValue = 0.0;
		//������ʶ
		//ע�����б���ֻ����걨����ǰ���ڲ����걨������Ĭ�������һ���걨,
		//������ڣ����걨������ھ������һ���걨��һ��Ҳ����ɲ鲻������
		int iCurYear =Integer.parseInt(sAccountMonth.substring(0,4));
		String[] sReportDate=null;
		int iCount=0;
		//1����ȡ�걨
		String sMonth=sAccountMonth.substring(4);//2012/09 �걨������12�·�Ϊ׼���Ե�ǰ�걨�·�Ϊ׼
		if(firstN>0){
			sReportDate=new String[firstN];
			sReportDate[0]=sAccountMonth;
			for(int i=1;i<firstN;i++){
				sReportDate[i]=(iCurYear-i)+sMonth;
			}
		}else{//firstNΪ��ֵ������һ��ĳһ������
			sReportDate=new String[1];
			sReportDate[0]=(iCurYear+firstN)+sMonth;
			firstN=1;
		}
		//2����ѯ���񱨱����ֵ������У��
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
		if(iCount<firstN){//û��ô���걨������ȡ�����Ƕ���
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
    	//�����ʱУ�� CheckValue���õ��Ƿ�ĸ
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
				//�쳣����� ���Ӳ����ڣ�����Ϊnull,��ĸ�����ڣ���ĸΪnull,��ĸΪ0�����ӷ�ĸͬΪ��ֵ
				if(!sItemNo.endsWith("TJMX")){
					if(dCVFZ==null||dCVFZ==999999999||dCVFM==null||dCVFM==999999999||dCVFM==0){
						if(FirstN==1){//��ĳһ��Ĳ���ָ�꣬�쳣ֵʱ������ȡ��ͷ�(0)
							Sqlca.executeSQL("update Evaluate_Model set Remark='@true@' where ModelNo='"+sModelNo+"' and ItemNo='"+sItemNo+"'");
						}
						dCurOrYearValue=0;
					}
					if(dCurOrYearValue==888888888){
						dCurOrYearValue =dCVFZ/dCVFM;
					}
					//���� ���ӷ�ĸ�����õ�ֵΪ�������ʱ������ ��ǰmodelNo��ǰItemNo��RemarkֵΪ@true@ 
					if(dCurOrYearValue>0&&dCVFM<0){
						if(FirstN==1){//��ĳһ��Ĳ���ָ�꣬���ڷ��ӷ�ĸΪ��ֵʱ������ȡ��ͷ�
							Sqlca.executeSQL("update Evaluate_Model set Remark='@true@' where ModelNo='"+sModelNo+"' and ItemNo='"+sItemNo+"'");
							dCurOrYearValue=0-dCurOrYearValue;
						}else{
							//��n��ƽ��ֵʱ��Ϊͳ��ģ��ʱ���ڷ��ӷ�Ϊ��ֵʱ����ǰ�����Ϊ0
							dCurOrYearValue=0;
						}
					}
					
				}else if(sItemNo.endsWith("TJMX")){
					if(dCVFZ==null||dCVFZ==999999999||dCVFM==null||dCVFM==999999999||dCVFM==0||dCurOrYearValue>0&&dCVFM<0){
						if(sItemNo.endsWith("1.1.1.TJMX")||sItemNo.endsWith("1.1.2.TJMX")||sItemNo.endsWith("1.3.1.TJMX")){//Ӧ���ʿ���ת�����������ת�������ʲ���ծ��
							dCurOrYearValue=9999;
						}else if(sItemNo.endsWith("1.2.1.TJMX")||sItemNo.endsWith("1.4.1.TJMX")||sItemNo.endsWith("1.5.1.TJMX")){//��Ϣ���ϱ������ֽ���ʡ������ܶ�
							dCurOrYearValue=-9999;
						}
					}
					//����ת������ת����
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
			if(aCheckValue1.length==2&&aCheckValue1[1].indexOf("&")<0){//���ӻ��ĸֻ��һ��ָ��ʱ�����Ϊ������Ϊ999999999
				sRowSub=aCheckValue1[0];
				RowSubjects+=sRowSub+"')";
				ColNValues+=" when RowSubject='"+sRowSub+"' then ";
				ColNValues+="nvl("+aCheckValue1[1]+",999999999)";
			}else{                                                      //���ӻ��ĸ��ֻһ��ָ��ʱ�����Ϊ������Ϊ0
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
    //ͳ��ģ�͸���ָ��ת��
    /**
     * CheckValue  ��ʽ�� ModelNo@ItemNo~808@ColValue
     */
    public double TJMXFormula(double dItemValue,Transaction Sqlca,String sObjectNo,String sReportDate,String sModelNo,String sItemNo) throws Exception {
		double dReturn = dItemValue;
		String sSql ="";
		if(sModelNo!=null&&sModelNo.length()>0&&sItemNo!=null&&sItemNo.length()>0){
			if(sItemNo.endsWith("TJMX")){
				//1����ȡͳ��ģ��ָ�����ù�ʽ����
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
					//2����ȡ����ָ���ֵ��Ȩ��
					double dCoefficient =Sqlca.getDouble("select Coefficient from Evaluate_Model" +
															" where ModelNo='"+sModelNo+"'" +
															" and ItemNo ='"+sItemNo+"'");
					//3��У��ָ��ֵ
					if(dItemValue>=UpperLimit){
						dItemValue =UpperLimit;
					}else if(dItemValue<=LowerLimit){
						dItemValue =LowerLimit;
					}
					//4�����ù�ʽ���м����ȡ���ո���ָ��÷�
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
				//2�л�ǰ 1�л���
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
				
				double ͳ��ģ�͵÷�=1.5946-dTotalTJMXZBScore;
				double minScore =-1.50201828;
				double maxScore =3.519853887;
				dReturn=100*(ͳ��ģ�͵÷�-(minScore-0.15))/((maxScore+0.15)-(minScore-0.15));
			}
		}
		return dReturn;
    }
}
