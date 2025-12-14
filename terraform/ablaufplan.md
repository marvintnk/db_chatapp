Grober Ablaufplan für deine AWS-SvelteKit-Chatbot-App mit Terraform
1. Infrastruktur vorbereiten

Definiere dein eigenes VPC mit Terraform

Erstelle Public und Private Subnetze

IPv6-Integration optional hinzufügen

Richte notwendige Sicherheitsgruppen und Routing-Tabellen ein

ecr

2. Datenbank einrichten

Wähle einen AWS-Datenbankdienst (z.B. Amazon RDS für relationale DB oder DynamoDB)

Erstelle die Datenbankressource mit Terraform im privaten Subnetz

Richte Zugang und IAM-Rollen/Sicherheitsgruppen ein

4. Storage für statische Inhalte einrichten --> Da alles im Docker glaube unwichtig

Erstelle einen S3-Bucket für deine statischen Assets (z.B. Frontend-Build)

Konfiguriere Berechtigungen (z.B. über Bucket Policy oder CloudFront)

5. Compute-Ressourcen provisionieren

Erstelle eine  ECS Fargate Aufgabe, um die SvelteKit-App zu hosten (oder AWS Lambda bei Serverless-Ansatz)

Diese Instanz zieht die Daten aus der Datenbank und integriert den Chatbot

Definiere Umweltvariablen, z.B. zum Verbinden mit der Datenbank und Keys

6. alb
7. 


dann worklow

dann ecr vorher erstellen, wir brauchen ein bootstrap workflow
da alle deployments den state kenne müssen, remote backend erstellen
