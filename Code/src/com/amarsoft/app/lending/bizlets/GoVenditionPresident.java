package com.amarsoft.app.lending.bizlets;
/*
		Author: --xyong 2012/03/29
		Tester:
		Describe: --���ݷ��������ж��Ƿ���Ӫ���г�
		Input Param:
				ObjectNo:--������ˮ��
		Output Param:
				return������ֵ��TRUE --ɾ���ɹ�,FALSE��

		HistoryLog:
 */
import com.amarsoft.are.sql.ASResultSet;
import com.amarsoft.are.sql.Transaction;
import com.amarsoft.biz.bizlet.Bizlet;
import com.amarsoft.are.util.*;

public class GoVenditionPresident extends Bizlet {

	public Object run(Transaction Sqlca) throws Exception{
		String sObjectNo = (String)this.getAttribute("ObjectNo");
	
		//����ֵת���ɿ��ַ���
		if(sObjectNo == null) sObjectNo = "";
		
		String sSql = "";
		ASResultSet rs = null;
		//�������:
		String sRelativeSerialNo = "";//����������ˮ��
		String sMainOccurType = "";//��ҵ�񵣱���ʽ
		String sMessage = "FALSE";//����ֵ
		
		 sSql = " select OccurType from BUSINESS_APPLY "+
			          " where SerialNo = '"+sObjectNo+"' ";
		 rs = Sqlca.getASResultSet(sSql);
		if(rs.next())
		{
			sMainOccurType = rs.getString("OccurType");
		}
		rs.getStatement().close();
		
		//����Ǹ���ҵ��ȡ����ҵ��ķ���������Ϊ�ж�
		if("090".equals(sMainOccurType))
		{
			 sSql = " select ObjectNo from APPLY_RELATIVE "+
	          " where SerialNo = '"+sObjectNo+"' and ObjectType='BusinessReApply'  ";
			rs = Sqlca.getASResultSet(sSql);
			if(rs.next())
			{
				sRelativeSerialNo = rs.getString("ObjectNo");
				if(sRelativeSerialNo==null) sRelativeSerialNo="";
			}
			rs.getStatement().close();
			if(!"".equals(sRelativeSerialNo)){
				 sSql = " select OccurType from BUSINESS_APPLY "+
		          " where SerialNo = '"+sRelativeSerialNo+"' ";
				rs = Sqlca.getASResultSet(sSql);
				if(rs.next())
				{
					sMainOccurType = rs.getString("OccurType");
				}
				rs.getStatement().close();
			}
		}
		//��������Ϊ:�·���/�ʲ�����/����������������Ӫ���г�����
		if("010".equals(sMainOccurType)||"065".equals(sMainOccurType)||"030".equals(sMainOccurType))
		{
			sMessage="TRUE";
		}
		
		
		return sMessage;
	}
}
