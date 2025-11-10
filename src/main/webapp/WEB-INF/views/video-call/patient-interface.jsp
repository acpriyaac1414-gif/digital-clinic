<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .video-container {
            background: #1a1a1a;
            min-height: 100vh;
            color: white;
        }
        .video-main {
            height: 70vh;
            background: #2d2d2d;
            border-radius: 10px;
            position: relative;
        }
        .video-remote {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 10px;
        }
        .video-local {
            position: absolute;
            bottom: 20px;
            right: 20px;
            width: 200px;
            height: 150px;
            border: 2px solid #007bff;
            border-radius: 8px;
            background: #000;
        }
        .controls-container {
            background: rgba(45, 45, 45, 0.9);
            border-radius: 10px;
            padding: 1rem;
            margin-top: 1rem;
        }
        .control-btn {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            border: none;
            margin: 0 10px;
            font-size: 1.2rem;
            transition: all 0.3s;
        }
        .control-btn:hover {
            transform: scale(1.1);
        }
        .btn-mute {
            background: #6c757d;
            color: white;
        }
        .btn-mute.active {
            background: #dc3545;
        }
        .btn-video {
            background: #6c757d;
            color: white;
        }
        .btn-video.active {
            background: #dc3545;
        }
        .btn-call {
            background: #dc3545;
            color: white;
        }
        .btn-call.active {
            background: #28a745;
        }
        .patient-info {
            background: rgba(0, 123, 255, 0.1);
            border-radius: 10px;
            padding: 1rem;
        }
        .consultation-timer {
            font-size: 1.5rem;
            font-weight: bold;
            color: #28a745;
        }
        .chat-container {
            background: #2d2d2d;
            border-radius: 10px;
            height: 400px;
            display: flex;
            flex-direction: column;
        }
        .chat-messages {
            flex: 1;
            overflow-y: auto;
            padding: 1rem;
        }
        .chat-input {
            border-top: 1px solid #444;
            padding: 1rem;
        }
    </style>
