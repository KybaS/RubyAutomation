require 'bigdecimal'
require 'dotenv'
require 'capybara'
require 'capybara/cucumber'
require 'rspec'
require 'capybara/dsl'
require 'selenium-webdriver'
require 'capybara-screenshot/cucumber'
require 'capybara/email'
require 'ffaker'
require 'site_prism'
require 'pry'
require 'byebug'
require 'selenium/webdriver/chrome'
require 'capybara_table/rspec'
require 'report_builder'
require 'rest-client'
require 'yaml'
require 'recursive-open-struct'
require 'headless'
require 'rspec/expectations'
require 'rspec'
require 'capybara/rspec'
require 'cucumber'
require 'touch_action'
require 'rspec/core'
require 'appium_lib'
require 'appium_capybara'
require 'em/pure_ruby'


HOST = 'PROD'.freeze

if HOST == 'PROD'
  URL = 'https://golang.org'.freeze
elsif HOST == 'DEV'
  URL = 'https://here.dev.host.com'.freeze
end

Capybara::Screenshot.autosave_on_failure = false
Capybara.ignore_hidden_elements = true
Capybara.default_max_wait_time = 10
Capybara.configure do |config|
  config.default_driver = :selenium
  config.javascript_driver = :selenium
  config.app_host = URL
  config.run_server = false
end

@browser = ENV.fetch('BROWSER', 'chrome').downcase
if @browser == 'firefox'
  Capybara.register_driver :selenium do |app|
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-gpu')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--start-maximized')
    driver = Capybara::Selenium::Driver.new(app, browser: :firefox, options: options)
    driver
  end
elsif @browser == 'chrome'
  Capybara.register_driver :selenium do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    # options.add_argument('--headless')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-gpu')
    options.add_argument('--disable-popup-blocking')
    options.add_argument('--start-maximized')

    options.add_preference(:download, directory_upgrade: true,
                                      prompt_for_download: true,
                                      default_directory:
                               '/home/user/Documents/CucumberWithRuby')

    options.add_preference(:browser, set_download_behavior: { behavior: 'allow' })

    driver = Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
    bridge = driver.browser.send(:bridge)

    path = '/session/:session_id/chromium/send_command'
    path[':session_id'] = bridge.session_id

    bridge.http.call(:post, path, cmd: 'Page.setDownloadBehavior',
                                  params: {
                                    behavior: 'allow',
                                    downloadPath: '/tmp'
                                  })
    driver
  end

elsif @browser == 'firefox_selenoid'
  Capybara.register_driver :selenium do |_app|
    caps = Selenium::WebDriver::Remote::Capabilities.new
    caps['browserName'] = 'firefox'
    caps['version'] = '61.0'
    caps['enableVNC'] = true
    Capybara::Selenium::Driver.new(:remote,
                                   url: 'http://localhost:4444/wd/hub',
                                   desired_capabilities: caps)
  end

elsif @browser == 'chrome_selenoid'

  Capybara.register_driver :selenium do |app|
    caps = Selenium::WebDriver::Remote::Capabilities.new
    caps['browserName'] = 'chrome'
    caps['version'] = '73.0'
    caps['enableVNC'] = true
    caps['screenResolution'] = '1920x1080x24'
    Capybara::Selenium::Driver.new(app, url: 'http://192.168.99.100:4444/wd/hub',
                                        browser: :remote,
                                        desired_capabilities: caps)
  end

elsif @browser == 'android_chrome'
  Capybara.register_driver(:appium) do |app|
    all_options = {
      caps: {
        platformName: 'Android',
        versionNumber: '7.0',
        deviceName: 'Pixel XL 7',
        device: 'Pixel',
        browserName: 'Chrome'
      },
      server_url: 'http://localhost:4723/wd/hub'
    }

    Appium::Capybara::Driver.new app, all_options
  end
end

Capybara.default_driver = :appium if @browser == 'android_chrome'

require "#{File.dirname(__FILE__)}/../../page_objects/pages/home_page.rb"
Dir["#{File.dirname(__FILE__)}/../../page_objects/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/../../page_objects/pages/*.rb"].each { |f| require f }
Dir["#{File.dirname(__FILE__)}/../../lib/**/*.rb"].each { |f| require f }

SitePrism.configure do |config|
  config.use_implicit_waits = false
end
