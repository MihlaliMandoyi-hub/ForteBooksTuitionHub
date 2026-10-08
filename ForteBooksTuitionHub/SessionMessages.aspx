<%@ Page Title="Session Messages" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SessionMessages.aspx.cs" Inherits="ForteBooksTuitionHub.SessionMessages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h2><i class="fa-solid fa-comments"></i> Session Messages</h2>

    <asp:Panel ID="pnlNotFound" runat="server" Visible="false">
        <div class="error-text"><i class="fa-solid fa-circle-exclamation"></i> This session was not found or does not belong to you.</div>
        <br />
        <a href="Sessions.aspx" class="btn">Back to Sessions</a>
    </asp:Panel>

    <asp:Panel ID="pnlThread" runat="server" Visible="false">
        <div class="form-box" style="max-width:600px;">
            <p><i class="fa-solid fa-user-graduate"></i> Student: <strong><asp:Label ID="lblStudentName" runat="server"></asp:Label></strong>
               &nbsp;&nbsp; <i class="fa-solid fa-chalkboard-user"></i> Tutor: <strong><asp:Label ID="lblTutorName" runat="server"></asp:Label></strong></p>
            <p><i class="fa-solid fa-calendar"></i> <asp:Label ID="lblSessionInfo" runat="server"></asp:Label>
               &nbsp;&nbsp; <i class="fa-solid fa-location-dot"></i> <asp:Label ID="lblVenue" runat="server"></asp:Label></p>
        </div>

        <div class="form-box" style="max-width:600px; margin-top:15px; max-height:400px; overflow-y:auto;">
            <asp:Repeater ID="rptMessages" runat="server">
                <ItemTemplate>
                    <div style='margin-bottom:14px; padding:10px 14px; border-radius:10px; max-width:80%; <%# Eval("BubbleStyle") %>'>
                        <div style="font-size:11px; font-weight:700; margin-bottom:3px; opacity:0.7;">
                            <%# Eval("SenderLabel") %> &middot; <%# Eval("CreatedDate", "{0:yyyy-MM-dd HH:mm}") %>
                        </div>
                        <div style="font-size:14px;"><%# Eval("MessageText") %></div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Label ID="lblNoMessages" runat="server" Visible="false" Text="No messages yet — start the conversation below." style="color:var(--text-muted); font-size:13px;"></asp:Label>
        </div>

        <div class="form-box" style="max-width:600px; margin-top:15px;">
            <label>Your Message</label>
            <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="3" placeholder="Ask for directions, follow up on the lecture, or send a quick note..."></asp:TextBox>
            <asp:RequiredFieldValidator runat="server" ControlToValidate="txtMessage"
                ErrorMessage="Please enter a message." CssClass="error-text" Display="Dynamic" />

            <br /><br />
            <asp:Button ID="btnSend" runat="server" Text="Send Message" CssClass="btn btn-gold" OnClick="btnSend_Click" />
            <a href="Sessions.aspx" class="btn">Back to Sessions</a>
        </div>
    </asp:Panel>

</asp:Content>