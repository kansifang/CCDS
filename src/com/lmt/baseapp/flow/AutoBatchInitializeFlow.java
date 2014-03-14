package com.lmt.baseapp.flow;
/**
 * History Log modified by fhuang 2007.01.08 ������С��ҵ����ѡ��
 * 
 * */
import com.lmt.baseapp.util.DataConvert;
import com.lmt.frameapp.sql.ASResultSet;
import com.lmt.frameapp.sql.Transaction;

public class AutoBatchInitializeFlow extends InitializeFlow {
 public Object  run(Transaction Sqlca) throws Exception
	 {			
		//ObjectNo~TableName~Column~ColumnV ������ţ�������һ�������ţ�
		String sSelect = DataConvert.toString((String)this.getAttribute("ObjectNo"));
		String[]sS=sSelect.split("@");
		if(sS.length>3){
			ASResultSet rs = Sqlca.getASResultSet("select "+sS[0]+" from "+sS[1]+" where "+sS[2]+"='"+sS[3]+"'");
			while(rs.next()){
				this.setAttribute("ObjectNo", DataConvert.toString(rs.getString(1)));
				super.run(Sqlca);
			}
		}else{
			super.run(Sqlca);
		}
	    return "1";
	 }
}
