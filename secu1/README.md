
# Script bash serveur

Utilisation de Fail2ban, Iptables et UFW pour ce script.



## Features

- ### fail2ban
    Fail2Ban est un logiciel de prévention d'intrusion qui protège les serveurs contre les attaques de types brute-force. Il permet d'éditer une série de règles qui va permettre de bloquer automatiquement les connections anormales.
-  ### iptables
    1. Limite la fréquence des nouvelles connexions SYN pour éviter les attaques DDoS par SYN flood.
    2. Limite le nombre de connexions simultanées autorisées à partir d'une seule IP sur les ports HTTP et HTTPS pour éviter les attaques DDoS.
    3. Ajoute une règle pour consigner les tentatives de connexion bloquées dans les logs du système.
- ### ufw
    Pare-feu simplifié pour gérer les règles d'accès. Il bloque par défaut les connexions entrantes, sauf pour SSH, HTTP, et HTTPS.



## Installation

```bash
  cd votre-dossier
  https://github.com/planetkraken/security-server.git
```

Rendez exécutable le script
```bash
  chmod +x secu.sh
```

Executez le en tant qu'administrateur
```bash
  sudo ./secu.sh
```




