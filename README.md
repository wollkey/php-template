# PHP Backend Base Template

A modern, production-ready PHP backend base template for pet projects with Docker, quality tools, and CI/CD.

## 🛠️ Installation

1. Clone the repository
2. `make setup`
3. `make up`
4. Check http://localhost:8000

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
│   └── Application.php    # Main application
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

## 📚 Resources

- [PHP Documentation](https://www.php.net/docs.php)
- [Caddy Documentation](https://caddyserver.com/docs/)
- [FrankenPhp](https://frankenphp.dev/)
- [FastRoute](https://github.com/nikic/FastRoute)
- [PHPUnit](https://phpunit.de/documentation.html)
- [Psalm](https://psalm.dev/docs/)
- [PHP CS Fixer](https://github.com/PHP-CS-Fixer/PHP-CS-Fixer)
