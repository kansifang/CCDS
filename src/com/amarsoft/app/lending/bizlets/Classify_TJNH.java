/*
		Author: --zrli 2009-8-26
		Tester:
		Describe: --���ũ���弶����
		Input Param:
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.lending.bizlets;

import java.sql.ResultSet;
import java.sql.SQLException;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
/**
 *    �˷���Ϊ���ũ���弶�����Զ�����ĺ��Ĵ����࣬��Ҫ���������ֹ��ܣ�һ����Ϊ25�Ž��з����ʼ������CLASSIFY_RECORD��¼
 * ��һ����Ϊ��ĩ���м�¼���϶���ɡ���һ������Զ�˽����ľ��󷨽������ɷ����¼���Թ�����ֱ�������ϴη���Ľ������
 * ���ڴη����¼���ڶ�������Զ�˽����ͶԹ���������϶���
 * @author zrli
 * @version 1.0
 *
 */
public class Classify_TJNH  extends Bizlet {
	//================================================================================

	public Object run(Transaction Sqlca) throws Exception{
		
		String sContractSerialNo = (String)this.getAttribute("SerialNo");
		if(sContractSerialNo == null) sContractSerialNo = "";
		//��ͬ�ţ�ҵ��Ʒ�֡�������
		 String sBusinessType = "",sManageOrgID = "",sManageUserID ="",sVouchTypeTemp="",
			sVouchType="",sCustomerID="",sCustomerType = "",sLowRisk = "",sCreditLevel = "",sLockClassifyResult="";
		
		//��ͬ���
		double dBlance =0;
			
		//��������
		int iOverDueDays = 0;
		
		//���ֽ��,��ʱ���
		String sResult1="01",sResultTemp="";
		
		//�������
		String sOpition="";
		
		//����Classify_Record����ˮ��

		String sSql= "select " +
		" SerialNo,nvl(BusinessType,'1010010') as BusinessType," +
		" ManageOrgID,ManageUserID,nvl(Balance,0) as Balance,VouchType,CustomerID,OverDueDays,LowRisk,LockClassifyResult " +
		" from Business_Contract where Balance >0 " +
		" and businesstype is not null " +
		" and businesstype <>'' " +
		" and vouchtype is not null " +
		" and vouchtype <>'' " +
		" and (finishdate is null or finishdate = '') " +
		" and left(BusinessType,1) <>'3'"+
		" and PutOutDate is not null and PutOutDate<>''"+
		" and serialno = '"+sContractSerialNo+"'";
		
		ASResultSet rs = Sqlca.getASResultSet(sSql);
		if (rs.next()){
			sContractSerialNo = rs.getString("SerialNo");
			sBusinessType = rs.getString("BusinessType");
			sManageOrgID = rs.getString("ManageOrgID");
			sManageUserID  = rs.getString("ManageUserID");
			dBlance = rs.getDouble("Balance");
			sVouchType= rs.getString("VouchType");
			sCustomerID= rs.getString("CustomerID");
			iOverDueDays= rs.getInt("OverDueDays");
			sLowRisk = rs.getString("LowRisk");
			sLockClassifyResult = rs.getString("LockClassifyResult");
			if(sContractSerialNo==null) sContractSerialNo="";
			if(sBusinessType==null) sBusinessType="";
			if(sManageOrgID==null) sManageOrgID="";
			if(sManageUserID==null) sManageUserID="";
			if(sVouchType==null) sVouchType="";
			if(sCustomerID==null) sCustomerID="";
			if(sLowRisk==null) sLowRisk="";
			if(sLockClassifyResult==null) sLockClassifyResult="";
		}
		rs.getStatement().close();
		sResult1 = "";
		//�󶨷��շ���
		if(!sLockClassifyResult.equals(""))
		{
			sResult1 = sLockClassifyResult;
		}else{
			
			sVouchTypeTemp = sVouchType;
			if(sVouchType.length()>3) sVouchType=sVouchType.substring(0,3);
			
			//ȡ�ÿͻ�����
			sCustomerType = getCustomerType(Sqlca,sCustomerID);
			
			//���ΪС��ҵ
			if(sCustomerType.equals("010")){
				//���Ϊ�ͷ���
				if(sLowRisk.equals("1")){
					sOpition="С��ҵ�ͷ�����������ʮ��������";
					sResult1 = ClassifyModel.ClassifyModelWithOverDueDays(iOverDueDays, ClassifyModel.M1);
				}else{
					sOpition="С��ҵ�ǵͷ�����������ʮ��������";
					sResult1 = ClassifyModel.ClassifyModelWithVouchTypeOverdueDays(sVouchType,iOverDueDays, ClassifyModel.M2);
				}
			//���Ϊһ����ҵ
			}else if(sCustomerType.equals("020")){
				//���Ϊ�ͷ���
				if(sLowRisk.equals("1")){
					sOpition="һ����ҵ�ͷ�����������ʮ��������";
					sResult1 = ClassifyModel.ClassifyModelWithOverDueDays(iOverDueDays, ClassifyModel.M5);
				}else{
					sCreditLevel = getCreditLevel(Sqlca,sCustomerID);
					sResult1 = "0101";//�Ƚ��г�ʼ��
					sResultTemp = "0101";//�Ƚ��г�ʼ��
					sResultTemp = ClassifyModel.ClassifyModelWithOverDueDays(iOverDueDays, ClassifyModel.M6);
					sResult1 = compareClassify(sResult1,sResultTemp);
					sResultTemp = ClassifyModel.ClassifyModelWithCreditLevelVouchType(sCreditLevel,sVouchTypeTemp, ClassifyModel.M9);
					sResult1 = compareClassify(sResult1,sResultTemp);
					if(sResult1.equals(sResultTemp)){
						sOpition="һ����ҵ�ǵͷ������õȼ���������ʽʮ��������";
					}
					else
					{
						sOpition="һ����ҵ�ǵͷ�����������ʮ��������";
					}
				}
			//���Ϊũ��
			}else if(sCustomerType.equals("030")){
				sOpition="ũ��������ʽ����������ʮ��������";
				sResult1 = ClassifyModel.ClassifyModelWithVouchTypeOverdueDays(sVouchType, iOverDueDays, ClassifyModel.M10);
			//���Ϊ��ũ��
			}else if(sCustomerType.equals("040")){
				sOpition="��ũ��������ʽ����������ʮ��������";
				sResult1 = ClassifyModel.ClassifyModelWithVouchTypeOverdueDays(sVouchType, iOverDueDays, ClassifyModel.M11);
			}
		}
		return sResult1 +","+sOpition;
	}

