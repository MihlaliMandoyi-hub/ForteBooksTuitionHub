<%@ Page Title="Session Messages" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SessionMessages.aspx.cs" Inherits="ForteBooksTuitionHub.SessionMessages" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="messages-workspace">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-comments" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Session Messages</h2>
                <p>Keep your session questions and arrangements together.</p>
            </div>
        </div>

        <asp:Panel ID="pnlNotFound" runat="server"
            Visible="false" CssClass="messages-not-found">

            <div class="error-text" role="alert">
                <i class="fa-solid fa-circle-exclamation"></i>
                This session was not found or does not belong to you.
            </div>

            <a href="Sessions.aspx" class="btn">Back to Sessions</a>
        </asp:Panel>

        <asp:Panel ID="pnlThread" runat="server" Visible="false">

            <div class="messages-session-summary">
                <div class="messages-person">
                    <i class="fa-solid fa-user-graduate" aria-hidden="true"></i>
                    <div>
                        <span>Student</span>
                        <strong>
                            <asp:Label ID="lblStudentName" runat="server" />
                        </strong>
                    </div>
                </div>

                <div class="messages-person">
                    <i class="fa-solid fa-chalkboard-user" aria-hidden="true"></i>
                    <div>
                        <span>Tutor</span>
                        <strong>
                            <asp:Label ID="lblTutorName" runat="server" />
                        </strong>
                    </div>
                </div>

                <div class="messages-session-meta">
                    <span>
                        <i class="fa-solid fa-calendar"></i>
                        <asp:Label ID="lblSessionInfo" runat="server" />
                    </span>

                    <span>
                        <i class="fa-solid fa-location-dot"></i>
                        <asp:Label ID="lblVenue" runat="server" />
                    </span>
                </div>
            </div>

            <div class="messages-body">

                <div class="messages-conversation-heading">
                    <h3>Conversation</h3>
                    <a href="Sessions.aspx">Back to Sessions &raquo;</a>
                </div>

                <div class="messages-conversation" id="messageConversation"
                    tabindex="0" role="region" aria-label="Session conversation">

                    <asp:Repeater ID="rptMessages" runat="server">
                        <ItemTemplate>
                            <div class='<%# Eval("SenderLabel").ToString() == Convert.ToString(Session["Role"]) ? "message-bubble message-mine" : "message-bubble message-other" %>'>

                                <div class="message-bubble-heading">
                                    <strong><%#: Eval("SenderLabel") %></strong>
                                    <time>
                                        <%#: Eval("CreatedDate", "{0:yyyy-MM-dd HH:mm}") %>
                                    </time>
                                </div>

                                <div class="message-bubble-text"><%# Eval("MessageText") %></div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <asp:Label ID="lblNoMessages" runat="server"
                        Visible="false"
                        Text="No messages yet — start the conversation below."
                        CssClass="messages-empty" />
                </div>

                <div class="messages-composer">
                    <asp:Label ID="lblMessageCaption" runat="server"
                        AssociatedControlID="txtMessage"
                        Text="Your message" CssClass="messages-composer-label" />

                    <div class="messages-quick-replies">
                        <button type="button" data-quick-reply="Could you please confirm the meeting venue?">
                            Confirm venue
                        </button>

                        <button type="button" data-quick-reply="What should I prepare before our session?">
                            Ask about preparation
                        </button>

                        <button type="button" data-quick-reply="Thank you for the session!">
                            Say thank you
                        </button>
                    </div>

                    <asp:TextBox ID="txtMessage" runat="server"
                        TextMode="MultiLine" Rows="4"
                        placeholder="Ask for directions, follow up on the lecture, or send a quick note..." />

                    <asp:RequiredFieldValidator runat="server"
                        ControlToValidate="txtMessage"
                        ErrorMessage="Please enter a message."
                        CssClass="error-text" Display="Dynamic" />

                    <div class="messages-send-bar">
                        <span>Quick replies are editable before sending.</span>

                        <asp:Button ID="btnSend" runat="server"
                            Text="Send Message" CssClass="btn btn-gold"
                            OnClick="btnSend_Click" />
                    </div>
                </div>

            </div>
        </asp:Panel>
    </div>

    <script>
        (function () {
            var messageBox = document.getElementById('<%= txtMessage.ClientID %>');
            var conversation = document.getElementById('messageConversation');

            document.querySelectorAll('.messages-quick-replies button')
                .forEach(function (button) {
                    button.addEventListener('click', function () {
                        if (!messageBox) return;

                        var suggestion = button.getAttribute('data-quick-reply');

                        messageBox.value = messageBox.value.trim()
                            ? messageBox.value + '\n' + suggestion
                            : suggestion;

                        messageBox.focus();
                        messageBox.setSelectionRange(
                            messageBox.value.length,
                            messageBox.value.length
                        );
                    });
                });

            if (conversation) {
                conversation.scrollTop = conversation.scrollHeight;
            }
        })();
    </script>

</asp:Content>