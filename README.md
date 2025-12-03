# PHP Backend Base Template

A modern, production-ready PHP backend base template for pet projects with Docker, quality tools, and CI/CD.

## 🚀 Features

- **PHP 8.3** with latest best practices
- **Caddy Server** - Modern web server with automatic HTTPS
- **PostgreSQL 16** - Robust database (optional)
- **Redis 7** - Fast caching and sessions (optional)
- **Docker & Docker Compose** - Containerized development
- **Quality Tools**:
    - PHPUnit 11 - Unit testing
    - Psalm 5 - Static analysis
    - PHP CS Fixer 3 - Code style enforcement
- **GitHub Actions** - Automated CI/CD
- **PSR Standards** - PSR-4 autoloading, PSR-12 coding style
- **Simple Routing** - Fast Route for API endpoints
- **Logging** - Monolog integration
- **Environment Management** - DotEnv support

## 📋 Requirements

- Docker 24.0+
- Docker Compose 2.0+
- Make (optional, for convenience commands)
- Git

## 🛠️ Installation

### 1. Clone the repository

```bash
git clone <your-repo-url> my-project
cd my-project
```

### 2. Configure environment

```bash
cp .env.example .env
# Edit .env with your settings
```

### 3. Start containers

```bash
make up
# or
.docker-compose up -d
```

### 4. Install dependencies

```bash
make install
# or
.docker-compose exec php composer install
```

### 5. Access the application

- **API**: http://localhost:8000
- **Health Check**: http://localhost:8000/health

## 🎯 Quick Start

### Using Make (Recommended)

```bash
# Start development environment
make dev

# Run tests
make test

# Check code quality
make check

# View logs
make logs

# Open PHP shell
make shell

# See all commands
make help
```

### Using Docker Compose Directly

```bash
# Start containers
.docker-compose up -d

# Install dependencies
.docker-compose exec php composer install

# Run tests
.docker-compose exec php composer test

# Run Psalm
.docker-compose exec php composer psalm

# Fix code style
.docker-compose exec php composer cs:fix
```

## 📁 Project Structure

```
.
├── .github/
│   └── workflows/          # GitHub Actions CI/CD
│       ├── ci.yml         # Tests and quality checks
│       └── deploy.yml     # Deployment workflow
├── docker/
│   ├── caddy/
│   │   └── Caddyfile      # Caddy configuration
│   └── php/
│       ├── Dockerfile     # PHP container
│       ├── php.ini        # Development PHP config
│       ├── php-prod.ini   # Production PHP config
│       └── xdebug.ini     # Xdebug configuration
├── public/
│   └── index.php          # Application entry point
├── src/
│   └── Core/
│       ├── Application.php    # Main application
│       ├── Http/
│       │   ├── Request.php   # HTTP request
│       │   └── Response.php  # HTTP response
│       └── Routing/
│           └── Router.php    # Router implementation
├── tests/
│   ├── bootstrap.php      # Test bootstrap
│   ├── Unit/             # Unit tests
│   └── Integration/      # Integration tests
├── var/
│   ├── cache/            # Cache files
│   └── logs/             # Application logs
├── .env.example          # Environment variables template
├── .gitignore
├── .php-cs-fixer.php     # PHP CS Fixer configuration
├── composer.json         # PHP dependencies
├── docker-compose.yml    # Docker services
├── Makefile              # Development commands
├── phpunit.xml           # PHPUnit configuration
├── psalm.xml             # Psalm configuration
└── README.md
```

## 🔧 Development

### Adding Routes

Edit `src/Core/Application.php` in the `registerRoutes()` method:

```php
// GET endpoint
$this->router->get('/api/users', function (Request $request) {
    return new Response(['users' => []]);
});

// POST endpoint
$this->router->post('/api/users', function (Request $request) {
    $data = $request->getBody();
    return new Response(['created' => $data], 201);
});

// Route with parameters
$this->router->get('/api/users/{id:\d+}', function (Request $request) {
    $id = $request->getRouteParam('id');
    return new Response(['user_id' => $id]);
});
```

### Creating Services

Create new classes in `src/`:

```php
<?php

declare(strict_types=1);

namespace App\Service;

class UserService
{
    public function getUsers(): array
    {
        // Your logic here
        return [];
    }
}
```

### Writing Tests

#### Unit Tests

Create in `tests/Unit/`:

```php
<?php

declare(strict_types=1);

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;

final class UserServiceTest extends TestCase
{
    public function testGetUsers(): void
    {
        $service = new UserService();
        $users = $service->getUsers();
        
        $this->assertIsArray($users);
    }
}
```

#### Integration Tests

Create in `tests/Integration/`:

```php
<?php

declare(strict_types=1);

namespace Tests\Integration;

use PHPUnit\Framework\TestCase;

final class ApiTest extends TestCase
{
    public function testHealthEndpoint(): void
    {
        // Your integration test
    }
}
```

### Database Usage

Connect to PostgreSQL in your code:

```php
<?php

$dsn = $_ENV['DATABASE_URL'];
$pdo = new PDO($dsn);
```

Access database shell:

```bash
make db-shell
# or
.docker-compose exec postgres psql -U app -d app_db
```

