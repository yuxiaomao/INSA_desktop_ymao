package jUnitTest;

import static org.junit.Assert.*;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
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

import contact.Contact;

public class ControllerSendTest {
	
	ControllerAdapterInterface cA ;
	Contact userLocal;
	Contact userRemote;

	/* we prepare an environment that the controller is already connected, 
	 * and there is an user remote in the system
	 * and we want to test all reply
	 */
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
		this.cA.connection();
		this.cA.setStatus(true);
		this.cA.modelAddContact(userRemote);
	}

	@After
	public void cleanUpEnvironnement(){
		this.cA.disconnection();
		this.cA.cleanUpEnvironnement();
	}
	
	/* verify a msgTxt can be detect correctly in jUnit */
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
	
	
	/* when user connect, he must send a hello broadcast */
	@Test
	public void BroadcastHelloTest() {
		// analyze the package that the controller sent
		DatagramPacket packet = this.cA.getLastDatagramPacketSended();
		Message messageSended = this.datagramPacketToMessage(packet);
		if (messageSended instanceof MsgHello){
			MsgHello msgHelloSended = (MsgHello) messageSended;
			assertFalse("when user connect, he sent a hello ack = 0", msgHelloSended.getAck());
			assertTrue("when user connect, he sent a hello connect = 1", msgHelloSended.getConnect());
			assertEquals("when user connect, he sent a hello broadcast", this.cA.getBroadcastInetAddress(), packet.getAddress());
		} else{
			fail("when user connect, he must send a hello");
		}
	}
	
	/* when user disconnect, he must send a goodbye broadcast */
	@Test
	public void BroadcastGoodbyeTest() {
		this.cA.disconnection();
		
		DatagramPacket packet = this.cA.getLastDatagramPacketSended();
		Message messageSended = this.datagramPacketToMessage(packet);
		if (messageSended instanceof MsgGoodbye){
			assertEquals("when user disconnect, he sent a goodbye broadcast", this.cA.getBroadcastInetAddress(), packet.getAddress());
		} else{
			fail("when user disconnect, he must send a goodbye");
		}
	}

	/* when user receive an Hello with a valid username, he reply a hello ok*/
	@Test
	public void ReplyHelloOKTest() {
		Contact userRemote2 = null;
		try {
			userRemote2 = new Contact("remote2",InetAddress.getByName("10.10.10.11"), null);
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		MsgHello messageReceived = new MsgHello(userRemote2.getUsername(), userLocal.getUsername(), false, true);
		this.cA.receiveMessage(messageReceived, userRemote2.getIp());
		
		DatagramPacket packet = this.cA.getLastDatagramPacketSended();
		Message messageSended = this.datagramPacketToMessage(packet);
		if (messageSended instanceof MsgHello){
			MsgHello msgHelloSended = (MsgHello) messageSended;
			assertTrue("when user receive an Hello with a valid username, he reply a hello ok with ack=1", msgHelloSended.getAck());
			assertTrue("when user receive an Hello with a valid username, he reply a hello ok with connect=1", msgHelloSended.getConnect());
		}
	}
	
	/* when user receive an Hello with a local username, reply a hello not ok*/
	@Test
	public void ReplyHelloNOKTest() {
		Contact userRemote2 = null;
		try {
			userRemote2 = new Contact("local",InetAddress.getByName("10.10.10.11"), null);
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		MsgHello messageReceived = new MsgHello(userRemote2.getUsername(), userLocal.getUsername(), false, true);
		this.cA.receiveMessage(messageReceived, userRemote2.getIp());
		
		DatagramPacket packet = this.cA.getLastDatagramPacketSended();		
		Message messageSended = this.datagramPacketToMessage(packet);
		if (messageSended instanceof MsgHello){
			MsgHello msgHelloSended = (MsgHello) messageSended;
			assertTrue("when user receive an Hello with the same username, he reply a hello nok with ack=1", msgHelloSended.getAck());
			assertFalse("when user receive an Hello with the same username, he reply a hello nok with connect=0", msgHelloSended.getConnect());
		}
	}
	
	/* when user receive an Hello with a no local but either no valid username, reply nothing*/
	@Test
	public void ReplyHelloNothingTest() {
		Contact userRemote2 = null;
		try {
			userRemote2 = new Contact("remote",InetAddress.getByName("10.10.10.11"), null);
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}
		MsgHello messageReceived = new MsgHello(userRemote2.getUsername(), userLocal.getUsername(), false, true);
		this.cA.receiveMessage(messageReceived, userRemote2.getIp());
		
		DatagramPacket packet = this.cA.getLastDatagramPacketSended();		
		Message messageSended = this.datagramPacketToMessage(packet);
		// so the last packet sended by user local might be a hello or other, but not a reply
		if (messageSended instanceof MsgHello){
			MsgHello msgHelloSended = (MsgHello) messageSended;
			// so if it is an normal hello then ok
			assertFalse("when user receive an Hello with a no valid username, he reply nothing", msgHelloSended.getAck());
		} else{
			assertTrue("when user receive an Hello with a no valid username, the last message he sended could not be type hello", true);
		}
	}
	
	/* when user receive an Check, he reply automatically an check ok*/
	@Test
	public void ReplyCheckOKTest() {
		MsgCheck messageReceived = new MsgCheck(this.userRemote.getUsername(), this.userLocal.getUsername(), false);
		this.cA.receiveMessage(messageReceived, this.userRemote.getIp());
		
		DatagramPacket packet = this.cA.getLastDatagramPacketSended();		
		Message messageSended = this.datagramPacketToMessage(packet);
		
		// verify it's type is check ok
		if (messageSended instanceof MsgCheck){
			MsgCheck msgCheckSended = (MsgCheck) messageSended;
			assertTrue("when user receive an Check, he reply an Check ok", msgCheckSended.getAck());
		}else{
			fail("when user receive an Check, he must reply");
		}
	}
	
	/* when user want to send an msgTxt, it really sent an msgTxt */
	@Test
	public void SendMsgTxtTest() {
		String content = "This is a message";
		this.cA.userWroteAMessageAndWantToSend(content, this.userRemote.getUsername());
		
		DatagramPacket packet = this.cA.getLastDatagramPacketSended();		
		Message messageSended = this.datagramPacketToMessage(packet);
		
		// verify it's type is messageTxt
		if (messageSended instanceof MsgTxt){
			MsgTxt msgTxtSended = (MsgTxt) messageSended;
			assertEquals("when user want to send a txt, the content is right",content, msgTxtSended.getData());
		}else{
			fail("when user want to send a txt, a msgTxt will be sended");
		}
	}
	
	/* when user want to send an msgFile, it really sent an msgFile */
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
		
		DatagramPacket packet = this.cA.getLastDatagramPacketSended();		
		Message messageSended = this.datagramPacketToMessage(packet);
		
		// verify it's type is messageTxt
		if (messageSended instanceof MsgFile){
			MsgFile msgFileSended = (MsgFile) messageSended;
			System.out.println("Content:"+content);
			System.out.println("data:"+msgFileSended.getData().toString());
			
			// construct the content of file
			assertEquals("when user want to send a File, the content is right",content, new String(msgFileSended.getData(), StandardCharsets.UTF_8));
		}else{
			fail("when user want to send a File, a msgFile will be sended");
		}
	}
	
	/* when user received 2 files, those 2 files are both saved */
	@Test
	public void Receive2FilesText() {
		byte[] content1 = "Hello hello".getBytes(StandardCharsets.UTF_8);
		MsgFile msgFile1 = new MsgFile(this.userRemote.getUsername(), this.userLocal.getUsername(), content1);
		this.cA.receiveMessage(msgFile1, this.userRemote.getIp());
		
		byte[] content2 = "Hello hello 2".getBytes(StandardCharsets.UTF_8);
		MsgFile msgFile2 = new MsgFile(this.userRemote.getUsername(), this.userLocal.getUsername(), content2);
		this.cA.receiveMessage(msgFile2, this.userRemote.getIp());
		
		/*these line are specific to our implementation, i.e file tmp0 tmp1
		 * and this do not consider the extension of file*/
		// verify that tmp0 = content1
		String filetmp0 = "";
		try (BufferedReader reader = Files.newBufferedReader(Paths.get("tmp0.txt"), StandardCharsets.UTF_8)){
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
		try (BufferedReader reader = Files.newBufferedReader(Paths.get("tmp1.txt"), StandardCharsets.UTF_8)){
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
			Files.delete(Paths.get("tmp0.txt"));
			Files.delete(Paths.get("tmp1.txt"));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	/* a function to unpackage datagram */
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
