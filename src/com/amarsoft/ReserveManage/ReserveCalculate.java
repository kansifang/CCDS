package com.amarsoft.ReserveManage;
/**
 * ����ת����
 * �����ھ���������ڡ�ת�ء���ֵ׼��������Ϊ�����ھ���������ڡ����ֻز�����ֵ׼��
 * �����ھ���������ڡ���������ֵ׼��������Ϊ"�����ھ���������ڡ�ת�ء���ֵ׼��"
 *
 * 
 */

import java.util.ArrayList;
import java.util.Vector;
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.are.util.DataConvert;



public class ReserveCalculate {
	
	private Transaction Sqlca = null;
	
	public ReserveCalculate(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;			
	}

	/**
	 * ���ݻ���·ݡ������ʺź�ͳ�ƿھ���ȡ������������ϼ����ֵ׼��
	 * ע�⣺��Թ��������������ʧ�ʡ�����ھ�ʶ���ڼ䡢����ھ�����ϵ��������ָ�����ʱ�������ͬһ��ֵ����
	 * @param alReserveTotal ����Ϊ������·ݡ������ʺš�......,sAccountMonth ����·�,sScope ͳ�ƿھ�
	 * @return double ��ϼ����ֵ׼��
	 */
	public double getACompReserveSum(ArrayList alReserveTotal,String sAccountMonth,String sScope) throws Exception
	{
		//�������		
		ArrayList alReservePara = new ArrayList();//��ż�ֵ���������Ϣ		
		double dACompReserveSum = 0.0;//���������������ϼ����ֵ׼��
		double dExchangeRate = 0.0;//���ڻ���
		double dBalance = 0.0;//���ڱ���
		double dInterest = 0.0;//������Ϣ����
		double dMLossRate1 = 0.0;//���������������ʧ��
		double dALossRate1 = 0.0;//��������������ʧ��
		double dMLossTerm = 0.0;//����ھ�ʶ���ڼ�
		double dALossTerm = 0.0;//��ƿھ�ʶ���ڼ�
		double dMAdjustValue = 0.0;//����ھ�����ϵ��
		double dAAdjustValue = 0.0;//��ƿھ�����ϵ��
		
		
		//��ô������ݿ������Ϣ
		dExchangeRate = DataConvert.toDouble((String)alReserveTotal.get(31));//���ڻ���
		dBalance = DataConvert.toDouble((String)alReserveTotal.get(30));//���ڱ���(Ŀǰ���)
		dInterest = DataConvert.toDouble((String)alReserveTotal.get(37));//������Ϣ����
		
		//��ȡ��Ӧ����·ݵļ�ֵ���������Ϣ
		ReservePara reservePara = new ReservePara(this.Sqlca);
		alReservePara = reservePara.getReservePara(sAccountMonth);
		if(!alReservePara.isEmpty())
		{
			//��������������ʧ��
			String sALossRate1 = (String)alReservePara.get(10);
			if(sALossRate1 == null || sALossRate1.equals(""))sALossRate1 = "0.0";
			dALossRate1 = Double.parseDouble(sALossRate1)/100.0;
			dMLossRate1 = dALossRate1;
			
			//��ƿھ�ʶ���ڼ�
			String sALossTerm = (String)alReservePara.get(2);
			if(sALossTerm == null || sALossTerm.equals(""))sALossTerm = "0.0";
			dALossTerm = Double.parseDouble(sALossTerm)/365.0;
			dMLossTerm = dALossTerm;
			
			//��ƿھ�����ϵ��
			String sAAdjustValue = (String)alReservePara.get(4);
			if(sAAdjustValue == null || sAAdjustValue.equals(""))sAAdjustValue = "0.0";
			dAAdjustValue = Double.parseDouble(sAAdjustValue);
			dMAdjustValue = dAAdjustValue;
			
			//dMLossRate1 = Double.parseDouble((String)alReservePara.get(5));//���������������ʧ��
			//dALossRate1 = Double.parseDouble((String)alReservePara.get(10));//��������������ʧ��
			//dMLossTerm = Double.parseDouble((String)alReservePara.get(1));//����ھ�ʶ���ڼ�
			//dALossTerm = Double.parseDouble((String)alReservePara.get(2));//��ƿھ�ʶ���ڼ�
			//dMAdjustValue = Double.parseDouble((String)alReservePara.get(3));//����ھ�����ϵ��
			//dAAdjustValue = Double.parseDouble((String)alReservePara.get(4));//��ƿھ�����ϵ��
		}	
		
		if(sScope.equals("M")) //�����ھ�
		{
			/*
			����������ֵ׼��
			=���ڻ���X(���ڱ���+������Ϣ����)X���������������ʧ��X������ʧʶ���ڼ�X���ڵ���ϵ��*/
			dACompReserveSum = dExchangeRate * (dBalance + dInterest) * dMLossRate1 * dMLossTerm * dMAdjustValue;
		}
		
		if(sScope.equals("A")) //��ƿھ�
		{
			/*
			����������ֵ׼��				
			=���ڻ���X(���ڱ���+������Ϣ����)X���������������ʧ��X������ʧʶ���ڼ�X���ڵ���ϵ��*/
			dACompReserveSum = dExchangeRate * (dBalance + dInterest) * dALossRate1 * dALossTerm * dAAdjustValue;
		}
		
		return dACompReserveSum;
	}

    /**
     * ���˴�����ϼ�����㹫ʽ
     * ���ݻ���·ݡ������ʺź�ͳ�ƿھ���ȡ������������ϼ����ֵ׼��
     * ע�⣺��Թ��������������ʧ�ʡ�����ھ�ʶ���ڼ䡢����ھ�����ϵ��������ָ�����ʱ�������ͬһ��ֵ����
     * @param alReserveTotal ����Ϊ������·ݡ������ʺš�......,sAccountMonth ����·�,sScope ͳ�ƿھ�
     * @return double ��ϼ����ֵ׼��
     */
    public double getPACompReserveSum(ArrayList alReserveTotal,String sAccountMonth,String sScope) throws Exception
    {
        //�������      
        ArrayList alReservePara = new ArrayList();//��ż�ֵ���������Ϣ      
        double dACompReserveSum = 0.0;//���������������ϼ����ֵ׼��
        double dExchangeRate = 0.0;//���ڻ���
        double dBalance = 0.0;//���ڱ���
        double dInterest = 0.0;//������Ϣ����
        double dMLossRate1 = 0.0;//���������������ʧ��
        double dALossRate1 = 0.0;//��������������ʧ��
        double dMAdjustValue = 0.0;//����ھ�����ϵ��
        double dAAdjustValue = 0.0;//��ƿھ�����ϵ��
        double dAOverDueDaysAdjust1 = 0.0;//��ƿھ���������ϵ��
        double dAOverDueDaysAdjust2 = 0.0;//��ƿھ�����1-30��������ϵ��
        double dAOverDueDaysAdjust3 = 0.0;//����31-90��������ϵ��
        double dAOverDueDaysAdjust4 = 0.0;//����91-180��������ϵ��
        double dAOverDueDaysAdjust5 = 0.0;//����181-360��������ϵ��
        double dAOverDueDaysAdjust6 = 0.0;//����360������������ϵ��
        double dTemp = 0.0;//������������ϵ��
        
        //��ô������ݿ������Ϣ
        dExchangeRate = Double.parseDouble((String)alReserveTotal.get(31));//���ڻ���
        dBalance = Double.parseDouble((String)alReserveTotal.get(30));//���ڱ���(Ŀǰ���)
        dInterest = DataConvert.toDouble((String)alReserveTotal.get(37));//������Ϣ����
        
        //��ȡ��Ӧ����·ݵļ�ֵ���������Ϣ
        ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
        alReservePara = reservePara.getReservePara(sAccountMonth);
        if(!alReservePara.isEmpty())
        {
            //��������������ʧ��
            String sALossRate1 = (String)alReservePara.get(2);
            if(sALossRate1 == null || sALossRate1.equals(""))sALossRate1 = "0.0";
            dALossRate1 = DataConvert.toDouble(sALossRate1)/100.0;
            dMLossRate1 = dALossRate1;
            
            //��ƿھ�����ϵ��
            String sAAdjustValue = (String)alReservePara.get(1);
            if(sAAdjustValue == null || sAAdjustValue.equals(""))sAAdjustValue = "0.0";
            dAAdjustValue = DataConvert.toDouble(sAAdjustValue);
            dMAdjustValue = dAAdjustValue;
            
            //��ƿھ�����ϵ��
            dAOverDueDaysAdjust1 = DataConvert.toDouble((String)alReservePara.get(4));
            dAOverDueDaysAdjust2 = DataConvert.toDouble((String)alReservePara.get(5));
            dAOverDueDaysAdjust3 = DataConvert.toDouble((String)alReservePara.get(6));
            dAOverDueDaysAdjust4 = DataConvert.toDouble((String)alReservePara.get(7));
            dAOverDueDaysAdjust5 = DataConvert.toDouble((String)alReservePara.get(8));
            dAOverDueDaysAdjust6 = DataConvert.toDouble((String)alReservePara.get(9));
           
            double dOverDueDays = DataConvert.toDouble((String)alReserveTotal.get(72));
            if(dOverDueDays>0 && dOverDueDays<=30){
                dTemp = dAOverDueDaysAdjust2;
            }
            else if(dOverDueDays>30 && dOverDueDays<=90){
                dTemp = dAOverDueDaysAdjust3;
            }
            else if(dOverDueDays>90 && dOverDueDays<=180){
                dTemp = dAOverDueDaysAdjust4;
            }
            else if(dOverDueDays>180 && dOverDueDays<=360){
                dTemp = dAOverDueDaysAdjust5;
            }
            else if(dOverDueDays>360){
                dTemp = dAOverDueDaysAdjust6;
            }else{
                dTemp = dAOverDueDaysAdjust1;
            }

        }   
        
        if(sScope.equals("M")) //�����ھ�
        {
            /*
            ����������ֵ׼��
            =���ڻ���X(���ڱ���+������Ϣ����)X���������������ʧ��X������ʧʶ���ڼ�X���ڵ���ϵ��*/
            dACompReserveSum = dExchangeRate * (dBalance + dInterest) * dMLossRate1 * dMAdjustValue *dTemp ;
        }
        
        if(sScope.equals("A")) //��ƿھ�
        {
            /*
            ����������ֵ׼��               
            =���ڻ���X(���ڱ���+������Ϣ����)X���������������ʧ��X������ʧʶ���ڼ�X���ڵ���ϵ��*/
            dACompReserveSum = dExchangeRate * (dBalance + dInterest) * dALossRate1  * dAAdjustValue *dTemp;
        }
        
        return dACompReserveSum;
    }

	/**
	 * ���ݻ���·ݡ������ʺź�ͳ�ƿھ���ȡ��ע��������ϼ����ֵ׼��
	 * @param alReserveTotal ����Ϊ������·ݡ������ʺš�......,sAccountMonth ����·�,sScope ͳ�ƿھ�
	 * @return double ��ϼ����ֵ׼��
	 */
	public double getBCompReserveSum(ArrayList alReserveTotal,String sAccountMonth,String sScope) throws Exception
	{
		//�������		
		ArrayList alReservePara = new ArrayList();//��ż�ֵ���������Ϣ		
		double dBCompReserveSum = 0.0;//��Ź�ע��������ϼ����ֵ׼��
		double dExchangeRate = 0.0;//���ڻ���
		double dBalance = 0.0;//���ڱ���
		double dInterest = 0.0;//������Ϣ����
		double dMLossRate2 = 0.0;//�����ע�������ʧ��
		double dALossRate2 = 0.0;//��ƹ�ע�������ʧ��
		double dMLossTerm = 0.0;//����ھ�ʶ���ڼ�
		double dALossTerm = 0.0;//��ƿھ�ʶ���ڼ�
		double dMAdjustValue = 0.0;//����ھ�����ϵ��
		double dAAdjustValue = 0.0;//��ƿھ�����ϵ��
		
		//��ô������ݿ������Ϣ
		dExchangeRate = DataConvert.toDouble((String)alReserveTotal.get(31));//���ڻ���
		dBalance = DataConvert.toDouble((String)alReserveTotal.get(30));//���ڱ���(Ŀǰ���)
		dInterest = DataConvert.toDouble((String)alReserveTotal.get(37));//������Ϣ����
		
		//��ȡ��Ӧ����·ݵļ�ֵ���������Ϣ
		ReservePara reservePara = new ReservePara(this.Sqlca);
		alReservePara = reservePara.getReservePara(sAccountMonth);
		if(!alReservePara.isEmpty())
		{				
			//��ƹ�ע�������ʧ��
			String sALossRate2 = (String)alReservePara.get(11);
			if(sALossRate2 == null || sALossRate2.equals(""))sALossRate2 = "0.0";
			dALossRate2 = DataConvert.toDouble(sALossRate2)/100.0;
			dMLossRate2 = dALossRate2;
			
			//��ƿھ�ʶ���ڼ�
			String sALossTerm = (String)alReservePara.get(2);
			if(sALossTerm == null || sALossTerm.equals(""))sALossTerm = "0.0";
			dALossTerm = DataConvert.toDouble(sALossTerm)/365.0;
			dMLossTerm = dALossTerm;
			
			//��ƿھ�����ϵ��
			String sAAdjustValue = (String)alReservePara.get(4);
			if(sAAdjustValue == null || sAAdjustValue.equals(""))sAAdjustValue = "0.0";
			dAAdjustValue = DataConvert.toDouble(sAAdjustValue);
			dMAdjustValue = dAAdjustValue;

			//dMLossRate2 = DataConvert.toDouble((String)alReservePara.get(6));//�����ע�������ʧ��
			//dALossRate2 = DataConvert.toDouble((String)alReservePara.get(11));//��ƹ�ע�������ʧ��
			//dMLossTerm = DataConvert.toDouble((String)alReservePara.get(1));//����ھ�ʶ���ڼ�
			//dALossTerm = DataConvert.toDouble((String)alReservePara.get(2));//��ƿھ�ʶ���ڼ�
			//dMAdjustValue = DataConvert.toDouble((String)alReservePara.get(3));//����ھ�����ϵ��
			//dAAdjustValue = DataConvert.toDouble((String)alReservePara.get(4));//��ƿھ�����ϵ�� 
		}
		
		if(sScope.equals("M")) //�����ھ�
		{
			/*
			��ע������ֵ׼��				
			=���ڻ���X(���ڱ���+������Ϣ����)X���ڹ�ע�������ʧ��X������ʧʶ���ڼ�X���ڵ���ϵ��*/
			dBCompReserveSum = dExchangeRate * (dBalance + dInterest) * dMLossRate2 * dMLossTerm * dMAdjustValue;
		}
		
		if(sScope.equals("A")) //��ƿھ�
		{
			/*
			��ע������ֵ׼��				
			=���ڻ���X(���ڱ���+������Ϣ����)X���ڹ�ע�������ʧ��X������ʧʶ���ڼ�X���ڵ���ϵ��*/
			dBCompReserveSum = dExchangeRate * (dBalance + dInterest) * dALossRate2 * dALossTerm * dAAdjustValue;
		}
		
		return dBCompReserveSum;
	}
    
