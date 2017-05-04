package controller;

import gui.WindowInterface;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.List;
import javax.swing.Timer;

import contact.Contact;
import contact.State;
import model.Model;
import model.ModelContactRemote;
import model.MsgTxt;

public class Controller {

	private Model model;
	private ControllerNetwork cNet;
	private Timer timerCheck;
	private WindowInterface vue;

	public Controller(WindowInterface vue){
		// create contact userLocal , model and begin transmission
		this.vue = vue;
		Contact userLocal = null;

		try {
			userLocal = new Contact(this.vue.getUsernameContent().getText(), InetAddress.getLocalHost(), new ActionListener()
			{
				public void actionPerformed(ActionEvent e)
				{
					timerUserLocalHasExpired();
				}
			});
		} catch (UnknownHostException e1) {
			e1.printStackTrace();
		}
		this.model = new Model(userLocal);
		this.cNet = new ControllerNetwork(model, vue);

		// gestion check, start when pass to connected
		this.timerCheck = new Timer(6000,new ActionListener()
		{
			public void actionPerformed(ActionEvent e)
			{
				timerCheckHasExpired();
			}
		});
	}

	public Model getModel(){
		return this.model;
	}

	// only for jUnit test
	public ControllerNetwork getControllerNetWork(){
		return this.cNet;
	}

	public void sayHello(){
		this.model.getUserLocal().startTimer();
		this.model.getUserLocal().setState(State.CONNECTING);
		this.cNet.sendMsgHello();
	}

	public void sayGoodbye(){
		this.model.getUserLocal().stopTimer();
		this.model.getUserLocal().setState(State.DISCONNECTED);
		this.cNet.sendMsgGoodbye();
		this.timerCheck.stop();
		this.model.removeAllUserListElement();
		this.cNet.closeSocketUDP();
		//there's always socket exception for receiving the goodbye that local user broadcasted
	}


	public void sendMessage(){
		String content = vue.getMessageContent().getText();
		String localUsername = this.model.getUserLocal().getUsername();

		List<String> selectedUsers = vue.getListUser().getSelectedValuesList();
		for (String username : selectedUsers) {
			if(username.equals("All")){
				MsgTxt message = new MsgTxt(localUsername,"all", content);
				this.cNet.sendMsgTxtToAll(message);
				break;
			}
			else{
				MsgTxt message = new MsgTxt(localUsername,username,content);
				Contact userRemote = this.model.getUserRemoteByName(username);
				if (userRemote != null){
					this.cNet.sendMsgTxt(message, userRemote.getIp());
				}
			}
		}
	}

	public void sendFile(){
		File file = vue.getFileChoose().getSelectedFile();
		List<String> selectedUsers = vue.getListUser().getSelectedValuesList();

		if (file == null){
			System.err.println("Input File not valid");
			return;
		}

		this.model.writeLog("Sending: " + file.getName() + ".\n" );
		byte[] bytesArray = new byte[(int) file.length()];
		FileInputStream fis;
		try {
			fis = new FileInputStream(file);
			fis.read(bytesArray); //read file into bytes[]
			fis.close();
		} catch (IOException e1) {
			e1.printStackTrace();
		}

		for (String username : selectedUsers) {
			if(username.equals("All")){
				model.MsgFile message = new model.MsgFile(this.model.getUserLocal().getUsername(), "all", bytesArray);
				this.cNet.sendMsgFileToAll(message);
				break;
			}
			else{
				Contact userRemote = this.model.getUserRemoteByName(username);
				model.MsgFile message = new model.MsgFile(this.model.getUserLocal().getUsername(), userRemote.getUsername(), bytesArray);
				this.cNet.sendMsgFile(message, userRemote.getIp());
			}
		}
		this.model.writeLog("Sended.\n" );
	}

	public String getLog(){
		return this.model.getLog();
	}

	String getChatHistoryByName(String username){
		ModelContactRemote mcr=this.model.getModelContactRemoteByName(username);
		if (mcr == null){
			return "User selected not find \n";
		}else{
			return mcr.getChatHistory();
		}
	}


	private void timerUserLocalHasExpired(){
		this.model.getUserLocal().stopTimer();
		if (this.model.getUserLocal().getState() == State.CONNECTING){
			this.timerCheck.start();
			this.model.getUserLocal().setState(State.CONNECTED);
			System.out.println("[Controller] Connected!");
			this.vue.setUIConnected();
		}else{
			//disconnected
			this.vue.setUIDisconnected();
		}
	}

	private void timerCheckHasExpired(){
		this.cNet.sendMsgCheck();
	}

}
