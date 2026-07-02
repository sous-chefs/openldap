# frozen_string_literal: true

name 'openldap'

run_list 'test::default'

cookbook 'openldap', path: '.'
cookbook 'test', path: './test/cookbooks/test'
cookbook 'dpkg_autostart', git: 'https://github.com/sous-chefs/dpkg_autostart.git', branch: 'main'

Dir.children('./test/cookbooks/test/recipes').grep(/\.rb\z/).sort.each do |recipe|
  recipe_name = File.basename(recipe, '.rb')

  named_run_list recipe_name.to_sym, "test::#{recipe_name}"
end
