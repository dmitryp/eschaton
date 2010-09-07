require 'rake'
require 'yard'
require 'rake/testtask'
require 'rake/rdoctask'

desc 'Default: run eschaton tests.'
task :default => :test

desc 'Test the eschaton plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate YARD documentation for the eschaton plugin.'
YARD::Rake::YardocTask.new(:ydoc) do |t|  
  t.files = ['lib/**/*.rb', "slices/*/**/*.rb"]
  t.options = ['-r', 'README.rdoc']  
end

desc 'Generate documentation for the eschaton plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'eschaton'
  rdoc.options << '--line-numbers' << '--inline-source' << "--force-update"
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.main = "README.rdoc"

  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.rdoc_files.include("slices/*/**/*.rb")
end

desc 'Opens documentation for the eschaton plugin.'
task :open_doc do
  `open doc/index.html`
end

desc 'Default: run eschaton tests.'
task :rdoc_and_open => [:rdoc, :open_doc]

desc 'Updates eschaton related javascript files.'
task :update_javascript do
  update_javascript
end

def update_javascript
  project_dir = RAILS_ROOT + '/public/javascripts/'

  FileUtils.cp ['generators/map/templates/eschaton.js'], project_dir

  puts 'Updated javascripts:'
  puts "  /public/javascripts/eschaton.js"
end
