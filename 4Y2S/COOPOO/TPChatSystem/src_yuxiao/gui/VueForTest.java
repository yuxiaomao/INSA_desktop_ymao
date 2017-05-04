package gui;

import java.awt.Component;
import java.awt.event.ActionListener;

import javax.swing.DefaultListModel;
import javax.swing.JButton;
import javax.swing.JFileChooser;
import javax.swing.JList;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.event.ListSelectionListener;

public class VueForTest implements WindowInterface {

	private JButton jButton2;
	private JButton jButton3;
	private JButton jButton4;
	private JButton jButton5;
	private JButton jButton6;
	private JTextArea jTextArea1;
	private JTextField jTextField3;
	private JTextField jTextField4;
	private JTextField jTextField5;
	private JList<String> jList1;
	private DefaultListModel<String> listModel;
	private JFileChooser fc;


	public VueForTest(){
		this.initComponent();
	}

	private void initComponent(){
		this.jButton2 = new JButton();
		this.jButton3 = new JButton();
		this.jButton4 = new JButton();
		this.jButton5 = new JButton();
		this.jButton6 = new JButton();

		this.jTextArea1 = new JTextArea();this.jTextField3 = new JTextField();
		this.jTextField3.setText("default username");
		this.jTextField4 = new JTextField();
		this.jList1 = new javax.swing.JList<String>();
		this.jList1.setModel((this.listModel = new DefaultListModel<String>()));
		listModel.addElement("All");
		
		fc = new JFileChooser();
	}

	public Component getComponent(){
		return null;
	}

	public void setALLDisconnected(){}

	public void setUIConnected(){}

	public void setUIDisconnected(){}

	public JTextArea getMessageDisplay(){
		return jTextArea1;
	}

	public JTextField getUsernameContent(){
		return jTextField3;
	}

	public JTextField getMessageContent(){
		return jTextField4;
	}

	public JTextField getFileContent(){
		return jTextField5;
	}

	public JList<String> getListUser(){
		return jList1;
	}

	public JFileChooser getFileChoose(){
		return fc;
	}

	public void addActionConnect(ActionListener action){
		jButton2.addActionListener(action);
	}

	public void addActionDisconnect(ActionListener action){
		jButton3.addActionListener(action);
	}

	public void addActionSendMsg(ActionListener action){
		jButton4.addActionListener(action);
	}

	public void addActionChooseFile(ActionListener action){
		jButton5.addActionListener(action);
	}

	public void addActionSendFile(ActionListener action){
		jButton6.addActionListener(action);
	}

	public void addActionListSelectionListener(ListSelectionListener listener){
		jList1.addListSelectionListener(listener);
	}

	public DefaultListModel<String> getDefaultListModel(){
		return listModel;
	}

}
