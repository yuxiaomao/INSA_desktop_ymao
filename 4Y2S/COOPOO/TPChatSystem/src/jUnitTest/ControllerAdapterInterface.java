package jUnitTest;

import java.io.File;
import java.net.DatagramPacket;
import java.net.InetAddress;

import controller.Controller;
import gui.Window;
import model.Contact;
import model.Message;

public interface ControllerAdapterInterface {
	
	/* global function */
	void setUserLocal(Contact userLocal);
	void initComponents();
	void connection();
	void disconnection();

	/* status */
	Boolean isConnected();
	Boolean isDisconnected();
	void setStatus(Boolean connected);

	/* check */
	int getTimerCheckDelay();
	
	/* model */
	void modelAddContact(Contact userRemote);
	Boolean findRemoteUserFromModel(Contact userRemote);
	boolean isEmptyUserRemoteList();

	/* simulation action */
	void userRemoteActionTimerHasExpired(Contact userRemote);
	
	/* message receive and send */
	void receiveMessage(Message message, InetAddress ip);
	InetAddress getBroadcastInetAddress();
	void userWroteAMessageAndWantToSend(String content, String usernameDest);
	void userChosedAFileAndWantToSend(File file, String usernameDest);

	void cleanUpEnvironment();

	public Controller getController();	
	public Window getVue();
	
}
