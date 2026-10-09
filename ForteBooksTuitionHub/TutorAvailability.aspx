<%@ Page Title="Tutor Availability" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TutorAvailability.aspx.cs" Inherits="ForteBooksTuitionHub.TutorAvailability" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="student-editor availability-editor">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-calendar-days" aria-hidden="true"></i>
            </div>
            <div>
                <div class="management-eyebrow">FORTE BOOKS &amp; TUITION HUB</div>
                <h2>Tutor Availability</h2>
                <p>Organise weekly teaching times and make venues clear.</p>
            </div>
        </div>

        <div class="student-editor-body">

            <asp:HiddenField ID="hfTutorId" runat="server" />

            <div class="student-editor-toolbar">
                <div class="availability-tutor">
                    <span>
                        <i class="fa-solid fa-chalkboard-user" aria-hidden="true"></i>
                    </span>
                    <div>
                        <small>PLANNING FOR</small>
                        <strong>
                            <asp:Label ID="lblTutorName" runat="server"></asp:Label>
                        </strong>
                    </div>
                </div>

                <a href="Tutors.aspx" class="btn student-editor-back">
                    <i class="fa-solid fa-arrow-left" aria-hidden="true"></i>
                    Back to Tutors
                </a>
            </div>

            <div class="availability-layout">

                <asp:Panel ID="pnlSlotForm" runat="server"
                    CssClass="student-editor-section availability-form"
                    DefaultButton="btnAdd">

                    <div class="student-editor-heading">
                        <span>+</span>
                        <div>
                            <h3>Add a teaching slot</h3>
                            <p>Choose a day, time range and venue.</p>
                        </div>
                    </div>

                    <div class="student-editor-field availability-field">
                        <asp:Label runat="server"
                            AssociatedControlID="ddlDay"
                            Text="Day of the week"></asp:Label>

                        <asp:DropDownList ID="ddlDay" runat="server">
                            <asp:ListItem Text="Monday" Value="Monday" />
                            <asp:ListItem Text="Tuesday" Value="Tuesday" />
                            <asp:ListItem Text="Wednesday" Value="Wednesday" />
                            <asp:ListItem Text="Thursday" Value="Thursday" />
                            <asp:ListItem Text="Friday" Value="Friday" />
                            <asp:ListItem Text="Saturday" Value="Saturday" />
                            <asp:ListItem Text="Sunday" Value="Sunday" />
                        </asp:DropDownList>
                    </div>

                    <div class="availability-time-fields">
                        <div class="student-editor-field">
                            <asp:Label runat="server"
                                AssociatedControlID="txtStartTime"
                                Text="Start time *"></asp:Label>

                            <asp:TextBox ID="txtStartTime" runat="server"
                                TextMode="Time"></asp:TextBox>
                        </div>

                        <div class="student-editor-field">
                            <asp:Label runat="server"
                                AssociatedControlID="txtEndTime"
                                Text="End time *"></asp:Label>

                            <asp:TextBox ID="txtEndTime" runat="server"
                                TextMode="Time"></asp:TextBox>
                        </div>
                    </div>

                    <div class="student-editor-field availability-field">
                        <asp:Label runat="server"
                            AssociatedControlID="txtVenue"
                            Text="Venue *"></asp:Label>

                        <asp:TextBox ID="txtVenue" runat="server"
                            placeholder="e.g. Library Study Room 3"></asp:TextBox>

                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtVenue"
                            ErrorMessage="Please specify a venue so students know where to go."
                            CssClass="error-text"
                            Display="Dynamic" />

                        <p class="student-editor-help">
                            Include a room name or specify the online platform.
                        </p>
                    </div>

                    <asp:Label ID="lblError" runat="server"
                        CssClass="student-editor-error"
                        role="alert"></asp:Label>

                    <asp:Button ID="btnAdd" runat="server"
                        Text="Add Availability Slot"
                        CssClass="btn btn-gold availability-add"
                        OnClick="btnAdd_Click" />

                    <div class="availability-form-note">
                        <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
                        <p>
                            End time must be after start time.
                            Review existing slots before adding another.
                        </p>
                    </div>

                </asp:Panel>

                <section class="availability-schedule">

                    <div class="availability-schedule-heading">
                        <div>
                            <span class="management-eyebrow">WEEKLY TEACHING PLAN</span>
                            <h3>Current slots</h3>
                            <p>Listed by weekday, then start time.</p>
                        </div>
                        <i class="fa-solid fa-calendar-check" aria-hidden="true"></i>
                    </div>

                    <asp:GridView ID="gvAvailability" runat="server"
                        AutoGenerateColumns="false"
                        ShowHeader="false"
                        CssClass="availability-grid"
                        DataKeyNames="AvailabilityId"
                        OnRowCommand="gvAvailability_RowCommand"
                        GridLines="None">

                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>

                                    <article class="availability-slot">

                                        <div class="availability-day">
                                            <i class="fa-solid fa-calendar-day" aria-hidden="true"></i>
                                            <strong><%#: Eval("DayOfWeek") %></strong>
                                        </div>

                                        <div class="availability-slot-details">
                                            <strong class="availability-slot-time">
                                                <%#: Eval("StartTime", "{0:hh\\:mm}") %>
                                                <span>–</span>
                                                <%#: Eval("EndTime", "{0:hh\\:mm}") %>
                                            </strong>

                                            <p>
                                                <i class="fa-solid fa-location-dot" aria-hidden="true"></i>
                                                <%#: Eval("Venue") %>
                                            </p>
                                        </div>

                                        <asp:Button runat="server"
                                            Text="Remove"
                                            CommandName="DeleteSlot"
                                            CommandArgument='<%# Eval("AvailabilityId") %>'
                                            CssClass="btn availability-remove"
                                            CausesValidation="false"
                                            OnClientClick="return confirm('Remove this availability slot?');" />

                                    </article>

                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>

                        <EmptyDataTemplate>
                            <div class="availability-empty">
                                <i class="fa-solid fa-calendar-plus" aria-hidden="true"></i>
                                <h3>A week of possibilities</h3>
                                <p>
                                    No availability slots have been added.
                                    Use the form to start this tutor’s weekly plan.
                                </p>
                            </div>
                        </EmptyDataTemplate>

                    </asp:GridView>

                </section>

            </div>
        </div>
    </div>

</asp:Content>