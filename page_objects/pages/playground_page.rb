module PageObjects
  class PlaygroundPage < SitePrism::Page
    element :run_button, 'input#run'
    element :program_output, '.stdout'
  end
end
