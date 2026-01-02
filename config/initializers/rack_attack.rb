# frozen_string_literal: true

class Rack::Attack
  # Block specific IP addresses
  blocklist("block malicious IPs") do |req|
    # Block the specific IP address
    ["74.7.227.183"].include?(req.ip)
  end

  # Throttle all requests by IP (30 requests per 30 seconds)
  throttle("req/ip", limit: 30, period: 30.seconds) do |req|
    req.ip
  end
end
