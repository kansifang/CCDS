package com.amarsoft.ReserveManage;
/**
 * �ر�ע�⣺
 *   1��sAuditRate:����ʵ�������ʺ����޷���ȡ���ʼ򵥸�ֵΪ����������
 *   2��sPdgSum:  ��������ã����ں����޷���ȡ���ʼ򵥸�ֵΪ��0
 *   3��sGuarantyDiscountValue,��Ѻ�﹫�ʼ�ֵ���޷���ȡ���ʼ򵥸�ֵΪ ��sGuarantyNowValue (����Ѻ��������ֵ)
 */
import java.util.ArrayList;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.ConnectionManager;
import com.amarsoft.are.sql.Transaction;


public class BatchReserveInfo {

	private Transaction Sqlca = null;
	private boolean debug = true;
		
	public BatchReserveInfo(Transaction Sqlca)
	{
		this.Sqlca = Sqlca;		
	}



	/**
	 * ���´������ݿ��л���·ݺʹ����ʺ����Ӧ��¼�ļ�ֵ����������Ϣ
	 * @param 
	 * @return 
	 */
	public void runCalculateData(String sAccountMonth,String sLoanAccountNo,String sManageStatFlag,String sBusinessFlag) throws Exception
	{
        //�������			
		ArrayList alReserveTotal = new ArrayList();//��Ŵ������ݿ�ļ�ֵ������Ϣ

		try
		{		        
			ReserveTotal reserveTotal = new ReserveTotal(this.Sqlca);	
            if("1".equals(sManageStatFlag)){
                alReserveTotal = this.BatchCalculateData(sAccountMonth,sLoanAccountNo,sBusinessFlag);
            }else{
                alReserveTotal = this.singleCalculateData(sAccountMonth,sLoanAccountNo,sBusinessFlag);
            }
			if(!alReserveTotal.isEmpty())
				reserveTotal.updateReserveTotal(alReserveTotal);				
		}catch(Exception e)
		{
			e.printStackTrace();
			System.out.println("--------BatchReserveInfo.runCalculateData--------"+e.toString());
		}
	}
			


