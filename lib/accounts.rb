module Accounts
  def self.get_settings(account)
    settings = YAML::load(File.open("#{Rails.root}/config/accounts.yml"))[account]
  end
  
  def self.consumer(account)
    settings = self.get_settings(account)
    OAuth::Consumer.new(settings["consumer_key"], settings["consumer_secret"], {:site=>settings["site"]})
  end
end
