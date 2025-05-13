from celery import Celery
from ..models.job import Job


# ✅ Create a Celery instance (but don't configure it yet)
celery = Celery(__name__)

def create_celery(app):
    # ✅ Configure the existing Celery instance with Flask settings
    celery.conf.update(
        broker_url=app.config['CELERY_BROKER_URL'],
        result_backend=app.config['CELERY_RESULT_BACKEND'],
        broker_connection_retry_on_startup=True
    )
    
    # ✅ Add Flask context
    class ContextTask(celery.Task):
        def __call__(self, *args, **kwargs):
            with app.app_context():
                return self.run(*args, **kwargs)

    celery.Task = ContextTask
    
@celery.task(name='cpu_enhance')
def cpu_enhance_task(job_id):
    from .. import socketio
    job = Job.get(job_id)
    print(f"Processing job: {job_id}")
    if not job:
        return

    try:
        # Simulate image processing
        processed_path = f"processed_{job.job_id}.jpg"
        
        # Update job status and result URL
        job.status = 'processed'
        job.result_url = f"http://10.0.2.2:5000/static/{processed_path}"
        
        # Notify via Socket.IO
        socketio.emit('status_update', {
            'job_id': job_id,
            'status': 'processed',
            'result_url': job.result_url
        })
        print(f"Job {job_id} processed!")
    except Exception as e:
        job.status = 'failed'
        socketio.emit('status_update', {
            'job_id': job_id,
            'status': 'failed'
        })