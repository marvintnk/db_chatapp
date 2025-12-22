## 💻 Lokale Entwicklung

Dieser Abschnitt beschreibt, wie du das Projekt lokal aufsetzt, die Datenbank startest und die Umgebungsvariablen konfigurierst.

### 1. Voraussetzungen

- **Node.js** (Empfohlen: v18 LTS oder neuer)
- **Docker & Docker Compose** (für die lokale Datenbank)
    - *Alternativ: Eine andere lokal erreichbare MySQL-Datenbank*
- **Git**

### 2. Installation

Klone das Repository und installiere die Abhängigkeiten:

```bash
git clone <REPO-URL>
cd db_chatapp
npm install
```

### 3. Lokale Datenbank starten

Das Projekt benötigt eine MySQL-Datenbank. Diese kann einfach via Docker gestartet werden.
Hierfür existiert eine `docker-compose.yml` im Hauptverzeichnis, welche die Datenbank bereitstellt.

Starte die Datenbank mit:

```bash
docker compose up -d
```

### 4. Konfiguration (.env)

Erstelle eine `.env` Datei im Hauptverzeichnis des Projekts und füge die Umgebungsvariablen aus der `.env_example` hinzu.

#### 4.1 Azure OpenAI einrichten
1. Erstelle ein KI-Projekt unter [https://ai.azure.com](https://ai.azure.com).
2. Deploye ein Chat-Modell und trage folgende Werte in deine `.env` ein:
   - **AZURE_OPENAI_API_KEY**
   - **AZURE_OPENAI_API_VERSION**
   - **AZURE_OPENAI_API_ENDPOINT**
   - **AZURE_OPENAI_API_DEPLOYMENT** 
   - **AZURE_OPENAI_API_MODEL_NAME**

#### 4.2 Azure Speech Service (Optional)
1. Öffne das [Azure Portal](https://portal.azure.com).
2. Erstelle einen **Speech Service**.
3. Trage **AZURE_SPEECH_KEY** und **AZURE_SPEECH_REGION** in deine `.env` ein.

#### 4.3 Weitere Variablen
Setze die Variablen der Datenbank basierend auf den Werten in der `docker-compose.yml` und wähle ein beliebiges Unlock-Passwort.

### 5. Anwendung starten

Sobald die Datenbank läuft und die `.env` Datei konfiguriert ist, starte den Entwicklungsserver:

```bash
npm run dev
```

Die Anwendung ist nun unter `http://localhost:3000` erreichbar.
