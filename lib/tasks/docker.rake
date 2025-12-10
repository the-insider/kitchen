namespace :docker do
  desc "Start Docker services (database)"
  task :up do
    sh "docker-compose up -d db"
  end

  desc "Stop Docker services"
  task :down do
    sh "docker-compose down"
  end

  desc "Start Rails server"
  task :server do
    Rake::Task["docker:up"].invoke
    sh "docker-compose run --service-ports api bin/rails server -b 0.0.0.0"
  end

  desc "Open Rails console"
  task :console do
    Rake::Task["docker:up"].invoke
    sh "docker-compose run api bin/rails console"
  end

  desc "Run database migrations"
  task :migrate do
    Rake::Task["docker:up"].invoke
    sh "docker-compose run api bin/rails db:migrate"
  end

  desc "Create database"
  task :"db:create" do
    Rake::Task["docker:up"].invoke
    sh "docker-compose run api bin/rails db:create"
  end

  desc "Drop database"
  task :"db:drop" do
    Rake::Task["docker:up"].invoke
    sh "docker-compose run api bin/rails db:drop"
  end

  desc "Reset database (drop, create, migrate)"
  task :"db:reset" => [:"db:drop", :"db:create", :migrate]

  desc "Run database seeds"
  task :"db:seed" do
    Rake::Task["docker:up"].invoke
    sh "docker-compose run api bin/rails db:seed"
  end

  desc "Run tests"
  task :test do
    Rake::Task["docker:up"].invoke
    sh "docker-compose run api bin/rails test"
  end

  desc "Run any Rails command (usage: rake docker:exec[command])"
  task :exec, [:command] do |t, args|
    Rake::Task["docker:up"].invoke
    if args[:command]
      sh "docker-compose run api bin/rails #{args[:command]}"
    else
      puts "Usage: rake docker:exec[command]"
      puts "Example: rake docker:exec['generate model User name:string']"
    end
  end

  desc "Build Docker images"
  task :build do
    sh "docker-compose build"
  end

  desc "Show Docker logs"
  task :logs do
    sh "docker-compose logs -f"
  end
end

