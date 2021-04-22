package shop;

import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextField;

public class Login_usr extends JDialog implements ActionListener{
	
	static final int YES=1,NO =0;
	JLabel JLusername = new JLabel("用户名");
	JTextField JTusername = new JTextField();
	JLabel JLpassword = new JLabel("密码");
	JTextField JTpassword = new JTextField();

	int message=-1;
	JButton yes,no,sigin;
	Login_usr(JFrame f,String s,boolean b){
		super(f,s,b);
		yes=new JButton("确定");
		yes.addActionListener(this);
		no=new JButton("No");
		no.addActionListener(this);
		sigin=new JButton("登录");
		sigin.addActionListener(this);
		setLayout(new GridLayout(3,4,100,50));		

		add(JLusername);
		add(JTusername);
		add(JLpassword);
		add(JTpassword);
		
		
		add(yes);
//		add(no);
		add(sigin);
		
		setBounds(60,60,100,100);
		addWindowListener(new WindowAdapter() {
			public void windowClosing(WindowEvent e) {
				message=-1;
				setVisible(false);
			}
		});
	}
	
	@Override
	public void actionPerformed(ActionEvent e) {
		if(e.getSource()==yes) {
			message=YES;
//			Connect_jdbc con = new Connect_jdbc();
//			System.out.println(con.check_login_usr("usr1", "qstuser1"));

			setVisible(false);
		}else if(e.getSource()==no) {
			message=NO;
			setVisible(false);
		}		
	}
	
	public int getMessage() {
		return message;
	}
	

}


//菜单显示  注册功能，登录功能，查看商城功能，购买商品功能，查看已购买商品的功能，退出功能；
//管理员          登录功能，商品添加功能、修改功能、删除功能、查看功能、查询功能，退出功能