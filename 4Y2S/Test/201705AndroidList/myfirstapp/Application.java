package com.example.ymao.myfirstapp;


public class Application {

    private String nom;
    private ApplicationType type;
    private String version;


    public Application(String nom, ApplicationType type, String version){
        this.nom = nom;
        this.type = type;
        this.version = version;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public ApplicationType getType() {
        return type;
    }

    public void setType(ApplicationType type) {
        this.type = type;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    @Override
    public String toString(){
        String s = "App nom:<" + this.nom + ">, type:" + this.type.toString() +
                ", version: " + this.version;
        return s;
    }


}
