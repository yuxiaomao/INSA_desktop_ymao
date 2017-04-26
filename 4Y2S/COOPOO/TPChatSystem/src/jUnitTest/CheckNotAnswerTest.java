package jUnitTest;

import static org.junit.Assert.*;
import org.hamcrest.*;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.net.InetAddress;
import java.net.UnknownHostException;

import contact.Contact;
import controller.*;
import gui.*;
import network.*;

public class CheckNotAnswerTest {
	
	static Controller c; 
	static Window w;
	static Contact user;
	static UDPSender udps;
	static UDPReceiver udpr;
	
	@org.junit.BeforeClass
	public static void setUpBeforeClass() {
		w = new Window();
		c = new Controller("Test-045",w);
		InetAddress addr=null;
		try {
			addr = InetAddress.getLocalHost();
		} catch (UnknownHostException e1) {
			e1.printStackTrace();
		}
		user=new Contact("UserTest",addr,new ActionListener(){
		      public void actionPerformed(ActionEvent e){
		      }
		});
	}
	
	
	@org.junit.Before
	public void setUp() {
		c.getCheckTimer().stop();
		c.getModel().addRemoteUser(user);
	}
	
	//If someone is in our connected List and his timer expires, he is removed from the model
	@org.junit.Test
	public void CheckHasNoAnswerTest(){
		c.aTimerHasExpired("UserTest");
		assertNull("User has been deleted",c.getModel().checkRemoteUserName("UserTest"));
	}
	
	/*
	 * If someone is in the list and his timer get restarted (by receiving a CheckOK)
	 * he isn't deleted from the 
	 */
	@org.junit.Test
	public void CheckHasAnsweredTest(){
		//Pas fini
		c.getModel().addRemoteUser(user);
		assertNotNull("User has not been deleted",c.getModel().checkRemoteUserName("UserTest"));
	}

	/*
	 * If we disconnect, only All label is available in the JList 
	 */
	@org.junit.Test
	public void DisconnectionTest(){
		InetAddress addr=null;
		try {
			addr = InetAddress.getLocalHost();
		} catch (UnknownHostException e1) {
			e1.printStackTrace();
		}
		Contact user1=new Contact("UserTest1",addr,new ActionListener(){
		      public void actionPerformed(ActionEvent e){
		      }
		});
		c.getModel().addRemoteUser(user1);
		
		c.cleanUI();
  	  	c.getModel().getLocalUser().setState(Contact.State.DISCONNECTED);
  	  
		assertNotNull("Emptied connected List",c.getModel().checkRemoteUserName("All"));
	}
	
	/*Si on reçoit helloOk ou Hello, on ajoute bien l’utilisateur dans la liste.
	     

	Si on reçoit un goodbye qui vient d'une personne pas présente dans la liste,
	alors on ne modifie pas la liste (plus précisément on enlève pas ce qui est
	déjà connecté)
	exemple: rama est yuxiao sont connectés. Un autre rama veut se connecter,
	mais rama et yuxiao ne l'ajoute pas dans leur liste. Si l’autre rama se déconnecte, il enverra peut-être un goodbye (normalement si on a bien codé non).
	Si yuxiao reçoit ce goodbye du deuxième rama, alors il ne faut pas enlever le premier (et l’unique) rama.*/

	
}
