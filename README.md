# AWS Chatbot – Dokumentation

## Installationsanleitung (AWS)

Diese Anleitung beschreibt die Bereitstellung der Anwendung auf **AWS** mithilfe von **GitHub Actions**.  
Die Infrastruktur wird über einen **Bootstrap-Workflow** initial erstellt und anschließend über einen **Main-Workflow** deployed.

---

## 1. Voraussetzungen

- AWS Account
- GitHub Repository mit der Anwendung
- AWS IAM User mit ausreichenden Rechten für:
  - ECR
  - ECS / EC2 (je nach Architektur)
  - S3
  - IAM
  - CloudWatch
- GitHub Actions aktiviert
- GitHub Environment **`default`** erstellt (für alle Variablen und Secrets)

---

## 2. AWS Zugangsdaten in GitHub hinterlegen

In GitHub unter:

**Settings → Environments → default**

### Secrets

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
```

### Variablen

```
AWS_REGION
```

---

## 3. Bootstrap-Phase (Infrastruktur initialisieren)

In der **Bootstrap-Phase** wird die grundlegende AWS-Infrastruktur erstellt, darunter:

- ECR Repository
- Remote Backend (S3 + DynamoDB) für den Terraform-State

### 3.1 Bootstrap-Variablen setzen

In GitHub unter:

**Settings → Environments → default**

folgende **Variablen** anlegen und mit beliebigen Werten setzen:

```
TF_STATE_S3_BUCKET           (z. B. tf-state-locks)
TF_STATE_DYNAMODB_TABLE      (z. B. chatapp-tfstate-locks)
```

---

### 3.2 Bootstrap-Workflow ausführen

Der Bootstrap-Workflow wird **einmalig** ausgeführt.

In GitHub unter:

**Actions → Infra Bootstrap → Run workflow**

---

### 3.3 Output aus Bootstrap übernehmen

Nach erfolgreichem Durchlauf des Bootstrap-Workflows:

1. Öffnen Sie den entsprechenden Workflow Run
2. Kopieren Sie im Schritt **Terraform Outputs** die ausgegebene **ECR Repository URL**, z. B.:

```
123456789012.dkr.ecr.eu-central-1.amazonaws.com/aws-chatbot
```

3. Hinterlegen Sie diese als **Variable** im Environment `default`:

```
AWS_ECR_REPOSITORY
```

---

## 4. Externe Services (Azure)

### 4.1 KI (Azure OpenAI)

- Erstellen Sie ein KI-Projekt unter  
  https://ai.azure.com
- Deployen Sie ein beliebiges Chat-Modell
- Notieren Sie sich:
  - API_KEY
  - API_VERSION
  - API_ENDPOINT
  - MODEL_NAME
  - API_DEPLOYMENT

---

### 4.2 Speech-to-Text (Azure Speech Service)

- Öffnen Sie https://portal.azure.com
- Erstellen Sie einen **Speech Service**
- Notieren Sie sich:
  - SPEECH_KEY
  - SPEECH_REGION

---

## 5. Main-Phase (Deployment der Anwendung)

Nach erfolgreicher Bootstrap-Phase kann der **Main-Workflow** ausgeführt werden:

```
.github/workflows/main.yml
```

Der Workflow übernimmt:
- Build des Docker Images
- Push des Images in das ECR Repository
- Deployment der Anwendung auf AWS

---

## 6. Konfiguration der Anwendung

Die Konfiguration erfolgt über **GitHub Secrets** und **GitHub Variablen** im Environment **`default`**.

### 6.1 KI-Konfiguration (Azure OpenAI)

#### Variablen

```
TF_VAR_AZURE_OPENAI_API_MODEL_NAME
TF_VAR_AZURE_OPENAI_API_ENDPOINT
TF_VAR_AZURE_OPENAI_API_DEPLOYMENT
```

#### Secrets

```
TF_VAR_AZURE_OPENAI_API_KEY
```

---

### 6.2 Datenbank (Amazon RDS MySQL)

#### Variablen

```
TF_VAR_DB_NAME
```

#### Secrets

```
TF_VAR_DB_PASSWORD
```

---

### 6.3 Text-to-Speech (optional, Azure Speech)

#### Variablen

```
TF_VAR_AZURE_SPEECH_REGION
```

#### Secrets

```
TF_VAR_AZURE_SPEECH_KEY
```

---

### 6.4 Zugriffsschutz

#### Secret

```
TF_VAR_UNLOCK_PASSWORD
```

Eigenes Passwort zum Freischalten der Weboberfläche der Chat-Anwendung.

---

## 7. Übersicht aller zu setzenden GitHub Variablen und Secrets

| Kategorie                     | Name                                    | Typ       | Beschreibung |
|--------------------------------|----------------------------------------|-----------|-------------|
| AWS Zugangsdaten               | AWS_ACCESS_KEY_ID                       | Secret    | AWS IAM Access Key |
|                                | AWS_SECRET_ACCESS_KEY                   | Secret    | AWS IAM Secret Key |
| AWS Region                     | AWS_REGION                              | Variable  | AWS Region, z.B. eu-central-1 |
| Remote Backend                 | TF_STATE_S3_BUCKET                      | Variable  | S3 Bucket für Terraform State |
|                                | TF_STATE_DYNAMODB_TABLE                 | Variable  | DynamoDB Table für Terraform Locks |
| ECR Repository                 | AWS_ECR_REPOSITORY                       | Variable  | ECR Repository URL aus Bootstrap |
| Azure OpenAI                   | TF_VAR_AZURE_OPENAI_API_MODEL_NAME      | Variable  | Name des KI-Modells |
|                                | TF_VAR_AZURE_OPENAI_API_ENDPOINT        | Variable  | Endpoint der KI-API |
|                                | TF_VAR_AZURE_OPENAI_API_DEPLOYMENT      | Variable  | Deployment-Name der KI |
|                                | TF_VAR_AZURE_OPENAI_API_KEY             | Secret    | API Key für die KI |
| Datenbank (RDS MySQL)          | TF_VAR_DB_NAME                           | Variable  | Name der Datenbank |
|                                | TF_VAR_DB_PASSWORD                       | Secret    | Passwort für die Datenbank |
| Azure Speech (optional)        | TF_VAR_AZURE_SPEECH_REGION              | Variable  | Region des Speech Service |
|                                | TF_VAR_AZURE_SPEECH_KEY                 | Secret    | API Key für Speech Service |
| Zugriffsschutz                 | TF_VAR_UNLOCK_PASSWORD                   | Secret    | Passwort für Chat-App Weboberfläche |

---

## 8. CI/CD Ablaufübersicht

```
1. Bootstrap Workflow
   └── Erstellt Infrastruktur
   └── Initialisiert Remote Backend
   └── Erstellt ECR Repository

2. Variable setzen
   └── AWS_ECR_REPOSITORY aus Bootstrap Output übernehmen

3. Main Workflow
   └── Build Docker Image
   └── Push nach ECR
   └── Deployment auf AWS
```

---

## 9. Testphasen

Im Rahmen der GitHub Actions Pipeline sind zwei Testphasen integriert:

### Testphase 1 – Unit Tests
- Ausführung vor dem Deployment
- Test einzelner Funktionen und Module

### Testphase 2 – Integration Test
- Ausführung nach dem Deployment
- Prüfung der Erreichbarkeit der Anwendung

---

## 10. Ergebnis

Nach erfolgreichem Durchlauf beider Workflows:

- Die Anwendung läuft vollständig auf **AWS**
- KI- und Text-to-Speech-Funktionalitäten werden über **Azure Services** bereitgestellt
- Deployment erfolgt automatisiert über **GitHub Actions**
