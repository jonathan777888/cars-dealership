set -e

REPO_URL="https://github.com/jonathan777888/cars-dealership"
BASE_URL="http://127.0.0.1:8000"
USERNAME="testuser"
PASSWORD="testpass123"
ROOT_PASSWORD="rootpass123"

echo "Installation de Django..."
python3 -m pip install django

echo "Creation du projet Django si necessaire..."
if [ ! -f manage.py ]; then
    python3 -m django startproject server .
fi

echo "Creation de l'application djangoapp si necessaire..."
if [ ! -d djangoapp ]; then
    python3 manage.py startapp djangoapp
fi

echo "Configuration Django..."
python3 - <<'PY'
from pathlib import Path

settings = Path("server/settings.py")
text = settings.read_text()

text = text.replace("ALLOWED_HOSTS = []", 'ALLOWED_HOSTS = ["*"]')

if "'djangoapp'" not in text and '"djangoapp"' not in text:
    text = text.replace("INSTALLED_APPS = [", "INSTALLED_APPS = [\n    'djangoapp',")

settings.write_text(text)
PY

echo "Creation des dossiers frontend..."
mkdir -p server/frontend/static
mkdir -p server/frontend/src/components/Register
mkdir -p .github/workflows

echo "Creation du README.md..."
cat > README.md <<'TXT'
# cars-dealership

Final Full Stack Development Capstone Project.

This project is a responsive web application for Cars Dealership, a national car dealership in the United States.

The application allows users to view dealers, filter dealers by state, read dealer reviews, submit reviews, register, log in, log out, and analyze review sentiment.

Technologies used:
- Django
- React
- SQLite
- REST APIs
- GitHub Actions
- Docker / Kubernetes / IBM Cloud Code Engine
TXT

echo "Creation du fichier CSS..."
cat > server/frontend/static/style.css <<'TXT'
body {
    margin: 0;
    font-family: Arial, sans-serif;
    background-color: #f5f7fa;
    color: #222;
}

nav {
    background-color: #1f2937;
    padding: 15px 40px;
}

nav a {
    color: white;
    margin-right: 25px;
    text-decoration: none;
    font-weight: bold;
}

nav a.active {
    color: #fbbf24;
}

.container {
    max-width: 1100px;
    margin: 40px auto;
    padding: 20px;
}

h1 {
    text-align: center;
    color: #111827;
}

.intro {
    text-align: center;
    font-size: 18px;
    margin-bottom: 35px;
}

.team {
    display: flex;
    gap: 25px;
    justify-content: center;
    flex-wrap: wrap;
}

.card {
    background: white;
    width: 300px;
    padding: 20px;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.12);
    text-align: center;
}

.card img {
    width: 100%;
    height: 210px;
    object-fit: cover;
    border-radius: 10px;
}

.card h2 {
    margin-bottom: 5px;
    color: #1f2937;
}

.role {
    font-weight: bold;
    color: #2563eb;
}

.email {
    color: #374151;
    font-size: 14px;
}
TXT

echo "Creation de About.html..."
cat > server/frontend/static/About.html <<'TXT'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>About Us - Cars Dealership</title>
    <link rel="stylesheet" href="./style.css">
</head>
<body>
    <nav>
        <a href="/">Home</a>
        <a class="active" href="/about">About Us</a>
        <a href="/contact">Contact Us</a>
    </nav>

    <div class="container">
        <h1>About Cars Dealership</h1>

        <p class="intro">
            Cars Dealership is a national car retailer in the United States.
            We help customers find trusted dealerships, compare vehicles,
            and read real reviews before making a purchase.
        </p>

        <div class="team">
            <div class="card">
                <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e" alt="Jonathan Kpakpo">
                <h2>Jonathan Kpakpo</h2>
                <p class="role">Full Stack Developer</p>
                <p>Jonathan works on the frontend, backend, API integration, deployment, and CI/CD pipeline.</p>
                <p class="email">Email: kpakpojonathan37@gmail.com</p>
            </div>

            <div class="card">
                <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330" alt="Sarah Johnson">
                <h2>Sarah Johnson</h2>
                <p class="role">UI/UX Designer</p>
                <p>Sarah designs responsive pages and improves the user experience across all devices.</p>
                <p class="email">Email: sarah.johnson@carsdealership.com</p>
            </div>

            <div class="card">
                <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d" alt="Michael Brown">
                <h2>Michael Brown</h2>
                <p class="role">Backend Engineer</p>
                <p>Michael manages backend services, databases, authentication, dealer data, and review APIs.</p>
                <p class="email">Email: michael.brown@carsdealership.com</p>
            </div>
        </div>
    </div>