    /**
     * ��ϼ�����������ӿڣ�������Ӧ�Ĺ�ʽ�����Ӧ�ھ��ļ�ֵ��������
     * @param sLoanAccountNo �����ʺ�
     * @return ArrayList ����Ϊ��������ֵ׼�������ڴ��������桢�����ھ�����Ԥ���ֽ�����������ֵ��......
     */
    private ArrayList BatchCalculateData(String sAccountMonth,String sLoanAccountNo,String sBusinessFlag) throws Exception
    {
        //�������
        ArrayList alReserveTotal = new ArrayList();//��ż�ֵ׼���Ĵ������ݿ����������Ϣ
        ArrayList alReserveBasicData = new ArrayList();//��ż�ֵ׼���Ĵ������ݿ����������Ϣ
        ArrayList alLastReserveBasicData = new ArrayList();//��ż�ֵ׼���Ĵ������ݿ����������Ϣ����һ�ڣ�
        ArrayList alReserveCalculateData = new ArrayList();//��ż�ֵ׼���Ĵ������ݿ��ֵ������Ϣ�����ݹ�ʽ���㣩 
        ArrayList alReservePara = new ArrayList();//��ŵ�ǰ����·ݵļ�ֵ׼������
        ArrayList alLastPredictCapital = new ArrayList();//��Ź����ھ�����ƿھ��Ĳ�����������Ԥ���ֽ�����������ֵ��Ϣ
        boolean bExistFlag = true;//�������ݿ����Ƿ���ڱ��ڴ����ʻ��ı�־�����Ƿ��Ѿ��������
        String sLastAccountMonth = "";//��ֵ����׼���������е����ڻ���·�       
        String sMFiveClassify = "";//���ڹ�����弶����
        String sAFiveClassify = "";//��������弶����
        String sManageStatFlag = "";//���ڼ��᷽ʽ
        String sLastMFiveClassify = "";//���ڹ�����弶����
        String sLastAFiveClassify = "";//��������弶����
        String sLastManageStatFlag = "";//���ڼ��᷽ʽ
        
        double dLastBalance = 0.0;//���ڴ������
        double dBalance = 0.0;//���ڴ������
        double dRetSum = 0.0;//�����ջؽ��
        double dOmitSum = 0.0;//���ں������
        
        //�����ֶ�Ϊ�������ݿ��е�Ҫ��
        String sMCancelReserveSum = "0.0";//�����ھ�������ֵ׼��
        String sACancelReserveSum = "0.0";//��ƿھ�������ֵ׼��
        String sMExforLoss = "0.0";//�����ھ����ڴ���������
        String sAExforLoss = "0.0";//��ƿھ����ڴ���������
        String sMBadLastPrdDiscount = "0.0";//�����ھ�����Ԥ���ֽ�����������ֵ
        String sMBadPrdDiscount = "0.0";//�����ھ����������Ԥ���ֽ�������ֵ
        String sMBadReserveSum = "0.0";//�����ھ���������ڼ����ֵ׼��
        String sMBadMinusSum = "0.0";//�����ھ���������ڳ�����ֵ׼��
        String sMBadRetSum = "0.0";//�����ھ����������ת�ؼ�ֵ׼��
        String sMBadReserveBalance = "0.0";//�����ھ���������ڼ�ֵ׼�����
        String sABadLastprdDiscount = "0.0";//��ƿھ�������������Ԥ���ֽ�����������ֵ
        String sABadPrdDiscount = "0.0";//��ƿھ����������Ԥ���ֽ�������ֵ
        String sABadReserveSum = "0.0";//��ƿھ���������ڼ����ֵ׼��
        String sABadMinusSum = "0.0";//��ƿھ���������ڳ�����ֵ׼��
        String sABadRetSum = "0.0";//��ƿھ����������ת�ؼ�ֵ׼��
        String sABadReserveBalance = "0.0";//��ƿھ���������ڼ�ֵ׼�����
        String sMNormalReserveSum = "0.0";//�����ھ���������ڼ����ֵ׼��
        String sMNormalMinusSum = "0.0";//�����ھ���������ڳ�����ֵ׼��
        String sMNormalReserveBalance = "0.0";//�����ھ���������ڼ�ֵ׼�����
        String sANormalReserveSum = "0.0";//��ƿھ���������ڼ����ֵ׼��
        String sANormalMinusSum = "0.0";//��ƿھ���������ڳ�����ֵ׼��
        String sANormalReserveBalance = "0.0";//��ƿھ���������ڼ�ֵ׼�����
        
        
        //��ȡ��Ӧ����·ݵļ�ֵ���������Ϣ
        if("1".equals(sBusinessFlag)){
            ReservePara reservePara = new ReservePara(this.Sqlca);
            alReservePara = reservePara.getReservePara(sAccountMonth);
            if(!alReservePara.isEmpty())
                sLastAccountMonth = (String)alReservePara.get(30);
        }else{
            ReserveParaInd reservePara = new ReserveParaInd(this.Sqlca);
            alReservePara = reservePara.getReservePara(sAccountMonth);
            if(!alReservePara.isEmpty())
                sLastAccountMonth = (String)alReservePara.get(11);
        }
        
        //��RESERVE_TOTAL�м�鱾�ڻ����������Ƿ���ڸô����ʺŵ���Ϣ
        ReserveTotal reserveTotal = new ReserveTotal(this.Sqlca);
        bExistFlag = reserveTotal.findExistReserveTotal(sAccountMonth,sLoanAccountNo);
        if(bExistFlag == true) //�������ݿ��д��ڱ��ڵĴ����ʻ���Ϣ
        {
            ReserveCalculate reserveCalculate = new ReserveCalculate(this.Sqlca);
            //��ȡ���ڴ������ݿ��������
            alReserveBasicData = reserveTotal.selectReserveTotal(sAccountMonth,sLoanAccountNo);
            //��ȡ���ڴ������ݿ��������
            alLastReserveBasicData = reserveTotal.selectReserveTotal(sLastAccountMonth,sLoanAccountNo);
            if(!alLastReserveBasicData.isEmpty()){
                //���ڴ������Ϊ�㣬���������ֵ׼��
                if(Double.parseDouble((String)alLastReserveBasicData.get(30)) == 0 ){
                    return alReserveTotal;
                }
            }
            //��ȡ���ڴ������ݿ��������
            sMFiveClassify = (String)alReserveBasicData.get(34);//���ڹ�����弶����     
            sAFiveClassify = (String)alReserveBasicData.get(35);//��������弶����
            sManageStatFlag = (String)alReserveBasicData.get(70);//���ڼ��᷽ʽ 
            //��ȡ���ڴ������ݿ��������
            if(!alLastReserveBasicData.isEmpty()){
               sLastMFiveClassify = (String)alLastReserveBasicData.get(34);//���ڹ�����弶����      
               sLastAFiveClassify = (String)alLastReserveBasicData.get(35);//��������弶����
               sLastManageStatFlag = (String)alLastReserveBasicData.get(70);//���ڼ��᷽ʽ 
            }
            //����ֵת��Ϊ���ַ���
            if(sMFiveClassify == null) sMFiveClassify = "";
            if(sAFiveClassify == null) sAFiveClassify = "";
            if(sLastMFiveClassify == null) sLastMFiveClassify = "";
            if(sLastAFiveClassify == null) sLastAFiveClassify = "";
            //��ȡ�����ջؽ��ͱ��ں������
            dRetSum = reserveCalculate.calRetSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//�����ջؽ��
            dOmitSum = reserveCalculate.calOmitSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//���ں������

            if(debug)System.out.println("111111111111111");     
            if(alLastReserveBasicData.isEmpty()) //�ñʴ���Ϊ������������
            {
                if(debug)System.out.println("111111111111111-----------1111111111");    
                //����ReserveCalculate�ļ��㹫ʽReserveCalculateFormula1
                alReserveCalculateData = reserveCalculate.ReserveCalculateFormula1(alReserveBasicData);
                if(!alReserveCalculateData.isEmpty())
                {
                    sMNormalReserveSum = (String)alReserveCalculateData.get(10);//�����ھ���������ڼ����ֵ׼��
                    sMNormalReserveBalance = (String)alReserveCalculateData.get(10);//�����ھ���������ڼ�ֵ׼�����
                    sANormalReserveSum = (String)alReserveCalculateData.get(12);//��ƿھ���������ڼ����ֵ׼��
                    sANormalReserveBalance = (String)alReserveCalculateData.get(12);//��ƿھ���������ڼ�ֵ׼�����
                }
            }else
            {
                dLastBalance = Double.parseDouble((String)alLastReserveBasicData.get(30));//���ڴ������
                dBalance = Double.parseDouble((String)alReserveBasicData.get(30));//���ڴ������
                dRetSum = reserveCalculate.calRetSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//�����ջؽ��
                dOmitSum = reserveCalculate.calOmitSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//���ں������
                
                if(dRetSum > 0 && dLastBalance > 0 && dRetSum == dLastBalance && dBalance == 0)//����ȫ���ջ�
                {
                    //����ReserveCalculate�ļ��㹫ʽReserveCalculateFormula2
                    alReserveCalculateData = reserveCalculate.ReserveCalculateFormula2(alLastReserveBasicData,alReserveBasicData);
                    if(!alReserveCalculateData.isEmpty())
                    {
                        alLastPredictCapital = reserveCalculate.getLastPredictCapital(alLastReserveBasicData, alReserveBasicData);
                        if(!alLastPredictCapital.isEmpty())
                        {
                            sMBadLastPrdDiscount = (String)alLastPredictCapital.get(0);//�����ھ�������������Ԥ���ֽ�����������ֵ
                            sABadLastprdDiscount = (String)alLastPredictCapital.get(1);//��ƿھ�������������Ԥ���ֽ�����������ֵ
                        }
                        sMExforLoss = (String)alReserveCalculateData.get(2);//�����ھ����ڴ���������
                        sAExforLoss = (String)alReserveCalculateData.get(3);//��ƿھ����ڴ���������                          
                        sMBadMinusSum = (String)alReserveCalculateData.get(5);//�����ھ���������ڳ�����ֵ׼��   
                        sMBadRetSum = (String)alReserveCalculateData.get(6);//�����ھ����������ת�ؼ�ֵ׼��
                        sABadMinusSum = (String)alReserveCalculateData.get(8);//��ƿھ���������ڳ�����ֵ׼��
                        sABadRetSum = (String)alReserveCalculateData.get(9);//��ƿھ����������ת�ؼ�ֵ׼��
                        sMNormalMinusSum = (String)alReserveCalculateData.get(11);//�����ھ���������ڳ�����ֵ׼��
                        sANormalMinusSum = (String)alReserveCalculateData.get(13);//��ƿھ���������ڳ�����ֵ׼��
                    }
                }else if(dOmitSum > 0 && dLastBalance > 0 && dOmitSum == dLastBalance && dBalance == 0)//����ȫ������
                {
                    //����ReserveCalculate�ļ��㹫ʽReserveCalculateFormula3
                    alReserveCalculateData = reserveCalculate.ReserveCalculateFormula3(alLastReserveBasicData,alReserveBasicData);
                    if(!alReserveCalculateData.isEmpty())
                    {
                        //������������Ԥ���ֽ�����������ֵ
                        alLastPredictCapital = reserveCalculate.getLastPredictCapital(alLastReserveBasicData, alReserveBasicData);
                        if(!alLastPredictCapital.isEmpty())
                        {
                            sMBadLastPrdDiscount = (String)alLastPredictCapital.get(0);//�����ھ�������������Ԥ���ֽ�����������ֵ
                            sABadLastprdDiscount = (String)alLastPredictCapital.get(1);//��ƿھ�������������Ԥ���ֽ�����������ֵ
                        }
                        sMCancelReserveSum = (String)alReserveCalculateData.get(0);//�����ھ�������ֵ׼��
                        sACancelReserveSum = (String)alReserveCalculateData.get(1);//��ƿھ�������ֵ׼��
                        sMExforLoss = (String)alReserveCalculateData.get(2);//�����ھ����ڴ���������
                        sAExforLoss = (String)alReserveCalculateData.get(3);//��ƿھ����ڴ���������
                    }
                }else 
                {
                    //�ñʴ�������Ϊ���ʼ��ᣬ����Ϊ��ϼ���
                    if(sLastManageStatFlag.equals("2") && sManageStatFlag.equals("1"))
                    {
                        //������������Ԥ���ֽ�����������ֵ
                        sMBadLastPrdDiscount = reserveCalculate.getLastPredictCapital(alLastReserveBasicData, alReserveBasicData, "M") + "";
                        //����ReserveCalculate�ļ��㹫ʽReserveCalculateFormula5
                        alReserveCalculateData = reserveCalculate.ReserveCalculateFormula5(alLastReserveBasicData,alReserveBasicData, "M");
                        if(!alReserveCalculateData.isEmpty())
                        {
                            sMExforLoss = (String)alReserveCalculateData.get(1);//�����ھ����ڴ���������
                            //sAExforLoss = (String)alReserveCalculateData.get(3);//��ƿھ����ڴ���������
                            sMBadMinusSum = (String)alReserveCalculateData.get(3);//�����ھ���������ڳ�����ֵ׼��
                            sMBadRetSum = (String)alReserveCalculateData.get(4);//�����ھ����������ת�ؼ�ֵ׼��
                            //sABadMinusSum = (String)alReserveCalculateData.get(8);//��ƿھ���������ڳ�����ֵ׼��                                  
                            sMNormalReserveSum = (String)alReserveCalculateData.get(5);//�����ھ���������ڼ����ֵ׼��                                  
                            sMNormalReserveBalance = (String)alReserveCalculateData.get(5);//�����ھ���������ڼ�ֵ׼�����
                            //sANormalReserveSum = (String)alReserveCalculateData.get(12);//��ƿھ���������ڼ����ֵ׼��                                    
                            //sANormalReserveBalance = (String)alReserveCalculateData.get(12);//��ƿھ���������ڼ�ֵ׼�����
                        }
                    }else
                    {
                        //ĳ�ʴ�������Ϊ�����������Ϊ��������
                        if(sLastManageStatFlag.equals("1") && sManageStatFlag.equals("1"))
                        {
                            //����ReserveCalculate�ļ��㹫ʽReserveCalculateFormula6
                            alReserveCalculateData = reserveCalculate.ReserveCalculateFormula6(alLastReserveBasicData,alReserveBasicData, "M");
                            if(!alReserveCalculateData.isEmpty())
                            {
                                sMExforLoss = (String)alReserveCalculateData.get(1);//�����ھ����ڴ���������
                                //sAExforLoss = (String)alReserveCalculateData.get(3);//��ƿھ����ڴ���������
                                sMNormalReserveSum = (String)alReserveCalculateData.get(5);//�����ھ���������ڼ����ֵ׼��
                                sMNormalMinusSum = (String)alReserveCalculateData.get(6);//�����ھ���������ڳ�����ֵ׼��
                                if(sMFiveClassify.equals("01")) //������
                                    sMNormalReserveBalance = String.valueOf(reserveCalculate.getACompReserveSum(alReserveBasicData,sAccountMonth,"M"));//�����ھ���������ڼ�ֵ׼�����
                                if(sMFiveClassify.equals("02")) //��ע��
                                    sMNormalReserveBalance = String.valueOf(reserveCalculate.getBCompReserveSum(alReserveBasicData,sAccountMonth,"M"));//�����ھ���������ڼ�ֵ׼�����
                                //sANormalReserveSum = (String)alReserveCalculateData.get(12);//��ƿھ���������ڼ����ֵ׼��
                                //sANormalMinusSum = (String)alReserveCalculateData.get(13);//��ƿھ���������ڳ�����ֵ׼��
                                //if(sAFiveClassify.equals("01")) //������
                                    //sANormalReserveBalance = String.valueOf(reserveCalculate.getACompReserveSum(alReserveBasicData,sAccountMonth,"A"));//��ƿھ���������ڼ�ֵ׼�����
                                //if(sAFiveClassify.equals("02")) //��ע��
                                    //sANormalReserveBalance = String.valueOf(reserveCalculate.getBCompReserveSum(alReserveBasicData,sAccountMonth,"A"));//��ƿھ���������ڼ�ֵ׼�����
                            }
                        }
                    }
                
                    
                    /**����Ϊ��ƿھ����д���**/
                    //�ñʴ�������Ϊ���ʼ��ᣬ����Ϊ��ϼ���
                    if(sLastManageStatFlag.equals("2") && sManageStatFlag.equals("1"))
                    {
                        //������������Ԥ���ֽ�����������ֵ
                        sABadLastprdDiscount = reserveCalculate.getLastPredictCapital(alLastReserveBasicData, alReserveBasicData, "A") + "";
                        //����ReserveCalculate�ļ��㹫ʽReserveCalculateFormula5
                        alReserveCalculateData = reserveCalculate.ReserveCalculateFormula5(alLastReserveBasicData,alReserveBasicData, "A");
                        if(!alReserveCalculateData.isEmpty())
                        {
                            sAExforLoss = (String)alReserveCalculateData.get(1);//��ƿھ����ڴ���������
                            sABadMinusSum = (String)alReserveCalculateData.get(3);//��ƿھ���������ڳ�����ֵ׼��
                            sABadRetSum = (String)alReserveCalculateData.get(4);//��ƿھ����������ת�ؼ�ֵ׼��
                            sANormalReserveSum = (String)alReserveCalculateData.get(5);//��ƿھ���������ڼ����ֵ׼��                                   
                            sANormalReserveBalance = (String)alReserveCalculateData.get(5);//��ƿھ���������ڼ�ֵ׼�����
                        }
                    }else
                    {
                        //ĳ�ʴ�������Ϊ�����������Ϊ��������
                        if(sLastManageStatFlag.equals("1") && sManageStatFlag.equals("1"))
                        {
                            //����ReserveCalculate�ļ��㹫ʽReserveCalculateFormula6
                            alReserveCalculateData = reserveCalculate.ReserveCalculateFormula6(alLastReserveBasicData,alReserveBasicData, "A");
                            if(!alReserveCalculateData.isEmpty())
                            {
                                sAExforLoss = (String)alReserveCalculateData.get(1);//��ƿھ����ڴ���������
                                sANormalReserveSum = (String)alReserveCalculateData.get(5);//��ƿھ���������ڼ����ֵ׼��
                                sANormalMinusSum = (String)alReserveCalculateData.get(6);//��ƿھ���������ڳ�����ֵ׼��
                                if(sAFiveClassify.equals("01")) //������
                                    sANormalReserveBalance = String.valueOf(reserveCalculate.getACompReserveSum(alReserveBasicData,sAccountMonth,"A"));//��ƿھ���������ڼ�ֵ׼�����
                                if(sAFiveClassify.equals("02")) //��ע��
                                    sANormalReserveBalance = String.valueOf(reserveCalculate.getBCompReserveSum(alReserveBasicData,sAccountMonth,"A"));//��ƿھ���������ڼ�ֵ׼�����
                            }
                        }
                    }
                 }
            }           
        }
        //��������õ���Ϣ����ڴ������ݿ����alReserveTotal��
        alReserveTotal.add(0, sAccountMonth); //����·�
        alReserveTotal.add(1, sLoanAccountNo); //�����ʺ�
        alReserveTotal.add(2, sMCancelReserveSum); //�����ھ�������ֵ׼��
        alReserveTotal.add(3, sACancelReserveSum); //��ƿھ�������ֵ׼��
        alReserveTotal.add(4, sMExforLoss); //�����ھ��������
        alReserveTotal.add(5, sAExforLoss); //��ƿھ��������
        alReserveTotal.add(6, sMBadLastPrdDiscount); //�����ھ�����Ԥ���ֽ�����������ֵ
        alReserveTotal.add(7, sMBadPrdDiscount); //�����ھ����������Ԥ���ֽ�������ֵ
        alReserveTotal.add(8, sMBadReserveSum); //�����ھ���������ڼ����ֵ׼��
        alReserveTotal.add(9, sMBadMinusSum); //�����ھ���������ڳ�����ֵ׼��
        alReserveTotal.add(10, sMBadRetSum); //�����ھ����������ת�ؼ�ֵ׼��
        alReserveTotal.add(11, sMBadReserveBalance); //�����ھ���������ڼ�ֵ׼�����
        alReserveTotal.add(12, sABadLastprdDiscount); //��ƿھ�������������Ԥ���ֽ�����������ֵ
        alReserveTotal.add(13, sABadPrdDiscount); //��ƿھ����������Ԥ���ֽ�������ֵ
        alReserveTotal.add(14, sABadReserveSum); //��ƿھ���������ڼ����ֵ׼��
        alReserveTotal.add(15, sABadMinusSum); //��ƿھ���������ڳ�����ֵ׼��
        alReserveTotal.add(16, sABadRetSum); //��ƿھ����������ת�ؼ�ֵ׼��
        alReserveTotal.add(17, sABadReserveBalance); //��ƿھ���������ڼ�ֵ׼�����
        alReserveTotal.add(18, sMNormalReserveSum); //�����ھ���������ڼ����ֵ׼��
        alReserveTotal.add(19, sMNormalMinusSum); //�����ھ���������ڳ�����ֵ׼��
        alReserveTotal.add(20, sMNormalReserveBalance); //�����ھ���������ڼ�ֵ׼�����
        alReserveTotal.add(21, sANormalReserveSum); //��ƿھ���������ڼ����ֵ׼��
        alReserveTotal.add(22, sANormalMinusSum); //��ƿھ���������ڳ�����ֵ׼��
        alReserveTotal.add(23, sANormalReserveBalance); //��ƿھ���������ڼ�ֵ׼�����
        alReserveTotal.add(24, dRetSum+""); //�����ջؽ��
        alReserveTotal.add(25, dOmitSum+""); //���ں������
        
        return alReserveTotal;
    }   
    
