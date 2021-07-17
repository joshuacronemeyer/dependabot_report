require_relative './github_graph_api.rb'
require 'csv'
require "json"

api = GithubGraphApi.new(ENV["GITHUB_OAUTH_TOKEN"])
owner = "lane-one"
repos = ["laneone-core", "laneone-consumer-web", "laneone-queue", "laneone-consumer-android", "laneone-consumer-ios"]

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
puts "Done"