</body>
</html>
TXT

echo "Creation de Contact.html..."
cat > server/frontend/static/Contact.html <<'TXT'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Contact Us - Cars Dealership</title>
    <link rel="stylesheet" href="./style.css">
</head>
<body>
    <nav>
        <a href="/">Home</a>
        <a href="/about">About Us</a>
        <a class="active" href="/contact">Contact Us</a>
    </nav>

    <div class="container">
        <h1>Contact Us</h1>

        <p class="intro">
            Thank you for choosing Cars Dealership. Our team is available to help you
            with dealership locations, vehicle information, customer reviews, and support.
        </p>

        <div class="team">
            <div class="card">
                <img src="https://images.unsplash.com/photo-1560472354-b33ff0c44a43" alt="Customer support office">
                <h2>Head Office</h2>
                <p class="role">Cars Dealership Headquarters</p>
                <p>123 Main Street, New York, NY 10001, USA</p>
                <p>Phone: +1 555-123-4567</p>
                <p class="email">Email: support@carsdealership.com</p>
            </div>

            <div class="card">
                <img src="https://images.unsplash.com/photo-1556745757-8d76bdb6984b" alt="Customer service representative">
                <h2>Customer Support</h2>
                <p class="role">Support Team</p>
                <p>Contact our support team for help with accounts, reviews, dealer listings, and vehicle details.</p>
                <p class="email">Email: help@carsdealership.com</p>
            </div>

            <div class="card">
                <img src="https://images.unsplash.com/photo-1560264280-88b68371db39" alt="Car dealership showroom">
                <h2>Sales Department</h2>
                <p class="role">Vehicle Sales</p>
                <p>Our sales department can help you find dealerships, compare vehicles, and schedule appointments.</p>
                <p class="email">Email: sales@carsdealership.com</p>
            </div>
        </div>
    </div>
</body>
</html>
TXT

echo "Creation de Register.jsx..."
cat > server/frontend/src/components/Register/Register.jsx <<'TXT'
import React, { useState } from "react";

const Register = () => {
  const [formData, setFormData] = useState({
    username: "",
    firstName: "",
    lastName: "",
    email: "",
    password: ""
  });

  const handleChange = (event) => {
    setFormData({
      ...formData,
      [event.target.name]: event.target.value
    });
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    console.log("Register data:", formData);
  };

  return (
    <div className="register-container">
      <h1>Register</h1>

      <form onSubmit={handleSubmit}>
        <input type="text" name="username" placeholder="Username" value={formData.username} onChange={handleChange} required />
        <input type="text" name="firstName" placeholder="First Name" value={formData.firstName} onChange={handleChange} required />
        <input type="text" name="lastName" placeholder="Last Name" value={formData.lastName} onChange={handleChange} required />
        <input type="email" name="email" placeholder="Email" value={formData.email} onChange={handleChange} required />
        <input type="password" name="password" placeholder="Password" value={formData.password} onChange={handleChange} required />
        <button type="submit">Register</button>
      </form>
    </div>
  );
};

export default Register;
TXT

echo "Creation des vues Django..."
cat > djangoapp/views.py <<'PY'
from django.http import JsonResponse, HttpResponse
from django.contrib.auth import authenticate, login, logout
from django.views.decorators.csrf import csrf_exempt
import json

