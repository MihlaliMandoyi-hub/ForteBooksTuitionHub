<%@ Page Title="Tutor Approvals" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TutorApprovals.aspx.cs" Inherits="ForteBooksTuitionHub.TutorApprovals" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="approvals-workspace">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-user-check" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Tutor Approvals</h2>
                <p>Review tutor applications and manage their approval status.</p>
            </div>
        </div>

        <div class="approvals-body">

            <div class="approvals-guide">
                <strong>Review before approving</strong>
                <p>
                    Self-registered tutors await approval before they can
                    log in. Check their contact details, subject and
                    hourly rate before making a decision.
                </p>
            </div>

            <asp:Label ID="lblMessage" runat="server"
                ForeColor="Green" Font-Bold="true"
                CssClass="approvals-message" />

            <section class="approvals-section">
                <div class="approvals-section-heading">
                    <h3>
                        <i class="fa-solid fa-hourglass-half"></i>
                        Pending Applications
                    </h3>
                    <p>Applications awaiting your decision.</p>
                </div>

                <div class="approvals-table-wrap" tabindex="0"
                    role="region" aria-label="Pending tutor applications">

                    <asp:GridView ID="gvPending" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="grid"
                        DataKeyNames="UserId"
                        OnRowCommand="gvPending_RowCommand"
                        GridLines="None">

                        <Columns>
                            <asp:BoundField DataField="FullName"
                                HeaderText="Full Name" />

                            <asp:BoundField DataField="Email"
                                HeaderText="Email" />

                            <asp:BoundField DataField="Phone"
                                HeaderText="Phone" />

                            <asp:BoundField DataField="Subject"
                                HeaderText="Subject" />

                            <asp:BoundField DataField="HourlyRate"
                                HeaderText="Hourly Rate (R)"
                                DataFormatString="{0:N2}"
                                HeaderStyle-CssClass="approval-rate"
                                ItemStyle-CssClass="approval-rate" />

                            <asp:BoundField DataField="Username"
                                HeaderText="Username" />

                            <asp:TemplateField HeaderText="Decision"
                                HeaderStyle-CssClass="no-print"
                                ItemStyle-CssClass="no-print">
                                <ItemTemplate>
                                    <div class="approval-row-actions">
                                        <asp:Button runat="server"
                                            Text="Approve"
                                            CommandName="ApproveTutor"
                                            CommandArgument='<%# Eval("UserId") %>'
                                            CssClass="btn btn-gold approval-approve"
                                            OnClientClick="return confirm('Approve this tutor? They will be able to log in immediately.');" />

                                        <asp:Button runat="server"
                                            Text="Reject"
                                            CommandName="RejectTutor"
                                            CommandArgument='<%# Eval("UserId") %>'
                                            CssClass="btn btn-danger approval-reject"
                                            OnClientClick="return confirm('Reject this tutor application?');" />
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>

                        <EmptyDataTemplate>
                            <div class="approvals-empty">
                                <i class="fa-solid fa-circle-check"
                                    aria-hidden="true"></i>
                                <h3>You're up to date</h3>
                                <p>No pending tutor applications right now.</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </section>

            <section class="approvals-section">
                <div class="approvals-section-heading">
                    <h3>
                        <i class="fa-solid fa-clock-rotate-left"></i>
                        Previously Reviewed
                    </h3>
                    <p>Review earlier decisions and re-approve rejected applications.</p>
                </div>

                <div class="approvals-table-wrap" tabindex="0"
                    role="region" aria-label="Previously reviewed tutor applications">

                    <asp:GridView ID="gvReviewed" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="grid approvals-reviewed"
                        DataKeyNames="UserId"
                        OnRowCommand="gvReviewed_RowCommand"
                        OnRowDataBound="gvReviewed_RowDataBound"
                        GridLines="None">

                        <Columns>
                            <asp:BoundField DataField="FullName"
                                HeaderText="Full Name" />

                            <asp:BoundField DataField="Email"
                                HeaderText="Email" />

                            <asp:BoundField DataField="Subject"
                                HeaderText="Subject" />

                            <asp:BoundField DataField="Username"
                                HeaderText="Username" />

                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class="approval-status">
                                        <asp:Label ID="lblStatus"
                                            runat="server" />
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:TemplateField HeaderText="Actions"
                                HeaderStyle-CssClass="no-print"
                                ItemStyle-CssClass="no-print">
                                <ItemTemplate>
                                    <asp:Button runat="server"
                                        Text="Re-approve"
                                        CommandName="ApproveTutor"
                                        CommandArgument='<%# Eval("UserId") %>'
                                        CssClass="btn btn-gold approval-approve"
                                        Visible='<%# Eval("Status").ToString() == "Rejected" %>'
                                        OnClientClick="return confirm('Approve this tutor?');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>

                        <EmptyDataTemplate>
                            <div class="approvals-empty">
                                No applications have been reviewed yet.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </section>

        </div>
    </div>

</asp:Content>