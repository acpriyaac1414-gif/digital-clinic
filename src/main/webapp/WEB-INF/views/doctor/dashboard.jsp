<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>${title != null ? title : 'Doctor Dashboard - Digital Clinic'}</title>

    <!-- Bootstrap + FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background-color: #f5f6fa;
            font-family: 'Segoe UI', sans-serif;
        }

        .navbar {
            background-color: #2e7d32;
        }

        .sidebar {
            background-color: #ffffff;
            min-height: 100vh;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        }

        .sidebar .nav-link {
            color: #333;
            padding: 12px 18px;
            border-radius: 6px;
            transition: all 0.3s;
        }

        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background-color: #28a745;
            color: white;
        }

        .banner {
            background: url('https://img.freepik.com/free-photo/confident-male-doctor-hospital_329181-11605.jpg') no-repeat center center;
            background-size: cover;
            border-radius: 12px;
            color: white;
            padding: 60px 30px;
            position: relative;
        }

        .banner-overlay {
            background: rgba(0, 0, 0, 0.5);
            border-radius: 12px;
            padding: 40px;
        }

        .stats-card {
            border-radius: 10px;
            color: white;
            transition: transform 0.3s ease;
        }

        .stats-card:hover {
            transform: translateY(-5px);
        }

        .card-header {
            font-weight: 600;
        }

        .verification-badge {
            background-color: #43a047;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            color: white;
        }

        .quick-actions .btn {
            text-align: left;
        }
    </style>
</head>

<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand fw-bold" href="/doctor/dashboard">
                <i class="fas fa-user-md me-2"></i> Digital Clinic - Doctor
            </a>
            <div class="ms-auto text-white">
                Welcome, Dr. ${user.fullName} |
                <a href="/doctor/profile" class="text-white ms-3"><i class="fas fa-user"></i> Profile</a>
                <a href="/logout" class="text-white ms-3"><i class="fas fa-sign-out-alt"></i> Logout</a>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar py-3">
                <h5 class="text-center mb-4">Doctor Panel</h5>
                <nav class="nav flex-column">
                    <a class="nav-link active" href="/doctor/dashboard"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</a>
                    <a class="nav-link" href="/doctor/profile"><i class="fas fa-user me-2"></i>My Profile</a>
                    <a class="nav-link" href="/doctor/appointments"><i class="fas fa-calendar-check me-2"></i>Appointments</a>
                    <a class="nav-link" href="/doctor/patients"><i class="fas fa-users me-2"></i>My Patients</a>
                    <a class="nav-link" href="/doctor/consultations"><i class="fas fa-video me-2"></i>Video Consultations</a>
                    <a class="nav-link" href="/doctor/prescriptions"><i class="fas fa-file-prescription me-2"></i>Prescriptions</a>
                    <a class="nav-link" href="/doctor/schedule"><i class="fas fa-clock me-2"></i>Schedule</a>
                </nav>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 p-4">
                <!-- Banner with Doctor Image -->
                <div class="banner mb-4">
                    <div class="banner-overlay">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h2 class="fw-bold">Welcome, Dr. ${user.fullName}</h2>
                                <p class="lead mb-0">Provide quality healthcare to rural communities through our platform.</p>
                            </div>
                            <div>
                                <span class="verification-badge">
                                    <i class="fas fa-check-circle me-1"></i>
                                    Verified Doctor
                                </span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Stats -->
                <div class="row mb-4">
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card bg-primary">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>${todayAppointments}</h4>
                                        <p>Today's Appointments</p>
                                    </div>
                                    <i class="fas fa-calendar-day fa-2x"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card bg-info">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>${totalPatients}</h4>
                                        <p>Total Patients</p>
                                    </div>
                                    <i class="fas fa-users fa-2x"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card bg-warning">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>${pendingConsultations}</h4>
                                        <p>Pending Consultations</p>
                                    </div>
                                    <i class="fas fa-video fa-2x"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stats-card bg-success">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h4>₹${monthlyEarnings}</h4>
                                        <p>Monthly Earnings</p>
                                    </div>
                                    <i class="fas fa-rupee-sign fa-2x"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Professional Info + Quick Actions -->
                <div class="row">
                    <div class="col-md-6 mb-4">
                        <div class="card">
                            <div class="card-header bg-success text-white">
                                <i class="fas fa-info-circle me-2"></i> Professional Information
                            </div>
                            <div class="card-body">
                                <c:if test="${not empty doctor.specialization}">
                                    <p><strong>Specialization:</strong> ${doctor.specialization}</p>
                                    <p><strong>Qualification:</strong> ${doctor.qualification}</p>
                                    <p><strong>Experience:</strong> ${doctor.experienceYears} years</p>
                                    <p><strong>Consultation Fee:</strong> ₹${doctor.consultationFee}</p>
                                    <p><strong>License Number:</strong> <code>${doctor.licenseNumber}</code></p>
                                    <c:if test="${not empty doctor.hospitalAffiliation}">
                                        <p><strong>Hospital:</strong> ${doctor.hospitalAffiliation}</p>
                                    </c:if>
                                    <a href="/doctor/profile/edit" class="btn btn-outline-success btn-sm">
                                        <i class="fas fa-edit me-1"></i> Update Information
                                    </a>
                                </c:if>
                                <c:if test="${empty doctor.specialization}">
                                    <div class="text-center py-3">
                                        <i class="fas fa-stethoscope fa-3x text-muted mb-3"></i>
                                        <p class="text-muted">Complete your profile to start receiving patients.</p>
                                        <a href="/doctor/profile/edit" class="btn btn-success">
                                            <i class="fas fa-user-plus me-1"></i> Complete Profile
                                        </a>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6 mb-4">
                        <div class="card">
                            <div class="card-header bg-primary text-white">
                                <i class="fas fa-rocket me-2"></i> Quick Actions
                            </div>
                            <div class="card-body quick-actions">
                                <div class="d-grid gap-2">
                                    <a href="/doctor/appointments" class="btn btn-outline-primary"><i class="fas fa-calendar-check me-2"></i> View Appointments</a>
                                    <a href="/doctor/schedule" class="btn btn-outline-success"><i class="fas fa-clock me-2"></i> Manage Schedule</a>
                                    <a href="/doctor/consultations" class="btn btn-outline-info"><i class="fas fa-video me-2"></i> Video Consultations</a>
                                    <a href="/doctor/patients" class="btn btn-outline-warning"><i class="fas fa-users me-2"></i> My Patients</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Today's Appointments -->
                <div class="card mb-5">
                    <div class="card-header bg-info text-white">
                        <i class="fas fa-calendar-alt me-2"></i> Today's Appointments
                    </div>
                    <div class="card-body text-center py-4">
                        <i class="fas fa-calendar-times fa-2x text-muted mb-3"></i>
                        <h6 class="text-muted">No appointments scheduled for today</h6>
                        <p class="text-muted small">Appointments will appear once patients book consultations.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap Script -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

