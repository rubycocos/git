require 'hoe'
require './lib/gitti/version.rb'

Hoe.spec 'gitti' do

  self.version = Gitti::VERSION

  self.summary = 'gitti - (yet) another (lite) git command line wrapper / library'
  self.description = summary

  self.urls    = ['https://github.com/rubylibs/gitti']

  self.author  = 'Gerald Bauer'
  self.email   = 'ruby-talk@ruby-lang.org'

  # switch extension to .markdown for gihub formatting
  self.readme_file  = 'README.md'
  self.history_file = 'HISTORY.md'

  self.extra_deps = [
    ['logutils' ],
  ]

  self.licenses = ['Public Domain']

  self.spec_extras = {
   required_ruby_version: '>= 1.9.2'
  }

end
