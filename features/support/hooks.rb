Before do
  @go = Go.new
end

at_exit do
  ReportBuilder.configure do |config|
    config.json_path = 'tmp/'
    config.report_path = 'tmp/report'
    config.retry_report_path = 'tmp/retry.txt'
    config.report_types = %i[html retry]
    config.report_tabs = %i[overview features scenarios errors]
    config.report_title = 'Test Results'
    config.compress_images = false
  end

  ReportBuilder.build_report
end

if @browser == 'firefox'
  Before do
    page.driver.browser.manage.window.resize_to('1920', '1080')
  end
end

Before('@resize') do
  page.driver.browser.manage.window.resize_to(1080, 1920)
end

