<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" exclude-result-prefixes="xsl"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml">

	<xsl:template match="/">
		<html>
		<head>
			<meta http-equiv="content-type" content="text/html; charset=utf-8"/>
			<title>INSA - Base de données des stages</title>
			<link rel="stylesheet" type="text/css" href="./style.css"/>
			<script src="./script.js"></script>
		</head>
		<body>
			<h1>Base de données des stages de l'INSA</h1>

			<ul class="tabs">
				<xsl:for-each select="main/*">
					<li><a href="javascript:void(0)" class="tabLink">
						<xsl:attribute name="onclick">openTab(event, '<xsl:value-of select="local-name()"/>')</xsl:attribute>
						<xsl:value-of select="local-name()"/>
					</a></li>
				</xsl:for-each>
			</ul>

			<xsl:for-each select="main/*">
				<div class="tabContent">
					<xsl:attribute name="id"><xsl:value-of select="local-name()"/></xsl:attribute>
					<xsl:apply-templates select="."/>
				</div>
			</xsl:for-each>
		</body>
		</html>
	</xsl:template>

	<xsl:template match="/main/etudiants">
		<table>
			<colgroup class="key" span="1"/>
			<thead><tr>
				<th>Numéro</th>
				<th>Nom</th>
				<th>Prénom</th>
				<th>Date de naissance</th>
			</tr></thead>
			<tbody>
				<xsl:for-each select="etudiant">
					<xsl:sort select="@numEtudiant"/>
					<tr>
						<td><xsl:value-of select="@numEtudiant"/></td>
						<td><xsl:value-of select="nom"/></td>
						<td><xsl:value-of select="prenom"/></td>
						<td><xsl:value-of select="dateDeNaissance"/></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="/main/personnels">
		<table>
			<colgroup class="key" span="1"/>
			<thead><tr>
				<th>Code de personnel</th>
				<th>Nom</th>
				<th>Prénom</th>
				<th>Fonction</th>
				<th>Adresse email</th>
				<th>Téléphone</th>
				<th>Status</th>
			</tr></thead>
			<tbody>
				<xsl:for-each select="personnel">
					<xsl:sort select="@codePersonnel"/>
					<tr>
						<td><xsl:value-of select="@codePersonnel"/></td>
						<td><xsl:value-of select="nom"/></td>
						<td><xsl:value-of select="prenom"/></td>
						<td><xsl:value-of select="fonction"/></td>
						<td><xsl:for-each select="mail">
							<xsl:value-of select="."/><br/>
						</xsl:for-each></td>
						<td><xsl:for-each select="tel">
							<xsl:value-of select="."/><br/>
						</xsl:for-each></td>
						<td><xsl:variable name="varPersonnel" select="@codePersonnel"/>
							<xsl:for-each select="/main/enseignants/enseignant[@codePersonnel=$varPersonnel]">
								Enseignant<br/>
							</xsl:for-each>
							<xsl:for-each select="/main/encadrants/encadrant[@codePersonnel=$varPersonnel]">
								Encadrant<br/>
							</xsl:for-each>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="/main/enseignants">
		<table>
			<colgroup class="key" span="1"/>
			<thead><tr>
				<th>Code de personnel</th>
			</tr></thead>
			<tbody>
				<xsl:for-each select="enseignant">
					<xsl:sort select="@codePersonnel"/>
					<tr>
						<td><xsl:value-of select="@codePersonnel"/></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="/main/encadrants">
		<table>
			<colgroup class="key" span="1"/>
			<thead><tr>
					<th>Code de personnel (industriel)</th>
					<th>Numéro SIRET (entreprise)</th>
			</tr></thead>
			<tbody>
				<xsl:for-each select="encadrant">
					<xsl:sort select="industriel/@numSIRET"/>
					<xsl:if test="industriel">
						<tr>
							<td><xsl:value-of select="@codePersonnel"/></td>
							<td><xsl:value-of select="industriel/@numSIRET"/></td>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</tbody>
		</table>
		<table>
			<colgroup class="key" span="1"/>
			<thead><tr>
					<th>Code de personnel (chercheur)</th>
					<th>Unité (laboratoire)</th>
			</tr></thead>
			<tbody>
				<xsl:for-each select="encadrant">
					<xsl:sort select="chercheur/@unite"/>
					<xsl:if test="chercheur">
						<tr>
							<td><xsl:value-of select="@codePersonnel"/></td>
							<td><xsl:value-of select="chercheur/@unite"/></td>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="/main/etablissements">
		<table>
			<colgroup span="2"/>
			<colgroup class="key" span="1"/>
			<thead><tr>
				<th>Entreprise</th>
				<th>Adresse</th>
				<th>Numéro SIRET</th>
			</tr></thead>
			<tbody>
				<xsl:for-each select="entreprise">
					<xsl:sort select="@numSIRET"/>
					<tr>
						<td><xsl:value-of select="nom"/></td>
						<td><xsl:value-of select="adresse"/></td>
						<td><xsl:value-of select="@numSIRET"/></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
		<table>
			<colgroup span="2"/>
			<colgroup class="key" span="1"/>
			<thead><tr>
				<th>Laboratoire</th>
				<th>Adresse</th>
				<th>Unité</th>
			</tr></thead>
			<tbody>
				<xsl:for-each select="laboratoire">
					<xsl:sort select="@unite"/>
					<tr>
						<td><xsl:value-of select="nom"/></td>
						<td><xsl:value-of select="adresse"/></td>
						<td><xsl:value-of select="@unite"/></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="/main/POs">
		<table>
			<colgroup class="key" span="1"/>
			<thead><tr>
				<th>Intitulé</th>
				<th>Département</th>
			</tr></thead>
			<tbody>
				<xsl:for-each select="PO">
					<xsl:sort select="@intitule"/>
					<tr>
						<td><xsl:value-of select="@intitule"/></td>
						<td><xsl:value-of select="departement"/></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="/main/stages">
			<table>
				<colgroup class="key" span="1"/>
				<thead><tr>
					<th>Code de stage<br/>Intitulé</th>
					<th>Etudiant<br/>Nom<br/>Prénom</th>
					<th>PO</th>
					<th>Rapport<br/>Evaluation</th>
					<th>Année<br/>Durée</th>
					<th>Tuteur (enseignant)<br/>Encadrant(s)</th>
					<th>Mots-Clés</th>
				</tr></thead>
				<tbody>
					<xsl:for-each select="stage">
						<xsl:sort select="@codeStage"/>
						<tr>
							<td>
								<xsl:value-of select="@codeStage"/><br/>
								<xsl:value-of select="intitule"/>
							</td>
							<td>
								<xsl:value-of select="@etudiant"/><br/>
								<xsl:variable name="varEtudiant" select="@etudiant"/>
								<xsl:for-each select="/main/etudiants/etudiant[@numEtudiant=$varEtudiant]">
									<xsl:value-of select="nom"/><br/>
									<xsl:value-of select="prenom"/>
								</xsl:for-each>
							</td>
							<td>
								<xsl:value-of select="@PO"/>
							</td>
							<td>
								<xsl:value-of select="@rapport"/><br/>
								<xsl:value-of select="@evaluation"/>
							</td>
							<td>
								<xsl:value-of select="annee"/><br/>
								<xsl:value-of select="duree"/>
							</td>
							<td>
								<xsl:value-of select="enseignant"/><br/>
								<xsl:for-each select="encadrant">
									<xsl:value-of select="."/><br/>
								</xsl:for-each>
							</td>
							<td>
								<xsl:for-each select="motCle">
									<xsl:value-of select="."/><br/>
								</xsl:for-each>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
	</xsl:template>

	<xsl:template match="/main/evaluations">
		<table>
			<colgroup class="key" span="1"/>
			<thead><tr>
				<th>Code d'évaluation</th>
				<th>Note</th>
				<th>Commentaire</th>
			</tr></thead>
			<tbody>
				<xsl:for-each select="evaluation">
					<xsl:sort select="@codeEvaluation"/>
					<tr>
						<td><xsl:value-of select="@codeEvaluation"/></td>
						<td><xsl:value-of select="note"/></td>
						<td><xsl:value-of select="commentaire"/></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="/main/rapports">
		<table>
			<colgroup class="key" span="1"/>
			<thead><tr>
				<th>Code de rapport</th>
				<th>Intitulé</th>
				<th>Note</th>
				<th>Code de soutenance</th>
			</tr></thead>
			<tbody>
				<xsl:for-each select="rapport">
					<xsl:sort select="@codeRapport"/>
					<tr>
						<td><xsl:value-of select="@codeRapport"/></td>
						<td><xsl:value-of select="intitule"/></td>
						<td><xsl:value-of select="note"/></td>
						<td><xsl:value-of select="soutenance"/></td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>

	<xsl:template match="/main/soutenances">
		<table>
			<colgroup class="key" span="1"/>
			<thead><tr>
				<th>Code de soutenance</th>
				<th>Date</th>
				<th>Lieu</th>
				<th>Note de présentation</th>
				<th>Note de rapport</th>
				<th>Jury (enseignants)</th>
				<th>Jury (encadrants)</th>
				<th>Jury (tuteur)</th>
			</tr></thead>
			<tbody>
				<xsl:for-each select="soutenance">
					<xsl:sort select="@codeSoutenance"/>
					<tr>
						<td><xsl:value-of select="@codeSoutenance"/></td>
						<td><xsl:value-of select="date"/></td>
						<td><xsl:value-of select="lieu"/></td>
						<td><xsl:value-of select="notePresentation"/></td>
						<td><xsl:value-of select="noteRapport"/></td>
						<td><xsl:for-each select="jury/enseignant">
							<xsl:value-of select="."/><br/>
						</xsl:for-each></td>
						<!-- Retrouve les membres de jury de stage -->
							<xsl:variable name="varSoutenance" select="@codeSoutenance"/>
							<xsl:for-each select="/main/rapports/rapport[soutenance=$varSoutenance]">
								<xsl:variable name="varRapport" select="@codeRapport"/>
								<td><xsl:for-each select="/main/stages/stage[@rapport=$varRapport]/encadrant">
									<xsl:value-of select="."/><br/>
									</xsl:for-each>
								</td>
								<td><xsl:for-each select="/main/stages/stage[@rapport=$varRapport]/enseignant">
									<xsl:value-of select="."/><br/>
									</xsl:for-each>
								</td>
							</xsl:for-each>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
</xsl:stylesheet>
