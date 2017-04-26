package gui;

import java.awt.event.ActionListener;
import java.awt.event.KeyListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.io.File;

import javax.swing.*;
import javax.swing.event.ListSelectionListener;

import controller.*;

public class Window extends JFrame {
	

	private static final long serialVersionUID = 1346882983818929158L;
	
	public static JButton jButton2;
    public static JButton jButton3;
    public static JButton jButton4;
    public static JButton jButton5;
    public static JButton jButton6;
    private static JLabel jLabel4;
    private static  JLabel jLabel5;
    private static  JLabel jLabel6;
    public static JList<String> jList1;
    public static JPasswordField jPasswordField1;
    private static  JScrollPane jScrollPane1;
    private static  JScrollPane jScrollPane2;
    private static  JSeparator jSeparator1;
    private static  JSeparator jSeparator2;
    public static JTextArea jTextArea1;
    public static JTextField jTextField3;
    public static JTextField jTextField4;
    public static JTextField jTextField5;
    public static DefaultListModel<String> model;
    public static JFileChooser fc;
    public Controller controller;
    
	public Window(){
		initComponents();
        this.setTitle("Chat Messenger - Rama Desplats & Yuxiao Mao");
        model.addElement("All");
        jList1.setSelectedIndex(0);
        this.addWindowListener(new WindowListener() {
            @Override public void windowOpened(WindowEvent e) {}
            @Override public void windowClosing(WindowEvent e) {}
            @Override public void windowClosed(WindowEvent e) {}
            @Override public void windowIconified(WindowEvent e) {}
            @Override public void windowDeiconified(WindowEvent e) {}
            @Override public void windowActivated(WindowEvent e) {}
            @Override public void windowDeactivated(WindowEvent e) {}
        });

	}
	
