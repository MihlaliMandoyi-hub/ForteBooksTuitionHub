<%@ Page Title="Forte Books & Tuition Hub" Language="C#" AutoEventWireup="true" CodeBehind="Landing.aspx.cs" Inherits="ForteBooksTuitionHub.Landing" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Forte Books &amp; Tuition Hub — Tutoring &amp; Book Rentals</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <link href="LandingStyle.css" rel="stylesheet" />
</head>
<body class="landing-body">
    <form id="form1" runat="server">

        <nav class="landing-nav" id="landingNav">
            <div class="landing-nav-brand">
                <img src="Images/ufh-logo.png" alt="UFH Crest" />
                <span>Forte Books &amp; Tuition Hub</span>
            </div>
            <div class="landing-nav-links">
                <a href="About.aspx" class="nav-link-ghost">About</a>
                <a href="Login.aspx" class="nav-link-ghost">Login</a>
                <a href="Register.aspx" class="nav-link-solid">Get Started</a>
            </div>
        </nav>

        <section class="hero">
            <div class="hero-slide active" style="background-image:url('Images/landing/slide1.jpg');"></div>
            <div class="hero-slide" style="background-image:url('Images/landing/slide2.jpg');"></div>
            <div class="hero-slide" style="background-image:url('Images/landing/slide3.jpg');"></div>
            <div class="hero-slide" style="background-image:url('Images/landing/slide4.jpg');"></div>
            <div class="hero-slide" style="background-image:url('Images/landing/slide5.jpg');"></div>

            <div class="hero-content">
                <div class="hero-badge"><i class="fa-solid fa-shield-halved"></i> University of Fort Hare &mdash; Together in Excellence</div>
                <h1 class="hero-title">Tutoring and Book Rentals, All in One Trusted Place</h1>
                <p class="hero-subtitle">Book verified tutors, borrow academic books for free, and track your sessions, payments, and balance &mdash; safely and simply.</p>
                <div class="hero-cta">
                    <a href="Register.aspx" class="hero-btn hero-btn-primary"><i class="fa-solid fa-user-plus"></i> Create Free Account</a>
                    <a href="Login.aspx" class="hero-btn hero-btn-secondary"><i class="fa-solid fa-right-to-bracket"></i> I Already Have an Account</a>
                </div>
            </div>

            <div class="hero-dots" id="heroDots">
                <div class="hero-dot active" data-index="0"></div>
                <div class="hero-dot" data-index="1"></div>
                <div class="hero-dot" data-index="2"></div>
                <div class="hero-dot" data-index="3"></div>
                <div class="hero-dot" data-index="4"></div>
            </div>
        </section>

        <div class="trust-strip">
            <div class="trust-item"><i class="fa-solid fa-user-check"></i> Admin-Approved Tutors</div>
            <div class="trust-item"><i class="fa-solid fa-lock"></i> Secure Payments</div>
            <div class="trust-item"><i class="fa-solid fa-star"></i> Rated by Real Students</div>
            <div class="trust-item"><i class="fa-solid fa-clock"></i> Real-Time Booking</div>
        </div>

        <section class="features-section">
            <div class="section-eyebrow">Why Forte Books &amp; Tuition Hub</div>
            <h2 class="section-title">Built for Trust, Made for Students</h2>
            <p class="section-subtitle">Every feature is designed to remove the friction &mdash; and the risk &mdash; from getting academic support.</p>

            <div class="features-grid">
                <div class="feature-card">
                    <div class="feature-icon"><i class="fa-solid fa-user-check"></i></div>
                    <h3>Verified Tutors Only</h3>
                    <p>Every tutor is reviewed and approved by our administrators before they can accept a single booking.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon"><i class="fa-solid fa-calendar-check"></i></div>
                    <h3>No Double Bookings</h3>
                    <p>Our system checks real-time availability automatically, so your session is always guaranteed.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon"><i class="fa-solid fa-book"></i></div>
                    <h3>Free Book Rentals</h3>
                    <p>Borrow from our academic catalogue at no cost, with clear due dates and simple returns.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon"><i class="fa-solid fa-wallet"></i></div>
                    <h3>Transparent Balances</h3>
                    <p>See exactly what you owe or are owed at any time &mdash; no surprises, no hidden charges.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon"><i class="fa-solid fa-comments"></i></div>
                    <h3>Direct Messaging</h3>
                    <p>Ask your tutor for directions or lecture follow-ups right inside your session, safely and privately.</p>
                </div>
                <div class="feature-card">
                    <div class="feature-icon"><i class="fa-solid fa-star"></i></div>
                    <h3>Honest Ratings</h3>
                    <p>Every session can be rated, helping keep quality high and giving you confidence before you book.</p>
                </div>
            </div>
        </section>

        <section class="services-section">
            <div class="services-grid">
                <div class="service-card">
                    <i class="fa-solid fa-chalkboard-user service-icon"></i>
                    <h3>Tutoring Sessions</h3>
                    <p>Book one-on-one time with subject specialists, at a venue and time that suits you.</p>
                    <ul class="service-list">
                        <li><i class="fa-solid fa-check"></i> Choose your subject and tutor</li>
                        <li><i class="fa-solid fa-check"></i> See venue &amp; availability upfront</li>
                        <li><i class="fa-solid fa-check"></i> Secure your slot with a deposit</li>
                    </ul>
                    <a href="Register.aspx" class="hero-btn hero-btn-primary">Book a Tutor</a>
                </div>
                <div class="service-card">
                    <i class="fa-solid fa-book-open service-icon"></i>
                    <h3>Book Rentals</h3>
                    <p>Access our academic catalogue and borrow the resources you need, completely free.</p>
                    <ul class="service-list">
                        <li><i class="fa-solid fa-check"></i> Browse titles by subject</li>
                        <li><i class="fa-solid fa-check"></i> 14-day loan periods</li>
                        <li><i class="fa-solid fa-check"></i> Automatic due-date reminders</li>
                    </ul>
                    <a href="Register.aspx" class="hero-btn hero-btn-primary">Browse Books</a>
                </div>
            </div>
        </section>

        <section class="final-cta">
            <h2>Ready to Get Started?</h2>
            <p>Join students and tutors already using Forte Books &amp; Tuition Hub to make academic support simple.</p>
            <div class="hero-cta">
                <a href="Register.aspx" class="hero-btn hero-btn-primary"><i class="fa-solid fa-user-plus"></i> Create Your Free Account</a>
            </div>
        </section>

        <div class="landing-footer">
            Forte Books &amp; Tuition Hub Management System &copy; <%: DateTime.Now.Year %>
            &nbsp;|&nbsp; <a href="About.aspx">About &amp; Contact</a>
            &nbsp;|&nbsp; University of Fort Hare &mdash; Together in Excellence
        </div>

    </form>

    <script>
        (function () {
            var slides = document.querySelectorAll('.hero-slide');
            var dots = document.querySelectorAll('.hero-dot');
            var current = 0;
            var intervalMs = 10000;
            var timer;

            function showSlide(index) {
                slides.forEach(function (s) { s.classList.remove('active'); });
                dots.forEach(function (d) { d.classList.remove('active'); });
                slides[index].classList.add('active');
                dots[index].classList.add('active');
                current = index;
            }

            function nextSlide() {
                showSlide((current + 1) % slides.length);
            }

            function resetTimer() {
                clearInterval(timer);
                timer = setInterval(nextSlide, intervalMs);
            }

            dots.forEach(function (dot) {
                dot.addEventListener('click', function () {
                    showSlide(parseInt(dot.getAttribute('data-index'), 10));
                    resetTimer();
                });
            });

            resetTimer();

            var nav = document.getElementById('landingNav');
            window.addEventListener('scroll', function () {
                if (window.scrollY > 40) {
                    nav.classList.add('scrolled');
                } else {
                    nav.classList.remove('scrolled');
                }
            });
        })();
    </script>
</body>
</html