	/**
	 * ȡ�ͻ����Ͱ��� 010С��ҵ  020һ����ҵ  030ũ��  040��ũ��  050�޿ͻ���Ϣ
	 * @param sCustomerID
	 * @return
	 */
	private String getCustomerType(Transaction Sqlca,String sCustomerID) throws Exception{
		String sCustomerType = "";
		String sFarmerType = "";
		double dBalanceSum = 0;
		ResultSet rs = null;
		try {
			//�Ȳ��ҿͻ�����
			sCustomerType = Sqlca.getString("select CustomerType from CUSTOMER_INFO where CustomerID = '"+sCustomerID+"'");
			if(sCustomerType == null) sCustomerType = "";
			
			//���Ϊ���˿ͻ�
			if("".equals(sCustomerType)){
				sCustomerType = "050";
			}
			else if(sCustomerType.startsWith("03")){
				
				sFarmerType = Sqlca.getString("select IndRPRType from IND_INFO where CustomerID = '"+sCustomerID+"'");
				if(sFarmerType == null) sFarmerType = "";

				//���Ϊũ��
				if(sFarmerType.equals("010")){
					sCustomerType = "030";
				}else{
					sCustomerType = "040";
				}
			}else{

				dBalanceSum = Sqlca.getDouble("select sum(Balance) as Balance from BUSINESS_CONTRACT where CustomerID = '"+sCustomerID+"'");

				//����������С��500����ôΪС��ҵ
				if(dBalanceSum <= 5000000){
					sCustomerType = "010";
				}else{
					sCustomerType = "020";
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return sCustomerType;
	}
	
	/**
	 * ȡ�ͻ��ļ������õȼ�
	 * @param sCustomerID
	 * @return
	 */
	private String getCreditLevel(Transaction Sqlca,String sCustomerID) throws Exception{
		String sCreditLevel = "";
		try {
			sCreditLevel = Sqlca.getString("select CreditLevel from ENT_INFO where CustomerID = '"+sCustomerID+"'");
			if(sCreditLevel == null) sCreditLevel = "";
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return sCreditLevel;
	}
	/**
	 * ʮ����������С�Ƚ� ���ز�ļ���
	 * @param sResult1
	 * @param sResult2
	 * @return
	 */
	private String compareClassify(String sResult1,String sResult2){
		String sBadResult = "";
		try{
		if(Integer.parseInt(sResult1)>Integer.parseInt(sResult2)){
			sBadResult =  sResult1;
		}else{
			sBadResult = sResult2;
		}
		}catch(Exception ex){
			sBadResult = sResult1.length()>0?sResult1:sResult2;
		}
		return sBadResult;
	}
}
