# Image-Enhancer-APP

**Frontend Server(Flutter):**
Install flutter and add it to enviornment along with dart (inside flutter folder).
Move to project directory and run command : flutter pub get
Then to run frontend: run main.dart and select chrome.

**Backend Server(Flask):**
Open backend folder.
Make a new python enviornment and add then run requirements.txt using command: pip install -r requirements.txt
Then run the redis server with command: redis-server
Then run run.py file in another terminal.
Then run the celery server  using the command: celery -A app.celery_app.celery worker --loglevel=info
