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
            border: 2px solid #28a745;
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
            background: #28a745;
            color: white;
        }
        .btn-call.active {
            background: #dc3545;
        }
        .patient-details {
            background: rgba(40, 167, 69, 0.1);
            border-radius: 10px;
            padding: 1rem;
        }
        .consultation-timer {
            font-size: 1.5rem;
            font-weight: bold;
            color: #28a745;
        }
        .medical-tools {
            background: #2d2d2d;
            border-radius: 10px;
            padding: 1rem;
        }
        .tool-btn {
            margin: 5px;
            padding: 10px;
            border: 1px solid #444;
            border-radius: 5px;
            background: #3d3d3d;
            color: white;
            transition: all 0.3s;
        }
        .tool-btn:hover {
            background: #007bff;
            border-color: #007bff;
        }
        .prescription-editor {
            background: #2d2d2d;
            border-radius: 10px;
            padding: 1rem;
            height: 300px;
        }
    </style>
</head>
<body class="video-container">
    <div class="container-fluid py-4">
        <div class="row">
            <!-- Main Video Area -->
            <div class="col-lg-8">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h4 class="mb-0">
                            <i class="fas fa-user-md me-2 text-success"></i>
                            Consultation with ${patient.user.fullName}
                        </h4>
                        <p class="text-muted mb-0">
                            Video Consultation - ${consultation.appointment.doctor.specialization}
                        </p>
                    </div>
                    <div class="consultation-timer" id="consultationTimer">
                        00:00
                    </div>
                </div>

                <!-- Video Streams -->
                <div class="video-main mb-3">
                    <!-- Remote Video (Patient) -->
                    <div class="video-remote" id="remoteVideo">
                        <div class="h-100 d-flex align-items-center justify-content-center">
                            <div class="text-center">
                                <i class="fas fa-user fa-4x text-muted mb-3"></i>
                                <h5 class="text-muted">Patient Video Feed</h5>
                                <div class="spinner-border text-success" role="status">
                                    <span class="visually-hidden">Loading...</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Local Video (Doctor) -->
                    <div class="video-local" id="localVideo">
                        <div class="h-100 d-flex align-items-center justify-content-center bg-dark">
                            <i class="fas fa-user-md fa-2x text-muted"></i>
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
                        
                        <button class="control-btn btn-call" id="callBtn" onclick="endConsultation()">
                            <i class="fas fa-phone-slash"></i>
                        </button>
                        
                        <button class="control-btn" onclick="showPatientDetails()" 
                                style="background: #17a2b8; color: white;">
                            <i class="fas fa-file-medical"></i>
                        </button>
                        
                        <button class="control-btn" onclick="togglePrescription()" 
                                style="background: #ffc107; color: black;">
                            <i class="fas fa-file-prescription"></i>
                        </button>
                    </div>
                </div>

                <!-- Patient Details -->
                <div class="row mt-4">
                    <div class="col-md-6">
                        <div class="patient-details">
                            <h6><i class="fas fa-user me-2"></i>Patient Information</h6>
                            <p class="mb-1"><strong>Name:</strong> ${patient.user.fullName}</p>
                            <p class="mb-1"><strong>Age:</strong> ${patient.age} years</p>
                            <p class="mb-1"><strong>Gender:</strong> ${patient.gender}</p>
                            <p class="mb-0"><strong>Blood Group:</strong> ${patient.bloodGroup}</p>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="patient-details">
                            <h6><i class="fas fa-stethoscope me-2"></i>Current Symptoms</h6>
                            <p class="mb-0">${consultation.appointment.symptoms}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Sidebar -->
            <div class="col-lg-4">
                <!-- Medical Tools -->
                <div class="medical-tools mb-4">
                    <h6 class="mb-3">
                        <i class="fas fa-tools me-2"></i>Medical Tools
                    </h6>
                    <div class="row g-2">
                        <div class="col-6">
                            <button class="tool-btn w-100" onclick="vitalSigns()">
                                <i class="fas fa-heartbeat me-1"></i>Vital Signs
                            </button>
                        </div>
                        <div class="col-6">
                            <button class="tool-btn w-100" onclick="medicalHistory()">
                                <i class="fas fa-history me-1"></i>History
                            </button>
                        </div>
                        <div class="col-6">
                            <button class="tool-btn w-100" onclick="diagnosis()">
                                <i class="fas fa-diagnoses me-1"></i>Diagnosis
                            </button>
                        </div>
                        <div class="col-6">
                            <button class="tool-btn w-100" onclick="labTests()">
                                <i class="fas fa-flask me-1"></i>Lab Tests
                            </button>
                        </div>
                        <div class="col-6">
                            <button class="tool-btn w-100" onclick="shareScreen()">
                                <i class="fas fa-desktop me-1"></i>Share Screen
                            </button>
                        </div>
                        <div class="col-6">
                            <button class="tool-btn w-100" onclick="recordSession()">
                                <i class="fas fa-record-vinyl me-1"></i>Record
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Prescription Editor -->
                <div class="prescription-editor mb-4">
                    <h6 class="mb-3">
                        <i class="fas fa-file-prescription me-2"></i>Prescription
                    </h6>
                    <textarea class="form-control bg-dark text-white border-0" 
                              id="prescriptionText" rows="8" 
                              placeholder="Enter prescription details, medications, dosage, instructions..."></textarea>
                    <div class="mt-3">
                        <button class="btn btn-success btn-sm me-2" onclick="savePrescription()">
                            <i class="fas fa-save me-1"></i>Save
                        </button>
                        <button class="btn btn-primary btn-sm" onclick="printPrescription()">
                            <i class="fas fa-print me-1"></i>Print
                        </button>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="card bg-dark border-0">
                    <div class="card-body">
                        <h6 class="card-title">
                            <i class="fas fa-bolt me-2"></i>Quick Actions
                        </h6>
                        <div class="d-grid gap-2">
                            <button class="btn btn-outline-warning btn-sm" onclick="scheduleFollowup()">
                                <i class="fas fa-calendar-plus me-1"></i>Schedule Follow-up
                            </button>
                            <button class="btn btn-outline-info btn-sm" onclick="referToSpecialist()">
                                <i class="fas fa-user-md me-1"></i>Refer to Specialist
                            </button>
                            <button class="btn btn-outline-danger btn-sm" onclick="emergencyProtocol()">
                                <i class="fas fa-ambulance me-1"></i>Emergency Protocol
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Patient Details Modal -->
    <div class="modal fade" id="patientDetailsModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content bg-dark text-white">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-file-medical me-2"></i>Complete Patient Details
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Personal Information</h6>
                            <p><strong>Name:</strong> ${patient.user.fullName}</p>
                            <p><strong>Age:</strong> ${patient.age} years</p>
                            <p><strong>Gender:</strong> ${patient.gender}</p>
                            <p><strong>Blood Group:</strong> ${patient.bloodGroup}</p>
                            <p><strong>Height:</strong> ${patient.height} cm</p>
                            <p><strong>Weight:</strong> ${patient.weight} kg</p>
                        </div>
                        <div class="col-md-6">
                            <h6>Contact Information</h6>
                            <p><strong>Phone:</strong> ${patient.user.phone}</p>
                            <p><strong>Email:</strong> ${patient.user.email}</p>
                            <p><strong>Address:</strong> ${patient.user.address}</p>
                        </div>
                    </div>
                    
                    <div class="mt-3">
                        <h6>Medical History</h6>
                        <div class="border rounded p-3 bg-dark">
                            <c:if test="${not empty patient.medicalHistory}">
                                ${patient.medicalHistory}
                            </c:if>
                            <c:if test="${empty patient.medicalHistory}">
                                <p class="text-muted mb-0">No medical history recorded.</p>
                            </c:if>
                        </div>
                    </div>
                    
                    <div class="row mt-3">
                        <div class="col-md-6">
                            <h6>Allergies</h6>
                            <div class="border rounded p-3 bg-dark">
                                <c:if test="${not empty patient.allergies}">
                                    ${patient.allergies}
                                </c:if>
                                <c:if test="${empty patient.allergies}">
                                    <p class="text-muted mb-0">No known allergies.</p>
                                </c:if>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <h6>Current Medications</h6>
                            <div class="border rounded p-3 bg-dark">
                                <c:if test="${not empty patient.currentMedications}">
                                    ${patient.currentMedications}
                                </c:if>
                                <c:if test="${empty patient.currentMedications}">
                                    <p class="text-muted mb-0">No current medications.</p>
                                </c:if>
                            </div>
                        </div>
                    </div>
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
        }

        // Control functions
        let isMuted = false;
        let isVideoOn = true;

        function toggleMute() {
            isMuted = !isMuted;
            const btn = document.getElementById('muteBtn');
            btn.classList.toggle('active', isMuted);
            btn.innerHTML = isMuted ? '<i class="fas fa-microphone-slash"></i>' : '<i class="fas fa-microphone"></i>';
            console.log('Audio ' + (isMuted ? 'muted' : 'unmuted'));
        }

        function toggleVideo() {
            isVideoOn = !isVideoOn;
            const btn = document.getElementById('videoBtn');
            btn.classList.toggle('active', !isVideoOn);
            btn.innerHTML = isVideoOn ? '<i class="fas fa-video"></i>' : '<i class="fas fa-video-slash"></i>';
            
            const localVideo = document.getElementById('localVideo');
            if (isVideoOn) {
                localVideo.innerHTML = '<div class="h-100 d-flex align-items-center justify-content-center bg-dark"><i class="fas fa-user-md fa-2x text-muted"></i></div>';
            } else {
                localVideo.innerHTML = '<div class="h-100 d-flex align-items-center justify-content-center bg-danger"><i class="fas fa-video-slash fa-2x text-white"></i></div>';
            }
            
            console.log('Video ' + (isVideoOn ? 'enabled' : 'disabled'));
        }

        function endConsultation() {
            if (confirm('Are you sure you want to end the consultation?')) {
                const prescription = document.getElementById('prescriptionText').value;
                
                // Submit form to complete consultation
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '/video-call/${consultation.id}/complete';
                
                const prescriptionInput = document.createElement('input');
                prescriptionInput.type = 'hidden';
                prescriptionInput.name = 'prescription';
                prescriptionInput.value = prescription;
                form.appendChild(prescriptionInput);
                
                const notesInput = document.createElement('input');
                notesInput.type = 'hidden';
                notesInput.name = 'notes';
                notesInput.value = 'Consultation completed via video call';
                form.appendChild(notesInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }

        function showPatientDetails() {
            const modal = new bootstrap.Modal(document.getElementById('patientDetailsModal'));
            modal.show();
        }

        function togglePrescription() {
            const editor = document.querySelector('.prescription-editor');
            editor.style.display = editor.style.display === 'none' ? 'block' : 'none';
        }

        // Medical tools functions
        function vitalSigns() {
            alert('Vital Signs Tool: In full implementation, this would show patient vital signs monitoring.');
        }

        function medicalHistory() {
            showPatientDetails();
        }

        function diagnosis() {
            alert('Diagnosis Tool: In full implementation, this would provide diagnosis assistance tools.');
        }

        function labTests() {
            alert('Lab Tests: In full implementation, this would allow ordering lab tests.');
        }

        function shareScreen() {
            alert('Screen Sharing: In full implementation, this would start screen sharing.');
        }

        function recordSession() {
            alert('Session Recording: In full implementation, this would start recording the consultation.');
        }

        function savePrescription() {
            const prescription = document.getElementById('prescriptionText').value;
            if (prescription.trim()) {
                alert('Prescription saved successfully!');
                // In real app, this would save to the database
            } else {
                alert('Please enter prescription details.');
            }
        }

        function printPrescription() {
            window.print();
        }

        function scheduleFollowup() {
            alert('Follow-up Scheduling: In full implementation, this would open scheduling interface.');
        }

        function referToSpecialist() {
            alert('Specialist Referral: In full implementation, this would open referral system.');
        }

        function emergencyProtocol() {
            if (confirm('Initiate emergency protocol? This will alert emergency services and save consultation recording.')) {
                alert('Emergency protocol initiated!');
                // In real app, this would trigger emergency procedures
            }
        }

        // Simulate patient video feed
        setTimeout(() => {
            const remoteVideo = document.getElementById('remoteVideo');
            remoteVideo.innerHTML = `
                <div class="h-100 d-flex align-items-center justify-content-center bg-primary bg-opacity-25">
                    <div class="text-center">
                        <i class="fas fa-user fa-4x text-primary mb-3"></i>
                        <h5 class="text-primary">${patient.user.fullName}</h5>
                        <p class="text-muted">Video consultation in progress</p>
                    </div>
                </div>
            `;
        }, 3000);

        // Auto-save prescription every 2 minutes
        setInterval(() => {
            const prescription = document.getElementById('prescriptionText').value;
            if (prescription.trim()) {
                console.log('Auto-saving prescription...');
                // In real app, this would auto-save to prevent data loss
            }
        }, 120000);

        // Handle page unload
        window.addEventListener('beforeunload', function(e) {
            const prescription = document.getElementById('prescriptionText').value;
            if (prescription.trim()) {
                e.preventDefault();
                e.returnValue = 'You have unsaved prescription changes. Are you sure you want to leave?';
            }
        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>