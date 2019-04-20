module PageObjects
  class DocumentsPage < SitePrism::Page
    set_url '/doc'
    set_url_matcher %r{/doc}

    element :how_to_write_go_code, :xpath, "//a[contains(@href,'code.html')]"
  end
end
