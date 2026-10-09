<%@ Page Title="Outstanding Balances" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OutstandingBalances.aspx.cs" Inherits="ForteBooksTuitionHub.OutstandingBalances" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <div class="finance-report balances-report">

        <div class="management-page-header">
            <div class="management-header-icon">
                <i class="fa-solid fa-scale-balanced" aria-hidden="true"></i>
            </div>

            <div>
                <span class="management-eyebrow">Forte Books &amp; Tuition Hub</span>
                <h2>Outstanding Balances</h2>
                <p>Compare student charges, payments and remaining balances.</p>
            </div>
        </div>

        <div class="finance-report-toolbar no-print">
            <div>
                <h3>Student account overview</h3>
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

        <asp:Label ID="lblMessage" runat="server"
            ForeColor="Green" Font-Bold="true"
            CssClass="finance-report-message" />

        <div class="finance-report-table" tabindex="0"
            role="region" aria-label="Student balances report">

            <asp:GridView ID="gvBalances" runat="server"
                AutoGenerateColumns="false"
                CssClass="grid" GridLines="None">

                <Columns>
                    <asp:BoundField DataField="FullName"
                        HeaderText="Student" />

                    <asp:BoundField DataField="TotalCharges"
                        HeaderText="Total Charges (R)"
                        DataFormatString="{0:N2}"
                        HeaderStyle-CssClass="finance-number"
                        ItemStyle-CssClass="finance-number" />

                    <asp:BoundField DataField="TotalPaid"
                        HeaderText="Total Paid (R)"
                        DataFormatString="{0:N2}"
                        HeaderStyle-CssClass="finance-number"
                        ItemStyle-CssClass="finance-number" />

                    <asp:BoundField DataField="Balance"
                        HeaderText="Balance (R)"
                        DataFormatString="{0:N2}"
                        HeaderStyle-CssClass="finance-number"
                        ItemStyle-CssClass="finance-number balance-amount" />

                    <asp:TemplateField HeaderText="Actions"
                        HeaderStyle-CssClass="no-print"
                        ItemStyle-CssClass="no-print">
                        <ItemTemplate>
                            <a href='RefundStudent.aspx?studentId=<%# Eval("StudentId") %>'
                                class="btn btn-gold balance-refund no-print">
                                <i class="fa-solid fa-hand-holding-dollar"></i>
                                Refund
                            </a>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>

                <EmptyDataTemplate>
                    <div class="finance-report-empty">
                        <i class="fa-solid fa-scale-balanced"
                            aria-hidden="true"></i>
                        <h3>No students found</h3>
                        <p>Student account records will appear here when available.</p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>

        <div class="balance-guide no-print">
            <i class="fa-solid fa-circle-info" aria-hidden="true"></i>

            <div>
                <strong>Understanding the balance</strong>
                <p>
                    A positive balance is an amount still owed by the student.
                    A negative balance means the student has credit.
                    Use Refund when returning that credit to the student.
                </p>
            </div>
        </div>

    </div>

</asp:Content>