    /**
     * ���ʼ�����㹫ʽ��������Ӧ�Ĺ�ʽ�����Ӧ�ھ��ļ�ֵ��������
     * @param sLoanAccountNo �����ʺ�
     * @return ArrayList ����Ϊ��������ֵ׼�������ڴ��������桢�����ھ�����Ԥ���ֽ�����������ֵ��......
     */
    private ArrayList singleCalculateData(String sAccountMonth,String sLoanAccountNo,String sBusinessFlag) throws Exception
    {
        //�������
        ArrayList alReserveTotal = new ArrayList();//��ż�ֵ׼���Ĵ������ݿ����������Ϣ
        ArrayList alReserveBasicData = new ArrayList();//��ż�ֵ׼���Ĵ������ݿ����������Ϣ
        ArrayList alLastReserveBasicData = new ArrayList();//��ż�ֵ׼���Ĵ������ݿ����������Ϣ����һ�ڣ�
        ArrayList alReserveCalculateData = new ArrayList();//��ż�ֵ׼���Ĵ������ݿ��ֵ������Ϣ�����ݹ�ʽ���㣩 
        ArrayList alReservePara = new ArrayList();//��ŵ�ǰ����·ݵļ�ֵ׼������
        ArrayList alCurPredictCapital = new ArrayList();//��Ź����ھ�����ƿھ��Ĳ��������Ԥ���ֽ�����Ϣ
        boolean bExistFlag = true;//�������ݿ����Ƿ���ڱ��ڴ����ʻ��ı�־�����Ƿ��Ѿ��������
        String sLastAccountMonth = "";//��ֵ����׼���������е����ڻ���·�       
        String sMFiveClassify = "";//���ڹ�����弶����
        String sAFiveClassify = "";//��������弶����
        String sManageStatFlag = "";//���ڼ��᷽ʽ
        String sLastMFiveClassify = "";//���ڹ�����弶����
        String sLastAFiveClassify = "";//��������弶����
        String sLastManageStatFlag = "";//���ڼ��᷽ʽ
        double dLastBalance = 0.0;//���ڴ������
        double dBalance = 0.0;//���ڴ������
        double dRetSum = 0.0;//�����ջؽ��
        double dOmitSum = 0.0;//���ں������
        
        //�����ֶ�Ϊ�������ݿ��е�Ҫ��
        String sMCancelReserveSum = "0.0";//�����ھ�������ֵ׼��
        String sACancelReserveSum = "0.0";//��ƿھ�������ֵ׼��
        String sMExforLoss = "0.0";//�����ھ����ڴ���������
        String sAExforLoss = "0.0";//��ƿھ����ڴ���������
        String sMBadLastPrdDiscount = "0.0";//�����ھ�����Ԥ���ֽ�����������ֵ
        String sMBadPrdDiscount = "0.0";//�����ھ����������Ԥ���ֽ�������ֵ
        String sMBadReserveSum = "0.0";//�����ھ���������ڼ����ֵ׼��
        String sMBadMinusSum = "0.0";//�����ھ���������ڳ�����ֵ׼��
        String sMBadRetSum = "0.0";//�����ھ����������ת�ؼ�ֵ׼��
        String sMBadReserveBalance = "0.0";//�����ھ���������ڼ�ֵ׼�����
        String sABadLastprdDiscount = "0.0";//��ƿھ�������������Ԥ���ֽ�����������ֵ
        String sABadPrdDiscount = "0.0";//��ƿھ����������Ԥ���ֽ�������ֵ
        String sABadReserveSum = "0.0";//��ƿھ���������ڼ����ֵ׼��
        String sABadMinusSum = "0.0";//��ƿھ���������ڳ�����ֵ׼��
        String sABadRetSum = "0.0";//��ƿھ����������ת�ؼ�ֵ׼��
        String sABadReserveBalance = "0.0";//��ƿھ���������ڼ�ֵ׼�����
        String sMNormalReserveSum = "0.0";//�����ھ���������ڼ����ֵ׼��
        String sMNormalMinusSum = "0.0";//�����ھ���������ڳ�����ֵ׼��
        String sMNormalReserveBalance = "0.0";//�����ھ���������ڼ�ֵ׼�����
        String sANormalReserveSum = "0.0";//��ƿھ���������ڼ����ֵ׼��
        String sANormalMinusSum = "0.0";//��ƿھ���������ڳ�����ֵ׼��
        String sANormalReserveBalance = "0.0";//��ƿھ���������ڼ�ֵ׼�����
        
                
        //��ȡ��Ӧ����·ݵļ�ֵ���������Ϣ
        ReservePara reservePara = new ReservePara(this.Sqlca);
        alReservePara = reservePara.getReservePara(sAccountMonth);
        if(!alReservePara.isEmpty())
            sLastAccountMonth = (String)alReservePara.get(30);
                
        //��RESERVE_TOTAL�м�鱾�ڻ����������Ƿ���ڸô����ʺŵ���Ϣ
        ReserveTotal reserveTotal = new ReserveTotal(this.Sqlca);
        bExistFlag = reserveTotal.findExistReserveTotal(sAccountMonth,sLoanAccountNo);
        if(bExistFlag == true) //�������ݿ��д��ڱ��ڵĴ����ʻ���Ϣ
        {
            ReserveCalculate reserveCalculate = new ReserveCalculate(this.Sqlca);
            //��ȡ���ڴ������ݿ��������
            alReserveBasicData = reserveTotal.selectReserveTotal(sAccountMonth,sLoanAccountNo);
            //��ȡ���ڴ������ݿ��������
            alLastReserveBasicData = reserveTotal.selectReserveTotal(sLastAccountMonth,sLoanAccountNo);
            if(!alLastReserveBasicData.isEmpty()){
                //���ڴ������Ϊ�㣬���������ֵ׼��
                if(Double.parseDouble((String)alLastReserveBasicData.get(30)) == 0 ){
                    return alReserveTotal;
                }
            }
            //��ȡ���ڴ������ݿ��������
            sMFiveClassify = (String)alReserveBasicData.get(34);//���ڹ�����弶����     
            sAFiveClassify = (String)alReserveBasicData.get(35);//��������弶����
            sManageStatFlag = (String)alReserveBasicData.get(70);//���ڼ��᷽ʽ 
            //��ȡ���ڴ������ݿ��������
            if(!alLastReserveBasicData.isEmpty()){
               sLastMFiveClassify = (String)alLastReserveBasicData.get(34);//���ڹ�����弶����      
               sLastAFiveClassify = (String)alLastReserveBasicData.get(35);//��������弶����
               sLastManageStatFlag = (String)alLastReserveBasicData.get(70);//���ڼ��᷽ʽ 
            }
            //����ֵת��Ϊ���ַ���
            if(sMFiveClassify == null) sMFiveClassify = "";
            if(sAFiveClassify == null) sAFiveClassify = "";
            if(sManageStatFlag == null) sManageStatFlag = "";
            if(sLastMFiveClassify == null) sLastMFiveClassify = "";
            if(sLastAFiveClassify == null) sLastAFiveClassify = "";
            if(sLastManageStatFlag == null) sLastManageStatFlag = "";
            //��ȡ�����ջؽ��ͱ��ں������
            dRetSum = reserveCalculate.calRetSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//�����ջؽ��
            dOmitSum = reserveCalculate.calOmitSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//���ں������

            if(debug)System.out.println("111111111111111");     
            if(alLastReserveBasicData.isEmpty()) //�ñʴ���Ϊ������������
            {
                if(debug)System.out.println("111111111111111-----------1111111111");    
                //����ReserveCalculate�ļ��㹫ʽReserveCalculateFormula1
                alReserveCalculateData = reserveCalculate.ReserveCalculateFormula1(alReserveBasicData);
                if(!alReserveCalculateData.isEmpty())
                {
                    //���ڲ���������Ҫ���㱾���ֽ�������ֵ
                    alCurPredictCapital = reserveCalculate.getCurPredictCapital(alReserveBasicData);
                    if(!alCurPredictCapital.isEmpty())
                    {
                        sMBadPrdDiscount = (String)alCurPredictCapital.get(0);//�����ھ����������Ԥ���ֽ�������ֵ
                        sABadPrdDiscount = (String)alCurPredictCapital.get(1);//��ƿھ����������Ԥ���ֽ�������ֵ
                    }
                    if(debug)System.out.println("111111111111111-----------333333333"); 
                    sMBadReserveSum = (String)alReserveCalculateData.get(4);//�����ھ���������ڼ����ֵ׼��
                    sMBadReserveBalance = (String)alReserveCalculateData.get(4);//�����ھ���������ڼ�ֵ׼�����
                    sABadReserveSum = (String)alReserveCalculateData.get(7);//��ƿھ���������ڼ����ֵ׼��
                    sABadReserveBalance = (String)alReserveCalculateData.get(7);//��ƿھ���������ڼ�ֵ׼�����
                    sMNormalReserveSum = (String)alReserveCalculateData.get(10);//�����ھ���������ڼ����ֵ׼��
                    sMNormalReserveBalance = (String)alReserveCalculateData.get(10);//�����ھ���������ڼ�ֵ׼�����
                    sANormalReserveSum = (String)alReserveCalculateData.get(12);//��ƿھ���������ڼ����ֵ׼��
                    sANormalReserveBalance = (String)alReserveCalculateData.get(12);//��ƿھ���������ڼ�ֵ׼�����
                }
            }else
            {
                dLastBalance = Double.parseDouble((String)alLastReserveBasicData.get(30));//���ڴ������
                dBalance = Double.parseDouble((String)alReserveBasicData.get(30));//���ڴ������
                dRetSum = reserveCalculate.calRetSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//�����ջؽ��
                dOmitSum = reserveCalculate.calOmitSum(sLastAccountMonth, sAccountMonth, sLoanAccountNo);//���ں������
                
                //�ñʴ�������Ϊ��ϼ��ᣬ����Ϊ���ʼ���
                if(sLastManageStatFlag.equals("1")&& sManageStatFlag.equals("2"))
                {
                    //���ڲ���������Ҫ���㱾���ֽ�������ֵ
                    sMBadPrdDiscount = reserveCalculate.getCurPredictCapital(alReserveBasicData, "M")+"";//�����ھ����������Ԥ���ֽ�������ֵ
                    //����ReserveCalculate�ļ��㹫ʽReserveCalculateFormula4
                    alReserveCalculateData = reserveCalculate.ReserveCalculateFormula4(alLastReserveBasicData,alReserveBasicData, "M");
                    if(!alReserveCalculateData.isEmpty())
                    {                               
                        sMExforLoss = (String)alReserveCalculateData.get(1);//�����ھ����ڴ���������
                        //sAExforLoss = (String)alReserveCalculateData.get(3);//��ƿھ����ڴ���������
                        sMBadReserveSum = (String)alReserveCalculateData.get(2);//�����ھ���������ڼ����ֵ׼��
                        sMBadReserveBalance = String.valueOf(reserveCalculate.getSingleReserveSum(alReserveBasicData,"M"));//�����ھ���������ڼ�ֵ׼�����
                        //sABadReserveSum = (String)alReserveCalculateData.get(7);//��ƿھ���������ڼ����ֵ׼��
                        //sABadReserveBalance = String.valueOf(reserveCalculate.getSingleReserveSum(alReserveBasicData,"A"));//��ƿھ���������ڼ�ֵ׼�����
                        sMNormalMinusSum = (String)alReserveCalculateData.get(6);//�����ھ���������ڳ�����ֵ׼��
                        //sANormalMinusSum = (String)alReserveCalculateData.get(13);//��ƿھ���������ڳ�����ֵ׼��
                    }
                }else 
                {
                    //ĳ�ʴ�������Ϊ���ʼ��ᣬ����Ϊ���ʼ���
                    if(sLastManageStatFlag.equals("2")&& sManageStatFlag.equals("2"))
                    {
                        //������������Ԥ���ֽ�����������ֵ
                        sMBadLastPrdDiscount = reserveCalculate.getLastPredictCapital(alLastReserveBasicData, alReserveBasicData, "M") + "";
                        //���ڲ���������Ҫ���㱾���ֽ�������ֵ
                        sMBadPrdDiscount = reserveCalculate.getCurPredictCapital(alReserveBasicData, "M") + "";
                        //����ReserveCalculate�ļ��㹫ʽReserveCalculateFormula7
                        alReserveCalculateData = reserveCalculate.ReserveCalculateFormula7(alLastReserveBasicData,alReserveBasicData, "M",sBusinessFlag);
                        if(!alReserveCalculateData.isEmpty())
                        {
                            sMExforLoss = (String)alReserveCalculateData.get(1);//�����ھ����ڴ���������
                            sMBadReserveSum = (String)alReserveCalculateData.get(2);//�����ھ���������ڼ����ֵ׼��
                            sMBadMinusSum = (String)alReserveCalculateData.get(3);//�����ھ���������ڳ�����ֵ׼��
                            sMBadRetSum = (String)alReserveCalculateData.get(4);//�����ھ����������ת�ؼ�ֵ׼��
                            sMBadReserveBalance = String.valueOf(reserveCalculate.getSingleReserveSum(alReserveBasicData,"M"));//�����ھ���������ڼ�ֵ׼�����
                        }
                    }   
                
                }
                
                /**����Ϊ��ƿھ����д���**/
                //�ñʴ�������Ϊ��ϼ��ᣬ����Ϊ���ʼ���
                if(sLastManageStatFlag.equals("1")&& sManageStatFlag.equals("2"))
                {
                    //���ڲ���������Ҫ���㱾���ֽ�������ֵ
                    sABadPrdDiscount = reserveCalculate.getCurPredictCapital(alReserveBasicData, "A")+"";//��Ʋ�ھ����������Ԥ���ֽ�������ֵ
                    //����ReserveCalculate�ļ��㹫ʽReserveCalculateFormula4
                    alReserveCalculateData = reserveCalculate.ReserveCalculateFormula4(alLastReserveBasicData,alReserveBasicData, "A");
                    if(!alReserveCalculateData.isEmpty())
                    {                               
                        sAExforLoss = (String)alReserveCalculateData.get(1);//��ƿھ����ڴ���������
                        sABadReserveSum = (String)alReserveCalculateData.get(2);//��ƿھ���������ڼ����ֵ׼��
                        sABadReserveBalance = String.valueOf(reserveCalculate.getSingleReserveSum(alReserveBasicData,"A"));//��ƿھ���������ڼ�ֵ׼�����
                        sANormalMinusSum = (String)alReserveCalculateData.get(6);//��ƿھ���������ڳ�����ֵ׼��
                    }
                }else 
                {
                    //ĳ�ʴ�������Ϊ���ʼ���������Ϊ���ʼ������
                    if(sLastManageStatFlag.equals("2")&& sManageStatFlag.equals("2"))
                    {
                        //������������Ԥ���ֽ�����������ֵ
                        sABadLastprdDiscount = reserveCalculate.getLastPredictCapital(alLastReserveBasicData, alReserveBasicData, "A") + "";
                        //���ڲ���������Ҫ���㱾���ֽ�������ֵ
                        sABadPrdDiscount = reserveCalculate.getCurPredictCapital(alReserveBasicData, "A") + "";
                        //����ReserveCalculate�ļ��㹫ʽReserveCalculateFormula7
                        alReserveCalculateData = reserveCalculate.ReserveCalculateFormula7(alLastReserveBasicData,alReserveBasicData, "A",sBusinessFlag);
                        if(!alReserveCalculateData.isEmpty())
                        {
                            sAExforLoss = (String)alReserveCalculateData.get(1);//��ƿھ����ڴ���������
                            sABadReserveSum = (String)alReserveCalculateData.get(2);//��ƿھ���������ڼ����ֵ׼��
                            sABadMinusSum = (String)alReserveCalculateData.get(3);//��ƿھ���������ڳ�����ֵ׼��
                            sABadRetSum = (String)alReserveCalculateData.get(4);//��ƿھ����������ת�ؼ�ֵ׼��
                            sABadReserveBalance = String.valueOf(reserveCalculate.getSingleReserveSum(alReserveBasicData,"A"));//��ƿھ���������ڼ�ֵ׼�����
                        }
                    }
                 }         
            }           
        }
        //��������õ���Ϣ����ڴ������ݿ����alReserveTotal��
        alReserveTotal.add(0, sAccountMonth); //����·�
        alReserveTotal.add(1, sLoanAccountNo); //�����ʺ�
        alReserveTotal.add(2, sMCancelReserveSum); //�����ھ�������ֵ׼��
        alReserveTotal.add(3, sACancelReserveSum); //��ƿھ�������ֵ׼��
        alReserveTotal.add(4, sMExforLoss); //�����ھ��������
        alReserveTotal.add(5, sAExforLoss); //��ƿھ��������
        alReserveTotal.add(6, sMBadLastPrdDiscount); //�����ھ�����Ԥ���ֽ�����������ֵ
        alReserveTotal.add(7, sMBadPrdDiscount); //�����ھ����������Ԥ���ֽ�������ֵ
        alReserveTotal.add(8, sMBadReserveSum); //�����ھ���������ڼ����ֵ׼��
        alReserveTotal.add(9, sMBadMinusSum); //�����ھ���������ڳ�����ֵ׼��
        alReserveTotal.add(10, sMBadRetSum); //�����ھ����������ת�ؼ�ֵ׼��
        alReserveTotal.add(11, sMBadReserveBalance); //�����ھ���������ڼ�ֵ׼�����
        alReserveTotal.add(12, sABadLastprdDiscount); //��ƿھ�������������Ԥ���ֽ�����������ֵ
        alReserveTotal.add(13, sABadPrdDiscount); //��ƿھ����������Ԥ���ֽ�������ֵ
        alReserveTotal.add(14, sABadReserveSum); //��ƿھ���������ڼ����ֵ׼��
        alReserveTotal.add(15, sABadMinusSum); //��ƿھ���������ڳ�����ֵ׼��
        alReserveTotal.add(16, sABadRetSum); //��ƿھ����������ת�ؼ�ֵ׼��
        alReserveTotal.add(17, sABadReserveBalance); //��ƿھ���������ڼ�ֵ׼�����
        alReserveTotal.add(18, sMNormalReserveSum); //�����ھ���������ڼ����ֵ׼��
        alReserveTotal.add(19, sMNormalMinusSum); //�����ھ���������ڳ�����ֵ׼��
        alReserveTotal.add(20, sMNormalReserveBalance); //�����ھ���������ڼ�ֵ׼�����
        alReserveTotal.add(21, sANormalReserveSum); //��ƿھ���������ڼ����ֵ׼��
        alReserveTotal.add(22, sANormalMinusSum); //��ƿھ���������ڳ�����ֵ׼��
        alReserveTotal.add(23, sANormalReserveBalance); //��ƿھ���������ڼ�ֵ׼�����
        alReserveTotal.add(24, dRetSum+""); //�����ջؽ��
        alReserveTotal.add(25, dOmitSum+""); //���ں������
        
        return alReserveTotal;
    }
		
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try
		{
			java.sql.Connection conn = ConnectionManager.getConnection("jdbc:informix-sqli://38.19.7.31:1526/als6hs:INFORMIXSERVER=hsxd_kf",
					"com.informix.jdbc.IfxDriver", "informix", "informix");
			Transaction Sqlca = new Transaction(conn);
			BatchReserveInfo bri = new BatchReserveInfo(Sqlca);
	
			String sql = "select * from reserve_total where accountmonth = '2008/05' ";
			ASResultSet rs = Sqlca.getASResultSet(sql);
			while(rs.next()){
               System.out.println("������"+ rs.getString("LoanAccount"));
			   bri.runCalculateData(rs.getString("AccountMonth"), rs.getString("LoanAccount"),rs.getString("ManageStatFlag"),rs.getString("BusinessFlag"));
			}
			rs.getStatement().close();

			//bri.runCalculateData("2006/12", "01090302900113001000619");
			//bri.runCheckBasicData();
			Sqlca.conn.commit();
			
		}catch(Exception e)
		{
			e.printStackTrace();
			System.out.println(e.toString());
		}
	}
}
