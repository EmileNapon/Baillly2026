🧠 QCM (20 questions) – Compréhension du code
🧩 Partie 1 : Classes de base

1. SecurityCheck représente :
A. Un utilisateur
B. Une vérification de sécurité
C. Un logement
D. Une API

2. ok dans SecurityCheck signifie :
A. Nom du document
B. Résultat de validation (true/false)
C. Date
D. Prix

3. label dans SecurityCheck sert à :
A. Stocker un nombre
B. Décrire la vérification
C. Gérer l’UI
D. Calculer un score

🧩 Partie 2 : Historique

4. HistoryEvent représente :
A. Une facture
B. Un événement passé du logement
C. Un utilisateur
D. Une image

5. date est de type :
A. int
B. double
C. String
D. bool

6. ok dans HistoryEvent permet :
A. Vérifier si l’événement est positif ou négatif
B. Calculer le prix
C. Afficher carte
D. Gérer GPS

🧩 Partie 3 : Classe principale Listing

7. Listing représente :
A. Un utilisateur
B. Une maison/logement
C. Une carte
D. Une API

8. id sert à :
A. Afficher texte
B. Identifier un logement unique
C. Calculer prix
D. Gérer GPS

9. quartier est :
A. Un nombre
B. Une position GPS
C. Une zone géographique
D. Une API

🧩 Partie 4 : Données géographiques

10. mapX et mapY représentent :
A. Prix
B. Coordonnées sur carte
C. Distance
D. Score

11. distTravail représente :
A. Prix transport
B. Distance maison → travail
C. Surface
D. Sécurité

🧩 Partie 5 : Données financières 🔥

12. loyer correspond à :
A. Coût transport
B. Prix mensuel du logement
C. Prix total
D. Caution

13. charges incluent :
A. Salaire
B. Eau + électricité + services
C. Distance
D. Carte

14. caution représente :
A. Paiement mensuel
B. Dépôt initial
C. Transport
D. Score

🧩 Partie 6 : Sécurité & confiance 🔐

15. verified signifie :
A. Maison disponible
B. Maison vérifiée
C. Maison chère
D. Maison occupée

16. trust est :
A. Distance
B. Score de confiance
C. Prix
D. GPS

17. litiges indique :
A. Nombre de pièces
B. Problèmes passés
C. Prix
D. Surface

🧩 Partie 7 : Listes complexes

18. securite est :
A. Une variable simple
B. Une liste de SecurityCheck
C. Une API
D. Un bool

19. history est :
A. Une liste de HistoryEvent
B. Une image
C. Un nombre
D. Une API

🧩 Partie 8 : Getters (très important 🔥)

20. totalMensuel fait quoi ?

int get totalMensuel => loyer + charges;

A. Multiplie
B. Additionne loyer + charges
C. Calcule distance
D. Rien

🔥 BONUS (niveau avancé)

21. totalAvecCarburant permet de :
A. Voir coût réel complet
B. Calculer surface
C. Gérer sécurité
D. Gérer API

22. categoryLetter retourne :
A. Prix
B. Lettre selon type logement
C. Distance
D. Score

⚠️ Question piège (très importante)

23. Pourquoi utiliser const Listing(...) ?
A. Pour accélérer
B. Pour rendre immuable
C. Pour afficher
D. Pour calculer

👉 Réponse clé :
➡️ Données fixes = sécurité + performance

🧠 Compréhension globale (ce que tu dois retenir)

👉 Ton code fait 3 choses essentielles :

1. Modélisation

Tu représentes un logement réel :

Maison = prix + localisation + sécurité + historique
2. Confiance 🔐
SecurityCheck + HistoryEvent + trust

👉 Tu combats les arnaques

3. Décision intelligente 🔥
totalMensuel
totalAvecCarburant

👉 Tu montres le vrai coût de vie