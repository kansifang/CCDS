/**
		Author: --fhuang 2006-12-28
		Tester:
		Describe: --����Approve_Performance_D�������
				  --��������е�����Ϊ�������ݣ�����������ˮ���е����ݣ����������ͳ����Approve_Performance_D��
				  --ÿ��������һ��
		Input Param:
		Output Param:
		HistoryLog:
*/
package com.amarsoft.app.performance;

import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.*;


public class CreatePerformanceData extends Bizlet {	
	public final static String AGREEMENT = "ͬ��";
	public final static String DISAGREEMENT = "���";
	public final static String DEALING = "�˻ز�������";
	
	public Object run(Transaction Sqlca) throws Exception{
		String sSTATISTICDATE = (String)this.getAttribute("STATISTICDATE");//ͳ������ 
		//ͳ������Ϊ����������ʱ��,����Ϊ��ʱ���ǰһ��,��������趨
		if(sSTATISTICDATE ==null)
			sSTATISTICDATE = StringFunction.getToday();
		
		String sSerialNo = "";//������ˮ��
		String sORGID = "";//��������
		String sUSERID = "";//������Ա
		String sFLOWNO = "";//���̱��
		String sPHASENO = "";//�׶α��
		int iCURRDEALCOUNT = 0;//Ŀǰ�������ܱ���
		double dCURRDEALSUM = 0.00;//Ŀǰ�������ܽ��
		//���뱻���������������׼���������;�������ͣ����̽׶�Ҫ�޳�0010(�Ŵ�Ա׼���׶�)��3000���˻ز������ϣ�
		int iMAGGREECOUNT = 0;//������׼�ܱ���
		int iMDISAGREECOUNT = 0;//���·���ܱ���
		int iMAFLOATCOUNT = 0;//������;�ܱ���	
		int iMAGGREETIME = 0;//������׼�ܺ�ʱ
		int iMDISAGREETIME = 0;//���·���ܺ�ʱ
		int iMAFLOATTIME = 0;//������;�ܺ�ʱ	
		//���뱻��׼������׼����Ϊ���µ�ҵ��
		int iMNAPPROVECOUNT = 0;//����δǩ�����ܱ���
		double dMNAPPROVESUM = 0.00;//����δǩ�����ܽ��
		int iMNCONTRACTCOUNT = 0;//����δǩ��ͬ�ܱ���
		double dMNCONTRACTSUM = 0.00;//����δǩ��ͬ�ܽ�� 
		int iMNPUTOUTCOUNT = 0;//����δ�Ŵ�����
		double dMNPUTOUTSUM = 0.00;//����δ�Ŵ���� 
		//���뱻��׼������׼����Ϊ���µ�ҵ��(����ݷ���)
		double dMNORMALSUM = 0.00;//�����������
		double dMATTENTIONSUM = 0.00;//���¹�ע���
		double dMSECONDARYSUM = 0.00;//���´μ����
		double dMSHADINESSSUM = 0.00;//���¿������
		double dMLOSSSUM = 0.00;//������ʧ���
		//���������ڱ���,�ҷ��,��׼����;��ҵ����
		double dMAPPLYSUM = 0.00;//���������ܽ��
	   //���뱻���������������׼���������;�������ͣ����̽׶�Ҫ�޳�0010(�Ŵ�Ա׼���׶�)��3000���˻ز������ϣ�
		int iYAGGREECOUNT = 0;//������׼�ܱ���
		int iYDISAGREECOUNT = 0;//�������ܱ���
		int iYAFLOATCOUNT = 0;//������;�ܱ���	
		int iYAGGREETIME = 0;//������׼�ܺ�ʱ
		int iYDISAGREETIME = 0;//�������ܺ�ʱ
		int iYAFLOATTIME = 0;//������;�ܺ�ʱ
		//���뱻��׼������׼����Ϊ�����ҵ��
		int iYNAPPROVECOUNT= 0;//����δǩ�����ܱ���
		double dYNAPPROVESUM = 0.00;//����δǩ�����ܽ��
		int iYNCONTRACTCOUNT = 0;//����δǩ��ͬ�ܱ���
		double dYNCONTRACTSUM = 0.00;//����δǩ��ͬ�ܽ�� 
		int iYNPUTOUTCOUNT = 0;//����δ�Ŵ�����
		double dYNPUTOUTSUM = 0.00;//����δ�Ŵ����
		//���뱻��׼������׼����Ϊ�����ҵ��(����ݷ���)
		double dYNORMALSUM = 0.00;//�����������
		double dYATTENTIONSUM = 0.00;//�����ע���
		double dYSECONDARYSUM = 0.00;//����μ����
		double dYSHADINESSSUM = 0.00;//����������
		double dYLOSSSUM = 0.00;//������ʧ���
		//���������ڱ���,�ҷ��,��׼����;��ҵ����
		double dYAPPLYSUM = 0.00;//���������ܽ��
		
	    //���뱻���������������׼���������;�������ͣ����̽׶�Ҫ�޳�0010(�Ŵ�Ա׼���׶�)��3000���˻ز������ϣ�
		int iCAGGREECOUNT = 0;//��ǰ�ۼ���׼�ܱ���
		int iCDISAGREECOUNT = 0;//��ǰ�ۼƷ���ܱ���
		int iCAFLOATCOUNT = 0;//��ǰ�ۼ���;�ܱ���	
		int iCAGGREETIME = 0;//��ǰ�ۼ���׼�ܺ�ʱ
		int iCDISAGREETIME = 0;//��ǰ�ۼƷ���ܺ�ʱ
		int iCAFLOATTIME = 0;//��ǰ�ۼ���;�ܺ�ʱ
		//���뱻��׼
		int iCNAPPROVECOUNT= 0;//��ǰ�ۼ�δǩ�����ܱ���
		double dCNAPPROVESUM = 0.00;//��ǰ�ۼ���δǩ�����ܽ��
		int iCNCONTRACTCOUNT = 0;//��ǰ�ۼ�δǩ��ͬ�ܱ���
		double dCNCONTRACTSUM = 0.00;//��ǰ�ۼ�δǩ��ͬ�ܽ�� 
		int iCNPUTOUTCOUNT = 0;//��ǰ�ۼ�δ�Ŵ�����
		double dCNPUTOUTSUM = 0.00;//��ǰ�ۼ�δ�Ŵ����
		//���뱻��׼(����ݷ���)
		double dCNORMALSUM = 0.00;//��ǰ�ۼ��������
		double dCATTENTIONSUM = 0.00;//��ǰ�ۼƹ�ע���
		double dCSECONDARYSUM = 0.00;//��ǰ�ۼƴμ����
		double dCSHADINESSSUM = 0.00;//��ǰ�ۼƿ������
		double dCLOSSSUM = 0.00;//��ǰ�ۼ���ʧ���		
		//���������ڵ�ǰ,�ҷ��,��׼����;��ҵ����
		double dCAPPLYSUM = 0.00;//��ǰ�ۼ������ܽ��


		//�����Approve_Performance_D�е����ݼ�¼
		clearRecord(Sqlca);		
		String sSql = "";
		ASResultSet rs = null;
		sSql = " select SerialNo,BusinessSum*getERate(BusinessCurrency,'01','"+sSTATISTICDATE+"') "+
			   " as BusinessSum,OccurDate from Business_Apply where exists ("+
			   " select 1 from Flow_Object where ObjectType='CreditApply' "+
			   " and ObjectNo=Business_Apply.SerialNo)";
		rs = Sqlca.getASResultSet(sSql);
		while(rs.next())
		{
			sSerialNo = rs.getString("SerialNo");//������ˮ��
			double dBusinessSum = rs.getDouble("BusinessSum");//������
			String sOccurDate = rs.getString("OccurDate");
			//����Flow_Task���Ƿ���ڳ�0010,3000���Ŵ�Ա�ģ���Ľ׶Ρ�
			String sSql1 = "";
			ASResultSet rs1 = null;
			int iCount = 0;
			sSql1 = " select count(*) from Flow_Task where ObjectType='CreditApply' " +
					" and PhaseNo not in ('0010','3000') and ObjectNo='"+sSerialNo+"'"; 
			rs1 = Sqlca.getASResultSet(sSql1);
			if(rs1.next())
			{
				iCount = rs1.getInt(1);
			}
			rs1.getStatement().close();
			if(iCount==0) continue;
			
			//����Flow_Object�еĸñ�ҵ���״̬
			 String sStatus = "";//1000,8000 or ����
			 sSql1 = " select PhaseNo from Flow_Object where ObjectType='CreditApply' " +
			 		 " and ObjectNo='"+sSerialNo+"'";
			 rs1 = Sqlca.getASResultSet(sSql1);
			 if(rs1.next())
			 {
				 sStatus = rs1.getString("PhaseNo");
			 }
			 else
			 {
				 System.out.println("Flow_Object�����޴�ҵ��"+sSerialNo+"��¼");
			 }
			 rs1.getStatement().close();
			 //1000��ʾ��׼,8000��ʾ���,����Ϊ��;
			 
			 //���Ҹñ�ҵ���FlowNo,PhaseNo,UserID���������
			 sSql1 = " select FlowNo,PhaseNo,UserID,Count(*) from Flow_Task where "+
			         " ObjectType='CreditApply' and PhaseNo not in ('0010','1000','3000','8000')"+
			         " and ObjectNo='"+sSerialNo+"' group by FlowNo,PhaseNo,UserID";
			 rs1 = Sqlca.getASResultSet(sSql1);
			 while(rs1.next())
			 {
				 sFLOWNO = rs1.getString("FlowNo");
				 sPHASENO = rs1.getString("PhaseNo");
				 sUSERID = rs1.getString("UserID");
				 iCount = rs1.getInt(4);
				 //����UserID���OrgID
				 sORGID = Sqlca.getString("select BelongOrg from User_Info where UserID='"+sUSERID+"'");
				 //����Flow_Task��EndTime �Ƿ�Ϊ�����ж�Ŀǰ�����������ͽ��
				 String sSql2 = " select count(*) from Flow_Task where ObjectType='CreditApply' "+
				                " and ObjectNo='"+sSerialNo+"' and UserID='"+sUSERID+"' "+
				                " and PhaseNo='"+sPHASENO+"' and FlowNo='"+sFLOWNO+"' "+
				                " and EndTime is null";
				ASResultSet rs2 = Sqlca.getASResultSet(sSql2);
				int iCount2 = 0;
				 if(rs2.next())
				 {
					 iCount2 = rs2.getInt(1);
				 }
				 rs2.getStatement().close();
				 if(iCount2>=1)
				 {
					iCURRDEALCOUNT = 1;//Ŀǰ�������ܱ���
					dCURRDEALSUM = dBusinessSum;//Ŀǰ�������ܽ��
				 }
				 else
				 {
					 iCURRDEALCOUNT = 0;//Ŀǰ�������ܱ���
					 dCURRDEALSUM = 0.00;//Ŀǰ�������ܽ��
				 }
				 dMAPPLYSUM = getBusinessSum(sOccurDate,sSTATISTICDATE,dBusinessSum,"M");//���������ܽ��
				 dYAPPLYSUM = getBusinessSum(sOccurDate,sSTATISTICDATE,dBusinessSum,"Y");//���������ܽ��
				 dCAPPLYSUM = dBusinessSum;//��ǰ�ۼ������ܽ��	
				 //1.ҵ������״̬������׼�������������;��
				 if(!sStatus.equals("1000")&&!sStatus.equals("8000"))
				 {
						iMAGGREECOUNT = 0;//������׼�ܱ���
						iMDISAGREECOUNT = 0;//���·���ܱ���
						iMAFLOATCOUNT = 1;//������;�ܱ���	
						iMAGGREETIME = 0;//������׼�ܺ�ʱ
						iMDISAGREETIME = 0;//���·���ܺ�ʱ
						iMAFLOATTIME = getSumTime(sSerialNo,sFLOWNO,sPHASENO,sUSERID,Sqlca);//������;�ܺ�ʱ
						iMNAPPROVECOUNT = 0;//����δǩ�����ܱ���
						dMNAPPROVESUM = 0.00;//����δǩ�����ܽ��
						iMNCONTRACTCOUNT = 0;//����δǩ��ͬ�ܱ���
						dMNCONTRACTSUM = 0.00;//����δǩ��ͬ�ܽ�� 
						iMNPUTOUTCOUNT = 0;//����δ�Ŵ�����
						dMNPUTOUTSUM = 0.00;//����δ�Ŵ����
						dMNORMALSUM = 0.00;//�����������
						dMATTENTIONSUM = 0.00;//���¹�ע���
						dMSECONDARYSUM = 0.00;//���´μ����
						dMSHADINESSSUM = 0.00;//���¿������
						dMLOSSSUM = 0.00;//������ʧ���
						
						iYAGGREECOUNT = 0;//������׼�ܱ���
						iYDISAGREECOUNT = 0;//�������ܱ���
						iYAFLOATCOUNT = 1;//������;�ܱ���	
						iYAGGREETIME = 0;//������׼�ܺ�ʱ
						iYDISAGREETIME = 0;//�������ܺ�ʱ
						iYAFLOATTIME = iMAFLOATTIME;//������;�ܺ�ʱ
						iYNAPPROVECOUNT= 0;//����δǩ�����ܱ���
						dYNAPPROVESUM = 0.00;//����δǩ�����ܽ��
						iYNCONTRACTCOUNT = 0;//����δǩ��ͬ�ܱ���
						dYNCONTRACTSUM = 0.00;//����δǩ��ͬ�ܽ�� 
						iYNPUTOUTCOUNT = 0;//����δ�Ŵ�����
						dYNPUTOUTSUM = 0.00;//����δ�Ŵ����
						dYNORMALSUM = 0.00;//�����������
						dYATTENTIONSUM = 0.00;//�����ע���
						dYSECONDARYSUM = 0.00;//����μ����
						dYSHADINESSSUM = 0.00;//����������
						dYLOSSSUM = 0.00;//������ʧ���
					
						iCAGGREECOUNT = 0;//��ǰ�ۼ���׼�ܱ���
						iCDISAGREECOUNT = 0;//��ǰ�ۼƷ���ܱ���
						iCAFLOATCOUNT = 1;//��ǰ�ۼ���;�ܱ���	
						iCAGGREETIME = 0;//��ǰ�ۼ���׼�ܺ�ʱ
						iCDISAGREETIME = 0;//��ǰ�ۼƷ���ܺ�ʱ
						iCAFLOATTIME = iMAFLOATTIME;//��ǰ�ۼ���;�ܺ�ʱ
						iCNAPPROVECOUNT= 0;//��ǰ�ۼ�δǩ�����ܱ���
						dCNAPPROVESUM = 0.00;//��ǰ�ۼ���δǩ�����ܽ��
						iCNCONTRACTCOUNT = 0;//��ǰ�ۼ�δǩ��ͬ�ܱ���
						dCNCONTRACTSUM = 0.00;//��ǰ�ۼ�δǩ��ͬ�ܽ�� 
						iCNPUTOUTCOUNT = 0;//��ǰ�ۼ�δ�Ŵ�����
						dCNPUTOUTSUM = 0.00;//��ǰ�ۼ�δ�Ŵ����
						dCNORMALSUM = 0.00;//��ǰ�ۼ��������
						dCATTENTIONSUM = 0.00;//��ǰ�ۼƹ�ע���
						dCSECONDARYSUM = 0.00;//��ǰ�ۼƴμ����
					    dCSHADINESSSUM = 0.00;//��ǰ�ۼƿ������
						dCLOSSSUM = 0.00;//��ǰ�ۼ���ʧ���						 
				 }else if (sStatus.equals("8000"))//����Ϊ���
				 {
						String sPhaseOpinion = getPhaseOpinion(sSerialNo,sFLOWNO,sPHASENO,sUSERID,Sqlca);
						String sEndTime = getEndTime(sSerialNo,sFLOWNO,sPHASENO,sUSERID,Sqlca);
						int sSumTime = getSumTime(sSerialNo,sFLOWNO,sPHASENO,sUSERID,Sqlca);
						//----���㵱ǰ������
						if(sPhaseOpinion.equals(AGREEMENT))
						{
							iCAGGREECOUNT = 1;//��ǰ�ۼ���׼�ܱ���
							iCDISAGREECOUNT = 0;//��ǰ�ۼƷ���ܱ���
							iCAGGREETIME = sSumTime;//��ǰ�ۼ���׼�ܺ�ʱ
							iCDISAGREETIME = 0;//��ǰ�ۼƷ���ܺ�ʱ
						}else if(sPhaseOpinion.equals(DISAGREEMENT)) 
						{
							iCAGGREECOUNT = 0;//��ǰ�ۼ���׼�ܱ���
							iCDISAGREECOUNT = 1;//��ǰ�ۼƷ���ܱ���
							iCAGGREETIME = 0;//��ǰ�ۼ���׼�ܺ�ʱ
							iCDISAGREETIME = sSumTime;//��ǰ�ۼƷ���ܺ�ʱ
						}
						else
						{
							throw new Exception("Flow_Task�г�����δ�����PhaseOpinion,���飡");
						}
						iCAFLOATCOUNT = 0;//��ǰ�ۼ���;�ܱ���	
						iCAFLOATTIME = 0;//��ǰ�ۼ���;�ܺ�ʱ
						iCNAPPROVECOUNT= 0;//��ǰ�ۼ�δǩ�����ܱ���
						dCNAPPROVESUM = 0.00;//��ǰ�ۼ���δǩ�����ܽ��
						iCNCONTRACTCOUNT = 0;//��ǰ�ۼ�δǩ��ͬ�ܱ���
						dCNCONTRACTSUM = 0.00;//��ǰ�ۼ�δǩ��ͬ�ܽ�� 
						iCNPUTOUTCOUNT = 0;//��ǰ�ۼ�δ�Ŵ�����
						dCNPUTOUTSUM = 0.00;//��ǰ�ۼ�δ�Ŵ����
						dCNORMALSUM = 0.00;//��ǰ�ۼ��������
						dCATTENTIONSUM = 0.00;//��ǰ�ۼƹ�ע���
						dCSECONDARYSUM = 0.00;//��ǰ�ۼƴμ����
					    dCSHADINESSSUM = 0.00;//��ǰ�ۼƿ������
						dCLOSSSUM = 0.00;//��ǰ�ۼ���ʧ���
						
						if(!sEndTime.equals("") && sEndTime.substring(0,4).equals(sSTATISTICDATE.substring(0,4)))//ͳ�Ʊ���
						{
							iYAGGREECOUNT = iCAGGREECOUNT;//������׼�ܱ���
							iYDISAGREECOUNT = iCDISAGREECOUNT;//�������ܱ���
							iYAGGREETIME = iCAGGREETIME;//������׼�ܺ�ʱ
							iYDISAGREETIME = iCDISAGREETIME;//�������ܺ�ʱ
							iYAFLOATCOUNT = 0;//������;�ܱ���	
							iYAFLOATTIME = 0;//������;�ܺ�ʱ
							iYNAPPROVECOUNT= 0;//����δǩ�����ܱ���
							dYNAPPROVESUM = 0.00;//����δǩ�����ܽ��
							iYNCONTRACTCOUNT = 0;//����δǩ��ͬ�ܱ���
							dYNCONTRACTSUM = 0.00;//����δǩ��ͬ�ܽ�� 
							iYNPUTOUTCOUNT = 0;//����δ�Ŵ�����
							dYNPUTOUTSUM = 0.00;//����δ�Ŵ����
							dYNORMALSUM = 0.00;//�����������
							dYATTENTIONSUM = 0.00;//�����ע���
							dYSECONDARYSUM = 0.00;//����μ����
							dYSHADINESSSUM = 0.00;//����������
							dYLOSSSUM = 0.00;//������ʧ���
							if(sEndTime.substring(0,7).equals(sSTATISTICDATE.substring(0,7)))//ͳ�Ʊ�������(���µ����ֺͱ���һ��)
							{
								iMAGGREECOUNT = iYAGGREECOUNT;//������׼�ܱ���
								iMDISAGREECOUNT = iYDISAGREECOUNT;//���·���ܱ���
								iMAFLOATCOUNT = 0;//������;�ܱ���	
								iMAGGREETIME = iYAGGREETIME;//������׼�ܺ�ʱ
								iMDISAGREETIME = iYDISAGREETIME;//���·���ܺ�ʱ
								iMAFLOATTIME = 0;//������;�ܺ�ʱ
								iMNAPPROVECOUNT = 0;//����δǩ�����ܱ���
								dMNAPPROVESUM = 0.00;//����δǩ�����ܽ��
								iMNCONTRACTCOUNT = 0;//����δǩ��ͬ�ܱ���
								dMNCONTRACTSUM = 0.00;//����δǩ��ͬ�ܽ�� 
								iMNPUTOUTCOUNT = 0;//����δ�Ŵ�����
								dMNPUTOUTSUM = 0.00;//����δ�Ŵ����
								dMNORMALSUM = 0.00;//�����������
								dMATTENTIONSUM = 0.00;//���¹�ע���
								dMSECONDARYSUM = 0.00;//���´μ����
								dMSHADINESSSUM = 0.00;//���¿������
								dMLOSSSUM = 0.00;//������ʧ���
							}
							else//���Ǳ��µ�ֵ,���µ�ֵȫ��Ϊ0
							{
								iMAGGREECOUNT = 0;//������׼�ܱ���
								iMDISAGREECOUNT = 0;//���·���ܱ���
								iMAFLOATCOUNT = 0;//������;�ܱ���	
								iMAGGREETIME = 0;//������׼�ܺ�ʱ
								iMDISAGREETIME = 0;//���·���ܺ�ʱ
								iMAFLOATTIME = 0;//������;�ܺ�ʱ
								iMNAPPROVECOUNT = 0;//����δǩ�����ܱ���
								dMNAPPROVESUM = 0.00;//����δǩ�����ܽ��
								iMNCONTRACTCOUNT = 0;//����δǩ��ͬ�ܱ���
								dMNCONTRACTSUM = 0.00;//����δǩ��ͬ�ܽ�� 
								iMNPUTOUTCOUNT = 0;//����δ�Ŵ�����
								dMNPUTOUTSUM = 0.00;//����δ�Ŵ����
								dMNORMALSUM = 0.00;//�����������
								dMATTENTIONSUM = 0.00;//���¹�ע���
								dMSECONDARYSUM = 0.00;//���´μ����
								dMSHADINESSSUM = 0.00;//���¿������
								dMLOSSSUM = 0.00;//������ʧ���
							}
								
						}
						else//���ǵ����ֵ,���굱�µ�ֵ��Ϊ0
						{
							iYAGGREECOUNT = 0;//������׼�ܱ���
							iYDISAGREECOUNT = 0;//�������ܱ���
							iYAGGREETIME = 0;//������׼�ܺ�ʱ
							iYDISAGREETIME = 0;//�������ܺ�ʱ
							iYAFLOATCOUNT = 0;//������;�ܱ���	
							iYAFLOATTIME = 0;//������;�ܺ�ʱ
							iYNAPPROVECOUNT= 0;//����δǩ�����ܱ���
							dYNAPPROVESUM = 0.00;//����δǩ�����ܽ��
							iYNCONTRACTCOUNT = 0;//����δǩ��ͬ�ܱ���
							dYNCONTRACTSUM = 0.00;//����δǩ��ͬ�ܽ�� 
							iYNPUTOUTCOUNT = 0;//����δ�Ŵ�����
							dYNPUTOUTSUM = 0.00;//����δ�Ŵ����
							dYNORMALSUM = 0.00;//�����������
							dYATTENTIONSUM = 0.00;//�����ע���
							dYSECONDARYSUM = 0.00;//����μ����
							dYSHADINESSSUM = 0.00;//����������
							dYLOSSSUM = 0.00;//������ʧ���
							iMAGGREECOUNT = 0;//������׼�ܱ���
							iMDISAGREECOUNT = 0;//���·���ܱ���
							iMAFLOATCOUNT = 0;//������;�ܱ���	
							iMAGGREETIME = 0;//������׼�ܺ�ʱ
							iMDISAGREETIME = 0;//���·���ܺ�ʱ
							iMAFLOATTIME = 0;//������;�ܺ�ʱ
							iMNAPPROVECOUNT = 0;//����δǩ�����ܱ���
							dMNAPPROVESUM = 0.00;//����δǩ�����ܽ��
							iMNCONTRACTCOUNT = 0;//����δǩ��ͬ�ܱ���
							dMNCONTRACTSUM = 0.00;//����δǩ��ͬ�ܽ�� 
							iMNPUTOUTCOUNT = 0;//����δ�Ŵ�����
							dMNPUTOUTSUM = 0.00;//����δ�Ŵ����
							dMNORMALSUM = 0.00;//�����������
							dMATTENTIONSUM = 0.00;//���¹�ע���
							dMSECONDARYSUM = 0.00;//���´μ����
							dMSHADINESSSUM = 0.00;//���¿������
							dMLOSSSUM = 0.00;//������ʧ���
						}
				 }
				 else//����Ϊ��׼
				 {
					String sPhaseOpinion = getPhaseOpinion(sSerialNo,sFLOWNO,sPHASENO,sUSERID,Sqlca);
					String sEndTime = getEndTime(sSerialNo,sFLOWNO,sPHASENO,sUSERID,Sqlca);
					int sSumTime = getSumTime(sSerialNo,sFLOWNO,sPHASENO,sUSERID,Sqlca);
					//System.out.println("���������,"+sPhaseOpinion+",����ʱ�䣺"+sEndTime+",������ʱ,"+sSumTime);
					//�ȼ��㵱ǰ��ֵ
					if(sPhaseOpinion.equals(AGREEMENT))
					{
						iCAGGREECOUNT = 1;//��ǰ�ۼ���׼�ܱ���
						iCDISAGREECOUNT = 0;//��ǰ�ۼƷ���ܱ���
						iCAGGREETIME = sSumTime;//��ǰ�ۼ���׼�ܺ�ʱ
						iCDISAGREETIME = 0;//��ǰ�ۼƷ���ܺ�ʱ
					}else if(sPhaseOpinion.equals(DISAGREEMENT)) 
					{
						iCAGGREECOUNT = 0;//��ǰ�ۼ���׼�ܱ���
						iCDISAGREECOUNT = 1;//��ǰ�ۼƷ���ܱ���
						iCAGGREETIME = 0;//��ǰ�ۼ���׼�ܺ�ʱ
						iCDISAGREETIME = sSumTime;//��ǰ�ۼƷ���ܺ�ʱ
					}
					else
					{
						throw new Exception("Flow_Task�г�����δ�����PhaseOpinion,���飡");
					}
					iCAFLOATCOUNT = 0;//��ǰ�ۼ���;�ܱ���	
					iCAFLOATTIME = 0;//��ǰ�ۼ���;�ܺ�ʱ
					
					//�ж�δǩ���Ƚ��鷳,�����һ�������˵��������Ϊ׼.
					sSql2 = " Select count(*) from Business_Approve "+
							" where RelativeSerialNo='"+sSerialNo+"'";
					rs2 = Sqlca.getASResultSet(sSql2);
					//System.out.println(sSql2);
					int iCount3 = 0;
					if(rs2.next())
					{
						iCount3 = rs2.getInt(1);
					}
					rs2.getStatement().close();
					if(iCount3==0)
					{
						iCNAPPROVECOUNT = 1;//��ǰ�ۼ�δǩ�����ܱ���
					}
					else
					{
						iCNAPPROVECOUNT= 0;//��ǰ�ۼ�δǩ�����ܱ���
					}
					if(iCNAPPROVECOUNT == 1)//δǩ����
					{
						String sSql3 = " select BusinessSum*getERate(BusinessCurrency,'01','"+sSTATISTICDATE+
									   "') as BusinessSum from Flow_Opinion "+
									   " where OpinionNo=(select SerialNo from Flow_Task "+
									   " where ObjectType='CreditApply' and PhaseNo='1000' "+
									   " and ObjectNo='"+sSerialNo+"')";
						ASResultSet rs3 = Sqlca.getASResultSet(sSql3);
						
						if(rs3.next())
						{
							dCNAPPROVESUM = rs3.getDouble(1);//��ǰ�ۼ���δǩ�����ܽ��
							rs3.getStatement().close();
						}
						else
						{
							rs3.getStatement().close();
							throw new Exception ("δ�ҵ�ҵ�������˵����!");
						}
						//--δǩ��������������ֵ��Ϊ0
						iCNCONTRACTCOUNT = 0;//��ǰ�ۼ�δǩ��ͬ�ܱ���
						dCNCONTRACTSUM = 0.00;//��ǰ�ۼ�δǩ��ͬ�ܽ�� 
						iCNPUTOUTCOUNT = 0;//��ǰ�ۼ�δ�Ŵ�����
						dCNPUTOUTSUM = 0.00;//��ǰ�ۼ�δ�Ŵ����
						dCNORMALSUM = 0.00;//��ǰ�ۼ��������
						dCATTENTIONSUM = 0.00;//��ǰ�ۼƹ�ע���
						dCSECONDARYSUM = 0.00;//��ǰ�ۼƴμ����
					    dCSHADINESSSUM = 0.00;//��ǰ�ۼƿ������
						dCLOSSSUM = 0.00;//��ǰ�ۼ���ʧ���
					}
					else
					{
						dCNAPPROVESUM = 0.00;//��ǰ�ۼ���δǩ�����ܽ��
						//���������ˮ�ź��������
						String sSql3 = " Select SerialNo,BusinessSum*getERate(BusinessCurrency,'01','"+sSTATISTICDATE+
									   "') as BusinessSum from Business_Approve "+
									   " where RelativeSerialNo='"+sSerialNo+"'";
						ASResultSet rs3 = Sqlca.getASResultSet(sSql3);
						String sApproveSerialNo = "";
						int iCount4 = 0;
						double dApproveSum = 0.00;
						if(rs3.next())
						{
							sApproveSerialNo = rs3.getString("SerialNo");//������ˮ��
							dApproveSum = rs3.getDouble("BusinessSum");//�������еĽ��
						}
						rs3.getStatement().close();
						sSql3 = " Select count(*) from Business_Contract "+
								" where RelativeSerialNo='"+sApproveSerialNo+"'";
						rs3 = Sqlca.getASResultSet(sSql3);
						if(rs3.next())
						{
							iCount4 = rs3.getInt(1);//������ˮ��
						}
						rs3.getStatement().close();
						if(iCount4==0)
						{
							iCNCONTRACTCOUNT = 1;//��ǰ�ۼ�δǩ��ͬ�ܱ���
							dCNCONTRACTSUM = dApproveSum;//��ǰ�ۼ�δǩ��ͬ�ܽ��
							//----δǩ��ͬ���µ�ֵ��Ϊ0
							iCNPUTOUTCOUNT = 0;//��ǰ�ۼ�δ�Ŵ�����
							dCNPUTOUTSUM = 0.00;//��ǰ�ۼ�δ�Ŵ����
							dCNORMALSUM = 0.00;//��ǰ�ۼ��������
							dCATTENTIONSUM = 0.00;//��ǰ�ۼƹ�ע���
							dCSECONDARYSUM = 0.00;//��ǰ�ۼƴμ����
						    dCSHADINESSSUM = 0.00;//��ǰ�ۼƿ������
							dCLOSSSUM = 0.00;//��ǰ�ۼ���ʧ���
						}
						else
						{
							iCNCONTRACTCOUNT = 0;//��ǰ�ۼ�δǩ��ͬ�ܱ���
							dCNCONTRACTSUM = 0.00;//��ǰ�ۼ�δǩ��ͬ�ܽ��
							//�ж��Ƿ�Ŵ���������ActualPutoutSum�Ƿ�>0
							String sSql4 = " select count(*) from Business_Contract "+
										   " where ActualPutoutSum>0 and RelativeSerialNo='"+sApproveSerialNo+"'";
							ASResultSet rs4 = Sqlca.getASResultSet(sSql4);
							int iCount5 = 0;
							if(rs4.next())
							{
								iCount5 = rs4.getInt(1);
							}
							rs4.getStatement().close();
							if(iCount5==0)
							{
								iCNPUTOUTCOUNT = 1;//��ǰ�ۼ�δ�Ŵ�����
								dCNPUTOUTSUM = dApproveSum;//��ǰ�ۼ�δ�Ŵ����
								//----δ�Ŵ����µ�ֵ��Ϊ0
								dCNORMALSUM = 0.00;//��ǰ�ۼ��������
								dCATTENTIONSUM = 0.00;//��ǰ�ۼƹ�ע���
								dCSECONDARYSUM = 0.00;//��ǰ�ۼƴμ����
							    dCSHADINESSSUM = 0.00;//��ǰ�ۼƿ������
								dCLOSSSUM = 0.00;//��ǰ�ۼ���ʧ���
							}else
							{
								iCNPUTOUTCOUNT = 0;//��ǰ�ۼ�δ�Ŵ�����
								dCNPUTOUTSUM = 0.00;//��ǰ�ۼ�δ�Ŵ����
								String sContractSerialNo = "";
								sContractSerialNo = Sqlca.getString(" Select SerialNo from Business_Contract where RelativeSerialNo='"+sApproveSerialNo+"'");
								int iCount6 = 0;
								sSql4 = " select count(*) from Business_DueBill where RelativeSerialNo2='"+sContractSerialNo+"'";
								rs4 = Sqlca.getASResultSet(sSql4);
								if(rs4.next())
								{
									iCount6 = rs4.getInt(1);
								}
								rs4.getStatement().close();
								if(iCount6==0)
								{
									dCNORMALSUM = 0.00;//��ǰ�ۼ��������
									dCATTENTIONSUM = 0.00;//��ǰ�ۼƹ�ע���
									dCSECONDARYSUM = 0.00;//��ǰ�ۼƴμ����
								    dCSHADINESSSUM = 0.00;//��ǰ�ۼƿ������
									dCLOSSSUM = 0.00;//��ǰ�ۼ���ʧ���
									//System.out.println("--------------"+sContractSerialNo);
								}else
								{
									sSql4 = " select ClassifyResult,sum(balance*getERate(BusinessCurrency,'01','"+sSTATISTICDATE+"')) as Balance "+
										    " from Business_DueBill where RelativeSerialNo2='"+sContractSerialNo+"' group by ClassifyResult";
									rs4 = Sqlca.getASResultSet(sSql4);
									while(rs4.next())
									{
										String sClassifyResult = rs4.getString("ClassifyResult");
										
										if(sClassifyResult==null) sClassifyResult = "";
										if(sClassifyResult.equals("")||sClassifyResult.equals("01"))
											dCNORMALSUM += rs4.getDouble("Balance");//��ǰ�ۼ��������(δ������������)
										else if(sClassifyResult.equals("02"))
											dCATTENTIONSUM += rs4.getDouble("Balance");//��ǰ�ۼƹ�ע���
										else if(sClassifyResult.equals("03"))
											dCSECONDARYSUM += rs4.getDouble("Balance");//��ǰ�ۼƴμ����
										else if(sClassifyResult.equals("04"))
											dCSHADINESSSUM += rs4.getDouble("Balance");//��ǰ�ۼƿ������
										else if(sClassifyResult.equals("05"))
											dCLOSSSUM += rs4.getDouble("Balance");//��ǰ�ۼ���ʧ���
										else
											throw new Exception("����δ֪���弶����Ĵ���,����!");
									}
									rs4.getStatement().close();
								}//�ж��Ƿ��н��
							}//�ж��Ƿ�Ŵ�
						}//�ж��Ƿ�ǩ��ͬ
					}//�ж��Ƿ�ǩ����
					if(!sEndTime.equals("") && sEndTime.substring(0,4).equals(sSTATISTICDATE.substring(0,4)))//ͳ�Ʊ���
					{
						iYAGGREECOUNT = iCAGGREECOUNT;//������׼�ܱ���
						iYDISAGREECOUNT = iCDISAGREECOUNT;//�������ܱ���
						iYAGGREETIME = iCAGGREETIME;//������׼�ܺ�ʱ
						iYDISAGREETIME = iCDISAGREETIME;//�������ܺ�ʱ
						iYAFLOATCOUNT = iCAFLOATCOUNT;//������;�ܱ���	
						iYAFLOATTIME = iCAFLOATTIME;//������;�ܺ�ʱ
						iYNAPPROVECOUNT= iCNAPPROVECOUNT;//����δǩ�����ܱ���
						dYNAPPROVESUM = dCNAPPROVESUM;//����δǩ�����ܽ��
						iYNCONTRACTCOUNT = iCNCONTRACTCOUNT;//����δǩ��ͬ�ܱ���
						dYNCONTRACTSUM = dCNCONTRACTSUM;//����δǩ��ͬ�ܽ�� 
						iYNPUTOUTCOUNT = iCNPUTOUTCOUNT;//����δ�Ŵ�����
						dYNPUTOUTSUM = dCNPUTOUTSUM;//����δ�Ŵ����
						dYNORMALSUM = dCNORMALSUM;//�����������
						dYATTENTIONSUM = dCATTENTIONSUM;//�����ע���
						dYSECONDARYSUM = dCSECONDARYSUM;//����μ����
						dYSHADINESSSUM = dCSHADINESSSUM;//����������
						dYLOSSSUM = dCLOSSSUM;//������ʧ���
						if(sEndTime.substring(0,7).equals(sSTATISTICDATE.substring(0,7)))//ͳ�Ʊ�������(���µ����ֺͱ���һ��)
						{
							iMAGGREECOUNT = iCAGGREECOUNT;//������׼�ܱ���
							iMDISAGREECOUNT = iCDISAGREECOUNT;//���·���ܱ���
							iMAFLOATCOUNT = iCAFLOATCOUNT;//������;�ܱ���	
							iMAGGREETIME = iCAGGREETIME;//������׼�ܺ�ʱ
							iMDISAGREETIME = iCDISAGREETIME;//���·���ܺ�ʱ
							iMAFLOATTIME = iCAFLOATTIME;//������;�ܺ�ʱ
							iMNAPPROVECOUNT = iCNAPPROVECOUNT;//����δǩ�����ܱ���
							dMNAPPROVESUM = dCNAPPROVESUM;//����δǩ�����ܽ��
							iMNCONTRACTCOUNT = iCNCONTRACTCOUNT;//����δǩ��ͬ�ܱ���
							dMNCONTRACTSUM = dCNCONTRACTSUM;//����δǩ��ͬ�ܽ�� 
							iMNPUTOUTCOUNT = iCNPUTOUTCOUNT;//����δ�Ŵ�����
							dMNPUTOUTSUM = dCNPUTOUTSUM;//����δ�Ŵ����
							dMNORMALSUM = dCNORMALSUM;//�����������
							dMATTENTIONSUM = dCATTENTIONSUM;//���¹�ע���
							dMSECONDARYSUM = dCSECONDARYSUM;//���´μ����
							dMSHADINESSSUM = dCSHADINESSSUM;//���¿������
							dMLOSSSUM = dCLOSSSUM;//������ʧ���
						}
						else//���Ǳ��µ�ֵ,���µ�ֵȫ��Ϊ0
						{
							iMAGGREECOUNT = 0;//������׼�ܱ���
							iMDISAGREECOUNT = 0;//���·���ܱ���
							iMAFLOATCOUNT = 0;//������;�ܱ���	
							iMAGGREETIME = 0;//������׼�ܺ�ʱ
							iMDISAGREETIME = 0;//���·���ܺ�ʱ
							iMAFLOATTIME = 0;//������;�ܺ�ʱ
							iMNAPPROVECOUNT = 0;//����δǩ�����ܱ���
							dMNAPPROVESUM = 0.00;//����δǩ�����ܽ��
							iMNCONTRACTCOUNT = 0;//����δǩ��ͬ�ܱ���
							dMNCONTRACTSUM = 0.00;//����δǩ��ͬ�ܽ�� 
							iMNPUTOUTCOUNT = 0;//����δ�Ŵ�����
							dMNPUTOUTSUM = 0.00;//����δ�Ŵ����
							dMNORMALSUM = 0.00;//�����������
							dMATTENTIONSUM = 0.00;//���¹�ע���
							dMSECONDARYSUM = 0.00;//���´μ����
							dMSHADINESSSUM = 0.00;//���¿������
							dMLOSSSUM = 0.00;//������ʧ���
						}
					} else//���ǵ����ֵ,���굱�µ�ֵ��Ϊ0
					{
						iYAGGREECOUNT = 0;//������׼�ܱ���
						iYDISAGREECOUNT = 0;//�������ܱ���
						iYAGGREETIME = 0;//������׼�ܺ�ʱ
						iYDISAGREETIME = 0;//�������ܺ�ʱ
						iYAFLOATCOUNT = 0;//������;�ܱ���	
						iYAFLOATTIME = 0;//������;�ܺ�ʱ
						iYNAPPROVECOUNT= 0;//����δǩ�����ܱ���
						dYNAPPROVESUM = 0.00;//����δǩ�����ܽ��
						iYNCONTRACTCOUNT = 0;//����δǩ��ͬ�ܱ���
						dYNCONTRACTSUM = 0.00;//����δǩ��ͬ�ܽ�� 
						iYNPUTOUTCOUNT = 0;//����δ�Ŵ�����
						dYNPUTOUTSUM = 0.00;//����δ�Ŵ����
						dYNORMALSUM = 0.00;//�����������
						dYATTENTIONSUM = 0.00;//�����ע���
						dYSECONDARYSUM = 0.00;//����μ����
						dYSHADINESSSUM = 0.00;//����������
						dYLOSSSUM = 0.00;//������ʧ���
						iMAGGREECOUNT = 0;//������׼�ܱ���
						iMDISAGREECOUNT = 0;//���·���ܱ���
						iMAFLOATCOUNT = 0;//������;�ܱ���	
						iMAGGREETIME = 0;//������׼�ܺ�ʱ
						iMDISAGREETIME = 0;//���·���ܺ�ʱ
						iMAFLOATTIME = 0;//������;�ܺ�ʱ
						iMNAPPROVECOUNT = 0;//����δǩ�����ܱ���
						dMNAPPROVESUM = 0.00;//����δǩ�����ܽ��
						iMNCONTRACTCOUNT = 0;//����δǩ��ͬ�ܱ���
						dMNCONTRACTSUM = 0.00;//����δǩ��ͬ�ܽ�� 
						iMNPUTOUTCOUNT = 0;//����δ�Ŵ�����
						dMNPUTOUTSUM = 0.00;//����δ�Ŵ����
						dMNORMALSUM = 0.00;//�����������
						dMATTENTIONSUM = 0.00;//���¹�ע���
						dMSECONDARYSUM = 0.00;//���´μ����
						dMSHADINESSSUM = 0.00;//���¿������
						dMLOSSSUM = 0.00;//������ʧ���
					}
				 }
		 sSql2 = "Insert Into Approve_Performance_D values("+
		 		 "'"+sSerialNo+"', " +
		 		 "'"+sSTATISTICDATE+"', " +
		 		 "'"+sORGID+"', " +
		 		 "'"+sUSERID+"', "+
		 		 "'"+sFLOWNO+"', "+
		 		 "'"+sPHASENO+"', "+
		 		 ""+iCURRDEALCOUNT+", "+
		 		 ""+dCURRDEALSUM+", "+
		 		 ""+iMAGGREECOUNT+", "+
		 		 ""+iMDISAGREECOUNT+", "+
		 		 ""+iMAFLOATCOUNT+", "+
		 		 ""+iMAGGREETIME+", "+
		 		 ""+iMDISAGREETIME+", "+
		 		 ""+iMAFLOATTIME+", "+
		 		 ""+iMNAPPROVECOUNT+", "+
		 		 ""+dMNAPPROVESUM+", "+
		 		 ""+iMNCONTRACTCOUNT+", "+
		 		 ""+dMNCONTRACTSUM+", "+
		 		 ""+iMNPUTOUTCOUNT+", "+
		 		 ""+dMNPUTOUTSUM+", "+
		 		 ""+dMNORMALSUM+", "+
		 		 ""+dMATTENTIONSUM+", "+
		 		 ""+dMSECONDARYSUM+", "+
		 		 ""+dMSHADINESSSUM+", "+
		 		 ""+dMLOSSSUM+", "+
		 		 ""+dMAPPLYSUM+", "+
		 		 ""+iYAGGREECOUNT+", "+
		 		 ""+iYDISAGREECOUNT+", "+
		 		 ""+iYAFLOATCOUNT+", "+
		 		 ""+iYAGGREETIME+", "+
		 		 ""+iYDISAGREETIME+", "+
		 		 ""+iYAFLOATTIME+", "+
		 		 ""+iYNAPPROVECOUNT+", "+
		 		 ""+dYNAPPROVESUM+", "+
		 		 ""+iYNCONTRACTCOUNT+", "+
		 		 ""+dYNCONTRACTSUM+", "+
		 		 ""+iYNPUTOUTCOUNT+", "+
		 		 ""+dYNPUTOUTSUM+", "+
		 		 ""+dYNORMALSUM+", "+
		 		 ""+dYATTENTIONSUM+", "+
		 		 ""+dYSECONDARYSUM+", "+
		 		 ""+dYSHADINESSSUM+", "+
		 		 ""+dYLOSSSUM+", "+
		 		 ""+dYAPPLYSUM+", "+
		 		 ""+iCAGGREECOUNT+", "+
		 		 ""+iCDISAGREECOUNT+", "+
		 		 ""+iCAFLOATCOUNT+", "+
		 		 ""+iCAGGREETIME+", "+
		 		 ""+iCDISAGREETIME+", "+
		 		 ""+iCAFLOATTIME+", "+
		 		 ""+iCNAPPROVECOUNT+", "+
		 		 ""+dCNAPPROVESUM+", "+
		 		 ""+iCNCONTRACTCOUNT+", "+
		 		 ""+dCNCONTRACTSUM+", "+
		 		 ""+iCNPUTOUTCOUNT+", "+
		 		 ""+dCNPUTOUTSUM+", "+
		 		""+dCNORMALSUM+", "+
		 		""+dCATTENTIONSUM+", "+
		 		""+dCSECONDARYSUM+", "+
		 		""+dCSHADINESSSUM+", "+
		 		""+dCLOSSSUM+", "+
		 		""+dCAPPLYSUM+")";
		 //System.out.print(sSql2);
		 Sqlca.executeSQL(sSql2);
		 System.out.println("����ҵ����ˮ��Ϊ"+sSerialNo+",���̱��Ϊ"+sFLOWNO+",�����׶�Ϊ"+sPHASENO+",������ԱΪ"+sUSERID);		 
			 }//end of FLow_Task
			 rs1.getStatement().close();

		}//end of Business_Apply
		rs.getStatement().close();
		System.out.println("�ձ�Approve_Performance_D�����������");
		return "Finish";
	}
	
