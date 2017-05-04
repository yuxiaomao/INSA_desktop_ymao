package jUnitTest;

import gui.VueForTest;
import gui.WindowInterface;

import java.io.File;
import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.List;

import model.Message;
import model.ModelContactRemote;
import contact.Contact;
import contact.State;
import controller.Controller;

public class ControllerAdapter implements ControllerAdapterInterface {

	private Controller controller;
	private WindowInterface vue;


	public ControllerAdapter(){
		this.vue = new VueForTest();
		this.controller = null;
	}

	@Override
	public void setUserLocal(Contact userLocal) {
		this.vue.getUsernameContent().setText(userLocal.getUsername());
	}

	@Override
	public void initComponents() {
		this.controller = new Controller(this.vue);
	}

	@Override
	public void connection() {
		this.controller.sayHello();
	}

	@Override
	public void disconnection() {
		this.controller.sayGoodbye();
	}

	@Override
	public Boolean isConnected(){
		contact.State s = this.controller.getModel().getUserLocal().getState();
		return s == contact.State.CONNECTED;
	}

	@Override
	public Boolean isDisconnected(){
		contact.State s = this.controller.getModel().getUserLocal().getState();
		return s == contact.State.DISCONNECTED;
	}


	@Override
	public void setStatus(Boolean connected){
		if (connected){
			this.controller.getModel().getUserLocal().setState(State.CONNECTED);
		}else{
			this.controller.getModel().getUserLocal().setState(State.DISCONNECTED);
		}
	}

	@Override
	public int getTimerCheckDelay() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public void modelAddContact(Contact userRemote) {
		this.vue.getDefaultListModel().addElement(userRemote.getUsername());
		this.controller.getModel().addUserRemote(userRemote);
	}

	@Override
	public Boolean findRemoteUserFromModel(Contact userRemote) {
		ModelContactRemote mcr = this.controller.getModel().getModelContactRemoteByName(userRemote.getUsername());
		System.out.println("[CA]: "+this.controller.getModel().getRemoteUsers().toString());
		return mcr!=null;
	}

	@Override
	public boolean isEmptyUserRemoteList() {
		return this.controller.getModel().getRemoteUsers().isEmpty();
	}

	@Override
	public void userRemoteActionTimerHasExpired(Contact userRemote) {
		this.controller.getControllerNetWork().aTimerHasExpired(userRemote.getUsername());
	}

	@Override
	public void receiveMessage(Message message, InetAddress ip) {
		this.controller.getControllerNetWork().aMessageHasBeenReceived(ip, message);
		System.out.println("[CA]"+ip.toString() + " : " + message.toString());
	}
	
	@Override
	public DatagramPacket getLastDatagramPacketSended(){
		return this.controller.getControllerNetWork().getLastPacketSended();
	}
	
	@Override
	public InetAddress getBroadcastInetAddress(){
		InetAddress broadcastIp = null;
		try {
			broadcastIp = InetAddress.getByName("255.255.255.255");
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		return broadcastIp;
	}
	
	@Override
	public void userWroteAMessageAndWantToSend(String content, String usernameDest){
		this.vue.getMessageContent().setText(content);
		this.vue.getListUser().clearSelection();
		this.vue.getListUser().setSelectedValue(usernameDest, true);
				
		this.controller.sendMessage();
	}
	
	@Override
	public void userChosedAFileAndWantToSend(File file, String usernameDest){
		this.vue.getFileChoose().setSelectedFile(file);
		this.vue.getListUser().clearSelection();
		this.vue.getListUser().setSelectedValue(usernameDest, true);
		
		this.controller.sendFile();
	}

	@Override
	public void cleanUpEnvironnement() {

	}



}
