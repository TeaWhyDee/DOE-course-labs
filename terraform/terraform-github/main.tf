terraform {
  required_version = "~> 1.5.0"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.token # or `GITHUB_TOKEN`
}

resource "github_repository" "DOE-course-labs" {
  name          = "DOE-course-labs"
  description   = "Updated description from terraform"
  has_wiki      = true
  has_projects  = true
  has_downloads = true
  # (resource arguments)
}

#Create and initialise a public GitHub Repository with MIT license and a Visual Studio .gitignore file (incl. issues and wiki)
resource "github_repository" "repo" {
  name               = "inno-DOE-terraform-repo-2023"
  description        = "My awesome codebase"
  visibility         = "public"
  has_issues         = true
  has_wiki           = true
  auto_init          = true
  license_template   = "mit"
  gitignore_template = "VisualStudio"
}

#Set default branch 'master'
resource "github_branch_default" "master" {
  repository = github_repository.repo.name
  branch     = "main"
}

#Create branch protection rule to protect the default branch. (Use "github_branch_protection_v3" resource for Organisation rules)
resource "github_branch_protection" "default" {
  repository_id                   = github_repository.repo.id
  pattern                         = github_branch_default.master.branch
  require_conversation_resolution = true
  enforce_admins                  = true

  required_pull_request_reviews {
    required_approving_review_count = 1
  }
}
