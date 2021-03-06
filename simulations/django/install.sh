#!/bin/bash

source /tmp/netpipevenv/bin/activate

pip install --upgrade django django-admin django-rest-swagger

git clone https://github.com/jpadilla/django-project-template.git
git clone https://github.com/macropin/django-registration.git

cd django-project-template
django-admin.py startproject \
    --template=https://github.com/jpadilla/django-project-template/archive/master.zip \
    --name=Procfile \
    --extension=py,md,env \
    project_name >> /dev/null
cp ../example.env .env
cp ../manage.py .
cp ../settings.py ./project_name/settings.py
cp ../wsgi.py ./project_name/wsgi.py
cp ../urls.py ./project_name/urls.py
cp ../views.py ./project_name/views.py
cp ../create-super-user.sh create-super-user.sh
cp -r ../templates ./project_name/
cp -r ../django-registration/test_app/templates/* ./project_name/templates/
cp -r ../django-registration/registration/templates/* ./project_name/templates/
cp ../Procfile ./Procfile

pipenv install --dev

export DJANGO_SECRET_KEY=supersecret

echo "Running makemigrations"
python manage.py makemigrations

echo "Running initial migration"
python manage.py migrate --noinput

./create-super-user.sh

echo ""
echo "Run ./start.sh to run Django"
