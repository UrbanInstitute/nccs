desc "Starts local development server"
task :dev do
  sh "bundle exec jekyll serve"
end

desc "Builds site locally"
task :build do
  sh "bundle exec jekyll build"
end

desc "Cleans generated site files"
task :clean do
  puts "Cleaning generated files..."
  sh "rm -rf ./_site"
end