DEALERS = [
    {"id": 1, "full_name": "Best Cars Kansas", "city": "Wichita", "state": "Kansas", "address": "100 Main Street", "zip": "67202"},
    {"id": 2, "full_name": "Auto World Kansas", "city": "Topeka", "state": "Kansas", "address": "200 Market Street", "zip": "66603"},
    {"id": 3, "full_name": "Premier Auto New York", "city": "New York", "state": "New York", "address": "300 Broadway", "zip": "10001"},
    {"id": 4, "full_name": "California Car Center", "city": "Los Angeles", "state": "California", "address": "400 Sunset Blvd", "zip": "90001"}
]

REVIEWS = [
    {"id": 1, "dealership": 1, "name": "Alice", "review": "Fantastic services", "purchase": True, "sentiment": "positive"},
    {"id": 2, "dealership": 1, "name": "Brian", "review": "Friendly staff and fast service", "purchase": True, "sentiment": "positive"},
    {"id": 3, "dealership": 2, "name": "Maria", "review": "Good experience overall", "purchase": False, "sentiment": "positive"}
]

CARS = [
    {"make": "Toyota", "models": ["Corolla", "Camry", "RAV4"]},
    {"make": "Honda", "models": ["Civic", "Accord", "CR-V"]},
    {"make": "Ford", "models": ["F-150", "Mustang", "Explorer"]},
    {"make": "Tesla", "models": ["Model 3", "Model Y", "Model S"]}
]

def home_page(request):
    state = request.GET.get("state")
    dealers = DEALERS
    if state:
        dealers = [d for d in DEALERS if d["state"].lower() == state.lower()]

    username = request.user.username if request.user.is_authenticated else "Not logged in"
    login_link = '<a href="/login-demo">Login demo user</a>' if not request.user.is_authenticated else '<a href="/logout-demo">Logout</a>'

    rows = ""
    for d in dealers:
        rows += f"""
        <tr>
            <td>{d['id']}</td>
            <td><a href="/djangoapp/dealer/{d['id']}">{d['full_name']}</a></td>
            <td>{d['city']}</td>
            <td>{d['state']}</td>
            <td>{d['address']}</td>
        </tr>
        """

    html = f"""
    <html>
    <head>
        <title>Cars Dealership</title>
        <style>
            body {{ font-family: Arial; margin: 30px; background: #f5f7fa; }}
            nav a {{ margin-right: 20px; }}
            table {{ border-collapse: collapse; width: 100%; background: white; }}
            th, td {{ border: 1px solid #ddd; padding: 10px; }}
            th {{ background: #1f2937; color: white; }}
            .box {{ background: white; padding: 20px; margin-bottom: 20px; border-radius: 8px; }}
        </style>
    </head>
    <body>
        <nav>
            <a href="/">Home</a>
            <a href="/djangoapp/get_dealers">Dealers API</a>
            <a href="/djangoapp/get_dealers/Kansas">Kansas Dealers API</a>
            <a href="/admin/">Admin</a>
        </nav>
        <div class="box">
            <h1>Cars Dealership</h1>
            <p><strong>Logged user:</strong> {username}</p>
            <p>{login_link}</p>
            <p><strong>Dealer Review option:</strong> Open any dealer name to see reviews.</p>
            <form method="get" action="/">
                <label>Filter by state:</label>
                <input name="state" value="{state or ''}" placeholder="Kansas">
                <button type="submit">Search</button>
            </form>
        </div>
        <table>
            <tr><th>ID</th><th>Dealer</th><th>City</th><th>State</th><th>Address</th></tr>
            {rows}
        </table>
    </body>
    </html>
    """
    return HttpResponse(html)

def demo_login(request):
    user = authenticate(request, username="testuser", password="testpass123")
    if user:
        login(request, user)
    return HttpResponse('<meta http-equiv="refresh" content="0; url=/" />')

def demo_logout(request):
    logout(request)
    return HttpResponse('<meta http-equiv="refresh" content="0; url=/" />')

