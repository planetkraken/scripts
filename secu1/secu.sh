#!/bin/bash

# Vérifier si le script est exécuté en tant que root
if [ "$EUID" -ne 0 ]; then
  echo "Veuillez exécuter ce script en tant que root."
  exit
fi

# Mettre à jour le système
echo "Mise à jour du système..."
apt-get update -y && apt-get upgrade -y

# Installer fail2ban pour protéger contre les attaques par bruteforce
echo "Installation de fail2ban..."
apt-get install fail2ban -y

# Créer un fichier de configuration pour fail2ban
echo "Configuration de fail2ban..."
cat <<EOT > /etc/fail2ban/jail.local
[DEFAULT]
# Temps de bannissement en secondes (ici 10 minutes)
bantime = 600
# Nombre de tentatives avant de bannir
maxretry = 5
# Activation de la protection SSH
[sshd]
enabled = true
# Activation de la protection Apache pour bruteforce
[apache-auth]
enabled = true
EOT

# Redémarrer fail2ban pour appliquer les modifications
echo "Redémarrage de fail2ban..."
systemctl restart fail2ban

# Configurer iptables pour se protéger contre les attaques DDoS
echo "Configuration d'iptables pour la protection contre les DDoS..."
iptables -A INPUT -p tcp --syn -m limit --limit 1/s -j ACCEPT
iptables -A INPUT -p tcp --syn -m limit --limit 50/s --limit-burst 100 -j ACCEPT
iptables -A INPUT -p tcp --syn -j DROP

# Limiter le nombre de connexions depuis une même IP
iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 20 -j REJECT
iptables -A INPUT -p tcp --dport 443 -m connlimit --connlimit-above 20 -j REJECT

# Activer UFW (pare-feu simple)
echo "Installation et configuration d'ufw..."
apt-get install ufw -y
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https

# Activer UFW
echo "Activation d'ufw..."
ufw enable

# Activer la surveillance du trafic avec iptables pour les logs
echo "Activation de la surveillance du trafic avec iptables..."
iptables -A INPUT -m limit --limit 5/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4

# Sauvegarder les règles iptables
echo "Sauvegarde des règles iptables..."
iptables-save > /etc/iptables/rules.v4

echo "Sécurisation du serveur terminée."