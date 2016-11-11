package core;

public class Label implements Comparable<Label>{
	//toujours float
	
	private boolean marquage;
	private float cout;  //cout distance en m, coutTemps en min
	private int pere;  // -1 si pas de pere
	private int sommet_courant;
	
	public Label(boolean marquage, float cout, int pere, int sommet_courant) {
		this.marquage = marquage;
		this.cout = cout;
		this.pere = pere;
		this.sommet_courant = sommet_courant;
	}

	public boolean isMarquage() {
		return marquage;
	}

	public void setMarquage(boolean marquage) {
		this.marquage = marquage;
	}

	public float getCout() {
		return cout;
	}

	public void setCout(float cout) {
		this.cout = cout;
	}

	public int getPere() {
		return pere;
	}

	public void setPere(int pere) {
		this.pere = pere;
	}

	public int getSommet_courant() {
		return sommet_courant;
	}

	public void setSommet_courant(int sommet_courant) {
		this.sommet_courant = sommet_courant;
	}

	public int compareTo(Label o) {
		float diff = this.cout - o.cout;
		if (diff ==0.0f){
			return 0;
		}else if(diff > 0.0f){
			return 1;// doute si int0.1=0ou1
		}else{
			return -1;
		}
		//return Cout.compare(this.cout,o.cout);
	}
	
	public String toString(){
		return this.sommet_courant + " " + this.cout;
	}
	
}
