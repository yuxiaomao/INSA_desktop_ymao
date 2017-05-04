package jUnitTest;

import java.io.File;
import java.net.DatagramPacket;
import java.net.InetAddress;

import model.Message;
import contact.Contact;

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
	DatagramPacket getLastDatagramPacketSended();
	InetAddress getBroadcastInetAddress();
	void userWroteAMessageAndWantToSend(String content, String usernameDest);
	void userChosedAFileAndWantToSend(File file, String usernameDest);
	
	
	
	void cleanUpEnvironnement();


}
