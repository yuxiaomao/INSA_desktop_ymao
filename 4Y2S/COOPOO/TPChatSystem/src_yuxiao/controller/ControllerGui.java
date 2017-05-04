package controller;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import javax.swing.DefaultListModel;
import javax.swing.JFileChooser;
import javax.swing.JList;
import javax.swing.event.ListSelectionEvent;
import javax.swing.event.ListSelectionListener;

import gui.Window;
import gui.WindowInterface;

public class ControllerGui {

	private WindowInterface vue;
	private Controller controller;

	public ControllerGui(){
		this.vue = new Window();
		this.vue.setUIDisconnected();

		this.vue.addActionConnect(new ActionListener(){
			public void actionPerformed(ActionEvent e)
			{
				vue.setALLDisconnected();
				controller = new Controller(vue);
				controller.sayHello();
			}
		});

		this.vue.addActionDisconnect(new ActionListener(){
			public void actionPerformed(ActionEvent e)
			{
				vue.setUIDisconnected();
				vue.getDefaultListModel().removeAllElements();
				vue.getDefaultListModel().addElement("All");
				controller.sayGoodbye();
			}
		});

		this.vue.addActionSendMsg(new ActionListener(){
			public void actionPerformed(ActionEvent e)
			{
				controller.sendMessage();
			}
		});

		this.vue.addActionChooseFile(new ActionListener(){
			public void actionPerformed(ActionEvent e){
				JFileChooser fc = vue.getFileChoose();
				fc.showOpenDialog(vue.getComponent());
				vue.getFileContent().setText(fc.getSelectedFile().toString());
			}
		});

		this.vue.addActionSendFile(new ActionListener(){
			public void actionPerformed(ActionEvent e){
				controller.sendFile();
			}
		});

		// display chat history
		this.vue.addActionListSelectionListener(new ListSelectionListener(){
			@Override
			public void valueChanged(ListSelectionEvent e) {
				if (e.getSource() instanceof JList){
					JList<?> list = (JList<?>) e.getSource();
					if (list.isSelectionEmpty()){
						// list vide
					}else if (!e.getValueIsAdjusting()){
						DefaultListModel<String> dlm = vue.getDefaultListModel();
						if (!dlm.isEmpty()){
							int selectedindex = list.getSelectedIndex();
							String selected = (String) dlm.getElementAt(selectedindex);

							if (selected.equals("All")){
								vue.getMessageDisplay().setText(controller.getLog());
							}else{
								vue.getMessageDisplay().setText(controller.getChatHistoryByName(selected));
							}
						}
					}
				}
			}
		});

		// select text if user click user name field
		this.vue.getUsernameContent().addFocusListener(new FocusListener(){
			@Override
			public void focusGained(FocusEvent e) {
				vue.getUsernameContent().selectAll();
			}

			@Override
			public void focusLost(FocusEvent e) {
				vue.getUsernameContent().select(0, 0);
			}
		});

		// select text if user click message field
		this.vue.getMessageContent().addFocusListener(new FocusListener(){
			@Override
			public void focusGained(FocusEvent e) {
				vue.getMessageContent().selectAll();
			}

			@Override
			public void focusLost(FocusEvent e) {
				vue.getMessageContent().select(0, 0);
			}
		});

		// allow touch return to send a message
		this.vue.getMessageContent().addKeyListener(new KeyListener(){
			@Override
			public void keyPressed(KeyEvent e) {
				if (e.getKeyCode() == KeyEvent.VK_ENTER) {
					controller.sendMessage();
				}
			}

			@Override
			public void keyReleased(KeyEvent arg0) {}

			@Override
			public void keyTyped(KeyEvent arg0) {}

		});

	}

}
