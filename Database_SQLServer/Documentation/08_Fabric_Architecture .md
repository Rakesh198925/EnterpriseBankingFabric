# Enterprise Banking Fabric Architecture


## Source Layer


Microsoft SQL Server 2019


Database:

BankingERP


Schemas:

Master
Customer
Account
Loan
Card
Transactions



## Ingestion Layer


Microsoft Fabric Data Factory


Pipeline:

SQL Server
      |
      |
      v

Bronze Lakehouse



## Bronze Layer


Purpose:

Store raw data


Format:

Delta Tables


Example:

bronze_customer

bronze_account

bronze_transaction



## Silver Layer


Purpose:

Clean and transform data


Activities:

- Data cleansing
- Deduplication
- SCD Type 2
- Data validation


Tables:

dim_customer

dim_account

fact_transaction



## Gold Layer


Business Analytics


Customer 360


Measures:

- Total Accounts
- Loan Exposure
- Transaction Amount
- Risk Category
- Customer Value



## Security


Implemented:

- Microsoft Entra ID
- Workspace Roles
- Row Level Security
- Data Governance


## CI/CD


Source Control:

GitHub


Deployment:

Dev
 |
Test
 |
Production



## Monitoring


Tools:

Fabric Monitoring Hub

Data Quality Checks

Microsoft Purview