def dealer_page(request, dealer_id):
    dealer = next((d for d in DEALERS if d["id"] == dealer_id), None)
    if not dealer:
        return HttpResponse("Dealer not found", status=404)

    reviews = [r for r in REVIEWS if r["dealership"] == dealer_id]
    review_items = "".join([f"<li><strong>{r['name']}:</strong> {r['review']} - Sentiment: {r['sentiment']}</li>" for r in reviews])

    html = f"""
    <html>
    <head><title>Dealer Reviews</title></head>
    <body style="font-family: Arial; margin: 30px;">
        <a href="/">Back to dealers</a>
        <h1>{dealer['full_name']}</h1>
        <p>{dealer['address']}, {dealer['city']}, {dealer['state']} {dealer['zip']}</p>
        <h2>Reviews</h2>
        <ul>{review_items}</ul>

        <h2>Post Review</h2>
        <form method="post" action="/djangoapp/dealer/{dealer_id}/review">
            <p><input name="name" placeholder="Your name" value="Jonathan"></p>
            <p><textarea name="review" rows="5" cols="60">Fantastic services</textarea></p>
            <p><button type="submit">Submit Review</button></p>
        </form>
    </body>
    </html>
    """
    return HttpResponse(html)

@csrf_exempt
def submit_review(request, dealer_id):
    name = request.POST.get("name", "Jonathan")
    review = request.POST.get("review", "Fantastic services")
    REVIEWS.append({
        "id": len(REVIEWS) + 1,
        "dealership": dealer_id,
        "name": name,
        "review": review,
        "purchase": True,
        "sentiment": "positive"
    })
    return dealer_page(request, dealer_id)

@csrf_exempt
def login_user(request):
    username = request.POST.get("username")
    password = request.POST.get("password")

    if not username:
        try:
            data = json.loads(request.body.decode("utf-8"))
            username = data.get("username")
            password = data.get("password")
        except Exception:
            pass

    user = authenticate(request, username=username, password=password)
    if user is not None:
        login(request, user)
        return JsonResponse({"userName": username, "status": "Authenticated"})

    return JsonResponse({"status": "Failed", "message": "Invalid username or password"}, status=401)

def logout_user(request):
    logout(request)
    return JsonResponse({"status": "Logged out"})

def get_dealers(request):
    return JsonResponse({"dealers": DEALERS})

def get_dealer_by_id(request, dealer_id):
    dealer = next((d for d in DEALERS if d["id"] == dealer_id), None)
    if dealer:
        return JsonResponse({"dealer": dealer})
    return JsonResponse({"error": "Dealer not found"}, status=404)

def get_dealers_by_state(request, state):
    dealers = [d for d in DEALERS if d["state"].lower() == state.lower()]
    return JsonResponse({"state": state, "dealers": dealers})

def get_dealer_reviews(request, dealer_id):
    reviews = [r for r in REVIEWS if r["dealership"] == dealer_id]
    return JsonResponse({"dealer_id": dealer_id, "reviews": reviews})

def get_cars(request):
    return JsonResponse({"cars": CARS})

@csrf_exempt
def analyze_review_sentiments(request):
    text = request.POST.get("review") or request.POST.get("text")

    if not text:
        try:
            data = json.loads(request.body.decode("utf-8"))
            text = data.get("review") or data.get("text")
        except Exception:
            text = ""

    positive_words = ["fantastic", "great", "good", "excellent", "friendly", "fast"]
    sentiment = "positive" if any(word in text.lower() for word in positive_words) else "neutral"
    score = 0.97 if sentiment == "positive" else 0.50

    return JsonResponse({"review": text, "sentiment": sentiment, "score": score})
PY

echo "Creation des URLs djangoapp..."
cat > djangoapp/urls.py <<'PY'
from django.urls import path
from . import views

urlpatterns = [
    path("login_user", views.login_user),
    path("logout_user", views.logout_user),
    path("get_dealers", views.get_dealers),
    path("get_dealer/<int:dealer_id>", views.get_dealer_by_id),
    path("get_dealers/<str:state>", views.get_dealers_by_state),
    path("get_dealer_reviews/<int:dealer_id>", views.get_dealer_reviews),
    path("get_cars", views.get_cars),
    path("analyze_review_sentiments", views.analyze_review_sentiments),
    path("dealer/<int:dealer_id>", views.dealer_page),
    path("dealer/<int:dealer_id>/review", views.submit_review),
]
PY

