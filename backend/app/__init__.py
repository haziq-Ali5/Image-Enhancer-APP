from flask import Flask
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from flask_socketio import SocketIO
from .config import Config
 
socketio = SocketIO(cors_allowed_origins="*")
jwt = JWTManager()

def create_app():
    app = Flask(__name__, static_folder='static')
    app.config.from_object(Config)
    Config.init_app(app)

    CORS(app, resources={r"/*": {"origins": "*"}})
    jwt.init_app(app)
    socketio.init_app(app)
    from .tasks.celery_worker import  create_celery 
    # ✅ Initialize Celery
    create_celery(app)  # Configures the global `celery` instance
    
    # Register blueprints
    from .routes.auth import auth_bp
    from .routes.jobs import jobs_bp
    app.register_blueprint(auth_bp)
    app.register_blueprint(jobs_bp)
    @app.before_first_request
    def print_routes():
        print("Registered routes:")
        for rule in app.url_map.iter_rules():
            print(f"- {rule}")

    return app, socketio