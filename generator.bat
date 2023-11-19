
cls

echo 'Setting variables'
SET ClientName=Jimmy
SET ProjectName=CarReservation
SET ResourceName=API


@REM |Blank for latest version |-f net5.0 |-f net6.0 |-f net7.0 |-f net8.0
@REM SET FrameworkVersion=-f net5.0
SET FrameworkVersion=-f net8.0

@REM |console |webapi |webapp |blazor |razor
SET ApplicationType=webapi

@REM |Blank for mstest |mstest |xunit |nunit
SET TestsFramework=xunit


SET AddDatabaseFeatures=0
SET AddSQLServer=0
SET SQLite=0
SET AddUnitTests=1
SET CodeCoverage=1
SET YamlGenerator=0


rem Structure preparation
echo 'Step 1 - Solution Preparation'
SET SolutionName=%ClientName%_%ProjectName%_%ResourceName%
md  /q terraform
echo '# Terraform main flow' >> terraform\main.tf
echo '# Terraform variables' >> terraform\variables.tf
echo '# Terraform output' >> terraform\outputs.tf

md /q azuredevops
echo '# Resource Provisioning' >> azuredevops\provision.yml
echo '# Build and Deploy' >> azuredevops\build_deploy.yml

md /q docs
echo '# Documentation Folder' >> docs\.boilerplate

rmdir /s src
md src
md src
cd src
dotnet new sln -n %SolutionName%

rem Structure preparation
echo 'Step 2 - Folder Creation'

echo 'Step 2.1 - Creating application folder and resources'
echo '##################################################################################################'
SET ApplicationFolder="1 - Application"
SET ApplicationFolderDescription=Application layer: responsible for the main project, because that is where the API drivers and Infrastructures will be developed. It has the function of receiving all requests and directing them to some Infrastructure to perform a certain action
md %ApplicationFolder%
echo %ApplicationFolderDescription% >> %ApplicationFolder%\readme.md
dotnet new %ApplicationType% %FrameworkVersion% -n %ProjectName%.Application -o %ApplicationFolder%\%ProjectName%.Application
dotnet sln add %ApplicationFolder%\%ProjectName%.Application

IF %AddUnitTests% EQU 1 (
    echo 'Step 2.1.1 - Adding XUnit Test Project'
    dotnet new %TestsFramework% %FrameworkVersion% -n %ProjectName%.Application.Tests -o %ApplicationFolder%\%ProjectName%.Application.Tests
    dotnet sln add %ApplicationFolder%\%ProjectName%.Application.Tests
    dotnet add %ApplicationFolder%\%ProjectName%.Application.Tests reference %ApplicationFolder%\%ProjectName%.Application
)


echo 'Step 2.2 - Creating Domain folder and resources'
echo '##################################################################################################'
SET DomainFolder="2 - Domain"
SET DomainFolderDescription=Domain layer: responsible for implementing classes/models, which will be mapped to the database, in addition to obtaining the declarations of interfaces, constants, DTOs (Data Transfer Object) and enums
md %DomainFolder%
echo %DomainFolderDescription% >> %DomainFolder%\readme.md
dotnet new classlib %FrameworkVersion% -n %ProjectName%.Domain -o %DomainFolder%\%ProjectName%.Domain
dotnet sln add %DomainFolder%\%ProjectName%.Domain

IF %AddUnitTests% EQU 1 (
    echo 'Step 2.2.1 - Adding XUnit Test Project'
    dotnet new %TestsFramework% %FrameworkVersion% -n %ProjectName%.Domain.Tests -o %DomainFolder%\%ProjectName%.Domain.Tests
    dotnet sln add %DomainFolder%\%ProjectName%.Domain.Tests
    dotnet add %DomainFolder%\%ProjectName%.Domain.Tests reference %DomainFolder%\%ProjectName%.Domain
)


echo 'Step 2.3 - Creating Service folder and resources'
echo '##################################################################################################'
SET ServiceFolder="3 - Service"
SET ServiceFolderDescription=Service layer: The Service layer contains the implementation of the application services. The service layer may also contain additional implementations of domain interfaces, if the implementations provided by the infrastructure layer are not sufficient.
md %ServiceFolder%
echo %ServiceFolderDescription% >> %ServiceFolder%\readme.md
dotnet new classlib -n %ProjectName%.Service -o %ServiceFolder%\%ProjectName%.Service
dotnet sln add %ServiceFolder%\%ProjectName%.Service

