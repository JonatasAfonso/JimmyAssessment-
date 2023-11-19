[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=bcct-azfun-pipelines-analyzer&metric=alert_status&token=d6b8b0078e17be84cdff38b1dafcff0b0a1750c9)](https://sonarcloud.io/summary/new_code?id=bcct-azfun-pipelines-analyzer)

# Introduction 

As the demand grew to adapt the data capture to meet the specific requirements of the Architecture team's queries, the PowerBI Pipelines Analyzer solution was developed.

The primary objective is to gain visibility into the progress of Teams and projects by incorporating one or more widgets or charts into your dashboard. These customizable, highly configurable dashboards empower you and your teams to share information effectively, track progress and trends, and optimize workflow processes. With a focus on providing a more high-level analytical visibility, each team can tailor their dashboards to share information and monitor their progress effectively.


# High-level architecture

![Diagram showing the resources used in Pipeline Analyzer process.](./docs/img/diagram.png)

**Figure 1**. Pipeline Analyzer architecture diagram

| Step | Description |
| -------- | ------- |
| 1 | In each Pipeline execution, the API is requested, the payload and headers are validated and logged. |
| 2 | If http request match the expected contracts the function is triggered|
| 3 | Function is responsible to encapsulate data, validade fields and if they are correct, store them in SQLDatabase|
| 4 | Once stored in SQLDatabase, PowerBI can be used to query data|

**Table 1**. Pipeline Analyzer explanation

## Layers in PipelinesAnalyzer

When tackling complexity, it is important to have a domain model controlled by aggregate roots that make sure that all the invariants and rules related to that group of entities (aggregate) are performed through a single entry-point or gate, the aggregate root.

Figure bellow shows how a layered design is implemented in the NRT-PipelinesAnalyzer application.

![Diagram showing the layers in a domain-driven design microservice.](./docs/img/solutionStrucuture.png)

**Figure 4**. DDD layers explanation



## Projects folder structure

![General Project Folder Structure](./docs/img/folderStructure.png) 
**Figure 5**. General Project Folder Structure


| Folder     | Description |
| --------   | ------- |
| src        | The source code for the Application|
| docs       | Side documentation for the project, usually PDFs, PPTs and samples to support development tasks|
| terraform  | Following CI/CD best practices ARI is promoting IaC as part of it's core process |
| azuredevops| Following CI/CD best practices ARI is promoting provisioning pipelines and build-deploy pipelines |

**Table 3**. General Project Folder Structure


## Azure Pipeline Analyzer Interfaces

### CarInputDto
```json
{
    "Make": "Ford",
    "Model": "Fiesta"
}
```

### CarOutputDto
```json
{
    "Id":"C1",
    "Make": "Ford",
    "Model": "Fiesta"
}
```

# Additional Information

## Build and Test
This solution was developed using .NET Framework version 8 using the Minimal API Approach given the simplicity of definitio.

For local testing, it is recommended to use Visual Studio 2022+. However, since it is integrated into a Continuous Integration process in Azure DevOps, every commit made to the Develop or Main branches will automatically initiate the compilation process, run automated tests, perform static code analysis using SonarCloud, and then deploy to Azure Cloud using the predefined release pipeline.

![1-tracks.png](./docs/img/pipelines.png)
**Figure 6**. The Provision pipeline elements for the various teams. 

The pipeline is triggered by a commit to the Develop branch. The pipeline is responsible for provisioning the infrastructure in Azure Cloud, including the creation of the Azure Function App, the Azure SQL Database, and the Azure Storage Account. The pipeline also creates the Azure DevOps release pipeline, which is responsible for deploying the application to the Azure Function App.

For more detailed information, please consult the azure-pipelines.yml file.

## Naming convention and standards

Following the best practices in Cloud Adoption Framework (CAF), explained in https://learn.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming, the solution was developed using the following naming convention and standards:

"A good name for a resource helps you to quickly identify its type, its associated workload, its environment, and the Azure region where it runs. To do so, names should follow a consistent format—a naming convention—that is composed of important information about each resource. The information in the names ideally includes whatever you need to identify specific instances of resources. For example, a public IP address (PIP) for a production SharePoint workload in the West US region might be pip-sharepoint-prod-westus-001."

![Diagram 1: Components of an Azure resource name](./docs/img/resource-naming.png)
**Figure 7**. Components of an Azure resource name

