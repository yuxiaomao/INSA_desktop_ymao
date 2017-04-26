package jUnitTest;

import java.net.InetAddress;

import model.Message;
import contact.Contact;

public interface ControllerAdapterInterface {
	
	void setUserLocal(Contact userLocal);
	void initComponents();
	void connection();
	void disconnection();
	
	Boolean isConnected();
	Boolean isDisconnected();
	void setStatus(Boolean connected);
	
	int getTimerCheckDelay();

	void modelAddContact(Contact userRemote);
	Boolean findRemoteUserFromModel(Contact userRemote);
	boolean isEmptyUserRemoteList();

	void userRemoteActionTimerHasExpired(Contact userRemote);

	void receiveMessage(Message message, InetAddress ip);

	void cleanUpEnvironnement();

	
}
