import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;



public class CommunicaSystem {

	public CommunicaSystem() {
		// TODO Auto-generated constructor stub
	}

	/** main entry point */
	public static void main(String[] args) {
		
		File fileAtoB = new File("AtoB.txt");
		File fileBtoA = new File("BtoA.txt");
		BufferedReader readerA = null;
		BufferedReader readerB = null;
		BufferedWriter writerA = null;
		BufferedWriter writerB = null;
		try {
			readerA = new BufferedReader(new FileReader(fileBtoA));
			readerB = new BufferedReader(new FileReader(fileAtoB));
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		}
		
		try {
			writerA = new BufferedWriter(new FileWriter(fileAtoB));
			writerB = new BufferedWriter(new FileWriter(fileBtoA));
		} catch (IOException e) {
			e.printStackTrace();
		}
		Comunica cA = new Comunica(readerA, writerA);
		Comunica cB = new Comunica(readerB, writerB);
		cA.setLocation(300, 300);
		cB.setLocation(0, 300);
	}

}