IF %AddUnitTests% EQU 1 (
    echo 'Step 2.3.1 - Adding XUnit Test Project'
    dotnet new %TestsFramework% %FrameworkVersion% -n %ProjectName%.Service.Tests -o %ServiceFolder%\%ProjectName%.Service.Tests
    dotnet sln add %ServiceFolder%\%ProjectName%.Service.Tests
    dotnet add %ServiceFolder%\%ProjectName%.Service.Tests reference %ServiceFolder%\%ProjectName%.Service
)


echo 'Step 2.4 - Creating Infrastructure folder and resources'
echo '##################################################################################################'
SET InfrastructureFolder="4 - Infrastructure"
SET InfrastructureFolderDescription=Infrastructure layer: it would be the 'heart' of the project, because it is in it that all business rules and validations are done, before the data persists in the database
md %InfrastructureFolder%
echo %InfrastructureFolderDescription% >> %InfrastructureFolder%\readme.md
dotnet new classlib -n %ProjectName%.Infrastructure -o %InfrastructureFolder%\%ProjectName%.Infrastructure
dotnet sln add %InfrastructureFolder%\%ProjectName%.Infrastructure

IF %AddUnitTests% EQU 1 (
    echo 'Step 2.4.1 - Adding XUnit Test Project'
    dotnet new %TestsFramework% %FrameworkVersion% -n %ProjectName%.Infrastructure.Tests -o %InfrastructureFolder%\%ProjectName%.Infrastructure.Tests
    dotnet sln add %InfrastructureFolder%\%ProjectName%.Infrastructure.Tests
    dotnet add %InfrastructureFolder%\%ProjectName%.Infrastructure.Tests reference %InfrastructureFolder%\%ProjectName%.Infrastructure
)


IF %AddDatabaseFeatures% EQU 1 (
    echo 'Step 2.4.2 - Adding Entity Framework Features'

    dotnet tool install --global dotnet-ef
    dotnet add %InfrastructureFolder%\%ProjectName%.Infrastructure package Microsoft.EntityFrameworkCore
    dotnet add %InfrastructureFolder%\%ProjectName%.Infrastructure package Microsoft.EntityFrameworkCore.Design
    dotnet add %InfrastructureFolder%\%ProjectName%.Infrastructure package Microsoft.EntityFrameworkCore.Tools

    IF %AddSQLServer% EQU 1 (
        dotnet add %InfrastructureFolder%\%ProjectName%.Infrastructure package Microsoft.EntityFrameworkCore.SqlServer
    )

    IF %AddSQLServer% EQU 1 (
        dotnet add %InfrastructureFolder%\%ProjectName%.Infrastructure package Microsoft.EntityFrameworkCore.Sqlite
    )
)



echo 'Step 3 - Project Referencing'
echo '##################################################################################################'
rem Project Referencing
rem ApplicationLayer: Infrastructure and Domain
dotnet add %ApplicationFolder%\%ProjectName%.Application reference %DomainFolder%\%ProjectName%.Domain
dotnet add %ApplicationFolder%\%ProjectName%.Application reference %InfrastructureFolder%\%ProjectName%.Infrastructure
dotnet add %ApplicationFolder%\%ProjectName%.Application reference %ServiceFolder%\%ProjectName%.Service
rem InfrastructureLayer: Domain and Infrastructure
dotnet add %InfrastructureFolder%\%ProjectName%.Infrastructure reference %DomainFolder%\%ProjectName%.Domain
dotnet add %ServiceFolder%\%ProjectName%.Service reference %DomainFolder%\%ProjectName%.Domain
dotnet add %ServiceFolder%\%ProjectName%.Service reference %InfrastructureFolder%\%ProjectName%.Infrastructure


IF %CodeCoverage% EQU 1 (
    dotnet tool install --global coverlet.console
    dotnet test %SolutionName%.sln --collect:"XPlat Code Coverage"
)

IF %YamlGenerator% EQU 1 (
    SET YamlDefinition=dotnet restore dotnet build dotnet test
    echo %YamlDefinition% >> %SolutionName%_CICD.yaml
)

cd ..
echo 'Solution Generated successfully'
