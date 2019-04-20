class Go
  def home_page
    PageObjects::HomePage.new
  end

  def documents_page
    PageObjects::DocumentsPage.new
  end

  def playground_page
    PageObjects::PlaygroundPage.new
  end
end
