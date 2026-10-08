<%@ Page Title="Tutor Availability" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TutorAvailability.aspx.cs" Inherits="ForteBooksTuitionHub.TutorAvailability" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2>Availability for <asp:Label ID="lblTutorName" runat="server"></asp:Label></h2>
    <p><a href="Tutors.aspx" class="btn">&laquo; Back to Tutors</a></p>

    <div class="form-box">
        <asp:HiddenField ID="hfTutorId" runat="server" />

        <label>Day of Week</label>
        <asp:DropDownList ID="ddlDay" runat="server" style="padding:8px; width:100%;">
            <asp:ListItem Text="Monday" Value="Monday" />
            <asp:ListItem Text="Tuesday" Value="Tuesday" />
            <asp:ListItem Text="Wednesday" Value="Wednesday" />
            <asp:ListItem Text="Thursday" Value="Thursday" />
            <asp:ListItem Text="Friday" Value="Friday" />
            <asp:ListItem Text="Saturday" Value="Saturday" />
            <asp:ListItem Text="Sunday" Value="Sunday" />
        </asp:DropDownList>

        <label>Start Time</label>
        <asp:TextBox ID="txtStartTime" runat="server" TextMode="Time"></asp:TextBox>

        <label>End Time</label>
        <asp:TextBox ID="txtEndTime" runat="server" TextMode="Time"></asp:TextBox>

        <label>Venue</label>
        <asp:TextBox ID="txtVenue" runat="server" placeholder="e.g. Library Study Room 3, or Online (Zoom)"></asp:TextBox>
        <asp:RequiredFieldValidator runat="server" ControlToValidate="txtVenue"
            ErrorMessage="Please specify a venue so students know where to go." CssClass="error-text" Display="Dynamic" />

        <br /><br />
        <asp:Button ID="btnAdd" runat="server" Text="Add Availability Slot" CssClass="btn btn-gold" OnClick="btnAdd_Click" />
        <br /><br />
        <asp:Label ID="lblError" runat="server" CssClass="error-text"></asp:Label>
    </div>

    <h3>Current Slots</h3>
    <asp:GridView ID="gvAvailability" runat="server" AutoGenerateColumns="false"
        CssClass="grid" DataKeyNames="AvailabilityId" OnRowCommand="gvAvailability_RowCommand" GridLines="None">
        <Columns>
            <asp:BoundField DataField="DayOfWeek" HeaderText="Day" />
            <asp:BoundField DataField="StartTime" HeaderText="Start Time" />
            <asp:BoundField DataField="EndTime" HeaderText="End Time" />
            <asp:BoundField DataField="Venue" HeaderText="Venue" />
            <asp:TemplateField HeaderText="">
                <ItemTemplate>
                    <asp:Button runat="server" Text="Remove" CommandName="DeleteSlot"
                        CommandArgument='<%# Eval("AvailabilityId") %>' CssClass="btn btn-danger"
                        OnClientClick="return confirm('Remove this slot?');" />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

</asp:Content>