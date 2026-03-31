## Local Development Environment Setup
A bash script I designed to simplify the process of setting up a development environment by
provisioning a local development environment with packages, environment variables, repositories and test data, with just one command.

___

### Features
* One-command setup
* Automatic package installation
* Logging system with timestamps
* Color-coded terminal output

___

### Project Structure
```
.
├── logs/
│   └── (generated log files)
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

---

### Future Plans
* Environment Configuration
* Git Repo Setup
* Database Setup
* ...
