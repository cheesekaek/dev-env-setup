## Local Development Environment Setup
A bash script I designed to simplify the process of setting up a development environment by
provisioning a local development environment with packages, a cloned repository, and database, with just one command.

___

### Features
* One-command setup
* Logging system with timestamps
* Color-coded terminal output
* Automatic package installation
* Clone repositories
* Installs corresponding dependencies (currently only those in package.json and requirements.txt)
* Sets up a MySQL database for an existing .sql file

___

### Project Structure
```

├── logs/
│   └── (generated log files)
├── README.md
├── dev-setup.sh
├── packages.txt
```
* ```logs/```: Stores logs with timestamps
* ```dev-setup.sh```: Main script
* ```packages.txt```: List of packages to be installed
___

### Setup
1. Clone the repository  
```angular2html
git clone https://github.com/cheesekaek/dev-env-setup.git
cd your-repo-name
```
2. Make the script executable
```angular2html
chmod +x dev-setup.sh
```
3. Run the script
```angular2html
./dev-setup.sh
```