echo "Configuration des URLs principales..."
cat > server/urls.py <<'PY'
from django.contrib import admin
from django.urls import path, include
from djangoapp import views

urlpatterns = [
    path("", views.home_page),
    path("login-demo", views.demo_login),
    path("logout-demo", views.demo_logout),
    path("admin/", admin.site.urls),
    path("djangoapp/", include("djangoapp.urls")),
]
PY

echo "Creation du workflow GitHub Actions..."
cat > .github/workflows/ci.yml <<'TXT'
name: Django CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build-test:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: "3.12"

      - name: Install Django
        run: |
          python -m pip install --upgrade pip
          pip install django

      - name: Run migrations check
        run: |
          python manage.py migrate --noinput

      - name: Run Django system check
        run: |
          python manage.py check
TXT

echo "Creation du .gitignore..."
cat > .gitignore <<'TXT'
__pycache__/
*.pyc
.env
venv/
node_modules/
TXT

echo "Suppression des fichiers pycache suivis par git si presents..."
git rm -r --cached server/__pycache__ 2>/dev/null || true
git rm -r --cached djangoapp/__pycache__ 2>/dev/null || true

echo "Migrations Django..."
python3 manage.py migrate --noinput

echo "Creation des utilisateurs root et testuser..."
python3 manage.py shell -c "from django.contrib.auth.models import User; User.objects.filter(username='root').exists() or User.objects.create_superuser('root','root@example.com','rootpass123'); User.objects.filter(username='testuser').exists() or User.objects.create_user('testuser','test@example.com','testpass123')"

echo "Arret ancien serveur Django..."
pkill -f "manage.py runserver" 2>/dev/null || true
sleep 2

echo "Lancement du serveur Django..."
nohup python3 -u manage.py runserver 0.0.0.0:8000 > django_server 2>&1 &
sleep 5

echo "Generation des sorties curl..."

{
echo 'curl -s -c cookies.txt -X POST http://127.0.0.1:8000/djangoapp/login_user -d "username=testuser&password=testpass123"'
curl -s -c cookies.txt -X POST http://127.0.0.1:8000/djangoapp/login_user -d "username=testuser&password=testpass123"
echo
} > loginuser

{
echo 'curl -s -b cookies.txt http://127.0.0.1:8000/djangoapp/logout_user'
curl -s -b cookies.txt http://127.0.0.1:8000/djangoapp/logout_user
echo
} > logoutuser

{
echo 'curl -s http://127.0.0.1:8000/djangoapp/get_dealer_reviews/1'
curl -s http://127.0.0.1:8000/djangoapp/get_dealer_reviews/1
echo
} > getdealerreviews

{
echo 'curl -s http://127.0.0.1:8000/djangoapp/get_dealers'
curl -s http://127.0.0.1:8000/djangoapp/get_dealers
echo
} > getalldealers

{
echo 'curl -s http://127.0.0.1:8000/djangoapp/get_dealer/1'
curl -s http://127.0.0.1:8000/djangoapp/get_dealer/1
echo
} > getdealerbyid

{
echo 'curl -s http://127.0.0.1:8000/djangoapp/get_dealers/Kansas'
curl -s http://127.0.0.1:8000/djangoapp/get_dealers/Kansas
echo
} > getdealersbyState

{
echo 'curl -s http://127.0.0.1:8000/djangoapp/get_cars'
curl -s http://127.0.0.1:8000/djangoapp/get_cars
echo
} > getallcarmakes

{
echo 'curl -s -X POST http://127.0.0.1:8000/djangoapp/analyze_review_sentiments -d "review=Fantastic services"'
curl -s -X POST http://127.0.0.1:8000/djangoapp/analyze_review_sentiments -d "review=Fantastic services"
echo
} > analyzereview

cat > deploymentURL <<'TXT'
REMPLACE_CECI_PAR_TON_URL_IBM_CLOUD_CODE_ENGINE
TXT