	private void initComponents() {

		fc = new JFileChooser();
        jLabel4 = new javax.swing.JLabel();
        jSeparator1 = new javax.swing.JSeparator();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTextArea1 = new javax.swing.JTextArea();
        jScrollPane2 = new javax.swing.JScrollPane();
        jList1 = new javax.swing.JList<String>();
        jLabel5 = new javax.swing.JLabel();
        jTextField3 = new javax.swing.JTextField();
        jTextField4 = new javax.swing.JTextField();
        jButton4 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jButton3 = new javax.swing.JButton();
        jSeparator2 = new javax.swing.JSeparator();
        jTextField5 = new javax.swing.JTextField();
        jButton5 = new javax.swing.JButton();
        jButton6 = new javax.swing.JButton();
        jLabel6 = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jTextField3.setText("- Enter an username -");
        
        jButton2.setText("Login");
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });
        
        jButton3.setText("Disconnection");
        jButton3.setEnabled(false);

        jTextField4.setEnabled(false);
        jTextField5.setEnabled(false);
        jLabel4.setText("Username :");

        jTextArea1.setColumns(20);
        jTextArea1.setLineWrap(true);
        jTextArea1.setFont(new java.awt.Font("Consolas", 0, 12)); // NOI18N
        jTextArea1.setRows(10);
        jScrollPane1.setViewportView(jTextArea1);
        jTextArea1.setEnabled(false);

        jList1.setModel((model = new DefaultListModel<String>()));
        jScrollPane2.setViewportView(jList1);
        jList1.setEnabled(false);

        jLabel5.setText("Message : ");

        jButton4.setText("Send Message ");
        jButton4.setEnabled(false);

        jButton5.setText("...");
        jButton5.setEnabled(false);

        jButton6.setText("Send");
        jButton6.setEnabled(false);

        jLabel6.setText("File :");
        
        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jSeparator2)
                    .addComponent(jSeparator1, javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel4))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jTextField3))
                                .addGap(18, 18, 18)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING))))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false))
                                .addComponent(jButton3, javax.swing.GroupLayout.DEFAULT_SIZE, 81, Short.MAX_VALUE))))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addComponent(jScrollPane1)
                        .addGap(18, 18, 18)
                        .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addGap(23, 23, 23)
                        .addComponent(jLabel6)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, 378, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 27, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton6, javax.swing.GroupLayout.PREFERRED_SIZE, 77, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addComponent(jLabel5)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jTextField4)
                        .addGap(18, 18, 18)
                        .addComponent(jButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 108, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextField3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel4)
                    .addComponent(jButton3)
                    .addComponent(jButton2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jSeparator1, javax.swing.GroupLayout.PREFERRED_SIZE, 10, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jScrollPane1)
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 264, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton4)
                    .addComponent(jLabel5)
                    .addComponent(jTextField4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jSeparator2, javax.swing.GroupLayout.PREFERRED_SIZE, 10, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE, false)
                    .addComponent(jButton6, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButton5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jLabel6)
                    .addComponent(jTextField5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );

        pack();
    }

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {
    	//Deleted all chat related files in case ther is remaining ones
    	File dir = new File(System.getProperty("user.dir"));
    	for(File file: dir.listFiles()){ 
  		    if (!file.isDirectory()) {
  		    	if(!file.getName().contains("tmp")){
  		    		file.delete();
  		    	}
  		    }
  	  	}
    	String username=jTextField3.getText();
    	this.setALLDisconnected();
    	this.controller=new Controller(username,this);
    }

    /*
     * Set the UI window with nothing enabled (for connecting process purpose)
     */
    public void setALLDisconnected(){
    	jTextField3.setEnabled(false);
        jButton2.setEnabled(false);
        jTextField4.setEnabled(false);
        jTextField5.setEnabled(false);
        jTextArea1.setEnabled(false);
        jList1.setEnabled(false);
        jButton4.setEnabled(false);
        jButton5.setEnabled(false);
        jButton6.setEnabled(false);
    }
    
    /*
     * Set the UI window for a connected state
     */
    public void setUIConnected(){
    	jTextField3.setEnabled(false);
        jButton2.setEnabled(false);
        jButton3.setEnabled(true);
        jTextField4.setEnabled(true);
        jTextField5.setEnabled(true);
        jTextArea1.setEnabled(true);
        jList1.setEnabled(true);
        jButton4.setEnabled(true);
        jButton5.setEnabled(true);
        jButton6.setEnabled(true);

    }
    
    /*
     * Set the UI window for a disconnected state
     */
    public void setUIDisconnected(){
    	jTextField3.setEnabled(true);
        jButton2.setEnabled(true);
        jButton3.setEnabled(false);
        jTextField4.setEnabled(false);
        jTextField5.setEnabled(false);
        jTextArea1.setEnabled(false);
        jList1.setEnabled(false);
        jButton4.setEnabled(false);
        jButton5.setEnabled(false);
        jButton6.setEnabled(false);
    }
    
    /*
     * Getter got the editable Part of the GUI
     */
    public JButton getDisconnectionButton(){
    	return jButton3;
    }
    public JTextField getUsernameContent(){
    	return jTextField3;
    }
    
    public JTextArea getMessageDisplay(){
    	return jTextArea1;
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
    
    public DefaultListModel<String> getDefaultListModel(){
    	return model;
    }
    
    /*
     * Methods to add ActionListener/KeyListener to the GUI
     */
    public void addActionDisconnect(ActionListener action){
    	jButton3.addActionListener(action);
    }
    
    public void addActionSendMsg(ActionListener action, KeyListener actionbis){
    	jButton4.addActionListener(action);
    	jTextField4.addKeyListener(actionbis);
    }
    
    public void addActionChooseFile(ActionListener action){
    	jButton5.addActionListener(action);
    }
    
    public void addActionSendFile(ActionListener action){
    	jButton6.addActionListener(action);
    }
    
    public void addListUserAction(ListSelectionListener action){
    	jList1.addListSelectionListener(action);
    }
    
    public static void main(String args[]) {
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
        } 
        catch(Exception ex){
            System.out.println("Look & Feel exception");
        }
        
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new Window().setVisible(true);
            }
        });
    }
    
}
