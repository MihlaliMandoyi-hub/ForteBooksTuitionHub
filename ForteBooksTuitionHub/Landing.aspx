<%@ Page Title="Forte Books & Tuition Hub" Language="C#" AutoEventWireup="true" CodeBehind="Landing.aspx.cs" Inherits="ForteBooksTuitionHub.Landing" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Forte Books &amp; Tuition Hub</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="anonymous" />
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700;800&amp;display=swap"
        rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css"
        rel="stylesheet" />

    <link href="<%= ResolveUrl("~/LandingStyle.css") %>?v=forte-showcase-3"
        rel="stylesheet" />
</head>

<body>
<form id="form1" runat="server">

    <a class="skip-link" href="#main">Skip to content</a>

    <header class="site-header">
        <div class="container header-inner">

            <a href="Landing.aspx" class="brand">
                <img src="Images/ufh-logo.png"
                    alt="University of Fort Hare crest" />

                <span>
                    <strong>Forte Books &amp; Tuition Hub</strong>
                    <small>InnovaTech Hub</small>
                </span>
            </a>

            <nav aria-label="Main navigation">
                <a href="#services">Explore</a>
                <a href="About.aspx">About &amp; Contact</a>
                <a href="Login.aspx">Sign In</a>
                <a href="Register.aspx" class="button gold">Join the Hub</a>
            </nav>

        </div>
    </header>

    <main id="main">

        <section class="hero">
            <div class="container hero-grid">

                <div class="hero-copy">

                    <div class="welcome-pill">
                        <span></span>
                        A PLACE TO LEARN. SPACE TO GROW.
                    </div>

                    <h1>
                        Big dreams.<br />
                        Better support.<br />
                        <span class="highlight">Your next chapter.</span>
                    </h1>

                    <p class="hero-description">
                        Find your tutor. Discover your next book.
                        Bring your learning together at
                        Forte Books &amp; Tuition Hub.
                    </p>

                    <div class="hero-actions">
                        <a href="Register.aspx" class="button gold">
                            Start Your Journey
                            <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                        </a>

                        <a href="Login.aspx" class="button outline">
                            <i class="fa-solid fa-right-to-bracket" aria-hidden="true"></i>
                            Sign In
                        </a>
                    </div>

                    <div class="hero-footnote">
                        <span class="hero-footnote-icon">
                            <i class="fa-solid fa-graduation-cap" aria-hidden="true"></i>
                        </span>
                        <div>
                            <strong>Learning, connected.</strong>
                            <span>Books, tutoring and your schedule in one hub.</span>
                        </div>
                    </div>

                </div>

                <section class="showcase" aria-label="Photo showcase">

                    <div class="showcase-topline">
                        <span>DISCOVER THE POSSIBILITIES</span>
                        <span id="photoCount">01 / 05</span>
                    </div>

                    <div class="photo-frame">

                        <div class="photo-fallback" aria-hidden="true">
                            <i class="fa-solid fa-book-open-reader"></i>
                            <strong>Your learning space</strong>
                        </div>

                        <img class="showcase-photo active"
                            src="Images/landing/slide1.jpg"
                            alt="Hub showcase photo 1" />
                        <img class="showcase-photo"
                            src="Images/landing/slide2.jpg"
                            alt="Hub showcase photo 2" />
                        <img class="showcase-photo"
                            src="Images/landing/slide3.jpg"
                            alt="Hub showcase photo 3" />
                        <img class="showcase-photo"
                            src="Images/landing/slide4.jpg"
                            alt="Hub showcase photo 4" />
                        <img class="showcase-photo"
                            src="Images/landing/slide5.jpg"
                            alt="Hub showcase photo 5" />

                        <div class="photo-caption">
                            <span>FORTE BOOKS &amp; TUITION HUB</span>
                            <strong>Make room for possibility.</strong>
                        </div>

                        <div class="photo-controls" role="group"
                            aria-label="Slideshow controls">

                            <button type="button" id="previousPhoto"
                                aria-label="Previous photo">
                                <i class="fa-solid fa-arrow-left" aria-hidden="true"></i>
                            </button>

                            <button type="button" id="pausePhotos"
                                aria-label="Pause slideshow">
                                <i class="fa-solid fa-pause" aria-hidden="true"></i>
                            </button>

                            <button type="button" id="nextPhoto"
                                aria-label="Next photo">
                                <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                            </button>

                        </div>

                    </div>

                    <div class="photo-thumbnails" role="group"
                        aria-label="Choose a showcase photo">

                        <button type="button" data-photo="0"
                            aria-label="Show photo 1" aria-pressed="true">
                            <img src="Images/landing/slide1.jpg" alt="" />
                            <span>01</span>
                        </button>

                        <button type="button" data-photo="1"
                            aria-label="Show photo 2" aria-pressed="false">
                            <img src="Images/landing/slide2.jpg" alt="" />
                            <span>02</span>
                        </button>

                        <button type="button" data-photo="2"
                            aria-label="Show photo 3" aria-pressed="false">
                            <img src="Images/landing/slide3.jpg" alt="" />
                            <span>03</span>
                        </button>

                        <button type="button" data-photo="3"
                            aria-label="Show photo 4" aria-pressed="false">
                            <img src="Images/landing/slide4.jpg" alt="" />
                            <span>04</span>
                        </button>

                        <button type="button" data-photo="4"
                            aria-label="Show photo 5" aria-pressed="false">
                            <img src="Images/landing/slide5.jpg" alt="" />
                            <span>05</span>
                        </button>

                    </div>

                    <div class="showcase-badge">
                        <span>
                            <i class="fa-solid fa-book-open" aria-hidden="true"></i>
                        </span>
                        <div>
                            <strong>Free book rentals</strong>
                            <small>A new chapter within reach</small>
                        </div>
                    </div>

                </section>

            </div>
        </section>

        <section class="container quick-facts" aria-label="Hub services">

            <div>
                <i class="fa-solid fa-chalkboard-user" aria-hidden="true"></i>
                <span><strong>Academic tutoring</strong><small>Support for your learning goals</small></span>
            </div>

            <div>
                <i class="fa-solid fa-book-open" aria-hidden="true"></i>
                <span><strong>14-day book loans</strong><small>Explore. Borrow. Discover.</small></span>
            </div>

            <div>
                <i class="fa-solid fa-calendar-check" aria-hidden="true"></i>
                <span><strong>Your learning, organised</strong><small>Sessions and schedules together</small></span>
            </div>

        </section>

        <section id="services" class="container section">

            <div class="section-intro">
                <div>
                    <span class="eyebrow">MORE THAN A PLACE TO STUDY</span>
                    <h2>Find your way forward.</h2>
                </div>
                <p>
                    A little guidance, the right resources and a clear plan
                    can make your next step easier.
                </p>
            </div>

            <div class="services">

                <article class="service-card">
                    <div class="service-top">
                        <span class="service-icon">
                            <i class="fa-solid fa-chalkboard-user" aria-hidden="true"></i>
                        </span>
                        <span class="service-number">01</span>
                    </div>

                    <h3>Learn with<br />a tutor.</h3>
                    <p>
                        Explore tutor subjects, rates and availability.
                        Book a session that supports your learning goals.
                    </p>

                    <div class="service-tags">
                        <span>Subjects</span>
                        <span>Sessions</span>
                        <span>Messages</span>
                    </div>

                    <a href="Register.aspx">
                        Begin your journey
                        <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                    </a>
                </article>

                <article class="service-card book-service">
                    <div class="service-top">
                        <span class="service-icon">
                            <i class="fa-solid fa-book-open" aria-hidden="true"></i>
                        </span>
                        <span class="service-number">02</span>
                    </div>

                    <h3>Open a book.<br />Open possibilities.</h3>
                    <p>
                        Search the collection and borrow available books for free.
                        Loans last 14 days; late returns cost R5.00 per day.
                    </p>

                    <div class="service-tags">
                        <span>Free rentals</span>
                        <span>14-day loans</span>
                    </div>

                    <a href="Login.aspx">
                        Sign in to discover
                        <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                    </a>
                </article>

                <article class="service-card">
                    <div class="service-top">
                        <span class="service-icon">
                            <i class="fa-solid fa-calendar-days" aria-hidden="true"></i>
                        </span>
                        <span class="service-number">03</span>
                    </div>

                    <h3>Less searching.<br />More learning.</h3>
                    <p>
                        Bring your schedule, rental records, session conversations
                        and account information into one place.
                    </p>

                    <div class="service-tags">
                        <span>Schedule</span>
                        <span>Rentals</span>
                        <span>Account</span>
                    </div>

                    <a href="Login.aspx">
                        Open your account
                        <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                    </a>
                </article>

            </div>
        </section>

        <section class="container section">

            <div class="journey-panel">

                <div class="journey-heading">
                    <span class="eyebrow">MAKE YOUR FIRST MOVE</span>
                    <h2>Three steps.<br />A new beginning.</h2>
                    <a href="Register.aspx" class="button gold">
                        Join the Hub
                        <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                    </a>
                </div>

                <div class="journey-steps">
                    <div>
                        <span>01</span>
                        <section>
                            <h3>Create your account</h3>
                            <p>Join as a student or apply as a tutor.</p>
                        </section>
                    </div>

                    <div>
                        <span>02</span>
                        <section>
                            <h3>Find your starting point</h3>
                            <p>Sign in to explore the services available to your role.</p>
                        </section>
                    </div>

                    <div>
                        <span>03</span>
                        <section>
                            <h3>Take your next step</h3>
                            <p>Plan a session, explore books or organise your week.</p>
                        </section>
                    </div>

                    <p class="tutor-note">
                        <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
                        Tutor accounts require administrator approval before sign-in.
                    </p>
                </div>

            </div>

        </section>

        <section class="container section">
            <div class="closing-banner">
                <div>
                    <span class="eyebrow">YOUR STORY IS STILL BEING WRITTEN</span>
                    <h2>Let’s make the next chapter count.</h2>
                    <p>Forte Books &amp; Tuition Hub · InnovaTech Hub</p>
                </div>
                <a href="Register.aspx" class="button gold">Get Started</a>
            </div>
        </section>

    </main>

    <footer>
        <div class="container footer-inner">
            <a href="Landing.aspx" class="brand footer-brand">
                <img src="Images/ufh-logo.png"
                    alt="University of Fort Hare crest" />
                <span>
                    <strong>Forte Books &amp; Tuition Hub</strong>
                    <small>InnovaTech Hub</small>
                </span>
            </a>

            <nav aria-label="Footer navigation">
                <a href="About.aspx">About &amp; Contact</a>
                <a href="Login.aspx">Sign In</a>
            </nav>

            <small class="copyright">
                &copy; <%: TimeZoneInfo.ConvertTimeBySystemTimeZoneId(DateTime.UtcNow, "South Africa Standard Time").Year %>
                Forte Books &amp; Tuition Hub
            </small>
        </div>
    </footer>

