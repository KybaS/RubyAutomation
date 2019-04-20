module PageObjects
  class HomePage < SitePrism::Page
    set_url '/'
    set_url_matcher %r{/}

    element :header, '#topbar'
    element :play_go_lang_popup, '#learn>.popout'
  end
end