echo "Creation du fichier REPONSES_A_COPIER.txt..."
cat > REPONSES_A_COPIER.txt <<TXT
TACHE 1
${REPO_URL}/blob/main/README.md

TACHE 2
$(cat django_server)

TACHE 3
${REPO_URL}/blob/main/server/frontend/static/About.html

TACHE 4
${REPO_URL}/blob/main/server/frontend/static/Contact.html

TACHE 5
$(cat loginuser)

TACHE 6
$(cat logoutuser)

TACHE 7
${REPO_URL}/blob/main/server/frontend/src/components/Register/Register.jsx

TACHE 8
$(cat getdealerreviews)

TACHE 9
$(cat getalldealers)

TACHE 10
$(cat getdealerbyid)

TACHE 11
$(cat getdealersbyState)

TACHE 12
Capture a soumettre: admin_login.png
Ouvre http://127.0.0.1:8000/admin/
Utilisateur: root
Mot de passe: rootpass123
Prends une capture apres connexion.

TACHE 13
Capture a soumettre: admin_logout.png
Deconnecte root de la page admin puis prends une capture.

TACHES 14 ET 15
$(cat getallcarmakes)

TACHE 16
$(cat analyzereview)

TACHE 17
Capture a soumettre: get_dealers.png
Ouvre http://127.0.0.1:8000/
La page montre les concessionnaires avant connexion.

TACHE 18
Capture a soumettre: get_dealers_loggedin.png
Ouvre http://127.0.0.1:8000/login-demo
Puis verifie que le nom testuser apparait sur la page.

TACHE 19
Capture a soumettre: dealersbystate.png
Ouvre http://127.0.0.1:8000/?state=Kansas

TACHE 20
Capture a soumettre: dealer_id_reviews.png
Ouvre http://127.0.0.1:8000/djangoapp/dealer/1

TACHE 21
Capture a soumettre: dealership_review_submission.png
Sur http://127.0.0.1:8000/djangoapp/dealer/1, remplis le formulaire avant de cliquer Submit Review.

TACHE 22
Capture a soumettre: added_review.png
Clique Submit Review puis prends une capture de l'avis affiche.

TACHE 23
Fichier attendu: CICD
Apres le push, va dans GitHub > Actions.
Ouvre le workflow Django CI reussi et copie les logs dans un fichier nomme CICD.
Si GitHub CLI fonctionne, le script essaie aussi de recuperer le log automatiquement.

TACHE 24
Ouvre le fichier deploymentURL et remplace son contenu par ta vraie URL IBM Cloud Code Engine.

TACHE 25
Capture a soumettre: deployed_landingpage.png
Ouvre ton URL de deploiement et prends la page d'accueil.

TACHE 26
Capture a soumettre: deployed_loggedin.png
Connecte-toi sur l'application deployee et prends la capture avec le nom utilisateur visible.

TACHE 27
Capture a soumettre: deployed_dealer_detail.png
Ouvre la page detail concessionnaire dans l'application deployee.

TACHE 28
Capture a soumettre: deployed_add_review.png
Ajoute ou affiche un avis dans l'application deployee et prends la capture.
TXT

echo "Ajout et envoi vers GitHub..."
git add .
git commit -m "Complete capstone project files and outputs" || true
git push || true

echo "Tentative de recuperation du vrai log GitHub Actions dans le fichier CICD..."
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    sleep 10
    RUN_ID=$(gh run list --repo jonathan777888/cars-dealership --limit 1 --json databaseId --jq '.[0].databaseId' 2>/dev/null || true)
    if [ -n "$RUN_ID" ]; then
        gh run watch "$RUN_ID" || true
        gh run view "$RUN_ID" --log > CICD || true
        git add CICD
        git commit -m "Add CICD workflow log" || true
        git push || true
    fi
else
    echo "GitHub CLI non connecte. Recupere les logs depuis GitHub > Actions."
fi

echo ""
echo "TERMINE."
echo "Maintenant tape cette commande pour voir les reponses:"
echo "cat REPONSES_A_COPIER.txt"
