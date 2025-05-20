# Projet d'Infrastructure Réseau - BTS SIO SISR

## 📌 Présentation

Ce projet a pour objectif la conception, la mise en œuvre et la sécurisation complète d’une infrastructure réseau pour une entreprise fictive, dans le cadre de mon BTS SIO option SISR. Il inclut la configuration de serveurs, de services réseau essentiels, la mise en place d’une DMZ, la redondance des équipements, et la sécurisation globale du système.

## 🛠️ Technologies & outils utilisés

- **Proxmox VE** – Virtualisation des machines
- **Windows Server (AD, DNS, DHCP, GPO)** – Services principaux
- **Wireshark / Putty / TeamViewer / CCleaner** – Outils d’administration
- **Scripts PowerShell** – Automatisation des tâches (GPO, AD, etc.)

## 🧱 Architecture réseau

L’infrastructure comprend :

- routeurs
- firewalls (DMZ sécurisée)
- switches
- serveurs
- 1 routeur WiFi

## 📋 Ordre de mise en place

1. Câblage de l'infrastructure
2. Configuration des routeurs
3. Configuration des switchs
4. Configuration des VLAN
5. Configuration du routeur wifi
6. Création et configuration d'un container
7. Mise en place de SSH
8. Mise en place serveur DHCP
9. Routage statique inter-VLAN sur le LAN
10. Serveur AD
11. Serveur Web Privé avec espace de stockage (serveur de fichiers)
12. Serveur Web Public
13. Mise en place d’un serveur d’authentification RADIUS pour réseau WiFi
14. Mise en place d’ACL pour DMZ et règles d’accès réseau internes

## 🔐 Sécurité mise en place

- VLAN pour l'isolation des réseaux
- Règles firewall strictes
- DMZ pour héberger les services publics
- Sécurisation des accès utilisateurs (GPO, ACLs, scripts PowerShell)
- Redondance des routeurs pour assurer la haute disponibilité
- Surveillance réseau (logs, Wireshark)
