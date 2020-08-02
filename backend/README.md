# DjangoAPI
The Django backend API endpoints for the app.

# Setup

## Postgres installation (for development environment)

- Follow the instructions [here](https://www.digitalocean.com/community/tutorials/how-to-use-postgresql-with-your-django-application-on-ubuntu-14-04)
- Database details
  - Name: mdm
  - User: mdm_user
  - Password: InchOwiL

## Pipenv installation 
- Execute these commands from this project's root.
- Install the `pipenv` package (only have to do it once).
  ```bash
  $ pip install pipenv
  ```
- Open the virtual environment shell.
  ```bash
  $ pipenv shell
  ```
- Install all the packages from Pipfile
  ```bash
  $ pipenv install
  ```
  
## Using the project
- Execute these commands inside the pipenv shell opened from the above steps.
- Make and run migrations:
  ```bash
  $ python manage.py makemigrations
  $ python manage.py migrate
  ```
- Run server:
  ```bash
  $ python manage.py runserver
  ```
- Open browser and access the website on [127.0.0.1:8000](http://127.0.0.1:8000)
