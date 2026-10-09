<%@ Page Title="Revenue Report" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="RevenueReport.aspx.cs" Inherits="ForteBooksTuitionHub.RevenueReport" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="finance-report revenue-report">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-chart-line" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">Forte Books &amp; Tuition Hub</span>
                <h2>Revenue Report</h2>
                <p>Explore recorded payments by month, method and reason.</p>
            </div>
        </div>

        <div class="finance-report-toolbar no-print">
            <div>
                <h3>Revenue overview</h3>
                <p>All amounts are shown in South African rand.</p>
            </div>

            <div class="finance-report-actions">
                <a href="Payments.aspx" class="btn finance-report-back">
                    &laquo; Back to Payments
                </a>

                <asp:Button ID="btnPrint" runat="server"
                    Text="Print This Report" CssClass="btn btn-gold"
                    OnClientClick="window.print(); return false;" />
            </div>
        </div>

        <div class="revenue-body">

            <div class="revenue-summary">
                <div class="revenue-summary-icon">
                    <i class="fa-solid fa-sack-dollar" aria-hidden="true"></i>
                </div>

                <div>
                    <span class="revenue-summary-label">Total Revenue To Date</span>

                    <div class="revenue-summary-value">
                        R<asp:Label ID="lblTotalRevenue" runat="server" />
                    </div>

                    <p>Total of all payment amounts recorded in the system.</p>
                </div>
            </div>

            <section class="revenue-section">
                <div class="revenue-section-heading">
                    <h3>
                        <i class="fa-solid fa-calendar"></i>
                        Revenue by Month
                    </h3>

                    <asp:Button ID="btnExportMonth" runat="server"
                        Text="Download CSV"
                        CssClass="btn btn-gold no-print"
                        OnClick="btnExportMonth_Click"
                        CausesValidation="false" />
                </div>

                <div class="revenue-table-wrap" tabindex="0"
                    role="region" aria-label="Revenue by month">

                    <asp:GridView ID="gvByMonth" runat="server"
                        AutoGenerateColumns="false"
                        CssClass="grid" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="MonthLabel"
                                HeaderText="Month" />

                            <asp:BoundField DataField="PaymentCount"
                                HeaderText="Number of Payments" />

                            <asp:BoundField DataField="TotalAmount"
                                HeaderText="Total (R)"
                                DataFormatString="{0:N2}" />
                        </Columns>

                        <EmptyDataTemplate>
                            <div class="revenue-empty">
                                No payments recorded yet.
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </section>

            <div class="revenue-breakdowns">

                <section class="revenue-section">
                    <div class="revenue-section-heading">
                        <h3>
                            <i class="fa-solid fa-credit-card"></i>
                            Revenue by Payment Method
                        </h3>

                        <asp:Button ID="btnExportMethod" runat="server"
                            Text="Download CSV"
                            CssClass="btn btn-gold no-print"
                            OnClick="btnExportMethod_Click"
                            CausesValidation="false" />
                    </div>

                    <div class="revenue-table-wrap" tabindex="0"
                        role="region" aria-label="Revenue by payment method">

                        <asp:GridView ID="gvByMethod" runat="server"
                            AutoGenerateColumns="false"
                            CssClass="grid" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="Method"
                                    HeaderText="Method" />

                                <asp:BoundField DataField="PaymentCount"
                                    HeaderText="Number of Payments" />

                                <asp:BoundField DataField="TotalAmount"
                                    HeaderText="Total (R)"
                                    DataFormatString="{0:N2}" />
                            </Columns>

                            <EmptyDataTemplate>
                                <div class="revenue-empty">
                                    No payments recorded yet.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </section>

                <section class="revenue-section">
                    <div class="revenue-section-heading">
                        <h3>
                            <i class="fa-solid fa-tags"></i>
                            Revenue by Reason
                        </h3>

                        <asp:Button ID="btnExportReason" runat="server"
                            Text="Download CSV"
                            CssClass="btn btn-gold no-print"
                            OnClick="btnExportReason_Click"
                            CausesValidation="false" />
                    </div>

                    <div class="revenue-table-wrap" tabindex="0"
                        role="region" aria-label="Revenue by payment reason">

                        <asp:GridView ID="gvByReason" runat="server"
                            AutoGenerateColumns="false"
                            CssClass="grid" GridLines="None">
                            <Columns>
                                <asp:BoundField DataField="Reason"
                                    HeaderText="Reason" />

                                <asp:BoundField DataField="PaymentCount"
                                    HeaderText="Number of Payments" />

                                <asp:BoundField DataField="TotalAmount"
                                    HeaderText="Total (R)"
                                    DataFormatString="{0:N2}" />
                            </Columns>

                            <EmptyDataTemplate>
                                <div class="revenue-empty">
                                    No payments recorded yet.
                                </div>
                            </EmptyDataTemplate>
                        </asp:GridView>
                    </div>
                </section>

            </div>
        </div>
    </div>

</asp:Content>