package jUnitTest;

import static org.junit.Assert.*;

import java.net.InetAddress;
import java.net.UnknownHostException;

import model.MsgGoodbye;
import model.MsgHello;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import contact.Contact;

public class ControllerTest {

	ControllerAdapterInterface cA ;
	Contact userLocal;
	Contact userRemote;

	@Before
	public void prepareEnvironnement(){
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

	@After
	public void cleanUpEnvironnement(){
		this.cA.disconnection();
		this.cA.cleanUpEnvironnement();
	}

	//Init the component and make sure that in the beginning there's no any remoteUser
	@Test
	public void InitModelContainsNoRemoteUserTest(){
		assertTrue("Before this test, Model should not conteins any userRemote", this.cA.isEmptyUserRemoteList());
	}

	//If someone is in our connected List and his timer expires, he is removed from the model
	@Test
	public void CheckHasNoAnswerTest(){
		this.cA.modelAddContact(userRemote);
		this.cA.userRemoteActionTimerHasExpired(userRemote);
		assertFalse("The remote user must be delected after his no reponse and a timer expired", this.cA.findRemoteUserFromModel(userRemote));
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

	//If we receive Hello, we add it into the list
	@Test
	public void ReceivedHelloTest(){
		MsgHello message = new MsgHello(userRemote.getUsername(), userLocal.getUsername(), false, true);
		this.cA.setStatus(true);
		this.cA.receiveMessage(message,userRemote.getIp());
		assertTrue("User must be present in the list when he says a Hello to userLocal",this.cA.findRemoteUserFromModel(userRemote));
	}

	//During the connection if we receive Hello OK, we add it into the list
	@Test
	public void ReceivedHelloOkTest(){
		MsgHello message = new MsgHello(userRemote.getUsername(), userLocal.getUsername(), true, true);
		this.cA.connection();
		this.cA.receiveMessage(message,userRemote.getIp());
		assertTrue("User must be present in the list when you receive a reply hello ok during the connecting time",this.cA.findRemoteUserFromModel(userRemote));
	}

	//During the connection if we receive Hello OK, we will deconnect
	@Test
	public void ReceivedHelloNokTest(){
		MsgHello message = new MsgHello(userRemote.getUsername(), userLocal.getUsername(), true, false);
		this.cA.connection();
		this.cA.receiveMessage(message,userRemote.getIp());
		assertTrue("User must be present in the list when you receive a reply hello ok during the connecting time",this.cA.isDisconnected());
	}

	//Receive Goodbye during the connecting, remove that user
	@Test
	public void ReceivedGoodbyeDuringConnectingTest(){
		MsgGoodbye message = new MsgGoodbye(userRemote.getUsername(), userLocal.getUsername());
		this.cA.connection();
		this.cA.modelAddContact(userRemote);
		this.cA.receiveMessage(message,userRemote.getIp());
		assertFalse("User must be removed from the list while you received a Goodbye during connecting phase",this.cA.findRemoteUserFromModel(userRemote));
	}

	//Receive Goodbye during the connecting, remove that user
	@Test
	public void ReceivedGoodbyeDuringConnectedTest(){
		MsgGoodbye message = new MsgGoodbye(userRemote.getUsername(), userLocal.getUsername());
		this.cA.connection();
		this.cA.setStatus(true);
		this.cA.modelAddContact(userRemote);
		this.cA.receiveMessage(message,userRemote.getIp());
		assertFalse("User must be removed from the list while you received a Goodbye during connecting phase",this.cA.findRemoteUserFromModel(userRemote));
	}

	//Receive Goodbye with someone who have the same username but not the same ip, should not removed the one already exist
	//This can happened when someone try to connecte with a username already been used
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
			this.cA.receiveMessage(message,userRemote2.getIp());
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		assertTrue("User must be removed from the list while you received a Goodbye during connecting phase",this.cA.findRemoteUserFromModel(userRemote));
	}


}
