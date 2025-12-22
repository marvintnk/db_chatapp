## Deployment auf AWS


### 1. Voraussetzungen

*   AWS Account & IAM User (Rechte: ECR, ECS, S3, RDS, IAM, CloudWatch)
*   GitHub Repository mit aktiviertem GitHub Actions
*   Azure Account (für OpenAI & Speech Services)
*   GitHub Environment **`default`** (Settings → Environments → New environment)

---

### 2. AWS Zugangsdaten in GitHub hinterlegen

In **GitHub → Settings → Environments → default**:

**Secrets anlegen:**
*   `AWS_ACCESS_KEY_ID`
*   `AWS_SECRET_ACCESS_KEY`

**Variable anlegen:**
*   `AWS_REGION` (z.B. `eu-central-1`)

---

### 3. Infrastruktur initialisieren (Bootstrap)

Erstellt einmalig das ECR Repository sowie S3-Bucket und DynamoDB-Tabelle für den Terraform-State.

#### 3.1 Variablen setzen
In **Environment `default`** folgende Variablen definieren (Werte frei wählbar, müssen global eindeutig sein):
*   `TF_STATE_S3_BUCKET` (z. B. `my-project-tf-state`)
*   `TF_STATE_DYNAMODB_TABLE` (z. B. `my-project-tf-locks`)

#### 3.2 Workflow starten
1.  Gehe zu **Actions → Infra Bootstrap**.
2.  Klicke **Run workflow**.

#### 3.3 ECR-URL übernehmen
Nach Abschluss des Workflows:
1.  Öffne den Run-Log → Schritt **Terraform Outputs**.
2.  Kopiere die URL (z.B. `123456.dkr.ecr.eu-central-1.amazonaws.com/repo`).
3.  Erstelle im **Environment `default`** die Variable:
    *   `AWS_ECR_REPOSITORY` mit dem kopierten Wert.

---

### 4. Externe Services konfigurieren (Azure)

#### 4.1 KI (Azure OpenAI)
Erstelle ein Projekt im [Azure AI Studio](https://ai.azure.com) und deploye ein Modell (z.B. GPT-4o).
**Benötigte Werte:**
*   API Key & Endpoint
*   Deployment-Name & Modell-Name

#### 4.2 Speech-to-Text (Optional)
Erstelle eine "Speech Service" Ressource im [Azure Portal](https://portal.azure.com).
**Benötigte Werte:**
*   Key & Region

---

### 5. Anwendung deployen (Main Workflow)

Konfiguriere alle restlichen Umgebungsvariablen in GitHub, bevor du den Main-Workflow startest.

#### Übersicht aller Variablen & Secrets (Environment `default`)

| Name | Typ | Beschreibung |
| :--- | :--- | :--- |
| **TF_VAR_AZURE_OPENAI_API_KEY** | Secret | OpenAI API Key |
| `TF_VAR_AZURE_OPENAI_API_ENDPOINT` | Variable | OpenAI Endpoint URL |
| `TF_VAR_AZURE_OPENAI_API_DEPLOYMENT` | Variable | Name des Deployments |
| `TF_VAR_AZURE_OPENAI_API_MODEL_NAME` | Variable | Name des Modells |
| **TF_VAR_DB_PASSWORD** | Secret | Datenbank-Passwort (frei wählbar) |
| `TF_VAR_DB_NAME` | Variable | Name der DB (z.B. `chatapp`) |
| **TF_VAR_UNLOCK_PASSWORD** | Secret | Passwort für App-Login |
| **TF_VAR_AZURE_SPEECH_KEY** | Secret | (Optional) Speech Service Key |
| `TF_VAR_AZURE_SPEECH_REGION` | Variable | (Optional) Speech Region |

#### Deployment starten
Der Workflow **Deploy to AWS** (`main.yml`) startet automatisch bei Push auf `master` oder kann manuell unter **Actions** getriggert werden.

**Ablauf:**
1.  **Test & Scan:** SonarCloud, CodeQL, Unit- & Functional-Tests.
2.  **Build:** Docker-Image bauen & push zu ECR.
3.  **Deploy:** Terraform aktualisiert ECS/RDS.

---

### 6. Ressourcen löschen (Destroy)

Zum Entfernen der AWS-Ressourcen (Kostenstopp):

1.  Gehe zu **Actions → Destroy Infrastructure**.
2.  Klicke **Run workflow**.
3.  Eingabe: `DELETE` (Sicherheitsbestätigung).

> **Hinweis:** S3-State-Bucket und ECR-Repository (aus Bootstrap) bleiben erhalten, um Re-Deployments zu ermöglichen.
