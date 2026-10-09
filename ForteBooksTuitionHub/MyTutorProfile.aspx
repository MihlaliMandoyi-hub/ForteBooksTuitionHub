<%@ Page Title="My Tutor Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyTutorProfile.aspx.cs" Inherits="ForteBooksTuitionHub.MyTutorProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="student-editor personal-profile tutor-personal-profile">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-chalkboard-user" aria-hidden="true"></i>
            </div>
            <div>
                <div class="management-eyebrow">FORTE BOOKS &amp; TUITION HUB</div>
                <h2>My Tutor Profile</h2>
                <p>Your teaching identity, activity and earnings in one place.</p>
            </div>
        </div>

        <div class="student-editor-body">

            <div class="tutor-profile-welcome">

                <div class="tutor-profile-intro">
                    <span class="management-eyebrow">YOUR TEACHING JOURNEY</span>
                    <h3>Share knowledge.<br />Make a difference.</h3>
                    <p>
                        Keep your profile current, organise your teaching times
                        and review feedback from your students.
                    </p>

                    <div class="tutor-profile-shortcuts">
                        <a href="MyAvailability.aspx" class="btn student-editor-back">
                            <i class="fa-solid fa-calendar-days" aria-hidden="true"></i>
                            My Availability
                        </a>
                        <a href="MySchedule.aspx" class="btn btn-gold">
                            My Schedule
                        </a>
                    </div>
                </div>

                <div class="hub-student-card hub-tutor-card">

                    <div class="student-card-header">
                        <img src="Images/ufh-logo.png"
                            alt="University of Fort Hare crest" />
                        <div>
                            <strong>FORTE BOOKS</strong>
                            <span>&amp; Tuition Hub</span>
                        </div>
                        <span class="student-card-role">TUTOR</span>
                    </div>

                    <div class="student-card-person">
                        <div class="student-card-avatar">
                            <i class="fa-solid fa-chalkboard-user" aria-hidden="true"></i>
                        </div>
                        <div>
                            <span class="student-card-caption">ACCOUNT HOLDER</span>

                            <strong class="student-card-name">
                                <%: string.IsNullOrWhiteSpace(txtFullName.Text)
                                    ? Convert.ToString(Session["Username"])
                                    : txtFullName.Text %>
                            </strong>

                            <span class="student-card-description">
                                <%: txtSubject.Text %>
                            </span>
                        </div>
                    </div>

                    <div class="tutor-card-username">
                        Username: <%: Convert.ToString(Session["Username"]) %>
                    </div>

                    <div class="student-card-footer">
                        <span>InnovaTech Hub</span>
                        <a href="#tutorDetails">
                            My Details
                            <i class="fa-solid fa-arrow-down" aria-hidden="true"></i>
                        </a>
                    </div>

                </div>

            </div>

            <div class="tutor-profile-stats">

                <div>
                    <i class="fa-solid fa-calendar-check" aria-hidden="true"></i>
                    <span>NON-CANCELLED SESSIONS</span>
                    <strong>
                        <asp:Label ID="lblTotalSessions" runat="server"></asp:Label>
                    </strong>
                    <small>All recorded non-cancelled sessions</small>
                </div>

                <div class="tutor-stat-approved">
                    <i class="fa-solid fa-circle-check" aria-hidden="true"></i>
                    <span>APPROVED HOURS</span>
                    <strong>
                        <asp:Label ID="lblApprovedHours" runat="server"></asp:Label>
                    </strong>
                    <small>Approved timesheet hours</small>
                </div>

                <div>
                    <i class="fa-solid fa-calendar-days" aria-hidden="true"></i>
                    <span>WEEKLY AVAILABILITY</span>
                    <strong>
                        <asp:Label ID="lblAvailableHours" runat="server"></asp:Label>
                        <small>hrs</small>
                    </strong>
                    <small>Across your recorded slots</small>
                </div>

                <div class="tutor-stat-rating">
                    <i class="fa-solid fa-star" aria-hidden="true"></i>
                    <span>STUDENT RATINGS</span>
                    <strong class="tutor-rating-value">
                        <asp:Label ID="lblAvgRating" runat="server"></asp:Label>
                    </strong>
                    <span class="tutor-profile-stars">
                        <asp:Label ID="lblAvgStars" runat="server"></asp:Label>
                    </span>
                </div>

            </div>

            <div class="tutor-profile-section-heading">
                <h3>Earnings &amp; payouts</h3>
                <p>All-time figures from your existing account records.</p>
            </div>

            <div class="tutor-finance-grid">

                <div>
                    <span>NET EARNINGS</span>
                    <strong>
                        R<asp:Label ID="lblNetEarnings" runat="server"></asp:Label>
                    </strong>
                    <small>After the 5% commission</small>
                </div>

                <div class="tutor-finance-paid">
                    <span>ALREADY PAID OUT</span>
                    <strong>
                        R<asp:Label ID="lblPaidOut" runat="server"></asp:Label>
                    </strong>
                    <small>Recorded tutor payouts</small>
                </div>

                <div class="tutor-finance-pending">
                    <span>REMAINING PAYOUT BALANCE</span>
                    <strong>
                        R<asp:Label ID="lblStillOwed" runat="server"></asp:Label>
                    </strong>
                    <small>Net earnings minus recorded payouts</small>
                </div>

            </div>

            <asp:Panel ID="pnlTutorDetails" runat="server"
                DefaultButton="btnSave">

                <div class="student-editor-section" id="tutorDetails">

                    <div class="student-editor-heading">
                        <span>
                            <i class="fa-solid fa-user-pen" aria-hidden="true"></i>
                        </span>
                        <div>
                            <h3>My personal details</h3>
                            <p>Keep your contact information and teaching details current.</p>
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
                                CssClass="error-text" Display="Dynamic" />
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
                                CssClass="error-text" Display="Dynamic" />
                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtEmail"
                                ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                                ErrorMessage="Enter a valid email address."
                                CssClass="error-text" Display="Dynamic" />
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
                                CssClass="error-text" Display="Dynamic" />
                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtPhone"
                                ValidationExpression="^0\d{9}$"
                                ErrorMessage="Enter a valid 10-digit phone number starting with 0."
                                CssClass="error-text" Display="Dynamic" />
                        </div>

                        <div class="student-editor-field">
                            <asp:Label runat="server"
                                AssociatedControlID="txtSubject"
                                Text="Subject / specialty *"></asp:Label>
                            <asp:TextBox ID="txtSubject" runat="server"></asp:TextBox>
                            <asp:RequiredFieldValidator runat="server"
                                ControlToValidate="txtSubject"
                                ErrorMessage="Subject is required."
                                CssClass="error-text" Display="Dynamic" />
                        </div>

                        <div class="student-editor-field">
                            <asp:Label runat="server"
                                AssociatedControlID="txtHourlyRate"
                                Text="Hourly rate (R)"></asp:Label>
                            <asp:TextBox ID="txtHourlyRate" runat="server"
                                inputmode="decimal"></asp:TextBox>
                            <asp:RegularExpressionValidator runat="server"
                                ControlToValidate="txtHourlyRate"
                                ValidationExpression="^\d+(\.\d{1,2})?$"
                                ErrorMessage="Enter a valid amount (e.g. 150 or 150.00)."
                                CssClass="error-text" Display="Dynamic" />
                            <p class="student-editor-help">
                                Use a full stop for decimal amounts.
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
                        Account Settings
                    </a>
                </div>

            </asp:Panel>

            <div class="tutor-profile-section-heading tutor-feedback-heading">
                <h3>Recent student feedback</h3>
                <p>Your 10 most recent rated sessions.</p>
            </div>

            <div class="tutor-feedback-wrap">
                <asp:GridView ID="gvFeedback" runat="server"
                    AutoGenerateColumns="false"
                    CssClass="grid tutor-feedback-table"
                    GridLines="None">

                    <Columns>
                        <asp:TemplateField HeaderText="Rating">
                            <ItemTemplate>
                                <asp:Label runat="server"
                                    CssClass="tutor-feedback-stars"
                                    Text='<%# new string((char)9733, Convert.ToInt32(Eval("Rating")))
                                        + new string((char)9734, 5 - Convert.ToInt32(Eval("Rating"))) %>'>
                                </asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="StudentName" HeaderText="Student" />
                        <asp:BoundField DataField="Comment" HeaderText="Comment" />
                        <asp:BoundField DataField="CreatedDate"
                            HeaderText="Date"
                            DataFormatString="{0:dd MMM yyyy}" />
                    </Columns>

                    <EmptyDataTemplate>
                        <div class="tutor-feedback-empty">
                            <i class="fa-solid fa-comments" aria-hidden="true"></i>
                            <h3>Your feedback journey starts here</h3>
                            <p>Student feedback will appear after your sessions are rated.</p>
                        </div>
                    </EmptyDataTemplate>

                </asp:GridView>
            </div>

        </div>
    </div>

</asp:Content>