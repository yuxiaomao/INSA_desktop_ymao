package jUnitTest;

import static org.junit.Assert.*;

import java.net.InetAddress;
import java.net.UnknownHostException;

import model.Contact;
import model.MsgGoodbye;
import model.MsgHello;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class ControllerTest {
	
	ControllerAdapterInterface cA ;
	Contact userLocal;
	Contact userRemote;
	
	@Before
	/* Creating a test environment with two users with different IP and a ControllerAdapter */
	public void prepareEnvironment(){
		try {
			this.userLocal = new Contact("local", InetAddress.getLocalHost(), null);
			this.userRemote = new Contact("remote",InetAddress.getByName("10.10.10.10"), null);
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		this.cA = new ControllerAdapter();
		this.cA.setUserLocal(userLocal);
		this.cA.initComponents();
	}
	
	/* Clean the environment after each of the test*/
	@After
	public void cleanUpEnvironment(){
		this.cA.disconnection();
		this.cA.cleanUpEnvironment();
	}
	
	/* Init the components and verify that at the beginning, no user are in the list of connected users*/
	@Test
	public void InitModelContainsNoRemoteUserTest(){
		assertTrue("Before this test, the model should not contains any userRemote", this.cA.isEmptyUserRemoteList());
	}
	
	/* If we disconnect from the system, it removes all the connected users from the list */
	@Test
	public void DisconnectRemoveElements(){
		this.cA.modelAddContact(userRemote);
		this.cA.disconnection();
		assertFalse("All users must be removed", this.cA.findRemoteUserFromModel(userRemote));
	}

	/* If an user is in our connected list and his timer expires, he is then removed from the model */
	@Test
	public void CheckHasNoAnswerTest(){
		this.cA.modelAddContact(userRemote);
		this.cA.userRemoteActionTimerHasExpired(userRemote);
		assertFalse("The remote user must be removed from the model if he doesn't answer the check and his timer has expired", this.cA.findRemoteUserFromModel(userRemote));
	}
	
	/*
	//If someone is in the list and his timer get restarted (by receiving a CheckOK), he isn't removed
	@Ignore
	@Test
	public void CheckHasAnsweredTest(){
		cA.modelAddContact(userRemote);
		// creer un autre entité qui répond automatiquement à tout les checks?
		Timer timerCheck = new Timer(cA.getTimerCheckDelay(),new ActionListener()
		{
			public void actionPerformed(ActionEvent e)
			{
				assertNotNull("User must not be delected when he response always the chat",cA.findRemoteUserFromModel(userRemote));
			}
		});
		//timerCheck.setRepeats(false);
		timerCheck.start();
	}
	*/ 
	
	/* If we receive a Hello message, we add the User in the list of connected users */
	@Test
	public void ReceivedHelloTest(){
		MsgHello message = new MsgHello(userRemote.getUsername(), userLocal.getUsername(), false, true);
		this.cA.getController().udpr.setMessagewithip(0, message);
		this.cA.setStatus(true);
		this.cA.receiveMessage(message,userRemote.getIp());
		assertTrue("After receiving a hello from another user, the user must be added in the list of connected users",this.cA.findRemoteUserFromModel(userRemote));
	}
	
	/* During the connection phase, if we receive a Hello_OK message, we add the User in the list of connected users */
	@Test
	public void ReceivedHelloOkTest(){
		MsgHello message = new MsgHello(userRemote.getUsername(), userLocal.getUsername(), true, true);
		this.cA.connection();
		this.cA.getController().udpr.setMessagewithip(0, message);
		this.cA.receiveMessage(message,userRemote.getIp());
		assertTrue("After receiving a hello ok during the connection time, the user must be present in the list of connected users",this.cA.findRemoteUserFromModel(userRemote));
	}
	
	/* During the connection phase, if we receive a Hello_Not_OK message, we will be disconnected from the Chat System*/
	@Test
	public void ReceivedHelloNotOkTest(){
		MsgHello message = new MsgHello(userRemote.getUsername(), userLocal.getUsername(), true, false);
		this.cA.connection();
		this.cA.getController().udpr.setMessagewithip(0, message);
		this.cA.receiveMessage(message,userRemote.getIp());
		assertTrue("After receiving a HelloNotOk during the connection phase, we get disconnected",this.cA.isDisconnected());
	}
	
	/* Receiving a Goodbye message during the connecting phase removes the given user off the connected List */
	@Test
	public void ReceivedGoodbyeDuringConnectingTest(){
		MsgGoodbye message = new MsgGoodbye(userRemote.getUsername(), userLocal.getUsername());
		this.cA.connection();
		this.cA.modelAddContact(userRemote);
		this.cA.getController().udpr.setMessagewithip(0, message);
		this.cA.receiveMessage(message,userRemote.getIp());
		assertFalse("User is removed of the list, because of receiving a Goodbye during connecting phase",this.cA.findRemoteUserFromModel(userRemote));
	}
	
	/* Receiving a Goodbye message after being connected removes the given user off the connected List */
	@Test
	public void ReceivedGoodbyeDuringConnectedTest(){
		MsgGoodbye message = new MsgGoodbye(userRemote.getUsername(), userLocal.getUsername());
		this.cA.connection();
		this.cA.setStatus(true);
		this.cA.modelAddContact(userRemote);
		this.cA.getController().udpr.setMessagewithip(0, message);
		this.cA.receiveMessage(message,userRemote.getIp());
		assertFalse("User is removed of the list, because of receiving a Goodbye",this.cA.findRemoteUserFromModel(userRemote));
	}
	
	/* Receiving a Goodbye from an user who have the same username (as an user from our connected users list)
	 * and a different ip, should not remove the user that already exist
	 * This could happen when someone try to connect with a username that is already used */
	@Test
	public void ReceivedGoodbyeFromSomeoneNotInListTest(){
		Contact userRemote2;
		MsgGoodbye message;
		this.cA.connection();
		this.cA.setStatus(true);
		this.cA.modelAddContact(userRemote);
		try {
			userRemote2 = new Contact("remote",InetAddress.getByName("10.10.10.11"), null);
			message = new MsgGoodbye(userRemote2.getUsername(), userLocal.getUsername());
			this.cA.getController().udpr.setMessagewithip(0, message);
			this.cA.receiveMessage(message,userRemote2.getIp());
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		assertTrue("Already connected user isn't removed from receiving Goodbye of an user (with same username and different IP",this.cA.findRemoteUserFromModel(userRemote));
	}
	
	
	
}
