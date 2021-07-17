# frozen_string_literal: true

require "net/http"
require "json"
# Understands github graph api
class GithubGraphApi
  ENDPOINT = "https://api.github.com/graphql"
  def initialize(oauth_token)
    raise "You must provide an oauth token" unless oauth_token

    @oauth_token = oauth_token
  end

  def fetch_vulnerabilities(project:, owner:)
    uri = URI(ENDPOINT)
    https = Net::HTTP.new(uri.host, uri.port)
    # https.set_debug_output($stdout)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path, { "Authorization" => "bearer #{@oauth_token}" })
    req.body = JSON[{ "query" => request_json(project: project, owner: owner) }]
    res = https.request(req)
    res.body
  end

  private

  def request_json(project:, owner:)
    <<-HERE
      query{
        repository(name: "#{project}", owner: "#{owner}") {
          vulnerabilityAlerts(first: 100) {
            nodes {
              createdAt
              dismissedAt
              securityVulnerability {
                package {
                  name
                }
                advisory {
                  description
                }
              }
            }
          }
        }
      }
    HERE
  end
end
