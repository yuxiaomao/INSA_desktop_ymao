package model;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.file.DirectoryNotEmptyException;
import java.nio.file.Files;
import java.nio.file.NoSuchFileException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

import contact.Contact;

public class ModelContactRemote {
	private Contact contact;
	private Path chatHistoryFile;
	
	public ModelContactRemote(Contact contact){
		this.contact = contact;
		this.chatHistoryFile = Paths.get(this.contact.getUsername()+"Hist.txt");
		this.cleanChatHistory();
	}
	
	public Contact getContact(){
		return this.contact;
	}
	
	public String getChatHistory(){
		Charset charset = Charset.forName("UTF-8");
		String hist = "--- THE HISTORY ---";
		try (BufferedReader reader = Files.newBufferedReader(chatHistoryFile, charset)) {
		    String line = null;
		    while ((line = reader.readLine()) != null) {
		        hist = hist+"\n"+line;
		    }
		} catch (IOException x) {
		    System.err.format("IOException: %s%n", x);
		}
		return hist;
	}
	
	public void writeChatHistory(String s){
		// write the line at the end of the history file
		Charset charset = Charset.forName("UTF-8");
		try (BufferedWriter writer = Files.newBufferedWriter(this.chatHistoryFile, charset, StandardOpenOption.APPEND)) {
		    writer.write(s, 0, s.length());
		} catch (IOException x) {
		    System.err.format("IOException: %s%n", x);
		}
	}
	
	public void cleanChatHistory(){
		// write null and crash the content of original file
		Charset charset = Charset.forName("UTF-8");
		String s = "";
		try (BufferedWriter writer = Files.newBufferedWriter(this.chatHistoryFile, charset)) {
		    writer.write(s, 0, s.length());
		} catch (IOException x) {
		    System.err.format("IOException: %s%n", x);
		}
	}
	
	public String toString(){
		return this.getContact().toString();
	}
	
	@Override
	protected void finalize() throws Throwable {
		try {
		    Files.delete(this.chatHistoryFile);
		} catch (NoSuchFileException x) {
		    System.err.format("%s: no such" + " file or directory%n", this.chatHistoryFile);
		} catch (DirectoryNotEmptyException x) {
		    System.err.format("%s not empty%n", this.chatHistoryFile);
		} catch (IOException x) {
		    // File permission problems are caught here.
		    System.err.println(x);
		}
	}


}
