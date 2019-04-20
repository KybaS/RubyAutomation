Given(/^navigate to Go playground page$/) do
  @go.home_page.load
  @go.home_page.play_go_lang_popup.click
end

And(/^run executing exist code$/) do
  @go.playground_page.run_button.click
end

Then(/^check output$/) do
  expect(page).to have_css('.stdout', text: 'Hello, 世界')
end
