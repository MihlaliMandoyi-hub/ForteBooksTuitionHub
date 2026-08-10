<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="ForteBooksTuitionHub.About" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-circle-info"></i> About Forte Books &amp; Tuition Hub</h2>

    <div style="display:flex; flex-wrap:wrap; gap:25px;">

        <div class="form-box" style="flex:2; min-width:300px; max-width:none;">
            <h3><i class="fa-solid fa-book-open-reader"></i> Who We Are</h3>
            <p>
                Forte Books &amp; Tuition Hub is a community-focused centre offering affordable academic tutoring
                and book rentals to students. Our mission is to make quality learning support accessible, organised,
                and easy to track for students, tutors, and staff alike.
            </p>

            <h3 style="margin-top:20px;"><i class="fa-solid fa-graduation-cap"></i> What We Offer</h3>
            <ul style="line-height:2;">
                <li><i class="fa-solid fa-calendar-check" style="color:var(--ufh-sky);"></i> One-on-one and small group tutoring sessions</li>
                <li><i class="fa-solid fa-book" style="color:var(--ufh-sky);"></i> Free book rentals from our academic library</li>
                <li><i class="fa-solid fa-chalkboard-user" style="color:var(--ufh-sky);"></i> Qualified, approved tutors across multiple subjects</li>
                <li><i class="fa-solid fa-money-bill-wave" style="color:var(--ufh-sky);"></i> Transparent fee tracking and digital payment records</li>
            </ul>
        </div>

        <div class="form-box" style="flex:1; min-width:260px; max-width:none;">
            <h3><i class="fa-solid fa-address-card"></i> Contact Us</h3>

            <p><i class="fa-solid fa-location-dot" style="color:var(--ufh-gold);"></i> East London, Eastern Cape, South Africa</p>
            <p><i class="fa-solid fa-phone" style="color:var(--ufh-gold);"></i> 043 000 0000</p>
            <p><i class="fa-solid fa-envelope" style="color:var(--ufh-gold);"></i> info@fortebookstuitionhub.co.za</p>
            <p><i class="fa-solid fa-clock" style="color:var(--ufh-gold);"></i> Mon - Fri: 08:00 - 17:00</p>
            <p><i class="fa-solid fa-clock" style="color:var(--ufh-gold);"></i> Sat: 09:00 - 13:00</p>

            <hr style="margin:15px 0; border-color:#eee;" />

            <h3><i class="fa-solid fa-circle-question"></i> Need Help?</h3>
            <p style="font-size:13px; color:#7A8699;">
                For account issues or tutor applications, please visit the front desk or reach out via the contact
                details above. Students and Tutors can also use the "Forgot Password" link on the login page for
                password resets.
            </p>
        </div>

    </div>

</asp:Content>