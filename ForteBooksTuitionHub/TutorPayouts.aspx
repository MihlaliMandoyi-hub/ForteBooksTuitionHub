<%@ Page Title="Tutor Payouts" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TutorPayouts.aspx.cs" Inherits="ForteBooksTuitionHub.TutorPayouts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="finance-report tutor-payouts">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-hand-holding-dollar"
                    aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">
                    Forte Books &amp; Tuition Hub
                </span>
                <h2>Tutor Payouts</h2>
                <p>Review tutor earnings, outstanding amounts and payout history.</p>
            </div>
        </div>

        <div class="payouts-body">

            <div class="payouts-guide">
                <strong>How net earnings are calculated</strong>
                <p>
                    Earnings are calculated from sessions marked
                    <strong>Completed</strong>, at each tutor's hourly rate,
                    less the centre's <strong>5% commission</strong>.
                </p>
            </div>

            <asp:Label ID="lblMessage" runat="server"
                ForeColor="Green" Font-Bold="true"
                CssClass="payouts-message" />

            <section class="payouts-section">
                <div class="payouts-section-heading">
                    <h3>Earnings and balances</h3>
                    <p>Compare earnings with amounts already paid out.</p>
                </div>

                <div class="payouts-table-wrap" tabindex="0"
                    role="region" aria-label="Tutor earnings and payout balances">

                    <asp:GridView ID="gvPayoutStatus" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="grid" GridLines="None">

                        <Columns>
                            <asp:BoundField DataField="FullName"
                                HeaderText="Tutor" />

                            <asp:BoundField DataField="Subject"
                                HeaderText="Subject" />

                            <asp:BoundField DataField="GrossEarnings"
                                HeaderText="Gross Earnings (R)"
                                DataFormatString="{0:N2}"
                                HeaderStyle-CssClass="payout-number"
                                ItemStyle-CssClass="payout-number" />

                            <asp:BoundField DataField="Commission"
                                HeaderText="Commission -5% (R)"
                                DataFormatString="{0:N2}"
                                HeaderStyle-CssClass="payout-number"
                                ItemStyle-CssClass="payout-number" />

                            <asp:BoundField DataField="NetEarnings"
                                HeaderText="Net Earnings (R)"
                                DataFormatString="{0:N2}"
                                HeaderStyle-CssClass="payout-number"
                                ItemStyle-CssClass="payout-number payout-net" />

                            <asp:BoundField DataField="PaidOut"
                                HeaderText="Already Paid Out (R)"
                                DataFormatString="{0:N2}"
                                HeaderStyle-CssClass="payout-number"
                                ItemStyle-CssClass="payout-number" />

                            <asp:BoundField DataField="StillOwed"
                                HeaderText="Still Owed (R)"
                                DataFormatString="{0:N2}"
                                HeaderStyle-CssClass="payout-number"
                                ItemStyle-CssClass="payout-number payout-owed" />

                            <asp:TemplateField HeaderText="Actions"
                                HeaderStyle-CssClass="no-print"
                                ItemStyle-CssClass="no-print">
                                <ItemTemplate>
                                    <a href='RecordPayout.aspx?tutorId=<%# Eval("TutorId") %>'
                                        class="btn btn-gold payout-record">
                                        <i class="fa-solid fa-money-check-dollar"></i>
                                        Record Payout
                                    </a>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>

                        <EmptyDataTemplate>
                            <div class="payouts-empty">No tutors found.</div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </section>

            <section class="payouts-section">
                <div class="payouts-section-heading">
                    <h3>
                        <i class="fa-solid fa-clock-rotate-left"></i>
                        Payout History
                    </h3>
                    <p>Previously recorded payments to tutors.</p>
                </div>

                <div class="payouts-table-wrap" tabindex="0"
                    role="region" aria-label="Tutor payout history">

                    <asp:GridView ID="gvHistory" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="grid payout-history" GridLines="None">

                        <Columns>
                            <asp:BoundField DataField="TutorName"
                                HeaderText="Tutor" />

                            <asp:BoundField DataField="Amount"
                                HeaderText="Amount (R)"
                                DataFormatString="{0:N2}"
                                HeaderStyle-CssClass="payout-number"
                                ItemStyle-CssClass="payout-number payout-net" />

                            <asp:BoundField DataField="PayoutDate"
                                HeaderText="Date"
                                DataFormatString="{0:yyyy-MM-dd HH:mm}" />

                            <asp:BoundField DataField="Notes"
                                HeaderText="Notes" />
                        </Columns>

                        <EmptyDataTemplate>
                            <div class="payouts-empty">
                                No payouts recorded yet.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </section>

        </div>
    </div>

</asp:Content>