    /**
     * ���˴����ϼ���
     * ���ݻ���·ݡ������ʺź�ͳ�ƿھ���ȡ��ע��������ϼ����ֵ׼��
     * @param alReserveTotal ����Ϊ������·ݡ������ʺš�......,sAccountMonth ����·�,sScope ͳ�ƿھ�
     * @return double ��ϼ����ֵ׼��
     */
    public double getPBCompReserveSum(ArrayList alReserveTotal,String sAccountMonth,String sScope) throws Exception
    {
        //�������      
        ArrayList alReservePara = new ArrayList();//��ż�ֵ���������Ϣ      
        double dBCompReserveSum = 0.0;//��Ź�ע��������ϼ����ֵ׼��
        double dExchangeRate = 0.0;//���ڻ���
        double dBalance = 0.0;//���ڱ���
        double dInterest = 0.0;//������Ϣ����
        double dMLossRate2 = 0.0;//�����ע�������ʧ��
        double dALossRate2 = 0.0;//��ƹ�ע�������ʧ��
        double dMAdjustValue = 0.0;//����ھ�����ϵ��
        double dAAdjustValue = 0.0;//��ƿھ�����ϵ��
        double dAOverDueDaysAdjust1 = 0.0;//��ƿھ���������ϵ��
        double dAOverDueDaysAdjust2 = 0.0;//��ƿھ�����1-30��������ϵ��
        double dAOverDueDaysAdjust3 = 0.0;//����31-90��������ϵ��
        double dAOverDueDaysAdjust4 = 0.0;//����91-180��������ϵ��
        double dAOverDueDaysAdjust5 = 0.0;//����181-360��������ϵ��
        double dAOverDueDaysAdjust6 = 0.0;//����360������������ϵ��
        double dTemp = 0.0;//������������ϵ��
        
        //��ô������ݿ������Ϣ
        dExchangeRate = DataConvert.toDouble((String)alReserveTotal.get(31));//���ڻ���
        dBalance = DataConvert.toDouble((String)alReserveTotal.get(30));//���ڱ���(Ŀǰ���)
        dInterest = DataConvert.toDouble((String)alReserveTotal.get(37));//������Ϣ����
        
        //��ȡ��Ӧ����·ݵļ�ֵ���������Ϣ
        ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
        alReservePara = reservePara.getReservePara(sAccountMonth);
        if(!alReservePara.isEmpty())
        {
            //��������������ʧ��
            String sALossRate2 = (String)alReservePara.get(3);
            if(sALossRate2 == null || sALossRate2.equals(""))sALossRate2 = "0.0";
            dALossRate2 = DataConvert.toDouble(sALossRate2)/100.0;
            dMLossRate2 = dALossRate2;
            
            //��ƿھ�����ϵ��
            String sAAdjustValue = (String)alReservePara.get(1);
            if(sAAdjustValue == null || sAAdjustValue.equals(""))sAAdjustValue = "0.0";
            dAAdjustValue = DataConvert.toDouble(sAAdjustValue);
            dMAdjustValue = dAAdjustValue;
            
            //��ƿھ�����ϵ��
            dAOverDueDaysAdjust1 = DataConvert.toDouble((String)alReservePara.get(4));
            dAOverDueDaysAdjust2 = DataConvert.toDouble((String)alReservePara.get(5));
            dAOverDueDaysAdjust3 = DataConvert.toDouble((String)alReservePara.get(6));
            dAOverDueDaysAdjust4 = DataConvert.toDouble((String)alReservePara.get(7));
            dAOverDueDaysAdjust5 = DataConvert.toDouble((String)alReservePara.get(8));
            dAOverDueDaysAdjust6 = DataConvert.toDouble((String)alReservePara.get(9));
           
            double dOverDueDays = DataConvert.toDouble((String)alReserveTotal.get(72));
            if(dOverDueDays>0 && dOverDueDays<=30){
                dTemp = dAOverDueDaysAdjust2;
            }
            else if(dOverDueDays>30 && dOverDueDays<=90){
                dTemp = dAOverDueDaysAdjust3;
            }
            else if(dOverDueDays>90 && dOverDueDays<=180){
                dTemp = dAOverDueDaysAdjust4;
            }
            else if(dOverDueDays>180 && dOverDueDays<=360){
                dTemp = dAOverDueDaysAdjust5;
            }
            else if(dOverDueDays>360){
                dTemp = dAOverDueDaysAdjust6;
            }else{
                dTemp = dAOverDueDaysAdjust1;
            }

        }   
        
        if(sScope.equals("M")) //�����ھ�
        {
            /*
            ��ע������ֵ׼��               
            =���ڻ���X(���ڱ���+������Ϣ����)X���ڹ�ע�������ʧ��X������ʧʶ���ڼ�X���ڵ���ϵ��*/
            dBCompReserveSum = dExchangeRate * (dBalance + dInterest) * dMLossRate2 * dMAdjustValue * dTemp;
        }
        
        if(sScope.equals("A")) //��ƿھ�
        {
            /*
            ��ע������ֵ׼��               
            =���ڻ���X(���ڱ���+������Ϣ����)X���ڹ�ע�������ʧ��X������ʧʶ���ڼ�X���ڵ���ϵ��*/
            dBCompReserveSum = dExchangeRate * (dBalance + dInterest) * dALossRate2 * dAAdjustValue * dTemp;
        }
        
        return dBCompReserveSum;
    }

	
	/**
	 * ���ݻ���·ݡ������ʺź�ͳ�ƿھ���ȡ��Ӧ�ĵ�������ֵ׼��
	 * @param alReserveTotal ����Ϊ������·ݡ������ʺš�......,sScope ͳ�ƿھ�
	 * @return double ��������ֵ׼��
	 */
	public double getSingleReserveSum(ArrayList alReserveTotal,String sScope) throws Exception
	{
		//�������			
		String sCurAccountMonth = "";//���ڻ���·�
		String sLoanAccountNo = "";//�����ʺ�
		double dSingleReserveSum = 0.0;//��ŵ�������ֵ׼����
		double dExchangeRate = 0.0;//���ڻ���
		double dBalance = 0.0;//���ڱ���
		double dInterest = 0.0;//������Ϣ����
        String sBusinessFlag = ""; //ҵ���ʶ 1-�Թ�����   2-���˴���
		String sMFiveClassify = "";//������弶����
		String sAFiveClassify = "";//����弶����
		double dTotalBadPrdDiscount = 0.0;//�����ֽ�������ֵ
		double dMBadPrdDiscount = 0.0;//���ڹ�����ֽ�������ֵ
		double dABadPrdDiscount = 0.0;//��������ֽ�������ֵ
		
		//��ô������ݿ������Ϣ
		sCurAccountMonth = (String)alReserveTotal.get(0);//����·�
		sLoanAccountNo = (String)alReserveTotal.get(1);//�����ʺ�
		dExchangeRate = DataConvert.toDouble((String)alReserveTotal.get(31));//���ڻ���
		dBalance = DataConvert.toDouble((String)alReserveTotal.get(30));//���ڱ���(Ŀǰ���)
		dInterest = DataConvert.toDouble((String)alReserveTotal.get(37));//������Ϣ����
		sMFiveClassify = (String)alReserveTotal.get(34);//������弶����
		sAFiveClassify = (String)alReserveTotal.get(35);//����弶����
        sBusinessFlag = (String)alReserveTotal.get(71);//ҵ���ʶ 1-�Թ�����   2-���˴���
		//����ֵת��Ϊ���ַ���
		if(sMFiveClassify == null) sMFiveClassify = "";
		if(sAFiveClassify == null) sAFiveClassify = "";
		//�����ֽ�������ֵ
		dTotalBadPrdDiscount = getTotalBadPrdDiscount(sCurAccountMonth,sLoanAccountNo,sBusinessFlag);
		//��ʧ�����Ĭ�ϱ����ֽ�������ֵΪ0
		if(!sMFiveClassify.equals("05"))
			dMBadPrdDiscount = dTotalBadPrdDiscount;
		if(!sAFiveClassify.equals("05"))
			dABadPrdDiscount = dTotalBadPrdDiscount;
				
		if(sScope.equals("M")) //�����ھ�
		{
			/*
			���������ֵ׼��
			=�������׼����
			=���ڻ���X(���ڱ���+������Ϣ����)-�����ֽ�������ֵ*/
			dSingleReserveSum = dExchangeRate * (dBalance + dInterest) - dMBadPrdDiscount;
		}
		
		if(sScope.equals("A")) //��ƿھ�
		{
			/*
			���������ֵ׼��
			=�������׼����
			=���ڻ���X(���ڱ���+������Ϣ����)-�����ֽ�������ֵ*/
			dSingleReserveSum = dExchangeRate * (dBalance + dInterest) - dABadPrdDiscount;
		}
		
		return dSingleReserveSum;
	}
	
