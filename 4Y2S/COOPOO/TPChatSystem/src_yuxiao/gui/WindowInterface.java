package gui;

import java.awt.Component;
import java.awt.event.ActionListener;

import javax.swing.DefaultListModel;
import javax.swing.JFileChooser;
import javax.swing.JList;
import javax.swing.JTextArea;
import javax.swing.JTextField;
import javax.swing.event.ListSelectionListener;

public interface WindowInterface {
	
	public Component getComponent();
	
	public void setALLDisconnected();
    
    public void setUIConnected();
    
    public void setUIDisconnected();
    
    public JTextField getUsernameContent();
    
    public JTextArea getMessageDisplay();
    
    public JTextField getMessageContent();
    
    public JTextField getFileContent();
    
    public JList<String> getListUser();
    
    public JFileChooser getFileChoose();
    
    public void addActionConnect(ActionListener action);
    
    public void addActionDisconnect(ActionListener action);
    
    public void addActionSendMsg(ActionListener action);
    
    public void addActionChooseFile(ActionListener action);
    
    public void addActionSendFile(ActionListener action);
    
    public void addActionListSelectionListener(ListSelectionListener listener);
    
    public DefaultListModel<String> getDefaultListModel();

}