	//����������еļ�¼
	 private void clearRecord(Transaction Sqlca) throws Exception
	 {
		 String sSql = "";
		 sSql = " delete from Approve_Performance_D";
		 //ִ�и������
		 Sqlca.executeSQL(sSql);	 
	 }
	 
	 /**
	  * ���㱾��������ͱ���������
	  * @param:�������ڣ�ͳ�����ڣ��������־��"M"�����£�"Y"�����꣩
	  * @Return:�������������������
	  * */
	 private double getBusinessSum (String sOccurDate,String sSTATISTICDATE,double dBusinessSum,String sFalg)
	 {
		 double dResult = 0.00;
		 if(sOccurDate.length()>=7 && sSTATISTICDATE.length()>=7)//�жϳ��ȣ�����Խ��
		 {
			 if(sFalg.equals("M"))
			 {
				 if(sOccurDate.substring(0,7).equals(sSTATISTICDATE.substring(0,7)))
				 {
					 dResult = dBusinessSum;
				 }
				 else 
					 dResult = 0.00;
			 }
			 if(sFalg.equals("Y"))
			 {
				 if(sOccurDate.substring(0,4).equals(sSTATISTICDATE.substring(0,4)))
				 {
					 dResult = dBusinessSum;
				 }
				 else 
					 dResult = 0.00;
			 }
		 }
		 else
		 {
			 System.out.println("�������ڡ�ͳ������Ϊ�ջ���Ϊ����������");
			 dResult = 0.00;
		 }
		 return dResult;
	 }
	 /**
	  * ȡ�������
	  * @param:������ˮ�ţ��������ͣ������׶Σ�������Ա,���������
	  * @Return:���ظ�������Ա���һ�����������
	  * 
	  * */  
	 private String getPhaseOpinion (String sSerialNo,String sFlowNo,String sPhaseNo,String sUserID,Transaction Sqlca) throws Exception
	 {
		 String sSql2 = "";
		 String sPhaseOpinion = "";
		 ASResultSet rs2 = null;
		 sSql2 = " Select PhaseOpinion1 from Flow_Task where ObjectType='CreditApply' "+
		         " and ObjectNo='"+sSerialNo+"' and UserID='"+sUserID+"' "+
		         " and PhaseNo='"+sPhaseNo+"' and FlowNo='"+sFlowNo+"' "+
		         " and EndTime =(select Max(EndTime) from Flow_Task where ObjectType='CreditApply' "+
		         " and ObjectNo='"+sSerialNo+"' and UserID='"+sUserID+"' "+
		         " and PhaseNo='"+sPhaseNo+"' and FlowNo='"+sFlowNo+"')";

		 rs2 = Sqlca.getASResultSet(sSql2);
		 if(rs2.next())
		 {
			 sPhaseOpinion = rs2.getString("PhaseOpinion1");//ȡ�����˵����
		 }
		 else
		 {
			 sPhaseOpinion = "";
		 }
		 rs2.getStatement().close();
		 return sPhaseOpinion;
	 }
	 /**
	  * ȡ���һ������ʱ��
	  * @param:������ˮ�ţ��������ͣ������׶Σ�������Ա,���������
	  * @Return:���ظ�������Ա���һ������ʱ��(yyyy/mm/dd)
	  * 
	  * */  
	 private String getEndTime (String sSerialNo,String sFlowNo,String sPhaseNo,String sUserID,Transaction Sqlca) throws Exception
	 {
		 String sSql2 = "";
		 String sEndTime = "";
		 ASResultSet rs2 = null;
		 sSql2 = " Select Max(EndTime) as EndTime from Flow_Task where ObjectType='CreditApply' "+
		         " and ObjectNo='"+sSerialNo+"' and UserID='"+sUserID+"' "+
		         " and PhaseNo='"+sPhaseNo+"' and FlowNo='"+sFlowNo+"' ";

		 rs2 = Sqlca.getASResultSet(sSql2);
		 if(rs2.next())
		 {
			 sEndTime = rs2.getString("EndTime");//ȡ�����˵����
			 sEndTime = sEndTime.substring(0,10);//ȡyyyy/mm/dd
		 }
		 else
		 {
			 sEndTime = "";
		 }
		 rs2.getStatement().close();
		 return sEndTime;
	 }
	 /**
	  * ȡ�����ܺ�ʱ
	  * @param:������ˮ�ţ��������ͣ������׶Σ�������Ա,���������
	  * @Return:���ظ�������Ա���һ������ʱ��(yyyy/mm/dd)
	  * 
	  * */  
	 private int getSumTime (String sSerialNo,String sFlowNo,String sPhaseNo,String sUserID,Transaction Sqlca) throws Exception
	 {
		 String sSql2 = "";
		 int iSum = 0;
		 ASResultSet rs2 = null;
		 sSql2 = " select Sum(ceil(to_date(endtime,'yyyy/mm/dd hh24:mi:ss')-"+
			     " to_date(begintime,'yyyy/mm/dd hh24:mi:ss'))) as Sum1 "+
			     " from Flow_Task where ObjectType='CreditApply' "+
			     " and ObjectNo='"+sSerialNo+"' and UserID='"+sUserID+"' "+
			     " and PhaseNo='"+sPhaseNo+"' and FlowNo='"+sFlowNo+"' "+
			     " and EndTime is not null";
		 rs2 = Sqlca.getASResultSet(sSql2);
		 if(rs2.next())
		 {
			 iSum = rs2.getInt("Sum1");//ȡ�����˵����
		 }
		 else
		 {
			 iSum = 0;
		 }
		 rs2.getStatement().close();
		 return iSum;
	 }
	 
}
