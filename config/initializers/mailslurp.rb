MailSlurpClient.configure do |config|
    config.api_key['x-api-key'] = ENV['MAILSLURP_API_KEY']
  end
  