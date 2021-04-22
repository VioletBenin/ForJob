package shop;

import java.*;
import javax.*;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextArea;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class MainWin extends JFrame implements ActionListener {
//	JTextArea text;
	JButton button_usr, button_adm, button_sign;
	Login_usr login_usr;

	MainWin() {
		
		initBasic();// 窗口布局的初始化
		initComponent();// 窗口控件的初始化
//	initListener();// 事件监听器的初始化

		this.setVisible(true); // 可视窗口，必须放在最后
		this.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);// 设置默认关闭方式，必须放在最后
	}

	private void initBasic() {

//		窗口基础设置JFrame
		Container con = getContentPane();// 背景色
		con.setBackground(new Color(255, 230, 246));

		this.setLayout(new FlowLayout());
		this.setBounds(100, 100, 1500, 800);// 位置，大小
		this.setTitle("学生信息管理系统");

		ImageIcon icon = new ImageIcon("Benin.png"); // 图片和项目同一路径，故不用图片的路径
		this.setIconImage(icon.getImage());

	}

	private void initComponent() {

		this.setLayout(new BorderLayout()); // 为Frame窗口设置布局为BorderLayout
		this.add(new JLabel("      "), BorderLayout.WEST);
		this.add(new JLabel("      "), BorderLayout.EAST);
		this.add(new JLabel("\n\n\n"), BorderLayout.NORTH);
		this.add(new JLabel("Copyright © by VioletBenin. All right deserved.", JLabel.CENTER), BorderLayout.SOUTH);

//		text = new JTextArea(5, 22);
		button_usr = new JButton("用户登录");
		button_adm = new JButton("管理员登录");
		button_sign = new JButton("注册登录");
		button_usr.addActionListener(this);

		JPanel toppanel = new JPanel();
		toppanel.setBackground(new Color(255, 230, 246));
		toppanel.setLayout(new BorderLayout());

		toppanel.add(new JLabel("      "), BorderLayout.WEST);
		toppanel.add(new JLabel("      "), BorderLayout.EAST);
		toppanel.add(new JLabel("\n\n\n"), BorderLayout.NORTH);

		JPanel inner = new JPanel();
		inner.setLayout(new GridLayout(7, 5));

		inner.add(new JLabel("      "));
		inner.add(button_usr);
		inner.add(new JLabel("      "));
		inner.add(button_adm);
		inner.add(new JLabel("      "));
		inner.add(button_sign);
//		toppanel.add(button_usr, BorderLaOyout.NORTH);
//		toppanel.add(button_adm, BorderLayout.NORTH);
//		toppanel.add(button_sign, BorderLayout.SOUTH);

		toppanel.add(inner, BorderLayout.CENTER);
		this.add(toppanel, BorderLayout.CENTER);

//		toppanel.add(text);
//		this.add(toppanel, BorderLayout.CENTER);

		login_usr = new Login_usr(this, "登录", true);
	}

	public void actionPerformed(ActionEvent e) {
		if (e.getSource() == button_usr) {
			int x = this.getBounds().x + this.getBounds().width;
			int y = this.getBounds().y;
			login_usr.setLocation(x, y);
			login_usr.setVisible(true);
			if (login_usr.getMessage() == Login_usr.YES)
				;
//				text.append("\n登录成功");
			else if (login_usr.getMessage() == Login_usr.NO)
				;
//				text.append("\n登陆失败");
			else if (login_usr.getMessage() == -1)
				;
//				text.append("\n关闭");
		}
	}
}

//public class MainWin {
//	MainWin()
//	{
//		boolean flag=true;
//		while(flag)
//		{
//		System.out.println("***********欢迎进入商城***********");
//		System.out.println("1.管理员登录");
//		System.out.println("2.用户登录");
//		System.out.println("3.新用户注册");
//		System.out.println("4.查看我购买的商品");
//		System.out.println("5.浏览商品");
//		System.out.println("6.退出");
//		
//		int op;
//Scanner scanner=new Scanner();
//System.in(op);
//		
//		switch()
//		{
//		
//		}
//		}
//
//	}
//}

//Signin signin();
//while(signin.getLogin()) {
////		进入系统
//	}
