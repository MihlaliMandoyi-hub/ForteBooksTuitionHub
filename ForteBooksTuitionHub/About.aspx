<%@ Page Title="About & Contact" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="ForteBooksTuitionHub.About" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="about-page">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-book-open-reader" aria-hidden="true"></i>
            </div>
            <div>
                <div class="management-eyebrow">Forte Books &amp; Tuition Hub</div>
                <h2>Learning Starts With Support</h2>
                <p>Books, tutoring and a community that helps you move forward.</p>
            </div>
        </div>

        <div class="about-content">

            <section class="about-welcome">

                <div>
                    <span class="about-eyebrow">WELCOME TO THE HUB</span>
                    <h3>A place to learn.<br />Space to grow.</h3>

                    <p>
                        Forte Books &amp; Tuition Hub is a community-focused centre
                        offering affordable academic tutoring and free book rentals.
                    </p>

                    <p>
                        Our mission is to make learning support accessible,
                        organised and easy to track—for students, tutors and staff.
                    </p>
                </div>

                <div class="about-learning-art" aria-hidden="true">

                    <div class="about-art-circle">
                        <i class="fa-solid fa-graduation-cap"></i>
                    </div>

                    <div class="about-art-book book-one">LEARN</div>
                    <div class="about-art-book book-two">DISCOVER</div>
                    <div class="about-art-book book-three">GROW</div>

                    <span class="about-art-caption">ONE CHAPTER AT A TIME</span>
                </div>

            </section>

            <div class="about-section-heading">
                <span class="about-eyebrow">WHAT WE OFFER</span>
                <h3>Support for your next step</h3>
                <p>Explore the services available through the hub.</p>
            </div>

            <div class="about-services">

                <section class="about-service">
                    <div class="about-service-icon">
                        <i class="fa-solid fa-chalkboard-user" aria-hidden="true"></i>
                    </div>
                    <span class="about-service-number">01</span>
                    <h4>Academic tutoring</h4>
                    <p>
                        One-on-one and small group sessions, with tutors
                        across multiple subjects.
                    </p>
                </section>

                <section class="about-service">
                    <div class="about-service-icon">
                        <i class="fa-solid fa-book-open" aria-hidden="true"></i>
                    </div>
                    <span class="about-service-number">02</span>
                    <h4>Free book rentals</h4>
                    <p>
                        Explore the collection and borrow books for a
                        14-day loan period.
                    </p>
                </section>

                <section class="about-service">
                    <div class="about-service-icon">
                        <i class="fa-solid fa-calendar-check" aria-hidden="true"></i>
                    </div>
                    <span class="about-service-number">03</span>
                    <h4>Organised learning</h4>
                    <p>
                        Keep your bookings, schedule and session conversations
                        together in your account.
                    </p>
                </section>

                <section class="about-service">
                    <div class="about-service-icon">
                        <i class="fa-solid fa-receipt" aria-hidden="true"></i>
                    </div>
                    <span class="about-service-number">04</span>
                    <h4>Clear account records</h4>
                    <p>
                        View your account balance, recorded payments
                        and book rental fines.
                    </p>
                </section>

            </div>

            <div class="about-contact-layout">

                <section class="about-contact">
                    <div class="about-panel-heading">
                        <div class="about-service-icon">
                            <i class="fa-solid fa-address-card" aria-hidden="true"></i>
                        </div>
                        <div>
                            <span class="about-eyebrow">GET IN TOUCH</span>
                            <h3>Let’s talk</h3>
                        </div>
                    </div>

                    <p class="about-panel-intro">
                        Have a question about your account, tutoring or books?
                        Contact the centre or visit the front desk.
                    </p>

                    <div class="about-contact-item">
                        <i class="fa-solid fa-location-dot" aria-hidden="true"></i>
                        <div>
                            <span>LOCATION</span>
                            <strong>East London, Eastern Cape</strong>
                            <p>South Africa</p>
                        </div>
                    </div>

                    <div class="about-contact-item">
                        <i class="fa-solid fa-phone" aria-hidden="true"></i>
                        <div>
                            <span>PHONE</span>
                            <a href="tel:+27430000000">043 000 0000</a>
                        </div>
                    </div>

                    <div class="about-contact-item">
                        <i class="fa-solid fa-envelope" aria-hidden="true"></i>
                        <div>
                            <span>EMAIL</span>
                            <a href="mailto:info@fortebookstuitionhub.co.za">
                                info@fortebookstuitionhub.co.za
                            </a>
                        </div>
                    </div>

                    <div class="about-hours">
                        <h4>
                            <i class="fa-solid fa-clock" aria-hidden="true"></i>
                            Opening hours
                        </h4>

                        <div>
                            <span>Monday – Friday</span>
                            <strong>08:00 – 17:00</strong>
                        </div>
                        <div>
                            <span>Saturday</span>
                            <strong>09:00 – 13:00</strong>
                        </div>

                        <p>All times are South African Standard Time.</p>
                    </div>

                </section>

                <section class="about-help">
                    <div class="about-panel-heading">
                        <div class="about-service-icon">
                            <i class="fa-solid fa-circle-question" aria-hidden="true"></i>
                        </div>
                        <div>
                            <span class="about-eyebrow">A LITTLE GUIDANCE</span>
                            <h3>Helpful answers</h3>
                        </div>
                    </div>

                    <p class="about-panel-intro">
                        Open a question below for a quick explanation.
                    </p>

                    <details class="about-faq">
                        <summary>How do book rentals work?</summary>
                        <p>
                            Book rentals are free, with a 14-day loan period.
                            Check the Book Catalogue for available copies.
                            Late returns incur a fine of R5.00 per day.
                        </p>
                    </details>

                    <details class="about-faq">
                        <summary>Where can I see my bookings?</summary>
                        <p>
                            Sign in to view your sessions and schedule.
                            Your session records also provide access to
                            the available session actions.
                        </p>
                    </details>

                    <details class="about-faq">
                        <summary>What if I forget my password?</summary>
                        <p>
                            Students and tutors can use the Forgot Password
                            link on the login page. Contact the centre if
                            you need further account assistance.
                        </p>
                    </details>

                    <details class="about-faq">
                        <summary>How do I get help with a tutor application?</summary>
                        <p>
                            Visit the front desk or contact the centre
                            using the phone number or email shown here.
                        </p>
                    </details>

                    <div class="about-help-note">
                        <i class="fa-solid fa-comments" aria-hidden="true"></i>
                        <div>
                            <strong>Still have a question?</strong>
                            <p>
                                Tell the centre what you need help with.
                                Never include your password or payment credentials.
                            </p>
                        </div>
                    </div>

                </section>

            </div>

            <div class="about-signature">
                <i class="fa-solid fa-graduation-cap" aria-hidden="true"></i>
                <span>Forte Books &amp; Tuition Hub</span>
                <strong>InnovaTech Hub</strong>
            </div>

        </div>
    </div>

</asp:Content>