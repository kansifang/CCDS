package com.amarsoft.app.performance;
import com.amarsoft.are.sql.*;
import java.sql.Connection;

public class RunPerformance {
	public RunPerformance()
	{
		
	}
	public static void main(String args[])
	{		 
		Connection con = null;
		Transaction Sqlca = null;
		try
		{
			con = ConnectionManager.getConnection("jdbc:oracle:thin:@192.168.0.88:1521:amarbank","oracle.jdbc.driver.OracleDriver","credit","credit");
			Sqlca = new Transaction(con);
			CreatePerformanceData cpd = new CreatePerformanceData();
			cpd.setAttribute("STATISTICDATE","2006/11/15");
			cpd.run(Sqlca);
			SumPerformanceData spd = new SumPerformanceData();
			spd.setAttribute("STATISTICDATE","2006/11/15");
			spd.run(Sqlca);
			Sqlca.disConnect();
		}catch(Exception e)
		{
			System.out.println("连接数据库异常："+e.toString());
			
		}
	}
}
