# Enterprise Banking Data Lineage


## Customer Data Flow


SQL Server BankingERP

        |
        |
        v

Customer.Customer

        |
        |
        v

Fabric Bronze Lakehouse

Tables:

bronze_customer
bronze_customer_address
bronze_customer_kyc


        |
        |
        v


Silver Lakehouse


dim_customer
dim_customer_address


        |
        |
        v


Gold Lakehouse


customer360


        |
        |
        v


Power BI Customer Dashboard



## Data Quality Rules


CustomerID
- Not Null
- Unique


EmailAddress
- Valid Email Format


KYCStatus
- Approved Customers Only

