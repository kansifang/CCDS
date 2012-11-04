package com.amarsoft.app.lending.bizlets;




import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.context.ASUser;
import com.amarsoft.web.dw.ASDataWindow;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.sql.DBFunction;

public class CheckBusinessTypeAndEvaluate extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		//������ˮ��
		String sObjectNo = "";
		//��������
		String sObjectType = "";	
		//�ͻ����
		String sCustomerID = "";
		//����ҵ����׼
		String sBusinessType = "";
		//��������ģ�ͱ��
		String sModelNo = "";
		//�Ƿ�ͣ�ò�����������
		String sIsInuse = "";
		//sql
		String sSql = "";
		//������Ϣ
		String sMessage = "";
		//sql�α�
		ASResultSet rs2 = null;
		//��ȡ����
		sObjectNo= (String)this.getAttribute("OjectNo");
		sObjectType= (String)this.getAttribute("ObjectType");
		sCustomerID= (String)this.getAttribute("CustomerID");
		sBusinessType= (String)this.getAttribute("BusinessType");
		//����ֵת��Ϊ���ַ���
		if(sObjectNo == null) sObjectNo = "";
		if(sObjectType == null) sObjectType = "";
		if(sCustomerID == null) sCustomerID = "";
		if(sBusinessType == null) sBusinessType = "";
		//ȡ�Ƿ�ͣ�ò��пͻ���������
		sIsInuse = Sqlca.getString(" select IsInuse  from code_library where codeno = 'UnusedOldEvaluateCard' and itemno = 'UnusedOldEvaluateCard' ");
		if (sIsInuse== null) sIsInuse="" ;
        if(sIsInuse.equals("2"))
        {
	        sSql = " select ModelNo from Evaluate_Record where ObjectType ='NewEvaluate' "+
		           " and ObjectNo ='"+sCustomerID+"' and EvaluateResult <>'' and EvaluateResult is not null order by AccountMonth desc,SerialNo desc fetch first 1 rows only ";
	        sModelNo = Sqlca.getString(sSql);
	        if (sModelNo == null) sModelNo = "";
	        // 1110010-����һ��ס������,1110020-���˶���ס������,1110025-ֱ��ʽס������,1110027-ס����������ϴ���(��ҵ���Ҳ���),1140010-����һ����ҵ�÷�����,1140020-���˶�����ҵ�÷�����
	        // 1140025-ֱ��ʽ���÷�����,sModelNo.equals("511")-����ר�Ҵ�ֿ�
	        if((("1110010,1110020,1110025,1110027,1140010,1140020,1140025".indexOf(sBusinessType)) > -1) && !sModelNo.equals("511"))
	        {	        	
	        	sMessage = "��Ҫʹ�á����������ֿ����������˽������õȼ�����(��ģ��)!";
	        }else if(sBusinessType.startsWith("1110") && !sModelNo.equals("512") && ("1110010,1110020,1110025,1110027,1140010,1140020,1140025".indexOf(sBusinessType)) == -1)
	        {
	        	sMessage = "��Ҫʹ�á����������ֿ����������˽������õȼ�����(��ģ��)!";
	        }else if(sBusinessType.startsWith("1150") && !sModelNo.equals("513"))
	        {	
	        	sMessage = "��Ҫʹ�á���Ӫ����ũ�������ֿ����������˽������õȼ�����(��ģ��)!";
	        }else if(sBusinessType.startsWith("1140") && !sModelNo.equals("513")&& !sModelNo.equals("514")&& ("1110010,1110020,1110025,1110027,1140010,1140020,1140025".indexOf(sBusinessType)) == -1)
	        {
	        	sMessage = "��Ҫʹ�á���Ӫ����ũ�������ֿ����򡰾�Ӫ�Է���ũ�������ֿ����������˽������õȼ�����(��ģ��)!";
	        }
        }
        else
        {
	        sSql = " select ModelNo from Evaluate_Record where ObjectType ='Customer' "+
		           " and ObjectNo ='"+sCustomerID+"' and (EvaluateResult <>'' and EvaluateResult is not null) order by AccountMonth desc,SerialNo desc  fetch first 1 rows only ";
	        sModelNo = Sqlca.getString(sSql);
	        if (sModelNo == null) sModelNo = "";
	        // 1110010-����һ��ס������,1110020-���˶���ס������,1110025-ֱ��ʽס������,1110027-ס����������ϴ���(��ҵ���Ҳ���),1140010-����һ����ҵ�÷�����,1140020-���˶�����ҵ�÷�����
	        // 1140025-ֱ��ʽ���÷�����,sModelNo.equals("511")-����ר�Ҵ�ֿ�
	        if((("1110010,1110020,1110025,1110027,1140010,1140020,1140025".indexOf(sBusinessType)) > -1) && !sModelNo.equals("511"))
	        {	   
	        	sMessage = "��Ҫʹ�á����������ֿ����������˽������õȼ�����!";
	        }else if(sBusinessType.startsWith("1110") && !sModelNo.equals("512")&& ("1110010,1110020,1110025,1110027,1140010,1140020,1140025".indexOf(sBusinessType)) == -1)
	        {
	        	sMessage = "��Ҫʹ�á����������ֿ����������˽������õȼ�����!";
	        }else if(sBusinessType.startsWith("1150") && !sModelNo.equals("513"))
	        {	
	        	sMessage = "��Ҫʹ�á���Ӫ����ũ�������ֿ����������˽������õȼ�����!";
	        }else if(sBusinessType.startsWith("1140") && !sModelNo.equals("513")&& !sModelNo.equals("514") && ("1110010,1110020,1110025,1110027,1140010,1140020,1140025".indexOf(sBusinessType)) == -1)
	        {
	        	sMessage = "��Ҫʹ�á���Ӫ����ũ�������ֿ����򡰾�Ӫ�Է���ũ�������ֿ����������˽������õȼ�����!";
	        }
        }				
		return sMessage;
	}		
}
