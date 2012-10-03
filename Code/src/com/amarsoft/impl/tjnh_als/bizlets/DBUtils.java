package com.amarsoft.impl.tjnh_als.bizlets;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class DBUtils {
	//public static String url = "jdbc:db2://100.100.105.215:50000/als6fd"; // for type4 协议：子协议：数据库服务器地址：端口/数据库 

	public static String url = "jdbc:db2:als6fd";//for type2
	
	public static String user = "als6fd";// 数据库连接者ID

	public static String password = "amars0ft";// 数据库连接者密码

	//public static String sDBDriver = "com.ibm.db2.jcc.DB2Driver";//for type4
	public static String sDBDriver = "COM.ibm.db2.jdbc.app.DB2Driver";//for type2

	public static Connection conn = null;

	public static Statement stmt = null;

	public static void initDB() {
		try {
			Class.forName(sDBDriver).newInstance();
			conn = DriverManager.getConnection(url, user, password);
			stmt = conn.createStatement();// 创建数据库连接对象
		} catch (Exception ex) {
			ex.printStackTrace();
			System.out.println("数据库连接失败！");
		}
	}

	public static String getErrCode(String sCodeNo) throws SQLException {
		String sql = "select MsgBdy from MF_ErrCode where CodeNo='" + sCodeNo
				+ "'";
		ResultSet rs = stmt.executeQuery(sql);
		String sErrCode = "";
		if (rs.next()) {
			sErrCode = rs.getString(1);
		}
		rs.close();
		return sErrCode;
	}

}
