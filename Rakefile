require 'hoe'
require './lib/gitta/version.rb'

Hoe.spec 'gitta' do

  self.version = Gitta::VERSION

  self.summary = 'gitta - (yet) another (lite) git command line wrapper / library'
  self.description = summary

  self.urls    = ['https://github.com/rubylibs/gitta']

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
