from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required
from ..models.job import Job
from ..services.storage import save_file
from .. import socketio
from ..tasks.celery_worker import cpu_enhance_task  # Direct import

jobs_bp = Blueprint('jobs', __name__)
@jobs_bp.route('/health-check', methods=['GET'])
def health_check():
    return jsonify(status="OK"), 200
@jobs_bp.route('/jobs', methods=['POST'])
@jwt_required()
def create_job():
    if 'image' not in request.files:
        return jsonify(error="No image uploaded"), 400

    file = request.files['image']
    job_id = save_file(file)
    job = Job.create(job_id, status='uploaded')

    # Trigger Celery task
    cpu_enhance_task.delay(job_id)

    # Notify frontend via WebSocket
    socketio.emit('status_update', {'job_id': job_id, 'status': 'uploaded'})
    return jsonify(job_id=job_id), 201  # Key is 'job_id'
