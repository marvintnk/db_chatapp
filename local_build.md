## 💻 Lokale Entwicklung

Dieser Abschnitt beschreibt, wie du das Projekt lokal aufsetzt, die Datenbank startest und die Umgebungsvariablen konfigurierst.

### 1. Voraussetzungen

- **Node.js** (Empfohlen: v18 LTS oder neuer)
- **Docker & Docker Compose** (für die lokale Datenbank)
    - *Alternativ: Eine andere lokal erreichbare MySQL-Datenbank*
- **Git**

### 2. Installation

Klone das Repository und installiere die Abhängigkeiten:

```
git clone <REPO-URL>
cd db_chatapp
npm install
```

### 3. Lokale Datenbank starten

Das Projekt benötigt eine MySQL-Datenbank. Diese kann einfach via Docker gestartet werden.
Hierfür existiert eine `docker-compose.yml` im Hauptverzeichnis, welche die Datenbank bereitstellt.

Starte die Datenbank mit:

```
docker compose up -d
```

### 4. Konfiguration (.env)

Erstelle eine `.env` Datei im Hauptverzeichnis des Projekts und füge die folgenden Umgebungsvariablen hinzu. Einige Variablen (für Azure) kannst du erst nach Schritt 4.1 und 4.2 setzen.

> **Wichtig:** Diese Datei enthält sensible Daten und darf **nicht** ins Git-Repository gepusht werden.

```
# --- App-Core ---
PORT=3000
ORIGIN=http://localhost:3000

# --- Azure OpenAI (Microsoft Foundry) ---
AZURE_OPENAI_API_KEY="..."
AZURE_OPENAI_API_VERSION="..." 
AZURE_OPENAI_API_ENDPOINT="..."
AZURE_OPENAI_API_MODEL_NAME="..."
AZURE_OPENAI_API_DEPLOYMENT="..."

# --- MySQL Datenbank (lokaler Docker) ---
AZURE_MYSQL_HOST=localhost
AZURE_MYSQL_PORT=3306
AZURE_MYSQL_USERNAME=app_user
AZURE_MYSQL_PASSWORD=DeinPasswort123!
AZURE_MYSQL_DATABASE_NAME=chatapp

# --- Unlock ---
UNLOCK="DeinGeheimesPasswort"

# --- Azure Speech Service (Optional) ---
AZURE_SPEECH_KEY="..."
AZURE_SPEECH_REGION="..."
```

#### 4.1 Azure OpenAI einrichten
1. Erstelle ein KI-Projekt unter [https://ai.azure.com](https://ai.azure.com).
2. Deploye ein Chat-Modell und trage folgende Werte in deine `.env` ein:
   - **AZURE_OPENAI_API_KEY**
   - **AZURE_OPENAI_API_VERSION** (z.B. "2024-02-01")
   - **AZURE_OPENAI_API_ENDPOINT**
   - **AZURE_OPENAI_API_DEPLOYMENT** 
   - **AZURE_OPENAI_API_MODEL_NAME**

#### 4.2 Azure Speech Service (Optional)
1. Öffne das [Azure Portal](https://portal.azure.com).
2. Erstelle einen **Speech Service**.
3. Trage **AZURE_SPEECH_KEY** und **AZURE_SPEECH_REGION** in deine `.env` ein.

### 5. Anwendung starten

Sobald die Datenbank läuft und die `.env` Datei konfiguriert ist, starte den Entwicklungsserver:

```
npm run dev
```

Die Anwendung ist nun unter `http://localhost:3000` erreichbar.
```
