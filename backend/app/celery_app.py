from app import create_app
from app.tasks.celery_worker import create_celery

flask_app, _ = create_app()
celery = create_celery(flask_app)