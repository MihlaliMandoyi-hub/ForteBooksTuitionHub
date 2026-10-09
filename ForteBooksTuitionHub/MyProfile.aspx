<%@ Page Title="My Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyProfile.aspx.cs" Inherits="ForteBooksTuitionHub.MyProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="student-editor personal-profile">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-id-badge" aria-hidden="true"></i>
            </div>
            <div>
                <div class="management-eyebrow">FORTE BOOKS &amp; TUITION HUB</div>
                <h2>My Student Profile</h2>
                <p>Your account, your details and your learning activity.</p>
            </div>
        </div>

        <div class="student-editor-body">

            <asp:Panel ID="pnlBalanceCard" runat="server"
                CssClass="balance-banner balance-settled">

                <div class="student-balance-details">
                    <div class="balance-banner-icon">
                        <i class="fa-solid fa-wallet" aria-hidden="true"></i>
                    </div>

                    <div>
                        <div class="balance-banner-label">Your Account Balance</div>

                        <div class="balance-banner-amount">
                            <asp:Label ID="lblBalanceAmount" runat="server"></asp:Label>
                        </div>

                        <div class="balance-banner-meaning">
                            <asp:Label ID="lblBalanceMeaning" runat="server"></asp:Label>
                        </div>

                        <a href="TopUpBalance.aspx"
                            class="btn btn-gold student-balance-topup">
                            <i class="fa-solid fa-wallet" aria-hidden="true"></i>
                            Top Up Balance
                        </a>
                    </div>
                </div>

                <div class="hub-student-card">

                    <div class="student-card-header">
                        <img src="Images/ufh-logo.png"
                            alt="University of Fort Hare crest" />

                        <div>
                            <strong>FORTE BOOKS</strong>
                            <span>&amp; Tuition Hub</span>
                        </div>

                        <span class="student-card-role">STUDENT</span>
                    </div>

                    <div class="student-card-person">
                        <div class="student-card-avatar">
                            <i class="fa-solid fa-user-graduate" aria-hidden="true"></i>
                        </div>

                        <div>
                            <span class="student-card-caption">ACCOUNT HOLDER</span>

                            <strong class="student-card-name">
                                <%: string.IsNullOrWhiteSpace(txtFullName.Text)
                                    ? Convert.ToString(Session["Username"])
                                    : txtFullName.Text %>
                            </strong>

                            <span class="student-card-description">
                                Username: <%: Convert.ToString(Session["Username"]) %>
                            </span>
                        </div>
                    </div>

                    <div class="student-card-footer">
                        <span>InnovaTech Hub</span>
                        <a href="#profileDetails">
                            My Details
                            <i class="fa-solid fa-arrow-down" aria-hidden="true"></i>
                        </a>
                    </div>

                </div>

            </asp:Panel>

            <div class="profile-activity">

                <a href="Sessions.aspx" class="profile-activity-card">
                    <span class="profile-activity-icon">
                        <i class="fa-solid fa-calendar-check" aria-hidden="true"></i>
                    </span>
                    <div>
                        <span>NON-CANCELLED SESSIONS</span>
                        <strong>
                            <asp:Label ID="lblTotalSessions" runat="server"></asp:Label>
                        </strong>
                        <small>View my sessions</small>
                    </div>
                    <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                </a>

                <a href="MyRentals.aspx" class="profile-activity-card">
                    <span class="profile-activity-icon">
                        <i class="fa-solid fa-book-open" aria-hidden="true"></i>
                    </span>
                    <div>
                        <span>BOOKS ON LOAN</span>
                        <strong>
                            <asp:Label ID="lblBooksOnLoan" runat="server"></asp:Label>
                        </strong>
                        <small>Open my bookshelf</small>
                    </div>
                    <i class="fa-solid fa-arrow-right" aria-hidden="true"></i>
                </a>

            </div>

            <asp:Panel ID="pnlProfileDetails" runat="server"
                DefaultButton="btnSave">

                <div class="student-editor-section" id="profileDetails">

                    <div class="student-editor-heading">
                        <span>
                            <i class="fa-solid fa-user-pen" aria-hidden="true"></i>
                        </span>
                        <div>
                            <h3>My personal details</h3>
                            <p>Keep your name and contact information up to date.</p>
                        </div>
                    </div>

                    <div class="student-editor-fields">

                        <div class="student-editor-field student-editor-wide">
                            <asp:Label runat="server"
                                AssociatedControlID="txtFullName"
                                Text="Full name *"></asp:Label>

                            <asp:TextBox ID="txtFullName" runat="server"
                                autocomplete="name"></asp:TextBox>

                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtFullName"
                                ErrorMessage="Full name is required."
                                CssClass="error-text"
                                Display="Dynamic" />
                        </div>

                        <div class="student-editor-field">
                            <asp:Label runat="server"
                                AssociatedControlID="txtEmail"
                                Text="Email address *"></asp:Label>

                            <asp:TextBox ID="txtEmail" runat="server"
                                TextMode="Email"
                                autocomplete="email"></asp:TextBox>

                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtEmail"
                                ErrorMessage="Email is required."
                                CssClass="error-text"
                                Display="Dynamic" />

                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtEmail"
                                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                                ErrorMessage="Enter a valid email address."
                                CssClass="error-text"
                                Display="Dynamic" />
                        </div>

                        <div class="student-editor-field">
                            <asp:Label runat="server"
                                AssociatedControlID="txtPhone"
                                Text="Phone number *"></asp:Label>

                            <asp:TextBox ID="txtPhone" runat="server"
                                autocomplete="tel"
                                inputmode="tel"></asp:TextBox>

                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtPhone"
                                ErrorMessage="Phone number is required."
                                CssClass="error-text"
                                Display="Dynamic" />

                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtPhone"
                                ValidationExpression="^0\d{9}$"
                                ErrorMessage="Enter a valid 10-digit phone number starting with 0."
                                CssClass="error-text"
                                Display="Dynamic" />

                            <p class="student-editor-help">
                                Enter 10 digits, starting with 0.
                            </p>
                        </div>

                    </div>
                </div>

                <asp:Label ID="lblMessage" runat="server"
                    CssClass="profile-save-success"
                    role="status"></asp:Label>

                <asp:Label ID="lblError" runat="server"
                    CssClass="student-editor-error"
                    role="alert"></asp:Label>

                <div class="student-editor-actions">
                    <asp:Button ID="btnSave" runat="server"
                        Text="Save Profile Changes"
                        CssClass="btn btn-gold"
                        OnClick="btnSave_Click" />

                    <a href="Settings.aspx" class="btn student-editor-back">
                        <i class="fa-solid fa-gear" aria-hidden="true"></i>
                        Account Settings
                    </a>
                </div>

            </asp:Panel>

        </div>
    </div>

</asp:Content>