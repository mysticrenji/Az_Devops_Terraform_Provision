provider "azuredevops" {
  version = ">= 0.0.1"
  org_service_url= "https://dev.azure.com/Azrockstar/" #export AZDO_ORG_SERVICE_URL
  personal_access_token= "6bebkb2ori6hlz2gljoq7opmiz7kudjssmaaks44pzwdiip5loya" #export AZDO_PERSONAL_ACCESS_TOKEN
}

resource "azuredevops_project" "project" {
  project_name = "Az_Devops_Terraform "
  description  = "Project created using terraform"
  visibility         = "private"
  version_control    = "Git"
  work_item_template = "Agile"
}

resource "azuredevops_git_repository" "repository" {
  project_id = azuredevops_project.project.id
  name       = "Terraform-Created-Repo"
  initialization {
    init_type = "Clean"
  }
}

resource "azuredevops_build_definition" "build_definition" {
  project_id = azuredevops_project.project.id
  name       = "Terraform-Created-Pipeline"
  path       = "\\"

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.repository.id
    branch_name = azuredevops_git_repository.repository.default_branch
    yml_path    = "azure-pipelines.yml"
  }
}

# dockerhub registry service connection
resource "azuredevops_serviceendpoint_dockerregistry" "dockerhubregistry" {
	project_id             = azuredevops_project.project.id
	service_endpoint_name  = "Terraform-Created-DockerHub"

    docker_username        = "mysticrenji" # export AZDO_DOCKERREGISTRY_SERVICE_CONNECTION_USERNAME 
    docker_email           = "mysticrenji@gmail.com" # export AZDO_DOCKERREGISTRY_SERVICE_CONNECTION_EMAIL
    docker_password        = "Sayonara!1"  # export AZDO_DOCKERREGISTRY_SERVICE_CONNECTION_PASSWORD
    registry_type          = "DockerHub"
}