### Redis Usage

```php
<?php

$redis = new Redis();
$redis->connect('redis', 6379);
$redis->set('key', 'value');
```

## 🧪 Testing

```bash
# Run all tests
make test

# Run with coverage
make test-coverage

# Run Psalm static analysis
make psalm

# Check code style
make cs-check

# Fix code style
make cs-fix

# Run all quality checks
make check
```

## 🚀 Deployment to VDS

### 1. Setup GitHub Secrets

Go to your repository → Settings → Secrets and variables → Actions

Add the following secrets:

- `VDS_HOST` - Your VDS IP or domain
- `VDS_USERNAME` - SSH username
- `VDS_SSH_KEY` - Private SSH key
- `VDS_PORT` - SSH port (usually 22)
- `VDS_APP_DIR` - Application directory on VDS (e.g., `/var/www/myapp`)
- `APP_URL` - Your application URL for health checks

Optional (for notifications):
- `TELEGRAM_TO` - Your Telegram chat ID
- `TELEGRAM_TOKEN` - Telegram bot token

### 2. Prepare VDS

Install required packages:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install PHP 8.3
sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install -y php8.3-fpm php8.3-cli php8.3-pgsql \
  php8.3-redis php8.3-mbstring php8.3-xml php8.3-curl \
  php8.3-zip php8.3-intl php8.3-bcmath

# Install Caddy
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https curl
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install caddy

# Install PostgreSQL
sudo apt install -y postgresql postgresql-contrib

# Install Redis
sudo apt install -y redis-server
```

Create application structure:

```bash
# Create directories
sudo mkdir -p /var/www/myapp/{releases,shared/var/{logs,cache}}
sudo chown -R www-data:www-data /var/www/myapp

# Create .env file
sudo nano /var/www/myapp/shared/.env
# Add your production environment variables
```

Configure Caddy:

```bash
sudo nano /etc/caddy/Caddyfile
```

Add:

```caddyfile
yourdomain.com {
    root * /var/www/myapp/current/public
    php_fastcgi unix//var/run/php/php8.3-fpm.sock
    file_server
    encode gzip
}
```

Reload Caddy:

```bash
sudo systemctl reload caddy
```

### 3. Deploy

Push to main branch or manually trigger:

```bash
git push origin main
```

Or use GitHub Actions UI to manually trigger deployment.

### 4. Manual Deployment

If you prefer manual deployment:

```bash
# On your local machine
composer install --no-dev --optimize-autoloader
tar -czf deploy.tar.gz --exclude='var/logs/*' --exclude='var/cache/*' .

# Upload to server
scp deploy.tar.gz user@your-vds:/tmp/

# On VDS
cd /var/www/myapp/releases
mkdir $(date +%Y%m%d_%H%M%S)
cd $(date +%Y%m%d_%H%M%S)
tar -xzf /tmp/deploy.tar.gz
ln -sfn $(pwd) /var/www/myapp/current
sudo systemctl reload php8.3-fpm
```

## 🐛 Debugging

### Enable Xdebug

Xdebug is already configured in development. Configure your IDE:

**PHPStorm:**
- Go to Settings → PHP → Servers
- Add server: Name: `localhost`, Host: `localhost`, Port: `8000`
- Map: `your-project-path` → `/var/www`

**VSCode:**

Add to `.vscode/launch.json`:

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for Xdebug",
            "type": "php",
            "request": "launch",
            "port": 9003,
            "pathMappings": {
                "/var/www": "${workspaceFolder}"
            }
        }
    ]
}
```

### View Logs

```bash
# All logs
make logs

# PHP errors
.docker-compose exec php tail -f /var/www/var/logs/php_errors.log

# Application logs
.docker-compose exec php tail -f /var/www/var/logs/app.log

# Xdebug logs
.docker-compose exec php tail -f /var/www/var/logs/xdebug.log
```

## 📝 Common Tasks

### Update Dependencies

```bash
make update
# or
.docker-compose exec php composer update
```

### Clear Cache

```bash
make clean
```

### Database Backup

```bash
make db-dump
# Creates backup_YYYYMMDD_HHMMSS.sql
```

### Database Restore

```bash
make db-restore FILE=backup.sql
```

### Fix Permissions

```bash
make permissions
```

### Check Service Health

```bash
make health
```

## 🔒 Security Notes

- Never commit `.env` file
- Keep dependencies updated
- Use strong passwords in production
- Enable HTTPS in production
- Review and restrict CORS settings
- Use environment-specific configurations
- Regularly backup database
- Monitor logs for suspicious activity

## 📚 Resources

- [PHP Documentation](https://www.php.net/docs.php)
- [Caddy Documentation](https://caddyserver.com/docs/)
- [FastRoute](https://github.com/nikic/FastRoute)
- [PHPUnit](https://phpunit.de/documentation.html)
- [Psalm](https://psalm.dev/docs/)
- [PHP CS Fixer](https://github.com/PHP-CS-Fixer/PHP-CS-Fixer)

## 🤝 Contributing

This is a base template. Fork it and customize for your needs!

## 📄 License

MIT License - feel free to use for your pet projects!

## 🎉 Happy Coding!

Questions? Issues? Create an issue in the repository!
