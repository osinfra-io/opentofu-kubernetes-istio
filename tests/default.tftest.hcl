# Terraform Tests
# https://developer.hashicorp.com/terraform/language/tests

# Terraform Mock Providers
# https://developer.hashicorp.com/terraform/language/tests/mocking

mock_provider "google" {}
mock_provider "google-beta" {}
mock_provider "helm" {}
mock_provider "kubernetes" {}

mock_provider "terraform" {
  mock_data "terraform_remote_state" {
    defaults = {
      outputs = {
        gateway_mci_global_address = "192.0.2.0" # https://www.rfc-editor.org/rfc/rfc5737#section-3
      }
    }
  }
}

run "default" {
  command = apply

  module {
    source = "./tests/fixtures/default"
  }

  variables {
    gateway_dns = {
      "mock-environment.mock-subdomain.mock-domain" = {
        managed_zone = "mock-environment-mock-subdomain-mock-domain"
        project      = "mock-dns-project"
      }
    }
  }
}

run "default_regional" {
  command = apply

  module {
    source = "./tests/fixtures/default/regional"
  }

  variables {
    gateway_dns = {
      "mock-region-a.mock-environment.mock-subdomain.mock-domain" = {
        managed_zone = "mock-environment-mock-subdomain-mock-domain"
        project      = "mock-dns-project"
      }
    }
  }
}

variables {
  project     = "mock-project"
}
