{ pkgs, lib, ... }: 
{
  # Create inventree directory and docker-compose file
  home.file."inventree/docker-compose.yml".text = ''
    version: '3.8'

    services:
      inventree-db:
        container_name: inventree-db
        image: postgres:13
        restart: unless-stopped
        environment:
          - POSTGRES_DB=inventree
          - POSTGRES_USER=inventree
          - POSTGRES_PASSWORD=inventreepassword
        volumes:
          - inventree_data:/var/lib/postgresql/data
        healthcheck:
          test: ["CMD-SHELL", "pg_isready -U inventree -d inventree"]
          interval: 10s
          timeout: 5s
          retries: 5

      inventree-server:
        container_name: inventree-server
        image: inventree/inventree:stable
        restart: unless-stopped
        depends_on:
          inventree-db:
            condition: service_healthy
        ports:
          - "8000:8000"
        environment:
          - INVENTREE_DB_ENGINE=postgresql
          - INVENTREE_DB_NAME=inventree
          - INVENTREE_DB_USER=inventree
          - INVENTREE_DB_PASSWORD=inventreepassword
          - INVENTREE_DB_HOST=inventree-db
          - INVENTREE_DB_PORT=5432
          - INVENTREE_DEBUG=False
          - INVENTREE_LOG_LEVEL=INFO
          - INVENTREE_SITE_URL=http://localhost:8000
          - CSRF_TRUSTED_ORIGINS=http://localhost:8000
        volumes:
          - inventree_media:/home/inventree/data/media
          - inventree_static:/home/inventree/data/static

    volumes:
      inventree_data:
      inventree_media:
      inventree_static:
  '';

  # Create convenient launcher script
  home.file."inventree/start.sh" = {
    text = ''
      #!/usr/bin/env bash
      cd ~/inventree
      echo "Starting Inventree with Docker Compose..."
      docker-compose up -d
      echo "Inventree is starting up. It will be available at http://localhost:8000"
      echo "Use 'docker-compose logs -f' to view logs"
    '';
    executable = true;
  };

  # Create setup script for first-time initialization
  home.file."inventree/setup.sh" = {
    text = ''
      #!/usr/bin/env bash
      cd ~/inventree
      echo "Setting up Inventree for first time..."
      docker-compose up -d inventree-db
      echo "Waiting for database to be ready..."
      sleep 10
      echo "Running initial migration..."
      docker-compose run --rm inventree-server invoke migrate
      echo "Collecting static files..."
      docker-compose run --rm inventree-server python manage.py collectstatic --noinput
      echo "Creating superuser (you'll be prompted for details)..."
      docker-compose run --rm inventree-server invoke superuser
      echo "Starting Inventree..."
      docker-compose up -d
      echo "Inventree setup complete! Available at http://localhost:8000"
    '';
    executable = true;
  };

  home.file."inventree/stop.sh" = {
    text = ''
      #!/usr/bin/env bash
      cd ~/inventree
      echo "Stopping Inventree..."
      docker-compose down
    '';
    executable = true;
  };
}