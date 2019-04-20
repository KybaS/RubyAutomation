Given(/^open go land site$/) do
  @go.home_page.load
end

When(/^navigate to the Documents$/) do
  @go.documents_page.load
end

And(/^open the How to Write Go Code page$/) do
  @go.documents_page.how_to_write_go_code.click
end

Then(/^check the (.*)$/) do |block|
  find(:xpath, "//h3[contains(text(), '#{block}')]")
end
