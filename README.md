[![Infra Bootstrap](https://github.com/marvintnk/db_chatapp/actions/workflows/bootstrap.yml/badge.svg)](https://github.com/marvintnk/db_chatapp/actions/workflows/bootstrap.yml)
[![Deploy to AWS](https://github.com/marvintnk/db_chatapp/actions/workflows/main.yml/badge.svg?branch=master)](https://github.com/marvintnk/db_chatapp/actions/workflows/main.yml)
[![Destroy Infrastructure](https://github.com/marvintnk/db_chatapp/actions/workflows/destroy.yml/badge.svg)](https://github.com/marvintnk/db_chatapp/actions/workflows/destroy.yml)

# DB Chat Application

## Projektbeschreibung & Kontext

Diese Webanwendung ermöglicht die administrative Verwaltung von Benutzerkonten über einen dialogbasierten **Chatbot**. Sie ersetzt komplexe SQL-Abfragen oder Admin-Oberflächen durch natürliche Sprache.

**Kernfunktionen:**
*   **Geführte Prozesse:** Schrittweise Anleitung durch administrative Aufgaben (z. B. User-Anlage).
*   **Validierung:** Direkte Überprüfung von Eingaben im Chat-Dialog.
*   **Speech-to-Text:** Optionale Spracheingabe für Barrierefreiheit.
*   **Reporting:** Admin-Panel für Statistiken und PDF-Exporte.

**Kontext:**
Dies ist ein Fork des Projekts [azure-bot](https://github.com/adrku24/azure-bot/). Es wurde für das Master-Modul „Cloud Computing“ technisch neu ausgerichtet:
*   **Zielplattform:** Migration von Azure zu **AWS**.
*   **Infrastructure as Code:** Vollständige Automatisierung mit **Terraform**.

---

## Architektur

Die Architektur gliedert sich in die logische Service-Struktur und deren physisches Mapping auf AWS-Ressourcen.

### 1. Software-Services

Die Anwendungslogik ist in fünf fachliche Services unterteilt:

*   **Chat Service:** Interface zum LLM. Verwaltet den Nachrichtenstrom, erkennt JSON-Antworten zur Prozesssteuerung und nutzt RAG (Retrieval Augmented Generation) für Abfragen auf internen Daten.
*   **Transcription Service:** Wandelt Audio-Input via Speech-to-Text in Text um und übergibt diesen an den Chat.
*   **User Service:** Abstrahiert Datenbankoperationen. Verwaltet normalisierte Entitäten (`User`, `Address`, `Phone`).
*   **Unlock Service (Auth):** Sichert den Zugriff. Validiert das Global-Passwort und verwaltet Session-Cookies (Access Tokens).
*   **Statistik Service:** Aggregiert Nutzungsdaten aus LLM-Antworten für das Admin-Dashboard.

### 2. AWS-Infrastruktur

Das System läuft als containerisierte Anwendung in einer VPC-Umgebung, verwaltet durch Terraform.

![AWS Architekturdiagramm](architecture.jpg)

| Software-Komponente | AWS Ressource | Details |
| :--- | :--- | :--- |
| **Applikation** | **ECS Fargate** | Alle Services laufen in einem SvelteKit-Container. Serverless-Betrieb im privaten Subnetz. |
| **Datenbank** | **RDS (MySQL)** | Persistente Speicherung von User- und Statistikdaten im privaten Subnetz. |
| **Routing** | **ALB** | Application Load Balancer im öffentlichen Subnetz terminiert HTTPS und leitet Traffic weiter. |
| **Artefakte** | **ECR** | Speicherung und Versionierung der Docker-Images. |

---

## Software Delivery (CI/CD)

Jede Code-Änderung durchläuft eine automatisierte GitHub Actions Pipeline (`main.yml`).

| Schritt | Aktion | Beschreibung |
| :--- | :--- | :--- |
| **1. Test** | `npm run test` | Ausführung von Unit- und funktionalen Tests sowie SonarCloud-Analyse. |
| **2. Security** | `CodeQL` | Statische Analyse auf Sicherheitslücken im JavaScript-Code. |
| **3. Build** | `docker build` | Erstellung des Docker-Images und Push in die AWS ECR Registry (`:latest`). |
| **4. Deploy** | `terraform apply` | Update der Infrastruktur (ECS Task Definition) ohne Downtime. |

Zusätzliche Workflows:
*   `bootstrap.yml`: Einmalige Initialisierung von Terraform State (S3) und Lock-Table (DynamoDB).
*   `destroy.yml`: Vollständiger Abbau der AWS-Ressourcen (erfordert manuelle Bestätigung).

---

## Lokale Entwicklung

Die Anleitung zur lokalen Einrichtung (Tools, Umgebungsvariablen, Build) befindet sich im separaten Dokument.

➡️ **Siehe:** [Lokale Entwicklung](documentation/local_build.md)

---

## Deployment auf AWS

Die Infrastruktur wird initial einmalig eingerichtet, danach erfolgt das Deployment über die Pipeline.

➡️ **Details siehe:** [Deployment Anleitung](documentation/deployment.md)

---

## Lizenz
Akademischer Prototyp für Lehrzwecke. Keine Gewährleistung auf Sicherheit oder Funktion im Produktivbetrieb.
