# frozen_string_literal: true

require_relative "dependabot_report/version"
require "thor"
require "csv"
require "json"
require "github_graph_api"

module DependabotReport
  # Understands how to roll a dependabot report
  class DependabotReport < Thor
    package_name "Dependabot Report"
    method_options oauth_token: :string
    desc "csv OWNER REPOS", "Create CSV report of dependabot vulnerabilities for OWNER's REPO(s)"

    def csv(owner, *repos)
      CSV.open("dependabot_alerts.csv", "w") do |csv|
        headings = ["Repo", "Vulnerability Name", "Description"]
        csv << headings
        add_each_repo(owner, repos, csv)
      end
    end

    private

    def add_each_repo(owner, repos, csv)
      repos.each do |repo|
        api = GithubGraphApi.new(ENV["GITHUB_OAUTH_TOKEN"] || options.oauth_token)
        dependaboot_data = JSON.parse(api.fetch_vulnerabilities(owner: owner, project: repo))
        next unless dependaboot_data["data"]

        alerts = dependaboot_data["data"]["repository"]["vulnerabilityAlerts"]["nodes"]
        puts "Found #{alerts.count} vulnerabilities from #{repo}. Creating csv report in dependabot_alerts.csv"
        add_each_alert(alerts, csv, repo)
      end
    end

    def add_each_alert(alerts, csv, repo)
      alerts.each do |alert|
        csv << [repo, alert["securityVulnerability"]["package"]["name"],
                alert["securityVulnerability"]["advisory"]["description"]]
      end
    end
  end
end
