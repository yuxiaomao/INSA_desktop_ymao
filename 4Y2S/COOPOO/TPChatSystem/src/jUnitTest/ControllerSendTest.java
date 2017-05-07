package jUnitTest;

import static org.junit.Assert.*;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.DatagramPacket;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import model.Message;
import model.MsgCheck;
import model.MsgFile;
import model.MsgGoodbye;
import model.MsgHello;
import model.MsgTxt;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import model.Contact;

public class ControllerSendTest {
	
	ControllerAdapterInterface cA ;
	Contact userLocal;
	Contact userRemote;

	/* We set a complete environment where a controller is created and connected
	 * and with two users in the system to test the response to messages.
	 */
	@Before
	public void prepareEnvironment(){
		try {
			this.userLocal = new Contact("local", InetAddress.getLocalHost(), null);
			this.userRemote = new Contact("remote",InetAddress.getByName("10.10.10.10"), null);
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		this.cA = new ControllerAdapter();
		this.cA.initComponents();
		this.cA.setUserLocal(userLocal);
		this.cA.connection();
		this.cA.setStatus(true);
		this.cA.modelAddContact(userRemote);
	}

	@After
	public void cleanUpEnvironment(){
		this.cA.disconnection();
		this.cA.cleanUpEnvironment();
	}
	
	/* Verify that an instance of the class Message is correctly detected */
	@Test
	public void InstanceOfTest() {
		String content = "This is a message";
		MsgTxt msgTxt = new MsgTxt(this.userRemote.getUsername(), this.userLocal.getUsername(), content);
		byte[] buf = new byte[2048];

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		try {
			ObjectOutputStream oos = new ObjectOutputStream(baos);
			oos.writeObject(msgTxt);
			oos.close();
			buf=baos.toByteArray();
		} catch (IOException e1) {
			e1.printStackTrace();
		}
		DatagramPacket packet = new DatagramPacket(buf, buf.length, null, 1234);
		Message message = this.datagramPacketToMessage(packet);
		assertTrue("A msgTxt after analyse must be a msgTxt", message instanceof MsgTxt);
	}
	
	
	/* When an user connects to the system, he sends a hello message in broadcast mode*/
	@Test
	public void BroadcastHelloTest() {
		// analyze the package that the controller sent
		Message messageSent = this.cA.getController().udps.getLastMessage();
		if (messageSent instanceof MsgHello){
			MsgHello msgHelloSent = (MsgHello) messageSent;
			assertFalse("When an user connects, he sends a hello (ack = 0)", msgHelloSent.getAck());
			assertTrue("When an user connects, he sends a hello (connect = 1)", msgHelloSent.getConnect());
			assertEquals("When an user connects, he sends a hello broadcast", "All", messageSent.getUserDest());
		} else{
			fail("When an user connects, he have to send a hello");
		}
	}
	
	/* When an user disconnects, he have to send a goodbye message in broadcast mode*/
	@Test
	public void BroadcastGoodbyeTest() {
		this.cA.disconnection();
		Message messageSent = this.cA.getController().udps.getLastMessage();
		if (messageSent instanceof MsgGoodbye){
			assertEquals("When an user disconnects, he sends a goodbye broadcast", "All", messageSent.getUserDest());
		} else{
			fail("When an user connects, he have to send a a goodbye");
		}
	}

	/* When an user receives an Hello with a valid username, he automatically replies a hello ok*/
	@Test
	public void ReplyHelloOKTest() {
		Contact userRemote2 = null;
		try {
			userRemote2 = new Contact("remote2",InetAddress.getByName("10.10.10.11"), null);
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		MsgHello messageReceived = new MsgHello(userRemote2.getUsername(), userLocal.getUsername(), false, true);
		this.cA.getController().udpr.setMessagewithip(0, messageReceived);
		this.cA.receiveMessage(messageReceived, userRemote2.getIp());
		
		Message messageSent = this.cA.getController().udps.getLastMessage();
		if (messageSent instanceof MsgHello){
			MsgHello msgHelloSent = (MsgHello) messageSent;
			assertTrue("When an user receives an Hello with a valid username, he replies a hello ok with ack=1", msgHelloSent.getAck());
			assertTrue("When an user receives an Hello with a valid username, he replies a hello ok with connect=1", msgHelloSent.getConnect());
		}
	}
	
	/* When user receive an Hello with an username that matches his current username, he automatically replies a hello not ok*/
	@Test
	public void ReplyHelloNOKTest() {
		Contact userRemote2 = null;
		try {
			userRemote2 = new Contact("local",InetAddress.getByName("10.10.10.11"), null);
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		MsgHello messageReceived = new MsgHello(userRemote2.getUsername(), userLocal.getUsername(), false, true);
		this.cA.getController().udpr.setMessagewithip(0, messageReceived);
		this.cA.receiveMessage(messageReceived, userRemote2.getIp());
		
		Message messageSent = this.cA.getController().udps.getLastMessage();
		if (messageSent instanceof MsgHello){
			MsgHello msgHelloSent = (MsgHello) messageSent;
			assertTrue("When user receive an Hello with an username that matches his current username, he replies a hello nok with ack=1", msgHelloSent.getAck());
			assertFalse("When user receive an Hello with an username that matches his current username, he replies a hello nok with connect=0", msgHelloSent.getConnect());
		}
	}
	
	/* When an user receives a Check message, he automatically replies a check ok*/
	@Test
	public void ReplyCheckOKTest() {
		MsgCheck messageReceived = new MsgCheck(this.userRemote.getUsername(), this.userLocal.getUsername(), false);
		this.cA.getController().udpr.setMessagewithip(0, messageReceived);
		this.cA.receiveMessage(messageReceived, this.userRemote.getIp());
		Message messageSent = this.cA.getController().udps.getLastMessage();
		if (messageSent instanceof MsgCheck){
			MsgCheck msgCheckSent = (MsgCheck) messageSent;
			assertTrue(" When an user receives a Check message, he automatically replies a check ok", msgCheckSent.getAck());
		}else{
			fail(" When an user receives a Check message, he have to reply automatically");
		}
	}
	
	/* When an user wants to send a TxtMessage, a text message with it's content is indeed sent*/
	@Test
	public void SendMsgTxtTest() {
		String content = "This is a message";
		this.cA.userWroteAMessageAndWantToSend(content, this.userRemote.getUsername());
		Message messageSent = this.cA.getController().udps.getLastMessage();
		if (messageSent instanceof MsgTxt){
			MsgTxt msgTxtSent = (MsgTxt) messageSent;
			assertEquals("When an user wants to send a TxtMessage, a text message with it's content is indeed sent",content, msgTxtSent.getData());
		}else{
			fail("When an user wants to send a TxtMessage, a message must be sent");
		}
	}
	
	/* When a user wants to send an msgFile, a file message with it's content is indeed sent */
	@Test
	public void SendMsgFileTest() {
		// create a file
		Path path = Paths.get("jUnitSendMsgFileTest.txt");
		Charset charset = Charset.forName("UTF-8");
		String content = "This is a message";
		try (BufferedWriter writer = Files.newBufferedWriter(path, charset)) {
			writer.write(content, 0, content.length());
		} catch (IOException x) {
			System.err.format("IOException: %s%n", x);
		}
		this.cA.userChosedAFileAndWantToSend(path.toFile(), this.userRemote.getUsername());
		Message messageSent = this.cA.getController().udps.getLastMessage();
		
		if (messageSent instanceof MsgFile){
			MsgFile msgFileSent = (MsgFile) messageSent;
			System.out.println("Content:"+content);
			System.out.println("data:"+msgFileSent.getData().toString());
			
			assertEquals("When an user sent a file, it's content is the same at reception",content, new String(msgFileSent.getData(), StandardCharsets.UTF_8));
		}else{
			fail("When user wants to send a File, a msgFile is indeed sent");
		}
	}
	
	/* When an user received 2 files, the 2 files are both saved without erasing the first received */
	@Test
	public void Receive2FilesText() throws FileNotFoundException {
		byte[] content1 = "Hello hello".getBytes(StandardCharsets.UTF_8);
		MsgFile msgFile1 = new MsgFile(this.userRemote.getUsername(), this.userLocal.getUsername(), content1);
		this.cA.getController().udpr.setMessagewithip(0, msgFile1);
		this.cA.receiveMessage(msgFile1, this.userRemote.getIp());
		
		byte[] content2 = "Hello hello 2".getBytes(StandardCharsets.UTF_8);
		MsgFile msgFile2 = new MsgFile(this.userRemote.getUsername(), this.userLocal.getUsername(), content2);
		this.cA.getController().udpr.setMessagewithip(1, msgFile2);
		this.cA.receiveMessage(msgFile2, this.userRemote.getIp());
		
		/*these line are specific to our implementation, i.e file tmp0 tmp1
		 * and this do not consider the extension of file*/
		// verify that tmp0 = content1
		String filetmp0 = "";
		File f=new File("tmp0");
		FileReader in = new FileReader(f);
		try (BufferedReader reader = new BufferedReader(in)){
			String line = null;
			while ((line = reader.readLine()) != null) {
				filetmp0 = line;
			}
		}catch (IOException x) {
			System.err.format("IOException: %s%n", x);
		}
		assertEquals("when user received 2 file, the first file is saved",new String(content1, StandardCharsets.UTF_8), filetmp0);
		
		// verify that tmp1 = content2
		String filetmp1 = "";
		File f1=new File("tmp1");
		FileReader in1 = new FileReader(f1);
		try (BufferedReader reader = new BufferedReader(in1)){
			String line = null;
			while ((line = reader.readLine()) != null) {
				filetmp1 = line;
			}
		}catch (IOException x) {
			System.err.format("IOException: %s%n", x);
		}
		assertEquals("when user received 2 file, the second file is saved",new String(content2, StandardCharsets.UTF_8), filetmp1);	
		
		// after that, delete tmp0 and tmp1, the file received
		try {
			Files.delete(Paths.get("tmp0"));
			Files.delete(Paths.get("tmp1"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/* a function to unpack datagram */
	private Message datagramPacketToMessage(DatagramPacket packet){
		Message message = null;
		ByteArrayInputStream bais = new ByteArrayInputStream(packet.getData());
		try {
			ObjectInputStream ois = new ObjectInputStream(bais);
			message = (Message) ois.readObject() ;
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return message;
	}
	

}
