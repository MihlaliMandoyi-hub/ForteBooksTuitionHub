<%@ Page Title="My Availability" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyAvailability.aspx.cs" Inherits="ForteBooksTuitionHub.MyAvailability" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="availability-workspace">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-calendar-days" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>My Availability</h2>
                <p>Shape your tutoring week with clear times and meeting venues.</p>
            </div>
        </div>

        <div class="availability-body">

            <div class="availability-builder">

                <aside class="availability-guide">
                    <span class="availability-guide-number">01</span>
                    <h3>Build your week</h3>
                    <p>Add a slot for each period you are available to tutor.</p>

                    <ol>
                        <li>Choose the day.</li>
                        <li>Set your start and end times.</li>
                        <li>Enter a clear meeting venue.</li>
                    </ol>

                    <a href="MySchedule.aspx">View My Schedule &raquo;</a>
                </aside>

                <section class="form-box availability-form">
                    <h3>Add an availability slot</h3>
                    <p class="availability-description">
                        Set an end time later than the start time.
                    </p>

                    <div class="availability-field">
                        <asp:Label ID="lblDayCaption" runat="server"
                            AssociatedControlID="ddlDay" Text="Day of week" />

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

                    <div class="availability-time-grid">
                        <div class="availability-field">
                            <asp:Label ID="lblStartCaption" runat="server"
                                AssociatedControlID="txtStartTime"
                                Text="Start time" />
                            <asp:TextBox ID="txtStartTime" runat="server"
                                TextMode="Time" />
                        </div>

                        <div class="availability-field">
                            <asp:Label ID="lblEndCaption" runat="server"
                                AssociatedControlID="txtEndTime"
                                Text="End time" />
                            <asp:TextBox ID="txtEndTime" runat="server"
                                TextMode="Time" />
                        </div>
                    </div>

                    <div class="availability-field">
                        <asp:Label ID="lblVenueCaption" runat="server"
                            AssociatedControlID="txtVenue" Text="Venue *" />

                        <asp:TextBox ID="txtVenue" runat="server"
                            placeholder="e.g. Library Study Room 3, or Online (Zoom)" />

                        <asp:RequiredFieldValidator runat="server"
                            ControlToValidate="txtVenue"
                            ErrorMessage="Please specify a venue so students know where to go."
                            CssClass="error-text" Display="Dynamic" />
                    </div>

                    <div class="availability-add-actions">
                        <asp:Button ID="btnAdd" runat="server"
                            Text="Add Availability Slot"
                            CssClass="btn btn-gold"
                            OnClick="btnAdd_Click" />
                    </div>

                    <asp:Label ID="lblError" runat="server"
                        CssClass="error-text availability-error"
                        role="alert" />
                </section>

            </div>

            <section class="availability-current">
                <div class="availability-current-heading">
                    <span class="availability-guide-number">02</span>
                    <div>
                        <h3>My Current Slots</h3>
                        <p>Your saved weekly availability, ordered by day and time.</p>
                    </div>
                </div>

                <div class="availability-table-wrap" tabindex="0"
                    role="region" aria-label="Your saved availability slots">

                    <asp:GridView ID="gvAvailability" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="grid"
                        DataKeyNames="AvailabilityId"
                        OnRowCommand="gvAvailability_RowCommand"
                        GridLines="None">

                        <Columns>
                            <asp:TemplateField HeaderText="Day">
                                <ItemTemplate>
                                    <span class="availability-day">
                                        <%#: Eval("DayOfWeek") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>

                            <asp:BoundField DataField="StartTime"
                                HeaderText="Start Time" />

                            <asp:BoundField DataField="EndTime"
                                HeaderText="End Time" />

                            <asp:BoundField DataField="Venue"
                                HeaderText="Venue" />

                            <asp:TemplateField HeaderText="Actions"
                                HeaderStyle-CssClass="no-print"
                                ItemStyle-CssClass="no-print">
                                <ItemTemplate>
                                    <asp:Button runat="server"
                                        Text="Remove"
                                        CommandName="DeleteSlot"
                                        CommandArgument='<%# Eval("AvailabilityId") %>'
                                        CssClass="btn btn-danger availability-remove"
                                        OnClientClick="return confirm('Remove this slot?');" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>

                        <EmptyDataTemplate>
                            <div class="availability-empty">
                                <i class="fa-solid fa-calendar-days"
                                    aria-hidden="true"></i>
                                <h3>Your week starts here</h3>
                                <p>Add your first availability slot using the form above.</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </section>

        </div>
    </div>

</asp:Content>