</head>
<body class="video-container">
    <div class="container-fluid py-4">
        <div class="row">
            <!-- Main Video Area -->
            <div class="col-lg-9">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h4 class="mb-0">
                            <i class="fas fa-video me-2 text-primary"></i>
                            Video Consultation with 
                            <c:if test="${not empty consultation.appointment.doctor}">
                                Dr. ${consultation.appointment.doctor.user.fullName}
                            </c:if>
                        </h4>
                        <p class="text-muted mb-0">
                            ${consultation.appointment.doctor.specialization}
                        </p>
                    </div>
                    <div class="consultation-timer" id="consultationTimer">
                        00:00
                    </div>
                </div>

                <!-- Video Streams -->
                <div class="video-main mb-3">
                    <!-- Remote Video (Doctor) -->
                    <div class="video-remote" id="remoteVideo">
                        <div class="h-100 d-flex align-items-center justify-content-center">
                            <div class="text-center">
                                <i class="fas fa-user-md fa-4x text-muted mb-3"></i>
                                <h5 class="text-muted">Waiting for doctor to join...</h5>
                                <div class="spinner-border text-primary" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Local Video (Patient) -->
                    <div class="video-local" id="localVideo">
                        <div class="h-100 d-flex align-items-center justify-content-center bg-dark">
                            <i class="fas fa-user fa-2x text-muted"></i>
                        </div>
                    </div>

                    <!-- Connection Status -->
                    <div class="position-absolute top-0 end-0 m-3">
                        <span class="badge bg-success" id="connectionStatus">
                            <i class="fas fa-wifi me-1"></i>Connected
                        </span>
                    </div>
                </div>

                <!-- Controls -->
                <div class="controls-container">
                    <div class="d-flex justify-content-center align-items-center">
                        <button class="control-btn btn-mute" id="muteBtn" onclick="toggleMute()">
                            <i class="fas fa-microphone"></i>
                        </button>
                        
                        <button class="control-btn btn-video" id="videoBtn" onclick="toggleVideo()">
                            <i class="fas fa-video"></i>
                        </button>
                        
                        <button class="control-btn btn-call" id="callBtn" onclick="endCall()">
                            <i class="fas fa-phone-slash"></i>
                        </button>
                        
                        <button class="control-btn btn-info" onclick="showPatientInfo()" 
                                style="background: #17a2b8; color: white;">
                            <i class="fas fa-info"></i>
                        </button>
                        
                        <button class="control-btn btn-chat" onclick="toggleChat()" 
                                style="background: #ffc107; color: black;">
                            <i class="fas fa-comments"></i>
                        </button>
                    </div>
                </div>

                <!-- Consultation Info -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="patient-info">
                            <h6><i class="fas fa-user me-2"></i>Your Information</h6>
                            <p class="mb-1"><strong>Name:</strong> ${patient.user.fullName}</p>
                            <p class="mb-1"><strong>Age:</strong> ${patient.age} years</p>
                            <p class="mb-0"><strong>Symptoms:</strong> ${consultation.appointment.symptoms}</p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="patient-info">
                            <h6><i class="fas fa-stethoscope me-2"></i>Consultation Details</h6>
                            <p class="mb-1"><strong>Started:</strong> <span id="startTime">Just now</span></p>
                            <p class="mb-1"><strong>Duration:</strong> <span id="duration">00:00</span></p>
                            <p class="mb-0"><strong>Type:</strong> Video Consultation</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="col-lg-3">
                <!-- Chat Panel -->
                <div class="chat-container mb-4">
                    <div class="chat-header bg-primary text-white p-3 rounded-top">
                        <h6 class="mb-0">
                            <i class="fas fa-comments me-2"></i>Chat
                        </h6>
                    </div>
                    <div class="chat-messages" id="chatMessages">
                        <div class="text-center text-muted mt-3">
                            <i class="fas fa-comment-slash fa-2x mb-2"></i>
                            <p>No messages yet</p>
                        </div>
                    </div>
                    <div class="chat-input">
                        <div class="input-group">
                            <input type="text" class="form-control" id="chatInput" 
                                   placeholder="Type a message...">
                            <button class="btn btn-primary" onclick="sendMessage()">
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Tools & Resources -->
                <div class="card bg-dark border-0 mb-3">
                    <div class="card-body">
                        <h6 class="card-title">
                            <i class="fas fa-tools me-2"></i>Quick Tools
                        </h6>
                        <div class="d-grid gap-2">
                            <button class="btn btn-outline-info btn-sm" onclick="shareScreen()">
                                <i class="fas fa-desktop me-1"></i>Share Screen
                            </button>
                            <button class="btn btn-outline-warning btn-sm" onclick="takeSnapshot()">
                                <i class="fas fa-camera me-1"></i>Take Snapshot
                            </button>
                            <button class="btn btn-outline-success btn-sm" onclick="showPrescription()">
                                <i class="fas fa-file-prescription me-1"></i>View Prescription
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Emergency Help -->
                <div class="card bg-danger bg-opacity-25 border-0">
                    <div class="card-body">
                        <h6 class="card-title">
                            <i class="fas fa-first-aid me-2"></i>Emergency Help
                        </h6>
                        <p class="small mb-2">If you need immediate medical assistance:</p>
                        <div class="d-grid">
                            <button class="btn btn-outline-danger btn-sm" onclick="emergencyHelp()">
                                <i class="fas fa-ambulance me-1"></i>Emergency Support
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Patient Info Modal -->
    <div class="modal fade" id="patientInfoModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-user me-2"></i>Patient Information
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <strong>Personal Details:</strong>
                        <p class="mb-1">Name: ${patient.user.fullName}</p>
                        <p class="mb-1">Age: ${patient.age} years</p>
                        <p class="mb-1">Gender: ${patient.gender}</p>
                        <p class="mb-0">Blood Group: ${patient.bloodGroup}</p>
                    </div>
                    <div class="mb-3">
                        <strong>Current Symptoms:</strong>
                        <p class="mb-0">${consultation.appointment.symptoms}</p>
                    </div>
                    <c:if test="${not empty patient.medicalHistory}">
                        <div>
                            <strong>Medical History:</strong>
                            <p class="mb-0 small">${patient.medicalHistory}</p>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Prescription Modal -->
    <div class="modal fade" id="prescriptionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-file-prescription me-2"></i>Prescription
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div id="prescriptionContent">
                        <c:if test="${not empty consultation.appointment.prescription}">
                            <div class="prescription-box bg-dark border rounded p-3">
                                ${consultation.appointment.prescription}
                            </div>
                        </c:if>
                        <c:if test="${empty consultation.appointment.prescription}">
                            <div class="text-center text-muted py-4">
                                <i class="fas fa-file-medical fa-3x mb-3"></i>
                                <p>No prescription has been provided yet.</p>
                            </div>
                        </c:if>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="printPrescription()">
                        <i class="fas fa-print me-1"></i>Print
                    </button>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Consultation timer
        let startTime = new Date();
        let timerInterval = setInterval(updateTimer, 1000);

        function updateTimer() {
            const now = new Date();
            const diff = Math.floor((now - startTime) / 1000);
            const minutes = Math.floor(diff / 60);
            const seconds = diff % 60;
            
            document.getElementById('consultationTimer').textContent = 
                `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
            document.getElementById('duration').textContent = 
                `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
        }

        // Control functions
        let isMuted = false;
        let isVideoOn = true;

        function toggleMute() {
            isMuted = !isMuted;
            const btn = document.getElementById('muteBtn');
            btn.classList.toggle('active', isMuted);
            btn.innerHTML = isMuted ? '<i class="fas fa-microphone-slash"></i>' : '<i class="fas fa-microphone"></i>';
            
            // In real app, this would mute/unmute the audio track
            console.log('Audio ' + (isMuted ? 'muted' : 'unmuted'));
        }

        function toggleVideo() {
            isVideoOn = !isVideoOn;
            const btn = document.getElementById('videoBtn');
            btn.classList.toggle('active', !isVideoOn);
            btn.innerHTML = isVideoOn ? '<i class="fas fa-video"></i>' : '<i class="fas fa-video-slash"></i>';
            
            // In real app, this would enable/disable the video track
            const localVideo = document.getElementById('localVideo');
            if (isVideoOn) {
                localVideo.innerHTML = '<div class="h-100 d-flex align-items-center justify-content-center bg-dark"><i class="fas fa-user fa-2x text-muted"></i></div>';
            } else {
                localVideo.innerHTML = '<div class="h-100 d-flex align-items-center justify-content-center bg-danger"><i class="fas fa-video-slash fa-2x text-white"></i></div>';
            }
            
            console.log('Video ' + (isVideoOn ? 'enabled' : 'disabled'));
        }

        function endCall() {
            if (confirm('Are you sure you want to end the consultation?')) {
                // In real app, this would close the connection and redirect
                window.location.href = '/appointments/${consultation.appointment.id}';
            }
        }

        function showPatientInfo() {
            const modal = new bootstrap.Modal(document.getElementById('patientInfoModal'));
            modal.show();
        }

        function toggleChat() {
            const chatContainer = document.querySelector('.chat-container');
            chatContainer.style.display = chatContainer.style.display === 'none' ? 'flex' : 'none';
        }

        function sendMessage() {
            const input = document.getElementById('chatInput');
            const message = input.value.trim();
            
            if (message) {
                const chatMessages = document.getElementById('chatMessages');
                
                // Clear initial state if present
                if (chatMessages.querySelector('.text-center')) {
                    chatMessages.innerHTML = '';
                }
                
                // Add new message
                const messageDiv = document.createElement('div');
                messageDiv.className = 'mb-2';
                messageDiv.innerHTML = `
                    <div class="d-flex justify-content-end">
                        <div class="bg-primary text-white rounded p-2" style="max-width: 80%;">
                            <small class="d-block">You</small>
                            ${message}
                            <small class="d-block text-end mt-1" style="opacity: 0.7;">
                                ${new Date().toLocaleTimeString()}
                            </small>
                        </div>
                    </div>
                `;
                
                chatMessages.appendChild(messageDiv);
                chatMessages.scrollTop = chatMessages.scrollHeight;
                input.value = '';
                
                // In real app, send message via WebSocket
                console.log('Sending message:', message);
            }
        }

        function shareScreen() {
            alert('In full implementation, this would start screen sharing.');
        }

        function takeSnapshot() {
            alert('In full implementation, this would take a snapshot of the video.');
        }

        function showPrescription() {
            const modal = new bootstrap.Modal(document.getElementById('prescriptionModal'));
            modal.show();
        }

        function emergencyHelp() {
            if (confirm('Are you experiencing a medical emergency? This will alert emergency services.')) {
                window.location.href = '/emergency';
            }
        }

        function printPrescription() {
            window.print();
        }

        // Simulate doctor joining after 5 seconds
        setTimeout(() => {
            const remoteVideo = document.getElementById('remoteVideo');
            remoteVideo.innerHTML = `
                <div class="h-100 d-flex align-items-center justify-content-center bg-success bg-opacity-25">
                    <div class="text-center">
                        <i class="fas fa-user-md fa-4x text-success mb-3"></i>
                        <h5 class="text-success">Dr. ${consultation.appointment.doctor.user.fullName} Joined</h5>
                        <p class="text-muted">Consultation in progress...</p>
                    </div>
                </div>
            `;
        }, 5000);

        // Handle page unload
        window.addEventListener('beforeunload', function() {
            // In real app, this would properly end the consultation
            console.log('Consultation ended by patient');
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>