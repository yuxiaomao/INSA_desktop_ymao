package model;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.net.InetAddress;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

import javax.swing.DefaultListModel;

import contact.Contact;
import contact.State;

public class Model{

	private Contact userLocal;
	private DefaultListModel<ModelContactRemote> userList;
	private Path localLog;

	public Model(Contact userLocal) {
		this.userLocal = userLocal;
		this.userList = new DefaultListModel<ModelContactRemote>();
		this.userLocal.setState(State.DISCONNECTED);
		this.localLog = Paths.get(this.userLocal.getUsername()+"Log.txt");
		this.cleanLog();
	}

	public Contact getUserLocal() {
		return userLocal;
	}

	public DefaultListModel<ModelContactRemote> getRemoteUsers()
    {
        return this.userList;
    }

	public void addUserRemote(Contact userRemote){
		Contact userTmp = null;
		for(int i=0;i<this.userList.size();i++){
			userTmp = this.userList.getElementAt(i).getContact();
            if (userTmp.getIp().equals(userRemote.getIp())){
            	// userRemote already in the list
            	return;
            }
        }
		// userRemote not in the list
		this.userList.addElement(new ModelContactRemote(userRemote));
		System.out.println("[Model]List of remoteUsers:"+this.userList.toString());
	}

	public void removeUserRemote(Contact userRemote){
		Contact userTmp = null;
		System.out.println("[Model]remove userRemote Ip:"+userRemote.getIp());
		for(int i=0;i<this.userList.size();i++){
			userTmp = this.userList.getElementAt(i).getContact();
            if (userTmp.getIp().equals(userRemote.getIp())){
            	// userRemote already in the list
            	this.userList.removeElementAt(i);

            }
        }
		System.out.println("[Model]List of remoteUsers:"+this.userList.toString());
	}

	public Contact getUserRemoteByName(String username){
		Contact userRemote = null;
		Contact userTmp = null;
		for(int i=0;i<this.userList.size();i++){
			userTmp = this.userList.getElementAt(i).getContact();
            if (userTmp.getUsername().equals(username)){
            	userRemote = userTmp;
            	break;
            }
        }
		return userRemote;
	}

	public Contact getUserRemoteByIP(InetAddress hostaddr){
		Contact userRemote = null;
		Contact userTmp = null;
		for(int i=0;i<this.userList.size();i++){
			userTmp = this.userList.getElementAt(i).getContact();
            if (userTmp.getIp().equals(hostaddr)){
            	userRemote = userTmp;
            	break;
            }
        }
		return userRemote;
	}

	public ModelContactRemote getModelContactRemoteByName(String username){
		ModelContactRemote userRemote = null;
		ModelContactRemote userTmp = null;
		for(int i=0;i<this.userList.size();i++){
			userTmp = this.userList.getElementAt(i);
            if (userTmp.getContact().getUsername().equals(username)){
            	userRemote = userTmp;
            	break;
            }
        }
		return userRemote;
	}

	public String getChatHistoryByName(String username){
		ModelContactRemote userRemote = null;
		ModelContactRemote userTmp = null;
		for(int i=0;i<this.userList.size();i++){
			userTmp = this.userList.getElementAt(i);
            if (userTmp.getContact().getUsername().equals(username)){
            	userRemote = userTmp;
            	break;
            }
        }
		return userRemote.getChatHistory();
	}

	public void removeAllUserListElement(){
		this.userList.removeAllElements();
	}

	// these 3 functions below is the same as in ModelContactRemote for chatHistory
    // but for the mesure that a local user is different to remote users
    // I haven't use the same model

	public String getLog(){
		Charset charset = Charset.forName("UTF-8");
		String log = "---THE LOG---";
		try (BufferedReader reader = Files.newBufferedReader(localLog, charset)) {
		    String line = null;
		    while ((line = reader.readLine()) != null) {
		        log = log+"\n"+line;
		    }
		} catch (IOException x) {
		    System.err.format("IOException: %s%n", x);
		}
		return log;
	}

	public void writeLog(String s){
		// write the line at the end of the history file
		Charset charset = Charset.forName("UTF-8");
		try (BufferedWriter writer = Files.newBufferedWriter(this.localLog, charset, StandardOpenOption.APPEND)) {
		    writer.write(s, 0, s.length());
		} catch (IOException x) {
		    System.err.format("IOException: %s%n", x);
		}
	}

	public void cleanLog(){
		// write null and crash the content of original file
		Charset charset = Charset.forName("UTF-8");
		String s = "";
		try (BufferedWriter writer = Files.newBufferedWriter(this.localLog, charset)) {
		    writer.write(s, 0, s.length());
		} catch (IOException x) {
		    System.err.format("IOException: %s%n", x);
		}
	}

}