</form>

<script>
    (function () {
        var showcase = document.querySelector('.showcase');
        if (!showcase) return;

        var photos = showcase.querySelectorAll('.showcase-photo');
        var thumbnails = showcase.querySelectorAll('button[data-photo]');
        var count = document.getElementById('photoCount');
        var pause = document.getElementById('pausePhotos');

        var current = 0;
        var timer = null;
        var paused = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        var hovered = false;
        var focused = false;

        function show(index) {
            current = (index + photos.length) % photos.length;

            photos.forEach(function (photo, i) {
                var active = i === current;
                photo.classList.toggle('active', active);
                photo.setAttribute('aria-hidden', active ? 'false' : 'true');
            });

            thumbnails.forEach(function (button, i) {
                button.setAttribute('aria-pressed', i === current ? 'true' : 'false');
            });

            count.textContent = '0' + (current + 1) + ' / 05';
        }

        function updateTimer() {
            clearInterval(timer);

            pause.setAttribute('aria-label',
                paused ? 'Play slideshow' : 'Pause slideshow');

            pause.querySelector('i').className =
                paused ? 'fa-solid fa-play' : 'fa-solid fa-pause';

            if (!paused && !hovered && !focused && !document.hidden) {
                timer = setInterval(function () {
                    show(current + 1);
                }, 6500);
            }
        }

        thumbnails.forEach(function (button) {
            button.addEventListener('click', function () {
                show(Number(button.dataset.photo));
                updateTimer();
            });
        });

        document.getElementById('previousPhoto').addEventListener('click', function () {
            show(current - 1);
            updateTimer();
        });

        document.getElementById('nextPhoto').addEventListener('click', function () {
            show(current + 1);
            updateTimer();
        });

        pause.addEventListener('click', function () {
            paused = !paused;
            updateTimer();
        });

        showcase.addEventListener('mouseenter', function () {
            hovered = true;
            updateTimer();
        });

        showcase.addEventListener('mouseleave', function () {
            hovered = false;
            updateTimer();
        });

        showcase.addEventListener('focusin', function () {
            focused = true;
            updateTimer();
        });

        showcase.addEventListener('focusout', function (event) {
            focused = showcase.contains(event.relatedTarget);
            updateTimer();
        });

        document.addEventListener('visibilitychange', updateTimer);

        photos.forEach(function (photo) {
            function hideFailedPhoto() {
                photo.style.visibility = 'hidden';
            }

            photo.addEventListener('error', hideFailedPhoto);

            if (photo.complete && photo.naturalWidth === 0) {
                hideFailedPhoto();
            }
        });

        show(0);
        updateTimer();
    })();
</script>

</body>
</html>