	/**
	 * ��ñ��ڲ�������Ԥ���ֽ�������ֵ
	 * @param alReserveTotal ����Ϊ������·ݡ������ʺš�......
	 * @return ArrayList ����Ϊ�������ھ����������Ԥ���ֽ�������ֵ����ƿھ����������Ԥ���ֽ�������ֵ
	 */
	public ArrayList getCurPredictCapital(ArrayList alReserveTotal) throws Exception
	{
		//�������		
		ArrayList alCurPredictCapital = new ArrayList();//��Ź����ھ�����ƿھ��Ĳ��������Ԥ���ֽ�����Ϣ
		String sAccountMonth = "";//���ڻ���·�
		String sLoanAccountNo = "";//�����ʺ�
		String sMFiveClassify = "";//���ڹ�����弶����
		String sAFiveClassify = "";//��������弶����
        String sBusinessFlag = "";//ҵ���ʶ 1-�Թ�����   2-���˴���
		double dMTotalBadPrdDiscount = 0.0;//�����ھ����������Ԥ���ֽ�������ֵ
		double dATotalBadPrdDiscount = 0.0;//��ƿھ����������Ԥ���ֽ�������ֵ
		
		//��ȡ���ڴ������ݿ��������
		sAccountMonth = (String)alReserveTotal.get(0);//���ڻ���·�
		sLoanAccountNo = (String)alReserveTotal.get(1);//�����ʺ�
		sMFiveClassify = (String)alReserveTotal.get(34);//���ڹ�����弶����		
		sAFiveClassify = (String)alReserveTotal.get(35);//��������弶����
        sBusinessFlag = (String)alReserveTotal.get(71);//ҵ���ʶ 1-�Թ�����   2-���˴���
		//����ֵת��Ϊ���ַ���
		if(sMFiveClassify == null) sMFiveClassify = "";
		if(sAFiveClassify == null) sAFiveClassify = "";
		
		//����������Ҫ���㱾���ֽ�������ֵ
		if(!sMFiveClassify.equals("01") && !sMFiveClassify.equals("02") || !sAFiveClassify.equals("01") && !sAFiveClassify.equals("02"))
		{
			//��ʧ�����Ĭ�ϱ����ֽ�������ֵΪ0����������������Ҫ���չ�ʽ����
			if(!sMFiveClassify.equals("05") && !sAFiveClassify.equals("05")) //�����ھ�����ƿھ�����Ϊ��ʧ�࣬�����ֽ�������ֵ��ȣ���Ϊ��ʽ��������
			{
				dMTotalBadPrdDiscount = getTotalBadPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);
				dATotalBadPrdDiscount = dMTotalBadPrdDiscount;
			}else if(sMFiveClassify.equals("05") && !sAFiveClassify.equals("05"))//�����ھ�Ϊ��ʧ�࣬����ƿھ�����Ϊ��ʧ�࣬������ھ������ֽ�������ֵΪ0������ƿھ������ֽ�������ֵ���ڹ�ʽ��������
			{
				dATotalBadPrdDiscount = getTotalBadPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);
			}else if(!sMFiveClassify.equals("05") && sAFiveClassify.equals("05"))//�����ھ���Ϊ��ʧ�࣬����ƿھ���Ϊ��ʧ�࣬����ƿھ������ֽ�������ֵΪ0���������ھ������ֽ�������ֵ���ڹ�ʽ��������
			{
				dMTotalBadPrdDiscount = getTotalBadPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);
			}
		}
		
		alCurPredictCapital.add(0, String.valueOf(dMTotalBadPrdDiscount));
		alCurPredictCapital.add(1, String.valueOf(dATotalBadPrdDiscount));
		
		return alCurPredictCapital;
	}
	
	/**
	 * ��ñ��ڲ�������Ԥ���ֽ�������ֵ
	 * @param alReserveTotal ����Ϊ������·ݡ������ʺš�......
	 * @return ArrayList ����Ϊ�������ھ����������Ԥ���ֽ�������ֵ����ƿھ����������Ԥ���ֽ�������ֵ
	 */
	public double getCurPredictCapital(ArrayList alReserveTotal, String sScope) throws Exception
	{
		//�������		
		String sAccountMonth = "";//���ڻ���·�
		String sLoanAccountNo = "";//�����ʺ�
		String sFiveClassify = "";//�����弶����
		String sBusinessFlag = "";//ҵ���ʶ 1-�Թ�����   2-���˴���
		double dTotalBadPrdDiscount = 0.0;//���������Ԥ���ֽ�������ֵ
		
		//��ȡ���ڴ������ݿ��������
		sAccountMonth = (String)alReserveTotal.get(0);//���ڻ���·�
		sLoanAccountNo = (String)alReserveTotal.get(1);//�����ʺ�
        sBusinessFlag = (String)alReserveTotal.get(71);//ҵ���ʶ 1-�Թ�����   2-���˴���
		if(sScope.equals("M")){
			sFiveClassify = (String)alReserveTotal.get(34);//���ڹ�����弶����
		}else{
			sFiveClassify = (String)alReserveTotal.get(35);//��������弶����
		}
		//����ֵת��Ϊ���ַ���
		if(sFiveClassify == null) sFiveClassify = "";
		
		//����������Ҫ���㱾���ֽ�������ֵ, ��ʧ�����Ĭ�ϱ����ֽ�������ֵΪ0
		if(sFiveClassify.equals("03") || sFiveClassify.equals("04")){
			dTotalBadPrdDiscount = getTotalBadPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);				
		}
		
		return dTotalBadPrdDiscount;
	}

	/**
	 * ���ݲ��������Ԥ���ֽ�����ò��������Ԥ���ֽ�������ֵ
	 * @param sAccountMonth ����·ݣ�sLoanAccountNo �����ʺ�
	 * @return double ���������Ԥ���ֽ�������ֵ
	 */
	public double getTotalBadPrdDiscount(String sAccountMonth,String sLoanAccountNo,String sBusinessFlag) throws Exception
	{
		//�������
		Vector vPredictCapital = new Vector();//��Ż���·ݺʹ����ʺŶ�ӦԤ���ֽ�����Ϣ
		ArrayList alPredictCapital = new ArrayList();//���ÿһ��Ԥ���ֽ�����Ϣ
		ArrayList alReservePara = new ArrayList();//��ŵ�ǰ����·ݵļ�ֵ׼������
		String sBaseDate = "";//��׼����
		String sReturnDate = "";//Ԥ���ջ�����
		String sGrade = ""; //Ԥ���ֽ���ʹ�õļ���
		double dDiscountRate = 0.0;//������(���������ݿ��еĴ���ʵ������)
		double dDueSum = 0.0;//ÿ�ʱ���Ԥ���ֽ���
		double dTotalBadPrdDiscount = 0.0;//��������Ԥ���ֽ�������ֵ�ϼ�ֵ
		double dBadPrdDiscount = 0.0;//ÿ�ʲ�������Ԥ���ֽ�������ֵ
		
		//�����Ӧ����·ݵļ�ֵ׼������
        if("1".equals(sBusinessFlag)){
    		ReservePara reservePara = new ReservePara(this.Sqlca);
    		alReservePara = reservePara.getReservePara(sAccountMonth);
    		if(!alReservePara.isEmpty()){
    			sBaseDate = (String)alReservePara.get(29);
    		    sGrade = (String)alReservePara.get(31);
    		    if(sGrade.equals(""))sGrade = "04";//04-�����϶����
    		}
        }else{
            ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
            alReservePara = reservePara.getReservePara(sAccountMonth);
            if(!alReservePara.isEmpty()){
                sBaseDate = (String)alReservePara.get(29);
                sGrade = (String)alReservePara.get(31);
                if(sGrade.equals(""))sGrade = "04";//04-�����϶����
            }
        }
		//��û���·ݵ���Ч�ֽ������ݣ��������������GradeΪ05��
		ReservePredictData reservePredictData = new ReservePredictData(this.Sqlca);
		vPredictCapital = reservePredictData.getPredictCapital(sAccountMonth,sLoanAccountNo,sGrade);
		if(!vPredictCapital.isEmpty())
		{
			for(int i=0;i<vPredictCapital.size();i++)
			{
				alPredictCapital = (ArrayList)vPredictCapital.get(i);
				if(!alPredictCapital.isEmpty())
				{
					sReturnDate = (String)alPredictCapital.get(1);
					dDiscountRate = DataConvert.toDouble((String)alPredictCapital.get(12));
					dDueSum = DataConvert.toDouble((String)alPredictCapital.get(11));
					//��ȡÿ��Ԥ���ֽ���������ֵ
					dBadPrdDiscount = getBadPrdDiscount(dDueSum,sReturnDate,sBaseDate,dDiscountRate);
					//dBadPrdDiscount = DataConvert.toDouble((String)alPredictCapital.get(13));
				}
				dTotalBadPrdDiscount += dBadPrdDiscount;
			}
		}
		
		return dTotalBadPrdDiscount;
	}
	
	/**
	 * ��ñ��ڲ�����������Ԥ���ֽ�����������ֵ
	 * @param alLastReserveTotal ����·ݣ���һ�ڣ���Ӧ�Ĵ������ݿ�������ݡ�alCurReserveTotal ����·ݣ����ڣ���Ӧ�Ĵ������ݿ��������
	 * @return ArrayList ����Ϊ�������ھ�����������һ��Ԥ���ֽ�����������ֵ����ƿھ�����������һ��Ԥ���ֽ�����������ֵ
	 */
	public ArrayList getLastPredictCapital(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal) throws Exception
	{
		//�������		
		ArrayList alLastPredictCapital = new ArrayList();//��Ź����ھ�����ƿھ��Ĳ�����������Ԥ���ֽ�����������ֵ��Ϣ
		String sAccountMonth = "";//���ڻ���·�
		String sLoanAccountNo = "";//�����ʺ�
		String sLastMFiveClassify = "";//���ڹ�����弶����
		String sLastAFiveClassify = "";//��������弶����
        String sLastManageStatFlag = "";//���ڼ��᷽ʽ
		double dMTotalBadLastPrdDiscount = 0.0;//�����ھ�����������һ��Ԥ���ֽ�����������ֵ
		double dATotalBadLastPrdDiscount = 0.0;//��ƿھ�����������һ��Ԥ���ֽ�����������ֵ
		String sBusinessFlag = "";////ҵ���ʶ 1-�Թ�����   2-���˴���
		//��ȡ���ڴ������ݿ��������
		sAccountMonth = (String)alCurReserveTotal.get(0);//���ڻ���·�
		sLoanAccountNo = (String)alCurReserveTotal.get(1);//�����ʺ�
		//��ȡ���ڴ������ݿ��������
		sLastMFiveClassify = (String)alLastReserveTotal.get(34);//���ڹ�����弶����		
		sLastAFiveClassify = (String)alLastReserveTotal.get(35);//��������弶����
        sLastManageStatFlag = (String)alLastReserveTotal.get(70);//���ڼ��᷽ʽ
        sBusinessFlag = (String)alCurReserveTotal.get(71);//ҵ���ʶ 1-�Թ�����   2-���˴���
		//����ֵת��Ϊ���ַ���
		if(sLastMFiveClassify == null) sLastMFiveClassify = "";
		if(sLastAFiveClassify == null) sLastAFiveClassify = "";
		
		
        
		if(sLastManageStatFlag.equals("2"))//���ʼ��ᣬ���ڲ���������Ҫ��������Ԥ���ֽ�����������ֵ
		{
			//�����ڴ���Ĺ����ھ�����ƿھ��弶����Ϊ��ʧ�࣬�����²�����Ԥ���ֽ������������Ԥ���ֽ�����������ֵ����֮����Ҫ���չ�ʽ����
			if(!sLastMFiveClassify.equals("05") && !sLastAFiveClassify.equals("05")) //�����ھ�����ƿھ�����Ϊ��ʧ�࣬������Ԥ���ֽ�����������ֵ��ȣ���Ϊ��ʽ��������
			{
				dMTotalBadLastPrdDiscount = getTotalBadLastPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);
				dATotalBadLastPrdDiscount = dMTotalBadLastPrdDiscount;
			}else if(!sLastMFiveClassify.equals("05") && sLastAFiveClassify.equals("05")) //�����ھ�����Ԥ���ֽ�����������ֵΪ��ʽ�������ã���ƿھ�����Ԥ���ֽ�����������ֵΪ0
			{
				dMTotalBadLastPrdDiscount = getTotalBadLastPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);
			}else if(sLastMFiveClassify.equals("05") && !sLastAFiveClassify.equals("05")) //��ƿھ�����Ԥ���ֽ�����������ֵΪ��ʽ�������ã�����������Ԥ���ֽ�����������ֵ��Ϊ0
			{
				dATotalBadLastPrdDiscount = getTotalBadLastPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);
			}
		}
		
		alLastPredictCapital.add(0, String.valueOf(dMTotalBadLastPrdDiscount));
		alLastPredictCapital.add(1, String.valueOf(dATotalBadLastPrdDiscount));
		
		return alLastPredictCapital;
	}

	/**
	 * ��ñ��ڲ�����������Ԥ���ֽ�����������ֵ
	 * @param alLastReserveTotal ����·ݣ���һ�ڣ���Ӧ�Ĵ������ݿ�������ݡ�alCurReserveTotal ����·ݣ����ڣ���Ӧ�Ĵ������ݿ��������
	 * @return ArrayList ����Ϊ�������ھ�����������һ��Ԥ���ֽ�����������ֵ����ƿھ�����������һ��Ԥ���ֽ�����������ֵ
	 */
	public double getLastPredictCapital(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal, String sScope) throws Exception
	{
		//�������		
		String sAccountMonth = "";//���ڻ���·�
		String sLoanAccountNo = "";//�����ʺ�
		String sLastFiveClassify = "";//�����弶����
        String sLastManageStatFlag = "";//���ڼ��᷽ʽ
        String sBusinessFlag = "";//ҵ���ʶ 1-�Թ�����   2-���˴���
		double dTotalBadLastPrdDiscount = 0.0;//����������һ��Ԥ���ֽ�����������ֵ
		//��ȡ���ڴ������ݿ��������
		sAccountMonth = (String)alCurReserveTotal.get(0);//���ڻ���·�
		sLoanAccountNo = (String)alCurReserveTotal.get(1);//�����ʺ�
        
        sBusinessFlag = (String)alCurReserveTotal.get(71);//ҵ���ʶ 1-�Թ�����   2-���˴���
		//��ȡ���ڴ������ݿ��������
		if(sScope.equals("M")){
			sLastFiveClassify = (String)alLastReserveTotal.get(34);//���ڹ�����弶����
		}else{
			sLastFiveClassify = (String)alLastReserveTotal.get(35);//��������弶����
		}
        sLastManageStatFlag = (String)alLastReserveTotal.get(70);//���ڼ��᷽ʽ
		//����ֵת��Ϊ���ַ���
		if(sLastFiveClassify == null) sLastFiveClassify = "";
		
		//���ڴ���Ϊ���ʼ���, ��ʧ�࣬�����²�����Ԥ���ֽ���
		if(sLastManageStatFlag.equals("2") && !sLastFiveClassify.equals("05")){
				dTotalBadLastPrdDiscount = getTotalBadLastPrdDiscount(sAccountMonth,sLoanAccountNo,sBusinessFlag);
		}
		
		return dTotalBadLastPrdDiscount;
	}

	/**
	 * ���ݲ���������һ��Ԥ���ֽ�����ò���������һ��Ԥ���ֽ�����������ֵ
	 * @param sCurAccountMonth ����·ݣ����ڣ���sLoanAccountNo �����ʺ�
	 * @return double ����������һ��Ԥ���ֽ�����������ֵ
	 */
	public double getTotalBadLastPrdDiscount(String sCurAccountMonth,String sLoanAccountNo,String sBusinessFlag) throws Exception
	{
		//�������
		Vector vPredictCapital = new Vector();//��Ż���·ݺʹ����ʺŶ�ӦԤ���ֽ�����Ϣ
		ArrayList alPredictCapital = new ArrayList();//���ÿһ��Ԥ���ֽ�����Ϣ
		ArrayList alReservePara = new ArrayList();//��ŵ�ǰ����·ݵļ�ֵ׼������
		ArrayList alLastReservePara = new ArrayList();//������ڻ���·ݵļ�ֵ׼������
		String sLastAccountMonth = "";//����·ݣ���һ�ڣ�
		String sLastGrade = "";//��һ�ڸ��¼�ֵ׼��ʹ�õ��ֽ�������
		String sBaseDate = "";//��׼����
		String sReturnDate = "";//Ԥ���ջ�����
		double dDiscountRate = 0.0;//������(���������ݿ��еĴ���ʵ������)
		double dDueSum = 0.0;//ÿ�ʱ���Ԥ���ֽ���
		double dTotalBadPrdDiscount = 0.0;//��������Ԥ���ֽ�������ֵ�ϼ�ֵ
		double dBadPrdDiscount = 0.0;//ÿ�ʲ�������Ԥ���ֽ�������ֵ
		if("1".equals(sBusinessFlag)){
    		//�����Ӧ����·ݵļ�ֵ׼������
    		ReservePara reservePara = new ReservePara(this.Sqlca);
    		alReservePara = reservePara.getReservePara(sCurAccountMonth);
    		if(!alReservePara.isEmpty())
    		{
    			sBaseDate = (String)alReservePara.get(29);
    			sLastAccountMonth = (String)alReservePara.get(30);
    		}
    		
    		alLastReservePara = reservePara.getReservePara(sLastAccountMonth);
    		if(!alLastReservePara.isEmpty())
    		{
    			sLastGrade = (String)alReservePara.get(31);
    			if(sLastGrade.equals(""))sLastGrade = "04";//04-�����϶����
    		}
        }else{
            //�����Ӧ����·ݵļ�ֵ׼������
            ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
            alReservePara = reservePara.getReservePara(sCurAccountMonth);
            if(!alReservePara.isEmpty())
            {
                sBaseDate = (String)alReservePara.get(10);
                sLastAccountMonth = (String)alReservePara.get(11);
            }
            
            alLastReservePara = reservePara.getReservePara(sLastAccountMonth);
            if(!alLastReservePara.isEmpty())
            {
                sLastGrade = (String)alReservePara.get(12);
                if(sLastGrade.equals(""))sLastGrade = "04";//04-�����϶����
            }
            
        }
		
		//��ȡ����·ݣ���һ�ڣ�����Ч�ֽ������ݣ��������������GradeΪ05��
		ReservePredictData reservePredictData = new ReservePredictData(this.Sqlca);
		vPredictCapital = reservePredictData.getPredictCapital(sLastAccountMonth,sLoanAccountNo,sLastGrade);
		if(!vPredictCapital.isEmpty())
		{
			for(int i=0;i<vPredictCapital.size();i++)
			{
				alPredictCapital = (ArrayList)vPredictCapital.get(i);
				if(!alPredictCapital.isEmpty())
				{
					sReturnDate = (String)alPredictCapital.get(1);
					dDiscountRate = DataConvert.toDouble((String)alPredictCapital.get(12));
					dDueSum = DataConvert.toDouble((String)alPredictCapital.get(11));
					//��ȡÿ��Ԥ���ֽ���������ֵ
					dBadPrdDiscount = getBadPrdDiscount(dDueSum,sReturnDate,sBaseDate,dDiscountRate);
				}
				dTotalBadPrdDiscount += dBadPrdDiscount;
			}
		}
		
		return dTotalBadPrdDiscount;
	}
		
	/**
	 * ���ݲ�������ÿ�ʱ���Ԥ���ֽ�����ò�������ÿ�ʱ���Ԥ���ֽ�������ֵ
	 * @param dDueSum ÿ�ʱ���Ԥ���ֽ���,sReturnDate Ԥ���ջ�����,sBaseDate ��׼����,dDiscountRate ������(���������ݿ��еĴ���ʵ������)
	 * @return double ��������ÿ�ʱ���Ԥ���ֽ�������ֵ
	 */
	private double getBadPrdDiscount(double dDueSum,String sReturnDate,String sBaseDate,double dDiscountRate) throws Exception
	{
		//�������
		double dBadPrdDiscount = 0.0;//��������Ԥ���ֽ�������ֵ		
		double dYears = 0.0;//����
					
		//��Ԥ���ջ��������׼����֮���ʱ�������Ϊ��
		dYears = StringDeal.getQuot(sReturnDate, sBaseDate) / 365.0;
		
		//���ݼ��㹫ʽ��ci/��1+r��^yi�������Ӧ�Ĳ�������Ԥ���ֽ�������ֵ
		dBadPrdDiscount = dDueSum / Math.pow((1 + dDiscountRate/100.0),dYears);
		
		return dBadPrdDiscount;
	}
			
	/**
	 * ���ñʴ���Ϊ������������ʱ�������ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 * @param alReserveTotal ����Ϊ������·ݡ������ʺš�......
	 * @return ArrayList ����Ϊ����ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 */
	public ArrayList ReserveCalculateFormula1(ArrayList alReserveTotal) throws Exception
	{
		//�������
		ArrayList alReserveCalculateData = new ArrayList();//��ż�ֵ׼���������Ϣ
		String sCurAccountMonth = "";//���ڻ���·�
		String sMFiveClassify = "";//������弶����
		String sAFiveClassify = "";//����弶����
        String sManageStatFlag = "";//���᷽ʽ 1-��Ϸ�ʽ  2-���ʼ���
        String sBusinessFlag = "";//ҵ���ʶ 1-�Թ�����   2-���˴���
		
		//�����ֶ�Ϊ�������ݿ��е�Ҫ��	
		double dMCancelReserveSum = 0.0;//�����ھ����ں�����ֵ׼��
		double dACancelReserveSum = 0.0;//��ƿھ����ں�����ֵ׼��
		double dMExforLoss = 0.0;//�����ھ����ڴ���������
		double dAExforLoss = 0.0;//��ƿھ����ڴ���������
		double dMBadReserveSum = 0.0;//�����ھ���������ڼ����ֵ׼��
		double dMBadMinusSum = 0.0;//�����ھ���������ڳ�����ֵ׼��
		double dMBadRetSum = 0.0;//�����ھ����������ת�ؼ�ֵ׼��
		double dABadReserveSum = 0.0;//��ƿھ���������ڼ����ֵ׼��
		double dABadMinusSum = 0.0;//��ƿھ���������ڳ�����ֵ׼��
		double dABadRetSum = 0.0;//��ƿھ����������ת�ؼ�ֵ׼��
		double dMNormalReserveSum = 0.0;//�����ھ���������ڼ����ֵ׼��
		double dMNormalMinusSum = 0.0;//�����ھ���������ڳ�����ֵ׼��
		double dANormalReserveSum = 0.0;//��ƿھ���������ڼ����ֵ׼��
		double dANormalMinusSum = 0.0;//��ƿھ���������ڳ�����ֵ׼��
		
		//��ô������ݱ��������
		sCurAccountMonth = (String)alReserveTotal.get(0);//����·�
		sMFiveClassify = (String)alReserveTotal.get(34);//������弶����		
		sAFiveClassify = (String)alReserveTotal.get(35);//����弶����
        sManageStatFlag = (String)alReserveTotal.get(70);//���᷽ʽ 1-��Ϸ�ʽ  2-���ʼ���
        sBusinessFlag = (String)alReserveTotal.get(71);//ҵ���ʶ 1-�Թ�����   2-���˴���
		//����ֵת��Ϊ���ַ���
		if(sMFiveClassify == null) sMFiveClassify = "";
		if(sAFiveClassify == null) sAFiveClassify = "";
        if(sBusinessFlag == null) sBusinessFlag = "";
		
		//���չ�����弶����ھ����м���
        if(sManageStatFlag.equals("1")){//��Ϸ�ʽ
    		if(sMFiveClassify.equals("01"))//0Ϊ����
    		{
    			//��ȡ��ϼ���׼���𣬼�������ھ���������ڼ����ֵ׼��
                if(sBusinessFlag.equals("1")){//�Թ�����
                    dMNormalReserveSum = getACompReserveSum(alReserveTotal,sCurAccountMonth,"M");
                }else{//���˴���
                    dMNormalReserveSum = getPACompReserveSum(alReserveTotal,sCurAccountMonth,"M");
                }
    		}else if(sMFiveClassify.equals("02"))//02Ϊ��ע
    		{
    			//��ȡ��ϼ���׼���𣬼�������ھ���������ڼ����ֵ׼��
                if(sBusinessFlag.equals("1")){//�Թ�����
                    dMNormalReserveSum = getBCompReserveSum(alReserveTotal,sCurAccountMonth,"M");
                }else{//���˴���
                    dMNormalReserveSum = getPBCompReserveSum(alReserveTotal,sCurAccountMonth,"M");
                }
    		}
        }
		else//���ʼ���  03Ϊ�μ���04Ϊ���ɡ�05Ϊ��ʧ
		{
			//��ȡ�������׼���𣬼�������ھ���������ڼ����ֵ׼��
			dMBadReserveSum = getSingleReserveSum(alReserveTotal,"M");
		}
				
		//������ƿھ��弶����ھ����м���
        if(sManageStatFlag.equals("1")){//��Ϸ�ʽ
    		if(sAFiveClassify.equals("01"))//01Ϊ����
    		{
    			//��ȡ��ϼ���׼���𣬼�����ƿھ���������ڼ����ֵ׼��
                if(sBusinessFlag.equals("1")){//�Թ�����
                    dANormalReserveSum = getACompReserveSum(alReserveTotal,sCurAccountMonth,"A");
                }else{//���˴���
                    dANormalReserveSum = getPACompReserveSum(alReserveTotal,sCurAccountMonth,"A");
                }
                
    		}else if(sAFiveClassify.equals("02"))//02Ϊ��ע
    		{
    			//��ȡ��ϼ���׼���𣬼�����ƿھ���������ڼ����ֵ׼��
                if(sBusinessFlag.equals("1")){//�Թ�����
                    dANormalReserveSum = getBCompReserveSum(alReserveTotal,sCurAccountMonth,"A");
                }else{//���˴���
                    dANormalReserveSum = getPBCompReserveSum(alReserveTotal,sCurAccountMonth,"A");
                }
            }
		}else//���ʼ���  03Ϊ�μ���04Ϊ���ɡ�05Ϊ��ʧ
		{
			//��ȡ�������׼���𣬼�����ƿھ���������ڼ����ֵ׼��
			dABadReserveSum = getSingleReserveSum(alReserveTotal,"A");
		}
		
		//�����������õ����ݴ����alReserveCalculateData��
		alReserveCalculateData.add(0, String.valueOf(dMCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dACancelReserveSum));
		alReserveCalculateData.add(2, String.valueOf(dMExforLoss));	
		alReserveCalculateData.add(3, String.valueOf(dAExforLoss));		
		alReserveCalculateData.add(4, String.valueOf(dMBadReserveSum));
		alReserveCalculateData.add(5, String.valueOf(dMBadMinusSum));
		alReserveCalculateData.add(6, String.valueOf(dMBadRetSum));		
		alReserveCalculateData.add(7, String.valueOf(dABadReserveSum));
		alReserveCalculateData.add(8, String.valueOf(dABadMinusSum));
		alReserveCalculateData.add(9, String.valueOf(dABadRetSum));		
		alReserveCalculateData.add(10, String.valueOf(dMNormalReserveSum));		
		alReserveCalculateData.add(11, String.valueOf(dMNormalMinusSum));		
		alReserveCalculateData.add(12, String.valueOf(dANormalReserveSum));
		alReserveCalculateData.add(13, String.valueOf(dANormalMinusSum));		
		
		return alReserveCalculateData;
	}
	
	/**
	 * ������ĳ�ʴ������ȫ�ջ�ʱ�������ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 * @param alLastReserveTotal ����·ݣ���һ�ڣ���Ӧ�Ĵ������ݿ�������ݡ�alCurReserveTotal ����·ݣ����ڣ���Ӧ�Ĵ������ݿ��������
	 * @return ArrayList ����Ϊ����ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 */
	public ArrayList ReserveCalculateFormula2(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal) throws Exception
	{
		//�������
		ArrayList alReserveCalculateData = new ArrayList();//��ż�ֵ׼���������Ϣ
		//double dLastMBadReserveSum = 0.0;//���ڵĹ����ھ�������������ֵ׼��
		//double dLastABadReserveSum = 0.0;//���ڵ���ƿھ�������������ֵ׼��
		//double dLastMNormalReserveSum = 0.0;//���ڵĹ����ھ���������ڼ����ֵ׼��
		//double dLastANormalReserveSum = 0.0;//���ڵ���ƿھ���������ڼ����ֵ׼��
		double dLastMBadReserveBalance = 0.0;//���ڹ����ھ����������ֵ׼�����
		double dLastABadReserveBalance = 0.0;//������ƿھ����������ֵ׼�����
		double dLastMNormalReserveBalance = 0.0;//���ڹ����ھ���������ڼ�ֵ׼�����
		double dLastANormalReserveBalance = 0.0;//������ƿھ���������ڼ�ֵ׼�����		
		double dLastBalance = 0.0;//���ڵ�Ŀǰ��ԭ�ң�
		double dLastInterest = 0.0;//���ڵ���Ϣ����
		double dLastExchangeRate = 0.0;//���ڵĻ���
		double dExchangeRate = 0.0;//���ڻ���
		double dLastMReserveBalance = 0.0; //��������ڼ���ļ�ֵ׼�����
		double dLastAReserveBalance = 0.0; //��Ʋ����ڼ���ļ�ֵ׼�����
		String sLastMFiveClassify = "";//���ڵĹ�����弶����
		String sLastAFiveClassify = "";//���ڵ�����弶����
        String sLastManageStatFlag = "";//���ڼ��᷽ʽ 1-��Ϸ�ʽ  2-���ʼ���
        String sCurBusinessFlag = "";//����ҵ���ʶ 1-�Թ�����   2-���˴���
		//�����ֶ�Ϊ�������ݿ��е�Ҫ��	
		double dMCancelReserveSum = 0.0;//�����ھ����ں�����ֵ׼��
		double dACancelReserveSum = 0.0;//��ƿھ����ں�����ֵ׼��
		double dMExforLoss = 0.0;//�����ھ����ڴ���������
		double dAExforLoss = 0.0;//��ƿھ����ڴ���������
		double dMBadReserveSum = 0.0;//�����ھ���������ڼ����ֵ׼��
		double dMBadMinusSum = 0.0;//�����ھ���������ڳ�����ֵ׼��������Ϊ�����ھ����������ת�ؼ�ֵ׼��
		double dMBadRetSum = 0.0;//�����ھ����������ת�ؼ�ֵ׼��--�����ھ�������������ֻز���ֵ׼��
		double dABadReserveSum = 0.0;//��ƿھ���������ڼ����ֵ׼��
		double dABadMinusSum = 0.0;//��ƿھ���������ڳ�����ֵ׼��
		double dABadRetSum = 0.0;//��ƿھ����������ת�ؼ�ֵ׼��
		double dMNormalReserveSum = 0.0;//�����ھ���������ڼ����ֵ׼��
		double dMNormalMinusSum = 0.0;//�����ھ���������ڳ�����ֵ׼��
		double dANormalReserveSum = 0.0;//��ƿھ���������ڼ����ֵ׼��
		double dANormalMinusSum = 0.0;//��ƿھ���������ڳ�����ֵ׼��
	
		//������ڴ������ݿ��������
        sCurBusinessFlag = (String)alCurReserveTotal.get(71);//����ҵ���ʶ 1-�Թ�����   2-���˴���
		//dLastMBadReserveSum = DataConvert.toDouble((String)alLastReserveTotal.get(47));//���ڵĹ����ھ�������������ֵ׼��
		//dLastABadReserveSum = DataConvert.toDouble((String)alLastReserveTotal.get(53));//���ڵ���ƿھ�������������ֵ׼��
		//dLastMNormalReserveSum = DataConvert.toDouble((String)alLastReserveTotal.get(58));//���ڵĹ����ھ���������ڼ����ֵ׼��
		//dLastANormalReserveSum = DataConvert.toDouble((String)alLastReserveTotal.get(61));//���ڵ���ƿھ���������ڼ����ֵ׼��
		dLastBalance = DataConvert.toDouble((String)alLastReserveTotal.get(30));//���ڵ�Ŀǰ��ԭ�ң�
		dLastInterest = DataConvert.toDouble((String)alLastReserveTotal.get(37));//���ڵ���Ϣ����
		dLastExchangeRate = DataConvert.toDouble((String)alLastReserveTotal.get(31));//���ڵĻ���
		sLastMFiveClassify = (String)alLastReserveTotal.get(34);//���ڹ�����弶����
		sLastAFiveClassify = (String)alLastReserveTotal.get(35);//��������弶����
        sLastManageStatFlag = (String)alLastReserveTotal.get(70);//���ڼ��᷽ʽ
		dLastMBadReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(51));//�����ھ���������ڼ�ֵ׼�����
		dLastABadReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(57));//��ƿھ���������ڼ�ֵ׼�����
		dLastMNormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(60));//�����ھ���������ڼ�ֵ׼�����
		dLastANormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(63));//��ƿھ���������ڼ�ֵ׼�����
		
		//��ñ��ڴ������ݿ��������
		dExchangeRate = DataConvert.toDouble((String)alCurReserveTotal.get(31));//���ڻ���
		
		//���ݼ��㹫ʽ������Ӧ����ļ�ֵ׼��+(����ԭ�ұ���+����ԭ����Ϣ����)�������ڻ��ʣ����ڻ��ʣ�����ù����ھ���������ڳ�����ֵ׼��
		//dMBadMinusSum = dLastMBadReserveSum + (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
		
		//���ݼ��㹫ʽ������Ӧ����ļ�ֵ׼��+(����ԭ�ұ���+����ԭ����Ϣ����)�������ڻ��ʣ����ڻ��ʣ��������ƿھ���������ڳ�����ֵ׼��
		//dABadMinusSum = dLastABadReserveSum + (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
		
		//���ݼ��㹫ʽ������Ӧ����ļ�ֵ׼��+(����ԭ�ұ���+����ԭ����Ϣ����)�������ڻ��ʣ����ڻ��ʣ�����ù����ھ���������ڳ�����ֵ׼��
		//dMNormalMinusSum = dLastMNormalReserveSum + (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
		
		//���ݼ��㹫ʽ������Ӧ����ļ�ֵ׼��+(����ԭ�ұ���+����ԭ����Ϣ����)�������ڻ��ʣ����ڻ��ʣ��������ƿھ���������ڳ�����ֵ׼��
		//dANormalMinusSum = dLastANormalReserveSum + (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
		
		//���ݼ��㹫ʽ��(��������������ϼ���׼����������ڻ���/���ڻ���-1������ù����ھ����ڴ������������ƿھ����ڴ���������
        if(sLastManageStatFlag.equals("1")){//��ϼ���
    		if(sLastMFiveClassify.equals("01")|| sLastMFiveClassify.equals("02")){
    		    dMExforLoss = dLastMNormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
    		    dLastMReserveBalance = dLastMNormalReserveBalance;
    			//���ݼ��㹫ʽ (����ת�ؼ�ֵ׼��=����Ӧ����ļ�ֵ׼�������ڼ�ֵ׼�������)��ȡ����㱾��ת�ؼ�ֵ׼������Ʊ���ת�ؼ�ֵ׼��
    			dMNormalMinusSum = dLastMReserveBalance + dMExforLoss;
    		}
        }else{
			//���ݼ��㹫ʽ��(����ԭ�ұ���+����ԭ����Ϣ����)�������ڻ��ʣ����ڻ��ʣ�����ù����ھ����ڴ������������ƿھ����ڴ���������
			dMExforLoss = (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
			//���ݼ��㹫ʽ ���ڼ�ֵ׼�����ֻز�=(�����ֽ�����������ֵ-�����ֽ�������ֵ)
			dMBadRetSum = getTotalBadLastPrdDiscount((String)alCurReserveTotal.get(0),(String)alCurReserveTotal.get(1),sCurBusinessFlag)- getTotalBadPrdDiscount((String)alLastReserveTotal.get(0),(String)alLastReserveTotal.get(1),(String)alLastReserveTotal.get(71));
			dLastMReserveBalance = dLastMBadReserveBalance;
			//���ݼ��㹫ʽ (����ת�ؼ�ֵ׼��=����Ӧ����ļ�ֵ׼�������ڼ�ֵ׼������𣭱��ڼ�ֵ׼�����ֻز�)��ȡ����㱾��ת�ؼ�ֵ׼������Ʊ���ת�ؼ�ֵ׼��
			dMBadMinusSum = dLastMReserveBalance + dMExforLoss - dMBadRetSum;
		}
		
        if(sLastManageStatFlag.equals("1")){//��ϼ���
    		if(sLastAFiveClassify.equals("01")|| sLastAFiveClassify.equals("02")){
    		    dAExforLoss = dLastANormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
    		    dLastAReserveBalance = dLastANormalReserveBalance;
    			//���ݼ��㹫ʽ (����ת�ؼ�ֵ׼��=����Ӧ����ļ�ֵ׼�������ڼ�ֵ׼�������)��ȡ����㱾��ת�ؼ�ֵ׼������Ʊ���ת�ؼ�ֵ׼��
    			dANormalMinusSum = dLastAReserveBalance + dAExforLoss;
    		}
        }else{
			//���ݼ��㹫ʽ��(����ԭ�ұ���+����ԭ����Ϣ����)�������ڻ��ʣ����ڻ��ʣ�����ù����ھ����ڴ������������ƿھ����ڴ���������
			dAExforLoss = (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
			//���ݼ��㹫ʽ ���ڼ�ֵ׼�����ֻز�=(�����ֽ�����������ֵ-�����ֽ�������ֵ)
			dABadRetSum = getTotalBadLastPrdDiscount((String)alCurReserveTotal.get(0),(String)alCurReserveTotal.get(1),sCurBusinessFlag)- getTotalBadPrdDiscount((String)alLastReserveTotal.get(0),(String)alLastReserveTotal.get(1),(String)alLastReserveTotal.get(71));
			dLastAReserveBalance = dLastABadReserveBalance;
			//���ݼ��㹫ʽ (����ת�ؼ�ֵ׼��=����Ӧ����ļ�ֵ׼�������ڼ�ֵ׼������𣭱��ڼ�ֵ׼�����ֻز�)��ȡ����㱾��ת�ؼ�ֵ׼������Ʊ���ת�ؼ�ֵ׼��
			dABadMinusSum = dLastAReserveBalance + dAExforLoss - dABadRetSum;
		}
				
		//�����������õ����ݴ����alReserveCalculateData��
		alReserveCalculateData.add(0, String.valueOf(dMCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dACancelReserveSum));
		alReserveCalculateData.add(2, String.valueOf(dMExforLoss));	
		alReserveCalculateData.add(3, String.valueOf(dAExforLoss));	
		alReserveCalculateData.add(4, String.valueOf(dMBadReserveSum));
		alReserveCalculateData.add(5, String.valueOf(dMBadMinusSum));
		alReserveCalculateData.add(6, String.valueOf(dMBadRetSum));		
		alReserveCalculateData.add(7, String.valueOf(dABadReserveSum));
		alReserveCalculateData.add(8, String.valueOf(dABadMinusSum));
		alReserveCalculateData.add(9, String.valueOf(dABadRetSum));		
		alReserveCalculateData.add(10, String.valueOf(dMNormalReserveSum));		
		alReserveCalculateData.add(11, String.valueOf(dMNormalMinusSum));		
		alReserveCalculateData.add(12, String.valueOf(dANormalReserveSum));
		alReserveCalculateData.add(13, String.valueOf(dANormalMinusSum));		
		
		return alReserveCalculateData;
	}
	
	/**
	 * ������ĳ�ʴ������ȫ����ʱ�������ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 * @param alLastReserveTotal ����·ݣ���һ�ڣ���Ӧ�Ĵ������ݿ�������ݡ�alCurReserveTotal ����·ݣ����ڣ���Ӧ�Ĵ������ݿ��������
	 * @return ArrayList ����Ϊ����ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 */
	public ArrayList ReserveCalculateFormula3(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal) throws Exception
	{
		//�������
		ArrayList alReserveCalculateData = new ArrayList();//��ż�ֵ׼���������Ϣ
		//double dLastMBadReserveSum = 0.0;//���ڵĹ����ھ���������ڼ����ֵ׼��
		//double dLastABadReserveSum = 0.0;//���ڵ���ƿھ���������ڼ����ֵ׼��
		double dLastMBadReserveBalance = 0.0;//���ڹ����ھ����������ֵ׼�����
		double dLastABadReserveBalance = 0.0;//������ƿھ����������ֵ׼�����
		double dLastMNormalReserveBalance = 0.0;//���ڹ����ھ���������ڼ�ֵ׼�����
		double dLastANormalReserveBalance = 0.0;//������ƿھ���������ڼ�ֵ׼�����		
		double dLastBalance = 0.0;//���ڵ�Ŀǰ��ԭ�ң�
		double dLastInterest = 0.0;//���ڵ���Ϣ����
		double dLastExchangeRate = 0.0;//���ڵĻ���
		double dExchangeRate = 0.0;//���ڻ���
		double dLastMReserveBalance = 0.0; //��������ڼ���ļ�ֵ׼�����
		double dLastAReserveBalance = 0.0; //��Ʋ����ڼ���ļ�ֵ׼�����
		String sLastMFiveClassify = "";//���ڵĹ�����弶����
		String sLastAFiveClassify = "";//���ڵ�����弶����
        String sLastManageStatFlag = "";//���ڼ��᷽ʽ 1-��Ϸ�ʽ  2-���ʼ���
						
		//�����ֶ�Ϊ�������ݿ��е�Ҫ��	
		double dMCancelReserveSum = 0.0;//�����ھ����ں�����ֵ׼��
		double dACancelReserveSum = 0.0;//��ƿھ����ں�����ֵ׼��
		double dMExforLoss = 0.0;//�����ھ����ڴ���������
		double dAExforLoss = 0.0;//��ƿھ����ڴ���������
		double dMBadReserveSum = 0.0;//�����ھ���������ڼ����ֵ׼��
		double dMBadMinusSum = 0.0;//�����ھ���������ڳ�����ֵ׼��
		double dMBadRetSum = 0.0;//�����ھ����������ת�ؼ�ֵ׼��
		double dABadReserveSum = 0.0;//��ƿھ���������ڼ����ֵ׼��
		double dABadMinusSum = 0.0;//��ƿھ���������ڳ�����ֵ׼��
		double dABadRetSum = 0.0;//��ƿھ����������ת�ؼ�ֵ׼��
		double dMNormalReserveSum = 0.0;//�����ھ���������ڼ����ֵ׼��
		double dMNormalMinusSum = 0.0;//�����ھ���������ڳ�����ֵ׼��
		double dANormalReserveSum = 0.0;//��ƿھ���������ڼ����ֵ׼��
		double dANormalMinusSum = 0.0;//��ƿھ���������ڳ�����ֵ׼��
		
		//������ڴ������ݿ��������
		//dLastMBadReserveSum = DataConvert.toDouble((String)alLastReserveTotal.get(47));//���ڵĹ����ھ���������ڼ����ֵ׼��
		//dLastABadReserveSum = DataConvert.toDouble((String)alLastReserveTotal.get(53));//���ڵ���ƿھ���������ڼ����ֵ׼��
		dLastBalance = DataConvert.toDouble((String)alLastReserveTotal.get(30));//���ڵ�Ŀǰ��ԭ�ң�
		dLastInterest = DataConvert.toDouble((String)alLastReserveTotal.get(37));//���ڵ���Ϣ����
		dLastExchangeRate = DataConvert.toDouble((String)alLastReserveTotal.get(31));//���ڵĻ���
		sLastMFiveClassify = (String)alLastReserveTotal.get(34);//���ڹ�����弶����
		sLastAFiveClassify = (String)alLastReserveTotal.get(35);//��������弶����
        sLastManageStatFlag = (String)alLastReserveTotal.get(70);//���ڼ��᷽ʽ
		dLastMBadReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(51));//�����ھ���������ڼ�ֵ׼�����
		dLastABadReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(57));//��ƿھ���������ڼ�ֵ׼�����
		dLastMNormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(60));//�����ھ���������ڼ�ֵ׼�����
		dLastANormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(63));//��ƿھ���������ڼ�ֵ׼�����
		
		//��ñ��ڴ������ݿ��������
		dExchangeRate = DataConvert.toDouble((String)alCurReserveTotal.get(31));//���ڻ���
		
		//���ݼ��㹫ʽ������Ӧ����ļ�ֵ׼��+(����ԭ�ұ���+����ԭ����Ϣ����)�������ڻ��ʣ����ڻ��ʣ�����ù����ھ����ں�����ֵ׼��
		//dMCancelReserveSum = dLastMBadReserveSum + (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
		
		//���ݼ��㹫ʽ������Ӧ����ļ�ֵ׼��+(����ԭ�ұ���+����ԭ����Ϣ����)�������ڻ��ʣ����ڻ��ʣ��������ƿھ����ں�����ֵ׼��
		//dACancelReserveSum = dLastABadReserveSum + (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
		
		//���ݼ��㹫ʽ��(����ԭ�ұ���+����ԭ����Ϣ����)�������ڻ��ʣ����ڻ��ʣ�����ù����ھ����ڴ������������ƿھ����ڴ���������
		dMExforLoss = (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
		dAExforLoss = dMExforLoss;
       
		//���ݼ��㹫ʽ��(��������������ϼ���׼����������ڻ���/���ڻ���-1������ù����ھ����ڴ������������ƿھ����ڴ���������
        if(sLastManageStatFlag.equals("1")){//��ϼ���
    		if(sLastMFiveClassify.equals("01")|| sLastMFiveClassify.equals("02")){
    		    dMExforLoss = dLastMNormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
    		    dLastMReserveBalance = dLastMNormalReserveBalance;
    		}
        }else{
			//���ݼ��㹫ʽ��(����ԭ�ұ���+����ԭ����Ϣ����)�������ڻ��ʣ����ڻ��ʣ�����ù����ھ����ڴ������������ƿھ����ڴ���������
			dMExforLoss = (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
			//���ݼ��㹫ʽ ���ڼ�ֵ׼�����ֻز�=(�����ֽ�����������ֵ-�����ֽ�������ֵ)
			dMBadRetSum = getTotalBadLastPrdDiscount((String)alCurReserveTotal.get(0),(String)alCurReserveTotal.get(1),(String)alCurReserveTotal.get(71))- getTotalBadPrdDiscount((String)alLastReserveTotal.get(0),(String)alLastReserveTotal.get(1),(String)alLastReserveTotal.get(71));
			dLastMReserveBalance = dLastMBadReserveBalance;
		}
		
        if(sLastManageStatFlag.equals("1")){//��ϼ���
    		if(sLastAFiveClassify.equals("01")|| sLastAFiveClassify.equals("02")){
    		    dAExforLoss = dLastANormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
    		    dLastAReserveBalance = dLastANormalReserveBalance;
    		}
        }else{
			//���ݼ��㹫ʽ��(����ԭ�ұ���+����ԭ����Ϣ����)�������ڻ��ʣ����ڻ��ʣ�����ù����ھ����ڴ������������ƿھ����ڴ���������
			dAExforLoss = (dLastBalance + dLastInterest) * (dExchangeRate - dLastExchangeRate);
			//���ݼ��㹫ʽ ���ڼ�ֵ׼�����ֻز�=(�����ֽ�����������ֵ-�����ֽ�������ֵ)
			dABadRetSum = getTotalBadLastPrdDiscount((String)alCurReserveTotal.get(0),(String)alCurReserveTotal.get(1),(String)alCurReserveTotal.get(71))- getTotalBadPrdDiscount((String)alLastReserveTotal.get(0),(String)alLastReserveTotal.get(1),(String)alLastReserveTotal.get(71));
			dLastAReserveBalance = dLastABadReserveBalance;
		}
		
		//���ݼ��㹫ʽ (���ں�����ֵ׼��=����Ӧ����ļ�ֵ׼�������ڼ�ֵ׼������𣭱��ڼ�ֵ׼�����ֻز�)��ȡ����㱾��ת�ؼ�ֵ׼������Ʊ���ת�ؼ�ֵ׼��
		dMCancelReserveSum = dLastMReserveBalance + dMExforLoss - dMBadRetSum;
		dACancelReserveSum = dLastAReserveBalance + dAExforLoss - dABadRetSum;
		
		//�����������õ����ݴ����alReserveCalculateData��
		alReserveCalculateData.add(0, String.valueOf(dMCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dACancelReserveSum));
		alReserveCalculateData.add(2, String.valueOf(dMExforLoss));	
		alReserveCalculateData.add(3, String.valueOf(dAExforLoss));
		alReserveCalculateData.add(4, String.valueOf(dMBadReserveSum));
		alReserveCalculateData.add(5, String.valueOf(dMBadMinusSum));
		alReserveCalculateData.add(6, String.valueOf(dMBadRetSum));		
		alReserveCalculateData.add(7, String.valueOf(dABadReserveSum));
		alReserveCalculateData.add(8, String.valueOf(dABadMinusSum));
		alReserveCalculateData.add(9, String.valueOf(dABadRetSum));		
		alReserveCalculateData.add(10, String.valueOf(dMNormalReserveSum));		
		alReserveCalculateData.add(11, String.valueOf(dMNormalMinusSum));		
		alReserveCalculateData.add(12, String.valueOf(dANormalReserveSum));
		alReserveCalculateData.add(13, String.valueOf(dANormalMinusSum));		
		
		return alReserveCalculateData;
	}
		
	/**
	 * ��ĳ�ʴ�������Ϊ�����������Ϊ��������ʱ�������ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 * @param alLastReserveTotal ����·ݣ���һ�ڣ���Ӧ�Ĵ������ݿ�������ݡ�alCurReserveTotal ����·ݣ����ڣ���Ӧ�Ĵ������ݿ��������
	 * @return ArrayList ����Ϊ����ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 */
	public ArrayList ReserveCalculateFormula4(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal, String sScope) throws Exception
	{
		//�������
		ArrayList alReserveCalculateData = new ArrayList();//��ż�ֵ׼���������Ϣ		
		String sCurAccountMonth = "";//��ǰ����·�
		String sLoanAccountNo = "";//�����ʺ�
		double dBalance = 0.0;//����Ŀǰ��ԭ�ң�
		double dInterest = 0.0;//������Ϣ����		
		double dExchangeRate = 0.0;//���ڻ���
		double dLastNormalReserveBalance = 0.0;//������������ڼ�ֵ׼�����
		double dLastExchangeRate = 0.0;//���ڵĻ���
		String sBusinessFlag = "";//			ҵ���ʶ 1-�Թ�����   2-���˴���	
		//�����ֶ�Ϊ�������ݿ��е�Ҫ��	
		double dCancelReserveSum = 0.0;//���ں�����ֵ׼��
		double dExforLoss = 0.0;//���ڴ���������
		double dBadReserveSum = 0.0;//��������ڼ����ֵ׼��
		double dBadMinusSum = 0.0;//��������ڳ�����ֵ׼��
		double dBadRetSum = 0.0;//���������ת�ؼ�ֵ׼��
		double dNormalReserveSum = 0.0;//��������ڼ����ֵ׼��
		double dNormalMinusSum = 0.0;//��������ڳ�����ֵ׼��
        sBusinessFlag = (String)alCurReserveTotal.get(71);//ҵ���ʶ 1-�Թ�����   2-���˴���
		//������ڴ������ݿ��������
		if(sScope.equals("M")){//�����
			dLastNormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(60));
		}else{//��Ʋ�
			dLastNormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(63));
		}
		dLastExchangeRate = DataConvert.toDouble((String)alLastReserveTotal.get(31));//���ڵĻ���
		//��ñ��ڴ������ݿ��������
		sCurAccountMonth = (String)alCurReserveTotal.get(0);//����·�
		sLoanAccountNo = (String)alCurReserveTotal.get(1);//�����ʺ�
		dBalance = DataConvert.toDouble((String)alCurReserveTotal.get(30));//����Ŀǰ��ԭ�ң�
		dInterest = DataConvert.toDouble((String)alCurReserveTotal.get(37));//������Ϣ����		
		dExchangeRate = DataConvert.toDouble((String)alCurReserveTotal.get(31));//���ڻ���
        if(dLastExchangeRate==0){
            dLastExchangeRate =1;
        }
						
		//���ݼ��㹫ʽ����������������ϼ���׼��������ڻ���/���ڻ��ʣ���ù����ھ���������ڳ�����ֵ׼��
		dNormalMinusSum = dLastNormalReserveBalance * dExchangeRate / dLastExchangeRate;
		//���ݼ��㹫ʽ�����ڻ��ʡ�(���ڱ���+������Ϣ����)-�����ֽ�������ֵ����ù����ھ���������ڼ����ֵ׼��
		dBadReserveSum = dExchangeRate * (dBalance + dInterest) - getTotalBadPrdDiscount(sCurAccountMonth,sLoanAccountNo,sBusinessFlag);
				
		//���ݼ��㹫ʽ��(��������������ϼ���׼����������ڻ���/���ڻ���-1������ù����ھ����ڴ������������ƿھ����ڴ���������
		dExforLoss = dLastNormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
				
		//�����������õ����ݴ����alReserveCalculateData��
		alReserveCalculateData.add(0, String.valueOf(dCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dExforLoss));	
		alReserveCalculateData.add(2, String.valueOf(dBadReserveSum));
		alReserveCalculateData.add(3, String.valueOf(dBadMinusSum));
		alReserveCalculateData.add(4, String.valueOf(dBadRetSum));		
		alReserveCalculateData.add(5, String.valueOf(dNormalReserveSum));		
		alReserveCalculateData.add(6, String.valueOf(dNormalMinusSum));		
		
		return alReserveCalculateData;
	}

	/**
	 * ��ĳ�ʴ�������Ϊ�����������Ϊ��������ʱ�������ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 * @param alLastReserveTotal ����·ݣ���һ�ڣ���Ӧ�Ĵ������ݿ�������ݡ�alCurReserveTotal ����·ݣ����ڣ���Ӧ�Ĵ������ݿ��������
	 * @return ArrayList ����Ϊ����ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 */
	public ArrayList ReserveCalculateFormula5(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal, String sScope) throws Exception
	{
		//�������
		ArrayList alReserveCalculateData = new ArrayList();//��ż�ֵ׼���������Ϣ
		ArrayList alReservePara = new ArrayList();//��ż�ֵ׼���Ĳ���
		String sCurAccountMonth = "";//���ڻ���·�
		String sLastAccountMonth = "";//���ڻ���·�
		String sLoanAccountNo = "";//�����ʺ�
		double dExchangeRate = 0.0;//���ڻ���
		String sFiveClassify = "";//�弶����
        String sBusinessFlag = "";//ҵ���ʶ 1-�Թ�����   2-���˴���
		double dLastBadReserveBalance = 0.0;//���ڲ��������ֵ׼�����
		double dLastBalance = 0.0;//���ڵ�Ŀǰ��ԭ�ң�
		double dLastInterest = 0.0;//���ڵ���Ϣ����
		double dLastExchangeRate = 0.0;//���ڵĻ���
								
		//�����ֶ�Ϊ�������ݿ��е�Ҫ��	
		double dCancelReserveSum = 0.0;//���ں�����ֵ׼��
		double dExforLoss = 0.0;//���ڴ���������
		double dBadReserveSum = 0.0;//��������ڼ����ֵ׼��
		double dBadMinusSum = 0.0;//��������ڳ�����ֵ׼��
		double dBadRetSum = 0.0;//���������ת�ؼ�ֵ׼��
		double dNormalReserveSum = 0.0;//��������ڼ����ֵ׼��
		double dNormalMinusSum = 0.0;//��������ڳ�����ֵ׼��
		
		//��ñ��ڴ������ݿ������Ϣ
		sCurAccountMonth = (String)alCurReserveTotal.get(0);//���ڻ���·�
		sLoanAccountNo  = (String)alCurReserveTotal.get(1);//�����ʺ�
		dExchangeRate = DataConvert.toDouble((String)alCurReserveTotal.get(31));//���ڻ���
        sBusinessFlag = (String)alLastReserveTotal.get(71);//ҵ���ʶ 1-�Թ�����   2-���˴���
		if(sScope.equals("M")){
			sFiveClassify = (String)alCurReserveTotal.get(34);//������弶����
			dLastBadReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(51));//���ڹ����ھ����������ֵ׼�����
		}else{
			sFiveClassify = (String)alCurReserveTotal.get(35);//����弶����
			dLastBadReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(57));//������ƿھ����������ֵ׼�����
		}
		//����ֵת��Ϊ���ַ���
		if(sFiveClassify == null) sFiveClassify = "";
        if(sBusinessFlag == null) sBusinessFlag = "";
		
		//������ڴ������ݿ������Ϣ
		dLastBalance = DataConvert.toDouble((String)alLastReserveTotal.get(30));//���ڵ�Ŀǰ��ԭ�ң�
		dLastInterest = DataConvert.toDouble((String)alLastReserveTotal.get(37));//���ڵ���Ϣ����
		dLastExchangeRate = DataConvert.toDouble((String)alLastReserveTotal.get(31));//���ڵĻ���

        //�����Ӧ����·ݵļ�ֵ׼������
        if("1".equals(sBusinessFlag)){
            ReservePara reservePara = new ReservePara(this.Sqlca);
            alReservePara = reservePara.getReservePara(sCurAccountMonth);
            if(!alReservePara.isEmpty())
                sLastAccountMonth = (String)alReservePara.get(30);
        }else{
            ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
            alReservePara = reservePara.getReservePara(sCurAccountMonth);
            if(!alReservePara.isEmpty())
                sLastAccountMonth = (String)alReservePara.get(11);
        }
		//��������ֽ�������ֵ
		double dLastTotalBadPrdDiscount = getTotalBadPrdDiscount(sLastAccountMonth,sLoanAccountNo,sBusinessFlag);
		if(sScope.equals("M")){//�����
			if(((String)alLastReserveTotal.get(34)).equals("05")){
				dLastTotalBadPrdDiscount = 0.0;
			}
		}else{//��Ʋ�
			if(((String)alLastReserveTotal.get(35)).equals("05")){
				dLastTotalBadPrdDiscount = 0.0;
			}			
		}
		//��������ֽ�����������ֵ
		double dTotalBadLastPrdDiscount = getTotalBadLastPrdDiscount(sCurAccountMonth,sLoanAccountNo,(String)alCurReserveTotal.get(71));
		if(sScope.equals("M")){//�����
			if(((String)alLastReserveTotal.get(34)).equals("05")){
				dTotalBadLastPrdDiscount = 0.0;
			}
		}else{//��Ʋ�
			if(((String)alLastReserveTotal.get(35)).equals("05")){
				dTotalBadLastPrdDiscount = 0.0;
			}			
		}
		
		//���ݼ��㹫ʽ�������ֽ�����������ֵ-�����ֽ�������ֵ����ù����ھ����������ת�ؼ�ֵ׼������ƿھ����������ת�ؼ�ֵ׼��
		dBadRetSum = dTotalBadLastPrdDiscount - dLastTotalBadPrdDiscount;

		//���ݼ��㹫ʽ�����ڲ�����������׼����+�����ڻ���-���ڻ��ʣ���(���ڱ���+������Ϣ����)�����ڼ�ֵ׼�����ֻز�����ù����ھ���������ڳ�����ֵ׼��
		dBadMinusSum = dLastBadReserveBalance + (dExchangeRate - dLastExchangeRate) * (dLastBalance + dLastInterest) - dBadRetSum;
				
		//�����弶����ھ����м���
		if(sFiveClassify.equals("01"))//0Ϊ����
		{
			//��ȡ��ϼ���׼���𣬼�����������ڼ����ֵ׼��
            if(sBusinessFlag.equals("1")){//�Թ�����
                dNormalReserveSum = getACompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }else{
                dNormalReserveSum = getPACompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }
		}else if(sFiveClassify.equals("02"))//02Ϊ��ע
		{
			//��ȡ��ϼ���׼���𣬼�����������ڼ����ֵ׼��
            if(sBusinessFlag.equals("1")){//�Թ�����
                dNormalReserveSum = getBCompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }else{//���˴���
                dNormalReserveSum = getPBCompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }
		}
										
		//���ݼ��㹫ʽ�������ڻ���-���ڻ��ʣ���(���ڱ���+������Ϣ����)����ñ��ڴ���������
		dExforLoss = (dExchangeRate - dLastExchangeRate) * (dLastBalance + dLastInterest);
		
		//�����������õ����ݴ����alReserveCalculateData��
		alReserveCalculateData.add(0, String.valueOf(dCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dExforLoss));	
		alReserveCalculateData.add(2, String.valueOf(dBadReserveSum));
		alReserveCalculateData.add(3, String.valueOf(dBadMinusSum));
		alReserveCalculateData.add(4, String.valueOf(dBadRetSum));		
		alReserveCalculateData.add(5, String.valueOf(dNormalReserveSum));		
		alReserveCalculateData.add(6, String.valueOf(dNormalMinusSum));		
		
		return alReserveCalculateData;
	}

	/**
	 * ��ĳ�ʴ�������Ϊ�����������Ϊ��������ʱ�������ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 * @param alLastReserveTotal ����·ݣ���һ�ڣ���Ӧ�Ĵ������ݿ�������ݡ�alCurReserveTotal ����·ݣ����ڣ���Ӧ�Ĵ������ݿ��������
	 * @return ArrayList ����Ϊ����ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 */
	public ArrayList ReserveCalculateFormula6(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal, String sScope) throws Exception
	{
		//�������
		ArrayList alReserveCalculateData = new ArrayList();//��ż�ֵ׼���������Ϣ
		ArrayList alReservePara = new ArrayList();//��ż�ֵ׼���Ĳ���
		String sCurAccountMonth = "";//��ǰ����·�
		String sLastAccountMonth = "";//���ڻ���·�
		double dLastExchangeRate = 0.0;//���ڵĻ���
		double dLastNormalReserveBalance = 0.0;//��������������ϼ���׼����
		double dCurNormalReserveBalance = 0.0;//��������������ϼ���׼����
		double dExchangeRate = 0.0;//���ڻ���
		String sFiveClassify = "";//�弶����
        String sBusinessFlag = "";//ҵ���ʶ 1-�Թ�����   2-���˴���
		double dCurCalculateSum = 0.0;//���ݹ�ʽ��ü�����
		
						
		//�����ֶ�Ϊ�������ݿ��е�Ҫ��	
		double dCancelReserveSum = 0.0;//���ں�����ֵ׼��
		double dExforLoss = 0.0;//���ڴ���������
		double dBadReserveSum = 0.0;//��������ڼ����ֵ׼��
		double dBadMinusSum = 0.0;//��������ڳ�����ֵ׼��
		double dBadRetSum = 0.0;//���������ת�ؼ�ֵ׼��
		double dNormalReserveSum = 0.0;//��������ڼ����ֵ׼��
		double dNormalMinusSum = 0.0;//��������ڳ�����ֵ׼��
		
		//��ñ��ڴ������ݿ������Ϣ
		sCurAccountMonth = (String)alCurReserveTotal.get(0);//����·�
		dExchangeRate = DataConvert.toDouble((String)alCurReserveTotal.get(31));//���ڻ���
		if(sScope.equals("M")){
			sFiveClassify = (String)alCurReserveTotal.get(34);//������弶����
			dLastNormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(60));//���ڹ����ھ�����������ϼ���׼����
		}
		else{
			sFiveClassify = (String)alCurReserveTotal.get(35);//����弶����
			dLastNormalReserveBalance = DataConvert.toDouble((String)alLastReserveTotal.get(63));//������ƿھ�����������ϼ���׼����
		}
        sBusinessFlag = (String)alCurReserveTotal.get(71);//ҵ���ʶ 1-�Թ�����   2-���˴���
		//����ֵת��Ϊ���ַ���
		if(sFiveClassify == null) sFiveClassify = "";
        if(sBusinessFlag == null) sBusinessFlag = "";
		dLastExchangeRate = DataConvert.toDouble((String)alLastReserveTotal.get(31));//���ڵĻ���
		if(dLastExchangeRate == 0){//��ֹ������������ĸΪ��
            dLastExchangeRate = 1 ;      
        }
		
		//�����弶����ھ����м���
		if(sFiveClassify.equals("01"))//0Ϊ����
		{
			//��ñ�������������ϼ���׼����
            if(sBusinessFlag.equals("1")){//�Թ�����
                dCurNormalReserveBalance = getACompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }else{
                dCurNormalReserveBalance = getPACompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }
		}else if(sFiveClassify.equals("02"))//02Ϊ��ע
		{
			//��ñ�������������ϼ���׼����
            if(sBusinessFlag.equals("1")){//�Թ�����
                dCurNormalReserveBalance = getBCompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }else{//���˴���
                dCurNormalReserveBalance = getPBCompReserveSum(alCurReserveTotal,sCurAccountMonth,sScope);
            }
		}
								
		//���ݼ��㹫ʽ����������������ϼ���׼����-��������������ϼ���׼����-��������������ϼ���׼����������ڻ���/���ڻ���-1������ù����ھ�����������ƿھ�������
		dCurCalculateSum = dCurNormalReserveBalance - dLastNormalReserveBalance - dLastNormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
		
		//�������ھ�����������0������ݼ��㹫ʽ����������������ϼ���׼����-��������������ϼ���׼����-��������������ϼ���׼����������ڻ���/���ڻ���-1������ù����ھ���������ڼ����ֵ׼��
		if(dCurCalculateSum > 0)
			dNormalReserveSum = dCurNormalReserveBalance - dLastNormalReserveBalance - dLastNormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
		else //��֮�����ݼ��㹫ʽ����������������ϼ���׼����+��������������ϼ���׼����������ڻ���/���ڻ���-1��-��������������ϼ���׼���𣩻�ù����ھ���������ڳ�����ֵ׼��
			dNormalMinusSum = dLastNormalReserveBalance + dLastNormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1) - dCurNormalReserveBalance;
						
		//���ݼ��㹫ʽ����������������ϼ���׼����������ڻ���/���ڻ���-1������ù����ھ����ڴ������������ƿھ����ڴ���������
		dExforLoss = dLastNormalReserveBalance * (dExchangeRate / dLastExchangeRate - 1);
				
		//�����������õ����ݴ����alReserveCalculateData��
		alReserveCalculateData.add(0, String.valueOf(dCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dExforLoss));
		alReserveCalculateData.add(2, String.valueOf(dBadReserveSum));
		alReserveCalculateData.add(3, String.valueOf(dBadMinusSum));
		alReserveCalculateData.add(4, String.valueOf(dBadRetSum));		
		alReserveCalculateData.add(5, String.valueOf(dNormalReserveSum));		
		alReserveCalculateData.add(6, String.valueOf(dNormalMinusSum));		
		
		return alReserveCalculateData;
	}

	/**
	 * ��ĳ�ʴ�������Ϊ�����������Ϊ��������ʱ�������ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 * @param alLastReserveTotal ����·ݣ���һ�ڣ���Ӧ�Ĵ������ݿ�������ݡ�alCurReserveTotal ����·ݣ����ڣ���Ӧ�Ĵ������ݿ��������
	 * @return ArrayList ����Ϊ����ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 */
	private ArrayList ReserveCalculateFormula7(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal,String sBusinessFlag) throws Exception
	{
		//�������
		ArrayList alReserveCalculateData = new ArrayList();//��ż�ֵ׼���������Ϣ
		ArrayList alReservePara = new ArrayList();//��ż�ֵ׼���Ĳ���
		String sCurAccountMonth = "";//��ǰ����·�
		String sLastAccountMonth = "";//���ڻ���·�
		String sLoanAccountNo = "";//�����ʺ�
		double dBalance = 0.0;//���ڵ�Ŀǰ��ԭ�ң�
		double dInterest = 0.0;//���ڵ���Ϣ����
		double dExchangeRate = 0.0;//���ڻ���
		double dCurTotalBadPrdDiscount = 0.0;//�����ֽ�������ֵ
		double dTotalBadLastPrdDiscount = 0.0;//�����ֽ�����������ֵ		
		double dLastTotalBadPrdDiscount = 0.0;//�����ֽ�������ֵ
		double dLastBalance = 0.0;//���ڵ�Ŀǰ��ԭ�ң�
		double dLastInterest = 0.0;//���ڵ���Ϣ����
		double dLastExchangeRate = 0.0;//���ڵĻ���
		//double dCurCalculateSum = 0.0;//���ݹ�ʽ��ü�����
						
		//�����ֶ�Ϊ�������ݿ��е�Ҫ��	
		double dMCancelReserveSum = 0.0;//�����ھ����ں�����ֵ׼��
		double dACancelReserveSum = 0.0;//��ƿھ����ں�����ֵ׼��
		double dMExforLoss = 0.0;//�����ھ��������
		double dAExforLoss = 0.0;//��ƿھ��������		
		double dMBadReserveSum = 0.0;//�����ھ���������ڼ����ֵ׼��
		double dMBadMinusSum = 0.0;//�����ھ���������ڳ�����ֵ׼��
		double dMBadRetSum = 0.0;//�����ھ����������ת�ؼ�ֵ׼��
		double dABadReserveSum = 0.0;//��ƿھ���������ڼ����ֵ׼��
		double dABadMinusSum = 0.0;//��ƿھ���������ڳ�����ֵ׼��
		double dABadRetSum = 0.0;//��ƿھ����������ת�ؼ�ֵ׼��
		double dMNormalReserveSum = 0.0;//�����ھ���������ڼ����ֵ׼��
		double dMNormalMinusSum = 0.0;//�����ھ���������ڳ�����ֵ׼��
		double dANormalReserveSum = 0.0;//��ƿھ���������ڼ����ֵ׼��
		double dANormalMinusSum = 0.0;//��ƿھ���������ڳ�����ֵ׼��
		String sCurBusinessFlag = "";//����ҵ���ʶ 1-�Թ�����   2-���˴���
		String sLastBusinessFlag = "";//����ҵ���ʶ 1-�Թ�����   2-���˴���
		//��ȡ��ǰ�Ļ���·�
		sCurAccountMonth = (String)alCurReserveTotal.get(0);
		sLoanAccountNo = (String)alCurReserveTotal.get(1);//��ȡ�����ʺ�
        sLastBusinessFlag = (String)alLastReserveTotal.get(71);//ҵ���ʶ 1-�Թ�����   2-���˴���
        sCurBusinessFlag = (String)alCurReserveTotal.get(71);//ҵ���ʶ 1-�Թ�����   2-���˴���
        //�����Ӧ����·ݵļ�ֵ׼������
        if("1".equals(sBusinessFlag)){
            ReservePara reservePara = new ReservePara(this.Sqlca);
            alReservePara = reservePara.getReservePara(sCurAccountMonth);
            if(!alReservePara.isEmpty())
                sLastAccountMonth = (String)alReservePara.get(30);
        }else{
            ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
            alReservePara = reservePara.getReservePara(sCurAccountMonth);
            if(!alReservePara.isEmpty())
                sLastAccountMonth = (String)alReservePara.get(11);
        }
		
		//��ñ����ֽ�������ֵ
		dCurTotalBadPrdDiscount = getTotalBadPrdDiscount(sCurAccountMonth,sLoanAccountNo,sCurBusinessFlag);
		double dMCurTotalBadPrdDiscount = dCurTotalBadPrdDiscount;//�����
		double dACurTotalBadPrdDiscount = dCurTotalBadPrdDiscount;//��Ʋ�
		if(((String)alCurReserveTotal.get(34)).equals("05")){
			dMCurTotalBadPrdDiscount = 0.0;
		}
		if(((String)alCurReserveTotal.get(35)).equals("05")){
			dACurTotalBadPrdDiscount = 0.0;
		}
		//��������ֽ�������ֵ
		dLastTotalBadPrdDiscount = getTotalBadPrdDiscount(sLastAccountMonth,sLoanAccountNo,sLastBusinessFlag);
		double dMLastTotalBadPrdDiscount = dLastTotalBadPrdDiscount;//�����
		double dALastTotalBadPrdDiscount = dLastTotalBadPrdDiscount;//��Ʋ�
		if(((String)alLastReserveTotal.get(34)).equals("05")){
			dMLastTotalBadPrdDiscount = 0.0;
		}
		if(((String)alLastReserveTotal.get(35)).equals("05")){
			dALastTotalBadPrdDiscount = 0.0;
		}
		//��������ֽ�����������ֵ
		dTotalBadLastPrdDiscount = getTotalBadLastPrdDiscount(sCurAccountMonth,sLoanAccountNo,(String)alCurReserveTotal.get(71));
		double dMTotalBadLastPrdDiscount = dTotalBadLastPrdDiscount;//�����
		double dATotalBadLastPrdDiscount = dTotalBadLastPrdDiscount;//��Ʋ�
		if(((String)alLastReserveTotal.get(34)).equals("05")){
			dMTotalBadLastPrdDiscount = 0.0;
		}
		if(((String)alLastReserveTotal.get(35)).equals("05")){
			dATotalBadLastPrdDiscount = 0.0;
		}
		
		//������ڵ�Ŀǰ��ԭ�ң�
		dLastBalance = DataConvert.toDouble((String)alLastReserveTotal.get(30));
		//������ڵ���Ϣ����
		dLastInterest = DataConvert.toDouble((String)alLastReserveTotal.get(37));
		//������ڵĻ���
		dLastExchangeRate = DataConvert.toDouble((String)alLastReserveTotal.get(31));
		//��ñ��ڵ�Ŀǰ��ԭ�ң�
		dBalance = DataConvert.toDouble((String)alCurReserveTotal.get(30));
		//��ñ��ڵ���Ϣ����
		dInterest = DataConvert.toDouble((String)alCurReserveTotal.get(37));
		//��ñ��ڻ���
		dExchangeRate = DataConvert.toDouble((String)alCurReserveTotal.get(31));
		
		//���ݼ��㹫ʽ��[�����ڱ���+������Ϣ������-�����ڱ���+������Ϣ������]�����ڻ���+�������ֽ�����������ֵ-�����ֽ�������ֵ������ü�����
		//dCurCalculateSum = ((dBalance + dInterest) - (dLastBalance + dLastInterest)) * dExchangeRate + (dTotalBadLastPrdDiscount - dCurTotalBadPrdDiscount);
		double dMCurCalculateSum = ((dBalance + dInterest) - (dLastBalance + dLastInterest)) * dExchangeRate + (dMTotalBadLastPrdDiscount - dMCurTotalBadPrdDiscount);
		double dACurCalculateSum = ((dBalance + dInterest) - (dLastBalance + dLastInterest)) * dExchangeRate + (dATotalBadLastPrdDiscount - dACurTotalBadPrdDiscount);
		
		//������������0��������ھ���������ڼ����ֵ׼������ƿھ���������ڼ����ֵ׼����Ϊ������
		if(dMCurCalculateSum > 0)
		{
			dMBadReserveSum = dMCurCalculateSum;
		}
		else //��֮�������ھ���������ڳ�����ֵ׼������ƿھ���������ڳ�����ֵ׼����Ϊ������
		{
			dMBadMinusSum = -dMCurCalculateSum;
		}
		//��Ƽ�����
		if(dACurCalculateSum > 0)
		{
			dABadReserveSum = dACurCalculateSum;
		}
		else //��֮�������ھ���������ڳ�����ֵ׼������ƿھ���������ڳ�����ֵ׼����Ϊ������
		{
			dABadMinusSum = -dACurCalculateSum;
		}

		//���ݼ��㹫ʽ�������ֽ�����������ֵ-�����ֽ�������ֵ����ù����ھ����������ת�ؼ�ֵ׼������ƿھ����������ת�ؼ�ֵ׼��
		dMBadRetSum = dMTotalBadLastPrdDiscount - dMLastTotalBadPrdDiscount;
		dABadRetSum = dATotalBadLastPrdDiscount - dALastTotalBadPrdDiscount;
				
		//���ݼ��㹫ʽ�������ڻ���-���ڻ��ʣ���(���ڱ���+������Ϣ����)����ù����ھ�����������ƿھ��������
		dAExforLoss = (dExchangeRate - dLastExchangeRate) * (dLastBalance + dLastInterest);
		dMExforLoss = (dExchangeRate - dLastExchangeRate) * (dLastBalance + dLastInterest);
				
		//�����������õ����ݴ����alReserveCalculateData��
		alReserveCalculateData.add(0, String.valueOf(dMCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dACancelReserveSum));
		alReserveCalculateData.add(2, String.valueOf(dMExforLoss));	
		alReserveCalculateData.add(3, String.valueOf(dAExforLoss));	
		alReserveCalculateData.add(4, String.valueOf(dMBadReserveSum));
		alReserveCalculateData.add(5, String.valueOf(dMBadMinusSum));
		alReserveCalculateData.add(6, String.valueOf(dMBadRetSum));		
		alReserveCalculateData.add(7, String.valueOf(dABadReserveSum));
		alReserveCalculateData.add(8, String.valueOf(dABadMinusSum));
		alReserveCalculateData.add(9, String.valueOf(dABadRetSum));		
		alReserveCalculateData.add(10, String.valueOf(dMNormalReserveSum));		
		alReserveCalculateData.add(11, String.valueOf(dMNormalMinusSum));		
		alReserveCalculateData.add(12, String.valueOf(dANormalReserveSum));
		alReserveCalculateData.add(13, String.valueOf(dANormalMinusSum));		
		
		return alReserveCalculateData;
	}

	/**
	 * ��ĳ�ʴ�������Ϊ�����������Ϊ��������ʱ�������ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 * @param alLastReserveTotal ����·ݣ���һ�ڣ���Ӧ�Ĵ������ݿ�������ݡ�alCurReserveTotal ����·ݣ����ڣ���Ӧ�Ĵ������ݿ��������
	 * @return ArrayList ����Ϊ����ƿھ����ں�����ֵ׼���������ھ����ں�����ֵ׼����......
	 */
	public ArrayList ReserveCalculateFormula7(ArrayList alLastReserveTotal,ArrayList alCurReserveTotal, String sScope,String sBusinessFlag) throws Exception
	{
		//�������
		ArrayList alReserveCalculateData = new ArrayList();//��ż�ֵ׼���������Ϣ
		ArrayList alReservePara = new ArrayList();//��ż�ֵ׼���Ĳ���
		String sCurAccountMonth = "";//��ǰ����·�
		String sLastAccountMonth = "";//���ڻ���·�
		String sLoanAccountNo = "";//�����ʺ�
		double dBalance = 0.0;//���ڵ�Ŀǰ��ԭ�ң�
		double dInterest = 0.0;//���ڵ���Ϣ����
		double dExchangeRate = 0.0;//���ڻ���
		double dCurTotalBadPrdDiscount = 0.0;//�����ֽ�������ֵ
		double dTotalBadLastPrdDiscount = 0.0;//�����ֽ�����������ֵ		
		double dLastTotalBadPrdDiscount = 0.0;//�����ֽ�������ֵ
		double dLastBalance = 0.0;//���ڵ�Ŀǰ��ԭ�ң�
		double dLastInterest = 0.0;//���ڵ���Ϣ����
		double dLastExchangeRate = 0.0;//���ڵĻ���
						
		//�����ֶ�Ϊ�������ݿ��е�Ҫ��	
		double dCancelReserveSum = 0.0;//���ں�����ֵ׼��
		double dExforLoss = 0.0;//�������	
		double dBadReserveSum = 0.0;//��������ڼ����ֵ׼��
		double dBadMinusSum = 0.0;//��������ڳ�����ֵ׼��
		double dBadRetSum = 0.0;//���������ת�ؼ�ֵ׼��
		double dNormalReserveSum = 0.0;//��������ڼ����ֵ׼��
		double dNormalMinusSum = 0.0;//��������ڳ�����ֵ׼��
        
        String sCurBusinessFlag = "";//����ҵ���ʶ 1-�Թ�����   2-���˴���
        String sLastBusinessFlag = "";//����ҵ���ʶ 1-�Թ�����   2-���˴���
		
		//��ȡ��ǰ�Ļ���·�
		sCurAccountMonth = (String)alCurReserveTotal.get(0);
		sLoanAccountNo = (String)alCurReserveTotal.get(1);//��ȡ�����ʺ�
		//�����Ӧ����·ݵļ�ֵ׼������
        if("1".equals(sBusinessFlag)){
    		ReservePara reservePara = new ReservePara(this.Sqlca);
    		alReservePara = reservePara.getReservePara(sCurAccountMonth);
    		if(!alReservePara.isEmpty())
    			sLastAccountMonth = (String)alReservePara.get(30);
        }else{
            ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
            alReservePara = reservePara.getReservePara(sCurAccountMonth);
            if(!alReservePara.isEmpty())
                sLastAccountMonth = (String)alReservePara.get(11);
        }
        sLastBusinessFlag = (String)alLastReserveTotal.get(71);//ҵ���ʶ 1-�Թ�����   2-���˴���
        sCurBusinessFlag = (String)alCurReserveTotal.get(71);//ҵ���ʶ 1-�Թ�����   2-���˴���

		//��ñ����ֽ�������ֵ
		dCurTotalBadPrdDiscount = getTotalBadPrdDiscount(sCurAccountMonth,sLoanAccountNo,sCurBusinessFlag);
		if(sScope.equals("M")){//�����
			if(((String)alCurReserveTotal.get(34)).equals("05")){
				dCurTotalBadPrdDiscount = 0.0;
			}
		}else{//��Ʋ�
			if(((String)alCurReserveTotal.get(35)).equals("05")){
				dCurTotalBadPrdDiscount = 0.0;
			}			
		}
		//��������ֽ�������ֵ
		dLastTotalBadPrdDiscount = getTotalBadPrdDiscount(sLastAccountMonth,sLoanAccountNo,sLastBusinessFlag);
		if(sScope.equals("M")){//�����
			if(((String)alLastReserveTotal.get(34)).equals("05")){
				dLastTotalBadPrdDiscount = 0.0;
			}
		}else{//��Ʋ�
			if(((String)alLastReserveTotal.get(35)).equals("05")){
				dLastTotalBadPrdDiscount = 0.0;
			}			
		}
		//��������ֽ�����������ֵ
		dTotalBadLastPrdDiscount = getTotalBadLastPrdDiscount(sCurAccountMonth,sLoanAccountNo,(String)alCurReserveTotal.get(71));
		if(sScope.equals("M")){//�����
			if(((String)alLastReserveTotal.get(34)).equals("05")){
				dTotalBadLastPrdDiscount = 0.0;
			}
		}else{//��Ʋ�
			if(((String)alLastReserveTotal.get(35)).equals("05")){
				dTotalBadLastPrdDiscount = 0.0;
			}			
		}
		
		//������ڵ�Ŀǰ��ԭ�ң�
		dLastBalance = DataConvert.toDouble((String)alLastReserveTotal.get(30));
		//������ڵ���Ϣ����
		dLastInterest = DataConvert.toDouble((String)alLastReserveTotal.get(37));
		//������ڵĻ���
		dLastExchangeRate = DataConvert.toDouble((String)alLastReserveTotal.get(31));
		//��ñ��ڵ�Ŀǰ��ԭ�ң�
		dBalance = DataConvert.toDouble((String)alCurReserveTotal.get(30));
		//��ñ��ڵ���Ϣ����
		dInterest = DataConvert.toDouble((String)alCurReserveTotal.get(37));
		//��ñ��ڻ���
		dExchangeRate = DataConvert.toDouble((String)alCurReserveTotal.get(31));
		
		//���ݼ��㹫ʽ��[�����ڱ���+������Ϣ������-�����ڱ���+������Ϣ������]�����ڻ���+�������ֽ�����������ֵ-�����ֽ�������ֵ������ü�����
		//dCurCalculateSum = ((dBalance + dInterest) - (dLastBalance + dLastInterest)) * dExchangeRate + (dTotalBadLastPrdDiscount - dCurTotalBadPrdDiscount);
		double dCurCalculateSum = ((dBalance + dInterest) - (dLastBalance + dLastInterest)) * dExchangeRate + (dTotalBadLastPrdDiscount - dCurTotalBadPrdDiscount);
		
		//������������0��������ھ���������ڼ����ֵ׼������ƿھ���������ڼ����ֵ׼����Ϊ������
		if(dCurCalculateSum > 0)
		{
			dBadReserveSum = dCurCalculateSum;
		}
		else //��֮�������ھ���������ڳ�����ֵ׼������ƿھ���������ڳ�����ֵ׼����Ϊ������
		{
			dBadMinusSum = -dCurCalculateSum;
		}
		//���ݼ��㹫ʽ�������ֽ�����������ֵ-�����ֽ�������ֵ����ù����ھ����������ת�ؼ�ֵ׼������ƿھ����������ת�ؼ�ֵ׼��
		dBadRetSum = dTotalBadLastPrdDiscount - dLastTotalBadPrdDiscount;
				
		//���ݼ��㹫ʽ�������ڻ���-���ڻ��ʣ���(���ڱ���+������Ϣ����)����ù����ھ�����������ƿھ��������
		dExforLoss = (dExchangeRate - dLastExchangeRate) * (dLastBalance + dLastInterest);
				
		//�����������õ����ݴ����alReserveCalculateData��
		alReserveCalculateData.add(0, String.valueOf(dCancelReserveSum));
		alReserveCalculateData.add(1, String.valueOf(dExforLoss));	
		alReserveCalculateData.add(2, String.valueOf(dBadReserveSum));
		alReserveCalculateData.add(3, String.valueOf(dBadMinusSum));
		alReserveCalculateData.add(4, String.valueOf(dBadRetSum));		
		alReserveCalculateData.add(5, String.valueOf(dNormalReserveSum));		
		alReserveCalculateData.add(6, String.valueOf(dNormalMinusSum));		
		
		return alReserveCalculateData;
	}

	/**
	 * ���㱾�ڵ��ۼ��ջؽ��
	 * @param sLastAccountMonth  ���ڻ���·�
	 * @param sAccountMonth      ���ڻ���·�
	 * @param sLoanAccountNo     �����ʺ�
	 * @return
	 * @throws Exception
	 */
	public double calRetSum(String sLastAccountMonth, String sAccountMonth, String sLoanAccountNo) throws Exception{
		//�������
		String sSql = "";
		ASResultSet rs = null;
		double dRetSum = 0.0;
		
		sSql = 	" select sum(MonthRetSum) from RESERVE_TOTAL "+
				" where (AccountMonth <= '"+sAccountMonth+"' "+
				" and AccountMonth > '"+sLastAccountMonth+"') "+
				" and LoanAccount = '"+sLoanAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dRetSum = rs.getDouble(1);
		}
		rs.getStatement().close();
		
		return dRetSum;
	}
	
	/**
	 * ���㱾�ڵ��ۼƺ������
	 * @param sLastAccountMonth  ���ڻ���·�
	 * @param sAccountMonth      ���ڻ���·�
	 * @param sLoanAccountNo     �����ʺ�
	 * @return
	 * @throws Exception
	 */
	public double calOmitSum(String sLastAccountMonth, String sAccountMonth, String sLoanAccountNo) throws Exception{
		//�������
		String sSql = "";
		ASResultSet rs = null;
		double dOmitSum = 0.0;
		
		sSql = 	" select sum(MonthOmitSum) from RESERVE_TOTAL "+
				" where (AccountMonth <= '"+sAccountMonth+"' "+
				" and AccountMonth > '"+sLastAccountMonth+"') "+
				" and LoanAccount = '"+sLoanAccountNo+"' ";
		rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			dOmitSum = rs.getDouble(1);
		}
		rs.getStatement().close();
		
		return dOmitSum;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try
		{
			
		}catch(Exception e)
		{
			System.out.println(e.toString());
		}
	}
}
