# frozen_string_literal: true

require_relative "dependabot_report/version"
require 'thor'
require_relative './github_graph_api.rb'
require 'csv'
require "json"

module DependabotReport

  class DependabotReport < Thor
    package_name "Dependabot Report"
    method_options :oauth_token => :string
    desc "csv OWNER REPOS", "Create CSV report of dependabot vulnerabilities for OWNER's REPO(s)"

    def csv(owner, *repos)
      api = GithubGraphApi.new(ENV["GITHUB_OAUTH_TOKEN"] || ooptions.oauth_token)

      CSV.open("dependabot_alerts.csv", "w") do |csv|
        headings = ["Repo", "Vulnerability Name", "Description"]
        csv << headings
        repos.each do |repo|
          dependaboot_data = JSON.parse(api.fetch_vulnerabilities(owner: owner, project: repo))
          next unless dependaboot_data["data"]
          alerts = dependaboot_data["data"]["repository"]["vulnerabilityAlerts"]["nodes"]
          puts "Found #{alerts.count} vulnerabilities from #{repo}. Creating csv report in dependabot_alerts.csv"
          alerts.each{|alert| csv << [repo, alert["securityVulnerability"]["package"]["name"], alert["securityVulnerability"]["advisory"]["description"]]}
        end
      end
    end

  end
end
