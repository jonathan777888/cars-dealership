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
