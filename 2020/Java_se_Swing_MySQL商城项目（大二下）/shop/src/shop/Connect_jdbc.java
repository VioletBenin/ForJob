package shop;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Connect_jdbc {

	// ��������
	Connection con = null;
	// sql״̬
	Statement st;
	// �����
	ResultSet rs;
// ��������·�����汾:5.0.4��
	String JDBC_DRIVER = "com.mysql.jdbc.Driver";

	String uri = "jdbc:mysql://localhost:3306/gui_shop?"
			+ "useSSL=false&serverTimezone=CST&characterEncoding=utf-8&allowPublicKeyRetrieval=true";

	String user = "root";
	String password = "";


	Connect_jdbc() {
		try {
			// ���Լ���JDBC-MySQL8.0������:���˴�Mysql�汾Ϊ 5.1.34
			Class.forName(JDBC_DRIVER);
		} catch (Exception e) {
		}

		try {
			con = DriverManager.getConnection(uri, user, password); // ����
		} catch (SQLException e) {
			System.out.println(e);
		}
	}

	boolean check_login_usr(String usr, String psd) {
//		usr_info
//		usr1
//	qstuser1
		try {
			st = con.createStatement();
			rs = st.executeQuery("SELECT psd FROM usr_info WHERE usr=\'" + usr + "\';");// ���
			System.out.println(rs.getString(1));
			if(rs.getString(1)==psd)
			{
				return true;
			}
		} catch (SQLException e) {
			System.out.println(e);
		}
		return false;
	}

	boolean check_login_adm() {
//		adm_info
		return false;
	}

	boolean create_signin_usr() {
		return false;
	}

}
