# Superstore_Sales_Analysis
Interactive Power BI Executive Dashboard analyzing $2.3M in US Superstore sales data, focusing on profit margins, regional performance, and customer segmentation.
# Project Highlights
**Star Schema Architecture**: You have successfully transformed flat data into a professional star schema by creating dedicated dimension tables for Customers, Products, Locations, and Shipping Modes.

**Advanced SQL Implementation**: Your appendix features a complete SQL script for database setup, automated date key generation, and complex joins to populate the FactSales table.

**Strategic Recommendations**: You’ve identified critical business interventions, such as optimizing discounting practices for low-return categories and using shipping speed as a loyalty driver for your "Champions" customer segment.

**Performance Analysis**: The project highlights regional disparities, specifically suggesting that successful strategies from the West region be applied to the Central region and loss-making states like Texas and Illinois.


# The Story of the Data: From Raw Chaos to Executive Clarity

1. **The Challenge: A Sea of Information**
The project began with a "flat" dataset containing over 9,000 rows of raw transaction data from the US Superstore. While rich in detail, the data was unstructured, making it difficult for leadership to

quickly answer critical questions like Which regions are bleeding profit?" or "How do our most loyal customers prefer to ship?

2. **The Transformation: Engineering the Star Schema**
   
To turn this raw data into a high-performance engine, I moved beyond simple spreadsheets and engineered a Star Schema in SQL Server:

**The Hub (Fact Table)**: I centralized all measurable metrics—Sales, Profit, Quantity, and Discounts—into a single FactSales table.

**The Spokes (Dimension Tables)**: I built specialized tables for Customers, Products, Locations, and Shipping, allowing for lightning-fast filtering and complex multi-dimensional analysis.

3. **The Discovery: Uncovering Hidden Truths**

With the new architecture in place, the data began to tell a clear story:

**The Profit Leak**: I discovered that aggressive discounting in categories like Binders and Furniture was actually eroding the bottom line in states like Texas and Illinois.

**The Golden Segments**: My analysis identified a segment of "Champions"—loyal, high-value customers who could be further incentivized through optimized shipping perks.

**Regional Excellence**: The West region emerged as the "playbook" for success, maintaining high margins through superior product mix and pricing discipline.

4.**The Impact: Data-Driven Recommendations**

**This isn't just a dashboard**; it's a strategic roadmap. My work provides direct recommendations to:

**Tighten discount controls** on low-return items.

**Target loss-making states** with urgent pricing interventions.

**Nurture "Potential" customers** into "Champions" using data-backed loyalty drivers.

# The Technical Stack: Enterprise-Grade Data Engineering

While the dashboard provides the final insights, the engine behind it was built using a robust, containerized data pipeline:

**Database Engine**: SQL Server managed via Azure Data Studio for a cross-platform, modern development experience.

**Infrastructure**: Deployed the SQL environment using Docker Containers, ensuring a consistent, scalable, and isolated development environment that matches professional production standards.

**Cloud Integration**: Leveraged Azure services to host and manage data assets, providing a foundation for cloud-scale analytics.

**Modeling**: Transformed the raw dataset into a Star Schema architecture using a complex SQL script to create a high-performance Data Warehouse.

**Visualization**: Built a fully interactive Executive Overview in Power BI, utilizing DAX for advanced measures and profit analysis.

## 🛠️ Technical Stack
* **Database:** SQL Server hosted in a **Docker Container** for isolated development.
* **Tools:** **Azure Data Studio** for SQL development and **Power BI** for visualization.
* **Architecture:** Custom-built **Star Schema** with Fact and Dimension tables.
