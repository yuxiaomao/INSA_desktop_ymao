package core;

import java.util.ArrayList;

//une liste de sommets
public class Chemin {
	ArrayList <Integer> chemin;
	
	public Chemin() {
		this.chemin = new ArrayList <Integer>();	
	}
	
	public int getSize(){
		return this.chemin.size();
	}
	
	//cas sommets reçus dans l'ordre du chemin (new sommet ajoute a la fin)
	public void addSommet(int s){
		chemin.add(s);
	}
	
	//cas 1er sommet reçu est le dernier du chemin (new sommet insere au debut)
	public void addSommetInverse(int s){
		chemin.add(0, s);
	}
	
	public int getSommet(int index){
		return this.chemin.get(index);
	}
	


}
