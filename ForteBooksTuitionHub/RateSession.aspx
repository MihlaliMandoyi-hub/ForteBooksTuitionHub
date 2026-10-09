<%@ Page Title="Rate Session" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RateSession.aspx.cs" Inherits="ForteBooksTuitionHub.RateSession" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="rating-page">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-star" aria-hidden="true"></i>
            </div>
            <div>
                <div class="management-eyebrow">Forte Books &amp; Tuition Hub</div>
                <h2>Rate Your Session</h2>
                <p>Share your experience and help improve future tutoring sessions.</p>
            </div>
        </div>

        <asp:Panel ID="pnlNotFound" runat="server"
            Visible="false" CssClass="rating-state rating-unavailable">

            <div class="rating-state-icon">
                <i class="fa-solid fa-circle-exclamation" aria-hidden="true"></i>
            </div>

            <h3>This session cannot be rated</h3>
            <p>
                This session was not found, does not belong to you,
                is not completed yet, or has already been rated.
            </p>

            <a href="Sessions.aspx" class="btn">Back to My Sessions</a>
        </asp:Panel>

        <asp:Panel ID="pnlForm" runat="server"
            Visible="false" CssClass="rating-content">

            <div class="rating-session">
                <div class="rating-session-icon">
                    <i class="fa-solid fa-chalkboard-user" aria-hidden="true"></i>
                </div>

                <div>
                    <span class="rating-small-label">YOUR TUTOR</span>
                    <strong>
                        <asp:Label ID="lblTutorName" runat="server"></asp:Label>
                    </strong>
                </div>

                <div class="rating-session-date">
                    <i class="fa-solid fa-calendar" aria-hidden="true"></i>
                    <asp:Label ID="lblSessionDate" runat="server"></asp:Label>
                </div>
            </div>

            <div class="rating-layout">

                <div class="rating-form">

                    <div class="rating-section-heading">
                        <span class="rating-step">01</span>
                        <div>
                            <h3>How was your session?</h3>
                            <p>Choose the rating that best describes your experience.</p>
                        </div>
                    </div>

                    <div class="rating-picker">

                        <div class="rating-stars" id="ratingStars" hidden
                            role="group" aria-label="Choose a session rating">

                            <button type="button" data-rating="1"
                                aria-label="1 star — Poor" aria-pressed="false">
                                <i class="fa-solid fa-star" aria-hidden="true"></i>
                            </button>

                            <button type="button" data-rating="2"
                                aria-label="2 stars — Below Average" aria-pressed="false">
                                <i class="fa-solid fa-star" aria-hidden="true"></i>
                            </button>

                            <button type="button" data-rating="3"
                                aria-label="3 stars — Average" aria-pressed="false">
                                <i class="fa-solid fa-star" aria-hidden="true"></i>
                            </button>

                            <button type="button" data-rating="4"
                                aria-label="4 stars — Good" aria-pressed="false">
                                <i class="fa-solid fa-star" aria-hidden="true"></i>
                            </button>

                            <button type="button" data-rating="5"
                                aria-label="5 stars — Excellent" aria-pressed="false">
                                <i class="fa-solid fa-star" aria-hidden="true"></i>
                            </button>

                        </div>

                        <div class="rating-preview" id="ratingPreview"
                            aria-live="polite" aria-atomic="true">
                            <strong id="ratingDescription">Good</strong>
                            <span id="ratingScore">4 out of 5 stars</span>
                        </div>

                        <asp:Label ID="lblRatingCaption" runat="server"
                            AssociatedControlID="ddlRating"
                            CssClass="rating-field-label"
                            Text="Session rating"></asp:Label>

                        <asp:DropDownList ID="ddlRating" runat="server"
                            CssClass="rating-select">

                            <asp:ListItem Text="&#9733;&#9734;&#9734;&#9734;&#9734;  (1 - Poor)" Value="1" />
                            <asp:ListItem Text="&#9733;&#9733;&#9734;&#9734;&#9734;  (2 - Below Average)" Value="2" />
                            <asp:ListItem Text="&#9733;&#9733;&#9733;&#9734;&#9734;  (3 - Average)" Value="3" />
                            <asp:ListItem Text="&#9733;&#9733;&#9733;&#9733;&#9734;  (4 - Good)" Value="4" Selected="True" />
                            <asp:ListItem Text="&#9733;&#9733;&#9733;&#9733;&#9733;  (5 - Excellent)" Value="5" />

                        </asp:DropDownList>

                    </div>

                    <div class="rating-section-heading rating-comment-heading">
                        <span class="rating-step">02</span>
                        <div>
                            <h3>Add your feedback</h3>
                            <p>A few useful details can make a difference.</p>
                        </div>
                    </div>

                    <asp:Label ID="lblCommentCaption" runat="server"
                        AssociatedControlID="txtComment"
                        CssClass="rating-field-label"
                        Text="Comments (optional)"></asp:Label>

                    <asp:TextBox ID="txtComment" runat="server"
                        TextMode="MultiLine" Rows="5"
                        CssClass="rating-comment"
                        placeholder="What helped you learn? What could be improved?"></asp:TextBox>

                    <div class="rating-submit-note">
                        <i class="fa-solid fa-circle-info" aria-hidden="true"></i>
                        Your tutor will be notified when you submit your rating.
                    </div>

                    <div class="rating-actions">
                        <asp:Button ID="btnSubmit" runat="server"
                            Text="Submit Rating"
                            CssClass="btn btn-gold"
                            OnClick="btnSubmit_Click" />

                        <a href="Sessions.aspx" class="btn rating-cancel">Cancel</a>
                    </div>

                </div>

                <aside class="rating-guide">

                    <div class="rating-guide-icon">
                        <i class="fa-solid fa-comments" aria-hidden="true"></i>
                    </div>

                    <h3>Your experience matters</h3>
                    <p>
                        Thoughtful feedback helps tutors understand what worked
                        and where they can improve.
                    </p>

                    <div class="rating-guide-item">
                        <span>01</span>
                        <div>
                            <strong>Think about clarity</strong>
                            <p>Were explanations easy to understand?</p>
                        </div>
                    </div>

                    <div class="rating-guide-item">
                        <span>02</span>
                        <div>
                            <strong>Reflect on your progress</strong>
                            <p>Did the session help with your learning goals?</p>
                        </div>
                    </div>

                    <div class="rating-guide-item">
                        <span>03</span>
                        <div>
                            <strong>Keep it constructive</strong>
                            <p>Mention something helpful or a specific improvement.</p>
                        </div>
                    </div>

                    <div class="rating-guide-footer">
                        <i class="fa-solid fa-star" aria-hidden="true"></i>
                        Small feedback. Better learning.
                    </div>

                </aside>

            </div>

        </asp:Panel>

        <asp:Panel ID="pnlSuccess" runat="server"
            Visible="false" CssClass="rating-state rating-success">

            <div class="rating-state-icon">
                <i class="fa-solid fa-check" aria-hidden="true"></i>
            </div>

            <span class="rating-success-badge">RATING SUBMITTED</span>
            <h3>Thank you for your feedback!</h3>
            <p>Your rating has been saved. Your tutor has been notified.</p>

            <a href="Sessions.aspx" class="btn rating-success-button">
                Back to My Sessions
            </a>

        </asp:Panel>

    </div>

    <script>
        (function () {
            var select = document.getElementById('<%= ddlRating.ClientID %>');
            var stars = document.getElementById('ratingStars');

            if (!select || !stars) return;

            var buttons = stars.querySelectorAll('button[data-rating]');
            var description = document.getElementById('ratingDescription');
            var score = document.getElementById('ratingScore');

            var descriptions = {
                1: 'Poor',
                2: 'Below Average',
                3: 'Average',
                4: 'Good',
                5: 'Excellent'
            };

            function updateRating() {
                var value = parseInt(select.value, 10);

                buttons.forEach(function (button) {
                    var buttonValue = parseInt(button.dataset.rating, 10);

                    button.classList.toggle('is-filled', buttonValue <= value);
                    button.classList.toggle('is-selected', buttonValue === value);
                    button.setAttribute(
                        'aria-pressed',
                        buttonValue === value ? 'true' : 'false'
                    );
                });

                description.textContent = descriptions[value];
                score.textContent = value + ' out of 5 stars';
            }

            buttons.forEach(function (button) {
                button.addEventListener('click', function () {
                    select.value = button.dataset.rating;
                    updateRating();
                });
            });

            select.addEventListener('change', updateRating);
            stars.hidden = false;
            updateRating();
        })();
    </script>

</asp:Content>