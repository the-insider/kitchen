namespace :docker do
  desc 'Start Docker services (database)'
  task up: :environment do
    sh 'docker-compose up -d db'
  end

  desc 'Stop Docker services'
  task down: :environment do
    sh 'docker-compose down'
  end

  desc 'Install gems (bundle install)'
  task bundle: :environment do
    Rake::Task['docker:up'].invoke
    sh 'docker-compose run api bundle install'
  end

  desc 'Start Rails server'
  task server: :bundle do
    Rake::Task['docker:up'].invoke
    sh 'docker-compose run --service-ports api bin/rails server -b 0.0.0.0'
  end

  desc 'Open Rails console'
  task console: :bundle do
    Rake::Task['docker:up'].invoke
    sh 'docker-compose run api bin/rails console'
  end

  desc 'Run database migrations'
  task migrate: :bundle do
    Rake::Task['docker:up'].invoke
    sh 'docker-compose run api bin/rails db:migrate'
  end

  desc 'Create database'
  task 'db:create': :bundle do
    Rake::Task['docker:up'].invoke
    sh 'docker-compose run api bin/rails db:create'
  end

  desc 'Drop database'
  task 'db:drop': :bundle do
    Rake::Task['docker:up'].invoke
    sh 'docker-compose run api bin/rails db:drop'
  end

  desc 'Reset database (drop, create, migrate)'
  task 'db:reset': %i[db:drop db:create migrate]

  desc 'Run database seeds'
  task 'db:seed': :bundle do
    Rake::Task['docker:up'].invoke
    sh 'docker-compose run api bin/rails db:seed'
  end

  desc 'Run RSpec tests'
  task spec: :bundle do
    Rake::Task['docker:up'].invoke
    sh 'docker-compose run api bundle exec rspec'
  end

  desc 'Run RuboCop linter'
  task lint: :bundle do
    Rake::Task['docker:up'].invoke
    sh 'docker-compose run api bundle exec rubocop'
  end

  desc 'Run any Rails command (usage: rake docker:exec[command])'
  task :exec, [:command] => :bundle do |_t, args|
    Rake::Task['docker:up'].invoke
    if args[:command]
      sh "docker-compose run api bin/rails #{args[:command]}"
    else
      puts 'Usage: rake docker:exec[command]'
      puts "Example: rake docker:exec['generate model User name:string']"
    end
  end

  desc 'Build Docker images'
  task build: :environment do
    sh 'docker-compose build'
  end

  desc 'Show Docker logs'
  task logs: :environment do
    sh 'docker-compose logs -f'
  end
end
