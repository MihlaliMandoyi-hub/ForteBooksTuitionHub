<%@ Page Title="Tutor Utilisation" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TutorUtilisation.aspx.cs" Inherits="ForteBooksTuitionHub.TutorUtilisation" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="utilisation-page">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-chart-simple" aria-hidden="true"></i>
            </div>
            <div>
                <div class="management-eyebrow">FORTE BOOKS &amp; TUITION HUB</div>
                <h2>Tutor Utilisation Report</h2>
                <p>Review teaching availability, session activity and approved work.</p>
            </div>
        </div>

        <div class="utilisation-toolbar no-print">
            <a href="Tutors.aspx" class="btn utilisation-secondary">
                <i class="fa-solid fa-arrow-left" aria-hidden="true"></i>
                Back to Tutors
            </a>

            <div>
                <asp:Button ID="btnPrint" runat="server"
                    Text="Print Report"
                    CssClass="btn btn-gold"
                    CausesValidation="false"
                    OnClientClick="window.print(); return false;" />

                <asp:Button ID="btnExport" runat="server"
                    Text="Download CSV"
                    CssClass="btn utilisation-secondary"
                    OnClick="btnExport_Click"
                    CausesValidation="false" />
            </div>
        </div>

        <div class="utilisation-body">

            <div class="utilisation-summary" id="utilisationSummary" hidden>

                <div>
                    <i class="fa-solid fa-chalkboard-user" aria-hidden="true"></i>
                    <span>TUTORS IN REPORT</span>
                    <strong id="summaryTutors">0</strong>
                    <small>Listed tutor records</small>
                </div>

                <div>
                    <i class="fa-solid fa-calendar-days" aria-hidden="true"></i>
                    <span>WEEKLY AVAILABILITY</span>
                    <strong id="summaryAvailable">0</strong>
                    <small>Total hours across listed slots</small>
                </div>

                <div>
                    <i class="fa-solid fa-calendar-check" aria-hidden="true"></i>
                    <span>SESSION RECORDS</span>
                    <strong id="summarySessions">0</strong>
                    <small>All non-cancelled sessions</small>
                </div>

                <div class="approved-summary">
                    <i class="fa-solid fa-circle-check" aria-hidden="true"></i>
                    <span>APPROVED HOURS</span>
                    <strong id="summaryApproved">0</strong>
                    <small>All approved timesheet hours</small>
                </div>

            </div>

            <div class="utilisation-heading">
                <h3>Teaching activity at a glance</h3>
                <p>Compare tutor records, then print or export the report.</p>
            </div>

            <div class="utilisation-table-wrap">

                <asp:GridView ID="gvUtilisation" runat="server"
                    AutoGenerateColumns="false"
                    CssClass="grid utilisation-table"
                    GridLines="None">

                    <Columns>

                        <asp:TemplateField HeaderText="Tutor">
                            <ItemTemplate>
                                <div class="utilisation-tutor"
                                    data-available='<%# Convert.ToDecimal(Eval("AvailableHoursPerWeek")).ToString(System.Globalization.CultureInfo.InvariantCulture) %>'
                                    data-sessions='<%# Eval("SessionsBooked") %>'
                                    data-approved='<%# Convert.ToDecimal(Eval("ApprovedHours")).ToString(System.Globalization.CultureInfo.InvariantCulture) %>'>

                                    <span class="utilisation-avatar">
                                        <i class="fa-solid fa-chalkboard-user" aria-hidden="true"></i>
                                    </span>

                                    <strong><%#: Eval("FullName") %></strong>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="Subject" HeaderText="Subject" />

                        <asp:TemplateField HeaderText="Available hours / week">
                            <ItemTemplate>
                                <div class="utilisation-availability">
                                    <strong>
                                        <%#: Eval("AvailableHoursPerWeek", "{0:N1}") %>
                                        <small>hrs</small>
                                    </strong>

                                    <div class="utilisation-bar" hidden aria-hidden="true">
                                        <span></span>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Non-cancelled sessions">
                            <ItemTemplate>
                                <span class="utilisation-session-count">
                                    <%#: Eval("SessionsBooked") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Approved hours logged">
                            <ItemTemplate>
                                <span class="utilisation-approved">
                                    <i class="fa-solid fa-circle-check" aria-hidden="true"></i>
                                    <%#: Eval("ApprovedHours", "{0:N1}") %> hrs
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                    </Columns>

                    <EmptyDataTemplate>
                        <div class="utilisation-empty">
                            <i class="fa-solid fa-chart-simple" aria-hidden="true"></i>
                            <h3>No tutors to report yet</h3>
                            <p>Tutor activity will appear here when records are available.</p>
                        </div>
                    </EmptyDataTemplate>

                </asp:GridView>

            </div>

            <div class="utilisation-report-note">
                <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
                <div>
                    <strong>Reading this report</strong>
                    <p>
                        Availability is the total duration of recorded weekly slots.
                        Sessions include all non-cancelled records, and approved
                        hours include all approved timesheets. These totals are not
                        limited to the current week.
                    </p>
                    <p>
                        Availability bars are scaled against the highest weekly
                        availability in this report. They are not a booking or
                        capacity percentage.
                    </p>
                </div>
            </div>

        </div>
    </div>

    <script>
        (function () {
            var tutors = document.querySelectorAll(
                '.utilisation-page .utilisation-tutor'
            );

            if (!tutors.length) return;

            var available = 0;
            var sessions = 0;
            var approved = 0;
            var highestAvailability = 0;

            tutors.forEach(function (tutor) {
                var hours = Number(tutor.dataset.available) || 0;
                available += hours;
                sessions += Number(tutor.dataset.sessions) || 0;
                approved += Number(tutor.dataset.approved) || 0;
                highestAvailability = Math.max(highestAvailability, hours);
            });

            function format(value, decimals) {
                return value.toLocaleString('en-ZA', {
                    minimumFractionDigits: decimals,
                    maximumFractionDigits: decimals
                });
            }

            document.getElementById('summaryTutors').textContent = format(tutors.length, 0);
            document.getElementById('summaryAvailable').textContent = format(available, 1);
            document.getElementById('summarySessions').textContent = format(sessions, 0);
            document.getElementById('summaryApproved').textContent = format(approved, 1);

            document.getElementById('utilisationSummary').hidden = false;

            tutors.forEach(function (tutor) {
                var row = tutor.closest('tr');
                var bar = row.querySelector('.utilisation-bar');
                if (!bar) return;

                var hours = Number(tutor.dataset.available) || 0;
                var width = highestAvailability > 0
                    ? Math.max(0, Math.min(100, hours / highestAvailability * 100))
                    : 0;

                bar.querySelector('span').style.width = width + '%';
                bar.hidden = false;
            });
        })();
    </script>

</asp:Content>